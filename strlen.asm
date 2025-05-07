global _main

section .data
test_string db 'abcdef', 0

section .text

strlen:
  xor rax, rax ;store the len in rax, init with 0

.loop:
  cmp byte [rdi + rax], 0 ;is current byte a zero terminator?
  je .end ; return

  inc rax ;increment offset and repeat
  jmp .loop

.end:
  ret

_main:
  lea rdi, [rel test_string]
  call strlen

  mov rdi, rax ;return code = strlen result
  mov rax, 0x2000001 ;exit syscall
  syscall
