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
                                        #       Child Loop BB0_6 Depth 3
                                        #       Child Loop BB0_17 Depth 3
                                        #       Child Loop BB0_20 Depth 3
                                        #       Child Loop BB0_31 Depth 3
                                        #       Child Loop BB0_34 Depth 3
	block
	block
	block
	block
	block
	block
	block
	block
	block
	loop                            # label9:
	i32.const	$push97=, u
	i32.add 	$1=, $0, $pop97
	i32.const	$2=, 1
.LBB0_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
                                        #       Child Loop BB0_6 Depth 3
                                        #       Child Loop BB0_17 Depth 3
                                        #       Child Loop BB0_20 Depth 3
                                        #       Child Loop BB0_31 Depth 3
                                        #       Child Loop BB0_34 Depth 3
	loop                            # label11:
	i32.const	$push0=, u
	i32.const	$push101=, 97
	i32.const	$push100=, 96
	i32.call	$5=, memset@FUNCTION, $pop0, $pop101, $pop100
	i32.const	$6=, 0
	i32.const	$push99=, 0
	i32.call	$4=, memset@FUNCTION, $1, $pop99, $2
	block
	i32.const	$push98=, 1
	i32.lt_s	$push1=, $0, $pop98
	br_if   	0, $pop1        # 0: down to label13
.LBB0_3:                                # %for.body11
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label14:
	i32.load8_u	$push2=, u($6)
	i32.const	$push102=, 97
	i32.ne  	$push3=, $pop2, $pop102
	br_if   	10, $pop3       # 10: down to label5
# BB#4:                                 # %for.inc16
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push104=, u+1
	i32.add 	$5=, $6, $pop104
	i32.const	$push103=, 1
	i32.add 	$3=, $6, $pop103
	copy_local	$6=, $3
	i32.lt_s	$push4=, $3, $0
	br_if   	0, $pop4        # 0: up to label14
.LBB0_5:                                # %for.body22.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label15:
	end_block                       # label13:
	i32.const	$6=, 0
.LBB0_6:                                # %for.body22
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label16:
	i32.add 	$push5=, $5, $6
	i32.load8_u	$push6=, 0($pop5)
	br_if   	6, $pop6        # 6: down to label8
# BB#7:                                 # %for.inc28
                                        #   in Loop: Header=BB0_6 Depth=3
	i32.const	$push105=, 1
	i32.add 	$6=, $6, $pop105
	i32.lt_s	$push7=, $6, $2
	br_if   	0, $pop7        # 0: up to label16
# BB#8:                                 # %for.body35.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label17:
	i32.add 	$push108=, $5, $6
	tee_local	$push107=, $6=, $pop108
	i32.load8_u	$push8=, 0($pop107)
	i32.const	$push106=, 97
	i32.ne  	$push9=, $pop8, $pop106
	br_if   	10, $pop9       # 10: down to label2
# BB#9:                                 # %for.inc41
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push110=, 1
	i32.add 	$push10=, $6, $pop110
	i32.load8_u	$push11=, 0($pop10)
	i32.const	$push109=, 97
	i32.ne  	$push12=, $pop11, $pop109
	br_if   	10, $pop12      # 10: down to label2
# BB#10:                                # %for.inc41.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push134=, 2
	i32.add 	$push13=, $6, $pop134
	i32.load8_u	$push14=, 0($pop13)
	i32.const	$push133=, 97
	i32.ne  	$push15=, $pop14, $pop133
	br_if   	10, $pop15      # 10: down to label2
# BB#11:                                # %for.inc41.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push136=, 3
	i32.add 	$push16=, $6, $pop136
	i32.load8_u	$push17=, 0($pop16)
	i32.const	$push135=, 97
	i32.ne  	$push18=, $pop17, $pop135
	br_if   	10, $pop18      # 10: down to label2
# BB#12:                                # %for.inc41.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push138=, 4
	i32.add 	$push19=, $6, $pop138
	i32.load8_u	$push20=, 0($pop19)
	i32.const	$push137=, 97
	i32.ne  	$push21=, $pop20, $pop137
	br_if   	10, $pop21      # 10: down to label2
# BB#13:                                # %for.inc41.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push140=, 5
	i32.add 	$push22=, $6, $pop140
	i32.load8_u	$push23=, 0($pop22)
	i32.const	$push139=, 97
	i32.ne  	$push24=, $pop23, $pop139
	br_if   	10, $pop24      # 10: down to label2
# BB#14:                                # %for.inc41.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push142=, 6
	i32.add 	$push25=, $6, $pop142
	i32.load8_u	$push26=, 0($pop25)
	i32.const	$push141=, 97
	i32.ne  	$push27=, $pop26, $pop141
	br_if   	10, $pop27      # 10: down to label2
# BB#15:                                # %for.inc41.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push144=, 7
	i32.add 	$push28=, $6, $pop144
	i32.load8_u	$push29=, 0($pop28)
	i32.const	$push143=, 97
	i32.ne  	$push30=, $pop29, $pop143
	br_if   	10, $pop30      # 10: down to label2
