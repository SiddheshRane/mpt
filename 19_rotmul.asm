.model small
.stack 100h
.8086
.data
	msg1 db 10,13,"Enter the no 1: 0x$"
	msg2 db 10,13,"Enter the no 2: 0x$"
	msg_equ db 10,13,"Result = 0x$"

.code
include tty.asm

main proc
	push bp

	mov ax, offset msg1
	push ax
	call puts
	call scn4x
	mov si, ax; hi 16
	call scn4x
	mov di, ax; lo 16

	mov ax, offset msg2
	push ax
	call puts
	call scn4x
	mov cx, ax; hi 16
	call scn4x
	mov dx, ax; lo 16

	mov bp, 32; counter
	mov ax, 0
	mov bx, 0
	; result will be in ax:bx:cx:dx
	clc
mainLoop:
	rcr ax, 1
	rcr bx, 1
	rcr cx, 1
	rcr dx, 1
	jnc main__noadd
	add bx, di
	adc ax, si
main__noadd:
	dec bp
	jnz mainLoop
	rcr ax, 1
	rcr bx, 1
	rcr cx, 1
	rcr dx, 1

	mov bp, 4
	push dx
	push bp
	push cx
	push bp
	push bx
	push bp
	push ax
	push bp

	mov ax, offset msg_equ
	push ax
	call puts
	call prt_x
	call prt_x
	call prt_x
	call prt_x
	pop bp

	ret
endp main
.startup
	mov ax, @data
	mov ds, ax

	call main
	mov ax, 4c00h
	int 21h
end
