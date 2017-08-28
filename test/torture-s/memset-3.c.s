	.text
	.file	"memset-3.c"
	.section	.text.reset,"ax",@progbits
	.hidden	reset                   # -- Begin function reset
	.globl	reset
	.type	reset,@function
reset:                                  # @reset
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i64.const	$push0=, 7016996765293437281
	i64.store	u+23($pop1):p2align=0, $pop0
	i32.const	$push7=, 0
	i64.const	$push6=, 7016996765293437281
	i64.store	u+16($pop7), $pop6
	i32.const	$push5=, 0
	i64.const	$push4=, 7016996765293437281
	i64.store	u+8($pop5), $pop4
	i32.const	$push3=, 0
	i64.const	$push2=, 7016996765293437281
	i64.store	u($pop3), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	reset, .Lfunc_end0-reset
                                        # -- End function
	.section	.text.check,"ax",@progbits
	.hidden	check                   # -- Begin function check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32, i32, i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	block   	
	block   	
	block   	
	i32.const	$push28=, 1
	i32.lt_s	$push0=, $0, $pop28
	br_if   	0, $pop0        # 0: down to label3
# BB#1:                                 # %for.body.preheader
	i32.const	$3=, 0
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label4:
	i32.const	$push30=, u
	i32.add 	$push1=, $3, $pop30
	i32.load8_u	$push2=, 0($pop1)
	i32.const	$push29=, 97
	i32.ne  	$push3=, $pop2, $pop29
	br_if   	4, $pop3        # 4: down to label0
# BB#3:                                 # %for.inc
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push33=, 1
	i32.add 	$push32=, $3, $pop33
	tee_local	$push31=, $3=, $pop32
	i32.lt_s	$push4=, $pop31, $0
	br_if   	0, $pop4        # 0: up to label4
# BB#4:                                 # %for.end.loopexit
	end_loop
	i32.const	$push5=, u
	i32.add 	$0=, $3, $pop5
	i32.const	$push34=, 1
	i32.ge_s	$push7=, $1, $pop34
	br_if   	1, $pop7        # 1: down to label2
	br      	2               # 2: down to label1
.LBB1_5:
	end_block                       # label3:
	i32.const	$0=, u
	i32.const	$push35=, 1
	i32.lt_s	$push6=, $1, $pop35
	br_if   	1, $pop6        # 1: down to label1
.LBB1_6:                                # %for.body6.preheader
	end_block                       # label2:
	i32.const	$3=, 0
.LBB1_7:                                # %for.body6
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label5:
	i32.add 	$push8=, $0, $3
	i32.load8_s	$push9=, 0($pop8)
	i32.ne  	$push10=, $pop9, $2
	br_if   	2, $pop10       # 2: down to label0
# BB#8:                                 # %for.inc12
                                        #   in Loop: Header=BB1_7 Depth=1
	i32.const	$push38=, 1
	i32.add 	$push37=, $3, $pop38
	tee_local	$push36=, $3=, $pop37
	i32.lt_s	$push11=, $pop36, $1
	br_if   	0, $pop11       # 0: up to label5
# BB#9:                                 # %for.end15.loopexit
	end_loop
	i32.add 	$0=, $0, $3
.LBB1_10:                               # %for.end15
	end_block                       # label1:
	i32.load8_u	$push12=, 0($0)
	i32.const	$push39=, 97
	i32.ne  	$push13=, $pop12, $pop39
	br_if   	0, $pop13       # 0: down to label0
# BB#11:                                # %for.inc25
	i32.load8_u	$push14=, 1($0)
	i32.const	$push40=, 97
	i32.ne  	$push15=, $pop14, $pop40
	br_if   	0, $pop15       # 0: down to label0
# BB#12:                                # %for.inc25.1
	i32.load8_u	$push16=, 2($0)
	i32.const	$push41=, 97
	i32.ne  	$push17=, $pop16, $pop41
	br_if   	0, $pop17       # 0: down to label0
