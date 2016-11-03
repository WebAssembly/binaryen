	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20090113-3.c"
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
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push16=, 0
	i32.const	$push13=, 0
	i32.load	$push14=, __stack_pointer($pop13)
	i32.const	$push15=, 32
	i32.sub 	$push35=, $pop14, $pop15
	tee_local	$push34=, $5=, $pop35
	i32.store	__stack_pointer($pop16), $pop34
	i32.const	$push20=, 16
	i32.add 	$push21=, $5, $pop20
	i32.const	$push22=, 12
	i32.add 	$push23=, $5, $pop22
	call    	bmp_iter_set_init@FUNCTION, $pop21, $0, $pop23
	i32.load	$4=, 16($5)
	i32.const	$push3=, 24
	i32.add 	$1=, $5, $pop3
	block   	
	block   	
	i32.load	$push33=, 28($5)
	tee_local	$push32=, $0=, $pop33
	br_if   	0, $pop32       # 0: down to label1
# BB#1:
	i32.const	$6=, 2
	br      	1               # 1: down to label0
.LBB1_2:
	end_block                       # label1:
	i32.const	$6=, 0
.LBB1_3:                                # =>This Inner Loop Header: Depth=1
	end_block                       # label0:
	loop    	                # label2:
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$6, 1, 0, 4, 5, 6, 7, 11, 12, 13, 8, 9, 10, 14, 2, 3, 3 # 1: down to label28
                                        # 0: down to label29
                                        # 4: down to label25
                                        # 5: down to label24
                                        # 6: down to label23
                                        # 7: down to label22
                                        # 11: down to label18
                                        # 12: down to label17
                                        # 13: down to label16
                                        # 8: down to label21
                                        # 9: down to label20
                                        # 10: down to label19
                                        # 14: down to label15
                                        # 2: down to label27
                                        # 3: down to label26
.LBB1_4:                                # %for.inc
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label29:
	i32.const	$push28=, 16
	i32.add 	$push29=, $5, $pop28
	i32.const	$push39=, 12
	i32.add 	$push10=, $pop29, $pop39
	i32.const	$push38=, 1
	i32.shr_u	$push37=, $0, $pop38
	tee_local	$push36=, $0=, $pop37
	i32.store	0($pop10), $pop36
	i32.eqz 	$push69=, $0
	br_if   	14, $pop69      # 14: down to label14
# BB#5:                                 #   in Loop: Header=BB1_3 Depth=1
	i32.const	$6=, 0
	br      	26              # 26: up to label2
.LBB1_6:                                # %while.cond.preheader.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label28:
	i32.const	$push40=, 1
	i32.and 	$push0=, $0, $pop40
	br_if   	15, $pop0       # 15: down to label12
# BB#7:                                 #   in Loop: Header=BB1_3 Depth=1
	i32.const	$6=, 13
	br      	25              # 25: up to label2
.LBB1_8:                                # %while.body.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label27:
	i32.const	$push44=, 1
	i32.shr_u	$push43=, $0, $pop44
	tee_local	$push42=, $0=, $pop43
	i32.const	$push41=, 1
	i32.and 	$push1=, $pop42, $pop41
	i32.eqz 	$push70=, $pop1
	br_if   	23, $pop70      # 23: down to label3
# BB#9:                                 #   in Loop: Header=BB1_3 Depth=1
	i32.const	$6=, 14
	br      	24              # 24: up to label2
.LBB1_10:                               # %while.cond.return.loopexit62_crit_edge.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label26:
	i32.const	$push30=, 16
	i32.add 	$push31=, $5, $pop30
	i32.const	$push45=, 12
	i32.add 	$push2=, $pop31, $pop45
	i32.store	0($pop2), $0
	br      	12              # 12: down to label13
.LBB1_11:                               # %if.end.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label25:
	i32.load	$push4=, 0($1)
	i32.const	$push46=, 1
	i32.add 	$3=, $pop4, $pop46
# BB#12:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$6=, 3
	br      	22              # 22: up to label2
.LBB1_13:                               # %while.body6.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label24:
	i32.const	$push47=, 2
	i32.eq  	$push5=, $3, $pop47
	br_if   	16, $pop5       # 16: down to label7
# BB#14:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$6=, 4
	br      	21              # 21: up to label2
.LBB1_15:                               # %while.body9.i.preheader
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label23:
	i32.const	$push49=, 2
	i32.shl 	$push6=, $3, $pop49
	i32.add 	$push7=, $4, $pop6
	i32.const	$push48=, 12
	i32.add 	$2=, $pop7, $pop48
# BB#16:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$6=, 5
	br      	20              # 20: up to label2
