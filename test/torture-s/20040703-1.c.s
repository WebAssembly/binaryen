	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040703-1.c"
	.section	.text.num_lshift,"ax",@progbits
	.hidden	num_lshift
	.globl	num_lshift
	.type	num_lshift,@function
num_lshift:                             # @num_lshift
	.param  	i32, i32, i32, i32
	.local  	i32, i32, i64, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	block
	block
	i32.ge_u	$push5=, $3, $2
	br_if   	0, $pop5        # 0: down to label1
# BB#1:                                 # %if.else
	i32.load	$4=, 0($1)
	i32.load	$5=, 4($1)
	copy_local	$8=, $5
	copy_local	$9=, $4
	copy_local	$7=, $3
	block
	i32.const	$push14=, 32
	i32.lt_u	$push15=, $3, $pop14
	br_if   	0, $pop15       # 0: down to label2
# BB#2:                                 # %if.then5
	i32.const	$push18=, 4
	i32.add 	$push19=, $1, $pop18
	i32.const	$push16=, 0
	i32.store	$8=, 0($pop19), $pop16
	i32.const	$push17=, -32
	i32.add 	$7=, $3, $pop17
	i32.store	$9=, 0($1), $5
.LBB0_3:                                # %if.end
	end_block                       # label2:
	block
	i32.const	$push106=, 0
	i32.eq  	$push107=, $7, $pop106
	br_if   	0, $pop107      # 0: down to label3
# BB#4:                                 # %if.then10
	i32.const	$push21=, 32
	i32.sub 	$push22=, $pop21, $7
	i32.shr_u	$11=, $8, $pop22
	i32.const	$push23=, 4
	i32.add 	$push24=, $1, $pop23
	i32.shl 	$push1=, $8, $7
	i32.store	$8=, 0($pop24), $pop1
	i32.shl 	$push20=, $9, $7
	i32.or  	$push0=, $11, $pop20
	i32.store	$9=, 0($1), $pop0
.LBB0_5:                                # %if.end18
	end_block                       # label3:
	i32.const	$push25=, 8
	i32.add 	$push26=, $1, $pop25
	i64.load	$6=, 0($pop26):p2align=2
	block
	block
	i32.const	$push27=, 33
	i32.lt_u	$push28=, $2, $pop27
	br_if   	0, $pop28       # 0: down to label5
# BB#6:                                 # %if.then.i
	i32.const	$push35=, -32
	i32.add 	$push2=, $2, $pop35
	tee_local	$push97=, $7=, $pop2
	i32.const	$push36=, 31
	i32.gt_u	$push37=, $pop97, $pop36
	br_if   	1, $pop37       # 1: down to label4
# BB#7:                                 # %if.then2.i
	i32.const	$push38=, 1
	i32.shl 	$push39=, $pop38, $7
	i32.const	$push40=, -1
	i32.add 	$push41=, $pop39, $pop40
	i32.and 	$9=, $9, $pop41
	br      	1               # 1: down to label4
.LBB0_8:                                # %if.else.i
	end_block                       # label5:
	i32.const	$9=, 0
	i32.const	$push29=, 31
	i32.gt_u	$push30=, $2, $pop29
	br_if   	0, $pop30       # 0: down to label4
# BB#9:                                 # %if.then5.i
	i32.const	$push31=, 1
	i32.shl 	$push32=, $pop31, $2
	i32.const	$push33=, -1
	i32.add 	$push34=, $pop32, $pop33
	i32.and 	$8=, $8, $pop34
.LBB0_10:                               # %num_trim.exit
	end_block                       # label4:
	i32.const	$push42=, 4
	i32.add 	$push43=, $1, $pop42
	i32.store	$7=, 0($pop43), $8
	i32.store	$8=, 0($1), $9
	block
	i32.wrap/i64	$push44=, $6
	i32.const	$push108=, 0
	i32.eq  	$push109=, $pop44, $pop108
	br_if   	0, $pop109      # 0: down to label6
# BB#11:                                # %if.then21
	i32.const	$push45=, 0
	i32.store	$discard=, 12($1), $pop45
	br      	2               # 2: down to label0
