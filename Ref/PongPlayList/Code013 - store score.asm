; Trying to disp score
.model small 
.stack 64
.data
;   VARS TO CONTROLL COLLESION
    WINDOW_WIDTH dw 140h                        ; 320 Pixels
    WINDOW_HEIGHT dw 0C8h                       ; 200 Pixels
    WINDOW_BOUNDS DW 6h                         ; to check collesion early
;   VARS TO CONTROL MOVEMENT
    OLD_TIME DB 0                               ; old time
    BALL_ORIGINAL_X DW 0A0H                     ; X-position of the point of the center 
    BALL_ORIGINAL_Y DW 64H                      ; Y-position of the point of the center 
;   VARS TO DROW BALL
    BALL_X DW 0Ah                               ; "BALL" X position (cloumn)
    BALL_Y DW 0Ah                               ; "BALL" y position (row - line)
    BALL_SIZE DW 04h                            ; SIze of the ball 4-x 4-y
    BALL_VELOCITY_X DW 05h                      ; X-Velocity of the ball (Horizantal)
    BALL_VELOCITY_Y DW 02h                      ; Y-Velocity of the ball (Vertical)
;   VARS TO DROW LEFT_PADDELS
    PADDLE_LEFT_X dw 0Ah                        ; "LEFT-PADDLE" X position (cloumn)
    PADDLE_LEFT_Y DW 0Ah                        ; "LEFT-PADDLE" y position (row - line)
;   VARS TO DROW RIGHT_PADDELS
    PADDLE_RIGHT_X dw 130h                      ; "RIGHT-PADDLE" X position (cloumn)
    PADDLE_RIGHT_Y DW 0Ah                       ; "RIGHT-PADDLE" y position (row - line)
;   PADDELS SIZE
    PADDLE_WIDTH dw 05h                         ;  PADDLE Width  (how many columns)
    PADDLE_HEIGHT dw 1Fh                        ;  PADDLE Height (how many rows)
;   PADDEL VELOCITY
    PADDLE_VELOCITY dw 05h                      ; Paddel Vertical Velocity
;   SCORE VARS
    LEFT_PLAYER_SCORE db 30h                    ; score of the player at the left
    CONCATINATE db ':'                          ; used to display the score    
    RIGHT_PLAYER_SCORE db 30h                   ; score of the player at the right
    SCORE_LENGTH EQU 3                          ; used to display the score 
.code 
    main proc
        mov ax,@data
        mov ds, ax
        
        call CLEAR_SCREEN               
        
        CHECK_TIME:
;           get system time, more information @"http://spike.scu.edu.au/~barry/interrupts.html#ah2c"
            mov ah, 2Ch                            ; get the system time
            int 21h                                ; Return: CH = hour CL = minute DH = second DL = 1/100 seconds
            cmp dl, OLD_TIME                       ; compare old time with the one just returned from the system
            JE CHECK_TIME                          ; if (the same) THEN { check Time again;} ELSE { continue;}
            mov OLD_TIME, dl                       ; OLD_TIME := store current time

;           clear screen to draw next frame
            call CLEAR_SCREEN                      ; we create the Illosion of movement by "Clear - move - draw - clear ...." 

            call MOV_BALL                          ; move the ball
            call DRAW_SCORE
            call DRAW_BALL                         ; draw the ball

            call MOVE_PADDLES                      ; move paddles
            call DRAW_PADDLES                      ; draw paddles

            call DRAW_SCORE

            jmp CHECK_TIME                         ; loop again

;       Enters Infinte Loop       
        jmp $
;       return to operating system
        EXIT:
            mov ah,04ch                            ; "INT 21h, ah=04Ch" return to the operating system
            int 21h                                ; Excute according to the above configurations "ah" > return to the operating system
    main endp


;   this procedure handels all the logic behind setting the ball's position
    MOV_BALL PROC NEAR                           

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;       "Horizantal Movement"       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        mov ax,  BALL_VELOCITY_X                ; how mush shall the ball move in the x-direction   
        add BALL_X, ax                          ; x-position(ball) = x-position(ball) + Velocity(X) "Horizantal"
