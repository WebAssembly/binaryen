	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040703-1.c"
	.section	.text.num_lshift,"ax",@progbits
	.hidden	num_lshift
	.globl	num_lshift
	.type	num_lshift,@function
num_lshift:                             # @num_lshift
	.param  	i32, i32, i32, i32
	.local  	i32, i64, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	block
	block
	block
	block
	block
	block
	i32.ge_u	$push1=, $3, $2
	br_if   	0, $pop1        # 0: down to label6
# BB#1:                                 # %if.else
	i32.load	$push95=, 4($1)
	tee_local	$push94=, $10=, $pop95
	copy_local	$7=, $pop94
	i32.load	$push93=, 0($1)
	tee_local	$push92=, $9=, $pop93
	copy_local	$11=, $pop92
	copy_local	$6=, $3
	block
	i32.const	$push10=, 32
	i32.lt_u	$push11=, $3, $pop10
	br_if   	0, $pop11       # 0: down to label7
# BB#2:                                 # %if.then5
	i32.const	$7=, 0
	i32.const	$push13=, 4
	i32.add 	$push14=, $1, $pop13
	i32.const	$push96=, 0
	i32.store	$discard=, 0($pop14), $pop96
	i32.const	$push12=, -32
	i32.add 	$6=, $3, $pop12
	i32.store	$push0=, 0($1), $10
	copy_local	$11=, $pop0
.LBB0_3:                                # %if.end
	end_block                       # label7:
	block
	i32.const	$push113=, 0
	i32.eq  	$push114=, $6, $pop113
	br_if   	0, $pop114      # 0: down to label8
# BB#4:                                 # %if.then10
	i32.const	$push16=, 32
	i32.sub 	$push17=, $pop16, $6
	i32.shr_u	$8=, $7, $pop17
	i32.shl 	$7=, $7, $6
	i32.const	$push18=, 4
	i32.add 	$push19=, $1, $pop18
	i32.store	$discard=, 0($pop19), $7
	i32.shl 	$push15=, $11, $6
	i32.or  	$push98=, $8, $pop15
	tee_local	$push97=, $11=, $pop98
	i32.store	$discard=, 0($1), $pop97
.LBB0_5:                                # %if.end18
	end_block                       # label8:
	i32.const	$push20=, 8
	i32.add 	$push21=, $1, $pop20
	i64.load	$5=, 0($pop21):p2align=2
	i32.const	$push22=, 33
	i32.lt_u	$push23=, $2, $pop22
	br_if   	1, $pop23       # 1: down to label5
# BB#6:                                 # %if.then.i
	i32.const	$push30=, -32
	i32.add 	$push100=, $2, $pop30
	tee_local	$push99=, $6=, $pop100
	i32.const	$push31=, 31
	i32.gt_u	$push32=, $pop99, $pop31
	br_if   	2, $pop32       # 2: down to label4
# BB#7:                                 # %if.then2.i
	i32.const	$push33=, 1
	i32.shl 	$push34=, $pop33, $6
	i32.const	$push35=, -1
	i32.add 	$push36=, $pop34, $pop35
	i32.and 	$11=, $11, $pop36
	br      	2               # 2: down to label4
.LBB0_8:                                # %if.then
	end_block                       # label6:
	i32.load	$push2=, 8($1)
	i32.const	$push115=, 0
	i32.eq  	$push116=, $pop2, $pop115
	br_if   	2, $pop116      # 2: down to label3
# BB#9:                                 # %if.then.land.end_crit_edge
	i32.const	$2=, 0
	br      	3               # 3: down to label2
.LBB0_10:                               # %if.else.i
	end_block                       # label5:
	i32.const	$11=, 0
	i32.const	$push24=, 32
	i32.eq  	$push25=, $2, $pop24
	br_if   	0, $pop25       # 0: down to label4
# BB#11:                                # %if.then5.i
	i32.const	$push26=, 1
	i32.shl 	$push27=, $pop26, $2
	i32.const	$push28=, -1
	i32.add 	$push29=, $pop27, $pop28
	i32.and 	$7=, $7, $pop29
