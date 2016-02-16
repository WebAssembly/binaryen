	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/arith-rand-ll.c"
	.section	.text.simple_rand,"ax",@progbits
	.hidden	simple_rand
	.globl	simple_rand
	.type	simple_rand,@function
simple_rand:                            # @simple_rand
	.result 	i64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push9=, 0
	i64.load	$push1=, simple_rand.seed($pop9)
	i64.const	$push2=, 1103515245
	i64.mul 	$push3=, $pop1, $pop2
	i64.const	$push4=, 12345
	i64.add 	$push5=, $pop3, $pop4
	i64.store	$push6=, simple_rand.seed($pop0), $pop5
	i64.const	$push7=, 8
	i64.shr_u	$push8=, $pop6, $pop7
	return  	$pop8
	.endfunc
.Lfunc_end0:
	.size	simple_rand, .Lfunc_end0-simple_rand

	.section	.text.random_bitstring,"ax",@progbits
	.hidden	random_bitstring
	.globl	random_bitstring
	.type	random_bitstring,@function
random_bitstring:                       # @random_bitstring
	.result 	i64
	.local  	i64, i32, i64, i32, i64
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$push10=, 0
	i64.load	$0=, simple_rand.seed($pop10)
	i64.const	$2=, 0
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i64.const	$push18=, 1103515245
	i64.mul 	$push0=, $0, $pop18
	i64.const	$push17=, 12345
	i64.add 	$0=, $pop0, $pop17
	i64.const	$push16=, 9
	i64.shr_u	$push15=, $0, $pop16
	tee_local	$push14=, $4=, $pop15
	i32.wrap/i64	$push1=, $pop14
	i32.const	$push13=, 15
	i32.and 	$push12=, $pop1, $pop13
	tee_local	$push11=, $3=, $pop12
	i32.const	$push25=, 0
	i32.eq  	$push26=, $pop11, $pop25
	br_if   	1, $pop26       # 1: down to label1
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i64.const	$push21=, 15
	i64.and 	$push2=, $4, $pop21
	i64.shl 	$2=, $2, $pop2
	i32.add 	$1=, $3, $1
	block
	i64.const	$push20=, 256
	i64.and 	$push3=, $0, $pop20
	i64.const	$push19=, 0
	i64.eq  	$push4=, $pop3, $pop19
	br_if   	0, $pop4        # 0: down to label2
# BB#3:                                 # %if.then2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push23=, 1
	i32.shl 	$push5=, $pop23, $3
	i32.const	$push22=, -1
	i32.add 	$push6=, $pop5, $pop22
	i64.extend_s/i32	$push7=, $pop6
	i64.or  	$2=, $pop7, $2
.LBB1_4:                                # %if.end
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.const	$push24=, 71
	i32.lt_u	$push8=, $1, $pop24
	br_if   	0, $pop8        # 0: up to label0
.LBB1_5:                                # %cleanup
	end_loop                        # label1:
	i32.const	$push9=, 0
	i64.store	$discard=, simple_rand.seed($pop9), $0
	return  	$2
	.endfunc
.Lfunc_end1:
	.size	random_bitstring, .Lfunc_end1-random_bitstring

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i32, i32, i32, i64, i64, i32, i64, i64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push76=, 0
	i64.load	$1=, simple_rand.seed($pop76)
	i64.const	$0=, 0
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
                                        #     Child Loop BB2_7 Depth 2
	block
	block
	block
	block
	loop                            # label7:
	i64.const	$5=, 0
	i32.const	$4=, 0
.LBB2_2:                                # %for.cond.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label9:
	i64.const	$push84=, 1103515245
	i64.mul 	$push0=, $1, $pop84
	i64.const	$push83=, 12345
	i64.add 	$1=, $pop0, $pop83
	i64.const	$push82=, 9
	i64.shr_u	$push81=, $1, $pop82
	tee_local	$push80=, $6=, $pop81
	i32.wrap/i64	$push1=, $pop80
	i32.const	$push79=, 15
	i32.and 	$push78=, $pop1, $pop79
	tee_local	$push77=, $7=, $pop78
	i32.const	$push175=, 0
	i32.eq  	$push176=, $pop77, $pop175
	br_if   	1, $pop176      # 1: down to label10