;       Check if their is collesions with the right boundries
        mov ax, WINDOW_BOUNDS                   ; left boundry
        cmp BALL_X, ax                          ; compares the x-position(ball) ~ left boundry
        JL RESET_POSITION_LEFT                  ; IF (less) {THEN Collesion with left Boundry;} ELSE {continue;}
;       Check if their is collesions with the left boundrie
        mov ax, WINDOW_WIDTH                    ; Window width
        sub ax, BALL_SIZE                       ; size of the ball
        sub ax, WINDOW_BOUNDS                   ; right boundry
        CMP BALL_X, ax                          ; compare x-position(ball) ~ [Window width - size of the ball - right boundry]
        JG RESET_POSITION_RIGHT                 ; IF (Greater) {THEN Collesion with right Boundry;} ELSE {continue;}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;       "Vertical Movement"       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        mov ax,  BALL_VELOCITY_Y                ; how mush shall the ball move in the Y-direction 
        add BALL_Y, ax                          ; Y-position(ball) = Y-position(ball)+ Velocity(Y) "Vertical"
;       Check if their is collesions with the upper boundries
        mov ax, WINDOW_BOUNDS                   ; Upper boundry
        cmp BALL_Y, ax                          ; compares the y-position(ball) ~ Upper boundry
        JL NEG_VELOCITY_Y                       ; IF (less) {THEN Collesion with Upper Boundry;} ELSE {continue;}
;       Check if their is collesions with the lower boundries
        mov ax, WINDOW_HEIGHT                   ; Window height
        sub ax, BALL_SIZE                       ; size of the ball
        sub ax, WINDOW_BOUNDS                   ; lower boundry
        cmp BALL_Y, ax                          ; compare Y-position(ball) ~ [Window height - size of the ball - lower boundry]
        JG NEG_VELOCITY_Y                       ; IF (Greater) {THEN Collesion with lower Boundry;} ELSE {continue;}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
        jmp NEXT
;       return if After setting the ball to center point as a result for hetting any of the left of right boundry 
        RESET_POSITION_LEFT:
            add RIGHT_PLAYER_SCORE, 1
            call RESET_BALL_POSITION
            ret
        RESET_POSITION_RIGHT:
            add LEFT_PLAYER_SCORE, 1
            call RESET_BALL_POSITION
            ret
        ;RESET_POSITION:
            call RESET_BALL_POSITION
            ret

;       return if After reversing the velocity of the ball due to hetting any of the Upper of lower boundry
        NEG_VELOCITY_Y:
            NEG BALL_VELOCITY_Y
            ret
        
        NEXT:
;       CHECK COLLISION, morre information @"https://www.azurefromthetrenches.com/introductory-guide-to-aabb-tree-collision-detection/"

;       check ball collision with the right paddle
        ; CONDITION: "maxx1 > minx2" && "minx1 < maxx2" && "maxy1 > miny1" && "miny1 < maxy2"
        ; PROJECTION OF THE ABOVE CONDITION USING OUR VARIABLES:
        ; "maxx1=(BALL_X + BALL_Size)" > "minx2=PADDLE_RIGHT_X" 
        ; &&
        ; "minx1=BALL_X" < "maxx2=(PADDLE_RIGHT_X + PADDLE_WIDTH)"
        ; && 
        ; "maxy1=(BALL_Y + BALL_SIZE)" > "miny1=PADDLE_RIGHT_Y"
        ; &&
        ; "miny1=BALL_Y" < "maxy2=(PADDLE_RIGHT_Y + PADDLE_HEIGHT)"

;       [1]: (BALL_X + BALL_Size) > PADDLE_RIGHT_X
        mov ax, BALL_X
        add ax, BALL_SIZE                       ; (BALL_X + BALL_Size) 
        cmp ax, PADDLE_RIGHT_X                  ; [1]: compares the (BALL_X + BALL_Size) ~ PADDLE_RIGHT_X
        JNG CHECK_COLLISION_LEFT_PADDLE         ; IF (Greater) THEN {Collesion with right paddle;} ELSE {Check if their exist a collision with left paddle;}
