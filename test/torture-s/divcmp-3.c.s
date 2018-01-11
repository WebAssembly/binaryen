	.text
	.file	"divcmp-3.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1                   # -- Begin function test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1
                                        # -- End function
	.section	.text.test1u,"ax",@progbits
	.hidden	test1u                  # -- Begin function test1u
	.globl	test1u
	.type	test1u,@function
test1u:                                 # @test1u
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	test1u, .Lfunc_end1-test1u
                                        # -- End function
	.section	.text.test2,"ax",@progbits
	.hidden	test2                   # -- Begin function test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	test2, .Lfunc_end2-test2
                                        # -- End function
	.section	.text.test2u,"ax",@progbits
	.hidden	test2u                  # -- Begin function test2u
	.globl	test2u
	.type	test2u,@function
test2u:                                 # @test2u
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end3:
	.size	test2u, .Lfunc_end3-test2u
                                        # -- End function
	.section	.text.test3,"ax",@progbits
	.hidden	test3                   # -- Begin function test3
	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end4:
	.size	test3, .Lfunc_end4-test3
                                        # -- End function
	.section	.text.test3u,"ax",@progbits
	.hidden	test3u                  # -- Begin function test3u
	.globl	test3u
	.type	test3u,@function
test3u:                                 # @test3u
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end5:
	.size	test3u, .Lfunc_end5-test3u
                                        # -- End function
	.section	.text.test4,"ax",@progbits
	.hidden	test4                   # -- Begin function test4
	.globl	test4
	.type	test4,@function
test4:                                  # @test4
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end6:
	.size	test4, .Lfunc_end6-test4
                                        # -- End function
	.section	.text.test4u,"ax",@progbits
	.hidden	test4u                  # -- Begin function test4u
	.globl	test4u
	.type	test4u,@function
test4u:                                 # @test4u
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end7:
	.size	test4u, .Lfunc_end7-test4u
                                        # -- End function
	.section	.text.test5,"ax",@progbits
	.hidden	test5                   # -- Begin function test5
	.globl	test5
	.type	test5,@function
test5:                                  # @test5
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end8:
	.size	test5, .Lfunc_end8-test5
                                        # -- End function
	.section	.text.test5u,"ax",@progbits
	.hidden	test5u                  # -- Begin function test5u
	.globl	test5u
	.type	test5u,@function
test5u:                                 # @test5u
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end9:
	.size	test5u, .Lfunc_end9-test5u
                                        # -- End function
	.section	.text.test6,"ax",@progbits
	.hidden	test6                   # -- Begin function test6
	.globl	test6
	.type	test6,@function
test6:                                  # @test6
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end10:
	.size	test6, .Lfunc_end10-test6
                                        # -- End function
	.section	.text.test6u,"ax",@progbits
	.hidden	test6u                  # -- Begin function test6u
	.globl	test6u
	.type	test6u,@function
test6u:                                 # @test6u
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end11:
	.size	test6u, .Lfunc_end11-test6u
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end12:
	.size	main, .Lfunc_end12-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
