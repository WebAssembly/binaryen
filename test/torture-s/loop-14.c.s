	.text
	.file	"loop-14.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
# %bb.0:                                # %entry
	i64.const	$push0=, 90194313258
	i64.store	4($0):p2align=2, $pop0
                                        # fallthrough-return
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
	i64.const	$push0=, 90194313258
	i64.store	a3+4($pop1):p2align=2, $pop0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	a3                      # @a3
	.type	a3,@object
	.section	.bss.a3,"aw",@nobits
	.globl	a3
	.p2align	2
a3:
	.skip	12
	.size	a3, 12


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
