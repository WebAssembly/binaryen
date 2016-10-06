	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040703-1.c"
	.section	.text.num_lshift,"ax",@progbits
	.hidden	num_lshift
	.globl	num_lshift
	.type	num_lshift,@function
num_lshift:                             # @num_lshift
	.param  	i32, i32, i32, i32
	.local  	i32, i32, i64, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push93=, 0
	i32.load	$push94=, __stack_pointer($pop93)
	i32.const	$push95=, 16
	i32.sub 	$12=, $pop94, $pop95
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	i32.ge_u	$push0=, $3, $2
	br_if   	0, $pop0        # 0: down to label6
# BB#1:                                 # %if.else
	i32.load	$push103=, 4($1)
	tee_local	$push102=, $5=, $pop103
	copy_local	$7=, $pop102
	i32.load	$push101=, 0($1)
	tee_local	$push100=, $4=, $pop101
	copy_local	$9=, $pop100
	copy_local	$8=, $3
	block   	
	i32.const	$push9=, 32
	i32.lt_u	$push10=, $3, $pop9
	br_if   	0, $pop10       # 0: down to label7
# BB#2:                                 # %if.then5
	i32.store	0($1), $5
	i32.const	$7=, 0
	i32.const	$push11=, 4
	i32.add 	$push12=, $1, $pop11
	i32.const	$push104=, 0
	i32.store	0($pop12), $pop104
	i32.const	$push13=, -32
	i32.add 	$8=, $3, $pop13
	copy_local	$9=, $5
.LBB0_3:                                # %if.end
	end_block                       # label7:
	i32.eqz 	$push125=, $8
	br_if   	1, $pop125      # 1: down to label5
# BB#4:                                 # %if.then10
	i32.const	$push14=, 4
	i32.add 	$push15=, $1, $pop14
	i32.shl 	$push108=, $7, $8
	tee_local	$push107=, $10=, $pop108
	i32.store	0($pop15), $pop107
	i32.const	$push17=, 32
	i32.sub 	$push18=, $pop17, $8
	i32.shr_u	$push19=, $7, $pop18
	i32.shl 	$push16=, $9, $8
	i32.or  	$push106=, $pop19, $pop16
	tee_local	$push105=, $9=, $pop106
	i32.store	0($1), $pop105
	br      	2               # 2: down to label4
.LBB0_5:                                # %if.then
	end_block                       # label6:
	i32.load	$push1=, 8($1)
	i32.eqz 	$push126=, $pop1
	br_if   	2, $pop126      # 2: down to label3
# BB#6:                                 # %if.then.land.end_crit_edge
	i32.const	$2=, 0
	br      	3               # 3: down to label2
.LBB0_7:
	end_block                       # label5:
	copy_local	$10=, $7
.LBB0_8:                                # %if.end18
	end_block                       # label4:
	i32.const	$push22=, 8
	i32.add 	$push23=, $1, $pop22
	i64.load	$6=, 0($pop23):p2align=2
	block   	
	block   	
	i32.const	$push20=, 33
	i32.lt_u	$push21=, $2, $pop20
	br_if   	0, $pop21       # 0: down to label9
# BB#9:                                 # %if.then.i
	i32.const	$push30=, -32
	i32.add 	$push110=, $2, $pop30
	tee_local	$push109=, $8=, $pop110
	i32.const	$push31=, 31
	i32.gt_u	$push32=, $pop109, $pop31
	br_if   	1, $pop32       # 1: down to label8
# BB#10:                                # %if.then2.i
	i32.const	$push33=, 1
	i32.shl 	$push34=, $pop33, $8
	i32.const	$push35=, -1
	i32.add 	$push36=, $pop34, $pop35
	i32.and 	$9=, $9, $pop36
	br      	1               # 1: down to label8
.LBB0_11:                               # %if.else.i
	end_block                       # label9:
	i32.const	$9=, 0
	i32.const	$push24=, 32
	i32.eq  	$push25=, $2, $pop24
	br_if   	0, $pop25       # 0: down to label8
# BB#12:                                # %if.then5.i
	i32.const	$push26=, 1
	i32.shl 	$push27=, $pop26, $2
	i32.const	$push28=, -1
	i32.add 	$push29=, $pop27, $pop28
	i32.and 	$10=, $10, $pop29
.LBB0_13:                               # %num_trim.exit
	end_block                       # label8:
	i32.store	0($1), $9
	i32.const	$push37=, 4
	i32.add 	$push38=, $1, $pop37
	i32.store	0($pop38), $10
	i32.wrap/i64	$push39=, $6
	i32.eqz 	$push127=, $pop39
	br_if   	2, $pop127      # 2: down to label1
