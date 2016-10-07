	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990628-1.c"
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
	i32.store	fetch.fetch_count($pop3), $pop5
	i32.const	$push11=, 0
	i32.const	$push7=, 100
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.gt_s	$push6=, $0, $pop9
	i32.select	$push8=, $pop7, $pop10, $pop6
	i32.store	sqlca($pop11), $pop8
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
	i32.const	$push0=, 0
	i32.const	$push26=, 404
	i32.call	$push25=, malloc@FUNCTION, $pop26
	tee_local	$push24=, $3=, $pop25
	i32.store	data_ptr($pop0), $pop24
	i32.const	$push1=, 170
	i32.const	$push23=, 404
	i32.call	$drop=, memset@FUNCTION, $3, $pop1, $pop23
	i32.const	$push2=, data_tmp
	i32.const	$push22=, 85
	i32.const	$push21=, 404
	i32.call	$0=, memset@FUNCTION, $pop2, $pop22, $pop21
	i32.const	$push20=, 0
	i32.const	$push19=, 0
	i32.load	$push18=, fetch.fetch_count($pop19)
	tee_local	$push17=, $2=, $pop18
	i32.const	$push16=, 1
	i32.add 	$push3=, $pop17, $pop16
	i32.store	fetch.fetch_count($pop20), $pop3
	i32.const	$push15=, 0
	i32.const	$push4=, 100
	i32.const	$push14=, 0
	i32.const	$push13=, 0
	i32.gt_s	$push12=, $2, $pop13
	tee_local	$push11=, $1=, $pop12
	i32.select	$push5=, $pop4, $pop14, $pop11
	i32.store	sqlca($pop15), $pop5
	block   	
	br_if   	0, $1           # 0: down to label0
.LBB2_1:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push34=, 404
	i32.call	$drop=, memcpy@FUNCTION, $3, $0, $pop34
	i32.const	$push33=, 85
	i32.const	$push32=, 404
	i32.call	$drop=, memset@FUNCTION, $0, $pop33, $pop32
	i32.const	$push31=, 404
	i32.add 	$3=, $3, $pop31
	i32.const	$push30=, 1
	i32.add 	$push29=, $2, $pop30
	tee_local	$push28=, $2=, $pop29
	i32.const	$push27=, 1
	i32.lt_s	$push6=, $pop28, $pop27
	br_if   	0, $pop6        # 0: up to label1
# BB#2:                                 # %while.cond.while.end_crit_edge
	end_loop
	i32.const	$push8=, 0
	i32.const	$push7=, 100
	i32.store	sqlca($pop8), $pop7
	i32.const	$push35=, 0
	i32.const	$push9=, 1
	i32.add 	$push10=, $2, $pop9
	i32.store	fetch.fetch_count($pop35), $pop10
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
	i32.const	$push0=, 0
	i32.const	$push29=, 404
	i32.call	$push28=, malloc@FUNCTION, $pop29
	tee_local	$push27=, $2=, $pop28
	i32.store	data_ptr($pop0), $pop27
	i32.const	$push1=, 170
	i32.const	$push26=, 404
	i32.call	$0=, memset@FUNCTION, $2, $pop1, $pop26
	i32.const	$push2=, data_tmp
	i32.const	$push25=, 85
	i32.const	$push24=, 404
	i32.call	$1=, memset@FUNCTION, $pop2, $pop25, $pop24
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i32.load	$push21=, fetch.fetch_count($pop22)
	tee_local	$push20=, $2=, $pop21
	i32.const	$push19=, 1
	i32.add 	$push3=, $pop20, $pop19
	i32.store	fetch.fetch_count($pop23), $pop3
	i32.const	$push18=, 0
	i32.const	$push4=, 100
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.gt_s	$push15=, $2, $pop16
	tee_local	$push14=, $3=, $pop15
	i32.select	$push5=, $pop4, $pop17, $pop14
	i32.store	sqlca($pop18), $pop5
	block   	
	br_if   	0, $3           # 0: down to label2
# BB#1:                                 # %while.body.lr.ph.i
	copy_local	$3=, $0
.LBB3_2:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
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
	i32.lt_s	$push6=, $pop31, $pop30
	br_if   	0, $pop6        # 0: up to label3
# BB#3:                                 # %while.cond.while.end_crit_edge.i
	end_loop
	i32.const	$push8=, 0
	i32.const	$push7=, 100
	i32.store	sqlca($pop8), $pop7
	i32.const	$push38=, 0
	i32.const	$push9=, 2
	i32.store	fetch.fetch_count($pop38), $pop9
.LBB3_4:                                # %load_data.exit
	end_block                       # label2:
	block   	
	i32.load	$push10=, 0($0)
	i32.const	$push11=, 1431655765
	i32.ne  	$push12=, $pop10, $pop11
	br_if   	0, $pop12       # 0: down to label4
# BB#5:                                 # %if.end
	i32.const	$push13=, 0
	call    	exit@FUNCTION, $pop13
	unreachable
.LBB3_6:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	fetch.fetch_count,@object # @fetch.fetch_count
	.section	.bss.fetch.fetch_count,"aw",@nobits
	.p2align	2
fetch.fetch_count:
	.int32	0                       # 0x0
	.size	fetch.fetch_count, 4

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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	malloc, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
