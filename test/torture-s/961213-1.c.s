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
# BB#0:                                 # %entry
	i64.const	$5=, 0
	i64.const	$push5=, 0
	i64.store	0($0), $pop5
	block   	
	i32.const	$push1=, 1
	i32.lt_s	$push2=, $1, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %for.body.lr.ph
	i64.extend_s/i32	$4=, $3
	copy_local	$3=, $1
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i64.mul 	$push3=, $5, $4
	i64.load32_u	$push4=, 0($2)
	i64.add 	$5=, $pop3, $pop4
	i32.const	$push9=, 4
	i32.add 	$push0=, $2, $pop9
	copy_local	$2=, $pop0
	i32.const	$push8=, -1
	i32.add 	$push7=, $3, $pop8
	tee_local	$push6=, $3=, $pop7
	br_if   	0, $pop6        # 0: up to label1
# BB#3:                                 # %for.cond.for.end_crit_edge
	end_loop
	i64.store	0($0), $5
.LBB0_4:                                # %for.end
	end_block                       # label0:
	copy_local	$push10=, $1
                                        # fallthrough-return: $pop10
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
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	exit, void, i32
