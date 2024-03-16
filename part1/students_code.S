.global get_element_from_matrix, inner_prod, matrix_multiplication

.macro push_caller_saved
	pushq %rax
	pushq %rdi
	pushq %rsi
	pushq %rdx
	pushq %rcx
	pushq %r8
	pushq %r9
	# pushq %r10
	# pushq %r11
.endm

.macro pop_caller_saved
	# popq %r11
	# popq %r10
	popq %r9
	popq %r8
	popq %rcx
	popq %rdx
	popq %rsi
	popq %rdi
	popq %rax
.endm

get_element_from_matrix:
	# prologue
    pushq %rbp
    movq %rsp, %rbp
	# %rdi is matrix
	# %esi is n
	# %edx is row
	# %ecx is col
	# %esi = %edx * %esi + %ecx
	imull %edx, %esi
	addl %ecx, %esi
	# extent %esi
	movl %esi, %eax
	cdqe
	movq %rax, %rsi
	# %rsi *= 4
	imulq $4, %rsi
	# %rdi = %rdi + %rsi
	addq %rsi, %rdi
	# %eax = (%rdi)
	movl (%rdi), %eax
    # epilogue
    popq %rbp
    ret

inner_prod:
	# prologue
    pushq %rbp
    movq %rsp, %rbp
	pushq %r12
	# %rdi is mat_a
	# %rsi is mat_b
	# %edx is row_a
	# %ecx is col_b
	# %r8d is max_col_a
	# %r9d is max_col_b
	# %rax is the sum
	# %r10d is a_item
	# %r11d is b_item
	# %r12d is i (the index)
	# %r12d = 0
	movl $0, %r12d
	# %rax = 0
	movq $0, %rax
while_inner_prod_HW3:
	cmpl %r12d, %r8d
	jle after_while_inner_prod_HW3
# a_item = get_element_from_matrix(mat_a, max_col_a, row_a, i);
	push_caller_saved
	movl %r8d, %esi
	movl %r12d, %ecx
	call get_element_from_matrix
	movl %eax, %r10d
	pop_caller_saved
# b_item = get_element_from_matrix(mat_b, max_col_b, i, col_b);
	push_caller_saved
	pushq %r10
	movq %rsi, %rdi
	movl %r9d, %esi
	movl %r12d, %edx
	call get_element_from_matrix
	movl %eax, %r11d
	popq %r10
	pop_caller_saved
whiles_calculations_HW3:
	# %r11d *= %r10d
	imull %r10d, %r11d
	# %eax += %r11d
	addl %r11d, %eax
	# i += 1;
	incl %r12d
	jmp while_inner_prod_HW3
after_while_inner_prod_HW3:
    # epilogue
	popq %r12
    popq %rbp
    ret

matrix_multiplication:
	# %rdi is res
	# %rsi is mat_a
	# %rdx is mat_b
	# %ecx is a_rows
	# %r8d is a_colls
	# %r9d is b_rows
	# %r10d is b colls
	movl 8(%rsp), %r15d # 7th param
	pushq %rbp
	movq %rsp, %rbp
	cmpl %r8d, %r9d
	jz valid_size_HW3
	
	movl $0, %eax
	# popq %rbp
	leave
	ret
valid_size_HW3:
	pushq %r15
	
	subq $12, %rsp

	movl $0, -4(%rbp) # i = res rows
rows_loop_HW3:
	movl $0, -8(%rbp) # j = res colls
cols_loop_HW3:

	push_caller_saved
	movq %rsi, %rdi
	movq %rdx, %rsi
	movl -4(%rbp), %edx
	movl -8(%rbp), %ecx

	movl %r8d, %r8d
	movl %r15d, %r9d

	# r8d already set
	# movl %r10d, %r9d

	call inner_prod
	movl %eax, -12(%rbp) # inner res
	pop_caller_saved

	push_caller_saved
	# rdi has res matrix
	movl %r15d, %esi
	movl -4(%rbp), %edx
	movl -8(%rbp), %ecx
	movl -12(%rbp), %r8d
	call set_element_in_matrix
	pop_caller_saved

	
	incl -8(%rbp)
	cmpl %r15d, -8(%rbp)
	jnz cols_loop_HW3

	incl -4(%rbp)
	cmpl %ecx, -4(%rbp)
	jnz rows_loop_HW3

	popq %r15
	movl $1, %eax
	leave
    ret