# BB#14:                                # %if.then21
	i32.const	$push40=, 0
	i32.store	12($1), $pop40
	br      	3               # 3: down to label0
.LBB0_15:                               # %land.rhs
	end_block                       # label3:
	i32.load	$push5=, 0($1)
	i32.const	$push2=, 4
	i32.add 	$push3=, $1, $pop2
	i32.load	$push4=, 0($pop3)
	i32.or  	$push6=, $pop5, $pop4
	i32.const	$push7=, 0
	i32.ne  	$2=, $pop6, $pop7
.LBB0_16:                               # %land.end
	end_block                       # label2:
	i32.store	12($1), $2
	i64.const	$push8=, 0
	i64.store	0($1):p2align=2, $pop8
	br      	1               # 1: down to label0
.LBB0_17:                               # %if.else3.i
	end_block                       # label1:
	i32.store	8($12), $9
	i32.store	4($12), $10
	i32.const	$push43=, -1
	i32.const	$push50=, 0
	i32.const	$push41=, 32
	i32.gt_u	$push113=, $2, $pop41
	tee_local	$push112=, $8=, $pop113
	i32.select	$push42=, $9, $10, $pop112
	i32.const	$push47=, 1
	i32.const	$push44=, -33
	i32.const	$push111=, -1
	i32.select	$push45=, $pop44, $pop111, $8
	i32.add 	$push46=, $pop45, $2
	i32.shl 	$push48=, $pop47, $pop46
	i32.and 	$push49=, $pop42, $pop48
	i32.select	$8=, $pop43, $pop50, $pop49
	block   	
	block   	
	block   	
	i32.const	$push51=, 31
	i32.gt_u	$push52=, $2, $pop51
	br_if   	0, $pop52       # 0: down to label12
# BB#18:                                # %if.then5.i61
	i32.store	8($12), $8
	i32.const	$push96=, 4
	i32.add 	$push97=, $12, $pop96
	copy_local	$7=, $pop97
	copy_local	$11=, $2
	br      	1               # 1: down to label11
.LBB0_19:                               # %if.else8.i
	end_block                       # label12:
	i32.const	$push53=, 63
	i32.gt_u	$push54=, $2, $pop53
	br_if   	1, $pop54       # 1: down to label10
# BB#20:                                # %if.then10.i
	i32.const	$push55=, -32
	i32.add 	$11=, $2, $pop55
	i32.const	$push98=, 8
	i32.add 	$push99=, $12, $pop98
	copy_local	$7=, $pop99
	copy_local	$10=, $9
.LBB0_21:                               # %if.end15.sink.split.i
	end_block                       # label11:
	i32.shl 	$push56=, $8, $11
	i32.or  	$push57=, $10, $pop56
	i32.store	0($7), $pop57
.LBB0_22:                               # %if.end15.i
	end_block                       # label10:
	block   	
	i32.const	$push58=, 32
	i32.lt_u	$push59=, $3, $pop58
	br_if   	0, $pop59       # 0: down to label13
# BB#23:                                # %if.then17.i
	i32.load	$push60=, 8($12)
	i32.store	4($12), $pop60
	i32.store	8($12), $8
	i32.const	$push61=, -32
	i32.add 	$3=, $3, $pop61
.LBB0_24:                               # %if.end22.i
	end_block                       # label13:
	block   	
	block   	
	i32.eqz 	$push128=, $3
	br_if   	0, $pop128      # 0: down to label15
# BB#25:                                # %if.end38.sink.split.i
	i32.load	$push121=, 8($12)
	tee_local	$push120=, $10=, $pop121
	i32.const	$push64=, 32
	i32.sub 	$push119=, $pop64, $3
	tee_local	$push118=, $7=, $pop119
	i32.shl 	$push65=, $pop120, $pop118
	i32.load	$push62=, 4($12)
	i32.shr_u	$push63=, $pop62, $3
	i32.or  	$push117=, $pop65, $pop63
	tee_local	$push116=, $9=, $pop117
	i32.store	4($12), $pop116
	i32.shr_u	$push66=, $10, $3
	i32.shl 	$push67=, $8, $7
	i32.or  	$push115=, $pop66, $pop67
	tee_local	$push114=, $3=, $pop115
	i32.store	8($12), $pop114
	br      	1               # 1: down to label14
.LBB0_26:                               # %if.end22.if.end38_crit_edge.i
	end_block                       # label15:
	i32.load	$9=, 4($12)
	i32.load	$3=, 8($12)
.LBB0_27:                               # %if.end38.i
	end_block                       # label14:
	block   	
	block   	
	i32.const	$push68=, 33
	i32.lt_u	$push69=, $2, $pop68
	br_if   	0, $pop69       # 0: down to label17