# BB#3:                                 # %if.else.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i64.const	$push87=, 15
	i64.and 	$push2=, $6, $pop87
	i64.shl 	$5=, $5, $pop2
	i32.add 	$4=, $7, $4
	block
	i64.const	$push86=, 256
	i64.and 	$push3=, $1, $pop86
	i64.const	$push85=, 0
	i64.eq  	$push4=, $pop3, $pop85
	br_if   	0, $pop4        # 0: down to label11
# BB#4:                                 # %if.then2.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.const	$push89=, 1
	i32.shl 	$push5=, $pop89, $7
	i32.const	$push88=, -1
	i32.add 	$push6=, $pop5, $pop88
	i64.extend_s/i32	$push7=, $pop6
	i64.or  	$5=, $pop7, $5
.LBB2_5:                                # %if.end.i
                                        #   in Loop: Header=BB2_2 Depth=2
	end_block                       # label11:
	i32.const	$push90=, 71
	i32.lt_u	$push8=, $4, $pop90
	br_if   	0, $pop8        # 0: up to label9
.LBB2_6:                                # %random_bitstring.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label10:
	i64.const	$6=, 0
	i32.const	$4=, 0
.LBB2_7:                                # %for.cond.i452
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label12:
	i64.const	$push98=, 1103515245
	i64.mul 	$push9=, $1, $pop98
	i64.const	$push97=, 12345
	i64.add 	$1=, $pop9, $pop97
	i64.const	$push96=, 9
	i64.shr_u	$push95=, $1, $pop96
	tee_local	$push94=, $8=, $pop95
	i32.wrap/i64	$push10=, $pop94
	i32.const	$push93=, 15
	i32.and 	$push92=, $pop10, $pop93
	tee_local	$push91=, $7=, $pop92
	i32.const	$push177=, 0
	i32.eq  	$push178=, $pop91, $pop177
	br_if   	1, $pop178      # 1: down to label13
# BB#8:                                 # %if.else.i457
                                        #   in Loop: Header=BB2_7 Depth=2
	i64.const	$push101=, 15
	i64.and 	$push11=, $8, $pop101
	i64.shl 	$6=, $6, $pop11
	i32.add 	$4=, $7, $4
	block
	i64.const	$push100=, 256
	i64.and 	$push12=, $1, $pop100
	i64.const	$push99=, 0
	i64.eq  	$push13=, $pop12, $pop99
	br_if   	0, $pop13       # 0: down to label14
# BB#9:                                 # %if.then2.i462
                                        #   in Loop: Header=BB2_7 Depth=2
	i32.const	$push103=, 1
	i32.shl 	$push14=, $pop103, $7
	i32.const	$push102=, -1
	i32.add 	$push15=, $pop14, $pop102
	i64.extend_s/i32	$push16=, $pop15
	i64.or  	$6=, $pop16, $6
.LBB2_10:                               # %if.end.i465
                                        #   in Loop: Header=BB2_7 Depth=2
	end_block                       # label14:
	i32.const	$push104=, 71
	i32.lt_u	$push17=, $4, $pop104
	br_if   	0, $pop17       # 0: up to label12
.LBB2_11:                               # %random_bitstring.exit467
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label13:
	block
	i64.const	$push105=, 0
	i64.eq  	$push18=, $6, $pop105
	br_if   	0, $pop18       # 0: down to label15
# BB#12:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i64.const	$push107=, 9223372036854775807
	i64.and 	$push19=, $5, $pop107
	i64.const	$push106=, 0
	i64.ne  	$push20=, $pop19, $pop106
	br_if   	0, $pop20       # 0: down to label16
# BB#13:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	i64.const	$push108=, -1
	i64.eq  	$push21=, $6, $pop108
	br_if   	1, $pop21       # 1: down to label15
