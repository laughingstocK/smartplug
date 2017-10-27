#include <mega128a.h> 
#include <stdio.h>
#include <stdlib.h>
#include <delay.h>
#include <io.h>
#include <initial_system.h>
#include <uart.h>
#include <debug.h>
#include <xbee.h>
#include <timer.h>
#include <int_protocol.h>
#include <adc.h>

/* ================================================================================= */ 
int initial_system(void) { 
    
    init_IO();
    
    //============ Uart Initial ============//
    init_uart(0, 38400);     // uart0 for printDebug
    init_uart(1, 38400);    // uart1 for xbee   
    
    //============ Timer Initial ============//
    init_timer();
    enable_timerOverflow(0);      // interrupt every 0.021 sec.
    enable_timerOverflow(1);      // interrupt every 1 sec. 
    enable_timerOverflow(3);      // interrupt every 0.5 sec. 
    
    //============ Module Initial ============//
    init_adc(VREF_AVCC); 
    
    return 0;
}

/* ================================================================================= */ 
void init_IO(void) {
      
    /*----- Digital Input -----*/
    // Initial Direction 
    SW_BUTTON_DDR;           // Switch Button, Join Button 
    // pull up             
    SW_BUTTON_PORT = 1;  
    
    D_SW1_DDR; 
    D_SW2_DDR;
    D_SW3_DDR;
    D_SW4_DDR;
    
    /*----- Digital Output -----*/
    // Initial Direction 
    LED_STAT_DDR;                   // LED Status
    POWER_RELAY_DDR;                // Drive relay 
    XBEE_RESET_DDR; 
    XBEE_SLEEP_DDR;  
    
    LED_STAT_OFF;
    POWER_RELAY_OFF;
    XBEE_RESET_HIGH;      // XBee Reset active low 
    XBEE_SLEEP_LOW;

}
/* ================================================================================= */ 
int8_t read_dSwitch() {
    int8_t read1, read2;     
    read1 = D_SW1_PIN | (D_SW2_PIN<<1) | (D_SW3_PIN<<2) | (D_SW4_PIN<<3); 
    delay_ms(100); 
    read2 = D_SW1_PIN | (D_SW2_PIN<<1) | (D_SW3_PIN<<2) | (D_SW4_PIN<<3);
    if(read1 == read2) {
        return read1;
    }else {
        return -1;
    }
}