;       [2]: BALL_X < (PADDLE_RIGHT_X + PADDLE_WIDTH)
        mov ax, PADDLE_RIGHT_X
        add ax, PADDLE_WIDTH                    ; (PADDLE_RIGHT_X + PADDLE_WIDTH)
        cmp BALL_X, ax                          ; [2]: compares the BALL_X ~ (PADDLE_RIGHT_X + PADDLE_WIDTH)
        JNL CHECK_COLLISION_LEFT_PADDLE         ; IF (LESS) THEN {Collesion with right paddle;} ELSE {Check if their exist a collision with left paddle;}
;       [3]: (BALL_Y + BALL_SIZE) > PADDLE_RIGHT_Y
        mov ax, BALL_Y
        add ax, BALL_SIZE                       ; (BALL_Y + BALL_SIZE)
        cmp ax, PADDLE_RIGHT_Y                  ; [3]: compares the (BALL_Y + BALL_SIZE) ~ PADDLE_RIGHT_Y
        JNG CHECK_COLLISION_LEFT_PADDLE         ; IF (Greater) THEN {Collesion with right paddle;} ELSE {Check if their exist a collision with left paddle;}
;       [4]: BALL_Y < (PADDLE_RIGHT_Y + PADDLE_HEIGHT)
        mov ax, PADDLE_RIGHT_Y
        add ax, PADDLE_HEIGHT                   ; (PADDLE_RIGHT_Y + PADDLE_HEIGHT)
        cmp BALL_Y, ax                          ; [4]: compares the BALL_Y ~ (PADDLE_RIGHT_Y + PADDLE_HEIGHT)
        JNL CHECK_COLLISION_LEFT_PADDLE         ; IF (LESS) THEN {Collesion with right paddle;} ELSE {Check if their exist a collision with left paddle;}
;       THERE IS A COLLISION O_o with the right PADDLE
        NEG BALL_VELOCITY_X                     ; reverse the X-Velosity(Ball)
        ret

        CHECK_COLLISION_LEFT_PADDLE:
;       check ball collision with the left paddle
        ; [1]: (BALL_X + BALL_Size) > PADDLE_LEFT_X 
        ; && 
        ; [2]: BALL_X < (PADDLE_LEFT_X + PADDLE_WIDTH)
        ; && 
        ; [3]: (BALL_Y + BALL_SIZE) > PADDLE_LEFT_Y 
        ; && 
        ; [4]: BALL_Y < (PADDLE_LEFT_Y + PADDLE_HEIGHT)

;       [1]: (BALL_X + BALL_Size) > PADDLE_LEFT_X
        mov ax, BALL_X
        add ax, BALL_SIZE                       ; (BALL_X + BALL_Size) 
        cmp ax, PADDLE_LEFT_X                   ; [1]: compares the (BALL_X + BALL_Size) ~ PADDLE_LEFT_X
        JNG OUT_PROC                            ; IF (Greater) THEN {Collesion with left paddle;} ELSE {EXIT;}
;       [2]: BALL_X < (PADDLE_LEFT_X + PADDLE_WIDTH)
        mov ax, PADDLE_LEFT_X
        add ax, PADDLE_WIDTH                    ; (PADDLE_LEFT_X + PADDLE_WIDTH)
        cmp BALL_X, ax                          ; [2]: compares the BALL_X ~ (PADDLE_RIGHT_X + PADDLE_WIDTH)
        JNL OUT_PROC                            ; IF (LESS) THEN {Collesion with left paddle;} ELSE {EXIT;}
;       [3]: (BALL_Y + BALL_SIZE) > PADDLE_LEFT_Y
        mov ax, BALL_Y
        add ax, BALL_SIZE                       ; (BALL_Y + BALL_SIZE)
        cmp ax, PADDLE_LEFT_Y                   ; [3]: compares the (BALL_Y + BALL_SIZE) ~ PADDLE_LEFT_Y
        JNG OUT_PROC                            ; IF (Greater) THEN {Collesion with left paddle;} ELSE ELSE {EXIT;}