.LBB0_12:                               # %num_trim.exit
	end_block                       # label4:
	i32.const	$push37=, 4
	i32.add 	$push38=, $1, $pop37
	i32.store	$4=, 0($pop38), $7
	i32.store	$6=, 0($1), $11
	i32.wrap/i64	$push39=, $5
	i32.const	$push117=, 0
	i32.eq  	$push118=, $pop39, $pop117
	br_if   	2, $pop118      # 2: down to label1
# BB#13:                                # %if.then21
	i32.const	$push40=, 0
	i32.store	$discard=, 12($1), $pop40
	br      	3               # 3: down to label0
.LBB0_14:                               # %land.rhs
	end_block                       # label3:
	i32.load	$push6=, 0($1)
	i32.const	$push3=, 4
	i32.add 	$push4=, $1, $pop3
	i32.load	$push5=, 0($pop4)
	i32.or  	$push7=, $pop6, $pop5
	i32.const	$push8=, 0
	i32.ne  	$2=, $pop7, $pop8
.LBB0_15:                               # %land.end
	end_block                       # label2:
	i32.store	$discard=, 12($1), $2
	i64.const	$push9=, 0
	i64.store	$discard=, 0($1):p2align=2, $pop9
	br      	1               # 1: down to label0
.LBB0_16:                               # %if.else23
	end_block                       # label1:
	block
	block
	block
	block
	i32.const	$push101=, 32
	i32.le_u	$push41=, $2, $pop101
	br_if   	0, $pop41       # 0: down to label12
# BB#17:                                # %if.else8.i
	i32.const	$push56=, -1
	i32.const	$push55=, 0
	i32.const	$push52=, 1
	i32.const	$push50=, -33
	i32.add 	$push51=, $2, $pop50
	i32.shl 	$push53=, $pop52, $pop51
	i32.and 	$push54=, $6, $pop53
	i32.select	$8=, $pop56, $pop55, $pop54
	i32.const	$push57=, 63
	i32.gt_u	$push58=, $2, $pop57
	br_if   	3, $pop58       # 3: down to label9
	br      	1               # 1: down to label11
.LBB0_18:                               # %if.else3.i
	end_block                       # label12:
	i32.const	$push42=, -1
	i32.const	$push47=, 0
	i32.const	$push44=, 1
	i32.const	$push103=, -1
	i32.add 	$push43=, $2, $pop103
	i32.shl 	$push45=, $pop44, $pop43
	i32.and 	$push46=, $4, $pop45
	i32.select	$8=, $pop42, $pop47, $pop46
	i32.const	$push102=, 32
	i32.ne  	$push48=, $2, $pop102
	br_if   	1, $pop48       # 1: down to label10
.LBB0_19:                               # %if.then10.i
	end_block                       # label11:
	i32.const	$push59=, -32
	i32.add 	$push60=, $2, $pop59
	i32.shl 	$push61=, $8, $pop60
	i32.or  	$11=, $pop61, $6
	br      	1               # 1: down to label9
.LBB0_20:                               # %if.then5.i64
	end_block                       # label10:
	i32.shl 	$push49=, $8, $2
	i32.or  	$7=, $pop49, $4
	copy_local	$11=, $8
.LBB0_21:                               # %if.end15.i
	end_block                       # label9:
	i32.const	$push62=, 31
	i32.gt_u	$push107=, $3, $pop62
	tee_local	$push106=, $4=, $pop107
	i32.select	$6=, $11, $7, $pop106
	i32.select	$7=, $8, $11, $4
	block
	i32.const	$push63=, -32
	i32.add 	$push64=, $3, $pop63
	i32.select	$push105=, $pop64, $3, $4
	tee_local	$push104=, $3=, $pop105
	i32.const	$push119=, 0
	i32.eq  	$push120=, $pop104, $pop119
	br_if   	0, $pop120      # 0: down to label13
# BB#22:                                # %if.then24.i
	i32.const	$push66=, 32
	i32.sub 	$push109=, $pop66, $3
	tee_local	$push108=, $11=, $pop109
	i32.shl 	$push67=, $7, $pop108
	i32.shr_u	$push65=, $6, $3
	i32.or  	$6=, $pop67, $pop65
	i32.shr_u	$push68=, $7, $3
	i32.shl 	$push69=, $8, $11
	i32.or  	$7=, $pop68, $pop69
