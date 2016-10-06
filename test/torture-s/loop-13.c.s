	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-13.c"
	.section	.text.scale,"ax",@progbits
	.hidden	scale
	.globl	scale
	.type	scale,@function
scale:                                  # @scale
	.param  	i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	
	i32.load	$push15=, 0($0)
	tee_local	$push14=, $3=, $pop15
	i32.const	$push13=, 1
	i32.eq  	$push0=, $pop14, $pop13
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push16=, 1
	i32.lt_s	$push1=, $2, $pop16
	br_if   	0, $pop1        # 0: down to label0
# BB#2:                                 # %for.body.preheader
	i32.load	$push2=, 0($1)
	i32.mul 	$push3=, $pop2, $3
	i32.store	0($1), $pop3
	i32.load	$push4=, 4($1)
	i32.mul 	$push5=, $pop4, $3
	i32.store	4($1), $pop5
	i32.const	$push6=, 1
	i32.eq  	$push7=, $2, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#3:                                 # %for.body.for.body_crit_edge.preheader
	i32.const	$push8=, 12
	i32.add 	$1=, $1, $pop8
	i32.const	$push17=, -1
	i32.add 	$2=, $2, $pop17
.LBB0_4:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.load	$push9=, 0($1)
	i32.load	$push26=, 0($0)
	tee_local	$push25=, $3=, $pop26
	i32.mul 	$push10=, $pop9, $pop25
	i32.store	0($1), $pop10
	i32.const	$push24=, -4
	i32.add 	$push23=, $1, $pop24
	tee_local	$push22=, $4=, $pop23
	i32.load	$push11=, 0($4)
	i32.mul 	$push12=, $3, $pop11
	i32.store	0($pop22), $pop12
	i32.const	$push21=, 8
	i32.add 	$1=, $1, $pop21
	i32.const	$push20=, -1
	i32.add 	$push19=, $2, $pop20
	tee_local	$push18=, $2=, $pop19
	br_if   	0, $pop18       # 0: up to label1
.LBB0_5:                                # %if.end
	end_loop
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	scale, .Lfunc_end0-scale

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
