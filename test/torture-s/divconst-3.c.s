	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/divconst-3.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i64
	.result 	i64
# BB#0:                                 # %entry
	i64.const	$push0=, 10000000000
	i64.div_s	$push1=, $0, $pop0
	return  	$pop1
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
