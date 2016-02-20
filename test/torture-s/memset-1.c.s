	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memset-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
.LBB0_1:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
                                        #       Child Loop BB0_3 Depth 3
                                        #       Child Loop BB0_7 Depth 3
                                        #       Child Loop BB0_18 Depth 3
                                        #       Child Loop BB0_22 Depth 3
                                        #       Child Loop BB0_33 Depth 3
                                        #       Child Loop BB0_37 Depth 3
	block
	loop                            # label1:
	i32.const	$push97=, u
	i32.add 	$1=, $0, $pop97
	i32.const	$2=, 1
.LBB0_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
                                        #       Child Loop BB0_7 Depth 3
                                        #       Child Loop BB0_18 Depth 3
                                        #       Child Loop BB0_22 Depth 3
                                        #       Child Loop BB0_33 Depth 3
                                        #       Child Loop BB0_37 Depth 3
	loop                            # label3:
	i32.const	$push0=, u
	i32.const	$push101=, 97
	i32.const	$push100=, 96
	i32.call	$5=, memset@FUNCTION, $pop0, $pop101, $pop100
	i32.const	$4=, 0
	i32.const	$push99=, 0
	i32.call	$3=, memset@FUNCTION, $1, $pop99, $2
	block
	i32.const	$push98=, 1
	i32.lt_s	$push1=, $0, $pop98
	br_if   	0, $pop1        # 0: down to label5
.LBB0_3:                                # %for.body11
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label6:
	copy_local	$push104=, $4
	tee_local	$push103=, $5=, $pop104
	i32.load8_u	$push2=, u($pop103)
	i32.const	$push102=, 97
	i32.ne  	$push3=, $pop2, $pop102
	br_if   	7, $pop3        # 7: down to label0
# BB#4:                                 # %for.inc16
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push105=, 1
	i32.add 	$4=, $5, $pop105
	i32.lt_s	$push4=, $4, $0
	br_if   	0, $pop4        # 0: up to label6
# BB#5:                                 #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label7:
	i32.const	$push106=, u+1
	i32.add 	$5=, $5, $pop106
.LBB0_6:                                # %for.body22.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label5:
	i32.const	$4=, 0
.LBB0_7:                                # %for.body22
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label8:
	i32.add 	$push5=, $5, $4
	i32.load8_u	$push6=, 0($pop5)
	br_if   	6, $pop6        # 6: down to label0
# BB#8:                                 # %for.inc28
                                        #   in Loop: Header=BB0_7 Depth=3
	i32.const	$push107=, 1
	i32.add 	$4=, $4, $pop107
	i32.lt_s	$push7=, $4, $2
	br_if   	0, $pop7        # 0: up to label8
# BB#9:                                 # %for.body35.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label9:
	i32.add 	$push110=, $5, $4
	tee_local	$push109=, $4=, $pop110
	i32.load8_u	$push8=, 0($pop109)
	i32.const	$push108=, 97
	i32.ne  	$push9=, $pop8, $pop108
	br_if   	4, $pop9        # 4: down to label0
# BB#10:                                # %for.inc41
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push112=, 1
	i32.add 	$push10=, $4, $pop112
	i32.load8_u	$push11=, 0($pop10)
	i32.const	$push111=, 97
	i32.ne  	$push12=, $pop11, $pop111
	br_if   	4, $pop12       # 4: down to label0
# BB#11:                                # %for.inc41.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push140=, 2
	i32.add 	$push13=, $4, $pop140
	i32.load8_u	$push14=, 0($pop13)
	i32.const	$push139=, 97
	i32.ne  	$push15=, $pop14, $pop139
	br_if   	4, $pop15       # 4: down to label0
# BB#12:                                # %for.inc41.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push142=, 3
	i32.add 	$push16=, $4, $pop142
	i32.load8_u	$push17=, 0($pop16)
	i32.const	$push141=, 97
	i32.ne  	$push18=, $pop17, $pop141
	br_if   	4, $pop18       # 4: down to label0
# BB#13:                                # %for.inc41.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push144=, 4
	i32.add 	$push19=, $4, $pop144
	i32.load8_u	$push20=, 0($pop19)
	i32.const	$push143=, 97
	i32.ne  	$push21=, $pop20, $pop143
	br_if   	4, $pop21       # 4: down to label0
# BB#14:                                # %for.inc41.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push146=, 5
	i32.add 	$push22=, $4, $pop146
	i32.load8_u	$push23=, 0($pop22)
	i32.const	$push145=, 97
	i32.ne  	$push24=, $pop23, $pop145
	br_if   	4, $pop24       # 4: down to label0
# BB#15:                                # %for.inc41.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push148=, 6
	i32.add 	$push25=, $4, $pop148
	i32.load8_u	$push26=, 0($pop25)
	i32.const	$push147=, 97
	i32.ne  	$push27=, $pop26, $pop147
	br_if   	4, $pop27       # 4: down to label0
