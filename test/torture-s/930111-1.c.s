	.text
	.file	"930111-1.c"
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
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.wwrite,"ax",@progbits
	.hidden	wwrite                  # -- Begin function wwrite
	.globl	wwrite
	.type	wwrite,@function
wwrite:                                 # @wwrite
	.param  	i64
	.result 	i32
# %bb.0:                                # %entry
	i64.const	$push1=, -3
	i64.add 	$0=, $0, $pop1
	block   	
	i64.const	$push2=, 44
	i64.gt_u	$push3=, $0, $pop2
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %entry
	block   	
	i32.wrap/i64	$push0=, $0
	br_table 	$pop0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 # 0: down to label1
                                        # 1: down to label0
.LBB1_2:                                # %return
	end_block                       # label1:
	i32.const	$push5=, 0
	return  	$pop5
.LBB1_3:                                # %sw.default
	end_block                       # label0:
	i32.const	$push4=, 123
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end1:
	.size	wwrite, .Lfunc_end1-wwrite
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
