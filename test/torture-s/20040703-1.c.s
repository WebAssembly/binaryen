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
	block
	block
	block
	block
	block
	i32.ge_u	$push2=, $3, $2
	br_if   	0, $pop2        # 0: down to label6
# BB#1:                                 # %if.else
	i32.load	$4=, 0($1)
	i32.load	$5=, 4($1)
	copy_local	$8=, $5
	copy_local	$9=, $4
	copy_local	$7=, $3
	block
	i32.const	$push11=, 32
	i32.lt_u	$push12=, $3, $pop11
	br_if   	0, $pop12       # 0: down to label7
# BB#2:                                 # %if.then5
	i32.const	$push15=, 4
	i32.add 	$push16=, $1, $pop15
	i32.const	$push13=, 0
	i32.store	$8=, 0($pop16), $pop13
	i32.const	$push14=, -32
	i32.add 	$7=, $3, $pop14
	i32.store	$9=, 0($1), $5
.LBB0_3:                                # %if.end
	end_block                       # label7:
	block
	i32.const	$push106=, 0
	i32.eq  	$push107=, $7, $pop106
	br_if   	0, $pop107      # 0: down to label8
# BB#4:                                 # %if.then10
	i32.const	$push18=, 32
	i32.sub 	$push19=, $pop18, $7
	i32.shr_u	$11=, $8, $pop19
	i32.const	$push20=, 4
	i32.add 	$push21=, $1, $pop20
	i32.shl 	$push1=, $8, $7
	i32.store	$8=, 0($pop21), $pop1
	i32.shl 	$push17=, $9, $7
	i32.or  	$push0=, $11, $pop17
	i32.store	$9=, 0($1), $pop0
.LBB0_5:                                # %if.end18
	end_block                       # label8:
	i32.const	$push22=, 8
	i32.add 	$push23=, $1, $pop22
	i64.load	$6=, 0($pop23):p2align=2
	i32.const	$push24=, 33
	i32.lt_u	$push25=, $2, $pop24
	br_if   	1, $pop25       # 1: down to label5
# BB#6:                                 # %if.then.i
	i32.const	$push32=, -32
	i32.add 	$push93=, $2, $pop32
	tee_local	$push92=, $7=, $pop93
	i32.const	$push33=, 31
	i32.gt_u	$push34=, $pop92, $pop33
	br_if   	2, $pop34       # 2: down to label4
# BB#7:                                 # %if.then2.i
	i32.const	$push35=, 1
	i32.shl 	$push36=, $pop35, $7
	i32.const	$push37=, -1
	i32.add 	$push38=, $pop36, $pop37
	i32.and 	$9=, $9, $pop38
	br      	2               # 2: down to label4
.LBB0_8:                                # %if.then
	end_block                       # label6:
	i32.load	$push3=, 8($1)
	i32.const	$push108=, 0
	i32.eq  	$push109=, $pop3, $pop108
	br_if   	2, $pop109      # 2: down to label3
# BB#9:                                 # %if.then.land.end_crit_edge
	i32.const	$2=, 0
	br      	3               # 3: down to label2
.LBB0_10:                               # %if.else.i
	end_block                       # label5:
	i32.const	$9=, 0
	i32.const	$push26=, 31
	i32.gt_u	$push27=, $2, $pop26
	br_if   	0, $pop27       # 0: down to label4
# BB#11:                                # %if.then5.i
	i32.const	$push28=, 1
	i32.shl 	$push29=, $pop28, $2
	i32.const	$push30=, -1
	i32.add 	$push31=, $pop29, $pop30
	i32.and 	$8=, $8, $pop31
.LBB0_12:                               # %num_trim.exit
	end_block                       # label4:
	i32.const	$push39=, 4
	i32.add 	$push40=, $1, $pop39
	i32.store	$7=, 0($pop40), $8
	i32.store	$8=, 0($1), $9
	i32.wrap/i64	$push41=, $6
	i32.const	$push110=, 0
	i32.eq  	$push111=, $pop41, $pop110
	br_if   	2, $pop111      # 2: down to label1
# BB#13:                                # %if.then21
	i32.const	$push42=, 0
	i32.store	$discard=, 12($1), $pop42
	br      	3               # 3: down to label0
.LBB0_14:                               # %land.rhs
	end_block                       # label3:
	i32.load	$push7=, 0($1)
	i32.const	$push4=, 4
	i32.add 	$push5=, $1, $pop4
	i32.load	$push6=, 0($pop5)
	i32.or  	$push8=, $pop7, $pop6
	i32.const	$push9=, 0
	i32.ne  	$2=, $pop8, $pop9
.LBB0_15:                               # %land.end
	end_block                       # label2:
	i32.store	$discard=, 12($1), $2
	i64.const	$push10=, 0
	i64.store	$discard=, 0($1):p2align=2, $pop10
	br      	1               # 1: down to label0
.LBB0_16:                               # %if.else23
	end_block                       # label1:
	block
	block
	block
	i32.const	$push43=, 32
	i32.le_u	$push44=, $2, $pop43
	br_if   	0, $pop44       # 0: down to label11
# BB#17:                                # %if.else8.i
	i32.const	$10=, 0
	i32.const	$push58=, -1
	i32.const	$push96=, 0
	i32.const	$push55=, 1
	i32.const	$push53=, -33
	i32.add 	$push54=, $2, $pop53
	i32.shl 	$push56=, $pop55, $pop54
	i32.and 	$push57=, $8, $pop56
	i32.select	$11=, $pop58, $pop96, $pop57
	i32.const	$push59=, 63
	i32.gt_u	$push60=, $2, $pop59
	br_if   	2, $pop60       # 2: down to label9
	br      	1               # 1: down to label10
