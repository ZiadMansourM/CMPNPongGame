.model small 
.stack 64
.data
;put data here
msg db 'GAME OVER'
STR_LENGTH EQU 9
.code 
main proc
    mov ax,@data
    mov ds, ax

    call CLEAR_SCREEN               
    call GAME_OVER

    ;exit
    jmp $
main endp


GAME_OVER PROC NEAR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov si, @data                    ;moves to si the location in memory of the data segment
    mov es, si                       ;moves to es the location in memory of the data segment
    mov ah, 13h                      ;service to print string in graphic mode
    mov al, 0                        ;sub-service 0 all the characters will be in the same color(bl) and cursor position is not updated after the string is written
    mov bh, 0                        ;page number=always zero
    mov bl, 0Fh                      ;color of the text (white foreground 1111 and black background 0000 )
    mov cx, STR_LENGTH               ;length of string
    mov dl, 15                       ;Column 0 > 39
    mov dh, 12                       ;Row    0 > 24
    mov bp, offset msg               ;mov bp the offset of the string
    int 10h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ret
GAME_OVER ENDP


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