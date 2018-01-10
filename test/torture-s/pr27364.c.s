	.text
	.file	"pr27364.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$1=, 0
	block   	
	i32.const	$push0=, 1294
	i32.gt_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push2=, 3321928
	i32.mul 	$push3=, $0, $pop2
	i32.const	$push4=, 1000000
	i32.div_u	$push5=, $pop3, $pop4
	i32.const	$push6=, 1
	i32.add 	$push7=, $pop5, $pop6
	i32.const	$push8=, 4
	i32.shr_u	$1=, $pop7, $pop8
.LBB0_2:                                # %return
	end_block                       # label0:
	copy_local	$push9=, $1
                                        # fallthrough-return: $pop9
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
