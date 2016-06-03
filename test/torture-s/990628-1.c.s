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
                                        # fallthrough-return: $pop0
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
	i32.const	$push2=, data_tmp
	i32.const	$push1=, 85
	i32.const	$push0=, 404
	i32.call	$drop=, memset@FUNCTION, $pop2, $pop1, $pop0
	i32.const	$push3=, 0
	i32.const	$push14=, 0
	i32.load	$push13=, fetch.fetch_count($pop14)
	tee_local	$push12=, $0=, $pop13
	i32.const	$push4=, 1
	i32.add 	$push5=, $pop12, $pop4
	i32.store	$drop=, fetch.fetch_count($pop3), $pop5
	i32.const	$push11=, 0
	i32.const	$push7=, 100
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.gt_s	$push6=, $0, $pop9
	i32.select	$push8=, $pop7, $pop10, $pop6
	i32.store	$drop=, sqlca($pop11), $pop8
                                        # fallthrough-return
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
	i32.const	$push1=, 0
	i32.const	$push27=, 404
	i32.call	$push26=, malloc@FUNCTION, $pop27
	tee_local	$push25=, $3=, $pop26
	i32.store	$push0=, data_ptr($pop1), $pop25
	i32.const	$push2=, 170
	i32.const	$push24=, 404
	i32.call	$drop=, memset@FUNCTION, $pop0, $pop2, $pop24
	i32.const	$push3=, data_tmp
	i32.const	$push23=, 85
	i32.const	$push22=, 404
	i32.call	$0=, memset@FUNCTION, $pop3, $pop23, $pop22
	i32.const	$push21=, 0
	i32.const	$push20=, 0
	i32.load	$push19=, fetch.fetch_count($pop20)
	tee_local	$push18=, $2=, $pop19
	i32.const	$push17=, 1
	i32.add 	$push4=, $pop18, $pop17
	i32.store	$drop=, fetch.fetch_count($pop21), $pop4
	i32.const	$push16=, 0
	i32.const	$push5=, 100
	i32.const	$push15=, 0
	i32.const	$push14=, 0
	i32.gt_s	$push13=, $2, $pop14
	tee_local	$push12=, $1=, $pop13
	i32.select	$push6=, $pop5, $pop15, $pop12
	i32.store	$drop=, sqlca($pop16), $pop6
	block
	br_if   	0, $1           # 0: down to label0
.LBB2_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push35=, 404
	i32.call	$drop=, memcpy@FUNCTION, $3, $0, $pop35
	i32.const	$push34=, 85
	i32.const	$push33=, 404
	i32.call	$drop=, memset@FUNCTION, $0, $pop34, $pop33
	i32.const	$push32=, 404
	i32.add 	$3=, $3, $pop32
	i32.const	$push31=, 1
	i32.add 	$push30=, $2, $pop31
	tee_local	$push29=, $2=, $pop30
	i32.const	$push28=, 1
	i32.lt_s	$push7=, $pop29, $pop28
	br_if   	0, $pop7        # 0: up to label1
# BB#2:                                 # %while.cond.while.end_crit_edge
	end_loop                        # label2:
	i32.const	$push9=, 0
	i32.const	$push8=, 100
	i32.store	$drop=, sqlca($pop9), $pop8
	i32.const	$push36=, 0
	i32.const	$push10=, 1
	i32.add 	$push11=, $2, $pop10
	i32.store	$drop=, fetch.fetch_count($pop36), $pop11
.LBB2_3:                                # %while.end
	end_block                       # label0:
                                        # fallthrough-return
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
	i32.const	$push2=, 0
	i32.const	$push29=, 404
	i32.call	$push1=, malloc@FUNCTION, $pop29
	i32.store	$push0=, data_ptr($pop2), $pop1
	i32.const	$push3=, 170
	i32.const	$push28=, 404
	i32.call	$0=, memset@FUNCTION, $pop0, $pop3, $pop28
	i32.const	$push4=, data_tmp
	i32.const	$push27=, 85
	i32.const	$push26=, 404
	i32.call	$1=, memset@FUNCTION, $pop4, $pop27, $pop26
	i32.const	$push25=, 0
	i32.const	$push24=, 0
	i32.load	$push23=, fetch.fetch_count($pop24)
	tee_local	$push22=, $2=, $pop23
	i32.const	$push21=, 1
	i32.add 	$push5=, $pop22, $pop21
	i32.store	$drop=, fetch.fetch_count($pop25), $pop5
	i32.const	$push20=, 0
	i32.const	$push6=, 100
	i32.const	$push19=, 0
	i32.const	$push18=, 0
	i32.gt_s	$push17=, $2, $pop18
	tee_local	$push16=, $3=, $pop17
	i32.select	$push7=, $pop6, $pop19, $pop16
	i32.store	$drop=, sqlca($pop20), $pop7
	block
	br_if   	0, $3           # 0: down to label3
# BB#1:                                 # %while.body.lr.ph.i
	copy_local	$3=, $0
.LBB3_2:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.const	$push37=, 404
	i32.call	$drop=, memcpy@FUNCTION, $3, $1, $pop37
	i32.const	$push36=, 85
	i32.const	$push35=, 404
	i32.call	$drop=, memset@FUNCTION, $1, $pop36, $pop35
	i32.const	$push34=, 404
	i32.add 	$3=, $3, $pop34
	i32.const	$push33=, 1
	i32.add 	$push32=, $2, $pop33
	tee_local	$push31=, $2=, $pop32
	i32.const	$push30=, 1
	i32.lt_s	$push8=, $pop31, $pop30
	br_if   	0, $pop8        # 0: up to label4
# BB#3:                                 # %while.cond.while.end_crit_edge.i
	end_loop                        # label5:
	i32.const	$push10=, 0
	i32.const	$push9=, 100
	i32.store	$drop=, sqlca($pop10), $pop9
	i32.const	$push38=, 0
	i32.const	$push11=, 2
	i32.store	$drop=, fetch.fetch_count($pop38), $pop11
.LBB3_4:                                # %load_data.exit
	end_block                       # label3:
	block
	i32.load	$push12=, 0($0)
	i32.const	$push13=, 1431655765
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label6
# BB#5:                                 # %if.end
	i32.const	$push15=, 0
	call    	exit@FUNCTION, $pop15
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
	.functype	malloc, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
