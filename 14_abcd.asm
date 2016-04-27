.model small
.stack 100h
.8086
.data
	msga db 10,13,"(a:0x$"
	msgb db " + b:0x$"
	msgc db ") * ( c:0x$"
	msgd db " + d:0x$"
	msgend db " ) = $"
	endl db 10,13,"$"
	msg_hex db "0x$"
	msg_equ db " = $"
	a dw ?
	b dw ?
	c dw ?
	d dw ?
.code
	mov ax, @data
	mov ds, ax
	
	mov ah, 09h
	lea dx, msga	;a
	int 21h
	call input8
	mov a, ax

	mov ah,09h
	lea dx, msgb	;b
	int 21h
	call input8
	mov b, ax

	mov ah,09h
	lea dx, msgc	;c
	int 21h
	call input8
	mov c, ax

	mov ah,09h
	lea dx, msgd	;d
	int 21h
	call input8
	mov d, ax

	mov ah, 09h
	lea dx, msgend	; )
	int 21h

	mov ax, a
	add ax,  b		;a+b
	mov a,ax		;a = a+b
	mov ax, c
	add ax, d		;ax = c+d
	mul a		;c+d * a+b
	
	call disp16bit
	mov ah, 4ch
	int 21h
;Library Functions
input8  proc ; return val in ax
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

disp16bit proc ; arg in ax
	push cx
	push bx
	push dx
	
	mov bx, ax
	mov cl, 04h
	mov ch,cl
m:
	rol bx, cl
	mov dl, bl
	and dl, 0fh
	cmp dl, 0Ah	; < 10 = num
	jb n
	add dl, 07h	;otherwise A-F
n:
	add dl, 30h
	mov ah, 02h
	int 21h
	dec ch
	jnz m

	pop dx
	pop bx
	pop cx
	ret
disp16bit endp
end