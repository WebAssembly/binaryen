	.text
	.file	"pr34130.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push8=, 0
	i32.const	$push4=, -2
	i32.add 	$push5=, $0, $pop4
	i32.const	$push2=, 2
	i32.sub 	$push3=, $pop2, $0
	i32.const	$push0=, 1
	i32.gt_s	$push1=, $0, $pop0
	i32.select	$push6=, $pop5, $pop3, $pop1
	i32.const	$push10=, 1
	i32.shl 	$push7=, $pop6, $pop10
	i32.sub 	$push9=, $pop8, $pop7
                                        # fallthrough-return: $pop9
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
