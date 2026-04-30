;*******************************************************;
;							;
; Title		:	flashcards: ps			;
; Creator	:	John Coleman			;
; Creation Date	:	2024.03.08			;
; Modified Date	:	2024.03.08			;
; Brief	:						;
; x86 Assembly application written for Linux.  		;
; Provides terminal flash cards for studying Linux 	;
; commands.						;
;							;
;*******************************************************;

section .bss

rbufflen:	equ		2
rbuff:		resb		rbufflen

section .data

clr:		db		27,"[2J"
clrlen:		equ		$-clr

loc:		db		27,"[01;01H"
loclen:		equ		$-loc

cursor:		db		27,"[11;10H"
cursorlen:	equ		$-cursor

front:		db		" -------------------------------------------------------------------------------------- ", 10
		db		"|											|", 10
		db		"|											|", 10
		db		"|					ps						|", 10
		db		"|											|", 10
		db		"|			report a snapshot of the current processes			|", 10
		db		"|											|", 10
		db		"|											|", 10
		db		"|											|", 10
		db		"|											|", 10
		db		"|											|", 10
		db		" -------------------------------------------------------------------------------------- ", 10
                db              "[b]=back,[f]=front,[x]=exit: "
flen:		equ		$-front

back:		db		" -------------------------------------------------------------------------------------- ", 10
		db		"|											|", 10
		db		"|			$ ps aux							|", 10
		db		"|			$ ps -ef							|", 10
		db		"|			$ ps -p $(pidof process)					|", 10
		db		"|			$ ps ax --format pid,%mem,cmd --sort -%mem			|", 10
		db		"|			$ ps -p xxxx -o etime						|", 10
		db		"|			$ ps --forest -C process -o pid,ppid,cmd			|", 10
		db		"|			$ ps axo pid,ppid,rss,%cpu --sort=-rss				|", 10
		db		"|			$ ps -U user							|", 10
		db		"|											|", 10
		db		" -------------------------------------------------------------------------------------- ", 10
		db		"[b]=back,[f]=front,[x]=exit: "
blen:		equ		$-back

section .text
global _start
_start:

lfront:
	call scrn
	mov eax, 4
	mov ebx, 1
	mov ecx, front
	mov edx, flen
	int 0x80
	jmp read

lback:
	call scrn
	mov eax, 4
	mov ebx, 1
	mov ecx, back
	mov edx, blen
	int 0x80
	jmp read

scrn:
        mov eax, 4
        mov ebx, 1
        mov ecx, clr
        mov edx, clrlen
        int 0x80
        mov eax, 4
        mov ebx, 1
        mov ecx, loc
        mov edx, loclen
        int 0x80
        ret

cursorloc:
        mov eax, 4
        mov ebx, 1
        mov ecx, cursor
        mov edx, cursorlen
        int 0x80
	ret

read:
;	call cursorloc
	mov eax, 3
	mov ebx, 0
	mov ecx, rbuff
	mov edx, rbufflen
	int 0x80

test:
	xor eax, eax
	mov al, byte[rbuff]
	cmp eax, 'f'
	je lfront
	cmp eax, 'b'
	je lback
	cmp eax, 'x'
	je exit

exit:
	mov eax, 1
	mov ebx, 0
	int 0x80
