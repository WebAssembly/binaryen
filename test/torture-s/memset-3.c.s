	.text
	.file	"memset-3.c"
	.section	.text.reset,"ax",@progbits
	.hidden	reset                   # -- Begin function reset
	.globl	reset
	.type	reset,@function
reset:                                  # @reset
# %bb.0:                                # %entry
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
# %bb.0:                                # %entry
	block   	
	block   	
	block   	
	block   	
	i32.const	$push28=, 1
	i32.lt_s	$push0=, $0, $pop28
	br_if   	0, $pop0        # 0: down to label3
# %bb.1:                                # %for.body.preheader
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
# %bb.3:                                # %for.inc
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push31=, 1
	i32.add 	$3=, $3, $pop31
	i32.lt_s	$push4=, $3, $0
	br_if   	0, $pop4        # 0: up to label4
# %bb.4:                                # %for.end.loopexit
	end_loop
	i32.const	$push5=, u
	i32.add 	$0=, $3, $pop5
	i32.const	$push32=, 1
	i32.ge_s	$push7=, $1, $pop32
	br_if   	1, $pop7        # 1: down to label2
	br      	2               # 2: down to label1
.LBB1_5:
	end_block                       # label3:
	i32.const	$0=, u
	i32.const	$push33=, 1
	i32.lt_s	$push6=, $1, $pop33
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
# %bb.8:                                # %for.inc12
                                        #   in Loop: Header=BB1_7 Depth=1
	i32.const	$push34=, 1
	i32.add 	$3=, $3, $pop34
	i32.lt_s	$push11=, $3, $1
	br_if   	0, $pop11       # 0: up to label5
# %bb.9:                                # %for.end15.loopexit
	end_loop
	i32.add 	$0=, $0, $3
.LBB1_10:                               # %for.end15
	end_block                       # label1:
	i32.load8_u	$push12=, 0($0)
	i32.const	$push35=, 97
	i32.ne  	$push13=, $pop12, $pop35
	br_if   	0, $pop13       # 0: down to label0
# %bb.11:                               # %for.inc25
	i32.load8_u	$push14=, 1($0)
	i32.const	$push36=, 97
	i32.ne  	$push15=, $pop14, $pop36
	br_if   	0, $pop15       # 0: down to label0
# %bb.12:                               # %for.inc25.1
	i32.load8_u	$push16=, 2($0)
	i32.const	$push37=, 97
	i32.ne  	$push17=, $pop16, $pop37
	br_if   	0, $pop17       # 0: down to label0
# %bb.13:                               # %for.inc25.2
	i32.load8_u	$push18=, 3($0)
	i32.const	$push38=, 97
	i32.ne  	$push19=, $pop18, $pop38
	br_if   	0, $pop19       # 0: down to label0
# %bb.14:                               # %for.inc25.3
	i32.load8_u	$push20=, 4($0)
	i32.const	$push39=, 97
	i32.ne  	$push21=, $pop20, $pop39
	br_if   	0, $pop21       # 0: down to label0
# %bb.15:                               # %for.inc25.4
	i32.load8_u	$push22=, 5($0)
	i32.const	$push40=, 97
	i32.ne  	$push23=, $pop22, $pop40
	br_if   	0, $pop23       # 0: down to label0
# %bb.16:                               # %for.inc25.5
	i32.load8_u	$push24=, 6($0)
	i32.const	$push41=, 97
	i32.ne  	$push25=, $pop24, $pop41
	br_if   	0, $pop25       # 0: down to label0
# %bb.17:                               # %for.inc25.6
	i32.load8_u	$push26=, 7($0)
	i32.const	$push42=, 97
	i32.ne  	$push27=, $pop26, $pop42
	br_if   	0, $pop27       # 0: down to label0
# %bb.18:                               # %for.inc25.7
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
# %bb.0:                                # %entry
	i32.const	$1=, 0
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
	i32.call	$0=, memset@FUNCTION, $pop77, $pop76, $1
	i32.const	$2=, u
	block   	
	i32.eqz 	$push261=, $1
	br_if   	0, $pop261      # 0: down to label8
