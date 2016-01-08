	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040223-1.c"
	.section	.text.a,"ax",@progbits
	.hidden	a
	.globl	a
	.type	a,@function
a:                                      # @a
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	.LBB0_2
	i32.const	$push0=, 1234
	i32.ne  	$push1=, $1, $pop0
	br_if   	$pop1, .LBB0_2
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	a, .Lfunc_end0-a

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
