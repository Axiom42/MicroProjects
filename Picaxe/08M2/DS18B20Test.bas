' ---- [ DS18B20Test.bas ] -----------------------
'
SYMBOL LED        = C.0
SYMBOL RHPower    = C.1
SYMBOL RHSense    = C.2
SYMBOL Thermo     = C.3
SYMBOL DS         = C.4

SYMBOL RHDuration = 1000

SYMBOL FlashPause = B13
SYMBOL FlashCount = B12
SYMBOL Counter    = B11
SYMBOL Flashes    = B10

SYMBOL RawTemp    = B9
SYMBOL FTemp      = B8

SYMBOL Whole      = B7
SYMBOL Fract      = B6

SYMBOL Pulses     = W0
SYMBOL RH_10      = W1

PowerOnReset:
	HIGH  LED
	PAUSE 2000
	LOW   LED
	
DO 'Main loop
	
	FlashPause = 100
	FlashCount = 20
	GOSUB Flash
	
	' READTEMP DS, RawTemp
	RawTemp = 10
	FTemp = RawTemp * 9 / 5 +32
	
	FlashPause = 500
	FlashCount = FTemp
	GOSUB Flash
	
	PAUSE 1000
	
	FlashPause = 100
	FlashCount = 20
	GOSUB Flash
		
LOOP ' End of main loop

Flash:
	Flashes = FlashCount / 10
	GOSUB DoFlash
	
	PAUSE FlashPause
	
	FlashPause = 500
	Flashes = FlashCount % 10
	GOSUB DoFlash
	
	RETURN
	
DoFlash:
	IF Flashes = 0 THEN
		Flashes = 1
		FlashPause = 100
	ENDIF
	
	FOR Counter = 1 to Flashes
		HIGH  LED
		PAUSE FlashPause
		LOW   LED
		PAUSE FlashPause
	NEXT Counter
	
	RETURN