;       [4]: BALL_Y < (PADDLE_LEFT_Y + PADDLE_HEIGHT)
        mov ax, PADDLE_LEFT_Y
        add ax, PADDLE_HEIGHT                   ; (PADDLE_LEFT_Y + PADDLE_HEIGHT)
        cmp BALL_Y, ax                          ; [4]: compares the BALL_Y ~ (PADDLE_LEFT_Y + PADDLE_HEIGHT)
        JNL OUT_PROC                            ; IF (LESS) THEN {Collesion with left paddle;} ELSE ELSE {EXIT;}
;       THERE IS A COLLISION O_o with the left PADDLE
        NEG BALL_VELOCITY_X                     ; reverse the X-Velosity(Ball)
        ret

        OUT_PROC:
;       return if every thing is okay while setting the positions 
        ret

    MOV_BALL ENDP


DRAW_SCORE PROC NEAR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov si, @data                    ;moves to si the location in memory of the data segment
    mov es, si                       ;moves to es the location in memory of the data segment
    mov ah, 13h                      ;service to print string in graphic mode
    mov al, 0                        ;sub-service 0 all the characters will be in the same color(bl) and cursor position is not updated after the string is written
    mov bh, 0                        ;page number=always zero
    mov bl, 00001111b                ;color of the text (white foreground 1111 and black background 0000 )
    mov cx, SCORE_LENGTH             ;length of string
    mov dl, 18                       ;Column 0 > 39
    mov dh, 2                        ;Row    0 > 24
    mov bp, offset LEFT_PLAYER_SCORE ;mov bp the offset of the string
    int 10h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ret

DRAW_SCORE ENDP


;   this procedure handels all the logic behind setting the paddles' positions
    MOVE_PADDLES PROC NEAR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;       "LEFT PADDLE MOVEMENT"       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;        Check if a key is pressed - DON't WAIT
        mov ah, 01h                                 ; Get Keyboard Status
        int 16h                                     ; Excute according to the above configurations "ah" - DON'T WAIT
        JZ CHECK_RIGHT_PADDLE_MOVEMENT              ; ZF = 0 if a key pressed  >>> 1: check if a player is trying to move the right paddle
        
    ;;;;;;;;;;;;;;;;;; WHICH KEY WAS PRESSED ;;;;;;;;;;;;;;;;;
    ;   to check which key was pressed
        mov ah, 00h                                 ; read the char > al
        int 16h                                     ; Excute according to the above configurations "ah"
    ;   check if 'w', 'W' was pressed
        CMP al, 77h                                 ; 'w' = 77h
        je MOVE_LEFT_PADDLE_UP                      ; move the left paddle up
        CMP al, 57h                                 ; 'W' = 57h 
        je MOVE_LEFT_PADDLE_UP                      ; move the left paddle up
    ;   check if 's', 'S' was pressed
        CMP al, 73h                                 ; 's' = 73h
        je MOVE_LEFT_PADDLE_DOWN                    ; move the left paddle down
        CMP al, 53h                                 ; 'S' = 53h
        je MOVE_LEFT_PADDLE_DOWN                    ; move the left paddle down
    ;   Nothing of the expecting keys THEN {Check if they are related to the right paddel;}
        JMP CHECK_RIGHT_PADDLE_MOVEMENT
    ;;;;;;;;;;;;;;;; END: WHICH KEY WAS PRESSED ;;;;;;;;;;;;;;;

;       Move left paddle "up"
        MOVE_LEFT_PADDLE_UP:
            mov ax, PADDLE_VELOCITY                 ; how mush shall the paddle move in the Y-direction
            sub PADDLE_LEFT_Y, ax                   ; mov paddle
            mov ax, WINDOW_BOUNDS                   ; upper boundry
            cmp PADDLE_LEFT_Y, ax                   ; compares the y-position(paddel) ~ upper boundry
            JL FIX_LEFT_PADDLE_TOP_POSITION         ; IF(LESS) THEN {Fix the position of the left paddle;} ELSE {continue;}
            JMP CHECK_RIGHT_PADDLE_MOVEMENT         ; check if a player is trying to move the right paddle
;       correct the paddle position if it exceded the upper boundry
        FIX_LEFT_PADDLE_TOP_POSITION:
            mov ax, WINDOW_BOUNDS                   ; upper boundry
            mov PADDLE_LEFT_Y, ax                   ; sets the Y-position(paddle) := upper boundry
            jmp CHECK_RIGHT_PADDLE_MOVEMENT         ; check if a player is trying to move the right paddle
