	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20011008-3.c"
	.section	.text.log_compare,"ax",@progbits
	.hidden	log_compare
	.globl	log_compare
	.type	log_compare,@function
log_compare:                            # @log_compare
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	log_compare, .Lfunc_end0-log_compare

	.section	.text.__db_txnlist_lsnadd,"ax",@progbits
	.hidden	__db_txnlist_lsnadd
	.globl	__db_txnlist_lsnadd
	.type	__db_txnlist_lsnadd,@function
__db_txnlist_lsnadd:                    # @__db_txnlist_lsnadd
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push7=, 1
	i32.and 	$4=, $3, $pop7
	i32.const	$push1=, 12
	i32.add 	$5=, $1, $pop1
	i32.const	$3=, 0
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$6=, 1
	block
	i32.eqz 	$push9=, $4
	br_if   	0, $pop9        # 0: down to label2
# BB#2:                                 # %cond.false
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.load	$6=, 0($5)
.LBB1_3:                                # %cond.end
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.ge_s	$push2=, $3, $6
	br_if   	1, $pop2        # 1: down to label1
# BB#4:                                 # %for.body
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push8=, 1
	i32.add 	$3=, $3, $pop8
	br      	0               # 0: up to label0
.LBB1_5:                                # %for.end35
	end_loop                        # label1:
	i32.const	$push3=, 20
	i32.add 	$push4=, $1, $pop3
	i32.load	$push5=, 0($pop4)
	i64.load	$push6=, 0($pop5):p2align=2
	i64.store	$discard=, 0($2):p2align=2, $pop6
	i32.add 	$push0=, $0, $3
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	__db_txnlist_lsnadd, .Lfunc_end1-__db_txnlist_lsnadd

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end6
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
