	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-13.c"
	.section	.text.scale,"ax",@progbits
	.hidden	scale
	.globl	scale
	.type	scale,@function
scale:                                  # @scale
	.param  	i32, i32, i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.load	$4=, 0($0)
	i32.const	$6=, 1
	block
	i32.eq  	$push0=, $4, $6
	br_if   	$pop0, 0        # 0: down to label0
# BB#1:                                 # %entry
	i32.lt_s	$push1=, $2, $6
	br_if   	$pop1, 0        # 0: down to label0
# BB#2:                                 # %for.body.preheader
	i32.load	$5=, 4($1)
	i32.load	$push2=, 0($1)
	i32.mul 	$push3=, $pop2, $4
	i32.store	$discard=, 0($1), $pop3
	i32.mul 	$push4=, $5, $4
	i32.store	$discard=, 4($1), $pop4
	i32.eq  	$push5=, $2, $6
	br_if   	$pop5, 0        # 0: down to label0
# BB#3:                                 # %for.body.for.body_crit_edge.preheader
	i32.const	$push6=, 12
	i32.add 	$1=, $1, $pop6
	i32.const	$3=, -1
	i32.add 	$6=, $2, $3
.LBB0_4:                                # %for.body.for.body_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push7=, -4
	i32.add 	$4=, $1, $pop7
	i32.load	$2=, 0($0)
	i32.load	$5=, 0($1)
	i32.load	$push8=, 0($4)
	i32.mul 	$push9=, $pop8, $2
	i32.store	$discard=, 0($4), $pop9
	i32.mul 	$push10=, $5, $2
	i32.store	$discard=, 0($1), $pop10
	i32.const	$push11=, 8
	i32.add 	$1=, $1, $pop11
	i32.add 	$6=, $6, $3
	br_if   	$6, 0           # 0: up to label1
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
