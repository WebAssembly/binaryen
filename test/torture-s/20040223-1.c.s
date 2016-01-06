	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040223-1.c"
	.globl	a
	.type	a,@function
a:                                      # @a
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	BB0_2
	i32.const	$push0=, 1234
	i32.ne  	$push1=, $1, $pop0
	br_if   	$pop1, BB0_2
# BB#1:                                 # %if.end
	return
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	a, func_end0-a

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
