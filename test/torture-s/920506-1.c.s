	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/920506-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB0_2
	i32.load	$push0=, l($0)
	br_if   	$pop0, BB0_2
# BB#1:                                 # %sw.bb
	call    	exit, $0
	unreachable
BB0_2:                                  # %sw.epilog
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	l,@object               # @l
	.data
	.globl	l
	.align	2
l:
	.int32	0                       # 0x0
	.int32	1                       # 0x1
	.size	l, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
