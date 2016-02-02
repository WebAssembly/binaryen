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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, data_tmp
	i32.const	$push2=, 85
	i32.const	$push1=, 404
	i32.call	$discard=, memset@FUNCTION, $pop0, $pop2, $pop1
	i32.const	$push3=, 0
	i32.const	$push14=, 0
	i32.load	$push4=, fetch.fetch_count($pop14)
	tee_local	$push13=, $0=, $pop4
	i32.const	$push5=, 1
	i32.add 	$push6=, $pop13, $pop5
	i32.store	$discard=, fetch.fetch_count($pop3), $pop6
	i32.const	$push12=, 0
	i32.const	$push11=, 0
	i32.gt_s	$push7=, $0, $pop11
	i32.const	$push8=, 100
	i32.const	$push10=, 0
	i32.select	$push9=, $pop7, $pop8, $pop10
	i32.store	$discard=, sqlca($pop12), $pop9
	return
	.endfunc
.Lfunc_end1:
	.size	fetch, .Lfunc_end1-fetch

	.section	.text.load_data,"ax",@progbits
	.hidden	load_data
	.globl	load_data
	.type	load_data,@function
load_data:                              # @load_data
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push3=, 0
	i32.const	$push26=, 404
	i32.call	$push0=, malloc@FUNCTION, $pop26
	i32.store	$push4=, data_ptr($pop3), $pop0
	i32.const	$push5=, 170
	i32.const	$push25=, 404
	i32.call	$2=, memset@FUNCTION, $pop4, $pop5, $pop25
	i32.const	$push6=, data_tmp
	i32.const	$push24=, 85
	i32.const	$push23=, 404
	i32.call	$1=, memset@FUNCTION, $pop6, $pop24, $pop23
	i32.const	$push22=, 0
	i32.const	$push21=, 0
	i32.load	$push14=, fetch.fetch_count($pop21)
	tee_local	$push20=, $3=, $pop14
	i32.const	$push19=, 1
	i32.add 	$push7=, $pop20, $pop19
	i32.store	$discard=, fetch.fetch_count($pop22), $pop7
	i32.const	$push18=, 0
	i32.const	$push17=, 0
	i32.gt_s	$push8=, $3, $pop17
	tee_local	$push16=, $0=, $pop8
	i32.const	$push9=, 100
	i32.const	$push15=, 0
	i32.select	$push10=, $pop16, $pop9, $pop15
	i32.store	$discard=, sqlca($pop18), $pop10
	block
	br_if   	$0, 0           # 0: down to label0
.LBB2_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push33=, 404
	i32.add 	$0=, $2, $pop33
	i32.const	$push32=, 404
	i32.call	$discard=, memcpy@FUNCTION, $2, $1, $pop32
	i32.const	$push31=, 85
	i32.const	$push30=, 404
	i32.call	$discard=, memset@FUNCTION, $1, $pop31, $pop30
	copy_local	$2=, $0
	copy_local	$push1=, $3
	tee_local	$push29=, $0=, $pop1
	i32.const	$push28=, 1
	i32.add 	$3=, $pop29, $pop28
	i32.const	$push27=, 1
	i32.lt_s	$push11=, $3, $pop27
	br_if   	$pop11, 0       # 0: up to label1
# BB#2:                                 # %while.cond.while.end_crit_edge
	end_loop                        # label2:
	i32.const	$push12=, 0
	i32.const	$push35=, 2
	i32.add 	$push2=, $0, $pop35
	i32.store	$discard=, fetch.fetch_count($pop12), $pop2
	i32.const	$push34=, 0
	i32.const	$push13=, 100
	i32.store	$discard=, sqlca($pop34), $pop13
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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push29=, 404
	i32.call	$push0=, malloc@FUNCTION, $pop29
	i32.store	$push2=, data_ptr($pop1), $pop0
	i32.const	$push3=, 170
	i32.const	$push28=, 404
	i32.call	$0=, memset@FUNCTION, $pop2, $pop3, $pop28
	i32.const	$push4=, data_tmp
	i32.const	$push27=, 85
	i32.const	$push26=, 404
	i32.call	$2=, memset@FUNCTION, $pop4, $pop27, $pop26
	i32.const	$push25=, 0
	i32.const	$push24=, 0
	i32.load	$push17=, fetch.fetch_count($pop24)
	tee_local	$push23=, $4=, $pop17
	i32.const	$push22=, 1
	i32.add 	$push5=, $pop23, $pop22
	i32.store	$discard=, fetch.fetch_count($pop25), $pop5
	i32.const	$push21=, 0
	i32.const	$push20=, 0
	i32.gt_s	$push6=, $4, $pop20
	tee_local	$push19=, $3=, $pop6
	i32.const	$push7=, 100
	i32.const	$push18=, 0
	i32.select	$push8=, $pop19, $pop7, $pop18
	i32.store	$discard=, sqlca($pop21), $pop8
	block
	br_if   	$3, 0           # 0: down to label3
# BB#1:                                 # %while.body.lr.ph.i
	copy_local	$3=, $0
.LBB3_2:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$push35=, 404
	i32.add 	$1=, $3, $pop35
	i32.const	$push34=, 404
	i32.call	$discard=, memcpy@FUNCTION, $3, $2, $pop34
	i32.const	$push33=, 85
	i32.const	$push32=, 404
	i32.call	$discard=, memset@FUNCTION, $2, $pop33, $pop32
	i32.const	$push31=, 1
	i32.add 	$4=, $4, $pop31
	copy_local	$3=, $1
	i32.const	$push30=, 1
	i32.lt_s	$push9=, $4, $pop30
	br_if   	$pop9, 0        # 0: up to label4
# BB#3:                                 # %while.cond.while.end_crit_edge.i
	end_loop                        # label5:
	i32.const	$push10=, 0
	i32.const	$push11=, 2
	i32.store	$discard=, fetch.fetch_count($pop10), $pop11
	i32.const	$push36=, 0
	i32.const	$push12=, 100
	i32.store	$discard=, sqlca($pop36), $pop12
.LBB3_4:                                # %load_data.exit
	end_block                       # label3:
	block
	i32.load	$push13=, 0($0)
	i32.const	$push14=, 1431655765
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	$pop15, 0       # 0: down to label6
# BB#5:                                 # %if.end
	i32.const	$push16=, 0
	call    	exit@FUNCTION, $pop16
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
	.p2align	2
data_tmp:
	.skip	404
	.size	data_tmp, 404

	.hidden	sqlca                   # @sqlca
	.type	sqlca,@object
	.section	.bss.sqlca,"aw",@nobits
	.globl	sqlca
	.p2align	2
sqlca:
	.skip	4
	.size	sqlca, 4

	.hidden	data_ptr                # @data_ptr
	.type	data_ptr,@object
	.section	.bss.data_ptr,"aw",@nobits
	.globl	data_ptr
	.p2align	2
data_ptr:
	.int32	0
	.size	data_ptr, 4


	.ident	"clang version 3.9.0 "
