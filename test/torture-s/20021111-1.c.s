	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021111-1.c"
	.globl	aim_callhandler
	.type	aim_callhandler,@function
aim_callhandler:                        # @aim_callhandler
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	.LBB0_5
	i32.const	$push5=, 0
	i32.eq  	$push6=, $1, $pop5
	br_if   	$pop6, .LBB0_5
# BB#1:                                 # %entry
	i32.const	$push0=, 65535
	i32.eq  	$push1=, $3, $pop0
	br_if   	$pop1, .LBB0_5
# BB#2:                                 # %if.end3
	i32.const	$1=, 0
	i32.load	$3=, aim_callhandler.i($1)
	i32.const	$4=, 1
	block   	.LBB0_4
	i32.ge_s	$push2=, $3, $4
	br_if   	$pop2, .LBB0_4
# BB#3:                                 # %if.end7
	i32.add 	$push3=, $3, $4
	i32.store	$discard=, aim_callhandler.i($1), $pop3
	br      	.LBB0_5
.LBB0_4:                                  # %if.then6
	call    	abort
	unreachable
.LBB0_5:                                  # %return
	i32.const	$push4=, 0
	return  	$pop4
.Lfunc_end0:
	.size	aim_callhandler, .Lfunc_end0-aim_callhandler

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$0=, aim_callhandler.i($1)
	i32.const	$2=, 1
	block   	.LBB1_2
	i32.lt_s	$push0=, $0, $2
	br_if   	$pop0, .LBB1_2
# BB#1:                                 # %if.then6.i
	call    	abort
	unreachable
.LBB1_2:                                  # %aim_callhandler.exit
	i32.add 	$push1=, $0, $2
	i32.store	$discard=, aim_callhandler.i($1), $pop1
	call    	exit, $1
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	aim_callhandler.i,@object # @aim_callhandler.i
	.lcomm	aim_callhandler.i,4,2

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
