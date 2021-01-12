; Trying to disp score
.model small 
.stack 64
.data
;   ========== CHAT MODULE VARIABLES ==========
    TRANS_MESSAGE DB '-This is the transmitter PC-', '$'
    TRANS_MSG db  15, ?, 15 dup('$') 
    ;PREPARE_FOR_SENDING DB 'SENDING: "', 0AH, 0DH, '$'
    DONE_SENDING DB 0AH, 0DH, '$'
    CURSER_ROW DB 1
    CURSER_COL DB 1
    END_CHAT_MESSAGE_PART1 DB '-To end chatting with $'
    LENGTH_END_CHAT_MESSAGE EQU 22
    END_CHAT_MESSAGE_PART2 DB 'Press F3$'
;DASHED_LINE db '--------------------------------------------------------------------------------','$'
; TO RECEIVE
    CURSER_ROW_REC DB 16
    CURSER_COL_REC DB 1
    RECEIVE_MSG db  15, ?, 15 dup('$'), 0AH, 0DH,'$'
    PREPARE_RECEIVE_MSG db  'PLAYER: ', '$'
    PREPARE_SEND_MSG db  'PLAYER: ', '$'
    REASSIGN_VAR db 24h
;   ========== VARS TO CONTROLL COLLESION ==========
    WINDOW_WIDTH dw 280h                        ; 320 Pixels 640
    WINDOW_HEIGHT dw 165h                        ; 120 Pixels 480 => old value 180 <=
    WINDOW_BOUNDS DW 6h                         ; to check collesion early
;   ========== Status bar variables ==========
    STATUS_BAR_START_ROW_UPPER_PART db 22       ; the start of the status bar => Score part
    STATUS_BAR_START_ROW_LOWER_PART db 28       ; the start of the status bar => end game part
    STATUS_BAR_START_ROW_MIDDLE_PART db 25      ; the start of the status bar => in-game chat part
    LEFT_PLAYER_INGAME_MESSAGE DB 35, ?, 35 dup('$')
    RIGHT_PLAYER_INGAME_MESSAGE DB 35, ?, 35 dup('$')
    FLAG_lEFT_PLAYER_MESSAGE DB 00H             ; To check if a string was entered before
    FLAG_RIGHT_PLAYER_MESSAGE DB 00H
    TO_CONCATINATE_STRINGS DB ' : $'
    SWITCH_BETWEEN_PLAYERS DB 'To switch the chat with the other player Press enter then F5, ESC => end chat','$'
;   ========== VARS TO CONTROL MOVEMENT ==========
    OLD_TIME DB 0                                           ; old time
    BALL_ORIGINAL_X DW 140h                                 ; X-position of the point of the center 
    BALL_ORIGINAL_Y DW 0c0h                                 ; Y-position of the point of the center 
;   ========== VARS TO DROW BALL ==========
    BALL_X DW 140h                                          ; "BALL" X position (cloumn)
    BALL_Y DW 0c0h                                          ; "BALL" y position (row - line)
    BALL_SIZE DW 8h                                         ; SIze of the ball 4-x 4-y
    BALL_VELOCITY_X_ARR DW 05h,04h,03h,04h,02h,05h,03h      ; velocity values in x direction for level 1 
    BALL_VELOCITY_X_ARR_2 DW 07h,03h,05h,04h,06h,02h,06h    ; velocity values in x direction for level 2
    BALL_VELOCITY_X DW 05h                                  ; current ball velocity in x direction
    BALL_VELOCITY_Y_ARR DW 02h,04h,05h,03h,05h,03h,04h      ; velocity values in y direction for level 1
    BALL_VELOCITY_Y_ARR_2 DW 02h,06h,05h,06h,03h,07h,04h    ; velocity values in y direction for level 2
    BALL_VELOCITY_Y DW 02h                                  ; current ball velocity in y direction
    BALL_VELOCITY_CURRENT DW 0                              ; index of the current velocity to loop the arrays
    BALL_VELOCITY_TOT DB 0  
;   ========== VARS TO DROW LEFT_PADDELS ==========
    PADDLE_LEFT_X dw 0Ah                                    ; "LEFT-PADDLE" X position (cloumn)
    PADDLE_LEFT_Y DW 0Ah                                    ; "LEFT-PADDLE" y position (row - line)
;   ========== VARS TO DROW RIGHT_PADDELS ==========
    PADDLE_RIGHT_X dw 624                                   ; "RIGHT-PADDLE" X position (cloumn)
    PADDLE_RIGHT_Y DW 0Ah                       ; "RIGHT-PADDLE" y position (row - line)
;   ========== PADDELS SIZE ==========
    PADDLE_WIDTH dw 05h                         ;  PADDLE Width  (how many columns)
    PADDLE_HEIGHT dw 3Fh                        ;  PADDLE Height (how many rows)
    PADDLE_ELONGATED_HEIGHT DW 6FH
    PADDLE_LEFT_HEIGHT dw 3Fh         
    PADDLE_RIGHT_HEIGHT dw 3Fh                
;   ========== PADDEL VELOCITY ==========
    PADDLE_VELOCITY dw 07h                      ; Paddel Vertical Velocity
;   ========== VARS USED in GAVE_OVER Page ==========
    msg db 'GAME OVER'
    STR_LENGTH EQU 15
;   ========== SCORE VARS ==========
    OPEN_PRACIKT db ' ('
    LEFT_PLAYER_SCORE db 30h                 ; First digit of the score of the player at the left
    CONCATINATE db ':'                          ; used to display the score    
    RIGHT_PLAYER_SCORE db 30h                ; First digit of the score of the player at the right
    SCORE_LENGTH EQU 3                          ; used to display the score
    CLOSE_PRACIKT db ')'
    MSG_TO_DISPLAY_SCORE__IN_GAME_MODE db "'s Score: ", '$'
;   ========== LEVEL number ==========
    SCORE_LIMIT db 35h
    LEVEL db 00h 
;   ========== Player user name ==========
    WLCOME_MSG_PLAYER1 db  'Please Enter your Name:', 10, 9, 9, 9, 9, '$'
    WLCOME_MSG_PLAYER2 db  'Please Enter your Name:', 10, 9, 9, 9, 9, '$'
    MY_USER_NAME_PLAYER1       db  15, ?, 15 dup('$'), '$'
    MY_USER_NAME_PLAYER2       db  15, ?, 15 dup('$'), '$'
    WLCOME_MSG_LENGTH  EQU 28
    LAST_MSG           db  'Please Press any key to continue', '$'
    ERROR_NAME_MSG     db  10, 9, 'Your name should start with a letter, Please enter it again: ','$'
    DASHED_LINE db '--------------------------------------------------------------------------------','$'
;   ========== Transition between level One and Two ==========
    trans_msg_level          db  'LEVEL "2"'
    trans_msg_LENGTH   EQU 9
;   ========== Main Screen variables ==========
    start_chatting_msg db  '*To Start chatting press F1','$'
    start_PongGame_msg db  '*To Start Pong game press F2','$'
    end_game_msg       db  '*To end the program press ESC','$'
    start_row          db  9                  ; row position of main menu message 
    start_column       db 25                  ; row position of main menu message
    end_game_msg_part1 db '-To end the game with ', '$'
    end_game_msg_part2 db 'Press F4', '$'
    dummy_variable_to_count_strings_length db 0h 
;   ===========Elongation Card Variables=========
    Is_Two  db 2h    
    NEW_PADDLE_HEIGHT db 2fh
    LEFT_PADDLE_FLAG_HEIGHT db 0h
    RIGHT_PADDLE_FLAG_HEIGHT db 0h 
    ELONGATION_ONCE_LEFT DB  00H
    ELONGATION_ONCE_RIGHT DB  00H 
;   ===================freeze card variables================  
    Is_Three db 3h
    Right_Freeze_Flag db 0h
    Left_Freeze_Flag db 0h
    Froze_Once_Left db 00H
    Froze_Once_Right db 00H
;   ==================DOUBLE CARD VARIABLES==================
    COLLISION_COUNTER DB 00H