# %bb.2:                                # %for.body6.i.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$2=, 0
.LBB2_3:                                # %for.body6.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label9:
	i32.add 	$push0=, $2, $0
	i32.load8_u	$push1=, 0($pop0)
	br_if   	3, $pop1        # 3: down to label6
# %bb.4:                                # %for.inc12.i
                                        #   in Loop: Header=BB2_3 Depth=2
	i32.const	$push86=, 1
	i32.add 	$2=, $2, $pop86
	i32.lt_u	$push2=, $2, $1
	br_if   	0, $pop2        # 0: up to label9
# %bb.5:                                # %for.end15.i.loopexit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	i32.add 	$2=, $2, $0
.LBB2_6:                                # %for.end15.i
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label8:
	i32.load8_u	$push3=, 0($2)
	i32.const	$push87=, 97
	i32.ne  	$push4=, $pop3, $pop87
	br_if   	1, $pop4        # 1: down to label6
# %bb.7:                                # %for.inc25.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push5=, 1($2)
	i32.const	$push88=, 97
	i32.ne  	$push6=, $pop5, $pop88
	br_if   	1, $pop6        # 1: down to label6
# %bb.8:                                # %for.inc25.1.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push7=, 2($2)
	i32.const	$push89=, 97
	i32.ne  	$push8=, $pop7, $pop89
	br_if   	1, $pop8        # 1: down to label6
# %bb.9:                                # %for.inc25.2.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push9=, 3($2)
	i32.const	$push90=, 97
	i32.ne  	$push10=, $pop9, $pop90
	br_if   	1, $pop10       # 1: down to label6
# %bb.10:                               # %for.inc25.3.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push11=, 4($2)
	i32.const	$push91=, 97
	i32.ne  	$push12=, $pop11, $pop91
	br_if   	1, $pop12       # 1: down to label6
# %bb.11:                               # %for.inc25.4.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push13=, 5($2)
	i32.const	$push92=, 97
	i32.ne  	$push14=, $pop13, $pop92
	br_if   	1, $pop14       # 1: down to label6
# %bb.12:                               # %for.inc25.5.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push15=, 6($2)
	i32.const	$push93=, 97
	i32.ne  	$push16=, $pop15, $pop93
	br_if   	1, $pop16       # 1: down to label6
# %bb.13:                               # %for.inc25.6.i
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push17=, 7($2)
	i32.const	$push94=, 97
	i32.ne  	$push18=, $pop17, $pop94
	br_if   	1, $pop18       # 1: down to label6
# %bb.14:                               # %check.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$2=, u
	i32.const	$push96=, u
	i32.const	$push95=, 0
	i32.load8_u	$push19=, A($pop95)
	i32.call	$drop=, memset@FUNCTION, $pop96, $pop19, $1
	block   	
	i32.eqz 	$push262=, $1
	br_if   	0, $pop262      # 0: down to label10
# %bb.15:                               # %for.body6.i242.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$2=, 0
.LBB2_16:                               # %for.body6.i242
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label11:
	i32.add 	$push20=, $2, $0
	i32.load8_u	$push21=, 0($pop20)
	i32.const	$push97=, 65
	i32.ne  	$push22=, $pop21, $pop97
	br_if   	3, $pop22       # 3: down to label6
# %bb.17:                               # %for.inc12.i247
                                        #   in Loop: Header=BB2_16 Depth=2
	i32.const	$push98=, 1
	i32.add 	$2=, $2, $pop98
	i32.lt_u	$push23=, $2, $1
	br_if   	0, $pop23       # 0: up to label11
# %bb.18:                               # %for.end15.i250.loopexit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	i32.add 	$2=, $2, $0
.LBB2_19:                               # %for.end15.i250
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label10:
	i32.load8_u	$push24=, 0($2)
	i32.const	$push99=, 97
	i32.ne  	$push25=, $pop24, $pop99
	br_if   	1, $pop25       # 1: down to label6
# %bb.20:                               # %for.inc25.i254
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push26=, 1($2)
	i32.const	$push100=, 97
	i32.ne  	$push27=, $pop26, $pop100
	br_if   	1, $pop27       # 1: down to label6
# %bb.21:                               # %for.inc25.1.i257
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push28=, 2($2)
	i32.const	$push101=, 97
	i32.ne  	$push29=, $pop28, $pop101
	br_if   	1, $pop29       # 1: down to label6
