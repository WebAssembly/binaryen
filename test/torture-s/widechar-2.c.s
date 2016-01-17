	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/widechar-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	ws                      # @ws
	.type	ws,@object
	.section	.rodata.ws,"a",@progbits
	.globl	ws
	.align	4
ws:
	.int32	102                     # 0x66
	.int32	111                     # 0x6f
	.int32	111                     # 0x6f
	.int32	0                       # 0x0
	.size	ws, 16


	.ident	"clang version 3.9.0 "
