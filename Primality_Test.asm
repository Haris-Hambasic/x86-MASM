TITLE Program Template     (template.asm)

; Description: Program asks user for input between 1-200 --> [1...200]
;				If user enters number between 1-200 then that many primes will be displayed up to an unspecified "n" value
;				If user enters number outside range of 1-200 then the user will be prompted again to enter a number in the range 1-200

INCLUDE Irvine32.inc

MIN_NUMBER							=		1
MAX_NUMBER							=		200

.data

programmersName						BYTE	"Haris Hambasic", 0
programTitle						BYTE	"Project 4", 0
programIntroduction					BYTE	"Welcome! This progrm allows you to enter a number for which you want to view all primes up to it!", 0
programFarewell						BYTE	"Thanks for playing!", 0

promptNumberOfPrimesToDisplay		BYTE	"Enter the number of primes to be displayed: ", 0
numberOfPrimesToDisplay				DWORD	0
numberToDetermineIfPrime			DWORD	?

primeWasFound						WORD	0 ; 0=FALSE, 1=TRUE

numberOfPrimesToDisplayIsLess		BYTE	"The integer you entered is less than 1. The value must must be greater than or equal to 1. Please enter another number now: ", 0
numberOfPrimesToDisplayIsGreater	BYTE	"The integer you entered is greater than 200. The value must be less than or equal to 200. Please enter another number now: ", 0

.code
main PROC
	CALL	introduction
	CALL	getUserData
	CALL	showPrimes
	CALL	farewell

	Invoke ExitProcess,0
main ENDP

introduction PROC
	; --------------------------------------------------------------------------------- 
	; Name: introduction 
	;  
	; Introduces the program by printing the programmer's name, the program title,
	;		and the program introduction statement 
	; 
	; Preconditions: values at memory locations programmersName, programTitle, and programIntroduction
	; 
	; Postconditions: none. 
	; 
	; returns: no return value
	; ---------------------------------------------------------------------------------
	MOV		EDX, OFFSET programmersName
	CALL	WriteString
	CALL	CrLf

	MOV		EDX, OFFSET programTitle
	CALL	WriteString
	CALL	CrLf
	CALL	CrLf
	
	MOV		EDX, OFFSET programIntroduction
	CALL	WriteString
	CALL	CrLf
	CALL	CrLf

	RET
introduction ENDP

getUserData PROC
	; --------------------------------------------------------------------------------- 
	; Name: getUserData 
	;  
	; Gets the user's input data, specifically the number of primes to display
	; 
	; Preconditions: none
	; 
	; Postconditions:
	;		- memory location "numberOfPrimesToDisplay" is populated with the number
	;			of prime numbers to display
	; 
	; returns: no return value
	; ---------------------------------------------------------------------------------
	_setNumberOfPrimesToDisplay:
		MOV		EDX, OFFSET promptNumberOfPrimesToDisplay
		CALL	WriteString
		CALL	ReadInt
		MOV		numberOfPrimesToDisplay, EAX
		CALL	validate
		CALL	CrLf

	RET
getUserData ENDP

validate PROC
	; --------------------------------------------------------------------------------- 
	; Name: validate 
	;  
	; Validates the user's input
	; 
	; Preconditions:
	;		- values at memory locations:
	;			- MIN_NUMBER
	;			- MAX_NUMBER
	; 
	; Postconditions:
	;		- validated user input at memory location "numberOfPrimesToDisplay"
	; 
	; returns: no return value 
	; ---------------------------------------------------------------------------------
	_validateNumberOfPrimesToDisplay:
		CMP		numberOfPrimesToDisplay, OFFSET MIN_NUMBER
		JL		_isLess?

		CMP		numberOfPrimesToDisplay, OFFSET MAX_NUMBER
		JG		_isGreater?

		JMP		_endValidation

	_isLess?:
		MOV		EDX, OFFSET numberOfPrimesToDisplayIsLess
		CALL	WriteString
		CALL	ReadInt
		MOV		numberOfPrimesToDisplay, EAX
		JMP		_validateNumberOfPrimesToDisplay

	_isGreater?:
		MOV		EDX, OFFSET numberOfPrimesToDisplayIsGreater
		CALL	WriteString
		CALL	ReadInt
		MOV		numberOfPrimesToDisplay, EAX
		JMP		_validateNumberOfPrimesToDisplay

	_endValidation:

	RET
