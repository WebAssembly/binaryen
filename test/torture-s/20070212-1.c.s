	.text
	.file	"20070212-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g                       # -- Begin function g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push3=, 0
	i32.load	$4=, __stack_pointer($pop3)
	i32.const	$push0=, 0
	i32.store	0($3), $pop0
	i32.const	$push4=, 16
	i32.sub 	$push8=, $4, $pop4
	tee_local	$push7=, $3=, $pop8
	i32.store	12($pop7), $0
	i32.const	$push5=, 12
	i32.add 	$push6=, $3, $pop5
	i32.select	$push1=, $pop6, $2, $1
	i32.load	$push2=, 0($pop1)
                                        # fallthrough-return: $pop2
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
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
