	.text
	.file	"20040703-1.c"
	.section	.text.num_lshift,"ax",@progbits
	.hidden	num_lshift              # -- Begin function num_lshift
	.globl	num_lshift
	.type	num_lshift,@function
num_lshift:                             # @num_lshift
	.param  	i32, i32, i32, i32
	.local  	i32, i32, i64, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	i32.ge_u	$push0=, $3, $2
	br_if   	0, $pop0        # 0: down to label6
# %bb.1:                                # %if.else
	i32.load	$5=, 4($1)
	i32.load	$4=, 0($1)
	copy_local	$8=, $5
	copy_local	$11=, $4
	copy_local	$9=, $3
	block   	
	i32.const	$push9=, 32
	i32.lt_u	$push10=, $3, $pop9
	br_if   	0, $pop10       # 0: down to label7
# %bb.2:                                # %if.then5
	i32.store	0($1), $5
	i32.const	$8=, 0
	i32.const	$push11=, 4
	i32.add 	$push12=, $1, $pop11
	i32.const	$push97=, 0
	i32.store	0($pop12), $pop97
	i32.const	$push13=, -32
	i32.add 	$9=, $3, $pop13
	copy_local	$11=, $5
.LBB0_3:                                # %if.end
	end_block                       # label7:
	i32.eqz 	$push102=, $9
	br_if   	1, $pop102      # 1: down to label5
# %bb.4:                                # %if.then10
	i32.shl 	$10=, $8, $9
	i32.const	$push14=, 4
	i32.add 	$push15=, $1, $pop14
	i32.store	0($pop15), $10
	i32.const	$push17=, 32
	i32.sub 	$push18=, $pop17, $9
	i32.shr_u	$push19=, $8, $pop18
	i32.shl 	$push16=, $11, $9
	i32.or  	$11=, $pop19, $pop16
	i32.store	0($1), $11
	br      	2               # 2: down to label4
.LBB0_5:                                # %if.then
	end_block                       # label6:
	i32.load	$push1=, 8($1)
	i32.eqz 	$push103=, $pop1
	br_if   	2, $pop103      # 2: down to label3
# %bb.6:                                # %if.then.land.end_crit_edge
	i32.const	$2=, 0
	br      	3               # 3: down to label2
.LBB0_7:
	end_block                       # label5:
	copy_local	$10=, $8
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
# %bb.9:                                # %if.then.i
	i32.const	$push30=, -32
	i32.add 	$9=, $2, $pop30
	i32.const	$push31=, 31
	i32.gt_u	$push32=, $9, $pop31
	br_if   	1, $pop32       # 1: down to label8
# %bb.10:                               # %if.then2.i
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
# %bb.12:                               # %if.then5.i
	i32.const	$push26=, 1
	i32.shl 	$push27=, $pop26, $2
	i32.const	$push28=, -1
	i32.add 	$push29=, $pop27, $pop28
	i32.and 	$10=, $10, $pop29
.LBB0_13:                               # %num_trim.exit
	end_block                       # label8:
	i32.store	0($1), $11
	i32.const	$push37=, 4
	i32.add 	$push38=, $1, $pop37
	i32.store	0($pop38), $10
	i32.wrap/i64	$push39=, $6
	i32.eqz 	$push104=, $pop39
	br_if   	2, $pop104      # 2: down to label1
# %bb.14:                               # %if.then21
	i32.const	$push40=, 12
	i32.add 	$push41=, $1, $pop40
	i32.const	$push42=, 0
	i32.store	0($pop41), $pop42
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
.LBB0_17:                               # %if.else23
	end_block                       # label1:
	block   	
	block   	
	block   	
	block   	
	i32.const	$push98=, 32
	i32.le_u	$push43=, $2, $pop98
	br_if   	0, $pop43       # 0: down to label13
# %bb.18:                               # %if.else8.i
	i32.const	$push58=, -1
	i32.const	$push57=, 0
	i32.const	$push54=, 1
	i32.const	$push52=, -33
	i32.add 	$push53=, $2, $pop52
	i32.shl 	$push55=, $pop54, $pop53
	i32.and 	$push56=, $11, $pop55
	i32.select	$8=, $pop58, $pop57, $pop56
	i32.const	$push59=, 63
	i32.le_u	$push60=, $2, $pop59
	br_if   	1, $pop60       # 1: down to label12
	br      	3               # 3: down to label10
