#ifndef XBEE_H
#define XBEE_H

#define AI          0
#define SH          1
#define SL          2           
                                   
#endif

void xbee_receivePacket( uint8_t recvPacket[],uint16_t size);
void xbee_processPacket(char *buf);
void xbee_sendAPI(uint8_t buff[],uint16_t len);
void xbee_sendATCommand(int param);
int xbee_checksum(char buf[],int len);
uint16_t xbee_send(uint8_t buff[],uint16_t len);
void xbee_read();
void do_something(int _event);

extern int flag_state;
extern char EndDevice_MacAddress[8];
extern char Gateway_MacAddress[8];
extern uint8_t STATUS_DEVICE;
extern int event_state;
extern int input[30];
extern int count_input;
extern int count_event;
