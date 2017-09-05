	.text
	.file	"arith-rand-ll.c"
	.section	.text.simple_rand,"ax",@progbits
	.hidden	simple_rand             # -- Begin function simple_rand
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
                                        # -- End function
	.section	.text.random_bitstring,"ax",@progbits
	.hidden	random_bitstring        # -- Begin function random_bitstring
	.globl	random_bitstring
	.type	random_bitstring,@function
random_bitstring:                       # @random_bitstring
	.result 	i64
	.local  	i32, i32, i64, i64, i64
# BB#0:                                 # %entry
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i64.load	$push0=, simple_rand.seed($pop22)
	i64.const	$push21=, 1103515245
	i64.mul 	$push1=, $pop0, $pop21
	i64.const	$push20=, 12345
	i64.add 	$push19=, $pop1, $pop20
	tee_local	$push18=, $3=, $pop19
	i64.store	simple_rand.seed($pop23), $pop18
	i64.const	$4=, 0
	block   	
	i64.const	$push17=, 9
	i64.shr_u	$push16=, $3, $pop17
	tee_local	$push15=, $2=, $pop16
	i32.wrap/i64	$push2=, $pop15
	i32.const	$push14=, 15
	i32.and 	$push13=, $pop2, $pop14
	tee_local	$push12=, $0=, $pop13
	i32.eqz 	$push40=, $pop12
	br_if   	0, $pop40       # 0: down to label0
# BB#1:                                 # %if.else.preheader
	copy_local	$1=, $0
.LBB1_2:                                # %if.else
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i64.const	$push25=, 15
	i64.and 	$push3=, $2, $pop25
	i64.shl 	$4=, $4, $pop3
	block   	
	i64.const	$push24=, 256
	i64.and 	$push4=, $3, $pop24
	i64.eqz 	$push5=, $pop4
	br_if   	0, $pop5        # 0: down to label2
# BB#3:                                 # %if.then2
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push27=, 1
	i32.shl 	$push6=, $pop27, $1
	i32.const	$push26=, -1
	i32.add 	$push7=, $pop6, $pop26
	i64.extend_s/i32	$push8=, $pop7
	i64.or  	$4=, $4, $pop8
.LBB1_4:                                # %if.end
                                        #   in Loop: Header=BB1_2 Depth=1
	end_block                       # label2:
	i32.const	$push28=, 71
	i32.ge_u	$push9=, $0, $pop28
	br_if   	1, $pop9        # 1: down to label0
# BB#5:                                 # %for.cond
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push39=, 0
	i64.const	$push38=, 1103515245
	i64.mul 	$push10=, $3, $pop38
	i64.const	$push37=, 12345
	i64.add 	$push36=, $pop10, $pop37
	tee_local	$push35=, $3=, $pop36
	i64.store	simple_rand.seed($pop39), $pop35
	i64.const	$push34=, 9
	i64.shr_u	$push33=, $3, $pop34
	tee_local	$push32=, $2=, $pop33
	i32.wrap/i64	$push11=, $pop32
	i32.const	$push31=, 15
	i32.and 	$push30=, $pop11, $pop31
	tee_local	$push29=, $1=, $pop30
	i32.add 	$0=, $pop29, $0
	br_if   	0, $1           # 0: up to label1
.LBB1_6:                                # %cleanup
	end_loop
	end_block                       # label0:
	copy_local	$push41=, $4
                                        # fallthrough-return: $pop41
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
	.local  	i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$push80=, 0
	i64.load	$2=, simple_rand.seed($pop80)
	i64.const	$1=, 0
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_3 Depth 2
                                        #     Child Loop BB2_10 Depth 2
	block   	
	block   	
	block   	
	block   	
	loop    	                # label7:
	copy_local	$0=, $1
	block   	
	block   	
	i64.const	$push90=, 1103515245
	i64.mul 	$push0=, $2, $pop90
	i64.const	$push89=, 12345
	i64.add 	$push88=, $pop0, $pop89
	tee_local	$push87=, $1=, $pop88
	i64.const	$push86=, 9
	i64.shr_u	$push85=, $pop87, $pop86
	tee_local	$push84=, $2=, $pop85
	i32.wrap/i64	$push1=, $pop84
	i32.const	$push83=, 15
	i32.and 	$push82=, $pop1, $pop83
	tee_local	$push81=, $8=, $pop82
	i32.eqz 	$push208=, $pop81
	br_if   	0, $pop208      # 0: down to label9
# BB#2:                                 # %if.else.i.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i64.const	$10=, 0
	copy_local	$9=, $8
