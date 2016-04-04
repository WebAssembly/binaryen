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
	i32.load	$push13=, 0($pop12)
	i32.const	$push14=, 48
	i32.sub 	$1=, $pop13, $pop14
	i32.const	$push15=, __stack_pointer
	i32.store	$discard=, 0($pop15), $1
	i32.const	$push19=, 24
	i32.add 	$push20=, $1, $pop19
	i32.const	$push2=, 16
	i32.add 	$push3=, $pop20, $pop2
	i32.const	$push0=, 0
	i32.load	$push1=, .Lmain.elem+16($pop0)
	i32.store	$discard=, 0($pop3):p2align=3, $pop1
	i32.const	$push21=, 24
	i32.add 	$push22=, $1, $pop21
	i32.const	$push5=, 8
	i32.add 	$push6=, $pop22, $pop5
	i32.const	$push11=, 0
	i64.load	$push4=, .Lmain.elem+8($pop11):p2align=2
	i64.store	$discard=, 0($pop6), $pop4
	i32.const	$push10=, 0
	i64.load	$push7=, .Lmain.elem($pop10):p2align=2
	i64.store	$discard=, 24($1), $pop7
	i32.const	$push23=, 24
	i32.add 	$push24=, $1, $pop23
	i32.store	$discard=, 8($1):p2align=3, $pop24
	i32.const	$push25=, 24
	i32.add 	$push26=, $1, $pop25
	i32.store	$discard=, 12($1), $pop26
	i32.const	$push9=, 0
	i32.store	$push8=, 16($1):p2align=3, $pop9
	i32.store	$0=, 20($1), $pop8
	i32.const	$push27=, 8
	i32.add 	$push28=, $1, $pop27
	call    	foobar@FUNCTION, $pop28
	i32.const	$push18=, __stack_pointer
	i32.const	$push16=, 48
	i32.add 	$push17=, $1, $pop16
	i32.store	$discard=, 0($pop18), $pop17
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
	i32.const	$push37=, __stack_pointer
	i32.load	$push38=, 0($pop37)
	i32.const	$push39=, 32
	i32.sub 	$5=, $pop38, $pop39
	i32.const	$push40=, __stack_pointer
	i32.store	$discard=, 0($pop40), $5
	i32.const	$push44=, 16
	i32.add 	$push45=, $5, $pop44
	i32.const	$push46=, 12
	i32.add 	$push47=, $5, $pop46
	call    	bmp_iter_set_init@FUNCTION, $pop45, $0, $pop47
	i32.const	$push48=, 16
	i32.add 	$push49=, $5, $pop48
	i32.const	$push4=, 8
	i32.add 	$2=, $pop49, $pop4
	i32.load	$1=, 16($5):p2align=3
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
	i32.const	$push58=, 0
	i32.eq  	$push59=, $0, $pop58
	br_if   	0, $pop59       # 0: down to label3
# BB#2:                                 # %while.cond.preheader.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push14=, 1
	i32.and 	$push1=, $0, $pop14
	br_if   	1, $pop1        # 1: down to label2
.LBB1_3:                                # %while.body.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label4:
	i32.const	$push16=, 1
	i32.shr_u	$0=, $0, $pop16
	i32.const	$push15=, 1
	i32.and 	$push2=, $0, $pop15
	i32.const	$push60=, 0
	i32.eq  	$push61=, $pop2, $pop60
	br_if   	0, $pop61       # 0: up to label4
# BB#4:                                 # %while.cond.return.loopexit62_crit_edge.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label5:
	i32.const	$push56=, 16
	i32.add 	$push57=, $5, $pop56
	i32.const	$push34=, 12
	i32.add 	$push3=, $pop57, $pop34
	i32.store	$discard=, 0($pop3), $0
	br      	1               # 1: down to label2
.LBB1_5:                                # %if.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label3:
	i32.load	$push5=, 0($2):p2align=3
	i32.const	$push17=, 1
	i32.add 	$0=, $pop5, $pop17
