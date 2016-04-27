.model small
.stack 100h
.8086
.data
	a1 db 4 dup (?)
	a2 db 4 dup (?)
	LEN EQU 4

	msg1 db 10,13,"Enter 4 bytes: $"
	msg2 db 10,13,"Copied bytes ",10,13,"$"

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

main__inp:
	call input8
	stosb
	loop main__inp

	lea di, a2
	lea si,a1
	mov cx, LEN
	rep movsb

	lea dx, msg2
	mov ah,09h
	int 21h

	lea si, a2
	mov cx, LEN

main__res_prt:
	lodsb
	mov ah, al
	push ax
	mov bx, 0002h
	push bx
	call print8
	loop main__res_prt

	
	mov ax, 4c00h
	int 21h
;Library Function
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

end

