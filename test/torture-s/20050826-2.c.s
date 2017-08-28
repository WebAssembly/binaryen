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
# BB#0:                                 # %entry
	i32.const	$3=, 0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.const	$push11=, 1
	i32.add 	$3=, $3, $pop11
	block   	
	i32.load	$push10=, 0($1)
	tee_local	$push9=, $2=, $pop10
	i32.eqz 	$push19=, $pop9
	br_if   	0, $pop19       # 0: down to label2
# BB#2:                                 # %if.then
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.load16_u	$push0=, 0($2)
	i32.const	$push13=, 65532
	i32.and 	$push1=, $pop0, $pop13
	i32.const	$push12=, 4
	i32.eq  	$push2=, $pop1, $pop12
	br_if   	2, $pop2        # 2: down to label0
# BB#3:                                 # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push15=, 1
	i32.or  	$push3=, $3, $pop15
	i32.const	$push14=, 9
	i32.eq  	$push4=, $pop3, $pop14
	br_if   	0, $pop4        # 0: down to label2
# BB#4:                                 # %if.then9
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push16=, 4
	i32.add 	$push5=, $2, $pop16
	i32.store	0($1), $pop5
.LBB0_5:                                # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.const	$push18=, 4
	i32.add 	$1=, $1, $pop18
	i32.const	$push17=, 14
	i32.lt_u	$push6=, $3, $pop17
	br_if   	0, $pop6        # 0: up to label1
# BB#6:
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
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push87=, 0
	i32.const	$push85=, 0
	i32.load	$push84=, __stack_pointer($pop85)
	i32.const	$push86=, 64
	i32.sub 	$push150=, $pop84, $pop86
	tee_local	$push149=, $5=, $pop150
	i32.store	__stack_pointer($pop87), $pop149
	i64.const	$push0=, 51539607564
	i64.store	56($5), $pop0
	i32.const	$push91=, 56
	i32.add 	$push92=, $5, $pop91
	i32.store	0($5), $pop92
	i32.const	$push93=, 56
	i32.add 	$push94=, $5, $pop93
	i32.store	4($5), $pop94
	i32.const	$push95=, 56
	i32.add 	$push96=, $5, $pop95
	i32.store	8($5), $pop96
	i32.const	$push97=, 56
	i32.add 	$push98=, $5, $pop97
	i32.store	12($5), $pop98
	i32.const	$push99=, 56
	i32.add 	$push100=, $5, $pop99
	i32.store	16($5), $pop100
	i32.const	$push101=, 56
	i32.add 	$push102=, $5, $pop101
	i32.store	20($5), $pop102
	i32.const	$push103=, 56
	i32.add 	$push104=, $5, $pop103
	i32.store	24($5), $pop104
	i32.const	$push105=, 56
	i32.add 	$push106=, $5, $pop105
	i32.store	28($5), $pop106
	i32.const	$push107=, 56
	i32.add 	$push108=, $5, $pop107
	i32.store	32($5), $pop108
	i32.const	$push109=, 56
	i32.add 	$push110=, $5, $pop109
	i32.store	36($5), $pop110
	i32.const	$push111=, 56
	i32.add 	$push112=, $5, $pop111
	i32.store	40($5), $pop112
	i32.const	$push113=, 56
	i32.add 	$push114=, $5, $pop113
	i32.store	44($5), $pop114
	i32.const	$push115=, 56
	i32.add 	$push116=, $5, $pop115
	i32.store	48($5), $pop116
	i32.const	$push117=, 56
	i32.add 	$push118=, $5, $pop117
	i32.store	52($5), $pop118
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	i32.call	$push2=, inet_check_attr@FUNCTION, $3, $5
	br_if   	0, $pop2        # 0: down to label19
# BB#1:                                 # %if.end
	i32.load	$push16=, 0($5)
	i32.const	$push119=, 56
	i32.add 	$push120=, $5, $pop119
	i32.const	$push1=, 4
	i32.or  	$push152=, $pop120, $pop1
	tee_local	$push151=, $0=, $pop152
	i32.ne  	$push17=, $pop16, $pop151
	br_if   	1, $pop17       # 1: down to label18
# BB#2:                                 # %if.end
	i32.load	$push3=, 4($5)
	i32.ne  	$push38=, $pop3, $0
	br_if   	2, $pop38       # 2: down to label17
# BB#3:                                 # %if.end
	i32.load	$push4=, 8($5)
	i32.ne  	$push39=, $pop4, $0
	br_if   	3, $pop39       # 3: down to label16
