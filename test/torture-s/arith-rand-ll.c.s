	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/arith-rand-ll.c"
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
	i64.store	$discard=, simple_rand.seed($pop0), $pop7
	i64.const	$push5=, 8
	i64.shr_u	$push6=, $0, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end0:
	.size	simple_rand, .Lfunc_end0-simple_rand

	.section	.text.random_bitstring,"ax",@progbits
	.hidden	random_bitstring
	.globl	random_bitstring
	.type	random_bitstring,@function
random_bitstring:                       # @random_bitstring
	.result 	i64
	.local  	i64, i32, i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$push10=, 0
	i64.load	$4=, simple_rand.seed($pop10)
	i64.const	$0=, 0
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i64.const	$push20=, 1103515245
	i64.mul 	$push0=, $4, $pop20
	i64.const	$push19=, 12345
	i64.add 	$push18=, $pop0, $pop19
	tee_local	$push17=, $4=, $pop18
	i64.const	$push16=, 9
	i64.shr_u	$push15=, $pop17, $pop16
	tee_local	$push14=, $3=, $pop15
	i32.wrap/i64	$push1=, $pop14
	i32.const	$push13=, 15
	i32.and 	$push12=, $pop1, $pop13
	tee_local	$push11=, $2=, $pop12
	i32.eqz 	$push26=, $pop11
	br_if   	1, $pop26       # 1: down to label1
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i64.const	$push22=, 15
	i64.and 	$push2=, $3, $pop22
	i64.shl 	$0=, $0, $pop2
	i32.add 	$1=, $2, $1
	block
	i64.const	$push21=, 256
	i64.and 	$push3=, $4, $pop21
	i64.eqz 	$push4=, $pop3
	br_if   	0, $pop4        # 0: down to label2
# BB#3:                                 # %if.then2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push24=, 1
	i32.shl 	$push5=, $pop24, $2
	i32.const	$push23=, -1
	i32.add 	$push6=, $pop5, $pop23
	i64.extend_s/i32	$push7=, $pop6
	i64.or  	$0=, $pop7, $0
.LBB1_4:                                # %if.end
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.const	$push25=, 71
	i32.lt_u	$push8=, $1, $pop25
	br_if   	0, $pop8        # 0: up to label0
.LBB1_5:                                # %cleanup
	end_loop                        # label1:
	i32.const	$push9=, 0
	i64.store	$discard=, simple_rand.seed($pop9), $4
	return  	$0
	.endfunc
.Lfunc_end1:
	.size	random_bitstring, .Lfunc_end1-random_bitstring

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i64, i32, i64, i32, i64, i64, i64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push76=, 0
	i64.load	$8=, simple_rand.seed($pop76)
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
	i64.const	$3=, 0
	i32.const	$4=, 0
.LBB2_2:                                # %for.cond.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label9:
	i64.const	$push86=, 1103515245
	i64.mul 	$push0=, $8, $pop86
	i64.const	$push85=, 12345
	i64.add 	$push84=, $pop0, $pop85
	tee_local	$push83=, $8=, $pop84
	i64.const	$push82=, 9
	i64.shr_u	$push81=, $pop83, $pop82
	tee_local	$push80=, $5=, $pop81
	i32.wrap/i64	$push1=, $pop80
	i32.const	$push79=, 15
	i32.and 	$push78=, $pop1, $pop79
	tee_local	$push77=, $6=, $pop78
	i32.eqz 	$push176=, $pop77
	br_if   	1, $pop176      # 1: down to label10
# BB#3:                                 # %if.else.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i64.const	$push88=, 15
	i64.and 	$push2=, $5, $pop88
	i64.shl 	$3=, $3, $pop2
	i32.add 	$4=, $6, $4
	block
	i64.const	$push87=, 256
	i64.and 	$push3=, $8, $pop87
	i64.eqz 	$push4=, $pop3
	br_if   	0, $pop4        # 0: down to label11