;       Move left paddle "down"
        MOVE_LEFT_PADDLE_DOWN:
            mov ax, PADDLE_VELOCITY                 ; how mush shall the paddle move in the Y-direction
            add PADDLE_LEFT_Y, ax                   ; mov paddle
            mov ax, WINDOW_HEIGHT                   ; Window height "the height of the screen"
            sub ax, WINDOW_BOUNDS                   ; the lower boundry
            sub ax, PADDLE_HEIGHT                   ; the height of the paddle
            cmp PADDLE_LEFT_Y, ax                   ; compare Y-position(paddle) ~ [Window height - lower boundry - height of the paddle]
            JG FIX_PADDLE_LEFT_BOTTOM_POSITION      ; IF (Greater) {Fix the position of the right paddle;} ELSE {continue;}
            JMP CHECK_RIGHT_PADDLE_MOVEMENT         ; check if a player is trying to move the right paddle
;       correct the paddle position if it exceded the lower boundry
        FIX_PADDLE_LEFT_BOTTOM_POSITION:
            mov PADDLE_LEFT_Y, ax                   ; sets the Y-position(paddle) := [Window height - lower boundry - height of the paddle]
            jmp CHECK_RIGHT_PADDLE_MOVEMENT         ; check if a player is trying to move the right paddle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     "END: LEFT PADDLE MOVEMENT"     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;       "RIGHT PADDLE MOVEMENT"       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;       check if a player is trying to move the right paddle
        CHECK_RIGHT_PADDLE_MOVEMENT:
        ;;;;;;;;;;;;;;;;;; WHICH KEY WAS PRESSED ;;;;;;;;;;;;;;;;;
        ;   check if 'o', 'O' was pressed
            CMP al, 6Fh                             ; 'o' = 6Fh
            je MOVE_RIGHT_PADDLE_UP                 ; move the right paddle up
            CMP al, 4Fh                             ; 'O' = 4Fh
            je MOVE_RIGHT_PADDLE_UP                 ; move the right paddle up
        ;   check if 's', 'S' was pressed
            CMP al, 6Ch                             ; 'l' = 6Ch 
            je MOVE_RIGHT_PADDLE_DOWN               ; move the right paddle down
            CMP al, 4Ch                             ; 'L' = 4Ch
            je MOVE_RIGHT_PADDLE_DOWN               ; move the right paddle down
        ;   Nothing of the expecting keys THEN {EXIT;}
            JMP EXIT_PROC
        ;;;;;;;;;;;;;;;; END: WHICH KEY WAS PRESSED ;;;;;;;;;;;;;;;

;       Move right paddle "up"
        MOVE_RIGHT_PADDLE_UP:                       
            mov ax, PADDLE_VELOCITY                 ; how mush shall the paddle move in the Y-direction
            sub PADDLE_RIGHT_Y, ax                  ; mov paddle
            mov ax, WINDOW_BOUNDS                   ; upper boundry
            cmp PADDLE_RIGHT_Y, ax                  ; compares the y-position(paddel) ~ upper boundry
            JL FIX_PADDLE_RIGHT_TOP_POSITION        ; IF(LESS) THEN {Fix the position of the right paddle;} ELSE {continue;}
            JMP EXIT_PROC                           ; Everything went smoothly THEN {DONE, EXIT;}
;       correct the paddle position if it exceded the upper boundry
        FIX_PADDLE_RIGHT_TOP_POSITION:
            mov ax, WINDOW_BOUNDS                   ; upper boundry
            mov PADDLE_RIGHT_Y, ax                  ; sets the Y-position(paddle) := upper boundry
            jmp EXIT_PROC                           ; Everything went smoothly THEN {DONE, EXIT;}
