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
	i32.const	$0=, 0
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
	i32.const	$push94=, u
	i32.add 	$1=, $0, $pop94
	i32.const	$2=, 1
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
	i32.const	$push0=, u
	i32.const	$push100=, 97
	i32.const	$push99=, 96
	i32.call	$6=, memset@FUNCTION, $pop0, $pop100, $pop99
	i32.const	$push98=, 0
	i32.call	$3=, memset@FUNCTION, $1, $pop98, $2
	block
	i32.const	$push97=, 1
	i32.lt_s	$push96=, $0, $pop97
	tee_local	$push95=, $5=, $pop96
	br_if   	0, $pop95       # 0: down to label5
# BB#3:                                 # %for.body11.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$4=, 0
.LBB0_4:                                # %for.body11
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label6:
	copy_local	$push103=, $4
	tee_local	$push102=, $6=, $pop103
	i32.load8_u	$push1=, u($pop102)
	i32.const	$push101=, 97
	i32.ne  	$push2=, $pop1, $pop101
	br_if   	7, $pop2        # 7: down to label0
# BB#5:                                 # %for.inc16
                                        #   in Loop: Header=BB0_4 Depth=3
	i32.const	$push104=, 1
	i32.add 	$4=, $6, $pop104
	i32.lt_s	$push3=, $4, $0
	br_if   	0, $pop3        # 0: up to label6
# BB#6:                                 #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label7:
	i32.const	$push105=, u+1
	i32.add 	$6=, $6, $pop105
.LBB0_7:                                # %for.body22.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label5:
	i32.const	$4=, 0
.LBB0_8:                                # %for.body22
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label8:
	i32.add 	$push4=, $6, $4
	i32.load8_u	$push5=, 0($pop4)
	br_if   	6, $pop5        # 6: down to label0
# BB#9:                                 # %for.inc28
                                        #   in Loop: Header=BB0_8 Depth=3
	i32.const	$push106=, 1
	i32.add 	$4=, $4, $pop106
	i32.lt_s	$push6=, $4, $2
	br_if   	0, $pop6        # 0: up to label8
# BB#10:                                # %for.body35.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label9:
	i32.add 	$push109=, $6, $4
	tee_local	$push108=, $4=, $pop109
	i32.load8_u	$push7=, 0($pop108)
	i32.const	$push107=, 97
	i32.ne  	$push8=, $pop7, $pop107
	br_if   	4, $pop8        # 4: down to label0
# BB#11:                                # %for.inc41
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push111=, 1
	i32.add 	$push9=, $4, $pop111
	i32.load8_u	$push10=, 0($pop9)
	i32.const	$push110=, 97
	i32.ne  	$push11=, $pop10, $pop110
	br_if   	4, $pop11       # 4: down to label0
# BB#12:                                # %for.inc41.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push139=, 2
	i32.add 	$push12=, $4, $pop139
	i32.load8_u	$push13=, 0($pop12)
	i32.const	$push138=, 97
	i32.ne  	$push14=, $pop13, $pop138
	br_if   	4, $pop14       # 4: down to label0
# BB#13:                                # %for.inc41.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push141=, 3
	i32.add 	$push15=, $4, $pop141
	i32.load8_u	$push16=, 0($pop15)
	i32.const	$push140=, 97
	i32.ne  	$push17=, $pop16, $pop140
	br_if   	4, $pop17       # 4: down to label0
# BB#14:                                # %for.inc41.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push143=, 4
	i32.add 	$push18=, $4, $pop143
	i32.load8_u	$push19=, 0($pop18)
	i32.const	$push142=, 97
	i32.ne  	$push20=, $pop19, $pop142
	br_if   	4, $pop20       # 4: down to label0
# BB#15:                                # %for.inc41.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push145=, 5
	i32.add 	$push21=, $4, $pop145
	i32.load8_u	$push22=, 0($pop21)
	i32.const	$push144=, 97
	i32.ne  	$push23=, $pop22, $pop144
	br_if   	4, $pop23       # 4: down to label0
# BB#16:                                # %for.inc41.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push147=, 6
	i32.add 	$push24=, $4, $pop147
	i32.load8_u	$push25=, 0($pop24)
	i32.const	$push146=, 97
	i32.ne  	$push26=, $pop25, $pop146
	br_if   	4, $pop26       # 4: down to label0
# BB#17:                                # %for.inc41.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push149=, 7
	i32.add 	$push27=, $4, $pop149
	i32.load8_u	$push28=, 0($pop27)
	i32.const	$push148=, 97
	i32.ne  	$push29=, $pop28, $pop148
	br_if   	4, $pop29       # 4: down to label0
