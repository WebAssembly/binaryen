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
	i32.const	$4=, u
	i32.const	$push100=, u
	i32.const	$push99=, 97
	i32.const	$push98=, 96
	i32.call	$drop=, memset@FUNCTION, $pop100, $pop99, $pop98
	i32.const	$push97=, 0
	i32.call	$0=, memset@FUNCTION, $2, $pop97, $3
	block
	i32.const	$push96=, 1
	i32.lt_s	$push95=, $1, $pop96
	tee_local	$push94=, $5=, $pop95
	br_if   	0, $pop94       # 0: down to label5
# BB#3:                                 # %for.body11.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$6=, 0
.LBB0_4:                                # %for.body11
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label6:
	copy_local	$push103=, $6
	tee_local	$push102=, $4=, $pop103
	i32.load8_u	$push0=, u($pop102)
	i32.const	$push101=, 97
	i32.ne  	$push1=, $pop0, $pop101
	br_if   	7, $pop1        # 7: down to label0
# BB#5:                                 # %for.inc16
                                        #   in Loop: Header=BB0_4 Depth=3
	i32.const	$push106=, 1
	i32.add 	$push105=, $4, $pop106
	tee_local	$push104=, $6=, $pop105
	i32.lt_s	$push2=, $pop104, $1
	br_if   	0, $pop2        # 0: up to label6
# BB#6:                                 #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label7:
	i32.const	$push107=, u+1
	i32.add 	$4=, $4, $pop107
.LBB0_7:                                # %for.body22.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label5:
	i32.const	$6=, 0
.LBB0_8:                                # %for.body22
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label8:
	i32.add 	$push3=, $4, $6
	i32.load8_u	$push4=, 0($pop3)
	br_if   	6, $pop4        # 6: down to label0
# BB#9:                                 # %for.inc28
                                        #   in Loop: Header=BB0_8 Depth=3
	i32.const	$push110=, 1
	i32.add 	$push109=, $6, $pop110
	tee_local	$push108=, $6=, $pop109
	i32.lt_s	$push5=, $pop108, $3
	br_if   	0, $pop5        # 0: up to label8
# BB#10:                                # %for.body35.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label9:
	i32.add 	$push113=, $4, $6
	tee_local	$push112=, $6=, $pop113
	i32.load8_u	$push6=, 0($pop112)
	i32.const	$push111=, 97
	i32.ne  	$push7=, $pop6, $pop111
	br_if   	4, $pop7        # 4: down to label0
# BB#11:                                # %for.inc41
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push115=, 1
	i32.add 	$push8=, $6, $pop115
	i32.load8_u	$push9=, 0($pop8)
	i32.const	$push114=, 97
	i32.ne  	$push10=, $pop9, $pop114
	br_if   	4, $pop10       # 4: down to label0
# BB#12:                                # %for.inc41.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push117=, 2
	i32.add 	$push11=, $6, $pop117
	i32.load8_u	$push12=, 0($pop11)
	i32.const	$push116=, 97
	i32.ne  	$push13=, $pop12, $pop116
	br_if   	4, $pop13       # 4: down to label0
# BB#13:                                # %for.inc41.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push119=, 3
	i32.add 	$push14=, $6, $pop119
	i32.load8_u	$push15=, 0($pop14)
	i32.const	$push118=, 97
	i32.ne  	$push16=, $pop15, $pop118
	br_if   	4, $pop16       # 4: down to label0
# BB#14:                                # %for.inc41.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push121=, 4
	i32.add 	$push17=, $6, $pop121
	i32.load8_u	$push18=, 0($pop17)
	i32.const	$push120=, 97
	i32.ne  	$push19=, $pop18, $pop120
	br_if   	4, $pop19       # 4: down to label0
# BB#15:                                # %for.inc41.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push123=, 5
	i32.add 	$push20=, $6, $pop123
	i32.load8_u	$push21=, 0($pop20)
	i32.const	$push122=, 97
	i32.ne  	$push22=, $pop21, $pop122
	br_if   	4, $pop22       # 4: down to label0
# BB#16:                                # %for.inc41.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push125=, 6
	i32.add 	$push23=, $6, $pop125
	i32.load8_u	$push24=, 0($pop23)
	i32.const	$push124=, 97
	i32.ne  	$push25=, $pop24, $pop124
	br_if   	4, $pop25       # 4: down to label0
# BB#17:                                # %for.inc41.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push127=, 7
	i32.add 	$push26=, $6, $pop127
	i32.load8_u	$push27=, 0($pop26)
	i32.const	$push126=, 97
	i32.ne  	$push28=, $pop27, $pop126
	br_if   	4, $pop28       # 4: down to label0
