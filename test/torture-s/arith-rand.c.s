	.text
	.file	"arith-rand.c"
	.section	.text.simple_rand,"ax",@progbits
	.hidden	simple_rand             # -- Begin function simple_rand
	.globl	simple_rand
	.type	simple_rand,@function
simple_rand:                            # @simple_rand
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push9=, 0
	i32.load	$push1=, simple_rand.seed($pop9)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push8=, $pop3, $pop4
	tee_local	$push7=, $0=, $pop8
	i32.store	simple_rand.seed($pop0), $pop7
	i32.const	$push5=, 8
	i32.shr_u	$push6=, $0, $pop5
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end0:
	.size	simple_rand, .Lfunc_end0-simple_rand
                                        # -- End function
	.section	.text.random_bitstring,"ax",@progbits
	.hidden	random_bitstring        # -- Begin function random_bitstring
	.globl	random_bitstring
	.type	random_bitstring,@function
random_bitstring:                       # @random_bitstring
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.const	$push18=, 0
	i32.const	$push17=, 0
	i32.load	$push0=, simple_rand.seed($pop17)
	i32.const	$push16=, 1103515245
	i32.mul 	$push1=, $pop0, $pop16
	i32.const	$push15=, 12345
	i32.add 	$push14=, $pop1, $pop15
	tee_local	$push13=, $2=, $pop14
	i32.store	simple_rand.seed($pop18), $pop13
	block   	
	i32.const	$push12=, 9
	i32.shr_u	$push2=, $2, $pop12
	i32.const	$push11=, 15
	i32.and 	$push10=, $pop2, $pop11
	tee_local	$push9=, $0=, $pop10
	i32.eqz 	$push32=, $pop9
	br_if   	0, $pop32       # 0: down to label0
# BB#1:                                 # %if.else.preheader
	copy_local	$1=, $0
	i32.const	$3=, 0
.LBB1_2:                                # %if.else
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.shl 	$3=, $3, $1
	block   	
	i32.const	$push19=, 256
	i32.and 	$push3=, $2, $pop19
	i32.eqz 	$push33=, $pop3
	br_if   	0, $pop33       # 0: down to label2
# BB#3:                                 # %if.then1
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push21=, 1
	i32.shl 	$push4=, $pop21, $1
	i32.const	$push20=, -1
	i32.add 	$push5=, $pop4, $pop20
	i32.or  	$3=, $pop5, $3
.LBB1_4:                                # %if.end
                                        #   in Loop: Header=BB1_2 Depth=1
	end_block                       # label2:
	i32.const	$push22=, 39
	i32.ge_u	$push6=, $0, $pop22
	br_if   	1, $pop6        # 1: down to label0
# BB#5:                                 # %for.cond
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push31=, 0
	i32.const	$push30=, 1103515245
	i32.mul 	$push7=, $2, $pop30
	i32.const	$push29=, 12345
	i32.add 	$push28=, $pop7, $pop29
	tee_local	$push27=, $2=, $pop28
	i32.store	simple_rand.seed($pop31), $pop27
	i32.const	$push26=, 9
	i32.shr_u	$push8=, $2, $pop26
	i32.const	$push25=, 15
	i32.and 	$push24=, $pop8, $pop25
	tee_local	$push23=, $1=, $pop24
	i32.add 	$0=, $pop23, $0
	br_if   	0, $1           # 0: up to label1
.LBB1_6:                                # %cleanup
	end_loop
	end_block                       # label0:
	copy_local	$push34=, $3
                                        # fallthrough-return: $pop34
	.endfunc
