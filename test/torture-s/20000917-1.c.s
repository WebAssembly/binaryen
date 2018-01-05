	.text
	.file	"20000917-1.c"
	.section	.text.one,"ax",@progbits
	.hidden	one                     # -- Begin function one
	.globl	one
	.type	one,@function
one:                                    # @one
	.param  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 1
	i32.store	8($0), $pop0
	i64.const	$push1=, 4294967297
	i64.store	0($0):p2align=2, $pop1
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	one, .Lfunc_end0-one
                                        # -- End function
	.section	.text.zero,"ax",@progbits
	.hidden	zero                    # -- Begin function zero
	.globl	zero
	.type	zero,@function
zero:                                   # @zero
	.param  	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.store	8($0), $pop0
	i64.const	$push1=, 0
	i64.store	0($0):p2align=2, $pop1
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	zero, .Lfunc_end1-zero
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
