	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20051104-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.store	$discard=, s($0), $0
	i32.const	$push0=, .str
	i32.store	$discard=, s+4($0), $pop0
	return  	$0
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	s,@object               # @s
	.bss
	.globl	s
	.align	2
s:
	.zero	8
	.size	s, 8

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.zero	1
	.size	.str, 1


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