.code 
    main proc
        mov ax,@data
        mov ds, ax
	
	    call USER_NAME_PLAYER1
        call USER_NAME_PLAYER2
START_GAME: 
        mov LEFT_PLAYER_SCORE, 30h
        mov RIGHT_PLAYER_SCORE, 30h 
        call MAIN_MENU	
CHECK_AGAIN_ON_KEYPRESSED:
        mov ah,00h                             ; get keypress from user
        int 16h
        cmp ah, 03Bh                            ; Check if F1 was pressed (Scan code of F1 = 3B )
        JZ CHATTING_MODE 
        cmp ah, 03Ch                           ; Check if F2 was pressed (Scan code of F2 = 3C )
        JZ GAME_MODE 
        cmp ah, 01h                            ; Check if ESC was pressed (Scan code of ESC = 01 )
        JZ EXIT2 
; else none of the keys corresponds to a valid command (take a keypress again)
	 jmp CHECK_AGAIN_ON_KEYPRESSED

    EXIT2:
	     mov ah, 04ch
		 int 21h

CHATTING_MODE:
    call CHAT_MODE
    jmp START_GAME

GAME_MODE:
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
            call STATUS_BAR
            mov ah,01h                          ; get keypress from user to check if user pressed F4
            int 16h
            cmp ah, 03Eh                        ; Check if F4 was pressed (Scan code of F4 = 01 )
            JE START_GAME 

            call MOV_BALL                          ; move the ball
            call DRAW_BALL                         ; draw the ball

            CAll CHECK_ELONGATE_CARD                ;call the Elongate card
            CAll CHECK_FREZE_CARD                  ;call the freeze card

            call MOVE_PADDLES                      ; move paddles
            
            call DRAW_PADDLES                      ; draw paddles

            call DRAW_SCORE                        ; draw score

;           if reached the limit score of level one
            mov al, SCORE_LIMIT
            cmp LEFT_PLAYER_SCORE, al
            JE NEXT_LEVEL
            mov al, SCORE_LIMIT
            cmp RIGHT_PLAYER_SCORE, al
            JE NEXT_LEVEL

            jmp CHECK_TIME                         ; loop again

        NEXT_LEVEL:
            cmp LEVEL, 01h
            JE GAME_OVER_ALERT
            ;transferring x values for velocity from the array specified for level 2
            mov cx,7                                ; the number of possible values for velocity
            mov di,offset BALL_VELOCITY_X_ARR       ; the old array to change valuues
            mov si,offset BALL_VELOCITY_X_ARR_2     ; the array to copy values from
            REP MOVSW                               ; trasferring vlues
            ;transferring y values for velocity from the array specified for level 2
            mov cx,7                                ; the number of possible values for velocity
            mov di,offset BALL_VELOCITY_Y_ARR       ; the old array to change valuues
            mov si,offset BALL_VELOCITY_Y_ARR_2     ; the array to copy values from
            REP MOVSW                               ; trasferring vlues
            mov LEVEL, 01h                          ; previous value was 0
            mov SCORE_LIMIT, 39h                    ; 39 = '9', previous value was 35h = '5'
            call CLEAR_SCREEN
            call TRANSITION
            jmp CHECK_TIME
        GAME_OVER_ALERT:
            call CLEAR_SCREEN
            call GAME_OVER

;       Enters Infinte Loop       
        jmp $
;       return to operating system
        EXIT:
            mov ah,04ch                            ; "INT 21h, ah=04Ch" return to the operating system
            int 21h                                ; Excute according to the above configurations "ah" > return to the operating system
    main endp
    
;========================================================================== USER NAME PROCEDURE ==========================================================================
;=============== Player 1 ===============
USER_NAME_PLAYER1 PROC NEAR
	                       mov ah, 0h                   	; set video mode
	                       mov al, 03h                  	; configure video mode settings
	                       int 10h
	;Set cursor position to row 9 and column 25 and print welcome message
	                       mov ah, 02h                  	; int 10h on ah = 02h => Set cursor position
	                       mov dh, start_row            	; row 9
	                       mov dl, start_column         	; column 25
	                       int 10h
	                       mov ah , 09h
	                       mov dx, offset WLCOME_MSG_PLAYER1
	                       int 21h

	;   Wait user input and validate it => should start with a letter
    ;   should exist between 41h 'A' - 5Ah 'Z' or between 61h 'a' - 7Ah 'z'
	TAKE_INPUT_AGAIN:      
	                       mov ah, 0Ah                      ; get input from user
	                       mov dx, offset MY_USER_NAME_PLAYER1
	                       int 21h

	                       mov ah, MY_USER_NAME_PLAYER1[2]          ; move first character to ah to check on it

	                       cmp ah, 40h                      ; if character greater than 'A' => check if it is less than 'Z' 
	                       JG  CHECK_LESS_CAPITAL_Z         ; else => check if it is between 'a' and 'z'

	CHECK_SMALL_CHARACTERS:
	                       cmp ah, 60h                      ; if character greater than 'a' => check if it is less than 'z' 
	                       JG  CHECK_LESS_SMALL_Z           ; else => invalid character, take input again

	                       mov ah , 09h
	                       mov dx, offset ERROR_NAME_MSG    ; print error message and loop again
	                       int 21h
	                       jmp TAKE_INPUT_AGAIN

	CHECK_LESS_CAPITAL_Z:  
	                       mov ah, MY_USER_NAME_PLAYER1[2]
	                       cmp ah, 5Bh 
	                       JL  CONTINUE                    ; if character less than 'Z' => valid character and continue the program
	                       jmp CHECK_SMALL_CHARACTERS      ; else => it could be lower case character => check them

	CHECK_LESS_SMALL_Z:    
	                       mov ah, MY_USER_NAME_PLAYER1[2]
	                       cmp ah, 7Bh
	                       JL  CONTINUE                    ; if character less than 'Z' => valid character and continue the program
	                       mov ah , 09h                    ; else => print error message and loop again
	                       mov dx, offset ERROR_NAME_MSG
	                       int 21h
	                       jmp TAKE_INPUT_AGAIN
        

	CONTINUE:              
	;Set cursor position to row 9 and column 25 and print this message 'Press any key to continue'

                            mov ah,03h                       ; get cursor current position
                            int 10h

                            mov ah, 02h                  	; int 10h on ah = 02h => Set cursor position
                            add dh, 1                    	; row 13
                            mov dl, start_column         	; column 25
                            int 10h
                            mov ah , 09h
                            mov dx, offset LAST_MSG
                            int 21h

        ;Read any key to continue
                            mov ah, 00H
                            int 16h
                            ret
USER_NAME_PLAYER1 ENDP

