	.text
	.file	"20000503-1.c"
	.section	.text.sub,"ax",@progbits
	.hidden	sub                     # -- Begin function sub
	.globl	sub
	.type	sub,@function
sub:                                    # @sub
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -2
	i32.add 	$push8=, $0, $pop0
	tee_local	$push7=, $0=, $pop8
	i32.const	$push1=, 0
	i32.const	$push6=, 0
	i32.gt_s	$push2=, $0, $pop6
	i32.select	$push3=, $pop7, $pop1, $pop2
	i32.const	$push4=, 2
	i32.shl 	$push5=, $pop3, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end0:
	.size	sub, .Lfunc_end0-sub
                                        # -- End function
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
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
