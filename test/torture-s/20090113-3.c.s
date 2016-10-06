	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20090113-3.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push11=, 0
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 48
	i32.sub 	$push27=, $pop9, $pop10
	tee_local	$push26=, $0=, $pop27
	i32.store	__stack_pointer($pop11), $pop26
	i32.const	$push2=, 40
	i32.add 	$push3=, $0, $pop2
	i32.const	$push0=, 0
	i32.load	$push1=, .Lmain.elem+16($pop0)
	i32.store	0($pop3), $pop1
	i32.const	$push5=, 32
	i32.add 	$push6=, $0, $pop5
	i32.const	$push25=, 0
	i64.load	$push4=, .Lmain.elem+8($pop25):p2align=2
	i64.store	0($pop6), $pop4
	i32.const	$push24=, 0
	i64.load	$push7=, .Lmain.elem($pop24):p2align=2
	i64.store	24($0), $pop7
	i32.const	$push23=, 0
	i32.store	16($0), $pop23
	i32.const	$push22=, 0
	i32.store	20($0), $pop22
	i32.const	$push15=, 24
	i32.add 	$push16=, $0, $pop15
	i32.store	12($0), $pop16
	i32.const	$push17=, 24
	i32.add 	$push18=, $0, $pop17
	i32.store	8($0), $pop18
	i32.const	$push19=, 8
	i32.add 	$push20=, $0, $pop19
	call    	foobar@FUNCTION, $pop20
	i32.const	$push14=, 0
	i32.const	$push12=, 48
	i32.add 	$push13=, $0, $pop12
	i32.store	__stack_pointer($pop14), $pop13
	i32.const	$push21=, 0
                                        # fallthrough-return: $pop21
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.foobar,"ax",@progbits
	.type	foobar,@function
foobar:                                 # @foobar
	.param  	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, 0
	i32.const	$push13=, 0
	i32.load	$push14=, __stack_pointer($pop13)
	i32.const	$push15=, 32
	i32.sub 	$push33=, $pop14, $pop15
	tee_local	$push32=, $5=, $pop33
	i32.store	__stack_pointer($pop16), $pop32
	i32.const	$push20=, 16
	i32.add 	$push21=, $5, $pop20
	i32.const	$push22=, 12
	i32.add 	$push23=, $5, $pop22
	call    	bmp_iter_set_init@FUNCTION, $pop21, $0, $pop23
	i32.load	$0=, 28($5)
	i32.load	$4=, 16($5)
	i32.const	$push3=, 24
	i32.add 	$1=, $5, $pop3
.LBB1_1:                                # %for.cond
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_3 Depth 2
                                        #     Child Loop BB1_6 Depth 2
                                        #       Child Loop BB1_8 Depth 3
                                        #     Child Loop BB1_13 Depth 2
	loop                            # label0:
	block
	block
	i32.eqz 	$push67=, $0
	br_if   	0, $pop67       # 0: down to label3
# BB#2:                                 # %while.cond.preheader.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push38=, 1
	i32.and 	$push0=, $0, $pop38
	br_if   	1, $pop0        # 1: down to label2
.LBB1_3:                                # %while.body.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label4:
	i32.const	$push42=, 1
	i32.shr_u	$push41=, $0, $pop42
	tee_local	$push40=, $0=, $pop41
	i32.const	$push39=, 1
	i32.and 	$push1=, $pop40, $pop39
	i32.eqz 	$push68=, $pop1
	br_if   	0, $pop68       # 0: up to label4
# BB#4:                                 # %while.cond.return.loopexit62_crit_edge.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label5:
	i32.const	$push30=, 16
	i32.add 	$push31=, $5, $pop30
	i32.const	$push43=, 12
	i32.add 	$push2=, $pop31, $pop43
	i32.store	0($pop2), $0
	br      	1               # 1: down to label2
.LBB1_5:                                # %if.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label3:
	i32.load	$push4=, 0($1)
	i32.const	$push44=, 1
	i32.add 	$3=, $pop4, $pop44
.LBB1_6:                                # %while.body6.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_8 Depth 3
	loop                            # label6:
	block
	i32.const	$push45=, 2
	i32.eq  	$push5=, $3, $pop45
	br_if   	0, $pop5        # 0: down to label8