;=============== Player 2 ===============
USER_NAME_PLAYER2 PROC NEAR
                            mov ah, 0h                   	; set video mode
                            mov al, 03h                  	; configure video mode settings
                            int 10h
        ;Set cursor position to row 9 and column 25 and print welcome message
                            mov ah, 02h                  	; int 10h on ah = 02h => Set cursor position
                            mov dh, start_row            	; row 9
                            mov dl, start_column         	; column 25
                            int 10h
                            mov ah , 09h
                            mov dx, offset WLCOME_MSG_PLAYER2
                            int 21h

	;   Wait user input and validate it => should start with a letter
    ;   should exist between 41h 'A' - 5Ah 'Z' or between 61h 'a' - 7Ah 'z'
    TAKE_INPUT_AGAIN_P2:      
                            mov ah, 0Ah                      ; get input from user
                            mov dx, offset MY_USER_NAME_PLAYER2
                            int 21h

                            mov ah, MY_USER_NAME_PLAYER2[2]          ; move first character to ah to check on it

                            cmp ah, 40h                      ; if character greater than 'A' => check if it is less than 'Z' 
                            JG  CHECK_LESS_CAPITAL_Z_P2         ; else => check if it is between 'a' and 'z'

    CHECK_SMALL_CHARACTERS_P2:
                            cmp ah, 60h                      ; if character greater than 'a' => check if it is less than 'z' 
                            JG  CHECK_LESS_SMALL_Z_P2           ; else => invalid character, take input again

                            mov ah , 09h
                            mov dx, offset ERROR_NAME_MSG    ; print error message and loop again
                            int 21h
                            jmp TAKE_INPUT_AGAIN_P2

    CHECK_LESS_CAPITAL_Z_P2:  
                            mov ah, MY_USER_NAME_PLAYER2[2]
                            cmp ah, 5Bh 
                            JL  CONTINUE_P2                    ; if character less than 'Z' => valid character and continue the program
                            jmp CHECK_SMALL_CHARACTERS_P2      ; else => it could be lower case character => check them

    CHECK_LESS_SMALL_Z_P2:    
                            mov ah, MY_USER_NAME_PLAYER2[2]
                            cmp ah, 7Bh
                            JL  CONTINUE_P2                    ; if character less than 'Z' => valid character and continue the program
                            mov ah , 09h                    ; else => print error message and loop again
                            mov dx, offset ERROR_NAME_MSG
                            int 21h
                            jmp TAKE_INPUT_AGAIN_P2
        

	CONTINUE_P2:              
	;Set cursor position to row 9 and column 25 and print this message 'Press any key to continue'

                        mov ah,03h                       ; get cursor current position
                        int 10h

                        mov ah, 02h                  	; int 10h on ah = 02h => Set cursor position
                        add dh, 1                    	; row 13
                        mov dl, start_column         	; column 25
                        int 10h
                        mov ah , 09h
                        mov dx, offset LAST_MSG
                        int 21h

	;Read any key to continue
                        mov ah, 00H
                        int 16h
                        ret
USER_NAME_PLAYER2 ENDP
;========================================================================== MOVE BALL PROCEDURE ==========================================================================
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
        JL far ptr NEG_VELOCITY_Y_TEMP_TRANS                ; IF (less) {THEN Collesion with Upper Boundry;} ELSE {continue;}
;       Check if their is collesions with the lower boundries
        mov ax, WINDOW_HEIGHT                   ; Window height
        sub ax, BALL_SIZE                       ; size of the ball
        sub ax, WINDOW_BOUNDS                   ; lower boundry
        cmp BALL_Y, ax                          ; compare Y-position(ball) ~ [Window height - size of the ball - lower boundry]
        JG  far ptr NEG_VELOCITY_Y_TEMP_TRANS   ; IF (Greater) {THEN Collesion with lower Boundry;} ELSE {continue;}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
        jmp NEXT
        NEG_VELOCITY_Y_TEMP_TRANS:
        JMP NEG_VELOCITY_Y_TEMP
;       return if After setting the ball to center point as a result for hetting any of the left of right boundry 
        RESET_POSITION_LEFT:
            cmp COLLISION_COUNTER,0Ah
            JL  NORMAL_POINTS_RIGHT
            ADD RIGHT_PLAYER_SCORE,2
            MOV COLLISION_COUNTER,00H
            JMP DOUBLE_POINTS_RIGHT
            NORMAL_POINTS_RIGHT:
            add RIGHT_PLAYER_SCORE, 1
            DOUBLE_POINTS_RIGHT:
;           added for freeze card
            mov Left_Freeze_Flag,00H
;           end of freeze card
;           added for Elongation card 
            MOV AX ,PADDLE_HEIGHT
            MOV PADDLE_LEFT_HEIGHT,AX
;           finish addinf for elongation card
            ADD BALL_VELOCITY_CURRENT,2     ; to get the index of the next velocity(2 as it is an array of words) 
            INC BALL_VELOCITY_TOT
            cmp BALL_VELOCITY_CURRENT,12h   ; the last index in our array
            JLE CHANGING_VELOCITY           ;when we are in the appropriate range
            mov BALL_VELOCITY_CURRENT,0h    ;if we got away of the array we start again from 0 index 
            call RESET_BALL_POSITION        
            ret
        RESET_POSITION_RIGHT:
            cmp COLLISION_COUNTER,0ah
            JL  NORMAL_POINTS_LEFT
            ADD LEFT_PLAYER_SCORE,2
            MOV COLLISION_COUNTER,00H
            JMP DOUBLE_POINTS_LEFT
            NORMAL_POINTS_LEFT:
            add LEFT_PLAYER_SCORE, 1
            DOUBLE_POINTS_LEFT:
;           added for freeze card right  
            mov Right_Freeze_Flag ,00H
;           end of freeze card right
;           added for elongation card
            MOV AX ,PADDLE_HEIGHT
            MOV PADDLE_RIGHT_HEIGHT,AX
;           finish add for elongation
            ADD BALL_VELOCITY_CURRENT,2     ; to get the index of the next velocity(2 as it is an array of words) 
            INC BALL_VELOCITY_TOT
            cmp BALL_VELOCITY_CURRENT,12h   ; the last index in our array
            JLE CHANGING_VELOCITY           ;when we are in the appropriate range
            mov BALL_VELOCITY_CURRENT,0h    ;if we got away of the array we start again from 0 index 
            jmp CHANGING_VELOCITY
            NEG_VELOCITY_Y_TEMP: jmp NEG_VELOCITY_Y
        CHANGING_VELOCITY:
            lea bx,BALL_VELOCITY_X_ARR      ; gettig the offset of the x array
            add bx,BALL_VELOCITY_CURRENT    ; getting the value in the current index
            mov ax,[bx]                     ; getting the value in ax in order to move it to another place in memory
            mov BALL_VELOCITY_X,ax          ; refreshing the value of x velocity
            lea bx,BALL_VELOCITY_Y_ARR      ; gettig the offset of the y array
            add bx,BALL_VELOCITY_CURRENT    ; getting the value in the current index
            mov ax,[bx]                     ; getting the value in ax in order to move it to another place in memory
            mov BALL_VELOCITY_X,ax
            mov al,BALL_VELOCITY_TOT
            mov BALL_VELOCITY_Y,ax          ; refreshing the value of y velocity
            mov al,BALL_VELOCITY_TOT
            mov bl,04
            div bl
            cmp ah,0
            JE AFTER_CHANGING_VELOCITY
            cmp ah,1
            JE NegateX
            cmp ah,2
            JE NegateXY
            cmp ah,3
            JE NegateY
            NegateX:neg BALL_VELOCITY_X
            JMP AFTER_CHANGING_VELOCITY
            NegateY:neg BALL_VELOCITY_Y
            JMP AFTER_CHANGING_VELOCITY
            NegateXY:neg BALL_VELOCITY_X
            neg BALL_VELOCITY_Y
            AFTER_CHANGING_VELOCITY: call RESET_BALL_POSITION
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
        add ax, PADDLE_RIGHT_HEIGHT             ; (PADDLE_RIGHT_Y + PADDLE_HEIGHT)
        cmp BALL_Y, ax                          ; [4]: compares the BALL_Y ~ (PADDLE_RIGHT_Y + PADDLE_HEIGHT)
        JNL CHECK_COLLISION_LEFT_PADDLE         ; IF (LESS) THEN {Collesion with right paddle;} ELSE {Check if their exist a collision with left paddle;}
;       THERE IS A COLLISION O_o with the right PADDLE
        add COLLISION_COUNTER,1h                ; Counts the coolison with paddles
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
        add ax, PADDLE_LEFT_HEIGHT              ; (PADDLE_LEFT_Y + PADDLE_HEIGHT)
        cmp BALL_Y, ax                          ; [4]: compares the BALL_Y ~ (PADDLE_LEFT_Y + PADDLE_HEIGHT)
        JNL OUT_PROC                            ; IF (LESS) THEN {Collesion with left paddle;} ELSE ELSE {EXIT;}
;       THERE IS A COLLISION O_o with the left PADDLE
        add COLLISION_COUNTER,1h                ; Counts the coolison with paddles
        NEG BALL_VELOCITY_X                     ; reverse the X-Velosity(Ball)
        ret

        OUT_PROC:
;       return if every thing is okay while setting the positions 
        ret

    MOV_BALL ENDP

