	.text
	.file	"memset-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
.LBB0_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
                                        #       Child Loop BB0_4 Depth 3
                                        #       Child Loop BB0_8 Depth 3
                                        #       Child Loop BB0_20 Depth 3
                                        #       Child Loop BB0_25 Depth 3
                                        #       Child Loop BB0_37 Depth 3
                                        #       Child Loop BB0_42 Depth 3
	block   	
	loop    	                # label1:
	i32.const	$push96=, u
	i32.add 	$2=, $1, $pop96
	i32.const	$3=, 1
.LBB0_2:                                # %for.body3
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_4 Depth 3
                                        #       Child Loop BB0_8 Depth 3
                                        #       Child Loop BB0_20 Depth 3
                                        #       Child Loop BB0_25 Depth 3
                                        #       Child Loop BB0_37 Depth 3
                                        #       Child Loop BB0_42 Depth 3
	loop    	                # label2:
	i32.const	$4=, u
	i32.const	$push100=, u
	i32.const	$push99=, 97
	i32.const	$push98=, 96
	i32.call	$drop=, memset@FUNCTION, $pop100, $pop99, $pop98
	i32.const	$push97=, 0
	i32.call	$0=, memset@FUNCTION, $2, $pop97, $3
	block   	
	i32.eqz 	$push191=, $1
	br_if   	0, $pop191      # 0: down to label3
# BB#3:                                 # %for.body11.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$5=, 0
.LBB0_4:                                # %for.body11
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label4:
	i32.const	$push102=, u
	i32.add 	$push0=, $5, $pop102
	i32.load8_u	$push1=, 0($pop0)
	i32.const	$push101=, 97
	i32.ne  	$push2=, $pop1, $pop101
	br_if   	4, $pop2        # 4: down to label0
# BB#5:                                 # %for.inc16
                                        #   in Loop: Header=BB0_4 Depth=3
	i32.const	$push105=, 1
	i32.add 	$push104=, $5, $pop105
	tee_local	$push103=, $5=, $pop104
	i32.lt_u	$push3=, $pop103, $1
	br_if   	0, $pop3        # 0: up to label4
# BB#6:                                 # %for.body22.preheader.loopexit
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop
	i32.const	$push106=, u
	i32.add 	$4=, $5, $pop106
.LBB0_7:                                # %for.body22.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label3:
	i32.const	$5=, 0
.LBB0_8:                                # %for.body22
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label5:
	i32.add 	$push4=, $4, $5
	i32.load8_u	$push5=, 0($pop4)
	br_if   	3, $pop5        # 3: down to label0
# BB#9:                                 # %for.inc28
                                        #   in Loop: Header=BB0_8 Depth=3
	i32.const	$push109=, 1
	i32.add 	$push108=, $5, $pop109
	tee_local	$push107=, $5=, $pop108
	i32.lt_u	$push6=, $pop107, $3
	br_if   	0, $pop6        # 0: up to label5
# BB#10:                                # %for.end31
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop
	i32.add 	$push112=, $4, $5
	tee_local	$push111=, $5=, $pop112
	i32.load8_u	$push7=, 0($pop111)
	i32.const	$push110=, 97
	i32.ne  	$push8=, $pop7, $pop110
	br_if   	2, $pop8        # 2: down to label0
# BB#11:                                # %for.inc41
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push114=, 1
	i32.add 	$push9=, $5, $pop114
	i32.load8_u	$push10=, 0($pop9)
	i32.const	$push113=, 97
	i32.ne  	$push11=, $pop10, $pop113
	br_if   	2, $pop11       # 2: down to label0
# BB#12:                                # %for.inc41.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push116=, 2
	i32.add 	$push12=, $5, $pop116
	i32.load8_u	$push13=, 0($pop12)
	i32.const	$push115=, 97
	i32.ne  	$push14=, $pop13, $pop115
	br_if   	2, $pop14       # 2: down to label0
