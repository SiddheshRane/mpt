.model small
.stack 100h
.8086
.data
	msg1 db 10,13,"Enter the no 1: 0x$"
	msg2 db 10,13,"Enter the no 2: 0x$"
	endl db 10,13,"$"
	msg_hex db "0x$"
	msg_mul db " * $"
	msg_equ db " = $"

.code
	mov ax, @data
	mov ds, ax

	lea dx, msg1
	mov ah, 09h
	int 21h
	call input8
	mov bl, al

	lea dx, msg2
	mov ah, 09h
	int 21h
	call input8
	mov bh, al

	lea dx, endl
	mov ah, 09h
	int 21h

	lea dx, msg_hex
	mov ah, 09h
	int 21h

	mov ah, bl
	push ax
	mov ax, 2
	push ax
	call print8

	lea ax, msg_mul
	mov ah, 09h
	int 21h
	lea dx, msg_hex
	int 21h

	mov ah, bh
	push ax
	mov ax, 2
	push ax
	call print8

	mov ah, 0
	mov al, bl
	mul bh
	push ax
	mov ax, 4
	push ax

	mov ax, offset msg_hex
	push ax
	mov ax, offset msg_equ
	push ax
	call puts
	call puts
	call print8

	mov ax, 4c00h
	int 21h

;Library Functions
input8  proc
	push bx
	push cx

	mov ch, 2; characters to scan
	mov cl, 4; bits in a nibble
	mov bl, 0
parseNibble:
	shl bl, cl
	mov ah, 01h
	int 21h

	cmp al, 'A'
	jb ascii2num
	sub al, 07h; Difference between 'A' and '9'
ascii2num:
	sub al, '0'
	add bl, al
	dec ch
	jnz parseNibble

	mov al, bl
	mov ah, 00h
	pop cx
	pop bx
	ret
input8 endp

print8 proc; (data_16, chars_16)
	push bp
	mov bp, sp
	push bx
	push cx
	push dx

	mov cl, 4; bits in a nibble
	mov bx, [bp + 6]
	mov ax, [bp + 4]
	mov ch, al; chars to print

prt_x__nibble:
	rol bx, cl
	mov dl, bl
	and dl, 0fh
	cmp dl, 0Ah
	jb prt_x__digit
	add dl, 7; Difference between 'A' and '9'
prt_x__digit:
	add dl, '0'
	mov ah, 02h
	int 21h
	dec ch
	jnz prt_x__nibble

	pop dx
	pop cx
	pop bx
	pop bp
	ret 4
print8 endp


puts proc; (string address)
	push bp
	mov bp, sp
	push dx
	push si

	mov dx, [bp + 4]
	mov ah, 09h
	int 21h

	pop si
	pop dx
	pop bp
	ret 2
endp puts

end
