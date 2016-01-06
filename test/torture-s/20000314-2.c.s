	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000314-2.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	BB0_2
	i32.load	$push0=, a($0)
	br_if   	$pop0, BB0_2
# BB#1:                                 # %if.then
	call    	abort
	unreachable
BB0_2:                                  # %if.end
	call    	exit, $0
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	bigconst,@object        # @bigconst
	.section	.rodata,"a",@progbits
	.globl	bigconst
	.align	3
bigconst:
	.int64	17179869184             # 0x400000000
	.size	bigconst, 8

	.type	a,@object               # @a
	.data
	.globl	a
	.align	2
a:
	.int32	1                       # 0x1
	.size	a, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
