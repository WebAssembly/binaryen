	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr42833.c"
	.section	.text.helper_neon_rshl_s8,"ax",@progbits
	.hidden	helper_neon_rshl_s8
	.globl	helper_neon_rshl_s8
	.type	helper_neon_rshl_s8,@function
helper_neon_rshl_s8:                    # @helper_neon_rshl_s8
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, 0
	i32.const	$4=, 0
	block   	
	i32.const	$push75=, 24
	i32.shl 	$push74=, $1, $pop75
	tee_local	$push73=, $6=, $pop74
	i32.const	$push0=, 117440512
	i32.gt_s	$push1=, $pop73, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.else
	i32.const	$push76=, 24
	i32.shl 	$7=, $0, $pop76
	block   	
	i32.const	$push2=, -134217729
	i32.gt_s	$push3=, $6, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#2:                                 # %if.then13
	i32.const	$push13=, 31
	i32.shr_s	$4=, $7, $pop13
	br      	1               # 1: down to label0
.LBB0_3:                                # %if.else18
	end_block                       # label1:
	i32.const	$4=, 0
	i32.const	$push79=, 24
	i32.shr_s	$push78=, $6, $pop79
	tee_local	$push77=, $2=, $pop78
	i32.const	$push4=, -8
	i32.eq  	$push5=, $pop77, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#4:                                 # %if.else34
	i32.const	$push81=, 24
	i32.shr_s	$4=, $7, $pop81
	block   	
	i32.const	$push80=, -1
	i32.le_s	$push6=, $6, $pop80
	br_if   	0, $pop6        # 0: down to label2
# BB#5:                                 # %if.else48
	i32.shl 	$4=, $4, $2
	br      	1               # 1: down to label0
.LBB0_6:                                # %if.then38
	end_block                       # label2:
	i32.const	$push10=, 1
	i32.const	$push82=, -1
	i32.xor 	$push9=, $2, $pop82
	i32.shl 	$push11=, $pop10, $pop9
	i32.add 	$push12=, $pop11, $4
	i32.const	$push7=, 0
	i32.sub 	$push8=, $pop7, $2
	i32.shr_s	$4=, $pop12, $pop8
.LBB0_7:                                # %if.end57
	end_block                       # label0:
	block   	
	i32.const	$push87=, 16
	i32.shl 	$push14=, $1, $pop87
	i32.const	$push86=, 24
	i32.shr_s	$push85=, $pop14, $pop86
	tee_local	$push84=, $6=, $pop85
	i32.const	$push83=, 7
	i32.gt_s	$push15=, $pop84, $pop83
	br_if   	0, $pop15       # 0: down to label3
# BB#8:                                 # %if.else68
	i32.const	$push88=, 16
	i32.shl 	$7=, $0, $pop88
	block   	
	i32.const	$push17=, -9
	i32.gt_s	$push18=, $6, $pop17
	br_if   	0, $pop18       # 0: down to label4
# BB#9:                                 # %if.then72
	i32.const	$push28=, 31
	i32.shr_s	$5=, $7, $pop28
	br      	1               # 1: down to label3
.LBB0_10:                               # %if.else78
	end_block                       # label4:
	i32.const	$push19=, -8
	i32.eq  	$push20=, $6, $pop19
	br_if   	0, $pop20       # 0: down to label3
# BB#11:                                # %if.else96
	i32.const	$push16=, 24
	i32.shr_s	$5=, $7, $pop16
	block   	
	i32.const	$push89=, -1
	i32.le_s	$push21=, $6, $pop89
	br_if   	0, $pop21       # 0: down to label5
# BB#12:                                # %if.else112
	i32.shl 	$5=, $5, $6
	br      	1               # 1: down to label3
.LBB0_13:                               # %if.then100
	end_block                       # label5:
	i32.const	$push25=, 1
	i32.const	$push90=, -1
	i32.xor 	$push24=, $6, $pop90
	i32.shl 	$push26=, $pop25, $pop24
	i32.add 	$push27=, $pop26, $5
	i32.const	$push22=, 0
	i32.sub 	$push23=, $pop22, $6
	i32.shr_s	$5=, $pop27, $pop23
.LBB0_14:                               # %if.end122
	end_block                       # label3:
	i32.const	$7=, 0
	i32.const	$6=, 0
	block   	
	i32.const	$push95=, 8
	i32.shl 	$push29=, $1, $pop95
	i32.const	$push94=, 24
	i32.shr_s	$push93=, $pop29, $pop94
	tee_local	$push92=, $2=, $pop93
	i32.const	$push91=, 7
	i32.gt_s	$push30=, $pop92, $pop91
	br_if   	0, $pop30       # 0: down to label6
