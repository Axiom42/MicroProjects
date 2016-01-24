' ----- [ FlashDisply.bas ] ---------------------
'

#NO_DATA

SYMBOL LED = C.0 

SYMBOL FlashCount = B13
SYMBOL FlashDelay = B12
SYMBOL Flashes    = B11
SYMBOL Counter    = B10

PowerOnReset:
	HIGH  LED
	PAUSE 2000
	LOW   LED
	
	FlashDelay = 250
	
DO ' Main loop

	Flashes = 50
	GOSUB Flash

	PAUSE 1000
	
LOOP ' End of main loop

Flash:
	FlashDelay = 250
	FlashCount = Flashes / 10
	GOSUB DoFlash
	
	PAUSE 500
	
	FlashDelay = 250	
	FlashCount = Flashes % 10
	GOSUB DoFlash
	
	RETURN

DoFlash:
	IF FlashCount = 0 THEN
		FlashCount = 4
		FlashDelay = 100
	ENDIF
	
	FOR Counter = 1 to FlashCount
		HIGH LED
		Pause FlashDelay
		LOW LED
		PAUSE FlashDelay
	NEXT Counter
	
	RETURN