.Lfunc_end1:
	.size	random_bitstring, .Lfunc_end1-random_bitstring
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push62=, 0
	i32.load	$3=, simple_rand.seed($pop62)
	i32.const	$7=, 0
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_3 Depth 2
                                        #     Child Loop BB2_10 Depth 2
	block   	
	block   	
	block   	
	loop    	                # label6:
	copy_local	$0=, $7
	block   	
	block   	
	i32.const	$push70=, 1103515245
	i32.mul 	$push0=, $3, $pop70
	i32.const	$push69=, 12345
	i32.add 	$push68=, $pop0, $pop69
	tee_local	$push67=, $2=, $pop68
	i32.const	$push66=, 9
	i32.shr_u	$push1=, $pop67, $pop66
	i32.const	$push65=, 15
	i32.and 	$push64=, $pop1, $pop65
	tee_local	$push63=, $3=, $pop64
	i32.eqz 	$push164=, $pop63
	br_if   	0, $pop164      # 0: down to label8
# BB#2:                                 # %if.else.i.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$1=, 0
	copy_local	$7=, $3
.LBB2_3:                                # %if.else.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label9:
	i32.shl 	$1=, $1, $7
	block   	
	i32.const	$push71=, 256
	i32.and 	$push2=, $2, $pop71
	i32.eqz 	$push165=, $pop2
	br_if   	0, $pop165      # 0: down to label10
# BB#4:                                 # %if.then1.i
                                        #   in Loop: Header=BB2_3 Depth=2
	i32.const	$push73=, 1
	i32.shl 	$push3=, $pop73, $7
	i32.const	$push72=, -1
	i32.add 	$push4=, $pop3, $pop72
	i32.or  	$1=, $1, $pop4
.LBB2_5:                                # %if.end.i
                                        #   in Loop: Header=BB2_3 Depth=2
	end_block                       # label10:
	i32.const	$push74=, 39
	i32.ge_u	$push5=, $3, $pop74
	br_if   	2, $pop5        # 2: down to label7
# BB#6:                                 # %for.cond.i
                                        #   in Loop: Header=BB2_3 Depth=2
	i32.const	$push82=, 1103515245
	i32.mul 	$push6=, $2, $pop82
	i32.const	$push81=, 12345
	i32.add 	$push80=, $pop6, $pop81
	tee_local	$push79=, $2=, $pop80
	i32.const	$push78=, 9
	i32.shr_u	$push7=, $pop79, $pop78
	i32.const	$push77=, 15
	i32.and 	$push76=, $pop7, $pop77
	tee_local	$push75=, $7=, $pop76
	i32.add 	$3=, $pop75, $3
	br_if   	0, $7           # 0: up to label9
	br      	2               # 2: down to label7
.LBB2_7:                                #   in Loop: Header=BB2_1 Depth=1
	end_loop
	end_block                       # label8:
	i32.const	$1=, 0
.LBB2_8:                                # %random_bitstring.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label7:
	block   	
	i32.const	$push90=, 1103515245
	i32.mul 	$push8=, $2, $pop90
	i32.const	$push89=, 12345
	i32.add 	$push88=, $pop8, $pop89
	tee_local	$push87=, $3=, $pop88
	i32.const	$push86=, 9
	i32.shr_u	$push9=, $pop87, $pop86
	i32.const	$push85=, 15
	i32.and 	$push84=, $pop9, $pop85
	tee_local	$push83=, $8=, $pop84
	i32.eqz 	$push166=, $pop83
	br_if   	0, $pop166      # 0: down to label11
# BB#9:                                 # %if.else.i346.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$2=, 0
	copy_local	$7=, $8
.LBB2_10:                               # %if.else.i346
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label12:
	i32.shl 	$2=, $2, $7
	block   	
	i32.const	$push91=, 256
	i32.and 	$push10=, $3, $pop91
	i32.eqz 	$push167=, $pop10
	br_if   	0, $pop167      # 0: down to label13
# BB#11:                                # %if.then1.i350
                                        #   in Loop: Header=BB2_10 Depth=2
	i32.const	$push93=, 1
	i32.shl 	$push11=, $pop93, $7
	i32.const	$push92=, -1
	i32.add 	$push12=, $pop11, $pop92
	i32.or  	$2=, $2, $pop12
.LBB2_12:                               # %if.end.i353
                                        #   in Loop: Header=BB2_10 Depth=2
	end_block                       # label13:
	block   	
	i32.const	$push94=, 39
	i32.ge_u	$push13=, $8, $pop94
	br_if   	0, $pop13       # 0: down to label14