.LBB2_3:                                # %if.else.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label10:
	i64.const	$push92=, 15
	i64.and 	$push2=, $2, $pop92
	i64.shl 	$10=, $10, $pop2
	block   	
	i64.const	$push91=, 256
	i64.and 	$push3=, $1, $pop91
	i64.eqz 	$push4=, $pop3
	br_if   	0, $pop4        # 0: down to label11
# BB#4:                                 # %if.then2.i
                                        #   in Loop: Header=BB2_3 Depth=2
	i32.const	$push94=, 1
	i32.shl 	$push5=, $pop94, $9
	i32.const	$push93=, -1
	i32.add 	$push6=, $pop5, $pop93
	i64.extend_s/i32	$push7=, $pop6
	i64.or  	$10=, $10, $pop7
.LBB2_5:                                # %if.end.i
                                        #   in Loop: Header=BB2_3 Depth=2
	end_block                       # label11:
	i32.const	$push95=, 71
	i32.ge_u	$push8=, $8, $pop95
	br_if   	2, $pop8        # 2: down to label8
# BB#6:                                 # %for.cond.i
                                        #   in Loop: Header=BB2_3 Depth=2
	i64.const	$push105=, 1103515245
	i64.mul 	$push9=, $1, $pop105
	i64.const	$push104=, 12345
	i64.add 	$push103=, $pop9, $pop104
	tee_local	$push102=, $1=, $pop103
	i64.const	$push101=, 9
	i64.shr_u	$push100=, $pop102, $pop101
	tee_local	$push99=, $2=, $pop100
	i32.wrap/i64	$push10=, $pop99
	i32.const	$push98=, 15
	i32.and 	$push97=, $pop10, $pop98
	tee_local	$push96=, $9=, $pop97
	i32.add 	$8=, $pop96, $8
	br_if   	0, $9           # 0: up to label10
	br      	2               # 2: down to label8
.LBB2_7:                                #   in Loop: Header=BB2_1 Depth=1
	end_loop
	end_block                       # label9:
	i64.const	$10=, 0
.LBB2_8:                                # %random_bitstring.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label8:
	block   	
	i64.const	$push115=, 1103515245
	i64.mul 	$push11=, $1, $pop115
	i64.const	$push114=, 12345
	i64.add 	$push113=, $pop11, $pop114
	tee_local	$push112=, $2=, $pop113
	i64.const	$push111=, 9
	i64.shr_u	$push110=, $pop112, $pop111
	tee_local	$push109=, $11=, $pop110
	i32.wrap/i64	$push12=, $pop109
	i32.const	$push108=, 15
	i32.and 	$push107=, $pop12, $pop108
	tee_local	$push106=, $8=, $pop107
	i32.eqz 	$push209=, $pop106
	br_if   	0, $pop209      # 0: down to label12
# BB#9:                                 # %if.else.i459.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i64.const	$1=, 0
	copy_local	$9=, $8
.LBB2_10:                               # %if.else.i459
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label13:
	i64.const	$push117=, 15
	i64.and 	$push13=, $11, $pop117
	i64.shl 	$1=, $1, $pop13
	block   	
	i64.const	$push116=, 256
	i64.and 	$push14=, $2, $pop116
	i64.eqz 	$push15=, $pop14
	br_if   	0, $pop15       # 0: down to label14
# BB#11:                                # %if.then2.i464
                                        #   in Loop: Header=BB2_10 Depth=2
	i32.const	$push119=, 1
	i32.shl 	$push16=, $pop119, $9
	i32.const	$push118=, -1
	i32.add 	$push17=, $pop16, $pop118
	i64.extend_s/i32	$push18=, $pop17
	i64.or  	$1=, $1, $pop18
.LBB2_12:                               # %if.end.i467
                                        #   in Loop: Header=BB2_10 Depth=2
	end_block                       # label14:
	block   	
	i32.const	$push120=, 71
	i32.ge_u	$push19=, $8, $pop120
	br_if   	0, $pop19       # 0: down to label15
# BB#13:                                # %for.cond.i451
                                        #   in Loop: Header=BB2_10 Depth=2
	i64.const	$push130=, 1103515245
	i64.mul 	$push20=, $2, $pop130
	i64.const	$push129=, 12345
	i64.add 	$push128=, $pop20, $pop129
	tee_local	$push127=, $2=, $pop128
	i64.const	$push126=, 9
	i64.shr_u	$push125=, $pop127, $pop126
	tee_local	$push124=, $11=, $pop125
	i32.wrap/i64	$push21=, $pop124
	i32.const	$push123=, 15
	i32.and 	$push122=, $pop21, $pop123
	tee_local	$push121=, $9=, $pop122
	i32.add 	$8=, $pop121, $8
	br_if   	1, $9           # 1: up to label13
.LBB2_14:                               # %random_bitstring.exit469
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label15:
	end_loop
	i64.eqz 	$push22=, $1
	br_if   	0, $pop22       # 0: down to label12