# BB#15:                                # %if.else133
	i32.const	$push96=, 8
	i32.shl 	$3=, $0, $pop96
	block   	
	i32.const	$push31=, -9
	i32.gt_s	$push32=, $2, $pop31
	br_if   	0, $pop32       # 0: down to label7
# BB#16:                                # %if.then137
	i32.const	$push42=, 31
	i32.shr_s	$6=, $3, $pop42
	br      	1               # 1: down to label6
.LBB0_17:                               # %if.else143
	end_block                       # label7:
	i32.const	$6=, 0
	i32.const	$push33=, -8
	i32.eq  	$push34=, $2, $pop33
	br_if   	0, $pop34       # 0: down to label6
# BB#18:                                # %if.else161
	i32.const	$push98=, 24
	i32.shr_s	$6=, $3, $pop98
	block   	
	i32.const	$push97=, -1
	i32.le_s	$push35=, $2, $pop97
	br_if   	0, $pop35       # 0: down to label8
# BB#19:                                # %if.else177
	i32.shl 	$6=, $6, $2
	br      	1               # 1: down to label6
.LBB0_20:                               # %if.then165
	end_block                       # label8:
	i32.const	$push39=, 1
	i32.const	$push99=, -1
	i32.xor 	$push38=, $2, $pop99
	i32.shl 	$push40=, $pop39, $pop38
	i32.add 	$push41=, $pop40, $6
	i32.const	$push36=, 0
	i32.sub 	$push37=, $pop36, $2
	i32.shr_s	$6=, $pop41, $pop37
.LBB0_21:                               # %if.end187
	end_block                       # label6:
	block   	
	i32.const	$push102=, 24
	i32.shr_s	$push101=, $1, $pop102
	tee_local	$push100=, $1=, $pop101
	i32.const	$push43=, 7
	i32.gt_s	$push44=, $pop100, $pop43
	br_if   	0, $pop44       # 0: down to label9
# BB#22:                                # %if.else199
	block   	
	i32.const	$push46=, -9
	i32.gt_s	$push47=, $1, $pop46
	br_if   	0, $pop47       # 0: down to label10
# BB#23:                                # %if.then203
	i32.const	$push57=, 31
	i32.shr_s	$7=, $0, $pop57
	br      	1               # 1: down to label9
.LBB0_24:                               # %if.else209
	end_block                       # label10:
	i32.const	$push48=, -8
	i32.eq  	$push49=, $1, $pop48
	br_if   	0, $pop49       # 0: down to label9
# BB#25:                                # %if.else227
	i32.const	$push45=, 24
	i32.shr_s	$0=, $0, $pop45
	block   	
	i32.const	$push103=, -1
	i32.le_s	$push50=, $1, $pop103
	br_if   	0, $pop50       # 0: down to label11
# BB#26:                                # %if.else243
	i32.shl 	$7=, $0, $1
	br      	1               # 1: down to label9
.LBB0_27:                               # %if.then231
	end_block                       # label11:
	i32.const	$push54=, 1
	i32.const	$push104=, -1
	i32.xor 	$push53=, $1, $pop104
	i32.shl 	$push55=, $pop54, $pop53
	i32.add 	$push56=, $pop55, $0
	i32.const	$push51=, 0
	i32.sub 	$push52=, $pop51, $1
	i32.shr_s	$7=, $pop56, $pop52
.LBB0_28:                               # %if.end253
	end_block                       # label9:
	i32.const	$push60=, 8
	i32.shl 	$push61=, $5, $pop60
	i32.const	$push62=, 65280
	i32.and 	$push63=, $pop61, $pop62
	i32.const	$push58=, 255
	i32.and 	$push59=, $4, $pop58
	i32.or  	$push64=, $pop63, $pop59
	i32.const	$push65=, 16
	i32.shl 	$push66=, $6, $pop65
	i32.const	$push67=, 16711680
	i32.and 	$push68=, $pop66, $pop67
	i32.or  	$push69=, $pop64, $pop68
	i32.const	$push70=, 24
	i32.shl 	$push71=, $7, $pop70
	i32.or  	$push72=, $pop69, $pop71
                                        # fallthrough-return: $pop72
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
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
