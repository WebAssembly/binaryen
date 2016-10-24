	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20011008-3.c"
	.section	.text.log_compare,"ax",@progbits
	.hidden	log_compare
	.globl	log_compare
	.type	log_compare,@function
log_compare:                            # @log_compare
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
                                        # fallthrough-return: $pop0
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, 0
	i32.const	$push0=, 12
	i32.add 	$4=, $1, $pop0
	i32.const	$6=, 1
	block   	
	block   	
	i32.const	$push9=, 1
	i32.and 	$push8=, $3, $pop9
	tee_local	$push7=, $3=, $pop8
	br_if   	0, $pop7        # 0: down to label1
# BB#1:
	i32.const	$7=, 1
	br      	1               # 1: down to label0
.LBB1_2:
	end_block                       # label1:
	i32.const	$7=, 0
.LBB1_3:                                # =>This Inner Loop Header: Depth=1
	end_block                       # label0:
	loop    	i32             # label2:
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$7, 1, 2, 3, 0, 0 # 1: down to label7
                                        # 2: down to label6
                                        # 3: down to label5
                                        # 0: down to label8
.LBB1_4:                                # %for.body
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label8:
	i32.const	$push10=, 1
	i32.add 	$5=, $5, $pop10
	i32.const	$6=, 1
	i32.eqz 	$push11=, $3
	br_if   	3, $pop11       # 3: down to label4
# BB#5:                                 #   in Loop: Header=BB1_3 Depth=1
	i32.const	$7=, 0
	br      	5               # 5: up to label2
.LBB1_6:                                # %cond.false
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label7:
	i32.load	$6=, 0($4)
# BB#7:                                 #   in Loop: Header=BB1_3 Depth=1
	i32.const	$7=, 1
	br      	4               # 4: up to label2
.LBB1_8:                                # %cond.end
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label6:
	i32.lt_s	$push1=, $5, $6
	br_if   	2, $pop1        # 2: down to label3
# BB#9:                                 #   in Loop: Header=BB1_3 Depth=1
	i32.const	$7=, 2
	br      	3               # 3: up to label2
.LBB1_10:                               # %for.end35
	end_block                       # label5:
	i32.const	$push2=, 20
	i32.add 	$push3=, $1, $pop2
	i32.load	$push4=, 0($pop3)
	i64.load	$push5=, 0($pop4):p2align=2
	i64.store	0($2):p2align=2, $pop5
	i32.add 	$push6=, $0, $5
	return  	$pop6
.LBB1_11:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label4:
	i32.const	$7=, 1
	br      	1               # 1: up to label2
.LBB1_12:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label3:
	i32.const	$7=, 3
	br      	0               # 0: up to label2
.LBB1_13:
	end_loop
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


	.ident	"clang version 4.0.0 "
	.functype	exit, void, i32