.LBB2_14:                               # %if.end17
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label16:
	i64.rem_s	$8=, $5, $6
	i64.const	$push114=, 63
	i64.shr_s	$push113=, $8, $pop114
	tee_local	$push112=, $9=, $pop113
	i64.add 	$push24=, $8, $pop112
	i64.xor 	$push25=, $pop24, $9
	i64.const	$push111=, 63
	i64.shr_s	$push110=, $6, $pop111
	tee_local	$push109=, $8=, $pop110
	i64.add 	$push22=, $6, $pop109
	i64.xor 	$push23=, $pop22, $8
	i64.ge_u	$push26=, $pop25, $pop23
	br_if   	3, $pop26       # 3: down to label6
# BB#15:                                # %save_time
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.wrap/i64	$push116=, $6
	tee_local	$push115=, $4=, $pop116
	i32.const	$push179=, 0
	i32.eq  	$push180=, $pop115, $pop179
	br_if   	0, $pop180      # 0: down to label15
# BB#16:                                # %cleanup.cont65
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i32.wrap/i64	$push119=, $5
	tee_local	$push118=, $7=, $pop119
	i32.const	$push117=, 2147483647
	i32.and 	$push28=, $pop118, $pop117
	br_if   	0, $pop28       # 0: down to label17
# BB#17:                                # %cleanup.cont65
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push120=, -1
	i32.eq  	$push29=, $4, $pop120
	br_if   	1, $pop29       # 1: down to label15
.LBB2_18:                               # %if.end79
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label17:
	i32.rem_s	$2=, $7, $4
	i32.const	$push126=, 31
	i32.shr_s	$push125=, $2, $pop126
	tee_local	$push124=, $3=, $pop125
	i32.add 	$push32=, $2, $pop124
	i32.xor 	$push33=, $pop32, $3
	i32.const	$push123=, 31
	i32.shr_s	$push122=, $4, $pop123
	tee_local	$push121=, $3=, $pop122
	i32.add 	$push30=, $4, $pop121
	i32.xor 	$push31=, $pop30, $3
	i32.ge_u	$push34=, $pop33, $pop31
	br_if   	4, $pop34       # 4: down to label5
# BB#19:                                # %lor.lhs.false103
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i32.const	$push181=, 0
	i32.eq  	$push182=, $2, $pop181
	br_if   	0, $pop182      # 0: down to label18
# BB#20:                                # %lor.lhs.false103
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.xor 	$push35=, $2, $7
	i32.const	$push127=, -1
	i32.le_s	$push36=, $pop35, $pop127
	br_if   	5, $pop36       # 5: down to label5
.LBB2_21:                               # %cleanup.cont118
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label18:
	i32.const	$push128=, 65535
	i32.and 	$push37=, $4, $pop128
	i32.const	$push183=, 0
	i32.eq  	$push184=, $pop37, $pop183
	br_if   	0, $pop184      # 0: down to label15
# BB#22:                                # %cleanup.cont158
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push147=, 16
	i32.shl 	$push38=, $7, $pop147
	i32.const	$push146=, 16
	i32.shr_s	$push145=, $pop38, $pop146
	tee_local	$push144=, $12=, $pop145
	i32.const	$push143=, 16
	i32.shl 	$push142=, $4, $pop143
	tee_local	$push141=, $11=, $pop142
	i32.const	$push140=, 16
	i32.shr_s	$push139=, $pop141, $pop140
	tee_local	$push138=, $2=, $pop139
	i32.rem_s	$push39=, $pop144, $pop138
	i32.const	$push137=, 16
	i32.shl 	$push136=, $pop39, $pop137
	tee_local	$push135=, $10=, $pop136
	i32.const	$push134=, 16
	i32.shr_s	$3=, $pop135, $pop134
	i32.const	$push133=, 0
	i32.sub 	$push41=, $pop133, $3
	i32.const	$push132=, -65536
	i32.gt_s	$push40=, $10, $pop132
	i32.select	$push42=, $3, $pop41, $pop40
	i32.const	$push131=, 0
	i32.sub 	$push44=, $pop131, $2
	i32.const	$push130=, -65536
	i32.gt_s	$push43=, $11, $pop130
	i32.select	$push45=, $2, $pop44, $pop43
	i32.const	$push129=, 65535
	i32.and 	$push46=, $pop45, $pop129
	i32.ge_s	$push47=, $pop42, $pop46
	br_if   	5, $pop47       # 5: down to label4
