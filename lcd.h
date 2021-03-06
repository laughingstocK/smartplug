#ifndef LCD_H
#define LCD_H

typedef unsigned char byte;
/* table for the user defined character
   arrow that points to the top right corner */
extern flash byte celsius[8];
                    
void define_char(byte flash *pc, byte char_code);
void LCD_initial(void);
void LCD_printTemp(float temp);
void LCD_printSettingTemp(float temp);
                    
#endif
                    