# BB#18:                                # %for.inc41.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push128=, 0
	i32.load8_u	$push29=, A($pop128)
	i32.call	$drop=, memset@FUNCTION, $0, $pop29, $3
	i32.const	$4=, u
	block
	br_if   	0, $5           # 0: down to label10
# BB#19:                                # %for.body56.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$6=, 0
.LBB0_20:                               # %for.body56
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label11:
	copy_local	$push131=, $6
	tee_local	$push130=, $4=, $pop131
	i32.load8_u	$push30=, u($pop130)
	i32.const	$push129=, 97
	i32.ne  	$push31=, $pop30, $pop129
	br_if   	7, $pop31       # 7: down to label0
# BB#21:                                # %for.inc62
                                        #   in Loop: Header=BB0_20 Depth=3
	i32.const	$push134=, 1
	i32.add 	$push133=, $4, $pop134
	tee_local	$push132=, $6=, $pop133
	i32.lt_s	$push32=, $pop132, $1
	br_if   	0, $pop32       # 0: up to label11
# BB#22:                                #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label12:
	i32.const	$push135=, u+1
	i32.add 	$4=, $4, $pop135
.LBB0_23:                               # %for.body69.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label10:
	i32.const	$6=, 0
.LBB0_24:                               # %for.body69
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label13:
	i32.add 	$push33=, $4, $6
	i32.load8_u	$push34=, 0($pop33)
	i32.const	$push136=, 65
	i32.ne  	$push35=, $pop34, $pop136
	br_if   	6, $pop35       # 6: down to label0
# BB#25:                                # %for.inc75
                                        #   in Loop: Header=BB0_24 Depth=3
	i32.const	$push139=, 1
	i32.add 	$push138=, $6, $pop139
	tee_local	$push137=, $6=, $pop138
	i32.lt_s	$push36=, $pop137, $3
	br_if   	0, $pop36       # 0: up to label13
# BB#26:                                # %for.body82.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label14:
	i32.add 	$push142=, $4, $6
	tee_local	$push141=, $6=, $pop142
	i32.load8_u	$push37=, 0($pop141)
	i32.const	$push140=, 97
	i32.ne  	$push38=, $pop37, $pop140
	br_if   	4, $pop38       # 4: down to label0
# BB#27:                                # %for.inc88
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push144=, 1
	i32.add 	$push39=, $6, $pop144
	i32.load8_u	$push40=, 0($pop39)
	i32.const	$push143=, 97
	i32.ne  	$push41=, $pop40, $pop143
	br_if   	4, $pop41       # 4: down to label0
# BB#28:                                # %for.inc88.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push146=, 2
	i32.add 	$push42=, $6, $pop146
	i32.load8_u	$push43=, 0($pop42)
	i32.const	$push145=, 97
	i32.ne  	$push44=, $pop43, $pop145
	br_if   	4, $pop44       # 4: down to label0
# BB#29:                                # %for.inc88.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push148=, 3
	i32.add 	$push45=, $6, $pop148
	i32.load8_u	$push46=, 0($pop45)
	i32.const	$push147=, 97
	i32.ne  	$push47=, $pop46, $pop147
	br_if   	4, $pop47       # 4: down to label0
# BB#30:                                # %for.inc88.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push150=, 4
	i32.add 	$push48=, $6, $pop150
	i32.load8_u	$push49=, 0($pop48)
	i32.const	$push149=, 97
	i32.ne  	$push50=, $pop49, $pop149
	br_if   	4, $pop50       # 4: down to label0
# BB#31:                                # %for.inc88.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push152=, 5
	i32.add 	$push51=, $6, $pop152
	i32.load8_u	$push52=, 0($pop51)
	i32.const	$push151=, 97
	i32.ne  	$push53=, $pop52, $pop151
	br_if   	4, $pop53       # 4: down to label0
# BB#32:                                # %for.inc88.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push154=, 6
	i32.add 	$push54=, $6, $pop154
	i32.load8_u	$push55=, 0($pop54)
	i32.const	$push153=, 97
	i32.ne  	$push56=, $pop55, $pop153
	br_if   	4, $pop56       # 4: down to label0
# BB#33:                                # %for.inc88.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push156=, 7
	i32.add 	$push57=, $6, $pop156
	i32.load8_u	$push58=, 0($pop57)
	i32.const	$push155=, 97
	i32.ne  	$push59=, $pop58, $pop155
	br_if   	4, $pop59       # 4: down to label0
# BB#34:                                # %for.inc88.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push157=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop157, $3
	i32.const	$4=, u
	block
	br_if   	0, $5           # 0: down to label15
