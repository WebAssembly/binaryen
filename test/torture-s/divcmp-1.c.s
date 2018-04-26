	.text
	.file	"divcmp-1.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1                   # -- Begin function test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, -20
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 10
	i32.lt_u	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
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
	i32.const	$push0=, -20
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 10
	i32.lt_u	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
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
	i32.const	$push0=, 9
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 19
	i32.lt_u	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
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
	i32.const	$push0=, 10
	i32.lt_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
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
	i32.const	$push0=, -20
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 9
	i32.gt_u	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
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
	i32.const	$push0=, -20
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 9
	i32.gt_u	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
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
	i32.const	$push0=, 9
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 18
	i32.gt_u	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
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
	i32.const	$push0=, 9
	i32.gt_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
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
	i32.const	$push0=, 20
	i32.lt_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
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
	i32.const	$push0=, 20
	i32.lt_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
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
	i32.const	$push0=, -9
	i32.lt_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end10:
	.size	test6, .Lfunc_end10-test6
                                        # -- End function
	.section	.text.test7,"ax",@progbits
	.hidden	test7                   # -- Begin function test7
	.globl	test7
	.type	test7,@function
test7:                                  # @test7
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 30
	i32.lt_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end11:
	.size	test7, .Lfunc_end11-test7
                                        # -- End function
	.section	.text.test7u,"ax",@progbits
	.hidden	test7u                  # -- Begin function test7u
	.globl	test7u
	.type	test7u,@function
test7u:                                 # @test7u
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 30
	i32.lt_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end12:
	.size	test7u, .Lfunc_end12-test7u
                                        # -- End function
	.section	.text.test8,"ax",@progbits
	.hidden	test8                   # -- Begin function test8
	.globl	test8
	.type	test8,@function
test8:                                  # @test8
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 10
	i32.lt_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end13:
	.size	test8, .Lfunc_end13-test8
                                        # -- End function
	.section	.text.test8u,"ax",@progbits
	.hidden	test8u                  # -- Begin function test8u
	.globl	test8u
	.type	test8u,@function
test8u:                                 # @test8u
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 10
	i32.lt_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end14:
	.size	test8u, .Lfunc_end14-test8u
                                        # -- End function
	.section	.text.test9,"ax",@progbits
	.hidden	test9                   # -- Begin function test9
	.globl	test9
	.type	test9,@function
test9:                                  # @test9
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 29
	i32.gt_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end15:
	.size	test9, .Lfunc_end15-test9
                                        # -- End function
	.section	.text.test9u,"ax",@progbits
	.hidden	test9u                  # -- Begin function test9u
	.globl	test9u
	.type	test9u,@function
test9u:                                 # @test9u
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 29
	i32.gt_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end16:
	.size	test9u, .Lfunc_end16-test9u
                                        # -- End function
	.section	.text.test10,"ax",@progbits
	.hidden	test10                  # -- Begin function test10
	.globl	test10
	.type	test10,@function
test10:                                 # @test10
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 9
	i32.gt_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end17:
	.size	test10, .Lfunc_end17-test10
                                        # -- End function
	.section	.text.test10u,"ax",@progbits
	.hidden	test10u                 # -- Begin function test10u
	.globl	test10u
	.type	test10u,@function
test10u:                                # @test10u
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 9
	i32.gt_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end18:
	.size	test10u, .Lfunc_end18-test10u
                                        # -- End function
	.section	.text.test11,"ax",@progbits
	.hidden	test11                  # -- Begin function test11
	.globl	test11
	.type	test11,@function
test11:                                 # @test11
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 19
	i32.gt_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end19:
	.size	test11, .Lfunc_end19-test11
                                        # -- End function
	.section	.text.test11u,"ax",@progbits
	.hidden	test11u                 # -- Begin function test11u
	.globl	test11u
	.type	test11u,@function
test11u:                                # @test11u
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 19
	i32.gt_u	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end20:
	.size	test11u, .Lfunc_end20-test11u
                                        # -- End function
	.section	.text.test12,"ax",@progbits
	.hidden	test12                  # -- Begin function test12
	.globl	test12
	.type	test12,@function
test12:                                 # @test12
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, -10
	i32.gt_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end21:
	.size	test12, .Lfunc_end21-test12
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end428
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end22:
	.size	main, .Lfunc_end22-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
