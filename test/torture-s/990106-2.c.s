	.text
	.file	"990106-2.c"
	.section	.text.calc_mp,"ax",@progbits
	.hidden	calc_mp                 # -- Begin function calc_mp
	.globl	calc_mp
	.type	calc_mp,@function
calc_mp:                                # @calc_mp
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, -1
	i32.rem_u	$push1=, $pop0, $0
	i32.const	$push2=, 1
	i32.add 	$1=, $pop1, $pop2
	i32.const	$push4=, 0
	i32.gt_u	$push3=, $1, $0
	i32.select	$push5=, $0, $pop4, $pop3
	i32.sub 	$push6=, $1, $pop5
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end0:
	.size	calc_mp, .Lfunc_end0-calc_mp
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
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