# BB#7:                                 # %while.body9.i.preheader
                                        #   in Loop: Header=BB1_6 Depth=2
	i32.const	$push47=, 2
	i32.shl 	$push6=, $3, $pop47
	i32.add 	$push7=, $4, $pop6
	i32.const	$push46=, 12
	i32.add 	$2=, $pop7, $pop46
.LBB1_8:                                # %while.body9.i
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_6 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label9:
	i32.load	$push49=, 0($2)
	tee_local	$push48=, $0=, $pop49
	br_if   	4, $pop48       # 4: down to label7
# BB#9:                                 # %if.end26.i
                                        #   in Loop: Header=BB1_8 Depth=3
	i32.const	$push54=, 4
	i32.add 	$2=, $2, $pop54
	i32.const	$push53=, 1
	i32.add 	$push52=, $3, $pop53
	tee_local	$push51=, $3=, $pop52
	i32.const	$push50=, 2
	i32.ne  	$push11=, $pop51, $pop50
	br_if   	0, $pop11       # 0: up to label9
# BB#10:                                # %while.end30.i.loopexit
                                        #   in Loop: Header=BB1_6 Depth=2
	end_loop                        # label10:
	i32.const	$push24=, 16
	i32.add 	$push25=, $5, $pop24
	i32.const	$push56=, 12
	i32.add 	$push12=, $pop25, $pop56
	i32.const	$push55=, 0
	i32.store	0($pop12), $pop55
.LBB1_11:                               # %while.end30.i
                                        #   in Loop: Header=BB1_6 Depth=2
	end_block                       # label8:
	i32.const	$3=, 0
	i32.load	$push58=, 0($4)
	tee_local	$push57=, $4=, $pop58
	br_if   	0, $pop57       # 0: up to label6
	br      	4               # 4: down to label1
.LBB1_12:                               # %while.cond16.preheader.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label7:
	i32.const	$push26=, 16
	i32.add 	$push27=, $5, $pop26
	i32.const	$push62=, 12
	i32.add 	$push61=, $pop27, $pop62
	tee_local	$push60=, $2=, $pop61
	i32.store	0($pop60), $0
	i32.store	0($1), $3
	i32.const	$push59=, 1
	i32.and 	$push8=, $0, $pop59
	br_if   	0, $pop8        # 0: down to label2
.LBB1_13:                               # %while.body21.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label11:
	i32.const	$push66=, 1
	i32.shr_u	$push65=, $0, $pop66
	tee_local	$push64=, $0=, $pop65
	i32.const	$push63=, 1
	i32.and 	$push9=, $pop64, $pop63
	i32.eqz 	$push69=, $pop9
	br_if   	0, $pop69       # 0: up to label11
# BB#14:                                # %while.cond16.return.loopexit_crit_edge.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label12:
	i32.store	0($2), $0
.LBB1_15:                               # %for.inc
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.const	$push28=, 16
	i32.add 	$push29=, $5, $pop28
	i32.const	$push37=, 12
	i32.add 	$push10=, $pop29, $pop37
	i32.const	$push36=, 1
	i32.shr_u	$push35=, $0, $pop36
	tee_local	$push34=, $0=, $pop35
	i32.store	0($pop10), $pop34
	br      	0               # 0: up to label0
.LBB1_16:                               # %for.end
	end_loop                        # label1:
	i32.const	$push19=, 0
	i32.const	$push17=, 32
	i32.add 	$push18=, $5, $pop17
	i32.store	__stack_pointer($pop19), $pop18
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
	i32.const	$push7=, 0
	i32.store	4($0), $pop7
	i32.load	$push6=, 0($1)
	tee_local	$push5=, $1=, $pop6
	i32.store	0($0), $pop5
	block
	br_if   	0, $1           # 0: down to label13
# BB#1:                                 # %if.then
	i32.const	$1=, bitmap_zero_bits
	i32.const	$push8=, bitmap_zero_bits
	i32.store	0($0), $pop8
.LBB2_2:                                # %while.end
	end_block                       # label13:
	i32.const	$push11=, 0
	i32.store	8($0), $pop11
	i32.load	$push10=, 12($1)
	tee_local	$push9=, $3=, $pop10
	i32.store	12($0), $pop9
	i32.eqz 	$push3=, $3
	i32.load	$push0=, 8($1)
	i32.const	$push1=, 7
	i32.shl 	$push2=, $pop0, $pop1
	i32.or  	$push4=, $pop3, $pop2
	i32.store	0($2), $pop4
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283501)"
