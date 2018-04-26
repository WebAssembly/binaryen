	.text
	.file	"pr49123.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