# BB#13:                                # %for.inc25.2
	i32.load8_u	$push18=, 3($0)
	i32.const	$push42=, 97
	i32.ne  	$push19=, $pop18, $pop42
	br_if   	0, $pop19       # 0: down to label0
# BB#14:                                # %for.inc25.3
	i32.load8_u	$push20=, 4($0)
	i32.const	$push43=, 97
	i32.ne  	$push21=, $pop20, $pop43
	br_if   	0, $pop21       # 0: down to label0
# BB#15:                                # %for.inc25.4
	i32.load8_u	$push22=, 5($0)
	i32.const	$push44=, 97
	i32.ne  	$push23=, $pop22, $pop44
	br_if   	0, $pop23       # 0: down to label0
# BB#16:                                # %for.inc25.5
	i32.load8_u	$push24=, 6($0)
	i32.const	$push45=, 97
	i32.ne  	$push25=, $pop24, $pop45
	br_if   	0, $pop25       # 0: down to label0
# BB#17:                                # %for.inc25.6
	i32.load8_u	$push26=, 7($0)
	i32.const	$push46=, 97
	i32.ne  	$push27=, $pop26, $pop46
	br_if   	0, $pop27       # 0: down to label0
# BB#18:                                # %for.inc25.7
	return
.LBB1_19:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	check, .Lfunc_end1-check
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_3 Depth 2
                                        #     Child Loop BB2_16 Depth 2
                                        #     Child Loop BB2_29 Depth 2
	block   	
	loop    	                # label7:
	i32.const	$push85=, 0
	i64.const	$push84=, 7016996765293437281
	i64.store	u+23($pop85):p2align=0, $pop84
	i32.const	$push83=, 0
	i64.const	$push82=, 7016996765293437281
	i64.store	u+16($pop83), $pop82
	i32.const	$push81=, 0
	i64.const	$push80=, 7016996765293437281
	i64.store	u+8($pop81), $pop80
	i32.const	$push79=, 0
	i64.const	$push78=, 7016996765293437281
	i64.store	u($pop79), $pop78
	i32.const	$push77=, u
	i32.const	$push76=, 0
	i32.call	$0=, memset@FUNCTION, $pop77, $pop76, $2
	i32.const	$1=, u
	block   	
	i32.eqz 	$push281=, $2
	br_if   	0, $pop281      # 0: down to label8
# BB#2:                                 # %for.body6.i.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$1=, 0
.LBB2_3:                                # %for.body6.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label9:
	i32.add 	$push1=, $1, $0
	i32.load8_u	$push2=, 0($pop1)
	br_if   	3, $pop2        # 3: down to label6
# BB#4:                                 # %for.inc12.i
                                        #   in Loop: Header=BB2_3 Depth=2
	i32.const	$push88=, 1
	i32.add 	$push87=, $1, $pop88
	tee_local	$push86=, $1=, $pop87
	i32.lt_u	$push3=, $pop86, $2
	br_if   	0, $pop3        # 0: up to label9
# BB#5:                                 # %for.end15.i.loopexit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	i32.add 	$1=, $1, $0
.LBB2_6:                                # %for.end15.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label8:
	i32.load8_u	$push4=, 0($1)
	i32.const	$push89=, 97
	i32.ne  	$push5=, $pop4, $pop89
	br_if   	1, $pop5        # 1: down to label6
# BB#7:                                 # %for.inc25.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push6=, 1($1)
	i32.const	$push90=, 97
	i32.ne  	$push7=, $pop6, $pop90
	br_if   	1, $pop7        # 1: down to label6
# BB#8:                                 # %for.inc25.1.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push8=, 2($1)
	i32.const	$push91=, 97
	i32.ne  	$push9=, $pop8, $pop91
	br_if   	1, $pop9        # 1: down to label6
# BB#9:                                 # %for.inc25.2.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push10=, 3($1)
	i32.const	$push92=, 97
	i32.ne  	$push11=, $pop10, $pop92
	br_if   	1, $pop11       # 1: down to label6
