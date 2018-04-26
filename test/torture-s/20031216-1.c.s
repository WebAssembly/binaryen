	.text
	.file	"20031216-1.c"
	.section	.text.DisplayNumber,"ax",@progbits
	.hidden	DisplayNumber           # -- Begin function DisplayNumber
	.globl	DisplayNumber
	.type	DisplayNumber,@function
DisplayNumber:                          # @DisplayNumber
	.param  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push0=, 154
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	DisplayNumber, .Lfunc_end0-DisplayNumber
                                        # -- End function
	.section	.text.ReadNumber,"ax",@progbits
	.hidden	ReadNumber              # -- Begin function ReadNumber
	.globl	ReadNumber
	.type	ReadNumber,@function
ReadNumber:                             # @ReadNumber
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 10092544
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	ReadNumber, .Lfunc_end1-ReadNumber
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