.LBB0_19:                               # %if.else3.i
	end_block                       # label13:
	i32.const	$push44=, -1
	i32.const	$push49=, 0
	i32.const	$push46=, 1
	i32.const	$push100=, -1
	i32.add 	$push45=, $2, $pop100
	i32.shl 	$push47=, $pop46, $pop45
	i32.and 	$push48=, $10, $pop47
	i32.select	$8=, $pop44, $pop49, $pop48
	i32.const	$push99=, 32
	i32.ne  	$push50=, $2, $pop99
	br_if   	1, $pop50       # 1: down to label11
.LBB0_20:                               # %if.then10.i
	end_block                       # label12:
	i32.const	$push61=, -32
	i32.add 	$push62=, $2, $pop61
	i32.shl 	$push63=, $8, $pop62
	i32.or  	$11=, $pop63, $11
	br      	1               # 1: down to label10
.LBB0_21:                               # %if.then5.i64
	end_block                       # label11:
	i32.shl 	$push51=, $8, $2
	i32.or  	$10=, $pop51, $10
	copy_local	$11=, $8
.LBB0_22:                               # %if.end15.i
	end_block                       # label10:
	i32.const	$push64=, 31
	i32.gt_u	$9=, $3, $pop64
	i32.const	$push65=, -32
	i32.add 	$push66=, $3, $pop65
	i32.select	$3=, $pop66, $3, $9
	i32.select	$7=, $8, $11, $9
	i32.select	$11=, $11, $10, $9
	block   	
	block   	
	i32.eqz 	$push105=, $3
	br_if   	0, $pop105      # 0: down to label15
# %bb.23:                               # %if.then24.i
	i32.const	$push68=, 32
	i32.sub 	$10=, $pop68, $3
	i32.shr_u	$push67=, $7, $3
	i32.shl 	$push69=, $8, $10
	i32.or  	$9=, $pop67, $pop69
	i32.shl 	$push71=, $7, $10
	i32.shr_u	$push70=, $11, $3
	i32.or  	$11=, $pop71, $pop70
	br      	1               # 1: down to label14
.LBB0_24:
	end_block                       # label15:
	copy_local	$9=, $7
.LBB0_25:                               # %if.end38.i
	end_block                       # label14:
	block   	
	block   	
	i32.const	$push72=, 33
	i32.lt_u	$push73=, $2, $pop72
	br_if   	0, $pop73       # 0: down to label17
# %bb.26:                               # %if.then.i61.i
	i32.const	$push80=, -32
	i32.add 	$2=, $2, $pop80
	i32.const	$push81=, 31
	i32.gt_u	$push82=, $2, $pop81
	br_if   	1, $pop82       # 1: down to label16
# %bb.27:                               # %if.then2.i.i
	i32.const	$push83=, 1
	i32.shl 	$push84=, $pop83, $2
	i32.const	$push85=, -1
	i32.add 	$push86=, $pop84, $pop85
	i32.and 	$9=, $9, $pop86
	br      	1               # 1: down to label16
.LBB0_28:                               # %if.else.i.i
	end_block                       # label17:
	i32.const	$9=, 0
	i32.const	$push74=, 32
	i32.eq  	$push75=, $2, $pop74
	br_if   	0, $pop75       # 0: down to label16
# %bb.29:                               # %if.then5.i.i
	i32.const	$push76=, 1
	i32.shl 	$push77=, $pop76, $2
	i32.const	$push78=, -1
	i32.add 	$push79=, $pop77, $pop78
	i32.and 	$11=, $11, $pop79
.LBB0_30:                               # %num_rshift.exit
	end_block                       # label16:
	i32.const	$push90=, 12
	i32.add 	$push91=, $1, $pop90
	i32.ne  	$push88=, $5, $11
	i32.ne  	$push87=, $4, $9
	i32.or  	$push89=, $pop88, $pop87
	i32.store	0($pop91), $pop89