.LBB0_12:                               # %if.else23
	end_block                       # label6:
	block
	block
	block
	i32.const	$push46=, 32
	i32.le_u	$push47=, $2, $pop46
	br_if   	0, $pop47       # 0: down to label9
# BB#13:                                # %if.else8.i
	i32.const	$10=, 0
	i32.const	$push61=, -1
	i32.const	$push100=, 0
	i32.const	$push58=, 1
	i32.const	$push56=, -33
	i32.add 	$push57=, $2, $pop56
	i32.shl 	$push59=, $pop58, $pop57
	i32.and 	$push60=, $8, $pop59
	i32.select	$11=, $pop61, $pop100, $pop60
	i32.const	$push62=, 63
	i32.gt_u	$push63=, $2, $pop62
	br_if   	2, $pop63       # 2: down to label7
	br      	1               # 1: down to label8
.LBB0_14:                               # %if.else3.i
	end_block                       # label9:
	i32.const	$10=, 1
	i32.const	$push48=, -1
	i32.const	$push52=, 0
	i32.const	$push99=, 1
	i32.const	$push98=, -1
	i32.add 	$push49=, $2, $pop98
	i32.shl 	$push50=, $pop99, $pop49
	i32.and 	$push51=, $7, $pop50
	i32.select	$11=, $pop48, $pop52, $pop51
	i32.const	$push53=, 31
	i32.gt_u	$push54=, $2, $pop53
	br_if   	0, $pop54       # 0: down to label8
# BB#15:                                # %if.then5.i64
	i32.shl 	$push55=, $11, $2
	i32.or  	$7=, $pop55, $7
	copy_local	$8=, $11
	br      	1               # 1: down to label7
.LBB0_16:                               # %if.then10.i
	end_block                       # label8:
	i32.const	$push64=, -32
	i32.add 	$push65=, $2, $pop64
	i32.shl 	$push66=, $11, $pop65
	i32.or  	$8=, $pop66, $8
	i32.const	$10=, 0
.LBB0_17:                               # %if.end15.i
	end_block                       # label7:
	i32.const	$push67=, 31
	i32.gt_u	$push68=, $3, $pop67
	tee_local	$push102=, $12=, $pop68
	i32.select	$9=, $8, $7, $pop102
	i32.select	$8=, $11, $8, $12
	block
	i32.const	$push69=, -32
	i32.add 	$push70=, $3, $pop69
	i32.select	$push3=, $pop70, $3, $12
	tee_local	$push101=, $3=, $pop3
	i32.const	$push110=, 0
	i32.eq  	$push111=, $pop101, $pop110
	br_if   	0, $pop111      # 0: down to label10
# BB#18:                                # %if.then24.i
	i32.const	$push72=, 32
	i32.sub 	$push73=, $pop72, $3
	tee_local	$push103=, $7=, $pop73
	i32.shl 	$push74=, $8, $pop103
	i32.shr_u	$push71=, $9, $3
	i32.or  	$9=, $pop74, $pop71
	i32.shr_u	$push75=, $8, $3
	i32.shl 	$push76=, $11, $7
	i32.or  	$8=, $pop75, $pop76
.LBB0_19:                               # %if.end38.i
	end_block                       # label10:
	block
	block
	i32.const	$push77=, 33
	i32.lt_u	$push78=, $2, $pop77
	br_if   	0, $pop78       # 0: down to label12
# BB#20:                                # %if.then.i61.i
	i32.const	$push83=, -32
	i32.add 	$push4=, $2, $pop83
	tee_local	$push104=, $2=, $pop4
	i32.const	$push84=, 31
	i32.gt_u	$push85=, $pop104, $pop84
	br_if   	1, $pop85       # 1: down to label11
# BB#21:                                # %if.then2.i.i
	i32.const	$push86=, 1
	i32.shl 	$push87=, $pop86, $2
	i32.const	$push88=, -1
	i32.add 	$push89=, $pop87, $pop88
	i32.and 	$8=, $8, $pop89
	br      	1               # 1: down to label11
