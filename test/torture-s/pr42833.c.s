	.text
	.file	"pr42833.c"
	.section	.text.helper_neon_rshl_s8,"ax",@progbits
	.hidden	helper_neon_rshl_s8     # -- Begin function helper_neon_rshl_s8
	.globl	helper_neon_rshl_s8
	.type	helper_neon_rshl_s8,@function
helper_neon_rshl_s8:                    # @helper_neon_rshl_s8
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push94=, 24
	i32.shl 	$3=, $1, $pop94
	i32.const	$6=, 0
	i32.const	$5=, 0
	block   	
	i32.const	$push1=, 117440512
	i32.gt_s	$push2=, $3, $pop1
	br_if   	0, $pop2        # 0: down to label0
# %bb.1:                                # %if.else
	block   	
	i32.const	$push3=, -134217729
	i32.gt_s	$push4=, $3, $pop3
	br_if   	0, $pop4        # 0: down to label1
# %bb.2:                                # %if.then13
	i32.const	$push26=, 24
	i32.shl 	$push27=, $0, $pop26
	i32.const	$push28=, 31
	i32.shr_s	$5=, $pop27, $pop28
	br      	1               # 1: down to label0
.LBB0_3:                                # %if.else18
	end_block                       # label1:
	i32.const	$push95=, 24
	i32.shr_s	$7=, $3, $pop95
	block   	
	i32.const	$push5=, -134217728
	i32.ne  	$push6=, $3, $pop5
	br_if   	0, $pop6        # 0: down to label2
# %bb.4:                                # %if.then22
	i32.const	$push18=, 24
	i32.shl 	$push19=, $0, $pop18
	i32.const	$push97=, 24
	i32.shr_s	$push20=, $pop19, $pop97
	i32.const	$push16=, -1
	i32.add 	$push17=, $7, $pop16
	i32.shr_s	$push21=, $pop20, $pop17
	i32.const	$push96=, 24
	i32.shl 	$push22=, $pop21, $pop96
	i32.const	$push23=, 16777216
	i32.add 	$push24=, $pop22, $pop23
	i32.const	$push25=, 25
	i32.shr_s	$5=, $pop24, $pop25
	br      	1               # 1: down to label0
.LBB0_5:                                # %if.else34
	end_block                       # label2:
	i32.const	$push7=, 24
	i32.shl 	$push8=, $0, $pop7
	i32.const	$push99=, 24
	i32.shr_s	$5=, $pop8, $pop99
	block   	
	i32.const	$push98=, -1
	i32.le_s	$push9=, $3, $pop98
	br_if   	0, $pop9        # 0: down to label3
# %bb.6:                                # %if.else48
	i32.shl 	$5=, $5, $7
	br      	1               # 1: down to label0
.LBB0_7:                                # %if.then38
	end_block                       # label3:
	i32.const	$push13=, 1
	i32.const	$push100=, -1
	i32.xor 	$push12=, $7, $pop100
	i32.shl 	$push14=, $pop13, $pop12
	i32.add 	$push15=, $pop14, $5
	i32.const	$push10=, 0
	i32.sub 	$push11=, $pop10, $7
	i32.shr_s	$5=, $pop15, $pop11
.LBB0_8:                                # %if.end57
	end_block                       # label0:
	i32.const	$push102=, 16
	i32.shl 	$3=, $1, $pop102
	block   	
	i32.const	$push101=, 134217727
	i32.gt_s	$push29=, $3, $pop101
	br_if   	0, $pop29       # 0: down to label4
# %bb.9:                                # %if.else67
	i32.const	$push0=, 8
	i32.shr_u	$7=, $0, $pop0
	block   	
	i32.const	$push30=, -134217729
	i32.gt_s	$push31=, $3, $pop30
	br_if   	0, $pop31       # 0: down to label5
# %bb.10:                               # %if.then71
	i32.const	$push43=, 24
	i32.shl 	$push44=, $7, $pop43
	i32.const	$push45=, 31
	i32.shr_s	$6=, $pop44, $pop45
	br      	1               # 1: down to label4
.LBB0_11:                               # %if.else77
	end_block                       # label5:
	i32.const	$push103=, 24
	i32.shr_s	$8=, $3, $pop103
	i32.const	$push32=, -8
	i32.eq  	$push33=, $8, $pop32
	br_if   	0, $pop33       # 0: down to label4
# %bb.12:                               # %if.else95
	i32.const	$push34=, 24
	i32.shl 	$push35=, $7, $pop34
	i32.const	$push105=, 24
	i32.shr_s	$7=, $pop35, $pop105
	block   	
	i32.const	$push104=, -1
	i32.le_s	$push36=, $3, $pop104
	br_if   	0, $pop36       # 0: down to label6
# %bb.13:                               # %if.else111
	i32.shl 	$6=, $7, $8
	br      	1               # 1: down to label4
.LBB0_14:                               # %if.then99
	end_block                       # label6:
	i32.const	$push40=, 1
	i32.const	$push106=, -1
	i32.xor 	$push39=, $8, $pop106
	i32.shl 	$push41=, $pop40, $pop39
	i32.add 	$push42=, $pop41, $7
	i32.const	$push37=, 0
	i32.sub 	$push38=, $pop37, $8
	i32.shr_s	$6=, $pop42, $pop38