;       Move right paddle "down"
        MOVE_RIGHT_PADDLE_DOWN:
            mov ax, PADDLE_VELOCITY                 ; how mush shall the paddle move in the Y-direction
            add PADDLE_RIGHT_Y, ax                  ; mov paddle
            mov ax, WINDOW_HEIGHT                   ; Window height "the height of the screen"
            sub ax, WINDOW_BOUNDS                   ; the lower boundry
            sub ax, PADDLE_HEIGHT                   ; the height of the paddle
            cmp PADDLE_RIGHT_Y, ax                  ; compare Y-position(paddle) ~ [Window height - lower boundry - height of the paddle]
            JG FIX_PADDLE_RIGHT_BOTTOM_POSITION     ; IF (Greater) {Fix the position of the right paddle;} ELSE {continue;}
            JMP EXIT_PROC                           ; Everything went smoothly THEN {DONE, EXIT;}
;       correct the paddle position if it exceded the lower boundry
        FIX_PADDLE_RIGHT_BOTTOM_POSITION:
            mov PADDLE_RIGHT_Y, ax                  ; sets the Y-position(paddle) := [Window height - lower boundry - height of the paddle]
        jmp EXIT_PROC                               ; Everything went smoothly THEN {DONE, EXIT;}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     "END: Right PADDLE MOVEMENT"     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        EXIT_PROC:
            ret

    MOVE_PADDLES ENDP


;   this ptocedure recet the ball to the center of the screen
    RESET_BALL_POSITION PROC NEAR

        mov ax, BALL_ORIGINAL_X                     ; the X-position(center)
        mov BALL_X, ax                              ; X-position(ball)
        mov ax, BALL_ORIGINAL_Y                     ; Y-position(center)
        mov BALL_Y, ax                              ; Y-position(ball)
        ret

    RESET_BALL_POSITION ENDP


;   This procedure handels all the logic behind drawing the ball
    DRAW_BALL PROC NEAR

        mov cx, BALL_X                              ; set the initial X-position(ball) (Column)
        mov dx, BALL_Y                              ; set the initial Y-position(ball) (raws - lines)
;       Start drawing
        DRAW_BALL_HORIZANTAL:
;           Configure the screen to the draw pexil mode
            mov ah, 0Ch                             ; draw pixil mode
            mov al, 0Fh                             ; white color (ball)
            mov bh, 00h                             ; set page number
            int 10h                                 ; Excute according to the above configurations "ah, al, bh"
            
            INC CX                                  ; cx:"x-position" = cx:"x-position" + 1
;           AX := cx - X-position(ball)
            mov ax, cx                              ; the new X-position(ball)
            sub ax, BALL_X                          ; AX := new X-position(ball) - previous X-position(ball)
;           Check IF (AX >= BALL_SIZE) THEN {Draw the next "line || raw";} ELSE {continue;}
            cmp ax, BALL_SIZE                       ; AX := Size(Ball)
            JNG DRAW_BALL_HORIZANTAL                ; continue drawing the current "line || row"

;           "NEW HORIZANTAL line"
            mov cx, BALL_X                          ; set cx to initial X-position(ball) (Column)
            inc dx                                  ; go to the next line
;           AX := DC - Y-position(ball)
            mov ax, dx                              ; the new Y-position(ball)
            sub ax, BALL_Y                          ; AX := new Y-position(ball) - previous Y-position(ball)
;           Check IF (AX >= BALL_SIZE) THEN {EXIT;} ELSE {continue;}
            cmp ax, BALL_SIZE                       ; AX := Size(Ball)
            JNG DRAW_BALL_HORIZANTAL                ; continue drawing the current "line || row"
;       EXIT 
        ret

    DRAW_BALL ENDP


;   This procedure handels all the logic behind drawing the paddles
    DRAW_PADDLES PROC NEAR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  "Drawing The left paddle"  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        mov cx, PADDLE_LEFT_X                       ; set the initial X-position(LEFT_paddle) (Column)
        mov dx, PADDLE_LEFT_Y                       ; set the initial Y-position(LEFT_paddle) (raws - lines)

        DRAW_PADDLE_LEFT_HORIZANTAL:
;           Configure the screen to the draw pexil mode
            mov ah, 0Ch                             ; draw pixil mode
            mov al, 0Fh                             ; white color (paddle)
            mov bh, 00h                             ; set page number
            int 10h                                 ; Excute according to the above configurations "ah, al, bh"

            INC CX                                  ; cx:"x-position" = cx:"x-position" + 1
