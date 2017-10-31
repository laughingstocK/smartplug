
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128A
;Program type             : Application
;Clock frequency          : 11.059200 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : float, width, precision
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1280 byte(s)
;Heap size                : 1024 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega128A
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0500
	.EQU __HEAP_SIZE=0x0400
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _error=R5
	.DEF _read_D_SW=R4
	.DEF _start_event=R6
	.DEF _counter=R8
	.DEF _rx_wr_index1=R10
	.DEF _rxPackageIndex0=R13
	.DEF _rxPackageIndexCount0=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer3_ovf_isr
	JMP  _usart1_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;HEAP START MARKER INITIALIZATION
__HEAP_START_MARKER:
	.DW  0,0

_0x3:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0xFF,0xFF,0xFF,0xFF
_0x4D:
	.DB  0x0,0x0
_0x0:
	.DB  0xD,0xA,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B
	.DB  0x2B,0x2B,0x2B,0x2B,0x20,0x53,0x6D,0x61
	.DB  0x72,0x74,0x20,0x53,0x77,0x69,0x74,0x63
	.DB  0x68,0x20,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B
	.DB  0x2B,0x2B,0x2B,0x2B,0xD,0xA,0x0,0xD
	.DB  0xA,0x46,0x69,0x72,0x6D,0x77,0x61,0x72
	.DB  0x65,0x20,0x56,0x65,0x72,0x73,0x69,0x6F
	.DB  0x6E,0x20,0x3A,0x20,0x25,0x30,0x2E,0x31
	.DB  0x66,0xD,0xA,0x0,0x43,0x75,0x72,0x72
	.DB  0x65,0x6E,0x74,0x20,0x53,0x65,0x6E,0x73
	.DB  0x6F,0x72,0x20,0x20,0x20,0x3A,0x20,0x41
	.DB  0x43,0x53,0x37,0x31,0x32,0x45,0x4C,0x43
	.DB  0x54,0x52,0x2D,0x30,0x35,0x42,0x2D,0x54
	.DB  0x20,0x28,0x25,0x30,0x2E,0x31,0x66,0x20
	.DB  0x6D,0x56,0x2F,0x41,0x6D,0x70,0x2E,0x29
	.DB  0xD,0xA,0x0,0xD,0xA,0x2B,0x2B,0x2B
	.DB  0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x20
	.DB  0x53,0x6D,0x61,0x72,0x74,0x20,0x50,0x6C
	.DB  0x75,0x67,0x20,0x2B,0x2B,0x2B,0x2B,0x2B
	.DB  0x2B,0x2B,0x2B,0x2B,0x2B,0xD,0xA,0x0
	.DB  0x43,0x75,0x72,0x72,0x65,0x6E,0x74,0x20
	.DB  0x53,0x65,0x6E,0x73,0x6F,0x72,0x20,0x20
	.DB  0x20,0x3A,0x20,0x41,0x43,0x53,0x37,0x31
	.DB  0x32,0x45,0x4C,0x43,0x54,0x52,0x2D,0x32
	.DB  0x30,0x41,0x2D,0x54,0x20,0x28,0x25,0x30
	.DB  0x2E,0x31,0x66,0x20,0x6D,0x56,0x2F,0x41
	.DB  0x6D,0x70,0x2E,0x29,0xD,0xA,0x0,0xD
	.DB  0xA,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B
	.DB  0x2B,0x2B,0x2B,0x20,0x53,0x6D,0x61,0x72
	.DB  0x74,0x20,0x42,0x72,0x65,0x61,0x6B,0x65
	.DB  0x72,0x20,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B
	.DB  0x2B,0x2B,0x2B,0x2B,0xD,0xA,0x0,0x43
	.DB  0x75,0x72,0x72,0x65,0x6E,0x74,0x20,0x53
	.DB  0x65,0x6E,0x73,0x6F,0x72,0x20,0x20,0x20
	.DB  0x3A,0x20,0x41,0x43,0x53,0x37,0x31,0x32
	.DB  0x45,0x4C,0x43,0x54,0x52,0x2D,0x33,0x30
	.DB  0x41,0x2D,0x54,0x20,0x28,0x25,0x30,0x2E
	.DB  0x31,0x66,0x20,0x6D,0x56,0x2F,0x41,0x6D
	.DB  0x70,0x2E,0x29,0xD,0xA,0x0,0x52,0x65
	.DB  0x61,0x64,0x20,0x44,0x69,0x70,0x2D,0x53
	.DB  0x77,0x69,0x74,0x63,0x68,0x20,0x45,0x52
	.DB  0x52,0x4F,0x52,0x21,0xD,0xA,0x0,0xD
	.DB  0xA,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B
	.DB  0x2B,0x2B,0x2B,0x20,0x44,0x65,0x66,0x61
	.DB  0x75,0x6C,0x74,0x20,0x54,0x79,0x70,0x65
	.DB  0x20,0x3A,0x20,0x53,0x6D,0x61,0x72,0x74
	.DB  0x20,0x53,0x77,0x69,0x74,0x63,0x68,0x20
	.DB  0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B
	.DB  0x2B,0x2B,0xD,0xA,0x0,0x43,0x75,0x72
	.DB  0x72,0x65,0x6E,0x74,0x20,0x4D,0x65,0x61
	.DB  0x73,0x75,0x72,0x65,0x20,0x20,0x3A,0x20
	.DB  0x3E,0x20,0x25,0x30,0x2E,0x32,0x66,0x20
	.DB  0x41,0x6D,0x70,0x2E,0xD,0xA,0x0,0xD
	.DB  0xA,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x20,0x49,0x6E,0x69,0x74,0x69,0x61
	.DB  0x6C,0x20,0x43,0x6F,0x6D,0x70,0x6C,0x65
	.DB  0x74,0x65,0x20,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0xD,0xA,0x0,0xD,0xA
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x20,0x53,0x74,0x61,0x72,0x74,0x20,0x50
	.DB  0x72,0x6F,0x67,0x72,0x61,0x6D,0x20,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0xD
	.DB  0xA,0x0,0xD,0xA,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x20,0x49,0x64,0x6C
	.DB  0x65,0x20,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0xD,0xA,0x0,0xD,0xA,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x20
	.DB  0x50,0x4F,0x50,0x20,0x45,0x56,0x45,0x4E
	.DB  0x54,0x20,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0xD,0xA,0x0,0xD,0xA,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x20
	.DB  0x41,0x63,0x74,0x69,0x76,0x65,0x20,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0xD
	.DB  0xA,0x0
_0x20000:
	.DB  0x25,0x30,0x35,0x64,0x20,0x20,0x20,0x0
	.DB  0x25,0x30,0x32,0x58,0x20,0x0,0x25,0x63
	.DB  0x0,0x2E,0x0,0xD,0xA,0x0
_0x60000:
	.DB  0x57,0x41,0x52,0x4E,0x49,0x4E,0x47,0x20
	.DB  0x3A,0x20,0x55,0x41,0x52,0x54,0x30,0x20
	.DB  0x42,0x55,0x46,0x46,0x45,0x52,0x20,0x4F
	.DB  0x56,0x45,0x52,0x46,0x4C,0x4F,0x57,0x20
	.DB  0x25,0x64,0xD,0xA,0x0
_0x80003:
	.DB  0x7E,0x0,0x4,0x8,0x1,0x41,0x49,0x6C
_0x80004:
	.DB  0x7E,0x0,0x4,0x8,0x1,0x53,0x4C,0x57
_0x80005:
	.DB  0x7E,0x0,0x4,0x8,0x1,0x53,0x48,0x5B
_0x80000:
	.DB  0xD,0xA,0x20,0x2B,0x2B,0x2B,0x2B,0x2B
	.DB  0x2B,0x2B,0x2B,0x2B,0x2B,0x20,0x53,0x65
	.DB  0x6E,0x64,0x20,0x41,0x49,0x20,0x2B,0x2B
	.DB  0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0xD,0xA
	.DB  0x0,0xD,0xA,0x20,0x2B,0x2B,0x2B,0x2B
	.DB  0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x20,0x53
	.DB  0x65,0x6E,0x64,0x20,0x53,0x48,0x20,0x2B
	.DB  0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0xD
	.DB  0xA,0x0,0xD,0xA,0x20,0x2B,0x2B,0x2B
	.DB  0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x20
	.DB  0x53,0x65,0x6E,0x64,0x20,0x53,0x4C,0x20
	.DB  0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B
	.DB  0xD,0xA,0x0,0xD,0xA,0x20,0x2B,0x2B
	.DB  0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B
	.DB  0x20,0x52,0x65,0x63,0x72,0x65,0x69,0x76
	.DB  0x65,0x20,0x44,0x61,0x74,0x61,0x20,0x2B
	.DB  0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0xD
	.DB  0xA,0x0
_0xC0003:
	.DB  0x7E,0x0,0x23,0x10,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0xFF,0xFE,0x0
	.DB  0x0,0x30,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x7E,0x0,0x1,0xA1
_0xC0004:
	.DB  0x7E,0x0,0x23,0x10,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0xFF,0xFE,0x0
	.DB  0x0,0x30,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x7E,0x0,0x1,0xA4
_0xC0005:
	.DB  0x7E,0x0,0x25,0x10,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0xFF,0xFE,0x0
	.DB  0x0,0x30,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x7E,0x0,0x1,0xA5,0x1
_0xC0006:
	.DB  0x7E,0x0,0x48,0x10,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0xFF,0xFE,0x0
	.DB  0x0,0x30,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x7E,0x0,0x26,0xA7,0x1,0x1
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x2,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x3,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x4
_0xC0000:
	.DB  0xD,0xA,0x20,0x2B,0x2B,0x2B,0x2B,0x2B
	.DB  0x2B,0x2B,0x2B,0x2B,0x2B,0x20,0x53,0x65
	.DB  0x6E,0x64,0x20,0x4C,0x45,0x44,0x20,0x2B
	.DB  0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0xD
	.DB  0xA,0x0,0xD,0xA,0x20,0x2B,0x2B,0x2B
	.DB  0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x20
	.DB  0x53,0x65,0x6E,0x64,0x20,0x4A,0x6F,0x69
	.DB  0x6E,0x20,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B
	.DB  0x2B,0x2B,0xD,0xA,0x0,0xD,0xA,0x20
	.DB  0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B
	.DB  0x2B,0x2B,0x20,0x53,0x65,0x6E,0x64,0x20
	.DB  0x50,0x69,0x6E,0x67,0x20,0x2B,0x2B,0x2B
	.DB  0x2B,0x2B,0x2B,0x2B,0x2B,0xD,0xA,0x0
	.DB  0xD,0xA,0x20,0x2B,0x2B,0x2B,0x2B,0x2B
	.DB  0x2B,0x2B,0x2B,0x2B,0x2B,0x20,0x53,0x65
	.DB  0x6E,0x64,0x20,0x45,0x56,0x45,0x4E,0x54
	.DB  0x20,0x52,0x45,0x43,0x49,0x56,0x45,0x20
	.DB  0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B
	.DB  0xD,0xA,0x0,0xD,0xA,0x20,0x2B,0x2B
	.DB  0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B,0x2B
	.DB  0x20,0x53,0x65,0x6E,0x64,0x20,0x52,0x45
	.DB  0x50,0x4F,0x52,0x54,0x20,0x2B,0x2B,0x2B
	.DB  0x2B,0x2B,0x2B,0x2B,0x2B,0xD,0xA,0x0
	.DB  0xD,0xA,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0xD,0xA,0x0,0x56,0x73,0x75,0x6D,0x20
	.DB  0x3D,0x20,0x25,0x30,0x2E,0x34,0x66,0x20
	.DB  0x20,0x0,0x49,0x73,0x75,0x6D,0x20,0x3D
	.DB  0x20,0x25,0x30,0x2E,0x34,0x66,0x20,0x20
	.DB  0x0,0x50,0x73,0x75,0x6D,0x20,0x3D,0x20
	.DB  0x25,0x30,0x2E,0x34,0x66,0xD,0xA,0x0
	.DB  0x56,0x61,0x76,0x67,0x20,0x3D,0x20,0x25
	.DB  0x30,0x2E,0x34,0x66,0x20,0x20,0x20,0x0
	.DB  0x49,0x61,0x76,0x67,0x20,0x3D,0x20,0x25
	.DB  0x30,0x2E,0x34,0x66,0x20,0x20,0x20,0x0
	.DB  0x50,0x61,0x76,0x67,0x20,0x3D,0x20,0x25
	.DB  0x30,0x2E,0x34,0x66,0xD,0xA,0x0,0x57
	.DB  0x61,0x74,0x74,0x2D,0x48,0x6F,0x75,0x72
	.DB  0x20,0x53,0x75,0x6D,0x20,0x3D,0x20,0x25
	.DB  0x30,0x2E,0x34,0x66,0xD,0xA,0x0,0x4E
	.DB  0x75,0x6D,0x62,0x65,0x72,0x20,0x53,0x61
	.DB  0x6D,0x70,0x6C,0x69,0x6E,0x67,0x20,0x3D
	.DB  0x20,0x25,0x64,0xD,0xA,0x0,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0xD,0xA,0xD,0xA
	.DB  0x0,0x43,0x75,0x72,0x72,0x65,0x6E,0x74
	.DB  0x20,0x45,0x78,0x63,0x65,0x65,0x64,0x20
	.DB  0x2D,0x2D,0x53,0x57,0x49,0x54,0x43,0x48
	.DB  0x20,0x4F,0x46,0x46,0x21,0xD,0xA,0x0
_0xE0003:
	.DB  0x40
_0x100003:
	.DB  0x5
_0x120003:
	.DB  0x0,0x40,0x1C,0x45
_0x120000:
	.DB  0x41,0x44,0x43,0x20,0x3D,0x20,0x25,0x64
	.DB  0xD,0xA,0x0,0x56,0x6F,0x6C,0x74,0x20
	.DB  0x3D,0x20,0x25,0x66,0xD,0xA,0x0
_0x140000:
	.DB  0x45,0x56,0x45,0x4E,0x54,0x20,0x3D,0x20
	.DB  0x25,0x64,0xD,0xA,0x0,0x63,0x6F,0x75
	.DB  0x6E,0x74,0x5F,0x65,0x76,0x65,0x6E,0x74
	.DB  0x20,0x3D,0x20,0x25,0x64,0xD,0xA,0x0
	.DB  0xD,0xA,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x20,0x4A,0x4F,0x49,0x4E,0x54
	.DB  0x20,0x53,0x55,0x43,0x43,0x45,0x53,0x53
	.DB  0x20,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0xD,0xA,0x0,0xD,0xA,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x20,0x52
	.DB  0x45,0x43,0x49,0x56,0x45,0x20,0x50,0x49
	.DB  0x4E,0x47,0x20,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0xD,0xA,0x0,0xD,0xA
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x20,0x52,0x45,0x43,0x49,0x56,0x45,0x20
	.DB  0x45,0x56,0x45,0x4E,0x54,0x20,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0xD,0xA
	.DB  0x0,0xD,0xA,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x20,0x53,0x45,0x4E,0x44
	.DB  0x20,0x45,0x56,0x45,0x4E,0x54,0x20,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0xD
	.DB  0xA,0x0,0xD,0xA,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x20,0x53,0x45,0x4E
	.DB  0x44,0x20,0x52,0x45,0x50,0x4F,0x52,0x54
	.DB  0x20,0x53,0x55,0x43,0x43,0x45,0x53,0x53
	.DB  0x20,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0xD,0xA,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  0xD00
	.DW  __HEAP_START_MARKER*2

	.DW  0x0D
	.DW  _specData
	.DW  _0x3*2

	.DW  0x02
	.DW  0x08
	.DW  _0x4D*2

	.DW  0x08
	.DW  _AI_COMMAND
	.DW  _0x80003*2

	.DW  0x08
	.DW  _SL_COMMAND
	.DW  _0x80004*2

	.DW  0x08
	.DW  _SH_COMMAND
	.DW  _0x80005*2

	.DW  0x26
	.DW  _JOIN_A1
	.DW  _0xC0003*2

	.DW  0x26
	.DW  _PING_A4
	.DW  _0xC0004*2

	.DW  0x27
	.DW  _SEND_EVENT_
	.DW  _0xC0005*2

	.DW  0x43
	.DW  _SEND_REPORT_
	.DW  _0xC0006*2

	.DW  0x01
	.DW  _Vreferent
	.DW  _0xE0003*2

	.DW  0x01
	.DW  _Eaddress
	.DW  _0x100003*2

	.DW  0x04
	.DW  _avg
	.DW  _0x120003*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x600

	.CSEG
;/*****************************************************
;Project         : Smart_Plug
;Date            : 9/2017
;Author          : Krerkkiat Hemadhulin
;Company         : NextCrop Co.,Ltd.
;Comments        :
;Version Format  :
;Chip type       : ATmega128a
;Program type    : Application
;Frequency       : 11.059200 MHz
;*****************************************************/
;#include <mega128a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <main.h>
;#include <stdlib.h>
;#include <stdio.h>
;#include <stdint.h>
;#include <string.h>
;#include <delay.h>
;#include <sleep.h>
;#include <io.h>
;#include <math.h>
;#include <initial_system.h>
;#include <int_protocol.h>
;#include <uart.h>
;#include <debug.h>
;#include <xbee.h>
;#include <timer.h>
;#include <adc.h>
;#include <eeprom.h>
;#include <meansure.h>
;#include <queue.h>
;#define SWITCH_PRESSED !(PINC & (1<<PINC0))
;
;uint8_t SWITCH          = TURN_OFF;
;uint8_t specData[]      = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xFF,0xFF,0xFF,0xFF};   // Specific Stucture of Join Req packet

	.DSEG
