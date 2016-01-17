	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43438.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.const	$push0=, 1
	i32.store	$discard=, g_9($0), $pop0
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	g_9,@object             # @g_9
	.lcomm	g_9,4,2

	.ident	"clang version 3.9.0 "
