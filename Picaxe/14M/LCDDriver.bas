' *** LCDdriver.bas **************** 2009.03.17 **************** Ron Hackett ***
'
' 	This program runs on a Picaxe-14M @ 8 MHz. It receives serial data from
'	the master processor & displays it on an HD44780-type LCD (16X2 OR 8X2).
'	Because we are using DB5..DB2 rather than DB7..DB4, high nibbles need to
'	be divided by 4 & low nibbles multiplied by 4 to place on correct pins.
'
'	Program may appear crude, but it is fast. By dedicating 9 variables to
' 	the reception of serial data, it avoids the necessity of requiring the
'	master processor to delay between the transmission of each character.
'
' NOTE:
' 	In order for the LCD to function correctly, the master processor must
'	send serial data in "packets" of nine characters. The first char must
'	be a command that specifies the display location at which printing
'	should begin. The remaining 8 characters can be text or commands.


' *** Constants *********

	symbol baud   = input0			' used to set Baud (hi=4800/lo=2400)
	symbol hi     = 1					' used to set Baud (hi=4800/lo=2400)
	symbol cmd    = 0					' used to set up for cmd/txt byte		
	symbol txt    = 1					' used to set up for cmd/txt byte
	symbol enable = 1					' LCD enable pin = PICAXE output1
	symbol RSin   = outpin0			' LCD RegSel pin = PICAXE output0


' *** Variables *********

	symbol char  = b10				' character to be sent to LCD
	symbol index = b11				' used as counter in For-Next loops
	symbol RSbit = b12				' used to set  for cmd/txt byte
	symbol temp  = b13				' used to manipulate char


' *** Directives ********

	#com4							' AXE027 Green cable
	#picaxe14M						' set compiler mode


' *** Begin Main Program *******************************************************

setfreq m8
gosub Init

do
	if baud = hi then	
		serin 4,N4800_8,b0,b1,b2,b3,b4,b5,b6,b7,b8
	else		
		serin 4,N2400_8,b0,b1,b2,b3,b4,b5,b6,b7,b8
	endif

	char = b0
	gosub OutByte

	char = b1
	gosub OutByte

	char = b2
	gosub OutByte

	char = b3
	gosub OutByte

	char = b4
	gosub OutByte

	char = b5
	gosub OutByte

	char = b6
	gosub OutByte

	char = b7
	gosub OutByte

	char = b8
	gosub OutByte
loop


' *** End Main Program - Subroutines Follow ************************************


' *** Init Subroutine ***
Init:
	pins =  0							' clear all output lines
	pause 200							' pause 200 mS for LCD initialization

	pins = 12							' (48/4=12) set to 4-bit operation
 	pulsout enable,1					' send data
	pause 10								' pause 10 mS

	pulsout enable,1					' send again
	pulsout enable,1					' send again (necessary in 4-bit mode)

	pins =  8							' (32/4=8) set to 4-bit operation
	pulsout enable,1					' send data.
	pulsout enable,1					' send again (necessary in 4-bit mode)

	pins = 32							' (128/4=32) set to 2 line operation

	pulsout enable,1					' send data

	char = 12							' turn off cursor
	gosub OutByte						' send instruction to LCD

	return


' *** OutByte Subroutine ***

OutByte:
	if char<32 OR char>127 then
		 RSbit = cmd					' set up for command byte
	else
		 RSbit = txt					' set up for text byte
	endif

	temp = char / 4					' because we're using DB5...DB2
	temp = temp & %00111100			' mask for  DB5...DB2
	pins = temp							' place high nibble of char onto pins
	RSin = RSbit						' RSin = 0 for command or 1 for text
	pulsout enable,1					' send data

	temp = char * 4					' because we're using DB5...DB2
	temp = temp & %00111100			' mask for  DB5...DB2
	pins = temp							' place low nibble of char onto pins
	RSin = RSbit						' RSin = 0 for command or 1 for text
	pulsout enable,1					' send data

	return
