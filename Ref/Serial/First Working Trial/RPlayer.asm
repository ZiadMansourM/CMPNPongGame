.model small
.stack
.data
MESSAGE DB 'Serial communication lab', 0AH, 0DH
	    DB '-This is the transmitter PC-', 0AH, 0DH
	    DB 'PRESS ESC TO EXIT', 0AH, 0DH,'$'
TRANS   DB 'A' 
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

;   sending a value
    ;[1]: check that the transmitter holding register is empty
    mov dx, 3fdh        ; line status register
    AGAIN:
        in al, dx       ; read line status register
        test al, 00100000b
        JZ AGAIN        ; NOT EMPTY

        mov dx, 3f8h    ; trasmit data register
        mov al, TRANS   ; send 'A' to the other PC
        out dx, al
    jmp AGAIN
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