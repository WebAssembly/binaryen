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
	i32.load	$push0=, 0($0)
	tee_local	$push14=, $3=, $pop0
	i32.const	$push13=, 1
	i32.eq  	$push1=, $pop14, $pop13
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push15=, 1
	i32.lt_s	$push2=, $2, $pop15
	br_if   	0, $pop2        # 0: down to label0
# BB#2:                                 # %for.body.preheader
	i32.load	$4=, 4($1)
	i32.load	$push3=, 0($1)
	i32.mul 	$push4=, $pop3, $3
	i32.store	$discard=, 0($1), $pop4
	i32.mul 	$push5=, $4, $3
	i32.store	$discard=, 4($1), $pop5
	i32.const	$push6=, 1
	i32.eq  	$push7=, $2, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#3:                                 # %for.body.for.body_crit_edge.preheader
	i32.const	$push8=, 12
	i32.add 	$1=, $1, $pop8
	i32.const	$push16=, -1
	i32.add 	$2=, $2, $pop16
.LBB0_4:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push20=, -4
	i32.add 	$3=, $1, $pop20
	i32.load	$4=, 0($1)
	i32.load	$push10=, 0($3)
	i32.load	$push9=, 0($0)
	tee_local	$push19=, $5=, $pop9
	i32.mul 	$push11=, $pop10, $pop19
	i32.store	$discard=, 0($3), $pop11
	i32.mul 	$push12=, $4, $5
	i32.store	$discard=, 0($1), $pop12
	i32.const	$push18=, -1
	i32.add 	$2=, $2, $pop18
	i32.const	$push17=, 8
	i32.add 	$1=, $1, $pop17
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
