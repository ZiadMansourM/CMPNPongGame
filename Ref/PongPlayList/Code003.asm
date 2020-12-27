; Drawing your Ball
.model small 
.stack 64
.data
; DW 16bits AS we are using cx
BALL_X DW 0Ah ; x position (cloumn)
BALL_Y DW 0Ah ; y position (row - line)
Ball_SIZE DW 04h ; SIze of the ball 4-x 4-y
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
    call DRAW_BALL

    ;return to operating system
    jmp $
    ;hlt
    ;mov ah,04ch
    ;int 21h
main endp
; procedure to draw the ball
DRAW_BALL PROC NEAR
    ; start position
    mov cx, BALL_X ; set the initial x-position (Column)
    mov dx, BALL_Y ; set the initial y-position (raws - lines)
    DRAW_BALL_HORIZANTAL:
        ; [3]: Draw your first pixil "https://stanislavs.org/helppc/int_10-c.html"
        mov ah, 0Ch    ; draw pixil mode
        mov al, 0Fh    ; white color
        mov bh, 00h    ; set page number
        int 10h
        
        INC CX         ; cx = cx + 1
        ; AX := get Cx - Ball_X
        mov ax, cx
        sub ax, BALL_X
        ; Check IF AX >= Ball_Size THEN Jump next line ELSE continue
        cmp ax, Ball_SIZE
        JNG DRAW_BALL_HORIZANTAL
        ; "Finished drawing HORIZANTAL line"
        mov cx, BALL_X  ; set cx to initial
        inc dx          ; go to the next line
        ; AX := get DX - Ball_Y
        mov ax, dx
        sub ax, BALL_Y
        ; Check IF AX >= Ball_Size THEN Jump exit proc ELSE continue
        cmp ax, Ball_SIZE
        JNG DRAW_BALL_HORIZANTAL
    ; exit 
    ret
DRAW_BALL ENDP
end main