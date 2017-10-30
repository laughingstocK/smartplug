#include <mega128a.h>
#include <queue.h> 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <debug.h>
#include <xbee.h>
#include <int_protocol.h>
#include <uart.h>
#include <eeprom.h>

int input[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
int count_input = 0;
int count_event = 0;

void push_event(int event){
    input[count_input] = event;
    count_input++;
}

void pop_event(){
    int event = 0;
    event = input[count_event];
    printDebug("EVENT = %d\r\n", event);
    if (event != 0) count_event++;
    printDebug("count_event = %d\r\n", count_event);
    if(count_event == 30 ) count_event = 0;
    do_event(event);
}

void do_event(int event){

            if(event == 2){
                flag_state = 4;
                printDebug("\r\n-------- JOINT SUCCESS --------\r\n");
            }
            
        /*=============== Recive ACK ===============*/   
            else if(event == 3){
                printDebug("\r\n-------- RECIVE PING --------\r\n");
                send_ping();  
            }
            
        /*=============== Recive EVENT ===============*/     
            else if(event == 510 || event == 511){ 
            printDebug("\r\n ++++++++++ _event == 510 || _event == 511 ++++++++\r\n");
                if(event == 511){
                    EVENT[1] = 1;    
                    //flag_state = 5;
                    flag_state = 4;
                    STATUS_DEVICE = 1;
                    EEPROM_write(Eaddress,STATUS_DEVICE); 
                    LED_STAT_ON;
                    POWER_RELAY_ON;
                    send_event(1,1);
                }else if(event == 510){
                    EVENT[1] = 0;
                    //flag_state = 4;
                    flag_state = 3;
                    STATUS_DEVICE = 0;
                    EEPROM_write(Eaddress,STATUS_DEVICE); 
                    LED_STAT_OFF;
                    POWER_RELAY_OFF;
                    send_event(1,0);
                } 
                recive_event(1,EVENT[1]);
                printDebug("\r\n-------- RECIVE EVENT --------\r\n");      
            }
            
            /*=============== Send EVENT Success ===============*/   
            else if(event == 6){
                printDebug("\r\n-------- SEND EVENT SUCCESS --------\r\n");
            }
        
            /*=============== Send REPPORT Success ===============*/
            else if(event == 8){
                printDebug("\r\n-------- SEND REPORT SUCCESS --------\r\n");
            } 
}


