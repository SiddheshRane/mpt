.model small
.stack 100h
.8086
.data
	a1 db 9 dup (?)
	a2 db 9 dup (?)
	LEN EQU 9
	LEN_ROW EQU 3

	msg1 db 10,13,"Enter 3x3 matrix 1: $"
	msg2 db 10,13,"Enter 3x3 matrix 2: $"
	msgadd db 10,13,"Added:",10,13,"$"
	msgsub db 10,13,"Subtracted:",10,13,"$"
	eol db 10,13,"$"

.code

	mov ax, @data
	mov ds, ax
	mov es, ax

	lea dx, msg1
	mov ah, 09h
	int 21h
	mov cx, LEN
	lea di, a1
	cld
main__inp1:
	call input8
	stosb
	loop main__inp1

	mov ax, offset msg2
	push ax
	call puts
	mov cx, LEN
	mov di, offset a2
	cld
main__inp2:
	call input8
	stosb
	loop main__inp2

	mov ax, offset eol
	push ax
	call puts
	mov ax, offset a1
	push ax
	mov ax, LEN_ROW
	push ax
	call prtmat
	mov ax, offset eol
	push ax
	call puts
	mov ax, offset a2
	push ax
	mov ax, LEN_ROW
	push ax
	call prtmat

	mov si, offset a1
	mov di, offset a2
	mov cx, LEN
mainLoop:
	mov al, [si]
	mov ah, al
	sub al, [di]
	add ah, [di]
	mov [si], ah
	mov [di], al
	inc si
	inc di
	loop mainLoop

	mov ax, offset msgadd
	push ax
	call puts
	mov ax, offset a1
	push ax
	mov ax, LEN_ROW
	push ax
	call prtmat
	mov ax, offset msgsub
	push ax
	call puts
	mov ax, offset a2
	push ax
	mov ax, LEN_ROW
	push ax
	call prtmat

	mov ax, 4c00h
	int 21h

prtmat proc; (array, size)
	push bp
	mov bp, sp
	push si
	push cx
	push dx

	mov si, [bp + 6]
	mov dx, [bp + 4]

prtmat__loop1:
	mov cx, [bp + 4]
prtmat__loop:
	mov ah, [si]
	push ax
	mov ax, 2
	push ax
	call print8
	mov al, ' '
	push ax
	call putch
	inc si
	loop prtmat__loop

	mov ax, offset eol
	push ax
	call puts
	dec dx
	jnz prtmat__loop1

	pop dx
	pop cx
	pop si
	pop bp
	ret 4
prtmat endp
	
	
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
putch proc; (char8 lower)
	push bp
	mov bp, sp
	push dx

	mov dx, [bp + 4]
	mov ah, 02h
	int 21h

	pop dx
	pop bp
	ret 2
endp putch
end
