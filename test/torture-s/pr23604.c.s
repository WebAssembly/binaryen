	.text
	.file	"pr23604.c"
	.section	.text.g,"ax",@progbits
	.hidden	g                       # -- Begin function g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 1
	i32.gt_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %if.then2
	i32.eq  	$push2=, $0, $1
	br_if   	0, $pop2        # 0: down to label0
# %bb.2:                                # %if.then2
	i32.eqz 	$push5=, $1
	br_if   	0, $pop5        # 0: down to label0
# %bb.3:                                # %return
	i32.const	$push4=, 0
	return  	$pop4
.LBB0_4:                                # %if.end9
	end_block                       # label0:
	i32.const	$push3=, 1
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
