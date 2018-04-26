	.text
	.file	"20050826-2.c"
	.section	.text.inet_check_attr,"ax",@progbits
	.hidden	inet_check_attr         # -- Begin function inet_check_attr
	.globl	inet_check_attr
	.type	inet_check_attr,@function
inet_check_attr:                        # @inet_check_attr
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$3=, 1
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.load	$2=, 0($1)
	block   	
	i32.eqz 	$push17=, $2
	br_if   	0, $pop17       # 0: down to label2
# %bb.2:                                # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.load16_u	$push0=, 0($2)
	i32.const	$push10=, 65532
	i32.and 	$push1=, $pop0, $pop10
	i32.const	$push9=, 4
	i32.eq  	$push2=, $pop1, $pop9
	br_if   	2, $pop2        # 2: down to label0
# %bb.3:                                # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push12=, 1
	i32.or  	$push3=, $3, $pop12
	i32.const	$push11=, 9
	i32.eq  	$push4=, $pop3, $pop11
	br_if   	0, $pop4        # 0: down to label2
# %bb.4:                                # %if.then9
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push13=, 4
	i32.add 	$push5=, $2, $pop13
	i32.store	0($1), $pop5
.LBB0_5:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push16=, 4
	i32.add 	$1=, $1, $pop16
	i32.const	$push15=, 1
	i32.add 	$3=, $3, $pop15
	i32.const	$push14=, 15
	i32.lt_u	$push6=, $3, $pop14
	br_if   	0, $pop6        # 0: up to label1
# %bb.6:
	end_loop
	i32.const	$push7=, 0
	return  	$pop7
.LBB0_7:
	end_block                       # label0:
	i32.const	$push8=, -22
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end0:
	.size	inet_check_attr, .Lfunc_end0-inet_check_attr
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push84=, 0
	i32.load	$push83=, __stack_pointer($pop84)
	i32.const	$push85=, 64
	i32.sub 	$5=, $pop83, $pop85
	i32.const	$push86=, 0
	i32.store	__stack_pointer($pop86), $5
	i64.const	$push0=, 51539607564
	i64.store	56($5), $pop0
	i32.const	$push90=, 56
	i32.add 	$push91=, $5, $pop90
	i32.store	0($5), $pop91
	i32.const	$push92=, 56
	i32.add 	$push93=, $5, $pop92
	i32.store	4($5), $pop93
	i32.const	$push94=, 56
	i32.add 	$push95=, $5, $pop94
	i32.store	8($5), $pop95
	i32.const	$push96=, 56
	i32.add 	$push97=, $5, $pop96
	i32.store	12($5), $pop97
	i32.const	$push98=, 56
	i32.add 	$push99=, $5, $pop98
	i32.store	16($5), $pop99
	i32.const	$push100=, 56
	i32.add 	$push101=, $5, $pop100
	i32.store	20($5), $pop101
	i32.const	$push102=, 56
	i32.add 	$push103=, $5, $pop102
	i32.store	24($5), $pop103
	i32.const	$push104=, 56
	i32.add 	$push105=, $5, $pop104
	i32.store	28($5), $pop105
	i32.const	$push106=, 56
	i32.add 	$push107=, $5, $pop106
	i32.store	32($5), $pop107
	i32.const	$push108=, 56
	i32.add 	$push109=, $5, $pop108
	i32.store	36($5), $pop109
	i32.const	$push110=, 56
	i32.add 	$push111=, $5, $pop110
	i32.store	40($5), $pop111
	i32.const	$push112=, 56
	i32.add 	$push113=, $5, $pop112
	i32.store	44($5), $pop113
	i32.const	$push114=, 56
	i32.add 	$push115=, $5, $pop114
	i32.store	48($5), $pop115
	i32.const	$push116=, 56
	i32.add 	$push117=, $5, $pop116
	i32.store	52($5), $pop117
	block   	
	i32.call	$push2=, inet_check_attr@FUNCTION, $3, $5
	br_if   	0, $pop2        # 0: down to label3
# %bb.1:                                # %if.end
	i32.const	$push118=, 56
	i32.add 	$push119=, $5, $pop118
	i32.const	$push1=, 4
	i32.or  	$0=, $pop119, $pop1
	i32.load	$push16=, 0($5)
	i32.ne  	$push17=, $pop16, $0
	br_if   	0, $pop17       # 0: down to label3
