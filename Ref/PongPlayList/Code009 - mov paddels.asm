; Keyboard Input "MovePaddels"
.model small 
.stack 64
.data
; VARS TO CONTROLL COLLESION
WINDOW_WIDTH dw 140h  ; 320 Pixels
WINDOW_HEIGHT dw 0C8h ; 200 Pixels
WINDOW_BOUNDS DW 6h   ; to check collesion early
; VARS TO CONTROL MOVEMENT
TIME_AUX DB 0 ; old time
BALL_ORIGINAL_X DW 0A0H
BALL_ORIGINAL_Y DW 64H
; VARS TO DROW BALL
BALL_X DW 0Ah          ; x position (cloumn)
BALL_Y DW 0Ah          ; y position (row - line)
BALL_SIZE DW 04h       ; SIze of the ball 4-x 4-y
BALL_VELOCITY_X DW 05h ; X-Velocity of the ball (Horizantal)
BALL_VELOCITY_Y DW 02h ; Y-Velocity of the ball (Vertical)
; VARS TO DROW LEFT_PADDELS
PADDLE_LEFT_X dw 0Ah
PADDLE_LEFT_Y DW 0Ah
; VARS TO DROW RIGHT_PADDELS
PADDLE_RIGHT_X dw 130h
PADDLE_RIGHT_Y DW 0Ah
; PADDELS SIZE
PADDLE_WIDTH dw 05h
PADDLE_HEIGHT dw 1Fh
; PADDEL VELOCITY
PADDLE_VELOCITY dw 05h

.code 
main proc
    mov ax,@data
    mov ds, ax
    ;code
    
    call CLEAR_SCREEN
    
    CHECK_TIME:
        ; get system time "http://spike.scu.edu.au/~barry/interrupts.html#ah2c"
        mov ah, 2Ch  ; get the system time
        int 21h      ; Return: CH = hour CL = minute DH = second DL = 1/100 seconds
        cmp dl, TIME_AUX
        JE CHECK_TIME ; if time has not passed
        mov TIME_AUX, dl ; store current time

        call CLEAR_SCREEN

        call MOV_BALL
        call DRAW_BALL; if time has passed

        call MOVE_PADDLES
        call DRAW_PADDLES


        jmp CHECK_TIME

    ;return to operating system
    jmp $
    ;hlt
    ;mov ah,04ch
    ;int 21h
main endp

MOV_BALL PROC NEAR

    ; Move Horizantal
    mov ax,  BALL_VELOCITY_X 
    add BALL_X, ax              ; Ball_X = Ball_X + Velocity(X) "Horizantal"
    ; Check if their is collesions with the right or left boundries
    mov ax, WINDOW_BOUNDS
    cmp BALL_X, ax
    JL RESET_POSITION           ; Collesion with left Boundry

    mov ax, WINDOW_WIDTH
    sub ax, BALL_SIZE
    sub ax, WINDOW_BOUNDS
    CMP BALL_X, ax
    JG RESET_POSITION           ; Collesion with right Boundry

    ; Move Vertical
    mov ax,  BALL_VELOCITY_Y
    add BALL_Y, ax              ; Ball_Y = Ball_Y + Velocity(Y) "Vertical"
    
    mov ax, WINDOW_BOUNDS
    cmp BALL_Y, ax
    JL NEG_VELOCITY_Y           ; Collesion with Upper Boundry

    mov ax, WINDOW_HEIGHT
    sub ax, BALL_SIZE
    sub ax, WINDOW_BOUNDS
    cmp BALL_Y, ax
    JG NEG_VELOCITY_Y           ; Collesion with Lower Boundry

    ret

    RESET_POSITION:
        call RESET_BALL_POSITION
        ret

    NEG_VELOCITY_Y:
        NEG BALL_VELOCITY_Y
        ret
MOV_BALL ENDP