# BB#10:                                # %for.inc25.3.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push12=, 4($1)
	i32.const	$push93=, 97
	i32.ne  	$push13=, $pop12, $pop93
	br_if   	1, $pop13       # 1: down to label6
# BB#11:                                # %for.inc25.4.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push14=, 5($1)
	i32.const	$push94=, 97
	i32.ne  	$push15=, $pop14, $pop94
	br_if   	1, $pop15       # 1: down to label6
# BB#12:                                # %for.inc25.5.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push16=, 6($1)
	i32.const	$push95=, 97
	i32.ne  	$push17=, $pop16, $pop95
	br_if   	1, $pop17       # 1: down to label6
# BB#13:                                # %for.inc25.6.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push18=, 7($1)
	i32.const	$push96=, 97
	i32.ne  	$push19=, $pop18, $pop96
	br_if   	1, $pop19       # 1: down to label6
# BB#14:                                # %check.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$1=, u
	i32.const	$push98=, u
	i32.const	$push97=, 0
	i32.load8_u	$push20=, A($pop97)
	i32.call	$drop=, memset@FUNCTION, $pop98, $pop20, $2
	block   	
	i32.eqz 	$push282=, $2
	br_if   	0, $pop282      # 0: down to label10
# BB#15:                                # %for.body6.i242.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$1=, 0
.LBB2_16:                               # %for.body6.i242
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label11:
	i32.add 	$push21=, $1, $0
	i32.load8_u	$push22=, 0($pop21)
	i32.const	$push99=, 65
	i32.ne  	$push23=, $pop22, $pop99
	br_if   	3, $pop23       # 3: down to label6
# BB#17:                                # %for.inc12.i247
                                        #   in Loop: Header=BB2_16 Depth=2
	i32.const	$push102=, 1
	i32.add 	$push101=, $1, $pop102
	tee_local	$push100=, $1=, $pop101
	i32.lt_u	$push24=, $pop100, $2
	br_if   	0, $pop24       # 0: up to label11
# BB#18:                                # %for.end15.i250.loopexit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	i32.add 	$1=, $1, $0
.LBB2_19:                               # %for.end15.i250
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label10:
	i32.load8_u	$push25=, 0($1)
	i32.const	$push103=, 97
	i32.ne  	$push26=, $pop25, $pop103
	br_if   	1, $pop26       # 1: down to label6
# BB#20:                                # %for.inc25.i254
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push27=, 1($1)
	i32.const	$push104=, 97
	i32.ne  	$push28=, $pop27, $pop104
	br_if   	1, $pop28       # 1: down to label6
# BB#21:                                # %for.inc25.1.i257
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push29=, 2($1)
	i32.const	$push105=, 97
	i32.ne  	$push30=, $pop29, $pop105
	br_if   	1, $pop30       # 1: down to label6
# BB#22:                                # %for.inc25.2.i260
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push31=, 3($1)
	i32.const	$push106=, 97
	i32.ne  	$push32=, $pop31, $pop106
	br_if   	1, $pop32       # 1: down to label6
# BB#23:                                # %for.inc25.3.i263
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push33=, 4($1)
	i32.const	$push107=, 97
	i32.ne  	$push34=, $pop33, $pop107
	br_if   	1, $pop34       # 1: down to label6
# BB#24:                                # %for.inc25.4.i266
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push35=, 5($1)
	i32.const	$push108=, 97
	i32.ne  	$push36=, $pop35, $pop108
	br_if   	1, $pop36       # 1: down to label6
# BB#25:                                # %for.inc25.5.i269
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push37=, 6($1)
	i32.const	$push109=, 97
	i32.ne  	$push38=, $pop37, $pop109
	br_if   	1, $pop38       # 1: down to label6
# BB#26:                                # %for.inc25.6.i272
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push39=, 7($1)
	i32.const	$push110=, 97
	i32.ne  	$push40=, $pop39, $pop110
	br_if   	1, $pop40       # 1: down to label6