.LBB0_18:                               # %if.else3.i
	end_block                       # label11:
	i32.const	$10=, 1
	i32.const	$push45=, -1
	i32.const	$push49=, 0
	i32.const	$push95=, 1
	i32.const	$push94=, -1
	i32.add 	$push46=, $2, $pop94
	i32.shl 	$push47=, $pop95, $pop46
	i32.and 	$push48=, $7, $pop47
	i32.select	$11=, $pop45, $pop49, $pop48
	i32.const	$push50=, 31
	i32.gt_u	$push51=, $2, $pop50
	br_if   	0, $pop51       # 0: down to label10
# BB#19:                                # %if.then5.i64
	i32.shl 	$push52=, $11, $2
	i32.or  	$7=, $pop52, $7
	copy_local	$8=, $11
	br      	1               # 1: down to label9
.LBB0_20:                               # %if.then10.i
	end_block                       # label10:
	i32.const	$push61=, -32
	i32.add 	$push62=, $2, $pop61
	i32.shl 	$push63=, $11, $pop62
	i32.or  	$8=, $pop63, $8
	i32.const	$10=, 0
.LBB0_21:                               # %if.end15.i
	end_block                       # label9:
	i32.const	$push64=, 31
	i32.gt_u	$push100=, $3, $pop64
	tee_local	$push99=, $12=, $pop100
	i32.select	$9=, $8, $7, $pop99
	i32.select	$8=, $11, $8, $12
	block
	i32.const	$push65=, -32
	i32.add 	$push66=, $3, $pop65
	i32.select	$push98=, $pop66, $3, $12
	tee_local	$push97=, $3=, $pop98
	i32.const	$push112=, 0
	i32.eq  	$push113=, $pop97, $pop112
	br_if   	0, $pop113      # 0: down to label12
# BB#22:                                # %if.then24.i
	i32.const	$push68=, 32
	i32.sub 	$push102=, $pop68, $3
	tee_local	$push101=, $7=, $pop102
	i32.shl 	$push69=, $8, $pop101
	i32.shr_u	$push67=, $9, $3
	i32.or  	$9=, $pop69, $pop67
	i32.shr_u	$push70=, $8, $3
	i32.shl 	$push71=, $11, $7
	i32.or  	$8=, $pop70, $pop71
.LBB0_23:                               # %if.end38.i
	end_block                       # label12:
	block
	block
	i32.const	$push72=, 33
	i32.lt_u	$push73=, $2, $pop72
	br_if   	0, $pop73       # 0: down to label14
# BB#24:                                # %if.then.i61.i
	i32.const	$push78=, -32
	i32.add 	$push104=, $2, $pop78
	tee_local	$push103=, $2=, $pop104
	i32.const	$push79=, 31
	i32.gt_u	$push80=, $pop103, $pop79
	br_if   	1, $pop80       # 1: down to label13
# BB#25:                                # %if.then2.i.i
	i32.const	$push81=, 1
	i32.shl 	$push82=, $pop81, $2
	i32.const	$push83=, -1
	i32.add 	$push84=, $pop82, $pop83
	i32.and 	$8=, $8, $pop84
	br      	1               # 1: down to label13
.LBB0_26:                               # %if.else.i.i
	end_block                       # label14:
	i32.const	$8=, 0
	i32.const	$push114=, 0
	i32.eq  	$push115=, $10, $pop114
	br_if   	0, $pop115      # 0: down to label13
# BB#27:                                # %if.then5.i.i
	i32.const	$push74=, 1
	i32.shl 	$push75=, $pop74, $2
	i32.const	$push76=, -1
	i32.add 	$push77=, $pop75, $pop76
	i32.and 	$9=, $9, $pop77
.LBB0_28:                               # %num_rshift.exit
	end_block                       # label13:
	i32.ne  	$push86=, $5, $9
	i32.ne  	$push85=, $4, $8
	i32.or  	$push87=, $pop86, $pop85
	i32.store	$discard=, 12($1), $pop87
.LBB0_29:                               # %if.end37
	end_block                       # label0:
	i32.const	$push89=, 8
	i32.add 	$push91=, $1, $pop89
	i64.load	$6=, 0($pop91):p2align=2
	i64.load	$push88=, 0($1):p2align=2
	i64.store	$discard=, 0($0):p2align=2, $pop88
	i32.const	$push105=, 8
	i32.add 	$push90=, $0, $pop105
	i64.store	$discard=, 0($pop90):p2align=2, $6
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
	block
	block
	i32.or  	$push10=, $4, $pop9
	i32.load	$push11=, 0($pop10)
	i32.const	$push12=, 196608
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label17
# BB#1:                                 # %if.end
	i32.load	$push14=, 16($5):p2align=3
	br_if   	1, $pop14       # 1: down to label16
# BB#2:                                 # %if.end3
	i32.load	$push15=, 28($5)
	br_if   	2, $pop15       # 2: down to label15
# BB#3:                                 # %if.end6
	i32.const	$push16=, 0
	call    	exit@FUNCTION, $pop16
	unreachable
.LBB1_4:                                # %if.then
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB1_5:                                # %if.then2
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
.LBB1_6:                                # %if.then5
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
