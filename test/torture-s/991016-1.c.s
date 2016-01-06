	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/991016-1.c"
	.globl	doit
	.type	doit,@function
doit:                                   # @doit
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i64, i32, i64
# BB#0:                                 # %entry
	block   	BB0_13
	block   	BB0_10
	i32.const	$push11=, 0
	i32.eq  	$push12=, $0, $pop11
	br_if   	$pop12, BB0_10
# BB#1:                                 # %entry
	i32.const	$5=, 1
	block   	BB0_7
	i32.eq  	$push0=, $0, $5
	br_if   	$pop0, BB0_7
# BB#2:                                 # %entry
	block   	BB0_6
	i32.const	$push1=, 2
	i32.ne  	$push2=, $0, $pop1
	br_if   	$pop2, BB0_6
# BB#3:                                 # %do.body11.preheader
	i64.load	$6=, 0($2)
BB0_4:                                  # %do.body11
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_5
	i32.const	$push4=, -1
	i32.add 	$1=, $1, $pop4
	copy_local	$4=, $6
	i64.const	$push3=, 1
	i64.shl 	$6=, $4, $pop3
	br_if   	$1, BB0_4
BB0_5:                                  # %do.end16
	i64.store	$discard=, 0($2), $6
	i64.const	$push5=, 0
	i64.eq  	$1=, $4, $pop5
	br      	BB0_13
BB0_6:                                  # %sw.default
	call    	abort
	unreachable
BB0_7:                                  # %do.body2.preheader
	i32.load	$0=, 0($2)
BB0_8:                                  # %do.body2
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_9
	i32.const	$push6=, -1
	i32.add 	$1=, $1, $pop6
	copy_local	$3=, $0
	i32.shl 	$0=, $3, $5
	br_if   	$1, BB0_8
BB0_9:                                  # %do.end7
	i32.store	$discard=, 0($2), $0
	i32.const	$push7=, 0
	i32.eq  	$1=, $3, $pop7
	br      	BB0_13
BB0_10:                                 # %do.body.preheader
	i32.load	$0=, 0($2)
BB0_11:                                 # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB0_12
	i32.const	$push9=, -1
	i32.add 	$1=, $1, $pop9
	copy_local	$3=, $0
	i32.const	$push8=, 1
	i32.shl 	$0=, $3, $pop8
	br_if   	$1, BB0_11
BB0_12:                                 # %do.end
	i32.store	$discard=, 0($2), $0
	i32.const	$push10=, 0
	i32.eq  	$1=, $3, $pop10
BB0_13:                                 # %cleanup
	return  	$1
func_end0:
	.size	doit, func_end0-doit

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end8
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
