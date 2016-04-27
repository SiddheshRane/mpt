.model small
.stack 100h
.data
	msg1 db 10,13,"Find factorial of 0x$"
	msg2 db 10,13,"Factorial is 0x$"
	endl db 10,13,"$"
	num dw ?

.code

	mov ax, @data
	mov ds, ax
	mov ax, OFFSET msg1
	push ax
	call puts

	call input16
	mov num, ax

	mov ax, OFFSET endl
	push ax
	call puts

	mov cx, num
	mov ax, 0001h
main__fact:
	mul cl
	dec cx
	jnz main__fact

	push ax
	mov ax, 0004h
	push ax
	call print8

	mov ax, 4c00h
	int 21h

;Library Function

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
