.model small
.stack 100h
.8086
.data
	msg1 db 10,13,"a / b",10,13,"a = 0x$"
	msg2 db 10,13,"b = 0x$"
	msg_equ db 10,13,"Result = 0x$"
	msg_rem db ".$"
	msg_0div db 10,13,"Infinity$"

.code
	mov ax, @data
	mov ds, ax

	push bp
	mov ax, offset msg1
	push ax
	call puts
	call input16
	mov cx, ax; hi 16
	call input16
	mov dx, ax; lo 16

	mov ax, offset msg2
	push ax
	call puts
	call input16
	mov si, ax; hi 16
	call input16
	mov di, ax; lo 16

	or ax, si
	jz main__0div

	mov bp, 32; counter
	mov ax, 0
	mov bx, 0
	;remainder ax:bx
	;quotient cx:dx
	clc
mainLoop:
	rcl dx, 1
	rcl cx, 1
	rcl bx, 1
	rcl ax, 1

	cmp ax, si
	jb main__nosub
	ja main__sub
	cmp bx, di
	jb main__nosub
main__sub:
	sub bx, di
	sbb ax, si
	stc
	jmp main__next
main__nosub:
	clc
main__next:
	dec bp
	jnz mainLoop
	rcl dx, 1
	rcl cx, 1

	mov bp, 4
	push bx
	push bp
	push ax
	push bp
	push dx
	push bp
	push cx
	push bp

	mov ax, offset msg_equ
	push ax
	call puts
	call print8
	call print8
	mov ax, offset msg_rem
	push ax
	call puts
	call print8
	call print8
	pop bp

	jmp over
main__0div:
	mov ax, offset msg_0div
	push ax
	call puts
	pop bp
over:
	mov ax, 4c00h
	int 21h

input16 proc
	push bx
	push cx

	mov ch, 4; characters to scan
	mov cl, 4; bits in a nibble
	mov bl, 0
scn4x__nibble:
	shl bx, cl
	mov ah, 01h
	int 21h

	cmp al, 'A'
	jb scn4x__digit
	sub al, 07h; Difference between 'A' and '9'
scn4x__digit:
	sub al, '0'
	add bl, al
	dec ch
	jnz scn4x__nibble

	mov ax, bx
	pop cx
	pop bx
	ret
input16 endp
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
