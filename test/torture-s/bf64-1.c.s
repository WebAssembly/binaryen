	.text
	.file	"bf64-1.c"
	.section	.text.sub,"ax",@progbits
	.hidden	sub                     # -- Begin function sub
	.globl	sub
	.type	sub,@function
sub:                                    # @sub
	.param  	i32, i32
# %bb.0:                                # %entry
	i64.load	$push0=, 0($1)
	i64.const	$push1=, -8690468286197432320
	i64.or  	$push2=, $pop0, $pop1
	i64.store	0($0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	sub, .Lfunc_end0-sub
                                        # -- End function
	.section	.text.sub2,"ax",@progbits
	.hidden	sub2                    # -- Begin function sub2
	.globl	sub2
	.type	sub2,@function
sub2:                                   # @sub2
	.param  	i32, i32
# %bb.0:                                # %entry
	i64.load	$push0=, 0($1)
	i64.const	$push1=, 2381903268435576
	i64.or  	$push2=, $pop0, $pop1
	i64.store	0($0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	sub2, .Lfunc_end1-sub2
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end21
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
