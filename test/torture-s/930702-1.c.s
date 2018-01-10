	.text
	.file	"930702-1.c"
	.section	.text.fp,"ax",@progbits
	.hidden	fp                      # -- Begin function fp
	.globl	fp
	.type	fp,@function
fp:                                     # @fp
	.param  	f64, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	f64.const	$push0=, 0x1.08p5
	f64.ne  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:                                # %entry
	i32.const	$push2=, 11
	i32.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.2:                                # %if.end
	return  	$1
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	fp, .Lfunc_end0-fp
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
