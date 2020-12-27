; Drawing your first pixil
.model small 
.stack 64
.data
.code 
main proc
    mov ax,@data
    mov ds, ax
    ;code
    
    ; [1]: set video mode, plus which one "https://stanislavs.org/helppc/int_10-0.html"
    mov ah, 0h   ; set video mode
    mov al, 13h  ; configure video mode settings
    int 10h
    ; [2]: set backgroud "https://stanislavs.org/helppc/int_10-b.html"
    mov ah, 0bh  ; Set color palette
    mov bh, 00h  ; palette color ID - to set background and border color
    mov al, 00h  ; black color 
    int 10h

    ; [3]: Draw your first pixil "https://stanislavs.org/helppc/int_10-c.html"
    mov ah, 0Ch ; draw pixil mode
    mov al, 0Fh ; white color
    mov bh, 00h ; set page number
    mov cx, 0Ah ; set the x-position (Column)
    mov dx, 0Ah ; set the y-position (raws - lines)
    int 10h

    ;return to operating system
    jmp $
    ;hlt
    ;mov ah,04ch
    ;int 21h
main endp
end main