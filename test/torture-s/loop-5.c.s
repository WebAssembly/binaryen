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
	block
	i32.const	$push35=, 0
	i32.load	$push34=, t($pop35)
	tee_local	$push33=, $2=, $pop34
	i32.const	$push3=, 4
	i32.ge_s	$push4=, $pop33, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#1:                                 # %ap.exit.i
	i32.const	$push39=, 2
	i32.shl 	$push6=, $2, $pop39
	i32.const	$push38=, 0
	i32.store	$discard=, a($pop6), $pop38
	i32.const	$push37=, 0
	i32.const	$push5=, 1
	i32.add 	$push0=, $2, $pop5
	i32.store	$1=, t($pop37), $pop0
	i32.const	$push36=, 2
	i32.gt_s	$push7=, $2, $pop36
	br_if   	0, $pop7        # 0: down to label1
# BB#2:                                 # %ap.exit.1.i
	i32.const	$push44=, 2
	i32.shl 	$push8=, $1, $pop44
	i32.const	$push9=, 3
	i32.store	$1=, a($pop8), $pop9
	i32.const	$push43=, 0
	i32.const	$push42=, 2
	i32.add 	$push1=, $2, $pop42
	i32.store	$push41=, t($pop43), $pop1
	tee_local	$push40=, $3=, $pop41
	i32.gt_s	$push10=, $pop40, $1
	br_if   	0, $pop10       # 0: down to label1
# BB#3:                                 # %ap.exit.2.i
	i32.const	$push11=, 2
	i32.shl 	$push12=, $3, $pop11
	i32.const	$push47=, 2
	i32.store	$3=, a($pop12), $pop47
	i32.const	$push46=, 0
	i32.add 	$push2=, $2, $1
	i32.store	$1=, t($pop46), $pop2
	i32.const	$push45=, 0
	i32.le_s	$push13=, $2, $pop45
	br_if   	1, $pop13       # 1: down to label0
.LBB0_4:                                # %if.then.i.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_5:                                # %testit.exit
	end_block                       # label0:
	i32.shl 	$push17=, $1, $3
	i32.const	$push18=, 1
	i32.store	$discard=, a($pop17), $pop18
	i32.const	$push16=, 0
	i64.load	$0=, a($pop16):p2align=4
	i32.const	$push48=, 0
	i32.const	$push14=, 4
	i32.add 	$push15=, $2, $pop14
	i32.store	$discard=, t($pop48), $pop15
	block
	block
	block
	block
	i32.wrap/i64	$push19=, $0
	br_if   	0, $pop19       # 0: down to label5
# BB#6:                                 # %if.end
	i64.const	$push20=, -4294967296
	i64.and 	$push21=, $0, $pop20
	i64.const	$push22=, 12884901888
	i64.ne  	$push23=, $pop21, $pop22
	br_if   	1, $pop23       # 1: down to label4
# BB#7:                                 # %if.end3
	i32.const	$push24=, 0
	i64.load	$push50=, a+8($pop24)
	tee_local	$push49=, $0=, $pop50
	i32.wrap/i64	$push25=, $pop49
	i32.const	$push26=, 2
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	2, $pop27       # 2: down to label3
# BB#8:                                 # %if.end6
	i64.const	$push28=, -4294967296
	i64.and 	$push29=, $0, $pop28
	i64.const	$push30=, 4294967296
	i64.ne  	$push31=, $pop29, $pop30
	br_if   	3, $pop31       # 3: down to label2
# BB#9:                                 # %if.end9
	i32.const	$push32=, 0
	call    	exit@FUNCTION, $pop32
	unreachable
.LBB0_10:                               # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_11:                               # %if.then2
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_12:                               # %if.then5
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_13:                               # %if.then8
	end_block                       # label2:
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
