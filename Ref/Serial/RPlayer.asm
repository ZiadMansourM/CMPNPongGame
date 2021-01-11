.model small
.stack
.data
TRANS_MESSAGE DB '-This is the transmitter PC-', '$'
TRANS_MSG db  15, ?, 15 dup('$') 
PREPARE_FOR_SENDING DB 'SENDING: "', 0AH, 0DH, '$'
DONE_SENDING DB 0AH, 0DH, '$'
CURSER_ROW DB 1
CURSER_COL DB 1
DASHED_LINE db '--------------------------------------------------------------------------------','$'
; TO RECEIVE
VALUE   DB ?
START_rec_msg DB 'WE RECEIVED: "', '$'
END_rec_msg   DB '"', 0AH, 0DH, '$'
.code
main proc
	mov ax, @data
	mov ds, ax

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
	mov dx, offset TRANS_MESSAGE    ; get input from user
	int 21h

    CHK:
        call SEND_STRING
        call RECEIVE_BYTE
    jmp CHK

    jmp $
main endp

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

SEND_STRING PROC NEAR
    ;   Get the trans Message
        mov ah, 02h                     ; int 10h on ah = 02h => Set cursor position
        mov dh, CURSER_ROW            	; row 9
        mov dl, CURSER_COL         	    ; column 25
        add CURSER_ROW, 1
        int 10h
        mov ah, 0Ah                     ; get input from user
        mov dx, offset TRANS_MSG
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
        ;   go to the next line to Get next Message
            mov ah, 09
            mov dx, offset DONE_SENDING
            int 21h
    ret
SEND_STRING ENDP

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

RECEIVE_BYTE PROC NEAR
        mov dx, 3fdh    ; line status register
        in al, dx       ; read line status register
        test al, 1b
        JZ EXIT_RECEIVE_PROC    ; not ready "received nothing"

        mov dx, 3f8h    ; receive data register
        in al, dx
        mov VALUE, al   ; STORE WHAT YOU RECEIVED

    ;   Displaying Start receive Message
        mov ah, 09
        mov dx, offset START_rec_msg
        int 21h
    
    ;   display what is received
        mov ah, 02h	; display char in dl
        mov dl, VALUE
        int 21h
    
    ;   Displaying end receive Message
        mov ah, 09
        mov dx, offset END_rec_msg
        int 21h

        EXIT_RECEIVE_PROC:
    ret
RECEIVE_BYTE ENDP
end main