	.text
	.file	"20040411-1.c"
	.section	.text.sub1,"ax",@progbits
	.hidden	sub1                    # -- Begin function sub1
	.globl	sub1
	.type	sub1,@function
sub1:                                   # @sub1
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.add 	$push9=, $0, $pop0
	tee_local	$push8=, $0=, $pop9
	i32.const	$push7=, 2
	i32.shl 	$push4=, $pop8, $pop7
	i32.const	$push2=, 12
	i32.mul 	$push3=, $0, $pop2
	i32.const	$push6=, 2
	i32.eq  	$push1=, $1, $pop6
	i32.select	$push5=, $pop4, $pop3, $pop1
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end0:
	.size	sub1, .Lfunc_end0-sub1
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