# %bb.22:                               # %for.inc25.2.i260
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push30=, 3($2)
	i32.const	$push102=, 97
	i32.ne  	$push31=, $pop30, $pop102
	br_if   	1, $pop31       # 1: down to label6
# %bb.23:                               # %for.inc25.3.i263
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push32=, 4($2)
	i32.const	$push103=, 97
	i32.ne  	$push33=, $pop32, $pop103
	br_if   	1, $pop33       # 1: down to label6
# %bb.24:                               # %for.inc25.4.i266
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push34=, 5($2)
	i32.const	$push104=, 97
	i32.ne  	$push35=, $pop34, $pop104
	br_if   	1, $pop35       # 1: down to label6
# %bb.25:                               # %for.inc25.5.i269
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push36=, 6($2)
	i32.const	$push105=, 97
	i32.ne  	$push37=, $pop36, $pop105
	br_if   	1, $pop37       # 1: down to label6
# %bb.26:                               # %for.inc25.6.i272
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push38=, 7($2)
	i32.const	$push106=, 97
	i32.ne  	$push39=, $pop38, $pop106
	br_if   	1, $pop39       # 1: down to label6
# %bb.27:                               # %check.exit273
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$2=, u
	i32.const	$push108=, u
	i32.const	$push107=, 66
	i32.call	$drop=, memset@FUNCTION, $pop108, $pop107, $1
	block   	
	i32.eqz 	$push263=, $1
	br_if   	0, $pop263      # 0: down to label12
# %bb.28:                               # %for.body6.i280.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$2=, 0
.LBB2_29:                               # %for.body6.i280
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label13:
	i32.add 	$push40=, $2, $0
	i32.load8_u	$push41=, 0($pop40)
	i32.const	$push109=, 66
	i32.ne  	$push42=, $pop41, $pop109
	br_if   	3, $pop42       # 3: down to label6
# %bb.30:                               # %for.inc12.i285
                                        #   in Loop: Header=BB2_29 Depth=2
	i32.const	$push110=, 1
	i32.add 	$2=, $2, $pop110
	i32.lt_u	$push43=, $2, $1
	br_if   	0, $pop43       # 0: up to label13
# %bb.31:                               # %for.end15.i288.loopexit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	i32.add 	$2=, $2, $0
.LBB2_32:                               # %for.end15.i288
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label12:
	i32.load8_u	$push44=, 0($2)
	i32.const	$push111=, 97
	i32.ne  	$push45=, $pop44, $pop111
	br_if   	1, $pop45       # 1: down to label6
# %bb.33:                               # %for.inc25.i292
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push46=, 1($2)
	i32.const	$push112=, 97
	i32.ne  	$push47=, $pop46, $pop112
	br_if   	1, $pop47       # 1: down to label6
# %bb.34:                               # %for.inc25.1.i295
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push48=, 2($2)
	i32.const	$push113=, 97
	i32.ne  	$push49=, $pop48, $pop113
	br_if   	1, $pop49       # 1: down to label6
# %bb.35:                               # %for.inc25.2.i298
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push50=, 3($2)
	i32.const	$push114=, 97
	i32.ne  	$push51=, $pop50, $pop114
	br_if   	1, $pop51       # 1: down to label6
# %bb.36:                               # %for.inc25.3.i301
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push52=, 4($2)
	i32.const	$push115=, 97
	i32.ne  	$push53=, $pop52, $pop115
	br_if   	1, $pop53       # 1: down to label6
# %bb.37:                               # %for.inc25.4.i304
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push54=, 5($2)
	i32.const	$push116=, 97
	i32.ne  	$push55=, $pop54, $pop116
	br_if   	1, $pop55       # 1: down to label6
# %bb.38:                               # %for.inc25.5.i307
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push56=, 6($2)
	i32.const	$push117=, 97
	i32.ne  	$push57=, $pop56, $pop117
	br_if   	1, $pop57       # 1: down to label6
# %bb.39:                               # %for.inc25.6.i310
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.load8_u	$push58=, 7($2)
	i32.const	$push118=, 97
	i32.ne  	$push59=, $pop58, $pop118
	br_if   	1, $pop59       # 1: down to label6
