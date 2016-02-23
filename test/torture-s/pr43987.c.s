	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43987.c"
	.section	.text.add_input_file,"ax",@progbits
	.hidden	add_input_file
	.globl	add_input_file
	.type	add_input_file,@function
add_input_file:                         # @add_input_file
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, B+4($pop0)
	i32.store	$discard=, 0($pop1), $0
	return
	.endfunc
.Lfunc_end0:
	.size	add_input_file, .Lfunc_end0-add_input_file

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push2=, __stack_pointer
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 16
	i32.sub 	$1=, $pop3, $pop4
	i32.const	$push0=, 0
	i32.const	$0=, 12
	i32.add 	$0=, $1, $0
	i32.store	$discard=, B+4($pop0), $0
	i32.const	$push1=, 0
	return  	$pop1
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	B                       # @B
	.type	B,@object
	.section	.bss.B,"aw",@nobits
	.globl	B
	.p2align	4
B:
	.skip	1024
	.size	B, 1024


	.ident	"clang version 3.9.0 "
