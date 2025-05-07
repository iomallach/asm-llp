section .data
codes db '0123456789ABCDEF'

section .text
global _main
_main:
  mov rax, 0x1122334455667788
  mov rcx, 64

.loop:
  push rax ;put rax on the stack as we're about to modify it
  sub rcx, 4 ;decrement the loop register
  sar rax, cl ;cl=256 bits, we shift by the whole rcx here
  and rax, 0xF ;take the least significant 4 bits

  lea rsi, [rel codes] ;take the pointer to codes string
  add rsi, rax ;move to pointer by rax bits, which is the current number in the hex sequence

  mov rax, 0x2000004 ;prepare for the write syscall by putting its command in rax (write syscall convention)

  push rcx ;put rcx on the stack as it is going to be modified by the syscall
  mov rdi, 1 ;here and next: restore the registers for the write syscall
  mov rdx, 1
  syscall
  pop rcx ;restore the loop var and the number
  pop rax

  test rcx, rcx ;set flags for the loop jump condition (is rcx 0 or not?)
  jnz .loop ;repeat if rcx is not 0

   ; Exit properly
  mov rax, 0x2000001  ; macOS exit syscall
  xor rdi, rdi        ; exit code 0
  syscall
