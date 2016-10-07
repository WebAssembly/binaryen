	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/arith-rand.c"
	.section	.text.simple_rand,"ax",@progbits
	.hidden	simple_rand
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

	.section	.text.random_bitstring,"ax",@progbits
	.hidden	random_bitstring
	.globl	random_bitstring
	.type	random_bitstring,@function
random_bitstring:                       # @random_bitstring
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.const	$push7=, 0
	i32.load	$1=, simple_rand.seed($pop7)
	i32.const	$3=, 0
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label1:
	i32.const	$push15=, 1103515245
	i32.mul 	$push0=, $1, $pop15
	i32.const	$push14=, 12345
	i32.add 	$push13=, $pop0, $pop14
	tee_local	$push12=, $1=, $pop13
	i32.const	$push11=, 9
	i32.shr_u	$push1=, $pop12, $pop11
	i32.const	$push10=, 15
	i32.and 	$push9=, $pop1, $pop10
	tee_local	$push8=, $0=, $pop9
	i32.eqz 	$push20=, $pop8
	br_if   	1, $pop20       # 1: down to label0
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.add 	$3=, $0, $3
	i32.shl 	$2=, $2, $0
	block   	
	i32.const	$push16=, 256
	i32.and 	$push2=, $1, $pop16
	i32.eqz 	$push21=, $pop2
	br_if   	0, $pop21       # 0: down to label2
# BB#3:                                 # %if.then1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push18=, 1
	i32.shl 	$push3=, $pop18, $0
	i32.const	$push17=, -1
	i32.add 	$push4=, $pop3, $pop17
	i32.or  	$2=, $pop4, $2
.LBB1_4:                                # %if.end
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.const	$push19=, 39
	i32.lt_u	$push5=, $3, $pop19
	br_if   	0, $pop5        # 0: up to label1
.LBB1_5:                                # %cleanup
	end_loop
	end_block                       # label0:
	i32.const	$push6=, 0
	i32.store	simple_rand.seed($pop6), $1
	copy_local	$push22=, $2
                                        # fallthrough-return: $pop22
	.endfunc
.Lfunc_end1:
	.size	random_bitstring, .Lfunc_end1-random_bitstring

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push58=, 0
	i32.load	$2=, simple_rand.seed($pop58)
	i32.const	$0=, 0
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
                                        #     Child Loop BB2_7 Depth 2
	block   	
	block   	
	block   	
	loop    	                # label6:
	i32.const	$6=, 0
	i32.const	$7=, 0
.LBB2_2:                                # %for.cond.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label8:
	i32.const	$push66=, 1103515245
	i32.mul 	$push0=, $2, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push64=, $pop0, $pop65
	tee_local	$push63=, $2=, $pop64
	i32.const	$push62=, 9
	i32.shr_u	$push1=, $pop63, $pop62
	i32.const	$push61=, 15
	i32.and 	$push60=, $pop1, $pop61
	tee_local	$push59=, $1=, $pop60
	i32.eqz 	$push146=, $pop59
	br_if   	1, $pop146      # 1: down to label7
# BB#3:                                 # %if.else.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.add 	$7=, $1, $7
	i32.shl 	$6=, $6, $1
	block   	
	i32.const	$push67=, 256
	i32.and 	$push2=, $2, $pop67
	i32.eqz 	$push147=, $pop2
	br_if   	0, $pop147      # 0: down to label9
# BB#4:                                 # %if.then1.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.const	$push69=, 1
	i32.shl 	$push3=, $pop69, $1
	i32.const	$push68=, -1
	i32.add 	$push4=, $pop3, $pop68
	i32.or  	$6=, $pop4, $6
.LBB2_5:                                # %if.end.i
                                        #   in Loop: Header=BB2_2 Depth=2
	end_block                       # label9:
	i32.const	$push70=, 39
	i32.lt_u	$push5=, $7, $pop70
	br_if   	0, $pop5        # 0: up to label8
.LBB2_6:                                # %random_bitstring.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	end_block                       # label7:
	i32.const	$7=, 0
	i32.const	$8=, 0
