.model small
.stack 100h
.8086
.data
	msg1 db 10,13,"Enter the no 1: 0x$"
	msg2 db 10,13,"Enter the no 2: 0x$"
	endl db 10,13,"$"
	msg_hex db "0x$"
	msg_sub db " - $"
	msg_equ db " = $"

.code
	mov ax, @data
	mov ds, ax


	lea ax, msg1
	push ax
	call puts
	call input16
	mov si, ax
	call input16
	mov di, ax

	mov ax, offset msg2
	push ax
	call puts
	call input16
	mov cx, ax
	call input16
	mov dx, ax

	; sub 8 lower
	mov ax, offset endl
	push ax
	call puts

	mov ax, offset msg_hex
	push ax
	call puts

	mov ax, di
	mov ah, al
	push ax
	mov ax, 2
	push ax
	call print8

	mov ax, offset msg_sub
	push ax
	call puts
	mov ax, offset msg_hex
	push ax
	call puts

	mov ax, dx
	mov ah, al
	push ax
	mov ax, 2
	push ax
	call print8

	mov ax, di
	mov bx, dx
	sub al, bl
	mov ah, al
	push ax
	mov ax, 2
	push ax

	mov ax, offset msg_hex
	push ax
	mov ax, offset msg_equ
	push ax
	call puts
	call puts
	call print8

	; sub 16 lower
	mov ax, offset endl
	push ax
	call puts

	mov ax, offset msg_hex
	push ax
	call puts

	mov ax, di
	push ax
	mov ax, 4
	push ax
	call print8

	mov ax, offset msg_sub
	push ax
	call puts
	mov ax, offset msg_hex
	push ax
	call puts

	mov ax, dx
	push ax
	mov ax, 4
	push ax
	call print8

	mov ax, di
	sub ax, dx
	push ax
	mov ax, 4
	push ax

	mov ax, offset msg_hex
	push ax
	mov ax, offset msg_equ
	push ax
	call puts
	call puts
	call print8

	; sub 32 lower
	mov ax, offset endl
	push ax
	call puts

	mov ax, offset msg_hex
	push ax
	call puts

	mov ax, di
	push ax
	mov ax, 4
	push ax
	mov ax, si
	push ax
	mov ax, 4
	push ax
	call print8
	call print8

	mov ax, offset msg_sub
	push ax
	call puts
	mov ax, offset msg_hex
	push ax
	call puts

	mov ax, dx
	push ax
	mov ax, 4
	push ax
	mov ax, cx
	push ax
	mov ax, 4
	push ax
	call print8
	call print8

	mov ax, di
	sub ax, dx
	push ax
	mov ax, si
	sbb ax, cx
	mov bx, 4
	push bx
	push ax
	push bx

	mov ax, offset msg_hex
	push ax
	mov ax, offset msg_equ
	push ax
	call puts
	call puts
	call print8
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