;========================================================================== DRAW SCORE PROCEDURE ==========================================================================
DRAW_SCORE PROC NEAR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Draw Left Player Score ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov si, @data                    ;moves to si the location in memory of the data segment
    mov es, si                       ;moves to es the location in memory of the data segment
    mov ah, 13h                      ;service to print string in graphic mode
    mov al, 0                        ;sub-service 0 all the characters will be in the same color(bl) and cursor position is not updated after the string is written
    mov bh, 0                        ;page number=always zero
    mov bl, 0Ah                      ;color of the text (white foreground 1111 and black background 0000 )
    mov cx, SCORE_LENGTH             ;length of string
    mov dl, 38                       ;Column 0 > 40
    mov dh, 2                        ;Row    0 > 25
    mov bp, offset LEFT_PLAYER_SCORE ;mov bp the offset of the string
    int 10h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ret

DRAW_SCORE ENDP

;========================================================================== MOVE PADDLES PROCEDURE ==========================================================================
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
    ;   check for the freezing state of the leftplayer
        cmp Left_Freeze_Flag,1H
        JE CHECK_RIGHT_PADDLE_MOVEMENT  
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
;       check if the left paddle y is correct
            mov ax, WINDOW_HEIGHT                   ; Window height "the height of the screen"
            sub ax, WINDOW_BOUNDS                   ; the lower boundry
            sub ax, PADDLE_LEFT_HEIGHT              ; the height of the paddle
            cmp PADDLE_LEFT_Y, ax                   ; compare Y-position(paddle) ~ [Window height - lower boundry - height of the paddle]
            JG FIX_PADDLE_LEFT_BOTTOM_POSITION      ; IF (Greater) {Fix the position of the right paddle;} ELSE {continue;}
            JMP CHECK_RIGHT_PADDLE_MOVEMENT         ; check if a player is trying to move the right paddle
;       correct the paddle position if it exceded the lower boundry
        FIX_PADDLE_LEFT_BOTTOM_POSITION:            ; FIX: ELONGATION WITHOUT PRESSING KEYS
            mov PADDLE_LEFT_Y, ax                   ; sets the Y-position(paddle) := [Window height - lower boundry - height of the paddle]
            jmp CHECK_RIGHT_PADDLE_MOVEMENT         ; check if a player is trying to move the right paddle

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     "END: LEFT PADDLE MOVEMENT"     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;       "RIGHT PADDLE MOVEMENT"       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;       check if a player is trying to move the right paddle
        CHECK_RIGHT_PADDLE_MOVEMENT:
        ;;;;;;;;;;;;;;;;;; WHICH KEY WAS PRESSED ;;;;;;;;;;;;;;;;;
        ;   check for the freezing state of the leftplayer
        cmp Right_Freeze_Flag,1H
        JE EXIT_PROC
        ;   check if up_arrow key was pressed
            CMP ah, 72                              ; 72 is the scan code of the up arrow key
            je MOVE_RIGHT_PADDLE_UP                 ; move the right paddle up
        ;   check if down_arrow was pressed
            CMP ah, 80                              ; 80 is the scan code of the down arrow key 
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
            sub ax, PADDLE_RIGHT_HEIGHT                   ; the height of the paddle
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

;======================================================================= RESET BALL POSITION PROCEDURE =======================================================================
;   this ptocedure recet the ball to the center of the screen
    RESET_BALL_POSITION PROC NEAR

        mov ax, BALL_ORIGINAL_X                     ; the X-position(center)
        mov BALL_X, ax                              ; X-position(ball)
        mov ax, BALL_ORIGINAL_Y                     ; Y-position(center)
        mov BALL_Y, ax                              ; Y-position(ball)
        ret

    RESET_BALL_POSITION ENDP

;========================================================================== DRAW BALL PROCEDURE ==========================================================================
;   This procedure handels all the logic behind drawing the ball
    DRAW_BALL PROC NEAR

        mov cx, BALL_X                              ; set the initial X-position(ball) (Column)
        mov dx, BALL_Y                              ; set the initial Y-position(ball) (raws - lines)
;       Start drawing
        DRAW_BALL_HORIZANTAL:
;           Configure the screen to the draw pexil mode
            mov ah, 0Ch                             ; draw pixil mode
            mov al, 0Eh                             ; white color (ball)
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

;========================================================================== DRAW PADDLES PROCEDURE ==========================================================================
;   This procedure handels all the logic behind drawing the paddles
    DRAW_PADDLES PROC NEAR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  "Drawing The left paddle"  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        mov cx, PADDLE_LEFT_X                       ; set the initial X-position(LEFT_paddle) (Column)
        mov dx, PADDLE_LEFT_Y                       ; set the initial Y-position(LEFT_paddle) (raws - lines)

        DRAW_PADDLE_LEFT_HORIZANTAL:
;           Configure the screen to the draw pexil mode
            mov ah, 0Ch                             ; draw pixil mode
            mov al, RIGHT_PLAYER_SCORE
            cmp LEFT_PLAYER_SCORE, al
            JG GREEN_LEFT
            JL RED_LEFT
            mov al, 0Fh                             ; white color (paddle)
            jmp WHIET_LEFT
            GREEN_LEFT:
            mov al, 0Ah                             ; green color
            jmp WHIET_LEFT
            RED_LEFT:
            mov al, 04h                             ; RED color
            jmp WHIET_LEFT
            WHIET_LEFT:
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
            cmp ax, PADDLE_LEFT_HEIGHT                   ; AX := Height(paddle)
            JNG DRAW_PADDLE_LEFT_HORIZANTAL         ; continue drawing the current "line || row"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  "END: Drawing The left paddle"  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  "Drawing The right paddle"  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        mov cx, PADDLE_RIGHT_X                      ; set the initial X-position(RIGHT_paddle) (Column)
        mov dx, PADDLE_RIGHT_Y                      ; set the initial Y-position(RIGHT_paddle) (raws - lines)
        
        DRAW_PADDLE_RIGHT_HORIZANTAL:
;           Configure the screen to the draw pexil mode
            mov ah, 0Ch                             ; draw pixil mode
            mov al, LEFT_PLAYER_SCORE
            cmp RIGHT_PLAYER_SCORE, al
            JG GREEN_RIGHT
            JL RED_RIGHT
            mov al, 0Fh                             ; white color (paddle)
            jmp WHIET_RIGHT
            GREEN_RIGHT:
            mov al, 0Ah                             ; green color
            jmp WHIET_RIGHT
            RED_RIGHT:
            mov al, 04h                             ; RED color
            jmp WHIET_RIGHT
            WHIET_RIGHT:
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
            cmp ax, PADDLE_RIGHT_HEIGHT                   ; AX := Height(paddle)
            JNG DRAW_PADDLE_RIGHT_HORIZANTAL        ; continue drawing the current "line || row"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  "END: Drawing The right paddle"  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        ret

    DRAW_PADDLES ENDP

;========================================================================== CLEAR SCREEN PROCEDURE ==========================================================================
;   This procedure helps in creating the Illosion of movement by clearing the screen 
    CLEAR_SCREEN PROC NEAR
;       set video mode, more information @"https://stanislavs.org/helppc/int_10-0.html"
        mov ah, 00h                                  ; set video mode
        mov al, 12h                                 ; configure video mode settings
        int 10h                                     ; Excute according to the above configurations "ah, al"
;       set backgroud, more information @"https://stanislavs.org/helppc/int_10-b.html"
        mov ah, 0bh                                 ; Set color palette
        mov bh, 00h                                 ; palette color ID - to set background and border color
        mov bl, 00h                                 ; black color 
        int 10h                                     ; Excute according to the above configurations "ah, al, bh"
	
        ret

    CLEAR_SCREEN ENDP

;========================================================================= STATUS BAR PROCEDURE =========================================================================
STATUS_BAR PROC NEAR 
;Set cursor position to row 15 and column 0 and print a dashed line 
	     mov ah, 02h
	     mov dh, STATUS_BAR_START_ROW_UPPER_PART     	; row 15
	     mov dl, 0                        	; column 0
	     int 10h
         mov ah, 09h                        ; print dashed line
	     mov dx, offset DASHED_LINE 
	     int 21h 
