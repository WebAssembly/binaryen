	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-13.c"
	.section	.text.scale,"ax",@progbits
	.hidden	scale
	.globl	scale
	.type	scale,@function
scale:                                  # @scale
	.param  	i32, i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.load	$push13=, 0($0)
	tee_local	$push12=, $3=, $pop13
	i32.const	$push11=, 1
	i32.eq  	$push0=, $pop12, $pop11
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push14=, 1
	i32.lt_s	$push1=, $2, $pop14
	br_if   	0, $pop1        # 0: down to label0
# BB#2:                                 # %for.body.preheader
	i32.load	$4=, 4($1)
	i32.load	$push2=, 0($1)
	i32.mul 	$push3=, $pop2, $3
	i32.store	$discard=, 0($1), $pop3
	i32.mul 	$push4=, $4, $3
	i32.store	$discard=, 4($1), $pop4
	i32.const	$push5=, 1
	i32.eq  	$push6=, $2, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#3:                                 # %for.body.for.body_crit_edge.preheader
	i32.const	$push7=, 12
	i32.add 	$1=, $1, $pop7
	i32.const	$push15=, -1
	i32.add 	$2=, $2, $pop15
.LBB0_4:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push20=, -4
	i32.add 	$3=, $1, $pop20
	i32.load	$4=, 0($1)
	i32.load	$push8=, 0($3)
	i32.load	$push19=, 0($0)
	tee_local	$push18=, $5=, $pop19
	i32.mul 	$push9=, $pop8, $pop18
	i32.store	$discard=, 0($3), $pop9
	i32.mul 	$push10=, $4, $5
	i32.store	$discard=, 0($1), $pop10
	i32.const	$push17=, -1
	i32.add 	$2=, $2, $pop17
	i32.const	$push16=, 8
	i32.add 	$1=, $1, $pop16
	br_if   	0, $2           # 0: up to label1
.LBB0_5:                                # %if.end
	end_loop                        # label2:
	end_block                       # label0:
	return
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
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