# BB#15:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	block   	
	i64.const	$push132=, 9223372036854775807
	i64.and 	$push23=, $10, $pop132
	i64.const	$push131=, 0
	i64.ne  	$push24=, $pop23, $pop131
	br_if   	0, $pop24       # 0: down to label16
# BB#16:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	i64.const	$push133=, -1
	i64.eq  	$push25=, $1, $pop133
	br_if   	1, $pop25       # 1: down to label12
.LBB2_17:                               # %if.end17
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label16:
	i64.rem_s	$push141=, $10, $1
	tee_local	$push140=, $11=, $pop141
	i64.const	$push139=, 63
	i64.shr_s	$push138=, $11, $pop139
	tee_local	$push137=, $11=, $pop138
	i64.add 	$push28=, $pop140, $pop137
	i64.xor 	$push29=, $pop28, $11
	i64.const	$push136=, 63
	i64.shr_s	$push135=, $1, $pop136
	tee_local	$push134=, $11=, $pop135
	i64.add 	$push26=, $1, $pop134
	i64.xor 	$push27=, $pop26, $11
	i64.ge_u	$push30=, $pop29, $pop27
	br_if   	2, $pop30       # 2: down to label6
# BB#18:                                # %save_time
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.wrap/i64	$push143=, $1
	tee_local	$push142=, $8=, $pop143
	i32.eqz 	$push210=, $pop142
	br_if   	0, $pop210      # 0: down to label12
# BB#19:                                # %cleanup.cont65
                                        #   in Loop: Header=BB2_1 Depth=1
	block   	
	i32.wrap/i64	$push146=, $10
	tee_local	$push145=, $9=, $pop146
	i32.const	$push144=, 2147483647
	i32.and 	$push32=, $pop145, $pop144
	br_if   	0, $pop32       # 0: down to label17
# BB#20:                                # %cleanup.cont65
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push147=, -1
	i32.eq  	$push33=, $8, $pop147
	br_if   	1, $pop33       # 1: down to label12
.LBB2_21:                               # %if.end79
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label17:
	i32.rem_s	$push155=, $9, $8
	tee_local	$push154=, $3=, $pop155
	i32.const	$push153=, 31
	i32.shr_s	$push152=, $3, $pop153
	tee_local	$push151=, $5=, $pop152
	i32.add 	$push36=, $pop154, $pop151
	i32.xor 	$push37=, $pop36, $5
	i32.const	$push150=, 31
	i32.shr_s	$push149=, $8, $pop150
	tee_local	$push148=, $5=, $pop149
	i32.add 	$push34=, $8, $pop148
	i32.xor 	$push35=, $pop34, $5
	i32.ge_u	$push38=, $pop37, $pop35
	br_if   	3, $pop38       # 3: down to label5
# BB#22:                                # %lor.lhs.false103
                                        #   in Loop: Header=BB2_1 Depth=1
	block   	
	i32.eqz 	$push211=, $3
	br_if   	0, $pop211      # 0: down to label18
# BB#23:                                # %lor.lhs.false103
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.xor 	$push39=, $3, $9
	i32.const	$push156=, -1
	i32.le_s	$push40=, $pop39, $pop156
	br_if   	4, $pop40       # 4: down to label5
.LBB2_24:                               # %cleanup.cont118
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label18:
	i32.const	$push157=, 65535
	i32.and 	$push41=, $8, $pop157
	i32.eqz 	$push212=, $pop41
	br_if   	0, $pop212      # 0: down to label12
# BB#25:                                # %cleanup.cont158
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push178=, 16
	i32.shl 	$push42=, $9, $pop178
	i32.const	$push177=, 16
	i32.shr_s	$push176=, $pop42, $pop177
	tee_local	$push175=, $5=, $pop176
	i32.const	$push174=, 16
	i32.shl 	$push173=, $8, $pop174
	tee_local	$push172=, $6=, $pop173
	i32.const	$push171=, 16
	i32.shr_s	$push170=, $pop172, $pop171
	tee_local	$push169=, $3=, $pop170
	i32.rem_s	$push43=, $pop175, $pop169
	i32.const	$push168=, 16
	i32.shl 	$push167=, $pop43, $pop168
	tee_local	$push166=, $7=, $pop167
	i32.const	$push165=, 16
	i32.shr_s	$push164=, $pop166, $pop165
	tee_local	$push163=, $4=, $pop164
	i32.const	$push162=, 0
	i32.sub 	$push45=, $pop162, $4
	i32.const	$push161=, -65536
	i32.gt_s	$push44=, $7, $pop161
	i32.select	$push46=, $pop163, $pop45, $pop44
	i32.const	$push160=, 0
	i32.sub 	$push48=, $pop160, $3
	i32.const	$push159=, -65536
	i32.gt_s	$push47=, $6, $pop159
	i32.select	$push49=, $3, $pop48, $pop47
	i32.const	$push158=, 65535
	i32.and 	$push50=, $pop49, $pop158
	i32.ge_s	$push51=, $pop46, $pop50
	br_if   	4, $pop51       # 4: down to label4