# BB#16:                                # %for.inc41.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push150=, 7
	i32.add 	$push28=, $4, $pop150
	i32.load8_u	$push29=, 0($pop28)
	i32.const	$push149=, 97
	i32.ne  	$push30=, $pop29, $pop149
	br_if   	4, $pop30       # 4: down to label0
# BB#17:                                # %for.inc41.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$4=, 0
	i32.const	$push152=, 0
	i32.load8_u	$push32=, A($pop152)
	i32.call	$discard=, memset@FUNCTION, $3, $pop32, $2
	i32.const	$5=, u
	block
	i32.const	$push151=, 0
	i32.le_s	$push31=, $0, $pop151
	br_if   	0, $pop31       # 0: down to label10
.LBB0_18:                               # %for.body55
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label11:
	copy_local	$push115=, $4
	tee_local	$push114=, $5=, $pop115
	i32.load8_u	$push33=, u($pop114)
	i32.const	$push113=, 97
	i32.ne  	$push34=, $pop33, $pop113
	br_if   	7, $pop34       # 7: down to label0
# BB#19:                                # %for.inc61
                                        #   in Loop: Header=BB0_18 Depth=3
	i32.const	$push116=, 1
	i32.add 	$4=, $5, $pop116
	i32.lt_s	$push35=, $4, $0
	br_if   	0, $pop35       # 0: up to label11
# BB#20:                                #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label12:
	i32.const	$push117=, u+1
	i32.add 	$5=, $5, $pop117
.LBB0_21:                               # %for.body68.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label10:
	i32.const	$4=, 0
.LBB0_22:                               # %for.body68
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label13:
	i32.add 	$push36=, $5, $4
	i32.load8_u	$push37=, 0($pop36)
	i32.const	$push118=, 65
	i32.ne  	$push38=, $pop37, $pop118
	br_if   	6, $pop38       # 6: down to label0
# BB#23:                                # %for.inc74
                                        #   in Loop: Header=BB0_22 Depth=3
	i32.const	$push119=, 1
	i32.add 	$4=, $4, $pop119
	i32.lt_s	$push39=, $4, $2
	br_if   	0, $pop39       # 0: up to label13
# BB#24:                                # %for.body81.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label14:
	i32.add 	$push122=, $5, $4
	tee_local	$push121=, $4=, $pop122
	i32.load8_u	$push40=, 0($pop121)
	i32.const	$push120=, 97
	i32.ne  	$push41=, $pop40, $pop120
	br_if   	4, $pop41       # 4: down to label0
# BB#25:                                # %for.inc87
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push124=, 1
	i32.add 	$push42=, $4, $pop124
	i32.load8_u	$push43=, 0($pop42)
	i32.const	$push123=, 97
	i32.ne  	$push44=, $pop43, $pop123
	br_if   	4, $pop44       # 4: down to label0
# BB#26:                                # %for.inc87.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push154=, 2
	i32.add 	$push45=, $4, $pop154
	i32.load8_u	$push46=, 0($pop45)
	i32.const	$push153=, 97
	i32.ne  	$push47=, $pop46, $pop153
	br_if   	4, $pop47       # 4: down to label0
# BB#27:                                # %for.inc87.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push156=, 3
	i32.add 	$push48=, $4, $pop156
	i32.load8_u	$push49=, 0($pop48)
	i32.const	$push155=, 97
	i32.ne  	$push50=, $pop49, $pop155
	br_if   	4, $pop50       # 4: down to label0
# BB#28:                                # %for.inc87.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push158=, 4
	i32.add 	$push51=, $4, $pop158
	i32.load8_u	$push52=, 0($pop51)
	i32.const	$push157=, 97
	i32.ne  	$push53=, $pop52, $pop157
	br_if   	4, $pop53       # 4: down to label0
# BB#29:                                # %for.inc87.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push160=, 5
	i32.add 	$push54=, $4, $pop160
	i32.load8_u	$push55=, 0($pop54)
	i32.const	$push159=, 97
	i32.ne  	$push56=, $pop55, $pop159
	br_if   	4, $pop56       # 4: down to label0
# BB#30:                                # %for.inc87.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push162=, 6
	i32.add 	$push57=, $4, $pop162
	i32.load8_u	$push58=, 0($pop57)
	i32.const	$push161=, 97
	i32.ne  	$push59=, $pop58, $pop161
	br_if   	4, $pop59       # 4: down to label0
# BB#31:                                # %for.inc87.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push164=, 7
	i32.add 	$push60=, $4, $pop164
	i32.load8_u	$push61=, 0($pop60)
	i32.const	$push163=, 97
	i32.ne  	$push62=, $pop61, $pop163
	br_if   	4, $pop62       # 4: down to label0
# BB#32:                                # %for.inc87.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$4=, 0
	i32.const	$push166=, 66
	i32.call	$discard=, memset@FUNCTION, $3, $pop166, $2
	i32.const	$5=, u
	block
	i32.const	$push165=, 0
	i32.le_s	$push63=, $0, $pop165
	br_if   	0, $pop63       # 0: down to label15
