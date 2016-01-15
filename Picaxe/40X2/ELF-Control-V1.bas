SYMBOL scratch01 = B55
SYMBOL scratch02 = B54

SYMBOL cmdHigh = B53
SYMBOL cmdLow  = B52

SYMBOL seconds = B15
SYMBOL mins    = B14
SYMBOL hour    = B13
SYMBOL day     = B12
SYMBOL date    = B11
SYMBOL month   = B10
SYMBOL year    = B9
SYMBOL control = B8

; HD44780 LCD commands:
SYMBOL D0 =   8	; Display off
SYMBOL D1 =  12	; Display on (cursor off)
SYMBOL DC =   1	; Display clear (cursor home)
SYMBOL C0 =  12	; Cursor off (display on)
SYMBOL C1 =  14	; Cursor on (no blink)
SYMBOL CB =  15	; Cursor blink
SYMBOL CH =   2	; Cursor home (display not cleared)
SYMBOL L1 =  16	; Cursor left one position
SYMBOL R1 =  20	; Cursor right one position
SYMBOL Q1 = 128	; Cursor at position 1 of line 1
SYMBOL Q2 = 136	; Cursor at position 9 of line 1
SYMBOL Q3 = 192	; Cursor at position 1 of line 2
SYMBOL Q4 = 200	; Cursor at position 9 of line 2

SYMBOL GRNLED = A.4
SYMBOL BLULED = A.5
SYMBOL REDLED = A.6
SYMBOL DPLOUT = A.7

PowerOnReset:
	HIGH BLULED
	HIGH GRNLED
	LOW  REDLED
	
	SETFREQ M16
	HSERSETUP B38400_16, %00000
	
	PAUSE 1000
	SEROUT DPLOUT, N4800_16, (D1,"       ", CH)
	PAUSE 50
	
	HSEROUT 0, ("DESK ELF)
	SEROUT DPLOUT, N4800_16, (Q1, "DESK Elf")
	PAUSE 50
	
	SEROUT DPLOUT, N4800_16, (Q3,"  Init  ")
	PAUSE 50
	
	PAUSE 3000
	
	GOSUB ResetMODE
	
MainLoop:



	GOTO MainLoop
	
LoadMODE:
	HIGH BLULED
	HIGH GRNLED
	LOW  REDLED
	
	SEROUT DPLOUT, N4800_16, (Q1, "  Load  ")
	PAUSE 50
	SEROUT DPLOUT, N4800_16, (Q3, "0000  00")
	PAUSE 50
	
	RETURN
	
ResetMODE:

	LOW  BLULED
	HIGH GRNLED
	HIGH REDLED
	
	SEROUT DPLOUT, N4800, (Q1, "  Reset ")
	PAUSE 50
	SEROUT DPLOUT, N4800, (Q3, "0000  00")
	PAUSE 50
		
	RETURN

RunMODE:

	HIGH BLULED
	LOW  GRNLED
	HIGH REDLED
	
	SEROUT DPLOUT, N4800, (Q1, "Running ")
	PAUSE 50
	SEROUT DPLOUT, N4800, (Q3, "0000  00")
	PAUSE 50
		
	RETURN	