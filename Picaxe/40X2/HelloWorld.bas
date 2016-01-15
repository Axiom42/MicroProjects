' Hello world program for Picaxe 40X2

SYMBOL LED = B.7

HSERSETUP B9600_8, %00110

DO
	TOGGLE LED
	PAUSE 500
	
	HSEROUT 0, ("Hello!", CR, LF)
LOOP

END