# BB#27:                                # %check.exit273
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$1=, u
	i32.const	$push112=, u
	i32.const	$push111=, 66
	i32.call	$drop=, memset@FUNCTION, $pop112, $pop111, $2
	block   	
	i32.eqz 	$push283=, $2
	br_if   	0, $pop283      # 0: down to label12
# BB#28:                                # %for.body6.i280.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$1=, 0
.LBB2_29:                               # %for.body6.i280
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label13:
	i32.add 	$push41=, $1, $0
	i32.load8_u	$push42=, 0($pop41)
	i32.const	$push113=, 66
	i32.ne  	$push43=, $pop42, $pop113
	br_if   	3, $pop43       # 3: down to label6
# BB#30:                                # %for.inc12.i285
                                        #   in Loop: Header=BB2_29 Depth=2
	i32.const	$push116=, 1
	i32.add 	$push115=, $1, $pop116
	tee_local	$push114=, $1=, $pop115
	i32.lt_u	$push44=, $pop114, $2
	br_if   	0, $pop44       # 0: up to label13
# BB#31:                                # %for.end15.i288.loopexit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	i32.add 	$1=, $1, $0
.LBB2_32:                               # %for.end15.i288
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label12:
	i32.load8_u	$push45=, 0($1)
	i32.const	$push117=, 97
	i32.ne  	$push46=, $pop45, $pop117
	br_if   	1, $pop46       # 1: down to label6
# BB#33:                                # %for.inc25.i292
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push47=, 1($1)
	i32.const	$push118=, 97
	i32.ne  	$push48=, $pop47, $pop118
	br_if   	1, $pop48       # 1: down to label6
# BB#34:                                # %for.inc25.1.i295
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push49=, 2($1)
	i32.const	$push119=, 97
	i32.ne  	$push50=, $pop49, $pop119
	br_if   	1, $pop50       # 1: down to label6
# BB#35:                                # %for.inc25.2.i298
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push51=, 3($1)
	i32.const	$push120=, 97
	i32.ne  	$push52=, $pop51, $pop120
	br_if   	1, $pop52       # 1: down to label6
# BB#36:                                # %for.inc25.3.i301
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push53=, 4($1)
	i32.const	$push121=, 97
	i32.ne  	$push54=, $pop53, $pop121
	br_if   	1, $pop54       # 1: down to label6
# BB#37:                                # %for.inc25.4.i304
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push55=, 5($1)
	i32.const	$push122=, 97
	i32.ne  	$push56=, $pop55, $pop122
	br_if   	1, $pop56       # 1: down to label6
# BB#38:                                # %for.inc25.5.i307
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push57=, 6($1)
	i32.const	$push123=, 97
	i32.ne  	$push58=, $pop57, $pop123
	br_if   	1, $pop58       # 1: down to label6
# BB#39:                                # %for.inc25.6.i310
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push59=, 7($1)
	i32.const	$push124=, 97
	i32.ne  	$push60=, $pop59, $pop124
	br_if   	1, $pop60       # 1: down to label6
# BB#40:                                # %for.cond
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push126=, 14
	i32.lt_u	$0=, $2, $pop126
	i32.const	$push125=, 1
	i32.add 	$push0=, $2, $pop125
	copy_local	$2=, $pop0
	br_if   	0, $0           # 0: up to label7
# BB#41:                                # %for.body13.preheader
	end_loop
	i32.const	$2=, 0
