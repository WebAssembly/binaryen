	.text
	.file	"20020716-1.c"
	.section	.text.sub1,"ax",@progbits
	.hidden	sub1                    # -- Begin function sub1
	.globl	sub1
	.type	sub1,@function
sub1:                                   # @sub1
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
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
# %bb.0:                                # %entry
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
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
