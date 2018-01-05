	.text
	.file	"950322-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.load8_u	$push1=, 0($0)
	i32.load8_u	$push0=, 1($0)
	i32.sub 	$0=, $pop1, $pop0
	i32.const	$push2=, 31
	i32.shr_s	$1=, $0, $pop2
	i32.add 	$push3=, $0, $1
	i32.xor 	$push4=, $pop3, $1
	i32.const	$push7=, 31
	i32.shr_u	$push5=, $0, $pop7
	i32.add 	$push6=, $pop4, $pop5
                                        # fallthrough-return: $pop6
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