.LBB2_42:                               # %for.body13
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label14:
	i32.const	$push148=, 0
	i64.const	$push147=, 7016996765293437281
	i64.store	u+23($pop148):p2align=0, $pop147
	i32.const	$push146=, 0
	i64.const	$push145=, 7016996765293437281
	i64.store	u+16($pop146), $pop145
	i32.const	$push144=, 0
	i64.const	$push143=, 7016996765293437281
	i64.store	u+8($pop144), $pop143
	i32.const	$push142=, 0
	i64.const	$push141=, 7016996765293437281
	i64.store	u($pop142), $pop141
	i32.const	$push140=, u+1
	i32.const	$push139=, 0
	i32.call	$0=, memset@FUNCTION, $pop140, $pop139, $2
	i32.const	$push138=, 1
	i32.const	$push137=, 0
	call    	check@FUNCTION, $pop138, $2, $pop137
	i32.const	$push136=, 0
	i32.load8_u	$push61=, A($pop136)
	i32.call	$drop=, memset@FUNCTION, $0, $pop61, $2
	i32.const	$push135=, 1
	i32.const	$push134=, 65
	call    	check@FUNCTION, $pop135, $2, $pop134
	i32.const	$push133=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop133, $2
	i32.const	$push132=, 1
	i32.const	$push131=, 66
	call    	check@FUNCTION, $pop132, $2, $pop131
	i32.const	$push130=, 1
	i32.add 	$push129=, $2, $pop130
	tee_local	$push128=, $2=, $pop129
	i32.const	$push127=, 15
	i32.ne  	$push62=, $pop128, $pop127
	br_if   	0, $pop62       # 0: up to label14
# BB#43:                                # %for.body33.preheader
	end_loop
	i32.const	$2=, 0
.LBB2_44:                               # %for.body33
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label15:
	i32.const	$push170=, 0
	i64.const	$push169=, 7016996765293437281
	i64.store	u+23($pop170):p2align=0, $pop169
	i32.const	$push168=, 0
	i64.const	$push167=, 7016996765293437281
	i64.store	u+16($pop168), $pop167
	i32.const	$push166=, 0
	i64.const	$push165=, 7016996765293437281
	i64.store	u+8($pop166), $pop165
	i32.const	$push164=, 0
	i64.const	$push163=, 7016996765293437281
	i64.store	u($pop164), $pop163
	i32.const	$push162=, u+2
	i32.const	$push161=, 0
	i32.call	$0=, memset@FUNCTION, $pop162, $pop161, $2
	i32.const	$push160=, 2
	i32.const	$push159=, 0
	call    	check@FUNCTION, $pop160, $2, $pop159
	i32.const	$push158=, 0
	i32.load8_u	$push63=, A($pop158)
	i32.call	$drop=, memset@FUNCTION, $0, $pop63, $2
	i32.const	$push157=, 2
	i32.const	$push156=, 65
	call    	check@FUNCTION, $pop157, $2, $pop156
	i32.const	$push155=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop155, $2
	i32.const	$push154=, 2
	i32.const	$push153=, 66
	call    	check@FUNCTION, $pop154, $2, $pop153
	i32.const	$push152=, 1
	i32.add 	$push151=, $2, $pop152
	tee_local	$push150=, $2=, $pop151
	i32.const	$push149=, 15
	i32.ne  	$push64=, $pop150, $pop149
	br_if   	0, $pop64       # 0: up to label15
# BB#45:                                # %for.body53.preheader
	end_loop
	i32.const	$2=, 0
.LBB2_46:                               # %for.body53
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label16:
	i32.const	$push192=, 0
	i64.const	$push191=, 7016996765293437281
	i64.store	u+23($pop192):p2align=0, $pop191
	i32.const	$push190=, 0
	i64.const	$push189=, 7016996765293437281
	i64.store	u+16($pop190), $pop189
	i32.const	$push188=, 0
	i64.const	$push187=, 7016996765293437281
	i64.store	u+8($pop188), $pop187
	i32.const	$push186=, 0
	i64.const	$push185=, 7016996765293437281
	i64.store	u($pop186), $pop185
	i32.const	$push184=, u+3
	i32.const	$push183=, 0
	i32.call	$0=, memset@FUNCTION, $pop184, $pop183, $2
	i32.const	$push182=, 3
	i32.const	$push181=, 0
	call    	check@FUNCTION, $pop182, $2, $pop181
	i32.const	$push180=, 0
	i32.load8_u	$push65=, A($pop180)
	i32.call	$drop=, memset@FUNCTION, $0, $pop65, $2
	i32.const	$push179=, 3
	i32.const	$push178=, 65
	call    	check@FUNCTION, $pop179, $2, $pop178
	i32.const	$push177=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop177, $2
	i32.const	$push176=, 3
	i32.const	$push175=, 66
	call    	check@FUNCTION, $pop176, $2, $pop175
	i32.const	$push174=, 1
	i32.add 	$push173=, $2, $pop174
	tee_local	$push172=, $2=, $pop173
	i32.const	$push171=, 15
	i32.ne  	$push66=, $pop172, $pop171
	br_if   	0, $pop66       # 0: up to label16
