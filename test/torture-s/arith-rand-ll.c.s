	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/arith-rand-ll.c"
	.section	.text.simple_rand,"ax",@progbits
	.hidden	simple_rand
	.globl	simple_rand
	.type	simple_rand,@function
simple_rand:                            # @simple_rand
	.result 	i64
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push9=, 0
	i64.load	$push1=, simple_rand.seed($pop9)
	i64.const	$push2=, 1103515245
	i64.mul 	$push3=, $pop1, $pop2
	i64.const	$push4=, 12345
	i64.add 	$push8=, $pop3, $pop4
	tee_local	$push7=, $0=, $pop8
	i64.store	simple_rand.seed($pop0), $pop7
	i64.const	$push5=, 8
	i64.shr_u	$push6=, $0, $pop5
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end0:
	.size	simple_rand, .Lfunc_end0-simple_rand

	.section	.text.random_bitstring,"ax",@progbits
	.hidden	random_bitstring
	.globl	random_bitstring
	.type	random_bitstring,@function
random_bitstring:                       # @random_bitstring
	.result 	i64
	.local  	i64, i32, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$4=, 0
	i32.const	$push10=, 0
	i64.load	$2=, simple_rand.seed($pop10)
	i64.const	$3=, 0
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i64.const	$push20=, 1103515245
	i64.mul 	$push0=, $2, $pop20
	i64.const	$push19=, 12345
	i64.add 	$push18=, $pop0, $pop19
	tee_local	$push17=, $2=, $pop18
	i64.const	$push16=, 9
	i64.shr_u	$push15=, $pop17, $pop16
	tee_local	$push14=, $0=, $pop15
	i32.wrap/i64	$push1=, $pop14
	i32.const	$push13=, 15
	i32.and 	$push12=, $pop1, $pop13
	tee_local	$push11=, $1=, $pop12
	i32.eqz 	$push26=, $pop11
	br_if   	1, $pop26       # 1: down to label0
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.add 	$4=, $1, $4
	i64.const	$push22=, 15
	i64.and 	$push2=, $0, $pop22
	i64.shl 	$3=, $3, $pop2
	block   	
	i64.const	$push21=, 256
	i64.and 	$push3=, $2, $pop21
	i64.eqz 	$push4=, $pop3
	br_if   	0, $pop4        # 0: down to label2
# BB#3:                                 # %if.then2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push24=, 1
	i32.shl 	$push5=, $pop24, $1
	i32.const	$push23=, -1
	i32.add 	$push6=, $pop5, $pop23
	i64.extend_s/i32	$push7=, $pop6
	i64.or  	$3=, $pop7, $3
.LBB1_4:                                # %if.end
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.const	$push25=, 71
	i32.lt_u	$push8=, $4, $pop25
	br_if   	0, $pop8        # 0: up to label1
.LBB1_5:                                # %cleanup
	end_loop
	end_block                       # label0:
	i32.const	$push9=, 0
	i64.store	simple_rand.seed($pop9), $2
	copy_local	$push27=, $3
                                        # fallthrough-return: $pop27
	.endfunc
.Lfunc_end1:
	.size	random_bitstring, .Lfunc_end1-random_bitstring

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i64, i64, i32, i32, i32, i32, i32, i64, i32, i64
# BB#0:                                 # %entry
	i32.const	$push76=, 0
	i64.load	$2=, simple_rand.seed($pop76)
	i64.const	$0=, 0
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
                                        #     Child Loop BB2_7 Depth 2
	block   	
	block   	
	block   	
	block   	
	loop    	                # label7:
	i64.const	$9=, 0
	i32.const	$10=, 0
.LBB2_2:                                # %for.cond.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label9:
	i64.const	$push86=, 1103515245
	i64.mul 	$push0=, $2, $pop86
	i64.const	$push85=, 12345
	i64.add 	$push84=, $pop0, $pop85
	tee_local	$push83=, $2=, $pop84
	i64.const	$push82=, 9
	i64.shr_u	$push81=, $pop83, $pop82
	tee_local	$push80=, $11=, $pop81
	i32.wrap/i64	$push1=, $pop80
	i32.const	$push79=, 15
	i32.and 	$push78=, $pop1, $pop79
	tee_local	$push77=, $1=, $pop78
	i32.eqz 	$push186=, $pop77
	br_if   	1, $pop186      # 1: down to label8