# BB#4:                                 # %if.end
	i32.load	$push5=, 12($5)
	i32.ne  	$push40=, $pop5, $0
	br_if   	4, $pop40       # 4: down to label15
# BB#5:                                 # %if.end
	i32.const	$push36=, 16
	i32.add 	$push37=, $5, $pop36
	i32.load	$push6=, 0($pop37)
	i32.ne  	$push41=, $pop6, $0
	br_if   	5, $pop41       # 5: down to label14
# BB#6:                                 # %if.end
	i32.const	$push34=, 20
	i32.add 	$push35=, $5, $pop34
	i32.load	$push7=, 0($pop35)
	i32.ne  	$push42=, $pop7, $0
	br_if   	6, $pop42       # 6: down to label13
# BB#7:                                 # %if.end
	i32.const	$push32=, 24
	i32.add 	$push33=, $5, $pop32
	i32.load	$push8=, 0($pop33)
	i32.ne  	$push43=, $pop8, $0
	br_if   	7, $pop43       # 7: down to label12
# BB#8:                                 # %if.end
	i32.const	$push30=, 28
	i32.add 	$push31=, $5, $pop30
	i32.load	$push9=, 0($pop31)
	i32.const	$push121=, 56
	i32.add 	$push122=, $5, $pop121
	copy_local	$push154=, $pop122
	tee_local	$push153=, $3=, $pop154
	i32.ne  	$push44=, $pop9, $pop153
	br_if   	8, $pop44       # 8: down to label11
# BB#9:                                 # %if.end
	i32.const	$push28=, 32
	i32.add 	$push29=, $5, $pop28
	i32.load	$push10=, 0($pop29)
	i32.ne  	$push45=, $pop10, $3
	br_if   	9, $pop45       # 9: down to label10
# BB#10:                                # %if.end
	i32.const	$push26=, 36
	i32.add 	$push27=, $5, $pop26
	i32.load	$push11=, 0($pop27)
	i32.ne  	$push46=, $pop11, $0
	br_if   	10, $pop46      # 10: down to label9
# BB#11:                                # %if.end
	i32.const	$push24=, 40
	i32.add 	$push25=, $5, $pop24
	i32.load	$push12=, 0($pop25)
	i32.ne  	$push47=, $pop12, $0
	br_if   	11, $pop47      # 11: down to label8
# BB#12:                                # %if.end
	i32.const	$push22=, 44
	i32.add 	$push23=, $5, $pop22
	i32.load	$push13=, 0($pop23)
	i32.ne  	$push48=, $pop13, $0
	br_if   	12, $pop48      # 12: down to label7
# BB#13:                                # %if.end
	i32.const	$push20=, 48
	i32.add 	$push21=, $5, $pop20
	i32.load	$push14=, 0($pop21)
	i32.ne  	$push49=, $pop14, $0
	br_if   	13, $pop49      # 13: down to label6
# BB#14:                                # %if.end
	i32.const	$push18=, 52
	i32.add 	$push19=, $5, $pop18
	i32.load	$push15=, 0($pop19)
	i32.ne  	$push50=, $pop15, $0
	br_if   	14, $pop50      # 14: down to label5
