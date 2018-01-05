	.text
	.file	"loop-5.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push27=, 0
	i32.load	$0=, t($pop27)
	block   	
	i32.const	$push0=, 4
	i32.ge_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %ap.exit.i
	i32.const	$push33=, 1
	i32.add 	$1=, $0, $pop33
	i32.const	$push32=, 0
	i32.store	t($pop32), $1
	i32.const	$push31=, 2
	i32.shl 	$push2=, $0, $pop31
	i32.const	$push30=, a
	i32.add 	$push3=, $pop2, $pop30
	i32.const	$push29=, 0
	i32.store	0($pop3), $pop29
	i32.const	$push28=, 3
	i32.eq  	$push4=, $0, $pop28
	br_if   	0, $pop4        # 0: down to label0
# %bb.2:                                # %ap.exit.1.i
	i32.const	$push39=, 2
	i32.add 	$2=, $0, $pop39
	i32.const	$push38=, 0
	i32.store	t($pop38), $2
	i32.const	$push37=, 2
	i32.shl 	$push5=, $1, $pop37
	i32.const	$push36=, a
	i32.add 	$push6=, $pop5, $pop36
	i32.const	$push35=, 3
	i32.store	0($pop6), $pop35
	i32.const	$push34=, 1
	i32.gt_s	$push7=, $0, $pop34
	br_if   	0, $pop7        # 0: down to label0
# %bb.3:                                # %ap.exit.2.i
	i32.const	$push8=, 3
	i32.add 	$1=, $0, $pop8
	i32.const	$push44=, 0
	i32.store	t($pop44), $1
	i32.const	$push43=, 2
	i32.shl 	$push9=, $2, $pop43
	i32.const	$push42=, a
	i32.add 	$push10=, $pop9, $pop42
	i32.const	$push41=, 2
	i32.store	0($pop10), $pop41
	i32.const	$push40=, 1
	i32.eq  	$push11=, $0, $pop40
	br_if   	0, $pop11       # 0: down to label0
# %bb.4:                                # %testit.exit
	i32.const	$push49=, 2
	i32.shl 	$push12=, $1, $pop49
	i32.const	$push48=, a
	i32.add 	$push13=, $pop12, $pop48
	i32.const	$push47=, 1
	i32.store	0($pop13), $pop47
	i32.const	$push46=, 0
	i32.const	$push14=, 4
	i32.add 	$push15=, $0, $pop14
	i32.store	t($pop46), $pop15
	i32.const	$push45=, 0
	i32.load	$push16=, a($pop45)
	br_if   	0, $pop16       # 0: down to label0
# %bb.5:                                # %if.end
	i32.const	$push50=, 0
	i32.load	$push17=, a+4($pop50)
	i32.const	$push18=, 3
	i32.ne  	$push19=, $pop17, $pop18
	br_if   	0, $pop19       # 0: down to label0
# %bb.6:                                # %if.end3
	i32.const	$push51=, 0
	i32.load	$push20=, a+8($pop51)
	i32.const	$push21=, 2
	i32.ne  	$push22=, $pop20, $pop21
	br_if   	0, $pop22       # 0: down to label0
# %bb.7:                                # %if.end6
	i32.const	$push52=, 0
	i32.load	$push23=, a+12($pop52)
	i32.const	$push24=, 1
	i32.ne  	$push25=, $pop23, $pop24
	br_if   	0, $pop25       # 0: down to label0
# %bb.8:                                # %if.end9
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
