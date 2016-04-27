.model small
.stack 100h
.8086
.data
	msg1 db 10,13,"Enter the no 1: 0x$"
	msg2 db 10,13,"Enter the no 2: 0x$"
	msg_equ db 10,13,"Result = 0x$"
	msg_rem db ".$"
	msg_0div db 10,13,"Infinity$"

.code
include tty.asm

main proc
	push bp

	mov ax, offset msg1
	push ax
	call puts
	call scn4x
	mov cx, ax; hi 16
	call scn4x
	mov dx, ax; lo 16

	mov ax, offset msg2
	push ax
	call puts
	call scn4x
	mov si, ax; hi 16
	call scn4x
	mov di, ax; lo 16

	or ax, si
	jz main__0div

	mov bp, 32; counter
	mov ax, 0
	mov bx, 0
	;remainder ax:bx
	;quotient cx:dx
	clc
mainLoop:
	rcl dx, 1
	rcl cx, 1
	rcl bx, 1
	rcl ax, 1

	cmp ax, si
	jb main__nosub
	ja main__sub
	cmp bx, di
	jb main__nosub
main__sub:
	sub bx, di
	sbb ax, si
	stc
	jmp main__next
main__nosub:
	clc
main__next:
	dec bp
	jnz mainLoop
	rcl dx, 1
	rcl cx, 1

	mov bp, 4
	push bx
	push bp
	push ax
	push bp
	push dx
	push bp
	push cx
	push bp

	mov ax, offset msg_equ
	push ax
	call puts
	call prt_x
	call prt_x
	mov ax, offset msg_rem
	push ax
	call puts
	call prt_x
	call prt_x
	pop bp

	ret
main__0div:
	mov ax, offset msg_0div
	push ax
	call puts
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
