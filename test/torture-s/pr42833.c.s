	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr42833.c"
	.section	.text.helper_neon_rshl_s8,"ax",@progbits
	.hidden	helper_neon_rshl_s8
	.globl	helper_neon_rshl_s8
	.type	helper_neon_rshl_s8,@function
helper_neon_rshl_s8:                    # @helper_neon_rshl_s8
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, 0
	i32.const	$3=, 0
	block
	i32.const	$push88=, 24
	i32.shl 	$push87=, $1, $pop88
	tee_local	$push86=, $5=, $pop87
	i32.const	$push1=, 117440512
	i32.gt_s	$push2=, $pop86, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.else
	block
	i32.const	$push3=, -134217729
	i32.gt_s	$push4=, $5, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#2:                                 # %if.then13
	i32.const	$push16=, 24
	i32.shl 	$push17=, $0, $pop16
	i32.const	$push18=, 31
	i32.shr_s	$3=, $pop17, $pop18
	br      	1               # 1: down to label0
.LBB0_3:                                # %if.else18
	end_block                       # label1:
	i32.const	$3=, 0
	i32.const	$push91=, 24
	i32.shr_s	$push90=, $5, $pop91
	tee_local	$push89=, $6=, $pop90
	i32.const	$push5=, -8
	i32.eq  	$push6=, $pop89, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#4:                                 # %if.else34
	i32.const	$push7=, 24
	i32.shl 	$push8=, $0, $pop7
	i32.const	$push93=, 24
	i32.shr_s	$3=, $pop8, $pop93
	block
	i32.const	$push92=, -1
	i32.le_s	$push9=, $5, $pop92
	br_if   	0, $pop9        # 0: down to label2
# BB#5:                                 # %if.else48
	i32.shl 	$3=, $3, $6
	br      	1               # 1: down to label0
.LBB0_6:                                # %if.then38
	end_block                       # label2:
	i32.const	$push11=, 1
	i32.const	$push94=, -1
	i32.xor 	$push10=, $6, $pop94
	i32.shl 	$push12=, $pop11, $pop10
	i32.add 	$push13=, $pop12, $3
	i32.const	$push14=, 0
	i32.sub 	$push15=, $pop14, $6
	i32.shr_s	$3=, $pop13, $pop15
.LBB0_7:                                # %if.end57
	end_block                       # label0:
	block
	i32.const	$push99=, 16
	i32.shl 	$push19=, $1, $pop99
	i32.const	$push98=, 24
	i32.shr_s	$push97=, $pop19, $pop98
	tee_local	$push96=, $5=, $pop97
	i32.const	$push95=, 7
	i32.gt_s	$push20=, $pop96, $pop95
	br_if   	0, $pop20       # 0: down to label3
# BB#8:                                 # %if.else68
	i32.const	$push0=, 8
	i32.shr_u	$6=, $0, $pop0
	block
	i32.const	$push21=, -9
	i32.gt_s	$push22=, $5, $pop21
	br_if   	0, $pop22       # 0: down to label4
# BB#9:                                 # %if.then72
	i32.const	$push34=, 24
	i32.shl 	$push35=, $6, $pop34
	i32.const	$push36=, 31
	i32.shr_s	$4=, $pop35, $pop36
	br      	1               # 1: down to label3
.LBB0_10:                               # %if.else78
	end_block                       # label4:
	i32.const	$push23=, -8
	i32.eq  	$push24=, $5, $pop23
	br_if   	0, $pop24       # 0: down to label3
# BB#11:                                # %if.else96
	i32.const	$push25=, 24
	i32.shl 	$push26=, $6, $pop25
	i32.const	$push101=, 24
	i32.shr_s	$4=, $pop26, $pop101
	block
	i32.const	$push100=, -1
	i32.le_s	$push27=, $5, $pop100
	br_if   	0, $pop27       # 0: down to label5
# BB#12:                                # %if.else112
	i32.shl 	$4=, $4, $5
	br      	1               # 1: down to label3
.LBB0_13:                               # %if.then100
	end_block                       # label5:
	i32.const	$push29=, 1
	i32.const	$push102=, -1
	i32.xor 	$push28=, $5, $pop102
	i32.shl 	$push30=, $pop29, $pop28
	i32.add 	$push31=, $pop30, $4
	i32.const	$push32=, 0
	i32.sub 	$push33=, $pop32, $5
	i32.shr_s	$4=, $pop31, $pop33
.LBB0_14:                               # %if.end122
	end_block                       # label3:
	i32.const	$6=, 0
	i32.const	$5=, 0
	block
	i32.const	$push37=, 8
	i32.shl 	$push38=, $1, $pop37
	i32.const	$push106=, 24
	i32.shr_s	$push105=, $pop38, $pop106
	tee_local	$push104=, $7=, $pop105
	i32.const	$push103=, 7
	i32.gt_s	$push39=, $pop104, $pop103
	br_if   	0, $pop39       # 0: down to label6
