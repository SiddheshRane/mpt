.model small
.stack 100h
.8086
.data
	s1 db 100 dup (?)
	s2 db 100 dup (?)
	msg1 db 10,13,"Enter string 1: $"
	msg2 db 10,13,"Enter string 2: $"

.code
	mov ax, @data
	mov ds, ax


	mov ax, ds
	mov es, ax

	lea ax, msg1
	push ax
	call puts

	mov ax, offset s1
	push ax
	call gets

	mov ax, offset msg2
	push ax
	call puts

	mov ax, offset s2
	push ax
	call gets

	mov di, offset s1
	mov si, offset s2
	cld

main__scn_1:
	mov al, '$'
	scasb
	jne main__scn_1
	dec di

main__concat:
	lodsb
	cmp al, '$'
	je over
	stosb
	jmp main__concat
over:
	stosb

	mov ax, offset s1
	push ax
	call puts

	
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

getch proc
	mov ah, 01h
	int 21h
	ret
endp getch

gets proc; (dest address)
	push bp
	mov bp, sp
	push di
	push cx
	pushf

	mov cx, 0
	mov di, [bp + 4]
	cld

gets__loop:
	mov ah, 01h
	int 21h
	cmp al, 0dh
	jz gets__loop_end
	stosb
	inc cx
	jmp gets__loop
gets__loop_end:
	mov al, '$'
	stosb

	mov ax, cx
	popf
	pop cx
	pop di
	pop bp
	ret 2
endp gets
end

