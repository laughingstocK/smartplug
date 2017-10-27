#ifndef EEPROM_H
#define EEPROM_H

#include <stdio.h>
#include <mega128a.h>
#include <stdint.h>
#include <delay.h>
#include <string.h>


#endif

extern uint8_t Eaddress;
unsigned char EEPROM_read(unsigned int uiAddress);
void EEPROM_write(unsigned int uiAddress, unsigned char ucData);