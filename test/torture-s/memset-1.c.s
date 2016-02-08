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
                                        #       Child Loop BB0_3 Depth 3
                                        #       Child Loop BB0_7 Depth 3
                                        #       Child Loop BB0_18 Depth 3
                                        #       Child Loop BB0_22 Depth 3
                                        #       Child Loop BB0_33 Depth 3
                                        #       Child Loop BB0_37 Depth 3
	block
	block
	block
	block
	block
	block
	loop                            # label6:
	i32.const	$push100=, u
	i32.add 	$1=, $0, $pop100
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
	loop                            # label8:
	i32.const	$push3=, u
	i32.const	$push104=, 97
	i32.const	$push103=, 96
	i32.call	$5=, memset@FUNCTION, $pop3, $pop104, $pop103
	i32.const	$6=, 0
	i32.const	$push102=, 0
	i32.call	$4=, memset@FUNCTION, $1, $pop102, $2
	block
	i32.const	$push101=, 1
	i32.lt_s	$push4=, $0, $pop101
	br_if   	0, $pop4        # 0: down to label10
.LBB0_3:                                # %for.body11
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label11:
	i32.load8_u	$push5=, u($6)
	i32.const	$push105=, 97
	i32.ne  	$push6=, $pop5, $pop105
	br_if   	1, $pop6        # 1: down to label12
# BB#4:                                 # %for.inc16
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push107=, u+1
	i32.add 	$5=, $6, $pop107
	i32.const	$push106=, 1
	i32.add 	$3=, $6, $pop106
	copy_local	$6=, $3
	i32.lt_s	$push7=, $3, $0
	br_if   	0, $pop7        # 0: up to label11
	br      	2               # 2: down to label10
.LBB0_5:                                # %if.then14
	end_loop                        # label12:
	call    	abort@FUNCTION
	unreachable
.LBB0_6:                                # %for.body22.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label10:
	i32.const	$6=, 0
.LBB0_7:                                # %for.body22
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label13:
	i32.add 	$push8=, $5, $6
	i32.load8_u	$push9=, 0($pop8)
	br_if   	11, $pop9       # 11: down to label0
# BB#8:                                 # %for.inc28
                                        #   in Loop: Header=BB0_7 Depth=3
	i32.const	$push108=, 1
	i32.add 	$6=, $6, $pop108
	i32.lt_s	$push10=, $6, $2
	br_if   	0, $pop10       # 0: up to label13
# BB#9:                                 # %for.body35.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label14:
	i32.add 	$push0=, $5, $6
	tee_local	$push110=, $6=, $pop0
	i32.load8_u	$push11=, 0($pop110)
	i32.const	$push109=, 97
	i32.ne  	$push12=, $pop11, $pop109
	br_if   	8, $pop12       # 8: down to label1
# BB#10:                                # %for.inc41
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push112=, 1
	i32.add 	$push13=, $6, $pop112
	i32.load8_u	$push14=, 0($pop13)
	i32.const	$push111=, 97
	i32.ne  	$push15=, $pop14, $pop111
	br_if   	8, $pop15       # 8: down to label1
# BB#11:                                # %for.inc41.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push134=, 2
	i32.add 	$push16=, $6, $pop134
	i32.load8_u	$push17=, 0($pop16)
	i32.const	$push133=, 97
	i32.ne  	$push18=, $pop17, $pop133
	br_if   	8, $pop18       # 8: down to label1
# BB#12:                                # %for.inc41.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push136=, 3
	i32.add 	$push19=, $6, $pop136
	i32.load8_u	$push20=, 0($pop19)
	i32.const	$push135=, 97
	i32.ne  	$push21=, $pop20, $pop135
	br_if   	8, $pop21       # 8: down to label1
# BB#13:                                # %for.inc41.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push138=, 4
	i32.add 	$push22=, $6, $pop138
	i32.load8_u	$push23=, 0($pop22)
	i32.const	$push137=, 97
	i32.ne  	$push24=, $pop23, $pop137
	br_if   	8, $pop24       # 8: down to label1
# BB#14:                                # %for.inc41.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push140=, 5
	i32.add 	$push25=, $6, $pop140
	i32.load8_u	$push26=, 0($pop25)
	i32.const	$push139=, 97
	i32.ne  	$push27=, $pop26, $pop139
	br_if   	8, $pop27       # 8: down to label1
# BB#15:                                # %for.inc41.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push142=, 6
	i32.add 	$push28=, $6, $pop142
	i32.load8_u	$push29=, 0($pop28)
	i32.const	$push141=, 97
	i32.ne  	$push30=, $pop29, $pop141
	br_if   	8, $pop30       # 8: down to label1
# BB#16:                                # %for.inc41.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push144=, 7
	i32.add 	$push31=, $6, $pop144
	i32.load8_u	$push32=, 0($pop31)
	i32.const	$push143=, 97
	i32.ne  	$push33=, $pop32, $pop143
	br_if   	8, $pop33       # 8: down to label1
