	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memset-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
.LBB0_1:                                # %for.cond1.preheader
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
.LBB0_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_4 Depth 3
                                        #       Child Loop BB0_8 Depth 3
                                        #       Child Loop BB0_20 Depth 3
                                        #       Child Loop BB0_25 Depth 3
                                        #       Child Loop BB0_37 Depth 3
                                        #       Child Loop BB0_42 Depth 3
	loop    	                # label2:
	i32.const	$5=, u
	i32.const	$push103=, u
	i32.const	$push102=, 97
	i32.const	$push101=, 96
	i32.call	$drop=, memset@FUNCTION, $pop103, $pop102, $pop101
	i32.const	$push100=, 0
	i32.call	$0=, memset@FUNCTION, $2, $pop100, $3
	block   	
	i32.const	$push99=, 1
	i32.lt_s	$push98=, $1, $pop99
	tee_local	$push97=, $4=, $pop98
	br_if   	0, $pop97       # 0: down to label3
# BB#3:                                 # %for.body11.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$6=, 0
.LBB0_4:                                # %for.body11
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label4:
	i32.const	$push105=, u
	i32.add 	$push0=, $6, $pop105
	i32.load8_u	$push1=, 0($pop0)
	i32.const	$push104=, 97
	i32.ne  	$push2=, $pop1, $pop104
	br_if   	4, $pop2        # 4: down to label0
# BB#5:                                 # %for.inc16
                                        #   in Loop: Header=BB0_4 Depth=3
	i32.const	$push108=, 1
	i32.add 	$push107=, $6, $pop108
	tee_local	$push106=, $6=, $pop107
	i32.lt_s	$push3=, $pop106, $1
	br_if   	0, $pop3        # 0: up to label4
# BB#6:                                 # %for.body22.preheader.loopexit
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop
	i32.const	$push109=, u
	i32.add 	$5=, $6, $pop109
.LBB0_7:                                # %for.body22.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label3:
	i32.const	$6=, 0
.LBB0_8:                                # %for.body22
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label5:
	i32.add 	$push4=, $5, $6
	i32.load8_u	$push5=, 0($pop4)
	br_if   	3, $pop5        # 3: down to label0
# BB#9:                                 # %for.inc28
                                        #   in Loop: Header=BB0_8 Depth=3
	i32.const	$push112=, 1
	i32.add 	$push111=, $6, $pop112
	tee_local	$push110=, $6=, $pop111
	i32.lt_s	$push6=, $pop110, $3
	br_if   	0, $pop6        # 0: up to label5
# BB#10:                                # %for.body35.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop
	i32.add 	$push115=, $5, $6
	tee_local	$push114=, $6=, $pop115
	i32.load8_u	$push7=, 0($pop114)
	i32.const	$push113=, 97
	i32.ne  	$push8=, $pop7, $pop113
	br_if   	2, $pop8        # 2: down to label0
# BB#11:                                # %for.inc41
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push117=, 1
	i32.add 	$push9=, $6, $pop117
	i32.load8_u	$push10=, 0($pop9)
	i32.const	$push116=, 97
	i32.ne  	$push11=, $pop10, $pop116
	br_if   	2, $pop11       # 2: down to label0
# BB#12:                                # %for.inc41.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push119=, 2
	i32.add 	$push12=, $6, $pop119
	i32.load8_u	$push13=, 0($pop12)
	i32.const	$push118=, 97
	i32.ne  	$push14=, $pop13, $pop118
	br_if   	2, $pop14       # 2: down to label0
# BB#13:                                # %for.inc41.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push121=, 3
	i32.add 	$push15=, $6, $pop121
	i32.load8_u	$push16=, 0($pop15)
	i32.const	$push120=, 97
	i32.ne  	$push17=, $pop16, $pop120
	br_if   	2, $pop17       # 2: down to label0
# BB#14:                                # %for.inc41.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push123=, 4
	i32.add 	$push18=, $6, $pop123
	i32.load8_u	$push19=, 0($pop18)
	i32.const	$push122=, 97
	i32.ne  	$push20=, $pop19, $pop122
	br_if   	2, $pop20       # 2: down to label0
# BB#15:                                # %for.inc41.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push125=, 5
	i32.add 	$push21=, $6, $pop125
	i32.load8_u	$push22=, 0($pop21)
	i32.const	$push124=, 97
	i32.ne  	$push23=, $pop22, $pop124
	br_if   	2, $pop23       # 2: down to label0
# BB#16:                                # %for.inc41.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push127=, 6
	i32.add 	$push24=, $6, $pop127
	i32.load8_u	$push25=, 0($pop24)
	i32.const	$push126=, 97
	i32.ne  	$push26=, $pop25, $pop126
	br_if   	2, $pop26       # 2: down to label0
# BB#17:                                # %for.inc41.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push129=, 7
	i32.add 	$push27=, $6, $pop129
	i32.load8_u	$push28=, 0($pop27)
	i32.const	$push128=, 97
	i32.ne  	$push29=, $pop28, $pop128
	br_if   	2, $pop29       # 2: down to label0
