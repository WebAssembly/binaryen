	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000403-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB0_2
	i32.load	$push0=, aa($0)
	i32.const	$push2=, 4096
	i32.add 	$push3=, $pop0, $pop2
	i32.load	$push1=, bb($0)
	i32.sub 	$push4=, $pop3, $pop1
	i32.le_s	$push5=, $pop4, $0
	br_if   	$pop5, .LBB0_2
# BB#1:                                 # %if.end
	call    	exit, $0
	unreachable
.LBB0_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.globl	seqgt
	.type	seqgt,@function
seqgt:                                  # @seqgt
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.add 	$push0=, $1, $0
	i32.sub 	$push1=, $pop0, $2
	i32.const	$push2=, 0
	i32.gt_s	$push3=, $pop1, $pop2
	return  	$pop3
.Lfunc_end1:
	.size	seqgt, .Lfunc_end1-seqgt

	.globl	seqgt2
	.type	seqgt2,@function
seqgt2:                                 # @seqgt2
	.param  	i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.add 	$push0=, $1, $0
	i32.sub 	$push1=, $pop0, $2
	i32.const	$push2=, 0
	i32.gt_s	$push3=, $pop1, $pop2
	return  	$pop3
.Lfunc_end2:
	.size	seqgt2, .Lfunc_end2-seqgt2

	.type	aa,@object              # @aa
	.data
	.globl	aa
	.align	2
aa:
	.int32	2147479553              # 0x7ffff001
	.size	aa, 4

	.type	bb,@object              # @bb
	.globl	bb
	.align	2
bb:
	.int32	2147479553              # 0x7ffff001
	.size	bb, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
