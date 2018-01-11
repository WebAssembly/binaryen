	.text
	.file	"arith-rand-ll.c"
	.section	.text.simple_rand,"ax",@progbits
	.hidden	simple_rand             # -- Begin function simple_rand
	.globl	simple_rand
	.type	simple_rand,@function
simple_rand:                            # @simple_rand
	.result 	i64
	.local  	i64
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i64.load	$push1=, simple_rand.seed($pop0)
	i64.const	$push2=, 1103515245
	i64.mul 	$push3=, $pop1, $pop2
	i64.const	$push4=, 12345
	i64.add 	$0=, $pop3, $pop4
	i32.const	$push7=, 0
	i64.store	simple_rand.seed($pop7), $0
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
# %bb.0:                                # %entry
	i32.const	$push17=, 0
	i64.load	$push0=, simple_rand.seed($pop17)
	i64.const	$push16=, 1103515245
	i64.mul 	$push1=, $pop0, $pop16
	i64.const	$push15=, 12345
	i64.add 	$3=, $pop1, $pop15
	i32.const	$push14=, 0
	i64.store	simple_rand.seed($pop14), $3
	i64.const	$push13=, 9
	i64.shr_u	$2=, $3, $pop13
	i64.const	$4=, 0
	i32.wrap/i64	$push2=, $2
	i32.const	$push12=, 15
	i32.and 	$0=, $pop2, $pop12
	block   	
	i32.eqz 	$push28=, $0
	br_if   	0, $pop28       # 0: down to label0
# %bb.1:                                # %if.else.preheader
	copy_local	$1=, $0
.LBB1_2:                                # %if.else
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i64.const	$push19=, 15
	i64.and 	$push3=, $2, $pop19
	i64.shl 	$4=, $4, $pop3
	block   	
	i64.const	$push18=, 256
	i64.and 	$push4=, $3, $pop18
	i64.eqz 	$push5=, $pop4
	br_if   	0, $pop5        # 0: down to label2
# %bb.3:                                # %if.then2
                                        #   in Loop: Header=BB1_2 Depth=1
	i32.const	$push21=, 1
	i32.shl 	$push6=, $pop21, $1
	i32.const	$push20=, -1
	i32.add 	$push7=, $pop6, $pop20
	i64.extend_s/i32	$push8=, $pop7
	i64.or  	$4=, $4, $pop8
.LBB1_4:                                # %if.end
                                        #   in Loop: Header=BB1_2 Depth=1
	end_block                       # label2:
	i32.const	$push22=, 71
	i32.ge_u	$push9=, $0, $pop22
	br_if   	1, $pop9        # 1: down to label0
# %bb.5:                                # %for.cond
                                        #   in Loop: Header=BB1_2 Depth=1
	i64.const	$push27=, 1103515245
	i64.mul 	$push10=, $3, $pop27
	i64.const	$push26=, 12345
	i64.add 	$3=, $pop10, $pop26
	i32.const	$push25=, 0
	i64.store	simple_rand.seed($pop25), $3
	i64.const	$push24=, 9
	i64.shr_u	$2=, $3, $pop24
	i32.wrap/i64	$push11=, $2
	i32.const	$push23=, 15
	i32.and 	$1=, $pop11, $pop23
	i32.add 	$0=, $1, $0
	br_if   	0, $1           # 0: up to label1
.LBB1_6:                                # %cleanup
	end_loop
	end_block                       # label0:
	copy_local	$push29=, $4
                                        # fallthrough-return: $pop29
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
	.local  	i64, i64, i64, i32, i64, i64, i32, i32, i32, i32, i32, i32, i32, i64, i64
# %bb.0:                                # %entry
	i32.const	$push2=, 0
	i64.load	$2=, simple_rand.seed($pop2)
	i64.const	$0=, 0
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_3 Depth 2
                                        #     Child Loop BB2_10 Depth 2
	block   	
	block   	
	block   	
	block   	
	loop    	                # label7:
	i64.const	$push78=, 1103515245
	i64.mul 	$push3=, $2, $pop78
	i64.const	$push77=, 12345
	i64.add 	$2=, $pop3, $pop77
	i64.const	$push76=, 9
	i64.shr_u	$1=, $2, $pop76
	i32.wrap/i64	$push4=, $1
	i32.const	$push75=, 15
	i32.and 	$11=, $pop4, $pop75
	block   	
	block   	
	i32.eqz 	$push138=, $11
	br_if   	0, $pop138      # 0: down to label9
