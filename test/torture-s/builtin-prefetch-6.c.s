	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/builtin-prefetch-6.c"
	.section	.text.init_addrs,"ax",@progbits
	.hidden	init_addrs
	.globl	init_addrs
	.type	init_addrs,@function
init_addrs:                             # @init_addrs
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i64.const	$push0=, 8589934593
	i64.store	bad_addr($pop1), $pop0
	i32.const	$push55=, 0
	i64.const	$push2=, 34359738372
	i64.store	bad_addr+8($pop55), $pop2
	i32.const	$push54=, 0
	i64.const	$push3=, 137438953488
	i64.store	bad_addr+16($pop54), $pop3
	i32.const	$push53=, 0
	i64.const	$push4=, 549755813952
	i64.store	bad_addr+24($pop53), $pop4
	i32.const	$push52=, 0
	i64.const	$push5=, 2199023255808
	i64.store	bad_addr+32($pop52), $pop5
	i32.const	$push51=, 0
	i32.const	$push6=, 1024
	i32.store	bad_addr+40($pop51), $pop6
	i32.const	$push50=, 0
	i32.const	$push7=, 2048
	i32.store	bad_addr+44($pop50), $pop7
	i32.const	$push49=, 0
	i32.const	$push8=, 4096
	i32.store	bad_addr+48($pop49), $pop8
	i32.const	$push48=, 0
	i32.const	$push9=, 8192
	i32.store	bad_addr+52($pop48), $pop9
	i32.const	$push47=, 0
	i32.const	$push10=, 16384
	i32.store	bad_addr+56($pop47), $pop10
	i32.const	$push46=, 0
	i32.const	$push11=, 32768
	i32.store	bad_addr+60($pop46), $pop11
	i32.const	$push45=, 0
	i32.const	$push12=, 65536
	i32.store	bad_addr+64($pop45), $pop12
	i32.const	$push44=, 0
	i32.const	$push13=, 131072
	i32.store	bad_addr+68($pop44), $pop13
	i32.const	$push43=, 0
	i32.const	$push14=, 262144
	i32.store	bad_addr+72($pop43), $pop14
	i32.const	$push42=, 0
	i32.const	$push15=, 524288
	i32.store	bad_addr+76($pop42), $pop15
	i32.const	$push41=, 0
	i32.const	$push16=, 1048576
	i32.store	bad_addr+80($pop41), $pop16
	i32.const	$push40=, 0
	i32.const	$push17=, 2097152
	i32.store	bad_addr+84($pop40), $pop17
	i32.const	$push39=, 0
	i32.const	$push18=, 4194304
	i32.store	bad_addr+88($pop39), $pop18
	i32.const	$push38=, 0
	i32.const	$push19=, 8388608
	i32.store	bad_addr+92($pop38), $pop19
	i32.const	$push37=, 0
	i32.const	$push20=, 16777216
	i32.store	bad_addr+96($pop37), $pop20
	i32.const	$push36=, 0
	i32.const	$push21=, 33554432
	i32.store	bad_addr+100($pop36), $pop21
	i32.const	$push35=, 0
	i32.const	$push22=, 67108864
	i32.store	bad_addr+104($pop35), $pop22
	i32.const	$push34=, 0
	i32.const	$push23=, 134217728
	i32.store	bad_addr+108($pop34), $pop23
	i32.const	$push33=, 0
	i32.const	$push24=, 268435456
	i32.store	bad_addr+112($pop33), $pop24
	i32.const	$push32=, 0
	i32.const	$push25=, 536870912
	i32.store	bad_addr+116($pop32), $pop25
	i32.const	$push31=, 0
	i32.const	$push26=, 1073741824
	i32.store	bad_addr+120($pop31), $pop26
	i32.const	$push30=, 0
	i32.const	$push27=, -2147483648
	i32.store	bad_addr+124($pop30), $pop27
	i32.const	$push29=, 0
	i32.const	$push28=, 33
	i32.store	arr_used($pop29), $pop28
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
# BB#0:                                 # %entry
	call    	init_addrs@FUNCTION
	call    	prefetch_for_read@FUNCTION
	call    	prefetch_for_write@FUNCTION
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