# %bb.40:                               # %for.cond
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push120=, 1
	i32.add 	$1=, $1, $pop120
	i32.const	$push119=, 15
	i32.lt_u	$push60=, $1, $pop119
	br_if   	0, $pop60       # 0: up to label7
# %bb.41:                               # %for.body13.preheader
	end_loop
	i32.const	$2=, 0
.LBB2_42:                               # %for.body13
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label14:
	i32.const	$push140=, 0
	i64.const	$push139=, 7016996765293437281
	i64.store	u+23($pop140):p2align=0, $pop139
	i32.const	$push138=, 0
	i64.const	$push137=, 7016996765293437281
	i64.store	u+16($pop138), $pop137
	i32.const	$push136=, 0
	i64.const	$push135=, 7016996765293437281
	i64.store	u+8($pop136), $pop135
	i32.const	$push134=, 0
	i64.const	$push133=, 7016996765293437281
	i64.store	u($pop134), $pop133
	i32.const	$push132=, u+1
	i32.const	$push131=, 0
	i32.call	$1=, memset@FUNCTION, $pop132, $pop131, $2
	i32.const	$push130=, 1
	i32.const	$push129=, 0
	call    	check@FUNCTION, $pop130, $2, $pop129
	i32.const	$push128=, 0
	i32.load8_u	$push61=, A($pop128)
	i32.call	$drop=, memset@FUNCTION, $1, $pop61, $2
	i32.const	$push127=, 1
	i32.const	$push126=, 65
	call    	check@FUNCTION, $pop127, $2, $pop126
	i32.const	$push125=, 66
	i32.call	$drop=, memset@FUNCTION, $1, $pop125, $2
	i32.const	$push124=, 1
	i32.const	$push123=, 66
	call    	check@FUNCTION, $pop124, $2, $pop123
	i32.const	$push122=, 1
	i32.add 	$2=, $2, $pop122
	i32.const	$push121=, 15
	i32.ne  	$push62=, $2, $pop121
	br_if   	0, $pop62       # 0: up to label14
# %bb.43:                               # %for.body33.preheader
	end_loop
	i32.const	$2=, 0
.LBB2_44:                               # %for.body33
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label15:
	i32.const	$push160=, 0
	i64.const	$push159=, 7016996765293437281
	i64.store	u+23($pop160):p2align=0, $pop159
	i32.const	$push158=, 0
	i64.const	$push157=, 7016996765293437281
	i64.store	u+16($pop158), $pop157
	i32.const	$push156=, 0
	i64.const	$push155=, 7016996765293437281
	i64.store	u+8($pop156), $pop155
	i32.const	$push154=, 0
	i64.const	$push153=, 7016996765293437281
	i64.store	u($pop154), $pop153
	i32.const	$push152=, u+2
	i32.const	$push151=, 0
	i32.call	$1=, memset@FUNCTION, $pop152, $pop151, $2
	i32.const	$push150=, 2
	i32.const	$push149=, 0
	call    	check@FUNCTION, $pop150, $2, $pop149
	i32.const	$push148=, 0
	i32.load8_u	$push63=, A($pop148)
	i32.call	$drop=, memset@FUNCTION, $1, $pop63, $2
	i32.const	$push147=, 2
	i32.const	$push146=, 65
	call    	check@FUNCTION, $pop147, $2, $pop146
	i32.const	$push145=, 66
	i32.call	$drop=, memset@FUNCTION, $1, $pop145, $2
	i32.const	$push144=, 2
	i32.const	$push143=, 66
	call    	check@FUNCTION, $pop144, $2, $pop143
	i32.const	$push142=, 1
	i32.add 	$2=, $2, $pop142
	i32.const	$push141=, 15
	i32.ne  	$push64=, $2, $pop141
	br_if   	0, $pop64       # 0: up to label15
# %bb.45:                               # %for.body53.preheader
	end_loop
	i32.const	$2=, 0
