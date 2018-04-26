	.text
	.file	"pr40493.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 22
	i32.store	x01($pop1), $pop0
	i32.const	$push8=, 0
	i32.const	$push2=, 2
	i32.store	x00($pop8), $pop2
	i32.const	$push7=, 0
	i32.const	$push6=, 2
	i32.store	y00($pop7), $pop6
	i32.const	$push5=, 0
	i32.const	$push4=, 22
	i32.store	y01($pop5), $pop4
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	x00                     # @x00
	.type	x00,@object
	.section	.bss.x00,"aw",@nobits
	.globl	x00
	.p2align	2
x00:
	.int32	0                       # 0x0
	.size	x00, 4

	.hidden	x01                     # @x01
	.type	x01,@object
	.section	.bss.x01,"aw",@nobits
	.globl	x01
	.p2align	2
x01:
	.int32	0                       # 0x0
	.size	x01, 4

	.hidden	y00                     # @y00
	.type	y00,@object
	.section	.bss.y00,"aw",@nobits
	.globl	y00
	.p2align	2
y00:
	.int32	0                       # 0x0
	.size	y00, 4

	.hidden	y01                     # @y01
	.type	y01,@object
	.section	.bss.y01,"aw",@nobits
	.globl	y01
	.p2align	2
y01:
	.int32	0                       # 0x0
	.size	y01, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
