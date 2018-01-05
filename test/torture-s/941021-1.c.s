	.text
	.file	"941021-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, f64
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, glob_dbl
	i32.select	$push1=, $0, $pop0, $0
	f64.store	0($pop1), $1
	copy_local	$push2=, $0
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push1=, 0
	i64.const	$push0=, 4632951452917877965
	i64.store	glob_dbl($pop1), $pop0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	glob_dbl                # @glob_dbl
	.type	glob_dbl,@object
	.section	.bss.glob_dbl,"aw",@nobits
	.globl	glob_dbl
	.p2align	3
glob_dbl:
	.int64	0                       # double 0
	.size	glob_dbl, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
