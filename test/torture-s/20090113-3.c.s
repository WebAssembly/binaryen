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
	i32.const	$push12=, 0
	i32.const	$push9=, 0
	i32.load	$push10=, __stack_pointer($pop9)
	i32.const	$push11=, 48
	i32.sub 	$push22=, $pop10, $pop11
	i32.store	$push27=, __stack_pointer($pop12), $pop22
	tee_local	$push26=, $1=, $pop27
	i32.const	$push3=, 40
	i32.add 	$push4=, $pop26, $pop3
	i32.const	$push1=, 0
	i32.load	$push2=, .Lmain.elem+16($pop1)
	i32.store	$drop=, 0($pop4), $pop2
	i32.const	$push6=, 32
	i32.add 	$push7=, $1, $pop6
	i32.const	$push25=, 0
	i64.load	$push5=, .Lmain.elem+8($pop25):p2align=2
	i64.store	$drop=, 0($pop7), $pop5
	i32.const	$push24=, 0
	i64.load	$push8=, .Lmain.elem($pop24):p2align=2
	i64.store	$drop=, 24($1), $pop8
	i32.const	$push23=, 0
	i32.store	$push0=, 16($1), $pop23
	i32.store	$0=, 20($1), $pop0
	i32.const	$push16=, 24
	i32.add 	$push17=, $1, $pop16
	i32.store	$drop=, 12($1), $pop17
	i32.const	$push18=, 24
	i32.add 	$push19=, $1, $pop18
	i32.store	$drop=, 8($1), $pop19
	i32.const	$push20=, 8
	i32.add 	$push21=, $1, $pop20
	call    	foobar@FUNCTION, $pop21
	i32.const	$push15=, 0
	i32.const	$push13=, 48
	i32.add 	$push14=, $1, $pop13
	i32.store	$drop=, __stack_pointer($pop15), $pop14
	copy_local	$push28=, $0
                                        # fallthrough-return: $pop28
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.foobar,"ax",@progbits
	.type	foobar,@function
foobar:                                 # @foobar
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, 0
	i32.const	$push13=, 0
	i32.load	$push14=, __stack_pointer($pop13)
	i32.const	$push15=, 32
	i32.sub 	$push32=, $pop14, $pop15
	i32.store	$push34=, __stack_pointer($pop16), $pop32
	tee_local	$push33=, $1=, $pop34
	i32.const	$push20=, 16
	i32.add 	$push21=, $pop33, $pop20
	i32.const	$push22=, 12
	i32.add 	$push23=, $1, $pop22
	call    	bmp_iter_set_init@FUNCTION, $pop21, $0, $pop23
	i32.load	$0=, 28($1)
	i32.load	$6=, 16($1)
	i32.const	$push3=, 24
	i32.add 	$2=, $1, $pop3
.LBB1_1:                                # %for.cond
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_3 Depth 2
                                        #     Child Loop BB1_6 Depth 2
                                        #       Child Loop BB1_8 Depth 3
                                        #     Child Loop BB1_13 Depth 2
	loop                            # label0:
	block
	block
	i32.eqz 	$push68=, $0
	br_if   	0, $pop68       # 0: down to label3
# BB#2:                                 # %while.cond.preheader.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push39=, 1
	i32.and 	$push0=, $0, $pop39
	br_if   	1, $pop0        # 1: down to label2
.LBB1_3:                                # %while.body.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label4:
	i32.const	$push43=, 1
	i32.shr_u	$push42=, $0, $pop43
	tee_local	$push41=, $0=, $pop42
	i32.const	$push40=, 1
	i32.and 	$push1=, $pop41, $pop40
	i32.eqz 	$push69=, $pop1
	br_if   	0, $pop69       # 0: up to label4
# BB#4:                                 # %while.cond.return.loopexit62_crit_edge.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label5:
	i32.const	$push30=, 16
	i32.add 	$push31=, $1, $pop30
	i32.const	$push44=, 12
	i32.add 	$push2=, $pop31, $pop44
	i32.store	$drop=, 0($pop2), $0
	br      	1               # 1: down to label2
.LBB1_5:                                # %if.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label3:
	i32.load	$push4=, 0($2)
	i32.const	$push45=, 1
	i32.add 	$5=, $pop4, $pop45
.LBB1_6:                                # %while.body6.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_8 Depth 3
	loop                            # label6:
	block
	i32.const	$push46=, 2
	i32.eq  	$push5=, $5, $pop46
	br_if   	0, $pop5        # 0: down to label8
