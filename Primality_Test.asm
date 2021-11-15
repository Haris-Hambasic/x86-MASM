TITLE Program Template     (template.asm)

; Author: Haris Hambasic
; Last Modified: 14 November 2021
; OSU email address: hambasih@oregonstate.edu
; Course number/section:   CS271 Section 401
; Project Number: 4               Due Date: 15 November 2021
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

.data

; (insert variable definitions here
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

minNumber							WORD	1
maxNumber							WORD	200

here_ BYTE "HERE-->", 0

.code
main PROC
	CALL	introduction
	CALL	getUserData
	CALL	showPrimes
	CALL	farewell

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

introduction PROC
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
	_validateNumberOfPrimesToDisplay:
		CMP		numberOfPrimesToDisplay, 1
		JL		_isLess?

		CMP		numberOfPrimesToDisplay, 200
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
	; Display the first two primes, after we check how many primes the user want displayed

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

	; initialize running total, first number, and loop control
	MOV		EAX, 3						; EAX will hold the current number being tested
	MOV		EBX, 2						; The current divisor
	SUB		numberOfPrimesToDisplay, 1
	MOV		ECX, numberOfPrimesToDisplay	; ECX will hold the total number of primes to compute

	_primeLoop:
		PUSH	ECX
		PUSH	EAX
		
		CALL	isPrime ; check if current number is prime

		CMP		primeWasFound, 1
		JE		_continueToNextIteration

		_adjustECX:  ; because current number is not prime
			POP		EAX
			POP		ECX
			ADD		ECX, 1
			INC		EAX
			MOV		EBX, 2
			LOOP	_primeLoop

		JMP		_endShowPrimes

		_continueToNextIteration:
			POP		EAX
			POP		ECX
			call	CrLf
			CALL	WriteInt ;  write the prime number
			MOV		primeWasFound, 0
			INC		EAX
			MOV		EBX, 2
			LOOP	_primeLoop

	_endShowPrimes:

	RET
showPrimes ENDP

isPrime PROC
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
	CALL	CrLf
	CALL	CrLf
	CALL	CrLf
	MOV		EDX, OFFSET programFarewell
	CALL	WriteString
	CALL	CrLf
	CALL	CrLf
farewell ENDP

END main
