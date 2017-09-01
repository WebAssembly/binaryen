	.text
	.file	"20021111-1.c"
	.section	.text.aim_callhandler,"ax",@progbits
	.hidden	aim_callhandler         # -- Begin function aim_callhandler
	.globl	aim_callhandler
	.type	aim_callhandler,@function
aim_callhandler:                        # @aim_callhandler
	.param  	i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.eqz 	$push11=, $1
	br_if   	0, $pop11       # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push0=, 65535
	i32.eq  	$push1=, $3, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#2:                                 # %if.end3
	i32.const	$push8=, 0
	i32.load	$push7=, aim_callhandler.i($pop8)
	tee_local	$push6=, $1=, $pop7
	i32.const	$push5=, 1
	i32.ge_s	$push2=, $pop6, $pop5
	br_if   	1, $pop2        # 1: down to label0
# BB#3:                                 # %if.end7
	i32.const	$push10=, 0
	i32.const	$push9=, 1
	i32.add 	$push3=, $1, $pop9
	i32.store	aim_callhandler.i($pop10), $pop3
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
# BB#0:                                 # %entry
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