# BB#26:                                # %lor.lhs.false197
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push52=, $5, $3
	i32.mul 	$push53=, $pop52, $3
	i32.add 	$push54=, $pop53, $4
	i32.const	$push180=, 16
	i32.shl 	$push55=, $pop54, $pop180
	i32.const	$push179=, 16
	i32.shr_s	$push56=, $pop55, $pop179
	i32.ne  	$push57=, $pop56, $5
	br_if   	4, $pop57       # 4: down to label4
# BB#27:                                # %if.end209
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push181=, 255
	i32.and 	$push59=, $8, $pop181
	i32.eqz 	$push213=, $pop59
	br_if   	0, $pop213      # 0: down to label12
# BB#28:                                # %cleanup.cont249
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push202=, 24
	i32.shl 	$push60=, $9, $pop202
	i32.const	$push201=, 24
	i32.shr_s	$push200=, $pop60, $pop201
	tee_local	$push199=, $9=, $pop200
	i32.const	$push198=, 24
	i32.shl 	$push197=, $8, $pop198
	tee_local	$push196=, $5=, $pop197
	i32.const	$push195=, 24
	i32.shr_s	$push194=, $pop196, $pop195
	tee_local	$push193=, $8=, $pop194
	i32.rem_s	$push61=, $pop199, $pop193
	i32.const	$push192=, 24
	i32.shl 	$push191=, $pop61, $pop192
	tee_local	$push190=, $4=, $pop191
	i32.const	$push189=, 24
	i32.shr_s	$push188=, $pop190, $pop189
	tee_local	$push187=, $3=, $pop188
	i32.const	$push186=, 0
	i32.sub 	$push63=, $pop186, $3
	i32.const	$push185=, -16777216
	i32.gt_s	$push62=, $4, $pop185
	i32.select	$push64=, $pop187, $pop63, $pop62
	i32.const	$push184=, 0
	i32.sub 	$push66=, $pop184, $8
	i32.const	$push183=, -16777216
	i32.gt_s	$push65=, $5, $pop183
	i32.select	$push67=, $8, $pop66, $pop65
	i32.const	$push182=, 255
	i32.and 	$push68=, $pop67, $pop182
	i32.ge_s	$push69=, $pop64, $pop68
	br_if   	5, $pop69       # 5: down to label3
# BB#29:                                # %lor.lhs.false288
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push70=, $9, $8
	i32.mul 	$push71=, $pop70, $8
	i32.add 	$push72=, $pop71, $3
	i32.const	$push204=, 24
	i32.shl 	$push73=, $pop72, $pop204
	i32.const	$push203=, 24
	i32.shr_s	$push74=, $pop73, $pop203
	i32.ne  	$push75=, $pop74, $9
	br_if   	5, $pop75       # 5: down to label3
.LBB2_30:                               # %cleanup301
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label12:
	i64.const	$push206=, 1
	i64.add 	$1=, $0, $pop206
	i64.const	$push205=, 9999
	i64.lt_u	$push78=, $0, $pop205
	br_if   	0, $pop78       # 0: up to label7
# BB#31:                                # %for.end
	end_loop
	i32.const	$push79=, 0
	i64.store	simple_rand.seed($pop79), $2
	i32.const	$push207=, 0
	call    	exit@FUNCTION, $pop207
	unreachable
.LBB2_32:                               # %if.then32
	end_block                       # label6:
	i32.const	$push31=, 0
	i64.store	simple_rand.seed($pop31), $2
	call    	abort@FUNCTION
	unreachable
.LBB2_33:                               # %if.then111
	end_block                       # label5:
	i32.const	$push77=, 0
	i64.store	simple_rand.seed($pop77), $2
	call    	abort@FUNCTION
	unreachable
.LBB2_34:                               # %if.then208
	end_block                       # label4:
	i32.const	$push58=, 0
	i64.store	simple_rand.seed($pop58), $2
	call    	abort@FUNCTION
	unreachable
.LBB2_35:                               # %if.then299
	end_block                       # label3:
	i32.const	$push76=, 0
	i64.store	simple_rand.seed($pop76), $2
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.type	simple_rand.seed,@object # @simple_rand.seed
	.section	.data.simple_rand.seed,"aw",@progbits
	.p2align	3
simple_rand.seed:
	.int64	47114711                # 0x2cee9d7
	.size	simple_rand.seed, 8


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
