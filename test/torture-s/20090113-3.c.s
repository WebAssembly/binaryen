	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20090113-3.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push12=, __stack_pointer
	i32.const	$push9=, __stack_pointer
	i32.load	$push10=, 0($pop9)
	i32.const	$push11=, 48
	i32.sub 	$push22=, $pop10, $pop11
	i32.store	$push27=, 0($pop12), $pop22
	tee_local	$push26=, $1=, $pop27
	i32.const	$push3=, 40
	i32.add 	$push4=, $pop26, $pop3
	i32.const	$push1=, 0
	i32.load	$push2=, .Lmain.elem+16($pop1)
	i32.store	$discard=, 0($pop4), $pop2
	i32.const	$push6=, 32
	i32.add 	$push7=, $1, $pop6
	i32.const	$push25=, 0
	i64.load	$push5=, .Lmain.elem+8($pop25):p2align=2
	i64.store	$discard=, 0($pop7), $pop5
	i32.const	$push24=, 0
	i64.load	$push8=, .Lmain.elem($pop24):p2align=2
	i64.store	$discard=, 24($1), $pop8
	i32.const	$push16=, 24
	i32.add 	$push17=, $1, $pop16
	i32.store	$discard=, 8($1), $pop17
	i32.const	$push18=, 24
	i32.add 	$push19=, $1, $pop18
	i32.store	$discard=, 12($1), $pop19
	i32.const	$push23=, 0
	i32.store	$push0=, 16($1), $pop23
	i32.store	$0=, 20($1), $pop0
	i32.const	$push20=, 8
	i32.add 	$push21=, $1, $pop20
	call    	foobar@FUNCTION, $pop21
	i32.const	$push15=, __stack_pointer
	i32.const	$push13=, 48
	i32.add 	$push14=, $1, $pop13
	i32.store	$discard=, 0($pop15), $pop14
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.foobar,"ax",@progbits
	.type	foobar,@function
foobar:                                 # @foobar
	.param  	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push17=, __stack_pointer
	i32.const	$push14=, __stack_pointer
	i32.load	$push15=, 0($pop14)
	i32.const	$push16=, 32
	i32.sub 	$push33=, $pop15, $pop16
	i32.store	$push35=, 0($pop17), $pop33
	tee_local	$push34=, $5=, $pop35
	i32.const	$push21=, 16
	i32.add 	$push22=, $pop34, $pop21
	i32.const	$push23=, 12
	i32.add 	$push24=, $5, $pop23
	call    	bmp_iter_set_init@FUNCTION, $pop22, $0, $pop24
	i32.const	$push4=, 24
	i32.add 	$2=, $5, $pop4
	i32.load	$1=, 16($5)
	i32.load	$0=, 28($5)
.LBB1_1:                                # %for.cond
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_3 Depth 2
                                        #     Child Loop BB1_6 Depth 2
                                        #       Child Loop BB1_8 Depth 3
                                        #     Child Loop BB1_13 Depth 2
	loop                            # label0:
	block
	block
	i32.eqz 	$push59=, $0
	br_if   	0, $pop59       # 0: down to label3
# BB#2:                                 # %while.cond.preheader.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push38=, 1
	i32.and 	$push1=, $0, $pop38
	br_if   	1, $pop1        # 1: down to label2
.LBB1_3:                                # %while.body.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label4:
	i32.const	$push40=, 1
	i32.shr_u	$0=, $0, $pop40
	i32.const	$push39=, 1
	i32.and 	$push2=, $0, $pop39
	i32.eqz 	$push60=, $pop2
	br_if   	0, $pop60       # 0: up to label4
# BB#4:                                 # %while.cond.return.loopexit62_crit_edge.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label5:
	i32.const	$push31=, 16
	i32.add 	$push32=, $5, $pop31
	i32.const	$push41=, 12
	i32.add 	$push3=, $pop32, $pop41
	i32.store	$discard=, 0($pop3), $0
	br      	1               # 1: down to label2
.LBB1_5:                                # %if.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label3:
	i32.load	$push5=, 0($2)
	i32.const	$push42=, 1
	i32.add 	$4=, $pop5, $pop42
.LBB1_6:                                # %while.body6.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_8 Depth 3
	loop                            # label6:
	block
	i32.const	$push43=, 2
	i32.eq  	$push6=, $4, $pop43
	br_if   	0, $pop6        # 0: down to label8
