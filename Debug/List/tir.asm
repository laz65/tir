
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 16,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

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
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
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
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	.DEF _a=R3
	.DEF _a_msb=R4
	.DEF _sum=R5
	.DEF _sum_msb=R6
	.DEF _m60=R7
	.DEF _m60_msb=R8
	.DEF _pm60=R9
	.DEF _pm60_msb=R10
	.DEF _m70=R11
	.DEF _m70_msb=R12
	.DEF _pm70=R13
	.DEF _pm70_msb=R14

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

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
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_seg:
	.DB  0x40,0x79,0x24,0x30,0x19,0x12,0x2,0x78
	.DB  0x0,0x10

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

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

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

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
	.ORG 0x300

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 04.12.2015
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega328P
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;
;#include <delay.h>
;
;// Declare your global variables here
;
;#define seg_a 1
;#define seg_b 2
;#define seg_c 4
;#define seg_d 8
;#define seg_e 16
;#define seg_f 32
;#define seg_g 64
;
;#define r_1 PORTB.0
;#define r_2 PORTB.1
;#define r_3 PORTB.2
;#define p_1 PINB.0
;#define p_2 PINB.1
;#define p_3 PINB.2
;
;flash unsigned char  seg[10] = {seg_g, seg_a+seg_d+seg_e+seg_f+seg_g, seg_c+seg_f, seg_e+seg_f, seg_a+seg_d+seg_e, seg_b ...
;unsigned int a, sum, m60, pm60, m70, pm70, m80, pm80, m90, pm90, m100, pm100;
;unsigned long timer, timer2;
;unsigned char kol;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0033 {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0034 // Place your code here
; 0000 0035 timer = timer + 1;
	LDS  R30,_timer
	LDS  R31,_timer+1
	LDS  R22,_timer+2
	LDS  R23,_timer+3
	__ADDD1N 1
	STS  _timer,R30
	STS  _timer+1,R31
	STS  _timer+2,R22
	STS  _timer+3,R23
; 0000 0036 timer2 = timer2 + 1;
	LDS  R30,_timer2
	LDS  R31,_timer2+1
	LDS  R22,_timer2+2
	LDS  R23,_timer2+3
	__ADDD1N 1
	STS  _timer2,R30
	STS  _timer2+1,R31
	STS  _timer2+2,R22
	STS  _timer2+3,R23
; 0000 0037 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
; .FEND
;
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 003E {
_read_adc:
; .FSTART _read_adc
; 0000 003F ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	STS  124,R30
; 0000 0040 // Delay needed for the stabilization of the ADC input voltage
; 0000 0041 delay_us(10);
	__DELAY_USB 53
; 0000 0042 // Start the AD conversion
; 0000 0043 ADCSRA|=(1<<ADSC);
	LDS  R30,122
	ORI  R30,0x40
	STS  122,R30
; 0000 0044 // Wait for the AD conversion to complete
; 0000 0045 while ((ADCSRA & (1<<ADIF))==0);
_0x3:
	LDS  R30,122
	ANDI R30,LOW(0x10)
	BREQ _0x3
; 0000 0046 ADCSRA|=(1<<ADIF);
	LDS  R30,122
	ORI  R30,0x10
	STS  122,R30
; 0000 0047 return ADCW;
	LDS  R30,120
	LDS  R31,120+1
	ADIW R28,1
	RET
; 0000 0048 }
; .FEND
;
;void vivod(int vhod)
; 0000 004B {
_vivod:
; .FSTART _vivod
; 0000 004C     if(timer < 100)
	ST   -Y,R27
	ST   -Y,R26
;	vhod -> Y+0
	RCALL SUBOPT_0x0
	__CPD2N 0x64
	BRSH _0x6
; 0000 004D     {
; 0000 004E         if (!p_1)
	SBIC 0x3,0
	RJMP _0x7
; 0000 004F         {
; 0000 0050             r_3 = 0;
	CBI  0x5,2
; 0000 0051             r_2 = 0;
	CBI  0x5,1
; 0000 0052             r_1 = 0;
	RCALL SUBOPT_0x1
; 0000 0053             PORTD = seg[vhod / 100];
	RCALL SUBOPT_0x2
; 0000 0054             r_1 = 1;
	SBI  0x5,0
; 0000 0055         }
; 0000 0056 
; 0000 0057     }
_0x7:
; 0000 0058     else
	RJMP _0x10
_0x6:
; 0000 0059     if(timer < 200)
	RCALL SUBOPT_0x0
	__CPD2N 0xC8
	BRSH _0x11
; 0000 005A     {
; 0000 005B         if (!p_2)
	SBIC 0x3,1
	RJMP _0x12
; 0000 005C         {
; 0000 005D             r_1 = 0;
	CBI  0x5,0
; 0000 005E             r_2 = 0;
	CBI  0x5,1
; 0000 005F             r_3 = 0;
	CBI  0x5,2
; 0000 0060             PORTD = seg[(vhod / 10) - (vhod/100)*10];
	RCALL SUBOPT_0x3
	MOVW R26,R30
	MOVW R30,R22
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x2
; 0000 0061             r_2 = 1;
	SBI  0x5,1
; 0000 0062         }
; 0000 0063 
; 0000 0064     }
_0x12:
; 0000 0065     else
	RJMP _0x1B
_0x11:
; 0000 0066     if(timer<300)
	RCALL SUBOPT_0x0
	__CPD2N 0x12C
	BRSH _0x1C
; 0000 0067     {
; 0000 0068         if (!p_3)
	SBIC 0x3,2
	RJMP _0x1D
; 0000 0069         {
; 0000 006A             r_2 = 0;
	CBI  0x5,1
; 0000 006B             r_3 = 0;
	CBI  0x5,2
; 0000 006C             r_1 = 0;
	RCALL SUBOPT_0x1
; 0000 006D             PORTD = seg[vhod  - (vhod/100)*100 - ((vhod / 10) - (vhod/100)*10)*10];
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12
	LD   R26,Y
	LDD  R27,Y+1
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x3
	MOVW R26,R22
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MULW12
	POP  R26
	POP  R27
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	RCALL SUBOPT_0x2
; 0000 006E             r_3 = 1;
	SBI  0x5,2
; 0000 006F         }
; 0000 0070 
; 0000 0071 
; 0000 0072     }
_0x1D:
; 0000 0073     else
	RJMP _0x26
_0x1C:
; 0000 0074     {
; 0000 0075         timer = 0;
	LDI  R30,LOW(0)
	STS  _timer,R30
	STS  _timer+1,R30
	STS  _timer+2,R30
	STS  _timer+3,R30
; 0000 0076     }
_0x26:
_0x1B:
_0x10:
; 0000 0077 }
	ADIW R28,2
	RET
; .FEND
;
;void main(void)
; 0000 007A {
_main:
; .FSTART _main
; 0000 007B // Declare your local variables here
; 0000 007C 
; 0000 007D // Crystal Oscillator division factor: 1
; 0000 007E #pragma optsize-
; 0000 007F CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0080 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0081 #ifdef _OPTIMIZE_SIZE_
; 0000 0082 #pragma optsize+
; 0000 0083 #endif
; 0000 0084 
; 0000 0085 // Input/Output Ports initialization
; 0000 0086 // Port B initialization
; 0000 0087 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0088 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(7)
	OUT  0x4,R30
; 0000 0089 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 008A PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 008B 
; 0000 008C // Port C initialization
; 0000 008D // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 008E DDRC=(0<<DDC6) | (1<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 008F // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0090 PORTC=(0<<PORTC6) | (0<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);
	LDI  R30,LOW(31)
	OUT  0x8,R30
; 0000 0091 
; 0000 0092 // Port D initialization
; 0000 0093 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0094 DDRD=(0<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(127)
	OUT  0xA,R30
; 0000 0095 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0096 PORTD=(0<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (1<<PORTD0);
	OUT  0xB,R30
; 0000 0097 
; 0000 0098 // Timer/Counter 0 initialization
; 0000 0099 // Clock source: System Clock
; 0000 009A // Clock value: 16000,000 kHz
; 0000 009B // Mode: Normal top=0xFF
; 0000 009C // OC0A output: Disconnected
; 0000 009D // OC0B output: Disconnected
; 0000 009E // Timer Period: 0,016 ms
; 0000 009F TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 00A0 TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(1)
	OUT  0x25,R30
; 0000 00A1 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00A2 OCR0A=0x00;
	OUT  0x27,R30
; 0000 00A3 OCR0B=0x00;
	OUT  0x28,R30
; 0000 00A4 
; 0000 00A5 
; 0000 00A6 // Timer/Counter 1 initialization
; 0000 00A7 // Clock source: System Clock
; 0000 00A8 // Clock value: Timer1 Stopped
; 0000 00A9 // Mode: Normal top=0xFFFF
; 0000 00AA // OC1A output: Disconnected
; 0000 00AB // OC1B output: Disconnected
; 0000 00AC // Noise Canceler: Off
; 0000 00AD // Input Capture on Falling Edge
; 0000 00AE // Timer1 Overflow Interrupt: Off
; 0000 00AF // Input Capture Interrupt: Off
; 0000 00B0 // Compare A Match Interrupt: Off
; 0000 00B1 // Compare B Match Interrupt: Off
; 0000 00B2 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	STS  128,R30
; 0000 00B3 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	STS  129,R30
; 0000 00B4 TCNT1H=0x00;
	STS  133,R30
; 0000 00B5 TCNT1L=0x00;
	STS  132,R30
; 0000 00B6 ICR1H=0x00;
	STS  135,R30
; 0000 00B7 ICR1L=0x00;
	STS  134,R30
; 0000 00B8 OCR1AH=0x00;
	STS  137,R30
; 0000 00B9 OCR1AL=0x00;
	STS  136,R30
; 0000 00BA OCR1BH=0x00;
	STS  139,R30
; 0000 00BB OCR1BL=0x00;
	STS  138,R30
; 0000 00BC 
; 0000 00BD // Timer/Counter 2 initialization
; 0000 00BE // Clock source: System Clock
; 0000 00BF // Clock value: Timer2 Stopped
; 0000 00C0 // Mode: Normal top=0xFF
; 0000 00C1 // OC2A output: Disconnected
; 0000 00C2 // OC2B output: Disconnected
; 0000 00C3 ASSR=(0<<EXCLK) | (0<<AS2);
	STS  182,R30
; 0000 00C4 TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (0<<WGM21) | (0<<WGM20);
	STS  176,R30
; 0000 00C5 TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	STS  177,R30
; 0000 00C6 TCNT2=0x00;
	STS  178,R30
; 0000 00C7 OCR2A=0x00;
	STS  179,R30
; 0000 00C8 OCR2B=0x00;
	STS  180,R30
; 0000 00C9 
; 0000 00CA // Timer/Counter 0 Interrupt(s) initialization
; 0000 00CB TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 00CC 
; 0000 00CD // Timer/Counter 1 Interrupt(s) initialization
; 0000 00CE TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);
	LDI  R30,LOW(0)
	STS  111,R30
; 0000 00CF 
; 0000 00D0 // Timer/Counter 2 Interrupt(s) initialization
; 0000 00D1 TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);
	STS  112,R30
; 0000 00D2 
; 0000 00D3 // External Interrupt(s) initialization
; 0000 00D4 // INT0: Off
; 0000 00D5 // INT1: Off
; 0000 00D6 // Interrupt on any change on pins PCINT0-7: Off
; 0000 00D7 // Interrupt on any change on pins PCINT8-14: Off
; 0000 00D8 // Interrupt on any change on pins PCINT16-23: Off
; 0000 00D9 EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  105,R30
; 0000 00DA EIMSK=(0<<INT1) | (0<<INT0);
	OUT  0x1D,R30
; 0000 00DB PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);
	STS  104,R30
; 0000 00DC 
; 0000 00DD // USART initialization
; 0000 00DE // USART disabled
; 0000 00DF UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	STS  193,R30
; 0000 00E0 
; 0000 00E1 // Analog Comparator initialization
; 0000 00E2 // Analog Comparator: Off
; 0000 00E3 // The Analog Comparator's positive input is
; 0000 00E4 // connected to the AIN0 pin
; 0000 00E5 // The Analog Comparator's negative input is
; 0000 00E6 // connected to the AIN1 pin
; 0000 00E7 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 00E8 // Digital input buffer on AIN0: On
; 0000 00E9 // Digital input buffer on AIN1: On
; 0000 00EA DIDR1=(0<<AIN0D) | (0<<AIN1D);
	LDI  R30,LOW(0)
	STS  127,R30
; 0000 00EB 
; 0000 00EC // ADC initialization
; 0000 00ED // ADC Clock frequency: 1000,000 kHz
; 0000 00EE // ADC Voltage Reference: AVCC pin
; 0000 00EF // ADC Auto Trigger Source: ADC Stopped
; 0000 00F0 // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
; 0000 00F1 // ADC4: On, ADC5: On
; 0000 00F2 DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
	STS  126,R30
; 0000 00F3 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	STS  124,R30
; 0000 00F4 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(132)
	STS  122,R30
; 0000 00F5 ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 00F6 
; 0000 00F7 
; 0000 00F8 // SPI initialization
; 0000 00F9 // SPI disabled
; 0000 00FA SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0x2C,R30
; 0000 00FB 
; 0000 00FC // TWI initialization
; 0000 00FD // TWI disabled
; 0000 00FE TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  188,R30
; 0000 00FF 
; 0000 0100 
; 0000 0101 // Global enable interrupts
; 0000 0102 #asm("sei")
	sei
; 0000 0103 
; 0000 0104         r_1 = 0;
	CBI  0x5,0
; 0000 0105         r_2 = 0;
	CBI  0x5,1
; 0000 0106         PORTD = 12;
	LDI  R30,LOW(12)
	OUT  0xB,R30
; 0000 0107         r_3 = 1;
	RCALL SUBOPT_0x4
; 0000 0108         timer2 = 0;
; 0000 0109         while (timer2 < 500000);
_0x2D:
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
	BRLO _0x2D
; 0000 010A         pm100 = read_adc(0);
	LDI  R26,LOW(0)
	RCALL _read_adc
	STS  _pm100,R30
	STS  _pm100+1,R31
; 0000 010B         pm90 = read_adc(1);
	LDI  R26,LOW(1)
	RCALL _read_adc
	STS  _pm90,R30
	STS  _pm90+1,R31
; 0000 010C         pm80 = read_adc(2);
	LDI  R26,LOW(2)
	RCALL _read_adc
	STS  _pm80,R30
	STS  _pm80+1,R31
; 0000 010D         pm70 = read_adc(3);
	LDI  R26,LOW(3)
	RCALL _read_adc
	__PUTW1R 13,14
; 0000 010E         pm60 = read_adc(4);
	LDI  R26,LOW(4)
	RCALL _read_adc
	__PUTW1R 9,10
; 0000 010F         PORTD = seg[0];
	LDI  R30,LOW(_seg*2)
	LDI  R31,HIGH(_seg*2)
	LPM  R0,Z
	OUT  0xB,R0
; 0000 0110         kol = 10;
	LDI  R30,LOW(10)
	STS  _kol,R30
; 0000 0111 while (1)
_0x30:
; 0000 0112       {
; 0000 0113       // Place your code here
; 0000 0114         m100 = read_adc(0);
	LDI  R26,LOW(0)
	RCALL _read_adc
	STS  _m100,R30
	STS  _m100+1,R31
; 0000 0115         m90 = read_adc(1);
	LDI  R26,LOW(1)
	RCALL _read_adc
	STS  _m90,R30
	STS  _m90+1,R31
; 0000 0116         m80 = read_adc(2);
	LDI  R26,LOW(2)
	RCALL _read_adc
	STS  _m80,R30
	STS  _m80+1,R31
; 0000 0117         m70 = read_adc(3);
	LDI  R26,LOW(3)
	RCALL _read_adc
	__PUTW1R 11,12
; 0000 0118         m60 = read_adc(4);
	LDI  R26,LOW(4)
	RCALL _read_adc
	__PUTW1R 7,8
; 0000 0119         if((pm100 - 2) > m100) a = 100; else pm100 = m100;
	LDS  R26,_pm100
	LDS  R27,_pm100+1
	SBIW R26,2
	LDS  R30,_m100
	LDS  R31,_m100+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x33
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	__PUTW1R 3,4
	RJMP _0x34
_0x33:
	LDS  R30,_m100
	LDS  R31,_m100+1
	STS  _pm100,R30
	STS  _pm100+1,R31
; 0000 011A         if((pm90 - 3) > m90) { if(a==100) a= 90; else a = 80; } else pm90 = m90;
_0x34:
	LDS  R26,_pm90
	LDS  R27,_pm90+1
	SBIW R26,3
	LDS  R30,_m90
	LDS  R31,_m90+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x35
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R30,R3
	CPC  R31,R4
	BRNE _0x36
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	RJMP _0x63
_0x36:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
_0x63:
	__PUTW1R 3,4
	RJMP _0x38
_0x35:
	LDS  R30,_m90
	LDS  R31,_m90+1
	STS  _pm90,R30
	STS  _pm90+1,R31
; 0000 011B         if((pm80 - 4) > m80) { if(a==80) a= 70; else a = 60; } else pm80 = m80;
_0x38:
	LDS  R26,_pm80
	LDS  R27,_pm80+1
	SBIW R26,4
	LDS  R30,_m80
	LDS  R31,_m80+1
	CP   R30,R26
	CPC  R31,R27
	BRSH _0x39
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CP   R30,R3
	CPC  R31,R4
	BRNE _0x3A
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP _0x64
_0x3A:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
_0x64:
	__PUTW1R 3,4
	RJMP _0x3C
_0x39:
	LDS  R30,_m80
	LDS  R31,_m80+1
	STS  _pm80,R30
	STS  _pm80+1,R31
; 0000 011C         if((pm70 - 5) > m70) { if(a==60) a= 50; else a = 40; } else pm70 = m70;
_0x3C:
	__GETW2R 13,14
	SBIW R26,5
	CP   R11,R26
	CPC  R12,R27
	BRSH _0x3D
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R30,R3
	CPC  R31,R4
	BRNE _0x3E
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP _0x65
_0x3E:
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
_0x65:
	__PUTW1R 3,4
	RJMP _0x40
_0x3D:
	__MOVEWRR 13,14,11,12
; 0000 011D         if((pm60 - 6) > m60) { if(a==40) a= 30; else a = 20; } else pm60 = m60;
_0x40:
	__GETW2R 9,10
	SBIW R26,6
	CP   R7,R26
	CPC  R8,R27
	BRSH _0x41
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CP   R30,R3
	CPC  R31,R4
	BRNE _0x42
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RJMP _0x66
_0x42:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
_0x66:
	__PUTW1R 3,4
	RJMP _0x44
_0x41:
	__MOVEWRR 9,10,7,8
; 0000 011E         if (a > 0)
_0x44:
	CLR  R0
	CP   R0,R3
	CPC  R0,R4
	BRSH _0x45
; 0000 011F         {
; 0000 0120             timer2 = 0;
	RCALL SUBOPT_0x7
; 0000 0121             while (timer2 < 150000) vivod(a);
_0x46:
	RCALL SUBOPT_0x5
	__CPD2N 0x249F0
	BRSH _0x48
	__GETW2R 3,4
	RCALL _vivod
	RJMP _0x46
_0x48:
; 0000 0122 sum += a;
	__ADDWRR 5,6,3,4
; 0000 0123             a = 0;
	CLR  R3
	CLR  R4
; 0000 0124             kol--;
	LDS  R30,_kol
	SUBI R30,LOW(1)
	STS  _kol,R30
; 0000 0125             r_1 = 0;
	RCALL SUBOPT_0x8
; 0000 0126             r_2 = 0;
; 0000 0127             PORTD = seg[kol];
; 0000 0128             r_3 = 1;
	RCALL SUBOPT_0x4
; 0000 0129             timer2 = 0;
; 0000 012A             while (timer2 < 10000);
_0x4F:
	RCALL SUBOPT_0x9
	BRLO _0x4F
; 0000 012B             if (kol == 0)
	LDS  R30,_kol
	CPI  R30,0
	BRNE _0x52
; 0000 012C             {
; 0000 012D                 r_3 = 0;
	CBI  0x5,2
; 0000 012E                 if (sum == 1000) sum = 999;
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CP   R30,R5
	CPC  R31,R6
	BRNE _0x55
	LDI  R30,LOW(999)
	LDI  R31,HIGH(999)
	__PUTW1R 5,6
; 0000 012F                 while (timer2 < 500000) vivod(sum);
_0x55:
_0x56:
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
	BRSH _0x58
	__GETW2R 5,6
	RCALL _vivod
	RJMP _0x56
_0x58:
; 0000 0130 sum = 0;
	CLR  R5
	CLR  R6
; 0000 0131                 r_1 = 0;
	RCALL SUBOPT_0x8
; 0000 0132                 r_2 = 0;
; 0000 0133                 PORTD = seg[kol];
; 0000 0134                 r_3 = 1;
	SBI  0x5,2
; 0000 0135                 kol = 10;
	LDI  R30,LOW(10)
	STS  _kol,R30
; 0000 0136                 timer2 = 0;
	RCALL SUBOPT_0x7
; 0000 0137                 while (timer2 < 10000);
_0x5F:
	RCALL SUBOPT_0x9
	BRLO _0x5F
; 0000 0138             }
; 0000 0139         }
_0x52:
; 0000 013A       }
_0x45:
	RJMP _0x30
; 0000 013B }
_0x62:
	RJMP _0x62
; .FEND
;

	.DSEG
_m80:
	.BYTE 0x2
_pm80:
	.BYTE 0x2
_m90:
	.BYTE 0x2
_pm90:
	.BYTE 0x2
_m100:
	.BYTE 0x2
_pm100:
	.BYTE 0x2
_timer:
	.BYTE 0x4
_timer2:
	.BYTE 0x4
_kol:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	LDS  R26,_timer
	LDS  R27,_timer+1
	LDS  R24,_timer+2
	LDS  R25,_timer+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	CBI  0x5,0
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	SUBI R30,LOW(-_seg*2)
	SBCI R31,HIGH(-_seg*2)
	LPM  R0,Z
	OUT  0xB,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3:
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R22,R30
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	SBI  0x5,2
	LDI  R30,LOW(0)
	STS  _timer2,R30
	STS  _timer2+1,R30
	STS  _timer2+2,R30
	STS  _timer2+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x5:
	LDS  R26,_timer2
	LDS  R27,_timer2+1
	LDS  R24,_timer2+2
	LDS  R25,_timer2+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	__CPD2N 0x7A120
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	STS  _timer2,R30
	STS  _timer2+1,R30
	STS  _timer2+2,R30
	STS  _timer2+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	CBI  0x5,0
	CBI  0x5,1
	LDS  R30,_kol
	LDI  R31,0
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	RCALL SUBOPT_0x5
	__CPD2N 0x2710
	RET


	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

;END OF CODE MARKER
__END_OF_CODE:
