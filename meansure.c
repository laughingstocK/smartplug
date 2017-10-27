#include <mega128a.h> 
#include <stdio.h>
#include <stdint.h>
#include <delay.h>
#include <string.h>
#include <uart.h>
#include <int_protocol.h>
#include <debug.h>
#include <adc.h>
#include <math.h>
#include <meansure.h>

float SENSOR_SENSITIVE;
float AMP_ADJ_ZERO;
float total                 = 0.0; 
float avg                   = 2500.0;
float value                 = 0.0;
float Viout                 = 0.0; 
float Vdif                  = 0.0;
float Vsq_avg               = 0.0;
float volt                  = 0.0;
float amp                   = 0.0;
float power                 = 0.0;
float whour                 = 0.0;
float Vsum                  = 0.0;
float Isum                  = 0.0;
float Psum                  = 0.0;
float WHsum                 = 0.0;
float Vavg                  = 0.0;
float Iavg                  = 0.0;
float Pavg                  = 0.0; 
float CURRENT_VOLT          = 0.0;
float CURRENT_AMP           = 0.0;
uint16_t number             = 0; 
uint16_t adcValue           = 0;
uint16_t countSampling      = 0;
eeprom float ADJ0_SENSOR5A  = 0.090;
eeprom float ADJ0_SENSOR20A = 0.11;
eeprom float ADJ0_SENSOR30A = 0.11;

void ReadCurrent(void){
    adcValue = read_adc(ADC1); 
    printDebug("ADC = %d\r\n", adcValue);
    value = adcValue * (5000.0 / 1023.0);
                    
    // Keep track of the moving average 
    // See more : http://jeelabs.org/2011/09/15/power-measurement-acs-code/
    avg = (499.0*avg + value) / 500.0;
                    
    if(value > avg){
        Vdif = value - avg;
        total += (Vdif*Vdif);              
    }else if(value < avg) { 
        Vdif = avg - value;
        total += (Vdif*Vdif);
    }
    countSampling++; 
}

void ReadVoltage(void){
   /*---------- Voltage ----------*/
    adcValue = read_adc(ADC0);
    volt = (((adcValue*5.0)/1023.0)/0.01); 
    if(volt < 223.0) { 
        volt += 9.0;
    }else if(volt > 233.0) {
        volt -= 4.0;
    }
    printDebug("Volt = %f\r\n", volt);
    Vsum += volt;
                            
    /*---------- Current ----------*/
    // V-rms
    // See more : http://www.electronics-tutorials.ws/blog/rms-voltage.html
    Vsq_avg = total / countSampling;
    Viout = sqrt(Vsq_avg);
    amp = Viout / SENSOR_SENSITIVE;                  // ACS712 +-5 or +-20 or +-30 Amp.
                     
    /* Adjust Current to 0 */
    if(amp < AMP_ADJ_ZERO) {
        amp = 0.0;                                            
    } 
                    
    total = 0.0;
    countSampling = 0;
    Isum += amp;
                            
    /*---------- Power ----------*/
    power = volt*amp;
    Psum += power;
                            
    /*----------  Watt-hour ----------*/
    whour = power*(0.5/3600.0);
    WHsum += whour;
    number++;        
}