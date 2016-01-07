	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr31136.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load16_u	$push0=, s($0)
	i32.const	$push1=, 64512
	i32.and 	$push2=, $pop0, $pop1
	i32.const	$push3=, 255
	i32.or  	$push4=, $pop2, $pop3
	i32.store16	$discard=, s($0), $pop4
	return  	$0
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	s,@object               # @s
	.bss
	.globl	s
	.align	2
s:
	.zero	4
	.size	s, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
