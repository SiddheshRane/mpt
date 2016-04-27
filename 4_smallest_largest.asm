.model small
.stack 100h
.8086
.data
	a1 db 4 dup (?)
	LEN EQU 4
	msg1 db 10,13,"Enter 4 2-digit numbers: $"
	msg2 db 10,13,"Smallest number is 0x$"
	msg3 db 10,13,"Largest number is 0x$"

.code
	mov ax, @data
	mov ds, ax
	mov es, ax
	;display msg1
	lea dx, msg1
	mov ah, 09h
	int 21h

	mov cx, LEN
	lea di, a1
	cld

getInput:
	call input8
	stosb
	loop getInput

	lea si, a1
	mov cx, len
	lodsb
	dec cx
	mov bl, al
	mov bh, al
find:
	lodsb
	cmp al, bl
	ja above
	mov bl, al
above:
	cmp al, bh
	jb below
	mov bh, al
below:
	loop find

	; print output
	lea dx,msg2
	mov ah, 09h
	int 21h

	mov ah, bl
	push ax
	mov ax, 2
	push ax
	call print8

	lea dx, msg3
	mov ah, 09h
	int 21h

	mov ah, bh
	push ax
	mov ax, 2
	push ax
	call print8

	mov ax, 4c00h
	int 21h

;Libray Functions
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

end