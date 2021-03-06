#include <mega128a.h> 
#include <stdint.h>
#include <i2c.h>
#include "node_address.h"
#include "debug.h"
#include "int_protocol.h"

/* ================================================================================= */
// Get EUI-64 Node Address
uint8_t nodeAddress_read(uint8_t *addr) {

    uint8_t control_byte    = 0xA0;         // 1010 000 0   0=W, 1=R
    uint8_t address         = 0xFA;         // EUI-48 store in address 0xFA-0xFF
    uint8_t i = 0;
    
    i = i2c_start();
    if(!i) {
        printDebug("WARNING : [nodeAddress_read] i2c Bus is busy\r\n");
        return 1;
    }
    i2c_write(control_byte);
    i2c_write(address);
    i = i2c_start();
    if(!i) {
        printDebug("WARNING : [nodeAddress_read] i2c Bus is busy\r\n");
        return 1;
    }
    i2c_write(control_byte | 1);
    addr[0] = i2c_read(1);
    addr[1] = i2c_read(1);
    addr[2] = i2c_read(1);
    addr[3] = 0xFF;
    addr[4] = 0xFE;
    addr[5] = i2c_read(1);
    addr[6] = i2c_read(1);
    addr[7] = i2c_read(0);
    i2c_stop();
        
    printDebug("EUI-64 Address   : ");
    for(i = 0; i < 8; i++)  {
        printDebug("%02X ", addr[i]);    
    }
    printDebug("\r\n");
    return 0;

}
/* ================================================================================= */
uint8_t nodeAddress_write(uint8_t *addr){
    uint8_t i = 0;
    printDebug("EUI-64 Address   : ");
    for(i = 0; i < 8; i++)  {
        printDebug("%02X ", addr[i]);    
    }
    printDebug("\r\n");
    return 0;
}

