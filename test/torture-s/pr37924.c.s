	.text
	.file	"pr37924.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1                   # -- Begin function test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load8_s	$push1=, a($pop0)
	i32.const	$push2=, -1
	i32.xor 	$push3=, $pop1, $pop2
	i32.const	$push4=, 9
	i32.shr_u	$push5=, $pop3, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1
                                        # -- End function
	.section	.text.test2,"ax",@progbits
	.hidden	test2                   # -- Begin function test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 8388607
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	test2, .Lfunc_end1-test2
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end21
	i32.const	$push1=, 0
	i32.const	$push0=, 255
	i32.store8	b($pop1), $pop0
	i32.const	$push4=, 0
	i32.const	$push3=, 255
	i32.store8	a($pop4), $pop3
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
a:
	.int8	0                       # 0x0
	.size	a, 1

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
b:
	.int8	0                       # 0x0
	.size	b, 1


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
