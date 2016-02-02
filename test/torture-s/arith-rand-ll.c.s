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
	i32.const	$push12=, 0
	i64.load	$0=, simple_rand.seed($pop12)
	i64.const	$2=, 0
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i64.const	$push18=, 1103515245
	i64.mul 	$push2=, $0, $pop18
	i64.const	$push17=, 12345
	i64.add 	$0=, $pop2, $pop17
	i64.const	$push16=, 9
	i64.shr_u	$push0=, $0, $pop16
	tee_local	$push15=, $4=, $pop0
	i32.wrap/i64	$push3=, $pop15
	i32.const	$push14=, 15
	i32.and 	$push1=, $pop3, $pop14
	tee_local	$push13=, $3=, $pop1
	i32.const	$push25=, 0
	i32.eq  	$push26=, $pop13, $pop25
	br_if   	$pop26, 1       # 1: down to label1
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i64.const	$push21=, 15
	i64.and 	$push4=, $4, $pop21
	i64.shl 	$2=, $2, $pop4
	i32.add 	$1=, $3, $1
	block
	i64.const	$push20=, 256
	i64.and 	$push5=, $0, $pop20
	i64.const	$push19=, 0
	i64.eq  	$push6=, $pop5, $pop19
	br_if   	$pop6, 0        # 0: down to label2
# BB#3:                                 # %if.then2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push23=, 1
	i32.shl 	$push7=, $pop23, $3
	i32.const	$push22=, -1
	i32.add 	$push8=, $pop7, $pop22
	i64.extend_s/i32	$push9=, $pop8
	i64.or  	$2=, $pop9, $2
.LBB1_4:                                # %if.end
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.const	$push24=, 71
	i32.lt_u	$push10=, $1, $pop24
	br_if   	$pop10, 0       # 0: up to label0
.LBB1_5:                                # %cleanup
	end_loop                        # label1:
	i32.const	$push11=, 0
	i64.store	$discard=, simple_rand.seed($pop11), $0
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
	i32.const	$push94=, 0
	i64.load	$1=, simple_rand.seed($pop94)
	i64.const	$0=, 0
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
                                        #     Child Loop BB2_7 Depth 2
	loop                            # label3:
	i64.const	$5=, 0
	i32.const	$4=, 0
.LBB2_2:                                # %for.cond.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label5:
	i64.const	$push100=, 1103515245
	i64.mul 	$push10=, $1, $pop100
	i64.const	$push99=, 12345
	i64.add 	$1=, $pop10, $pop99
	i64.const	$push98=, 9
	i64.shr_u	$push0=, $1, $pop98
	tee_local	$push97=, $6=, $pop0
	i32.wrap/i64	$push11=, $pop97
	i32.const	$push96=, 15
	i32.and 	$push1=, $pop11, $pop96
	tee_local	$push95=, $7=, $pop1
	i32.const	$push175=, 0
	i32.eq  	$push176=, $pop95, $pop175
	br_if   	$pop176, 1      # 1: down to label6
# BB#3:                                 # %if.else.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i64.const	$push103=, 15
	i64.and 	$push12=, $6, $pop103
	i64.shl 	$5=, $5, $pop12
	i32.add 	$4=, $7, $4
	block
	i64.const	$push102=, 256
	i64.and 	$push13=, $1, $pop102
	i64.const	$push101=, 0
	i64.eq  	$push14=, $pop13, $pop101
	br_if   	$pop14, 0       # 0: down to label7
# BB#4:                                 # %if.then2.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.const	$push105=, 1
	i32.shl 	$push15=, $pop105, $7
	i32.const	$push104=, -1
	i32.add 	$push16=, $pop15, $pop104
	i64.extend_s/i32	$push17=, $pop16
	i64.or  	$5=, $pop17, $5
