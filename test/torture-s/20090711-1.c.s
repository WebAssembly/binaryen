	.text
	.file	"20090711-1.c"
	.section	.text.div,"ax",@progbits
	.hidden	div                     # -- Begin function div
	.globl	div
	.type	div,@function
div:                                    # @div
	.param  	i64
	.result 	i64
# %bb.0:                                # %entry
	i64.const	$push0=, 32768
	i64.div_s	$push1=, $0, $pop0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end0:
	.size	div, .Lfunc_end0-div
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i64.const	$push0=, -990000000
	i64.call	$push1=, div@FUNCTION, $pop0
	i64.const	$push2=, -30212
	i64.ne  	$push3=, $pop1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