.LBB0_31:                               # %if.end36
	end_block                       # label0:
	i64.load	$push92=, 0($1):p2align=2
	i64.store	0($0):p2align=2, $pop92
	i32.const	$push93=, 8
	i32.add 	$push94=, $0, $pop93
	i32.const	$push101=, 8
	i32.add 	$push95=, $1, $pop101
	i64.load	$push96=, 0($pop95):p2align=2
	i64.store	0($pop94):p2align=2, $pop96
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	num_lshift, .Lfunc_end0-num_lshift
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i64, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push27=, 0
	i32.load	$0=, n($pop27)
	block   	
	i32.const	$push0=, 63
	i32.gt_u	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label18
# %bb.1:                                # %if.else.i
	i32.const	$push31=, 0
	i64.load32_u	$6=, num+8($pop31)
	i32.const	$push30=, 0
	i32.load	$2=, num+4($pop30)
	i32.const	$push29=, 0
	i32.load	$1=, num($pop29)
	i32.const	$push2=, 31
	i32.gt_u	$7=, $0, $pop2
	i32.const	$push3=, -32
	i32.add 	$push4=, $0, $pop3
	i32.select	$3=, $pop4, $0, $7
	i32.select	$9=, $2, $1, $7
	i32.const	$push28=, 0
	i32.select	$7=, $pop28, $2, $7
	block   	
	i32.eqz 	$push33=, $3
	br_if   	0, $pop33       # 0: down to label19
# %bb.2:                                # %if.then10.i
	i32.const	$push6=, 32
	i32.sub 	$push7=, $pop6, $3
	i32.shr_u	$push8=, $7, $pop7
	i32.shl 	$push5=, $9, $3
	i32.or  	$9=, $pop8, $pop5
	i32.shl 	$7=, $7, $3
.LBB1_3:                                # %if.end18.i
	end_block                       # label19:
	block   	
	i32.wrap/i64	$push9=, $6
	br_if   	0, $pop9        # 0: down to label20
# %bb.4:                                # %if.else23.i
	i32.const	$push10=, 31
	i32.gt_u	$0=, $0, $pop10
	i32.const	$push32=, 31
	i32.shr_s	$4=, $9, $pop32
	i32.select	$5=, $4, $9, $0
	i32.select	$0=, $9, $7, $0
	block   	
	block   	
	br_if   	0, $3           # 0: down to label22
# %bb.5:
	copy_local	$4=, $5
	br      	1               # 1: down to label21
.LBB1_6:                                # %if.then24.i.i
	end_block                       # label22:
	i32.const	$push12=, 32
	i32.sub 	$8=, $pop12, $3
	i32.shr_u	$push11=, $5, $3
	i32.shl 	$push13=, $4, $8
	i32.or  	$4=, $pop11, $pop13
	i32.shl 	$push15=, $5, $8
	i32.shr_u	$push14=, $0, $3
	i32.or  	$0=, $pop15, $pop14
.LBB1_7:                                # %if.end38.i.i
	end_block                       # label21:
	i32.ne  	$push17=, $2, $0
	i32.ne  	$push16=, $1, $4
	i32.or  	$push18=, $pop17, $pop16
	i64.extend_u/i32	$push19=, $pop18
	i64.const	$push20=, 32
	i64.shl 	$push21=, $pop19, $pop20
	i64.or  	$6=, $pop21, $6
.LBB1_8:                                # %num_lshift.exit
	end_block                       # label20:
	i32.const	$push22=, 196608
	i32.ne  	$push23=, $7, $pop22
	br_if   	0, $pop23       # 0: down to label18
# %bb.9:                                # %if.end
	br_if   	0, $9           # 0: down to label18
# %bb.10:                               # %if.end3
	i64.const	$push24=, 4294967296
	i64.ge_u	$push25=, $6, $pop24
	br_if   	0, $pop25       # 0: down to label18
# %bb.11:                               # %if.end6
	i32.const	$push26=, 0
	call    	exit@FUNCTION, $pop26
	unreachable
.LBB1_12:                               # %if.then
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
