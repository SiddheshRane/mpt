.model small
.stack 100h
.8086
.data
	a1 db 9 dup (?)
	a2 db 9 dup (?)
	LEN EQU 9
	LEN_ROW EQU 3

	msg1 db 10,13,"Enter 3x3 matrix 1: $"
	msg2 db 10,13,"Enter 3x3 matrix 2: $"
	msgadd db 10,13,"Added:",10,13,"$"
	msgsub db 10,13,"Subtracted:",10,13,"$"
	eol db 10,13,"$"

.code
include tty.asm

prtmat proc; (array, size)
	push bp
	mov bp, sp
	push si
	push cx
	push dx

	mov si, [bp + 6]
	mov dx, [bp + 4]

prtmat__loop1:
	mov cx, [bp + 4]
prtmat__loop:
	mov ah, [si]
	push ax
	mov ax, 2
	push ax
	call prt_x
	mov al, ' '
	push ax
	call putch
	inc si
	loop prtmat__loop

	mov ax, offset eol
	push ax
	call puts
	dec dx
	jnz prtmat__loop1

	pop dx
	pop cx
	pop si
	pop bp
	ret 4
prtmat endp

main proc
	mov ax, ds
	mov es, ax

	mov ax, offset msg1
	push ax
	call puts
	mov cx, LEN
	mov di, offset a1
	cld
main__inp1:
	call scn2x
	stosb
	loop main__inp1

	mov ax, offset msg2
	push ax
	call puts
	mov cx, LEN
	mov di, offset a2
	cld
main__inp2:
	call scn2x
	stosb
	loop main__inp2

	mov ax, offset eol
	push ax
	call puts
	mov ax, offset a1
	push ax
	mov ax, LEN_ROW
	push ax
	call prtmat
	mov ax, offset eol
	push ax
	call puts
	mov ax, offset a2
	push ax
	mov ax, LEN_ROW
	push ax
	call prtmat

	mov si, offset a1
	mov di, offset a2
	mov cx, LEN
mainLoop:
	mov al, [si]
	mov ah, al
	sub al, [di]
	add ah, [di]
	mov [si], ah
	mov [di], al
	inc si
	inc di
	loop mainLoop

	mov ax, offset msgadd
	push ax
	call puts
	mov ax, offset a1
	push ax
	mov ax, LEN_ROW
	push ax
	call prtmat
	mov ax, offset msgsub
	push ax
	call puts
	mov ax, offset a2
	push ax
	mov ax, LEN_ROW
	push ax
	call prtmat

	ret
endp main
.startup
	mov ax, @data
	mov ds, ax

	call main
	mov ax, 4c00h
	int 21h
end
