	.text
	.file	"20000715-1.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1                   # -- Begin function test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1
                                        # -- End function
	.section	.text.test2,"ax",@progbits
	.hidden	test2                   # -- Begin function test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	test2, .Lfunc_end1-test2
                                        # -- End function
	.section	.text.test3,"ax",@progbits
	.hidden	test3                   # -- Begin function test3
	.globl	test3
	.type	test3,@function
test3:                                  # @test3
# %bb.0:                                # %entry
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
# %bb.0:                                # %if.end8
	i32.const	$push1=, 0
	i32.const	$push0=, 3
	i32.store	y($pop1), $pop0
	i32.const	$push3=, 0
	i32.const	$push2=, 3
	i32.store	x($pop3), $pop2
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
# %bb.0:                                # %if.end8
	i32.const	$push1=, 0
	i32.const	$push0=, 3
	i32.store	y($pop1), $pop0
	i32.const	$push3=, 0
	i32.const	$push2=, 3
	i32.store	x($pop3), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end4:
	.size	test5, .Lfunc_end4-test5
                                        # -- End function
	.section	.text.test6,"ax",@progbits
	.hidden	test6                   # -- Begin function test6
	.globl	test6
	.type	test6,@function
test6:                                  # @test6
# %bb.0:                                # %if.end8
	i32.const	$push1=, 0
	i32.const	$push0=, 3
	i32.store	y($pop1), $pop0
	i32.const	$push3=, 0
	i32.const	$push2=, 3
	i32.store	x($pop3), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end5:
	.size	test6, .Lfunc_end5-test6
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 3
	i32.store	y($pop1), $pop0
	i32.const	$push4=, 0
	i32.const	$push3=, 3
	i32.store	x($pop4), $pop3
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end6:
	.size	main, .Lfunc_end6-main
                                        # -- End function
	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	2
x:
	.int32	0                       # 0x0
	.size	x, 4

	.hidden	y                       # @y
	.type	y,@object
	.section	.bss.y,"aw",@nobits
	.globl	y
	.p2align	2
y:
	.int32	0                       # 0x0
	.size	y, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
