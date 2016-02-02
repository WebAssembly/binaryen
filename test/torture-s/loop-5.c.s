	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-5.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push37=, 0
	i32.load	$push0=, t($pop37)
	tee_local	$push36=, $2=, $pop0
	i32.const	$push5=, 4
	i32.ge_s	$push6=, $pop36, $pop5
	br_if   	$pop6, 0        # 0: down to label0
# BB#1:                                 # %ap.exit.i
	i32.const	$push41=, 2
	i32.shl 	$push8=, $2, $pop41
	i32.const	$push40=, 0
	i32.store	$discard=, a($pop8), $pop40
	i32.const	$push39=, 0
	i32.const	$push7=, 1
	i32.add 	$push1=, $2, $pop7
	i32.store	$1=, t($pop39), $pop1
	i32.const	$push38=, 2
	i32.gt_s	$push9=, $2, $pop38
	br_if   	$pop9, 0        # 0: down to label0
# BB#2:                                 # %ap.exit.1.i
	i32.const	$push45=, 2
	i32.shl 	$push11=, $1, $pop45
	i32.const	$push12=, 3
	i32.store	$1=, a($pop11), $pop12
	i32.const	$push44=, 0
	i32.const	$push43=, 2
	i32.add 	$push2=, $2, $pop43
	i32.store	$push10=, t($pop44), $pop2
	tee_local	$push42=, $3=, $pop10
	i32.gt_s	$push13=, $pop42, $1
	br_if   	$pop13, 0       # 0: down to label0
# BB#3:                                 # %ap.exit.2.i
	i32.const	$push14=, 2
	i32.shl 	$push15=, $3, $pop14
	i32.const	$push48=, 2
	i32.store	$3=, a($pop15), $pop48
	i32.const	$push47=, 0
	i32.add 	$push3=, $2, $1
	i32.store	$1=, t($pop47), $pop3
	i32.const	$push46=, 0
	i32.gt_s	$push16=, $2, $pop46
	br_if   	$pop16, 0       # 0: down to label0
# BB#4:                                 # %testit.exit
	i32.shl 	$push20=, $1, $3
	i32.const	$push21=, 1
	i32.store	$discard=, a($pop20), $pop21
	i32.const	$push19=, 0
	i64.load	$0=, a($pop19):p2align=4
	i32.const	$push49=, 0
	i32.const	$push17=, 4
	i32.add 	$push18=, $2, $pop17
	i32.store	$discard=, t($pop49), $pop18
	block
	i32.wrap/i64	$push22=, $0
	br_if   	$pop22, 0       # 0: down to label1
# BB#5:                                 # %if.end
	block
	i64.const	$push23=, -4294967296
	i64.and 	$push24=, $0, $pop23
	i64.const	$push25=, 12884901888
	i64.ne  	$push26=, $pop24, $pop25
	br_if   	$pop26, 0       # 0: down to label2
# BB#6:                                 # %if.end3
	block
	i32.const	$push27=, 0
	i64.load	$push4=, a+8($pop27)
	tee_local	$push50=, $0=, $pop4
	i32.wrap/i64	$push28=, $pop50
	i32.const	$push29=, 2
	i32.ne  	$push30=, $pop28, $pop29
	br_if   	$pop30, 0       # 0: down to label3
# BB#7:                                 # %if.end6
	block
	i64.const	$push31=, -4294967296
	i64.and 	$push32=, $0, $pop31
	i64.const	$push33=, 4294967296
	i64.ne  	$push34=, $pop32, $pop33
	br_if   	$pop34, 0       # 0: down to label4
# BB#8:                                 # %if.end9
	i32.const	$push35=, 0
	call    	exit@FUNCTION, $pop35
	unreachable
.LBB0_9:                                # %if.then8
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_10:                               # %if.then5
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_11:                               # %if.then2
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_12:                               # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_13:                               # %if.then.i.i
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	a,@object               # @a
	.lcomm	a,16,4
	.type	t,@object               # @t
	.lcomm	t,4,2

	.ident	"clang version 3.9.0 "