# %bb.2:                                # %if.end
	i32.load	$push3=, 4($5)
	i32.ne  	$push38=, $pop3, $0
	br_if   	0, $pop38       # 0: down to label3
# %bb.3:                                # %if.end
	i32.load	$push4=, 8($5)
	i32.ne  	$push39=, $pop4, $0
	br_if   	0, $pop39       # 0: down to label3
# %bb.4:                                # %if.end
	i32.load	$push5=, 12($5)
	i32.ne  	$push40=, $pop5, $0
	br_if   	0, $pop40       # 0: down to label3
# %bb.5:                                # %if.end
	i32.const	$push36=, 16
	i32.add 	$push37=, $5, $pop36
	i32.load	$push6=, 0($pop37)
	i32.ne  	$push41=, $pop6, $0
	br_if   	0, $pop41       # 0: down to label3
# %bb.6:                                # %if.end
	i32.const	$push34=, 20
	i32.add 	$push35=, $5, $pop34
	i32.load	$push7=, 0($pop35)
	i32.ne  	$push42=, $pop7, $0
	br_if   	0, $pop42       # 0: down to label3
# %bb.7:                                # %if.end
	i32.const	$push32=, 24
	i32.add 	$push33=, $5, $pop32
	i32.load	$push8=, 0($pop33)
	i32.ne  	$push43=, $pop8, $0
	br_if   	0, $pop43       # 0: down to label3
# %bb.8:                                # %if.end
	i32.const	$push120=, 56
	i32.add 	$push121=, $5, $pop120
	copy_local	$3=, $pop121
	i32.const	$push30=, 28
	i32.add 	$push31=, $5, $pop30
	i32.load	$push9=, 0($pop31)
	i32.ne  	$push44=, $pop9, $3
	br_if   	0, $pop44       # 0: down to label3
# %bb.9:                                # %if.end
	i32.const	$push28=, 32
	i32.add 	$push29=, $5, $pop28
	i32.load	$push10=, 0($pop29)
	i32.ne  	$push45=, $pop10, $3
	br_if   	0, $pop45       # 0: down to label3
# %bb.10:                               # %if.end
	i32.const	$push26=, 36
	i32.add 	$push27=, $5, $pop26
	i32.load	$push11=, 0($pop27)
	i32.ne  	$push46=, $pop11, $0
	br_if   	0, $pop46       # 0: down to label3
# %bb.11:                               # %if.end
	i32.const	$push24=, 40
	i32.add 	$push25=, $5, $pop24
	i32.load	$push12=, 0($pop25)
	i32.ne  	$push47=, $pop12, $0
	br_if   	0, $pop47       # 0: down to label3
# %bb.12:                               # %if.end
	i32.const	$push22=, 44
	i32.add 	$push23=, $5, $pop22
	i32.load	$push13=, 0($pop23)
	i32.ne  	$push48=, $pop13, $0
	br_if   	0, $pop48       # 0: down to label3
# %bb.13:                               # %if.end
	i32.const	$push20=, 48
	i32.add 	$push21=, $5, $pop20
	i32.load	$push14=, 0($pop21)
	i32.ne  	$push49=, $pop14, $0
	br_if   	0, $pop49       # 0: down to label3
# %bb.14:                               # %if.end
	i32.const	$push18=, 52
	i32.add 	$push19=, $5, $pop18
	i32.load	$push15=, 0($pop19)
	i32.ne  	$push50=, $pop15, $0
	br_if   	0, $pop50       # 0: down to label3
