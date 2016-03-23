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
	.local  	i64, i64, i32, i32, i64
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.const	$push10=, 0
	i64.load	$0=, simple_rand.seed($pop10)
	i64.const	$1=, 0
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
	i32.const	$push24=, 0
	i32.eq  	$push25=, $pop11, $pop24
	br_if   	1, $pop25       # 1: down to label1
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i64.const	$push20=, 15
	i64.and 	$push2=, $4, $pop20
	i64.shl 	$1=, $1, $pop2
	i32.add 	$2=, $3, $2
	block
	i64.const	$push19=, 256
	i64.and 	$push3=, $0, $pop19
	i64.eqz 	$push4=, $pop3
	br_if   	0, $pop4        # 0: down to label2
# BB#3:                                 # %if.then2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push22=, 1
	i32.shl 	$push5=, $pop22, $3
	i32.const	$push21=, -1
	i32.add 	$push6=, $pop5, $pop21
	i64.extend_s/i32	$push7=, $pop6
	i64.or  	$1=, $pop7, $1
.LBB1_4:                                # %if.end
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.const	$push23=, 71
	i32.lt_u	$push8=, $2, $pop23
	br_if   	0, $pop8        # 0: up to label0
.LBB1_5:                                # %cleanup
	end_loop                        # label1:
	i32.const	$push9=, 0
	i64.store	$discard=, simple_rand.seed($pop9), $0
	return  	$1
	.endfunc
.Lfunc_end1:
	.size	random_bitstring, .Lfunc_end1-random_bitstring

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i32, i32, i64, i32, i64, i32, i64, i64, i32, i32, i32
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
	i64.const	$4=, 0
	i32.const	$5=, 0
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
	i32.const	$push172=, 0
	i32.eq  	$push173=, $pop77, $pop172
	br_if   	1, $pop173      # 1: down to label10
# BB#3:                                 # %if.else.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i64.const	$push86=, 15
	i64.and 	$push2=, $6, $pop86
	i64.shl 	$4=, $4, $pop2
	i32.add 	$5=, $7, $5
	block
	i64.const	$push85=, 256
	i64.and 	$push3=, $1, $pop85
	i64.eqz 	$push4=, $pop3
	br_if   	0, $pop4        # 0: down to label11
# BB#4:                                 # %if.then2.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.const	$push88=, 1
	i32.shl 	$push5=, $pop88, $7
	i32.const	$push87=, -1
	i32.add 	$push6=, $pop5, $pop87
	i64.extend_s/i32	$push7=, $pop6
	i64.or  	$4=, $pop7, $4
.LBB2_5:                                # %if.end.i
                                        #   in Loop: Header=BB2_2 Depth=2
	end_block                       # label11:
	i32.const	$push89=, 71
	i32.lt_u	$push8=, $5, $pop89
	br_if   	0, $pop8        # 0: up to label9
.LBB2_6:                                # %random_bitstring.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label10:
	i64.const	$6=, 0
	i32.const	$5=, 0
.LBB2_7:                                # %for.cond.i452
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label12:
	i64.const	$push97=, 1103515245
	i64.mul 	$push9=, $1, $pop97
	i64.const	$push96=, 12345
	i64.add 	$1=, $pop9, $pop96
	i64.const	$push95=, 9
	i64.shr_u	$push94=, $1, $pop95
	tee_local	$push93=, $8=, $pop94
	i32.wrap/i64	$push10=, $pop93
	i32.const	$push92=, 15
	i32.and 	$push91=, $pop10, $pop92
	tee_local	$push90=, $7=, $pop91
	i32.const	$push174=, 0
	i32.eq  	$push175=, $pop90, $pop174
	br_if   	1, $pop175      # 1: down to label13
# BB#8:                                 # %if.else.i457
                                        #   in Loop: Header=BB2_7 Depth=2
	i64.const	$push99=, 15
	i64.and 	$push11=, $8, $pop99
	i64.shl 	$6=, $6, $pop11
	i32.add 	$5=, $7, $5
	block
	i64.const	$push98=, 256
	i64.and 	$push12=, $1, $pop98
	i64.eqz 	$push13=, $pop12
	br_if   	0, $pop13       # 0: down to label14
# BB#9:                                 # %if.then2.i462
                                        #   in Loop: Header=BB2_7 Depth=2
	i32.const	$push101=, 1
	i32.shl 	$push14=, $pop101, $7
	i32.const	$push100=, -1
	i32.add 	$push15=, $pop14, $pop100
	i64.extend_s/i32	$push16=, $pop15
	i64.or  	$6=, $pop16, $6
