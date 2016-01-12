	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr23941.c"
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
	f64.load	$push0=, d($0)
	f64.const	$push1=, 0x1p-127
	f64.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB0_2
# BB#1:                                 # %if.end
	return  	$0
.LBB0_2:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	d                       # @d
	.type	d,@object
	.section	.data.d,"aw",@progbits
	.globl	d
	.align	3
d:
	.int64	4035225266123964416     # double 5.8774717541114375E-39
	.size	d, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