# BB#13:                                # %for.cond.i339
                                        #   in Loop: Header=BB2_10 Depth=2
	i32.const	$push102=, 1103515245
	i32.mul 	$push14=, $3, $pop102
	i32.const	$push101=, 12345
	i32.add 	$push100=, $pop14, $pop101
	tee_local	$push99=, $3=, $pop100
	i32.const	$push98=, 9
	i32.shr_u	$push15=, $pop99, $pop98
	i32.const	$push97=, 15
	i32.and 	$push96=, $pop15, $pop97
	tee_local	$push95=, $7=, $pop96
	i32.add 	$8=, $pop95, $8
	br_if   	1, $7           # 1: up to label12
.LBB2_14:                               # %random_bitstring.exit355
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label14:
	end_loop
	i32.eqz 	$push168=, $2
	br_if   	0, $pop168      # 0: down to label11
# BB#15:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	block   	
	i32.const	$push103=, 2147483647
	i32.and 	$push16=, $1, $pop103
	br_if   	0, $pop16       # 0: down to label15
# BB#16:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push104=, -1
	i32.eq  	$push17=, $2, $pop104
	br_if   	1, $pop17       # 1: down to label11
.LBB2_17:                               # %if.end25
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label15:
	i32.rem_s	$push112=, $1, $2
	tee_local	$push111=, $7=, $pop112
	i32.const	$push110=, 31
	i32.shr_s	$push109=, $7, $pop110
	tee_local	$push108=, $7=, $pop109
	i32.add 	$push20=, $pop111, $pop108
	i32.xor 	$push21=, $pop20, $7
	i32.const	$push107=, 31
	i32.shr_s	$push106=, $2, $pop107
	tee_local	$push105=, $7=, $pop106
	i32.add 	$push18=, $2, $pop105
	i32.xor 	$push19=, $pop18, $7
	i32.ge_u	$push22=, $pop21, $pop19
	br_if   	3, $pop22       # 3: down to label4
# BB#18:                                # %cleanup.cont47
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push113=, 65535
	i32.and 	$push24=, $2, $pop113
	i32.eqz 	$push169=, $pop24
	br_if   	0, $pop169      # 0: down to label11
# BB#19:                                # %cleanup.cont86
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push134=, 16
	i32.shl 	$push25=, $1, $pop134
	i32.const	$push133=, 16
	i32.shr_s	$push132=, $pop25, $pop133
	tee_local	$push131=, $8=, $pop132
	i32.const	$push130=, 16
	i32.shl 	$push129=, $2, $pop130
	tee_local	$push128=, $5=, $pop129
	i32.const	$push127=, 16
	i32.shr_s	$push126=, $pop128, $pop127
	tee_local	$push125=, $7=, $pop126
	i32.rem_s	$push26=, $pop131, $pop125
	i32.const	$push124=, 16
	i32.shl 	$push123=, $pop26, $pop124
	tee_local	$push122=, $6=, $pop123
	i32.const	$push121=, 16
	i32.shr_s	$push120=, $pop122, $pop121
	tee_local	$push119=, $4=, $pop120
	i32.const	$push118=, 0
	i32.sub 	$push28=, $pop118, $4
	i32.const	$push117=, -65536
	i32.gt_s	$push27=, $6, $pop117
	i32.select	$push29=, $pop119, $pop28, $pop27
	i32.const	$push116=, 0
	i32.sub 	$push31=, $pop116, $7
	i32.const	$push115=, -65536
	i32.gt_s	$push30=, $5, $pop115
	i32.select	$push32=, $7, $pop31, $pop30
	i32.const	$push114=, 65535
	i32.and 	$push33=, $pop32, $pop114
	i32.ge_s	$push34=, $pop29, $pop33
	br_if   	2, $pop34       # 2: down to label5
