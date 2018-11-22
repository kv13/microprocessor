.cseg 
AEM1: .db 0x38,0x35,0x30,0x38
AEM2: .db 0x39,0x30,0x32,0x39
.def MinAemH=r16
.def MinAemE=r17
.def MinAemD=r18
.def MinAemM=r19
.def MaxAemH=r20
.def MaxAemE=r21
.def MaxAemD=r22
.def MaxAemM=r23
.def temp=r24
.def temp2=r25
.include "8515def.inc"
LDI ZH,HIGH(AEM1<<1)
LDI ZL,LOW(AEM1<<1)
LPM
MOV MinAemH,R0
ADIW ZL,1
LPM
MOV MinAemE,R0
ADIW ZL,1
LPM
MOV MinAemD,R0
ADIW ZL,1
LPM
MOV MinAemM,R0
LDI ZH,HIGH(AEM2<<1)
LDI ZL,LOW(AEM2<<1)
LPM
MOV MaxAemH,R0
ADIW ZL,1
LPM
MOV MaxAemE,R0
ADIW ZL,1
LPM
MOV MaxAemD,R0
ADIW ZL,1
LPM
MOV MaxAemM,R0
SUBI MinAemH,48
SUBI MinAemE,48
SUBI MinAemD,48
SUBI MinAemM,48
SUBI MaxAemH,48
SUBI MaxAemE,48
SUBI MaxAemD,48
SUBI MaxAemM,48
CP MinAemM,MaxAemM
CPC MinAemD,MaxAemD
CPC MinAemE,MaxAemE
CPC MinAemH,MaxAemH
BRSH swapaem
BRLO calculations



swapaem:     ;ousiastika to 1o aem den einai mikrotero kai prepei na allaksw thesi sta 2 aem
MOV temp,MinAemM
MOV MinAemM,MaxAemM
MOV MaxAemM,temp
MOV temp,MinAemD
MOV MinAemD,MaxAemD
MOV MaxAemD,temp
MOV temp,MinAemE
MOV MinAemE,MaxAemE
MOV MaxAemE,temp
MOV temp,MinAemH
MOV MinAemH,MaxAemH
MOV MaxAemH,temp
rjmp calculations




calculations:
LDI R26,0B11111111
OUT DDRB,R26
;το προβλημα που ειχαμε στο εργαστηριο ηταν εδω .ΤΟ εφτιαξα ΟΠοτε τωρα ο κωδικας ειναι κομπλε
MOV temp,MinAemD
LSL temp
LSL temp
LSL temp
LSL temp
OR temp,MinAemM
COM temp
OUT PORTB,temp
MOV temp,MaxAemM
MOV temp2,MinAemM
ANDI temp,0b00000001
ORI temp2,0b11111110
COM temp2
LDI R31,$FE
ADD temp,R31
LSL temp
OR temp,temp2
OUT PORTB,temp
rjmp part2



part2:


LDI temp,0b11111111
out DDRB,temp
LDI temp2,0b00000000
out DDRD,temp2


loop:
IN R27,PIND;
;5 switches:11111110(0),11111101(1),11111011(2),11110111(3),01111111(7)
CPI R27, 0b11111110
BREQ sw0
CPI R27, 0b11111101
BREQ sw1
CPI R27, 0b11111011
BREQ sw2
CPI R27, 0b11110111
BREQ nearsw3
CPI R27, 0b01111111
BREQ nearsw7
rjmp loop


sw0:
MOV temp,MaxAemD
LSL temp
LSL temp
LSL temp
LSL temp
OR temp,MaxAemM
COM temp
OUT PORTB,temp 

LDI R26,203
LDI R27,236
LDI R28,133
L1:DEC R28
   BRNE L1
   DEC R27
   BRNE L1
   DEC R26
   BRNE L1
   nop
   
LDI temp,0b11111111
OUT PORTB,temp
rjmp loop


sw1:
MOV temp,MaxAemH
LSL temp
LSL temp
LSL temp
LSL temp
OR temp,MaxAemE
COM temp
OUT PORTB,temp
LDI R26,203
LDI R27,236
LDI R28,133
L2:
DEC R28
BRNE L1
DEC R27
BRNE L1
DEC R26
BRNE L1
nop


LDI temp ,0b11111111
OUT PORTB,temp
rjmp loop

nearsw3:rjmp sw3
nearsw7:rjmp sw7
sw2:
MOV temp,MinAemD
LSL temp
LSL temp
LSL temp
LSL temp
OR temp,MinAemM
COM temp 
OUT PORTB,temp
LDI R26,203
LDI R27,236
LDI R28,133
L3:DEC R28
   BRNE L3
   DEC R27
   BRNE L3
   DEC R26
   BRNE L3
   nop
LDI temp,0b11111111
OUT PORTB,temp
rjmp loop


sw3:
MOV temp,MinAemH
LSL temp
LSL temp
LSL temp
LSL temp
OR temp,MinAemE
COM temp
OUT PORTB,temp
LDI R26,203
LDI R27,236
LDI R28,133
L4:DEC R28
   BRNE L4
   DEC R27
   BRNE L4
   DEC R26
   BRNE L4
   nop
LDI temp,0b11111111
OUT PORTB,temp
rjmp loop


sw7:
MOV temp,MaxAemM
MOV temp2,MinAemM
ANDI temp,0b00000001
ORI temp2,0b11111110
COM temp2
LDI R31,$FE
ADD temp,R31
LSL temp
OR temp,temp2
OUT PORTB,temp
rjmp loop
