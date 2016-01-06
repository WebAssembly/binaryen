	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20080222-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load8_u	$push0=, 4($0)
	return  	$pop0
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB1_2
	i32.load8_u	$push0=, space+4($0)
	i32.const	$push1=, 5
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, BB1_2
# BB#1:                                 # %if.end
	return  	$0
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	space,@object           # @space
	.data
	.globl	space
space:
	.ascii	"\001\002\003\004\005\006"
	.size	space, 6


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
