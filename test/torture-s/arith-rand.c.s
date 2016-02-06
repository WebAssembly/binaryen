	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/arith-rand.c"
	.section	.text.simple_rand,"ax",@progbits
	.hidden	simple_rand
	.globl	simple_rand
	.type	simple_rand,@function
simple_rand:                            # @simple_rand
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push9=, 0
	i32.load	$push1=, simple_rand.seed($pop9)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push5=, $pop3, $pop4
	i32.store	$push6=, simple_rand.seed($pop0), $pop5
	i32.const	$push7=, 8
	i32.shr_u	$push8=, $pop6, $pop7
	return  	$pop8
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
	i32.const	$push8=, 0
	i32.load	$0=, simple_rand.seed($pop8)
	i32.const	$1=, 0
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push13=, 1103515245
	i32.mul 	$push1=, $0, $pop13
	i32.const	$push12=, 12345
	i32.add 	$0=, $pop1, $pop12
	i32.const	$push11=, 9
	i32.shr_u	$push2=, $0, $pop11
	i32.const	$push10=, 15
	i32.and 	$push0=, $pop2, $pop10
	tee_local	$push9=, $3=, $pop0
	i32.const	$push18=, 0
	i32.eq  	$push19=, $pop9, $pop18
	br_if   	$pop19, 1       # 1: down to label1
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.add 	$1=, $3, $1
	i32.shl 	$2=, $2, $3
	block
	i32.const	$push14=, 256
	i32.and 	$push3=, $0, $pop14
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop3, $pop20
	br_if   	$pop21, 0       # 0: down to label2
# BB#3:                                 # %if.then1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push16=, 1
	i32.shl 	$push4=, $pop16, $3
	i32.const	$push15=, -1
	i32.add 	$push5=, $pop4, $pop15
	i32.or  	$2=, $pop5, $2
.LBB1_4:                                # %if.end
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.const	$push17=, 39
	i32.lt_u	$push6=, $1, $pop17
	br_if   	$pop6, 0        # 0: up to label0
.LBB1_5:                                # %cleanup
	end_loop                        # label1:
	i32.const	$push7=, 0
	i32.store	$discard=, simple_rand.seed($pop7), $0
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push70=, 0
	i32.load	$1=, simple_rand.seed($pop70)
	i32.const	$0=, 0
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
                                        #     Child Loop BB2_7 Depth 2
	loop                            # label3:
	i32.const	$2=, 0
	i32.const	$4=, 0
.LBB2_2:                                # %for.cond.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label5:
	i32.const	$push75=, 1103515245
	i32.mul 	$push6=, $1, $pop75
	i32.const	$push74=, 12345
	i32.add 	$1=, $pop6, $pop74
	i32.const	$push73=, 9
	i32.shr_u	$push7=, $1, $pop73
	i32.const	$push72=, 15
	i32.and 	$push0=, $pop7, $pop72
	tee_local	$push71=, $5=, $pop0
	i32.const	$push134=, 0
	i32.eq  	$push135=, $pop71, $pop134
	br_if   	$pop135, 1      # 1: down to label6
# BB#3:                                 # %if.else.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.add 	$4=, $5, $4
	i32.shl 	$2=, $2, $5
	block
	i32.const	$push76=, 256
	i32.and 	$push8=, $1, $pop76
	i32.const	$push136=, 0
	i32.eq  	$push137=, $pop8, $pop136
	br_if   	$pop137, 0      # 0: down to label7
# BB#4:                                 # %if.then1.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.const	$push78=, 1
	i32.shl 	$push9=, $pop78, $5
	i32.const	$push77=, -1
	i32.add 	$push10=, $pop9, $pop77
	i32.or  	$2=, $pop10, $2
.LBB2_5:                                # %if.end.i
                                        #   in Loop: Header=BB2_2 Depth=2
	end_block                       # label7:
	i32.const	$push79=, 39
	i32.lt_u	$push11=, $4, $pop79
	br_if   	$pop11, 0       # 0: up to label5
.LBB2_6:                                # %random_bitstring.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label6:
	i32.const	$4=, 0
	i32.const	$3=, 0
