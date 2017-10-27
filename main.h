#ifndef UART_H
#define UART_H

#include <mega128a.h> 



void ReadCurrent(void);
void ReadVoltage(void);


typedef struct {
    char dataID;
    char dataType;
    float value;
}DATASET;

#endif