MOVE_PADDLES PROC NEAR
    ; left paddel Movement
    ; [1]: Check if a key is pressed "https://www.stanislavs.org/helppc/int_16.html"
    mov ah, 01h
    int 16h
    JZ CHECK_RIGHT_PADDLE_MOVEMENT
    
    ;;;;;;;;;;;;;;;;;; WHICH KEY WAS PRESSED ;;;;;;;;;;;;;;;;;
    ; to check which key was pressed
    mov ah, 00h  ; read the char > al
    int 16h
    ; check if 'w' was pressed
    CMP al, 77h  ; w
    je MOVE_LEFT_PADDLE_UP
    CMP al, 57h  ; W
    je MOVE_LEFT_PADDLE_UP
    ; check if 's' was pressed
    CMP al, 73h  ; s
    je MOVE_LEFT_PADDLE_DOWN
    CMP al, 53h  ; S
    je MOVE_LEFT_PADDLE_DOWN
    JMP CHECK_RIGHT_PADDLE_MOVEMENT
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MOVE_LEFT_PADDLE_UP:
        mov ax, PADDLE_VELOCITY
        sub PADDLE_LEFT_Y, ax
        mov ax, WINDOW_BOUNDS
        cmp PADDLE_LEFT_Y, ax
        JL FIX_PADDLE_LEFT_TOP_POSITION
        JMP CHECK_RIGHT_PADDLE_MOVEMENT
    FIX_PADDLE_LEFT_TOP_POSITION:
        mov ax, WINDOW_BOUNDS
        mov PADDLE_LEFT_Y, ax
        jmp CHECK_RIGHT_PADDLE_MOVEMENT

    MOVE_LEFT_PADDLE_DOWN:
        mov ax, PADDLE_VELOCITY
        add PADDLE_LEFT_Y, ax
        mov ax, WINDOW_HEIGHT
        sub ax, WINDOW_BOUNDS
        sub ax, PADDLE_HEIGHT
        cmp PADDLE_LEFT_Y, ax
        JG FIX_PADDLE_LEFT_BOTTOM_POSITION
        JMP CHECK_RIGHT_PADDLE_MOVEMENT
    FIX_PADDLE_LEFT_BOTTOM_POSITION:
        mov PADDLE_LEFT_Y, ax
        jmp CHECK_RIGHT_PADDLE_MOVEMENT

    ; right paddel movement
    CHECK_RIGHT_PADDLE_MOVEMENT:
        ;;;;;;;;;;;;;;;;;; WHICH KEY WAS PRESSED ;;;;;;;;;;;;;;;;;
        ; check if 'o' was pressed
        CMP al, 6Fh  ; o
        je MOVE_RIGHT_PADDLE_UP
        CMP al, 4Fh  ; O
        je MOVE_RIGHT_PADDLE_UP
        ; check if 's' was pressed
        CMP al, 6Ch  ; l
        je MOVE_RIGHT_PADDLE_DOWN
        CMP al, 4Ch  ; L
        je MOVE_RIGHT_PADDLE_DOWN
        JMP EXIT_PROC
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    MOVE_RIGHT_PADDLE_UP:
        mov ax, PADDLE_VELOCITY
        sub PADDLE_RIGHT_Y, ax
        mov ax, WINDOW_BOUNDS
        cmp PADDLE_RIGHT_Y, ax
        JL FIX_PADDLE_RIGHT_TOP_POSITION
        JMP EXIT_PROC
    FIX_PADDLE_RIGHT_TOP_POSITION:
        mov ax, WINDOW_BOUNDS
        mov PADDLE_RIGHT_Y, ax
        jmp EXIT_PROC

    MOVE_RIGHT_PADDLE_DOWN:
        mov ax, PADDLE_VELOCITY
        add PADDLE_RIGHT_Y, ax
        mov ax, WINDOW_HEIGHT
        sub ax, WINDOW_BOUNDS
        sub ax, PADDLE_HEIGHT
        cmp PADDLE_RIGHT_Y, ax
        JG FIX_PADDLE_RIGHT_BOTTOM_POSITION
        JMP EXIT_PROC
    FIX_PADDLE_RIGHT_BOTTOM_POSITION:
        mov PADDLE_RIGHT_Y, ax
        jmp EXIT_PROC

    EXIT_PROC:
        ret
MOVE_PADDLES ENDP



RESET_BALL_POSITION PROC NEAR
    mov ax, BALL_ORIGINAL_X
    mov BALL_X, ax
    mov ax, BALL_ORIGINAL_Y
    mov BALL_Y, ax
    ret
