	.text
	.file	"simd-6.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push1=, 7
	i32.add 	$push2=, $0, $pop1
	i32.mul 	$push0=, $16, $8
	i32.store8	0($pop2), $pop0
	i32.const	$push4=, 6
	i32.add 	$push5=, $0, $pop4
	i32.mul 	$push3=, $15, $7
	i32.store8	0($pop5), $pop3
	i32.const	$push7=, 5
	i32.add 	$push8=, $0, $pop7
	i32.mul 	$push6=, $14, $6
	i32.store8	0($pop8), $pop6
	i32.mul 	$push9=, $13, $5
	i32.store8	4($0), $pop9
	i32.const	$push11=, 3
	i32.add 	$push12=, $0, $pop11
	i32.mul 	$push10=, $12, $4
	i32.store8	0($pop12), $pop10
	i32.mul 	$push13=, $11, $3
	i32.store8	2($0), $pop13
	i32.mul 	$push14=, $10, $2
	i32.store8	1($0), $pop14
	i32.mul 	$push15=, $9, $1
	i32.store8	0($0), $pop15
                                        # fallthrough-return
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
