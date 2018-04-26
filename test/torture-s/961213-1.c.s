	.text
	.file	"961213-1.c"
	.section	.text.g,"ax",@progbits
	.hidden	g                       # -- Begin function g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i64, i64
# %bb.0:                                # %entry
	i64.const	$5=, 0
	i64.const	$push5=, 0
	i64.store	0($0), $pop5
	block   	
	i32.const	$push1=, 1
	i32.lt_s	$push2=, $1, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %for.body.lr.ph
	i64.extend_s/i32	$4=, $3
	copy_local	$3=, $1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push7=, -1
	i32.add 	$3=, $3, $pop7
	i64.mul 	$push3=, $5, $4
	i64.load32_u	$push4=, 0($2)
	i64.add 	$5=, $pop3, $pop4
	i32.const	$push6=, 4
	i32.add 	$push0=, $2, $pop6
	copy_local	$2=, $pop0
	br_if   	0, $3           # 0: up to label1
# %bb.3:                                # %for.cond.for.end_crit_edge
	end_loop
	i64.store	0($0), $5
.LBB0_4:                                # %for.end
	end_block                       # label0:
	copy_local	$push8=, $1
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g
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