RESET_BALL_POSITION ENDP


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
        ; Check IF AX >= BALL_SIZE THEN Jump next line ELSE continue
        cmp ax, BALL_SIZE
        JNG DRAW_BALL_HORIZANTAL
        ; "Finished drawing HORIZANTAL line"
        mov cx, BALL_X  ; set cx to initial
        inc dx          ; go to the next line
        ; AX := get DX - Ball_Y
        mov ax, dx
        sub ax, BALL_Y
        ; Check IF AX >= BALL_SIZE THEN Jump exit proc ELSE continue
        cmp ax, BALL_SIZE
        JNG DRAW_BALL_HORIZANTAL
    ; exit 
    ret
DRAW_BALL ENDP

DRAW_PADDLES PROC NEAR
    ; start position
    mov cx, PADDLE_LEFT_X ; set the initial x-position (Column)
    mov dx, PADDLE_LEFT_Y ; set the initial y-position (raws - lines)
    
    DRAW_PADDLE_LEFT_HORIZANTAL:
        mov ah, 0Ch    ; draw pixil mode
        mov al, 0Fh    ; white color
        mov bh, 00h    ; set page number
        int 10h

        INC CX         ; cx = cx + 1
        ; AX := get Cx - PADDLE_LEFT_X
        mov ax, cx
        sub ax, PADDLE_LEFT_X
        ; Check IF AX >= PADDLE_WIDTH THEN Jump next line ELSE continue
        cmp ax, PADDLE_WIDTH
        JNG DRAW_PADDLE_LEFT_HORIZANTAL

        ; "Finished drawing HORIZANTAL line"
        mov cx, PADDLE_LEFT_X  ; set cx to initial
        inc dx          ; go to the next line
        ; AX := get DX - PADDLE_LEFT_Y
        mov ax, dx
        sub ax, PADDLE_LEFT_Y
        ; Check IF AX >= PADDLE_HEIGHT THEN Jump exit proc ELSE continue
        cmp ax, PADDLE_HEIGHT
        JNG DRAW_PADDLE_LEFT_HORIZANTAL

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; drawing right paddels
    ; start position
    mov cx, PADDLE_RIGHT_X ; set the initial x-position (Column)
    mov dx, PADDLE_RIGHT_Y ; set the initial y-position (raws - lines)
    
    DRAW_PADDLE_RIGHT_HORIZANTAL:
        mov ah, 0Ch    ; draw pixil mode
        mov al, 0Fh    ; white color
        mov bh, 00h    ; set page number
        int 10h

        INC CX         ; cx = cx + 1
        ; AX := get Cx - PADDLE_RIGHT_X
        mov ax, cx
        sub ax, PADDLE_RIGHT_X
        ; Check IF AX >= PADDLE_WIDTH THEN Jump next line ELSE continue
        cmp ax, PADDLE_WIDTH
        JNG DRAW_PADDLE_RIGHT_HORIZANTAL

        ; "Finished drawing HORIZANTAL line"
        mov cx, PADDLE_RIGHT_X  ; set cx to initial
        inc dx          ; go to the next line
        ; AX := get DX - PADDLE_RIGHT_Y
        mov ax, dx
        sub ax, PADDLE_RIGHT_Y
        ; Check IF AX >= PADDLE_HEIGHT THEN Jump exit proc ELSE continue
        cmp ax, PADDLE_HEIGHT
        JNG DRAW_PADDLE_RIGHT_HORIZANTAL
    ret 
DRAW_PADDLES ENDP


CLEAR_SCREEN PROC NEAR
    ; [1]: set video mode, plus which one "https://stanislavs.org/helppc/int_10-0.html"
    mov ah, 0h   ; set video mode
    mov al, 13h  ; configure video mode settings
    int 10h
    ; [2]: set backgroud "https://stanislavs.org/helppc/int_10-b.html"
    mov ah, 0bh  ; Set color palette
    mov bh, 00h  ; palette color ID - to set background and border color
    mov al, 00h  ; black color 
    int 10h
    ret
CLEAR_SCREEN ENDP

end main