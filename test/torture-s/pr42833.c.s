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
	i32.const	$push92=, 24
	i32.shl 	$push0=, $1, $pop92
	tee_local	$push91=, $5=, $pop0
	i32.const	$push6=, 117440512
	i32.gt_s	$push7=, $pop91, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.else
	block
	i32.const	$push8=, -134217729
	i32.gt_s	$push9=, $5, $pop8
	br_if   	0, $pop9        # 0: down to label1
# BB#2:                                 # %if.then13
	i32.const	$push21=, 24
	i32.shl 	$push22=, $0, $pop21
	i32.const	$push23=, 31
	i32.shr_s	$3=, $pop22, $pop23
	br      	1               # 1: down to label0
.LBB0_3:                                # %if.else18
	end_block                       # label1:
	i32.const	$3=, 0
	i32.const	$push94=, 24
	i32.shr_s	$push1=, $5, $pop94
	tee_local	$push93=, $6=, $pop1
	i32.const	$push10=, -8
	i32.eq  	$push11=, $pop93, $pop10
	br_if   	0, $pop11       # 0: down to label0
# BB#4:                                 # %if.else34
	i32.const	$push12=, 24
	i32.shl 	$push13=, $0, $pop12
	i32.const	$push96=, 24
	i32.shr_s	$3=, $pop13, $pop96
	block
	i32.const	$push95=, -1
	i32.le_s	$push14=, $5, $pop95
	br_if   	0, $pop14       # 0: down to label2
# BB#5:                                 # %if.else48
	i32.shl 	$3=, $3, $6
	br      	1               # 1: down to label0
.LBB0_6:                                # %if.then38
	end_block                       # label2:
	i32.const	$push16=, 1
	i32.const	$push97=, -1
	i32.xor 	$push15=, $6, $pop97
	i32.shl 	$push17=, $pop16, $pop15
	i32.add 	$push18=, $pop17, $3
	i32.const	$push19=, 0
	i32.sub 	$push20=, $pop19, $6
	i32.shr_s	$3=, $pop18, $pop20
.LBB0_7:                                # %if.end57
	end_block                       # label0:
	block
	i32.const	$push101=, 16
	i32.shl 	$push24=, $1, $pop101
	i32.const	$push100=, 24
	i32.shr_s	$push2=, $pop24, $pop100
	tee_local	$push99=, $5=, $pop2
	i32.const	$push98=, 7
	i32.gt_s	$push25=, $pop99, $pop98
	br_if   	0, $pop25       # 0: down to label3
# BB#8:                                 # %if.else68
	i32.const	$push5=, 8
	i32.shr_u	$6=, $0, $pop5
	block
	i32.const	$push26=, -9
	i32.gt_s	$push27=, $5, $pop26
	br_if   	0, $pop27       # 0: down to label4
# BB#9:                                 # %if.then72
	i32.const	$push39=, 24
	i32.shl 	$push40=, $6, $pop39
	i32.const	$push41=, 31
	i32.shr_s	$4=, $pop40, $pop41
	br      	1               # 1: down to label3
.LBB0_10:                               # %if.else78
	end_block                       # label4:
	i32.const	$push28=, -8
	i32.eq  	$push29=, $5, $pop28
	br_if   	0, $pop29       # 0: down to label3
# BB#11:                                # %if.else96
	i32.const	$push30=, 24
	i32.shl 	$push31=, $6, $pop30
	i32.const	$push103=, 24
	i32.shr_s	$4=, $pop31, $pop103
	block
	i32.const	$push102=, -1
	i32.le_s	$push32=, $5, $pop102
	br_if   	0, $pop32       # 0: down to label5
# BB#12:                                # %if.else112
	i32.shl 	$4=, $4, $5
	br      	1               # 1: down to label3
.LBB0_13:                               # %if.then100
	end_block                       # label5:
	i32.const	$push34=, 1
	i32.const	$push104=, -1
	i32.xor 	$push33=, $5, $pop104
	i32.shl 	$push35=, $pop34, $pop33
	i32.add 	$push36=, $pop35, $4
	i32.const	$push37=, 0
	i32.sub 	$push38=, $pop37, $5
	i32.shr_s	$4=, $pop36, $pop38
.LBB0_14:                               # %if.end122
	end_block                       # label3:
	i32.const	$6=, 0
	i32.const	$5=, 0
	block
	i32.const	$push42=, 8
	i32.shl 	$push43=, $1, $pop42
	i32.const	$push107=, 24
	i32.shr_s	$push3=, $pop43, $pop107
	tee_local	$push106=, $7=, $pop3
	i32.const	$push105=, 7
	i32.gt_s	$push44=, $pop106, $pop105
	br_if   	0, $pop44       # 0: down to label6
