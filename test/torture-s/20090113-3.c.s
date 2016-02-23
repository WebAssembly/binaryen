	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20090113-3.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push12=, __stack_pointer
	i32.load	$push13=, 0($pop12)
	i32.const	$push14=, 48
	i32.sub 	$6=, $pop13, $pop14
	i32.const	$push15=, __stack_pointer
	i32.store	$discard=, 0($pop15), $6
	i32.const	$push2=, 16
	i32.const	$1=, 24
	i32.add 	$1=, $6, $1
	i32.add 	$push3=, $1, $pop2
	i32.const	$push0=, 0
	i32.load	$push1=, .Lmain.elem+16($pop0)
	i32.store	$discard=, 0($pop3):p2align=3, $pop1
	i32.const	$push5=, 8
	i32.const	$2=, 24
	i32.add 	$2=, $6, $2
	i32.add 	$push6=, $2, $pop5
	i32.const	$push11=, 0
	i64.load	$push4=, .Lmain.elem+8($pop11):p2align=2
	i64.store	$discard=, 0($pop6), $pop4
	i32.const	$push10=, 0
	i64.load	$push7=, .Lmain.elem($pop10):p2align=2
	i64.store	$discard=, 24($6), $pop7
	i32.const	$3=, 24
	i32.add 	$3=, $6, $3
	i32.store	$discard=, 8($6):p2align=3, $3
	i32.const	$4=, 24
	i32.add 	$4=, $6, $4
	i32.store	$discard=, 12($6), $4
	i32.const	$push9=, 0
	i32.store	$push8=, 16($6):p2align=3, $pop9
	i32.store	$0=, 20($6), $pop8
	i32.const	$5=, 8
	i32.add 	$5=, $6, $5
	call    	foobar@FUNCTION, $5
	i32.const	$push16=, 48
	i32.add 	$6=, $6, $pop16
	i32.const	$push17=, __stack_pointer
	i32.store	$discard=, 0($pop17), $6
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.foobar,"ax",@progbits
	.type	foobar,@function
foobar:                                 # @foobar
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push31=, __stack_pointer
	i32.load	$push32=, 0($pop31)
	i32.const	$push33=, 32
	i32.sub 	$10=, $pop32, $pop33
	i32.const	$push34=, __stack_pointer
	i32.store	$discard=, 0($pop34), $10
	i32.const	$5=, 16
	i32.add 	$5=, $10, $5
	i32.const	$6=, 12
	i32.add 	$6=, $10, $6
	call    	bmp_iter_set_init@FUNCTION, $5, $0, $6
	i32.load	$2=, 24($10):p2align=3
	i32.load	$1=, 16($10):p2align=3
	i32.load	$0=, 28($10)
.LBB1_1:                                # %for.cond
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_3 Depth 2
                                        #     Child Loop BB1_6 Depth 2
                                        #       Child Loop BB1_8 Depth 3
                                        #     Child Loop BB1_12 Depth 2
	loop                            # label0:
	block
	block
	i32.const	$push37=, 0
	i32.eq  	$push38=, $0, $pop37
	br_if   	0, $pop38       # 0: down to label3
# BB#2:                                 # %while.cond.preheader.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push12=, 1
	i32.and 	$push2=, $0, $pop12
	br_if   	1, $pop2        # 1: down to label2
.LBB1_3:                                # %while.body.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label4:
	i32.const	$push14=, 1
	i32.shr_u	$0=, $0, $pop14
	i32.const	$push13=, 1
	i32.and 	$push3=, $0, $pop13
	i32.const	$push39=, 0
	i32.eq  	$push40=, $pop3, $pop39
	br_if   	0, $pop40       # 0: up to label4
# BB#4:                                 # %while.cond.return.loopexit61_crit_edge.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label5:
	i32.const	$push28=, 12
	i32.const	$9=, 16
	i32.add 	$9=, $10, $9
	i32.add 	$push4=, $9, $pop28
	i32.store	$discard=, 0($pop4), $0
	br      	1               # 1: down to label2
.LBB1_5:                                # %if.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label3:
	i32.const	$push15=, 1
	i32.add 	$2=, $2, $pop15
.LBB1_6:                                # %while.cond7.i.outer
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_8 Depth 3
	loop                            # label6:
	block
	i32.const	$push16=, 2
	i32.eq  	$push5=, $2, $pop16
	br_if   	0, $pop5        # 0: down to label8
# BB#7:                                 # %while.body9.i.preheader
                                        #   in Loop: Header=BB1_6 Depth=2
	i32.const	$push18=, 2
	i32.shl 	$push6=, $2, $pop18
	i32.add 	$push7=, $1, $pop6
	i32.const	$push17=, 12
	i32.add 	$3=, $pop7, $pop17