; ========== Player 1 score ==========
;Set cursor position to row 11 and column 0 and print the score of the players
         mov ah, 02h
         mov al, STATUS_BAR_START_ROW_UPPER_PART
         add al, 1
	     mov dh, al                       	; row 16
	     mov dl, 0                        	; column 0
	     int 10h
         mov ah, 09h                        ; print player's user name
	     mov dx, offset MY_USER_NAME_PLAYER1[2] 
	     int 21h 
;Count the length of the left player username  to set the cursor position after it
                     mov SI, offset MY_USER_NAME_PLAYER1[2]
                     mov ch, 0h
    STRING1_NOT_ENDED:
                     cmp byte PTR [SI], 24h
					 JE DONE_COUNTING1 
					 INC ch
					 INC SI 
					 jmp STRING1_NOT_ENDED
    DONE_COUNTING1:
                     ;add ch, 30h 
					 sub ch, 1h

         mov ah, 02h                         ; Set cursor position
	     mov dh, al                          ; row 16
	     mov dl, ch                          ; column after the name's length
	     int 10h
         mov ah, 09h                        ; print this message => 's score: 
	     mov dx, offset MSG_TO_DISPLAY_SCORE__IN_GAME_MODE 
	     int 21h 
; display score of left player 
         mov ah, 02h                         ; print player's score
         mov dl, LEFT_PLAYER_SCORE          ; character t be printed
         int 21h
; ========== player 2 score ==========
;Count the length of the left player username to set the cursor position after it
                     mov SI, offset MY_USER_NAME_PLAYER2[2]
                     mov ch, 0h
    STRING4_NOT_ENDED:
                     cmp byte PTR [SI], 24h
					 JE DONE_COUNTING4 
					 INC ch
					 INC SI 
					 jmp STRING4_NOT_ENDED
    DONE_COUNTING4:
                     mov dummy_variable_to_count_strings_length, ch 
;Count the length of "'s score: " message to set the cursor position after it
                     mov SI, offset MSG_TO_DISPLAY_SCORE__IN_GAME_MODE
                     mov ch, 0h
    STRING5_NOT_ENDED:
                     cmp byte PTR [SI], 24h
					 JE DONE_COUNTING5 
					 INC ch
					 INC SI 
					 jmp STRING5_NOT_ENDED
    DONE_COUNTING5:
                     add ch, dummy_variable_to_count_strings_length
                     add ch, 2                ; to leave space for the score                   
;Set cursor position to row 11 and column 0 and print the score of the players
         mov ah, 02h
         mov al, STATUS_BAR_START_ROW_UPPER_PART
         add al, 1
         mov cl, 80                         ; number of columns
         sub cl, ch
	     mov dh, al                       	; row 16
	     mov dl, cl                        	; column 0
	     int 10h
         mov ah, 09h                        ; print player's user name
	     mov dx, offset MY_USER_NAME_PLAYER2[2] 
	     int 21h 

         mov ah, 02h                         ; Set cursor position
	     mov dh, al                          ; row 16
         add cl, dummy_variable_to_count_strings_length
	     mov dl, cl                          ; column after the name's length
	     int 10h
         mov ah, 09h                         ; print this message => 's score: 
	     mov dx, offset MSG_TO_DISPLAY_SCORE__IN_GAME_MODE 
	     int 21h 
; display score of right player 
         mov ah, 02h                         ; print player's score
         mov dl, RIGHT_PLAYER_SCORE          ; character t be printed
         int 21h
;Set cursor position to row 17 and column 0 and print a dashed line
	     mov ah, 02h
         mov al, STATUS_BAR_START_ROW_UPPER_PART
         add al, 2
	     mov dh, al                       	; row 17
	     mov dl, 0                        	; column 0
	     int 10h
         mov ah, 09h                        ; print dashed line
	     mov dx, offset DASHED_LINE 
	     int 21h 

; ===================== In game chat  =====================
         mov ah,01h                          ; Check keyboard buffer has keypressed or not
         int 16h                             ; ZF = 1 => keystroke not available, ZF = 0 => keystroke available
    ;   Check if player inserted a string
         cmp al,50h
         JE PRINT_DASHED_LINE_FIRST                     ; CHECK if P was pressed
         cmp al,70h
         JE PRINT_DASHED_LINE_FIRST                     ; CHECK if p was pressed
         JMP EXIT_IN_CHAT_GAME
PRINT_DASHED_LINE_FIRST:
; Consume the character in keyboard buffer
         mov ah,07h
         int 21h
;Set cursor position to row 24 and column 0 and print a dashed line
	     mov ah, 02h
	     mov dh, STATUS_BAR_START_ROW_LOWER_PART                  	; row 27
	     mov dl, 0                                               	; column 0
	     int 10h
         mov ah, 09h                        ; print dashed line
	     mov dx, offset DASHED_LINE 
	     int 21h 
;Print end game message 
         mov ah, 09h                        ; print this message => To end the game with
	     mov dx, offset SWITCH_BETWEEN_PLAYERS 
	     int 21h 

IN_GAME_CHAT_LEFT_PLAYER:
         call DRAW_PADDLES     
         call DRAW_BALL
         call DRAW_SCORE 
; This piece of code is just to clear the row 
         mov ah, 02h
         mov dh, STATUS_BAR_START_ROW_MIDDLE_PART    ; row 25                       	
	     mov dl, 0                                   ; column 0
	     int 10h
         mov ah, 09h
         mov al, 'A'
         mov bl, 00H 
         mov cx, 40
         int 10h

         mov ah, 02h
         mov dh, STATUS_BAR_START_ROW_MIDDLE_PART    ; row 25                       	
	     mov dl, 0                                   ; column 0
	     int 10h
         mov ah, 09h                                 ; print left player's user name
	     mov dx, offset MY_USER_NAME_PLAYER1[2] 
	     int 21h
         mov ah, 02h
         mov dh, STATUS_BAR_START_ROW_MIDDLE_PART    ; row 16  
         mov dl, MY_USER_NAME_PLAYER1[1]
	     int 10h
         mov ah, 09h                                 ; print ':'
	     mov dx, offset TO_CONCATINATE_STRINGS 
	     int 21h

         mov ah, 02h
         mov dh, STATUS_BAR_START_ROW_MIDDLE_PART      
         mov dl, MY_USER_NAME_PLAYER1[1]
	     add dl, 3
	     int 10h
         mov ah, 0Ah                      ; get input from user
	     mov dx, offset LEFT_PLAYER_INGAME_MESSAGE
         int 21h

         mov FLAG_lEFT_PLAYER_MESSAGE, 01H   
         jmp DUMMY_JUMP

;transition jump because jump out of range
TRANSITION_BETWEEN_PLAYERS3:
         cmp ah, 03FH                      ; IF user pressed ESC close in game chat
         JE IN_GAME_CHAT_LEFT_PLAYER
         
DUMMY_JUMP:
; ESC => to end chat, F5 => to switch between users
WAIT_USER_INPUT_LEFT:
         mov ah, 00H
         int 16h 
         cmp ah, 01H                      ; IF user pressed F5 switch between players
         JE TRANSITION_BETWEEN_PLAYERS2
         cmp ah, 03FH 
         JE IN_GAME_CHAT_RIGTH_PLAYER
         mov ah, 00h
         int 16h
         JMP WAIT_USER_INPUT_LEFT

IN_GAME_CHAT_RIGTH_PLAYER:
         call DRAW_PADDLES   
         call DRAW_BALL
         call DRAW_SCORE   
         jmp SKIP_THIS_PART

         ;transition jump because jump out of range
TRANSITION_BETWEEN_PLAYERS:
         cmp ah, 03FH                      ; IF user pressed ESC close in game chat
         JE TRANSITION_BETWEEN_PLAYERS3

SKIP_THIS_PART:
        ; This piece of code is just to clear the row 
         mov ah, 02h
         mov dh, STATUS_BAR_START_ROW_MIDDLE_PART    ; row 25    
         add dh, 2                   	
	     mov dl, 0                                   ; column 0
	     int 10h
         mov ah, 09h
         mov al, 'A'
         mov bl, 00H 
         mov cx, 40
         int 10h
         jmp PLAYER2

