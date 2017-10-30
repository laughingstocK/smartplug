/*****************************************************
Project         : Smart_Plug
Date            : 9/2017
Author          : Krerkkiat Hemadhulin
Company         : NextCrop Co.,Ltd.
Comments        : 
Version Format  :
Chip type       : ATmega128a
Program type    : Application
Frequency       : 11.059200 MHz
*****************************************************/
#include <mega128a.h> 
#include <stdlib.h> 
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <delay.h>
#include <sleep.h>
#include <io.h>
#include <math.h>
#include <initial_system.h>
#include <int_protocol.h>
#include <uart.h>
#include <debug.h>
#include <xbee.h>
#include <timer.h>
#include <adc.h>
#include <eeprom.h>
#include <meansure.h>
#include <queue.h>
#define SWITCH_PRESSED !(PINC & (1<<PINC0))

uint8_t SWITCH          = TURN_OFF;
uint8_t specData[]      = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xFF,0xFF,0xFF,0xFF};   // Specific Stucture of Join Req packet   
uint8_t error;
int8_t read_D_SW;
int start_event;
int counter = 0;
//int e = 0;
//uint8_t SEND_EVENT_TEST[38];

void device_state(int state){
    if(state == 0){
        POWER_RELAY_OFF;
        LED_STAT_OFF;
        STATUS_DEVICE = 0;
    }else if(state == 1){
        POWER_RELAY_ON;
        LED_STAT_ON;
        STATUS_DEVICE = 1;
    }
}

