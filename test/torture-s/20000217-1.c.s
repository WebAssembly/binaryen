	.text
	.file	"20000217-1.c"
	.section	.text.showbug,"ax",@progbits
	.hidden	showbug                 # -- Begin function showbug
	.globl	showbug
	.type	showbug,@function
showbug:                                # @showbug
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	i32.load16_u	$push1=, 0($1)
	i32.load16_u	$push0=, 0($0)
	i32.add 	$push2=, $pop1, $pop0
	i32.const	$push3=, 65528
	i32.add 	$1=, $pop2, $pop3
	i32.store16	0($0), $1
	i32.const	$push7=, 65528
	i32.and 	$push4=, $1, $pop7
	i32.const	$push5=, 0
	i32.ne  	$push6=, $pop4, $pop5
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end0:
	.size	showbug, .Lfunc_end0-showbug
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