# BB#20:                                # %lor.lhs.false125
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push35=, $8, $7
	i32.mul 	$push36=, $pop35, $7
	i32.add 	$push37=, $pop36, $4
	i32.const	$push136=, 16
	i32.shl 	$push38=, $pop37, $pop136
	i32.const	$push135=, 16
	i32.shr_s	$push39=, $pop38, $pop135
	i32.ne  	$push40=, $pop39, $8
	br_if   	2, $pop40       # 2: down to label5
# BB#21:                                # %if.end137
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push137=, 255
	i32.and 	$push42=, $2, $pop137
	i32.eqz 	$push170=, $pop42
	br_if   	0, $pop170      # 0: down to label11
# BB#22:                                # %cleanup.cont177
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push158=, 24
	i32.shl 	$push43=, $1, $pop158
	i32.const	$push157=, 24
	i32.shr_s	$push156=, $pop43, $pop157
	tee_local	$push155=, $1=, $pop156
	i32.const	$push154=, 24
	i32.shl 	$push153=, $2, $pop154
	tee_local	$push152=, $8=, $pop153
	i32.const	$push151=, 24
	i32.shr_s	$push150=, $pop152, $pop151
	tee_local	$push149=, $7=, $pop150
	i32.rem_s	$push44=, $pop155, $pop149
	i32.const	$push148=, 24
	i32.shl 	$push147=, $pop44, $pop148
	tee_local	$push146=, $4=, $pop147
	i32.const	$push145=, 24
	i32.shr_s	$push144=, $pop146, $pop145
	tee_local	$push143=, $2=, $pop144
	i32.const	$push142=, 0
	i32.sub 	$push46=, $pop142, $2
	i32.const	$push141=, -16777216
	i32.gt_s	$push45=, $4, $pop141
	i32.select	$push47=, $pop143, $pop46, $pop45
	i32.const	$push140=, 0
	i32.sub 	$push49=, $pop140, $7
	i32.const	$push139=, -16777216
	i32.gt_s	$push48=, $8, $pop139
	i32.select	$push50=, $7, $pop49, $pop48
	i32.const	$push138=, 255
	i32.and 	$push51=, $pop50, $pop138
	i32.ge_s	$push52=, $pop47, $pop51
	br_if   	4, $pop52       # 4: down to label3
# BB#23:                                # %lor.lhs.false216
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push53=, $1, $7
	i32.mul 	$push54=, $pop53, $7
	i32.add 	$push55=, $pop54, $2
	i32.const	$push160=, 24
	i32.shl 	$push56=, $pop55, $pop160
	i32.const	$push159=, 24
	i32.shr_s	$push57=, $pop56, $pop159
	i32.ne  	$push58=, $pop57, $1
	br_if   	4, $pop58       # 4: down to label3
.LBB2_24:                               # %cleanup229
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label11:
	i32.const	$push162=, 1
	i32.add 	$7=, $0, $pop162
	i32.const	$push161=, 999
	i32.lt_u	$push60=, $0, $pop161
	br_if   	0, $pop60       # 0: up to label6
# BB#25:                                # %for.end
	end_loop
	i32.const	$push61=, 0
	i32.store	simple_rand.seed($pop61), $3
	i32.const	$push163=, 0
	call    	exit@FUNCTION, $pop163
	unreachable
.LBB2_26:                               # %if.then136
	end_block                       # label5:
	i32.const	$push41=, 0
	i32.store	simple_rand.seed($pop41), $3
	call    	abort@FUNCTION
	unreachable
.LBB2_27:                               # %if.then40
	end_block                       # label4:
	i32.const	$push23=, 0
	i32.store	simple_rand.seed($pop23), $3
	call    	abort@FUNCTION
	unreachable
.LBB2_28:                               # %if.then227
	end_block                       # label3:
	i32.const	$push59=, 0
	i32.store	simple_rand.seed($pop59), $3
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.type	simple_rand.seed,@object # @simple_rand.seed
	.section	.data.simple_rand.seed,"aw",@progbits
	.p2align	2
simple_rand.seed:
	.int32	47114711                # 0x2cee9d7
	.size	simple_rand.seed, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
