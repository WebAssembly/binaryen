	.text
	.file	"20030913-1.c"
	.section	.text.fn2,"ax",@progbits
	.hidden	fn2                     # -- Begin function fn2
	.globl	fn2
	.type	fn2,@function
fn2:                                    # @fn2
	.param  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, glob
	i32.store	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	fn2, .Lfunc_end0-fn2
                                        # -- End function
	.section	.text.test,"ax",@progbits
	.hidden	test                    # -- Begin function test
	.globl	test
	.type	test,@function
test:                                   # @test
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 42
	i32.store	glob($pop1), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	test, .Lfunc_end1-test
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, 42
	i32.store	glob($pop1), $pop0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	glob                    # @glob
	.type	glob,@object
	.section	.bss.glob,"aw",@nobits
	.globl	glob
	.p2align	2
glob:
	.int32	0                       # 0x0
	.size	glob, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