void main(void) {

    start_event = 0;
    STATUS_DEVICE = EEPROM_read(Eaddress);
    if(STATUS_DEVICE == 0xFF){
        EEPROM_write(Eaddress,0);
        STATUS_DEVICE = EEPROM_read(Eaddress);
    }
     
    /*=============== System Initialize ===============*/
    do{ error = initial_system(); }while(error); 

    /*=============== Select Device Type ===============*/
   
    do { 
        read_D_SW = read_dSwitch(); 
        if(read_D_SW == 0x0F) {
            SENSOR_SENSITIVE = SENSOR5A;
            if((ADJ0_SENSOR5A > 0.0) && (ADJ0_SENSOR5A < 0.12)) {
                AMP_ADJ_ZERO = ADJ0_SENSOR5A;
            }else {AMP_ADJ_ZERO = 0.09;}
            specData[8] = TYPE_SMART_SWITCH;                             // Device Type  
            printDebug("\r\n++++++++++ Smart Switch ++++++++++\r\n");
            printDebug("\r\nFirmware Version : %0.1f\r\n", FIRMWARE_VERSION); 
            printDebug("Current Sensor   : ACS712ELCTR-05B-T (%0.1f mV/Amp.)\r\n", SENSOR_SENSITIVE); 
        }else if(read_D_SW == 0x0E) {
            SENSOR_SENSITIVE = SENSOR20A;
            if((ADJ0_SENSOR20A > 0.0) && (ADJ0_SENSOR20A < 0.14)) {
                AMP_ADJ_ZERO = ADJ0_SENSOR20A;
            }else {AMP_ADJ_ZERO = 0.11;}
            specData[8] = TYPE_SMART_PLUG;                               // Device Type
            printDebug("\r\n++++++++++ Smart Plug ++++++++++\r\n");
            printDebug("\r\nFirmware Version : %0.1f\r\n", FIRMWARE_VERSION);  
            printDebug("Current Sensor   : ACS712ELCTR-20A-T (%0.1f mV/Amp.)\r\n", SENSOR_SENSITIVE);  
        }else if(read_D_SW == 0x0D) {
            SENSOR_SENSITIVE = SENSOR30A;
            if((ADJ0_SENSOR30A > 0.0) && (ADJ0_SENSOR30A < 0.15)) {
                AMP_ADJ_ZERO = ADJ0_SENSOR30A;
            }else {AMP_ADJ_ZERO = 0.12;}
            specData[8] = TYPE_SMART_BREAKER;                            // Device Type
            printDebug("\r\n++++++++++ Smart Breaker ++++++++++\r\n");
            printDebug("\r\nFirmware Version : %0.1f\r\n", FIRMWARE_VERSION); 
            printDebug("Current Sensor   : ACS712ELCTR-30A-T (%0.1f mV/Amp.)\r\n", SENSOR_SENSITIVE);  
        }else if(read_D_SW < 0) {
            printDebug("Read Dip-Switch ERROR!\r\n");
        }else {
            SENSOR_SENSITIVE = SENSOR5A;
            AMP_ADJ_ZERO = ADJ0_SENSOR5A;
            specData[8] = TYPE_SMART_SWITCH; 
            printDebug("\r\n++++++++++ Default Type : Smart Switch ++++++++++\r\n");
            printDebug("\r\nFirmware Version : %0.1f\r\n", FIRMWARE_VERSION);
            printDebug("Current Sensor   : ACS712ELCTR-05B-T (%0.1f mV/Amp.)\r\n", SENSOR_SENSITIVE); 
        }
    }while(read_D_SW < 0);  
    
    /*=============== Current Measurement ===============*/
    printDebug("Current Measure  : > %0.2f Amp.\r\n", AMP_ADJ_ZERO);

    
    #asm("sei")    // Global enable interrupts  
    
    printDebug("\r\n-------- Initial Complete --------\r\n");
    delay_ms(5000);
     
    printDebug("\r\n-------- Start Program --------\r\n");
    while(1) {
        xbee_read();
        
//        if(counter%111 == 0 && counter >= 111){
//        if(e%2 == 0){
//            SEND_EVENT_TEST[2] = 0x90;
//            SEND_EVENT_TEST[3] = 0x90;
//            SEND_EVENT_TEST[35] = 0xA5;
//            SEND_EVENT_TEST[36] = 0x01; 
//            SEND_EVENT_TEST[37] = 0x01;
//            xbee_receivePacket(SEND_EVENT_TEST,38);
//        }else{
//            SEND_EVENT_TEST[2] = 0x90;
//            SEND_EVENT_TEST[3] = 0x90;
//            SEND_EVENT_TEST[35] = 0xA5;
//            SEND_EVENT_TEST[36] = 0x01; 
//            SEND_EVENT_TEST[37] = 0x00;
//            xbee_receivePacket(SEND_EVENT_TEST,38);
//       }
//       e++;
//}
        switch (flag_state) {
        
            /*=============== Send AI ===============*/
            case 0 :
                xbee_sendATCommand(AI);
                delay_ms(100);
                
                /*=============== Check last state from eeprom ===============*/
                
                if(STATUS_DEVICE == 1){
                    delay_ms(100);
                    device_state(1);   //on
                    EEPROM_write(Eaddress,STATUS_DEVICE); 
                    start_event = 1;
                    push_event(511);
                }
            break;
           
            /*=============== Send SH( High Bits MacAddress) ===============*/
            case 1 :
                xbee_sendATCommand(SH);
                delay_ms(100);   
            break;
            
            /*=============== Send SL( LOW Bits MacAddress) ===============*/
            case 2 :
                xbee_sendATCommand(SL);
                delay_ms(100);
            break;
            
            /*=============== Send Join ===============*/
            case 3 :
                delay_ms(2000);
                send_join();
                delay_ms(100);
                
                if(SWITCH_PRESSED){
                    delay_ms(100);
                    if(STATUS_DEVICE == 0){
                        device_state(1);      //on        
                        EEPROM_write(Eaddress,STATUS_DEVICE);
                        push_event(5110);      
       
                    }else if(STATUS_DEVICE == 1){
                        device_state(0);      //off       
                        EEPROM_write(Eaddress,STATUS_DEVICE);
                        push_event(5100);      
        
                    }
                }
            break;
            
            /*=============== Idle State ===============*/
            case 4 :
                printDebug("\r\n-------- Idle --------\r\n");
                counter++;
                if(counter%10 == 0 ){
                    pop_event();
                    printDebug("\r\n-------- POP EVENT --------\r\n");
                } 
                
                if(start_event == 1){
                    if(STATUS_DEVICE == 1){
                        flag_state = 5;    
                    }else if(STATUS_DEVICE == 0){
                        flag_state = 4;
                    }
                    start_event = 0;
                }                               
                

                if(SWITCH_PRESSED){
                    delay_ms(200);
                       if(STATUS_DEVICE == 0){
                            device_state(1);      //on                            
                            EEPROM_write(Eaddress,STATUS_DEVICE);
                            flag_state = 5;
                            //printDebug("count_input = %d\r\n", count_input);
                            push_event(5110);       
                       }else if(STATUS_DEVICE == 1){
                            device_state(0);     //off 
                            EEPROM_write(Eaddress,STATUS_DEVICE);
                            flag_state = 4;
                            //printDebug("count_input = %d\r\n", count_input);
                            push_event(5100);      
                       }
                }              
            break;
            
            /*=============== Active State ===============*/
            case 5 : 
            printDebug("\r\n-------- Active --------\r\n");
                ReadCurrent();
                ReadVoltage();
                
                counter++;
                if(counter%10 == 0 ){
                    printDebug("\r\n-------- POP EVENT --------\r\n");
                    pop_event();
                }
                
                
                if(number == 1000){
                    SendStatusReport();
                }
                 
                if(SWITCH_PRESSED){
                    delay_ms(200);
                    device_state(0); // off
                    EEPROM_write(Eaddress,STATUS_DEVICE);
                    flag_state = 4;
//                    printDebug("count_input = %d\r\n", count_input);
                    push_event(5100);
                }
            break;                                      
        }
    }
}