.LBB2_7:                                # %for.cond.i339
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label8:
	i32.const	$push84=, 1103515245
	i32.mul 	$push12=, $1, $pop84
	i32.const	$push83=, 12345
	i32.add 	$1=, $pop12, $pop83
	i32.const	$push82=, 9
	i32.shr_u	$push13=, $1, $pop82
	i32.const	$push81=, 15
	i32.and 	$push1=, $pop13, $pop81
	tee_local	$push80=, $5=, $pop1
	i32.const	$push138=, 0
	i32.eq  	$push139=, $pop80, $pop138
	br_if   	$pop139, 1      # 1: down to label9
# BB#8:                                 # %if.else.i343
                                        #   in Loop: Header=BB2_7 Depth=2
	i32.add 	$3=, $5, $3
	i32.shl 	$4=, $4, $5
	block
	i32.const	$push85=, 256
	i32.and 	$push14=, $1, $pop85
	i32.const	$push140=, 0
	i32.eq  	$push141=, $pop14, $pop140
	br_if   	$pop141, 0      # 0: down to label10
# BB#9:                                 # %if.then1.i347
                                        #   in Loop: Header=BB2_7 Depth=2
	i32.const	$push87=, 1
	i32.shl 	$push15=, $pop87, $5
	i32.const	$push86=, -1
	i32.add 	$push16=, $pop15, $pop86
	i32.or  	$4=, $pop16, $4
.LBB2_10:                               # %if.end.i350
                                        #   in Loop: Header=BB2_7 Depth=2
	end_block                       # label10:
	i32.const	$push88=, 39
	i32.lt_u	$push17=, $3, $pop88
	br_if   	$pop17, 0       # 0: up to label8
.LBB2_11:                               # %random_bitstring.exit352
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label9:
	block
	i32.const	$push142=, 0
	i32.eq  	$push143=, $4, $pop142
	br_if   	$pop143, 0      # 0: down to label11
# BB#12:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i32.const	$push89=, 2147483647
	i32.and 	$push18=, $2, $pop89
	br_if   	$pop18, 0       # 0: down to label12
# BB#13:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push90=, -1
	i32.eq  	$push19=, $4, $pop90
	br_if   	$pop19, 1       # 1: down to label11
.LBB2_14:                               # %if.end25
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label12:
	i32.rem_s	$5=, $2, $4
	block
	i32.const	$push94=, 31
	i32.shr_s	$push23=, $5, $pop94
	tee_local	$push93=, $3=, $pop23
	i32.add 	$push24=, $5, $pop93
	i32.xor 	$push25=, $pop24, $3
	i32.const	$push92=, 31
	i32.shr_s	$push20=, $4, $pop92
	tee_local	$push91=, $5=, $pop20
	i32.add 	$push21=, $4, $pop91
	i32.xor 	$push22=, $pop21, $5
	i32.ge_u	$push26=, $pop25, $pop22
	br_if   	$pop26, 0       # 0: down to label13
# BB#15:                                # %cleanup.cont47
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push95=, 65535
	i32.and 	$push28=, $4, $pop95
	i32.const	$push144=, 0
	i32.eq  	$push145=, $pop28, $pop144
	br_if   	$pop145, 1      # 1: down to label11
# BB#16:                                # %cleanup.cont86
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push110=, 16
	i32.shl 	$push29=, $2, $pop110
	i32.const	$push109=, 16
	i32.shr_s	$push2=, $pop29, $pop109
	tee_local	$push108=, $8=, $pop2
	i32.const	$push107=, 16
	i32.shl 	$push30=, $4, $pop107
	tee_local	$push106=, $7=, $pop30
	i32.const	$push105=, 16
	i32.shr_s	$push3=, $pop106, $pop105
	tee_local	$push104=, $5=, $pop3
	i32.rem_s	$push31=, $pop108, $pop104
	i32.const	$push103=, 16
	i32.shl 	$push32=, $pop31, $pop103
	tee_local	$push102=, $6=, $pop32
	i32.const	$push101=, 16
	i32.shr_s	$3=, $pop102, $pop101
	block
	i32.const	$push100=, 0
	i32.sub 	$push34=, $pop100, $3
	i32.const	$push99=, -65536
	i32.gt_s	$push33=, $6, $pop99
	i32.select	$push35=, $3, $pop34, $pop33
	i32.const	$push98=, 0
	i32.sub 	$push37=, $pop98, $5
	i32.const	$push97=, -65536
	i32.gt_s	$push36=, $7, $pop97
	i32.select	$push38=, $5, $pop37, $pop36
	i32.const	$push96=, 65535
	i32.and 	$push39=, $pop38, $pop96
	i32.ge_s	$push40=, $pop35, $pop39
	br_if   	$pop40, 0       # 0: down to label14
