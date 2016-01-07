	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/981001-1.c"
	.globl	sub
	.type	sub,@function
sub:                                    # @sub
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	.LBB0_4
	i32.const	$push0=, 2
	i32.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_4
# BB#1:                                 # %if.then
	i32.const	$2=, 1
	block   	.LBB0_3
	i32.const	$push3=, 31
	i32.shr_u	$push4=, $0, $pop3
	i32.add 	$push5=, $0, $pop4
	i32.shr_s	$1=, $pop5, $2
	i32.and 	$push2=, $0, $2
	br_if   	$pop2, .LBB0_3
# BB#2:                                 # %if.then2
	i32.call	$0=, sub, $1
	i32.const	$push10=, -1
	i32.add 	$push11=, $1, $pop10
	i32.call	$push12=, sub, $pop11
	i32.shl 	$push13=, $pop12, $2
	i32.add 	$push14=, $pop13, $0
	i32.mul 	$push15=, $pop14, $0
	return  	$pop15
.LBB0_3:                                  # %if.else
	i32.add 	$push6=, $1, $2
	i32.call	$0=, sub, $pop6
	i32.call	$2=, sub, $1
	i32.mul 	$push8=, $2, $2
	i32.mul 	$push7=, $0, $0
	i32.add 	$push9=, $pop8, $pop7
	return  	$pop9
.LBB0_4:                                  # %cleanup
	return  	$0
.Lfunc_end0:
	.size	sub, .Lfunc_end0-sub

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 30
	i32.call	$1=, sub, $pop0
	i32.const	$2=, 0
	i32.load	$0=, flg($2)
	block   	.LBB1_4
	block   	.LBB1_3
	i32.const	$push1=, 832040
	i32.ne  	$push2=, $1, $pop1
	br_if   	$pop2, .LBB1_3
# BB#1:                                 # %if.end
	br_if   	$0, .LBB1_4
# BB#2:                                 # %if.end2
	call    	exit, $2
	unreachable
.LBB1_3:                                  # %if.end.thread
	i32.const	$push3=, 256
	i32.or  	$push4=, $0, $pop3
	i32.store	$discard=, flg($2), $pop4
.LBB1_4:                                  # %if.then1
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	flg,@object             # @flg
	.bss
	.globl	flg
	.align	2
flg:
	.int32	0                       # 0x0
	.size	flg, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
