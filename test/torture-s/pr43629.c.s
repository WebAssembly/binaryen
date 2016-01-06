	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43629.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB0_2
	i32.load	$push0=, flag($0)
	br_if   	$pop0, BB0_2
# BB#1:                                 # %if.end4
	return  	$0
BB0_2:                                  # %if.then3
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	flag,@object            # @flag
	.bss
	.globl	flag
	.align	2
flag:
	.int32	0                       # 0x0
	.size	flag, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
