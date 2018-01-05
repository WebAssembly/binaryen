	.text
	.file	"990531-1.c"
	.section	.text.bad,"ax",@progbits
	.hidden	bad                     # -- Begin function bad
	.globl	bad
	.type	bad,@function
bad:                                    # @bad
	.param  	i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push4=, 0
	i32.load	$push3=, __stack_pointer($pop4)
	i32.const	$push5=, 16
	i32.sub 	$2=, $pop3, $pop5
	i32.store	8($2), $1
	i32.const	$push6=, 8
	i32.add 	$push7=, $2, $pop6
	i32.add 	$push0=, $pop7, $0
	i32.const	$push1=, 0
	i32.store8	0($pop0), $pop1
	i32.load	$push2=, 8($2)
                                        # fallthrough-return: $pop2
	.endfunc
.Lfunc_end0:
	.size	bad, .Lfunc_end0-bad
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