# BB#17:                                # %lor.lhs.false125
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push41=, $8, $5
	i32.mul 	$push42=, $pop41, $5
	i32.add 	$push43=, $pop42, $3
	i32.const	$push112=, 16
	i32.shl 	$push44=, $pop43, $pop112
	i32.const	$push111=, 16
	i32.shr_s	$push45=, $pop44, $pop111
	i32.ne  	$push46=, $pop45, $8
	br_if   	$pop46, 0       # 0: down to label14
# BB#18:                                # %if.end137
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push113=, 255
	i32.and 	$push48=, $4, $pop113
	i32.const	$push146=, 0
	i32.eq  	$push147=, $pop48, $pop146
	br_if   	$pop147, 2      # 2: down to label11
# BB#19:                                # %cleanup.cont177
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push128=, 24
	i32.shl 	$push49=, $2, $pop128
	i32.const	$push127=, 24
	i32.shr_s	$push4=, $pop49, $pop127
	tee_local	$push126=, $2=, $pop4
	i32.const	$push125=, 24
	i32.shl 	$push50=, $4, $pop125
	tee_local	$push124=, $3=, $pop50
	i32.const	$push123=, 24
	i32.shr_s	$push5=, $pop124, $pop123
	tee_local	$push122=, $5=, $pop5
	i32.rem_s	$push51=, $pop126, $pop122
	i32.const	$push121=, 24
	i32.shl 	$push52=, $pop51, $pop121
	tee_local	$push120=, $8=, $pop52
	i32.const	$push119=, 24
	i32.shr_s	$4=, $pop120, $pop119
	block
	i32.const	$push118=, 0
	i32.sub 	$push54=, $pop118, $4
	i32.const	$push117=, -16777216
	i32.gt_s	$push53=, $8, $pop117
	i32.select	$push55=, $4, $pop54, $pop53
	i32.const	$push116=, 0
	i32.sub 	$push57=, $pop116, $5
	i32.const	$push115=, -16777216
	i32.gt_s	$push56=, $3, $pop115
	i32.select	$push58=, $5, $pop57, $pop56
	i32.const	$push114=, 255
	i32.and 	$push59=, $pop58, $pop114
	i32.ge_s	$push60=, $pop55, $pop59
	br_if   	$pop60, 0       # 0: down to label15
# BB#20:                                # %lor.lhs.false216
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push61=, $2, $5
	i32.mul 	$push62=, $pop61, $5
	i32.add 	$push63=, $pop62, $4
	i32.const	$push130=, 24
	i32.shl 	$push64=, $pop63, $pop130
	i32.const	$push129=, 24
	i32.shr_s	$push65=, $pop64, $pop129
	i32.eq  	$push66=, $pop65, $2
	br_if   	$pop66, 3       # 3: down to label11
.LBB2_21:                               # %if.then227
	end_block                       # label15:
	i32.const	$push67=, 0
	i32.store	$discard=, simple_rand.seed($pop67), $1
	call    	abort@FUNCTION
	unreachable
.LBB2_22:                               # %if.then136
	end_block                       # label14:
	i32.const	$push47=, 0
	i32.store	$discard=, simple_rand.seed($pop47), $1
	call    	abort@FUNCTION
	unreachable
.LBB2_23:                               # %if.then40
	end_block                       # label13:
	i32.const	$push27=, 0
	i32.store	$discard=, simple_rand.seed($pop27), $1
	call    	abort@FUNCTION
	unreachable
.LBB2_24:                               # %cleanup229
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label11:
	i32.const	$push132=, 1
	i32.add 	$0=, $0, $pop132
	i32.const	$push131=, 1000
	i32.lt_s	$push68=, $0, $pop131
	br_if   	$pop68, 0       # 0: up to label3
# BB#25:                                # %for.end
	end_loop                        # label4:
	i32.const	$push69=, 0
	i32.store	$discard=, simple_rand.seed($pop69), $1
	i32.const	$push133=, 0
	call    	exit@FUNCTION, $pop133
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


	.ident	"clang version 3.9.0 "