;           AX := cx - X-position(paddle)
            mov ax, cx                              ; the new X-position(paddle)
            sub ax, PADDLE_LEFT_X                   ; AX := new X-position(paddle) - previous X-position(paddle)
;           Check IF (AX >= Paddle Width) THEN {Draw the next "line || raw";} ELSE {continue;}
            cmp ax, PADDLE_WIDTH                    ; AX := Width(paddle)
            JNG DRAW_PADDLE_LEFT_HORIZANTAL         ; continue drawing the current "line || row"

;           "NEW HORIZANTAL line"
            mov cx, PADDLE_LEFT_X                   ; set cx to initial X-position(paddle) (Column)
            inc dx                                  ; go to the next line
;           AX := DC - Y-position(paddle)
            mov ax, dx                              ; the new Y-position(paddle)
            sub ax, PADDLE_LEFT_Y                   ; AX := new Y-position(paddle) - previous Y-position(paddle)
;           Check IF (AX >= Paddle Height) THEN {Draw The Right Paddle;} ELSE {continue;}
            cmp ax, PADDLE_HEIGHT                   ; AX := Height(paddle)
            JNG DRAW_PADDLE_LEFT_HORIZANTAL         ; continue drawing the current "line || row"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  "END: Drawing The left paddle"  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  "Drawing The right paddle"  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        mov cx, PADDLE_RIGHT_X                      ; set the initial X-position(RIGHT_paddle) (Column)
        mov dx, PADDLE_RIGHT_Y                      ; set the initial Y-position(RIGHT_paddle) (raws - lines)
        
        DRAW_PADDLE_RIGHT_HORIZANTAL:
;           Configure the screen to the draw pexil mode
            mov ah, 0Ch                             ; draw pixil mode
            mov al, 0Fh                             ; white color (paddle)
            mov bh, 00h                             ; set page number
            int 10h                                 ; Excute according to the above configurations "ah, al, bh"

            INC CX                                  ; cx:"x-position" = cx:"x-position" + 1
;           AX := cx - X-position(paddle)
            mov ax, cx                              ; the new X-position(paddle)
            sub ax, PADDLE_RIGHT_X                  ; AX := new X-position(paddle) - previous X-position(paddle)
;           Check IF (AX >= Paddle Width) THEN {Draw the next "line || raw";} ELSE {continue;}
            cmp ax, PADDLE_WIDTH                    ; AX := Width(paddle)
            JNG DRAW_PADDLE_RIGHT_HORIZANTAL        ; continue drawing the current "line || row"

;           "NEW HORIZANTAL line"
            mov cx, PADDLE_RIGHT_X                  ; set cx to initial X-position(paddle) (Column)
            inc dx                                  ; go to the next line
;           AX := DC - Y-position(paddle)
            mov ax, dx                              ; the new Y-position(paddle)
            sub ax, PADDLE_RIGHT_Y                  ; AX := new Y-position(paddle) - previous Y-position(paddle)
;           Check IF (AX >= Paddle Height) THEN {EXIT;} ELSE {continue;}
            cmp ax, PADDLE_HEIGHT                   ; AX := Height(paddle)
            JNG DRAW_PADDLE_RIGHT_HORIZANTAL        ; continue drawing the current "line || row"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  "END: Drawing The right paddle"  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        ret

    DRAW_PADDLES ENDP


;   This procedure helps in creating the Illosion of movement by clearing the screen 
    CLEAR_SCREEN PROC NEAR

;       set video mode, more information @"https://stanislavs.org/helppc/int_10-0.html"
        mov ah, 0h                                  ; set video mode
        mov al, 13h                                 ; configure video mode settings
        int 10h                                     ; Excute according to the above configurations "ah, al"
;       set backgroud, more information @"https://stanislavs.org/helppc/int_10-b.html"
        mov ah, 0bh                                 ; Set color palette
        mov bh, 00h                                 ; palette color ID - to set background and border color
        mov al, 00h                                 ; black color 
        int 10h                                     ; Excute according to the above configurations "ah, al, bh"

        ret

    CLEAR_SCREEN ENDP


end main