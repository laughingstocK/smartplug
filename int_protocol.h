#ifndef INT_PROTOCOL_H
#define INT_PROTOCOL_H  

#include <meansure.h>
#include <initial_system.h>

void send_join();
void send_ping();
void send_event(uint8_t led,uint8_t state);
void recive_event(uint8_t led,uint8_t state);
void send_report(uint8_t data_id,float Vavg,float Iavg,float Pavg,float WHsum);
void SendStatusReport(void);

#endif 