# BB#15:                                # %for.cond7.13
	i32.const	$push51=, 20
	i32.add 	$push52=, $5, $pop51
	i32.store	0($pop52), $0
	i32.const	$3=, 0
	i32.const	$push155=, 0
	i32.store	4($5), $pop155
	i32.const	$push53=, 16
	i32.add 	$push54=, $5, $pop53
	i32.const	$push123=, 56
	i32.add 	$push124=, $5, $pop123
	i32.store	0($pop54), $pop124
	i32.const	$push55=, 24
	i32.add 	$push56=, $5, $pop55
	i32.const	$push125=, 56
	i32.add 	$push126=, $5, $pop125
	i32.store	0($pop56), $pop126
	i32.const	$push57=, 28
	i32.add 	$push58=, $5, $pop57
	i32.const	$push127=, 56
	i32.add 	$push128=, $5, $pop127
	i32.store	0($pop58), $pop128
	i32.const	$push59=, 32
	i32.add 	$push60=, $5, $pop59
	i32.const	$push129=, 56
	i32.add 	$push130=, $5, $pop129
	i32.store	0($pop60), $pop130
	i32.const	$push61=, 36
	i32.add 	$push62=, $5, $pop61
	i32.const	$push131=, 56
	i32.add 	$push132=, $5, $pop131
	i32.store	0($pop62), $pop132
	i32.const	$push63=, 40
	i32.add 	$push64=, $5, $pop63
	i32.const	$push133=, 56
	i32.add 	$push134=, $5, $pop133
	i32.store	0($pop64), $pop134
	i32.const	$push65=, 44
	i32.add 	$push66=, $5, $pop65
	i32.const	$push135=, 56
	i32.add 	$push136=, $5, $pop135
	i32.store	0($pop66), $pop136
	i32.const	$push67=, 48
	i32.add 	$push68=, $5, $pop67
	i32.const	$push137=, 56
	i32.add 	$push138=, $5, $pop137
	i32.store	0($pop68), $pop138
	i32.const	$push69=, 52
	i32.add 	$push70=, $5, $pop69
	i32.const	$push139=, 56
	i32.add 	$push140=, $5, $pop139
	i32.store	0($pop70), $pop140
	i32.load16_u	$push72=, 60($5)
	i32.const	$push71=, 65528
	i32.add 	$push73=, $pop72, $pop71
	i32.store16	60($5), $pop73
	i32.const	$push141=, 56
	i32.add 	$push142=, $5, $pop141
	i32.store	8($5), $pop142
	i32.const	$push143=, 56
	i32.add 	$push144=, $5, $pop143
	i32.store	0($5), $pop144
	i32.const	$push145=, 56
	i32.add 	$push146=, $5, $pop145
	i32.store	12($5), $pop146
	i32.call	$push74=, inet_check_attr@FUNCTION, $3, $5
	i32.const	$push75=, -22
	i32.ne  	$push76=, $pop74, $pop75
	br_if   	15, $pop76      # 15: down to label4
# BB#16:                                # %if.end39
	copy_local	$2=, $5
	i32.load	$1=, 4($5)
	block   	
	i32.const	$push157=, 0
	i32.const	$push156=, 1
	i32.ne  	$push77=, $pop157, $pop156
	br_if   	0, $pop77       # 0: down to label20
# BB#17:
	i32.const	$6=, 7
	br      	17              # 17: down to label3
.LBB1_18:
	end_block                       # label20:
	i32.const	$6=, 3
	br      	16              # 16: down to label3
.LBB1_19:
	end_block                       # label19:
	i32.const	$6=, 5
	br      	15              # 15: down to label3
.LBB1_20:
	end_block                       # label18:
	i32.const	$6=, 5
	br      	14              # 14: down to label3
.LBB1_21:
	end_block                       # label17:
	i32.const	$6=, 5
	br      	13              # 13: down to label3
.LBB1_22:
	end_block                       # label16:
	i32.const	$6=, 5
	br      	12              # 12: down to label3
.LBB1_23:
	end_block                       # label15:
	i32.const	$6=, 5
	br      	11              # 11: down to label3
.LBB1_24:
	end_block                       # label14:
	i32.const	$6=, 5
	br      	10              # 10: down to label3
.LBB1_25:
	end_block                       # label13:
	i32.const	$6=, 5
	br      	9               # 9: down to label3
.LBB1_26:
	end_block                       # label12:
	i32.const	$6=, 5
	br      	8               # 8: down to label3
.LBB1_27:
	end_block                       # label11:
	i32.const	$6=, 5
	br      	7               # 7: down to label3
.LBB1_28:
	end_block                       # label10:
	i32.const	$6=, 5
	br      	6               # 6: down to label3
.LBB1_29:
	end_block                       # label9:
	i32.const	$6=, 5
	br      	5               # 5: down to label3
.LBB1_30:
	end_block                       # label8:
	i32.const	$6=, 5
	br      	4               # 4: down to label3
.LBB1_31:
	end_block                       # label7:
	i32.const	$6=, 5
	br      	3               # 3: down to label3
.LBB1_32:
	end_block                       # label6:
	i32.const	$6=, 5
	br      	2               # 2: down to label3
.LBB1_33:
	end_block                       # label5:
	i32.const	$6=, 5
	br      	1               # 1: down to label3
.LBB1_34:
	end_block                       # label4:
	i32.const	$6=, 5
.LBB1_35:                               # =>This Inner Loop Header: Depth=1
	end_block                       # label3:
	loop    	i32             # label21:
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$6, 5, 6, 0, 2, 4, 7, 3, 1, 1 # 5: down to label32
                                        # 6: down to label31
                                        # 0: down to label37
                                        # 2: down to label35
                                        # 4: down to label33
                                        # 7: down to label30
                                        # 3: down to label34
                                        # 1: down to label36
