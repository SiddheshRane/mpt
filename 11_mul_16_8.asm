.model small
.stack 100h
.8086
.data
	msg1 db 10,13,"Enter the no 1: 0x$"
	msg2 db 10,13,"Enter the no 2: 0x$"
	eol db 10,13,"$"
	msg_hex db "0x$"
	msg_mul db " * $"
	msg_equ db " = $"

.code
include tty.asm

main proc
	mov ax, offset msg1
	push ax
	call puts
	call scn4x
	mov bx, ax

	mov ax, offset msg2
	push ax
	call puts
	call scn2x
	mov cl, al

	mov ax, offset eol
	push ax
	call puts

	mov ax, offset msg_hex
	push ax
	call puts

	mov ax, bx
	push ax
	mov ax, 4
	push ax
	call prt_x

	mov ax, offset msg_mul
	push ax
	call puts
	mov ax, offset msg_hex
	push ax
	call puts

	mov ah, cl
	push ax
	mov ax, 2
	push ax
	call prt_x

	mov ax, bx
	mov ch, 0
	mul cx
	push ax
	mov ax, 4
	push ax
	push dx
	push ax

	mov ax, offset msg_hex
	push ax
	mov ax, offset msg_equ
	push ax
	call puts
	call puts
	call prt_x
	call prt_x
	ret
endp main
.startup
	mov ax, @data
	mov ds, ax

	call main
	mov ax, 4c00h
	int 21h
end