.LBB2_10:                               # %if.end.i465
                                        #   in Loop: Header=BB2_7 Depth=2
	end_block                       # label14:
	i32.const	$push102=, 71
	i32.lt_u	$push17=, $5, $pop102
	br_if   	0, $pop17       # 0: up to label12
.LBB2_11:                               # %random_bitstring.exit467
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label13:
	block
	i64.eqz 	$push18=, $6
	br_if   	0, $pop18       # 0: down to label15
# BB#12:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i64.const	$push104=, 9223372036854775807
	i64.and 	$push19=, $4, $pop104
	i64.const	$push103=, 0
	i64.ne  	$push20=, $pop19, $pop103
	br_if   	0, $pop20       # 0: down to label16
# BB#13:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	i64.const	$push105=, -1
	i64.eq  	$push21=, $6, $pop105
	br_if   	1, $pop21       # 1: down to label15
.LBB2_14:                               # %if.end17
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label16:
	i64.rem_s	$8=, $4, $6
	i64.const	$push111=, 63
	i64.shr_s	$push110=, $8, $pop111
	tee_local	$push109=, $9=, $pop110
	i64.add 	$push24=, $8, $pop109
	i64.xor 	$push25=, $pop24, $9
	i64.const	$push108=, 63
	i64.shr_s	$push107=, $6, $pop108
	tee_local	$push106=, $8=, $pop107
	i64.add 	$push22=, $6, $pop106
	i64.xor 	$push23=, $pop22, $8
	i64.ge_u	$push26=, $pop25, $pop23
	br_if   	3, $pop26       # 3: down to label6
# BB#15:                                # %save_time
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.wrap/i64	$push113=, $6
	tee_local	$push112=, $5=, $pop113
	i32.const	$push176=, 0
	i32.eq  	$push177=, $pop112, $pop176
	br_if   	0, $pop177      # 0: down to label15
# BB#16:                                # %cleanup.cont65
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i32.wrap/i64	$push116=, $4
	tee_local	$push115=, $7=, $pop116
	i32.const	$push114=, 2147483647
	i32.and 	$push28=, $pop115, $pop114
	br_if   	0, $pop28       # 0: down to label17
# BB#17:                                # %cleanup.cont65
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push117=, -1
	i32.eq  	$push29=, $5, $pop117
	br_if   	1, $pop29       # 1: down to label15
.LBB2_18:                               # %if.end79
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label17:
	i32.rem_s	$2=, $7, $5
	i32.const	$push123=, 31
	i32.shr_s	$push122=, $2, $pop123
	tee_local	$push121=, $3=, $pop122
	i32.add 	$push32=, $2, $pop121
	i32.xor 	$push33=, $pop32, $3
	i32.const	$push120=, 31
	i32.shr_s	$push119=, $5, $pop120
	tee_local	$push118=, $3=, $pop119
	i32.add 	$push30=, $5, $pop118
	i32.xor 	$push31=, $pop30, $3
	i32.ge_u	$push34=, $pop33, $pop31
	br_if   	4, $pop34       # 4: down to label5
# BB#19:                                # %lor.lhs.false103
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i32.const	$push178=, 0
	i32.eq  	$push179=, $2, $pop178
	br_if   	0, $pop179      # 0: down to label18
# BB#20:                                # %lor.lhs.false103
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.xor 	$push35=, $2, $7
	i32.const	$push124=, -1
	i32.le_s	$push36=, $pop35, $pop124
	br_if   	5, $pop36       # 5: down to label5
.LBB2_21:                               # %cleanup.cont118
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label18:
	i32.const	$push125=, 65535
	i32.and 	$push37=, $5, $pop125
	i32.const	$push180=, 0
	i32.eq  	$push181=, $pop37, $pop180
	br_if   	0, $pop181      # 0: down to label15
