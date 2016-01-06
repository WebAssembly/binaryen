	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/960116-1.c"
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 1
	block   	BB0_3
	block   	BB0_2
	i32.and 	$push0=, $0, $1
	br_if   	$pop0, BB0_2
# BB#1:                                 # %land.lhs.true
	i32.load	$push1=, 0($0)
	br_if   	$pop1, BB0_3
BB0_2:                                  # %if.end
	i32.const	$1=, 0
BB0_3:                                  # %return
	return  	$1
func_end0:
	.size	f, func_end0-f

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
