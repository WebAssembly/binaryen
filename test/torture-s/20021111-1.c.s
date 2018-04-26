	.text
	.file	"20021111-1.c"
	.section	.text.aim_callhandler,"ax",@progbits
	.hidden	aim_callhandler         # -- Begin function aim_callhandler
	.globl	aim_callhandler
	.type	aim_callhandler,@function
aim_callhandler:                        # @aim_callhandler
	.param  	i32, i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	block   	
	i32.eqz 	$push9=, $1
	br_if   	0, $pop9        # 0: down to label1
# %bb.1:                                # %entry
	i32.const	$push0=, 65535
	i32.eq  	$push1=, $3, $pop0
	br_if   	0, $pop1        # 0: down to label1
# %bb.2:                                # %if.end3
	i32.const	$push6=, 0
	i32.load	$1=, aim_callhandler.i($pop6)
	i32.const	$push5=, 1
	i32.ge_s	$push2=, $1, $pop5
	br_if   	1, $pop2        # 1: down to label0
# %bb.3:                                # %if.end7
	i32.const	$push8=, 0
	i32.const	$push7=, 1
	i32.add 	$push3=, $1, $pop7
	i32.store	aim_callhandler.i($pop8), $pop3
.LBB0_4:                                # %return
	end_block                       # label1:
	i32.const	$push4=, 0
	return  	$pop4
.LBB0_5:                                # %if.then6
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	aim_callhandler, .Lfunc_end0-aim_callhandler
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1
	i32.const	$push4=, 0
	i32.const	$push3=, 0
	i32.call	$drop=, aim_callhandler@FUNCTION, $pop1, $pop0, $pop4, $pop3
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	aim_callhandler.i,@object # @aim_callhandler.i
	.section	.bss.aim_callhandler.i,"aw",@nobits
	.p2align	2
aim_callhandler.i:
	.int32	0                       # 0x0
	.size	aim_callhandler.i, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