.LBB0_15:                               # %if.end121
	end_block                       # label4:
	i32.const	$push46=, 8
	i32.shl 	$3=, $1, $pop46
	i32.const	$8=, 0
	i32.const	$7=, 0
	block   	
	i32.const	$push107=, 134217727
	i32.gt_s	$push47=, $3, $pop107
	br_if   	0, $pop47       # 0: down to label7
# %bb.16:                               # %if.else131
	i32.const	$push108=, 16
	i32.shr_u	$2=, $0, $pop108
	block   	
	i32.const	$push48=, -134217729
	i32.gt_s	$push49=, $3, $pop48
	br_if   	0, $pop49       # 0: down to label8
# %bb.17:                               # %if.then135
	i32.const	$push61=, 24
	i32.shl 	$push62=, $2, $pop61
	i32.const	$push63=, 31
	i32.shr_s	$7=, $pop62, $pop63
	br      	1               # 1: down to label7
.LBB0_18:                               # %if.else141
	end_block                       # label8:
	i32.const	$push109=, 24
	i32.shr_s	$4=, $3, $pop109
	i32.const	$7=, 0
	i32.const	$push50=, -8
	i32.eq  	$push51=, $4, $pop50
	br_if   	0, $pop51       # 0: down to label7
# %bb.19:                               # %if.else159
	i32.const	$push52=, 24
	i32.shl 	$push53=, $2, $pop52
	i32.const	$push111=, 24
	i32.shr_s	$7=, $pop53, $pop111
	block   	
	i32.const	$push110=, -1
	i32.le_s	$push54=, $3, $pop110
	br_if   	0, $pop54       # 0: down to label9
# %bb.20:                               # %if.else175
	i32.shl 	$7=, $7, $4
	br      	1               # 1: down to label7
.LBB0_21:                               # %if.then163
	end_block                       # label9:
	i32.const	$push58=, 1
	i32.const	$push112=, -1
	i32.xor 	$push57=, $4, $pop112
	i32.shl 	$push59=, $pop58, $pop57
	i32.add 	$push60=, $pop59, $7
	i32.const	$push55=, 0
	i32.sub 	$push56=, $pop55, $4
	i32.shr_s	$7=, $pop60, $pop56
.LBB0_22:                               # %if.end185
	end_block                       # label7:
	block   	
	i32.const	$push64=, 134217727
	i32.gt_s	$push65=, $1, $pop64
	br_if   	0, $pop65       # 0: down to label10
# %bb.23:                               # %if.else196
	block   	
	i32.const	$push66=, -134217729
	i32.gt_s	$push67=, $1, $pop66
	br_if   	0, $pop67       # 0: down to label11
# %bb.24:                               # %if.then200
	i32.const	$push78=, 31
	i32.shr_s	$8=, $0, $pop78
	br      	1               # 1: down to label10
.LBB0_25:                               # %if.else206
	end_block                       # label11:
	i32.const	$push113=, 24
	i32.shr_s	$3=, $1, $pop113
	i32.const	$push68=, -8
	i32.eq  	$push69=, $3, $pop68
	br_if   	0, $pop69       # 0: down to label10
# %bb.26:                               # %if.else224
	i32.const	$push70=, 24
	i32.shr_s	$0=, $0, $pop70
	block   	
	i32.const	$push114=, -1
	i32.le_s	$push71=, $1, $pop114
	br_if   	0, $pop71       # 0: down to label12
# %bb.27:                               # %if.else240
	i32.shl 	$8=, $0, $3
	br      	1               # 1: down to label10
.LBB0_28:                               # %if.then228
	end_block                       # label12:
	i32.const	$push75=, 1
	i32.const	$push115=, -1
	i32.xor 	$push74=, $3, $pop115
	i32.shl 	$push76=, $pop75, $pop74
	i32.add 	$push77=, $pop76, $0
	i32.const	$push72=, 0
	i32.sub 	$push73=, $pop72, $3
	i32.shr_s	$8=, $pop77, $pop73
.LBB0_29:                               # %if.end250
	end_block                       # label10:
	i32.const	$push81=, 8
	i32.shl 	$push82=, $6, $pop81
	i32.const	$push83=, 65280
	i32.and 	$push84=, $pop82, $pop83
	i32.const	$push79=, 255
	i32.and 	$push80=, $5, $pop79
	i32.or  	$push85=, $pop84, $pop80
	i32.const	$push86=, 16
	i32.shl 	$push87=, $7, $pop86
	i32.const	$push88=, 16711680
	i32.and 	$push89=, $pop87, $pop88
	i32.or  	$push90=, $pop85, $pop89
	i32.const	$push91=, 24
	i32.shl 	$push92=, $8, $pop91
	i32.or  	$push93=, $pop90, $pop92
                                        # fallthrough-return: $pop93
	.endfunc
.Lfunc_end0:
	.size	helper_neon_rshl_s8, .Lfunc_end0-helper_neon_rshl_s8
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
