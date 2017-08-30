	.text
	.file	"pr49123.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push5=, 0
	i32.load8_u	$push1=, s.0($pop5)
	i32.const	$push2=, 1
	i32.or  	$push3=, $pop1, $pop2
	i32.store8	s.0($pop0), $pop3
	i32.const	$push4=, 0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	s.0,@object             # @s.0
	.section	.bss.s.0,"aw",@nobits
	.p2align	2
s.0:
	.int8	0                       # 0x0
	.size	s.0, 1


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
