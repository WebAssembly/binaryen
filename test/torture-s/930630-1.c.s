	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930630-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block   	.LBB1_2
	i32.const	$push0=, 7
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB1_2
# BB#1:                                 # %if.end
	return  	$0
.LBB1_2:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	f, .Lfunc_end1-f


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
