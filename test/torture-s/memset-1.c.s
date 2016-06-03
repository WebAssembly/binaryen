	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memset-1.c"
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
                                        #       Child Loop BB0_24 Depth 3
                                        #       Child Loop BB0_36 Depth 3
                                        #       Child Loop BB0_40 Depth 3
	block
	loop                            # label1:
	i32.const	$push93=, u
	i32.add 	$2=, $1, $pop93
	i32.const	$3=, 1
.LBB0_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_4 Depth 3
                                        #       Child Loop BB0_8 Depth 3
                                        #       Child Loop BB0_20 Depth 3
                                        #       Child Loop BB0_24 Depth 3
                                        #       Child Loop BB0_36 Depth 3
                                        #       Child Loop BB0_40 Depth 3
	loop                            # label3:
	i32.const	$5=, u
	i32.const	$push100=, u
	i32.const	$push99=, 97
	i32.const	$push98=, 96
	i32.call	$drop=, memset@FUNCTION, $pop100, $pop99, $pop98
	i32.const	$push97=, 0
	i32.call	$0=, memset@FUNCTION, $2, $pop97, $3
	block
	i32.const	$push96=, 1
	i32.lt_s	$push95=, $1, $pop96
	tee_local	$push94=, $4=, $pop95
	br_if   	0, $pop94       # 0: down to label5
# BB#3:                                 # %for.body11.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$6=, 0
.LBB0_4:                                # %for.body11
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label6:
	i32.load8_u	$push0=, u($6)
	i32.const	$push101=, 97
	i32.ne  	$push1=, $pop0, $pop101
	br_if   	7, $pop1        # 7: down to label0
# BB#5:                                 # %for.inc16
                                        #   in Loop: Header=BB0_4 Depth=3
	i32.const	$push104=, 1
	i32.add 	$push103=, $6, $pop104
	tee_local	$push102=, $6=, $pop103
	i32.lt_s	$push2=, $pop102, $1
	br_if   	0, $pop2        # 0: up to label6
# BB#6:                                 # %for.body22.preheader.loopexit
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label7:
	i32.const	$push105=, u
	i32.add 	$5=, $6, $pop105
.LBB0_7:                                # %for.body22.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label5:
	i32.const	$6=, 0
.LBB0_8:                                # %for.body22
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label8:
	i32.add 	$push3=, $5, $6
	i32.load8_u	$push4=, 0($pop3)
	br_if   	6, $pop4        # 6: down to label0
# BB#9:                                 # %for.inc28
                                        #   in Loop: Header=BB0_8 Depth=3
	i32.const	$push108=, 1
	i32.add 	$push107=, $6, $pop108
	tee_local	$push106=, $6=, $pop107
	i32.lt_s	$push5=, $pop106, $3
	br_if   	0, $pop5        # 0: up to label8
# BB#10:                                # %for.body35.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label9:
	i32.add 	$push111=, $5, $6
	tee_local	$push110=, $6=, $pop111
	i32.load8_u	$push6=, 0($pop110)
	i32.const	$push109=, 97
	i32.ne  	$push7=, $pop6, $pop109
	br_if   	4, $pop7        # 4: down to label0
# BB#11:                                # %for.inc41
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push113=, 1
	i32.add 	$push8=, $6, $pop113
	i32.load8_u	$push9=, 0($pop8)
	i32.const	$push112=, 97
	i32.ne  	$push10=, $pop9, $pop112
	br_if   	4, $pop10       # 4: down to label0
# BB#12:                                # %for.inc41.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push115=, 2
	i32.add 	$push11=, $6, $pop115
	i32.load8_u	$push12=, 0($pop11)
	i32.const	$push114=, 97
	i32.ne  	$push13=, $pop12, $pop114
	br_if   	4, $pop13       # 4: down to label0
# BB#13:                                # %for.inc41.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push117=, 3
	i32.add 	$push14=, $6, $pop117
	i32.load8_u	$push15=, 0($pop14)
	i32.const	$push116=, 97
	i32.ne  	$push16=, $pop15, $pop116
	br_if   	4, $pop16       # 4: down to label0
# BB#14:                                # %for.inc41.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push119=, 4
	i32.add 	$push17=, $6, $pop119
	i32.load8_u	$push18=, 0($pop17)
	i32.const	$push118=, 97
	i32.ne  	$push19=, $pop18, $pop118
	br_if   	4, $pop19       # 4: down to label0
# BB#15:                                # %for.inc41.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push121=, 5
	i32.add 	$push20=, $6, $pop121
	i32.load8_u	$push21=, 0($pop20)
	i32.const	$push120=, 97
	i32.ne  	$push22=, $pop21, $pop120
	br_if   	4, $pop22       # 4: down to label0
# BB#16:                                # %for.inc41.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push123=, 6
	i32.add 	$push23=, $6, $pop123
	i32.load8_u	$push24=, 0($pop23)
	i32.const	$push122=, 97
	i32.ne  	$push25=, $pop24, $pop122
	br_if   	4, $pop25       # 4: down to label0
