;=== LCDDriverTest.bas ========= 2009.09.09 ========= Ron Hackett ===

;	This program runs on a PICAXE-28X1 processor & sends 9-byte
; 	packets of serial data to a 14M-based serialized 8X2 LCD display.

; 	If you use 2400 Baud, be sure LCD jumper is set to "low" (left)
; 	If you use 4800 Baud, be sure LCD jumper is set to "hi" (right)

; 	In order for the LCD to function correctly, the master processor
; 	must send  data in "packets" of nine characters. The first character
; 	must be a command; the remaining 8 chars can be text or commands.

; 	After each 9-byte packet is sent to the LCD, a brief delay is
; 	necessary to allow the LCD enough time to update its display.

;======================================================================


;=== Constants ===
; Use these constants in any application using the LCD display.
					
	symbol abit =  100				; used to add pause between packets
	
;   HD44780 LCD Commands:
	symbol D0 =   8					; display off
	symbol D1 =  12					; display on (cursor off)
	symbol DC =   1					; display clear (cursor home)
	symbol C0 =  12					; cursor off (display on)
	symbol C1 =  14					; cursor on  (no blink)
	symbol CB =  15					; cursor blink	
	symbol CH =   2					; cursor home (display not cleared)
	symbol L1 =  16					; cursor left  one position
	symbol R1 =  20					; cursor right one position
	symbol Q1 = 128					; cursor at position 1 of line 1
	symbol Q2 = 136					; cursor at position 9 of line 1
	symbol Q3 = 192					; cursor at position 1 of line 2
	symbol Q4 = 200					; cursor at position 9 of line 2
	

;=== Directives ===

	#com4							; set COM port for downloading
	#picaxe 18M2					; set compiler mode
	

;=== Begin Main Program =====================================


wait 1								; allow time for LCD to initialize

do
	serout 0,N4800_4,(Q1,"N&V LCD ")
	pause abit
	
	serout 0,N4800_4,(Q3,"Display ")
	pause abit
	
	wait 1
	
	serout 0,N4800_4,(Q1," PICAXE ")
	pause abit
	
	serout 0,N4800_4,(Q3," Primer ")
	pause abit
	
	wait 1
		
loop




