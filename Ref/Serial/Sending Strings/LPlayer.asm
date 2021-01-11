.model small
.stack
.data
MESSAGE DB 'Serial communication lab.', 0AH, 0DH
	    DB '-This is the reciever PC-', 0AH, 0DH
	    DB 'PRESS ESC TO EXIT', 0AH, 0DH,'$'
VALUE   DB ?
START_rec_msg DB 'WE RECEIVED: "', '$'
END_rec_msg   DB '"', 0AH, 0DH, '$'
.code
main proc
	mov ax, @data
	mov ds, ax

;   Displaying Welcom Message
	mov ah, 09
	mov dx, offset MESSAGE
	int 21h
	
;   Port Initialization
    call PORT_INTIALIZATION

;   receiving a value
    ;[1]: check that data is ready "receieved data"
    CHK:
        mov dx, 3fdh    ; line status register
        in al, dx       ; read line status register
        test al, 1b
        JZ CHK          ; not ready "received nothing"

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

        jmp CHK
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

end main