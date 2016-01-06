	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20031003-1.c"
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	return  	$0
func_end0:
	.size	f1, func_end0-f1

	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	return  	$0
func_end1:
	.size	f2, func_end1-f2

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
