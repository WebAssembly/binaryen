	.text
	.file	"20030120-1.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1                   # -- Begin function test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.select	$push1=, $0, $pop0, $0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1
                                        # -- End function
	.section	.text.test2,"ax",@progbits
	.hidden	test2                   # -- Begin function test2
	.globl	test2
	.type	test2,@function
test2:                                  # @test2
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.select	$push1=, $0, $pop0, $0
                                        # fallthrough-return: $pop1
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
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.ne  	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end2:
	.size	test3, .Lfunc_end2-test3
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end11
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
