.model small 
.stack 64
.data

.code 
main proc
    mov ax,@data
    mov ds, ax
    ;code
    mov dl, 'A'
    mov ah, 6h
    int 21h
    ;return to operating system
    mov ah,04ch
    int 21h
main endp
end main