	.text
	.file	"20040319-1.c"
	.section	.text.blah,"ax",@progbits
	.hidden	blah                    # -- Begin function blah
	.globl	blah
	.type	blah,@function
blah:                                   # @blah
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 1
	i32.const	$push2=, 0
	i32.sub 	$push3=, $pop2, $0
	i32.const	$push0=, -1
	i32.gt_s	$push1=, $0, $pop0
	i32.select	$push5=, $pop4, $pop3, $pop1
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end0:
	.size	blah, .Lfunc_end0-blah
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.else
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