;transition jump because jump out of range
TRANSITION_BETWEEN_PLAYERS2:
         cmp ah, 01H                      ; IF user pressed F5 switch between players
         JE EXIT_IN_CHAT_GAME

PLAYER2:
         mov ah, 02h
         mov dh, STATUS_BAR_START_ROW_MIDDLE_PART    ; row 25  
         add dh, 2                    	
	     mov dl, 0                                   ; column 0
	     int 10h
         mov ah, 09h                                 ; print left player's user name
	     mov dx, offset MY_USER_NAME_PLAYER2[2] 
	     int 21h
         mov ah, 02h
         mov dh, STATUS_BAR_START_ROW_MIDDLE_PART    ; row 16  
         add dh, 2
         mov dl, MY_USER_NAME_PLAYER2[1]
	     int 10h
         mov ah, 09h                                 ; print ':'
	     mov dx, offset TO_CONCATINATE_STRINGS 
	     int 21h

         mov ah, 02h
         mov dh, STATUS_BAR_START_ROW_MIDDLE_PART      
         add dh, 2
         mov dl, MY_USER_NAME_PLAYER2[1]
	     add dl, 3
	     int 10h
         mov ah, 0Ah                      ; get input from user
	     mov dx, offset RIGHT_PLAYER_INGAME_MESSAGE
         int 21h

         mov FLAG_RIGHT_PLAYER_MESSAGE, 01H 

         ; ESC => to end chat, F5 => to switch between users
WAIT_USER_INPUT_RIGHT:
         mov ah, 00H
         int 16h 
         cmp ah, 01H                      ; IF user pressed ESC to end chat mode
         JE EXIT_IN_CHAT_GAME
         cmp ah, 03FH                     ; F5 => to switch between players
         JE TRANSITION_BETWEEN_PLAYERS
         mov ah,00h
         int 16h
         JMP WAIT_USER_INPUT_RIGHT

EXIT_IN_CHAT_GAME:
; ========== Player 1 message ==========
;Set cursor position to row 25 and column 0 and print the in-game chat of the players
         cmp FLAG_lEFT_PLAYER_MESSAGE, 00H 
         JE NO_CHAT_FOR_LEFT_PLAYER
         mov ah, 02h
         mov dh, STATUS_BAR_START_ROW_MIDDLE_PART    ; row 25                       	
	     mov dl, 0                                   ; column 0
	     int 10h
         mov ah, 09h                                 ; print left player's user name
	     mov dx, offset MY_USER_NAME_PLAYER1[2] 
	     int 21h
         mov ah, 02h
         mov dh, STATUS_BAR_START_ROW_MIDDLE_PART    ; row 16  
         mov dl, MY_USER_NAME_PLAYER1[1]
	     int 10h
         mov ah, 09h                                 ; print ':'
	     mov dx, offset TO_CONCATINATE_STRINGS 
	     int 21h

         mov ah, 02h
         mov dh, STATUS_BAR_START_ROW_MIDDLE_PART      
         mov dl, MY_USER_NAME_PLAYER1[1]
	     add dl, 3
	     int 10h
         mov ah, 09h                                 ; print left player's message
	     mov dx, offset LEFT_PLAYER_INGAME_MESSAGE[2] 
	     int 21h 

; ========== Player 2 message ==========
         cmp FLAG_RIGHT_PLAYER_MESSAGE, 00H 
NO_CHAT_FOR_LEFT_PLAYER:         
         JE NO_CHAT_YET
         mov ah, 02h
         mov dh, STATUS_BAR_START_ROW_MIDDLE_PART    ; row 25   
         add dh, 2                    	
	     mov dl, 0                                   ; column 0
	     int 10h
         mov ah, 09h                                 ; print left player's user name
	     mov dx, offset MY_USER_NAME_PLAYER2[2] 
	     int 21h
         mov ah, 02h
         mov dh, STATUS_BAR_START_ROW_MIDDLE_PART    ; row 16  
         add dh, 2
         mov dl, MY_USER_NAME_PLAYER2[1]
	     int 10h
         mov ah, 09h                                 ; print ':'
	     mov dx, offset TO_CONCATINATE_STRINGS 
	     int 21h

         mov ah, 02h
         mov dh, STATUS_BAR_START_ROW_MIDDLE_PART  
         add dh, 2    
         mov dl, MY_USER_NAME_PLAYER2[1]
	     add dl, 3
	     int 10h
         mov ah, 09h                                 ; print left player's message
	     mov dx, offset RIGHT_PLAYER_INGAME_MESSAGE[2] 
	     int 21h 

NO_CHAT_YET:
; ===================== End game part =====================
;Set cursor position to row 24 and column 0 and print a dashed line
	     mov ah, 02h
	     mov dh, STATUS_BAR_START_ROW_LOWER_PART                  	; row 27
	     mov dl, 0                                               	; column 0
	     int 10h
         mov ah, 09h                        ; print dashed line
	     mov dx, offset DASHED_LINE 
	     int 21h 
;Print end game message 
         mov ah, 09h                        ; print this message => To end the game with
	     mov dx, offset end_game_msg_part1 
	     int 21h 

         mov ah, 09h                        ; print the player's name 
	     mov dx, offset MY_USER_NAME_PLAYER1[2] 
	     int 21h
;Count the length of the first message to set the cursor position after it
                     mov SI, offset end_game_msg_part1
                     mov ch, 0h
    STRING2_NOT_ENDED:
                     cmp byte PTR [SI], 24h
					 JE DONE_COUNTING2 
					 INC ch
					 INC SI 
					 jmp STRING2_NOT_ENDED
    DONE_COUNTING2:
                     ;add ch, 30h 
					 ;sub ch, 1h
                     mov dummy_variable_to_count_strings_length, ch
;Count the length of the left player username to set the cursor position after it
                     mov SI, offset MY_USER_NAME_PLAYER1[2]
                     mov ch, 0h
    STRING3_NOT_ENDED:
                     cmp byte PTR [SI], 24h
					 JE DONE_COUNTING3 
					 INC ch
					 INC SI 
					 jmp STRING3_NOT_ENDED
    DONE_COUNTING3:
                     ;add ch, 30h 
					 ;sub ch, 1h
                     add ch, dummy_variable_to_count_strings_length

         mov ah, 02h                        ; Set cursor position
         mov dh, STATUS_BAR_START_ROW_LOWER_PART
	     add dh, 1                       	; row 28
	     mov dl, ch                        	; column after the name and first message length
	     int 10h
         mov ah, 09h                        ; print this message => Press F4
	     mov dx, offset end_game_msg_part2 
	     int 21h 

         ret 

STATUS_BAR ENDP 
;======================================================= MAIN MENU =======================================================
MAIN_MENU PROC NEAR
    mov ah, 00h                      	; set video mode
	mov al, 03h                      	; configure video mode settings (text mode 25 rows and 80 column)
	int 10h

;Set cursor position to row 9 and column 25 and print offset message (start chatting)
	mov ah, 02h                      	; int 10h on ah = 02h => Set cursor position
	mov dh, start_row                	; row 9
	mov dl, start_column             	; column 25
	int 10h
	mov ah, 09h
	mov dx, offset start_chatting_msg
	int 21h
;Set cursor position to row 13 and column 25 and print offset message (start game)
        mov ah, 02h
	mov cl,start_row
	add cl,2
	mov dh, cl                       	; row 11
	mov dl, start_column             	; column 25
	int 10h
	mov ah, 09h
	mov dx, offset start_PongGame_msg
	int 21h
;Set cursor position to row 11 and column 25 and print offset message (end program)
        mov ah, 02h
	mov cl,start_row
	add cl,4
	mov dh, cl                       	; row 13
	mov dl, start_column             	; column 25
	int 10h
	mov ah, 09h
	mov dx, offset end_game_msg
	int 21h
