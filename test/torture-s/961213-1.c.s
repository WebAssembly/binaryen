	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/961213-1.c"
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i64, i64, i64
# BB#0:                                 # %entry
	block   	.LBB0_4
	i64.const	$push0=, 0
	i64.store	$6=, 0($0), $pop0
	i32.const	$push1=, 1
	i32.lt_s	$push2=, $1, $pop1
	br_if   	$pop2, .LBB0_4
# BB#1:                                 # %for.body.lr.ph
	i64.extend_s/i32	$4=, $3
	copy_local	$3=, $1
.LBB0_2:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_3
	i64.load32_u	$5=, 0($2)
	i32.const	$push4=, 4
	i32.add 	$2=, $2, $pop4
	i32.const	$push5=, -1
	i32.add 	$3=, $3, $pop5
	i64.mul 	$push3=, $6, $4
	i64.add 	$6=, $5, $pop3
	br_if   	$3, .LBB0_2
.LBB0_3:                                  # %for.cond.for.end_crit_edge
	i64.store	$discard=, 0($0), $6
.LBB0_4:                                  # %for.end
	return  	$1
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
