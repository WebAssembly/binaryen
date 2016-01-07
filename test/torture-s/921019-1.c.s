	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/921019-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB0_2
	i32.load	$push0=, foo($0)
	i32.load8_u	$push1=, 0($pop0)
	i32.const	$push2=, 88
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, .LBB0_2
# BB#1:                                 # %if.end
	call    	exit, $0
	unreachable
.LBB0_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"X"
	.size	.str, 2

	.type	foo,@object             # @foo
	.data
	.globl	foo
	.align	2
foo:
	.int32	.str
	.size	foo, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
