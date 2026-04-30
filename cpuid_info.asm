;*******************************************************;
;														;
; Title		:	cpuid_info							;
; Creator	:	John Coleman							;
; Creation Date	:	2025.31.07							;
; Modified Date	:	2024.31.07							;
; Brief	:												;
; x86 Assembly application written for Linux.  			;
; Reads fields from CPUID instruction.									;
;*******************************************************;

section .bss
	abuffer_length:	equ 4
	abuffer: 	resb abuffer_length

	bbuffer_length:	equ 4
	bbuffer: 	resb abuffer_length

	cbuffer_length:	equ 4
	cbuffer: 	resb abuffer_length

	dbuffer_length:	equ 4
	dbuffer: 	resb abuffer_length

section .data

section .text
global _start
_start:
;	mov eax, 0xd
;	mov ecx, 0x1
	mov eax, 0x1
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	cpuid

	mov dword [abuffer], eax
	mov dword [bbuffer], ebx
	mov dword [cbuffer], ecx
	mov dword [dbuffer], edx

	mov eax, 0
	cpuid

	mov eax, 4
	mov ebx, 1
	mov ecx, abuffer
	mov edx, abuffer_length

	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, bbuffer
	mov edx, bbuffer_length

	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, cbuffer
	mov edx, cbuffer_length

	int 0x80

	mov eax, 4
	mov ebx, 1
	mov ecx, dbuffer
	mov edx, dbuffer_length

	int 0x80

	mov eax, 1
	mov ebx, 0, 
	
	int 0x80