# BB#13:                                # %for.inc41.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push118=, 3
	i32.add 	$push15=, $5, $pop118
	i32.load8_u	$push16=, 0($pop15)
	i32.const	$push117=, 97
	i32.ne  	$push17=, $pop16, $pop117
	br_if   	2, $pop17       # 2: down to label0
# BB#14:                                # %for.inc41.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push120=, 4
	i32.add 	$push18=, $5, $pop120
	i32.load8_u	$push19=, 0($pop18)
	i32.const	$push119=, 97
	i32.ne  	$push20=, $pop19, $pop119
	br_if   	2, $pop20       # 2: down to label0
# BB#15:                                # %for.inc41.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push122=, 5
	i32.add 	$push21=, $5, $pop122
	i32.load8_u	$push22=, 0($pop21)
	i32.const	$push121=, 97
	i32.ne  	$push23=, $pop22, $pop121
	br_if   	2, $pop23       # 2: down to label0
# BB#16:                                # %for.inc41.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push124=, 6
	i32.add 	$push24=, $5, $pop124
	i32.load8_u	$push25=, 0($pop24)
	i32.const	$push123=, 97
	i32.ne  	$push26=, $pop25, $pop123
	br_if   	2, $pop26       # 2: down to label0
# BB#17:                                # %for.inc41.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push126=, 7
	i32.add 	$push27=, $5, $pop126
	i32.load8_u	$push28=, 0($pop27)
	i32.const	$push125=, 97
	i32.ne  	$push29=, $pop28, $pop125
	br_if   	2, $pop29       # 2: down to label0
# BB#18:                                # %for.inc41.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push127=, 0
	i32.load8_u	$push30=, A($pop127)
	i32.call	$drop=, memset@FUNCTION, $0, $pop30, $3
	block   	
	block   	
	i32.eqz 	$push192=, $1
	br_if   	0, $pop192      # 0: down to label7
# BB#19:                                # %for.body55.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$5=, 0
.LBB0_20:                               # %for.body55
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label8:
	i32.const	$push129=, u
	i32.add 	$push31=, $5, $pop129
	i32.load8_u	$push32=, 0($pop31)
	i32.const	$push128=, 97
	i32.ne  	$push33=, $pop32, $pop128
	br_if   	5, $pop33       # 5: down to label0
# BB#21:                                # %for.inc61
                                        #   in Loop: Header=BB0_20 Depth=3
	i32.const	$push132=, 1
	i32.add 	$push131=, $5, $pop132
	tee_local	$push130=, $5=, $pop131
	i32.lt_u	$push34=, $pop130, $1
	br_if   	0, $pop34       # 0: up to label8
# BB#22:                                # %for.body68.preheader.loopexit
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop
	i32.const	$push133=, u
	i32.add 	$4=, $5, $pop133
	br      	1               # 1: down to label6
.LBB0_23:                               #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label7:
	i32.const	$4=, u
.LBB0_24:                               # %for.body68.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label6:
	i32.const	$5=, 0
.LBB0_25:                               # %for.body68
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label9:
	i32.add 	$push35=, $4, $5
	i32.load8_u	$push36=, 0($pop35)
	i32.const	$push134=, 65
	i32.ne  	$push37=, $pop36, $pop134
	br_if   	3, $pop37       # 3: down to label0
# BB#26:                                # %for.inc74
                                        #   in Loop: Header=BB0_25 Depth=3
	i32.const	$push137=, 1
	i32.add 	$push136=, $5, $pop137
	tee_local	$push135=, $5=, $pop136
	i32.lt_u	$push38=, $pop135, $3
	br_if   	0, $pop38       # 0: up to label9
# BB#27:                                # %for.end77
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop
	i32.add 	$push140=, $4, $5
	tee_local	$push139=, $5=, $pop140
	i32.load8_u	$push39=, 0($pop139)
	i32.const	$push138=, 97
	i32.ne  	$push40=, $pop39, $pop138
	br_if   	2, $pop40       # 2: down to label0
