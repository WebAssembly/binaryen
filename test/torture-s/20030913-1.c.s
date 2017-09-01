	.text
	.file	"20030913-1.c"
	.section	.text.fn2,"ax",@progbits
	.hidden	fn2                     # -- Begin function fn2
	.globl	fn2
	.type	fn2,@function
fn2:                                    # @fn2
	.param  	i32
# BB#0:                                 # %entry
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
# BB#0:                                 # %entry
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
# BB#0:                                 # %if.end
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