validate ENDP

showPrimes PROC
	; --------------------------------------------------------------------------------- 
	; Name: showPrimes 
	;  
	; Prints to the console a prime number if the current number is a prime.
	; 
	; Preconditions:
	;		- "numberOfPrimesToDisplay" to use as the counter for loop
	; 
	; Postconditions: none... this procedure only prints the number if is prime and
	;					keeps track of the loop constraints
	; 
	; returns: no return value
	; ---------------------------------------------------------------------------------


	; -----------------------------------
	; Checks if the user want only to
	;	to print one prime number
	; -----------------------------------
	CMP		numberOfPrimesToDisplay, 1
	JE		_displayOnePrime

	CMP		numberOfPrimesToDisplay, 2
	JGE		_main

	_displayOnePrime:
		MOV		EAX, 2
		CALL	WriteInt

	_farewell:
		CALL	farewell

	_main:
		MOV		EAX, 2
		CALL	WriteInt

		MOV		EAX, 3							; EAX will hold the current number being tested
		MOV		EBX, 2							; The current divisor
		SUB		numberOfPrimesToDisplay, 1
		MOV		ECX, numberOfPrimesToDisplay	; ECX will hold the total number of primes to compute

	_primeLoop:
		PUSH	ECX
		PUSH	EAX
		
		CALL	isPrime

		CMP		primeWasFound, 1
		JE		_continueToNextIteration


		; -------------------------- 
		; Adds 1 to ECX before the next loop decrements
		;	ECX causing an incorrect counter
		; -------------------------- 
		_adjustECX:
			POP		EAX
			POP		ECX
			ADD		ECX, 1						;  Adjust ECX so that when the next loop iteration decrements ECX, ECX will store the correct value
			INC		EAX
			MOV		EBX, 2
			LOOP	_primeLoop

		JMP		_endShowPrimes

		_continueToNextIteration:
			POP		EAX
			POP		ECX
			call	CrLf
			CALL	WriteInt
			MOV		primeWasFound, 0
			INC		EAX
			MOV		EBX, 2
			LOOP	_primeLoop
	_endShowPrimes:

	RET
showPrimes ENDP

isPrime PROC
	; --------------------------------------------------------------------------------- 
	; Name: isPrime 
	;  
	; Determines if the number is a prime
	; 
	; Preconditions: the number to check, in register EAX
	; 
	; Postconditions:
	;		- memory location "primeWasFound" is set (1) if the current number is
	;			prime and subsequently procedure "showPrimes" prints number to console
	;			otherwise number is not prime and next number is loaded
	; 
	; returns: no return value
	; ---------------------------------------------------------------------------------
	DEC		EAX
	DEC		EAX
	MOV		ECX, EAX
	_primeInnerLoop:
		CMP		EAX, 1
		JLE		_jumpEarly

		PUSH	EAX
		MOV		EDX, 0
		DIV		EBX

		POP		EAX
		CMP		EDX, 0
		JE		_endIsPrime

		DEC		EAX
		INC		EBX
	LOOP	_primeInnerLoop

	_jumpEarly:
		MOV		primeWasFound, 1
	
	_endIsPrime:

	RET
isPrime ENDP

farewell PROC
	; --------------------------------------------------------------------------------- 
	; Name: farewell 
	;  
	; Displays a farewell message to the user
	; 
	; Preconditions: none
	; 
	; Postconditions: none
	; 
	; returns: no return value
	; ---------------------------------------------------------------------------------
	CALL	CrLf
	CALL	CrLf
	CALL	CrLf
	MOV		EDX, OFFSET programFarewell
	CALL	WriteString
	CALL	CrLf
	CALL	CrLf
farewell ENDP

END main