# BB#17:                                # %for.inc41.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$6=, 0
	i32.const	$push146=, 0
	i32.load8_u	$push35=, A($pop146)
	i32.call	$discard=, memset@FUNCTION, $4, $pop35, $2
	i32.const	$5=, u
	block
	i32.const	$push145=, 0
	i32.le_s	$push34=, $0, $pop145
	br_if   	0, $pop34       # 0: down to label15
.LBB0_18:                               # %for.body55
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label16:
	i32.load8_u	$push36=, u($6)
	i32.const	$push113=, 97
	i32.ne  	$push37=, $pop36, $pop113
	br_if   	1, $pop37       # 1: down to label17
# BB#19:                                # %for.inc61
                                        #   in Loop: Header=BB0_18 Depth=3
	i32.const	$push115=, u+1
	i32.add 	$5=, $6, $pop115
	i32.const	$push114=, 1
	i32.add 	$3=, $6, $pop114
	copy_local	$6=, $3
	i32.lt_s	$push38=, $3, $0
	br_if   	0, $pop38       # 0: up to label16
	br      	2               # 2: down to label15
.LBB0_20:                               # %if.then59
	end_loop                        # label17:
	call    	abort@FUNCTION
	unreachable
.LBB0_21:                               # %for.body68.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label15:
	i32.const	$6=, 0
.LBB0_22:                               # %for.body68
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label18:
	i32.add 	$push39=, $5, $6
	i32.load8_u	$push40=, 0($pop39)
	i32.const	$push116=, 65
	i32.ne  	$push41=, $pop40, $pop116
	br_if   	9, $pop41       # 9: down to label2
# BB#23:                                # %for.inc74
                                        #   in Loop: Header=BB0_22 Depth=3
	i32.const	$push117=, 1
	i32.add 	$6=, $6, $pop117
	i32.lt_s	$push42=, $6, $2
	br_if   	0, $pop42       # 0: up to label18
# BB#24:                                # %for.body81.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label19:
	i32.add 	$push1=, $5, $6
	tee_local	$push119=, $6=, $pop1
	i32.load8_u	$push43=, 0($pop119)
	i32.const	$push118=, 97
	i32.ne  	$push44=, $pop43, $pop118
	br_if   	6, $pop44       # 6: down to label3
# BB#25:                                # %for.inc87
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push121=, 1
	i32.add 	$push45=, $6, $pop121
	i32.load8_u	$push46=, 0($pop45)
	i32.const	$push120=, 97
	i32.ne  	$push47=, $pop46, $pop120
	br_if   	6, $pop47       # 6: down to label3
# BB#26:                                # %for.inc87.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push148=, 2
	i32.add 	$push48=, $6, $pop148
	i32.load8_u	$push49=, 0($pop48)
	i32.const	$push147=, 97
	i32.ne  	$push50=, $pop49, $pop147
	br_if   	6, $pop50       # 6: down to label3
# BB#27:                                # %for.inc87.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push150=, 3
	i32.add 	$push51=, $6, $pop150
	i32.load8_u	$push52=, 0($pop51)
	i32.const	$push149=, 97
	i32.ne  	$push53=, $pop52, $pop149
	br_if   	6, $pop53       # 6: down to label3
# BB#28:                                # %for.inc87.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push152=, 4
	i32.add 	$push54=, $6, $pop152
	i32.load8_u	$push55=, 0($pop54)
	i32.const	$push151=, 97
	i32.ne  	$push56=, $pop55, $pop151
	br_if   	6, $pop56       # 6: down to label3
# BB#29:                                # %for.inc87.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push154=, 5
	i32.add 	$push57=, $6, $pop154
	i32.load8_u	$push58=, 0($pop57)
	i32.const	$push153=, 97
	i32.ne  	$push59=, $pop58, $pop153
	br_if   	6, $pop59       # 6: down to label3
# BB#30:                                # %for.inc87.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push156=, 6
	i32.add 	$push60=, $6, $pop156
	i32.load8_u	$push61=, 0($pop60)
	i32.const	$push155=, 97
	i32.ne  	$push62=, $pop61, $pop155
	br_if   	6, $pop62       # 6: down to label3
# BB#31:                                # %for.inc87.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push158=, 7
	i32.add 	$push63=, $6, $pop158
	i32.load8_u	$push64=, 0($pop63)
	i32.const	$push157=, 97
	i32.ne  	$push65=, $pop64, $pop157
	br_if   	6, $pop65       # 6: down to label3
# BB#32:                                # %for.inc87.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$6=, 0
	i32.const	$push160=, 66
	i32.call	$discard=, memset@FUNCTION, $4, $pop160, $2
	i32.const	$5=, u
	block
	i32.const	$push159=, 0
	i32.le_s	$push66=, $0, $pop159
	br_if   	0, $pop66       # 0: down to label20