.LBB1_6:                                # %while.body6.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_8 Depth 3
	loop                            # label6:
	block
	i32.const	$push18=, 2
	i32.eq  	$push6=, $0, $pop18
	br_if   	0, $pop6        # 0: down to label8
# BB#7:                                 # %while.body9.i.preheader
                                        #   in Loop: Header=BB1_6 Depth=2
	i32.const	$push20=, 2
	i32.shl 	$push7=, $0, $pop20
	i32.add 	$push8=, $1, $pop7
	i32.const	$push19=, 12
	i32.add 	$3=, $pop8, $pop19
.LBB1_8:                                # %while.body9.i
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_6 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label9:
	i32.load	$push22=, 0($3)
	tee_local	$push21=, $4=, $pop22
	br_if   	4, $pop21       # 4: down to label7
# BB#9:                                 # %if.end26.i
                                        #   in Loop: Header=BB1_8 Depth=3
	i32.const	$push31=, 1
	i32.add 	$0=, $0, $pop31
	i32.const	$push30=, 4
	i32.add 	$3=, $3, $pop30
	i32.const	$push29=, 2
	i32.ne  	$push12=, $0, $pop29
	br_if   	0, $pop12       # 0: up to label9
# BB#10:                                # %while.end30.i.loopexit
                                        #   in Loop: Header=BB1_6 Depth=2
	end_loop                        # label10:
	i32.const	$push50=, 16
	i32.add 	$push51=, $5, $pop50
	i32.const	$push33=, 12
	i32.add 	$push13=, $pop51, $pop33
	i32.const	$push32=, 0
	i32.store	$discard=, 0($pop13), $pop32
.LBB1_11:                               # %while.end30.i
                                        #   in Loop: Header=BB1_6 Depth=2
	end_block                       # label8:
	i32.load	$1=, 0($1)
	i32.const	$0=, 0
	br_if   	0, $1           # 0: up to label6
	br      	4               # 4: down to label1
.LBB1_12:                               # %while.cond16.preheader.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label7:
	i32.store	$discard=, 0($2):p2align=3, $0
	i32.const	$push52=, 16
	i32.add 	$push53=, $5, $pop52
	i32.const	$push26=, 12
	i32.add 	$push25=, $pop53, $pop26
	tee_local	$push24=, $3=, $pop25
	i32.store	$0=, 0($pop24), $4
	i32.const	$push23=, 1
	i32.and 	$push9=, $0, $pop23
	br_if   	0, $pop9        # 0: down to label2
.LBB1_13:                               # %while.body21.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label11:
	i32.const	$push28=, 1
	i32.shr_u	$0=, $0, $pop28
	i32.const	$push27=, 1
	i32.and 	$push10=, $0, $pop27
	i32.const	$push62=, 0
	i32.eq  	$push63=, $pop10, $pop62
	br_if   	0, $pop63       # 0: up to label11
# BB#14:                                # %while.cond16.return.loopexit_crit_edge.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label12:
	i32.store	$discard=, 0($3), $0
.LBB1_15:                               # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.const	$push54=, 16
	i32.add 	$push55=, $5, $pop54
	i32.const	$push36=, 12
	i32.add 	$push11=, $pop55, $pop36
	i32.const	$push35=, 1
	i32.shr_u	$push0=, $0, $pop35
	i32.store	$0=, 0($pop11), $pop0
	br      	0               # 0: up to label0
.LBB1_16:                               # %for.end
	end_loop                        # label1:
	i32.const	$push43=, __stack_pointer
	i32.const	$push41=, 32
	i32.add 	$push42=, $5, $pop41
	i32.store	$discard=, 0($pop43), $pop42
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
	i32.store	$discard=, 8($0), $3
	i32.store	$push5=, 12($0), $1
	i32.eqz 	$push6=, $pop5
	i32.const	$push3=, 7
	i32.shl 	$push4=, $4, $pop3
	i32.or  	$push7=, $pop6, $pop4
	i32.store	$discard=, 0($2), $pop7
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
