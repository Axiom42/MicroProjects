' ---- [ Membership Card Interface ]---------------------------------------------
' File...... MCInterface.bas
' Purpose... Interface between Membership Card and PC
' Author.... Chuck Bigham
' E-Mail.... chuck@bramblyhill.com
' WWW....... http://www.bramblyhill.com
' Started... 01 October 2010
' Updated... 

' Target PICAXE...
#PICAXE 20X2

' This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 
' Unported License. To view a copy of this license, visit 
' http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to 
' Creative Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.


' ---- [ Program Description ] --------------------------------------
' Interface between a serial only PC, like my laptop, and 
' Lee Hart's Membership Card ELF class computer.

' ---- [ Revision History ] ---------------
' 2010-10-01: First draft of application. Bench testing with LEDs.
' 2010-10-17: Refactoring and clean up. 
' 2010-11-02: Updated after testing with Membership Card hardware.
' 2011-02-05: Releasing to the Web.
' 2016-01-14: Adding to GitHub library.

' ---- [ Constants ] ------------------------------------------------

' Constants to identify the mode that the Memberhip Card is in.
symbol ModeRESET = 0
symbol ModeLOAD  = 1
symbol ModeRUN   = 2
	

' 20X2		DB25
' ID   Pin	Pin	Desc
' C.3  7	17	SELECTIN
' C.5  5	14	AUTOFEED
' C.4  6	16	INIT
' C.7  3	 1	STROBE
' C.6  4	15	ERROR
'
' B.0 18	 2	D0
' B.1 17	 3	D1
' B.2 16	 4	D2
' B.3 15	 5	D3
' B.4 14	 6	D4
' B.5 13	 7	D5
' B.6 12	 8	D6
' B.7 11	 9	D7

' Constants to identify the port C pins that are used to communicate
' with the Membership Card. The comment after each identifies the
' standard parallel port pin.
SYMBOL MP    = C.3	; SELECTIN -- active LOW
SYMBOL LOAD  = C.5	; AUTOFEED -- active LOW
SYMBOL CLR   = C.4	; INIT     -- active HIGH
SYMBOL INP   = C.7	; STROBE   -- active LOW
SYMBOL Q     = C.6  ; ERROR    -- active HIGH
        
' ---- [ Variables ] ------------------------------------------------

' The data byte to be sent to the Membership Card.
SYMBOL outByte    = B5

' The data byte read from the Membership Card.
SYMBOL inByte     = B6

' Index into the table to convert from a hex value to the ASCII
' value of the hex character (0 to 48, for example).
SYMBOL index      = B7

' First character received over the serial port. Represents the first
' character of a command or the high nibble of the byte to send to
' the Membership card.
SYMBOL highNibble = B8

' Second character received over the serial port. Represents the
' second character of a command or the low nibble of the byte to send
' to the Membership Card.
SYMBOL lowNibble  = B9

' Utility variable used when converting from the ASCII representation
' of a hex value to the binary representation of the hex value.
SYMBOL hexByte    = B10

' The current operating mode of the Membership Card. One of the 
' Mode* values.
SYMBOL elfMode    = B11

' The time, in milliseconds, to pause between setting and resetting
' the INP line when issuing and automatic INP press. Gives the 
' Membership Card time to react to the INP press.
SYMBOL inpPause   = B12

' ---- [ EEPROM Data ] ----------------------------------------------

' Conversion table from hex value to the ASCII character.
'          0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
DATA 00, (48,49,50,51,52,53,54,55,56,57,65,66,67,68,69,70)

' ---- [ Initialization ] -------------------------------------------

PowerOnReset:

; All pins on port B are outputs to start.
	dirsB = %11111111

; Setup inputs and outputs on port C .
	dirsC = %10111000

; Default pause after setting the INP line. 	
	inpPause = 125
	HIGH INP
	
; Reset the Membership Card so that it's in a known state.
	GOSUB ResetMode
  	GOSUB MemoryProtect ; see note in MemoryProtect subroutine.
	
' ---- [ Main Code ] ------------------------------------------------

