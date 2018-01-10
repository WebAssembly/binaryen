	.text
	.file	"20030120-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push5=, 4
	i32.const	$push0=, 3
	i32.const	$push2=, 1
	i32.eq  	$push3=, $0, $pop2
	i32.const	$push9=, 3
	i32.eq  	$push1=, $0, $pop9
	i32.select	$push4=, $pop0, $pop3, $pop1
	i32.const	$push8=, 4
	i32.eq  	$push6=, $0, $pop8
	i32.select	$push7=, $pop5, $pop4, $pop6
                                        # fallthrough-return: $pop7
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