# BB#3:                                 # %if.else.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.add 	$10=, $1, $10
	i64.const	$push88=, 15
	i64.and 	$push2=, $11, $pop88
	i64.shl 	$9=, $9, $pop2
	block   	
	i64.const	$push87=, 256
	i64.and 	$push3=, $2, $pop87
	i64.eqz 	$push4=, $pop3
	br_if   	0, $pop4        # 0: down to label10
# BB#4:                                 # %if.then2.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.const	$push90=, 1
	i32.shl 	$push5=, $pop90, $1
	i32.const	$push89=, -1
	i32.add 	$push6=, $pop5, $pop89
	i64.extend_s/i32	$push7=, $pop6
	i64.or  	$9=, $pop7, $9
.LBB2_5:                                # %if.end.i
                                        #   in Loop: Header=BB2_2 Depth=2
	end_block                       # label10:
	i32.const	$push91=, 71
	i32.lt_u	$push8=, $10, $pop91
	br_if   	0, $pop8        # 0: up to label9
.LBB2_6:                                # %random_bitstring.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	end_block                       # label8:
	i32.const	$10=, 0
	i64.const	$11=, 0
.LBB2_7:                                # %for.cond.i452
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label12:
	i64.const	$push101=, 1103515245
	i64.mul 	$push9=, $2, $pop101
	i64.const	$push100=, 12345
	i64.add 	$push99=, $pop9, $pop100
	tee_local	$push98=, $2=, $pop99
	i64.const	$push97=, 9
	i64.shr_u	$push96=, $pop98, $pop97
	tee_local	$push95=, $3=, $pop96
	i32.wrap/i64	$push10=, $pop95
	i32.const	$push94=, 15
	i32.and 	$push93=, $pop10, $pop94
	tee_local	$push92=, $1=, $pop93
	i32.eqz 	$push187=, $pop92
	br_if   	1, $pop187      # 1: down to label11
# BB#8:                                 # %if.else.i457
                                        #   in Loop: Header=BB2_7 Depth=2
	i32.add 	$10=, $1, $10
	i64.const	$push103=, 15
	i64.and 	$push11=, $3, $pop103
	i64.shl 	$11=, $11, $pop11
	block   	
	i64.const	$push102=, 256
	i64.and 	$push12=, $2, $pop102
	i64.eqz 	$push13=, $pop12
	br_if   	0, $pop13       # 0: down to label13
# BB#9:                                 # %if.then2.i462
                                        #   in Loop: Header=BB2_7 Depth=2
	i32.const	$push105=, 1
	i32.shl 	$push14=, $pop105, $1
	i32.const	$push104=, -1
	i32.add 	$push15=, $pop14, $pop104
	i64.extend_s/i32	$push16=, $pop15
	i64.or  	$11=, $pop16, $11
.LBB2_10:                               # %if.end.i465
                                        #   in Loop: Header=BB2_7 Depth=2
	end_block                       # label13:
	i32.const	$push106=, 71
	i32.lt_u	$push17=, $10, $pop106
	br_if   	0, $pop17       # 0: up to label12
.LBB2_11:                               # %random_bitstring.exit467
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	end_block                       # label11:
	block   	
	i64.eqz 	$push18=, $11
	br_if   	0, $pop18       # 0: down to label14
# BB#12:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	block   	
	i64.const	$push108=, 9223372036854775807
	i64.and 	$push19=, $9, $pop108
	i64.const	$push107=, 0
	i64.ne  	$push20=, $pop19, $pop107
	br_if   	0, $pop20       # 0: down to label15
# BB#13:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	i64.const	$push109=, -1
	i64.eq  	$push21=, $11, $pop109
	br_if   	1, $pop21       # 1: down to label14
.LBB2_14:                               # %if.end17
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label15:
	i64.rem_s	$push117=, $9, $11
	tee_local	$push116=, $3=, $pop117
	i64.const	$push115=, 63
	i64.shr_s	$push114=, $3, $pop115
	tee_local	$push113=, $3=, $pop114
	i64.add 	$push24=, $pop116, $pop113
	i64.xor 	$push25=, $pop24, $3
	i64.const	$push112=, 63
	i64.shr_s	$push111=, $11, $pop112
	tee_local	$push110=, $3=, $pop111
	i64.add 	$push22=, $11, $pop110
	i64.xor 	$push23=, $pop22, $3
	i64.ge_u	$push26=, $pop25, $pop23
	br_if   	2, $pop26       # 2: down to label6
