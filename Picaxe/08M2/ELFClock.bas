#PICAXE 08M2
#NO_DATA

SYMBOL CLOCK      = C.2
SYMBOL LED        = C.0

SYMBOL SpeedLow   = Bit0
SYMBOL SpeedHigh  = Bit1
SYMBOL Speed      = B0
SYMBOL LastSpeed  = B14

SYMBOL PWMFlag    = Bit8

SYMBOL ClockDelay = W13

PowerOnReset:
	DirC.3 = 0
	DirC.4 = 0
	
	PULLUP  %1100
	SETFREQ M32
	
	ClockDelay = 125
	Speed      = 0
	LastSpeed  = 0
	PWMFlag    = 0
	
DO ; Main loop
	
	SpeedLow  = PinC.3
	SpeedHigh = PinC.4
	
	IF Speed <> LastSpeed THEN
		IF Speed = 0 THEN GOSUB SetSpeedSlow
		IF Speed = 1 THEN GOSUB SetSpeedFast
		IF Speed = 2 THEN GOSUB SetSpeed1M7
		IF Speed = 3 THEN GOSUB SetSpeed2M
		
		LastSpeed = Speed
	ENDIF
	
	IF PWMFlag = 0 THEN
		TOGGLE CLOCK
		PAUSE  ClockDelay
	ENDIF
	
LOOP ; End of main loop

SetSpeedSlow: ' *********************************

	SERTXD ("Set speed slow", CR, LF)
	
	IF PWMFlag = 1 THEN
		PWMOUT 2, OFF
		PWMFlag = 0
	ENDIF
	
	ClockDelay = 2000
	
	RETURN
	
SetSpeedFast: ' *********************************

	SERTXD ("Set speed fast", CR, LF)
	
	IF PWMFlag = 1 THEN
		PWMOUT 2, OFF
		PWMFlag = 0
	ENDIF
	
	ClockDelay = 500
	
	RETURN
	
SetSpeed1M7: ' **********************************

	SERTXD ("Set speed 1M7", CR, LF)
	
	PWMOUT 2,4,9
	PWMFlag = 1
	
	RETURN
	
SetSpeed2M: ' ***********************************

	SERTXD ("Set speed 2M", CR, LF)
	
	PWMOUT 2,3,8
	PWMFlag = 1
	
	RETURN
