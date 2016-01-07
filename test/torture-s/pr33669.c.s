	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr33669.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i64, i32
	.result 	i64
	.local  	i32, i64, i32, i64
# BB#0:                                 # %entry
	i32.load	$3=, 0($0)
	i64.extend_u/i32	$push0=, $3
	i64.rem_s	$4=, $1, $pop0
	i32.add 	$push2=, $2, $3
	i32.wrap/i64	$push1=, $4
	i32.add 	$push3=, $pop2, $pop1
	i32.const	$push4=, -1
	i32.add 	$2=, $pop3, $pop4
	i32.rem_u	$5=, $2, $3
	i64.const	$6=, -1
	block   	.LBB0_3
	i32.sub 	$push5=, $2, $5
	i32.lt_u	$push6=, $3, $pop5
	br_if   	$pop6, .LBB0_3
# BB#1:                                 # %if.end
	i64.sub 	$6=, $1, $4
	i32.load	$push7=, 4($0)
	i32.le_u	$push8=, $pop7, $3
	br_if   	$pop8, .LBB0_3
# BB#2:                                 # %if.then13
	i32.const	$push9=, 4
	i32.add 	$push10=, $0, $pop9
	i32.store	$discard=, 0($pop10), $3
.LBB0_3:                                  # %cleanup
	return  	$6
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