.LBB2_46:                               # %for.body53
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label16:
	i32.const	$push180=, 0
	i64.const	$push179=, 7016996765293437281
	i64.store	u+23($pop180):p2align=0, $pop179
	i32.const	$push178=, 0
	i64.const	$push177=, 7016996765293437281
	i64.store	u+16($pop178), $pop177
	i32.const	$push176=, 0
	i64.const	$push175=, 7016996765293437281
	i64.store	u+8($pop176), $pop175
	i32.const	$push174=, 0
	i64.const	$push173=, 7016996765293437281
	i64.store	u($pop174), $pop173
	i32.const	$push172=, u+3
	i32.const	$push171=, 0
	i32.call	$1=, memset@FUNCTION, $pop172, $pop171, $2
	i32.const	$push170=, 3
	i32.const	$push169=, 0
	call    	check@FUNCTION, $pop170, $2, $pop169
	i32.const	$push168=, 0
	i32.load8_u	$push65=, A($pop168)
	i32.call	$drop=, memset@FUNCTION, $1, $pop65, $2
	i32.const	$push167=, 3
	i32.const	$push166=, 65
	call    	check@FUNCTION, $pop167, $2, $pop166
	i32.const	$push165=, 66
	i32.call	$drop=, memset@FUNCTION, $1, $pop165, $2
	i32.const	$push164=, 3
	i32.const	$push163=, 66
	call    	check@FUNCTION, $pop164, $2, $pop163
	i32.const	$push162=, 1
	i32.add 	$2=, $2, $pop162
	i32.const	$push161=, 15
	i32.ne  	$push66=, $2, $pop161
	br_if   	0, $pop66       # 0: up to label16
# %bb.47:                               # %for.body73.preheader
	end_loop
	i32.const	$2=, 0
.LBB2_48:                               # %for.body73
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label17:
	i32.const	$push200=, 0
	i64.const	$push199=, 7016996765293437281
	i64.store	u+23($pop200):p2align=0, $pop199
	i32.const	$push198=, 0
	i64.const	$push197=, 7016996765293437281
	i64.store	u+16($pop198), $pop197
	i32.const	$push196=, 0
	i64.const	$push195=, 7016996765293437281
	i64.store	u+8($pop196), $pop195
	i32.const	$push194=, 0
	i64.const	$push193=, 7016996765293437281
	i64.store	u($pop194), $pop193
	i32.const	$push192=, u+4
	i32.const	$push191=, 0
	i32.call	$1=, memset@FUNCTION, $pop192, $pop191, $2
	i32.const	$push190=, 4
	i32.const	$push189=, 0
	call    	check@FUNCTION, $pop190, $2, $pop189
	i32.const	$push188=, 0
	i32.load8_u	$push67=, A($pop188)
	i32.call	$drop=, memset@FUNCTION, $1, $pop67, $2
	i32.const	$push187=, 4
	i32.const	$push186=, 65
	call    	check@FUNCTION, $pop187, $2, $pop186
	i32.const	$push185=, 66
	i32.call	$drop=, memset@FUNCTION, $1, $pop185, $2
	i32.const	$push184=, 4
	i32.const	$push183=, 66
	call    	check@FUNCTION, $pop184, $2, $pop183
	i32.const	$push182=, 1
	i32.add 	$2=, $2, $pop182
	i32.const	$push181=, 15
	i32.ne  	$push68=, $2, $pop181
	br_if   	0, $pop68       # 0: up to label17
# %bb.49:                               # %for.body93.preheader
	end_loop
	i32.const	$2=, 0
.LBB2_50:                               # %for.body93
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label18:
	i32.const	$push220=, 0
	i64.const	$push219=, 7016996765293437281
	i64.store	u+23($pop220):p2align=0, $pop219
	i32.const	$push218=, 0
	i64.const	$push217=, 7016996765293437281
	i64.store	u+16($pop218), $pop217
	i32.const	$push216=, 0
	i64.const	$push215=, 7016996765293437281
	i64.store	u+8($pop216), $pop215
	i32.const	$push214=, 0
	i64.const	$push213=, 7016996765293437281
	i64.store	u($pop214), $pop213
	i32.const	$push212=, u+5
	i32.const	$push211=, 0
	i32.call	$1=, memset@FUNCTION, $pop212, $pop211, $2
	i32.const	$push210=, 5
	i32.const	$push209=, 0
	call    	check@FUNCTION, $pop210, $2, $pop209
	i32.const	$push208=, 0
	i32.load8_u	$push69=, A($pop208)
	i32.call	$drop=, memset@FUNCTION, $1, $pop69, $2
	i32.const	$push207=, 5
	i32.const	$push206=, 65
	call    	check@FUNCTION, $pop207, $2, $pop206
	i32.const	$push205=, 66
	i32.call	$drop=, memset@FUNCTION, $1, $pop205, $2
	i32.const	$push204=, 5
	i32.const	$push203=, 66
	call    	check@FUNCTION, $pop204, $2, $pop203
	i32.const	$push202=, 1
	i32.add 	$2=, $2, $pop202
	i32.const	$push201=, 15
	i32.ne  	$push70=, $2, $pop201
	br_if   	0, $pop70       # 0: up to label18
