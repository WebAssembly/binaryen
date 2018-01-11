	.text
	.file	"ipa-sra-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push1=, 1
	i32.const	$push0=, 40
	i32.call	$2=, calloc@FUNCTION, $pop1, $pop0
	i32.const	$push2=, 2000
	i32.gt_s	$push3=, $0, $pop2
	i32.call	$0=, foo@FUNCTION, $pop3, $2
	call    	free@FUNCTION, $2
	copy_local	$push4=, $0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.type	foo,@function           # -- Begin function foo
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 3999996
	i32.add 	$push1=, $1, $pop0
	i32.select	$push2=, $pop1, $1, $0
	i32.load	$push3=, 0($pop2)
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	calloc, i32, i32, i32
	.functype	free, void, i32
