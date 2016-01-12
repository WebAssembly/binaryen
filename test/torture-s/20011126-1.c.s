	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20011126-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB0_2
	i32.load	$push0=, a($0)
	i32.const	$push1=, -1
	i32.le_s	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB0_2
# BB#1:                                 # %if.end5
	return  	$0
.LBB0_2:                                # %if.then4
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.align	2
a:
	.int32	1                       # 0x1
	.size	a, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
