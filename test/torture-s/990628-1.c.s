	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990628-1.c"
	.section	.text.num_records,"ax",@progbits
	.hidden	num_records
	.globl	num_records
	.type	num_records,@function
num_records:                            # @num_records
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	num_records, .Lfunc_end0-num_records

	.section	.text.fetch,"ax",@progbits
	.hidden	fetch
	.globl	fetch
	.type	fetch,@function
fetch:                                  # @fetch
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, data_tmp
	i32.const	$push2=, 85
	i32.const	$push1=, 404
	call    	memset@FUNCTION, $pop0, $pop2, $pop1
	i32.const	$0=, 0
	i32.load	$1=, fetch.fetch_count($0)
	i32.const	$push3=, 1
	i32.add 	$push4=, $1, $pop3
	i32.store	$discard=, fetch.fetch_count($0), $pop4
	i32.gt_s	$push5=, $1, $0
	i32.const	$push6=, 100
	i32.select	$push7=, $pop5, $pop6, $0
	i32.store	$discard=, sqlca($0), $pop7
	return
	.endfunc
.Lfunc_end1:
	.size	fetch, .Lfunc_end1-fetch

	.section	.text.load_data,"ax",@progbits
	.hidden	load_data
	.globl	load_data
	.type	load_data,@function
load_data:                              # @load_data
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 404
	i32.call	$7=, malloc@FUNCTION, $1
	i32.const	$2=, 0
	i32.store	$8=, data_ptr($2), $7
	i32.const	$push1=, 170
	call    	memset@FUNCTION, $8, $pop1, $1
	i32.const	$3=, data_tmp
	i32.const	$4=, 85
	call    	memset@FUNCTION, $3, $4, $1
	i32.load	$7=, fetch.fetch_count($2)
	i32.const	$5=, 1
	i32.add 	$push2=, $7, $5
	i32.store	$discard=, fetch.fetch_count($2), $pop2
	i32.gt_s	$0=, $7, $2
	i32.const	$6=, 100
	block
	i32.select	$push3=, $0, $6, $2
	i32.store	$discard=, sqlca($2), $pop3
	br_if   	$0, 0           # 0: down to label0
.LBB2_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	copy_local	$0=, $7
	i32.add 	$7=, $8, $1
	call    	memcpy@FUNCTION, $8, $3, $1
	call    	memset@FUNCTION, $3, $4, $1
	copy_local	$8=, $7
	i32.add 	$7=, $0, $5
	i32.lt_s	$push5=, $7, $5
	br_if   	$pop5, 0        # 0: up to label1
# BB#2:                                 # %while.cond.while.end_crit_edge
	end_loop                        # label2:
	i32.const	$push4=, 2
	i32.add 	$push0=, $0, $pop4
	i32.store	$discard=, fetch.fetch_count($2), $pop0
	i32.store	$discard=, sqlca($2), $6
.LBB2_3:                                # %while.end
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end2:
	.size	load_data, .Lfunc_end2-load_data

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 404
	i32.call	$8=, malloc@FUNCTION, $2
	i32.const	$3=, 0
	i32.store	$0=, data_ptr($3), $8
	i32.const	$push0=, 170
	call    	memset@FUNCTION, $0, $pop0, $2
	i32.const	$4=, data_tmp
	i32.const	$5=, 85
	call    	memset@FUNCTION, $4, $5, $2
	i32.load	$8=, fetch.fetch_count($3)
	i32.const	$6=, 1
	i32.add 	$push1=, $8, $6
	i32.store	$discard=, fetch.fetch_count($3), $pop1
	i32.gt_s	$9=, $8, $3
	i32.const	$7=, 100
	block
	i32.select	$push2=, $9, $7, $3
	i32.store	$discard=, sqlca($3), $pop2
	br_if   	$9, 0           # 0: down to label3
# BB#1:                                 # %while.body.lr.ph.i
	copy_local	$9=, $0
.LBB3_2:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.add 	$1=, $9, $2
	call    	memcpy@FUNCTION, $9, $4, $2
	call    	memset@FUNCTION, $4, $5, $2
	i32.add 	$8=, $8, $6
	copy_local	$9=, $1
	i32.lt_s	$push3=, $8, $6
	br_if   	$pop3, 0        # 0: up to label4
# BB#3:                                 # %while.cond.while.end_crit_edge.i
	end_loop                        # label5:
	i32.const	$push4=, 2
	i32.store	$discard=, fetch.fetch_count($3), $pop4
	i32.store	$discard=, sqlca($3), $7
.LBB3_4:                                # %load_data.exit
	end_block                       # label3:
	block
	i32.load	$push5=, 0($0)
	i32.const	$push6=, 1431655765
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, 0        # 0: down to label6
# BB#5:                                 # %if.end
	call    	exit@FUNCTION, $3
	unreachable
.LBB3_6:                                # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	fetch.fetch_count,@object # @fetch.fetch_count
	.lcomm	fetch.fetch_count,4,2
	.hidden	data_tmp                # @data_tmp
	.type	data_tmp,@object
	.section	.bss.data_tmp,"aw",@nobits
	.globl	data_tmp
	.align	2
data_tmp:
	.skip	404
	.size	data_tmp, 404

	.hidden	sqlca                   # @sqlca
	.type	sqlca,@object
	.section	.bss.sqlca,"aw",@nobits
	.globl	sqlca
	.align	2
sqlca:
	.skip	4
	.size	sqlca, 4

	.hidden	data_ptr                # @data_ptr
	.type	data_ptr,@object
	.section	.bss.data_ptr,"aw",@nobits
	.globl	data_ptr
	.align	2
data_ptr:
	.int32	0
	.size	data_ptr, 4


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
