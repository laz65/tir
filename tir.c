/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 04.12.2015
Author  : 
Company : 
Comments: 


Chip type               : ATmega328P
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega328p.h>

#include <delay.h>

// Declare your global variables here

#define seg_a 1
#define seg_b 2
#define seg_c 4
#define seg_d 8
#define seg_e 16
#define seg_f 32
#define seg_g 64

#define r_1 PORTB.0
#define r_2 PORTB.1
#define r_3 PORTB.2
#define p_1 PINB.0
#define p_2 PINB.1
#define p_3 PINB.2
#define sv PORTB.4

flash unsigned char  seg[10] = {seg_g, seg_a+seg_d+seg_e+seg_f+seg_g, seg_c+seg_f, seg_e+seg_f, seg_a+seg_d+seg_e, seg_b+seg_e, seg_b, seg_d+seg_e+seg_f+seg_g, 0, seg_e};
unsigned int a, sum, m60, pm60, m70, pm70, m80, pm80, m90, pm90, m100, pm100;
unsigned long timer, timer2;
unsigned char kol, tt1, tr2;
bit flag_zvuk, flag_vikl;
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here
timer = timer + 1;
timer2 = timer2 + 1;
}

// Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}


// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
// Place your code here
    if(!flag_zvuk)
    {
        OCR2A=0x80;
        flag_zvuk = 1;
        sv = 1; 
        tr2 = 201 - a*2;
    }
    else 
    {
        if(tt1++ > (2*a))
        {
            tt1 = 0;
            OCR2A=0xFF;  
            sv = 0;
            flag_vikl = 1;
        }                        
        if (flag_vikl) if (--tr2 == 0)
        {
                flag_vikl = 0;
                flag_zvuk = 0;
                tt1 = 0;
                sv = 1;
                OCR2A=0x80;
        }

    }

}




void vivod(int vhod)
{
    while(timer < 100);
        
        if (!p_1)  
        {     
            r_3 = 0;
            r_2 = 0;
            r_1 = 0;  
            PORTD = seg[vhod / 100];
            r_1 = 1;  
        }
            
    while(timer < 200);
    
        if (!p_2)  
        {     
            r_1 = 0;
            r_2 = 0;
            r_3 = 0;
            PORTD = seg[(vhod / 10) - (vhod/100)*10];
            r_2 = 1;
        }

    while(timer < 300);
    
        if (!p_3)  
        {     
            r_2 = 0;
            r_3 = 0;
            r_1 = 0;
            PORTD = seg[vhod  - (vhod/100)*100 - ((vhod / 10) - (vhod/100)*10)*10];
            r_3 = 1;
        }
    
        timer = 0;
}

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=(1<<CLKPCE);
CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (1<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (1<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 16000,000 kHz
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
// Timer Period: 0,016 ms
TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;


// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Fast PWM top=0xFF
// OC2A output: Inverted PWM
// OC2B output: Disconnected
ASSR=(0<<EXCLK) | (0<<AS2);
TCCR2A=(1<<COM2A1) | (1<<COM2A0) | (0<<COM2B1) | (0<<COM2B0) | (1<<WGM21) | (1<<WGM20);
TCCR2B=(0<<WGM22) | (1<<CS22) | (0<<CS21) | (0<<CS20);
//TCCR2B=(0<<WGM22) | (0<<CS22) | (1<<CS21) | (1<<CS20);
TCNT2=0x00;
OCR2A=0xFF;
OCR2B=0x00;


// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);

// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (0<<TOIE1);

// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (1<<TOIE2);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-14: Off
// Interrupt on any change on pins PCINT16-23: Off
EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
EIMSK=(0<<INT1) | (0<<INT0);
PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);

// USART initialization
// USART disabled
UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
// Digital input buffer on AIN0: On
// Digital input buffer on AIN1: On
DIDR1=(0<<AIN0D) | (0<<AIN1D);

// ADC initialization
// ADC Clock frequency: 1000,000 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: ADC Stopped
// Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
// ADC4: On, ADC5: On
DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (0<<ADC0D);
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);


// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);


