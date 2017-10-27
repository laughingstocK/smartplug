#ifndef TIMER_H
#define TIMER_H

#include <mega128a.h> 
#include <stdint.h>

typedef unsigned long int TIMER;

extern TIMER baseCounter;
extern uint8_t pressedBTCounter;
extern uint8_t _FlagBT;
extern uint8_t _Flag05INT;
extern uint8_t _Flag0001INT;
extern uint8_t _BlinkLED_1Hz;
                                       
void init_timer(void);
void enable_timerOverflow(int ch);

#endif
