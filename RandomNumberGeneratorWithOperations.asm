TITLE Program Template     (template.asm)

; Author: Haris Hambasic
; Description: This program generates a random list of numbers then displays the original list, sorts the list, displays the median value of the list,
;				displays the  list sorted in ascending order, and finally displays the number of instances of each generated value.

INCLUDE Irvine32.inc
; (insert constant definitions here)
ARRAYSIZE						=			200
LO								=			15
HI								=			50

.data
; (insert variable definitions here)
half								BYTE	".5",0
introduction_title					BYTE	"Generating, Sorting, and Counting Random integers! Programmed by Haris Hambasic.",0
introduction_statement				BYTE	"This program generates a random list of numbers then displays the original list, sorts the list, displays the median value of the list, displays the  list sorted in ascending order, then displays the number of instances of each generated value.",0
goodbye_statement					BYTE	"Goodbye, and thanks for using this program!",0
unsorted_random_numbers_statement	BYTE	"Your unsorted random numbers:",0
median_value_of_array_statement		BYTE	"The median value of the array: ",0
sorted_random_numbers_statement		BYTE	"Your sorted random numbers:",0
list_of_instances_statement			BYTE	"Your list of instances of each generated number:",0
space_between						BYTE	" ",0
randArray							BYTE	ARRAYSIZE DUP(?)

.code
main PROC
	CALL	Randomize

	; introduce program
	PUSH	OFFSET introduction_title
	CALL	introduction
	CALL	CrLf
	CALL	CrLf

	PUSH	OFFSET introduction_statement
	CALL	introduction
	CALL	CrLf
	CALL	CrLf
	POP		EDX

	; populate the array
	PUSH	OFFSET space_between
	PUSH	OFFSET randArray
	CALL	fillArray
	POP		EDX
	POP		EDX

	; display the array elements
	PUSH	OFFSET randArray
	PUSH	OFFSET space_between
	PUSH	OFFSET unsorted_random_numbers_statement
	CALL	displayList
	POP		EDX
	POP		EDX
	POP		EDX

	; sort the array
	PUSH	OFFSET randArray
	CALL	sortList
	POP		EDX

	; displat the median of the array elements
	CALL	CrLf
	CALL	CrLf
	PUSH	OFFSET randArray
	PUSH	OFFSET median_value_of_array_statement
	CALL	displayMedian
	POP		EDX
	POP		EDX

	; display the sorted array elements
	CALL	CrLf
	CALL	CrLf
	PUSH	OFFSET randArray
	PUSH	OFFSET space_between
	PUSH	OFFSET sorted_random_numbers_statement
	CALL	displayList
	POP		EDX
	POP		EDX
	POP		EDX

	; additional formatting
	CALL	CrLf
	CALL	CrLf

	; display the count of each element of the array
	PUSH	OFFSET randArray
	PUSH	OFFSET space_between
	PUSH	OFFSET list_of_instances_statement
	CALL	countList
	POP		EDX
	POP		EDX
	POP		EDX

	; display a goodbye message
	PUSH	OFFSET goodbye_statement
	CALL	goodbye
	POP		EDX

	Invoke ExitProcess,0
main ENDP

introduction PROC
	; --------------------------------------------------------------------------------- 
	; Name: introduction 
	;  
	; Introduce the user to the program by displaying the title and a short description
	;	of the program.
	; 
	; Receives:
	;	- Push the string to display, onto the stack for use as parameter value
	; 
	; Returns: No return value
	; ---------------------------------------------------------------------------------
	PUSH	EBP
	MOV		EBP, ESP
	MOV		EDX, [EBP + 8]
	CALL	WriteString
	POP		EBP
	RET		4
introduction ENDP

goodbye PROC
	; --------------------------------------------------------------------------------- 
	; Name: goodbye 
	;  
	; Display a goodbye message to the user and thank them for using your program.
	; 
	; Receives:
	;	- Push the string to display, onto the stack for use as parameter value
	; 
	; Returns: No return value
	; ---------------------------------------------------------------------------------
	PUSH	EBP
	MOV		EBP, ESP
	
	CALL	CrLf
	CALL	CrLf
	MOV		EDX, [EBP + 8]
	CALL	WriteString
	CALL	CrLf
	RET		4
goodbye ENDP

fillArray PROC
	; --------------------------------------------------------------------------------- 
	; Name: fillArray 
	;  
	; Populate the random array with values
	; 
	; Preconditions:
	;	- A global variable (of array) to hold the random values
	; 
	; Receives:
	;	- Push the string to display, onto the stack for use as parameter value
	; 
	; Returns:
	;	- A populated global variable (or array) to hold the random values
	; ---------------------------------------------------------------------------------
	PUSH	EBP
	MOV		EBP, ESP
	MOV		ECX, ARRAYSIZE
	MOV		EDI, [EBP + 8]
	PUSH	EDI
	_generateRandomIntegers:
		_generateRandomInteger:
			MOV		EAX, HI
			CALL	RandomRange
		_isValidInteger:
			MOV		EBX, LO
			CMP		EBX, EAX
			JG		_generateRandomInteger
			STOSD
		LOOP _generateRandomIntegers
	POP		EDI
	MOV		ESI, EDI
	POP EBP
	_end:
		RET 8
fillArray ENDP

exchangeElements PROC
	; --------------------------------------------------------------------------------- 
	; Name: exchangeElements 
	;  
	; Swap element positions when sorting an unsorted array
	; 
	; Returns:
	;	- Sorted sub-array of remaining unsorted array
	; ---------------------------------------------------------------------------------
	MOV		[ESI - 4], EDX
	MOV		[ESI], EAX
	RET
exchangeElements ENDP

