	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr33992.c"
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i64
# BB#0:                                 # %entry
	block   	.LBB0_2
	i64.const	$push0=, 0
	i64.ne  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_2
# BB#1:                                 # %if.end
	return
.LBB0_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.globl	do_test
	.type	do_test,@function
do_test:                                # @do_test
	.param  	i32
	.local  	i64, i64, i64, i64, i64, i64, i64, i64, i64
# BB#0:                                 # %entry
	i64.load	$1=, 0($0)
	i64.const	$2=, -1
	i64.const	$8=, 63
	copy_local	$9=, $2
.LBB1_1:                                  # %for.cond.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_2
	i64.const	$3=, 4294967295
	i64.and 	$4=, $8, $3
	i64.const	$5=, 1
	i64.add 	$9=, $9, $5
	i64.add 	$8=, $8, $2
	i64.const	$6=, 0
	i64.shl 	$push0=, $5, $4
	i64.and 	$push1=, $pop0, $1
	i64.eq  	$push2=, $pop1, $6
	br_if   	$pop2, .LBB1_1
.LBB1_2:                                  # %foo.exit
	i64.const	$7=, 32
	i64.shl 	$push3=, $9, $7
	i64.shr_s	$push4=, $pop3, $7
	call    	bar, $pop4
	i64.load	$1=, 0($0)
	i64.const	$2=, -1
	i64.const	$8=, 63
	copy_local	$9=, $2
.LBB1_3:                                  # %for.cond.i.1
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_4
	i64.and 	$4=, $8, $3
	i64.add 	$9=, $9, $5
	i64.add 	$8=, $8, $2
	i64.shl 	$push5=, $5, $4
	i64.and 	$push6=, $pop5, $1
	i64.eq  	$push7=, $pop6, $6
	br_if   	$pop7, .LBB1_3
.LBB1_4:                                  # %foo.exit.1
	i64.shl 	$push8=, $9, $7
	i64.shr_s	$push9=, $pop8, $7
	call    	bar, $pop9
	return
.Lfunc_end1:
	.size	do_test, .Lfunc_end1-do_test

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$4=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$4=, 0($1), $4
	i64.const	$push0=, -9223372036854775807
	i64.store	$discard=, 8($4), $pop0
	i32.const	$3=, 8
	i32.add 	$3=, $4, $3
	call    	do_test, $3
	i32.const	$push1=, 0
	i32.const	$2=, 16
	i32.add 	$4=, $4, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	return  	$pop1
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
