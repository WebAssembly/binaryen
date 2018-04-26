	.text
	.file	"20031012-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push5=, 0
	i32.load	$push4=, __stack_pointer($pop5)
	i32.const	$push6=, 15008
	i32.sub 	$2=, $pop4, $pop6
	i32.const	$push7=, 0
	i32.store	__stack_pointer($pop7), $2
	i32.const	$push1=, 205
	i32.const	$push0=, 13371
	i32.call	$drop=, memset@FUNCTION, $2, $pop1, $pop0
	i32.const	$push12=, 0
	i32.store8	13371($2), $pop12
	block   	
	i32.call	$push2=, strlen@FUNCTION, $2
	i32.const	$push11=, 13371
	i32.ne  	$push3=, $pop2, $pop11
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %foo.exit
	i32.const	$push10=, 0
	i32.const	$push8=, 15008
	i32.add 	$push9=, $2, $pop8
	i32.store	__stack_pointer($pop10), $pop9
	i32.const	$push13=, 0
	return  	$pop13
.LBB0_2:                                # %if.then.i
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	strlen, i32, i32
	.functype	abort, void