# BB#28:                                # %if.then.i.i
	i32.const	$push76=, -32
	i32.add 	$push123=, $2, $pop76
	tee_local	$push122=, $2=, $pop123
	i32.const	$push77=, 31
	i32.gt_u	$push78=, $pop122, $pop77
	br_if   	1, $pop78       # 1: down to label16
# BB#29:                                # %if.then2.i.i
	i32.const	$push79=, 1
	i32.shl 	$push80=, $pop79, $2
	i32.const	$push81=, -1
	i32.add 	$push82=, $pop80, $pop81
	i32.and 	$3=, $3, $pop82
	br      	1               # 1: down to label16
.LBB0_30:                               # %if.else.i.i
	end_block                       # label17:
	i32.const	$3=, 0
	i32.const	$push70=, 32
	i32.eq  	$push71=, $2, $pop70
	br_if   	0, $pop71       # 0: down to label16
# BB#31:                                # %if.then5.i.i
	i32.const	$push72=, 1
	i32.shl 	$push73=, $pop72, $2
	i32.const	$push74=, -1
	i32.add 	$push75=, $pop73, $pop74
	i32.and 	$9=, $9, $pop75
.LBB0_32:                               # %num_rshift.exit
	end_block                       # label16:
	i32.const	$push86=, 12
	i32.add 	$push87=, $1, $pop86
	i32.ne  	$push84=, $5, $9
	i32.ne  	$push83=, $4, $3
	i32.or  	$push85=, $pop84, $pop83
	i32.store	0($pop87), $pop85
.LBB0_33:                               # %if.end37
	end_block                       # label0:
	i64.load	$push88=, 0($1):p2align=2
	i64.store	0($0):p2align=2, $pop88
	i32.const	$push89=, 8
	i32.add 	$push90=, $0, $pop89
	i32.const	$push124=, 8
	i32.add 	$push91=, $1, $pop124
	i64.load	$push92=, 0($pop91):p2align=2
	i64.store	0($pop90):p2align=2, $pop92
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	num_lshift, .Lfunc_end0-num_lshift

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push22=, 0
	i32.const	$push19=, 0
	i32.load	$push20=, __stack_pointer($pop19)
	i32.const	$push21=, 32
	i32.sub 	$push30=, $pop20, $pop21
	tee_local	$push29=, $0=, $pop30
	i32.store	__stack_pointer($pop22), $pop29
	i32.const	$push2=, 12
	i32.add 	$push3=, $0, $pop2
	i32.const	$push0=, 0
	i32.load	$push1=, num+12($pop0)
	i32.store	0($pop3), $pop1
	i32.const	$push5=, 8
	i32.add 	$push6=, $0, $pop5
	i32.const	$push28=, 0
	i32.load	$push4=, num+8($pop28)
	i32.store	0($pop6), $pop4
	i32.const	$push8=, 4
	i32.add 	$push9=, $0, $pop8
	i32.const	$push27=, 0
	i32.load	$push7=, num+4($pop27)
	i32.store	0($pop9), $pop7
	i32.const	$push26=, 0
	i32.load	$push10=, num($pop26)
	i32.store	0($0), $pop10
	i32.const	$push23=, 16
	i32.add 	$push24=, $0, $pop23
	i32.const	$push12=, 64
	i32.const	$push25=, 0
	i32.load	$push11=, n($pop25)
	call    	num_lshift@FUNCTION, $pop24, $0, $pop12, $pop11
	block   	
	i32.load	$push14=, 20($0)
	i32.const	$push13=, 196608
	i32.ne  	$push15=, $pop14, $pop13
	br_if   	0, $pop15       # 0: down to label18
# BB#1:                                 # %if.end
	i32.load	$push16=, 16($0)
	br_if   	0, $pop16       # 0: down to label18
# BB#2:                                 # %if.end3
	i32.load	$push17=, 28($0)
	br_if   	0, $pop17       # 0: down to label18
# BB#3:                                 # %if.end6
	i32.const	$push18=, 0
	call    	exit@FUNCTION, $pop18
	unreachable
.LBB1_4:                                # %if.then5
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	precision               # @precision
	.type	precision,@object
	.section	.data.precision,"aw",@progbits
	.globl	precision
	.p2align	2
precision:
	.int32	64                      # 0x40
	.size	precision, 4

	.hidden	n                       # @n
	.type	n,@object
	.section	.data.n,"aw",@progbits
	.globl	n
	.p2align	2
n:
	.int32	16                      # 0x10
	.size	n, 4

	.hidden	num                     # @num
	.type	num,@object
	.section	.data.num,"aw",@progbits
	.globl	num
	.p2align	2
num:
	.int32	0                       # 0x0
	.int32	3                       # 0x3
	.int32	0                       # 0x0
	.int32	0                       # 0x0
	.size	num, 16


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