# BB#47:                                # %for.body73.preheader
	end_loop
	i32.const	$2=, 0
.LBB2_48:                               # %for.body73
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label17:
	i32.const	$push214=, 0
	i64.const	$push213=, 7016996765293437281
	i64.store	u+23($pop214):p2align=0, $pop213
	i32.const	$push212=, 0
	i64.const	$push211=, 7016996765293437281
	i64.store	u+16($pop212), $pop211
	i32.const	$push210=, 0
	i64.const	$push209=, 7016996765293437281
	i64.store	u+8($pop210), $pop209
	i32.const	$push208=, 0
	i64.const	$push207=, 7016996765293437281
	i64.store	u($pop208), $pop207
	i32.const	$push206=, u+4
	i32.const	$push205=, 0
	i32.call	$0=, memset@FUNCTION, $pop206, $pop205, $2
	i32.const	$push204=, 4
	i32.const	$push203=, 0
	call    	check@FUNCTION, $pop204, $2, $pop203
	i32.const	$push202=, 0
	i32.load8_u	$push67=, A($pop202)
	i32.call	$drop=, memset@FUNCTION, $0, $pop67, $2
	i32.const	$push201=, 4
	i32.const	$push200=, 65
	call    	check@FUNCTION, $pop201, $2, $pop200
	i32.const	$push199=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop199, $2
	i32.const	$push198=, 4
	i32.const	$push197=, 66
	call    	check@FUNCTION, $pop198, $2, $pop197
	i32.const	$push196=, 1
	i32.add 	$push195=, $2, $pop196
	tee_local	$push194=, $2=, $pop195
	i32.const	$push193=, 15
	i32.ne  	$push68=, $pop194, $pop193
	br_if   	0, $pop68       # 0: up to label17
# BB#49:                                # %for.body93.preheader
	end_loop
	i32.const	$2=, 0
.LBB2_50:                               # %for.body93
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label18:
	i32.const	$push236=, 0
	i64.const	$push235=, 7016996765293437281
	i64.store	u+23($pop236):p2align=0, $pop235
	i32.const	$push234=, 0
	i64.const	$push233=, 7016996765293437281
	i64.store	u+16($pop234), $pop233
	i32.const	$push232=, 0
	i64.const	$push231=, 7016996765293437281
	i64.store	u+8($pop232), $pop231
	i32.const	$push230=, 0
	i64.const	$push229=, 7016996765293437281
	i64.store	u($pop230), $pop229
	i32.const	$push228=, u+5
	i32.const	$push227=, 0
	i32.call	$0=, memset@FUNCTION, $pop228, $pop227, $2
	i32.const	$push226=, 5
	i32.const	$push225=, 0
	call    	check@FUNCTION, $pop226, $2, $pop225
	i32.const	$push224=, 0
	i32.load8_u	$push69=, A($pop224)
	i32.call	$drop=, memset@FUNCTION, $0, $pop69, $2
	i32.const	$push223=, 5
	i32.const	$push222=, 65
	call    	check@FUNCTION, $pop223, $2, $pop222
	i32.const	$push221=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop221, $2
	i32.const	$push220=, 5
	i32.const	$push219=, 66
	call    	check@FUNCTION, $pop220, $2, $pop219
	i32.const	$push218=, 1
	i32.add 	$push217=, $2, $pop218
	tee_local	$push216=, $2=, $pop217
	i32.const	$push215=, 15
	i32.ne  	$push70=, $pop216, $pop215
	br_if   	0, $pop70       # 0: up to label18
