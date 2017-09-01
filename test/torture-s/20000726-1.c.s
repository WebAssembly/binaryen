	.text
	.file	"20000726-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
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
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.store16	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	adjust_xy, .Lfunc_end1-adjust_xy
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