# %bb.2:                                # %if.else.i.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i64.const	$13=, 0
	copy_local	$12=, $11
.LBB2_3:                                # %if.else.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label10:
	i64.const	$push80=, 15
	i64.and 	$push5=, $1, $pop80
	i64.shl 	$13=, $13, $pop5
	block   	
	i64.const	$push79=, 256
	i64.and 	$push6=, $2, $pop79
	i64.eqz 	$push7=, $pop6
	br_if   	0, $pop7        # 0: down to label11
# %bb.4:                                # %if.then2.i
                                        #   in Loop: Header=BB2_3 Depth=2
	i32.const	$push82=, 1
	i32.shl 	$push8=, $pop82, $12
	i32.const	$push81=, -1
	i32.add 	$push9=, $pop8, $pop81
	i64.extend_s/i32	$push10=, $pop9
	i64.or  	$13=, $13, $pop10
.LBB2_5:                                # %if.end.i
                                        #   in Loop: Header=BB2_3 Depth=2
	end_block                       # label11:
	i32.const	$push83=, 71
	i32.ge_u	$push11=, $11, $pop83
	br_if   	2, $pop11       # 2: down to label8
# %bb.6:                                # %for.cond.i
                                        #   in Loop: Header=BB2_3 Depth=2
	i64.const	$push87=, 1103515245
	i64.mul 	$push12=, $2, $pop87
	i64.const	$push86=, 12345
	i64.add 	$2=, $pop12, $pop86
	i64.const	$push85=, 9
	i64.shr_u	$1=, $2, $pop85
	i32.wrap/i64	$push13=, $1
	i32.const	$push84=, 15
	i32.and 	$12=, $pop13, $pop84
	i32.add 	$11=, $12, $11
	br_if   	0, $12          # 0: up to label10
	br      	2               # 2: down to label8
.LBB2_7:                                #   in Loop: Header=BB2_1 Depth=1
	end_loop
	end_block                       # label9:
	i64.const	$13=, 0
.LBB2_8:                                # %random_bitstring.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label8:
	i64.const	$push91=, 1103515245
	i64.mul 	$push14=, $2, $pop91
	i64.const	$push90=, 12345
	i64.add 	$2=, $pop14, $pop90
	i64.const	$push89=, 9
	i64.shr_u	$14=, $2, $pop89
	i32.wrap/i64	$push15=, $14
	i32.const	$push88=, 15
	i32.and 	$11=, $pop15, $pop88
	block   	
	i32.eqz 	$push139=, $11
	br_if   	0, $pop139      # 0: down to label12
# %bb.9:                                # %if.else.i459.preheader
                                        #   in Loop: Header=BB2_1 Depth=1
	i64.const	$1=, 0
	copy_local	$12=, $11
.LBB2_10:                               # %if.else.i459
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label13:
	i64.const	$push93=, 15
	i64.and 	$push16=, $14, $pop93
	i64.shl 	$1=, $1, $pop16
	block   	
	i64.const	$push92=, 256
	i64.and 	$push17=, $2, $pop92
	i64.eqz 	$push18=, $pop17
	br_if   	0, $pop18       # 0: down to label14
# %bb.11:                               # %if.then2.i464
                                        #   in Loop: Header=BB2_10 Depth=2
	i32.const	$push95=, 1
	i32.shl 	$push19=, $pop95, $12
	i32.const	$push94=, -1
	i32.add 	$push20=, $pop19, $pop94
	i64.extend_s/i32	$push21=, $pop20
	i64.or  	$1=, $1, $pop21
.LBB2_12:                               # %if.end.i467
                                        #   in Loop: Header=BB2_10 Depth=2
	end_block                       # label14:
	block   	
	i32.const	$push96=, 71
	i32.ge_u	$push22=, $11, $pop96
	br_if   	0, $pop22       # 0: down to label15
