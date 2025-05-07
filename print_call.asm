section .data
newline_char db 10
codes db '0123456789ABCDEF'

section .text
global _main

print_newline:
  mov rax, 0x2000004
  mov rdi, 1
  lea rsi, [rel newline_char]
  mov rdx, 1
  syscall
  ret

print_hex:
  mov rax, rdi
  mov rdi, 1
  mov rdx, 1
  mov rcx, 64
iterate:
  push rax
  sub rcx, 4
  sar rax, cl
  and rax, 0xF

  lea rsi, [rel codes]
  add rsi, rax

  mov rax, 0x2000004

  push rcx
  mov rdi, 1
  mov rdx, 1
  syscall
  pop rcx
  pop rax

  test rcx, rcx
  jnz iterate

  ret

exit:
  mov rax, 0x2000001  ; macOS exit syscall
  xor rdi, rdi        ; exit code 0
  syscall

_main:
  mov rdi, 0x1122334455667788
  call print_hex
  call print_newline
  call exit
