	.text
	.file	"pr34099-2.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1                   # -- Begin function test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.eqz 	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1
                                        # -- End function
	.section	.text.test2,"ax",@progbits
	.hidden	test2                   # -- Begin function test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.eqz 	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	test2, .Lfunc_end1-test2
                                        # -- End function
	.section	.text.test3,"ax",@progbits
	.hidden	test3                   # -- Begin function test3
	.globl	test3
	.type	test3,@function
test3:                                  # @test3
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.eqz 	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end2:
	.size	test3, .Lfunc_end2-test3
                                        # -- End function
	.section	.text.test4,"ax",@progbits
	.hidden	test4                   # -- Begin function test4
	.globl	test4
	.type	test4,@function
test4:                                  # @test4
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.eqz 	$push1=, $0
	i32.eqz 	$push0=, $1
	i32.or  	$push2=, $pop1, $pop0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end3:
	.size	test4, .Lfunc_end3-test4
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end12
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
