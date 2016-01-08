	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/builtin-prefetch-6.c"
	.section	.text.init_addrs,"ax",@progbits
	.hidden	init_addrs
	.globl	init_addrs
	.type	init_addrs,@function
init_addrs:                             # @init_addrs
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push5=, 1024
	i32.store	$discard=, bad_addr+40($0), $pop5
	i32.const	$push6=, 2048
	i32.store	$discard=, bad_addr+44($0), $pop6
	i32.const	$push7=, 4096
	i32.store	$discard=, bad_addr+48($0), $pop7
	i32.const	$push8=, 8192
	i32.store	$discard=, bad_addr+52($0), $pop8
	i32.const	$push9=, 16384
	i32.store	$discard=, bad_addr+56($0), $pop9
	i32.const	$push10=, 32768
	i32.store	$discard=, bad_addr+60($0), $pop10
	i32.const	$push11=, 65536
	i32.store	$discard=, bad_addr+64($0), $pop11
	i32.const	$push12=, 131072
	i32.store	$discard=, bad_addr+68($0), $pop12
	i32.const	$push13=, 262144
	i32.store	$discard=, bad_addr+72($0), $pop13
	i32.const	$push14=, 524288
	i32.store	$discard=, bad_addr+76($0), $pop14
	i32.const	$push15=, 1048576
	i32.store	$discard=, bad_addr+80($0), $pop15
	i32.const	$push16=, 2097152
	i32.store	$discard=, bad_addr+84($0), $pop16
	i32.const	$push17=, 4194304
	i32.store	$discard=, bad_addr+88($0), $pop17
	i32.const	$push18=, 8388608
	i32.store	$discard=, bad_addr+92($0), $pop18
	i32.const	$push19=, 16777216
	i32.store	$discard=, bad_addr+96($0), $pop19
	i32.const	$push20=, 33554432
	i32.store	$discard=, bad_addr+100($0), $pop20
	i32.const	$push21=, 67108864
	i32.store	$discard=, bad_addr+104($0), $pop21
	i32.const	$push22=, 134217728
	i32.store	$discard=, bad_addr+108($0), $pop22
	i32.const	$push23=, 268435456
	i32.store	$discard=, bad_addr+112($0), $pop23
	i32.const	$push24=, 536870912
	i32.store	$discard=, bad_addr+116($0), $pop24
	i32.const	$push25=, 1073741824
	i32.store	$discard=, bad_addr+120($0), $pop25
	i32.const	$push26=, -2147483648
	i32.store	$discard=, bad_addr+124($0), $pop26
	i32.const	$push27=, 33
	i32.store	$discard=, arr_used($0), $pop27
	i64.const	$push0=, 8589934593
	i64.store	$discard=, bad_addr($0), $pop0
	i64.const	$push1=, 34359738372
	i64.store	$discard=, bad_addr+8($0), $pop1
	i64.const	$push2=, 137438953488
	i64.store	$discard=, bad_addr+16($0), $pop2
	i64.const	$push3=, 549755813952
	i64.store	$discard=, bad_addr+24($0), $pop3
	i64.const	$push4=, 2199023255808
	i64.store	$discard=, bad_addr+32($0), $pop4
	return
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
	loop    	.LBB1_2
	i32.const	$push0=, 4
	i32.add 	$0=, $0, $pop0
	br_if   	$0, .LBB1_1
.LBB1_2:                                # %for.end
	return
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
	loop    	.LBB2_2
	i32.const	$push0=, 4
	i32.add 	$0=, $0, $pop0
	br_if   	$0, .LBB2_1
.LBB2_2:                                # %for.end
	return
