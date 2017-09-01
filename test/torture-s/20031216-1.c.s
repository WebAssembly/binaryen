	.text
	.file	"20031216-1.c"
	.section	.text.DisplayNumber,"ax",@progbits
	.hidden	DisplayNumber           # -- Begin function DisplayNumber
	.globl	DisplayNumber
	.type	DisplayNumber,@function
DisplayNumber:                          # @DisplayNumber
	.param  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push0=, 154
	i32.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
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
# BB#0:                                 # %entry
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
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
