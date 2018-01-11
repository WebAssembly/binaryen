	.text
	.file	"990117-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.result 	i32
# %bb.0:                                # %entry
	f64.convert_s/i32	$push4=, $0
	f64.convert_s/i32	$push3=, $1
	f64.div 	$push5=, $pop4, $pop3
	f64.convert_s/i32	$push1=, $2
	f64.convert_s/i32	$push0=, $3
	f64.div 	$push2=, $pop1, $pop0
	f64.lt  	$push6=, $pop5, $pop2
                                        # fallthrough-return: $pop6
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
