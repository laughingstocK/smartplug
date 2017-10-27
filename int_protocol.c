#include <mega128a.h> 
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <delay.h>
#include <math.h>
#include <uart.h>
#include <debug.h>
#include <xbee.h>
#include <meansure.h>

uint8_t JOIN_A1[]           = {0x7E,0x00,0x23,0x10,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xFF,0xFE,0x00,0x00,0x30,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x7E,0x00,0x01,0xA1,0x00};
uint8_t PING_A4[]           = {0x7E,0x00,0x23,0x10,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xFF,0xFE,0x00,0x00,0x30,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x7E,0x00,0x01,0xA4,0x00};
uint8_t SEND_EVENT_[]       = {0x7E,0x00,0x25,0x10,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xFF,0xFE,0x00,0x00,0x30,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x7E,0x00,0x01,0xA5,0x01,0x00,0x00};
uint8_t SEND_REPORT_[]      = {0x7E,0x00,0x48,0x10,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xFF,0xFE,0x00,0x00,0x30,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x7E,0x00,0x26,0xA7,0x01,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x04,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};                               
uint8_t _voltage[8]         = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
uint8_t _amp[8]             = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
uint8_t _power[8]           = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};   
uint8_t _watt[8]            = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};

void reverse(char *str, int len){
    int i=0,j=len-1,temp;
    
    while (i<j){
        temp = str[i];
        str[i] = str[j];
        str[j] = temp;
        i++; j--;
    }
}

// Converts a given integer x to string str[]. d is the number
// of digits required in output. If d is more than the number
// of digits in x, then 0s are added at the beginning.

int intToStr(int x, char str[], int d){
    int i = 0;
    while (x){
        str[i++] = (x%10) + '0';
        x = x/10;
    }

    // If number of digits required is more, then
    // add 0s at the beginning
    while (i < d)
        str[i++] = '0';

    reverse(str, i);
    str[i] = '\0';
    return i;
}

void _ftoa(float n, char *res, int afterpoint){
    // Extract integer part
    int ipart = (int)n;

    // Extract floating part
    float fpart = n - (float)ipart;

    // convert integer part to string
    int i = intToStr(ipart, res, 0);
    if(ipart == 0){
       res[i] = '0';
       i++; 
    }
    // check for display option after point
    if (afterpoint != 0){
        res[i] = '.'; // add dot

        // Get the value of fraction part upto given no.
        // of points after dot. The third parameter is needed
        // to handle cases like 233.007
        fpart = fpart * pow(10, afterpoint);

        intToStr((int)fpart, res + i + 1, afterpoint);
    }
}


void send_event(uint8_t led,uint8_t state){

    memcpy(&SEND_EVENT_[5],Gateway_MacAddress,8);
    memcpy(&SEND_EVENT_[18],EndDevice_MacAddress,8); 
    memcpy(&SEND_EVENT_[26],Gateway_MacAddress,8);
    memcpy(&SEND_EVENT_[39],&state,1);
    SEND_EVENT_[37] = 0xA5;
    SEND_EVENT_[38] = led;
    SEND_EVENT_[40] = xbee_checksum(&SEND_EVENT_[3],SEND_EVENT_[2]);
    printDebug("\r\n ++++++++++ Send LED ++++++++\r\n");
    print_payload(SEND_EVENT_,41);
    xbee_sendAPI(SEND_EVENT_,41);
    
}

void send_join(){

    memcpy(&JOIN_A1[18],EndDevice_MacAddress,8);
    JOIN_A1[38] = xbee_checksum(&JOIN_A1[3],JOIN_A1[2]);
    printDebug("\r\n ++++++++++ Send Join ++++++++\r\n");
    print_payload(JOIN_A1, 39);
    xbee_sendAPI(JOIN_A1,39);
    
}

void send_ping(){

    memcpy(&PING_A4[5],Gateway_MacAddress,8);
    memcpy(&PING_A4[18],EndDevice_MacAddress,8); 
    memcpy(&PING_A4[26],Gateway_MacAddress,8);
    PING_A4[38] = xbee_checksum(&PING_A4[3],PING_A4[2]);
    printDebug("\r\n ++++++++++ Send Ping ++++++++\r\n");
    print_payload(PING_A4, 39);
    xbee_sendAPI(PING_A4,39);
    
}

