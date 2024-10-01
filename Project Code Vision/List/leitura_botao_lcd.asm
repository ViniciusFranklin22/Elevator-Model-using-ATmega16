
;CodeVisionAVR C Compiler V2.05.0 Advanced
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 14,745600 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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
	.DEF _keys=R4
	.DEF _andar_elevador=R6
	.DEF _andar_atual=R8
	.DEF _controle_delay_parado=R10
	.DEF _proximo_andar=R12

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
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x0,0x0,0x1
_0x9:
	.DB  0x14
_0xA:
	.DB  0x80
_0xCC:
	.DB  0x0,0x0,0xFF,0xFF
_0x0:
	.DB  0xD,0xA,0x0,0x25,0x69,0x20,0x0,0xD
	.DB  0xA,0x41,0x6E,0x64,0x61,0x72,0x20,0x41
	.DB  0x74,0x75,0x61,0x6C,0x20,0x25,0x69,0x0
	.DB  0x44,0x69,0x73,0x74,0xE2,0x6E,0x63,0x69
	.DB  0x61,0x73,0x20,0x6F,0x72,0x64,0x65,0x6E
	.DB  0x61,0x64,0x61,0x73,0x20,0x65,0x20,0x73
	.DB  0x65,0x75,0x73,0x20,0x61,0x6E,0x64,0x61
	.DB  0x72,0x65,0x73,0x3A,0xA,0x0,0x44,0x69
	.DB  0x73,0x74,0xE2,0x6E,0x63,0x69,0x61,0x3A
	.DB  0x20,0x25,0x64,0x2C,0x20,0x41,0x6E,0x64
	.DB  0x61,0x72,0x3A,0x20,0x25,0x64,0xA,0x0
	.DB  0xD,0xA,0x41,0x72,0x72,0x61,0x79,0x20
	.DB  0x64,0x65,0x20,0x65,0x73,0x74,0x61,0x64
	.DB  0x6F,0x73,0x20,0x64,0x6F,0x73,0x20,0x73
	.DB  0x65,0x6E,0x73,0x6F,0x72,0x65,0x73,0x0
	.DB  0xD,0xA,0x41,0x72,0x72,0x61,0x79,0x20
	.DB  0x64,0x65,0x20,0x61,0x6E,0x64,0x61,0x72
	.DB  0x65,0x73,0x20,0x61,0x63,0x69,0x6F,0x6E
	.DB  0x61,0x64,0x6F,0x73,0x0,0xD,0xA,0x50
	.DB  0x72,0xF3,0x78,0x69,0x6D,0x6F,0x20,0x61
	.DB  0x6E,0x64,0x61,0x72,0x3A,0x20,0x25,0x69
	.DB  0xD,0xA,0x0,0x54,0x65,0x72,0x72,0x65
	.DB  0x6F,0x0,0x31,0xDF,0x20,0x61,0x6E,0x64
	.DB  0x61,0x72,0x0,0x32,0xDF,0x20,0x61,0x6E
	.DB  0x64,0x61,0x72,0x0,0xD,0xA,0x42,0x6F
	.DB  0x74,0xE3,0x6F,0x20,0x69,0x6E,0x74,0x65
	.DB  0x72,0x6E,0x6F,0x20,0x64,0x6F,0x20,0x65
	.DB  0x6C,0x65,0x76,0x61,0x64,0x6F,0x72,0x20
	.DB  0x70,0x72,0x65,0x73,0x73,0x69,0x6F,0x6E
	.DB  0x61,0x64,0x6F,0xD,0xA,0x0,0xD,0xA
	.DB  0x42,0x6F,0x74,0xE3,0x6F,0x20,0x65,0x78
	.DB  0x74,0x65,0x72,0x6E,0x6F,0x20,0x64,0x65
	.DB  0x20,0x63,0x68,0x61,0x6D,0x61,0x64,0x61
	.DB  0x20,0x64,0x6F,0x20,0x65,0x6C,0x65,0x76
	.DB  0x61,0x64,0x6F,0x72,0x20,0x70,0x72,0x65
	.DB  0x73,0x73,0x69,0x6F,0x6E,0x61,0x64,0x6F
	.DB  0xD,0xA,0x0,0xD,0xA,0x4E,0x65,0x6E
	.DB  0x68,0x75,0x6D,0x20,0x62,0x6F,0x74,0xE3
	.DB  0x6F,0x20,0x66,0x6F,0x69,0x20,0x70,0x72
	.DB  0x65,0x73,0x73,0x69,0x6F,0x6E,0x61,0x64
	.DB  0x6F,0xD,0xA,0x0,0xD,0xA,0x4E,0x65
	.DB  0x6E,0x68,0x75,0x6D,0x20,0x62,0x6F,0x74
	.DB  0xE3,0x6F,0x20,0x66,0x6F,0x69,0x20,0x70
	.DB  0x72,0x65,0x73,0x73,0x69,0x6F,0x6E,0x61
	.DB  0x64,0x6F,0xD,0xA,0x20,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2060060:
	.DB  0x1
_0x2060000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _key_pressed_counter_S0000004000
	.DW  _0x9*2

	.DW  0x01
	.DW  _column_S0000004000
	.DW  _0xA*2

	.DW  0x04
	.DW  0x0A
	.DW  _0xCC*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G103
	.DW  _0x2060060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

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
	LDI  R26,__SRAM_START
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
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Advanced
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : Leitura de botão e apresentação de informações no LCD
;Version : 1.0
;Date    : 02/09/2024
;Author  : Henrique Andrade Pancotti, Matheus Luiz Silva Felix, Vinicius Franklin
;Company : UFJF
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 14,745600 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// Alphanumeric LCD Module functions
;#include <alcd.h>
;
;// Standard Input/Output functions
;#include <string.h>
;#include <stdio.h>
;#include <delay.h>
;#include <stdlib.h>
;
;// PINA0..3 will be row inputs
;#define KEYIN PINA
;// PORTA4..7 will be column outputs
;#define KEYOUT PORTA
;#define FIRST_COLUMN 0x80
;#define LAST_COLUMN 0x10
;
;typedef unsigned char byte;
;// store here every key state as a bit,
;// bit 0 will be KEY0, bit 1 KEY1,...
;unsigned int keys;
;
;int andar_elevador;
;int andar_atual;
;int andares_acionados[3]; // Adaptar para 3 andares
;int fila_de_andares[3] = {0,1,0};

	.DSEG
