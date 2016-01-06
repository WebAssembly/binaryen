	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/builtin-types-compatible-p.c"
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

	.type	i,@object               # @i
	.bss
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.type	d,@object               # @d
	.globl	d
	.align	3
d:
	.int64	0                       # double 0
	.size	d, 8

	.type	rootbeer,@object        # @rootbeer
	.globl	rootbeer
	.align	2
rootbeer:
	.zero	4
	.size	rootbeer, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
