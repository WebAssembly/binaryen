	.text
	.file	"20000313-1.c"
	.section	.text.buggy,"ax",@progbits
	.hidden	buggy                   # -- Begin function buggy
	.globl	buggy
	.type	buggy,@function
buggy:                                  # @buggy
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$1=, 0($0)
	i32.const	$push0=, 0
	i32.store	0($0), $pop0
	i32.const	$push1=, -1
	i32.const	$push3=, 0
	i32.select	$push2=, $pop1, $pop3, $1
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	buggy, .Lfunc_end0-buggy
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end3
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
