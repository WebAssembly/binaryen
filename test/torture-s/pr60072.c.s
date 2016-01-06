	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr60072.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push0=, 2
	i32.store	$discard=, c($0), $pop0
	return  	$0
func_end0:
	.size	main, func_end0-main

	.type	c,@object               # @c
	.data
	.globl	c
	.align	2
c:
	.int32	1                       # 0x1
	.size	c, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