.Lfunc_end2:
	.size	prefetch_for_write, .Lfunc_end2-prefetch_for_write

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$push5=, 1024
	i32.store	$discard=, bad_addr+40($1), $pop5
	i32.const	$push6=, 2048
	i32.store	$discard=, bad_addr+44($1), $pop6
	i32.const	$push7=, 4096
	i32.store	$discard=, bad_addr+48($1), $pop7
	i32.const	$push8=, 8192
	i32.store	$discard=, bad_addr+52($1), $pop8
	i32.const	$push9=, 16384
	i32.store	$discard=, bad_addr+56($1), $pop9
	i32.const	$push10=, 32768
	i32.store	$discard=, bad_addr+60($1), $pop10
	i32.const	$push11=, 65536
	i32.store	$discard=, bad_addr+64($1), $pop11
	i32.const	$push12=, 131072
	i32.store	$discard=, bad_addr+68($1), $pop12
	i32.const	$push13=, 262144
	i32.store	$discard=, bad_addr+72($1), $pop13
	i32.const	$push14=, 524288
	i32.store	$discard=, bad_addr+76($1), $pop14
	i32.const	$push15=, 1048576
	i32.store	$discard=, bad_addr+80($1), $pop15
	i32.const	$push16=, 2097152
	i32.store	$discard=, bad_addr+84($1), $pop16
	i32.const	$push17=, 4194304
	i32.store	$discard=, bad_addr+88($1), $pop17
	i32.const	$push18=, 8388608
	i32.store	$discard=, bad_addr+92($1), $pop18
	i32.const	$push19=, 16777216
	i32.store	$discard=, bad_addr+96($1), $pop19
	i32.const	$push20=, 33554432
	i32.store	$discard=, bad_addr+100($1), $pop20
	i32.const	$push21=, 67108864
	i32.store	$discard=, bad_addr+104($1), $pop21
	i32.const	$push22=, 134217728
	i32.store	$discard=, bad_addr+108($1), $pop22
	i32.const	$push23=, 268435456
	i32.store	$discard=, bad_addr+112($1), $pop23
	i32.const	$push24=, 536870912
	i32.store	$discard=, bad_addr+116($1), $pop24
	i32.const	$push25=, 1073741824
	i32.store	$discard=, bad_addr+120($1), $pop25
	i32.const	$push26=, -2147483648
	i32.store	$discard=, bad_addr+124($1), $pop26
	i32.const	$push27=, 33
	i32.store	$discard=, arr_used($1), $pop27
	i64.const	$push0=, 8589934593
	i64.store	$discard=, bad_addr($1), $pop0
	i64.const	$push1=, 34359738372
	i64.store	$discard=, bad_addr+8($1), $pop1
	i64.const	$push2=, 137438953488
	i64.store	$discard=, bad_addr+16($1), $pop2
	i64.const	$push3=, 549755813952
	i64.store	$discard=, bad_addr+24($1), $pop3
	i32.const	$0=, 4
	i64.const	$push4=, 2199023255808
	i64.store	$discard=, bad_addr+32($1), $pop4
	copy_local	$2=, $0
.LBB3_1:                                # %for.body.i5.for.body.i5_crit_edge
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB3_2
	i32.add 	$2=, $2, $0
	i32.const	$3=, -260
	i32.const	$push28=, 260
	i32.ne  	$push29=, $2, $pop28
	br_if   	$pop29, .LBB3_1
.LBB3_2:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB3_3
	i32.const	$push30=, 4
	i32.add 	$3=, $3, $pop30
	br_if   	$3, .LBB3_2
.LBB3_3:                                # %prefetch_for_write.exit
	call    	exit, $1
	unreachable
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.hidden	bad_addr                # @bad_addr
	.type	bad_addr,@object
	.section	.bss.bad_addr,"aw",@nobits
	.globl	bad_addr
	.align	4
bad_addr:
	.skip	260
	.size	bad_addr, 260

	.hidden	arr_used                # @arr_used
	.type	arr_used,@object
	.section	.bss.arr_used,"aw",@nobits
	.globl	arr_used
	.align	2
arr_used:
	.int32	0                       # 0x0
	.size	arr_used, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
