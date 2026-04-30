; Executable name : Calc
; Version         : 1.0
; Created date    : 10/23/22
; Last update     : 01/20/2023
; Author          : John Coleman
; Description     : A basic arithmetic calculator
;
;
;
; Build using these commands:
;	nasm -f elf -g -F stabs calc32.asm
;	ld -m elf_i386 -o calc32 calc32.o
;

[SECTION .data]
	
	title	 	db 	"                        ==============",10,"                        ||   calc   ||",10,"                        ==============",10
	TITLELEN 	equ 	$-title
	prompt		db	"                        eq: "
	PROMPTLEN	equ	$-prompt
	clear		db	27,"[2J"
	CLEARLEN	equ	$-clear
	col		db	27,"[31C"
	COLLEN		equ	$-col
	pline		db	27,"[F"
	PLINELEN	equ	$-pline
	equal		db	"="
	EQUALLEN	equ	$-equal
	newline		db	10
	NEWLINELEN	equ	$-newline
	

[SECTION .bss]

	input 		resb 8
	firstin 	resb 1
	secondin 	resb 1
	sumlb 		resb 1
	sumhb 		resb 1

[SECTION .text]

;global main
global _start

;main:
_start:
	mov eax,4
	mov ebx,1
	mov ecx,clear
	mov edx,CLEARLEN
	int 80h

	mov eax,4
	mov ebx,1
	mov ecx,title
	mov edx,TITLELEN
	int 80h

	mov eax,4
	mov ebx,1
	mov ecx,prompt
	mov edx,PROMPTLEN
	int 80h

	mov eax,3		; Specify sysread call
	mov ebx,0		; File descriptor stdin
	mov ecx,input		; Store user input
	mov edx,8		; 8 bytes
	int 80h			; Make kernel call
	
.loop:
	cmp byte [input+1],43
	je add
	cmp byte [input+1],45
	je sub
add:
	and ax,ax
	mov bx,ax
	mov al,[input]
	sub al,'0'
	mov bl,[input+2]
	sub bl,'0'
	add al,bl
;	cmp al,9
	aaa
	add al,48
	add ah,48
	mov [sumlb],al
	mov [sumhb],ah
	jmp output

sub:
	nop

output:
	mov eax,4
	mov ebx,1
	mov ecx,pline
	mov edx,PLINELEN
	int 80h

	mov eax,4
	mov ebx,1
	mov ecx,col
	mov edx,COLLEN
	int 80h

	mov eax,4
	mov ebx,1
	mov ecx,equal
	mov edx,EQUALLEN
	int 80h

	and ecx,ecx
	
	mov eax,4
	mov ebx,1
	mov ecx,sumhb
	mov edx,1
	int 80H

	mov eax,4
	mov ebx,1
	mov ecx,sumlb
	mov edx,1
	int 80H

	mov eax,4
	mov ebx,1
	mov ecx,newline
	mov edx,NEWLINELEN
	int 80h

	mov eax,4
	mov ebx,1
	mov ecx,newline
	mov edx,NEWLINELEN
	int 80h

exit:
	mov eax,1		; Code for exit syscall
	mov ebx,0		; Return a code of 0
	int 80H			; Make kernel call
