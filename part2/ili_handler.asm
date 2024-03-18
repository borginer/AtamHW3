.globl my_ili_handler

.text
.align 4, 0x90

my_ili_handler:

  pushq %rax
	pushq %rdi
	pushq %rsi
	pushq %rdx
	pushq %rcx
	pushq %r8
	pushq %r9
	pushq %r10
	pushq %r11

  movq 80(%rsp), %rax # get rip after pushing regs
  movw (%rax), %ax # get opcode
  xorq %rbx, %rbx
  cmpb $0x0F, %al
  jnz one_byte_opcode_HW3
  shr $8, %rax
  addq $1, %rbx
one_byte_opcode_HW3:
  addq $1, %rbx
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
	popq %rax
  jmp *old_ili_handler

normal_return_HW3:

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
  addq %rbx, (%rsp)
  iretq
