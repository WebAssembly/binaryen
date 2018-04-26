	.text
	.file	"20000419-1.c"
	.section	.text.brother,"ax",@progbits
	.hidden	brother                 # -- Begin function brother
	.globl	brother
	.type	brother,@function
brother:                                # @brother
	.param  	i32, i32, i32
# %bb.0:                                # %entry
	block   	
	br_if   	0, $0           # 0: down to label0
# %bb.1:                                # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	brother, .Lfunc_end0-brother
                                        # -- End function
	.section	.text.sister,"ax",@progbits
	.hidden	sister                  # -- Begin function sister
	.globl	sister
	.type	sister,@function
sister:                                 # @sister
	.param  	i32, i32, i32
# %bb.0:                                # %entry
	block   	
	i32.load	$push0=, 4($0)
	i32.eq  	$push1=, $pop0, $1
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %brother.exit
	return
.LBB1_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	sister, .Lfunc_end1-sister
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %sister.exit
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
