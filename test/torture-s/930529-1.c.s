	.text
	.file	"930529-1.c"
	.section	.text.dd,"ax",@progbits
	.hidden	dd                      # -- Begin function dd
	.globl	dd
	.type	dd,@function
dd:                                     # @dd
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.div_s	$push0=, $0, $1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	dd, .Lfunc_end0-dd
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
.LBB1_1:                                # %if.end44
                                        # =>This Inner Loop Header: Depth=1
	loop    	i32             # label0:
	br      	0               # 0: up to label0
.LBB1_2:
	end_loop
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