# %bb.15:                               # %for.cond7.13
	i32.const	$push51=, 20
	i32.add 	$push52=, $5, $pop51
	i32.store	0($pop52), $0
	i32.const	$3=, 0
	i32.const	$push148=, 0
	i32.store	4($5), $pop148
	i32.const	$push53=, 16
	i32.add 	$push54=, $5, $pop53
	i32.const	$push122=, 56
	i32.add 	$push123=, $5, $pop122
	i32.store	0($pop54), $pop123
	i32.const	$push55=, 24
	i32.add 	$push56=, $5, $pop55
	i32.const	$push124=, 56
	i32.add 	$push125=, $5, $pop124
	i32.store	0($pop56), $pop125
	i32.const	$push57=, 28
	i32.add 	$push58=, $5, $pop57
	i32.const	$push126=, 56
	i32.add 	$push127=, $5, $pop126
	i32.store	0($pop58), $pop127
	i32.const	$push59=, 32
	i32.add 	$push60=, $5, $pop59
	i32.const	$push128=, 56
	i32.add 	$push129=, $5, $pop128
	i32.store	0($pop60), $pop129
	i32.const	$push61=, 36
	i32.add 	$push62=, $5, $pop61
	i32.const	$push130=, 56
	i32.add 	$push131=, $5, $pop130
	i32.store	0($pop62), $pop131
	i32.const	$push63=, 40
	i32.add 	$push64=, $5, $pop63
	i32.const	$push132=, 56
	i32.add 	$push133=, $5, $pop132
	i32.store	0($pop64), $pop133
	i32.const	$push65=, 44
	i32.add 	$push66=, $5, $pop65
	i32.const	$push134=, 56
	i32.add 	$push135=, $5, $pop134
	i32.store	0($pop66), $pop135
	i32.const	$push67=, 48
	i32.add 	$push68=, $5, $pop67
	i32.const	$push136=, 56
	i32.add 	$push137=, $5, $pop136
	i32.store	0($pop68), $pop137
	i32.const	$push69=, 52
	i32.add 	$push70=, $5, $pop69
	i32.const	$push138=, 56
	i32.add 	$push139=, $5, $pop138
	i32.store	0($pop70), $pop139
	i32.load16_u	$push72=, 60($5)
	i32.const	$push71=, 65528
	i32.add 	$push73=, $pop72, $pop71
	i32.store16	60($5), $pop73
	i32.const	$push140=, 56
	i32.add 	$push141=, $5, $pop140
	i32.store	8($5), $pop141
	i32.const	$push142=, 56
	i32.add 	$push143=, $5, $pop142
	i32.store	0($5), $pop143
	i32.const	$push144=, 56
	i32.add 	$push145=, $5, $pop144
	i32.store	12($5), $pop145
	i32.call	$push74=, inet_check_attr@FUNCTION, $3, $5
	i32.const	$push75=, -22
	i32.ne  	$push76=, $pop74, $pop75
	br_if   	0, $pop76       # 0: down to label3
# %bb.16:                               # %if.end39
	copy_local	$2=, $5
	i32.load	$1=, 4($5)
.LBB1_17:                               # %for.body43
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label4:
	block   	
	block   	
	i32.const	$push149=, 1
	i32.ne  	$push77=, $3, $pop149
	br_if   	0, $pop77       # 0: down to label6
# %bb.18:                               # %land.lhs.true
                                        #   in Loop: Header=BB1_17 Depth=1
	i32.eqz 	$push154=, $1
	br_if   	1, $pop154      # 1: down to label5
	br      	3               # 3: down to label3
.LBB1_19:                               # %if.else
                                        #   in Loop: Header=BB1_17 Depth=1
	end_block                       # label6:
	i32.load	$4=, 0($2)
	block   	
	i32.const	$push150=, 5
	i32.gt_u	$push78=, $3, $pop150
	br_if   	0, $pop78       # 0: down to label7
# %bb.20:                               # %land.lhs.true55
                                        #   in Loop: Header=BB1_17 Depth=1
	i32.eq  	$push80=, $4, $0
	br_if   	1, $pop80       # 1: down to label5
	br      	3               # 3: down to label3
.LBB1_21:                               # %land.lhs.true64
                                        #   in Loop: Header=BB1_17 Depth=1
	end_block                       # label7:
	i32.const	$push146=, 56
	i32.add 	$push147=, $5, $pop146
	i32.ne  	$push79=, $4, $pop147
	br_if   	2, $pop79       # 2: down to label3
.LBB1_22:                               # %for.inc73
                                        #   in Loop: Header=BB1_17 Depth=1
	end_block                       # label5:
	i32.const	$push153=, 4
	i32.add 	$2=, $2, $pop153
	i32.const	$push152=, 1
	i32.add 	$3=, $3, $pop152
	i32.const	$push151=, 14
	i32.lt_u	$push81=, $3, $pop151
	br_if   	0, $pop81       # 0: up to label4
# %bb.23:                               # %for.end75
	end_loop
	i32.const	$push89=, 0
	i32.const	$push87=, 64
	i32.add 	$push88=, $5, $pop87
	i32.store	__stack_pointer($pop89), $pop88
	i32.const	$push82=, 0
	return  	$pop82
.LBB1_24:                               # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