# BB#28:                                # %for.inc87
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push142=, 1
	i32.add 	$push41=, $5, $pop142
	i32.load8_u	$push42=, 0($pop41)
	i32.const	$push141=, 97
	i32.ne  	$push43=, $pop42, $pop141
	br_if   	2, $pop43       # 2: down to label0
# BB#29:                                # %for.inc87.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push144=, 2
	i32.add 	$push44=, $5, $pop144
	i32.load8_u	$push45=, 0($pop44)
	i32.const	$push143=, 97
	i32.ne  	$push46=, $pop45, $pop143
	br_if   	2, $pop46       # 2: down to label0
# BB#30:                                # %for.inc87.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push146=, 3
	i32.add 	$push47=, $5, $pop146
	i32.load8_u	$push48=, 0($pop47)
	i32.const	$push145=, 97
	i32.ne  	$push49=, $pop48, $pop145
	br_if   	2, $pop49       # 2: down to label0
# BB#31:                                # %for.inc87.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push148=, 4
	i32.add 	$push50=, $5, $pop148
	i32.load8_u	$push51=, 0($pop50)
	i32.const	$push147=, 97
	i32.ne  	$push52=, $pop51, $pop147
	br_if   	2, $pop52       # 2: down to label0
# BB#32:                                # %for.inc87.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push150=, 5
	i32.add 	$push53=, $5, $pop150
	i32.load8_u	$push54=, 0($pop53)
	i32.const	$push149=, 97
	i32.ne  	$push55=, $pop54, $pop149
	br_if   	2, $pop55       # 2: down to label0
# BB#33:                                # %for.inc87.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push152=, 6
	i32.add 	$push56=, $5, $pop152
	i32.load8_u	$push57=, 0($pop56)
	i32.const	$push151=, 97
	i32.ne  	$push58=, $pop57, $pop151
	br_if   	2, $pop58       # 2: down to label0
# BB#34:                                # %for.inc87.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push154=, 7
	i32.add 	$push59=, $5, $pop154
	i32.load8_u	$push60=, 0($pop59)
	i32.const	$push153=, 97
	i32.ne  	$push61=, $pop60, $pop153
	br_if   	2, $pop61       # 2: down to label0
# BB#35:                                # %for.inc87.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push155=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop155, $3
	block   	
	block   	
	i32.eqz 	$push193=, $1
	br_if   	0, $pop193      # 0: down to label11
# BB#36:                                # %for.body100.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$5=, 0
.LBB0_37:                               # %for.body100
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label12:
	i32.const	$push157=, u
	i32.add 	$push62=, $5, $pop157
	i32.load8_u	$push63=, 0($pop62)
	i32.const	$push156=, 97
	i32.ne  	$push64=, $pop63, $pop156
	br_if   	5, $pop64       # 5: down to label0
# BB#38:                                # %for.inc106
                                        #   in Loop: Header=BB0_37 Depth=3
	i32.const	$push160=, 1
	i32.add 	$push159=, $5, $pop160
	tee_local	$push158=, $5=, $pop159
	i32.lt_u	$push65=, $pop158, $1
	br_if   	0, $pop65       # 0: up to label12
# BB#39:                                # %for.body113.preheader.loopexit
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop
	i32.const	$push161=, u
	i32.add 	$4=, $5, $pop161
	br      	1               # 1: down to label10
.LBB0_40:                               #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label11:
	i32.const	$4=, u
.LBB0_41:                               # %for.body113.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label10:
	i32.const	$5=, 0
.LBB0_42:                               # %for.body113
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label13:
	i32.add 	$push66=, $4, $5
	i32.load8_u	$push67=, 0($pop66)
	i32.const	$push162=, 66
	i32.ne  	$push68=, $pop67, $pop162
	br_if   	3, $pop68       # 3: down to label0
