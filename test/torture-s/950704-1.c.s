	.text
	.file	"950704-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i64, i64
	.result 	i64
	.local  	i64
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.const	$push11=, 0
	i32.store	errflag($pop0), $pop11
	i64.add 	$2=, $1, $0
	block   	
	block   	
	block   	
	i64.const	$push10=, 0
	i64.lt_s	$push1=, $0, $pop10
	br_if   	0, $pop1        # 0: down to label2
# %bb.1:                                # %if.then
	i64.const	$push12=, 0
	i64.lt_s	$push5=, $1, $pop12
	br_if   	2, $pop5        # 2: down to label0
# %bb.2:                                # %if.then
	i64.const	$push6=, -1
	i64.le_s	$push7=, $2, $pop6
	br_if   	1, $pop7        # 1: down to label1
	br      	2               # 2: down to label0
.LBB0_3:                                # %if.else
	end_block                       # label2:
	i64.const	$push13=, 0
	i64.gt_s	$push2=, $1, $pop13
	br_if   	1, $pop2        # 1: down to label0
# %bb.4:                                # %if.else
	i64.const	$push3=, 0
	i64.lt_s	$push4=, $2, $pop3
	br_if   	1, $pop4        # 1: down to label0
.LBB0_5:                                # %if.end9
	end_block                       # label1:
	i32.const	$push9=, 0
	i32.const	$push8=, 1
	i32.store	errflag($pop9), $pop8
	i64.const	$2=, 0
.LBB0_6:                                # %cleanup
	end_block                       # label0:
	copy_local	$push14=, $2
                                        # fallthrough-return: $pop14
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
# %bb.0:                                # %if.end28
	i32.const	$push0=, 0
	i32.const	$push2=, 0
	i32.store	errflag($pop0), $pop2
	i32.const	$push1=, 0
	call    	exit@FUNCTION, $pop1
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	errflag                 # @errflag
	.type	errflag,@object
	.section	.bss.errflag,"aw",@nobits
	.globl	errflag
	.p2align	2
errflag:
	.int32	0                       # 0x0
	.size	errflag, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
