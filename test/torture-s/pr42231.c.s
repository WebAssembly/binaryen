	.text
	.file	"pr42231.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 1
	i32.call	$push1=, CallFunctionRec@FUNCTION, $pop0
	i32.eqz 	$push8=, $pop1
	br_if   	0, $pop8        # 0: down to label0
# %bb.1:                                # %land.rhs.i
	i32.const	$push2=, 0
	call    	storemax@FUNCTION, $pop2
.LBB0_2:                                # %CallFunction.exit
	end_block                       # label0:
	block   	
	i32.const	$push6=, 0
	i32.load	$push3=, max($pop6)
	i32.const	$push4=, 10
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label1
# %bb.3:                                # %if.end
	i32.const	$push7=, 0
	return  	$pop7
.LBB0_4:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.CallFunctionRec,"ax",@progbits
	.type	CallFunctionRec,@function # -- Begin function CallFunctionRec
CallFunctionRec:                        # @CallFunctionRec
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	call    	storemax@FUNCTION, $0
	block   	
	block   	
	i32.eqz 	$push5=, $0
	br_if   	0, $pop5        # 0: down to label3
# %bb.1:                                # %if.end
	i32.const	$1=, 1
	i32.const	$push0=, 9
	i32.gt_s	$push1=, $0, $pop0
	br_if   	1, $pop1        # 1: down to label2
# %bb.2:                                # %if.then1
	i32.const	$push2=, 1
	i32.add 	$push3=, $0, $pop2
	i32.call	$drop=, CallFunctionRec@FUNCTION, $pop3
	i32.const	$push4=, 1
	return  	$pop4
.LBB1_3:
	end_block                       # label3:
	i32.const	$1=, 0
.LBB1_4:                                # %return
	end_block                       # label2:
	copy_local	$push6=, $1
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end1:
	.size	CallFunctionRec, .Lfunc_end1-CallFunctionRec
                                        # -- End function
	.section	.text.storemax,"ax",@progbits
	.type	storemax,@function      # -- Begin function storemax
storemax:                               # @storemax
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push2=, 0
	i32.load	$push0=, max($pop2)
	i32.ge_s	$push1=, $pop0, $0
	br_if   	0, $pop1        # 0: down to label4
# %bb.1:                                # %if.then
	i32.const	$push3=, 0
	i32.store	max($pop3), $0
.LBB2_2:                                # %if.end
	end_block                       # label4:
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	storemax, .Lfunc_end2-storemax
                                        # -- End function
	.type	max,@object             # @max
	.section	.bss.max,"aw",@nobits
	.p2align	2
max:
	.int32	0                       # 0x0
	.size	max, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
