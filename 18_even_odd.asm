.model small
.stack 100h
.8086
.data
	msg1 db 10,13,"Enter the no : 0x$"
	msg2 db 10,13,"Number is even$"
	msg3 db 10,13,"Number is odd$"

.code
	mov ax, @data
	mov ds, ax


	lea ax, msg1
	push ax
	call puts
	call input16

	mov bx, offset msg3
	ror ax, 1
	jc main__even
	mov bx, offset msg2
main__even:
	push bx
	call puts
	
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

