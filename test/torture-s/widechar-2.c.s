	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/widechar-2.c"
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

	.type	ws,@object              # @ws
	.section	.rodata,"a",@progbits
	.globl	ws
	.align	4
ws:
	.int32	102                     # 0x66
	.int32	111                     # 0x6f
	.int32	111                     # 0x6f
	.int32	0                       # 0x0
	.size	ws, 16


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
