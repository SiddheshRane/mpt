.model small
.stack 100h
.8086
.data
	a1 db 100 dup (?)
	a2 db 20 dup (?)
	ldiff dw 1 dup (?)
	len_a2 dw 1 dup (?)
	msg1 db 10,13,"Enter string: $"
	msg2 db 10,13,"Enter substring: $"
	msg3 db 10,13,"Not found$"
	msg4 db 10,13,"Found at 0x$"


.code
	mov ax, @data
	mov ds, ax


	mov ax, ds
	mov es, ax

	lea ax, msg1
	push ax
	call puts

	mov ax, offset a1
	push ax
	call gets
	mov ldiff, ax

	mov ax, offset msg2
	push ax
	call puts

	mov ax, offset a2
	push ax
	call gets
	mov len_a2, ax
	sub ldiff, ax

	mov di, offset a1

	jmp main__loop_start
mainLoop:
	repnz scasb
	jnz main__not_found
	dec di
	mov dx, di
	mov cx, len_a2
	repz cmpsb
	jz main__found
	mov di, dx
	inc di
main__loop_start:
	lea si, a2
	mov al, [si]
	mov cx, ldiff
	inc cx
	sub cx, di
	add cx, offset a1
	jnz mainLoop

main__not_found:
	mov ax, offset msg3
	push ax
	call puts
	ret

main__found:
	mov ax, offset msg4
	push ax
	call puts
	sub di, len_a2
	sub di, offset a1
	push di
	mov ax, 4
	push ax
	call print8
	
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

