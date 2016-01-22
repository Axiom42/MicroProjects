
#NO_DATA

SYMBOL Line0 = C.4
SYMBOL Line1 = C.1
SYMBOL Line2 = C.2

PowerOnReset:
	
DO ' Main loop

	GOSUB Light1
	PAUSE 250

LOOP ' End of main loop

Light1:
	GOSUB FloatPins
	LOW  Line1
	HIGH Line0
	
	RETURN
	
Light2:
	GOSUB FloatPins
	LOW   Line1
	HIGH  Line2
	
	RETURN
	
Light3:
	GOSUB FloatPins
	LOW  Line0
	HIGH Line1
	
	RETURN
	
Light4:
	GOSUB FloatPins
	LOW  Line2
	HIGH Line1
	
	RETURN
	
Light5: 
	GOSUB FloatPins
	LOW  Line0
	HIGH Line2
	
	RETURN
	
Light6:
	GOSUB FloatPins
	LOW  Line2
	HIGH Line0
	
	RETURN

FloatPins:
	INPUT Line0
	INPUT Line1
	INPUT Line2
	RETURN