.LBB2_7:                                # %for.cond.i339
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label11:
	i32.const	$push78=, 1103515245
	i32.mul 	$push6=, $2, $pop78
	i32.const	$push77=, 12345
	i32.add 	$push76=, $pop6, $pop77
	tee_local	$push75=, $2=, $pop76
	i32.const	$push74=, 9
	i32.shr_u	$push7=, $pop75, $pop74
	i32.const	$push73=, 15
	i32.and 	$push72=, $pop7, $pop73
	tee_local	$push71=, $1=, $pop72
	i32.eqz 	$push148=, $pop71
	br_if   	1, $pop148      # 1: down to label10
# BB#8:                                 # %if.else.i343
                                        #   in Loop: Header=BB2_7 Depth=2
	i32.add 	$8=, $1, $8
	i32.shl 	$7=, $7, $1
	block   	
	i32.const	$push79=, 256
	i32.and 	$push8=, $2, $pop79
	i32.eqz 	$push149=, $pop8
	br_if   	0, $pop149      # 0: down to label12
# BB#9:                                 # %if.then1.i347
                                        #   in Loop: Header=BB2_7 Depth=2
	i32.const	$push81=, 1
	i32.shl 	$push9=, $pop81, $1
	i32.const	$push80=, -1
	i32.add 	$push10=, $pop9, $pop80
	i32.or  	$7=, $pop10, $7
.LBB2_10:                               # %if.end.i350
                                        #   in Loop: Header=BB2_7 Depth=2
	end_block                       # label12:
	i32.const	$push82=, 39
	i32.lt_u	$push11=, $8, $pop82
	br_if   	0, $pop11       # 0: up to label11
.LBB2_11:                               # %random_bitstring.exit352
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop
	end_block                       # label10:
	block   	
	i32.eqz 	$push150=, $7
	br_if   	0, $pop150      # 0: down to label13
# BB#12:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	block   	
	i32.const	$push83=, 2147483647
	i32.and 	$push12=, $6, $pop83
	br_if   	0, $pop12       # 0: down to label14
# BB#13:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push84=, -1
	i32.eq  	$push13=, $7, $pop84
	br_if   	1, $pop13       # 1: down to label13
.LBB2_14:                               # %if.end25
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label14:
	i32.rem_s	$push92=, $6, $7
	tee_local	$push91=, $1=, $pop92
	i32.const	$push90=, 31
	i32.shr_s	$push89=, $1, $pop90
	tee_local	$push88=, $1=, $pop89
	i32.add 	$push16=, $pop91, $pop88
	i32.xor 	$push17=, $pop16, $1
	i32.const	$push87=, 31
	i32.shr_s	$push86=, $7, $pop87
	tee_local	$push85=, $1=, $pop86
	i32.add 	$push14=, $7, $pop85
	i32.xor 	$push15=, $pop14, $1
	i32.ge_u	$push18=, $pop17, $pop15
	br_if   	3, $pop18       # 3: down to label4
# BB#15:                                # %cleanup.cont47
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push93=, 65535
	i32.and 	$push20=, $7, $pop93
	i32.eqz 	$push151=, $pop20
	br_if   	0, $pop151      # 0: down to label13
# BB#16:                                # %cleanup.cont86
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push114=, 16
	i32.shl 	$push21=, $6, $pop114
	i32.const	$push113=, 16
	i32.shr_s	$push112=, $pop21, $pop113
	tee_local	$push111=, $3=, $pop112
	i32.const	$push110=, 16
	i32.shl 	$push109=, $7, $pop110
	tee_local	$push108=, $4=, $pop109
	i32.const	$push107=, 16
	i32.shr_s	$push106=, $pop108, $pop107
	tee_local	$push105=, $1=, $pop106
	i32.rem_s	$push22=, $pop111, $pop105
	i32.const	$push104=, 16
	i32.shl 	$push103=, $pop22, $pop104
	tee_local	$push102=, $5=, $pop103
	i32.const	$push101=, 16
	i32.shr_s	$push100=, $pop102, $pop101
	tee_local	$push99=, $8=, $pop100
	i32.const	$push98=, 0
	i32.sub 	$push24=, $pop98, $8
	i32.const	$push97=, -65536
	i32.gt_s	$push23=, $5, $pop97
	i32.select	$push25=, $pop99, $pop24, $pop23
	i32.const	$push96=, 0
	i32.sub 	$push27=, $pop96, $1
	i32.const	$push95=, -65536
	i32.gt_s	$push26=, $4, $pop95
	i32.select	$push28=, $1, $pop27, $pop26
	i32.const	$push94=, 65535
	i32.and 	$push29=, $pop28, $pop94
	i32.ge_s	$push30=, $pop25, $pop29
	br_if   	2, $pop30       # 2: down to label5
