	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/961004-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB0_2
	i32.load	$push0=, k($0)
	br_if   	$pop0, .LBB0_2
# BB#1:                                 # %if.else
	i32.const	$push1=, 1
	i32.store	$discard=, k($0), $pop1
.LBB0_2:                                # %for.inc.1
	call    	exit@FUNCTION, $0
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	k                       # @k
	.type	k,@object
	.section	.bss.k,"aw",@nobits
	.globl	k
	.align	2
k:
	.int32	0                       # 0x0
	.size	k, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