# BB#4:                                 # %if.then2.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.const	$push90=, 1
	i32.shl 	$push5=, $pop90, $6
	i32.const	$push89=, -1
	i32.add 	$push6=, $pop5, $pop89
	i64.extend_s/i32	$push7=, $pop6
	i64.or  	$3=, $pop7, $3
.LBB2_5:                                # %if.end.i
                                        #   in Loop: Header=BB2_2 Depth=2
	end_block                       # label11:
	i32.const	$push91=, 71
	i32.lt_u	$push8=, $4, $pop91
	br_if   	0, $pop8        # 0: up to label9
.LBB2_6:                                # %random_bitstring.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label10:
	i64.const	$5=, 0
	i32.const	$4=, 0
.LBB2_7:                                # %for.cond.i452
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label12:
	i64.const	$push101=, 1103515245
	i64.mul 	$push9=, $8, $pop101
	i64.const	$push100=, 12345
	i64.add 	$push99=, $pop9, $pop100
	tee_local	$push98=, $8=, $pop99
	i64.const	$push97=, 9
	i64.shr_u	$push96=, $pop98, $pop97
	tee_local	$push95=, $7=, $pop96
	i32.wrap/i64	$push10=, $pop95
	i32.const	$push94=, 15
	i32.and 	$push93=, $pop10, $pop94
	tee_local	$push92=, $6=, $pop93
	i32.eqz 	$push177=, $pop92
	br_if   	1, $pop177      # 1: down to label13
# BB#8:                                 # %if.else.i457
                                        #   in Loop: Header=BB2_7 Depth=2
	i64.const	$push103=, 15
	i64.and 	$push11=, $7, $pop103
	i64.shl 	$5=, $5, $pop11
	i32.add 	$4=, $6, $4
	block
	i64.const	$push102=, 256
	i64.and 	$push12=, $8, $pop102
	i64.eqz 	$push13=, $pop12
	br_if   	0, $pop13       # 0: down to label14
# BB#9:                                 # %if.then2.i462
                                        #   in Loop: Header=BB2_7 Depth=2
	i32.const	$push105=, 1
	i32.shl 	$push14=, $pop105, $6
	i32.const	$push104=, -1
	i32.add 	$push15=, $pop14, $pop104
	i64.extend_s/i32	$push16=, $pop15
	i64.or  	$5=, $pop16, $5
.LBB2_10:                               # %if.end.i465
                                        #   in Loop: Header=BB2_7 Depth=2
	end_block                       # label14:
	i32.const	$push106=, 71
	i32.lt_u	$push17=, $4, $pop106
	br_if   	0, $pop17       # 0: up to label12
.LBB2_11:                               # %random_bitstring.exit467
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label13:
	block
	i64.eqz 	$push18=, $5
	br_if   	0, $pop18       # 0: down to label15
# BB#12:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i64.const	$push108=, 9223372036854775807
	i64.and 	$push19=, $3, $pop108
	i64.const	$push107=, 0
	i64.ne  	$push20=, $pop19, $pop107
	br_if   	0, $pop20       # 0: down to label16
# BB#13:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	i64.const	$push109=, -1
	i64.eq  	$push21=, $5, $pop109
	br_if   	1, $pop21       # 1: down to label15
.LBB2_14:                               # %if.end17
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label16:
	i64.rem_s	$7=, $3, $5
	i64.const	$push115=, 63
	i64.shr_s	$push114=, $7, $pop115
	tee_local	$push113=, $9=, $pop114
	i64.add 	$push24=, $7, $pop113
	i64.xor 	$push25=, $pop24, $9
	i64.const	$push112=, 63
	i64.shr_s	$push111=, $5, $pop112
	tee_local	$push110=, $7=, $pop111
	i64.add 	$push22=, $5, $pop110
	i64.xor 	$push23=, $pop22, $7
	i64.ge_u	$push26=, $pop25, $pop23
	br_if   	3, $pop26       # 3: down to label6