// Global enable interrupts
#asm("sei")
        a = 0;
        r_1 = 0;
        r_2 = 0;
        r_3 = 0;    
        PORTD = 12;   
        r_3 = 1;    
        timer2 = 0;
        while (timer2 < 300000);        
        OCR2A=0xFF;
        a = 0;
        TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);//���� ������ 2          
        TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);                  
        r_3 = 0;
        pm100 = read_adc(0);
        pm90 = read_adc(1);
        pm80 = read_adc(2);
        pm70 = read_adc(3);
        r_3 = 1;
        pm60 = read_adc(4);
        PORTD = seg[0]; 
        sv = 0;                    
        kol = 10;
while (1)
      {
      // Place your code here  
        
        r_3 = 0;
        m100 = read_adc(0);
        m90 = read_adc(1);
        m80 = read_adc(2);
        m70 = read_adc(3);
        r_3 = 1;
        m60 = read_adc(4);    
        if((pm100 - 3) > m100) 
        {
           if((pm100 - 3) > read_adc(0)) a = 100;
        } 
        else 
        {
            if((pm100 + 3) < m100)
            { 
               if((pm100 + 3) < read_adc(0)) pm100 = m100;
            } else  pm100 = m100;
        }
        if((pm90 - 4) > m90)
        { 
            if((pm90 - 4) > read_adc(1)) if(a==100) a= 90; else a = 80; 
        } 
        else 
        {
            if((pm90 + 4) < m90)
            { 
               if((pm90 + 4) < read_adc(1)) pm90 = m90;
            } else  pm90 = m90;
        }
        if((pm80 - 5) > m80) 
        { 
            if((pm80 - 5) > read_adc(2)) if(a==80) a= 70; else a = 60; 
        } 
        else 
        {
            if((pm80 + 5) < m80)
            { 
               if((pm80 + 5) < read_adc(2)) pm80 = m80;
            } else  pm80 = m80;
        }
        if((pm70 - 6) > m70) 
        { 
            if((pm70 - 6) > read_adc(3)) if(a==60) a= 50; else a = 40; 
        } 
        else 
        {
            if((pm70 + 6) < m70)
            { 
               if((pm70 + 6) < read_adc(3)) pm70 = m70;
            } else pm70 = m70;
        }
        if((pm60 - 7) > m60) 
        { 
            if((pm60 - 7) > read_adc(4)) if(a==40) a= 30; else a = 20; 
        } 
        else 
        {
            if((pm60 + 7) < m60)
            { 
               if((pm60 + 7) < read_adc(4)) pm60 = m60;
            } else pm60 = m60;
        }   
        if (a > 0) 
        {   
            flag_zvuk = 0;
            tt1 = 0;    
            TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (1<<CS00);                        
            TCCR2B=(0<<WGM22) | (1<<CS22) | (0<<CS21) | (0<<CS20); // ��� ������ 2
            timer2 = 0;
            while (timer2 < 150000) vivod(a);    
            sum += a;
            a = 0; 
            kol--;              
            r_1 = 0;
            r_2 = 0;
            r_3 = 0;    
            PORTD = seg[kol];   
            r_3 = 1;    
            if (kol == 0) 
            {  
                TCCR2B=(0<<WGM22) | (0<<CS22) | (1<<CS21) | (1<<CS20);
                r_3 = 0;   
                a = (sum - 200) / 8;
                if (sum == 1000) sum = 999;
                timer2 = 0;   
                while (timer2 < 150000) vivod(sum);
                TCCR2B=(0<<WGM22) | (1<<CS22) | (0<<CS21) | (1<<CS20);
                while (timer2 < 300000) vivod(sum);
                sum = 0;    
                a = 0;
                r_1 = 0;
                r_2 = 0;
                PORTD = seg[kol];   
                r_3 = 1;    
                kol = 10;    
                timer2 = 0;   
            } 
            OCR2A=0xFF;
            TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (0<<CS20);//���� ������ 2  
            TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);   
            r_3 = 0;        
            pm100 = read_adc(0);
            pm90 = read_adc(1);
            pm80 = read_adc(2);
            pm70 = read_adc(3);
            r_3 = 1;            
            pm60 = read_adc(4);            
            sv = 0;                    
        }
      }
}

