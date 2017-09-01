	.text
	.file	"pr44683.c"
	.section	.text.copysign_bug,"ax",@progbits
	.hidden	copysign_bug            # -- Begin function copysign_bug
	.globl	copysign_bug
	.type	copysign_bug,@function
copysign_bug:                           # @copysign_bug
	.param  	f64
	.result 	i32
# BB#0:                                 # %entry
	block   	
	f64.const	$push10=, 0x0p0
	f64.eq  	$push2=, $0, $pop10
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %entry
	f64.const	$push1=, 0x1p-1
	f64.mul 	$push0=, $0, $pop1
	f64.ne  	$push3=, $pop0, $0
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %return
	i32.const	$push11=, 1
	return  	$pop11
.LBB0_3:                                # %if.end
	end_block                       # label0:
	i32.const	$push8=, 2
	i32.const	$push7=, 3
	f64.const	$push4=, 0x1p0
	f64.copysign	$push5=, $pop4, $0
	f64.const	$push12=, 0x0p0
	f64.lt  	$push6=, $pop5, $pop12
	i32.select	$push9=, $pop8, $pop7, $pop6
                                        # fallthrough-return: $pop9
	.endfunc
.Lfunc_end0:
	.size	copysign_bug, .Lfunc_end0-copysign_bug
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	f64.const	$push0=, -0x0p0
	i32.call	$push1=, copysign_bug@FUNCTION, $pop0
	i32.const	$push2=, 2
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
