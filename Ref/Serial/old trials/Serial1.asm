.model small
.stack
.data
MESSAGE DB 'Serial communication via COM2, 4800, No P, 1 Stop, 8-BIT DATA.', 0AH, 0DH
	DB 'ANY KEY PRESS IS SENT TO OTHER PC.', 0AH, 0DH
	DB 'PRESS ESC TO EXIT', 0AH, 0DH,'$'
.code
main proc
	mov ax, @data
	mov ds, ax
	;Displaying Welcom Message
	mov ah, 09
	mov dx, offset MESSAGE
	int 21h
	
	;Initializing COM 2
	mov ah, 0	; initialize COM port
	mov dx, 1	; COM2
	mov al, 0C3H	; 4800, NO P, 1 STOP, 8-BIT
	int 14h
	
	;Checking key press and sending key to COM2 to be transfered
AGAIN:
	mov ah, 01h
	int 16h
	JZ NEXT		; NO KEY waw PRESSED
	mov ah, 00h	
	int 16h 	; AL:= ASCII char pressed
	; check if the user is trying to exit
	cmp al, 1Bh
	JE EXIT
	; send the ASCII to COM 2 PORT
	mov ah, 01h	; Transmit data
	mov dx, 01h	; COM 2
	int 14h 	; transmit data to COM2
	; check COM 2 Port if RECEIVED

NEXT:
	mov ah, 03h	; get Status
	mov dx, 01h 	; COM 2
	int 14h
	; analysis the status of COM 2
	and ah, 01h	; mask all bits except D0
	cmp ah, 01h	; check D0 if there is a char
	JNE AGAIN
	mov ah, 02h	; get data
	mov dx, 01	; COM2
	int 14h		; get it in al
	; display what you have received 
	mov dl, al
	mov ah, 02h	; display char in dl
	int 21h 
	JMP AGAIN
EXIT:	
	mov ah, 4ch	
	int 21h
main endp
end main