.LBB1_36:                               # %for.body43.backedge
                                        #   in Loop: Header=BB1_35 Depth=1
	end_block                       # label37:
	i32.const	$push162=, 4
	i32.add 	$2=, $2, $pop162
	i32.const	$push161=, 1
	i32.add 	$push160=, $3, $pop161
	tee_local	$push159=, $3=, $pop160
	i32.const	$push158=, 1
	i32.ne  	$push78=, $pop159, $pop158
	br_if   	7, $pop78       # 7: down to label29
# BB#37:                                #   in Loop: Header=BB1_35 Depth=1
	i32.const	$6=, 7
	br      	15              # 15: up to label21
.LBB1_38:                               # %land.lhs.true
                                        #   in Loop: Header=BB1_35 Depth=1
	end_block                       # label36:
	i32.eqz 	$push165=, $1
	br_if   	11, $pop165     # 11: down to label24
	br      	12              # 12: down to label23
.LBB1_39:                               # %if.else
                                        #   in Loop: Header=BB1_35 Depth=1
	end_block                       # label35:
	i32.load	$4=, 0($2)
	i32.const	$push163=, 5
	i32.gt_u	$push79=, $3, $pop163
	br_if   	12, $pop79      # 12: down to label22
# BB#40:                                #   in Loop: Header=BB1_35 Depth=1
	i32.const	$6=, 6
	br      	13              # 13: up to label21
.LBB1_41:                               # %land.lhs.true55
                                        #   in Loop: Header=BB1_35 Depth=1
	end_block                       # label34:
	i32.eq  	$push83=, $4, $0
	br_if   	5, $pop83       # 5: down to label28
	br      	6               # 6: down to label27
.LBB1_42:                               # %land.lhs.true64
                                        #   in Loop: Header=BB1_35 Depth=1
	end_block                       # label33:
	i32.const	$push147=, 56
	i32.add 	$push148=, $5, $pop147
	i32.ne  	$push80=, $4, $pop148
	br_if   	7, $pop80       # 7: down to label25
# BB#43:                                #   in Loop: Header=BB1_35 Depth=1
	i32.const	$6=, 0
	br      	11              # 11: up to label21
.LBB1_44:                               # %for.inc73
                                        #   in Loop: Header=BB1_35 Depth=1
	end_block                       # label32:
	i32.const	$push164=, 12
	i32.le_u	$push81=, $3, $pop164
	br_if   	5, $pop81       # 5: down to label26
# BB#45:                                #   in Loop: Header=BB1_35 Depth=1
	i32.const	$6=, 1
	br      	10              # 10: up to label21
.LBB1_46:                               # %for.end75
	end_block                       # label31:
	i32.const	$push90=, 0
	i32.const	$push88=, 64
	i32.add 	$push89=, $5, $pop88
	i32.store	__stack_pointer($pop90), $pop89
	i32.const	$push82=, 0
	return  	$pop82
.LBB1_47:                               # %if.then
	end_block                       # label30:
	call    	abort@FUNCTION
	unreachable
.LBB1_48:                               #   in Loop: Header=BB1_35 Depth=1
	end_block                       # label29:
	i32.const	$6=, 3
	br      	7               # 7: up to label21
.LBB1_49:                               #   in Loop: Header=BB1_35 Depth=1
	end_block                       # label28:
	i32.const	$6=, 2
	br      	6               # 6: up to label21
.LBB1_50:                               #   in Loop: Header=BB1_35 Depth=1
	end_block                       # label27:
	i32.const	$6=, 5
	br      	5               # 5: up to label21
.LBB1_51:                               #   in Loop: Header=BB1_35 Depth=1
	end_block                       # label26:
	i32.const	$6=, 2
	br      	4               # 4: up to label21
.LBB1_52:                               #   in Loop: Header=BB1_35 Depth=1
	end_block                       # label25:
	i32.const	$6=, 5
	br      	3               # 3: up to label21
.LBB1_53:                               #   in Loop: Header=BB1_35 Depth=1
	end_block                       # label24:
	i32.const	$6=, 2
	br      	2               # 2: up to label21
.LBB1_54:                               #   in Loop: Header=BB1_35 Depth=1
	end_block                       # label23:
	i32.const	$6=, 5
	br      	1               # 1: up to label21
.LBB1_55:                               #   in Loop: Header=BB1_35 Depth=1
	end_block                       # label22:
	i32.const	$6=, 4
	br      	0               # 0: up to label21
.LBB1_56:
	end_loop
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
