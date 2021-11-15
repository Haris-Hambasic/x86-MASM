TITLE Program Template     (template.asm)

; Author: Haris Hambasic
; Description: This file represents a program that allows the user to enter numbers between -200 and -100 (inclusive), and -50 and -1 (inclusive) and sums the value of the valid inputs while also displaying
;				to the user at the end of the program the following:
;				1) The maximum value entered
;				2) The minimum value entered
;				3) The average of the values entered
;				4) The total number of valid numbers entered

INCLUDE Irvine32.inc

; (insert constant definitions here)

rangeALow						= 		-200
rangeAHigh						=		-100
rangeBHigh						=		-1
rangeBLow						=		-50

.data

; (insert variable definitions here)

programTitle					BYTE	"Program Title: Project 3",0
programmersName					BYTE	"Programmer's Name: Haris Hambasic",0
greeting						BYTE	"Hello! Welcome to Project 3!",0
promptUsername					BYTE	"Please enter your name: ",0
programInstructions				BYTE	"Program Instructions: Please enter values between -200 and -100 (inclusive), and between -50 and -1 (inclusive)",0
greetUserWithUsername			BYTE	"Hello, ",0
userName						DWORD	?
period							BYTE	".",0
userPrompt						BYTE	"Please enter a number.",0

sum								DWORD	0
min								DWORD	0
minStatement					BYTE	"The minimum number entered is ",0
max								DWORD	-201
maxStatement					BYTE	"The maximum number entered is ",0
average							DWORD	0
averageStatement				BYTE	"The average of the numbers entered is ",0
totalNumbersEntered				DWORD	0
totalNumbersEnteredStatement	BYTE	" total valid numbers were entered.",0
outOfRangeALow					BYTE	"The number entered is less than -200.",0
outOfRangeBLow					BYTE	"The number entered is less than -50 and more than -100.",0
positiveNumberEntered			BYTE	"You entered a positive number, which now terminates the program. ",0
totalValueStatement				BYTE	"Your total computed value is: ",0
noValidNumbersEntered			BYTE	"Oh no! It looks as if you did not enter any valid numbers. Please play again!",0
partingMessage					BYTE	"Thanks for running my program! I hope to see you soon!",0

.code
main PROC
; (insert executable instructions here)

	; Display program title and programmer's name
	MOV		EDX, OFFSET programTitle
	CALL	WriteString
	MOV		EDX, OFFSET programmersName
	CALL	CrLf
	CALL	WriteString
	CALL	CrLf
	CALL	CrLf

	; Get the user's name and greet the user
	MOV		EDX, OFFSET greeting
	CALL	WriteString
	CALL	CrLf
	MOV		EDX, OFFSET promptUsername
	CALL	CrLf
	CALL	WriteString
	MOV		ECX, 32
	CALL	ReadString
	MOV		userName, EDX
	MOV		EDX, OFFSET greetUserWithUsername
	CALL	WriteString
	MOV		EDX, userName
	CALL	WriteString

	CALL	CrLf
	CALL	CrLf

	; Display program instructions
	MOV		EDX, OFFSET programInstructions
	CALL	WriteString

	CALL	CrLf
	CALL	CrLf

	JMP		_addToTotal?

	_validateUserInput:

		CMP		EAX, 0
		JNS		_positiveNumberEntered

		; Check if entered number is less than -200
		CMP		EAX, rangeALow
		JL		_outOfRangeALow

		; Check if entered number is less than -100
		CMP		EAX, rangeAHigh
		JLE		_addToTotal

		; Check if entered number is than -50
		CMP		EAX, rangeBLow
		JL		_outOfRangeBLow

		; Check if entered number is less than -1
		CMP		EAX, rangeBHigh
		JLE		_addToTotal

	; Out of range code labels
	_outOfRangeALow:
		MOV		EDX, OFFSET outOfRangeALow
		CALL	WriteString
		CALL	CrLf
		CALL	CrLf
		JMP		_addToTotal?

	_outOfRangeBLow:
		MOV		EDX, OFFSET outOfRangeBLow
		CALL	WriteString
		CALL	CrLf
		CALL	CrLf
		JMP		_addToTotal?

	_addToTotal?:
		MOV		EDX, OFFSET userPrompt
		CALL	WriteString
		CALL	CrLf
		CALL	ReadInt

		JMP		_validateUserInput

		; If negative number
		JS		_addToTotal

		; If positive number
		JNS		_terminateAddToTotal

	_addToTotal:
		CALL	CrLf
		ADD		totalNumbersEntered, 1

		; Set the max value
		CMP		EAX, max
		JG		_setMax

		; Set the min value
		CMP		EAX, min
		JL		_setMin

		JMP		_updateSum
	
	_updateSum:
		ADD		EAX, sum
		MOV		sum, EAX

		JMP		_addToTotal?

	_terminateAddToTotal:
		MOV		EDX, OFFSET programmersName
		CALL	WriteString
		JMP		_endProgram

	; Update the max number entered, as needed
	_setMax:
		MOV		max, EAX
		JMP		_updateSum

	; Update the min number entered, as needed
	_setMin:
		MOV		min, EAX
		JMP		_updateSum
		

	_positiveNumberEntered:
		CMP		totalNumbersEntered, 0
		JE		_noValidNumbersEndProgram

		CALL	CrLf
		CALL	CrLf

		; Inform the user they entered a positive number and the program is now terminating
		MOV		EDX, OFFSET positiveNumberEntered
		CALL	WriteString

		MOV		EDX, OFFSET totalValueStatement
		CALL	WriteString

		MOV		EAX, sum
		CALL	WriteInt

		MOV		EDX, OFFSET period
		CALL	WriteString

		CALL	CrLf
		CALL	CrLf

		; Display the total valid inputs entered by the user
		MOV		EAX, totalNumbersEntered
		CALL	WriteInt

		MOV		EDX, OFFSET totalNumbersEnteredStatement
		CALL	WriteString

		; Compute the average of all numbers entered
		CALL	CrLf
		CALL	CrLf

		MOV		EDX, OFFSET averageStatement
		CALL	WriteString

		CALL	CrLf
		CALL	CrLf

		; Display the minimum number inputted
		mov		EDX, OFFSET minStatement
		CALL	WriteString

		MOV		EAX, min
		CALL	WriteInt

		MOV		EDX, OFFSET period
		CALL	WriteString

		CALL	CrLf
		CALL	CrLf

		; Display the maximum number inputted
		MOV		EDX, OFFSET maxStatement
		CALL	WriteString

		MOV		EAX, max
		CALL	WriteInt

		MOV		EDX, OFFSET period
		CALL	WriteString

		CALL	CrLf
		CALL	CrLf
		CALL	CrLf
		CALL	CrLf

		; Display a parting message to the user
		MOV		EDX, OFFSET partingMessage
		CALL	WriteString
		
		JMP		_endProgram

	; Code label for when an instance of the program is executed without the user entering any valid inputs
	_noValidNumbersEndProgram:
		CALL	CrLf
		CALL	CrLf

		MOV		EDX, OFFSET noValidNumbersEntered
		CALL	WriteString

		CALL	CrLf
		CALL	CrLf

	; Add white space below program output
	_endProgram:
		CALL	CrLf
		CALL	CrLf

	Invoke ExitProcess,0	; exit to operating system
main ENDP

END main