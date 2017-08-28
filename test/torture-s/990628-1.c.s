	.text
	.file	"990628-1.c"
	.section	.text.num_records,"ax",@progbits
	.hidden	num_records             # -- Begin function num_records
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
                                        # -- End function
	.section	.text.fetch,"ax",@progbits
	.hidden	fetch                   # -- Begin function fetch
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
                                        # -- End function
	.section	.text.load_data,"ax",@progbits
	.hidden	load_data               # -- Begin function load_data
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
	i32.eqz 	$push36=, $1
	br_if   	0, $pop36       # 0: down to label0
# BB#1:                                 # %while.end
	return
.LBB2_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	end_block                       # label0:
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
# BB#3:                                 # %while.cond.while.end_crit_edge
	end_loop
	i32.const	$push8=, 0
	i32.const	$push7=, 100
	i32.store	sqlca($pop8), $pop7
	i32.const	$push35=, 0
	i32.const	$push9=, 1
	i32.add 	$push10=, $2, $pop9
	i32.store	fetch.fetch_count($pop35), $pop10
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	load_data, .Lfunc_end2-load_data
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push27=, 404
	i32.call	$push26=, malloc@FUNCTION, $pop27
	tee_local	$push25=, $1=, $pop26
	i32.store	data_ptr($pop0), $pop25
	i32.const	$push1=, 170
	i32.const	$push24=, 404
	i32.call	$0=, memset@FUNCTION, $1, $pop1, $pop24
	i32.const	$push2=, data_tmp
	i32.const	$push23=, 85
	i32.const	$push22=, 404
	i32.call	$1=, memset@FUNCTION, $pop2, $pop23, $pop22
	i32.const	$push21=, 0
	i32.const	$push20=, 0
	i32.load	$push19=, fetch.fetch_count($pop20)
	tee_local	$push18=, $2=, $pop19
	i32.const	$push17=, 1
	i32.add 	$push3=, $pop18, $pop17
	i32.store	fetch.fetch_count($pop21), $pop3
	i32.const	$push16=, 0
	i32.const	$push4=, 100
	i32.const	$push15=, 0
	i32.const	$push14=, 0
	i32.gt_s	$push13=, $2, $pop14
	tee_local	$push12=, $3=, $pop13
	i32.select	$push5=, $pop4, $pop15, $pop12
	i32.store	sqlca($pop16), $pop5
	block   	
	br_if   	0, $3           # 0: down to label2
# BB#1:                                 # %while.body.lr.ph.i
	copy_local	$3=, $0
.LBB3_2:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push35=, 404
	i32.call	$drop=, memcpy@FUNCTION, $3, $1, $pop35
	i32.const	$push34=, 85
	i32.const	$push33=, 404
	i32.call	$drop=, memset@FUNCTION, $1, $pop34, $pop33
	i32.const	$push32=, 404
	i32.add 	$3=, $3, $pop32
	i32.const	$push31=, 1
	i32.add 	$push30=, $2, $pop31
	tee_local	$push29=, $2=, $pop30
	i32.const	$push28=, 1
	i32.lt_s	$push6=, $pop29, $pop28
	br_if   	0, $pop6        # 0: up to label3
# BB#3:                                 # %load_data.exit
	end_loop
	i32.const	$push37=, 0
	i32.const	$push7=, 100
	i32.store	sqlca($pop37), $pop7
	i32.const	$push36=, 0
	i32.const	$push8=, 2
	i32.store	fetch.fetch_count($pop36), $pop8
	i32.load	$push9=, 0($0)
	i32.const	$push10=, 1431655765
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	0, $pop11       # 0: down to label2
# BB#4:                                 # %if.end
	i32.const	$push38=, 0
	call    	exit@FUNCTION, $pop38
	unreachable
.LBB3_5:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	malloc, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