# BB#7:                                 # %while.body9.i.preheader
                                        #   in Loop: Header=BB1_6 Depth=2
	i32.const	$push45=, 2
	i32.shl 	$push7=, $4, $pop45
	i32.add 	$push8=, $1, $pop7
	i32.const	$push44=, 12
	i32.add 	$3=, $pop8, $pop44
.LBB1_8:                                # %while.body9.i
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_6 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label9:
	i32.load	$push47=, 0($3)
	tee_local	$push46=, $0=, $pop47
	br_if   	4, $pop46       # 4: down to label7
# BB#9:                                 # %if.end26.i
                                        #   in Loop: Header=BB1_8 Depth=3
	i32.const	$push50=, 1
	i32.add 	$4=, $4, $pop50
	i32.const	$push49=, 4
	i32.add 	$3=, $3, $pop49
	i32.const	$push48=, 2
	i32.ne  	$push12=, $4, $pop48
	br_if   	0, $pop12       # 0: up to label9
# BB#10:                                # %while.end30.i.loopexit
                                        #   in Loop: Header=BB1_6 Depth=2
	end_loop                        # label10:
	i32.const	$push25=, 16
	i32.add 	$push26=, $5, $pop25
	i32.const	$push52=, 12
	i32.add 	$push13=, $pop26, $pop52
	i32.const	$push51=, 0
	i32.store	$discard=, 0($pop13), $pop51
.LBB1_11:                               # %while.end30.i
                                        #   in Loop: Header=BB1_6 Depth=2
	end_block                       # label8:
	i32.load	$1=, 0($1)
	i32.const	$4=, 0
	br_if   	0, $1           # 0: up to label6
	br      	4               # 4: down to label1
.LBB1_12:                               # %while.cond16.preheader.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label7:
	i32.store	$discard=, 0($2), $4
	i32.const	$push27=, 16
	i32.add 	$push28=, $5, $pop27
	i32.const	$push56=, 12
	i32.add 	$push55=, $pop28, $pop56
	tee_local	$push54=, $4=, $pop55
	i32.store	$push0=, 0($pop54), $0
	i32.const	$push53=, 1
	i32.and 	$push9=, $pop0, $pop53
	br_if   	0, $pop9        # 0: down to label2
.LBB1_13:                               # %while.body21.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label11:
	i32.const	$push58=, 1
	i32.shr_u	$0=, $0, $pop58
	i32.const	$push57=, 1
	i32.and 	$push10=, $0, $pop57
	i32.eqz 	$push61=, $pop10
	br_if   	0, $pop61       # 0: up to label11
# BB#14:                                # %while.cond16.return.loopexit_crit_edge.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label12:
	i32.store	$discard=, 0($4), $0
.LBB1_15:                               # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.const	$push37=, 1
	i32.shr_u	$0=, $0, $pop37
	i32.const	$push29=, 16
	i32.add 	$push30=, $5, $pop29
	i32.const	$push36=, 12
	i32.add 	$push11=, $pop30, $pop36
	i32.store	$discard=, 0($pop11), $0
	br      	0               # 0: up to label0
.LBB1_16:                               # %for.end
	end_loop                        # label1:
	i32.const	$push20=, __stack_pointer
	i32.const	$push18=, 32
	i32.add 	$push19=, $5, $pop18
	i32.store	$discard=, 0($pop20), $pop19
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
	i32.load	$push7=, 0($1)
	tee_local	$push6=, $1=, $pop7
	i32.store	$3=, 0($0), $pop6
	i32.const	$push1=, 0
	i32.store	$4=, 4($0), $pop1
	block
	br_if   	0, $3           # 0: down to label13
# BB#1:                                 # %if.then
	i32.const	$1=, bitmap_zero_bits
	i32.const	$push8=, bitmap_zero_bits
	i32.store	$discard=, 0($0), $pop8
.LBB2_2:                                # %while.end
	end_block                       # label13:
	i32.load	$3=, 8($1)
	i32.load	$1=, 12($1)
	i32.store	$discard=, 8($0), $4
	i32.store	$push0=, 12($0), $1
	i32.eqz 	$push4=, $pop0
	i32.const	$push2=, 7
	i32.shl 	$push3=, $3, $pop2
	i32.or  	$push5=, $pop4, $pop3
	i32.store	$discard=, 0($2), $pop5
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
