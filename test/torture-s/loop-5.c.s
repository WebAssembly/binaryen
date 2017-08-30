	.text
	.file	"loop-5.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push29=, 0
	i32.load	$push28=, t($pop29)
	tee_local	$push27=, $0=, $pop28
	i32.const	$push0=, 4
	i32.ge_s	$push1=, $pop27, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %ap.exit.i
	i32.const	$push37=, 0
	i32.const	$push36=, 1
	i32.add 	$push35=, $0, $pop36
	tee_local	$push34=, $1=, $pop35
	i32.store	t($pop37), $pop34
	i32.const	$push33=, 2
	i32.shl 	$push2=, $0, $pop33
	i32.const	$push32=, a
	i32.add 	$push3=, $pop2, $pop32
	i32.const	$push31=, 0
	i32.store	0($pop3), $pop31
	i32.const	$push30=, 3
	i32.eq  	$push4=, $0, $pop30
	br_if   	0, $pop4        # 0: down to label0
# BB#2:                                 # %ap.exit.1.i
	i32.const	$push45=, 0
	i32.const	$push44=, 2
	i32.add 	$push43=, $0, $pop44
	tee_local	$push42=, $2=, $pop43
	i32.store	t($pop45), $pop42
	i32.const	$push41=, 2
	i32.shl 	$push5=, $1, $pop41
	i32.const	$push40=, a
	i32.add 	$push6=, $pop5, $pop40
	i32.const	$push39=, 3
	i32.store	0($pop6), $pop39
	i32.const	$push38=, 1
	i32.gt_s	$push7=, $0, $pop38
	br_if   	0, $pop7        # 0: down to label0
# BB#3:                                 # %ap.exit.2.i
	i32.const	$push52=, 0
	i32.const	$push8=, 3
	i32.add 	$push51=, $0, $pop8
	tee_local	$push50=, $1=, $pop51
	i32.store	t($pop52), $pop50
	i32.const	$push49=, 2
	i32.shl 	$push9=, $2, $pop49
	i32.const	$push48=, a
	i32.add 	$push10=, $pop9, $pop48
	i32.const	$push47=, 2
	i32.store	0($pop10), $pop47
	i32.const	$push46=, 1
	i32.eq  	$push11=, $0, $pop46
	br_if   	0, $pop11       # 0: down to label0
# BB#4:                                 # %testit.exit
	i32.const	$push57=, 2
	i32.shl 	$push12=, $1, $pop57
	i32.const	$push56=, a
	i32.add 	$push13=, $pop12, $pop56
	i32.const	$push55=, 1
	i32.store	0($pop13), $pop55
	i32.const	$push54=, 0
	i32.const	$push14=, 4
	i32.add 	$push15=, $0, $pop14
	i32.store	t($pop54), $pop15
	i32.const	$push53=, 0
	i32.load	$push16=, a($pop53)
	br_if   	0, $pop16       # 0: down to label0
# BB#5:                                 # %if.end
	i32.const	$push58=, 0
	i32.load	$push17=, a+4($pop58)
	i32.const	$push18=, 3
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label0
# BB#6:                                 # %if.end3
	i32.const	$push59=, 0
	i32.load	$push20=, a+8($pop59)
	i32.const	$push21=, 2
	i32.ne  	$push22=, $pop20, $pop21
	br_if   	0, $pop22       # 0: down to label0
# BB#7:                                 # %if.end6
	i32.const	$push60=, 0
	i32.load	$push23=, a+12($pop60)
	i32.const	$push24=, 1
	i32.ne  	$push25=, $pop23, $pop24
	br_if   	0, $pop25       # 0: down to label0
# BB#8:                                 # %if.end9
	i32.const	$push26=, 0
	call    	exit@FUNCTION, $pop26
	unreachable
.LBB0_9:                                # %if.then.i.i
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
