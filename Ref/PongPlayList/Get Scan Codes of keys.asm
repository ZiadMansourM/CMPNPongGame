; use emulator
.model small 
.stack 64
.data
;put data here
.code 
main proc
    mov ax,@data
    mov ds, ax
;    wait for input from user INT 21h
    mov ah, 07               ; Al := Read One Char, No echo
    int 21h
; disp char
    mov ah, 
    ;exit
    jmp $
    mov ah,04ch
    int 21h
main endp
end main