	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr42721.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, b($0)
	block   	BB0_2
	i32.const	$push0=, 1
	i32.xor 	$push1=, $1, $pop0
	i32.store	$discard=, b($0), $pop1
	br_if   	$1, BB0_2
# BB#1:                                 # %if.end
	return  	$0
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	b,@object               # @b
	.lcomm	b,4,2

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