;Set cursor position to row 22 and column 0 and print a dashed line
	mov ah, 02h
	mov dh, 22                       	; row 22
	mov dl, 0                        	; column 0
	int 10h
	mov ah, 0Ah                             ; int 10h on ah = 0Ah => write character at cursor position
	mov cx, 80                              ; number of repetitions of the character '-'
	mov al, '-'                             ; character to be printed stored in al
	int 10h    
	
	ret
	
MAIN_MENU ENDP
;========================================================================== GAME OVER PROCEDURE ==========================================================================
GAME_OVER PROC NEAR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov si, @data                    ;moves to si the location in memory of the data segment
    mov es, si                       ;moves to es the location in memory of the data segment
    mov ah, 13h                      ;service to print string in graphic mode
    mov al, 0                        ;sub-service 0 all the characters will be in the same color(bl) and cursor position is not updated after the string is written
    mov bh, 0                        ;page number=always zero
    mov bl, 0Fh                      ;color of the text (white foreground 1111 and black background 0000 )
    mov cx, STR_LENGTH               ;length of string
    mov dl, 33                       ;Column 0:80
    mov dh, 12                       ;Row    0:25
    mov bp, offset msg               ;mov bp the offset of the string
    int 10h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ret

GAME_OVER ENDP

;========================================================================== TRANSITION PROCEDURE ==========================================================================
TRANSITION PROC NEAR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov si, @data                    ;moves to si the location in memory of the data segment
    mov es, si                       ;moves to es the location in memory of the data segment
    mov ah, 13h                      ;service to print string in graphic mode
    mov al, 0                        ;sub-service 0 all the characters will be in the same color(bl) and cursor position is not updated after the string is written
    mov bh, 0                        ;page number=always zero
    mov bl, 0Fh                      ;color of the text (white foreground 1111 and black background 0000 )
    mov cx, trans_msg_LENGTH         ;length of string
    mov dl, 36                       ;Column 0 > 80
    mov dh, 15                       ;Row    0 > 25
    mov bp, offset trans_msg_level         ;mov bp the offset of the string
    int 10h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    USER_INPUT:
        mov ah, 00h
        int 16h
;       users presses Enter
        cmp ah, 28
        JNZ USER_INPUT
    ret
TRANSITION ENDP

;=================================================================== Elongation Card =====================================================================
CHECK_ELONGATE_CARD PROC NEAR
;   for the left paddle
;   FRIST CHECK IF ELONGATED BEFORE?
    CMP ELONGATION_ONCE_LEFT,1h
    JE CHECK_RIGHT_PADDLE_FLAG
;   END OF CHECK
    mov al,LEFT_PLAYER_SCORE
    sub al,RIGHT_PLAYER_SCORE
    cmp al,Is_Two
    JE CHANGE_LEFT_PADDLE_HEIGHT
    jmp CHECK_RIGHT_PADDLE_FLAG

    CHANGE_LEFT_PADDLE_HEIGHT:
    MOV AX,PADDLE_ELONGATED_HEIGHT
    MOV PADDLE_LEFT_HEIGHT,AX
    MOV ELONGATION_ONCE_LEFT,1H  ;CHANGES THE STATUS TO MAKE SURE IT ALREADY ELONGATED BEFORE



;   for the right paddle
    CHECK_RIGHT_PADDLE_FLAG:
;   CHECK IF THE RIGHT PADDLE ELONGATED BEFORE OR NOT?
    CMP ELONGATION_ONCE_RIGHT,1h
    JE LEAVE_PROC
;   END OF CHECK
    mov al,RIGHT_PLAYER_SCORE
    sub al,LEFT_PLAYER_SCORE
    cmp al,Is_Two
    JE CHANGE_RIGHT_PADDLE_FLAG
    
    jmp LEAVE_PROC

    CHANGE_RIGHT_PADDLE_FLAG:
    MOV AX,PADDLE_ELONGATED_HEIGHT
    MOV PADDLE_RIGHT_HEIGHT,AX
    MOV ELONGATION_ONCE_RIGHT,1H ;CHANGES THE STATUS TO MAKE SURE IT ALREADY ELONGATED BEFORE

;   this label is done to leave this procedure
    LEAVE_PROC:
    ret

    ret
CHECK_ELONGATE_CARD ENDP


;======================================================FReeze card=========================================================
CHECK_FREZE_CARD PROC NEAR 
;   for the left player
;   Check if the freeze card was used once for his favour before or not for the left player
    cmp Froze_Once_Right,1H
    JE check_Left_Frozen_before
;   end of checking once  for the Freeze card for left player

;   start to check the freeze card conditions for the right player
    mov al,LEFT_PLAYER_SCORE
    sub al,RIGHT_PLAYER_SCORE
    cmp al,Is_Three
    JE change_Right_Freeze_Flag
    JMP check_Left_Frozen_before

    change_Right_Freeze_Flag:
    mov Right_Freeze_Flag,1H
    MOV Froze_Once_Right,1H             ;IF( PLAYER ACTIVATED THE FREEZE CARD AGAINST HIS OPPONENT ONCE HE WILL NOT BE ABLE TO CHANGE IT AGAIN)

    check_Left_Frozen_before:
;   Check if the freeze was used once before for his favour or not for the right player
    cmp  Froze_Once_Left,1H
    JE Leave_This_Proc
;   end of checking once  for the Freeze card for right player

;   start to check the freeze card conditions for the right player
    mov al,RIGHT_PLAYER_SCORE
    sub al,LEFT_PLAYER_SCORE
    cmp al,Is_Three
    JE change_Left_Freeze_Flag
    jmp Leave_This_Proc

    change_Left_Freeze_Flag:
    mov Left_Freeze_Flag,1H
    MOV Froze_Once_Left,1H             ;IF( PLAYER ACTIVATED THE FREEZE CARD AGAINST HIS OPPONENT ONCE HE WILL NOT BE ABLE TO CHANGE IT AGAIN)
;   this label is used to leave this procedure
Leave_This_Proc:

RET
CHECK_FREZE_CARD ENDP

;====================================================== CHAT MODULE =========================================================
;====================================================== PORT INITIALIZATION =========================================================
PORT_INTIALIZATION proc near
    ;[1]: ask to send baud rate
    mov dx, 3fbh        ; line control register
    mov al, 10000000b   ; set divisor latch access bit
    out dx, al      
    ;[2]: send LSB of the baud rate
    mov dx, 3f8h        ; Transmitter register
    mov al, 0Ch         ; LSB of baud rate
    out dx, al
    ;[3]: send MSB of the baud rate
    mov dx, 3f9h        ; MSB register
    mov al, 00h         ; MSB of baud rate
    out dx, al          ; baudrate = 000ch
    ;[4]: set port configuration
    mov dx, 3fbh        ; line control register
    mov al, 00011011b   ; "0":   access to receive, transmit buffer
                        ; "0":   set break disabled
                        ; "011": even parity
                        ; "0":   one stop bit
                        ; "11":  8-bits data
    out dx, al
    ret
PORT_INTIALIZATION endp

