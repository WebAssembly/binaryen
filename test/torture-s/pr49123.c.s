	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49123.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load8_u	$push0=, s.0($0)
	i32.const	$push1=, 1
	i32.or  	$push2=, $pop0, $pop1
	i32.store8	$discard=, s.0($0), $pop2
	return  	$0
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	s.0,@object             # @s.0
	.lcomm	s.0,1,2

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
