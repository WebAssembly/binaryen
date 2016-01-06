	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20011008-3.c"
	.globl	log_compare
	.type	log_compare,@function
log_compare:                            # @log_compare
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
func_end0:
	.size	log_compare, func_end0-log_compare

	.globl	__db_txnlist_lsnadd
	.type	__db_txnlist_lsnadd,@function
__db_txnlist_lsnadd:                    # @__db_txnlist_lsnadd
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32, i64, i32
# BB#0:                                 # %entry
	i32.const	$5=, 1
	i32.and 	$4=, $3, $5
	i32.const	$3=, 0
BB1_1:                                  # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB1_5
	copy_local	$7=, $5
	block   	BB1_3
	i32.const	$push10=, 0
	i32.eq  	$push11=, $4, $pop10
	br_if   	$pop11, BB1_3
# BB#2:                                 # %cond.false
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push1=, 12
	i32.add 	$push2=, $1, $pop1
	i32.load	$7=, 0($pop2)
BB1_3:                                  # %cond.end
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.ge_s	$push3=, $3, $7
	br_if   	$pop3, BB1_5
# BB#4:                                 # %for.body
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push9=, 1
	i32.add 	$3=, $3, $pop9
	br      	BB1_1
BB1_5:                                  # %for.end35
	i32.const	$push4=, 20
	i32.add 	$push5=, $1, $pop4
	i32.load	$7=, 0($pop5)
	i32.const	$5=, 4
	i64.load32_u	$6=, 0($7)
	i32.add 	$push8=, $2, $5
	i32.add 	$push6=, $7, $5
	i64.load32_u	$push7=, 0($pop6)
	i64.store32	$discard=, 0($pop8), $pop7
	i64.store32	$discard=, 0($2), $6
	i32.add 	$push0=, $0, $3
	return  	$pop0
func_end1:
	.size	__db_txnlist_lsnadd, func_end1-__db_txnlist_lsnadd

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end6
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
