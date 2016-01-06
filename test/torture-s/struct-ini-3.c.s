	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/struct-ini-3.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	result,@object          # @result
	.data
	.globl	result
	.align	2
result:
	.int8	255                     # 0xff
	.int8	15                      # 0xf
	.zero	2
	.size	result, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