;int controle_delay_parado = 0;
;int proximo_andar = -1;
;
;typedef struct {
;    int distancia;
;    int andar;
;} DistanciaAteAndar;
;
;void swap(DistanciaAteAndar *a, DistanciaAteAndar *b) {
; 0000 003B void swap(DistanciaAteAndar *a, DistanciaAteAndar *b) {

	.CSEG
; 0000 003C     DistanciaAteAndar temp;
; 0000 003D     temp = *a;
;	*a -> Y+6
;	*b -> Y+4
;	temp -> Y+0
; 0000 003E     *a = *b;
; 0000 003F     *b = temp;
; 0000 0040 }
;
;int partition(DistanciaAteAndar arr[], int low, int high) {
; 0000 0042 int partition(DistanciaAteAndar arr[], int low, int high) {
; 0000 0043     int pivot = arr[high].distancia; // Escolhe o valor do último elemento como pivô
; 0000 0044     int i = (low - 1); // Índice do menor elemento
; 0000 0045     int j;
; 0000 0046 
; 0000 0047     for (j = low; j < high; j++) {
;	arr -> Y+10
;	low -> Y+8
;	high -> Y+6
;	pivot -> R16,R17
;	i -> R18,R19
;	j -> R20,R21
; 0000 0048         if (arr[j].distancia < pivot) {
; 0000 0049             i++;
; 0000 004A             swap(&arr[i], &arr[j]); // Troca
; 0000 004B         }
; 0000 004C     }
; 0000 004D     swap(&arr[i + 1], &arr[high]); // Coloca o pivô na posição correta
; 0000 004E     return (i + 1);
; 0000 004F }
;
;void quickSort(DistanciaAteAndar arr[], int low, int high) {
; 0000 0051 void quickSort(DistanciaAteAndar arr[], int low, int high) {
; 0000 0052     if (low < high) {
;	arr -> Y+4
;	low -> Y+2
;	high -> Y+0
; 0000 0053         // Particiona o array e obtém o índice do pivô
; 0000 0054         int pi = partition(arr, low, high);
; 0000 0055 
; 0000 0056         // Ordena recursivamente os elementos antes e depois da partição
; 0000 0057         quickSort(arr, low, pi - 1);
;	arr -> Y+6
;	low -> Y+4
;	high -> Y+2
;	pi -> Y+0
; 0000 0058         quickSort(arr, pi + 1, high);
; 0000 0059     }
; 0000 005A }
;
;void qsort_custom(DistanciaAteAndar arr[], int n) {
; 0000 005C void qsort_custom(DistanciaAteAndar arr[], int n) {
; 0000 005D     quickSort(arr, 0, n - 1);
;	arr -> Y+2
;	n -> Y+0
; 0000 005E }
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0062 {
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0063 static byte key_pressed_counter=20;

	.DSEG

	.CSEG
; 0000 0064 static byte key_released_counter,column=FIRST_COLUMN;

	.DSEG

	.CSEG
; 0000 0065 static unsigned int row_data,crt_key;
; 0000 0066 // Reinitialize Timer 0 value
; 0000 0067 TCNT0=0x8D; // para 2ms
	LDI  R30,LOW(141)
	OUT  0x32,R30
; 0000 0068 // Place your code here
; 0000 0069 row_data<<=4;
	CALL SUBOPT_0x0
	CALL __LSLW4
	STS  _row_data_S0000004000,R30
	STS  _row_data_S0000004000+1,R31
; 0000 006A // get a group of 4 keys in in row_data
; 0000 006B row_data|=~KEYIN&0xf;
	IN   R30,0x19
	LDI  R31,0
	COM  R30
	COM  R31
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	LDS  R26,_row_data_S0000004000
	LDS  R27,_row_data_S0000004000+1
	OR   R30,R26
	OR   R31,R27
	STS  _row_data_S0000004000,R30
	STS  _row_data_S0000004000+1,R31
; 0000 006C column>>=1;
	LDS  R30,_column_S0000004000
	LDI  R31,0
	ASR  R31
	ROR  R30
	STS  _column_S0000004000,R30
; 0000 006D if (column==(LAST_COLUMN>>1))
	LDS  R26,_column_S0000004000
	CPI  R26,LOW(0x8)
	BRNE _0xB
; 0000 006E    {
; 0000 006F    column=FIRST_COLUMN;
	LDI  R30,LOW(128)
	STS  _column_S0000004000,R30
; 0000 0070    if (row_data==0) goto new_key;
	CALL SUBOPT_0x0
	SBIW R30,0
	BREQ _0xD
; 0000 0071    if (key_released_counter) --key_released_counter;
	LDS  R30,_key_released_counter_S0000004000
	CPI  R30,0
	BREQ _0xE
	SUBI R30,LOW(1)
	RJMP _0xC4
; 0000 0072    else
_0xE:
; 0000 0073       {
; 0000 0074       if (--key_pressed_counter==9) crt_key=row_data;
	LDS  R26,_key_pressed_counter_S0000004000
	SUBI R26,LOW(1)
	STS  _key_pressed_counter_S0000004000,R26
	CPI  R26,LOW(0x9)
	BRNE _0x10
	CALL SUBOPT_0x0
	STS  _crt_key_S0000004000,R30
	STS  _crt_key_S0000004000+1,R31
; 0000 0075       else
	RJMP _0x11
_0x10:
; 0000 0076          {
; 0000 0077          if (row_data!=crt_key)
	LDS  R30,_crt_key_S0000004000
	LDS  R31,_crt_key_S0000004000+1
	LDS  R26,_row_data_S0000004000
	LDS  R27,_row_data_S0000004000+1
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x12
; 0000 0078             {
; 0000 0079             new_key:
_0xD:
; 0000 007A             key_pressed_counter=10;
	LDI  R30,LOW(10)
	STS  _key_pressed_counter_S0000004000,R30
; 0000 007B             key_released_counter=0;
	LDI  R30,LOW(0)
	RJMP _0xC4
; 0000 007C             goto end_key;
; 0000 007D             };
_0x12:
; 0000 007E          if (!key_pressed_counter)
	LDS  R30,_key_pressed_counter_S0000004000
	CPI  R30,0
	BRNE _0x14
; 0000 007F             {
; 0000 0080             keys=row_data;
	__GETWRMN 4,5,0,_row_data_S0000004000
; 0000 0081             key_released_counter=20;
	LDI  R30,LOW(20)
_0xC4:
	STS  _key_released_counter_S0000004000,R30
; 0000 0082             };
_0x14:
; 0000 0083          };
_0x11:
; 0000 0084       };
; 0000 0085    end_key:;
; 0000 0086    row_data=0;
	LDI  R30,LOW(0)
	STS  _row_data_S0000004000,R30
	STS  _row_data_S0000004000+1,R30
; 0000 0087    };
_0xB:
; 0000 0088 // select next column, inputs will be with pull-up
; 0000 0089 KEYOUT=~column;
	LDS  R30,_column_S0000004000
	COM  R30
	OUT  0x1B,R30
; 0000 008A }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;unsigned inkey(void)
; 0000 008D {
_inkey:
; 0000 008E unsigned k;
; 0000 008F if (k=keys) keys=0;
	ST   -Y,R17
	ST   -Y,R16
;	k -> R16,R17
	MOVW R30,R4
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x15
	CLR  R4
	CLR  R5
; 0000 0090 return k;
_0x15:
	MOVW R30,R16
	RJMP _0x20C0005
; 0000 0091 }
;
;void init_keypad(void)
; 0000 0094 {
_init_keypad:
; 0000 0095 // PORT D initialization
; 0000 0096 // Bits 0..3 inputs
; 0000 0097 // Bits 4..7 outputs
; 0000 0098 DDRA=0xf0;
	LDI  R30,LOW(240)
	OUT  0x1A,R30
; 0000 0099 // Use pull-ups on bits 0..3 inputs
; 0000 009A // Output 1 on 4..7 outputs
; 0000 009B PORTA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 009C // Timer/Counter 0 initialization
; 0000 009D // Clock source: System Clock
; 0000 009E // Clock value: 57.600 kHz
; 0000 009F // Mode: Normal top=FFh
; 0000 00A0 // OC0 output: Disconnected
; 0000 00A1 //TCCR0=0x03;
; 0000 00A2 //INIT_TIMER0;
; 0000 00A3 TCCR0=0x04;
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0000 00A4 TCNT0=0x8D;
	LDI  R30,LOW(141)
	OUT  0x32,R30
; 0000 00A5 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 00A6 
; 0000 00A7 // External Interrupts are off
; 0000 00A8 //MCUCR=0x00;
; 0000 00A9 //EMCUCR=0x00;
; 0000 00AA // Timer 0 overflow interrupt is on
; 0000 00AB //TIMSK=0x02;
; 0000 00AC // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00AD TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 00AE #asm("sei")
	sei
; 0000 00AF }
	RET
;
;// Declare your global variables here
;// LCD display buffer
;char lcd_buffer[33];
;int estado_sensor_andares[8];
;
;// Passo atual do motor
;int step_number = 0;
;
;void atualiza_estado_sensores() {
; 0000 00B9 void atualiza_estado_sensores() {
_atualiza_estado_sensores:
; 0000 00BA     estado_sensor_andares[0] = PIND.0;
	LDI  R30,0
	SBIC 0x10,0
	LDI  R30,1
	LDI  R31,0
	STS  _estado_sensor_andares,R30
	STS  _estado_sensor_andares+1,R31
; 0000 00BB     estado_sensor_andares[1] = PIND.1;
	__POINTW2MN _estado_sensor_andares,2
	LDI  R30,0
	SBIC 0x10,1
	LDI  R30,1
	CALL SUBOPT_0x1
; 0000 00BC     estado_sensor_andares[2] = PIND.2;
	__POINTW2MN _estado_sensor_andares,4
	LDI  R30,0
	SBIC 0x10,2
	LDI  R30,1
	CALL SUBOPT_0x1
; 0000 00BD     estado_sensor_andares[3] = PIND.3;
	__POINTW2MN _estado_sensor_andares,6
	LDI  R30,0
	SBIC 0x10,3
	LDI  R30,1
	CALL SUBOPT_0x1
; 0000 00BE     estado_sensor_andares[4] = PIND.4;
	__POINTW2MN _estado_sensor_andares,8
	LDI  R30,0
	SBIC 0x10,4
	LDI  R30,1
	CALL SUBOPT_0x1
; 0000 00BF     estado_sensor_andares[5] = PIND.5;
	__POINTW2MN _estado_sensor_andares,10
	LDI  R30,0
	SBIC 0x10,5
	LDI  R30,1
	CALL SUBOPT_0x1
; 0000 00C0     estado_sensor_andares[6] = PIND.6;
	__POINTW2MN _estado_sensor_andares,12
	LDI  R30,0
	SBIC 0x10,6
	LDI  R30,1
	CALL SUBOPT_0x1
; 0000 00C1     estado_sensor_andares[7] = PIND.7;
	__POINTW2MN _estado_sensor_andares,14
	LDI  R30,0
	SBIC 0x10,7
	LDI  R30,1
	CALL SUBOPT_0x1
; 0000 00C2 }
	RET
;
;// Função para ordenar um array usando o algoritmo Bubble Sort
;void bubble_sort(int arr[], int n) {
; 0000 00C5 void bubble_sort(int arr[], int n) {
; 0000 00C6     int i, j, temp;
; 0000 00C7     for (i = 0; i < n - 1; i++) {
;	arr -> Y+8
;	n -> Y+6
;	i -> R16,R17
;	j -> R18,R19
;	temp -> R20,R21
; 0000 00C8         // Últimos i elementos já estão na posição correta
; 0000 00C9         for (j = 0; j < n - i - 1; j++) {
; 0000 00CA             // Troca se o elemento encontrado for maior do que o próximo elemento
; 0000 00CB             if (arr[j] > arr[j + 1]) {
; 0000 00CC                 temp = arr[j];
; 0000 00CD                 arr[j] = arr[j + 1];
; 0000 00CE                 arr[j + 1] = temp;
; 0000 00CF             }
; 0000 00D0         }
; 0000 00D1     }
; 0000 00D2 }
;
;void print_array(int array[], int size){
; 0000 00D4 void print_array(int array[], int size){
_print_array:
; 0000 00D5     int i;
; 0000 00D6     printf("\r\n");
	ST   -Y,R17
	ST   -Y,R16
;	array -> Y+4
;	size -> Y+2
;	i -> R16,R17
	CALL SUBOPT_0x2
; 0000 00D7     for(i = 0; i < size; i++) {
	__GETWRN 16,17,0
_0x1E:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x1F
; 0000 00D8         printf("%i ", array[i]);
	__POINTW1FN _0x0,3
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	CALL SUBOPT_0x3
; 0000 00D9         if(i == (size-1)){
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,1
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x20
; 0000 00DA             printf("\r\n");
	CALL SUBOPT_0x2
; 0000 00DB         }
; 0000 00DC     }
_0x20:
	__ADDWRN 16,17,1
	RJMP _0x1E
_0x1F:
; 0000 00DD }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
;
;unsigned identifica_andar_atual(){
; 0000 00DF unsigned identifica_andar_atual(){
_identifica_andar_atual:
; 0000 00E0     // Completar COLOCAR NAS PORTAS D
; 0000 00E1 
; 0000 00E2     int k;
; 0000 00E3 
; 0000 00E4     if(estado_sensor_andares[0]==1)
	ST   -Y,R17
	ST   -Y,R16
;	k -> R16,R17
	LDS  R26,_estado_sensor_andares
	LDS  R27,_estado_sensor_andares+1
	SBIW R26,1
	BRNE _0x21
; 0000 00E5             andar_atual =0;
	CLR  R8
	CLR  R9
; 0000 00E6     if(estado_sensor_andares[3]==1)
_0x21:
	__GETW1MN _estado_sensor_andares,6
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x22
; 0000 00E7             andar_atual = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
; 0000 00E8     if(estado_sensor_andares[2]==1)
_0x22:
	__GETW1MN _estado_sensor_andares,4
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x23
; 0000 00E9             andar_atual = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R8,R30
; 0000 00EA 
; 0000 00EB 
; 0000 00EC     printf("\r\nAndar Atual %i",andar_atual);
_0x23:
	__POINTW1FN _0x0,7
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R8
	CALL SUBOPT_0x3
; 0000 00ED     return andar_atual; // remover
	MOVW R30,R8
_0x20C0005:
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 00EE }
;
;void sobe_elevador(){
; 0000 00F0 void sobe_elevador(){
_sobe_elevador:
; 0000 00F1     PORTB.0 = 1;
	SBI  0x18,0
; 0000 00F2     PORTB.1 = 0;
	CBI  0x18,1
; 0000 00F3     PORTB.2 = 1;
	RJMP _0x20C0004
; 0000 00F4     PORTB.3 = 1;
; 0000 00F5     controle_delay_parado=1;
; 0000 00F6 }
;
;
;void desce_elevador(){
; 0000 00F9 void desce_elevador(){
_desce_elevador:
; 0000 00FA     PORTB.0 = 0;
	CBI  0x18,0
; 0000 00FB     PORTB.1 = 1;
	SBI  0x18,1
; 0000 00FC     PORTB.2 = 1;
_0x20C0004:
	SBI  0x18,2
; 0000 00FD     PORTB.3 = 1;
	SBI  0x18,3
; 0000 00FE     controle_delay_parado=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 00FF }
	RET
;
;void para_elevador(){
; 0000 0101 void para_elevador(){
_para_elevador:
; 0000 0102     andares_acionados[andar_atual] = 0;
	MOVW R30,R8
	LDI  R26,LOW(_andares_acionados)
	LDI  R27,HIGH(_andares_acionados)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
; 0000 0103     PORTB.0 = 0;
	CBI  0x18,0
; 0000 0104     PORTB.1 = 0;
	CBI  0x18,1
; 0000 0105     if(controle_delay_parado==1){
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0x38
; 0000 0106         PORTB.2 = 0;
	CBI  0x18,2
; 0000 0107         PORTB.3 = 0;
	CBI  0x18,3
; 0000 0108         delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x4
; 0000 0109         controle_delay_parado=0;
	CLR  R10
	CLR  R11
; 0000 010A     }
; 0000 010B 
; 0000 010C }
_0x38:
	RET
;
;int compareDistanciasAteAndares(const void *a, const void *b) {
; 0000 010E int compareDistanciasAteAndares(const void *a, const void *b) {
; 0000 010F     DistanciaAteAndar *elem1 = (DistanciaAteAndar *)a;
; 0000 0110     DistanciaAteAndar *elem2 = (DistanciaAteAndar *)b;
; 0000 0111     return elem1->distancia - elem2->distancia; // Comparação em ordem crescente
;	*a -> Y+6
;	*b -> Y+4
;	*elem1 -> R16,R17
;	*elem2 -> R18,R19
; 0000 0112 }
;
;void sortDistanciasAteAndares(int arr[], int n) {
; 0000 0114 void sortDistanciasAteAndares(int arr[], int n) {
; 0000 0115     int i;
; 0000 0116     DistanciaAteAndar *elements = malloc(n * sizeof(DistanciaAteAndar));
; 0000 0117 
; 0000 0118     // Preencher a estrutura com valores e índices
; 0000 0119     for (i = 0; i < n; i++) {
;	arr -> Y+6
;	n -> Y+4
;	i -> R16,R17
;	*elements -> R18,R19
; 0000 011A         elements[i].distancia = arr[i];
; 0000 011B         elements[i].andar = i;
; 0000 011C     }
; 0000 011D 
; 0000 011E     // Ordenar usando qsort
; 0000 011F     qsort_custom(elements, n);
; 0000 0120 
; 0000 0121     // Imprimir os valores ordenados e seus índices
; 0000 0122     printf("Distâncias ordenadas e seus andares:\n");
; 0000 0123 
; 0000 0124     for (i = 0; i < n; i++) {
; 0000 0125         printf("Distância: %d, Andar: %d\n", elements[i].distancia, elements[i].andar);
; 0000 0126     }
; 0000 0127 
; 0000 0128     // Liberar memória
; 0000 0129     free(elements);
; 0000 012A }
;
;void atualiza_fila_de_andares(char andares_acionados[], int fila[], int size) {
; 0000 012C void atualiza_fila_de_andares(char andares_acionados[], int fila[], int size) {
; 0000 012D     //int andar_atual = identifica_andar_atual();
; 0000 012E     int i;
; 0000 012F     int subtracoes_andares[3];
; 0000 0130 
; 0000 0131     for(i = 0; i<3; i++){
;	andares_acionados -> Y+12
;	fila -> Y+10
;	size -> Y+8
;	i -> R16,R17
;	subtracoes_andares -> Y+2
; 0000 0132         subtracoes_andares[i] = abs(andares_acionados[i]*(andar_atual-(andares_acionados[i]*i)));
; 0000 0133     }
; 0000 0134 
; 0000 0135     print_array(subtracoes_andares, sizeof(subtracoes_andares) / sizeof(subtracoes_andares[0]));
; 0000 0136 
; 0000 0137     sortDistanciasAteAndares(subtracoes_andares, (sizeof(subtracoes_andares) / sizeof(subtracoes_andares[0])));
; 0000 0138 
; 0000 0139     /*
; 0000 013A     bubble_sort(subtracoes_andares, 3);
; 0000 013B     printf("\r\nArray sub andares\r\n ");
; 0000 013C     print_array(subtracoes_andares, 3);
; 0000 013D 
; 0000 013E 
; 0000 013F     for(i = 0; i<3; i++) {
; 0000 0140         int resultado_atual = abs(subtracoes_andares[i]-andar_atual);
; 0000 0141         if (resultado_atual == andar_atual) fila[i] = 0;
; 0000 0142         else fila[i] = resultado_atual;
; 0000 0143     }
; 0000 0144 
; 0000 0145     if(fila[1] == 1 && fila[2] == 1)
; 0000 0146         fila[2]=3;
; 0000 0147 
; 0000 0148     print_array(fila, 3);
; 0000 0149     */
; 0000 014A }
;
;void define_proximo_andar() {
; 0000 014C void define_proximo_andar() {
_define_proximo_andar:
; 0000 014D     //int andar_atual = identifica_andar_atual();
; 0000 014E 
; 0000 014F     switch(andar_atual) {
	MOVW R30,R8
; 0000 0150         case 0:
	SBIW R30,0
	BRNE _0x49
; 0000 0151             if(andares_acionados[1] == 1){
	CALL SUBOPT_0x5
	BRNE _0x4A
; 0000 0152                 proximo_andar = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xC5
; 0000 0153                 sobe_elevador();
; 0000 0154             }
; 0000 0155             else if(andares_acionados[2] == 1){
_0x4A:
	CALL SUBOPT_0x6
	BRNE _0x4C
; 0000 0156                 proximo_andar = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
_0xC5:
	MOVW R12,R30
; 0000 0157                 sobe_elevador();
	RCALL _sobe_elevador
; 0000 0158                 //delay_ms(100);
; 0000 0159             }
; 0000 015A             break;
_0x4C:
	RJMP _0x48
; 0000 015B         case 1:
_0x49:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x4D
; 0000 015C             if(andares_acionados[0] == 1){
	LDS  R26,_andares_acionados
	LDS  R27,_andares_acionados+1
	SBIW R26,1
	BRNE _0x4E
; 0000 015D                 proximo_andar = 0;
	CLR  R12
	CLR  R13
; 0000 015E                 desce_elevador();
	RCALL _desce_elevador
; 0000 015F             }
; 0000 0160             else if(andares_acionados[2] == 1){
	RJMP _0x4F
_0x4E:
	CALL SUBOPT_0x6
	BRNE _0x50
; 0000 0161                 proximo_andar = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R12,R30
; 0000 0162                 sobe_elevador();
	RCALL _sobe_elevador
; 0000 0163                 //delay_ms(100);
; 0000 0164             }
; 0000 0165             break;
_0x50:
_0x4F:
	RJMP _0x48
; 0000 0166         case 2:
_0x4D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x48
; 0000 0167             if(andares_acionados[1] == 1){
	CALL SUBOPT_0x5
	BRNE _0x52
; 0000 0168                 proximo_andar = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
; 0000 0169                 desce_elevador();
	RJMP _0xC6
; 0000 016A             }
; 0000 016B             else if(andares_acionados[0] == 1){
_0x52:
	LDS  R26,_andares_acionados
	LDS  R27,_andares_acionados+1
	SBIW R26,1
	BRNE _0x54
; 0000 016C                 proximo_andar = 0;
	CLR  R12
	CLR  R13
; 0000 016D                 desce_elevador();
_0xC6:
	RCALL _desce_elevador
; 0000 016E             }
; 0000 016F             break;
_0x54:
; 0000 0170     };
_0x48:
; 0000 0171 }
	RET
;
;void verifica_chegada_andar_objetivo() {
; 0000 0173 void verifica_chegada_andar_objetivo() {
_verifica_chegada_andar_objetivo:
; 0000 0174     //int andar_atual = identifica_andar_atual();
; 0000 0175 
; 0000 0176     if(andar_atual == proximo_andar || proximo_andar == -1)
	__CPWRR 12,13,8,9
	BREQ _0x56
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0x55
_0x56:
; 0000 0177         para_elevador();
	RCALL _para_elevador
; 0000 0178 }
_0x55:
	RET
;
;void rotate_stepper_motor(int dir) {
; 0000 017A void rotate_stepper_motor(int dir) {
; 0000 017B     if (dir) {
;	dir -> Y+0
; 0000 017C         switch(step_number){
; 0000 017D             case 0:
; 0000 017E                 PORTB.1 = 1;
; 0000 017F                 PORTB.2 = 0;
; 0000 0180                 PORTB.3 = 0;
; 0000 0181                 PORTB.4 = 0;
; 0000 0182                 break;
; 0000 0183             case 1:
; 0000 0184                 PORTB.1 = 0;
; 0000 0185                 PORTB.2 = 1;
; 0000 0186                 PORTB.3 = 0;
; 0000 0187                 PORTB.4 = 0;
; 0000 0188                 break;
; 0000 0189             case 2:
; 0000 018A                 PORTB.1 = 0;
; 0000 018B                 PORTB.2 = 0;
; 0000 018C                 PORTB.3 = 1;
; 0000 018D                 PORTB.4 = 0;
; 0000 018E                 break;
; 0000 018F             case 3:
; 0000 0190                 PORTB.1 = 0;
; 0000 0191                 PORTB.2 = 0;
; 0000 0192                 PORTB.3 = 0;
; 0000 0193                 PORTB.4 = 1;
; 0000 0194                 break;
; 0000 0195         }
; 0000 0196     } else {
; 0000 0197         switch(step_number){
; 0000 0198             case 0:
; 0000 0199                 PORTB.1 = 0;
; 0000 019A                 PORTB.2 = 0;
; 0000 019B                 PORTB.3 = 0;
; 0000 019C                 PORTB.4 = 1;
; 0000 019D                 break;
; 0000 019E             case 1:
; 0000 019F                 PORTB.1 = 0;
; 0000 01A0                 PORTB.2 = 0;
; 0000 01A1                 PORTB.3 = 1;
; 0000 01A2                 PORTB.4 = 0;
; 0000 01A3                 break;
; 0000 01A4             case 2:
; 0000 01A5                 PORTB.1 = 0;
; 0000 01A6                 PORTB.2 = 1;
; 0000 01A7                 PORTB.3 = 0;
; 0000 01A8                 PORTB.4 = 0;
; 0000 01A9                 break;
; 0000 01AA             case 3:
; 0000 01AB                 PORTB.1 = 1;
; 0000 01AC                 PORTB.2 = 0;
; 0000 01AD                 PORTB.3 = 0;
; 0000 01AE                 PORTB.4 = 0;
; 0000 01AF                 break;
; 0000 01B0         }
; 0000 01B1     }
; 0000 01B2 }
;
;void main(void)
; 0000 01B5 {
_main:
; 0000 01B6 // Declare your local variables here
; 0000 01B7 unsigned int k;
; 0000 01B8 
; 0000 01B9 // Input/Output Ports initialization
; 0000 01BA // Port A initialization
; 0000 01BB // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01BC // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01BD PORTA=0x00;
;	k -> R16,R17
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 01BE DDRA=0x00;
	OUT  0x1A,R30
; 0000 01BF 
; 0000 01C0 // Port B initialization
; 0000 01C1 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 01C2 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 01C3 PORTB=0x00;
	OUT  0x18,R30
; 0000 01C4 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 01C5 
; 0000 01C6 // Port C initialization
; 0000 01C7 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01C8 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01C9 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 01CA DDRC=0x00;
	OUT  0x14,R30
; 0000 01CB 
; 0000 01CC // Port D initialization
; 0000 01CD // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01CE // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01CF PORTD=0x00;
	OUT  0x12,R30
; 0000 01D0 DDRD=0x00;
	OUT  0x11,R30
; 0000 01D1 
; 0000 01D2 // Timer/Counter 0 initialization
; 0000 01D3 // Clock source: System Clock
; 0000 01D4 // Clock value: 14745,600 kHz
; 0000 01D5 // Mode: Normal top=0xFF
; 0000 01D6 // OC0 output: Disconnected
; 0000 01D7 TCCR0=0x01;
	LDI  R30,LOW(1)
	OUT  0x33,R30
; 0000 01D8 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 01D9 OCR0=0x00;
	OUT  0x3C,R30
; 0000 01DA 
; 0000 01DB // Timer/Counter 1 initialization
; 0000 01DC // Clock source: System Clock
; 0000 01DD // Clock value: Timer1 Stopped
; 0000 01DE // Mode: Normal top=0xFFFF
; 0000 01DF // OC1A output: Discon.
; 0000 01E0 // OC1B output: Discon.
; 0000 01E1 // Noise Canceler: Off
; 0000 01E2 // Input Capture on Falling Edge
; 0000 01E3 // Timer1 Overflow Interrupt: Off
; 0000 01E4 // Input Capture Interrupt: Off
; 0000 01E5 // Compare A Match Interrupt: Off
; 0000 01E6 // Compare B Match Interrupt: Off
; 0000 01E7 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 01E8 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 01E9 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 01EA TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 01EB ICR1H=0x00;
	OUT  0x27,R30
; 0000 01EC ICR1L=0x00;
	OUT  0x26,R30
; 0000 01ED OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 01EE OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01EF OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01F0 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01F1 
; 0000 01F2 // Timer/Counter 2 initialization
; 0000 01F3 // Clock source: System Clock
; 0000 01F4 // Clock value: 14745,600 kHz
; 0000 01F5 // Mode: Fast PWM top=0xFF
; 0000 01F6 // OC2 output: Non-Inverted PWM
; 0000 01F7 ASSR=0x00;
	OUT  0x22,R30
; 0000 01F8 TCCR2=0x69;
	LDI  R30,LOW(105)
	OUT  0x25,R30
; 0000 01F9 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 01FA OCR2=200;
	LDI  R30,LOW(200)
	OUT  0x23,R30
; 0000 01FB 
; 0000 01FC // External Interrupt(s) initialization
; 0000 01FD // INT0: Off
; 0000 01FE // INT1: Off
; 0000 01FF // INT2: Off
; 0000 0200 MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0201 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0202 
; 0000 0203 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0204 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0205 
; 0000 0206 // USART initialization
; 0000 0207 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0208 // USART Receiver: On
; 0000 0209 // USART Transmitter: On
; 0000 020A // USART Mode: Asynchronous
; 0000 020B // USART Baud Rate: 19200
; 0000 020C UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 020D UCSRB=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 020E UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 020F UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0210 UBRRL=0x2F;
	LDI  R30,LOW(47)
	OUT  0x9,R30
; 0000 0211 
; 0000 0212 // Analog Comparator initialization
; 0000 0213 // Analog Comparator: Off
; 0000 0214 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0215 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0216 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0217 
; 0000 0218 // ADC initialization
; 0000 0219 // ADC disabled
; 0000 021A ADCSRA=0x00;
	OUT  0x6,R30
; 0000 021B 
; 0000 021C // SPI initialization
; 0000 021D // SPI disabled
; 0000 021E SPCR=0x00;
	OUT  0xD,R30
; 0000 021F 
; 0000 0220 // TWI initialization
; 0000 0221 // TWI disabled
; 0000 0222 TWCR=0x00;
	OUT  0x36,R30
; 0000 0223 
; 0000 0224 // Alphanumeric LCD initialization
; 0000 0225 // Connections specified in the
; 0000 0226 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0227 // RS - PORTC Bit 0
; 0000 0228 // RD - PORTC Bit 1
; 0000 0229 // EN - PORTC Bit 2
; 0000 022A // D4 - PORTC Bit 4
; 0000 022B // D5 - PORTC Bit 5
; 0000 022C // D6 - PORTC Bit 6
; 0000 022D // D7 - PORTC Bit 7
; 0000 022E // Characters/line: 16
; 0000 022F lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 0230 
; 0000 0231 // Global enable interrupts
; 0000 0232 #asm("sei")
	sei
; 0000 0233 //PORTD.7=1;// para apagar o led
; 0000 0234 init_keypad();
	RCALL _init_keypad
; 0000 0235 PORTC.3=1;
	SBI  0x15,3
; 0000 0236 
; 0000 0237 while (1)
_0xAA:
; 0000 0238     {
; 0000 0239         atualiza_estado_sensores();
	RCALL _atualiza_estado_sensores
; 0000 023A         printf("\r\nArray de estados dos sensores");
	__POINTW1FN _0x0,88
	CALL SUBOPT_0x7
; 0000 023B         print_array(estado_sensor_andares, 8);
	LDI  R30,LOW(_estado_sensor_andares)
	LDI  R31,HIGH(_estado_sensor_andares)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _print_array
; 0000 023C 
; 0000 023D         identifica_andar_atual();
	RCALL _identifica_andar_atual
; 0000 023E 
; 0000 023F 
; 0000 0240         printf("\r\nArray de andares acionados");
	__POINTW1FN _0x0,120
	CALL SUBOPT_0x7
; 0000 0241         print_array(andares_acionados, 3);
	LDI  R30,LOW(_andares_acionados)
	LDI  R31,HIGH(_andares_acionados)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _print_array
; 0000 0242 
; 0000 0243         define_proximo_andar();
	RCALL _define_proximo_andar
; 0000 0244         verifica_chegada_andar_objetivo();
	RCALL _verifica_chegada_andar_objetivo
; 0000 0245 
; 0000 0246 
; 0000 0247         printf("\r\nPróximo andar: %i\r\n", proximo_andar);
	__POINTW1FN _0x0,149
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R12
	CALL SUBOPT_0x3
; 0000 0248 
; 0000 0249         //printf("\r\nArray de fila de andares\r\n");
; 0000 024A         //atualiza_fila_de_andares(andares_acionados, fila_de_andares, 3);
; 0000 024B 
; 0000 024C         if (k=inkey())
	RCALL _inkey
	MOVW R16,R30
	SBIW R30,0
	BRNE PC+3
	JMP _0xAD
; 0000 024D         {
; 0000 024E             if (k >= 0x1000 && k <= 0x8000) {
	__CPWRN 16,17,4096
	BRLO _0xAF
	__CPWRN 16,17,-32767
	BRLO _0xB0
_0xAF:
	RJMP _0xAE
_0xB0:
; 0000 024F                 switch(k) {
	MOVW R30,R16
; 0000 0250                     case 0x8000:
	CPI  R30,LOW(0x8000)
	LDI  R26,HIGH(0x8000)
	CPC  R31,R26
	BRNE _0xB4
; 0000 0251                         sprintf(lcd_buffer, "Terreo");
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 0252                         andar_elevador = 0;
	CLR  R6
	CLR  R7
; 0000 0253                         andares_acionados[0] = 1;
	CALL SUBOPT_0xA
; 0000 0254                         break;
	RJMP _0xB3
; 0000 0255                     case 0x4000:
_0xB4:
	CPI  R30,LOW(0x4000)
	LDI  R26,HIGH(0x4000)
	CPC  R31,R26
	BRNE _0xB5
; 0000 0256                         sprintf(lcd_buffer, "1\xdf andar");
	CALL SUBOPT_0x8
	CALL SUBOPT_0xB
; 0000 0257                         andar_elevador = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R6,R30
; 0000 0258                         andares_acionados[1] = 1;
	__POINTW1MN _andares_acionados,2
	RJMP _0xC9
; 0000 0259                         break;
; 0000 025A                     case 0x2000:
_0xB5:
	CPI  R30,LOW(0x2000)
	LDI  R26,HIGH(0x2000)
	CPC  R31,R26
	BRNE _0xB3
; 0000 025B                         sprintf(lcd_buffer, "2\xdf andar");
	CALL SUBOPT_0x8
	CALL SUBOPT_0xC
; 0000 025C                         andar_elevador = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R6,R30
; 0000 025D                         andares_acionados[2] = 1;
	__POINTW1MN _andares_acionados,4
_0xC9:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 025E                         break;
; 0000 025F                     /*
; 0000 0260                     case 0x1000:
; 0000 0261                         sprintf(lcd_buffer, "3\xdf andar");
; 0000 0262                         andar_elevador = 3;
; 0000 0263                         andares_acionados[3] = 1;
; 0000 0264                         break;
; 0000 0265                     */
; 0000 0266                 }
_0xB3:
; 0000 0267                 printf("\r\nBotão interno do elevador pressionado\r\n");
	__POINTW1FN _0x0,196
	RJMP _0xCA
; 0000 0268             }
; 0000 0269             else if (k >= 0x1 && k <= 0x8) {
_0xAE:
	__CPWRN 16,17,1
	BRLO _0xB9
	__CPWRN 16,17,9
	BRLO _0xBA
_0xB9:
	RJMP _0xB8
_0xBA:
; 0000 026A                 switch(k) {
	MOVW R30,R16
; 0000 026B                     case 0x8:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xBE
; 0000 026C                         sprintf(lcd_buffer, "Terreo");
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 026D                         andares_acionados[0] = 1;
	CALL SUBOPT_0xA
; 0000 026E                         break;
	RJMP _0xBD
; 0000 026F                     case 0x4:
_0xBE:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xBF
; 0000 0270                         sprintf(lcd_buffer, "1\xdf andar");
	CALL SUBOPT_0x8
	CALL SUBOPT_0xB
; 0000 0271                         andares_acionados[1] = 1;
	__POINTW1MN _andares_acionados,2
	RJMP _0xCB
; 0000 0272                         break;
; 0000 0273                     case 0x2:
_0xBF:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xBD
; 0000 0274                         sprintf(lcd_buffer, "2\xdf andar");
	CALL SUBOPT_0x8
	CALL SUBOPT_0xC
; 0000 0275                         andares_acionados[2] = 1;
	__POINTW1MN _andares_acionados,4
_0xCB:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 0276                         break;
; 0000 0277                     /*
; 0000 0278                     case 0x1:
; 0000 0279                         sprintf(lcd_buffer, "3\xdf andar");
; 0000 027A                         andares_acionados[3] = 1;
; 0000 027B                         break;
; 0000 027C                     */
; 0000 027D                 }
_0xBD:
; 0000 027E                 printf("\r\nBotão externo de chamada do elevador pressionado\r\n");
	__POINTW1FN _0x0,238
	RJMP _0xCA
; 0000 027F             }
; 0000 0280             else
_0xB8:
; 0000 0281             {
; 0000 0282                 printf("\r\nNenhum botão foi pressionado\r\n");
	__POINTW1FN _0x0,291
_0xCA:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 0283             }
; 0000 0284             lcd_clear();
	RCALL _lcd_clear
; 0000 0285             lcd_gotoxy(3,1);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_gotoxy
; 0000 0286             lcd_puts(lcd_buffer);
	CALL SUBOPT_0x8
	RCALL _lcd_puts
; 0000 0287         }
; 0000 0288         else
	RJMP _0xC2
_0xAD:
; 0000 0289         {
; 0000 028A             printf("\r\nNenhum botão foi pressionado\r\n ");
	__POINTW1FN _0x0,324
	CALL SUBOPT_0x7
; 0000 028B         }
_0xC2:
; 0000 028C 
; 0000 028D         //rotate_stepper_motor(0);
; 0000 028E 
; 0000 028F         //step_number++;
; 0000 0290         //if(step_number > 3){
; 0000 0291         //    step_number = 0;
; 0000 0292         //}
; 0000 0293 
; 0000 0294         /*
; 0000 0295         printf("\r\nDIREÇÃO 1\r\n ");
; 0000 0296         sobe_elevador();
; 0000 0297         delay_ms(3000);
; 0000 0298         printf("\r\nDIREÇÃO 2\r\n ");
; 0000 0299         para_elevador();
; 0000 029A         delay_ms(3000);
; 0000 029B         printf("\r\nDIREÇÃO 3\r\n ");
; 0000 029C         desce_elevador();
; 0000 029D         */
; 0000 029E         delay_us(10);
	__DELAY_USB 49
; 0000 029F     }
	RJMP _0xAA
; 0000 02A0 }
_0xC3:
	RJMP _0xC3
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x15,4
	RJMP _0x2000005
_0x2000004:
	CBI  0x15,4
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x15,5
	RJMP _0x2000007
_0x2000006:
	CBI  0x15,5
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x15,6
	RJMP _0x2000009
_0x2000008:
	CBI  0x15,6
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x15,7
	RJMP _0x200000B
_0x200000A:
	CBI  0x15,7
_0x200000B:
	__DELAY_USB 10
	SBI  0x15,2
	__DELAY_USB 25
	CBI  0x15,2
	__DELAY_USB 25
	JMP  _0x20C0003
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 246
	JMP  _0x20C0003
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	CALL SUBOPT_0xD
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0xD
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	JMP  _0x20C0003
_0x2000013:
_0x2000010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,0
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x15,0
	JMP  _0x20C0003
_lcd_puts:
	ST   -Y,R17
_0x2000014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
	LDD  R17,Y+0
	JMP  _0x20C0002
_lcd_init:
	SBI  0x14,4
	SBI  0x14,5
	SBI  0x14,6
	SBI  0x14,7
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x4
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 369
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(133)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL __lcd_write_data
	RCALL _lcd_clear
	JMP  _0x20C0003

	.CSEG
_strlen:
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
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x20C0003:
	ADIW R28,1
	RET
_put_usart_G102:
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0xF
_0x20C0002:
	ADIW R28,3
	RET
_put_buff_G102:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2040012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0xF
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2040014
	CALL SUBOPT_0xF
_0x2040014:
_0x2040013:
	RJMP _0x2040015
_0x2040010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__print_G102:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R18,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	CALL SUBOPT_0x10
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R18,37
	BRNE _0x2040020
	CALL SUBOPT_0x10
	RJMP _0x20400C9
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2040021
	LDI  R16,LOW(1)
	RJMP _0x204001B
_0x2040021:
	CPI  R18,43
	BRNE _0x2040022
	LDI  R20,LOW(43)
	RJMP _0x204001B
_0x2040022:
	CPI  R18,32
	BRNE _0x2040023
	LDI  R20,LOW(32)
	RJMP _0x204001B
_0x2040023:
	RJMP _0x2040024
_0x204001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2040025
_0x2040024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040026
	ORI  R16,LOW(128)
	RJMP _0x204001B
_0x2040026:
	RJMP _0x2040027
_0x2040025:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x204001B
_0x2040027:
	CPI  R18,48
	BRLO _0x204002A
	CPI  R18,58
	BRLO _0x204002B
_0x204002A:
	RJMP _0x2040029
_0x204002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x204001B
_0x2040029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x204002F
	CALL SUBOPT_0x11
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x12
	RJMP _0x2040030
_0x204002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2040032
	CALL SUBOPT_0x11
	CALL SUBOPT_0x13
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2040033
_0x2040032:
	CPI  R30,LOW(0x70)
	BRNE _0x2040035
	CALL SUBOPT_0x11
	CALL SUBOPT_0x13
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2040036
_0x2040035:
	CPI  R30,LOW(0x64)
	BREQ _0x2040039
	CPI  R30,LOW(0x69)
	BRNE _0x204003A
_0x2040039:
	ORI  R16,LOW(4)
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x75)
	BRNE _0x204003C
_0x204003B:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x204003D
_0x204003C:
	CPI  R30,LOW(0x58)
	BRNE _0x204003F
	ORI  R16,LOW(8)
	RJMP _0x2040040
_0x204003F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2040071
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x204003D:
	SBRS R16,2
	RJMP _0x2040042
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2040043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2040043:
	CPI  R20,0
	BREQ _0x2040044
	SUBI R17,-LOW(1)
	RJMP _0x2040045
_0x2040044:
	ANDI R16,LOW(251)
_0x2040045:
	RJMP _0x2040046
_0x2040042:
	CALL SUBOPT_0x11
	CALL SUBOPT_0x14
_0x2040046:
_0x2040036:
	SBRC R16,0
	RJMP _0x2040047
_0x2040048:
	CP   R17,R21
	BRSH _0x204004A
	SBRS R16,7
	RJMP _0x204004B
	SBRS R16,2
	RJMP _0x204004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x204004D
_0x204004C:
	LDI  R18,LOW(48)
_0x204004D:
	RJMP _0x204004E
_0x204004B:
	LDI  R18,LOW(32)
_0x204004E:
	CALL SUBOPT_0x10
	SUBI R21,LOW(1)
	RJMP _0x2040048
_0x204004A:
_0x2040047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x204004F
_0x2040050:
	CPI  R19,0
	BREQ _0x2040052
	SBRS R16,3
	RJMP _0x2040053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2040054
_0x2040053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2040054:
	CALL SUBOPT_0x10
	CPI  R21,0
	BREQ _0x2040055
	SUBI R21,LOW(1)
_0x2040055:
	SUBI R19,LOW(1)
	RJMP _0x2040050
_0x2040052:
	RJMP _0x2040056
_0x204004F:
_0x2040058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x204005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x204005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x204005A
_0x204005C:
	CPI  R18,58
	BRLO _0x204005D
	SBRS R16,3
	RJMP _0x204005E
	SUBI R18,-LOW(7)
	RJMP _0x204005F
_0x204005E:
	SUBI R18,-LOW(39)
_0x204005F:
_0x204005D:
	SBRC R16,4
	RJMP _0x2040061
	CPI  R18,49
	BRSH _0x2040063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2040062
_0x2040063:
	RJMP _0x20400CA
_0x2040062:
	CP   R21,R19
	BRLO _0x2040067
	SBRS R16,0
	RJMP _0x2040068
_0x2040067:
	RJMP _0x2040066
_0x2040068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2040069
	LDI  R18,LOW(48)
_0x20400CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x204006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x12
	CPI  R21,0
	BREQ _0x204006B
	SUBI R21,LOW(1)
_0x204006B:
_0x204006A:
_0x2040069:
_0x2040061:
	CALL SUBOPT_0x10
	CPI  R21,0
	BREQ _0x204006C
	SUBI R21,LOW(1)
_0x204006C:
_0x2040066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2040059
	RJMP _0x2040058
_0x2040059:
_0x2040056:
	SBRS R16,0
	RJMP _0x204006D
_0x204006E:
	CPI  R21,0
	BREQ _0x2040070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x12
	RJMP _0x204006E
_0x2040070:
_0x204006D:
_0x2040071:
_0x2040030:
_0x20400C9:
	LDI  R17,LOW(0)
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x15
	SBIW R30,0
	BRNE _0x2040072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0001
_0x2040072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x15
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL SUBOPT_0x16
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G102
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL SUBOPT_0x16
	LDI  R30,LOW(_put_usart_G102)
	LDI  R31,HIGH(_put_usart_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G102
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_andares_acionados:
	.BYTE 0x6
_key_pressed_counter_S0000004000:
	.BYTE 0x1
_key_released_counter_S0000004000:
	.BYTE 0x1
_column_S0000004000:
	.BYTE 0x1
_row_data_S0000004000:
	.BYTE 0x2
_crt_key_S0000004000:
	.BYTE 0x2
_lcd_buffer:
	.BYTE 0x21
_estado_sensor_andares:
	.BYTE 0x10
_step_number:
	.BYTE 0x2
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G103:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDS  R30,_row_data_S0000004000
	LDS  R31,_row_data_S0000004000+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1:
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	__GETW1MN _andares_acionados,2
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	__GETW1MN _andares_acionados,4
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	__POINTW1FN _0x0,171
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _andares_acionados,R30
	STS  _andares_acionados+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	__POINTW1FN _0x0,178
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	__POINTW1FN _0x0,187
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _sprintf
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL __lcd_write_nibble_G100
	__DELAY_USW 369
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x10:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x12:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xE66
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
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

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
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
