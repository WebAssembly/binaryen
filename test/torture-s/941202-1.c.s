	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/941202-1.c"
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	.LBB0_2
	i32.const	$push0=, 3
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_2
# BB#1:                                 # %if.end
	return  	$0
.LBB0_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
