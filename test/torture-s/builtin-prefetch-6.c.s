	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/builtin-prefetch-6.c"
	.section	.text.init_addrs,"ax",@progbits
	.hidden	init_addrs
	.globl	init_addrs
	.type	init_addrs,@function
init_addrs:                             # @init_addrs
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i64.const	$push0=, 8589934593
	i64.store	bad_addr($pop1), $pop0
	i32.const	$push33=, 0
	i64.const	$push2=, 34359738372
	i64.store	bad_addr+8($pop33), $pop2
	i32.const	$push32=, 0
	i64.const	$push3=, 137438953488
	i64.store	bad_addr+16($pop32), $pop3
	i32.const	$push31=, 0
	i64.const	$push4=, 549755813952
	i64.store	bad_addr+24($pop31), $pop4
	i32.const	$push30=, 0
	i64.const	$push5=, 2199023255808
	i64.store	bad_addr+32($pop30), $pop5
	i32.const	$push29=, 0
	i64.const	$push6=, 8796093023232
	i64.store	bad_addr+40($pop29), $pop6
	i32.const	$push28=, 0
	i64.const	$push7=, 35184372092928
	i64.store	bad_addr+48($pop28), $pop7
	i32.const	$push27=, 0
	i64.const	$push8=, 140737488371712
	i64.store	bad_addr+56($pop27), $pop8
	i32.const	$push26=, 0
	i64.const	$push9=, 562949953486848
	i64.store	bad_addr+64($pop26), $pop9
	i32.const	$push25=, 0
	i64.const	$push10=, 2251799813947392
	i64.store	bad_addr+72($pop25), $pop10
	i32.const	$push24=, 0
	i64.const	$push11=, 9007199255789568
	i64.store	bad_addr+80($pop24), $pop11
	i32.const	$push23=, 0
	i64.const	$push12=, 36028797023158272
	i64.store	bad_addr+88($pop23), $pop12
	i32.const	$push22=, 0
	i64.const	$push13=, 144115188092633088
	i64.store	bad_addr+96($pop22), $pop13
	i32.const	$push21=, 0
	i64.const	$push14=, 576460752370532352
	i64.store	bad_addr+104($pop21), $pop14
	i32.const	$push20=, 0
	i64.const	$push15=, 2305843009482129408
	i64.store	bad_addr+112($pop20), $pop15
	i32.const	$push19=, 0
	i64.const	$push16=, -9223372035781033984
	i64.store	bad_addr+120($pop19), $pop16
	i32.const	$push18=, 0
	i32.const	$push17=, 33
	i32.store	arr_used($pop18), $pop17
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	init_addrs, .Lfunc_end0-init_addrs

	.section	.text.prefetch_for_read,"ax",@progbits
	.hidden	prefetch_for_read
	.globl	prefetch_for_read
	.type	prefetch_for_read,@function
prefetch_for_read:                      # @prefetch_for_read
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, -260
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push2=, 4
	i32.add 	$push1=, $0, $pop2
	tee_local	$push0=, $0=, $pop1
	br_if   	0, $pop0        # 0: up to label0
# BB#2:                                 # %for.end
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	prefetch_for_read, .Lfunc_end1-prefetch_for_read

	.section	.text.prefetch_for_write,"ax",@progbits
	.hidden	prefetch_for_write
	.globl	prefetch_for_write
	.type	prefetch_for_write,@function
prefetch_for_write:                     # @prefetch_for_write
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, -260
.LBB2_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push2=, 4
	i32.add 	$push1=, $0, $pop2
	tee_local	$push0=, $0=, $pop1
	br_if   	0, $pop0        # 0: up to label1
# BB#2:                                 # %for.end
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	prefetch_for_write, .Lfunc_end2-prefetch_for_write

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i64.const	$push0=, 8589934593
	i64.store	bad_addr($pop1), $pop0
	i32.const	$push36=, 0
	i64.const	$push2=, 34359738372
	i64.store	bad_addr+8($pop36), $pop2
	i32.const	$push35=, 0
	i64.const	$push3=, 137438953488
	i64.store	bad_addr+16($pop35), $pop3
	i32.const	$push34=, 0
	i64.const	$push4=, 549755813952
	i64.store	bad_addr+24($pop34), $pop4
	i32.const	$push33=, 0
	i64.const	$push5=, 2199023255808
	i64.store	bad_addr+32($pop33), $pop5
	i32.const	$push32=, 0
	i64.const	$push6=, 8796093023232
	i64.store	bad_addr+40($pop32), $pop6
	i32.const	$push31=, 0
	i64.const	$push7=, 35184372092928
	i64.store	bad_addr+48($pop31), $pop7
	i32.const	$push30=, 0
	i64.const	$push8=, 140737488371712
	i64.store	bad_addr+56($pop30), $pop8
	i32.const	$push29=, 0
	i64.const	$push9=, 562949953486848
	i64.store	bad_addr+64($pop29), $pop9
	i32.const	$push28=, 0
	i64.const	$push10=, 2251799813947392
	i64.store	bad_addr+72($pop28), $pop10
	i32.const	$push27=, 0
	i64.const	$push11=, 9007199255789568
	i64.store	bad_addr+80($pop27), $pop11
	i32.const	$push26=, 0
	i64.const	$push12=, 36028797023158272
	i64.store	bad_addr+88($pop26), $pop12
	i32.const	$push25=, 0
	i64.const	$push13=, 144115188092633088
	i64.store	bad_addr+96($pop25), $pop13
	i32.const	$push24=, 0
	i64.const	$push14=, 576460752370532352
	i64.store	bad_addr+104($pop24), $pop14
	i32.const	$push23=, 0
	i64.const	$push15=, 2305843009482129408
	i64.store	bad_addr+112($pop23), $pop15
	i32.const	$push22=, 0
	i64.const	$push16=, -9223372035781033984
	i64.store	bad_addr+120($pop22), $pop16
	i32.const	$push21=, 0
	i32.const	$push17=, 33
	i32.store	arr_used($pop21), $pop17
	i32.const	$0=, 4
.LBB3_1:                                # %for.body.i.for.body.i_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push40=, 4
	i32.add 	$push39=, $0, $pop40
	tee_local	$push38=, $0=, $pop39
	i32.const	$push37=, 260
	i32.ne  	$push18=, $pop38, $pop37
	br_if   	0, $pop18       # 0: up to label2
# BB#2:                                 # %for.body.i5.preheader
	end_loop
	i32.const	$0=, 4
.LBB3_3:                                # %for.body.i5.for.body.i5_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.const	$push44=, 4
	i32.add 	$push43=, $0, $pop44
	tee_local	$push42=, $0=, $pop43
	i32.const	$push41=, 260
	i32.ne  	$push19=, $pop42, $pop41
	br_if   	0, $pop19       # 0: up to label3
# BB#4:                                 # %prefetch_for_write.exit
	end_loop
	i32.const	$push20=, 0
	call    	exit@FUNCTION, $pop20
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.hidden	bad_addr                # @bad_addr
	.type	bad_addr,@object
	.section	.bss.bad_addr,"aw",@nobits
	.globl	bad_addr
	.p2align	4
bad_addr:
	.skip	260
	.size	bad_addr, 260

	.hidden	arr_used                # @arr_used
	.type	arr_used,@object
	.section	.bss.arr_used,"aw",@nobits
	.globl	arr_used
	.p2align	2
arr_used:
	.int32	0                       # 0x0
	.size	arr_used, 4


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	exit, void, i32