# BB#17:                                # %lor.lhs.false125
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push31=, $3, $1
	i32.mul 	$push32=, $pop31, $1
	i32.add 	$push33=, $pop32, $8
	i32.const	$push116=, 16
	i32.shl 	$push34=, $pop33, $pop116
	i32.const	$push115=, 16
	i32.shr_s	$push35=, $pop34, $pop115
	i32.ne  	$push36=, $pop35, $3
	br_if   	2, $pop36       # 2: down to label5
# BB#18:                                # %if.end137
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push117=, 255
	i32.and 	$push38=, $7, $pop117
	i32.eqz 	$push152=, $pop38
	br_if   	0, $pop152      # 0: down to label13
# BB#19:                                # %cleanup.cont177
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push138=, 24
	i32.shl 	$push39=, $6, $pop138
	i32.const	$push137=, 24
	i32.shr_s	$push136=, $pop39, $pop137
	tee_local	$push135=, $6=, $pop136
	i32.const	$push134=, 24
	i32.shl 	$push133=, $7, $pop134
	tee_local	$push132=, $8=, $pop133
	i32.const	$push131=, 24
	i32.shr_s	$push130=, $pop132, $pop131
	tee_local	$push129=, $1=, $pop130
	i32.rem_s	$push40=, $pop135, $pop129
	i32.const	$push128=, 24
	i32.shl 	$push127=, $pop40, $pop128
	tee_local	$push126=, $3=, $pop127
	i32.const	$push125=, 24
	i32.shr_s	$push124=, $pop126, $pop125
	tee_local	$push123=, $7=, $pop124
	i32.const	$push122=, 0
	i32.sub 	$push42=, $pop122, $7
	i32.const	$push121=, -16777216
	i32.gt_s	$push41=, $3, $pop121
	i32.select	$push43=, $pop123, $pop42, $pop41
	i32.const	$push120=, 0
	i32.sub 	$push45=, $pop120, $1
	i32.const	$push119=, -16777216
	i32.gt_s	$push44=, $8, $pop119
	i32.select	$push46=, $1, $pop45, $pop44
	i32.const	$push118=, 255
	i32.and 	$push47=, $pop46, $pop118
	i32.ge_s	$push48=, $pop43, $pop47
	br_if   	4, $pop48       # 4: down to label3
# BB#20:                                # %lor.lhs.false216
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push49=, $6, $1
	i32.mul 	$push50=, $pop49, $1
	i32.add 	$push51=, $pop50, $7
	i32.const	$push140=, 24
	i32.shl 	$push52=, $pop51, $pop140
	i32.const	$push139=, 24
	i32.shr_s	$push53=, $pop52, $pop139
	i32.ne  	$push54=, $pop53, $6
	br_if   	4, $pop54       # 4: down to label3
.LBB2_21:                               # %cleanup229
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label13:
	i32.const	$push144=, 1
	i32.add 	$push143=, $0, $pop144
	tee_local	$push142=, $0=, $pop143
	i32.const	$push141=, 1000
	i32.lt_s	$push56=, $pop142, $pop141
	br_if   	0, $pop56       # 0: up to label6
# BB#22:                                # %for.end
	end_loop
	i32.const	$push57=, 0
	i32.store	simple_rand.seed($pop57), $2
	i32.const	$push145=, 0
	call    	exit@FUNCTION, $pop145
	unreachable
.LBB2_23:                               # %if.then136
	end_block                       # label5:
	i32.const	$push37=, 0
	i32.store	simple_rand.seed($pop37), $2
	call    	abort@FUNCTION
	unreachable
.LBB2_24:                               # %if.then40
	end_block                       # label4:
	i32.const	$push19=, 0
	i32.store	simple_rand.seed($pop19), $2
	call    	abort@FUNCTION
	unreachable
.LBB2_25:                               # %if.then227
	end_block                       # label3:
	i32.const	$push55=, 0
	i32.store	simple_rand.seed($pop55), $2
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	simple_rand.seed,@object # @simple_rand.seed
	.section	.data.simple_rand.seed,"aw",@progbits
	.p2align	2
simple_rand.seed:
	.int32	47114711                # 0x2cee9d7
	.size	simple_rand.seed, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