.LBB0_22:                               # %if.else.i.i
	end_block                       # label12:
	i32.const	$8=, 0
	i32.const	$push112=, 0
	i32.eq  	$push113=, $10, $pop112
	br_if   	0, $pop113      # 0: down to label11
# BB#23:                                # %if.then5.i.i
	i32.const	$push79=, 1
	i32.shl 	$push80=, $pop79, $2
	i32.const	$push81=, -1
	i32.add 	$push82=, $pop80, $pop81
	i32.and 	$9=, $9, $pop82
.LBB0_24:                               # %num_rshift.exit
	end_block                       # label11:
	i32.ne  	$push91=, $5, $9
	i32.ne  	$push90=, $4, $8
	i32.or  	$push92=, $pop91, $pop90
	i32.store	$discard=, 12($1), $pop92
	br      	1               # 1: down to label0
.LBB0_25:                               # %if.then
	end_block                       # label1:
	block
	block
	i32.load	$push6=, 8($1)
	i32.const	$push114=, 0
	i32.eq  	$push115=, $pop6, $pop114
	br_if   	0, $pop115      # 0: down to label14
# BB#26:                                # %if.then.land.end_crit_edge
	i32.const	$2=, 0
	br      	1               # 1: down to label13
.LBB0_27:                               # %land.rhs
	end_block                       # label14:
	i32.load	$push10=, 0($1)
	i32.const	$push7=, 4
	i32.add 	$push8=, $1, $pop7
	i32.load	$push9=, 0($pop8)
	i32.or  	$push11=, $pop10, $pop9
	i32.const	$push12=, 0
	i32.ne  	$2=, $pop11, $pop12
.LBB0_28:                               # %land.end
	end_block                       # label13:
	i32.store	$discard=, 12($1), $2
	i64.const	$push13=, 0
	i64.store	$discard=, 0($1):p2align=2, $pop13
.LBB0_29:                               # %if.end37
	end_block                       # label0:
	i32.const	$push94=, 8
	i32.add 	$push96=, $1, $pop94
	i64.load	$6=, 0($pop96):p2align=2
	i64.load	$push93=, 0($1):p2align=2
	i64.store	$discard=, 0($0):p2align=2, $pop93
	i32.const	$push105=, 8
	i32.add 	$push95=, $0, $pop105
	i64.store	$discard=, 0($pop95):p2align=2, $6
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
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 32
	i32.sub 	$5=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$5=, 0($2), $5
	i32.const	$push0=, 0
	i32.load	$0=, n($pop0)
	i32.const	$push1=, 12
	i32.add 	$push2=, $5, $pop1
	i32.const	$push19=, 0
	i32.load	$push3=, num+12($pop19)
	i32.store	$discard=, 0($pop2), $pop3
	i32.const	$push4=, 8
	i32.add 	$push5=, $5, $pop4
	i32.const	$push18=, 0
	i32.load	$push6=, num+8($pop18)
	i32.store	$discard=, 0($pop5), $pop6
	i32.const	$push17=, 0
	i64.load	$push7=, num($pop17):p2align=2
	i64.store	$discard=, 0($5):p2align=2, $pop7
	i32.const	$push8=, 64
	i32.const	$3=, 16
	i32.add 	$3=, $5, $3
	call    	num_lshift@FUNCTION, $3, $5, $pop8, $0
	i32.const	$push9=, 4
	i32.const	$4=, 16
	i32.add 	$4=, $5, $4
	block
	i32.or  	$push10=, $4, $pop9
	i32.load	$push11=, 0($pop10)
	i32.const	$push12=, 196608
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label15
# BB#1:                                 # %if.end
	block
	i32.load	$push14=, 16($5):p2align=3
	br_if   	0, $pop14       # 0: down to label16
# BB#2:                                 # %if.end3
	block
	i32.load	$push15=, 28($5)
	br_if   	0, $pop15       # 0: down to label17
# BB#3:                                 # %if.end6
	i32.const	$push16=, 0
	call    	exit@FUNCTION, $pop16
	unreachable
.LBB1_4:                                # %if.then5
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB1_5:                                # %if.then2
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
.LBB1_6:                                # %if.then
	end_block                       # label15:
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