# %bb.13:                               # %for.cond.i451
                                        #   in Loop: Header=BB2_10 Depth=2
	i64.const	$push100=, 1103515245
	i64.mul 	$push23=, $2, $pop100
	i64.const	$push99=, 12345
	i64.add 	$2=, $pop23, $pop99
	i64.const	$push98=, 9
	i64.shr_u	$14=, $2, $pop98
	i32.wrap/i64	$push24=, $14
	i32.const	$push97=, 15
	i32.and 	$12=, $pop24, $pop97
	i32.add 	$11=, $12, $11
	br_if   	1, $12          # 1: up to label13
.LBB2_14:                               # %random_bitstring.exit469
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label15:
	end_loop
	i64.eqz 	$push25=, $1
	br_if   	0, $pop25       # 0: down to label12
# %bb.15:                               # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	block   	
	i64.const	$push102=, 9223372036854775807
	i64.and 	$push26=, $13, $pop102
	i64.const	$push101=, 0
	i64.ne  	$push27=, $pop26, $pop101
	br_if   	0, $pop27       # 0: down to label16
# %bb.16:                               # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	i64.const	$push103=, -1
	i64.eq  	$push28=, $1, $pop103
	br_if   	1, $pop28       # 1: down to label12
.LBB2_17:                               # %if.end17
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label16:
	i64.const	$push105=, 63
	i64.shr_s	$14=, $1, $pop105
	i64.rem_s	$4=, $13, $1
	i64.const	$push104=, 63
	i64.shr_s	$5=, $4, $pop104
	i64.add 	$push31=, $4, $5
	i64.xor 	$push32=, $pop31, $5
	i64.add 	$push29=, $1, $14
	i64.xor 	$push30=, $pop29, $14
	i64.ge_u	$push33=, $pop32, $pop30
	br_if   	2, $pop33       # 2: down to label6
# %bb.18:                               # %save_time
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.wrap/i64	$12=, $1
	i32.eqz 	$push140=, $12
	br_if   	0, $pop140      # 0: down to label12
# %bb.19:                               # %cleanup.cont65
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.wrap/i64	$11=, $13
	block   	
	i32.const	$push106=, 2147483647
	i32.and 	$push35=, $11, $pop106
	br_if   	0, $pop35       # 0: down to label17
# %bb.20:                               # %cleanup.cont65
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push107=, -1
	i32.eq  	$push36=, $12, $pop107
	br_if   	1, $pop36       # 1: down to label12
.LBB2_21:                               # %if.end79
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label17:
	i32.const	$push109=, 31
	i32.shr_s	$6=, $12, $pop109
	i32.rem_s	$3=, $11, $12
	i32.const	$push108=, 31
	i32.shr_s	$7=, $3, $pop108
	i32.add 	$push39=, $3, $7
	i32.xor 	$push40=, $pop39, $7
	i32.add 	$push37=, $12, $6
	i32.xor 	$push38=, $pop37, $6
	i32.ge_u	$push41=, $pop40, $pop38
	br_if   	3, $pop41       # 3: down to label5
# %bb.22:                               # %lor.lhs.false103
                                        #   in Loop: Header=BB2_1 Depth=1
	block   	
	i32.eqz 	$push141=, $3
	br_if   	0, $pop141      # 0: down to label18
# %bb.23:                               # %lor.lhs.false103
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.xor 	$push42=, $3, $11
	i32.const	$push110=, -1
	i32.le_s	$push43=, $pop42, $pop110
	br_if   	4, $pop43       # 4: down to label5
.LBB2_24:                               # %cleanup.cont118
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label18:
	i32.const	$push111=, 65535
	i32.and 	$push44=, $12, $pop111
	i32.eqz 	$push142=, $pop44
	br_if   	0, $pop142      # 0: down to label12
# %bb.25:                               # %cleanup.cont158
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push120=, 16
	i32.shl 	$7=, $12, $pop120
	i32.const	$push119=, 16
	i32.shr_s	$3=, $7, $pop119
	i32.const	$push118=, 16
	i32.shl 	$push45=, $11, $pop118
	i32.const	$push117=, 16
	i32.shr_s	$6=, $pop45, $pop117
	i32.div_s	$push0=, $6, $3
	i32.mul 	$8=, $pop0, $3
	i32.sub 	$push46=, $6, $8
	i32.const	$push116=, 16
	i32.shl 	$9=, $pop46, $pop116
	i32.const	$push115=, 31
	i32.shr_s	$10=, $9, $pop115
	i32.const	$push114=, 16
	i32.shr_s	$9=, $9, $pop114
	i32.const	$push113=, 31
	i32.shr_s	$7=, $7, $pop113
	i32.add 	$push47=, $9, $10
	i32.xor 	$push48=, $pop47, $10
	i32.add 	$push49=, $3, $7
	i32.xor 	$push50=, $pop49, $7
	i32.const	$push112=, 65535
	i32.and 	$push51=, $pop50, $pop112
	i32.ge_s	$push52=, $pop48, $pop51
	br_if   	4, $pop52       # 4: down to label4
