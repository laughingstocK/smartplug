#include <mega128a.h> 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <delay.h>
#include <uart.h>
#include <xbee.h>
#include <queue.h>
#include <debug.h>
#include <int_protocol.h>
#include <eeprom.h>

#define XBEE_RESET PORTE.2

char EndDevice_MacAddress[8];
char Gateway_MacAddress[8];

uint8_t AI_COMMAND[]            = {0x7E,0x00,0x04,0x08,0x01,0x41,0x49,0x6C};
uint8_t SL_COMMAND[]            = {0x7E,0x00,0x04,0x08,0x01,0x53,0x4C,0x57};
uint8_t SH_COMMAND[]            = {0x7E,0x00,0x04,0x08,0x01,0x53,0x48,0x5B};
uint8_t EVENT[2]                = {0x00,0x00};
uint8_t STATUS_DEVICE           = 0;
int flag_state                  = 0;


void xbee_sendATCommand(int param){
     switch(param) {
        case 0  : 
            printDebug("\r\n ++++++++++ Send AI ++++++++\r\n");
            print_payload(AI_COMMAND,8);
            xbee_send(AI_COMMAND,8);
            
        break;
    
        case 1  : 
            printDebug("\r\n ++++++++++ Send SH ++++++++\r\n");
            print_payload(SH_COMMAND,8);
            xbee_send(SH_COMMAND,8);
           
        break;
                  
        case 2  :   
            printDebug("\r\n ++++++++++ Send SL ++++++++\r\n");
            print_payload(SL_COMMAND,8);
            xbee_send(SL_COMMAND,8);
        break; 
     }
}

int xbee_checksum(char buf[],int len) {

    int i;
    char sum = 0;                                          
    for (i = 0; i < len; i++) {
        sum += buf[i];
    }                 
    return (0xFF - (sum & 0xFF));
}


void xbee_sendAPI(uint8_t buff[],uint16_t len){
    xbee_send(buff,len);
}
                                       

void xbee_receivePacket( uint8_t recvPacket[],uint16_t size){
    
    int start = 3;
    if(size <= 5)
        return;         
    printDebug("\r\n ++++++++++ Recreive Data ++++++++\r\n");
    print_payload(recvPacket, size);
    xbee_processPacket(&recvPacket[start]);

}

void xbee_processPacket(char *buf) {
      uint8_t frameType;                                           
      frameType = buf[0]; 
      switch(frameType) { 
        
        /*=============== Recive AI ===============*/
        case 0x88  :
            if(buf[2] == 0x41 && buf[3] == 0x49){ 
                flag_state = 1;
            } 
            
        /*=============== Recive SH ===============*/ 
            
            else if (buf[2] == 0x53 && buf[3] == 0x48){
                memcpy(EndDevice_MacAddress,&buf[5],4);
                flag_state = 2;
            }    
            
        /*=============== Recive SL ===============*/  
            
            else if( buf[2] == 0x53 && buf[3] == 0x4C){ 
                memcpy(&EndDevice_MacAddress[4],&buf[5],4); 
                flag_state = 3;
            }
                   
        break;
        
        /*=============== Recive ACK ===============*/       
        case 0x90  :
        
        if(buf[32] == 0xA2){
            memcpy(Gateway_MacAddress,&buf[1],8);  
            //input[count_input] = 2;
            flag_state = 4;
        }
        else if(buf[32] == 0xA3){
            memcpy(Gateway_MacAddress,&buf[1],8); 
            input[count_input] = 3;
            count_input++;
        }
        else if(buf[32] == 0xA5){
            memcpy(Gateway_MacAddress,&buf[1],8);
            if(buf[34] == 0x01) 
                input[count_input] = 511;
            else if(buf[34] == 0x00)
                input[count_input] = 510;
            count_input++;
        }
        else if(buf[32] == 0xA6){
            EVENT[0] = buf[33];
            EVENT[1] = buf[34];
            memcpy(Gateway_MacAddress,&buf[1],8); 
            input[count_input] = 6;
            count_input++;
        }
        else if(buf[32] == 0xA8){
            memcpy(Gateway_MacAddress,&buf[1],8); 
            input[count_input] = 8;
            count_input++;
        }
        
        break; 
      }
      if(input[count_input-1] != 0) do_event(input[count_input]);
      if(count_input == 30)  count_input = 0;
}
      
uint16_t xbee_send(uint8_t buff[],uint16_t len){
    uint16_t i;
    for(i = 0; i < len; i++) {
        putchar1(buff[i]);           
    }
    return i;
}

void xbee_read() {
  
    uint8_t readbuf[256];
    uint8_t data;
    uint16_t len = 0; 
    int i = 0;
    delay_ms(100);
    
    while (rx_counter1>0){
        data=rx_buffer1[rx_rd_index1++];
        readbuf[i++] = data; 
        len++;
        #if RX_BUFFER_SIZE1 != 256
        if (rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0; 
        #endif  
        #asm("cli")
        --rx_counter1;
        #asm("sei")
    } 
    
    xbee_receivePacket(readbuf, len);  
}      