.LBB0_23:                               # %if.end38.i
	end_block                       # label13:
	block
	block
	i32.const	$push70=, 33
	i32.lt_u	$push71=, $2, $pop70
	br_if   	0, $pop71       # 0: down to label15
# BB#24:                                # %if.then.i61.i
	i32.const	$push78=, -32
	i32.add 	$push111=, $2, $pop78
	tee_local	$push110=, $2=, $pop111
	i32.const	$push79=, 31
	i32.gt_u	$push80=, $pop110, $pop79
	br_if   	1, $pop80       # 1: down to label14
# BB#25:                                # %if.then2.i.i
	i32.const	$push81=, 1
	i32.shl 	$push82=, $pop81, $2
	i32.const	$push83=, -1
	i32.add 	$push84=, $pop82, $pop83
	i32.and 	$7=, $7, $pop84
	br      	1               # 1: down to label14
.LBB0_26:                               # %if.else.i.i
	end_block                       # label15:
	i32.const	$7=, 0
	i32.const	$push72=, 32
	i32.eq  	$push73=, $2, $pop72
	br_if   	0, $pop73       # 0: down to label14
# BB#27:                                # %if.then5.i.i
	i32.const	$push74=, 1
	i32.shl 	$push75=, $pop74, $2
	i32.const	$push76=, -1
	i32.add 	$push77=, $pop75, $pop76
	i32.and 	$6=, $6, $pop77
.LBB0_28:                               # %num_rshift.exit
	end_block                       # label14:
	i32.ne  	$push86=, $10, $6
	i32.ne  	$push85=, $9, $7
	i32.or  	$push87=, $pop86, $pop85
	i32.store	$discard=, 12($1), $pop87
.LBB0_29:                               # %if.end37
	end_block                       # label0:
	i32.const	$push89=, 8
	i32.add 	$push91=, $1, $pop89
	i64.load	$5=, 0($pop91):p2align=2
	i64.load	$push88=, 0($1):p2align=2
	i64.store	$discard=, 0($0):p2align=2, $pop88
	i32.const	$push112=, 8
	i32.add 	$push90=, $0, $pop112
	i64.store	$discard=, 0($pop90):p2align=2, $5
	return
	.endfunc
.Lfunc_end0:
	.size	num_lshift, .Lfunc_end0-num_lshift

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push21=, __stack_pointer
	i32.const	$push18=, __stack_pointer
	i32.load	$push19=, 0($pop18)
	i32.const	$push20=, 32
	i32.sub 	$push24=, $pop19, $pop20
	i32.store	$0=, 0($pop21), $pop24
	i32.const	$push0=, 0
	i32.load	$1=, n($pop0)
	i32.const	$push2=, 12
	i32.add 	$push3=, $0, $pop2
	i32.const	$push28=, 0
	i32.load	$push1=, num+12($pop28)
	i32.store	$discard=, 0($pop3), $pop1
	i32.const	$push5=, 8
	i32.add 	$push6=, $0, $pop5
	i32.const	$push27=, 0
	i32.load	$push4=, num+8($pop27)
	i32.store	$discard=, 0($pop6), $pop4
	i32.const	$push8=, 4
	i32.add 	$push9=, $0, $pop8
	i32.const	$push26=, 0
	i32.load	$push7=, num+4($pop26)
	i32.store	$discard=, 0($pop9), $pop7
	i32.const	$push25=, 0
	i32.load	$push10=, num($pop25)
	i32.store	$discard=, 0($0), $pop10
	i32.const	$push22=, 16
	i32.add 	$push23=, $0, $pop22
	i32.const	$push11=, 64
	call    	num_lshift@FUNCTION, $pop23, $0, $pop11, $1
	block
	i32.load	$push12=, 20($0)
	i32.const	$push13=, 196608
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	0, $pop14       # 0: down to label16
# BB#1:                                 # %if.end
	i32.load	$push15=, 16($0)
	br_if   	0, $pop15       # 0: down to label16
# BB#2:                                 # %if.end3
	i32.load	$push16=, 28($0)
	br_if   	0, $pop16       # 0: down to label16
# BB#3:                                 # %if.end6
	i32.const	$push17=, 0
	call    	exit@FUNCTION, $pop17
	unreachable
.LBB1_4:                                # %if.then5
	end_block                       # label16:
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