sortList PROC
	; --------------------------------------------------------------------------------- 
	; Name: sortList 
	;  
	; Sorts an unsorted array
	;
	; Receives:
	;	- An array to sort, as a passed argument
	; 
	; Returns:
	;	- A sorted array
	; ---------------------------------------------------------------------------------
	PUSH	EBP
	MOV		EBP, ESP

	MOV		EBX, ARRAYSIZE
	_outerLoop:
		MOV		ESI, [EBP + 8]
		MOV		ECX, EBX
	_innerLoop:
		LODSD
		MOV		EDX, [ESI]
		CMP		EAX, EDX
		JLE		_jumpOver
		CALL	exchangeElements
	_jumpOver:
		DEC		ECX
		JNZ		_innerLoop
		DEC		EBX
		JNZ		_outerLoop

	POP		EBP
	RET		4
sortList ENDP

displayList PROC
	; --------------------------------------------------------------------------------- 
	; Name: displayList 
	;  
	; Displays all elements of an array
	; 
	; Preconditions:
	;	-
	; 
	; Postconditions:
	;	-
	; 
	; Receives:
	;	- An array to print/display
	;	- A statement describing what is being displayed
	;	- A special formatting string to include spacing between array elements
	; 
	; Returns: N/A
	; ---------------------------------------------------------------------------------
	PUSH	EBP
	MOV		EBP, ESP

	MOV		EDX, [EBP + 8]
	CALL	WriteString
	CALL	CrLf

	MOV		ECX, ARRAYSIZE
	MOV		ESI, [EBP + 16]
	_printAllElementsOfArray:
		CMP		ECX, 10
		JLE		_printLastRow

		PUSH	ECX
		MOV		ECX, 10 
		_printRow:
			LODSD
			CALL	WriteInt
			MOV		EDX, [EBP + 12]
			CALL	WriteString
			LOOP	_printRow

		CALL	CrLf
		POP		ECX
		SUB		ECX, 9
		LOOP	_printAllElementsOfArray

	_printLastRow:
		LODSD
		CALL	WriteInt
		MOV		EDX, [EBP + 12]
		CALL	WriteString
		LOOP	_printLastRow

	POP		EBP
	RET		12
displayList ENDP

displayMedian PROC
	; --------------------------------------------------------------------------------- 
	; Name: displayMedian
	;  
	; Displays the median value of the array
	; 
	; Preconditions:
	;	- An already sorted array
	; 
	; Postconditions:
	;	-
	; 
	; Receives:
	;	- An array to search
	; 
	; Returns: N/A
	; ---------------------------------------------------------------------------------
	PUSH	EBP
	MOV		EBP, ESP

	MOV		EDX, [EBP + 8]
	CALL	WriteString

	MOV		ECX, ARRAYSIZE
	MOV		EAX, ARRAYSIZE
	MOV		EDX, 0
	MOV		EBX, 2
	DIV		EBX

	CMP		EDX, 0
	MOV		ESI, [EBP + 12]
	MOV		EDX, EAX

	JG		_findMedianOddArraySize


	_findMedianEvenArraySize:
		LODSD
		CMP		ECX, EDX
		JE		_computeMedian
		LOOP	_findMedianEvenArraySize
		_computeMedian:
			MOV		EBX, EAX				; 1 of 2 middle values is in EAX and ESI points to that value --> move that value into EBX
			MOV		EAX, [ESI - 8]			; get other middle value
			ADD		EAX, EBX
			MOV		EDX, 0
			MOV		EBX, 2
			DIV		EBX
			CMP		EDX, 1
			JE		_roundUp
			CALL	WriteInt
			JMP		_end
			_roundUp:
				INC		EAX
				CALL	WriteInt
				JMP		_end

	_findMedianOddArraySize:
		INC		EAX
		MOV		EDX, EAX
		
		_getMedianOfOddArraySize:
			LODSD
			CMP		EDX, ECX
			JE		_printMedianOfOddArraySize
			LOOP _getMedianOfOddArraySize
		
		_printMedianOfOddArraySize:
			CALL	WriteInt

	_end:
		POP EBP
		RET 8
displayMedian ENDP

countList PROC
	; --------------------------------------------------------------------------------- 
	; Name: countList 
	;  
	; Displays the count of each element in the array
	; 
	; Preconditions:
	;	- An array of random values
	; 
	; Receives:
	;	- An array to iterate over and display the count for each value in the array
	; 
	; Returns: N/A
	; ---------------------------------------------------------------------------------
	PUSH	EBP
	MOV		EBP, ESP
	MOV		EDI, 0
	MOV		EDX, [EBP + 8]
	CALL	WriteString
	CALL	CrLf
	MOV		ESI, [EBP + 16]
	MOV		ECX, ARRAYSIZE
	MOV		EDX, 0
	LODSD
	MOV		EBX, EAX
	INC		EDX
	_forEach:
		CMP		ECX, 1
		JE		_getNextNumber
		LODSD
		CMP		EBX, EAX
		JNE		_getNextNumber
		INC		EDX
		PUSH	EDX
		POP		EDX
		LOOP	_forEach
		_getNextNumber:
			PUSH	EAX
			MOV		EAX, EDX
			CMP		EDI, 20
			JE		_addNewRow
			_printNumber:
				CALL	WriteInt
			POP		EAX
			MOV		EDX, 1
			MOV		EBX, EAX
			CMP		ECX, 1
			JLE		_end
			PUSH	EDX
			MOV		EDX, [EBP + 12]
			CALL	WriteString
			POP		EDX
			INC		EDI
			LOOP	_forEach
		_addNewRow:
			CALL	CrLf
			MOV		EDI, 0
			JMP		_printNumber
	_end:
		POP		EBP
		RET		12
countList ENDP

END main
