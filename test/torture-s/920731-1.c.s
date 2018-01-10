	.text
	.file	"920731-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$2=, 0
	block   	
	i32.const	$push2=, 1
	i32.and 	$push0=, $0, $pop2
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %for.inc.preheader
	i32.const	$2=, 0
.LBB0_2:                                # %for.inc
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push4=, 1
	i32.add 	$2=, $2, $pop4
	i32.const	$push3=, 7
	i32.gt_u	$push1=, $2, $pop3
	br_if   	1, $pop1        # 1: down to label0
# %bb.3:                                # %for.inc
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push6=, 2
	i32.and 	$1=, $0, $pop6
	i32.const	$push5=, 1
	i32.shr_s	$0=, $0, $pop5
	i32.eqz 	$push7=, $1
	br_if   	0, $pop7        # 0: up to label1
.LBB0_4:                                # %for.end
	end_loop
	end_block                       # label0:
	copy_local	$push8=, $2
                                        # fallthrough-return: $pop8
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
