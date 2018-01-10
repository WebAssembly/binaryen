	.text
	.file	"20000726-1.c"
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
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.adjust_xy,"ax",@progbits
	.hidden	adjust_xy               # -- Begin function adjust_xy
	.globl	adjust_xy
	.type	adjust_xy,@function
adjust_xy:                              # @adjust_xy
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
	i32.store16	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	adjust_xy, .Lfunc_end1-adjust_xy
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
