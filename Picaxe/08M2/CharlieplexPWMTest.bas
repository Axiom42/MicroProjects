
#NO_DATA

SYMBOL RandomNumber = W3
SYMBOL RandomHigh   = B7
SYMBOL RandomLow    = B6

SYMBOL PWMLine  = B1
SYMBOL LowLine  = B2
SYMBOL LowLine2 = B3

SYMBOL NumberOfLoops = B8

SYMBOL Counter   = B5
SYMBOL Timer     = W2
SYMBOL DutyCycle = B0

SYMBOL index = B5

SYMBOL TwoLineFlag = B4

PowerOnReset:
	RandomNumber = 34567
	
DO
	RANDOM RandomNumber
	
	' Select a random pattern to display.
	index = RandomLow % 6
	SERTXD ("Branch to: ", #index, 13,10)
	ON index GOSUB Pattern124, Pattern142, Pattern214, Pattern412, Pattern241, Pattern421
	SERTXD ("Back from branch",13,10)
	
	' Do it again forever.
LOOP

Pattern124:
	SERTXD ("Pattern124", 13,10)
	PWMLine  = 1
	LowLine  = 2
	INPUT C.4
	
	GOSUB Blink
	SERTXD ("Back from blink",13,10)
	RETURN
	
Pattern142:
	SERTXD ("Pattern142", 13,10)
	PWMLine  = 1
	LowLine  = 4
	LowLine2 = 2
	
	GOSUB Blink
	SERTXD ("Back from blink",13,10)	
	RETURN
	
Pattern214:
	SERTXD ("Pattern214",13,10)
	PWMLine  = 2
	LowLine  = 1
	LowLine  = 4
	
	GOSUB Blink
	SERTXD ("Back from blink",13,10)
	RETURN
	
Pattern412:
	SERTXD ("Pattern412",13,10)
	PWMLine = 4
	LowLine = 1
	LowLine2 = 2
	
	GOSUB Blink
	SERTXD ("Back from blink",13,10)
	RETURN
	
Pattern241:
	SERTXD ("Pattern241", 13,10)
	PWMLine = 2
	LowLine = 4
	LowLine2 = 1
	
	GOSUB Blink
	SERTXD ("Back from blink",13,10)
	RETURN
	
Pattern421:
	SERTXD ("Pattern421", 13,10)
	PWMLine = 4
	LowLine = 2
	LowLine2 = 1
	
	GOSUB Blink
	SERTXD ("Back from blink",13,10)
	RETURN
	
Blink:
	' Number of flashes this time through the loop.
	RANDOM RandomNumber
	NumberOfLoops = RandomNumber % 4
	NumberOfLoops = NumberOfLoops + 1
	
	SERTXD ("Number of loops: ",#NumberOfLoops, 13,10)
	
	' Will this flash one or two LEDs.
	RANDOM RandomNumber
	TwoLineFlag = RandomNumber % 3
	
	' Random duty cycle and fade time.
	RANDOM RandomNumber
	
	FOR Counter = 1 TO NumberOfLoops
		SERTXD ("Loop number: ", #Counter, 13,10)
		
		FOR DutyCycle = 0 TO RandomLow STEP 10
			PWM PWMLine, DutyCycle, 8
			LOW LowLine
			IF TwoLineFlag = 0 THEN
				LOW LowLine2
			ELSE
				INPUT LowLine2
			ENDIF
		NEXT DutyCycle
		
		FOR DutyCycle = RandomHigh TO 0 STEP 10
			PWM PWMLine, DutyCycle, 2
			LOW LowLine
			IF TwoLineFlag = 0 THEN
				LOW LowLine2
			ELSE
				INPUT LowLine2
			ENDIF
		NEXT DutyCycle
	NEXT Counter
	
	' Random wait time between patterns.
	SERTXD ("Pausing",13,10)
	PAUSE 500
	
	RETURN