# %bb.26:                               # %lor.lhs.false197
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.add 	$push53=, $8, $9
	i32.const	$push122=, 16
	i32.shl 	$push54=, $pop53, $pop122
	i32.const	$push121=, 16
	i32.shr_s	$push55=, $pop54, $pop121
	i32.ne  	$push56=, $pop55, $6
	br_if   	4, $pop56       # 4: down to label4
# %bb.27:                               # %if.end209
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push123=, 255
	i32.and 	$push58=, $12, $pop123
	i32.eqz 	$push143=, $pop58
	br_if   	0, $pop143      # 0: down to label12
# %bb.28:                               # %cleanup.cont249
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push132=, 24
	i32.shl 	$3=, $12, $pop132
	i32.const	$push131=, 24
	i32.shr_s	$12=, $3, $pop131
	i32.const	$push130=, 24
	i32.shl 	$push59=, $11, $pop130
	i32.const	$push129=, 24
	i32.shr_s	$11=, $pop59, $pop129
	i32.div_s	$push1=, $11, $12
	i32.mul 	$6=, $pop1, $12
	i32.sub 	$push60=, $11, $6
	i32.const	$push128=, 24
	i32.shl 	$7=, $pop60, $pop128
	i32.const	$push127=, 31
	i32.shr_s	$8=, $7, $pop127
	i32.const	$push126=, 24
	i32.shr_s	$7=, $7, $pop126
	i32.const	$push125=, 31
	i32.shr_s	$3=, $3, $pop125
	i32.add 	$push61=, $7, $8
	i32.xor 	$push62=, $pop61, $8
	i32.add 	$push63=, $12, $3
	i32.xor 	$push64=, $pop63, $3
	i32.const	$push124=, 255
	i32.and 	$push65=, $pop64, $pop124
	i32.ge_s	$push66=, $pop62, $pop65
	br_if   	5, $pop66       # 5: down to label3
# %bb.29:                               # %lor.lhs.false288
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.add 	$push67=, $6, $7
	i32.const	$push134=, 24
	i32.shl 	$push68=, $pop67, $pop134
	i32.const	$push133=, 24
	i32.shr_s	$push69=, $pop68, $pop133
	i32.ne  	$push70=, $pop69, $11
	br_if   	5, $pop70       # 5: down to label3
.LBB2_30:                               # %cleanup301
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label12:
	i64.const	$push136=, 1
	i64.add 	$0=, $0, $pop136
	i64.const	$push135=, 10000
	i64.lt_u	$push73=, $0, $pop135
	br_if   	0, $pop73       # 0: up to label7
# %bb.31:                               # %for.end
	end_loop
	i32.const	$push74=, 0
	i64.store	simple_rand.seed($pop74), $2
	i32.const	$push137=, 0
	call    	exit@FUNCTION, $pop137
	unreachable
.LBB2_32:                               # %if.then32
	end_block                       # label6:
	i32.const	$push34=, 0
	i64.store	simple_rand.seed($pop34), $2
	call    	abort@FUNCTION
	unreachable
.LBB2_33:                               # %if.then111
	end_block                       # label5:
	i32.const	$push72=, 0
	i64.store	simple_rand.seed($pop72), $2
	call    	abort@FUNCTION
	unreachable
.LBB2_34:                               # %if.then208
	end_block                       # label4:
	i32.const	$push57=, 0
	i64.store	simple_rand.seed($pop57), $2
	call    	abort@FUNCTION
	unreachable
.LBB2_35:                               # %if.then299
	end_block                       # label3:
	i32.const	$push71=, 0
	i64.store	simple_rand.seed($pop71), $2
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