# BB#51:                                # %for.body113.preheader
	end_loop
	i32.const	$2=, 0
.LBB2_52:                               # %for.body113
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label19:
	i32.const	$push258=, 0
	i64.const	$push257=, 7016996765293437281
	i64.store	u+23($pop258):p2align=0, $pop257
	i32.const	$push256=, 0
	i64.const	$push255=, 7016996765293437281
	i64.store	u+16($pop256), $pop255
	i32.const	$push254=, 0
	i64.const	$push253=, 7016996765293437281
	i64.store	u+8($pop254), $pop253
	i32.const	$push252=, 0
	i64.const	$push251=, 7016996765293437281
	i64.store	u($pop252), $pop251
	i32.const	$push250=, u+6
	i32.const	$push249=, 0
	i32.call	$0=, memset@FUNCTION, $pop250, $pop249, $2
	i32.const	$push248=, 6
	i32.const	$push247=, 0
	call    	check@FUNCTION, $pop248, $2, $pop247
	i32.const	$push246=, 0
	i32.load8_u	$push71=, A($pop246)
	i32.call	$drop=, memset@FUNCTION, $0, $pop71, $2
	i32.const	$push245=, 6
	i32.const	$push244=, 65
	call    	check@FUNCTION, $pop245, $2, $pop244
	i32.const	$push243=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop243, $2
	i32.const	$push242=, 6
	i32.const	$push241=, 66
	call    	check@FUNCTION, $pop242, $2, $pop241
	i32.const	$push240=, 1
	i32.add 	$push239=, $2, $pop240
	tee_local	$push238=, $2=, $pop239
	i32.const	$push237=, 15
	i32.ne  	$push72=, $pop238, $pop237
	br_if   	0, $pop72       # 0: up to label19
# BB#53:                                # %for.body133.preheader
	end_loop
	i32.const	$2=, 0
.LBB2_54:                               # %for.body133
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label20:
	i32.const	$push280=, 0
	i64.const	$push279=, 7016996765293437281
	i64.store	u+23($pop280):p2align=0, $pop279
	i32.const	$push278=, 0
	i64.const	$push277=, 7016996765293437281
	i64.store	u+16($pop278), $pop277
	i32.const	$push276=, 0
	i64.const	$push275=, 7016996765293437281
	i64.store	u+8($pop276), $pop275
	i32.const	$push274=, 0
	i64.const	$push273=, 7016996765293437281
	i64.store	u($pop274), $pop273
	i32.const	$push272=, u+7
	i32.const	$push271=, 0
	i32.call	$0=, memset@FUNCTION, $pop272, $pop271, $2
	i32.const	$push270=, 7
	i32.const	$push269=, 0
	call    	check@FUNCTION, $pop270, $2, $pop269
	i32.const	$push268=, 0
	i32.load8_u	$push73=, A($pop268)
	i32.call	$drop=, memset@FUNCTION, $0, $pop73, $2
	i32.const	$push267=, 7
	i32.const	$push266=, 65
	call    	check@FUNCTION, $pop267, $2, $pop266
	i32.const	$push265=, 66
	i32.call	$drop=, memset@FUNCTION, $0, $pop265, $2
	i32.const	$push264=, 7
	i32.const	$push263=, 66
	call    	check@FUNCTION, $pop264, $2, $pop263
	i32.const	$push262=, 1
	i32.add 	$push261=, $2, $pop262
	tee_local	$push260=, $2=, $pop261
	i32.const	$push259=, 15
	i32.ne  	$push74=, $pop260, $pop259
	br_if   	0, $pop74       # 0: up to label20
# BB#55:                                # %for.end149
	end_loop
	i32.const	$push75=, 0
	call    	exit@FUNCTION, $pop75
	unreachable
.LBB2_56:                               # %if.then10.i
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
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
	.skip	32
	.size	u, 32


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