# BB#16:                                # %for.inc41.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$6=, 0
	i32.const	$push146=, 0
	i32.load8_u	$push32=, A($pop146)
	i32.call	$discard=, memset@FUNCTION, $4, $pop32, $2
	i32.const	$5=, u
	block
	i32.const	$push145=, 0
	i32.le_s	$push31=, $0, $pop145
	br_if   	0, $pop31       # 0: down to label18
.LBB0_17:                               # %for.body55
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label19:
	i32.load8_u	$push33=, u($6)
	i32.const	$push111=, 97
	i32.ne  	$push34=, $pop33, $pop111
	br_if   	11, $pop34      # 11: down to label4
# BB#18:                                # %for.inc61
                                        #   in Loop: Header=BB0_17 Depth=3
	i32.const	$push113=, u+1
	i32.add 	$5=, $6, $pop113
	i32.const	$push112=, 1
	i32.add 	$3=, $6, $pop112
	copy_local	$6=, $3
	i32.lt_s	$push35=, $3, $0
	br_if   	0, $pop35       # 0: up to label19
.LBB0_19:                               # %for.body68.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label20:
	end_block                       # label18:
	i32.const	$6=, 0
.LBB0_20:                               # %for.body68
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label21:
	i32.add 	$push36=, $5, $6
	i32.load8_u	$push37=, 0($pop36)
	i32.const	$push114=, 65
	i32.ne  	$push38=, $pop37, $pop114
	br_if   	7, $pop38       # 7: down to label7
# BB#21:                                # %for.inc74
                                        #   in Loop: Header=BB0_20 Depth=3
	i32.const	$push115=, 1
	i32.add 	$6=, $6, $pop115
	i32.lt_s	$push39=, $6, $2
	br_if   	0, $pop39       # 0: up to label21
# BB#22:                                # %for.body81.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label22:
	i32.add 	$push118=, $5, $6
	tee_local	$push117=, $6=, $pop118
	i32.load8_u	$push40=, 0($pop117)
	i32.const	$push116=, 97
	i32.ne  	$push41=, $pop40, $pop116
	br_if   	11, $pop41      # 11: down to label1
# BB#23:                                # %for.inc87
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push120=, 1
	i32.add 	$push42=, $6, $pop120
	i32.load8_u	$push43=, 0($pop42)
	i32.const	$push119=, 97
	i32.ne  	$push44=, $pop43, $pop119
	br_if   	11, $pop44      # 11: down to label1
# BB#24:                                # %for.inc87.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push148=, 2
	i32.add 	$push45=, $6, $pop148
	i32.load8_u	$push46=, 0($pop45)
	i32.const	$push147=, 97
	i32.ne  	$push47=, $pop46, $pop147
	br_if   	11, $pop47      # 11: down to label1
# BB#25:                                # %for.inc87.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push150=, 3
	i32.add 	$push48=, $6, $pop150
	i32.load8_u	$push49=, 0($pop48)
	i32.const	$push149=, 97
	i32.ne  	$push50=, $pop49, $pop149
	br_if   	11, $pop50      # 11: down to label1
# BB#26:                                # %for.inc87.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push152=, 4
	i32.add 	$push51=, $6, $pop152
	i32.load8_u	$push52=, 0($pop51)
	i32.const	$push151=, 97
	i32.ne  	$push53=, $pop52, $pop151
	br_if   	11, $pop53      # 11: down to label1
# BB#27:                                # %for.inc87.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push154=, 5
	i32.add 	$push54=, $6, $pop154
	i32.load8_u	$push55=, 0($pop54)
	i32.const	$push153=, 97
	i32.ne  	$push56=, $pop55, $pop153
	br_if   	11, $pop56      # 11: down to label1
# BB#28:                                # %for.inc87.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push156=, 6
	i32.add 	$push57=, $6, $pop156
	i32.load8_u	$push58=, 0($pop57)
	i32.const	$push155=, 97
	i32.ne  	$push59=, $pop58, $pop155
	br_if   	11, $pop59      # 11: down to label1
# BB#29:                                # %for.inc87.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push158=, 7
	i32.add 	$push60=, $6, $pop158
	i32.load8_u	$push61=, 0($pop60)
	i32.const	$push157=, 97
	i32.ne  	$push62=, $pop61, $pop157
	br_if   	11, $pop62      # 11: down to label1
# BB#30:                                # %for.inc87.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$6=, 0
	i32.const	$push160=, 66
	i32.call	$discard=, memset@FUNCTION, $4, $pop160, $2
	i32.const	$5=, u
	block
	i32.const	$push159=, 0
	i32.le_s	$push63=, $0, $pop159
	br_if   	0, $pop63       # 0: down to label23