void recive_event(uint8_t led,uint8_t state){

    memcpy(&SEND_EVENT_[5],Gateway_MacAddress,8);
    memcpy(&SEND_EVENT_[18],EndDevice_MacAddress,8); 
    memcpy(&SEND_EVENT_[26],Gateway_MacAddress,8);
    memcpy(&SEND_EVENT_[39],&state,1);
    SEND_EVENT_[37] = 0xA6;
    SEND_EVENT_[38] = led;
    SEND_EVENT_[40] = xbee_checksum(&SEND_EVENT_[3],SEND_EVENT_[2]);
    printDebug("\r\n ++++++++++ Send EVENT RECIVE ++++++++\r\n");
    print_payload(SEND_EVENT_,41);
    xbee_sendAPI(SEND_EVENT_,41);
    
}

void send_report(uint8_t data_id,float Vavg,float Iavg,float Pavg,float WHsum){

    memcpy(&SEND_REPORT_[5],Gateway_MacAddress,8);
    memcpy(&SEND_REPORT_[18],EndDevice_MacAddress,8); 
    memcpy(&SEND_REPORT_[26],Gateway_MacAddress,8);
     
    /*=============== Convert Data from float to ASCII ===============*/
    _ftoa(Vavg, _voltage,2);
    _ftoa(Iavg, _amp,2);
    _ftoa(Pavg, _power,2);
    _ftoa(WHsum, _watt,2);
    
    SEND_REPORT_[37] = 0xA7;
    SEND_REPORT_[38] = data_id;
    memcpy(&SEND_REPORT_[40],_voltage,8);
    memcpy(&SEND_REPORT_[49],_amp,8);
    memcpy(&SEND_REPORT_[58],_power,8);
    memcpy(&SEND_REPORT_[67],_watt,8);

    SEND_REPORT_[75] = xbee_checksum(&SEND_REPORT_[3],SEND_REPORT_[2]);
    printDebug("\r\n ++++++++++ Send REPORT ++++++++\r\n");
    print_payload(SEND_REPORT_,76);
    xbee_sendAPI(SEND_REPORT_,76);
                       
}

void SendStatusReport(void){

    Vavg = Vsum/number;      // Voltage
    Iavg = Isum/number;      // Current
    Pavg = Psum/number;      // Power 
                            
    CURRENT_VOLT = Vavg;
    CURRENT_AMP = Iavg; 
                            
    printDebug("\r\n======================================================\r\n");
    printDebug("Vsum = %0.4f  ", Vsum); printDebug("Isum = %0.4f  ", Isum); printDebug("Psum = %0.4f\r\n", Psum);
    printDebug("Vavg = %0.4f   ", Vavg); printDebug("Iavg = %0.4f   ", Iavg); printDebug("Pavg = %0.4f\r\n", Pavg);
    printDebug("Watt-Hour Sum = %0.4f\r\n", WHsum);
    printDebug("Number Sampling = %d\r\n", number);
    printDebug("======================================================\r\n\r\n");
                             
    Iavg *= 1000.0;
    send_report(01,Vavg,Iavg,Pavg,WHsum);
    Iavg /= 1000.0;                      
    /* Safety Current Sensor */
    if((SENSOR_SENSITIVE == SENSOR5A) && (Iavg > 4.9)) {
        SWITCH = TURN_OFF;
        POWER_RELAY_OFF;
        LED_STAT_OFF;
        CURRENT_VOLT = 0.0;
        CURRENT_AMP = 0.0;
        printDebug("Current Exceed --SWITCH OFF!\r\n");
    }else if((SENSOR_SENSITIVE == SENSOR20A) && (Iavg > 19.9)) {
        SWITCH = TURN_OFF;
        POWER_RELAY_OFF;
        LED_STAT_OFF;
        CURRENT_VOLT = 0.0;
        CURRENT_AMP = 0.0;
        printDebug("Current Exceed --SWITCH OFF!\r\n");
    }else if((SENSOR_SENSITIVE == SENSOR30A) && (Iavg > 29.9)) {
        SWITCH = TURN_OFF;
        POWER_RELAY_OFF;
        LED_STAT_OFF;
        CURRENT_VOLT = 0.0;
        CURRENT_AMP = 0.0;
        printDebug("Current Exceed --SWITCH OFF!\r\n");
    }
                            
    /* Reset value */
    number = 0;
    Vsum = 0.0;
    Isum = 0.0; 
    Psum = 0.0;
    WHsum = 0.0;
    
}         