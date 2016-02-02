	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021111-1.c"
	.section	.text.aim_callhandler,"ax",@progbits
	.hidden	aim_callhandler
	.globl	aim_callhandler
	.type	aim_callhandler,@function
aim_callhandler:                        # @aim_callhandler
	.param  	i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push11=, 0
	i32.eq  	$push12=, $1, $pop11
	br_if   	$pop12, 0       # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push1=, 65535
	i32.eq  	$push2=, $3, $pop1
	br_if   	$pop2, 0        # 0: down to label0
# BB#2:                                 # %if.end3
	block
	i32.const	$push8=, 0
	i32.load	$push0=, aim_callhandler.i($pop8)
	tee_local	$push7=, $1=, $pop0
	i32.const	$push6=, 1
	i32.ge_s	$push3=, $pop7, $pop6
	br_if   	$pop3, 0        # 0: down to label1
# BB#3:                                 # %if.end7
	i32.const	$push10=, 0
	i32.const	$push9=, 1
	i32.add 	$push4=, $1, $pop9
	i32.store	$discard=, aim_callhandler.i($pop10), $pop4
	br      	1               # 1: down to label0
.LBB0_4:                                # %if.then6
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_5:                                # %return
	end_block                       # label0:
	i32.const	$push5=, 0
	return  	$pop5
	.endfunc
.Lfunc_end0:
	.size	aim_callhandler, .Lfunc_end0-aim_callhandler

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push5=, 0
	i32.load	$push0=, aim_callhandler.i($pop5)
	tee_local	$push4=, $0=, $pop0
	i32.const	$push3=, 1
	i32.lt_s	$push1=, $pop4, $pop3
	br_if   	$pop1, 0        # 0: down to label2
# BB#1:                                 # %if.then6.i
	call    	abort@FUNCTION
	unreachable
.LBB1_2:                                # %aim_callhandler.exit
	end_block                       # label2:
	i32.const	$push8=, 0
	i32.const	$push7=, 1
	i32.add 	$push2=, $0, $pop7
	i32.store	$discard=, aim_callhandler.i($pop8), $pop2
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	aim_callhandler.i,@object # @aim_callhandler.i
	.lcomm	aim_callhandler.i,4,2

	.ident	"clang version 3.9.0 "
