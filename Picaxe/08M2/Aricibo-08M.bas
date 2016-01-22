' ---- [ Aricibo signal ] -----------------------
'
'
' Hardware requirements:
'    Standard download cable and resistors.
'    LED on output 0 connected so that HIGH
'       lights the LED.
' 
' Changes:
'	2016-01-20: Added variable to set pause
'			length.

SYMBOL byteCount = 80

SYMBOL pauseLength = 125

SYMBOL index = B13
SYMBOL bits  = B0
SYMBOL state = B2

SYMBOL LED = 0

EEPROM   0, (%00000010, %10101000, %00000000, %01010000, %01010000, %00010010, %00100010, %00100101)
EEPROM   8, (%10010101, %01010101, %01010010, %01000000, %00000000, %00000000, %00000000, %00000001)
EEPROM  16, (%10000000, %00000000, %00001101, %00000000, %00000000, %00011010, %00000000, %00000000)
EEPROM  24, (%01010100, %00000000, %00000000, %11111000, %00000000, %00000000, %00000000, %00000110)
EEPROM  32, (%00011100, %01100001, %10001000, %00000000, %00110010, %00011010, %00110001, %10000110)
EEPROM  40, (%10111110, %11111011, %11101111, %10000000, %00000000, %00000000, %00010000, %00000000)
EEPROM  48, (%00000100, %00000000, %00000000, %00000000, %00100000, %00000000, %00001111, %11000000)
EEPROM  56, (%00000001, %11110000, %00000000, %00000000, %00011000, %01100001, %11000110, %00100000)
EEPROM  64, (%00100000, %00001000, %01101000, %01100011, %10011010, %11111011, %11101111, %10111110)
EEPROM  72, (%00000000, %00000000, %00000000, %01000000, %11000000, %00010000, %00000001, %10000000)

PowerOnReset:
	LOW LED
	
DO ' main loop
	FOR index = 0 TO byteCount
		READ index, bits
		state = bit0
		GOSUB Flash
		
		state = bit1
		GOSUB Flash
		
		state = bit2
		GOSUB Flash
		
		state = bit3
		GOSUB Flash

		state = bit4
		GOSUB Flash
		
		state = bit5
		GOSUB Flash
		
		state = bit6
		GOSUB Flash
		
		state = bit7
		GOSUB Flash		
	NEXT
LOOP ' end of main loop

Flash:
	' Flashes the LED to send the bit value.
	' Total time for each flash is 1/4 second:
	'    1/4 second for a 0
	'    1/2 second for a 1
	'    1/4 second off to signal end of bit
	
	' High for 1/4 second.
	HIGH LED
	PAUSE pauseLength
	
	' If bit is 0 then turn LED off.
	' Delay for another 1/4 second.
	IF state = 0 THEN
		LOW LED
	ENDIF

	PAUSE pauseLength
	
	' Turn the LED off for 1/4 second
	' to complete the bit cycle.
	LOW LED
	PAUSE pauseLength
	
	RETURN