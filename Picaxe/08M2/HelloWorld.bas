' Absolutely dead basic LED flashing program

#PICAXE 08M2
#PORT COM4

symbol LED = 0

main: 
	TOGGLE LED
	WAIT 1
	
	GOTO main
	
end