# BB#22:                                # %cleanup.cont158
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push144=, 16
	i32.shl 	$push38=, $7, $pop144
	i32.const	$push143=, 16
	i32.shr_s	$push142=, $pop38, $pop143
	tee_local	$push141=, $12=, $pop142
	i32.const	$push140=, 16
	i32.shl 	$push139=, $5, $pop140
	tee_local	$push138=, $11=, $pop139
	i32.const	$push137=, 16
	i32.shr_s	$push136=, $pop138, $pop137
	tee_local	$push135=, $2=, $pop136
	i32.rem_s	$push39=, $pop141, $pop135
	i32.const	$push134=, 16
	i32.shl 	$push133=, $pop39, $pop134
	tee_local	$push132=, $10=, $pop133
	i32.const	$push131=, 16
	i32.shr_s	$3=, $pop132, $pop131
	i32.const	$push130=, 0
	i32.sub 	$push41=, $pop130, $3
	i32.const	$push129=, -65536
	i32.gt_s	$push40=, $10, $pop129
	i32.select	$push42=, $3, $pop41, $pop40
	i32.const	$push128=, 0
	i32.sub 	$push44=, $pop128, $2
	i32.const	$push127=, -65536
	i32.gt_s	$push43=, $11, $pop127
	i32.select	$push45=, $2, $pop44, $pop43
	i32.const	$push126=, 65535
	i32.and 	$push46=, $pop45, $pop126
	i32.ge_s	$push47=, $pop42, $pop46
	br_if   	5, $pop47       # 5: down to label4
# BB#23:                                # %lor.lhs.false197
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push48=, $12, $2
	i32.mul 	$push49=, $pop48, $2
	i32.add 	$push50=, $pop49, $3
	i32.const	$push146=, 16
	i32.shl 	$push51=, $pop50, $pop146
	i32.const	$push145=, 16
	i32.shr_s	$push52=, $pop51, $pop145
	i32.ne  	$push53=, $pop52, $12
	br_if   	5, $pop53       # 5: down to label4
# BB#24:                                # %if.end209
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push147=, 255
	i32.and 	$push55=, $5, $pop147
	i32.const	$push182=, 0
	i32.eq  	$push183=, $pop55, $pop182
	br_if   	0, $pop183      # 0: down to label15
# BB#25:                                # %cleanup.cont249
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push166=, 24
	i32.shl 	$push56=, $7, $pop166
	i32.const	$push165=, 24
	i32.shr_s	$push164=, $pop56, $pop165
	tee_local	$push163=, $2=, $pop164
	i32.const	$push162=, 24
	i32.shl 	$push161=, $5, $pop162
	tee_local	$push160=, $3=, $pop161
	i32.const	$push159=, 24
	i32.shr_s	$push158=, $pop160, $pop159
	tee_local	$push157=, $5=, $pop158
	i32.rem_s	$push57=, $pop163, $pop157
	i32.const	$push156=, 24
	i32.shl 	$push155=, $pop57, $pop156
	tee_local	$push154=, $12=, $pop155
	i32.const	$push153=, 24
	i32.shr_s	$7=, $pop154, $pop153
	i32.const	$push152=, 0
	i32.sub 	$push59=, $pop152, $7
	i32.const	$push151=, -16777216
	i32.gt_s	$push58=, $12, $pop151
	i32.select	$push60=, $7, $pop59, $pop58
	i32.const	$push150=, 0
	i32.sub 	$push62=, $pop150, $5
	i32.const	$push149=, -16777216
	i32.gt_s	$push61=, $3, $pop149
	i32.select	$push63=, $5, $pop62, $pop61
	i32.const	$push148=, 255
	i32.and 	$push64=, $pop63, $pop148
	i32.ge_s	$push65=, $pop60, $pop64
	br_if   	6, $pop65       # 6: down to label3
# BB#26:                                # %lor.lhs.false288
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push66=, $2, $5
	i32.mul 	$push67=, $pop66, $5
	i32.add 	$push68=, $pop67, $7
	i32.const	$push168=, 24
	i32.shl 	$push69=, $pop68, $pop168
	i32.const	$push167=, 24
	i32.shr_s	$push70=, $pop69, $pop167
	i32.ne  	$push71=, $pop70, $2
	br_if   	6, $pop71       # 6: down to label3
.LBB2_27:                               # %cleanup301
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label15:
	i64.const	$push170=, 1
	i64.add 	$0=, $0, $pop170
	i64.const	$push169=, 10000
	i64.lt_s	$push74=, $0, $pop169
	br_if   	0, $pop74       # 0: up to label7
# BB#28:                                # %for.end
	end_loop                        # label8:
	i32.const	$push75=, 0
	i64.store	$discard=, simple_rand.seed($pop75), $1
	i32.const	$push171=, 0
	call    	exit@FUNCTION, $pop171
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
