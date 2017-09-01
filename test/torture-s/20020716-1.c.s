	.text
	.file	"20020716-1.c"
	.section	.text.sub1,"ax",@progbits
	.hidden	sub1                    # -- Begin function sub1
	.globl	sub1
	.type	sub1,@function
sub1:                                   # @sub1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	copy_local	$push0=, $0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	sub1, .Lfunc_end0-sub1
                                        # -- End function
	.section	.text.testcond,"ax",@progbits
	.hidden	testcond                # -- Begin function testcond
	.globl	testcond
	.type	testcond,@function
testcond:                               # @testcond
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 5046272
	i32.select	$push2=, $pop1, $pop0, $0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end1:
	.size	testcond, .Lfunc_end1-testcond
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