# BB#43:                                # %for.inc119
                                        #   in Loop: Header=BB0_42 Depth=3
	i32.const	$push165=, 1
	i32.add 	$push164=, $5, $pop165
	tee_local	$push163=, $5=, $pop164
	i32.lt_u	$push69=, $pop163, $3
	br_if   	0, $pop69       # 0: up to label13
# BB#44:                                # %for.end122
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop
	i32.add 	$push168=, $4, $5
	tee_local	$push167=, $5=, $pop168
	i32.load8_u	$push70=, 0($pop167)
	i32.const	$push166=, 97
	i32.ne  	$push71=, $pop70, $pop166
	br_if   	2, $pop71       # 2: down to label0
# BB#45:                                # %for.inc132
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push170=, 1
	i32.add 	$push72=, $5, $pop170
	i32.load8_u	$push73=, 0($pop72)
	i32.const	$push169=, 97
	i32.ne  	$push74=, $pop73, $pop169
	br_if   	2, $pop74       # 2: down to label0
# BB#46:                                # %for.inc132.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push172=, 2
	i32.add 	$push75=, $5, $pop172
	i32.load8_u	$push76=, 0($pop75)
	i32.const	$push171=, 97
	i32.ne  	$push77=, $pop76, $pop171
	br_if   	2, $pop77       # 2: down to label0
# BB#47:                                # %for.inc132.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push174=, 3
	i32.add 	$push78=, $5, $pop174
	i32.load8_u	$push79=, 0($pop78)
	i32.const	$push173=, 97
	i32.ne  	$push80=, $pop79, $pop173
	br_if   	2, $pop80       # 2: down to label0
# BB#48:                                # %for.inc132.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push176=, 4
	i32.add 	$push81=, $5, $pop176
	i32.load8_u	$push82=, 0($pop81)
	i32.const	$push175=, 97
	i32.ne  	$push83=, $pop82, $pop175
	br_if   	2, $pop83       # 2: down to label0
# BB#49:                                # %for.inc132.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push178=, 5
	i32.add 	$push84=, $5, $pop178
	i32.load8_u	$push85=, 0($pop84)
	i32.const	$push177=, 97
	i32.ne  	$push86=, $pop85, $pop177
	br_if   	2, $pop86       # 2: down to label0
# BB#50:                                # %for.inc132.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push180=, 6
	i32.add 	$push87=, $5, $pop180
	i32.load8_u	$push88=, 0($pop87)
	i32.const	$push179=, 97
	i32.ne  	$push89=, $pop88, $pop179
	br_if   	2, $pop89       # 2: down to label0
# BB#51:                                # %for.inc132.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push182=, 7
	i32.add 	$push90=, $5, $pop182
	i32.load8_u	$push91=, 0($pop90)
	i32.const	$push181=, 97
	i32.ne  	$push92=, $pop91, $pop181
	br_if   	2, $pop92       # 2: down to label0
# BB#52:                                # %for.inc132.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push186=, 1
	i32.add 	$push185=, $3, $pop186
	tee_local	$push184=, $3=, $pop185
	i32.const	$push183=, 80
	i32.lt_u	$push93=, $pop184, $pop183
	br_if   	0, $pop93       # 0: up to label2
# BB#53:                                # %for.inc139
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop
	i32.const	$push190=, 1
	i32.add 	$push189=, $1, $pop190
	tee_local	$push188=, $1=, $pop189
	i32.const	$push187=, 8
	i32.lt_u	$push94=, $pop188, $pop187
	br_if   	0, $pop94       # 0: up to label1
# BB#54:                                # %for.end141
	end_loop
	i32.const	$push95=, 0
	call    	exit@FUNCTION, $pop95
	unreachable
.LBB0_55:                               # %if.then14
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	A                       # @A
	.type	A,@object
	.section	.data.A,"aw",@progbits
	.globl	A
A:
	.int8	65                      # 0x41
	.size	A, 1

	.type	u,@object               # @u
	.section	.bss.u,"aw",@nobits
	.p2align	4
u:
	.skip	96
	.size	u, 96


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
