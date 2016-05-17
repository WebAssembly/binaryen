	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-5.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push36=, 0
	i32.load	$push35=, t($pop36)
	tee_local	$push34=, $2=, $pop35
	i32.const	$push4=, 4
	i32.ge_s	$push5=, $pop34, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %ap.exit.i
	i32.const	$push39=, 2
	i32.shl 	$push7=, $2, $pop39
	i32.const	$push38=, 0
	i32.store	$push0=, a($pop7), $pop38
	i32.const	$push6=, 1
	i32.add 	$push1=, $2, $pop6
	i32.store	$0=, t($pop0), $pop1
	i32.const	$push37=, 3
	i32.eq  	$push8=, $2, $pop37
	br_if   	0, $pop8        # 0: down to label0
# BB#2:                                 # %ap.exit.1.i
	i32.const	$push45=, 2
	i32.shl 	$push9=, $0, $pop45
	i32.const	$push44=, 3
	i32.store	$0=, a($pop9), $pop44
	i32.const	$push43=, 0
	i32.const	$push42=, 2
	i32.add 	$push2=, $2, $pop42
	i32.store	$push41=, t($pop43), $pop2
	tee_local	$push40=, $3=, $pop41
	i32.gt_s	$push10=, $pop40, $0
	br_if   	0, $pop10       # 0: down to label0
# BB#3:                                 # %ap.exit.2.i
	i32.const	$push12=, 2
	i32.shl 	$push13=, $3, $pop12
	i32.const	$push48=, 2
	i32.store	$0=, a($pop13), $pop48
	i32.const	$push47=, 0
	i32.const	$push11=, 3
	i32.add 	$push3=, $2, $pop11
	i32.store	$3=, t($pop47), $pop3
	i32.const	$push46=, 0
	i32.gt_s	$push14=, $2, $pop46
	br_if   	0, $pop14       # 0: down to label0
# BB#4:                                 # %testit.exit
	i32.shl 	$push18=, $3, $0
	i32.const	$push19=, 1
	i32.store	$drop=, a($pop18), $pop19
	i32.const	$push17=, 0
	i64.load	$1=, a($pop17)
	i32.const	$push49=, 0
	i32.const	$push15=, 4
	i32.add 	$push16=, $2, $pop15
	i32.store	$drop=, t($pop49), $pop16
	i32.wrap/i64	$push20=, $1
	br_if   	0, $pop20       # 0: down to label0
# BB#5:                                 # %if.end
	i64.const	$push21=, -4294967296
	i64.and 	$push22=, $1, $pop21
	i64.const	$push23=, 12884901888
	i64.ne  	$push24=, $pop22, $pop23
	br_if   	0, $pop24       # 0: down to label0
# BB#6:                                 # %if.end3
	i32.const	$push25=, 0
	i64.load	$push51=, a+8($pop25)
	tee_local	$push50=, $1=, $pop51
	i32.wrap/i64	$push26=, $pop50
	i32.const	$push27=, 2
	i32.ne  	$push28=, $pop26, $pop27
	br_if   	0, $pop28       # 0: down to label0
# BB#7:                                 # %if.end6
	i64.const	$push29=, -4294967296
	i64.and 	$push30=, $1, $pop29
	i64.const	$push31=, 4294967296
	i64.ne  	$push32=, $pop30, $pop31
	br_if   	0, $pop32       # 0: down to label0
# BB#8:                                 # %if.end9
	i32.const	$push33=, 0
	call    	exit@FUNCTION, $pop33
	unreachable
.LBB0_9:                                # %if.then8
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
