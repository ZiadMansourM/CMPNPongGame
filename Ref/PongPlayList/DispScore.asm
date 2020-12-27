.model small 
.stack 64
.data
;put data here
msg db 'hello'
LEFT_PLAYER_SCORE db 30h
CONCATINATE db ':'
RIGHT_PLAYER_SCORE db 30h
SCORE_LENGTH EQU 3h
;   VARS TO CONTROL MOVEMENT
OLD_TIME DB 0                               ; old time

.code 
main proc
    mov ax,@data
    mov ds, ax

    ;mov ah, 0h                                  ; set video mode
    ;mov al, 13h                                 ; configure video mode settings
    ;int 10h                                     ; Excute according to the above configurations "ah, al"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
            call DRAW_SCORE                        ; draw score
            jmp CHECK_TIME                         ; loop again



    ;exit
    jmp $
main endp


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