;====================================================== SEND STRING =========================================================
SEND_STRING PROC NEAR

        mov ah, 01h                                 ; Get Keyboard Status
        int 16h                                     ; Excute according to the above configurations "ah" - DON'T WAIT
        JZ EXIT_PROC_SEND                           ; ZF = 0 if a key pressed
        
        CMP CURSER_ROW, 14
        JNZ continue_sending
        mov ah, 6	; function 6 Scroll Window Up
        mov al, 1	; scroll by 1 line
        mov bh, 0	; normal video attrbute
        mov ch, 0   ; upper left Y
        mov cl, 0	; upper left X
        mov dh, 14	; lower right Y
        mov dl, 79	; lower right x
        int 10h
        continue_sending:
    ;   Set Curser
        mov ah, 02h                     ; int 10h on ah = 02h => Set cursor position
        mov dh, CURSER_ROW            	; row 1
        mov dl, CURSER_COL         	    ; column 25
        CMP CURSER_ROW, 14
        JZ skip
        add CURSER_ROW, 1
        skip:
        int 10h

        ; by millania
        mov ah, 01h 
        int 16h 
        cmp ah, 28 
        JNE DUMMY_JUMP2 
        mov ah, 00h
        int 16h 
        DUMMY_JUMP2:

        mov ah, 09
        mov dx, offset PREPARE_SEND_MSG
        int 21h

        mov ah, 0Ah                     ; get input from user "WAIT:"
        mov dx, offset TRANS_MSG
        int 21h

        ; next line
        mov ah, 09h     ; print dashed line
        mov dx, offset DONE_SENDING 
        int 21h

    ;   sending the TRANS_MSG
        mov ch, 00h
        mov cl, TRANS_MSG[1]
        mov DI, offset TRANS_MSG+2
        ;[1]: check that the transmitter holding register is empty
        AGAIN:
            mov dx, 3fdh    ; line status register
            in al, dx       ; read line status register
            test al, 00100000b
            JZ AGAIN        ; transmitter holding register NOT EMPTY
        ;   transmitter holding register IS EMPTY
            mov dx, 3f8h    ; trasmit data register
            mov al, [DI]    ; send key Byte to the other PC
            out dx, al      ; EXCUTE
        ;   prepare to send next byte
            INC DI
        loop AGAIN
        
        AGAIN_Last:
            mov dx, 3fdh    ; line status register
            in al, dx       ; read line status register
            test al, 00100000b
            JZ AGAIN_Last        ; transmitter holding register NOT EMPTY
        ;   transmitter holding register IS EMPTY
            mov dx, 3f8h    ; trasmit data register
            mov al, 24h     ; send key Byte to the other PC
            out dx, al      ; EXCUTE
        
        EXIT_PROC_SEND:
    ret
SEND_STRING ENDP

BOTTOM_CHAT PROC NEAR
; PRINTS A DASHED LINE AND THIS MESSAGE 'To end chatting with "player name" press F3'
;Set cursor position to row 24 and column 0 and print a dashed line
	     mov ah, 02h
	     mov dh, STATUS_BAR_START_ROW_LOWER_PART                  	; row 28
	     mov dl, 0                                               	; column 0
	     int 10h
         mov ah, 09h                        ; print dashed line
	     mov dx, offset DASHED_LINE 
	     int 21h 
;Print end game message 
         mov ah, 09h                        ; print this message => To end the chatting with
	     mov dx, offset END_CHAT_MESSAGE_PART1 
	     int 21h 

         mov ah, 09h                        ; print the player's name 
	     mov dx, offset MY_USER_NAME_PLAYER1[2] 
	     int 21h
         
;Count the length of the left player username to set the cursor position after it
                     mov SI, offset MY_USER_NAME_PLAYER1[2]
                     mov ch, 0h
    STRING3_NOT_ENDED10:
                     cmp byte PTR [SI], 24h
					 JE DONE_COUNTING7 
					 INC ch
					 INC SI 
					 jmp STRING3_NOT_ENDED10
    DONE_COUNTING7:
                     ;add ch, 30h 
					 ;sub ch, 1h
                     add ch, dummy_variable_to_count_strings_length

         mov dl, LENGTH_END_CHAT_MESSAGE    ; column after the name and first message length
         add dl, ch
         mov ah, 02h                        ; Set cursor position
         mov dh, STATUS_BAR_START_ROW_LOWER_PART
	     add dh, 1                       	; row 28                	
	     int 10h
         mov ah, 09h                        ; print this message => Press F3
	     mov dx, offset END_CHAT_MESSAGE_PART2 
	     int 21h

    ret
BOTTOM_CHAT ENDP
;====================================================== SEND STRING =========================================================
;   This procedure helps in creating the Illosion of movement by clearing the screen 
;CLEAR_SCREEN PROC NEAR
;       set video mode, more information @"https://stanislavs.org/helppc/int_10-0.html"
;    mov ah, 00h                                  ; set video mode
;    mov al, 12h                                 ; configure video mode settings
;    int 10h                                     ; Excute according to the above configurations "ah, al"
;       set backgroud, more information @"https://stanislavs.org/helppc/int_10-b.html"
;    mov ah, 0bh                                 ; Set color palette
;    mov bh, 00h                                 ; palette color ID - to set background and border color
;    mov bl, 00h                                 ; black color 
;    int 10h                                     ; Excute according to the above configurations "ah, al, bh"
;    ret
;CLEAR_SCREEN ENDP

;====================================================== SPLIT SCREEN =========================================================
SPLIT_SCREEN PROC NEAR
    ; split screen
        mov ah, 02h
        mov dh, 15     	; row 15
        mov dl, 0       ; column 0
        int 10h
        mov ah, 09h     ; print dashed line
        mov dx, offset DASHED_LINE 
        int 21h
    ret
SPLIT_SCREEN ENDP

;====================================================== RECIEVE BYTE =========================================================
RECEIVE_BYTE PROC NEAR
        mov dx, 3fdh    ; line status register
        in al, dx       ; read line status register
        test al, 1b
        JZ EXIT_RECEIVE_PROC    ; not ready "received nothing"

        mov DI, offset RECEIVE_MSG+2
        RECEIVE:
        mov dx, 3f8h    ; receive data register
        in al, dx
        cmp al, 24h
        JZ DISP
        mov [DI], al   ; STORE WHAT YOU RECEIVED
        INC DI
        ; check if something else have been received
        CHK_AGAIN:
        mov dx, 3fdh            ; line status register
        in al, dx               ; read line status register
        test al, 1b
        JNZ RECEIVE             ; "received something"
        jZ CHK_AGAIN

        DISP:
        CMP CURSER_ROW_REC, 27
        JNZ continue_REC
        mov ah, 6	; function 6 Scroll Window Up
        mov al, 1	; scroll by 1 line
        mov bh, 0	; normal video attrbute
        mov ch, 16  ; upper left Y
        mov cl, 0	; upper left X
        mov dh, 27	; lower right Y
        mov dl, 79	; lower right x
        int 10h
        continue_REC:
    ;   Set Curser
        mov ah, 02h                     ; int 10h on ah = 02h => Set cursor position
        mov dh, CURSER_ROW_REC            	; row 1
        mov dl, CURSER_COL_REC         	    ; column 25
        CMP CURSER_ROW_REC, 27
        JZ skip_REC
        add CURSER_ROW_REC, 1
        skip_REC:
        int 10h


        ; mov ah, 02h                     ; int 10h on ah = 02h => Set cursor position
        ; mov dh, CURSER_ROW_REC          ; row 9
        ; mov dl, CURSER_COL_REC        	; column 25
        ; add CURSER_ROW_REC, 1
        ; int 10h                         ; set curser position
        
        mov ah, 09
        mov dx, offset PREPARE_RECEIVE_MSG
        int 21h

        mov ah, 09
        mov dx, offset RECEIVE_MSG+2
        int 21h

        
        mov ch, 00h
        mov cl, RECEIVE_MSG
        mov DI, offset RECEIVE_MSG+2
        REASSIGN:
        mov al, REASSIGN_VAR
        mov [DI], al
        INC DI
        loop REASSIGN

        EXIT_RECEIVE_PROC:
    ret
RECEIVE_BYTE ENDP
;====================================================== CHAT MODE =========================================================
CHAT_MODE PROC NEAR 

;   Port Initialization
    call PORT_INTIALIZATION

    call CLEAR_SCREEN
    call SPLIT_SCREEN

;   Displaying Welcom Message
    mov ah, 02h                     ; int 10h on ah = 02h => Set cursor position
    mov dh, 0            	        ; row 9
    mov dl, 25         	            ; column 25
    int 10h                         ; set curser position
	mov ah, 09                      
	mov dx, offset TRANS_MESSAGE    ; Print the welcom message
	int 21h

    CHK:
        call BOTTOM_CHAT
        mov ah,01h                          ; get keypress from user to check if user pressed F4
        int 16h
        cmp ah, 61
        JZ EXIT_CHAT  
        call SEND_STRING
        call RECEIVE_BYTE
    jmp CHK

    ;jmp $
    EXIT_CHAT:
    ret	
    ;mov ah,4Ch
    ;int 21h

CHAT_MODE ENDP


end main
