' *** ELFController.bas *************************

#PICAXE 14M2
#NO_DATA

SYMBOL ELFClear  = B.2
SYMBOL ELFWait   = B.1

SYMBOL SpeedHigh = C.1
SYMBOL SpeedLow  = C.0

SYMBOL DataHigh  = B15
SYMBOL DataLow   = B14
SYMBOL ELFMode   = B13

SYMBOL ELFModeReset = %100
SYMBOL ELFModeLoad  = %000
SYMBOL ELFModeWait  = %010
SYMBOL ELFModeRun   = %110

SYMBOL ELFClock2M   = %11
SYMBOL ELFClock1M7  = %10
SYMBOL ELFClockF    = %01
SYMBOL ELFClockS    = %00

PowerOnReset:

	' Put ELF in RESET mode
	GOSUB ELFReset
	
	' Start with clock at fast step
	LOW  SpeedHigh
	HIGH SpeedLow
	
	' Put ELF in RUN mode
	GOSUB ELFRun
	
DO ' Main loop
	SERRXD DataHigh, DataLow
	
	IF DataHigh = "R" THEN 
		GOSUB ELFReset
	ELSE IF DataHigh = "G" THEN 
		GOSUB ELFRun
	ELSE IF DataHigh ="L" THEN
		GOSUB ELFLoad
	ELSE IF DataHigh = "C" THEN
		GOSUB SetClock
	ENDIF
	
LOOP ' End of main loop

ELFLoad:

	IF ELFMode = ELFModeRUN THEN
		GOSUB ELFReset
	ENDIF
	
	ELFMode = ELFModeLOAD
	OutpinsB = ELFModeLOAD
	
	SERTXD ("Load", CR, LF)

	RETURN
	
ELFReset: 

	ELFMode = ELFModeRESET
	OutpinsB = ELFModeRESET
	
	SERTXD ("Reset", CR, LF)
	
	RETURN
	
ELFRun: 

	IF ELFMode = ELFModeLOAD THEN
		GOSUB ELFReset
	ENDIF

	ELFMode = ElfModeRUN
	OutpinsB = ELFModeRUN
	
	SERTXD ("Running", CR, LF)
	
	RETURN
	
SetClock:

	IF DataLow = "2" THEN
		OutpinsC = ELFClock2M
		SERTXD ("Clock 2Mhz", CR, LF)
	ELSE IF DataLow = "1" THEN
		OutpinsC = ELFClock1M7
		SERTXD ("Clock 1.7Mhz", CR, LF)
	ELSE IF DataLow = "F" THEN
		OutpinsC = ELFClockF
		SERTXD ("Fast step", CR, LF)
	ELSE IF DataLow = "S" THEN
		OutpinsC = ELFClockS
		SERTXD ("Slow step", CR, LF)
	ENDIF

	RETURN