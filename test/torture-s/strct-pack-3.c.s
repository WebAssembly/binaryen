	.text
	.file	"strct-pack-3.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push3=, 6
	i32.add 	$push4=, $0, $pop3
	i32.load	$1=, 0($pop4):p2align=1
	i32.const	$push1=, 16
	i32.shl 	$push8=, $1, $pop1
	i32.load	$push0=, 2($0):p2align=1
	i32.const	$push12=, 16
	i32.shl 	$push2=, $pop0, $pop12
	i32.const	$push5=, 17
	i32.shl 	$push6=, $1, $pop5
	i32.add 	$push7=, $pop2, $pop6
	i32.add 	$push9=, $pop8, $pop7
	i32.const	$push11=, 16
	i32.shr_s	$push10=, $pop9, $pop11
                                        # fallthrough-return: $pop10
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