.LBB0_33:                               # %for.body100
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label21:
	i32.load8_u	$push67=, u($6)
	i32.const	$push122=, 97
	i32.ne  	$push68=, $pop67, $pop122
	br_if   	1, $pop68       # 1: down to label22
# BB#34:                                # %for.inc106
                                        #   in Loop: Header=BB0_33 Depth=3
	i32.const	$push124=, u+1
	i32.add 	$5=, $6, $pop124
	i32.const	$push123=, 1
	i32.add 	$3=, $6, $pop123
	copy_local	$6=, $3
	i32.lt_s	$push69=, $3, $0
	br_if   	0, $pop69       # 0: up to label21
	br      	2               # 2: down to label20
.LBB0_35:                               # %if.then104
	end_loop                        # label22:
	call    	abort@FUNCTION
	unreachable
.LBB0_36:                               # %for.body113.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label20:
	i32.const	$6=, 0
.LBB0_37:                               # %for.body113
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label23:
	i32.add 	$push70=, $5, $6
	i32.load8_u	$push71=, 0($pop70)
	i32.const	$push125=, 66
	i32.ne  	$push72=, $pop71, $pop125
	br_if   	7, $pop72       # 7: down to label4
# BB#38:                                # %for.inc119
                                        #   in Loop: Header=BB0_37 Depth=3
	i32.const	$push126=, 1
	i32.add 	$6=, $6, $pop126
	i32.lt_s	$push73=, $6, $2
	br_if   	0, $pop73       # 0: up to label23
# BB#39:                                # %for.body126.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label24:
	i32.add 	$push2=, $5, $6
	tee_local	$push128=, $6=, $pop2
	i32.load8_u	$push74=, 0($pop128)
	i32.const	$push127=, 97
	i32.ne  	$push75=, $pop74, $pop127
	br_if   	4, $pop75       # 4: down to label5
# BB#40:                                # %for.inc132
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push130=, 1
	i32.add 	$push76=, $6, $pop130
	i32.load8_u	$push77=, 0($pop76)
	i32.const	$push129=, 97
	i32.ne  	$push78=, $pop77, $pop129
	br_if   	4, $pop78       # 4: down to label5
# BB#41:                                # %for.inc132.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push162=, 2
	i32.add 	$push79=, $6, $pop162
	i32.load8_u	$push80=, 0($pop79)
	i32.const	$push161=, 97
	i32.ne  	$push81=, $pop80, $pop161
	br_if   	4, $pop81       # 4: down to label5
# BB#42:                                # %for.inc132.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push164=, 3
	i32.add 	$push82=, $6, $pop164
	i32.load8_u	$push83=, 0($pop82)
	i32.const	$push163=, 97
	i32.ne  	$push84=, $pop83, $pop163
	br_if   	4, $pop84       # 4: down to label5
# BB#43:                                # %for.inc132.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push166=, 4
	i32.add 	$push85=, $6, $pop166
	i32.load8_u	$push86=, 0($pop85)
	i32.const	$push165=, 97
	i32.ne  	$push87=, $pop86, $pop165
	br_if   	4, $pop87       # 4: down to label5
# BB#44:                                # %for.inc132.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push168=, 5
	i32.add 	$push88=, $6, $pop168
	i32.load8_u	$push89=, 0($pop88)
	i32.const	$push167=, 97
	i32.ne  	$push90=, $pop89, $pop167
	br_if   	4, $pop90       # 4: down to label5
# BB#45:                                # %for.inc132.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push170=, 6
	i32.add 	$push91=, $6, $pop170
	i32.load8_u	$push92=, 0($pop91)
	i32.const	$push169=, 97
	i32.ne  	$push93=, $pop92, $pop169
	br_if   	4, $pop93       # 4: down to label5
# BB#46:                                # %for.inc132.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push172=, 7
	i32.add 	$push94=, $6, $pop172
	i32.load8_u	$push95=, 0($pop94)
	i32.const	$push171=, 97
	i32.ne  	$push96=, $pop95, $pop171
	br_if   	4, $pop96       # 4: down to label5
# BB#47:                                # %for.inc132.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push174=, 1
	i32.add 	$2=, $2, $pop174
	i32.const	$push173=, 80
	i32.lt_u	$push97=, $2, $pop173
	br_if   	0, $pop97       # 0: up to label8
# BB#48:                                # %for.inc139
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label9:
	i32.const	$push132=, 1
	i32.add 	$0=, $0, $pop132
	i32.const	$push131=, 8
	i32.lt_u	$push98=, $0, $pop131
	br_if   	0, $pop98       # 0: up to label6
# BB#49:                                # %for.end141
	end_loop                        # label7:
	i32.const	$push99=, 0
	call    	exit@FUNCTION, $pop99
	unreachable
.LBB0_50:                               # %if.then130
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_51:                               # %if.then117
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_52:                               # %if.then85
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_53:                               # %if.then72
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_54:                               # %if.then39
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_55:                               # %if.then26
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