# BB#18:                                # %for.inc41.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push150=, 0
	i32.load8_u	$push30=, A($pop150)
	i32.call	$discard=, memset@FUNCTION, $3, $pop30, $2
	i32.const	$6=, u
	block
	br_if   	0, $5           # 0: down to label10
# BB#19:                                # %for.body55.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$4=, 0
.LBB0_20:                               # %for.body55
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label11:
	copy_local	$push114=, $4
	tee_local	$push113=, $6=, $pop114
	i32.load8_u	$push31=, u($pop113)
	i32.const	$push112=, 97
	i32.ne  	$push32=, $pop31, $pop112
	br_if   	7, $pop32       # 7: down to label0
# BB#21:                                # %for.inc61
                                        #   in Loop: Header=BB0_20 Depth=3
	i32.const	$push115=, 1
	i32.add 	$4=, $6, $pop115
	i32.lt_s	$push33=, $4, $0
	br_if   	0, $pop33       # 0: up to label11
# BB#22:                                #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label12:
	i32.const	$push116=, u+1
	i32.add 	$6=, $6, $pop116
.LBB0_23:                               # %for.body68.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label10:
	i32.const	$4=, 0
.LBB0_24:                               # %for.body68
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label13:
	i32.add 	$push34=, $6, $4
	i32.load8_u	$push35=, 0($pop34)
	i32.const	$push117=, 65
	i32.ne  	$push36=, $pop35, $pop117
	br_if   	6, $pop36       # 6: down to label0
# BB#25:                                # %for.inc74
                                        #   in Loop: Header=BB0_24 Depth=3
	i32.const	$push118=, 1
	i32.add 	$4=, $4, $pop118
	i32.lt_s	$push37=, $4, $2
	br_if   	0, $pop37       # 0: up to label13
# BB#26:                                # %for.body81.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label14:
	i32.add 	$push121=, $6, $4
	tee_local	$push120=, $4=, $pop121
	i32.load8_u	$push38=, 0($pop120)
	i32.const	$push119=, 97
	i32.ne  	$push39=, $pop38, $pop119
	br_if   	4, $pop39       # 4: down to label0
# BB#27:                                # %for.inc87
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push123=, 1
	i32.add 	$push40=, $4, $pop123
	i32.load8_u	$push41=, 0($pop40)
	i32.const	$push122=, 97
	i32.ne  	$push42=, $pop41, $pop122
	br_if   	4, $pop42       # 4: down to label0
# BB#28:                                # %for.inc87.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push152=, 2
	i32.add 	$push43=, $4, $pop152
	i32.load8_u	$push44=, 0($pop43)
	i32.const	$push151=, 97
	i32.ne  	$push45=, $pop44, $pop151
	br_if   	4, $pop45       # 4: down to label0
# BB#29:                                # %for.inc87.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push154=, 3
	i32.add 	$push46=, $4, $pop154
	i32.load8_u	$push47=, 0($pop46)
	i32.const	$push153=, 97
	i32.ne  	$push48=, $pop47, $pop153
	br_if   	4, $pop48       # 4: down to label0
# BB#30:                                # %for.inc87.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push156=, 4
	i32.add 	$push49=, $4, $pop156
	i32.load8_u	$push50=, 0($pop49)
	i32.const	$push155=, 97
	i32.ne  	$push51=, $pop50, $pop155
	br_if   	4, $pop51       # 4: down to label0
# BB#31:                                # %for.inc87.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push158=, 5
	i32.add 	$push52=, $4, $pop158
	i32.load8_u	$push53=, 0($pop52)
	i32.const	$push157=, 97
	i32.ne  	$push54=, $pop53, $pop157
	br_if   	4, $pop54       # 4: down to label0
# BB#32:                                # %for.inc87.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push160=, 6
	i32.add 	$push55=, $4, $pop160
	i32.load8_u	$push56=, 0($pop55)
	i32.const	$push159=, 97
	i32.ne  	$push57=, $pop56, $pop159
	br_if   	4, $pop57       # 4: down to label0
# BB#33:                                # %for.inc87.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push162=, 7
	i32.add 	$push58=, $4, $pop162
	i32.load8_u	$push59=, 0($pop58)
	i32.const	$push161=, 97
	i32.ne  	$push60=, $pop59, $pop161
	br_if   	4, $pop60       # 4: down to label0
# BB#34:                                # %for.inc87.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push163=, 66
	i32.call	$discard=, memset@FUNCTION, $3, $pop163, $2
	i32.const	$6=, u
	block
	br_if   	0, $5           # 0: down to label15