# BB#7:                                 # %while.body9.i.preheader
                                        #   in Loop: Header=BB1_6 Depth=2
	i32.const	$push48=, 2
	i32.shl 	$push6=, $5, $pop48
	i32.add 	$push7=, $6, $pop6
	i32.const	$push47=, 12
	i32.add 	$4=, $pop7, $pop47
.LBB1_8:                                # %while.body9.i
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_6 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label9:
	i32.load	$push50=, 0($4)
	tee_local	$push49=, $0=, $pop50
	br_if   	4, $pop49       # 4: down to label7
# BB#9:                                 # %if.end26.i
                                        #   in Loop: Header=BB1_8 Depth=3
	i32.const	$push55=, 4
	i32.add 	$4=, $4, $pop55
	i32.const	$push54=, 1
	i32.add 	$push53=, $5, $pop54
	tee_local	$push52=, $5=, $pop53
	i32.const	$push51=, 2
	i32.ne  	$push11=, $pop52, $pop51
	br_if   	0, $pop11       # 0: up to label9
# BB#10:                                # %while.end30.i.loopexit
                                        #   in Loop: Header=BB1_6 Depth=2
	end_loop                        # label10:
	i32.const	$push24=, 16
	i32.add 	$push25=, $1, $pop24
	i32.const	$push57=, 12
	i32.add 	$push12=, $pop25, $pop57
	i32.const	$push56=, 0
	i32.store	$drop=, 0($pop12), $pop56
.LBB1_11:                               # %while.end30.i
                                        #   in Loop: Header=BB1_6 Depth=2
	end_block                       # label8:
	i32.const	$5=, 0
	i32.load	$push59=, 0($6)
	tee_local	$push58=, $6=, $pop59
	br_if   	0, $pop58       # 0: up to label6
	br      	4               # 4: down to label1
.LBB1_12:                               # %while.cond16.preheader.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label7:
	i32.const	$push26=, 16
	i32.add 	$push27=, $1, $pop26
	i32.const	$push63=, 12
	i32.add 	$push62=, $pop27, $pop63
	tee_local	$push61=, $3=, $pop62
	i32.store	$4=, 0($pop61), $0
	i32.store	$drop=, 0($2), $5
	i32.const	$push60=, 1
	i32.and 	$push8=, $4, $pop60
	br_if   	0, $pop8        # 0: down to label2
.LBB1_13:                               # %while.body21.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label11:
	i32.const	$push67=, 1
	i32.shr_u	$push66=, $0, $pop67
	tee_local	$push65=, $0=, $pop66
	i32.const	$push64=, 1
	i32.and 	$push9=, $pop65, $pop64
	i32.eqz 	$push70=, $pop9
	br_if   	0, $pop70       # 0: up to label11
# BB#14:                                # %while.cond16.return.loopexit_crit_edge.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label12:
	i32.store	$drop=, 0($3), $0
.LBB1_15:                               # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.const	$push28=, 16
	i32.add 	$push29=, $1, $pop28
	i32.const	$push38=, 12
	i32.add 	$push10=, $pop29, $pop38
	i32.const	$push37=, 1
	i32.shr_u	$push36=, $0, $pop37
	tee_local	$push35=, $0=, $pop36
	i32.store	$drop=, 0($pop10), $pop35
	br      	0               # 0: up to label0
.LBB1_16:                               # %for.end
	end_loop                        # label1:
	i32.const	$push19=, 0
	i32.const	$push17=, 32
	i32.add 	$push18=, $1, $pop17
	i32.store	$drop=, __stack_pointer($pop19), $pop18
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	foobar, .Lfunc_end1-foobar

	.section	.text.bmp_iter_set_init,"ax",@progbits
	.type	bmp_iter_set_init,@function
bmp_iter_set_init:                      # @bmp_iter_set_init
	.param  	i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$1=, 0($1)
	i32.const	$push2=, 0
	i32.store	$3=, 4($0), $pop2
	block
	i32.store	$push0=, 0($0), $1
	br_if   	0, $pop0        # 0: down to label13
# BB#1:                                 # %if.then
	i32.const	$1=, bitmap_zero_bits
	i32.const	$push9=, bitmap_zero_bits
	i32.store	$drop=, 0($0), $pop9
.LBB2_2:                                # %while.end
	end_block                       # label13:
	i32.store	$drop=, 8($0), $3
	i32.load	$push3=, 12($1)
	i32.store	$push1=, 12($0), $pop3
	i32.eqz 	$push7=, $pop1
	i32.load	$push4=, 8($1)
	i32.const	$push5=, 7
	i32.shl 	$push6=, $pop4, $pop5
	i32.or  	$push8=, $pop7, $pop6
	i32.store	$drop=, 0($2), $pop8
                                        # fallthrough-return
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