# %bb.51:                               # %for.body113.preheader
	end_loop
	i32.const	$2=, 0
.LBB2_52:                               # %for.body113
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label19:
	i32.const	$push240=, 0
	i64.const	$push239=, 7016996765293437281
	i64.store	u+23($pop240):p2align=0, $pop239
	i32.const	$push238=, 0
	i64.const	$push237=, 7016996765293437281
	i64.store	u+16($pop238), $pop237
	i32.const	$push236=, 0
	i64.const	$push235=, 7016996765293437281
	i64.store	u+8($pop236), $pop235
	i32.const	$push234=, 0
	i64.const	$push233=, 7016996765293437281
	i64.store	u($pop234), $pop233
	i32.const	$push232=, u+6
	i32.const	$push231=, 0
	i32.call	$1=, memset@FUNCTION, $pop232, $pop231, $2
	i32.const	$push230=, 6
	i32.const	$push229=, 0
	call    	check@FUNCTION, $pop230, $2, $pop229
	i32.const	$push228=, 0
	i32.load8_u	$push71=, A($pop228)
	i32.call	$drop=, memset@FUNCTION, $1, $pop71, $2
	i32.const	$push227=, 6
	i32.const	$push226=, 65
	call    	check@FUNCTION, $pop227, $2, $pop226
	i32.const	$push225=, 66
	i32.call	$drop=, memset@FUNCTION, $1, $pop225, $2
	i32.const	$push224=, 6
	i32.const	$push223=, 66
	call    	check@FUNCTION, $pop224, $2, $pop223
	i32.const	$push222=, 1
	i32.add 	$2=, $2, $pop222
	i32.const	$push221=, 15
	i32.ne  	$push72=, $2, $pop221
	br_if   	0, $pop72       # 0: up to label19
# %bb.53:                               # %for.body133.preheader
	end_loop
	i32.const	$2=, 0
.LBB2_54:                               # %for.body133
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label20:
	i32.const	$push260=, 0
	i64.const	$push259=, 7016996765293437281
	i64.store	u+23($pop260):p2align=0, $pop259
	i32.const	$push258=, 0
	i64.const	$push257=, 7016996765293437281
	i64.store	u+16($pop258), $pop257
	i32.const	$push256=, 0
	i64.const	$push255=, 7016996765293437281
	i64.store	u+8($pop256), $pop255
	i32.const	$push254=, 0
	i64.const	$push253=, 7016996765293437281
	i64.store	u($pop254), $pop253
	i32.const	$push252=, u+7
	i32.const	$push251=, 0
	i32.call	$1=, memset@FUNCTION, $pop252, $pop251, $2
	i32.const	$push250=, 7
	i32.const	$push249=, 0
	call    	check@FUNCTION, $pop250, $2, $pop249
	i32.const	$push248=, 0
	i32.load8_u	$push73=, A($pop248)
	i32.call	$drop=, memset@FUNCTION, $1, $pop73, $2
	i32.const	$push247=, 7
	i32.const	$push246=, 65
	call    	check@FUNCTION, $pop247, $2, $pop246
	i32.const	$push245=, 66
	i32.call	$drop=, memset@FUNCTION, $1, $pop245, $2
	i32.const	$push244=, 7
	i32.const	$push243=, 66
	call    	check@FUNCTION, $pop244, $2, $pop243
	i32.const	$push242=, 1
	i32.add 	$2=, $2, $pop242
	i32.const	$push241=, 15
	i32.ne  	$push74=, $2, $pop241
	br_if   	0, $pop74       # 0: up to label20
# %bb.55:                               # %for.end149
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