# BB#15:                                # %save_time
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.wrap/i64	$push119=, $11
	tee_local	$push118=, $10=, $pop119
	i32.eqz 	$push188=, $pop118
	br_if   	0, $pop188      # 0: down to label14
# BB#16:                                # %cleanup.cont65
                                        #   in Loop: Header=BB2_1 Depth=1
	block   	
	i32.wrap/i64	$push122=, $9
	tee_local	$push121=, $1=, $pop122
	i32.const	$push120=, 2147483647
	i32.and 	$push28=, $pop121, $pop120
	br_if   	0, $pop28       # 0: down to label16
# BB#17:                                # %cleanup.cont65
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push123=, -1
	i32.eq  	$push29=, $10, $pop123
	br_if   	1, $pop29       # 1: down to label14
.LBB2_18:                               # %if.end79
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label16:
	i32.rem_s	$push131=, $1, $10
	tee_local	$push130=, $4=, $pop131
	i32.const	$push129=, 31
	i32.shr_s	$push128=, $4, $pop129
	tee_local	$push127=, $6=, $pop128
	i32.add 	$push32=, $pop130, $pop127
	i32.xor 	$push33=, $pop32, $6
	i32.const	$push126=, 31
	i32.shr_s	$push125=, $10, $pop126
	tee_local	$push124=, $6=, $pop125
	i32.add 	$push30=, $10, $pop124
	i32.xor 	$push31=, $pop30, $6
	i32.ge_u	$push34=, $pop33, $pop31
	br_if   	3, $pop34       # 3: down to label5
# BB#19:                                # %lor.lhs.false103
                                        #   in Loop: Header=BB2_1 Depth=1
	block   	
	i32.eqz 	$push189=, $4
	br_if   	0, $pop189      # 0: down to label17
# BB#20:                                # %lor.lhs.false103
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.xor 	$push35=, $4, $1
	i32.const	$push132=, -1
	i32.le_s	$push36=, $pop35, $pop132
	br_if   	4, $pop36       # 4: down to label5
.LBB2_21:                               # %cleanup.cont118
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label17:
	i32.const	$push133=, 65535
	i32.and 	$push37=, $10, $pop133
	i32.eqz 	$push190=, $pop37
	br_if   	0, $pop190      # 0: down to label14
# BB#22:                                # %cleanup.cont158
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push154=, 16
	i32.shl 	$push38=, $1, $pop154
	i32.const	$push153=, 16
	i32.shr_s	$push152=, $pop38, $pop153
	tee_local	$push151=, $5=, $pop152
	i32.const	$push150=, 16
	i32.shl 	$push149=, $10, $pop150
	tee_local	$push148=, $7=, $pop149
	i32.const	$push147=, 16
	i32.shr_s	$push146=, $pop148, $pop147
	tee_local	$push145=, $4=, $pop146
	i32.rem_s	$push39=, $pop151, $pop145
	i32.const	$push144=, 16
	i32.shl 	$push143=, $pop39, $pop144
	tee_local	$push142=, $8=, $pop143
	i32.const	$push141=, 16
	i32.shr_s	$push140=, $pop142, $pop141
	tee_local	$push139=, $6=, $pop140
	i32.const	$push138=, 0
	i32.sub 	$push41=, $pop138, $6
	i32.const	$push137=, -65536
	i32.gt_s	$push40=, $8, $pop137
	i32.select	$push42=, $pop139, $pop41, $pop40
	i32.const	$push136=, 0
	i32.sub 	$push44=, $pop136, $4
	i32.const	$push135=, -65536
	i32.gt_s	$push43=, $7, $pop135
	i32.select	$push45=, $4, $pop44, $pop43
	i32.const	$push134=, 65535
	i32.and 	$push46=, $pop45, $pop134
	i32.ge_s	$push47=, $pop42, $pop46
	br_if   	4, $pop47       # 4: down to label4
