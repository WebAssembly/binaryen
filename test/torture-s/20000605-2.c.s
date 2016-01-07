	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000605-2.c"
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.load	$2=, 0($0)
	i32.const	$4=, 0
	block   	.LBB0_4
	i32.load	$push0=, 0($1)
	i32.ge_s	$push1=, $2, $pop0
	br_if   	$pop1, .LBB0_4
.LBB0_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_3
	i32.const	$push2=, 5
	i32.ge_s	$push3=, $4, $pop2
	br_if   	$pop3, .LBB0_3
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=.LBB0_1 Depth=1
	i32.const	$3=, 1
	i32.add 	$push4=, $2, $4
	i32.add 	$push5=, $pop4, $3
	i32.store	$discard=, 0($0), $pop5
	i32.add 	$3=, $4, $3
	copy_local	$4=, $3
	i32.add 	$push7=, $2, $3
	i32.load	$push6=, 0($1)
	i32.lt_s	$push8=, $pop7, $pop6
	br_if   	$pop8, .LBB0_1
	br      	.LBB0_4
.LBB0_3:                                  # %if.then
	call    	abort
	unreachable
.LBB0_4:                                  # %for.end
	return
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %for.inc.i
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