# BB#35:                                # %for.body100.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$4=, 0
.LBB0_36:                               # %for.body100
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label16:
	copy_local	$push126=, $4
	tee_local	$push125=, $6=, $pop126
	i32.load8_u	$push61=, u($pop125)
	i32.const	$push124=, 97
	i32.ne  	$push62=, $pop61, $pop124
	br_if   	7, $pop62       # 7: down to label0
# BB#37:                                # %for.inc106
                                        #   in Loop: Header=BB0_36 Depth=3
	i32.const	$push127=, 1
	i32.add 	$4=, $6, $pop127
	i32.lt_s	$push63=, $4, $0
	br_if   	0, $pop63       # 0: up to label16
# BB#38:                                #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label17:
	i32.const	$push128=, u+1
	i32.add 	$6=, $6, $pop128
.LBB0_39:                               # %for.body113.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label15:
	i32.const	$4=, 0
.LBB0_40:                               # %for.body113
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label18:
	i32.add 	$push64=, $6, $4
	i32.load8_u	$push65=, 0($pop64)
	i32.const	$push129=, 66
	i32.ne  	$push66=, $pop65, $pop129
	br_if   	6, $pop66       # 6: down to label0
# BB#41:                                # %for.inc119
                                        #   in Loop: Header=BB0_40 Depth=3
	i32.const	$push130=, 1
	i32.add 	$4=, $4, $pop130
	i32.lt_s	$push67=, $4, $2
	br_if   	0, $pop67       # 0: up to label18
# BB#42:                                # %for.body126.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label19:
	i32.add 	$push133=, $6, $4
	tee_local	$push132=, $4=, $pop133
	i32.load8_u	$push68=, 0($pop132)
	i32.const	$push131=, 97
	i32.ne  	$push69=, $pop68, $pop131
	br_if   	4, $pop69       # 4: down to label0
# BB#43:                                # %for.inc132
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push135=, 1
	i32.add 	$push70=, $4, $pop135
	i32.load8_u	$push71=, 0($pop70)
	i32.const	$push134=, 97
	i32.ne  	$push72=, $pop71, $pop134
	br_if   	4, $pop72       # 4: down to label0
# BB#44:                                # %for.inc132.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push165=, 2
	i32.add 	$push73=, $4, $pop165
	i32.load8_u	$push74=, 0($pop73)
	i32.const	$push164=, 97
	i32.ne  	$push75=, $pop74, $pop164
	br_if   	4, $pop75       # 4: down to label0
# BB#45:                                # %for.inc132.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push167=, 3
	i32.add 	$push76=, $4, $pop167
	i32.load8_u	$push77=, 0($pop76)
	i32.const	$push166=, 97
	i32.ne  	$push78=, $pop77, $pop166
	br_if   	4, $pop78       # 4: down to label0
# BB#46:                                # %for.inc132.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push169=, 4
	i32.add 	$push79=, $4, $pop169
	i32.load8_u	$push80=, 0($pop79)
	i32.const	$push168=, 97
	i32.ne  	$push81=, $pop80, $pop168
	br_if   	4, $pop81       # 4: down to label0
# BB#47:                                # %for.inc132.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push171=, 5
	i32.add 	$push82=, $4, $pop171
	i32.load8_u	$push83=, 0($pop82)
	i32.const	$push170=, 97
	i32.ne  	$push84=, $pop83, $pop170
	br_if   	4, $pop84       # 4: down to label0
# BB#48:                                # %for.inc132.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push173=, 6
	i32.add 	$push85=, $4, $pop173
	i32.load8_u	$push86=, 0($pop85)
	i32.const	$push172=, 97
	i32.ne  	$push87=, $pop86, $pop172
	br_if   	4, $pop87       # 4: down to label0
# BB#49:                                # %for.inc132.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push175=, 7
	i32.add 	$push88=, $4, $pop175
	i32.load8_u	$push89=, 0($pop88)
	i32.const	$push174=, 97
	i32.ne  	$push90=, $pop89, $pop174
	br_if   	4, $pop90       # 4: down to label0
# BB#50:                                # %for.inc132.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push177=, 1
	i32.add 	$2=, $2, $pop177
	i32.const	$push176=, 80
	i32.lt_u	$push91=, $2, $pop176
	br_if   	0, $pop91       # 0: up to label3
# BB#51:                                # %for.inc139
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label4:
	i32.const	$push137=, 1
	i32.add 	$0=, $0, $pop137
	i32.const	$push136=, 8
	i32.lt_u	$push92=, $0, $pop136
	br_if   	0, $pop92       # 0: up to label1
# BB#52:                                # %for.end141
	end_loop                        # label2:
	i32.const	$push93=, 0
	call    	exit@FUNCTION, $pop93
	unreachable
.LBB0_53:                               # %if.then130
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