# BB#18:                                # %for.inc41.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push130=, 0
	i32.load8_u	$push30=, A($pop130)
	i32.call	$drop=, memset@FUNCTION, $0, $pop30, $3
	block   	
	block   	
	br_if   	0, $4           # 0: down to label7
# BB#19:                                # %for.body55.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$6=, 0
.LBB0_20:                               # %for.body55
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label8:
	i32.const	$push132=, u
	i32.add 	$push31=, $6, $pop132
	i32.load8_u	$push32=, 0($pop31)
	i32.const	$push131=, 97
	i32.ne  	$push33=, $pop32, $pop131
	br_if   	5, $pop33       # 5: down to label0
# BB#21:                                # %for.inc61
                                        #   in Loop: Header=BB0_20 Depth=3
	i32.const	$push135=, 1
	i32.add 	$push134=, $6, $pop135
	tee_local	$push133=, $6=, $pop134
	i32.lt_s	$push34=, $pop133, $1
	br_if   	0, $pop34       # 0: up to label8
# BB#22:                                # %for.body68.preheader.loopexit
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop
	i32.const	$push136=, u
	i32.add 	$5=, $6, $pop136
	br      	1               # 1: down to label6
.LBB0_23:                               #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label7:
	i32.const	$5=, u
.LBB0_24:                               # %for.body68.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label6:
	i32.const	$6=, 0
.LBB0_25:                               # %for.body68
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label9:
	i32.add 	$push35=, $5, $6
	i32.load8_u	$push36=, 0($pop35)
	i32.const	$push137=, 65
	i32.ne  	$push37=, $pop36, $pop137
	br_if   	3, $pop37       # 3: down to label0
# BB#26:                                # %for.inc74
                                        #   in Loop: Header=BB0_25 Depth=3
	i32.const	$push140=, 1
	i32.add 	$push139=, $6, $pop140
	tee_local	$push138=, $6=, $pop139
	i32.lt_s	$push38=, $pop138, $3
	br_if   	0, $pop38       # 0: up to label9
# BB#27:                                # %for.body81.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop
	i32.add 	$push143=, $5, $6
	tee_local	$push142=, $6=, $pop143
	i32.load8_u	$push39=, 0($pop142)
	i32.const	$push141=, 97
	i32.ne  	$push40=, $pop39, $pop141
	br_if   	2, $pop40       # 2: down to label0
# BB#28:                                # %for.inc87
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push145=, 1
	i32.add 	$push41=, $6, $pop145
	i32.load8_u	$push42=, 0($pop41)
	i32.const	$push144=, 97
	i32.ne  	$push43=, $pop42, $pop144
	br_if   	2, $pop43       # 2: down to label0
# BB#29:                                # %for.inc87.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push147=, 2
	i32.add 	$push44=, $6, $pop147
	i32.load8_u	$push45=, 0($pop44)
	i32.const	$push146=, 97
	i32.ne  	$push46=, $pop45, $pop146
	br_if   	2, $pop46       # 2: down to label0
# BB#30:                                # %for.inc87.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push149=, 3
	i32.add 	$push47=, $6, $pop149
	i32.load8_u	$push48=, 0($pop47)
	i32.const	$push148=, 97
	i32.ne  	$push49=, $pop48, $pop148
	br_if   	2, $pop49       # 2: down to label0
# BB#31:                                # %for.inc87.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push151=, 4
	i32.add 	$push50=, $6, $pop151
	i32.load8_u	$push51=, 0($pop50)
	i32.const	$push150=, 97
	i32.ne  	$push52=, $pop51, $pop150
	br_if   	2, $pop52       # 2: down to label0
# BB#32:                                # %for.inc87.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push153=, 5
	i32.add 	$push53=, $6, $pop153
	i32.load8_u	$push54=, 0($pop53)
	i32.const	$push152=, 97
	i32.ne  	$push55=, $pop54, $pop152
	br_if   	2, $pop55       # 2: down to label0
# BB#33:                                # %for.inc87.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push155=, 6
	i32.add 	$push56=, $6, $pop155
	i32.load8_u	$push57=, 0($pop56)
	i32.const	$push154=, 97
	i32.ne  	$push58=, $pop57, $pop154
	br_if   	2, $pop58       # 2: down to label0
# BB#34:                                # %for.inc87.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push157=, 7
	i32.add 	$push59=, $6, $pop157
	i32.load8_u	$push60=, 0($pop59)
	i32.const	$push156=, 97
	i32.ne  	$push61=, $pop60, $pop156
	br_if   	2, $pop61       # 2: down to label0
# BB#35:                                # %for.inc87.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push158=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop158, $3
	block   	
	block   	
	br_if   	0, $4           # 0: down to label11
