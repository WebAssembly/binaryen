	.text
	.file	"multdi-1.c"
	.section	.text.mpy,"ax",@progbits
	.hidden	mpy                     # -- Begin function mpy
	.globl	mpy
	.type	mpy,@function
mpy:                                    # @mpy
	.param  	i32, i32
	.result 	i64
# BB#0:                                 # %entry
	i64.extend_s/i32	$push1=, $1
	i64.extend_s/i32	$push0=, $0
	i64.mul 	$push2=, $pop1, $pop0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	mpy, .Lfunc_end0-mpy
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i64.const	$push0=, -1
	i64.store	mpy_res($pop1), $pop0
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	mpy_res                 # @mpy_res
	.type	mpy_res,@object
	.section	.bss.mpy_res,"aw",@nobits
	.globl	mpy_res
	.p2align	3
mpy_res:
	.int64	0                       # 0x0
	.size	mpy_res, 8


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
