	.text
	.file	"20050316-1.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1                   # -- Begin function test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
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
	copy_local	$push0=, $0
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
	.param  	i32
# %bb.0:                                # %entry
	i64.const	$push0=, 0
	i64.store	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	test3, .Lfunc_end2-test3
                                        # -- End function
	.section	.text.test4,"ax",@progbits
	.hidden	test4                   # -- Begin function test4
	.globl	test4
	.type	test4,@function
test4:                                  # @test4
	.param  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push2=, 65535
	i32.and 	$push3=, $1, $pop2
	i32.const	$push0=, 16
	i32.shl 	$push1=, $2, $pop0
	i32.or  	$push4=, $pop3, $pop1
	i64.extend_s/i32	$push5=, $pop4
	i64.store	0($0), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	test4, .Lfunc_end3-test4
                                        # -- End function
	.section	.text.test5,"ax",@progbits
	.hidden	test5                   # -- Begin function test5
	.globl	test5
	.type	test5,@function
test5:                                  # @test5
	.param  	i32, i32, i32
# %bb.0:                                # %entry
	i32.store	4($0), $2
	i32.store	0($0), $1
                                        # fallthrough-return
	.endfunc
.Lfunc_end4:
	.size	test5, .Lfunc_end4-test5
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end30
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end5:
	.size	main, .Lfunc_end5-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
