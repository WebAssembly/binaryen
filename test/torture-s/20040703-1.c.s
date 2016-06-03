	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040703-1.c"
	.section	.text.num_lshift,"ax",@progbits
	.hidden	num_lshift
	.globl	num_lshift
	.type	num_lshift,@function
num_lshift:                             # @num_lshift
	.param  	i32, i32, i32, i32
	.local  	i32, i32, i32, i64, i32, i32, i32, i32
# BB#0:                                 # %entry
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
	i32.load	$push96=, 4($1)
	tee_local	$push95=, $6=, $pop96
	copy_local	$8=, $pop95
	i32.load	$push94=, 0($1)
	tee_local	$push93=, $5=, $pop94
	copy_local	$11=, $pop93
	copy_local	$9=, $3
	block
	i32.const	$push9=, 32
	i32.lt_u	$push10=, $3, $pop9
	br_if   	0, $pop10       # 0: down to label7
# BB#2:                                 # %if.then5
	i32.store	$11=, 0($1), $6
	i32.const	$8=, 0
	i32.const	$push11=, 4
	i32.add 	$push12=, $1, $pop11
	i32.const	$push97=, 0
	i32.store	$drop=, 0($pop12), $pop97
	i32.const	$push13=, -32
	i32.add 	$9=, $3, $pop13
	copy_local	$11=, $11
.LBB0_3:                                # %if.end
	end_block                       # label7:
	i32.eqz 	$push116=, $9
	br_if   	1, $pop116      # 1: down to label5
# BB#4:                                 # %if.then10
	i32.const	$push14=, 4
	i32.add 	$push15=, $1, $pop14
	i32.shl 	$push101=, $8, $9
	tee_local	$push100=, $10=, $pop101
	i32.store	$drop=, 0($pop15), $pop100
	i32.const	$push17=, 32
	i32.sub 	$push18=, $pop17, $9
	i32.shr_u	$push19=, $8, $pop18
	i32.shl 	$push16=, $11, $9
	i32.or  	$push99=, $pop19, $pop16
	tee_local	$push98=, $11=, $pop99
	i32.store	$drop=, 0($1), $pop98
	br      	2               # 2: down to label4
.LBB0_5:                                # %if.then
	end_block                       # label6:
	i32.load	$push1=, 8($1)
	i32.eqz 	$push117=, $pop1
	br_if   	2, $pop117      # 2: down to label3
# BB#6:                                 # %if.then.land.end_crit_edge
	i32.const	$2=, 0
	br      	3               # 3: down to label2
.LBB0_7:
	end_block                       # label5:
	copy_local	$10=, $8
.LBB0_8:                                # %if.end18
	end_block                       # label4:
	i32.const	$push22=, 8
	i32.add 	$push23=, $1, $pop22
	i64.load	$7=, 0($pop23):p2align=2
	block
	block
	i32.const	$push20=, 33
	i32.lt_u	$push21=, $2, $pop20
	br_if   	0, $pop21       # 0: down to label9
# BB#9:                                 # %if.then.i
	i32.const	$push30=, -32
	i32.add 	$push103=, $2, $pop30
	tee_local	$push102=, $9=, $pop103
	i32.const	$push31=, 31
	i32.gt_u	$push32=, $pop102, $pop31
	br_if   	1, $pop32       # 1: down to label8
# BB#10:                                # %if.then2.i
	i32.const	$push33=, 1
	i32.shl 	$push34=, $pop33, $9
	i32.const	$push35=, -1
	i32.add 	$push36=, $pop34, $pop35
	i32.and 	$11=, $11, $pop36
	br      	1               # 1: down to label8
.LBB0_11:                               # %if.else.i
	end_block                       # label9:
	i32.const	$11=, 0
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
	i32.store	$9=, 0($1), $11
	i32.const	$push37=, 4
	i32.add 	$push38=, $1, $pop37
	i32.store	$4=, 0($pop38), $10
	i32.wrap/i64	$push39=, $7
	i32.eqz 	$push118=, $pop39
	br_if   	2, $pop118      # 2: down to label1
# BB#14:                                # %if.then21
	i32.const	$push40=, 0
	i32.store	$drop=, 12($1), $pop40
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
	i32.store	$drop=, 12($1), $2
	i64.const	$push8=, 0
	i64.store	$drop=, 0($1):p2align=2, $pop8
	br      	1               # 1: down to label0
.LBB0_17:                               # %if.else23
	end_block                       # label1:
	block
	block
	block
	block
	i32.const	$push104=, 32
	i32.le_u	$push41=, $2, $pop104
	br_if   	0, $pop41       # 0: down to label13
# BB#18:                                # %if.else8.i
	i32.const	$push56=, -1
	i32.const	$push55=, 0
	i32.const	$push52=, 1
	i32.const	$push50=, -33
	i32.add 	$push51=, $2, $pop50
	i32.shl 	$push53=, $pop52, $pop51
	i32.and 	$push54=, $9, $pop53
	i32.select	$8=, $pop56, $pop55, $pop54
	i32.const	$push57=, 63
	i32.gt_u	$push58=, $2, $pop57
	br_if   	3, $pop58       # 3: down to label10
	br      	1               # 1: down to label12