# BB#17:                                # %for.inc41.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push125=, 7
	i32.add 	$push26=, $6, $pop125
	i32.load8_u	$push27=, 0($pop26)
	i32.const	$push124=, 97
	i32.ne  	$push28=, $pop27, $pop124
	br_if   	4, $pop28       # 4: down to label0
# BB#18:                                # %for.inc41.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push126=, 0
	i32.load8_u	$push29=, A($pop126)
	i32.call	$drop=, memset@FUNCTION, $0, $pop29, $3
	i32.const	$5=, u
	block
	br_if   	0, $4           # 0: down to label10
# BB#19:                                # %for.body56.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$6=, 0
.LBB0_20:                               # %for.body56
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label11:
	i32.load8_u	$push30=, u($6)
	i32.const	$push127=, 97
	i32.ne  	$push31=, $pop30, $pop127
	br_if   	7, $pop31       # 7: down to label0
# BB#21:                                # %for.inc62
                                        #   in Loop: Header=BB0_20 Depth=3
	i32.const	$push130=, 1
	i32.add 	$push129=, $6, $pop130
	tee_local	$push128=, $6=, $pop129
	i32.lt_s	$push32=, $pop128, $1
	br_if   	0, $pop32       # 0: up to label11
# BB#22:                                # %for.body69.preheader.loopexit
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label12:
	i32.const	$push131=, u
	i32.add 	$5=, $6, $pop131
.LBB0_23:                               # %for.body69.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label10:
	i32.const	$6=, 0
.LBB0_24:                               # %for.body69
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label13:
	i32.add 	$push33=, $5, $6
	i32.load8_u	$push34=, 0($pop33)
	i32.const	$push132=, 65
	i32.ne  	$push35=, $pop34, $pop132
	br_if   	6, $pop35       # 6: down to label0
# BB#25:                                # %for.inc75
                                        #   in Loop: Header=BB0_24 Depth=3
	i32.const	$push135=, 1
	i32.add 	$push134=, $6, $pop135
	tee_local	$push133=, $6=, $pop134
	i32.lt_s	$push36=, $pop133, $3
	br_if   	0, $pop36       # 0: up to label13
# BB#26:                                # %for.body82.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label14:
	i32.add 	$push138=, $5, $6
	tee_local	$push137=, $6=, $pop138
	i32.load8_u	$push37=, 0($pop137)
	i32.const	$push136=, 97
	i32.ne  	$push38=, $pop37, $pop136
	br_if   	4, $pop38       # 4: down to label0
# BB#27:                                # %for.inc88
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push140=, 1
	i32.add 	$push39=, $6, $pop140
	i32.load8_u	$push40=, 0($pop39)
	i32.const	$push139=, 97
	i32.ne  	$push41=, $pop40, $pop139
	br_if   	4, $pop41       # 4: down to label0
# BB#28:                                # %for.inc88.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push142=, 2
	i32.add 	$push42=, $6, $pop142
	i32.load8_u	$push43=, 0($pop42)
	i32.const	$push141=, 97
	i32.ne  	$push44=, $pop43, $pop141
	br_if   	4, $pop44       # 4: down to label0
# BB#29:                                # %for.inc88.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push144=, 3
	i32.add 	$push45=, $6, $pop144
	i32.load8_u	$push46=, 0($pop45)
	i32.const	$push143=, 97
	i32.ne  	$push47=, $pop46, $pop143
	br_if   	4, $pop47       # 4: down to label0
# BB#30:                                # %for.inc88.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push146=, 4
	i32.add 	$push48=, $6, $pop146
	i32.load8_u	$push49=, 0($pop48)
	i32.const	$push145=, 97
	i32.ne  	$push50=, $pop49, $pop145
	br_if   	4, $pop50       # 4: down to label0
# BB#31:                                # %for.inc88.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push148=, 5
	i32.add 	$push51=, $6, $pop148
	i32.load8_u	$push52=, 0($pop51)
	i32.const	$push147=, 97
	i32.ne  	$push53=, $pop52, $pop147
	br_if   	4, $pop53       # 4: down to label0
# BB#32:                                # %for.inc88.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push150=, 6
	i32.add 	$push54=, $6, $pop150
	i32.load8_u	$push55=, 0($pop54)
	i32.const	$push149=, 97
	i32.ne  	$push56=, $pop55, $pop149
	br_if   	4, $pop56       # 4: down to label0
# BB#33:                                # %for.inc88.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push152=, 7
	i32.add 	$push57=, $6, $pop152
	i32.load8_u	$push58=, 0($pop57)
	i32.const	$push151=, 97
	i32.ne  	$push59=, $pop58, $pop151
	br_if   	4, $pop59       # 4: down to label0
# BB#34:                                # %for.inc88.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push153=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop153, $3
	i32.const	$5=, u
	block
	br_if   	0, $4           # 0: down to label15