.LBB2_5:                                # %if.end.i
                                        #   in Loop: Header=BB2_2 Depth=2
	end_block                       # label7:
	i32.const	$push106=, 71
	i32.lt_u	$push18=, $4, $pop106
	br_if   	$pop18, 0       # 0: up to label5
.LBB2_6:                                # %random_bitstring.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label6:
	i64.const	$6=, 0
	i32.const	$4=, 0
.LBB2_7:                                # %for.cond.i452
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label8:
	i64.const	$push112=, 1103515245
	i64.mul 	$push19=, $1, $pop112
	i64.const	$push111=, 12345
	i64.add 	$1=, $pop19, $pop111
	i64.const	$push110=, 9
	i64.shr_u	$push2=, $1, $pop110
	tee_local	$push109=, $8=, $pop2
	i32.wrap/i64	$push20=, $pop109
	i32.const	$push108=, 15
	i32.and 	$push3=, $pop20, $pop108
	tee_local	$push107=, $7=, $pop3
	i32.const	$push177=, 0
	i32.eq  	$push178=, $pop107, $pop177
	br_if   	$pop178, 1      # 1: down to label9
# BB#8:                                 # %if.else.i457
                                        #   in Loop: Header=BB2_7 Depth=2
	i64.const	$push115=, 15
	i64.and 	$push21=, $8, $pop115
	i64.shl 	$6=, $6, $pop21
	i32.add 	$4=, $7, $4
	block
	i64.const	$push114=, 256
	i64.and 	$push22=, $1, $pop114
	i64.const	$push113=, 0
	i64.eq  	$push23=, $pop22, $pop113
	br_if   	$pop23, 0       # 0: down to label10
# BB#9:                                 # %if.then2.i462
                                        #   in Loop: Header=BB2_7 Depth=2
	i32.const	$push117=, 1
	i32.shl 	$push24=, $pop117, $7
	i32.const	$push116=, -1
	i32.add 	$push25=, $pop24, $pop116
	i64.extend_s/i32	$push26=, $pop25
	i64.or  	$6=, $pop26, $6
.LBB2_10:                               # %if.end.i465
                                        #   in Loop: Header=BB2_7 Depth=2
	end_block                       # label10:
	i32.const	$push118=, 71
	i32.lt_u	$push27=, $4, $pop118
	br_if   	$pop27, 0       # 0: up to label8
.LBB2_11:                               # %random_bitstring.exit467
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label9:
	block
	i64.const	$push119=, 0
	i64.eq  	$push28=, $6, $pop119
	br_if   	$pop28, 0       # 0: down to label11
# BB#12:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i64.const	$push121=, 9223372036854775807
	i64.and 	$push29=, $5, $pop121
	i64.const	$push120=, 0
	i64.ne  	$push30=, $pop29, $pop120
	br_if   	$pop30, 0       # 0: down to label12
# BB#13:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	i64.const	$push122=, -1
	i64.eq  	$push31=, $6, $pop122
	br_if   	$pop31, 1       # 1: down to label11
.LBB2_14:                               # %if.end17
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label12:
	i64.rem_s	$8=, $5, $6
	block
	i64.const	$push126=, 63
	i64.shr_s	$push35=, $8, $pop126
	tee_local	$push125=, $9=, $pop35
	i64.add 	$push36=, $8, $pop125
	i64.xor 	$push37=, $pop36, $9
	i64.const	$push124=, 63
	i64.shr_s	$push32=, $6, $pop124
	tee_local	$push123=, $8=, $pop32
	i64.add 	$push33=, $6, $pop123
	i64.xor 	$push34=, $pop33, $8
	i64.ge_u	$push38=, $pop37, $pop34
	br_if   	$pop38, 0       # 0: down to label13
# BB#15:                                # %save_time
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.wrap/i64	$push5=, $6
	tee_local	$push127=, $4=, $pop5
	i32.const	$push179=, 0
	i32.eq  	$push180=, $pop127, $pop179
	br_if   	$pop180, 1      # 1: down to label11
