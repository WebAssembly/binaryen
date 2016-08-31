	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-5.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i64
# BB#0:                                 # %entry
	block
	i32.const	$push35=, 0
	i32.load	$push34=, t($pop35)
	tee_local	$push33=, $0=, $pop34
	i32.const	$push0=, 4
	i32.ge_s	$push1=, $pop33, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %ap.exit.i
	i32.const	$push42=, 0
	i32.const	$push2=, 1
	i32.add 	$push41=, $0, $pop2
	tee_local	$push40=, $1=, $pop41
	i32.store	$drop=, t($pop42), $pop40
	i32.const	$push39=, 2
	i32.shl 	$push3=, $0, $pop39
	i32.const	$push38=, a
	i32.add 	$push4=, $pop3, $pop38
	i32.const	$push37=, 0
	i32.store	$drop=, 0($pop4), $pop37
	i32.const	$push36=, 3
	i32.eq  	$push5=, $0, $pop36
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %ap.exit.1.i
	i32.const	$push50=, 0
	i32.const	$push49=, 2
	i32.add 	$push48=, $0, $pop49
	tee_local	$push47=, $2=, $pop48
	i32.store	$drop=, t($pop50), $pop47
	i32.const	$push46=, 2
	i32.shl 	$push6=, $1, $pop46
	i32.const	$push45=, a
	i32.add 	$push7=, $pop6, $pop45
	i32.const	$push44=, 3
	i32.store	$drop=, 0($pop7), $pop44
	i32.const	$push43=, 3
	i32.gt_s	$push8=, $2, $pop43
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %ap.exit.2.i
	i32.const	$push57=, 0
	i32.const	$push9=, 3
	i32.add 	$push56=, $0, $pop9
	tee_local	$push55=, $1=, $pop56
	i32.store	$drop=, t($pop57), $pop55
	i32.const	$push54=, 2
	i32.shl 	$push10=, $2, $pop54
	i32.const	$push53=, a
	i32.add 	$push11=, $pop10, $pop53
	i32.const	$push52=, 2
	i32.store	$drop=, 0($pop11), $pop52
	i32.const	$push51=, 0
	i32.gt_s	$push12=, $0, $pop51
	br_if   	0, $pop12       # 0: down to label0
# BB#4:                                 # %testit.exit
	i32.const	$push62=, 2
	i32.shl 	$push13=, $1, $pop62
	i32.const	$push61=, a
	i32.add 	$push14=, $pop13, $pop61
	i32.const	$push15=, 1
	i32.store	$drop=, 0($pop14), $pop15
	i32.const	$push18=, 0
	i32.const	$push16=, 4
	i32.add 	$push17=, $0, $pop16
	i32.store	$drop=, t($pop18), $pop17
	i32.const	$push60=, 0
	i64.load	$push59=, a($pop60)
	tee_local	$push58=, $3=, $pop59
	i32.wrap/i64	$push19=, $pop58
	br_if   	0, $pop19       # 0: down to label0
# BB#5:                                 # %if.end
	i64.const	$push20=, -4294967296
	i64.and 	$push21=, $3, $pop20
	i64.const	$push22=, 12884901888
	i64.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label0
# BB#6:                                 # %if.end3
	i32.const	$push24=, 0
	i64.load	$push64=, a+8($pop24)
	tee_local	$push63=, $3=, $pop64
	i32.wrap/i64	$push25=, $pop63
	i32.const	$push26=, 2
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#7:                                 # %if.end6
	i64.const	$push28=, -4294967296
	i64.and 	$push29=, $3, $pop28
	i64.const	$push30=, 4294967296
	i64.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label0
# BB#8:                                 # %if.end9
	i32.const	$push32=, 0
	call    	exit@FUNCTION, $pop32
	unreachable
.LBB0_9:                                # %if.then8
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	a,@object               # @a
	.section	.bss.a,"aw",@nobits
	.p2align	4
a:
	.skip	16
	.size	a, 16

	.type	t,@object               # @t
	.section	.bss.t,"aw",@nobits
	.p2align	2
t:
	.int32	0                       # 0x0
	.size	t, 4


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