# BB#35:                                # %for.body102.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$6=, 0
.LBB0_36:                               # %for.body102
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label16:
	i32.load8_u	$push60=, u($6)
	i32.const	$push154=, 97
	i32.ne  	$push61=, $pop60, $pop154
	br_if   	7, $pop61       # 7: down to label0
# BB#37:                                # %for.inc108
                                        #   in Loop: Header=BB0_36 Depth=3
	i32.const	$push157=, 1
	i32.add 	$push156=, $6, $pop157
	tee_local	$push155=, $6=, $pop156
	i32.lt_s	$push62=, $pop155, $1
	br_if   	0, $pop62       # 0: up to label16
# BB#38:                                # %for.body115.preheader.loopexit
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label17:
	i32.const	$push158=, u
	i32.add 	$5=, $6, $pop158
.LBB0_39:                               # %for.body115.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label15:
	i32.const	$6=, 0
.LBB0_40:                               # %for.body115
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label18:
	i32.add 	$push63=, $5, $6
	i32.load8_u	$push64=, 0($pop63)
	i32.const	$push159=, 66
	i32.ne  	$push65=, $pop64, $pop159
	br_if   	6, $pop65       # 6: down to label0
# BB#41:                                # %for.inc121
                                        #   in Loop: Header=BB0_40 Depth=3
	i32.const	$push162=, 1
	i32.add 	$push161=, $6, $pop162
	tee_local	$push160=, $6=, $pop161
	i32.lt_s	$push66=, $pop160, $3
	br_if   	0, $pop66       # 0: up to label18
# BB#42:                                # %for.body128.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label19:
	i32.add 	$push165=, $5, $6
	tee_local	$push164=, $6=, $pop165
	i32.load8_u	$push67=, 0($pop164)
	i32.const	$push163=, 97
	i32.ne  	$push68=, $pop67, $pop163
	br_if   	4, $pop68       # 4: down to label0
# BB#43:                                # %for.inc134
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push167=, 1
	i32.add 	$push69=, $6, $pop167
	i32.load8_u	$push70=, 0($pop69)
	i32.const	$push166=, 97
	i32.ne  	$push71=, $pop70, $pop166
	br_if   	4, $pop71       # 4: down to label0
# BB#44:                                # %for.inc134.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push169=, 2
	i32.add 	$push72=, $6, $pop169
	i32.load8_u	$push73=, 0($pop72)
	i32.const	$push168=, 97
	i32.ne  	$push74=, $pop73, $pop168
	br_if   	4, $pop74       # 4: down to label0
# BB#45:                                # %for.inc134.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push171=, 3
	i32.add 	$push75=, $6, $pop171
	i32.load8_u	$push76=, 0($pop75)
	i32.const	$push170=, 97
	i32.ne  	$push77=, $pop76, $pop170
	br_if   	4, $pop77       # 4: down to label0
# BB#46:                                # %for.inc134.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push173=, 4
	i32.add 	$push78=, $6, $pop173
	i32.load8_u	$push79=, 0($pop78)
	i32.const	$push172=, 97
	i32.ne  	$push80=, $pop79, $pop172
	br_if   	4, $pop80       # 4: down to label0
# BB#47:                                # %for.inc134.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push175=, 5
	i32.add 	$push81=, $6, $pop175
	i32.load8_u	$push82=, 0($pop81)
	i32.const	$push174=, 97
	i32.ne  	$push83=, $pop82, $pop174
	br_if   	4, $pop83       # 4: down to label0
# BB#48:                                # %for.inc134.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push177=, 6
	i32.add 	$push84=, $6, $pop177
	i32.load8_u	$push85=, 0($pop84)
	i32.const	$push176=, 97
	i32.ne  	$push86=, $pop85, $pop176
	br_if   	4, $pop86       # 4: down to label0
# BB#49:                                # %for.inc134.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push179=, 7
	i32.add 	$push87=, $6, $pop179
	i32.load8_u	$push88=, 0($pop87)
	i32.const	$push178=, 97
	i32.ne  	$push89=, $pop88, $pop178
	br_if   	4, $pop89       # 4: down to label0
# BB#50:                                # %for.inc134.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push183=, 1
	i32.add 	$push182=, $3, $pop183
	tee_local	$push181=, $3=, $pop182
	i32.const	$push180=, 80
	i32.lt_u	$push90=, $pop181, $pop180
	br_if   	0, $pop90       # 0: up to label3
# BB#51:                                # %for.inc141
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label4:
	i32.const	$push187=, 1
	i32.add 	$push186=, $1, $pop187
	tee_local	$push185=, $1=, $pop186
	i32.const	$push184=, 8
	i32.lt_u	$push91=, $pop185, $pop184
	br_if   	0, $pop91       # 0: up to label1
# BB#52:                                # %for.end143
	end_loop                        # label2:
	i32.const	$push92=, 0
	call    	exit@FUNCTION, $pop92
	unreachable
.LBB0_53:                               # %if.then132
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
	.lcomm	u,96,4

	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
