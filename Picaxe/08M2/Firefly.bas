' ---- [ Electronic Fireflies ] -----------
' File...... FIREFLY.BAS
' Purpose... Electronic fireflies
' Author.... Chuck Bigham
' E-Mail.... chuck@puddlehaven.com
' WWW....... http://www.puddlehaven.com
' Started... 31 Oct 2007
' Updated... 

' Target PICAXE...
'#PICAXE 08M

' ---- [ Program Description ] ------------

' Based on the electronic fireflies code 
' developed by Bill Sherman and posted on
' his Web site:
'		 http://home.comcast.net/~botronics/
'
' I made two changes:
'    Rewrote the Blink subroutine to use
'    random numbers to decide on how many
'    times to flash the LEDs and for how
'    long as well as the which LEDs are lit.
'
'		 Made each LED pattern a branch call
'    that calls the Blink subroutine.
'
' My version is more random, and does not
' follow a fixed pattern when flashing the LEDs.
' On the breadboard the LEDs are too close
' together, hopefully if I get a chance to
' build it in a jar or at least move the LEDs
' off the breadboard it will look better.
'
' I also plan to add listen-only Serial Power 
' network routines so the fireflies will only 
' come on when the environmental sensor reports 
' that it is dark in the room. If I have 
' enough room I'll make the fireflies time
' sensitive as well, no sense having them come
' on when everyone is asleep. 

' ---- [ Revision History ] ---------------


'	31 Oct 2007 - First version, direct copy
'								of Bill Sherman's code.
'
'             - New blink routine and 
'							  random pattern selection.

'  1 Nov 2007 - Changed variable assignments
'               so there aren't any conflicts
'               with network stack.
'
'             - Started adding network stack.

' ---- [ Constants ] ----------------------

' Firefly variables.

SYMBOL RandomNumber = W3
SYMBOL RandomHigh   = B7
SYMBOL RandomLow    = B6

SYMBOL PWMLine  = B1
SYMBOL LowLine1 = B2
SYMBOL LowLine2 = B3

SYMBOL NumberOfLoops = B8

SYMBOL Counter   = B5
SYMBOL Timer     = W2
SYMBOL DutyCycle = B0

SYMBOL index = B5

SYMBOL TwoLineFlag = B4

' ---- [ Initialization ] -----------------

PowerOnReset:


	RandomNumber = 34567

' ---- [ Main Code ] ----------------------

Main:

	RANDOM RandomNumber
	
	' Select a random pattern to display.
	index = RandomLow % 6
	BRANCH index,(Pattern124, Pattern142, Pattern214, Pattern412, Pattern241, Pattern421)
	
	' Do it again forever.
	GOTO Main
	
' ---- [ Subroutines ] --------------------

' Pattern routines.

Pattern124:

	PWMLine  = 1
	LowLine1 = 2
	LowLine2 = 4
	
	GOSUB Blink

	GOTO Main
	
Pattern142:

	PWMLine  = 1
	LowLine1 = 4
	LowLine2 = 2

	GOSUB Blink

	GOTO Main
	
Pattern214:

	PWMLine  = 2
	LowLine1 = 1
	LowLine2 = 4

	GOSUB Blink

	GOTO Main
	
Pattern412:

	PWMLine  = 4
	LowLine1 = 1
	LowLine2 = 2

	GOSUB Blink

	GOTO Main
	
Pattern241:

	PWMLine  = 2
	LowLine1 = 4
	LowLine2 = 1

	GOSUB Blink

	GOTO Main
	
Pattern421: 

	PWMLine  = 4
	LowLine1 = 2
	LowLine2 = 1

	GOSUB Blink

	GOTO Main

' Makes the fireflies blink.	
Blink:

	' Number of flashes for this trip through the loop.
	RANDOM RandomNumber
	NumberOfLoops = RandomNumber % 3
	NumberOfLoops = NumberOfLoops + 1
	
	' Will this flash one or two LEDs?
	' Change the MOD number, only flashes 2 LEDs
	' when the remainder is 0. Right now it is
	' set to use 2 LEDs 25% of the time.
	RANDOM RandomNumber
	TwoLineFlag = RandomNumber % 2
	
	' Random duty cycle and fade time.
	RANDOM RandomNumber
	
	FOR Counter = 1 TO NumberOfLoops
		FOR DutyCycle = 0 TO RandomLow STEP 10
			PWM PWMLine, DutyCycle, 8
			LOW LowLine1
			IF TwoLineFlag = 0 THEN
				INPUT LowLine2
			ELSE
				LOW LowLine2
			ENDIF
		NEXT DutyCycle
		
		FOR DutyCycle = RandomHigh TO 0 STEP 10
			PWM PWMLine, DutyCycle, 2
			LOW LowLine1
			IF TwoLineFlag = 0 THEN
				INPUT LowLine2
			ELSE
				LOW LowLine2
			ENDIF
		NEXT DutyCycle
	NEXT Counter
	
	' Random wait time between patterns.
	RANDOM RandomNumber
	Timer = RandomNumber % 3
	Timer = Timer + 1
	Timer = Timer * 500
	PAUSE Timer

	RETURN
