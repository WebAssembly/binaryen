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
	i32.load	$push13=, fetch.fetch_count($pop14)
	tee_local	$push12=, $0=, $pop13
	i32.const	$push4=, 1
	i32.add 	$push5=, $pop12, $pop4
	i32.store	$discard=, fetch.fetch_count($pop3), $pop5
	i32.const	$push11=, 0
	i32.const	$push7=, 100
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.gt_s	$push6=, $0, $pop9
	i32.select	$push8=, $pop7, $pop10, $pop6
	i32.store	$discard=, sqlca($pop11), $pop8
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
	i32.const	$push27=, 404
	i32.call	$push26=, malloc@FUNCTION, $pop27
	tee_local	$push25=, $2=, $pop26
	i32.store	$push0=, data_ptr($pop3), $pop25
	i32.const	$push4=, 170
	i32.const	$push24=, 404
	i32.call	$discard=, memset@FUNCTION, $pop0, $pop4, $pop24
	i32.const	$push5=, data_tmp
	i32.const	$push23=, 85
	i32.const	$push22=, 404
	i32.call	$0=, memset@FUNCTION, $pop5, $pop23, $pop22
	i32.const	$push21=, 0
	i32.const	$push20=, 0
	i32.load	$push19=, fetch.fetch_count($pop20)
	tee_local	$push18=, $3=, $pop19
	i32.const	$push17=, 1
	i32.add 	$push6=, $pop18, $pop17
	i32.store	$discard=, fetch.fetch_count($pop21), $pop6
	i32.const	$push16=, 0
	i32.const	$push7=, 100
	i32.const	$push15=, 0
	i32.const	$push14=, 0
	i32.gt_s	$push13=, $3, $pop14
	tee_local	$push12=, $1=, $pop13
	i32.select	$push8=, $pop7, $pop15, $pop12
	i32.store	$discard=, sqlca($pop16), $pop8
	block
	br_if   	0, $1           # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
.LBB2_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	copy_local	$1=, $3
	i32.const	$push35=, 404
	i32.call	$discard=, memcpy@FUNCTION, $2, $0, $pop35
	i32.const	$push34=, 85
	i32.const	$push33=, 404
	i32.call	$discard=, memset@FUNCTION, $0, $pop34, $pop33
	i32.const	$push32=, 404
	i32.add 	$push1=, $2, $pop32
	copy_local	$2=, $pop1
	i32.const	$push31=, 1
	i32.add 	$push30=, $1, $pop31
	tee_local	$push29=, $3=, $pop30
	i32.const	$push28=, 1
	i32.lt_s	$push9=, $pop29, $pop28
	br_if   	0, $pop9        # 0: up to label1
# BB#3:                                 # %while.cond.while.end_crit_edge
	end_loop                        # label2:
	i32.const	$push10=, 0
	i32.const	$push37=, 2
	i32.add 	$push2=, $1, $pop37
	i32.store	$discard=, fetch.fetch_count($pop10), $pop2
	i32.const	$push36=, 0
	i32.const	$push11=, 100
	i32.store	$discard=, sqlca($pop36), $pop11
.LBB2_4:                                # %while.end
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push3=, 0
	i32.const	$push30=, 404
	i32.call	$push1=, malloc@FUNCTION, $pop30
	i32.store	$push0=, data_ptr($pop3), $pop1
	i32.const	$push4=, 170
	i32.const	$push29=, 404
	i32.call	$0=, memset@FUNCTION, $pop0, $pop4, $pop29
	i32.const	$push5=, data_tmp
	i32.const	$push28=, 85
	i32.const	$push27=, 404
	i32.call	$1=, memset@FUNCTION, $pop5, $pop28, $pop27
	i32.const	$push26=, 0
	i32.const	$push25=, 0
	i32.load	$push24=, fetch.fetch_count($pop25)
	tee_local	$push23=, $3=, $pop24
	i32.const	$push22=, 1
	i32.add 	$push6=, $pop23, $pop22
	i32.store	$discard=, fetch.fetch_count($pop26), $pop6
	i32.const	$push21=, 0
	i32.const	$push7=, 100
	i32.const	$push20=, 0
	i32.const	$push19=, 0
	i32.gt_s	$push18=, $3, $pop19
	tee_local	$push17=, $2=, $pop18
	i32.select	$push8=, $pop7, $pop20, $pop17
	i32.store	$discard=, sqlca($pop21), $pop8
	block
	br_if   	0, $2           # 0: down to label3
# BB#1:                                 # %while.body.lr.ph.i
	copy_local	$2=, $0
.LBB3_2:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$push36=, 404
	i32.call	$discard=, memcpy@FUNCTION, $2, $1, $pop36
	i32.const	$push35=, 85
	i32.const	$push34=, 404
	i32.call	$discard=, memset@FUNCTION, $1, $pop35, $pop34
	i32.const	$push33=, 1
	i32.add 	$3=, $3, $pop33
	i32.const	$push32=, 404
	i32.add 	$push2=, $2, $pop32
	copy_local	$2=, $pop2
	i32.const	$push31=, 1
	i32.lt_s	$push9=, $3, $pop31
	br_if   	0, $pop9        # 0: up to label4
# BB#3:                                 # %while.cond.while.end_crit_edge.i
	end_loop                        # label5:
	i32.const	$push10=, 0
	i32.const	$push11=, 2
	i32.store	$discard=, fetch.fetch_count($pop10), $pop11
	i32.const	$push37=, 0
	i32.const	$push12=, 100
	i32.store	$discard=, sqlca($pop37), $pop12
.LBB3_4:                                # %load_data.exit
	end_block                       # label3:
	block
	i32.load	$push13=, 0($0)
	i32.const	$push14=, 1431655765
	i32.ne  	$push15=, $pop13, $pop14
	br_if   	0, $pop15       # 0: down to label6
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