.LBB1_8:                                # %while.body9.i
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_6 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label9:
	i32.const	$push21=, 12
	i32.const	$7=, 16
	i32.add 	$7=, $10, $7
	i32.add 	$push20=, $7, $pop21
	tee_local	$push19=, $4=, $pop20
	i32.load	$push0=, 0($3)
	i32.store	$0=, 0($pop19), $pop0
	br_if   	4, $0           # 4: down to label7
# BB#9:                                 # %if.end26.i
                                        #   in Loop: Header=BB1_8 Depth=3
	i32.const	$push27=, 1
	i32.add 	$2=, $2, $pop27
	i32.const	$push26=, 4
	i32.add 	$3=, $3, $pop26
	i32.const	$push25=, 2
	i32.ne  	$push11=, $2, $pop25
	br_if   	0, $pop11       # 0: up to label9
.LBB1_10:                               # %while.end30.i
                                        #   in Loop: Header=BB1_6 Depth=2
	end_loop                        # label10:
	end_block                       # label8:
	i32.load	$1=, 0($1)
	i32.const	$2=, 0
	br_if   	0, $1           # 0: up to label6
	br      	4               # 4: down to label1
.LBB1_11:                               # %while.cond16.preheader.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label7:
	i32.const	$push22=, 1
	i32.and 	$push8=, $0, $pop22
	br_if   	0, $pop8        # 0: down to label2
.LBB1_12:                               # %while.body21.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label11:
	i32.const	$push24=, 1
	i32.shr_u	$0=, $0, $pop24
	i32.const	$push23=, 1
	i32.and 	$push9=, $0, $pop23
	i32.const	$push41=, 0
	i32.eq  	$push42=, $pop9, $pop41
	br_if   	0, $pop42       # 0: up to label11
# BB#13:                                # %while.cond16.return.loopexit_crit_edge.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label12:
	i32.store	$discard=, 0($4), $0
.LBB1_14:                               # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.const	$push30=, 12
	i32.const	$8=, 16
	i32.add 	$8=, $10, $8
	i32.add 	$push10=, $8, $pop30
	i32.const	$push29=, 1
	i32.shr_u	$push1=, $0, $pop29
	i32.store	$0=, 0($pop10), $pop1
	br      	0               # 0: up to label0
.LBB1_15:                               # %for.end
	end_loop                        # label1:
	i32.const	$push35=, 32
	i32.add 	$10=, $10, $pop35
	i32.const	$push36=, __stack_pointer
	i32.store	$discard=, 0($pop36), $10
	return
	.endfunc
.Lfunc_end1:
	.size	foobar, .Lfunc_end1-foobar

	.section	.text.bmp_iter_set_init,"ax",@progbits
	.type	bmp_iter_set_init,@function
bmp_iter_set_init:                      # @bmp_iter_set_init
	.param  	i32, i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($1)
	i32.store	$1=, 0($0), $pop0
	i32.const	$push1=, 0
	i32.store	$3=, 4($0), $pop1
	block
	br_if   	0, $1           # 0: down to label13
# BB#1:                                 # %if.then
	i32.const	$push2=, bitmap_zero_bits
	i32.store	$1=, 0($0), $pop2
.LBB2_2:                                # %while.end
	end_block                       # label13:
	i32.load	$4=, 8($1)
	i32.load	$1=, 12($1)
	i32.store	$push5=, 8($0), $3
	i32.store	$push6=, 12($0), $1
	i32.eq  	$push7=, $pop5, $pop6
	i32.const	$push3=, 7
	i32.shl 	$push4=, $4, $pop3
	i32.or  	$push8=, $pop7, $pop4
	i32.store	$discard=, 0($2), $pop8
	return
	.endfunc
.Lfunc_end2:
	.size	bmp_iter_set_init, .Lfunc_end2-bmp_iter_set_init

	.type	.Lmain.elem,@object     # @main.elem
	.section	.rodata..Lmain.elem,"a",@progbits
	.p2align	2
.Lmain.elem:
	.int32	0
	.int32	0
	.int32	0                       # 0x0
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.size	.Lmain.elem, 20

	.hidden	bitmap_zero_bits        # @bitmap_zero_bits
	.type	bitmap_zero_bits,@object
	.section	.bss.bitmap_zero_bits,"aw",@nobits
	.globl	bitmap_zero_bits
	.p2align	2
bitmap_zero_bits:
	.skip	20
	.size	bitmap_zero_bits, 20


	.ident	"clang version 3.9.0 "