# BB#15:                                # %save_time
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.wrap/i64	$push117=, $5
	tee_local	$push116=, $4=, $pop117
	i32.eqz 	$push178=, $pop116
	br_if   	0, $pop178      # 0: down to label15
# BB#16:                                # %cleanup.cont65
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i32.wrap/i64	$push120=, $3
	tee_local	$push119=, $6=, $pop120
	i32.const	$push118=, 2147483647
	i32.and 	$push28=, $pop119, $pop118
	br_if   	0, $pop28       # 0: down to label17
# BB#17:                                # %cleanup.cont65
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push121=, -1
	i32.eq  	$push29=, $4, $pop121
	br_if   	1, $pop29       # 1: down to label15
.LBB2_18:                               # %if.end79
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label17:
	i32.rem_s	$1=, $6, $4
	i32.const	$push127=, 31
	i32.shr_s	$push126=, $1, $pop127
	tee_local	$push125=, $2=, $pop126
	i32.add 	$push32=, $1, $pop125
	i32.xor 	$push33=, $pop32, $2
	i32.const	$push124=, 31
	i32.shr_s	$push123=, $4, $pop124
	tee_local	$push122=, $2=, $pop123
	i32.add 	$push30=, $4, $pop122
	i32.xor 	$push31=, $pop30, $2
	i32.ge_u	$push34=, $pop33, $pop31
	br_if   	4, $pop34       # 4: down to label5
# BB#19:                                # %lor.lhs.false103
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i32.eqz 	$push179=, $1
	br_if   	0, $pop179      # 0: down to label18
# BB#20:                                # %lor.lhs.false103
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.xor 	$push35=, $1, $6
	i32.const	$push128=, -1
	i32.le_s	$push36=, $pop35, $pop128
	br_if   	5, $pop36       # 5: down to label5
.LBB2_21:                               # %cleanup.cont118
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label18:
	i32.const	$push129=, 65535
	i32.and 	$push37=, $4, $pop129
	i32.eqz 	$push180=, $pop37
	br_if   	0, $pop180      # 0: down to label15
# BB#22:                                # %cleanup.cont158
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push148=, 16
	i32.shl 	$push38=, $6, $pop148
	i32.const	$push147=, 16
	i32.shr_s	$push146=, $pop38, $pop147
	tee_local	$push145=, $12=, $pop146
	i32.const	$push144=, 16
	i32.shl 	$push143=, $4, $pop144
	tee_local	$push142=, $11=, $pop143
	i32.const	$push141=, 16
	i32.shr_s	$push140=, $pop142, $pop141
	tee_local	$push139=, $1=, $pop140
	i32.rem_s	$push39=, $pop145, $pop139
	i32.const	$push138=, 16
	i32.shl 	$push137=, $pop39, $pop138
	tee_local	$push136=, $10=, $pop137
	i32.const	$push135=, 16
	i32.shr_s	$2=, $pop136, $pop135
	i32.const	$push134=, 0
	i32.sub 	$push41=, $pop134, $2
	i32.const	$push133=, -65536
	i32.gt_s	$push40=, $10, $pop133
	i32.select	$push42=, $2, $pop41, $pop40
	i32.const	$push132=, 0
	i32.sub 	$push44=, $pop132, $1
	i32.const	$push131=, -65536
	i32.gt_s	$push43=, $11, $pop131
	i32.select	$push45=, $1, $pop44, $pop43
	i32.const	$push130=, 65535
	i32.and 	$push46=, $pop45, $pop130
	i32.ge_s	$push47=, $pop42, $pop46
	br_if   	5, $pop47       # 5: down to label4