# BB#16:                                # %cleanup.cont65
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i32.wrap/i64	$push4=, $5
	tee_local	$push129=, $7=, $pop4
	i32.const	$push128=, 2147483647
	i32.and 	$push40=, $pop129, $pop128
	br_if   	$pop40, 0       # 0: down to label14
# BB#17:                                # %cleanup.cont65
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push130=, -1
	i32.eq  	$push41=, $4, $pop130
	br_if   	$pop41, 2       # 2: down to label11
.LBB2_18:                               # %if.end79
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label14:
	i32.rem_s	$2=, $7, $4
	block
	i32.const	$push134=, 31
	i32.shr_s	$push45=, $2, $pop134
	tee_local	$push133=, $3=, $pop45
	i32.add 	$push46=, $2, $pop133
	i32.xor 	$push47=, $pop46, $3
	i32.const	$push132=, 31
	i32.shr_s	$push42=, $4, $pop132
	tee_local	$push131=, $3=, $pop42
	i32.add 	$push43=, $4, $pop131
	i32.xor 	$push44=, $pop43, $3
	i32.ge_u	$push48=, $pop47, $pop44
	br_if   	$pop48, 0       # 0: down to label15
# BB#19:                                # %lor.lhs.false103
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i32.const	$push181=, 0
	i32.eq  	$push182=, $2, $pop181
	br_if   	$pop182, 0      # 0: down to label16
# BB#20:                                # %lor.lhs.false103
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.xor 	$push49=, $2, $7
	i32.const	$push135=, -1
	i32.le_s	$push50=, $pop49, $pop135
	br_if   	$pop50, 1       # 1: down to label15
.LBB2_21:                               # %cleanup.cont118
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label16:
	i32.const	$push136=, 65535
	i32.and 	$push51=, $4, $pop136
	i32.const	$push183=, 0
	i32.eq  	$push184=, $pop51, $pop183
	br_if   	$pop184, 2      # 2: down to label11
# BB#22:                                # %cleanup.cont158
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push151=, 16
	i32.shl 	$push52=, $7, $pop151
	i32.const	$push150=, 16
	i32.shr_s	$push6=, $pop52, $pop150
	tee_local	$push149=, $12=, $pop6
	i32.const	$push148=, 16
	i32.shl 	$push53=, $4, $pop148
	tee_local	$push147=, $11=, $pop53
	i32.const	$push146=, 16
	i32.shr_s	$push7=, $pop147, $pop146
	tee_local	$push145=, $2=, $pop7
	i32.rem_s	$push54=, $pop149, $pop145
	i32.const	$push144=, 16
	i32.shl 	$push55=, $pop54, $pop144
	tee_local	$push143=, $10=, $pop55
	i32.const	$push142=, 16
	i32.shr_s	$3=, $pop143, $pop142
	block
	i32.const	$push141=, -65536
	i32.gt_s	$push56=, $10, $pop141
	i32.const	$push140=, 0
	i32.sub 	$push57=, $pop140, $3
	i32.select	$push58=, $pop56, $3, $pop57
	i32.const	$push139=, -65536
	i32.gt_s	$push59=, $11, $pop139
	i32.const	$push138=, 0
	i32.sub 	$push60=, $pop138, $2
	i32.select	$push61=, $pop59, $2, $pop60
	i32.const	$push137=, 65535
	i32.and 	$push62=, $pop61, $pop137
	i32.ge_s	$push63=, $pop58, $pop62
	br_if   	$pop63, 0       # 0: down to label17
# BB#23:                                # %lor.lhs.false197
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push64=, $12, $2
	i32.mul 	$push65=, $pop64, $2
	i32.add 	$push66=, $pop65, $3
	i32.const	$push153=, 16
	i32.shl 	$push67=, $pop66, $pop153
	i32.const	$push152=, 16
	i32.shr_s	$push68=, $pop67, $pop152
	i32.ne  	$push69=, $pop68, $12
	br_if   	$pop69, 0       # 0: down to label17
