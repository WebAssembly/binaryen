	.text
	.file	"921204-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load	$1=, 0($1)
	i32.const	$push4=, 1310720
	i32.or  	$push5=, $1, $pop4
	i32.const	$push2=, -1310721
	i32.and 	$push3=, $1, $pop2
	i32.const	$push0=, 1
	i32.and 	$push1=, $1, $pop0
	i32.select	$push6=, $pop5, $pop3, $pop1
	i32.store	0($0), $pop6
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
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