.LBB0_33:                               # %for.body100
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label16:
	copy_local	$push127=, $4
	tee_local	$push126=, $5=, $pop127
	i32.load8_u	$push64=, u($pop126)
	i32.const	$push125=, 97
	i32.ne  	$push65=, $pop64, $pop125
	br_if   	7, $pop65       # 7: down to label0
# BB#34:                                # %for.inc106
                                        #   in Loop: Header=BB0_33 Depth=3
	i32.const	$push128=, 1
	i32.add 	$4=, $5, $pop128
	i32.lt_s	$push66=, $4, $0
	br_if   	0, $pop66       # 0: up to label16
# BB#35:                                #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label17:
	i32.const	$push129=, u+1
	i32.add 	$5=, $5, $pop129
.LBB0_36:                               # %for.body113.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label15:
	i32.const	$4=, 0
.LBB0_37:                               # %for.body113
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label18:
	i32.add 	$push67=, $5, $4
	i32.load8_u	$push68=, 0($pop67)
	i32.const	$push130=, 66
	i32.ne  	$push69=, $pop68, $pop130
	br_if   	6, $pop69       # 6: down to label0
# BB#38:                                # %for.inc119
                                        #   in Loop: Header=BB0_37 Depth=3
	i32.const	$push131=, 1
	i32.add 	$4=, $4, $pop131
	i32.lt_s	$push70=, $4, $2
	br_if   	0, $pop70       # 0: up to label18
# BB#39:                                # %for.body126.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label19:
	i32.add 	$push134=, $5, $4
	tee_local	$push133=, $4=, $pop134
	i32.load8_u	$push71=, 0($pop133)
	i32.const	$push132=, 97
	i32.ne  	$push72=, $pop71, $pop132
	br_if   	4, $pop72       # 4: down to label0
# BB#40:                                # %for.inc132
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push136=, 1
	i32.add 	$push73=, $4, $pop136
	i32.load8_u	$push74=, 0($pop73)
	i32.const	$push135=, 97
	i32.ne  	$push75=, $pop74, $pop135
	br_if   	4, $pop75       # 4: down to label0
# BB#41:                                # %for.inc132.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push168=, 2
	i32.add 	$push76=, $4, $pop168
	i32.load8_u	$push77=, 0($pop76)
	i32.const	$push167=, 97
	i32.ne  	$push78=, $pop77, $pop167
	br_if   	4, $pop78       # 4: down to label0
# BB#42:                                # %for.inc132.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push170=, 3
	i32.add 	$push79=, $4, $pop170
	i32.load8_u	$push80=, 0($pop79)
	i32.const	$push169=, 97
	i32.ne  	$push81=, $pop80, $pop169
	br_if   	4, $pop81       # 4: down to label0
# BB#43:                                # %for.inc132.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push172=, 4
	i32.add 	$push82=, $4, $pop172
	i32.load8_u	$push83=, 0($pop82)
	i32.const	$push171=, 97
	i32.ne  	$push84=, $pop83, $pop171
	br_if   	4, $pop84       # 4: down to label0
# BB#44:                                # %for.inc132.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push174=, 5
	i32.add 	$push85=, $4, $pop174
	i32.load8_u	$push86=, 0($pop85)
	i32.const	$push173=, 97
	i32.ne  	$push87=, $pop86, $pop173
	br_if   	4, $pop87       # 4: down to label0
# BB#45:                                # %for.inc132.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push176=, 6
	i32.add 	$push88=, $4, $pop176
	i32.load8_u	$push89=, 0($pop88)
	i32.const	$push175=, 97
	i32.ne  	$push90=, $pop89, $pop175
	br_if   	4, $pop90       # 4: down to label0
# BB#46:                                # %for.inc132.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push178=, 7
	i32.add 	$push91=, $4, $pop178
	i32.load8_u	$push92=, 0($pop91)
	i32.const	$push177=, 97
	i32.ne  	$push93=, $pop92, $pop177
	br_if   	4, $pop93       # 4: down to label0
# BB#47:                                # %for.inc132.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push180=, 1
	i32.add 	$2=, $2, $pop180
	i32.const	$push179=, 80
	i32.lt_u	$push94=, $2, $pop179
	br_if   	0, $pop94       # 0: up to label3
# BB#48:                                # %for.inc139
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label4:
	i32.const	$push138=, 1
	i32.add 	$0=, $0, $pop138
	i32.const	$push137=, 8
	i32.lt_u	$push95=, $0, $pop137
	br_if   	0, $pop95       # 0: up to label1
# BB#49:                                # %for.end141
	end_loop                        # label2:
	i32.const	$push96=, 0
	call    	exit@FUNCTION, $pop96
	unreachable
.LBB0_50:                               # %if.then130
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
