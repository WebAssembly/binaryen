	.text
	.file	"loop-13.c"
	.section	.text.scale,"ax",@progbits
	.hidden	scale                   # -- Begin function scale
	.globl	scale
	.type	scale,@function
scale:                                  # @scale
	.param  	i32, i32, i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.load	$4=, 0($0)
	block   	
	i32.const	$push13=, 1
	i32.eq  	$push0=, $4, $pop13
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %entry
	i32.const	$push14=, 1
	i32.lt_s	$push1=, $2, $pop14
	br_if   	0, $pop1        # 0: down to label0
# %bb.2:                                # %for.body.lr.ph
	i32.load	$push2=, 0($1)
	i32.mul 	$push3=, $pop2, $4
	i32.store	0($1), $pop3
	i32.load	$push4=, 4($1)
	i32.mul 	$push5=, $pop4, $4
	i32.store	4($1), $pop5
	i32.const	$push6=, 1
	i32.eq  	$push7=, $2, $pop6
	br_if   	0, $pop7        # 0: down to label0
# %bb.3:                                # %for.body.for.body_crit_edge.preheader
	i32.const	$push8=, 12
	i32.add 	$1=, $1, $pop8
	i32.const	$push15=, -1
	i32.add 	$4=, $2, $pop15
.LBB0_4:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.load	$2=, 0($0)
	i32.load	$push9=, 0($1)
	i32.mul 	$push10=, $pop9, $2
	i32.store	0($1), $pop10
	i32.const	$push18=, -4
	i32.add 	$3=, $1, $pop18
	i32.load	$push11=, 0($3)
	i32.mul 	$push12=, $2, $pop11
	i32.store	0($3), $pop12
	i32.const	$push17=, 8
	i32.add 	$1=, $1, $pop17
	i32.const	$push16=, -1
	i32.add 	$4=, $4, $pop16
	br_if   	0, $4           # 0: up to label1
.LBB0_5:                                # %if.end
	end_loop
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	scale, .Lfunc_end0-scale
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