# BB#23:                                # %lor.lhs.false197
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push48=, $5, $4
	i32.mul 	$push49=, $pop48, $4
	i32.add 	$push50=, $pop49, $6
	i32.const	$push156=, 16
	i32.shl 	$push51=, $pop50, $pop156
	i32.const	$push155=, 16
	i32.shr_s	$push52=, $pop51, $pop155
	i32.ne  	$push53=, $pop52, $5
	br_if   	4, $pop53       # 4: down to label4
# BB#24:                                # %if.end209
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push157=, 255
	i32.and 	$push55=, $10, $pop157
	i32.eqz 	$push191=, $pop55
	br_if   	0, $pop191      # 0: down to label14
# BB#25:                                # %cleanup.cont249
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push178=, 24
	i32.shl 	$push56=, $1, $pop178
	i32.const	$push177=, 24
	i32.shr_s	$push176=, $pop56, $pop177
	tee_local	$push175=, $4=, $pop176
	i32.const	$push174=, 24
	i32.shl 	$push173=, $10, $pop174
	tee_local	$push172=, $6=, $pop173
	i32.const	$push171=, 24
	i32.shr_s	$push170=, $pop172, $pop171
	tee_local	$push169=, $10=, $pop170
	i32.rem_s	$push57=, $pop175, $pop169
	i32.const	$push168=, 24
	i32.shl 	$push167=, $pop57, $pop168
	tee_local	$push166=, $5=, $pop167
	i32.const	$push165=, 24
	i32.shr_s	$push164=, $pop166, $pop165
	tee_local	$push163=, $1=, $pop164
	i32.const	$push162=, 0
	i32.sub 	$push59=, $pop162, $1
	i32.const	$push161=, -16777216
	i32.gt_s	$push58=, $5, $pop161
	i32.select	$push60=, $pop163, $pop59, $pop58
	i32.const	$push160=, 0
	i32.sub 	$push62=, $pop160, $10
	i32.const	$push159=, -16777216
	i32.gt_s	$push61=, $6, $pop159
	i32.select	$push63=, $10, $pop62, $pop61
	i32.const	$push158=, 255
	i32.and 	$push64=, $pop63, $pop158
	i32.ge_s	$push65=, $pop60, $pop64
	br_if   	5, $pop65       # 5: down to label3
# BB#26:                                # %lor.lhs.false288
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push66=, $4, $10
	i32.mul 	$push67=, $pop66, $10
	i32.add 	$push68=, $pop67, $1
	i32.const	$push180=, 24
	i32.shl 	$push69=, $pop68, $pop180
	i32.const	$push179=, 24
	i32.shr_s	$push70=, $pop69, $pop179
	i32.ne  	$push71=, $pop70, $4
	br_if   	5, $pop71       # 5: down to label3
.LBB2_27:                               # %cleanup301
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label14:
	i64.const	$push184=, 1
	i64.add 	$push183=, $0, $pop184
	tee_local	$push182=, $0=, $pop183
	i64.const	$push181=, 10000
	i64.lt_s	$push74=, $pop182, $pop181
	br_if   	0, $pop74       # 0: up to label7
# BB#28:                                # %for.end
	end_loop
	i32.const	$push75=, 0
	i64.store	simple_rand.seed($pop75), $2
	i32.const	$push185=, 0
	call    	exit@FUNCTION, $pop185
	unreachable
.LBB2_29:                               # %if.then32
	end_block                       # label6:
	i32.const	$push27=, 0
	i64.store	simple_rand.seed($pop27), $2
	call    	abort@FUNCTION
	unreachable
.LBB2_30:                               # %if.then111
	end_block                       # label5:
	i32.const	$push73=, 0
	i64.store	simple_rand.seed($pop73), $2
	call    	abort@FUNCTION
	unreachable
.LBB2_31:                               # %if.then208
	end_block                       # label4:
	i32.const	$push54=, 0
	i64.store	simple_rand.seed($pop54), $2
	call    	abort@FUNCTION
	unreachable
.LBB2_32:                               # %if.then299
	end_block                       # label3:
	i32.const	$push72=, 0
	i64.store	simple_rand.seed($pop72), $2
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	simple_rand.seed,@object # @simple_rand.seed
	.section	.data.simple_rand.seed,"aw",@progbits
	.p2align	3
simple_rand.seed:
	.int64	47114711                # 0x2cee9d7
	.size	simple_rand.seed, 8


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
