#ifndef MEANSURE_H
#define MEANSURE_H

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

#endif

void ReadCurrent(void);
void ReadVoltage(void);

extern uint16_t number; 
extern float AMP_ADJ_ZERO;
extern float SENSOR_SENSITIVE;
extern uint16_t adcValue;
extern float total; 
extern float avg;
extern float value;
extern float Viout; 
extern float Vdif;
extern float Vsq_avg;
extern float volt;
extern float amp;
extern float power;
extern float whour;
extern float Vsum;
extern float Isum;
extern float Psum;
extern float WHsum;
extern float Vavg;
extern float Iavg;
extern float Pavg; 
extern uint16_t countSampling; 
extern uint16_t adcValue;
extern float SENSOR_SENSITIVE;
extern float AMP_ADJ_ZERO;
extern eeprom float ADJ0_SENSOR5A;
extern eeprom float ADJ0_SENSOR20A;
extern eeprom float ADJ0_SENSOR30A;
extern float CURRENT_VOLT;
extern float CURRENT_AMP;
