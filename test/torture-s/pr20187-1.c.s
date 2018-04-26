	.text
	.file	"pr20187-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test                    # -- Begin function test
	.globl	test
	.type	test,@function
test:                                   # @test
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$0=, a($pop0)
	i32.const	$push9=, 0
	i32.load	$push3=, b($pop9)
	i32.mul 	$push4=, $pop3, $0
	i32.const	$push1=, 1
	i32.select	$push2=, $0, $pop1, $0
	i32.and 	$push5=, $pop4, $pop2
	i32.const	$push6=, 255
	i32.and 	$push7=, $pop5, $pop6
	i32.eqz 	$push8=, $pop7
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$0=, a($pop0)
	i32.const	$push10=, 0
	i32.load	$push3=, b($pop10)
	i32.mul 	$push4=, $pop3, $0
	i32.const	$push1=, 1
	i32.select	$push2=, $0, $pop1, $0
	i32.and 	$push5=, $pop4, $pop2
	i32.const	$push6=, 255
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push9=, 0
	i32.ne  	$push8=, $pop7, $pop9
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	2
a:
	.int32	257                     # 0x101
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.p2align	2
b:
	.int32	256                     # 0x100
	.size	b, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
