.model small 
.stack 64
.data
;put data here
msg db 'Please Enter your Name:', 10, 13, ' > ', '$'
InDATA db 15, ?, 15 dup('$')
msg_2 db 10, 13, 'Your user name is: ', '$'
.code 
main proc
    mov ax,@data
    mov ds, ax
;    code to outout a string then go to the next line 
    mov ah , 09h
    mov dx, offset msg
    int 21h
;    Wait for user input > 15 char
    mov ah, 0Ah
    mov dx, offset InDATA
    int 21h
;    Prepare for the output
    mov ah, 09h
    mov dx, offset msg_2
    int 21h
    mov ah, 09h
    mov dx, offset InDATA+2
    int 21h
;    Wait for input to exit
    again:
    mov ah,00h                                  ;Read one char and put in al without echo
    int 16h
;   check if 'w' was pressed
    CMP al, 77h                                 ; 'w' = 77h
    je EXIT                                     ; EXIT
    jmp again
;    exit
    jmp $
EXIT:
    mov ah,04ch
    int 21h
main endp
end main