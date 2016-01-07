	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr57875.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.load	$5=, i($3)
	block   	.LBB0_9
	i32.gt_s	$push0=, $5, $3
	br_if   	$pop0, .LBB0_9
# BB#1:                                 # %for.body.lr.ph
	i32.load	$0=, d($3)
	i32.load	$1=, c($3)
.LBB0_2:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_8
	block   	.LBB0_7
	br_if   	$0, .LBB0_7
# BB#3:                                 # %if.then
                                        #   in Loop: Header=.LBB0_2 Depth=1
	block   	.LBB0_6
	block   	.LBB0_5
	i32.const	$push14=, 0
	i32.eq  	$push15=, $1, $pop14
	br_if   	$pop15, .LBB0_5
# BB#4:                                 # %if.then.if.end_crit_edge
                                        #   in Loop: Header=.LBB0_2 Depth=1
	i32.load	$2=, f($3)
	br      	.LBB0_6
.LBB0_5:                                  # %if.then2
                                        #   in Loop: Header=.LBB0_2 Depth=1
	i32.const	$push1=, 2
	i32.store	$2=, f($3), $pop1
.LBB0_6:                                  # %if.end
                                        #   in Loop: Header=.LBB0_2 Depth=1
	i32.load8_u	$push2=, e($3)
	i32.and 	$push3=, $pop2, $2
	i32.store8	$discard=, e($3), $pop3
.LBB0_7:                                  # %for.inc
                                        #   in Loop: Header=.LBB0_2 Depth=1
	i32.const	$push4=, 1
	i32.add 	$2=, $5, $pop4
	i32.lt_s	$4=, $5, $3
	copy_local	$5=, $2
	br_if   	$4, .LBB0_2
.LBB0_8:                                  # %for.cond.for.end_crit_edge
	i32.store	$discard=, i($3), $2
.LBB0_9:                                  # %for.end
	block   	.LBB0_11
	i32.const	$push10=, a
	i32.load8_u	$push5=, e($3)
	i32.const	$push6=, 1
	i32.shl 	$push7=, $pop5, $pop6
	i32.const	$push8=, 4
	i32.and 	$push9=, $pop7, $pop8
	i32.add 	$push11=, $pop10, $pop9
	i32.load	$push12=, 0($pop11)
	i32.store	$push13=, b($3), $pop12
	br_if   	$pop13, .LBB0_11
# BB#10:                                # %if.end10
	return  	$3
.LBB0_11:                                 # %if.then9
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	i,@object               # @i
	.bss
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4

	.type	d,@object               # @d
	.globl	d
	.align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.type	c,@object               # @c
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.type	f,@object               # @f
	.globl	f
	.align	2
f:
	.int32	0                       # 0x0
	.size	f, 4

	.type	e,@object               # @e
	.globl	e
e:
	.zero	1
	.size	e, 1

	.type	a,@object               # @a
	.globl	a
	.align	2
a:
	.zero	4
	.size	a, 4

	.type	b,@object               # @b
	.globl	b
	.align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
