	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/simd-4.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i64.const	$push0=, -4294967295
	i64.store	$discard=, s64($0), $pop0
	return  	$0
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	s64,@object             # @s64
	.bss
	.globl	s64
	.align	3
s64:
	.int64	0                       # 0x0
	.size	s64, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
