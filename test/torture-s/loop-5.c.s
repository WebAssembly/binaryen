	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-5.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push31=, 0
	i32.load	$push30=, t($pop31)
	tee_local	$push29=, $0=, $pop30
	i32.const	$push0=, 4
	i32.ge_s	$push1=, $pop29, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %ap.exit.i
	i32.const	$push38=, 0
	i32.const	$push2=, 1
	i32.add 	$push37=, $0, $pop2
	tee_local	$push36=, $1=, $pop37
	i32.store	t($pop38), $pop36
	i32.const	$push35=, 2
	i32.shl 	$push3=, $0, $pop35
	i32.const	$push34=, a
	i32.add 	$push4=, $pop3, $pop34
	i32.const	$push33=, 0
	i32.store	0($pop4), $pop33
	i32.const	$push32=, 3
	i32.eq  	$push5=, $0, $pop32
	br_if   	0, $pop5        # 0: down to label0
# BB#2:                                 # %ap.exit.1.i
	i32.const	$push46=, 0
	i32.const	$push45=, 2
	i32.add 	$push44=, $0, $pop45
	tee_local	$push43=, $2=, $pop44
	i32.store	t($pop46), $pop43
	i32.const	$push42=, 2
	i32.shl 	$push6=, $1, $pop42
	i32.const	$push41=, a
	i32.add 	$push7=, $pop6, $pop41
	i32.const	$push40=, 3
	i32.store	0($pop7), $pop40
	i32.const	$push39=, 3
	i32.gt_s	$push8=, $2, $pop39
	br_if   	0, $pop8        # 0: down to label0
# BB#3:                                 # %ap.exit.2.i
	i32.const	$push53=, 0
	i32.const	$push9=, 3
	i32.add 	$push52=, $0, $pop9
	tee_local	$push51=, $1=, $pop52
	i32.store	t($pop53), $pop51
	i32.const	$push50=, 2
	i32.shl 	$push10=, $2, $pop50
	i32.const	$push49=, a
	i32.add 	$push11=, $pop10, $pop49
	i32.const	$push48=, 2
	i32.store	0($pop11), $pop48
	i32.const	$push47=, 0
	i32.gt_s	$push12=, $0, $pop47
	br_if   	0, $pop12       # 0: down to label0
# BB#4:                                 # %testit.exit
	i32.const	$push57=, 2
	i32.shl 	$push13=, $1, $pop57
	i32.const	$push56=, a
	i32.add 	$push14=, $pop13, $pop56
	i32.const	$push15=, 1
	i32.store	0($pop14), $pop15
	i32.const	$push55=, 0
	i32.const	$push16=, 4
	i32.add 	$push17=, $0, $pop16
	i32.store	t($pop55), $pop17
	i32.const	$push54=, 0
	i32.load	$push18=, a($pop54)
	br_if   	0, $pop18       # 0: down to label0
# BB#5:                                 # %if.end
	i32.const	$push58=, 0
	i32.load	$push19=, a+4($pop58)
	i32.const	$push20=, 3
	i32.ne  	$push21=, $pop19, $pop20
	br_if   	0, $pop21       # 0: down to label0
# BB#6:                                 # %if.end3
	i32.const	$push59=, 0
	i32.load	$push22=, a+8($pop59)
	i32.const	$push23=, 2
	i32.ne  	$push24=, $pop22, $pop23
	br_if   	0, $pop24       # 0: down to label0
# BB#7:                                 # %if.end6
	i32.const	$push60=, 0
	i32.load	$push25=, a+12($pop60)
	i32.const	$push26=, 1
	i32.ne  	$push27=, $pop25, $pop26
	br_if   	0, $pop27       # 0: down to label0
# BB#8:                                 # %if.end9
	i32.const	$push28=, 0
	call    	exit@FUNCTION, $pop28
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
