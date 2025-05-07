section .data
newline_char db 10

section .text
global _main

;exit, rdi = code, xor rdi, rdi = exit 0
exit:
  mov rax, 0x2000001  ; macOS exit syscall
  syscall

;calculate string length, rdi = input string pointer, null terminated
;returns string len in rax
strlen:
  xor rax, rax ;store the len in rax, init with 0

.loop:
  cmp byte [rdi + rax], 0 ;is current byte a zero terminator?
  je .end ; return

  inc rax ;increment offset and repeat
  jmp .loop

.end:
  ret

print_string:
  call strlen

  mov rdx, rax ;get the length in bytes
  mov rax, 0x2000004 ;write syscall
  mov rdi, 1 ;stdout
  lea rsi, [rdi] ;from this address rdx bytes
  syscall
  ret

print_char:
  mov rax, 0x2000004
  lea rsi, [rdi]
  mov rdi, 1
  mov rdx, 1
  syscall
  ret

print_newline:
  mov rax, 0x2000004
  lea rsi, [rel newline_char]
  mov rdi, 1
  mov rdx, 1
  syscall
  ret

; args: uint 8 bytes, rdi register
print_uint:
  push rbp ;save the address of the previous stack frame, this reserves 8 bytes and makes the stack address unaligned to 16 bytes system v abi
  mov rbp, rsp ;our function stack begins at this address
  sub rsp, 24 ;reserve 20 bytes for the longest possible 64 bit number + 4 for alignment: 24 + 8 = 32, divisible by 16
  mov rsi, rsp ;save the "end" of the buffer
  mov r8, 10 ;the divisor

  xor rcx, rcx ;set rcx to 0 and use as the digit counter

  mov rax, rdi ;save the argument in rax for divs

.loop:
  xor rdx, rdx ;zero out rdx before divs
  div r8 ;divide rax by r8
  add dl, 48 ;convert the last byte of rdx (remainder) to ascii code
  mov r9, 23 ;offsetting a byte left from 24 as we need that byte to write the last digit
  sub r9, rcx
  mov byte [rsi + r9], dl ;write a digit into the stack buffer
  inc rcx ;increment the counter

  test rax, rax ;set the zero flag
  jnz .loop ;if not zero, process the next digit

.print:
  mov rax, 0x2000004 ;write system call
  mov rdi, 1 ;stdout
  mov rdx, rcx ;rcx bytes
  mov rsi, rbp
  sub rsi, rcx
  syscall

  mov rsp, rbp ;restore the stack pointer
  pop rbp ; these lines are equivalent of the leave insruction
  ret

_main:
  mov rdi, 2014
  call print_uint
  call print_newline

  xor rdi, rdi
  call exit