# BB#15:                                # %if.else133
	i32.const	$push108=, 16
	i32.shr_u	$2=, $0, $pop108
	block
	i32.const	$push45=, -9
	i32.gt_s	$push46=, $7, $pop45
	br_if   	0, $pop46       # 0: down to label7
# BB#16:                                # %if.then137
	i32.const	$push58=, 24
	i32.shl 	$push59=, $2, $pop58
	i32.const	$push60=, 31
	i32.shr_s	$5=, $pop59, $pop60
	br      	1               # 1: down to label6
.LBB0_17:                               # %if.else143
	end_block                       # label7:
	i32.const	$5=, 0
	i32.const	$push47=, -8
	i32.eq  	$push48=, $7, $pop47
	br_if   	0, $pop48       # 0: down to label6
# BB#18:                                # %if.else161
	i32.const	$push49=, 24
	i32.shl 	$push50=, $2, $pop49
	i32.const	$push110=, 24
	i32.shr_s	$5=, $pop50, $pop110
	block
	i32.const	$push109=, -1
	i32.le_s	$push51=, $7, $pop109
	br_if   	0, $pop51       # 0: down to label8
# BB#19:                                # %if.else177
	i32.shl 	$5=, $5, $7
	br      	1               # 1: down to label6
.LBB0_20:                               # %if.then165
	end_block                       # label8:
	i32.const	$push53=, 1
	i32.const	$push111=, -1
	i32.xor 	$push52=, $7, $pop111
	i32.shl 	$push54=, $pop53, $pop52
	i32.add 	$push55=, $pop54, $5
	i32.const	$push56=, 0
	i32.sub 	$push57=, $pop56, $7
	i32.shr_s	$5=, $pop55, $pop57
.LBB0_21:                               # %if.end187
	end_block                       # label6:
	block
	i32.const	$push113=, 24
	i32.shr_s	$push4=, $1, $pop113
	tee_local	$push112=, $1=, $pop4
	i32.const	$push61=, 7
	i32.gt_s	$push62=, $pop112, $pop61
	br_if   	0, $pop62       # 0: down to label9
# BB#22:                                # %if.else199
	block
	i32.const	$push63=, -9
	i32.gt_s	$push64=, $1, $pop63
	br_if   	0, $pop64       # 0: down to label10
# BB#23:                                # %if.then203
	i32.const	$push75=, 31
	i32.shr_s	$6=, $0, $pop75
	br      	1               # 1: down to label9
.LBB0_24:                               # %if.else209
	end_block                       # label10:
	i32.const	$push65=, -8
	i32.eq  	$push66=, $1, $pop65
	br_if   	0, $pop66       # 0: down to label9
# BB#25:                                # %if.else227
	i32.const	$push67=, 24
	i32.shr_s	$0=, $0, $pop67
	block
	i32.const	$push114=, -1
	i32.le_s	$push68=, $1, $pop114
	br_if   	0, $pop68       # 0: down to label11
# BB#26:                                # %if.else243
	i32.shl 	$6=, $0, $1
	br      	1               # 1: down to label9
.LBB0_27:                               # %if.then231
	end_block                       # label11:
	i32.const	$push70=, 1
	i32.const	$push115=, -1
	i32.xor 	$push69=, $1, $pop115
	i32.shl 	$push71=, $pop70, $pop69
	i32.add 	$push72=, $pop71, $0
	i32.const	$push73=, 0
	i32.sub 	$push74=, $pop73, $1
	i32.shr_s	$6=, $pop72, $pop74
.LBB0_28:                               # %if.end253
	end_block                       # label9:
	i32.const	$push82=, 8
	i32.shl 	$push83=, $4, $pop82
	i32.const	$push84=, 65280
	i32.and 	$push85=, $pop83, $pop84
	i32.const	$push86=, 255
	i32.and 	$push87=, $3, $pop86
	i32.or  	$push88=, $pop85, $pop87
	i32.const	$push78=, 16
	i32.shl 	$push79=, $5, $pop78
	i32.const	$push80=, 16711680
	i32.and 	$push81=, $pop79, $pop80
	i32.or  	$push89=, $pop88, $pop81
	i32.const	$push76=, 24
	i32.shl 	$push77=, $6, $pop76
	i32.or  	$push90=, $pop89, $pop77
	return  	$pop90
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
