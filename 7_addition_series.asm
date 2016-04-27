.model small
.stack 100h
.8086
.data
	msg1 db 10,13,"Enter numbers to add (terminate with 00): $"
	msg_next db 10,13,"0x$"
	msg_res db 10,13,"Result: 0x$"

.code
include tty.asm

main proc
	mov ax, offset msg1
	push ax
	call puts

	mov dx, 0
	mov bx, offset msg_next
mainLoop:
	push bx
	call puts
	call scn2x
	cmp al, 0
	jz over
	mov ah, 0
	add dx, ax
	jmp mainLoop
over:
	push dx
	mov ax, 4
	push ax
	mov ax, offset msg_res
	push ax
	call puts
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
