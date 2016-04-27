.model small
.stack 100h
.8086
.data
	a1 db 4 dup (?)
	a2 db 4 dup (?)
	LEN EQU 4

	msg1 db 10,13,"Enter 4 array bytes: $"
	msg2 db 10,13,"Contents exchanged",10,13,"$"
	msg_eol db 10,13,"$"

.code
	mov ax, @data
	mov ds, ax
	mov es, ax
	cld
	lea ax, msg1
	push ax
	call puts
	mov cx, LEN
	mov di, offset a1
main__inp1:
	call input8
	stosb
	loop main__inp1

	lea ax, msg1
	push ax
	call puts
	mov cx, LEN
	mov di, offset a2
main__inp2:
	call input8
	stosb
	loop main__inp2

	mov si, offset a1
	mov di, offset a2
	mov cx, LEN

main__xchg:
	mov ah, [di]
	mov al, [si]
	mov [di], al
	mov [si], ah
	inc si
	inc di
	loop main__xchg

	mov ax, offset msg2
	push ax
	call puts

	mov bx, 0002h
	mov si, offset a1
	mov cx, LEN
main__prt1:
	lodsb
	mov ah, al
	push ax
	push bx
	call print8
	loop main__prt1

	mov ax, offset msg_eol
	push ax
	call puts

	lea si, a2
	mov cx, LEN
main__prt2:
	lodsb
	mov ah, al
	push ax
	push bx
	call print8
	loop main__prt2

	
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