# BB#23:                                # %lor.lhs.false197
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push48=, $12, $1
	i32.mul 	$push49=, $pop48, $1
	i32.add 	$push50=, $pop49, $2
	i32.const	$push150=, 16
	i32.shl 	$push51=, $pop50, $pop150
	i32.const	$push149=, 16
	i32.shr_s	$push52=, $pop51, $pop149
	i32.ne  	$push53=, $pop52, $12
	br_if   	5, $pop53       # 5: down to label4
# BB#24:                                # %if.end209
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push151=, 255
	i32.and 	$push55=, $4, $pop151
	i32.eqz 	$push181=, $pop55
	br_if   	0, $pop181      # 0: down to label15
# BB#25:                                # %cleanup.cont249
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push170=, 24
	i32.shl 	$push56=, $6, $pop170
	i32.const	$push169=, 24
	i32.shr_s	$push168=, $pop56, $pop169
	tee_local	$push167=, $1=, $pop168
	i32.const	$push166=, 24
	i32.shl 	$push165=, $4, $pop166
	tee_local	$push164=, $2=, $pop165
	i32.const	$push163=, 24
	i32.shr_s	$push162=, $pop164, $pop163
	tee_local	$push161=, $4=, $pop162
	i32.rem_s	$push57=, $pop167, $pop161
	i32.const	$push160=, 24
	i32.shl 	$push159=, $pop57, $pop160
	tee_local	$push158=, $12=, $pop159
	i32.const	$push157=, 24
	i32.shr_s	$6=, $pop158, $pop157
	i32.const	$push156=, 0
	i32.sub 	$push59=, $pop156, $6
	i32.const	$push155=, -16777216
	i32.gt_s	$push58=, $12, $pop155
	i32.select	$push60=, $6, $pop59, $pop58
	i32.const	$push154=, 0
	i32.sub 	$push62=, $pop154, $4
	i32.const	$push153=, -16777216
	i32.gt_s	$push61=, $2, $pop153
	i32.select	$push63=, $4, $pop62, $pop61
	i32.const	$push152=, 255
	i32.and 	$push64=, $pop63, $pop152
	i32.ge_s	$push65=, $pop60, $pop64
	br_if   	6, $pop65       # 6: down to label3
# BB#26:                                # %lor.lhs.false288
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push66=, $1, $4
	i32.mul 	$push67=, $pop66, $4
	i32.add 	$push68=, $pop67, $6
	i32.const	$push172=, 24
	i32.shl 	$push69=, $pop68, $pop172
	i32.const	$push171=, 24
	i32.shr_s	$push70=, $pop69, $pop171
	i32.ne  	$push71=, $pop70, $1
	br_if   	6, $pop71       # 6: down to label3
.LBB2_27:                               # %cleanup301
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label15:
	i64.const	$push174=, 1
	i64.add 	$0=, $0, $pop174
	i64.const	$push173=, 10000
	i64.lt_s	$push74=, $0, $pop173
	br_if   	0, $pop74       # 0: up to label7
# BB#28:                                # %for.end
	end_loop                        # label8:
	i32.const	$push75=, 0
	i64.store	$discard=, simple_rand.seed($pop75), $8
	i32.const	$push175=, 0
	call    	exit@FUNCTION, $pop175
	unreachable
.LBB2_29:                               # %if.then32
	end_block                       # label6:
	i32.const	$push27=, 0
	i64.store	$discard=, simple_rand.seed($pop27), $8
	call    	abort@FUNCTION
	unreachable
.LBB2_30:                               # %if.then111
	end_block                       # label5:
	i32.const	$push73=, 0
	i64.store	$discard=, simple_rand.seed($pop73), $8
	call    	abort@FUNCTION
	unreachable
.LBB2_31:                               # %if.then208
	end_block                       # label4:
	i32.const	$push54=, 0
	i64.store	$discard=, simple_rand.seed($pop54), $8
	call    	abort@FUNCTION
	unreachable
.LBB2_32:                               # %if.then299
	end_block                       # label3:
	i32.const	$push72=, 0
	i64.store	$discard=, simple_rand.seed($pop72), $8
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