.LBB0_31:                               # %for.body100
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label24:
	i32.load8_u	$push64=, u($6)
	i32.const	$push121=, 97
	i32.ne  	$push65=, $pop64, $pop121
	br_if   	12, $pop65      # 12: down to label3
# BB#32:                                # %for.inc106
                                        #   in Loop: Header=BB0_31 Depth=3
	i32.const	$push123=, u+1
	i32.add 	$5=, $6, $pop123
	i32.const	$push122=, 1
	i32.add 	$3=, $6, $pop122
	copy_local	$6=, $3
	i32.lt_s	$push66=, $3, $0
	br_if   	0, $pop66       # 0: up to label24
.LBB0_33:                               # %for.body113.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label25:
	end_block                       # label23:
	i32.const	$6=, 0
.LBB0_34:                               # %for.body113
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label26:
	i32.add 	$push67=, $5, $6
	i32.load8_u	$push68=, 0($pop67)
	i32.const	$push124=, 66
	i32.ne  	$push69=, $pop68, $pop124
	br_if   	8, $pop69       # 8: down to label6
# BB#35:                                # %for.inc119
                                        #   in Loop: Header=BB0_34 Depth=3
	i32.const	$push125=, 1
	i32.add 	$6=, $6, $pop125
	i32.lt_s	$push70=, $6, $2
	br_if   	0, $pop70       # 0: up to label26
# BB#36:                                # %for.body126.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label27:
	i32.add 	$push128=, $5, $6
	tee_local	$push127=, $6=, $pop128
	i32.load8_u	$push71=, 0($pop127)
	i32.const	$push126=, 97
	i32.ne  	$push72=, $pop71, $pop126
	br_if   	12, $pop72      # 12: down to label0
# BB#37:                                # %for.inc132
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push130=, 1
	i32.add 	$push73=, $6, $pop130
	i32.load8_u	$push74=, 0($pop73)
	i32.const	$push129=, 97
	i32.ne  	$push75=, $pop74, $pop129
	br_if   	12, $pop75      # 12: down to label0
# BB#38:                                # %for.inc132.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push162=, 2
	i32.add 	$push76=, $6, $pop162
	i32.load8_u	$push77=, 0($pop76)
	i32.const	$push161=, 97
	i32.ne  	$push78=, $pop77, $pop161
	br_if   	12, $pop78      # 12: down to label0
# BB#39:                                # %for.inc132.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push164=, 3
	i32.add 	$push79=, $6, $pop164
	i32.load8_u	$push80=, 0($pop79)
	i32.const	$push163=, 97
	i32.ne  	$push81=, $pop80, $pop163
	br_if   	12, $pop81      # 12: down to label0
# BB#40:                                # %for.inc132.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push166=, 4
	i32.add 	$push82=, $6, $pop166
	i32.load8_u	$push83=, 0($pop82)
	i32.const	$push165=, 97
	i32.ne  	$push84=, $pop83, $pop165
	br_if   	12, $pop84      # 12: down to label0
# BB#41:                                # %for.inc132.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push168=, 5
	i32.add 	$push85=, $6, $pop168
	i32.load8_u	$push86=, 0($pop85)
	i32.const	$push167=, 97
	i32.ne  	$push87=, $pop86, $pop167
	br_if   	12, $pop87      # 12: down to label0
# BB#42:                                # %for.inc132.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push170=, 6
	i32.add 	$push88=, $6, $pop170
	i32.load8_u	$push89=, 0($pop88)
	i32.const	$push169=, 97
	i32.ne  	$push90=, $pop89, $pop169
	br_if   	12, $pop90      # 12: down to label0
# BB#43:                                # %for.inc132.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push172=, 7
	i32.add 	$push91=, $6, $pop172
	i32.load8_u	$push92=, 0($pop91)
	i32.const	$push171=, 97
	i32.ne  	$push93=, $pop92, $pop171
	br_if   	12, $pop93      # 12: down to label0
# BB#44:                                # %for.inc132.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push174=, 1
	i32.add 	$2=, $2, $pop174
	i32.const	$push173=, 80
	i32.lt_u	$push94=, $2, $pop173
	br_if   	0, $pop94       # 0: up to label11
# BB#45:                                # %for.inc139
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label12:
	i32.const	$push132=, 1
	i32.add 	$0=, $0, $pop132
	i32.const	$push131=, 8
	i32.lt_u	$push95=, $0, $pop131
	br_if   	0, $pop95       # 0: up to label9
# BB#46:                                # %for.end141
	end_loop                        # label10:
	i32.const	$push96=, 0
	call    	exit@FUNCTION, $pop96
	unreachable
.LBB0_47:                               # %if.then26
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB0_48:                               # %if.then72
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB0_49:                               # %if.then117
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_50:                               # %if.then14
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_51:                               # %if.then59
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_52:                               # %if.then104
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_53:                               # %if.then39
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_54:                               # %if.then85
	end_block                       # label1:
	call    	abort@FUNCTION
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
	.lcomm	u,96,4

	.ident	"clang version 3.9.0 "