.LBB1_17:                               # %while.body9.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label22:
	i32.load	$push51=, 0($2)
	tee_local	$push50=, $0=, $pop51
	br_if   	16, $pop50      # 16: down to label5
# BB#18:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$6=, 9
	br      	19              # 19: up to label2
.LBB1_19:                               # %if.end26.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label21:
	i32.const	$push56=, 4
	i32.add 	$2=, $2, $pop56
	i32.const	$push55=, 1
	i32.add 	$push54=, $3, $pop55
	tee_local	$push53=, $3=, $pop54
	i32.const	$push52=, 2
	i32.ne  	$push11=, $pop53, $pop52
	br_if   	14, $pop11      # 14: down to label6
# BB#20:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$6=, 10
	br      	18              # 18: up to label2
.LBB1_21:                               # %while.end30.i.loopexit
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label20:
	i32.const	$push24=, 16
	i32.add 	$push25=, $5, $pop24
	i32.const	$push58=, 12
	i32.add 	$push12=, $pop25, $pop58
	i32.const	$push57=, 0
	i32.store	0($pop12), $pop57
# BB#22:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$6=, 11
	br      	17              # 17: up to label2
.LBB1_23:                               # %while.end30.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label19:
	i32.const	$3=, 0
	i32.load	$push60=, 0($4)
	tee_local	$push59=, $4=, $pop60
	br_if   	10, $pop59      # 10: down to label8
	br      	9               # 9: down to label9
.LBB1_24:                               # %while.cond16.preheader.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label18:
	i32.const	$push26=, 16
	i32.add 	$push27=, $5, $pop26
	i32.const	$push64=, 12
	i32.add 	$push63=, $pop27, $pop64
	tee_local	$push62=, $2=, $pop63
	i32.store	0($pop62), $0
	i32.store	0($1), $3
	i32.const	$push61=, 1
	i32.and 	$push8=, $0, $pop61
	br_if   	7, $pop8        # 7: down to label10
# BB#25:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$6=, 7
	br      	15              # 15: up to label2
.LBB1_26:                               # %while.body21.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label17:
	i32.const	$push68=, 1
	i32.shr_u	$push67=, $0, $pop68
	tee_local	$push66=, $0=, $pop67
	i32.const	$push65=, 1
	i32.and 	$push9=, $pop66, $pop65
	i32.eqz 	$push71=, $pop9
	br_if   	12, $pop71      # 12: down to label4
# BB#27:                                #   in Loop: Header=BB1_3 Depth=1
	i32.const	$6=, 8
	br      	14              # 14: up to label2
.LBB1_28:                               # %while.cond16.return.loopexit_crit_edge.i
                                        #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label16:
	i32.store	0($2), $0
	br      	4               # 4: down to label11
.LBB1_29:                               # %for.end
	end_block                       # label15:
	i32.const	$push19=, 0
	i32.const	$push17=, 32
	i32.add 	$push18=, $5, $pop17
	i32.store	__stack_pointer($pop19), $pop18
	return
.LBB1_30:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label14:
	i32.const	$6=, 2
	br      	11              # 11: up to label2
.LBB1_31:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label13:
	i32.const	$6=, 1
	br      	10              # 10: up to label2
.LBB1_32:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label12:
	i32.const	$6=, 1
	br      	9               # 9: up to label2
.LBB1_33:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label11:
	i32.const	$6=, 1
	br      	8               # 8: up to label2
.LBB1_34:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label10:
	i32.const	$6=, 1
	br      	7               # 7: up to label2
.LBB1_35:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label9:
	i32.const	$6=, 12
	br      	6               # 6: up to label2
.LBB1_36:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label8:
	i32.const	$6=, 3
	br      	5               # 5: up to label2
.LBB1_37:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label7:
	i32.const	$6=, 11
	br      	4               # 4: up to label2
.LBB1_38:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label6:
	i32.const	$6=, 5
	br      	3               # 3: up to label2
.LBB1_39:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label5:
	i32.const	$6=, 6
	br      	2               # 2: up to label2
.LBB1_40:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label4:
	i32.const	$6=, 7
	br      	1               # 1: up to label2
.LBB1_41:                               #   in Loop: Header=BB1_3 Depth=1
	end_block                       # label3:
	i32.const	$6=, 13
	br      	0               # 0: up to label2
.LBB1_42:
	end_loop
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
	br_if   	0, $1           # 0: down to label30
# BB#1:                                 # %if.then
	i32.const	$1=, bitmap_zero_bits
	i32.const	$push8=, bitmap_zero_bits
	i32.store	0($0), $pop8
.LBB2_2:                                # %while.end
	end_block                       # label30:
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


	.ident	"clang version 4.0.0 "
