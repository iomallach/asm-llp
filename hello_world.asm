global _start

section .data
message db 'hello, world!', 10, 10

section .text
_start:
  mov rax, 0x2000004 ;system call number should be stored in rax
  mov rdi, 1 ;where to write (file descriptor 1=stdout)
  lea rsi, [rel message] ;???
  mov rdx, 14 ;write 14 bytes
  syscall

   ; Exit properly
  mov rax, 0x2000001  ; macOS exit syscall
  xor rdi, rdi        ; exit code 0
  syscall