# BB#15:                                # %if.else133
	i32.const	$push107=, 16
	i32.shr_u	$2=, $0, $pop107
	block
	i32.const	$push40=, -9
	i32.gt_s	$push41=, $7, $pop40
	br_if   	0, $pop41       # 0: down to label7
# BB#16:                                # %if.then137
	i32.const	$push53=, 24
	i32.shl 	$push54=, $2, $pop53
	i32.const	$push55=, 31
	i32.shr_s	$5=, $pop54, $pop55
	br      	1               # 1: down to label6
.LBB0_17:                               # %if.else143
	end_block                       # label7:
	i32.const	$5=, 0
	i32.const	$push42=, -8
	i32.eq  	$push43=, $7, $pop42
	br_if   	0, $pop43       # 0: down to label6
# BB#18:                                # %if.else161
	i32.const	$push44=, 24
	i32.shl 	$push45=, $2, $pop44
	i32.const	$push109=, 24
	i32.shr_s	$5=, $pop45, $pop109
	block
	i32.const	$push108=, -1
	i32.le_s	$push46=, $7, $pop108
	br_if   	0, $pop46       # 0: down to label8
# BB#19:                                # %if.else177
	i32.shl 	$5=, $5, $7
	br      	1               # 1: down to label6
.LBB0_20:                               # %if.then165
	end_block                       # label8:
	i32.const	$push48=, 1
	i32.const	$push110=, -1
	i32.xor 	$push47=, $7, $pop110
	i32.shl 	$push49=, $pop48, $pop47
	i32.add 	$push50=, $pop49, $5
	i32.const	$push51=, 0
	i32.sub 	$push52=, $pop51, $7
	i32.shr_s	$5=, $pop50, $pop52
.LBB0_21:                               # %if.end187
	end_block                       # label6:
	block
	i32.const	$push113=, 24
	i32.shr_s	$push112=, $1, $pop113
	tee_local	$push111=, $1=, $pop112
	i32.const	$push56=, 7
	i32.gt_s	$push57=, $pop111, $pop56
	br_if   	0, $pop57       # 0: down to label9
# BB#22:                                # %if.else199
	block
	i32.const	$push58=, -9
	i32.gt_s	$push59=, $1, $pop58
	br_if   	0, $pop59       # 0: down to label10
# BB#23:                                # %if.then203
	i32.const	$push70=, 31
	i32.shr_s	$6=, $0, $pop70
	br      	1               # 1: down to label9
.LBB0_24:                               # %if.else209
	end_block                       # label10:
	i32.const	$push60=, -8
	i32.eq  	$push61=, $1, $pop60
	br_if   	0, $pop61       # 0: down to label9
# BB#25:                                # %if.else227
	i32.const	$push62=, 24
	i32.shr_s	$0=, $0, $pop62
	block
	i32.const	$push114=, -1
	i32.le_s	$push63=, $1, $pop114
	br_if   	0, $pop63       # 0: down to label11
# BB#26:                                # %if.else243
	i32.shl 	$6=, $0, $1
	br      	1               # 1: down to label9
.LBB0_27:                               # %if.then231
	end_block                       # label11:
	i32.const	$push65=, 1
	i32.const	$push115=, -1
	i32.xor 	$push64=, $1, $pop115
	i32.shl 	$push66=, $pop65, $pop64
	i32.add 	$push67=, $pop66, $0
	i32.const	$push68=, 0
	i32.sub 	$push69=, $pop68, $1
	i32.shr_s	$6=, $pop67, $pop69
.LBB0_28:                               # %if.end253
	end_block                       # label9:
	i32.const	$push77=, 8
	i32.shl 	$push78=, $4, $pop77
	i32.const	$push79=, 65280
	i32.and 	$push80=, $pop78, $pop79
	i32.const	$push81=, 255
	i32.and 	$push82=, $3, $pop81
	i32.or  	$push83=, $pop80, $pop82
	i32.const	$push73=, 16
	i32.shl 	$push74=, $5, $pop73
	i32.const	$push75=, 16711680
	i32.and 	$push76=, $pop74, $pop75
	i32.or  	$push84=, $pop83, $pop76
	i32.const	$push71=, 24
	i32.shl 	$push72=, $6, $pop71
	i32.or  	$push85=, $pop84, $pop72
	return  	$pop85
	.endfunc
.Lfunc_end0:
	.size	helper_neon_rshl_s8, .Lfunc_end0-helper_neon_rshl_s8

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