# BB#23:                                # %lor.lhs.false197
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push48=, $12, $2
	i32.mul 	$push49=, $pop48, $2
	i32.add 	$push50=, $pop49, $3
	i32.const	$push149=, 16
	i32.shl 	$push51=, $pop50, $pop149
	i32.const	$push148=, 16
	i32.shr_s	$push52=, $pop51, $pop148
	i32.ne  	$push53=, $pop52, $12
	br_if   	5, $pop53       # 5: down to label4
# BB#24:                                # %if.end209
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push150=, 255
	i32.and 	$push55=, $4, $pop150
	i32.const	$push185=, 0
	i32.eq  	$push186=, $pop55, $pop185
	br_if   	0, $pop186      # 0: down to label15
# BB#25:                                # %cleanup.cont249
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push169=, 24
	i32.shl 	$push56=, $7, $pop169
	i32.const	$push168=, 24
	i32.shr_s	$push167=, $pop56, $pop168
	tee_local	$push166=, $2=, $pop167
	i32.const	$push165=, 24
	i32.shl 	$push164=, $4, $pop165
	tee_local	$push163=, $3=, $pop164
	i32.const	$push162=, 24
	i32.shr_s	$push161=, $pop163, $pop162
	tee_local	$push160=, $4=, $pop161
	i32.rem_s	$push57=, $pop166, $pop160
	i32.const	$push159=, 24
	i32.shl 	$push158=, $pop57, $pop159
	tee_local	$push157=, $12=, $pop158
	i32.const	$push156=, 24
	i32.shr_s	$7=, $pop157, $pop156
	i32.const	$push155=, 0
	i32.sub 	$push59=, $pop155, $7
	i32.const	$push154=, -16777216
	i32.gt_s	$push58=, $12, $pop154
	i32.select	$push60=, $7, $pop59, $pop58
	i32.const	$push153=, 0
	i32.sub 	$push62=, $pop153, $4
	i32.const	$push152=, -16777216
	i32.gt_s	$push61=, $3, $pop152
	i32.select	$push63=, $4, $pop62, $pop61
	i32.const	$push151=, 255
	i32.and 	$push64=, $pop63, $pop151
	i32.ge_s	$push65=, $pop60, $pop64
	br_if   	6, $pop65       # 6: down to label3
# BB#26:                                # %lor.lhs.false288
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push66=, $2, $4
	i32.mul 	$push67=, $pop66, $4
	i32.add 	$push68=, $pop67, $7
	i32.const	$push171=, 24
	i32.shl 	$push69=, $pop68, $pop171
	i32.const	$push170=, 24
	i32.shr_s	$push70=, $pop69, $pop170
	i32.ne  	$push71=, $pop70, $2
	br_if   	6, $pop71       # 6: down to label3
.LBB2_27:                               # %cleanup301
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label15:
	i64.const	$push173=, 1
	i64.add 	$0=, $0, $pop173
	i64.const	$push172=, 10000
	i64.lt_s	$push74=, $0, $pop172
	br_if   	0, $pop74       # 0: up to label7
# BB#28:                                # %for.end
	end_loop                        # label8:
	i32.const	$push75=, 0
	i64.store	$discard=, simple_rand.seed($pop75), $1
	i32.const	$push174=, 0
	call    	exit@FUNCTION, $pop174
	unreachable
.LBB2_29:                               # %if.then32
	end_block                       # label6:
	i32.const	$push27=, 0
	i64.store	$discard=, simple_rand.seed($pop27), $1
	call    	abort@FUNCTION
	unreachable
.LBB2_30:                               # %if.then111
	end_block                       # label5:
	i32.const	$push73=, 0
	i64.store	$discard=, simple_rand.seed($pop73), $1
	call    	abort@FUNCTION
	unreachable
.LBB2_31:                               # %if.then208
	end_block                       # label4:
	i32.const	$push54=, 0
	i64.store	$discard=, simple_rand.seed($pop54), $1
	call    	abort@FUNCTION
	unreachable
.LBB2_32:                               # %if.then299
	end_block                       # label3:
	i32.const	$push72=, 0
	i64.store	$discard=, simple_rand.seed($pop72), $1
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


	.ident	"clang version 3.9.0 "