;uint8_t error;
;int8_t read_D_SW;
;int start_event;
;int counter = 0;
;//int e = 0;
;//uint8_t SEND_EVENT_TEST[38];
;
;void device_state(int state){
; 0000 002B void device_state(int state){

	.CSEG
_device_state:
; 0000 002C     if(state == 0){
	CALL SUBOPT_0x0
;	state -> Y+0
	BRNE _0x4
; 0000 002D         POWER_RELAY_OFF;
	CALL SUBOPT_0x1
; 0000 002E         LED_STAT_OFF;
	SBI  0x15,7
; 0000 002F         STATUS_DEVICE = 0;
	LDI  R30,LOW(0)
	RJMP _0x44
; 0000 0030     }else if(state == 1){
_0x4:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,1
	BRNE _0x8
; 0000 0031         POWER_RELAY_ON;
	LDS  R30,101
	ORI  R30,4
	STS  101,R30
; 0000 0032         LED_STAT_ON;
	CBI  0x15,7
; 0000 0033         STATUS_DEVICE = 1;
	LDI  R30,LOW(1)
_0x44:
	STS  _STATUS_DEVICE,R30
; 0000 0034     }
; 0000 0035 
; 0000 0036 }
_0x8:
	JMP  _0x20C0010
;void main(void) {
; 0000 0037 void main(void) {
_main:
; 0000 0038 
; 0000 0039     start_event = 0;
	CLR  R6
	CLR  R7
; 0000 003A     STATUS_DEVICE = EEPROM_read(Eaddress);
	CALL SUBOPT_0x2
; 0000 003B     if(STATUS_DEVICE == 0xFF){
	LDS  R26,_STATUS_DEVICE
	CPI  R26,LOW(0xFF)
	BRNE _0xB
; 0000 003C         EEPROM_write(Eaddress,0);
	CALL SUBOPT_0x3
	LDI  R26,LOW(0)
	CALL _EEPROM_write
; 0000 003D         STATUS_DEVICE = EEPROM_read(Eaddress);
	CALL SUBOPT_0x2
; 0000 003E     }
; 0000 003F 
; 0000 0040     /*=============== System Initialize ===============*/
; 0000 0041     do{ error = initial_system(); }while(error);
_0xB:
_0xD:
	CALL _initial_system
	MOV  R5,R30
	TST  R5
	BRNE _0xD
; 0000 0042 
; 0000 0043     /*=============== Select Device Type ===============*/
; 0000 0044 
; 0000 0045     do {
_0x10:
; 0000 0046         read_D_SW = read_dSwitch();
	CALL _read_dSwitch
	MOV  R4,R30
; 0000 0047         if(read_D_SW == 0x0F) {
	LDI  R30,LOW(15)
	CP   R30,R4
	BRNE _0x12
; 0000 0048             SENSOR_SENSITIVE = SENSOR5A;
	CALL SUBOPT_0x4
; 0000 0049             if((ADJ0_SENSOR5A > 0.0) && (ADJ0_SENSOR5A < 0.12)) {
	CALL SUBOPT_0x5
	BRGE _0x14
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3DF5C28F
	CALL __CMPF12
	BRLO _0x15
_0x14:
	RJMP _0x13
_0x15:
; 0000 004A                 AMP_ADJ_ZERO = ADJ0_SENSOR5A;
	LDI  R26,LOW(_ADJ0_SENSOR5A)
	LDI  R27,HIGH(_ADJ0_SENSOR5A)
	CALL __EEPROMRDD
	RJMP _0x45
; 0000 004B             }else {AMP_ADJ_ZERO = 0.09;}
_0x13:
	__GETD1N 0x3DB851EC
_0x45:
	STS  _AMP_ADJ_ZERO,R30
	STS  _AMP_ADJ_ZERO+1,R31
	STS  _AMP_ADJ_ZERO+2,R22
	STS  _AMP_ADJ_ZERO+3,R23
; 0000 004C             specData[8] = TYPE_SMART_SWITCH;                             // Device Type
	LDI  R30,LOW(18)
	__PUTB1MN _specData,8
; 0000 004D             printDebug("\r\n++++++++++ Smart Switch ++++++++++\r\n");
	__POINTW1FN _0x0,0
	RJMP _0x46
; 0000 004E             printDebug("\r\nFirmware Version : %0.1f\r\n", FIRMWARE_VERSION);
; 0000 004F             printDebug("Current Sensor   : ACS712ELCTR-05B-T (%0.1f mV/Amp.)\r\n", SENSOR_SENSITIVE);
; 0000 0050         }else if(read_D_SW == 0x0E) {
_0x12:
	LDI  R30,LOW(14)
	CP   R30,R4
	BRNE _0x18
; 0000 0051             SENSOR_SENSITIVE = SENSOR20A;
	__GETD1N 0x42C80000
	CALL SUBOPT_0x6
; 0000 0052             if((ADJ0_SENSOR20A > 0.0) && (ADJ0_SENSOR20A < 0.14)) {
	LDI  R26,LOW(_ADJ0_SENSOR20A)
	LDI  R27,HIGH(_ADJ0_SENSOR20A)
	CALL __EEPROMRDD
	CALL SUBOPT_0x5
	BRGE _0x1A
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3E0F5C29
	CALL __CMPF12
	BRLO _0x1B
_0x1A:
	RJMP _0x19
_0x1B:
; 0000 0053                 AMP_ADJ_ZERO = ADJ0_SENSOR20A;
	LDI  R26,LOW(_ADJ0_SENSOR20A)
	LDI  R27,HIGH(_ADJ0_SENSOR20A)
	CALL __EEPROMRDD
	RJMP _0x47
; 0000 0054             }else {AMP_ADJ_ZERO = 0.11;}
_0x19:
	__GETD1N 0x3DE147AE
_0x47:
	STS  _AMP_ADJ_ZERO,R30
	STS  _AMP_ADJ_ZERO+1,R31
	STS  _AMP_ADJ_ZERO+2,R22
	STS  _AMP_ADJ_ZERO+3,R23
; 0000 0055             specData[8] = TYPE_SMART_PLUG;                               // Device Type
	LDI  R30,LOW(17)
	__PUTB1MN _specData,8
; 0000 0056             printDebug("\r\n++++++++++ Smart Plug ++++++++++\r\n");
	__POINTW1FN _0x0,123
	CALL SUBOPT_0x7
; 0000 0057             printDebug("\r\nFirmware Version : %0.1f\r\n", FIRMWARE_VERSION);
; 0000 0058             printDebug("Current Sensor   : ACS712ELCTR-20A-T (%0.1f mV/Amp.)\r\n", SENSOR_SENSITIVE);
	__POINTW1FN _0x0,160
	RJMP _0x48
; 0000 0059         }else if(read_D_SW == 0x0D) {
_0x18:
	LDI  R30,LOW(13)
	CP   R30,R4
	BRNE _0x1E
; 0000 005A             SENSOR_SENSITIVE = SENSOR30A;
	__GETD1N 0x42840000
	CALL SUBOPT_0x6
; 0000 005B             if((ADJ0_SENSOR30A > 0.0) && (ADJ0_SENSOR30A < 0.15)) {
	LDI  R26,LOW(_ADJ0_SENSOR30A)
	LDI  R27,HIGH(_ADJ0_SENSOR30A)
	CALL __EEPROMRDD
	CALL SUBOPT_0x5
	BRGE _0x20
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3E19999A
	CALL __CMPF12
	BRLO _0x21
_0x20:
	RJMP _0x1F
_0x21:
; 0000 005C                 AMP_ADJ_ZERO = ADJ0_SENSOR30A;
	LDI  R26,LOW(_ADJ0_SENSOR30A)
	LDI  R27,HIGH(_ADJ0_SENSOR30A)
	CALL __EEPROMRDD
	RJMP _0x49
; 0000 005D             }else {AMP_ADJ_ZERO = 0.12;}
_0x1F:
	__GETD1N 0x3DF5C28F
_0x49:
	STS  _AMP_ADJ_ZERO,R30
	STS  _AMP_ADJ_ZERO+1,R31
	STS  _AMP_ADJ_ZERO+2,R22
	STS  _AMP_ADJ_ZERO+3,R23
; 0000 005E             specData[8] = TYPE_SMART_BREAKER;                            // Device Type
	LDI  R30,LOW(19)
	__PUTB1MN _specData,8
; 0000 005F             printDebug("\r\n++++++++++ Smart Breaker ++++++++++\r\n");
	__POINTW1FN _0x0,215
	CALL SUBOPT_0x7
; 0000 0060             printDebug("\r\nFirmware Version : %0.1f\r\n", FIRMWARE_VERSION);
; 0000 0061             printDebug("Current Sensor   : ACS712ELCTR-30A-T (%0.1f mV/Amp.)\r\n", SENSOR_SENSITIVE);
	__POINTW1FN _0x0,255
	RJMP _0x48
; 0000 0062         }else if(read_D_SW < 0) {
_0x1E:
	LDI  R30,LOW(0)
	CP   R4,R30
	BRGE _0x24
; 0000 0063             printDebug("Read Dip-Switch ERROR!\r\n");
	__POINTW1FN _0x0,310
	CALL SUBOPT_0x8
; 0000 0064         }else {
	RJMP _0x25
_0x24:
; 0000 0065             SENSOR_SENSITIVE = SENSOR5A;
	CALL SUBOPT_0x4
; 0000 0066             AMP_ADJ_ZERO = ADJ0_SENSOR5A;
	STS  _AMP_ADJ_ZERO,R30
	STS  _AMP_ADJ_ZERO+1,R31
	STS  _AMP_ADJ_ZERO+2,R22
	STS  _AMP_ADJ_ZERO+3,R23
; 0000 0067             specData[8] = TYPE_SMART_SWITCH;
	LDI  R30,LOW(18)
	__PUTB1MN _specData,8
; 0000 0068             printDebug("\r\n++++++++++ Default Type : Smart Switch ++++++++++\r\n");
	__POINTW1FN _0x0,335
_0x46:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printDebug
	ADIW R28,2
; 0000 0069             printDebug("\r\nFirmware Version : %0.1f\r\n", FIRMWARE_VERSION);
	__POINTW1FN _0x0,39
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
; 0000 006A             printDebug("Current Sensor   : ACS712ELCTR-05B-T (%0.1f mV/Amp.)\r\n", SENSOR_SENSITIVE);
	__POINTW1FN _0x0,68
_0x48:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xB
	CALL SUBOPT_0xA
; 0000 006B         }
_0x25:
; 0000 006C     }while(read_D_SW < 0);
	LDI  R30,LOW(0)
	CP   R4,R30
	BRGE _0x11
	RJMP _0x10
_0x11:
; 0000 006D 
; 0000 006E     /*=============== Current Measurement ===============*/
; 0000 006F     printDebug("Current Measure  : > %0.2f Amp.\r\n", AMP_ADJ_ZERO);
	__POINTW1FN _0x0,389
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xC
	CALL SUBOPT_0xA
; 0000 0070 
; 0000 0071 
; 0000 0072     #asm("sei")    // Global enable interrupts
	sei
; 0000 0073 
; 0000 0074     printDebug("\r\n-------- Initial Complete --------\r\n");
	__POINTW1FN _0x0,423
	CALL SUBOPT_0x8
; 0000 0075     delay_ms(5000);
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	CALL _delay_ms
; 0000 0076 
; 0000 0077     printDebug("\r\n-------- Start Program --------\r\n");
	__POINTW1FN _0x0,462
	CALL SUBOPT_0x8
; 0000 0078     while(1) {
_0x26:
; 0000 0079         xbee_read();
	CALL _xbee_read
; 0000 007A 
; 0000 007B //        if(counter%111 == 0 && counter >= 111){
; 0000 007C //        if(e%2 == 0){
; 0000 007D //            SEND_EVENT_TEST[2] = 0x90;
; 0000 007E //            SEND_EVENT_TEST[3] = 0x90;
; 0000 007F //            SEND_EVENT_TEST[35] = 0xA5;
; 0000 0080 //            SEND_EVENT_TEST[36] = 0x01;
; 0000 0081 //            SEND_EVENT_TEST[37] = 0x01;
; 0000 0082 //            xbee_receivePacket(SEND_EVENT_TEST,38);
; 0000 0083 //        }else{
; 0000 0084 //            SEND_EVENT_TEST[2] = 0x90;
; 0000 0085 //            SEND_EVENT_TEST[3] = 0x90;
; 0000 0086 //            SEND_EVENT_TEST[35] = 0xA5;
; 0000 0087 //            SEND_EVENT_TEST[36] = 0x01;
; 0000 0088 //            SEND_EVENT_TEST[37] = 0x00;
; 0000 0089 //            xbee_receivePacket(SEND_EVENT_TEST,38);
; 0000 008A //       }
; 0000 008B //       e++;
; 0000 008C //}
; 0000 008D         switch (flag_state) {
	LDS  R30,_flag_state
	LDS  R31,_flag_state+1
; 0000 008E 
; 0000 008F             /*=============== Send AI ===============*/
; 0000 0090             case 0 :
	SBIW R30,0
	BRNE _0x2C
; 0000 0091                 xbee_sendATCommand(AI);
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
; 0000 0092                 delay_ms(100);
; 0000 0093 
; 0000 0094                 /*=============== Check last state from eeprom ===============*/
; 0000 0095 
; 0000 0096                 if(STATUS_DEVICE == 1){
	LDS  R26,_STATUS_DEVICE
	CPI  R26,LOW(0x1)
	BRNE _0x2D
; 0000 0097                     delay_ms(100);
	CALL SUBOPT_0xF
; 0000 0098                     device_state(1);   //on
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
; 0000 0099                     EEPROM_write(Eaddress,STATUS_DEVICE);
	CALL SUBOPT_0x12
; 0000 009A                     start_event = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R6,R30
; 0000 009B                     push_event(5110);
	LDI  R26,LOW(5110)
	LDI  R27,HIGH(5110)
	CALL _push_event
; 0000 009C                 }
; 0000 009D             break;
_0x2D:
	RJMP _0x2B
; 0000 009E 
; 0000 009F             /*=============== Send SH( High Bits MacAddress) ===============*/
; 0000 00A0             case 1 :
_0x2C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x2E
; 0000 00A1                 xbee_sendATCommand(SH);
	CALL SUBOPT_0x10
	CALL SUBOPT_0xE
; 0000 00A2                 delay_ms(100);
; 0000 00A3             break;
	RJMP _0x2B
; 0000 00A4 
; 0000 00A5             /*=============== Send SL( LOW Bits MacAddress) ===============*/
; 0000 00A6             case 2 :
_0x2E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2F
; 0000 00A7                 xbee_sendATCommand(SL);
	CALL SUBOPT_0x13
	CALL SUBOPT_0xE
; 0000 00A8                 delay_ms(100);
; 0000 00A9             break;
	RJMP _0x2B
; 0000 00AA 
; 0000 00AB             /*=============== Send Join ===============*/
; 0000 00AC             case 3 :
_0x2F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x30
; 0000 00AD                 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 00AE                 send_join();
	CALL _send_join
; 0000 00AF                 delay_ms(100);
	CALL SUBOPT_0xF
; 0000 00B0 
; 0000 00B1                 if(SWITCH_PRESSED){
	SBIC 0x13,0
	RJMP _0x31
; 0000 00B2                     delay_ms(100);
	CALL SUBOPT_0xF
; 0000 00B3                     if(STATUS_DEVICE == 0){
	LDS  R30,_STATUS_DEVICE
	CPI  R30,0
	BRNE _0x32
; 0000 00B4                         device_state(1);      //on
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
; 0000 00B5                         EEPROM_write(Eaddress,STATUS_DEVICE);
	CALL SUBOPT_0x12
; 0000 00B6                         push_event(5110);
	LDI  R26,LOW(5110)
	LDI  R27,HIGH(5110)
	RJMP _0x4A
; 0000 00B7 
; 0000 00B8                     }else if(STATUS_DEVICE == 1){
_0x32:
	LDS  R26,_STATUS_DEVICE
	CPI  R26,LOW(0x1)
	BRNE _0x34
; 0000 00B9                         device_state(0);      //off
	CALL SUBOPT_0xD
	CALL SUBOPT_0x11
; 0000 00BA                         EEPROM_write(Eaddress,STATUS_DEVICE);
	CALL SUBOPT_0x12
; 0000 00BB                         push_event(5100);
	LDI  R26,LOW(5100)
	LDI  R27,HIGH(5100)
_0x4A:
	CALL _push_event
; 0000 00BC 
; 0000 00BD                     }
; 0000 00BE                 }
_0x34:
; 0000 00BF             break;
_0x31:
	RJMP _0x2B
; 0000 00C0 
; 0000 00C1             /*=============== Idle State ===============*/
; 0000 00C2             case 4 :
_0x30:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x35
; 0000 00C3                 printDebug("\r\n-------- Idle --------\r\n");
	__POINTW1FN _0x0,498
	CALL SUBOPT_0x8
; 0000 00C4                 counter++;
	CALL SUBOPT_0x14
; 0000 00C5                 if(counter%10 == 0 ){
	BRNE _0x36
; 0000 00C6                     pop_event();
	CALL _pop_event
; 0000 00C7                     printDebug("\r\n-------- POP EVENT --------\r\n");
	__POINTW1FN _0x0,525
	CALL SUBOPT_0x8
; 0000 00C8                 }
; 0000 00C9 
; 0000 00CA                 if(start_event == 1){
_0x36:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x37
; 0000 00CB                     if(STATUS_DEVICE == 1){
	LDS  R26,_STATUS_DEVICE
	CPI  R26,LOW(0x1)
	BRNE _0x38
; 0000 00CC                         flag_state = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP _0x4B
; 0000 00CD                     }else if(STATUS_DEVICE == 0){
_0x38:
	LDS  R30,_STATUS_DEVICE
	CPI  R30,0
	BRNE _0x3A
; 0000 00CE                         flag_state = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
_0x4B:
	STS  _flag_state,R30
	STS  _flag_state+1,R31
; 0000 00CF                     }
; 0000 00D0                     start_event = 0;
_0x3A:
	CLR  R6
	CLR  R7
; 0000 00D1                 }
; 0000 00D2 
; 0000 00D3 
; 0000 00D4                 if(SWITCH_PRESSED){
_0x37:
	SBIC 0x13,0
	RJMP _0x3B
; 0000 00D5                     delay_ms(200);
	CALL SUBOPT_0x15
; 0000 00D6                        if(STATUS_DEVICE == 0){
	LDS  R30,_STATUS_DEVICE
	CPI  R30,0
	BRNE _0x3C
; 0000 00D7                             device_state(1);      //on
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
; 0000 00D8                             EEPROM_write(Eaddress,STATUS_DEVICE);
	CALL SUBOPT_0x12
; 0000 00D9                             flag_state = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x16
; 0000 00DA                             //printDebug("count_input = %d\r\n", count_input);
; 0000 00DB                             push_event(5110);
	LDI  R26,LOW(5110)
	LDI  R27,HIGH(5110)
	RJMP _0x4C
; 0000 00DC                        }else if(STATUS_DEVICE == 1){
_0x3C:
	LDS  R26,_STATUS_DEVICE
	CPI  R26,LOW(0x1)
	BRNE _0x3E
; 0000 00DD                             device_state(0);     //off
	CALL SUBOPT_0xD
	CALL SUBOPT_0x11
; 0000 00DE                             EEPROM_write(Eaddress,STATUS_DEVICE);
	CALL SUBOPT_0x12
; 0000 00DF                             flag_state = 4;
	CALL SUBOPT_0x17
; 0000 00E0                             //printDebug("count_input = %d\r\n", count_input);
; 0000 00E1                             push_event(5100);
_0x4C:
	CALL _push_event
; 0000 00E2                        }
; 0000 00E3                 }
_0x3E:
; 0000 00E4             break;
_0x3B:
	RJMP _0x2B
; 0000 00E5 
; 0000 00E6             /*=============== Active State ===============*/
; 0000 00E7             case 5 :
_0x35:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x2B
; 0000 00E8             printDebug("\r\n-------- Active --------\r\n");
	__POINTW1FN _0x0,557
	CALL SUBOPT_0x8
; 0000 00E9                 ReadCurrent();
	CALL _ReadCurrent
; 0000 00EA                 ReadVoltage();
	CALL _ReadVoltage
; 0000 00EB 
; 0000 00EC                 counter++;
	CALL SUBOPT_0x14
; 0000 00ED                 if(counter%10 == 0 ){
	BRNE _0x40
; 0000 00EE                     printDebug("\r\n-------- POP EVENT --------\r\n");
	__POINTW1FN _0x0,525
	CALL SUBOPT_0x8
; 0000 00EF                     pop_event();
	CALL _pop_event
; 0000 00F0                 }
; 0000 00F1 
; 0000 00F2 
; 0000 00F3                 if(number == 1000){
_0x40:
	LDS  R26,_number
	LDS  R27,_number+1
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	BRNE _0x41
; 0000 00F4                     SendStatusReport();
	CALL _SendStatusReport
; 0000 00F5                 }
; 0000 00F6 
; 0000 00F7                 if(SWITCH_PRESSED){
_0x41:
	SBIC 0x13,0
	RJMP _0x42
; 0000 00F8                     delay_ms(200);
	CALL SUBOPT_0x15
; 0000 00F9                     device_state(0); // off
	CALL SUBOPT_0xD
	CALL SUBOPT_0x11
; 0000 00FA                     EEPROM_write(Eaddress,STATUS_DEVICE);
	CALL SUBOPT_0x12
; 0000 00FB                     flag_state = 4;
	CALL SUBOPT_0x17
; 0000 00FC //                  printDebug("count_input = %d\r\n", count_input);
; 0000 00FD                     push_event(5100);
	CALL _push_event
; 0000 00FE                 }
; 0000 00FF             break;
_0x42:
; 0000 0100         }
_0x2B:
; 0000 0101     }
	RJMP _0x26
; 0000 0102 }
_0x43:
	RJMP _0x43
;#include <stdio.h>
;#include <stdlib.h>
;#include <string.h>
;#include <stdarg.h>
;#include <ctype.h>
;#include <stdint.h>
;#include <debug.h>
;#include <uart.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <adc.h>
;#include <initial_system.h>
;
;/* ================================================================================= */
;void printDebug(flash char *fmtstr, ...)
; 0001 000E {

	.CSEG
_printDebug:
	PUSH R15
	MOV  R15,R24
; 0001 000F     char textBuffer[256];
; 0001 0010     va_list argptr;
; 0001 0011 
; 0001 0012     va_start(argptr, fmtstr);
	SUBI R29,1
	ST   -Y,R17
	ST   -Y,R16
;	*fmtstr -> Y+258
;	textBuffer -> Y+2
;	*argptr -> R16,R17
	MOVW R26,R28
	SUBI R26,LOW(-(254))
	SBCI R27,HIGH(-(254))
	CALL __ADDW2R15
	MOVW R16,R26
; 0001 0013     vsprintf(textBuffer,fmtstr,argptr);
	CALL SUBOPT_0x18
	MOVW R26,R28
	SUBI R26,LOW(-(260))
	SBCI R27,HIGH(-(260))
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	CALL _vsprintf
; 0001 0014     send_uart(0, textBuffer);
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,3
	CALL _send_uart
; 0001 0015     va_end(argptr);
; 0001 0016 
; 0001 0017     return;
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,2
	SUBI R29,-1
	POP  R15
	RET
; 0001 0018 }
;/* ================================================================================= */
; void print_payload(const unsigned char *payload, int len) {
; 0001 001A void print_payload(const unsigned char *payload, int len) {
_print_payload:
; 0001 001B 
; 0001 001C     int len_rem = len;
; 0001 001D     int line_width = 16;            // number of bytes per line //
; 0001 001E     int line_len;
; 0001 001F     int offset = 0;                  // zero-based offset counter //
; 0001 0020     const unsigned char *ch = payload;
; 0001 0021 
; 0001 0022     if (len <= 0)
	CALL SUBOPT_0x19
	STD  Y+2,R30
	LDI  R30,LOW(0)
	STD  Y+3,R30
	CALL __SAVELOCR6
;	*payload -> Y+12
;	len -> Y+10
;	len_rem -> R16,R17
;	line_width -> R18,R19
;	line_len -> R20,R21
;	offset -> Y+8
;	*ch -> Y+6
	__GETWRS 16,17,10
	__GETWRN 18,19,16
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL __CPW02
	BRGE _0x20C0012
; 0001 0023         return;
; 0001 0024 
; 0001 0025     // data fits on one line //
; 0001 0026     if (len <= line_width) {
	CP   R18,R26
	CPC  R19,R27
	BRLT _0x20004
; 0001 0027         print_hex_ascii_line(ch, len, offset);
	CALL SUBOPT_0x1A
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1B
; 0001 0028         return;
	RJMP _0x20C0012
; 0001 0029     }
; 0001 002A     // data spans multiple lines //
; 0001 002B     for ( ;; ) {
_0x20004:
_0x20006:
; 0001 002C         // compute current line length //
; 0001 002D         line_len = line_width % len_rem;
	MOVW R30,R16
	MOVW R26,R18
	CALL __MODW21
	MOVW R20,R30
; 0001 002E         // print line //
; 0001 002F         print_hex_ascii_line(ch, line_len, offset);
	CALL SUBOPT_0x1A
	ST   -Y,R21
	ST   -Y,R20
	CALL SUBOPT_0x1B
; 0001 0030         // compute total remaining //
; 0001 0031         len_rem = len_rem - line_len;
	__SUBWRR 16,17,20,21
; 0001 0032         // shift pointer to remaining bytes to print //
; 0001 0033         ch = ch + line_len;
	MOVW R30,R20
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0001 0034         // add offset //
; 0001 0035         offset = offset + line_width;
	MOVW R30,R18
	CALL SUBOPT_0x1C
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0001 0036         // check if we have line width chars or less //
; 0001 0037         if (len_rem <= line_width) {
	__CPWRR 18,19,16,17
	BRLT _0x20008
; 0001 0038             // print last line and get out //
; 0001 0039             print_hex_ascii_line(ch, len_rem, offset);
	CALL SUBOPT_0x1A
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x1B
; 0001 003A             break;
	RJMP _0x20007
; 0001 003B         }
; 0001 003C     }
_0x20008:
	RJMP _0x20006
_0x20007:
; 0001 003D     return;
_0x20C0012:
	CALL __LOADLOCR6
	ADIW R28,14
	RET
; 0001 003E 
; 0001 003F }
;/* ================================================================================= */
;void print_hex_ascii_line(const unsigned char *payload, int len, int offset) {
; 0001 0041 void print_hex_ascii_line(const unsigned char *payload, int len, int offset) {
_print_hex_ascii_line:
; 0001 0042 
; 0001 0043     int i;
; 0001 0044     int gap;
; 0001 0045     const unsigned char *ch;
; 0001 0046 
; 0001 0047     // offset //
; 0001 0048     printDebug("%05d   ", offset);
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR6
;	*payload -> Y+10
;	len -> Y+8
;	offset -> Y+6
;	i -> R16,R17
;	gap -> R18,R19
;	*ch -> R20,R21
	__POINTW1FN _0x20000,0
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL SUBOPT_0x1D
; 0001 0049 
; 0001 004A     // hex //
; 0001 004B     ch = payload;
	__GETWRS 20,21,10
; 0001 004C     for(i = 0; i < len; i++) {
	__GETWRN 16,17,0
_0x2000A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x2000B
; 0001 004D         printDebug("%02X ", *ch);
	__POINTW1FN _0x20000,8
	CALL SUBOPT_0x1E
; 0001 004E 
; 0001 004F         ch++;
	__ADDWRN 20,21,1
; 0001 0050         // print extra space after 8th byte for visual aid //
; 0001 0051         if (i == 7){
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2000C
; 0001 0052             printDebug(" ");
	__POINTW1FN _0x20000,6
	CALL SUBOPT_0x8
; 0001 0053 
; 0001 0054         }
; 0001 0055     }
_0x2000C:
	__ADDWRN 16,17,1
	RJMP _0x2000A
_0x2000B:
; 0001 0056     // print space to handle line less than 8 bytes //
; 0001 0057     if (len < 8){
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,8
	BRGE _0x2000D
; 0001 0058         printDebug(" ");
	__POINTW1FN _0x20000,6
	CALL SUBOPT_0x8
; 0001 0059 
; 0001 005A     }
; 0001 005B 
; 0001 005C     // fill hex gap with spaces if not full line //
; 0001 005D     if (len < 16) {
_0x2000D:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,16
	BRGE _0x2000E
; 0001 005E         gap = 16 - len;
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	SUB  R30,R26
	SBC  R31,R27
	MOVW R18,R30
; 0001 005F         for (i = 0; i < gap; i++) {
	__GETWRN 16,17,0
_0x20010:
	__CPWRR 16,17,18,19
	BRGE _0x20011
; 0001 0060             printDebug("   ");
	__POINTW1FN _0x20000,4
	CALL SUBOPT_0x8
; 0001 0061 
; 0001 0062         }
	__ADDWRN 16,17,1
	RJMP _0x20010
_0x20011:
; 0001 0063     }
; 0001 0064     printDebug("   ");
_0x2000E:
	__POINTW1FN _0x20000,4
	CALL SUBOPT_0x8
; 0001 0065 
; 0001 0066 
; 0001 0067     // ascii (if printable) //
; 0001 0068     ch = payload;
	__GETWRS 20,21,10
; 0001 0069     for(i = 0; i < len; i++) {
	__GETWRN 16,17,0
_0x20013:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x20014
; 0001 006A         if (isprint(*ch)){
	MOVW R26,R20
	LD   R26,X
	CALL _isprint
	CPI  R30,0
	BREQ _0x20015
; 0001 006B             printDebug("%c", *ch);
	__POINTW1FN _0x20000,14
	CALL SUBOPT_0x1E
; 0001 006C 
; 0001 006D         }
; 0001 006E         else{
	RJMP _0x20016
_0x20015:
; 0001 006F             printDebug(".");
	__POINTW1FN _0x20000,17
	CALL SUBOPT_0x8
; 0001 0070 
; 0001 0071         }
_0x20016:
; 0001 0072         ch++;
	__ADDWRN 20,21,1
; 0001 0073     }
	__ADDWRN 16,17,1
	RJMP _0x20013
_0x20014:
; 0001 0074 
; 0001 0075     printDebug("\r\n");
	__POINTW1FN _0x20000,19
	CALL SUBOPT_0x8
; 0001 0076     return;
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; 0001 0077 }
;#include <mega128a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include <stdint.h>
;#include <delay.h>
;#include <string.h>
;#include <timer.h>
;#include <debug.h>
;#include <int_protocol.h>
;#include <initial_system.h>
;
;TIMER baseCounter = 0;    // -- increase continually by 1 second timer. use for timer comparison -- //
;uint8_t pressedBTCounter = 0;
;uint8_t _FlagBT = 0;
;uint8_t _Flag05INT = 0;
;uint8_t _Flag0001INT = 0;
;uint8_t _BlinkLED_1Hz = 0;
;
;/* ================================================================================= */
;/*************************************************************************************/
;/******************************* Software Timer Support ******************************/
;/*************************************************************************************/
;/* ================================================================================= */
;
;/* ================================================================================= */
;
;/* ================================================================================= */
;/* ================================================================================= */
;/*************************************************************************************/
;/********************************* Hardware Support **********************************/
;/*************************************************************************************/
;/* ================================================================================= */
;// Timer 0 overflow interrupt service routine (1 ms.)
;interrupt [TIM0_OVF] void timer0_ovf_isr(void) {
; 0002 0021 interrupt [17] void timer0_ovf_isr(void) {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0002 0022 
; 0002 0023     // Reinitialize Timer 0 value
; 0002 0024     TCNT0 = 0xD7;
	LDI  R30,LOW(215)
	OUT  0x32,R30
; 0002 0025     // Place your code here
; 0002 0026     if(SWITCH == TURN_ON /*&& _pired*/) {
	LDS  R26,_SWITCH
	CPI  R26,LOW(0x1)
	BRNE _0x40003
; 0002 0027         _Flag0001INT = 1;
	LDI  R30,LOW(1)
	STS  __Flag0001INT,R30
; 0002 0028     }
; 0002 0029 
; 0002 002A }
_0x40003:
	RJMP _0x40015
;/* ================================================================================= */
;// Timer1 overflow interrupt service routine (1 sec.)
;interrupt [TIM1_OVF] void timer1_ovf_isr(void) {
; 0002 002D interrupt [15] void timer1_ovf_isr(void) {
_timer1_ovf_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0002 002E 
; 0002 002F     //char i;
; 0002 0030 
; 0002 0031     // Reinitialize Timer1 value
; 0002 0032     TCNT1H = 0x57;
	LDI  R30,LOW(87)
	OUT  0x2D,R30
; 0002 0033     TCNT1L = 0x40;
	LDI  R30,LOW(64)
	OUT  0x2C,R30
; 0002 0034 
; 0002 0035     baseCounter++;
	LDI  R26,LOW(_baseCounter)
	LDI  R27,HIGH(_baseCounter)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0002 0036 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
;/* ================================================================================= */
;// Timer3 overflow interrupt service routine (0.5 sec.)
;interrupt [TIM3_OVF] void timer3_ovf_isr(void) {
; 0002 0039 interrupt [30] void timer3_ovf_isr(void) {
_timer3_ovf_isr:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0002 003A 
; 0002 003B     // Reinitialize Timer3 value
; 0002 003C     TCNT3H = 0xAB;
	CALL SUBOPT_0x1F
; 0002 003D     TCNT3L = 0xA0;
; 0002 003E 
; 0002 003F     /*----- Count time pressed button -----*/
; 0002 0040     if(_FlagBT) {
	LDS  R30,__FlagBT
	CPI  R30,0
	BREQ _0x40004
; 0002 0041         pressedBTCounter++;
	LDS  R30,_pressedBTCounter
	SUBI R30,-LOW(1)
	STS  _pressedBTCounter,R30
; 0002 0042     }
; 0002 0043 
; 0002 0044     /*----- 0.5 millisecond flag -----*/
; 0002 0045     if(SWITCH == TURN_ON /*&& _pired*/) {
_0x40004:
	LDS  R26,_SWITCH
	CPI  R26,LOW(0x1)
	BRNE _0x40005
; 0002 0046         _Flag05INT = 1;
	LDI  R30,LOW(1)
	STS  __Flag05INT,R30
; 0002 0047     }
; 0002 0048 
; 0002 0049     /*----- Blink Power LED 1 Hz -----*/
; 0002 004A     if(_BlinkLED_1Hz) {
_0x40005:
	LDS  R30,__BlinkLED_1Hz
	CPI  R30,0
	BREQ _0x40006
; 0002 004B         if(LED_STAT_PIN == 1) {
	SBIS 0x13,7
	RJMP _0x40007
; 0002 004C             LED_STAT_ON;
	CBI  0x15,7
; 0002 004D         }else {
	RJMP _0x4000A
_0x40007:
; 0002 004E             LED_STAT_OFF;
	SBI  0x15,7
; 0002 004F         }
_0x4000A:
; 0002 0050     }
; 0002 0051 
; 0002 0052 }
_0x40006:
_0x40015:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
;/* ================================================================================= */
;void init_timer(void) {
; 0002 0054 void init_timer(void) {
_init_timer:
; 0002 0055 
; 0002 0056     // Timer/Counter 0 initialization (1 ms.)
; 0002 0057     // Clock source: System Clock
; 0002 0058     // Clock value: 43.200 kHz
; 0002 0059     // Mode: Normal top=0xFF
; 0002 005A     // OC0 output: Disconnected
; 0002 005B     ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0002 005C     TCCR0=0x06;
	LDI  R30,LOW(6)
	OUT  0x33,R30
; 0002 005D     TCNT0=0xD7;
	LDI  R30,LOW(215)
	OUT  0x32,R30
; 0002 005E     OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0002 005F 
; 0002 0060     // Timer/Counter 1 initialization (1 sec.)
; 0002 0061     // Clock source: System Clock
; 0002 0062     // Clock value: 43.200 kHz
; 0002 0063     // Mode: Normal top=0xFFFF
; 0002 0064     // OC1A output: Discon.
; 0002 0065     // OC1B output: Discon.
; 0002 0066     // OC1C output: Discon.
; 0002 0067     // Noise Canceler: Off
; 0002 0068     // Input Capture on Falling Edge
; 0002 0069     // Timer1 Overflow Interrupt: On
; 0002 006A     // Input Capture Interrupt: Off
; 0002 006B     // Compare A Match Interrupt: Off
; 0002 006C     // Compare B Match Interrupt: Off
; 0002 006D     // Compare C Match Interrupt: Off
; 0002 006E     TCCR1A=0x00;
	OUT  0x2F,R30
; 0002 006F     TCCR1B=0x04;
	LDI  R30,LOW(4)
	OUT  0x2E,R30
; 0002 0070     TCNT1H=0x57;
	LDI  R30,LOW(87)
	OUT  0x2D,R30
; 0002 0071     TCNT1L=0x40;
	LDI  R30,LOW(64)
	OUT  0x2C,R30
; 0002 0072     ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0002 0073     ICR1L=0x00;
	OUT  0x26,R30
; 0002 0074     OCR1AH=0x00;
	OUT  0x2B,R30
; 0002 0075     OCR1AL=0x00;
	OUT  0x2A,R30
; 0002 0076     OCR1BH=0x00;
	OUT  0x29,R30
; 0002 0077     OCR1BL=0x00;
	OUT  0x28,R30
; 0002 0078     OCR1CH=0x00;
	STS  121,R30
; 0002 0079     OCR1CL=0x00;
	STS  120,R30
; 0002 007A 
; 0002 007B     // Timer/Counter 2 initialization
; 0002 007C     // Clock source: System Clock
; 0002 007D     // Clock value: Timer2 Stopped
; 0002 007E     // Mode: Normal top=0xFF
; 0002 007F     // OC2 output: Disconnected
; 0002 0080     TCCR2=0x00;
	OUT  0x25,R30
; 0002 0081     TCNT2=0x00;
	OUT  0x24,R30
; 0002 0082     OCR2=0x00;
	OUT  0x23,R30
; 0002 0083 
; 0002 0084     // Timer/Counter 3 initialization (0.5 sec.)
; 0002 0085     // Clock source: System Clock
; 0002 0086     // Clock value: 43.200 kHz
; 0002 0087     // Mode: Normal top=0xFFFF
; 0002 0088     // OC3A output: Discon.
; 0002 0089     // OC3B output: Discon.
; 0002 008A     // OC3C output: Discon.
; 0002 008B     // Noise Canceler: Off
; 0002 008C     // Input Capture on Falling Edge
; 0002 008D     // Timer3 Overflow Interrupt: On
; 0002 008E     // Input Capture Interrupt: Off
; 0002 008F     // Compare A Match Interrupt: Off
; 0002 0090     // Compare B Match Interrupt: Off
; 0002 0091     // Compare C Match Interrupt: Off
; 0002 0092     TCCR3A=0x00;
	STS  139,R30
; 0002 0093     TCCR3B=0x04;
	LDI  R30,LOW(4)
	STS  138,R30
; 0002 0094     TCNT3H=0xAB;
	CALL SUBOPT_0x1F
; 0002 0095     TCNT3L=0xA0;
; 0002 0096     ICR3H=0x00;
	LDI  R30,LOW(0)
	STS  129,R30
; 0002 0097     ICR3L=0x00;
	STS  128,R30
; 0002 0098     OCR3AH=0x00;
	STS  135,R30
; 0002 0099     OCR3AL=0x00;
	STS  134,R30
; 0002 009A     OCR3BH=0x00;
	STS  133,R30
; 0002 009B     OCR3BL=0x00;
	STS  132,R30
; 0002 009C     OCR3CH=0x00;
	STS  131,R30
; 0002 009D     OCR3CL=0x00;
	STS  130,R30
; 0002 009E 
; 0002 009F     // Watchdog Timer initialization
; 0002 00A0     // Watchdog Timer Prescaler: OSC/2048k
; 0002 00A1     #pragma optsize-
; 0002 00A2     WDTCR=0x1F;
	LDI  R30,LOW(31)
	OUT  0x21,R30
; 0002 00A3     WDTCR=0x0F;
	LDI  R30,LOW(15)
	OUT  0x21,R30
; 0002 00A4     #ifdef _OPTIMIZE_SIZE_
; 0002 00A5     #pragma optsize+
; 0002 00A6     #endif
; 0002 00A7 
; 0002 00A8     // Timer/Counter 0 Interrupt(s) initialization
; 0002 00A9     TIMSK = 0x00;
	LDI  R30,LOW(0)
	OUT  0x37,R30
; 0002 00AA 
; 0002 00AB     // Timer/Counter 1 Interrupt(s) initialization
; 0002 00AC     TIMSK = 0x00;
	OUT  0x37,R30
; 0002 00AD 
; 0002 00AE     // Timer/Counter 3 Interrupt(s) initialization
; 0002 00AF     ETIMSK = 0x00;
	STS  125,R30
; 0002 00B0 
; 0002 00B1 }
	RET
;/* ================================================================================= */
;void enable_timerOverflow(int ch) {
; 0002 00B3 void enable_timerOverflow(int ch) {
_enable_timerOverflow:
; 0002 00B4 
; 0002 00B5     /*-------------- enable timer ---------------*/
; 0002 00B6     switch(ch){
	CALL SUBOPT_0x0
;	ch -> Y+0
; 0002 00B7         case 0: // Timer/Counter 0 Interrupt(s) initialization
	BRNE _0x40010
; 0002 00B8                 TIMSK |= 0x01;
	IN   R30,0x37
	ORI  R30,1
	OUT  0x37,R30
; 0002 00B9                 break;
	RJMP _0x4000F
; 0002 00BA         case 1: // Timer/Counter 1 Interrupt(s) initialization
_0x40010:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x40011
; 0002 00BB                 TIMSK |= 0x04;
	IN   R30,0x37
	ORI  R30,4
	OUT  0x37,R30
; 0002 00BC                 break;
	RJMP _0x4000F
; 0002 00BD         case 2: // Timer/Counter 2 Interrupt(s) initialization
_0x40011:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ _0x4000F
; 0002 00BE                 //TIMSK2=0x01;
; 0002 00BF                 break;
; 0002 00C0         case 3: // Timer/Counter 3 Interrupt(s) initialization
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x40013
; 0002 00C1                 ETIMSK |= 0x04;
	LDS  R30,125
	ORI  R30,4
	STS  125,R30
; 0002 00C2                 break;
; 0002 00C3         case 4: // Timer/Counter 4 Interrupt(s) initialization
_0x40013:
; 0002 00C4                 //TIMSK4=0x01;
; 0002 00C5                 break;
; 0002 00C6     }
_0x4000F:
; 0002 00C7     // Global enable interrupts
; 0002 00C8     #asm("sei")
	sei
; 0002 00C9 }
	JMP  _0x20C0010
;
;#include <mega128a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include <stdint.h>
;#include <delay.h>
;#include <string.h>
;#include <uart.h>
;#include <debug.h>
;#include <xbee.h>
;
;// UART 1
;uint8_t rx_buffer1[RX_BUFFER_SIZE1];                                       // USART0 Receiver buffer
;uint16_t rx_wr_index1, rx_rd_index1, rx_counter1;
;bit rx_buffer_overflow1;                                                // This flag is set on USART0 Receiver buffer overflow
;
;// UART 0
;flash uint8_t charHeader            = '$';
;flash uint8_t charTerminate         = '#';
;uint8_t _FlagPackageTerminate0      = 0;
;uint8_t rxPackageIndex0;
;uint8_t rxPackage0[RX_BUFFER_SIZE0];
;uint8_t rxPackageIndexCount0;
;
;#if RX_BUFFER_SIZE0 <= 256
;#else
;#endif
;
;interrupt [USART0_RXC] void usart0_rx_isr(void) {
; 0003 001B interrupt [19] void usart0_rx_isr(void) {

	.CSEG
_usart0_rx_isr:
	CALL SUBOPT_0x20
; 0003 001C 
; 0003 001D     uint8_t status, data;
; 0003 001E     status  = UCSR0A;
;	status -> R17
;	data -> R16
	IN   R17,11
; 0003 001F     data    = UDR0;
	IN   R16,12
; 0003 0020 
; 0003 0021     if((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN)) == 0) {
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x60003
; 0003 0022 
; 0003 0023         putchar0(data);
	MOV  R26,R16
	RCALL _putchar0
; 0003 0024         // Detect Package Header
; 0003 0025         if(data == charHeader) {
	CPI  R16,36
	BRNE _0x60004
; 0003 0026             rxPackageIndex0 = 0;
	CLR  R13
; 0003 0027         }
; 0003 0028 
; 0003 0029         rxPackage0[rxPackageIndex0++] = data;
_0x60004:
	MOV  R30,R13
	INC  R13
	LDI  R31,0
	SUBI R30,LOW(-_rxPackage0)
	SBCI R31,HIGH(-_rxPackage0)
	ST   Z,R16
; 0003 002A 
; 0003 002B         if(rxPackageIndex0 >= RX_BUFFER_SIZE0) {
	LDI  R30,LOW(32)
	CP   R13,R30
	BRLO _0x60005
; 0003 002C             rxPackageIndex0 = 0;
	CLR  R13
; 0003 002D         }
; 0003 002E 
; 0003 002F         if(data == charTerminate) {
_0x60005:
	CPI  R16,35
	BRNE _0x60006
; 0003 0030             rxPackageIndexCount0 = (rxPackageIndex0 - 1);
	MOV  R30,R13
	SUBI R30,LOW(1)
	MOV  R12,R30
; 0003 0031             rxPackageIndex0 = 0;
	CLR  R13
; 0003 0032             _FlagPackageTerminate0 = 1;
	LDI  R30,LOW(1)
	STS  __FlagPackageTerminate0,R30
; 0003 0033         }
; 0003 0034     }
_0x60006:
; 0003 0035 }
_0x60003:
	RJMP _0x6003E
;/* ================================================================================= */
;// Write a character to the USART0 Transmitter
;#pragma used+
;void putchar0(uint8_t c) {
; 0003 0039 void putchar0(uint8_t c) {
_putchar0:
; 0003 003A     while((UCSR0A & DATA_REGISTER_EMPTY) == 0);
	ST   -Y,R26
;	c -> Y+0
_0x60007:
	SBIS 0xB,5
	RJMP _0x60007
; 0003 003B     UDR0 = c;
	LD   R30,Y
	OUT  0xC,R30
; 0003 003C }
	RJMP _0x20C0011
;#pragma used-
;
;interrupt [USART1_RXC] void usart1_rx_isr(void) {
; 0003 003F interrupt [31] void usart1_rx_isr(void) {
_usart1_rx_isr:
	CALL SUBOPT_0x20
; 0003 0040 
; 0003 0041     uint8_t status, data;
; 0003 0042     status  = UCSR1A;
;	status -> R17
;	data -> R16
	LDS  R17,155
; 0003 0043     data    = UDR1;
	LDS  R16,156
; 0003 0044 
; 0003 0045     if((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN)) == 0) {
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x6000A
; 0003 0046         rx_buffer1[rx_wr_index1++] = data;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	SBIW R30,1
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	ST   Z,R16
; 0003 0047          //printDebug("%02X ",data);
; 0003 0048         if (rx_wr_index1 == RX_BUFFER_SIZE1)
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x6000B
; 0003 0049             rx_wr_index1 = 0;
	CLR  R10
	CLR  R11
; 0003 004A         if (++rx_counter1 == RX_BUFFER_SIZE1) {
_0x6000B:
	LDI  R26,LOW(_rx_counter1)
	LDI  R27,HIGH(_rx_counter1)
	CALL SUBOPT_0x21
	CPI  R30,LOW(0x200)
	LDI  R26,HIGH(0x200)
	CPC  R31,R26
	BRNE _0x6000C
; 0003 004B             printDebug("WARNING : UART0 BUFFER OVERFLOW %d\r\n", rx_counter1);
	__POINTW1FN _0x60000,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_rx_counter1
	LDS  R31,_rx_counter1+1
	CALL SUBOPT_0x22
; 0003 004C             rx_counter1 = 0;
	LDI  R30,LOW(0)
	STS  _rx_counter1,R30
	STS  _rx_counter1+1,R30
; 0003 004D             rx_buffer_overflow1 = 1;
	SET
	BLD  R2,0
; 0003 004E         }
; 0003 004F     }
_0x6000C:
; 0003 0050 }
_0x6000A:
_0x6003E:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART1 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void) {
; 0003 0057 char getchar(void) {
; 0003 0058 
; 0003 0059     uint8_t data;
; 0003 005A 
; 0003 005B     while (rx_counter1 == 0);
;	data -> R17
; 0003 005C     data = rx_buffer1[rx_rd_index1++];
; 0003 005D     if(rx_rd_index1 == RX_BUFFER_SIZE1)
; 0003 005E         rx_rd_index1 = 0;
; 0003 005F     #asm("cli")
; 0003 0060     --rx_counter1;
; 0003 0061     #asm("sei")
; 0003 0062     return data;
; 0003 0063 }
;
;
;#pragma used-
;// Write a character to the USART1 Transmitter
;#pragma used+
;void putchar1(uint8_t c) {
; 0003 0069 void putchar1(uint8_t c) {
_putchar1:
; 0003 006A 
; 0003 006B     while((UCSR1A & DATA_REGISTER_EMPTY) == 0);
	ST   -Y,R26
;	c -> Y+0
_0x60011:
	LDS  R30,155
	ANDI R30,LOW(0x20)
	BREQ _0x60011
; 0003 006C     UDR1 = c;
	LD   R30,Y
	STS  156,R30
; 0003 006D }
_0x20C0011:
	ADIW R28,1
	RET
;#pragma used-
;#endif
;
;void send_uart(uint8_t port, uint8_t *buffer) {
; 0003 0071 void send_uart(uint8_t port, uint8_t *buffer) {
_send_uart:
; 0003 0072 
; 0003 0073     uint8_t i = 0;
; 0003 0074 
; 0003 0075     switch(port) {
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	port -> Y+3
;	*buffer -> Y+1
;	i -> R17
	LDI  R17,0
	LDD  R30,Y+3
	LDI  R31,0
; 0003 0076         case 0:
	SBIW R30,0
	BRNE _0x60017
; 0003 0077             while(buffer[i] != 0) {
_0x60018:
	CALL SUBOPT_0x23
	LD   R30,X
	CPI  R30,0
	BREQ _0x6001A
; 0003 0078                 putchar0(buffer[i]);
	CALL SUBOPT_0x23
	LD   R26,X
	RCALL _putchar0
; 0003 0079                 i++;
	SUBI R17,-1
; 0003 007A             }
	RJMP _0x60018
_0x6001A:
; 0003 007B             break;
	RJMP _0x60016
; 0003 007C         case 1:
_0x60017:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x60016
; 0003 007D             while(buffer[i] != 0) {
_0x6001C:
	CALL SUBOPT_0x23
	LD   R30,X
	CPI  R30,0
	BREQ _0x6001E
; 0003 007E                 putchar1(buffer[i]);
	CALL SUBOPT_0x23
	LD   R26,X
	RCALL _putchar1
; 0003 007F                 i++;
	SUBI R17,-1
; 0003 0080             }
	RJMP _0x6001C
_0x6001E:
; 0003 0081             break;
; 0003 0082     }
_0x60016:
; 0003 0083 }
	LDD  R17,Y+0
	RJMP _0x20C000F
;
;
;void init_uart(uint8_t channel, uint32_t baud) {
; 0003 0086 void init_uart(uint8_t channel, uint32_t baud) {
_init_uart:
; 0003 0087 
; 0003 0088     switch(channel) {
	CALL __PUTPARD2
;	channel -> Y+4
;	baud -> Y+0
	LDD  R30,Y+4
	LDI  R31,0
; 0003 0089     case 0:
	SBIW R30,0
	BRNE _0x60022
; 0003 008A         // USART0 initialization
; 0003 008B         // FOSC = 11.0592 MHz
; 0003 008C         // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0003 008D         // USART0 Receiver: On
; 0003 008E         // USART0 Transmitter: On
; 0003 008F         // USART0 Mode: Asynchronous
; 0003 0090         // USART0 Baud Rate: 9600
; 0003 0091         UCSR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0003 0092         UCSR0B=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0003 0093         UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
; 0003 0094         UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0003 0095         switch (baud) {
	CALL SUBOPT_0x24
; 0003 0096         case 2400:
	BRNE _0x60026
; 0003 0097             UBRR0L = 0x1F;
	LDI  R30,LOW(31)
	RJMP _0x6003A
; 0003 0098             break;
; 0003 0099         case 9600:
_0x60026:
	CALL SUBOPT_0x25
	BREQ _0x6003B
; 0003 009A             UBRR0L = 0x47;
; 0003 009B             break;
; 0003 009C         case 14400:
	CALL SUBOPT_0x26
	BRNE _0x60028
; 0003 009D             UBRR0L = 0x2F;
	LDI  R30,LOW(47)
	RJMP _0x6003A
; 0003 009E             break;
; 0003 009F         case 19200:
_0x60028:
	CALL SUBOPT_0x27
	BRNE _0x60029
; 0003 00A0             UBRR0L = 0x23;
	LDI  R30,LOW(35)
	RJMP _0x6003A
; 0003 00A1             break;
; 0003 00A2         case 38400:
_0x60029:
	CALL SUBOPT_0x28
	BRNE _0x6002A
; 0003 00A3             UBRR0L = 0x11;
	LDI  R30,LOW(17)
	RJMP _0x6003A
; 0003 00A4             break;
; 0003 00A5         case 57600:
_0x6002A:
	CALL SUBOPT_0x29
	BRNE _0x6002B
; 0003 00A6             UBRR0L = 0x0B;
	LDI  R30,LOW(11)
	RJMP _0x6003A
; 0003 00A7             break;
; 0003 00A8         case 115200:
_0x6002B:
	CALL SUBOPT_0x2A
	BRNE _0x6002D
; 0003 00A9             UBRR0L = 0x05;
	LDI  R30,LOW(5)
	RJMP _0x6003A
; 0003 00AA             break;
; 0003 00AB         default:
_0x6002D:
; 0003 00AC             UBRR0L = 0x47;       // default baudrate is 9600
_0x6003B:
	LDI  R30,LOW(71)
_0x6003A:
	OUT  0x9,R30
; 0003 00AD         }
; 0003 00AE         break;
	RJMP _0x60021
; 0003 00AF     case 1:
_0x60022:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x60021
; 0003 00B0         // USART1 initialization
; 0003 00B1         // FOSC = 11.0592 MHz
; 0003 00B2         // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0003 00B3         // USART1 Receiver: On
; 0003 00B4         // USART1 Transmitter: On
; 0003 00B5         // USART1 Mode: Asynchronous
; 0003 00B6         // USART1 Baud Rate: 9600
; 0003 00B7         UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
; 0003 00B8         UCSR1B=0x98;
	LDI  R30,LOW(152)
	STS  154,R30
; 0003 00B9         UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0003 00BA         UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0003 00BB         switch ( baud ) {
	CALL SUBOPT_0x24
; 0003 00BC         case 2400:
	BRNE _0x60032
; 0003 00BD             UBRR1L = 0x1F;
	LDI  R30,LOW(31)
	RJMP _0x6003C
; 0003 00BE             break;
; 0003 00BF         case 9600:
_0x60032:
	CALL SUBOPT_0x25
	BREQ _0x6003D
; 0003 00C0             UBRR1L = 0x47;
; 0003 00C1             break;
; 0003 00C2         case 14400:
	CALL SUBOPT_0x26
	BRNE _0x60034
; 0003 00C3             UBRR1L = 0x2F;
	LDI  R30,LOW(47)
	RJMP _0x6003C
; 0003 00C4             break;
; 0003 00C5         case 19200:
_0x60034:
	CALL SUBOPT_0x27
	BRNE _0x60035
; 0003 00C6             UBRR1L = 0x23;
	LDI  R30,LOW(35)
	RJMP _0x6003C
; 0003 00C7             break;
; 0003 00C8         case 38400:
_0x60035:
	CALL SUBOPT_0x28
	BRNE _0x60036
; 0003 00C9             UBRR1L = 0x11;
	LDI  R30,LOW(17)
	RJMP _0x6003C
; 0003 00CA             break;
; 0003 00CB         case 57600:
_0x60036:
	CALL SUBOPT_0x29
	BRNE _0x60037
; 0003 00CC             UBRR1L = 0x0B;
	LDI  R30,LOW(11)
	RJMP _0x6003C
; 0003 00CD             break;
; 0003 00CE         case 115200:
_0x60037:
	CALL SUBOPT_0x2A
	BRNE _0x60039
; 0003 00CF             UBRR1L = 0x05;
	LDI  R30,LOW(5)
	RJMP _0x6003C
; 0003 00D0             break;
; 0003 00D1         default:
_0x60039:
; 0003 00D2             UBRR1L = 0x47;       // default baudrate is 9600
_0x6003D:
	LDI  R30,LOW(71)
_0x6003C:
	STS  153,R30
; 0003 00D3         }
; 0003 00D4         break;
; 0003 00D5 
; 0003 00D6     }
_0x60021:
; 0003 00D7 
; 0003 00D8 }
	ADIW R28,5
	RET
;#include <mega128a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include <stdlib.h>
;#include <string.h>
;#include <delay.h>
;#include <uart.h>
;#include <xbee.h>
;#include <queue.h>
;#include <debug.h>
;#include <int_protocol.h>
;#include <eeprom.h>
;
;#define XBEE_RESET PORTE.2
;
;char EndDevice_MacAddress[8];
;char Gateway_MacAddress[8];
;
;uint8_t AI_COMMAND[]            = {0x7E,0x00,0x04,0x08,0x01,0x41,0x49,0x6C};

	.DSEG
;uint8_t SL_COMMAND[]            = {0x7E,0x00,0x04,0x08,0x01,0x53,0x4C,0x57};
;uint8_t SH_COMMAND[]            = {0x7E,0x00,0x04,0x08,0x01,0x53,0x48,0x5B};
;uint8_t EVENT[2]                = {0x00,0x00};
;uint8_t STATUS_DEVICE           = 0;
;int flag_state                  = 0;
;
;
;void xbee_sendATCommand(int param){
; 0004 001A void xbee_sendATCommand(int param){

	.CSEG
_xbee_sendATCommand:
; 0004 001B      switch(param) {
	CALL SUBOPT_0x0
;	param -> Y+0
; 0004 001C         case 0  :
	BRNE _0x80009
; 0004 001D             printDebug("\r\n ++++++++++ Send AI ++++++++\r\n");
	__POINTW1FN _0x80000,0
	CALL SUBOPT_0x8
; 0004 001E             print_payload(AI_COMMAND,8);
	LDI  R30,LOW(_AI_COMMAND)
	LDI  R31,HIGH(_AI_COMMAND)
	CALL SUBOPT_0x2B
; 0004 001F             xbee_send(AI_COMMAND,8);
	LDI  R30,LOW(_AI_COMMAND)
	LDI  R31,HIGH(_AI_COMMAND)
	RJMP _0x80035
; 0004 0020 
; 0004 0021         break;
; 0004 0022 
; 0004 0023         case 1  :
_0x80009:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x8000A
; 0004 0024             printDebug("\r\n ++++++++++ Send SH ++++++++\r\n");
	__POINTW1FN _0x80000,33
	CALL SUBOPT_0x8
; 0004 0025             print_payload(SH_COMMAND,8);
	LDI  R30,LOW(_SH_COMMAND)
	LDI  R31,HIGH(_SH_COMMAND)
	CALL SUBOPT_0x2B
; 0004 0026             xbee_send(SH_COMMAND,8);
	LDI  R30,LOW(_SH_COMMAND)
	LDI  R31,HIGH(_SH_COMMAND)
	RJMP _0x80035
; 0004 0027 
; 0004 0028         break;
; 0004 0029 
; 0004 002A         case 2  :
_0x8000A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x80008
; 0004 002B             printDebug("\r\n ++++++++++ Send SL ++++++++\r\n");
	__POINTW1FN _0x80000,66
	CALL SUBOPT_0x8
; 0004 002C             print_payload(SL_COMMAND,8);
	LDI  R30,LOW(_SL_COMMAND)
	LDI  R31,HIGH(_SL_COMMAND)
	CALL SUBOPT_0x2B
; 0004 002D             xbee_send(SL_COMMAND,8);
	LDI  R30,LOW(_SL_COMMAND)
	LDI  R31,HIGH(_SL_COMMAND)
_0x80035:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2C
	RCALL _xbee_send
; 0004 002E         break;
; 0004 002F      }
_0x80008:
; 0004 0030 }
_0x20C0010:
	ADIW R28,2
	RET
;
;int xbee_checksum(char buf[],int len) {
; 0004 0032 int xbee_checksum(char buf[],int len) {
_xbee_checksum:
; 0004 0033 
; 0004 0034     int i;
; 0004 0035     char sum = 0;
; 0004 0036     for (i = 0; i < len; i++) {
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	buf -> Y+6
;	len -> Y+4
;	i -> R16,R17
;	sum -> R19
	LDI  R19,0
	__GETWRN 16,17,0
_0x8000D:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x8000E
; 0004 0037         sum += buf[i];
	MOVW R30,R16
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ADD  R19,R30
; 0004 0038     }
	__ADDWRN 16,17,1
	RJMP _0x8000D
_0x8000E:
; 0004 0039     return (0xFF - (sum & 0xFF));
	MOV  R30,R19
	LDI  R31,0
	ANDI R31,HIGH(0xFF)
	LDI  R26,LOW(255)
	LDI  R27,HIGH(255)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	CALL __LOADLOCR4
	JMP  _0x20C000C
; 0004 003A }
;
;
;void xbee_sendAPI(uint8_t buff[],uint16_t len){
; 0004 003D void xbee_sendAPI(uint8_t buff[],uint16_t len){
_xbee_sendAPI:
; 0004 003E     xbee_send(buff,len);
	ST   -Y,R27
	ST   -Y,R26
;	buff -> Y+2
;	len -> Y+0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RCALL _xbee_send
; 0004 003F }
_0x20C000F:
	ADIW R28,4
	RET
;
;
;void xbee_receivePacket( uint8_t recvPacket[],uint16_t size){
; 0004 0042 void xbee_receivePacket( uint8_t recvPacket[],uint16_t size){
_xbee_receivePacket:
; 0004 0043 
; 0004 0044     int start = 3;
; 0004 0045     if(size <= 5)
	CALL SUBOPT_0x2D
;	recvPacket -> Y+4
;	size -> Y+2
;	start -> R16,R17
	__GETWRN 16,17,3
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,6
	BRSH _0x8000F
; 0004 0046         return;
	RJMP _0x20C000E
; 0004 0047     printDebug("\r\n ++++++++++ Recreive Data ++++++++\r\n");
_0x8000F:
	__POINTW1FN _0x80000,99
	CALL SUBOPT_0x8
; 0004 0048     print_payload(recvPacket, size);
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL _print_payload
; 0004 0049     xbee_processPacket(&recvPacket[start]);
	CALL SUBOPT_0x2E
	RCALL _xbee_processPacket
; 0004 004A 
; 0004 004B }
	RJMP _0x20C000E
;
;void xbee_processPacket(char *buf) {
; 0004 004D void xbee_processPacket(char *buf) {
_xbee_processPacket:
; 0004 004E       uint8_t frameType;
; 0004 004F       frameType = buf[0];
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*buf -> Y+1
;	frameType -> R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R17,X
; 0004 0050       switch(frameType) {
	MOV  R30,R17
	LDI  R31,0
; 0004 0051 
; 0004 0052         /*=============== Recive AI ===============*/
; 0004 0053         case 0x88  :
	CPI  R30,LOW(0x88)
	LDI  R26,HIGH(0x88)
	CPC  R31,R26
	BRNE _0x80013
; 0004 0054             if(buf[2] == 0x41 && buf[3] == 0x49){
	CALL SUBOPT_0x2F
	CPI  R26,LOW(0x41)
	BRNE _0x80015
	CALL SUBOPT_0x30
	CPI  R26,LOW(0x49)
	BREQ _0x80016
_0x80015:
	RJMP _0x80014
_0x80016:
; 0004 0055                 flag_state = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x80036
; 0004 0056             }
; 0004 0057 
; 0004 0058         /*=============== Recive SH ===============*/
; 0004 0059 
; 0004 005A             else if (buf[2] == 0x53 && buf[3] == 0x48){
_0x80014:
	CALL SUBOPT_0x2F
	CPI  R26,LOW(0x53)
	BRNE _0x80019
	CALL SUBOPT_0x30
	CPI  R26,LOW(0x48)
	BREQ _0x8001A
_0x80019:
	RJMP _0x80018
_0x8001A:
; 0004 005B                 memcpy(EndDevice_MacAddress,&buf[5],4);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x32
; 0004 005C                 flag_state = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x80036
; 0004 005D             }
; 0004 005E 
; 0004 005F         /*=============== Recive SL ===============*/
; 0004 0060 
; 0004 0061             else if( buf[2] == 0x53 && buf[3] == 0x4C){
_0x80018:
	CALL SUBOPT_0x2F
	CPI  R26,LOW(0x53)
	BRNE _0x8001D
	CALL SUBOPT_0x30
	CPI  R26,LOW(0x4C)
	BREQ _0x8001E
_0x8001D:
	RJMP _0x8001C
_0x8001E:
; 0004 0062                 memcpy(&EndDevice_MacAddress[4],&buf[5],4);
	__POINTW1MN _EndDevice_MacAddress,4
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x32
; 0004 0063                 flag_state = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
_0x80036:
	STS  _flag_state,R30
	STS  _flag_state+1,R31
; 0004 0064             }
; 0004 0065 
; 0004 0066         break;
_0x8001C:
	RJMP _0x80012
; 0004 0067 
; 0004 0068         /*=============== Recive ACK ===============*/
; 0004 0069         case 0x90  :
_0x80013:
	CPI  R30,LOW(0x90)
	LDI  R26,HIGH(0x90)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x80012
; 0004 006A 
; 0004 006B         if(buf[32] == 0xA2){
	CALL SUBOPT_0x33
	CPI  R26,LOW(0xA2)
	BRNE _0x80020
; 0004 006C             memcpy(Gateway_MacAddress,&buf[1],8);
	CALL SUBOPT_0x34
	CALL _memcpy
; 0004 006D             //input[count_input] = 2;
; 0004 006E             flag_state = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x16
; 0004 006F         }
; 0004 0070         else if(buf[32] == 0xA3){
	RJMP _0x80021
_0x80020:
	CALL SUBOPT_0x33
	CPI  R26,LOW(0xA3)
	BRNE _0x80022
; 0004 0071             memcpy(Gateway_MacAddress,&buf[1],8);
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0004 0072             input[count_input] = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP _0x80037
; 0004 0073             count_input++;
; 0004 0074         }
; 0004 0075         else if(buf[32] == 0xA5){
_0x80022:
	CALL SUBOPT_0x33
	CPI  R26,LOW(0xA5)
	BRNE _0x80024
; 0004 0076             memcpy(Gateway_MacAddress,&buf[1],8);
	CALL SUBOPT_0x34
	CALL _memcpy
; 0004 0077             if(buf[34] == 0x01)
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,34
	LD   R26,X
	CPI  R26,LOW(0x1)
	BRNE _0x80025
; 0004 0078                 input[count_input] = 511;
	CALL SUBOPT_0x36
	LDI  R30,LOW(511)
	LDI  R31,HIGH(511)
	RJMP _0x80038
; 0004 0079             else if(buf[34] == 0x00)
_0x80025:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R30,Z+34
	CPI  R30,0
	BRNE _0x80027
; 0004 007A                 input[count_input] = 510;
	CALL SUBOPT_0x36
	LDI  R30,LOW(510)
	LDI  R31,HIGH(510)
_0x80038:
	ST   X+,R30
	ST   X,R31
; 0004 007B             count_input++;
_0x80027:
	RJMP _0x80039
; 0004 007C         }
; 0004 007D         else if(buf[32] == 0xA6){
_0x80024:
	CALL SUBOPT_0x33
	CPI  R26,LOW(0xA6)
	BRNE _0x80029
; 0004 007E             EVENT[0] = buf[33];
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R30,Z+33
	STS  _EVENT,R30
; 0004 007F             EVENT[1] = buf[34];
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R30,Z+34
	__PUTB1MN _EVENT,1
; 0004 0080             memcpy(Gateway_MacAddress,&buf[1],8);
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0004 0081             input[count_input] = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RJMP _0x80037
; 0004 0082             count_input++;
; 0004 0083         }
; 0004 0084         else if(buf[32] == 0xA8){
_0x80029:
	CALL SUBOPT_0x33
	CPI  R26,LOW(0xA8)
	BRNE _0x8002B
; 0004 0085             memcpy(Gateway_MacAddress,&buf[1],8);
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
; 0004 0086             input[count_input] = 8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
_0x80037:
	ST   X+,R30
	ST   X,R31
; 0004 0087             count_input++;
_0x80039:
	LDI  R26,LOW(_count_input)
	LDI  R27,HIGH(_count_input)
	CALL SUBOPT_0x21
; 0004 0088         }
; 0004 0089 
; 0004 008A         break;
_0x8002B:
_0x80021:
; 0004 008B       }
_0x80012:
; 0004 008C       if(input[count_input-1] != 0) do_event(input[count_input]);
	LDS  R30,_count_input
	LDS  R31,_count_input+1
	SBIW R30,1
	CALL SUBOPT_0x37
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x8002C
	CALL SUBOPT_0x36
	CALL __GETW1P
	MOVW R26,R30
	CALL _do_event
; 0004 008D       if(count_input == 30)  count_input = 0;
_0x8002C:
	LDS  R26,_count_input
	LDS  R27,_count_input+1
	SBIW R26,30
	BRNE _0x8002D
	LDI  R30,LOW(0)
	STS  _count_input,R30
	STS  _count_input+1,R30
; 0004 008E }
_0x8002D:
	LDD  R17,Y+0
	JMP  _0x20C000A
;
;uint16_t xbee_send(uint8_t buff[],uint16_t len){
; 0004 0090 uint16_t xbee_send(uint8_t buff[],uint16_t len){
_xbee_send:
; 0004 0091     uint16_t i;
; 0004 0092     for(i = 0; i < len; i++) {
	CALL SUBOPT_0x2D
;	buff -> Y+4
;	len -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x8002F:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x80030
; 0004 0093         putchar1(buff[i]);
	CALL SUBOPT_0x2E
	LD   R26,X
	RCALL _putchar1
; 0004 0094     }
	__ADDWRN 16,17,1
	RJMP _0x8002F
_0x80030:
; 0004 0095     return i;
	MOVW R30,R16
_0x20C000E:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
; 0004 0096 }
;
;void xbee_read() {
; 0004 0098 void xbee_read() {
_xbee_read:
; 0004 0099 
; 0004 009A     uint8_t readbuf[256];
; 0004 009B     uint8_t data;
; 0004 009C     uint16_t len = 0;
; 0004 009D     int i = 0;
; 0004 009E     delay_ms(100);
	SUBI R29,1
	CALL __SAVELOCR6
;	readbuf -> Y+6
;	data -> R17
;	len -> R18,R19
;	i -> R20,R21
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	CALL SUBOPT_0xF
; 0004 009F 
; 0004 00A0     while (rx_counter1>0){
_0x80031:
	LDS  R26,_rx_counter1
	LDS  R27,_rx_counter1+1
	CALL __CPW02
	BRSH _0x80033
; 0004 00A1         data=rx_buffer1[rx_rd_index1++];
	LDI  R26,LOW(_rx_rd_index1)
	LDI  R27,HIGH(_rx_rd_index1)
	CALL SUBOPT_0x21
	SBIW R30,1
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	LD   R17,Z
; 0004 00A2         readbuf[i++] = data;
	MOVW R30,R20
	__ADDWRN 20,21,1
	MOVW R26,R28
	ADIW R26,6
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
; 0004 00A3         len++;
	__ADDWRN 18,19,1
; 0004 00A4         #if RX_BUFFER_SIZE1 != 256
; 0004 00A5         if (rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
	LDS  R26,_rx_rd_index1
	LDS  R27,_rx_rd_index1+1
	CPI  R26,LOW(0x200)
	LDI  R30,HIGH(0x200)
	CPC  R27,R30
	BRNE _0x80034
	LDI  R30,LOW(0)
	STS  _rx_rd_index1,R30
	STS  _rx_rd_index1+1,R30
; 0004 00A6         #endif
; 0004 00A7         #asm("cli")
_0x80034:
	cli
; 0004 00A8         --rx_counter1;
	LDI  R26,LOW(_rx_counter1)
	LDI  R27,HIGH(_rx_counter1)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0004 00A9         #asm("sei")
	sei
; 0004 00AA     }
	RJMP _0x80031
_0x80033:
; 0004 00AB 
; 0004 00AC     xbee_receivePacket(readbuf, len);
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R18
	RCALL _xbee_receivePacket
; 0004 00AD }
	CALL __LOADLOCR6
	ADIW R28,6
	SUBI R29,-1
	RET
;#include <mega128a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include <stdlib.h>
;#include <delay.h>
;#include <io.h>
;#include <initial_system.h>
;#include <uart.h>
;#include <debug.h>
;#include <xbee.h>
;#include <timer.h>
;#include <int_protocol.h>
;#include <adc.h>
;
;/* ================================================================================= */
;int initial_system(void) {
; 0005 000F int initial_system(void) {

	.CSEG
_initial_system:
; 0005 0010 
; 0005 0011     init_IO();
	RCALL _init_IO
; 0005 0012 
; 0005 0013     //============ Uart Initial ============//
; 0005 0014     init_uart(0, 38400);     // uart0 for printDebug
	LDI  R30,LOW(0)
	CALL SUBOPT_0x38
; 0005 0015     init_uart(1, 38400);    // uart1 for xbee
	LDI  R30,LOW(1)
	CALL SUBOPT_0x38
; 0005 0016 
; 0005 0017     //============ Timer Initial ============//
; 0005 0018     init_timer();
	CALL _init_timer
; 0005 0019     enable_timerOverflow(0);      // interrupt every 0.021 sec.
	CALL SUBOPT_0xD
	CALL _enable_timerOverflow
; 0005 001A     enable_timerOverflow(1);      // interrupt every 1 sec.
	CALL SUBOPT_0x10
	CALL _enable_timerOverflow
; 0005 001B     enable_timerOverflow(3);      // interrupt every 0.5 sec.
	LDI  R26,LOW(3)
	LDI  R27,0
	CALL _enable_timerOverflow
; 0005 001C 
; 0005 001D     //============ Module Initial ============//
; 0005 001E     init_adc(VREF_AVCC);
	LDI  R26,LOW(64)
	CALL _init_adc
; 0005 001F 
; 0005 0020     return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET
; 0005 0021 }
;
;/* ================================================================================= */
;void init_IO(void) {
; 0005 0024 void init_IO(void) {
_init_IO:
; 0005 0025 
; 0005 0026     /*----- Digital Input -----*/
; 0005 0027     // Initial Direction
; 0005 0028     SW_BUTTON_DDR;           // Switch Button, Join Button
	CBI  0x14,0
; 0005 0029     // pull up
; 0005 002A     SW_BUTTON_PORT = 1;
	SBI  0x15,0
; 0005 002B 
; 0005 002C     D_SW1_DDR;
	CBI  0x1A,7
; 0005 002D     D_SW2_DDR;
	CBI  0x1A,6
; 0005 002E     D_SW3_DDR;
	CBI  0x1A,5
; 0005 002F     D_SW4_DDR;
	CBI  0x1A,4
; 0005 0030 
; 0005 0031     /*----- Digital Output -----*/
; 0005 0032     // Initial Direction
; 0005 0033     LED_STAT_DDR;                   // LED Status
	SBI  0x14,7
; 0005 0034     POWER_RELAY_DDR;                // Drive relay
	LDS  R30,100
	ORI  R30,4
	STS  100,R30
; 0005 0035     XBEE_RESET_DDR;
	SBI  0x2,2
; 0005 0036     XBEE_SLEEP_DDR;
	LDS  R30,100
	ORI  R30,8
	STS  100,R30
; 0005 0037 
; 0005 0038     LED_STAT_OFF;
	SBI  0x15,7
; 0005 0039     POWER_RELAY_OFF;
	CALL SUBOPT_0x1
; 0005 003A     XBEE_RESET_HIGH;      // XBee Reset active low
	SBI  0x3,2
; 0005 003B     XBEE_SLEEP_LOW;
	LDS  R30,101
	ANDI R30,0XF7
	STS  101,R30
; 0005 003C 
; 0005 003D }
	RET
;/* ================================================================================= */
;int8_t read_dSwitch() {
; 0005 003F int8_t read_dSwitch() {
_read_dSwitch:
; 0005 0040     int8_t read1, read2;
; 0005 0041     read1 = D_SW1_PIN | (D_SW2_PIN<<1) | (D_SW3_PIN<<2) | (D_SW4_PIN<<3);
	ST   -Y,R17
	ST   -Y,R16
;	read1 -> R17
;	read2 -> R16
	CALL SUBOPT_0x39
	MOV  R17,R30
; 0005 0042     delay_ms(100);
	CALL SUBOPT_0xF
; 0005 0043     read2 = D_SW1_PIN | (D_SW2_PIN<<1) | (D_SW3_PIN<<2) | (D_SW4_PIN<<3);
	CALL SUBOPT_0x39
	MOV  R16,R30
; 0005 0044     if(read1 == read2) {
	CP   R16,R17
	BRNE _0xA0017
; 0005 0045         return read1;
	MOV  R30,R17
	RJMP _0x20C000D
; 0005 0046     }else {
_0xA0017:
; 0005 0047         return -1;
	LDI  R30,LOW(255)
; 0005 0048     }
; 0005 0049 }
_0x20C000D:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;#include <mega128a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdint.h>
;#include <stdio.h>
;#include <stdlib.h>
;#include <string.h>
;#include <delay.h>
;#include <math.h>
;#include <uart.h>
;#include <debug.h>
;#include <xbee.h>
;#include <meansure.h>
;
;uint8_t JOIN_A1[]           = {0x7E,0x00,0x23,0x10,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xFF,0xFE,0x00,0x00,0x30,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x7E,0x00,0x01,0xA1,0x00};

	.DSEG
;uint8_t PING_A4[]           = {0x7E,0x00,0x23,0x10,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xFF,0xFE,0x00,0x00,0x30,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x7E,0x00,0x01,0xA4,0x00};
;uint8_t SEND_EVENT_[]       = {0x7E,0x00,0x25,0x10,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xFF,0xFE,0x00,0x00,0x30,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x7E,0x00,0x01,0xA5,0x01,0x00,0x00};
;uint8_t SEND_REPORT_[]      = {0x7E,0x00,0x48,0x10,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xFF,0xFE,0x00,0x00,0x30,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x7E,0x00,0x26,0xA7,0x01,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x03,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x04,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
;uint8_t _voltage[8]         = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
;uint8_t _amp[8]             = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
;uint8_t _power[8]           = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
;uint8_t _watt[8]            = {0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
;
;void reverse(char *str, int len){
; 0006 0016 void reverse(char *str, int len){

	.CSEG
_reverse:
; 0006 0017     int i=0,j=len-1,temp;
; 0006 0018 
; 0006 0019     while (i<j){
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR6
;	*str -> Y+8
;	len -> Y+6
;	i -> R16,R17
;	j -> R18,R19
;	temp -> R20,R21
	__GETWRN 16,17,0
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,1
	MOVW R18,R30
_0xC0007:
	__CPWRR 16,17,18,19
	BRGE _0xC0009
; 0006 001A         temp = str[i];
	MOVW R30,R16
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R20,X
	CLR  R21
; 0006 001B         str[i] = str[j];
	CALL SUBOPT_0x1C
	MOVW R0,R30
	MOVW R30,R18
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0006 001C         str[j] = temp;
	MOVW R30,R18
	CALL SUBOPT_0x1C
	ST   Z,R20
; 0006 001D         i++; j--;
	__ADDWRN 16,17,1
	__SUBWRN 18,19,1
; 0006 001E     }
	RJMP _0xC0007
_0xC0009:
; 0006 001F }
	CALL __LOADLOCR6
	ADIW R28,10
	RET
;
;// Converts a given integer x to string str[]. d is the number
;// of digits required in output. If d is more than the number
;// of digits in x, then 0s are added at the beginning.
;
;int intToStr(int x, char str[], int d){
; 0006 0025 int intToStr(int x, char str[], int d){
_intToStr:
; 0006 0026     int i = 0;
; 0006 0027     while (x){
	CALL SUBOPT_0x2D
;	x -> Y+6
;	str -> Y+4
;	d -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0xC000A:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,0
	BREQ _0xC000C
; 0006 0028         str[i++] = (x%10) + '0';
	MOVW R30,R16
	__ADDWRN 16,17,1
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
; 0006 0029         x = x/10;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0006 002A     }
	RJMP _0xC000A
_0xC000C:
; 0006 002B 
; 0006 002C     // If number of digits required is more, then
; 0006 002D     // add 0s at the beginning
; 0006 002E     while (i < d)
_0xC000D:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0xC000F
; 0006 002F         str[i++] = '0';
	MOVW R30,R16
	__ADDWRN 16,17,1
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0xC000D
_0xC000F:
; 0006 0031 reverse(str, i);
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	RCALL _reverse
; 0006 0032     str[i] = '\0';
	CALL SUBOPT_0x2E
	LDI  R30,LOW(0)
	ST   X,R30
; 0006 0033     return i;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20C000C:
	ADIW R28,8
	RET
; 0006 0034 }
;
;void _ftoa(float n, char *res, int afterpoint){
; 0006 0036 void _ftoa(float n, char *res, int afterpoint){
__ftoa:
; 0006 0037     // Extract integer part
; 0006 0038     int ipart = (int)n;
; 0006 0039 
; 0006 003A     // Extract floating part
; 0006 003B     float fpart = n - (float)ipart;
; 0006 003C 
; 0006 003D     // convert integer part to string
; 0006 003E     int i = intToStr(ipart, res, 0);
; 0006 003F     if(ipart == 0){
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR4
;	n -> Y+12
;	*res -> Y+10
;	afterpoint -> Y+8
;	ipart -> R16,R17
;	fpart -> Y+4
;	i -> R18,R19
	CALL SUBOPT_0x3A
	CALL __CFD1
	MOVW R16,R30
	MOVW R30,R16
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3E
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xD
	RCALL _intToStr
	MOVW R18,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0xC0010
; 0006 0040        res[i] = '0';
	MOVW R30,R18
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(48)
	ST   X,R30
; 0006 0041        i++;
	__ADDWRN 18,19,1
; 0006 0042     }
; 0006 0043     // check for display option after point
; 0006 0044     if (afterpoint != 0){
_0xC0010:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BREQ _0xC0011
; 0006 0045         res[i] = '.'; // add dot
	MOVW R30,R18
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(46)
	ST   X,R30
; 0006 0046 
; 0006 0047         // Get the value of fraction part upto given no.
; 0006 0048         // of points after dot. The third parameter is needed
; 0006 0049         // to handle cases like 233.007
; 0006 004A         fpart = fpart * pow(10, afterpoint);
	CALL SUBOPT_0x3F
	CALL __PUTPARD1
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CALL SUBOPT_0x3B
	MOVW R26,R30
	MOVW R24,R22
	CALL _pow
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
; 0006 004B 
; 0006 004C         intToStr((int)fpart, res + i + 1, afterpoint);
	CALL SUBOPT_0x42
	CALL __CFD1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R18
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL _intToStr
; 0006 004D     }
; 0006 004E }
_0xC0011:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
;
;
;void send_event(uint8_t led,uint8_t state){
; 0006 0051 void send_event(uint8_t led,uint8_t state){
_send_event:
; 0006 0052 
; 0006 0053     memcpy(&SEND_EVENT_[5],Gateway_MacAddress,8);
	CALL SUBOPT_0x43
;	led -> Y+1
;	state -> Y+0
	CALL SUBOPT_0x44
; 0006 0054     memcpy(&SEND_EVENT_[18],EndDevice_MacAddress,8);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x45
; 0006 0055     memcpy(&SEND_EVENT_[26],Gateway_MacAddress,8);
	CALL SUBOPT_0x46
; 0006 0056     memcpy(&SEND_EVENT_[39],&state,1);
	CALL SUBOPT_0x10
	CALL _memcpy
; 0006 0057     SEND_EVENT_[37] = 0xA5;
	LDI  R30,LOW(165)
	CALL SUBOPT_0x47
; 0006 0058     SEND_EVENT_[38] = led;
; 0006 0059     SEND_EVENT_[40] = xbee_checksum(&SEND_EVENT_[3],SEND_EVENT_[2]);
; 0006 005A     printDebug("\r\n ++++++++++ Send LED ++++++++\r\n");
	__POINTW1FN _0xC0000,0
	CALL SUBOPT_0x8
; 0006 005B     print_payload(SEND_EVENT_,41);
	CALL SUBOPT_0x48
	CALL _print_payload
; 0006 005C     xbee_sendAPI(SEND_EVENT_,41);
	CALL SUBOPT_0x48
	CALL _xbee_sendAPI
; 0006 005D 
; 0006 005E }
	JMP  _0x20C0008
;
;void send_join(){
; 0006 0060 void send_join(){
_send_join:
; 0006 0061 
; 0006 0062     memcpy(&JOIN_A1[18],EndDevice_MacAddress,8);
	__POINTW1MN _JOIN_A1,18
	CALL SUBOPT_0x49
	CALL SUBOPT_0x2C
	CALL _memcpy
; 0006 0063     JOIN_A1[38] = xbee_checksum(&JOIN_A1[3],JOIN_A1[2]);
	__POINTW1MN _JOIN_A1,3
	ST   -Y,R31
	ST   -Y,R30
	__GETB2MN _JOIN_A1,2
	CALL SUBOPT_0x4A
	__PUTB1MN _JOIN_A1,38
; 0006 0064     printDebug("\r\n ++++++++++ Send Join ++++++++\r\n");
	__POINTW1FN _0xC0000,34
	CALL SUBOPT_0x8
; 0006 0065     print_payload(JOIN_A1, 39);
	LDI  R30,LOW(_JOIN_A1)
	LDI  R31,HIGH(_JOIN_A1)
	CALL SUBOPT_0x4B
; 0006 0066     xbee_sendAPI(JOIN_A1,39);
	LDI  R30,LOW(_JOIN_A1)
	LDI  R31,HIGH(_JOIN_A1)
	RJMP _0x20C000B
; 0006 0067 
; 0006 0068 }
;
;void send_ping(){
; 0006 006A void send_ping(){
_send_ping:
; 0006 006B 
; 0006 006C     memcpy(&PING_A4[5],Gateway_MacAddress,8);
	__POINTW1MN _PING_A4,5
	CALL SUBOPT_0x4C
	CALL _memcpy
; 0006 006D     memcpy(&PING_A4[18],EndDevice_MacAddress,8);
	__POINTW1MN _PING_A4,18
	CALL SUBOPT_0x49
	CALL SUBOPT_0x2C
	CALL _memcpy
; 0006 006E     memcpy(&PING_A4[26],Gateway_MacAddress,8);
	__POINTW1MN _PING_A4,26
	CALL SUBOPT_0x4C
	CALL _memcpy
; 0006 006F     PING_A4[38] = xbee_checksum(&PING_A4[3],PING_A4[2]);
	__POINTW1MN _PING_A4,3
	ST   -Y,R31
	ST   -Y,R30
	__GETB2MN _PING_A4,2
	CALL SUBOPT_0x4A
	__PUTB1MN _PING_A4,38
; 0006 0070     printDebug("\r\n ++++++++++ Send Ping ++++++++\r\n");
	__POINTW1FN _0xC0000,69
	CALL SUBOPT_0x8
; 0006 0071     print_payload(PING_A4, 39);
	LDI  R30,LOW(_PING_A4)
	LDI  R31,HIGH(_PING_A4)
	CALL SUBOPT_0x4B
; 0006 0072     xbee_sendAPI(PING_A4,39);
	LDI  R30,LOW(_PING_A4)
	LDI  R31,HIGH(_PING_A4)
_0x20C000B:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(39)
	LDI  R27,0
	CALL _xbee_sendAPI
; 0006 0073 
; 0006 0074 }
	RET
;
;void recive_event(uint8_t led,uint8_t state){
; 0006 0076 void recive_event(uint8_t led,uint8_t state){
_recive_event:
; 0006 0077 
; 0006 0078     memcpy(&SEND_EVENT_[5],Gateway_MacAddress,8);
	CALL SUBOPT_0x43
;	led -> Y+1
;	state -> Y+0
	CALL SUBOPT_0x44
; 0006 0079     memcpy(&SEND_EVENT_[18],EndDevice_MacAddress,8);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x45
; 0006 007A     memcpy(&SEND_EVENT_[26],Gateway_MacAddress,8);
	CALL SUBOPT_0x46
; 0006 007B     memcpy(&SEND_EVENT_[39],&state,1);
	CALL SUBOPT_0x10
	CALL _memcpy
; 0006 007C     SEND_EVENT_[37] = 0xA6;
	LDI  R30,LOW(166)
	CALL SUBOPT_0x47
; 0006 007D     SEND_EVENT_[38] = led;
; 0006 007E     SEND_EVENT_[40] = xbee_checksum(&SEND_EVENT_[3],SEND_EVENT_[2]);
; 0006 007F     printDebug("\r\n ++++++++++ Send EVENT RECIVE ++++++++\r\n");
	__POINTW1FN _0xC0000,104
	CALL SUBOPT_0x8
; 0006 0080     print_payload(SEND_EVENT_,41);
	CALL SUBOPT_0x48
	CALL _print_payload
; 0006 0081     xbee_sendAPI(SEND_EVENT_,41);
	CALL SUBOPT_0x48
	CALL _xbee_sendAPI
; 0006 0082 
; 0006 0083 }
	JMP  _0x20C0008
;
;void send_report(uint8_t data_id,float Vavg,float Iavg,float Pavg,float WHsum){
; 0006 0085 void send_report(uint8_t data_id,float Vavg,float Iavg,float Pavg,float WHsum){
_send_report:
; 0006 0086 
; 0006 0087     memcpy(&SEND_REPORT_[5],Gateway_MacAddress,8);
	CALL __PUTPARD2
;	data_id -> Y+16
;	Vavg -> Y+12
;	Iavg -> Y+8
;	Pavg -> Y+4
;	WHsum -> Y+0
	__POINTW1MN _SEND_REPORT_,5
	CALL SUBOPT_0x4C
	CALL _memcpy
; 0006 0088     memcpy(&SEND_REPORT_[18],EndDevice_MacAddress,8);
	__POINTW1MN _SEND_REPORT_,18
	CALL SUBOPT_0x49
	CALL SUBOPT_0x2C
	CALL _memcpy
; 0006 0089     memcpy(&SEND_REPORT_[26],Gateway_MacAddress,8);
	__POINTW1MN _SEND_REPORT_,26
	CALL SUBOPT_0x4C
	CALL _memcpy
; 0006 008A 
; 0006 008B     /*=============== Convert Data from float to ASCII ===============*/
; 0006 008C     _ftoa(Vavg, _voltage,2);
	CALL SUBOPT_0x3A
	CALL __PUTPARD1
	LDI  R30,LOW(__voltage)
	LDI  R31,HIGH(__voltage)
	CALL SUBOPT_0x4D
	RCALL __ftoa
; 0006 008D     _ftoa(Iavg, _amp,2);
	CALL SUBOPT_0x4E
	CALL __PUTPARD1
	LDI  R30,LOW(__amp)
	LDI  R31,HIGH(__amp)
	CALL SUBOPT_0x4D
	RCALL __ftoa
; 0006 008E     _ftoa(Pavg, _power,2);
	CALL SUBOPT_0x42
	CALL __PUTPARD1
	LDI  R30,LOW(__power)
	LDI  R31,HIGH(__power)
	CALL SUBOPT_0x4D
	RCALL __ftoa
; 0006 008F     _ftoa(WHsum, _watt,2);
	CALL SUBOPT_0x4F
	CALL __PUTPARD1
	LDI  R30,LOW(__watt)
	LDI  R31,HIGH(__watt)
	CALL SUBOPT_0x4D
	RCALL __ftoa
; 0006 0090 
; 0006 0091     SEND_REPORT_[37] = 0xA7;
	LDI  R30,LOW(167)
	__PUTB1MN _SEND_REPORT_,37
; 0006 0092     SEND_REPORT_[38] = data_id;
	LDD  R30,Y+16
	__PUTB1MN _SEND_REPORT_,38
; 0006 0093     memcpy(&SEND_REPORT_[40],_voltage,8);
	__POINTW1MN _SEND_REPORT_,40
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(__voltage)
	LDI  R31,HIGH(__voltage)
	CALL SUBOPT_0x50
	CALL _memcpy
; 0006 0094     memcpy(&SEND_REPORT_[49],_amp,8);
	__POINTW1MN _SEND_REPORT_,49
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(__amp)
	LDI  R31,HIGH(__amp)
	CALL SUBOPT_0x50
	CALL _memcpy
; 0006 0095     memcpy(&SEND_REPORT_[58],_power,8);
	__POINTW1MN _SEND_REPORT_,58
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(__power)
	LDI  R31,HIGH(__power)
	CALL SUBOPT_0x50
	CALL _memcpy
; 0006 0096     memcpy(&SEND_REPORT_[67],_watt,8);
	__POINTW1MN _SEND_REPORT_,67
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(__watt)
	LDI  R31,HIGH(__watt)
	CALL SUBOPT_0x50
	CALL _memcpy
; 0006 0097 
; 0006 0098     SEND_REPORT_[75] = xbee_checksum(&SEND_REPORT_[3],SEND_REPORT_[2]);
	__POINTW1MN _SEND_REPORT_,3
	ST   -Y,R31
	ST   -Y,R30
	__GETB2MN _SEND_REPORT_,2
	CALL SUBOPT_0x4A
	__PUTB1MN _SEND_REPORT_,75
; 0006 0099     printDebug("\r\n ++++++++++ Send REPORT ++++++++\r\n");
	__POINTW1FN _0xC0000,147
	CALL SUBOPT_0x8
; 0006 009A     print_payload(SEND_REPORT_,76);
	CALL SUBOPT_0x51
	CALL _print_payload
; 0006 009B     xbee_sendAPI(SEND_REPORT_,76);
	CALL SUBOPT_0x51
	CALL _xbee_sendAPI
; 0006 009C 
; 0006 009D }
	ADIW R28,17
	RET
;
;void SendStatusReport(void){
; 0006 009F void SendStatusReport(void){
_SendStatusReport:
; 0006 00A0 
; 0006 00A1     Vavg = Vsum/number;      // Voltage
	CALL SUBOPT_0x52
	CALL SUBOPT_0x53
	CALL SUBOPT_0x54
	STS  _Vavg,R30
	STS  _Vavg+1,R31
	STS  _Vavg+2,R22
	STS  _Vavg+3,R23
; 0006 00A2     Iavg = Isum/number;      // Current
	CALL SUBOPT_0x52
	CALL SUBOPT_0x55
	CALL SUBOPT_0x54
	CALL SUBOPT_0x56
; 0006 00A3     Pavg = Psum/number;      // Power
	CALL SUBOPT_0x52
	CALL SUBOPT_0x57
	CALL SUBOPT_0x54
	STS  _Pavg,R30
	STS  _Pavg+1,R31
	STS  _Pavg+2,R22
	STS  _Pavg+3,R23
; 0006 00A4 
; 0006 00A5     CURRENT_VOLT = Vavg;
	CALL SUBOPT_0x58
	STS  _CURRENT_VOLT,R30
	STS  _CURRENT_VOLT+1,R31
	STS  _CURRENT_VOLT+2,R22
	STS  _CURRENT_VOLT+3,R23
; 0006 00A6     CURRENT_AMP = Iavg;
	CALL SUBOPT_0x59
	STS  _CURRENT_AMP,R30
	STS  _CURRENT_AMP+1,R31
	STS  _CURRENT_AMP+2,R22
	STS  _CURRENT_AMP+3,R23
; 0006 00A7 
; 0006 00A8     printDebug("\r\n======================================================\r\n");
	__POINTW1FN _0xC0000,184
	CALL SUBOPT_0x8
; 0006 00A9     printDebug("Vsum = %0.4f  ", Vsum); printDebug("Isum = %0.4f  ", Isum); printDebug("Psum = %0.4f\r\n", Psum);
	__POINTW1FN _0xC0000,243
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Vsum
	LDS  R31,_Vsum+1
	LDS  R22,_Vsum+2
	LDS  R23,_Vsum+3
	CALL SUBOPT_0xA
	__POINTW1FN _0xC0000,258
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Isum
	LDS  R31,_Isum+1
	LDS  R22,_Isum+2
	LDS  R23,_Isum+3
	CALL SUBOPT_0xA
	__POINTW1FN _0xC0000,273
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_Psum
	LDS  R31,_Psum+1
	LDS  R22,_Psum+2
	LDS  R23,_Psum+3
	CALL SUBOPT_0xA
; 0006 00AA     printDebug("Vavg = %0.4f   ", Vavg); printDebug("Iavg = %0.4f   ", Iavg); printDebug("Pavg = %0.4f\r\n", Pavg);
	__POINTW1FN _0xC0000,288
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x58
	CALL SUBOPT_0xA
	__POINTW1FN _0xC0000,304
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x59
	CALL SUBOPT_0xA
	__POINTW1FN _0xC0000,320
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x5A
	CALL SUBOPT_0xA
; 0006 00AB     printDebug("Watt-Hour Sum = %0.4f\r\n", WHsum);
	__POINTW1FN _0xC0000,335
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_WHsum
	LDS  R31,_WHsum+1
	LDS  R22,_WHsum+2
	LDS  R23,_WHsum+3
	CALL SUBOPT_0xA
; 0006 00AC     printDebug("Number Sampling = %d\r\n", number);
	__POINTW1FN _0xC0000,359
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x52
	CALL SUBOPT_0x22
; 0006 00AD     printDebug("======================================================\r\n\r\n");
	__POINTW1FN _0xC0000,382
	CALL SUBOPT_0x8
; 0006 00AE 
; 0006 00AF     Iavg *= 1000.0;
	CALL SUBOPT_0x5B
	CALL __MULF12
	CALL SUBOPT_0x56
; 0006 00B0     send_report(01,Vavg,Iavg,Pavg,WHsum);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL SUBOPT_0x58
	CALL __PUTPARD1
	CALL SUBOPT_0x59
	CALL __PUTPARD1
	CALL SUBOPT_0x5A
	CALL __PUTPARD1
	CALL SUBOPT_0x5C
	RCALL _send_report
; 0006 00B1     Iavg /= 1000.0;
	CALL SUBOPT_0x5B
	CALL __DIVF21
	CALL SUBOPT_0x56
; 0006 00B2     /* Safety Current Sensor */
; 0006 00B3     if((SENSOR_SENSITIVE == SENSOR5A) && (Iavg > 4.9)) {
	CALL SUBOPT_0x5D
	__CPD2N 0x43390000
	BRNE _0xC0013
	CALL SUBOPT_0x5E
	__GETD1N 0x409CCCCD
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xC0013
	RJMP _0xC0014
_0xC0013:
	RJMP _0xC0012
_0xC0014:
; 0006 00B4         SWITCH = TURN_OFF;
	RJMP _0xC0023
; 0006 00B5         POWER_RELAY_OFF;
; 0006 00B6         LED_STAT_OFF;
; 0006 00B7         CURRENT_VOLT = 0.0;
; 0006 00B8         CURRENT_AMP = 0.0;
; 0006 00B9         printDebug("Current Exceed --SWITCH OFF!\r\n");
; 0006 00BA     }else if((SENSOR_SENSITIVE == SENSOR20A) && (Iavg > 19.9)) {
_0xC0012:
	CALL SUBOPT_0x5D
	__CPD2N 0x42C80000
	BRNE _0xC0019
	CALL SUBOPT_0x5E
	__GETD1N 0x419F3333
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xC0019
	RJMP _0xC001A
_0xC0019:
	RJMP _0xC0018
_0xC001A:
; 0006 00BB         SWITCH = TURN_OFF;
	RJMP _0xC0023
; 0006 00BC         POWER_RELAY_OFF;
; 0006 00BD         LED_STAT_OFF;
; 0006 00BE         CURRENT_VOLT = 0.0;
; 0006 00BF         CURRENT_AMP = 0.0;
; 0006 00C0         printDebug("Current Exceed --SWITCH OFF!\r\n");
; 0006 00C1     }else if((SENSOR_SENSITIVE == SENSOR30A) && (Iavg > 29.9)) {
_0xC0018:
	CALL SUBOPT_0x5D
	__CPD2N 0x42840000
	BRNE _0xC001F
	CALL SUBOPT_0x5E
	__GETD1N 0x41EF3333
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0xC001F
	RJMP _0xC0020
_0xC001F:
	RJMP _0xC001E
_0xC0020:
; 0006 00C2         SWITCH = TURN_OFF;
_0xC0023:
	LDI  R30,LOW(0)
	STS  _SWITCH,R30
; 0006 00C3         POWER_RELAY_OFF;
	CALL SUBOPT_0x1
; 0006 00C4         LED_STAT_OFF;
	SBI  0x15,7
; 0006 00C5         CURRENT_VOLT = 0.0;
	LDI  R30,LOW(0)
	STS  _CURRENT_VOLT,R30
	STS  _CURRENT_VOLT+1,R30
	STS  _CURRENT_VOLT+2,R30
	STS  _CURRENT_VOLT+3,R30
; 0006 00C6         CURRENT_AMP = 0.0;
	STS  _CURRENT_AMP,R30
	STS  _CURRENT_AMP+1,R30
	STS  _CURRENT_AMP+2,R30
	STS  _CURRENT_AMP+3,R30
; 0006 00C7         printDebug("Current Exceed --SWITCH OFF!\r\n");
	__POINTW1FN _0xC0000,441
	CALL SUBOPT_0x8
; 0006 00C8     }
; 0006 00C9 
; 0006 00CA     /* Reset value */
; 0006 00CB     number = 0;
_0xC001E:
	LDI  R30,LOW(0)
	STS  _number,R30
	STS  _number+1,R30
; 0006 00CC     Vsum = 0.0;
	STS  _Vsum,R30
	STS  _Vsum+1,R30
	STS  _Vsum+2,R30
	STS  _Vsum+3,R30
; 0006 00CD     Isum = 0.0;
	STS  _Isum,R30
	STS  _Isum+1,R30
	STS  _Isum+2,R30
	STS  _Isum+3,R30
; 0006 00CE     Psum = 0.0;
	STS  _Psum,R30
	STS  _Psum+1,R30
	STS  _Psum+2,R30
	STS  _Psum+3,R30
; 0006 00CF     WHsum = 0.0;
	STS  _WHsum,R30
	STS  _WHsum+1,R30
	STS  _WHsum+2,R30
	STS  _WHsum+3,R30
; 0006 00D0 
; 0006 00D1 }
	RET
;#include <mega128a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include <stdint.h>
;#include <delay.h>
;#include <string.h>
;#include <adc.h>
;#include <debug.h>
;
;char Vreferent = VREF_AVCC;

	.DSEG
;
;
;void init_adc(unsigned char vrff) {
; 0007 000C void init_adc(unsigned char vrff) {

	.CSEG
_init_adc:
; 0007 000D 
; 0007 000E     // ADC initialization
; 0007 000F     // ADC Clock frequency: 691.200 kHz
; 0007 0010     // ADC Voltage Reference: vrff
; 0007 0011     Vreferent = vrff;
	ST   -Y,R26
;	vrff -> Y+0
	LD   R30,Y
	STS  _Vreferent,R30
; 0007 0012     ADMUX = Vreferent & 0xff;
	OUT  0x7,R30
; 0007 0013     ADCSRA = 0xA4;
	LDI  R30,LOW(164)
	OUT  0x6,R30
; 0007 0014     //printDebug("ADMUX = %02X\r\n", ADMUX);
; 0007 0015 
; 0007 0016 }
	ADIW R28,1
	RET
;
;// Read the AD conversion result
;uint16_t read_adc(unsigned char adc_input) {
; 0007 0019 uint16_t read_adc(unsigned char adc_input) {
_read_adc:
; 0007 001A 
; 0007 001B     unsigned int adc_data = 0x0000;
; 0007 001C 
; 0007 001D     ADMUX = (Vreferent | adc_input);
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	adc_input -> Y+2
;	adc_data -> R16,R17
	__GETWRN 16,17,0
	LDD  R30,Y+2
	LDS  R26,_Vreferent
	OR   R30,R26
	OUT  0x7,R30
; 0007 001E     //printDebug("ADMUX = %02X\r\n", ADMUX);
; 0007 001F 
; 0007 0020     // Delay needed for the stabilization of the ADC input voltage
; 0007 0021     delay_us(50);
	__DELAY_USB 184
; 0007 0022 
; 0007 0023     // Start the AD conversion
; 0007 0024     ADCSRA |= 0x80; // ENABLE ADC
	SBI  0x6,7
; 0007 0025     ADCSRA |= 0x40;  // Start convert
	SBI  0x6,6
; 0007 0026 
; 0007 0027     // Wait for the AD conversion to complete
; 0007 0028     while((ADCSRA & 0x10) == 0);
_0xE0004:
	SBIS 0x6,4
	RJMP _0xE0004
; 0007 0029     adc_data = ADCL;
	IN   R16,4
	CLR  R17
; 0007 002A     adc_data |= (ADCH & 0x00ff) << 8;
	IN   R30,0x5
	MOV  R31,R30
	LDI  R30,0
	__ORWRR 16,17,30,31
; 0007 002B 
; 0007 002C     ADCSRA |= 0x10;
	SBI  0x6,4
; 0007 002D 
; 0007 002E     return adc_data;
	MOVW R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20C000A
; 0007 002F }
;
;
;
;
;#include <mega128a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include <stdint.h>
;#include <delay.h>
;#include <string.h>
;#include <uart.h>
;#include <int_protocol.h>
;#include <debug.h>
;
;uint8_t Eaddress        = 5;

	.DSEG
;
;void EEPROM_write(unsigned int uiAddress, unsigned char ucData){
; 0008 000C void EEPROM_write(unsigned int uiAddress, unsigned char ucData){

	.CSEG
_EEPROM_write:
; 0008 000D     while(EECR & (1<<EEWE))
	ST   -Y,R26
;	uiAddress -> Y+1
;	ucData -> Y+0
_0x100004:
	SBIC 0x1C,1
; 0008 000E     ;
	RJMP _0x100004
; 0008 000F     EEAR = uiAddress;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	OUT  0x1E+1,R31
	OUT  0x1E,R30
; 0008 0010     EEDR = ucData;
	LD   R30,Y
	OUT  0x1D,R30
; 0008 0011     EECR |= (1<<EEMWE);
	SBI  0x1C,2
; 0008 0012     EECR |= (1<<EEWE);
	SBI  0x1C,1
; 0008 0013 }
_0x20C000A:
	ADIW R28,3
	RET
;
;
;unsigned char EEPROM_read(unsigned int uiAddress){
; 0008 0016 unsigned char EEPROM_read(unsigned int uiAddress){
_EEPROM_read:
; 0008 0017     while(EECR & (1<<EEWE))
	ST   -Y,R27
	ST   -Y,R26
;	uiAddress -> Y+0
_0x100007:
	SBIC 0x1C,1
; 0008 0018     ;
	RJMP _0x100007
; 0008 0019     EEAR = uiAddress;
	LD   R30,Y
	LDD  R31,Y+1
	OUT  0x1E+1,R31
	OUT  0x1E,R30
; 0008 001A     EECR |= (1<<EERE);
	SBI  0x1C,0
; 0008 001B     return EEDR;
	IN   R30,0x1D
	JMP  _0x20C0008
; 0008 001C }
;
;
;#include <mega128a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdio.h>
;#include <stdint.h>
;#include <delay.h>
;#include <string.h>
;#include <uart.h>
;#include <int_protocol.h>
;#include <debug.h>
;#include <adc.h>
;#include <math.h>
;#include <meansure.h>
;
;float SENSOR_SENSITIVE;
;float AMP_ADJ_ZERO;
;float total                 = 0.0;
;float avg                   = 2500.0;

	.DSEG
;float value                 = 0.0;
;float Viout                 = 0.0;
;float Vdif                  = 0.0;
;float Vsq_avg               = 0.0;
;float volt                  = 0.0;
;float amp                   = 0.0;
;float power                 = 0.0;
;float whour                 = 0.0;
;float Vsum                  = 0.0;
;float Isum                  = 0.0;
;float Psum                  = 0.0;
;float WHsum                 = 0.0;
;float Vavg                  = 0.0;
;float Iavg                  = 0.0;
;float Pavg                  = 0.0;
;float CURRENT_VOLT          = 0.0;
;float CURRENT_AMP           = 0.0;
;uint16_t number             = 0;
;uint16_t adcValue           = 0;
;uint16_t countSampling      = 0;
;eeprom float ADJ0_SENSOR5A  = 0.090;
;eeprom float ADJ0_SENSOR20A = 0.11;
;eeprom float ADJ0_SENSOR30A = 0.11;
;
;void ReadCurrent(void){
; 0009 0029 void ReadCurrent(void){

	.CSEG
_ReadCurrent:
; 0009 002A     adcValue = read_adc(ADC1);
	LDI  R26,LOW(1)
	CALL SUBOPT_0x5F
; 0009 002B     printDebug("ADC = %d\r\n", adcValue);
	__POINTW1FN _0x120000,0
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x60
	CALL SUBOPT_0x22
; 0009 002C     value = adcValue * (5000.0 / 1023.0);
	CALL SUBOPT_0x61
	__GETD2N 0x409C671A
	CALL __MULF12
	STS  _value,R30
	STS  _value+1,R31
	STS  _value+2,R22
	STS  _value+3,R23
; 0009 002D 
; 0009 002E     // Keep track of the moving average
; 0009 002F     // See more : http://jeelabs.org/2011/09/15/power-measurement-acs-code/
; 0009 0030     avg = (499.0*avg + value) / 500.0;
	CALL SUBOPT_0x62
	__GETD2N 0x43F98000
	CALL __MULF12
	CALL SUBOPT_0x63
	CALL SUBOPT_0x64
	__GETD1N 0x43FA0000
	CALL __DIVF21
	STS  _avg,R30
	STS  _avg+1,R31
	STS  _avg+2,R22
	STS  _avg+3,R23
; 0009 0031 
; 0009 0032     if(value > avg){
	CALL SUBOPT_0x65
	BREQ PC+2
	BRCC PC+3
	JMP  _0x120004
; 0009 0033         Vdif = value - avg;
	LDS  R26,_avg
	LDS  R27,_avg+1
	LDS  R24,_avg+2
	LDS  R25,_avg+3
	LDS  R30,_value
	LDS  R31,_value+1
	LDS  R22,_value+2
	LDS  R23,_value+3
	RJMP _0x12000B
; 0009 0034         total += (Vdif*Vdif);
; 0009 0035     }else if(value < avg) {
_0x120004:
	CALL SUBOPT_0x65
	BRSH _0x120006
; 0009 0036         Vdif = avg - value;
	CALL SUBOPT_0x63
	CALL SUBOPT_0x62
_0x12000B:
	CALL __SUBF12
	STS  _Vdif,R30
	STS  _Vdif+1,R31
	STS  _Vdif+2,R22
	STS  _Vdif+3,R23
; 0009 0037         total += (Vdif*Vdif);
	LDS  R26,_Vdif
	LDS  R27,_Vdif+1
	LDS  R24,_Vdif+2
	LDS  R25,_Vdif+3
	CALL __MULF12
	CALL SUBOPT_0x66
	CALL __ADDF12
	STS  _total,R30
	STS  _total+1,R31
	STS  _total+2,R22
	STS  _total+3,R23
; 0009 0038     }
; 0009 0039     countSampling++;
_0x120006:
	LDI  R26,LOW(_countSampling)
	LDI  R27,HIGH(_countSampling)
	RJMP _0x20C0009
; 0009 003A }
;
;void ReadVoltage(void){
; 0009 003C void ReadVoltage(void){
_ReadVoltage:
; 0009 003D    /*---------- Voltage ----------*/
; 0009 003E     adcValue = read_adc(ADC0);
	LDI  R26,LOW(0)
	CALL SUBOPT_0x5F
; 0009 003F     volt = (((adcValue*5.0)/1023.0)/0.01);
	CALL SUBOPT_0x61
	__GETD2N 0x40A00000
	CALL SUBOPT_0x67
	__GETD1N 0x447FC000
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3C23D70A
	CALL __DIVF21
	STS  _volt,R30
	STS  _volt+1,R31
	STS  _volt+2,R22
	STS  _volt+3,R23
; 0009 0040     if(volt < 223.0) {
	CALL SUBOPT_0x68
	__GETD1N 0x435F0000
	CALL __CMPF12
	BRSH _0x120007
; 0009 0041         volt += 9.0;
	CALL SUBOPT_0x69
	__GETD2N 0x41100000
	CALL __ADDF12
	RJMP _0x12000C
; 0009 0042     }else if(volt > 233.0) {
_0x120007:
	CALL SUBOPT_0x68
	__GETD1N 0x43690000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x120009
; 0009 0043         volt -= 4.0;
	CALL SUBOPT_0x69
	__GETD2N 0x40800000
	CALL __SUBF12
_0x12000C:
	STS  _volt,R30
	STS  _volt+1,R31
	STS  _volt+2,R22
	STS  _volt+3,R23
; 0009 0044     }
; 0009 0045     printDebug("Volt = %f\r\n", volt);
_0x120009:
	__POINTW1FN _0x120000,11
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x69
	CALL SUBOPT_0xA
; 0009 0046     Vsum += volt;
	CALL SUBOPT_0x69
	CALL SUBOPT_0x53
	CALL __ADDF12
	STS  _Vsum,R30
	STS  _Vsum+1,R31
	STS  _Vsum+2,R22
	STS  _Vsum+3,R23
; 0009 0047 
; 0009 0048     /*---------- Current ----------*/
; 0009 0049     // V-rms
; 0009 004A     // See more : http://www.electronics-tutorials.ws/blog/rms-voltage.html
; 0009 004B     Vsq_avg = total / countSampling;
	LDS  R30,_countSampling
	LDS  R31,_countSampling+1
	CALL SUBOPT_0x66
	CALL SUBOPT_0x54
	STS  _Vsq_avg,R30
	STS  _Vsq_avg+1,R31
	STS  _Vsq_avg+2,R22
	STS  _Vsq_avg+3,R23
; 0009 004C     Viout = sqrt(Vsq_avg);
	LDS  R26,_Vsq_avg
	LDS  R27,_Vsq_avg+1
	LDS  R24,_Vsq_avg+2
	LDS  R25,_Vsq_avg+3
	CALL _sqrt
	STS  _Viout,R30
	STS  _Viout+1,R31
	STS  _Viout+2,R22
	STS  _Viout+3,R23
; 0009 004D     amp = Viout / SENSOR_SENSITIVE;                  // ACS712 +-5 or +-20 or +-30 Amp.
	CALL SUBOPT_0xB
	LDS  R26,_Viout
	LDS  R27,_Viout+1
	LDS  R24,_Viout+2
	LDS  R25,_Viout+3
	CALL __DIVF21
	STS  _amp,R30
	STS  _amp+1,R31
	STS  _amp+2,R22
	STS  _amp+3,R23
; 0009 004E 
; 0009 004F     /* Adjust Current to 0 */
; 0009 0050     if(amp < AMP_ADJ_ZERO) {
	CALL SUBOPT_0xC
	LDS  R26,_amp
	LDS  R27,_amp+1
	LDS  R24,_amp+2
	LDS  R25,_amp+3
	CALL __CMPF12
	BRSH _0x12000A
; 0009 0051         amp = 0.0;
	LDI  R30,LOW(0)
	STS  _amp,R30
	STS  _amp+1,R30
	STS  _amp+2,R30
	STS  _amp+3,R30
; 0009 0052     }
; 0009 0053 
; 0009 0054     total = 0.0;
_0x12000A:
	LDI  R30,LOW(0)
	STS  _total,R30
	STS  _total+1,R30
	STS  _total+2,R30
	STS  _total+3,R30
; 0009 0055     countSampling = 0;
	STS  _countSampling,R30
	STS  _countSampling+1,R30
; 0009 0056     Isum += amp;
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x55
	CALL __ADDF12
	STS  _Isum,R30
	STS  _Isum+1,R31
	STS  _Isum+2,R22
	STS  _Isum+3,R23
; 0009 0057 
; 0009 0058     /*---------- Power ----------*/
; 0009 0059     power = volt*amp;
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x68
	CALL __MULF12
	STS  _power,R30
	STS  _power+1,R31
	STS  _power+2,R22
	STS  _power+3,R23
; 0009 005A     Psum += power;
	CALL SUBOPT_0x57
	CALL __ADDF12
	STS  _Psum,R30
	STS  _Psum+1,R31
	STS  _Psum+2,R22
	STS  _Psum+3,R23
; 0009 005B 
; 0009 005C     /*----------  Watt-hour ----------*/
; 0009 005D     whour = power*(0.5/3600.0);
	LDS  R26,_power
	LDS  R27,_power+1
	LDS  R24,_power+2
	LDS  R25,_power+3
	__GETD1N 0x3911A2B4
	CALL __MULF12
	STS  _whour,R30
	STS  _whour+1,R31
	STS  _whour+2,R22
	STS  _whour+3,R23
; 0009 005E     WHsum += whour;
	CALL SUBOPT_0x5C
	CALL __ADDF12
	STS  _WHsum,R30
	STS  _WHsum+1,R31
	STS  _WHsum+2,R22
	STS  _WHsum+3,R23
; 0009 005F     number++;
	LDI  R26,LOW(_number)
	LDI  R27,HIGH(_number)
_0x20C0009:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0009 0060 }
	RET
;#include <mega128a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <main.h>
;#include <queue.h>
;#include <stdio.h>
;#include <stdlib.h>
;#include <string.h>
;#include <debug.h>
;#include <xbee.h>
;#include <int_protocol.h>
;#include <uart.h>
;#include <eeprom.h>
;
;int input[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
;int count_input = 0;
;int count_event = 0;
;
;void push_event(int event){
; 000A 0011 void push_event(int event){

	.CSEG
_push_event:
; 000A 0012     input[count_input] = event;
	ST   -Y,R27
	ST   -Y,R26
;	event -> Y+0
	LDS  R30,_count_input
	LDS  R31,_count_input+1
	CALL SUBOPT_0x37
	ADD  R30,R26
	ADC  R31,R27
	LD   R26,Y
	LDD  R27,Y+1
	STD  Z+0,R26
	STD  Z+1,R27
; 000A 0013     count_input++;
	LDI  R26,LOW(_count_input)
	LDI  R27,HIGH(_count_input)
	CALL SUBOPT_0x21
; 000A 0014 }
	RJMP _0x20C0008
;
;void pop_event(){
; 000A 0016 void pop_event(){
_pop_event:
; 000A 0017     int event = 0;
; 000A 0018     event = input[count_event];
	ST   -Y,R17
	ST   -Y,R16
;	event -> R16,R17
	__GETWRN 16,17,0
	LDS  R30,_count_event
	LDS  R31,_count_event+1
	CALL SUBOPT_0x37
	ADD  R26,R30
	ADC  R27,R31
	LD   R16,X+
	LD   R17,X
; 000A 0019     printDebug("EVENT = %d\r\n", event);
	__POINTW1FN _0x140000,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	CALL SUBOPT_0x1D
; 000A 001A     if (event != 0) count_event++;
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x140003
	LDI  R26,LOW(_count_event)
	LDI  R27,HIGH(_count_event)
	CALL SUBOPT_0x21
; 000A 001B     printDebug("count_event = %d\r\n", count_event);
_0x140003:
	__POINTW1FN _0x140000,13
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_count_event
	LDS  R31,_count_event+1
	CALL SUBOPT_0x1D
; 000A 001C     if(count_event == 30 ) count_event = 0;
	LDS  R26,_count_event
	LDS  R27,_count_event+1
	SBIW R26,30
	BRNE _0x140004
	LDI  R30,LOW(0)
	STS  _count_event,R30
	STS  _count_event+1,R30
; 000A 001D     do_event(event);
_0x140004:
	MOVW R26,R16
	RCALL _do_event
; 000A 001E }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void do_event(int event){
; 000A 0020 void do_event(int event){
_do_event:
; 000A 0021 
; 000A 0022             if(event == 2){
	ST   -Y,R27
	ST   -Y,R26
;	event -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,2
	BRNE _0x140005
; 000A 0023                 flag_state = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x16
; 000A 0024                 printDebug("\r\n-------- JOINT SUCCESS --------\r\n");
	__POINTW1FN _0x140000,32
	RJMP _0x140018
; 000A 0025             }
; 000A 0026 
; 000A 0027         /*=============== Recive ACK ===============*/
; 000A 0028             else if(event == 3){
_0x140005:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,3
	BRNE _0x140007
; 000A 0029                 printDebug("\r\n-------- RECIVE PING --------\r\n");
	__POINTW1FN _0x140000,68
	CALL SUBOPT_0x8
; 000A 002A                 send_ping();
	CALL _send_ping
; 000A 002B             }
; 000A 002C 
; 000A 002D         /*=============== Recive EVENT from Gate Way ===============*/
; 000A 002E             else if(event == 510 || event == 511){
	RJMP _0x140008
_0x140007:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x1FE)
	LDI  R30,HIGH(0x1FE)
	CPC  R27,R30
	BREQ _0x14000A
	CPI  R26,LOW(0x1FF)
	LDI  R30,HIGH(0x1FF)
	CPC  R27,R30
	BRNE _0x140009
_0x14000A:
; 000A 002F                 if(event == 511){
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x1FF)
	LDI  R30,HIGH(0x1FF)
	CPC  R27,R30
	BRNE _0x14000C
; 000A 0030                     device_state(1); // on
	CALL SUBOPT_0x10
	CALL SUBOPT_0x6B
; 000A 0031                     EVENT[1] = 1;
; 000A 0032                     flag_state = 5;
	RJMP _0x140019
; 000A 0033                     EEPROM_write(Eaddress,STATUS_DEVICE);
; 000A 0034                 }else if(event == 510){
_0x14000C:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x1FE)
	LDI  R30,HIGH(0x1FE)
	CPC  R27,R30
	BRNE _0x14000E
; 000A 0035                     device_state(0); // off
	CALL SUBOPT_0xD
	CALL SUBOPT_0x6C
; 000A 0036                     EVENT[1] = 0;
; 000A 0037                     flag_state = 4;
_0x140019:
	STS  _flag_state,R30
	STS  _flag_state+1,R31
; 000A 0038                     EEPROM_write(Eaddress,STATUS_DEVICE);
	CALL SUBOPT_0x3
	CALL SUBOPT_0x12
; 000A 0039                 }
; 000A 003A                 recive_event(1,EVENT[1]);
_0x14000E:
	LDI  R30,LOW(1)
	ST   -Y,R30
	__GETB2MN _EVENT,1
	CALL _recive_event
; 000A 003B                 printDebug("\r\n-------- RECIVE EVENT --------\r\n");
	__POINTW1FN _0x140000,102
	RJMP _0x140018
; 000A 003C             }
; 000A 003D 
; 000A 003E             /*=============== Send EVENT from Smart Plug ===============*/
; 000A 003F 
; 000A 0040             else if(event == 5100 || event == 5110){
_0x140009:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x13EC)
	LDI  R30,HIGH(0x13EC)
	CPC  R27,R30
	BREQ _0x140011
	CPI  R26,LOW(0x13F6)
	LDI  R30,HIGH(0x13F6)
	CPC  R27,R30
	BRNE _0x140010
_0x140011:
; 000A 0041             printDebug("\r\n-------- SEND EVENT --------\r\n");
	__POINTW1FN _0x140000,137
	CALL SUBOPT_0x8
; 000A 0042                 if(event == 5110){
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x13F6)
	LDI  R30,HIGH(0x13F6)
	CPC  R27,R30
	BRNE _0x140013
; 000A 0043                     device_state(1); // on
	CALL SUBOPT_0x10
	CALL SUBOPT_0x6B
; 000A 0044                     EVENT[1] = 1;
; 000A 0045                     flag_state = 5;
	RJMP _0x14001A
; 000A 0046                     EEPROM_write(Eaddress,STATUS_DEVICE);
; 000A 0047                     send_event(1,EVENT[1]);
; 000A 0048                 }else if(event == 5100){
_0x140013:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x13EC)
	LDI  R30,HIGH(0x13EC)
	CPC  R27,R30
	BRNE _0x140015
; 000A 0049                     device_state(0); // off
	CALL SUBOPT_0xD
	CALL SUBOPT_0x6C
; 000A 004A                     EVENT[1] = 0;
; 000A 004B                     flag_state = 4;
_0x14001A:
	STS  _flag_state,R30
	STS  _flag_state+1,R31
; 000A 004C                     EEPROM_write(Eaddress,STATUS_DEVICE);
	CALL SUBOPT_0x3
	CALL SUBOPT_0x12
; 000A 004D                     send_event(1,EVENT[1]);
	LDI  R30,LOW(1)
	ST   -Y,R30
	__GETB2MN _EVENT,1
	CALL _send_event
; 000A 004E                 }
; 000A 004F             }
_0x140015:
; 000A 0050 
; 000A 0051             /*=============== Send REPPORT Success ===============*/
; 000A 0052             else if(event == 8){
	RJMP _0x140016
_0x140010:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,8
	BRNE _0x140017
; 000A 0053                 printDebug("\r\n-------- SEND REPORT SUCCESS --------\r\n");
	__POINTW1FN _0x140000,170
_0x140018:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printDebug
	ADIW R28,2
; 000A 0054             }
; 000A 0055 }
_0x140017:
_0x140016:
_0x140008:
_0x20C0008:
	ADIW R28,2
	RET
;
;
;

	.CSEG
_ftoa:
	CALL SUBOPT_0x19
	ST   Y,R30
	LDI  R30,LOW(0)
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x200000D
	CALL SUBOPT_0x1A
	__POINTW2FN _0x2000000,0
	CALL _strcpyf
	RJMP _0x20C0007
_0x200000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x200000C
	CALL SUBOPT_0x1A
	__POINTW2FN _0x2000000,1
	CALL _strcpyf
	RJMP _0x20C0007
_0x200000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x200000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x6E
	LDI  R30,LOW(45)
	ST   X,R30
_0x200000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2000010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2000010:
	LDD  R17,Y+8
_0x2000011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000013
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x70
	CALL SUBOPT_0x71
	RJMP _0x2000011
_0x2000013:
	CALL SUBOPT_0x72
	CALL __ADDF12
	CALL SUBOPT_0x6D
	LDI  R17,LOW(0)
	CALL SUBOPT_0x9
	CALL SUBOPT_0x71
_0x2000014:
	CALL SUBOPT_0x72
	CALL __CMPF12
	BRLO _0x2000016
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x73
	CALL SUBOPT_0x71
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2000017
	CALL SUBOPT_0x1A
	__POINTW2FN _0x2000000,5
	CALL _strcpyf
	RJMP _0x20C0007
_0x2000017:
	RJMP _0x2000014
_0x2000016:
	CPI  R17,0
	BRNE _0x2000018
	CALL SUBOPT_0x6E
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2000019
_0x2000018:
_0x200001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200001C
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x70
	CALL SUBOPT_0x74
	CALL SUBOPT_0x64
	CALL _floor
	CALL SUBOPT_0x71
	CALL SUBOPT_0x72
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x75
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x3B
	CALL __MULF12
	CALL SUBOPT_0x76
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x6D
	RJMP _0x200001A
_0x200001C:
_0x2000019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0006
	CALL SUBOPT_0x6E
	LDI  R30,LOW(46)
	ST   X,R30
_0x200001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2000020
	CALL SUBOPT_0x76
	CALL SUBOPT_0x73
	CALL SUBOPT_0x6D
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x75
	CALL SUBOPT_0x76
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x6D
	RJMP _0x200001E
_0x2000020:
_0x20C0006:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0007:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
	CALL SUBOPT_0x2D
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x21
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	CALL SUBOPT_0x21
_0x2020014:
_0x2020013:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__ftoe_G101:
	CALL SUBOPT_0x19
	ST   Y,R30
	LDI  R30,LOW(0)
	STD  Y+1,R30
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2020019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2020000,0
	CALL _strcpyf
	RJMP _0x20C0005
_0x2020019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2020018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2020000,1
	CALL _strcpyf
	RJMP _0x20C0005
_0x2020018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x202001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x202001B:
	LDD  R17,Y+11
_0x202001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x202001E
	CALL SUBOPT_0x77
	RJMP _0x202001C
_0x202001E:
	CALL SUBOPT_0x3A
	CALL __CPD10
	BRNE _0x202001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0x77
	RJMP _0x2020020
_0x202001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x78
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2020021
	CALL SUBOPT_0x77
_0x2020022:
	CALL SUBOPT_0x78
	BRLO _0x2020024
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x70
	CALL SUBOPT_0x79
	SUBI R19,-LOW(1)
	RJMP _0x2020022
_0x2020024:
	RJMP _0x2020025
_0x2020021:
_0x2020026:
	CALL SUBOPT_0x78
	BRSH _0x2020028
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x73
	CALL SUBOPT_0x79
	SUBI R19,LOW(1)
	RJMP _0x2020026
_0x2020028:
	CALL SUBOPT_0x77
_0x2020025:
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x74
	CALL __ADDF12
	CALL SUBOPT_0x79
	CALL SUBOPT_0x78
	BRLO _0x2020029
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x70
	CALL SUBOPT_0x79
	SUBI R19,-LOW(1)
_0x2020029:
_0x2020020:
	LDI  R17,LOW(0)
_0x202002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x202002C
	CALL SUBOPT_0x40
	CALL SUBOPT_0x70
	CALL SUBOPT_0x74
	CALL SUBOPT_0x64
	CALL _floor
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x42
	CALL SUBOPT_0x3C
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x7A
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL SUBOPT_0x40
	CALL __MULF12
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x79
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x202002A
	CALL SUBOPT_0x7A
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x202002A
_0x202002C:
	CALL SUBOPT_0x7B
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x202002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x202010E
_0x202002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x202010E:
	ST   X,R30
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x7B
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x7B
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0005:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
__print_G101:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x21
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2020032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2020036
	CPI  R18,37
	BRNE _0x2020037
	LDI  R17,LOW(1)
	RJMP _0x2020038
_0x2020037:
	CALL SUBOPT_0x7C
_0x2020038:
	RJMP _0x2020035
_0x2020036:
	CPI  R30,LOW(0x1)
	BRNE _0x2020039
	CPI  R18,37
	BRNE _0x202003A
	CALL SUBOPT_0x7C
	RJMP _0x202010F
_0x202003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x202003B
	LDI  R16,LOW(1)
	RJMP _0x2020035
_0x202003B:
	CPI  R18,43
	BRNE _0x202003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2020035
_0x202003C:
	CPI  R18,32
	BRNE _0x202003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2020035
_0x202003D:
	RJMP _0x202003E
_0x2020039:
	CPI  R30,LOW(0x2)
	BRNE _0x202003F
_0x202003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020040
	ORI  R16,LOW(128)
	RJMP _0x2020035
_0x2020040:
	RJMP _0x2020041
_0x202003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2020042
_0x2020041:
	CPI  R18,48
	BRLO _0x2020044
	CPI  R18,58
	BRLO _0x2020045
_0x2020044:
	RJMP _0x2020043
_0x2020045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2020035
_0x2020043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2020046
	LDI  R17,LOW(4)
	RJMP _0x2020035
_0x2020046:
	RJMP _0x2020047
_0x2020042:
	CPI  R30,LOW(0x4)
	BRNE _0x2020049
	CPI  R18,48
	BRLO _0x202004B
	CPI  R18,58
	BRLO _0x202004C
_0x202004B:
	RJMP _0x202004A
_0x202004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2020035
_0x202004A:
_0x2020047:
	CPI  R18,108
	BRNE _0x202004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2020035
_0x202004D:
	RJMP _0x202004E
_0x2020049:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x2020035
_0x202004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2020053
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x7D
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x7F
	RJMP _0x2020054
_0x2020053:
	CPI  R30,LOW(0x45)
	BREQ _0x2020057
	CPI  R30,LOW(0x65)
	BRNE _0x2020058
_0x2020057:
	RJMP _0x2020059
_0x2020058:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x202005A
_0x2020059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x80
	CALL __GETD1P
	CALL SUBOPT_0x81
	CALL SUBOPT_0x82
	LDD  R26,Y+13
	TST  R26
	BRMI _0x202005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x202005D
	RJMP _0x202005E
_0x202005B:
	CALL SUBOPT_0x83
	CALL __ANEGF1
	CALL SUBOPT_0x81
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x202005D:
	SBRS R16,7
	RJMP _0x202005F
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x7F
	RJMP _0x2020060
_0x202005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2020060:
_0x202005E:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2020062
	CALL SUBOPT_0x83
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x2020063
_0x2020062:
	CALL SUBOPT_0x83
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G101
_0x2020063:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x84
	RJMP _0x2020064
_0x202005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2020066
	CALL SUBOPT_0x82
	CALL SUBOPT_0x85
	CALL SUBOPT_0x84
	RJMP _0x2020067
_0x2020066:
	CPI  R30,LOW(0x70)
	BRNE _0x2020069
	CALL SUBOPT_0x82
	CALL SUBOPT_0x85
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020067:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x202006B
	CP   R20,R17
	BRLO _0x202006C
_0x202006B:
	RJMP _0x202006A
_0x202006C:
	MOV  R17,R20
_0x202006A:
_0x2020064:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x202006D
_0x2020069:
	CPI  R30,LOW(0x64)
	BREQ _0x2020070
	CPI  R30,LOW(0x69)
	BRNE _0x2020071
_0x2020070:
	ORI  R16,LOW(4)
	RJMP _0x2020072
_0x2020071:
	CPI  R30,LOW(0x75)
	BRNE _0x2020073
_0x2020072:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2020074
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x86
	LDI  R17,LOW(10)
	RJMP _0x2020075
_0x2020074:
	__GETD1N 0x2710
	CALL SUBOPT_0x86
	LDI  R17,LOW(5)
	RJMP _0x2020075
_0x2020073:
	CPI  R30,LOW(0x58)
	BRNE _0x2020077
	ORI  R16,LOW(8)
	RJMP _0x2020078
_0x2020077:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x20200B6
_0x2020078:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x202007A
	__GETD1N 0x10000000
	CALL SUBOPT_0x86
	LDI  R17,LOW(8)
	RJMP _0x2020075
_0x202007A:
	__GETD1N 0x1000
	CALL SUBOPT_0x86
	LDI  R17,LOW(4)
_0x2020075:
	CPI  R20,0
	BREQ _0x202007B
	ANDI R16,LOW(127)
	RJMP _0x202007C
_0x202007B:
	LDI  R20,LOW(1)
_0x202007C:
	SBRS R16,1
	RJMP _0x202007D
	CALL SUBOPT_0x82
	CALL SUBOPT_0x80
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2020110
_0x202007D:
	SBRS R16,2
	RJMP _0x202007F
	CALL SUBOPT_0x82
	CALL SUBOPT_0x85
	CALL __CWD1
	RJMP _0x2020110
_0x202007F:
	CALL SUBOPT_0x82
	CALL SUBOPT_0x85
	CLR  R22
	CLR  R23
_0x2020110:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2020081
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2020082
	CALL SUBOPT_0x83
	CALL __ANEGD1
	CALL SUBOPT_0x81
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2020082:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2020083
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2020084
_0x2020083:
	ANDI R16,LOW(251)
_0x2020084:
_0x2020081:
	MOV  R19,R20
_0x202006D:
	SBRC R16,0
	RJMP _0x2020085
_0x2020086:
	CP   R17,R21
	BRSH _0x2020089
	CP   R19,R21
	BRLO _0x202008A
_0x2020089:
	RJMP _0x2020088
_0x202008A:
	SBRS R16,7
	RJMP _0x202008B
	SBRS R16,2
	RJMP _0x202008C
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x202008D
_0x202008C:
	LDI  R18,LOW(48)
_0x202008D:
	RJMP _0x202008E
_0x202008B:
	LDI  R18,LOW(32)
_0x202008E:
	CALL SUBOPT_0x7C
	SUBI R21,LOW(1)
	RJMP _0x2020086
_0x2020088:
_0x2020085:
_0x202008F:
	CP   R17,R20
	BRSH _0x2020091
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2020092
	CALL SUBOPT_0x87
	BREQ _0x2020093
	SUBI R21,LOW(1)
_0x2020093:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2020092:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x7F
	CPI  R21,0
	BREQ _0x2020094
	SUBI R21,LOW(1)
_0x2020094:
	SUBI R20,LOW(1)
	RJMP _0x202008F
_0x2020091:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2020095
_0x2020096:
	CPI  R19,0
	BREQ _0x2020098
	SBRS R16,3
	RJMP _0x2020099
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x202009A
_0x2020099:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x202009A:
	CALL SUBOPT_0x7C
	CPI  R21,0
	BREQ _0x202009B
	SUBI R21,LOW(1)
_0x202009B:
	SUBI R19,LOW(1)
	RJMP _0x2020096
_0x2020098:
	RJMP _0x202009C
_0x2020095:
_0x202009E:
	CALL SUBOPT_0x88
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20200A0
	SBRS R16,3
	RJMP _0x20200A1
	SUBI R18,-LOW(55)
	RJMP _0x20200A2
_0x20200A1:
	SUBI R18,-LOW(87)
_0x20200A2:
	RJMP _0x20200A3
_0x20200A0:
	SUBI R18,-LOW(48)
_0x20200A3:
	SBRC R16,4
	RJMP _0x20200A5
	CPI  R18,49
	BRSH _0x20200A7
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20200A6
_0x20200A7:
	RJMP _0x20200A9
_0x20200A6:
	CP   R20,R19
	BRSH _0x2020111
	CP   R21,R19
	BRLO _0x20200AC
	SBRS R16,0
	RJMP _0x20200AD
_0x20200AC:
	RJMP _0x20200AB
_0x20200AD:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20200AE
_0x2020111:
	LDI  R18,LOW(48)
_0x20200A9:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20200AF
	CALL SUBOPT_0x87
	BREQ _0x20200B0
	SUBI R21,LOW(1)
_0x20200B0:
_0x20200AF:
_0x20200AE:
_0x20200A5:
	CALL SUBOPT_0x7C
	CPI  R21,0
	BREQ _0x20200B1
	SUBI R21,LOW(1)
_0x20200B1:
_0x20200AB:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x88
	CALL __MODD21U
	CALL SUBOPT_0x81
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x86
	__GETD1S 16
	CALL __CPD10
	BREQ _0x202009F
	RJMP _0x202009E
_0x202009F:
_0x202009C:
	SBRS R16,0
	RJMP _0x20200B2
_0x20200B3:
	CPI  R21,0
	BREQ _0x20200B5
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x7F
	RJMP _0x20200B3
_0x20200B5:
_0x20200B2:
_0x20200B6:
_0x2020054:
_0x202010F:
	LDI  R17,LOW(0)
_0x2020035:
	RJMP _0x2020030
_0x2020032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
_vsprintf:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	SBIW R30,0
	BRNE _0x20200BA
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	JMP  _0x20C0002
_0x20200BA:
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	STD  Y+4,R30
	STD  Y+4+1,R31
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G101
	MOVW R16,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R16
	JMP  _0x20C0002

	.CSEG
_memcpy:
	ST   -Y,R27
	ST   -Y,R26
    ldd  r25,y+1
    ld   r24,y
    adiw r24,0
    breq memcpy1
    ldd  r27,y+5
    ldd  r26,y+4
    ldd  r31,y+3
    ldd  r30,y+2
memcpy0:
    ld   r22,z+
    st   x+,r22
    sbiw r24,1
    brne memcpy0
memcpy1:
    ldd  r31,y+5
    ldd  r30,y+4
	ADIW R28,6
	RET
_strcpyf:
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
_strlen:
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG
_ftrunc:
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL SUBOPT_0x4F
	RJMP _0x20C0004
__floor1:
    brtc __floor0
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x89
_0x20C0004:
	ADIW R28,4
	RET
_log:
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x8A
	CALL __CPD02
	BRLT _0x208000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x20C0003
_0x208000C:
	CALL SUBOPT_0x8B
	CALL __PUTPARD1
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R17
	PUSH R16
	CALL _frexp
	POP  R16
	POP  R17
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8A
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x208000D
	CALL SUBOPT_0x8D
	CALL __ADDF12
	CALL SUBOPT_0x8C
	__SUBWRN 16,17,1
_0x208000D:
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x89
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x8B
	__GETD2N 0x3F800000
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	__GETD2N 0x3F654226
	CALL SUBOPT_0x67
	__GETD1N 0x4054114E
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x8A
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x8F
	__GETD2N 0x3FD4114D
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	CALL SUBOPT_0x3B
	__GETD2N 0x3F317218
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
_0x20C0003:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
_exp:
	CALL __PUTPARD2
	SBIW R28,8
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x90
	__GETD1N 0xC2AEAC50
	CALL __CMPF12
	BRSH _0x208000F
	CALL SUBOPT_0x91
	RJMP _0x20C0002
_0x208000F:
	CALL SUBOPT_0x83
	CALL __CPD10
	BRNE _0x2080010
	CALL SUBOPT_0x9
	RJMP _0x20C0002
_0x2080010:
	CALL SUBOPT_0x90
	__GETD1N 0x42B17218
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2080011
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0002
_0x2080011:
	CALL SUBOPT_0x90
	__GETD1N 0x3FB8AA3B
	CALL __MULF12
	CALL SUBOPT_0x81
	CALL SUBOPT_0x90
	RCALL _floor
	CALL __CFD1
	MOVW R16,R30
	MOVW R30,R16
	CALL SUBOPT_0x90
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3D
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F000000
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8E
	__GETD2N 0x3D6C4C6D
	CALL __MULF12
	__GETD2N 0x40E6E3A6
	CALL __ADDF12
	CALL SUBOPT_0x8A
	CALL __MULF12
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8F
	__GETD2N 0x41A68D28
	CALL __ADDF12
	CALL SUBOPT_0x71
	CALL SUBOPT_0x8B
	CALL SUBOPT_0x6F
	CALL __ADDF12
	__GETD2N 0x3FB504F3
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x8A
	CALL SUBOPT_0x8F
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL __PUTPARD1
	MOVW R26,R16
	CALL _ldexp
_0x20C0002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,14
	RET
_pow:
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0x4E
	CALL __CPD10
	BRNE _0x2080012
	CALL SUBOPT_0x91
	RJMP _0x20C0001
_0x2080012:
	__GETD2S 8
	CALL __CPD02
	BRGE _0x2080013
	CALL SUBOPT_0x42
	CALL __CPD10
	BRNE _0x2080014
	CALL SUBOPT_0x9
	RJMP _0x20C0001
_0x2080014:
	__GETD2S 8
	CALL SUBOPT_0x92
	RCALL _exp
	RJMP _0x20C0001
_0x2080013:
	CALL SUBOPT_0x42
	MOVW R26,R28
	CALL __CFD1
	CALL __PUTDP1
	CALL SUBOPT_0x4F
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x42
	CALL __CPD12
	BREQ _0x2080015
	CALL SUBOPT_0x91
	RJMP _0x20C0001
_0x2080015:
	CALL SUBOPT_0x4E
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x92
	RCALL _exp
	__PUTD1S 8
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x2080016
	CALL SUBOPT_0x4E
	RJMP _0x20C0001
_0x2080016:
	CALL SUBOPT_0x4E
	CALL __ANEGF1
_0x20C0001:
	ADIW R28,12
	RET

	.CSEG
_isprint:
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,32
    brlo isprint0
    cpi  r31,128
    brlo isprint1
isprint0:
    clr  r30
isprint1:
    ret

	.DSEG
_SWITCH:
	.BYTE 0x1
_CURRENT_VOLT:
	.BYTE 0x4
_CURRENT_AMP:
	.BYTE 0x4

	.ESEG
_ADJ0_SENSOR5A:
	.DB  0xEC,0x51,0xB8,0x3D
_ADJ0_SENSOR20A:
	.DB  0xAE,0x47,0xE1,0x3D
_ADJ0_SENSOR30A:
	.DB  0xAE,0x47,0xE1,0x3D

	.DSEG
__FlagPackageTerminate0:
	.BYTE 0x1
_rxPackage0:
	.BYTE 0x20
_flag_state:
	.BYTE 0x2
_rx_rd_index1:
	.BYTE 0x2
_rx_counter1:
	.BYTE 0x2
_rx_buffer1:
	.BYTE 0x200
_number:
	.BYTE 0x2
_AMP_ADJ_ZERO:
	.BYTE 0x4
_SENSOR_SENSITIVE:
	.BYTE 0x4
_adcValue:
	.BYTE 0x2
_total:
	.BYTE 0x4
_avg:
	.BYTE 0x4
_value:
	.BYTE 0x4
_Viout:
	.BYTE 0x4
_Vdif:
	.BYTE 0x4
_Vsq_avg:
	.BYTE 0x4
_volt:
	.BYTE 0x4
_amp:
	.BYTE 0x4
_power:
	.BYTE 0x4
_whour:
	.BYTE 0x4
_Vsum:
	.BYTE 0x4
_Isum:
	.BYTE 0x4
_Psum:
	.BYTE 0x4
_WHsum:
	.BYTE 0x4
_Vavg:
	.BYTE 0x4
_Iavg:
	.BYTE 0x4
_Pavg:
	.BYTE 0x4
_countSampling:
	.BYTE 0x2
_EndDevice_MacAddress:
	.BYTE 0x8
_Gateway_MacAddress:
	.BYTE 0x8
_STATUS_DEVICE:
	.BYTE 0x1
_EVENT:
	.BYTE 0x2
_baseCounter:
	.BYTE 0x4
_pressedBTCounter:
	.BYTE 0x1
__FlagBT:
	.BYTE 0x1
__Flag05INT:
	.BYTE 0x1
__Flag0001INT:
	.BYTE 0x1
__BlinkLED_1Hz:
	.BYTE 0x1
_Eaddress:
	.BYTE 0x1
_input:
	.BYTE 0x3C
_count_input:
	.BYTE 0x2
_count_event:
	.BYTE 0x2
_specData:
	.BYTE 0xD
_AI_COMMAND:
	.BYTE 0x8
_SL_COMMAND:
	.BYTE 0x8
_SH_COMMAND:
	.BYTE 0x8
_JOIN_A1:
	.BYTE 0x27
_PING_A4:
	.BYTE 0x27
_SEND_EVENT_:
	.BYTE 0x29
_SEND_REPORT_:
	.BYTE 0x4C
__voltage:
	.BYTE 0x8
__amp:
	.BYTE 0x8
__power:
	.BYTE 0x8
__watt:
	.BYTE 0x8
_Vreferent:
	.BYTE 0x1
__seed_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	ST   -Y,R27
	ST   -Y,R26
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDS  R30,101
	ANDI R30,0xFB
	STS  101,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	LDS  R26,_Eaddress
	CLR  R27
	CALL _EEPROM_read
	STS  _STATUS_DEVICE,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x3:
	LDS  R30,_Eaddress
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x4:
	__GETD1N 0x43390000
	STS  _SENSOR_SENSITIVE,R30
	STS  _SENSOR_SENSITIVE+1,R31
	STS  _SENSOR_SENSITIVE+2,R22
	STS  _SENSOR_SENSITIVE+3,R23
	LDI  R26,LOW(_ADJ0_SENSOR5A)
	LDI  R27,HIGH(_ADJ0_SENSOR5A)
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	MOVW R26,R30
	MOVW R24,R22
	CALL __CPD02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	STS  _SENSOR_SENSITIVE,R30
	STS  _SENSOR_SENSITIVE+1,R31
	STS  _SENSOR_SENSITIVE+2,R22
	STS  _SENSOR_SENSITIVE+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printDebug
	ADIW R28,2
	__POINTW1FN _0x0,39
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x3F800000
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printDebug
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:101 WORDS
SUBOPT_0x8:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printDebug
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0xA:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printDebug
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDS  R30,_SENSOR_SENSITIVE
	LDS  R31,_SENSOR_SENSITIVE+1
	LDS  R22,_SENSOR_SENSITIVE+2
	LDS  R23,_SENSOR_SENSITIVE+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDS  R30,_AMP_ADJ_ZERO
	LDS  R31,_AMP_ADJ_ZERO+1
	LDS  R22,_AMP_ADJ_ZERO+2
	LDS  R23,_AMP_ADJ_ZERO+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(0)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	CALL _xbee_sendATCommand
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(1)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x11:
	CALL _device_state
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x12:
	LDS  R26,_STATUS_DEVICE
	JMP  _EEPROM_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(2)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	MOVW R26,R8
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LDI  R26,LOW(200)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	STS  _flag_state,R30
	STS  _flag_state+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x16
	LDI  R26,LOW(5100)
	LDI  R27,HIGH(5100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1A:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	JMP  _print_hex_ascii_line

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	CALL __CWD1
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1E:
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R20
	LD   R30,X
	CLR  R31
	CLR  R22
	CLR  R23
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(171)
	STS  137,R30
	LDI  R30,LOW(160)
	STS  136,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x20:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x21:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	CLR  R22
	CLR  R23
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x23:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x24:
	CALL __GETD1S0
	__CPD1N 0x960
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x25:
	__CPD1N 0x2580
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x26:
	__CPD1N 0x3840
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x27:
	__CPD1N 0x4B00
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x28:
	__CPD1N 0x9600
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x29:
	__CPD1N 0xE100
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2A:
	__CPD1N 0x1C200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	JMP  _print_payload

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x2C:
	LDI  R26,LOW(8)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2E:
	MOVW R30,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,2
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,3
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(_EndDevice_MacAddress)
	LDI  R31,HIGH(_EndDevice_MacAddress)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x32:
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ADIW R30,5
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(4)
	LDI  R27,0
	JMP  _memcpy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x33:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,32
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x34:
	LDI  R30,LOW(_Gateway_MacAddress)
	LDI  R31,HIGH(_Gateway_MacAddress)
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x2C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x35:
	CALL _memcpy
	LDS  R30,_count_input
	LDS  R31,_count_input+1
	LDI  R26,LOW(_input)
	LDI  R27,HIGH(_input)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x36:
	LDS  R30,_count_input
	LDS  R31,_count_input+1
	LDI  R26,LOW(_input)
	LDI  R27,HIGH(_input)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	LDI  R26,LOW(_input)
	LDI  R27,HIGH(_input)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x38:
	ST   -Y,R30
	__GETD2N 0x9600
	JMP  _init_uart

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:20 WORDS
SUBOPT_0x39:
	LDI  R30,0
	SBIC 0x19,7
	LDI  R30,1
	MOV  R0,R30
	LDI  R26,0
	SBIC 0x19,6
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	OR   R0,R30
	LDI  R26,0
	SBIC 0x19,5
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	LSL  R30
	OR   R0,R30
	LDI  R26,0
	SBIC 0x19,4
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	LSL  R30
	LSL  R30
	OR   R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3B:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x3C:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3D:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3E:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x3F:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x40:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x41:
	CALL __MULF12
	RJMP SUBOPT_0x3E

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x42:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x43:
	ST   -Y,R26
	__POINTW1MN _SEND_EVENT_,5
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_Gateway_MacAddress)
	LDI  R31,HIGH(_Gateway_MacAddress)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x2C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x44:
	CALL _memcpy
	__POINTW1MN _SEND_EVENT_,18
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x45:
	CALL _memcpy
	__POINTW1MN _SEND_EVENT_,26
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_Gateway_MacAddress)
	LDI  R31,HIGH(_Gateway_MacAddress)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x2C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x46:
	CALL _memcpy
	__POINTW1MN _SEND_EVENT_,39
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x47:
	__PUTB1MN _SEND_EVENT_,37
	LDD  R30,Y+1
	__PUTB1MN _SEND_EVENT_,38
	__POINTW1MN _SEND_EVENT_,3
	ST   -Y,R31
	ST   -Y,R30
	__GETB2MN _SEND_EVENT_,2
	LDI  R27,0
	CALL _xbee_checksum
	__PUTB1MN _SEND_EVENT_,40
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x48:
	LDI  R30,LOW(_SEND_EVENT_)
	LDI  R31,HIGH(_SEND_EVENT_)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(41)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x49:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4A:
	LDI  R27,0
	JMP  _xbee_checksum

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4B:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(39)
	LDI  R27,0
	JMP  _print_payload

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4C:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_Gateway_MacAddress)
	LDI  R31,HIGH(_Gateway_MacAddress)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x2C

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4D:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4E:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4F:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x50:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x2C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x51:
	LDI  R30,LOW(_SEND_REPORT_)
	LDI  R31,HIGH(_SEND_REPORT_)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(76)
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x52:
	LDS  R30,_number
	LDS  R31,_number+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x53:
	LDS  R26,_Vsum
	LDS  R27,_Vsum+1
	LDS  R24,_Vsum+2
	LDS  R25,_Vsum+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x54:
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x55:
	LDS  R26,_Isum
	LDS  R27,_Isum+1
	LDS  R24,_Isum+2
	LDS  R25,_Isum+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x56:
	STS  _Iavg,R30
	STS  _Iavg+1,R31
	STS  _Iavg+2,R22
	STS  _Iavg+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x57:
	LDS  R26,_Psum
	LDS  R27,_Psum+1
	LDS  R24,_Psum+2
	LDS  R25,_Psum+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x58:
	LDS  R30,_Vavg
	LDS  R31,_Vavg+1
	LDS  R22,_Vavg+2
	LDS  R23,_Vavg+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x59:
	LDS  R30,_Iavg
	LDS  R31,_Iavg+1
	LDS  R22,_Iavg+2
	LDS  R23,_Iavg+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5A:
	LDS  R30,_Pavg
	LDS  R31,_Pavg+1
	LDS  R22,_Pavg+2
	LDS  R23,_Pavg+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5B:
	LDS  R26,_Iavg
	LDS  R27,_Iavg+1
	LDS  R24,_Iavg+2
	LDS  R25,_Iavg+3
	__GETD1N 0x447A0000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5C:
	LDS  R26,_WHsum
	LDS  R27,_WHsum+1
	LDS  R24,_WHsum+2
	LDS  R25,_WHsum+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5D:
	LDS  R26,_SENSOR_SENSITIVE
	LDS  R27,_SENSOR_SENSITIVE+1
	LDS  R24,_SENSOR_SENSITIVE+2
	LDS  R25,_SENSOR_SENSITIVE+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5E:
	LDS  R26,_Iavg
	LDS  R27,_Iavg+1
	LDS  R24,_Iavg+2
	LDS  R25,_Iavg+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5F:
	CALL _read_adc
	STS  _adcValue,R30
	STS  _adcValue+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x60:
	LDS  R30,_adcValue
	LDS  R31,_adcValue+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	RCALL SUBOPT_0x60
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x62:
	LDS  R30,_avg
	LDS  R31,_avg+1
	LDS  R22,_avg+2
	LDS  R23,_avg+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x63:
	LDS  R26,_value
	LDS  R27,_value+1
	LDS  R24,_value+2
	LDS  R25,_value+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x64:
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x65:
	RCALL SUBOPT_0x62
	RCALL SUBOPT_0x63
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x66:
	LDS  R26,_total
	LDS  R27,_total+1
	LDS  R24,_total+2
	LDS  R25,_total+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x67:
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x68:
	LDS  R26,_volt
	LDS  R27,_volt+1
	LDS  R24,_volt+2
	LDS  R25,_volt+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x69:
	LDS  R30,_volt
	LDS  R31,_volt+1
	LDS  R22,_volt+2
	LDS  R23,_volt+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6A:
	LDS  R30,_amp
	LDS  R31,_amp+1
	LDS  R22,_amp+2
	LDS  R23,_amp+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6B:
	CALL _device_state
	LDI  R30,LOW(1)
	__PUTB1MN _EVENT,1
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6C:
	CALL _device_state
	LDI  R30,LOW(0)
	__PUTB1MN _EVENT,1
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6D:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6E:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6F:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x70:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x71:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x72:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x73:
	RCALL SUBOPT_0x3F
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x74:
	__GETD2N 0x3F000000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x75:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x76:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x77:
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x3F
	RJMP SUBOPT_0x41

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x78:
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x3C
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x79:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7A:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7B:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7C:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x7D:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x7E:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7F:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x80:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x81:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x82:
	RCALL SUBOPT_0x7D
	RJMP SUBOPT_0x7E

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x83:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x84:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x85:
	RCALL SUBOPT_0x80
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x86:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x87:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x88:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x89:
	__GETD2N 0x3F800000
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x8A:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8B:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8C:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8D:
	RCALL SUBOPT_0x8B
	RJMP SUBOPT_0x8A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8E:
	CALL __MULF12
	RCALL SUBOPT_0x71
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8F:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x90:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x91:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x92:
	CALL _log
	RCALL SUBOPT_0x40
	RJMP SUBOPT_0x67


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

_frexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	CLR  R24
	SUBI R23,0x7E
	SBC  R24,R24
	ST   X+,R23
	ST   X,R24
	LDI  R23,0x7E
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

_ldexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	ADD  R23,R26
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

_sqrt:
	rcall __PUTPARD2
	sbiw r28,4
	push r21
	ldd  r25,y+7
	tst  r25
	brne __sqrt0
	adiw r28,8
	rjmp __zerores
__sqrt0:
	brpl __sqrt1
	adiw r28,8
	rjmp __maxres
__sqrt1:
	push r20
	ldi  r20,66
	ldd  r24,y+6
	ldd  r27,y+5
	ldd  r26,y+4
__sqrt2:
	st   y,r24
	std  y+1,r25
	std  y+2,r26
	std  y+3,r27
	movw r30,r26
	movw r22,r24
	ldd  r26,y+4
	ldd  r27,y+5
	ldd  r24,y+6
	ldd  r25,y+7
	rcall __divf21
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	rcall __addf12
	rcall __unpack1
	dec  r23
	rcall __repack
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	eor  r26,r30
	andi r26,0xf8
	brne __sqrt4
	cp   r27,r31
	cpc  r24,r22
	cpc  r25,r23
	breq __sqrt3
__sqrt4:
	dec  r20
	breq __sqrt3
	movw r26,r30
	movw r24,r22
	rjmp __sqrt2
__sqrt3:
	pop  r20
	pop  r21
	adiw r28,8
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDD:
	ADIW R26,2
	RCALL __EEPROMRDW
	MOVW R22,R30
	SBIW R26,2

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
