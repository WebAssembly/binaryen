	.text
	.file	"20000412-4.c"
	.section	.text.f,"ax",@progbits
	.hidden	f                       # -- Begin function f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32, i32, i32, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.sub 	$5=, $0, $2
	i32.const	$push0=, 0
	i32.const	$push11=, 0
	i32.gt_s	$push1=, $5, $pop11
	i32.select	$5=, $5, $pop0, $pop1
	block   	
	block   	
	i32.const	$push10=, 2
	i32.gt_u	$push2=, $5, $pop10
	br_if   	0, $pop2        # 0: down to label1
# %bb.1:                                # %for.body.lr.ph
	i32.add 	$push3=, $2, $5
	i32.const	$push12=, -1
	i32.add 	$push4=, $pop3, $pop12
	i32.sub 	$push5=, $pop4, $0
	i32.mul 	$push6=, $3, $pop5
	i32.add 	$push7=, $2, $pop6
	i32.sub 	$2=, $pop7, $1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.add 	$2=, $2, $3
	i32.const	$push13=, -1
	i32.le_s	$push8=, $2, $pop13
	br_if   	2, $pop8        # 2: down to label0
# %bb.3:                                # %for.cond
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push15=, 1
	i32.add 	$5=, $5, $pop15
	i32.const	$push14=, 2
	i32.le_u	$push9=, $5, $pop14
	br_if   	0, $pop9        # 0: up to label2
.LBB0_4:                                # %for.end
	end_loop
	end_block                       # label1:
	return
.LBB0_5:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %for.body.lr.ph.i
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
