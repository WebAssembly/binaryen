	.text
	.file	"pr36691.c"
	.section	.text.func_1,"ax",@progbits
	.hidden	func_1                  # -- Begin function func_1
	.globl	func_1
	.type	func_1,@function
func_1:                                 # @func_1
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push1=, 0
	i32.store8	g_5($pop0), $pop1
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	func_1, .Lfunc_end0-func_1
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	i32.const	$push2=, 0
	i32.store8	g_5($pop0), $pop2
	i32.const	$push1=, 0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	g_5                     # @g_5
	.type	g_5,@object
	.section	.bss.g_5,"aw",@nobits
	.globl	g_5
g_5:
	.int8	0                       # 0x0
	.size	g_5, 1


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
