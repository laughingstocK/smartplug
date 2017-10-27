#ifndef ATD_H
#define ATD_H

#define VREF_ARFF 0x00            // AREF, Internal VREF turned off
#define VREF_AVCC 0x40            // AVCC with external capacitor at AREF pin
#define VREF_INTERNAL_11 0x80     // Internal 1.1V Voltage Reference with external capacitor at AREF pin
#define VREF_INTERNAL_256 0xC0    // Internal 2.56V Voltage Reference with external capacitor at AREF pin
#define ADC0 0x00
#define ADC1 0x01

#include <mega128a.h>
#include <stdint.h>

#endif

void init_adc(unsigned char vrff);
uint16_t read_adc(unsigned char adc_input);