MainLoop:

  ' Read two characters from the serial port.
	SERRXD HighNibble, LowNibble
	
  ' Decode the first character to determine if it's a command.
	IF HighNibble = "R" THEN
		GOSUB ResetMode
	ELSE IF HighNibble = "L" THEN
		GOSUB LoadMode
	ELSE IF HighNibble = "G" THEN
	 	GOSUB RunMode
	ELSE IF HighNibble = "M" THEN
		GOSUB MemoryProtect
	ELSE IF HighNibble = "I" THEN
		GOSUB InputSwitch
	ELSE
    ' It's not a command, so convert from ASCII to binary.
		GOSUB HexToBinary
		
    ' Send the binary value to the Membership Card.
		outByte = HighNibble + LowNibble
		outpinsB = outByte
		
    ' If the Membership card is in LOAD mode, set and reset the INP
    ' line to store the byte on the data bus into memory. This makes
    ' sending data via a terminal program easier; otherwise a command
    ' to set and reset the INP line would be required after each 
    ' byte was sent to the Membership Card.
		IF elfMode = ModeLOAD THEN
			TOGGLE INP
			PAUSE inpPause
			TOGGLE INP
		ENDIF
	ENDIF
	
  ; Repeat it forever.
	GOTO MainLoop


' ---- [ Subroutines ] ----------------------------------------------

' The next three subroutines are used to set the operating mode of
' the Membership Card. The subroutine sets the control lines, sets
' the elfMode variable to indicate which mode the Membership Card is
' in, and then sends a response to the PC to indicate the mode change
' has taken place.

' Put the Membership Card is reset mode.
ResetMode:
	LOW CLR
	HIGH LOAD
	elfMode = ModeRESET
	SERTXD ("RESET",CR,LF)
	SERTXD ("MP",CR,LF)
	RETURN
	
' Put the Membership Card in load mode.
' If the Membership Card is running when this subroutine is called,
' the Membership Card is first reset. 
LoadMode:
	IF elfMode = ModeRUN THEN
		GOSUB ResetMode
	ENDIF
	
	LOW LOAD
	elfMode = ModeLOAD
	SERTXD ("LOADING",CR,LF)
	RETURN
	
' Put the Membership Card in run mode.
' If the Membership Card is loading when this subroutine is called,
' the Membership Card is first reset.
RunMode:
	IF elfMode = ModeLOAD THEN
		GOSUB ResetMode
	ENDIF 
	
	HIGH CLR
	elfMode = ModeRUN
	SERTXD ("RUNNING",CR,LF)
	RETURN

' End of mode subroutines.

' Other utility subroutines.
	
' Puts the Membership Card memory in read/write or read/only mode.
' 
' NOTE: The Membership Card memory is set to write ONLY if the low
'       nibble of the command is set to "W". That makes it harder to
'       accidentally put the memory in write mode, and make for a 
'       handy trick -- during PowerOnReset the LowNibble is set to 0,
'       so we can set the Memory Protect line by calling this
'       subroutine without first setting the LowNibble variable.

MemoryProtect:
	IF LowNibble = "W" THEN
		LOW MP
		SERTXD ("MW",CR,LF)
	ELSE
		HIGH MP
		SERTXD ("MP",CR,LF)
	ENDIF
	RETURN
	
' Handles pressing and resetting the INP switch. Note that this
' subroutine does not use the inpPause variable -- there is plenty
' of time for the Membership Card to react while the adapter sends
' data back and forth over the serial port.
InputSwitch:
	IF LowNibble = "D" THEN
		LOW INP
		SERTXD ("ID",CR,LF)
	ELSE
		HIGH INP
		SERTXD ("IU",CR,LF)
	ENDIF
	RETURN
	
' Converts an ASCII hex value in the HighNibble and LowNibble
' variables to the binary representation of that value. This 
' subroutine manages getting the high and low nibbles, it uses 
' the next to actually convert the values.
HEXToBinary:

	hexByte = HighNibble
	GOSUB DoHexToBinary
	HighNibble = hexByte << 4
	
	hexByte = LowNibble
	GOSUB DoHexToBinary
	LowNibble = hexByte
	
	RETURN
	
' Converts an ASCII hex value in the hexByte variable to its
' binary representation.
DoHexToBinary:
	IF hexByte >= 65 THEN
		hexByte = hexByte - 55
	ELSE
		hexByte = hexByte - "0"
	ENDIF
	RETURN
	