# BB#36:                                # %for.body100.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$6=, 0
.LBB0_37:                               # %for.body100
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label12:
	i32.const	$push160=, u
	i32.add 	$push62=, $6, $pop160
	i32.load8_u	$push63=, 0($pop62)
	i32.const	$push159=, 97
	i32.ne  	$push64=, $pop63, $pop159
	br_if   	5, $pop64       # 5: down to label0
# BB#38:                                # %for.inc106
                                        #   in Loop: Header=BB0_37 Depth=3
	i32.const	$push163=, 1
	i32.add 	$push162=, $6, $pop163
	tee_local	$push161=, $6=, $pop162
	i32.lt_s	$push65=, $pop161, $1
	br_if   	0, $pop65       # 0: up to label12
# BB#39:                                # %for.body113.preheader.loopexit
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop
	i32.const	$push164=, u
	i32.add 	$5=, $6, $pop164
	br      	1               # 1: down to label10
.LBB0_40:                               #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label11:
	i32.const	$5=, u
.LBB0_41:                               # %for.body113.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label10:
	i32.const	$6=, 0
.LBB0_42:                               # %for.body113
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label13:
	i32.add 	$push66=, $5, $6
	i32.load8_u	$push67=, 0($pop66)
	i32.const	$push165=, 66
	i32.ne  	$push68=, $pop67, $pop165
	br_if   	3, $pop68       # 3: down to label0
# BB#43:                                # %for.inc119
                                        #   in Loop: Header=BB0_42 Depth=3
	i32.const	$push168=, 1
	i32.add 	$push167=, $6, $pop168
	tee_local	$push166=, $6=, $pop167
	i32.lt_s	$push69=, $pop166, $3
	br_if   	0, $pop69       # 0: up to label13
# BB#44:                                # %for.body126.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop
	i32.add 	$push171=, $5, $6
	tee_local	$push170=, $6=, $pop171
	i32.load8_u	$push70=, 0($pop170)
	i32.const	$push169=, 97
	i32.ne  	$push71=, $pop70, $pop169
	br_if   	2, $pop71       # 2: down to label0
# BB#45:                                # %for.inc132
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push173=, 1
	i32.add 	$push72=, $6, $pop173
	i32.load8_u	$push73=, 0($pop72)
	i32.const	$push172=, 97
	i32.ne  	$push74=, $pop73, $pop172
	br_if   	2, $pop74       # 2: down to label0
# BB#46:                                # %for.inc132.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push175=, 2
	i32.add 	$push75=, $6, $pop175
	i32.load8_u	$push76=, 0($pop75)
	i32.const	$push174=, 97
	i32.ne  	$push77=, $pop76, $pop174
	br_if   	2, $pop77       # 2: down to label0
# BB#47:                                # %for.inc132.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push177=, 3
	i32.add 	$push78=, $6, $pop177
	i32.load8_u	$push79=, 0($pop78)
	i32.const	$push176=, 97
	i32.ne  	$push80=, $pop79, $pop176
	br_if   	2, $pop80       # 2: down to label0
# BB#48:                                # %for.inc132.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push179=, 4
	i32.add 	$push81=, $6, $pop179
	i32.load8_u	$push82=, 0($pop81)
	i32.const	$push178=, 97
	i32.ne  	$push83=, $pop82, $pop178
	br_if   	2, $pop83       # 2: down to label0
# BB#49:                                # %for.inc132.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push181=, 5
	i32.add 	$push84=, $6, $pop181
	i32.load8_u	$push85=, 0($pop84)
	i32.const	$push180=, 97
	i32.ne  	$push86=, $pop85, $pop180
	br_if   	2, $pop86       # 2: down to label0
# BB#50:                                # %for.inc132.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push183=, 6
	i32.add 	$push87=, $6, $pop183
	i32.load8_u	$push88=, 0($pop87)
	i32.const	$push182=, 97
	i32.ne  	$push89=, $pop88, $pop182
	br_if   	2, $pop89       # 2: down to label0
# BB#51:                                # %for.inc132.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push185=, 7
	i32.add 	$push90=, $6, $pop185
	i32.load8_u	$push91=, 0($pop90)
	i32.const	$push184=, 97
	i32.ne  	$push92=, $pop91, $pop184
	br_if   	2, $pop92       # 2: down to label0
# BB#52:                                # %for.inc132.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push189=, 1
	i32.add 	$push188=, $3, $pop189
	tee_local	$push187=, $3=, $pop188
	i32.const	$push186=, 80
	i32.lt_u	$push93=, $pop187, $pop186
	br_if   	0, $pop93       # 0: up to label2
# BB#53:                                # %for.inc139
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop
	i32.const	$push193=, 1
	i32.add 	$push192=, $1, $pop193
	tee_local	$push191=, $1=, $pop192
	i32.const	$push190=, 8
	i32.lt_u	$push94=, $pop191, $pop190
	br_if   	0, $pop94       # 0: up to label1
# BB#54:                                # %for.end141
	end_loop
	i32.const	$push95=, 0
	call    	exit@FUNCTION, $pop95
	unreachable
.LBB0_55:                               # %if.then130
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
	.functype	exit, void, i32
