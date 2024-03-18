.globl my_ili_handler

.text
.align 4, 0x90

.macro push_caller_saved
	pushq %rax
	pushq %rdi
	pushq %rsi
	pushq %rdx
	pushq %rcx
	pushq %r8
	pushq %r9
	pushq %r10
	pushq %r11
.endm

.macro pop_caller_saved
	popq %r11
	popq %r10
	popq %r9
	popq %r8
	popq %rcx
	popq %rdx
	popq %rsi
	popq %rdi
	popq %rax
.endm

my_ili_handler:
  push_caller_saved
  movw 72(%rsp), %ax # get opcode after pushing regs

  cmpb $0x0F, %al
  jnz one_byte_opcode_HW3
  shr $8, %rax
one_byte_opcode_HW3:
  movb %al, %dil

  call what_to_do

  cmpl $0, %eax
  jnz normal_return_HW3

call_old_handler_HW3:
	popq %r11
	popq %r10
	popq %r9
	popq %r8
	popq %rcx
	popq %rdx
	popq %rsi
	popq %rdi
  movq %rax, %rdi # can't use my macro :(
  popq %rax
  jmp old_ili_handler

normal_return_HW3:
  pop_caller_saved
  addq $4, (%rsp)
  iretq