# BB#35:                                # %for.body102.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$6=, 0
.LBB0_36:                               # %for.body102
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label16:
	copy_local	$push160=, $6
	tee_local	$push159=, $4=, $pop160
	i32.load8_u	$push60=, u($pop159)
	i32.const	$push158=, 97
	i32.ne  	$push61=, $pop60, $pop158
	br_if   	7, $pop61       # 7: down to label0
# BB#37:                                # %for.inc108
                                        #   in Loop: Header=BB0_36 Depth=3
	i32.const	$push163=, 1
	i32.add 	$push162=, $4, $pop163
	tee_local	$push161=, $6=, $pop162
	i32.lt_s	$push62=, $pop161, $1
	br_if   	0, $pop62       # 0: up to label16
# BB#38:                                #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label17:
	i32.const	$push164=, u+1
	i32.add 	$4=, $4, $pop164
.LBB0_39:                               # %for.body115.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label15:
	i32.const	$6=, 0
.LBB0_40:                               # %for.body115
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label18:
	i32.add 	$push63=, $4, $6
	i32.load8_u	$push64=, 0($pop63)
	i32.const	$push165=, 66
	i32.ne  	$push65=, $pop64, $pop165
	br_if   	6, $pop65       # 6: down to label0
# BB#41:                                # %for.inc121
                                        #   in Loop: Header=BB0_40 Depth=3
	i32.const	$push168=, 1
	i32.add 	$push167=, $6, $pop168
	tee_local	$push166=, $6=, $pop167
	i32.lt_s	$push66=, $pop166, $3
	br_if   	0, $pop66       # 0: up to label18
# BB#42:                                # %for.body128.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label19:
	i32.add 	$push171=, $4, $6
	tee_local	$push170=, $6=, $pop171
	i32.load8_u	$push67=, 0($pop170)
	i32.const	$push169=, 97
	i32.ne  	$push68=, $pop67, $pop169
	br_if   	4, $pop68       # 4: down to label0
# BB#43:                                # %for.inc134
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push173=, 1
	i32.add 	$push69=, $6, $pop173
	i32.load8_u	$push70=, 0($pop69)
	i32.const	$push172=, 97
	i32.ne  	$push71=, $pop70, $pop172
	br_if   	4, $pop71       # 4: down to label0
# BB#44:                                # %for.inc134.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push175=, 2
	i32.add 	$push72=, $6, $pop175
	i32.load8_u	$push73=, 0($pop72)
	i32.const	$push174=, 97
	i32.ne  	$push74=, $pop73, $pop174
	br_if   	4, $pop74       # 4: down to label0
# BB#45:                                # %for.inc134.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push177=, 3
	i32.add 	$push75=, $6, $pop177
	i32.load8_u	$push76=, 0($pop75)
	i32.const	$push176=, 97
	i32.ne  	$push77=, $pop76, $pop176
	br_if   	4, $pop77       # 4: down to label0
# BB#46:                                # %for.inc134.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push179=, 4
	i32.add 	$push78=, $6, $pop179
	i32.load8_u	$push79=, 0($pop78)
	i32.const	$push178=, 97
	i32.ne  	$push80=, $pop79, $pop178
	br_if   	4, $pop80       # 4: down to label0
# BB#47:                                # %for.inc134.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push181=, 5
	i32.add 	$push81=, $6, $pop181
	i32.load8_u	$push82=, 0($pop81)
	i32.const	$push180=, 97
	i32.ne  	$push83=, $pop82, $pop180
	br_if   	4, $pop83       # 4: down to label0
# BB#48:                                # %for.inc134.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push183=, 6
	i32.add 	$push84=, $6, $pop183
	i32.load8_u	$push85=, 0($pop84)
	i32.const	$push182=, 97
	i32.ne  	$push86=, $pop85, $pop182
	br_if   	4, $pop86       # 4: down to label0
# BB#49:                                # %for.inc134.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push185=, 7
	i32.add 	$push87=, $6, $pop185
	i32.load8_u	$push88=, 0($pop87)
	i32.const	$push184=, 97
	i32.ne  	$push89=, $pop88, $pop184
	br_if   	4, $pop89       # 4: down to label0
# BB#50:                                # %for.inc134.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push189=, 1
	i32.add 	$push188=, $3, $pop189
	tee_local	$push187=, $3=, $pop188
	i32.const	$push186=, 80
	i32.lt_u	$push90=, $pop187, $pop186
	br_if   	0, $pop90       # 0: up to label3
# BB#51:                                # %for.inc141
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label4:
	i32.const	$push193=, 1
	i32.add 	$push192=, $1, $pop193
	tee_local	$push191=, $1=, $pop192
	i32.const	$push190=, 8
	i32.lt_u	$push91=, $pop191, $pop190
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
