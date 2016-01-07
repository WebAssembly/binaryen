	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/960521-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, 0
	i32.const	$0=, 1
	block   	.LBB0_3
	i32.load	$push0=, n($4)
	i32.lt_s	$push1=, $pop0, $0
	br_if   	$pop1, .LBB0_3
# BB#1:                                 # %for.body.lr.ph
	i32.const	$1=, 0
	i32.load	$2=, a($1)
	copy_local	$3=, $1
.LBB0_2:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_3
	i32.const	$push2=, -1
	i32.store	$discard=, 0($2), $pop2
	i32.const	$push4=, 4
	i32.add 	$2=, $2, $pop4
	i32.add 	$3=, $3, $0
	i32.load	$push3=, n($1)
	i32.lt_s	$push5=, $3, $pop3
	br_if   	$pop5, .LBB0_2
.LBB0_3:                                  # %for.cond1.preheader
	i32.load	$2=, b($4)
.LBB0_4:                                  # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_5
	i32.add 	$push6=, $2, $4
	i32.const	$push7=, -1
	i32.store	$discard=, 0($pop6), $pop7
	i32.const	$push8=, 4
	i32.add 	$4=, $4, $pop8
	i32.const	$push9=, 131068
	i32.ne  	$push10=, $4, $pop9
	br_if   	$pop10, .LBB0_4
.LBB0_5:                                  # %for.end7
	return  	$4
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %for.body.lr.ph.i
	i32.const	$4=, 0
	i32.const	$5=, 131072
	i32.const	$push1=, 32768
	i32.store	$discard=, n($4), $pop1
	i32.call	$push0=, malloc, $5
	i32.store	$1=, a($4), $pop0
	i32.call	$2=, malloc, $5
	i32.store	$5=, 0($2), $4
	i32.load	$0=, n($5)
	i32.const	$3=, 4
	i32.add 	$push2=, $2, $3
	i32.store	$discard=, b($4), $pop2
.LBB1_1:                                  # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_2
	i32.const	$push4=, 1
	i32.add 	$5=, $5, $pop4
	i32.const	$push3=, -1
	i32.store	$4=, 0($1), $pop3
	i32.add 	$1=, $1, $3
	i32.lt_s	$push5=, $5, $0
	br_if   	$pop5, .LBB1_1
.LBB1_2:                                  # %for.cond1.preheader.i
	i32.const	$5=, 0
	i32.load	$1=, b($5)
.LBB1_3:                                  # %for.body3.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_4
	i32.add 	$push6=, $1, $5
	i32.store	$discard=, 0($pop6), $4
	i32.add 	$5=, $5, $3
	i32.const	$push7=, 131068
	i32.ne  	$push8=, $5, $pop7
	br_if   	$pop8, .LBB1_3
.LBB1_4:                                  # %foo.exit
	block   	.LBB1_6
	i32.const	$push9=, -4
	i32.add 	$push10=, $1, $pop9
	i32.load	$push11=, 0($pop10)
	br_if   	$pop11, .LBB1_6
# BB#5:                                 # %if.end
	i32.const	$push12=, 0
	call    	exit, $pop12
	unreachable
.LBB1_6:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	n,@object               # @n
	.bss
	.globl	n
	.align	2
n:
	.int32	0                       # 0x0
	.size	n, 4

	.type	a,@object               # @a
	.globl	a
	.align	2
a:
	.int32	0
	.size	a, 4

	.type	b,@object               # @b
	.globl	b
	.align	2
b:
	.int32	0
	.size	b, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
