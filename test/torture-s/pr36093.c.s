	.text
	.file	"pr36093.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push2=, foo
	i32.const	$push1=, 97
	i32.const	$push0=, 129
	i32.call	$drop=, memset@FUNCTION, $pop2, $pop1, $pop0
	i32.const	$push4=, foo+129
	i32.const	$push3=, 98
	i32.const	$push12=, 129
	i32.call	$drop=, memset@FUNCTION, $pop4, $pop3, $pop12
	i32.const	$push6=, foo+258
	i32.const	$push5=, 99
	i32.const	$push11=, 129
	i32.call	$drop=, memset@FUNCTION, $pop6, $pop5, $pop11
	i32.const	$push8=, foo+387
	i32.const	$push7=, 100
	i32.const	$push10=, 129
	i32.call	$drop=, memset@FUNCTION, $pop8, $pop7, $pop10
	i32.const	$push9=, 0
                                        # fallthrough-return: $pop9
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	foo                     # @foo
	.type	foo,@object
	.section	.bss.foo,"aw",@nobits
	.globl	foo
	.p2align	7
foo:
	.skip	2560
	.size	foo, 2560


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