.LBB0_19:                               # %if.else3.i
	end_block                       # label13:
	i32.const	$push42=, -1
	i32.const	$push47=, 0
	i32.const	$push44=, 1
	i32.const	$push106=, -1
	i32.add 	$push43=, $2, $pop106
	i32.shl 	$push45=, $pop44, $pop43
	i32.and 	$push46=, $4, $pop45
	i32.select	$8=, $pop42, $pop47, $pop46
	i32.const	$push105=, 32
	i32.ne  	$push48=, $2, $pop105
	br_if   	1, $pop48       # 1: down to label11
.LBB0_20:                               # %if.then10.i
	end_block                       # label12:
	i32.const	$push59=, -32
	i32.add 	$push60=, $2, $pop59
	i32.shl 	$push61=, $8, $pop60
	i32.or  	$11=, $pop61, $9
	br      	1               # 1: down to label10
.LBB0_21:                               # %if.then5.i64
	end_block                       # label11:
	i32.shl 	$push49=, $8, $2
	i32.or  	$10=, $pop49, $4
	copy_local	$11=, $8
.LBB0_22:                               # %if.end15.i
	end_block                       # label10:
	i32.const	$push62=, 31
	i32.gt_u	$push110=, $3, $pop62
	tee_local	$push109=, $9=, $pop110
	i32.select	$4=, $8, $11, $pop109
	i32.select	$11=, $11, $10, $9
	block
	block
	i32.const	$push63=, -32
	i32.add 	$push64=, $3, $pop63
	i32.select	$push108=, $pop64, $3, $9
	tee_local	$push107=, $9=, $pop108
	i32.eqz 	$push119=, $pop107
	br_if   	0, $pop119      # 0: down to label15
# BB#23:                                # %if.then24.i
	i32.shr_u	$push65=, $4, $9
	i32.const	$push66=, 32
	i32.sub 	$push112=, $pop66, $9
	tee_local	$push111=, $10=, $pop112
	i32.shl 	$push67=, $8, $pop111
	i32.or  	$3=, $pop65, $pop67
	i32.shl 	$push69=, $4, $10
	i32.shr_u	$push68=, $11, $9
	i32.or  	$11=, $pop69, $pop68
	br      	1               # 1: down to label14
.LBB0_24:
	end_block                       # label15:
	copy_local	$3=, $4
.LBB0_25:                               # %if.end38.i
	end_block                       # label14:
	block
	block
	i32.const	$push70=, 33
	i32.lt_u	$push71=, $2, $pop70
	br_if   	0, $pop71       # 0: down to label17
# BB#26:                                # %if.then.i61.i
	i32.const	$push78=, -32
	i32.add 	$push114=, $2, $pop78
	tee_local	$push113=, $2=, $pop114
	i32.const	$push79=, 31
	i32.gt_u	$push80=, $pop113, $pop79
	br_if   	1, $pop80       # 1: down to label16
# BB#27:                                # %if.then2.i.i
	i32.const	$push81=, 1
	i32.shl 	$push82=, $pop81, $2
	i32.const	$push83=, -1
	i32.add 	$push84=, $pop82, $pop83
	i32.and 	$3=, $3, $pop84
	br      	1               # 1: down to label16
.LBB0_28:                               # %if.else.i.i
	end_block                       # label17:
	i32.const	$3=, 0
	i32.const	$push72=, 32
	i32.eq  	$push73=, $2, $pop72
	br_if   	0, $pop73       # 0: down to label16
# BB#29:                                # %if.then5.i.i
	i32.const	$push74=, 1
	i32.shl 	$push75=, $pop74, $2
	i32.const	$push76=, -1
	i32.add 	$push77=, $pop75, $pop76
	i32.and 	$11=, $11, $pop77
.LBB0_30:                               # %num_rshift.exit
	end_block                       # label16:
	i32.ne  	$push86=, $6, $11
	i32.ne  	$push85=, $5, $3
	i32.or  	$push87=, $pop86, $pop85
	i32.store	$drop=, 12($1), $pop87
.LBB0_31:                               # %if.end37
	end_block                       # label0:
	i64.load	$push88=, 0($1):p2align=2
	i64.store	$drop=, 0($0):p2align=2, $pop88
	i32.const	$push89=, 8
	i32.add 	$push90=, $0, $pop89
	i32.const	$push115=, 8
	i32.add 	$push91=, $1, $pop115
	i64.load	$push92=, 0($pop91):p2align=2
	i64.store	$drop=, 0($pop90):p2align=2, $pop92
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
	i32.sub 	$push25=, $pop20, $pop21
	i32.store	$push31=, __stack_pointer($pop22), $pop25
	tee_local	$push30=, $0=, $pop31
	i32.const	$push2=, 12
	i32.add 	$push3=, $pop30, $pop2
	i32.const	$push0=, 0
	i32.load	$push1=, num+12($pop0)
	i32.store	$drop=, 0($pop3), $pop1
	i32.const	$push5=, 8
	i32.add 	$push6=, $0, $pop5
	i32.const	$push29=, 0
	i32.load	$push4=, num+8($pop29)
	i32.store	$drop=, 0($pop6), $pop4
	i32.const	$push8=, 4
	i32.add 	$push9=, $0, $pop8
	i32.const	$push28=, 0
	i32.load	$push7=, num+4($pop28)
	i32.store	$drop=, 0($pop9), $pop7
	i32.const	$push27=, 0
	i32.load	$push10=, num($pop27)
	i32.store	$drop=, 0($0), $pop10
	i32.const	$push23=, 16
	i32.add 	$push24=, $0, $pop23
	i32.const	$push12=, 64
	i32.const	$push26=, 0
	i32.load	$push11=, n($pop26)
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


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