# BB#24:                                # %if.end209
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push154=, 255
	i32.and 	$push71=, $4, $pop154
	i32.const	$push185=, 0
	i32.eq  	$push186=, $pop71, $pop185
	br_if   	$pop186, 3      # 3: down to label11
# BB#25:                                # %cleanup.cont249
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push169=, 24
	i32.shl 	$push72=, $7, $pop169
	i32.const	$push168=, 24
	i32.shr_s	$push8=, $pop72, $pop168
	tee_local	$push167=, $2=, $pop8
	i32.const	$push166=, 24
	i32.shl 	$push73=, $4, $pop166
	tee_local	$push165=, $3=, $pop73
	i32.const	$push164=, 24
	i32.shr_s	$push9=, $pop165, $pop164
	tee_local	$push163=, $4=, $pop9
	i32.rem_s	$push74=, $pop167, $pop163
	i32.const	$push162=, 24
	i32.shl 	$push75=, $pop74, $pop162
	tee_local	$push161=, $12=, $pop75
	i32.const	$push160=, 24
	i32.shr_s	$7=, $pop161, $pop160
	block
	i32.const	$push159=, -16777216
	i32.gt_s	$push76=, $12, $pop159
	i32.const	$push158=, 0
	i32.sub 	$push77=, $pop158, $7
	i32.select	$push78=, $pop76, $7, $pop77
	i32.const	$push157=, -16777216
	i32.gt_s	$push79=, $3, $pop157
	i32.const	$push156=, 0
	i32.sub 	$push80=, $pop156, $4
	i32.select	$push81=, $pop79, $4, $pop80
	i32.const	$push155=, 255
	i32.and 	$push82=, $pop81, $pop155
	i32.ge_s	$push83=, $pop78, $pop82
	br_if   	$pop83, 0       # 0: down to label18
# BB#26:                                # %lor.lhs.false288
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push84=, $2, $4
	i32.mul 	$push85=, $pop84, $4
	i32.add 	$push86=, $pop85, $7
	i32.const	$push171=, 24
	i32.shl 	$push87=, $pop86, $pop171
	i32.const	$push170=, 24
	i32.shr_s	$push88=, $pop87, $pop170
	i32.eq  	$push89=, $pop88, $2
	br_if   	$pop89, 4       # 4: down to label11
.LBB2_27:                               # %if.then299
	end_block                       # label18:
	i32.const	$push90=, 0
	i64.store	$discard=, simple_rand.seed($pop90), $1
	call    	abort@FUNCTION
	unreachable
.LBB2_28:                               # %if.then208
	end_block                       # label17:
	i32.const	$push70=, 0
	i64.store	$discard=, simple_rand.seed($pop70), $1
	call    	abort@FUNCTION
	unreachable
.LBB2_29:                               # %if.then111
	end_block                       # label15:
	i32.const	$push91=, 0
	i64.store	$discard=, simple_rand.seed($pop91), $1
	call    	abort@FUNCTION
	unreachable
.LBB2_30:                               # %if.then32
	end_block                       # label13:
	i32.const	$push39=, 0
	i64.store	$discard=, simple_rand.seed($pop39), $1
	call    	abort@FUNCTION
	unreachable
.LBB2_31:                               # %cleanup301
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label11:
	i64.const	$push173=, 1
	i64.add 	$0=, $0, $pop173
	i64.const	$push172=, 10000
	i64.lt_s	$push92=, $0, $pop172
	br_if   	$pop92, 0       # 0: up to label3
# BB#32:                                # %for.end
	end_loop                        # label4:
	i32.const	$push93=, 0
	i64.store	$discard=, simple_rand.seed($pop93), $1
	i32.const	$push174=, 0
	call    	exit@FUNCTION, $pop174
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
