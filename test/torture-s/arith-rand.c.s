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
	i32.const	$push7=, 0
	i32.load	$0=, simple_rand.seed($pop7)
	i32.const	$1=, 0
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push13=, 1103515245
	i32.mul 	$push0=, $0, $pop13
	i32.const	$push12=, 12345
	i32.add 	$0=, $pop0, $pop12
	i32.const	$push11=, 9
	i32.shr_u	$push1=, $0, $pop11
	i32.const	$push10=, 15
	i32.and 	$push9=, $pop1, $pop10
	tee_local	$push8=, $3=, $pop9
	i32.const	$push18=, 0
	i32.eq  	$push19=, $pop8, $pop18
	br_if   	1, $pop19       # 1: down to label1
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.add 	$1=, $3, $1
	i32.shl 	$2=, $2, $3
	block
	i32.const	$push14=, 256
	i32.and 	$push2=, $0, $pop14
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop2, $pop20
	br_if   	0, $pop21       # 0: down to label2
# BB#3:                                 # %if.then1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push16=, 1
	i32.shl 	$push3=, $pop16, $3
	i32.const	$push15=, -1
	i32.add 	$push4=, $pop3, $pop15
	i32.or  	$2=, $pop4, $2
.LBB1_4:                                # %if.end
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.const	$push17=, 39
	i32.lt_u	$push5=, $1, $pop17
	br_if   	0, $pop5        # 0: up to label0
.LBB1_5:                                # %cleanup
	end_loop                        # label1:
	i32.const	$push6=, 0
	i32.store	$discard=, simple_rand.seed($pop6), $0
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
	i32.const	$push58=, 0
	i32.load	$1=, simple_rand.seed($pop58)
	i32.const	$0=, 0
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
                                        #     Child Loop BB2_7 Depth 2
	block
	block
	block
	loop                            # label6:
	i32.const	$2=, 0
	i32.const	$4=, 0
.LBB2_2:                                # %for.cond.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label8:
	i32.const	$push64=, 1103515245
	i32.mul 	$push0=, $1, $pop64
	i32.const	$push63=, 12345
	i32.add 	$1=, $pop0, $pop63
	i32.const	$push62=, 9
	i32.shr_u	$push1=, $1, $pop62
	i32.const	$push61=, 15
	i32.and 	$push60=, $pop1, $pop61
	tee_local	$push59=, $5=, $pop60
	i32.const	$push134=, 0
	i32.eq  	$push135=, $pop59, $pop134
	br_if   	1, $pop135      # 1: down to label9
# BB#3:                                 # %if.else.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.add 	$4=, $5, $4
	i32.shl 	$2=, $2, $5
	block
	i32.const	$push65=, 256
	i32.and 	$push2=, $1, $pop65
	i32.const	$push136=, 0
	i32.eq  	$push137=, $pop2, $pop136
	br_if   	0, $pop137      # 0: down to label10
# BB#4:                                 # %if.then1.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.const	$push67=, 1
	i32.shl 	$push3=, $pop67, $5
	i32.const	$push66=, -1
	i32.add 	$push4=, $pop3, $pop66
	i32.or  	$2=, $pop4, $2
.LBB2_5:                                # %if.end.i
                                        #   in Loop: Header=BB2_2 Depth=2
	end_block                       # label10:
	i32.const	$push68=, 39
	i32.lt_u	$push5=, $4, $pop68
	br_if   	0, $pop5        # 0: up to label8
.LBB2_6:                                # %random_bitstring.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label9:
	i32.const	$4=, 0
	i32.const	$3=, 0
.LBB2_7:                                # %for.cond.i339
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label11:
	i32.const	$push74=, 1103515245
	i32.mul 	$push6=, $1, $pop74
	i32.const	$push73=, 12345
	i32.add 	$1=, $pop6, $pop73
	i32.const	$push72=, 9
	i32.shr_u	$push7=, $1, $pop72
	i32.const	$push71=, 15
	i32.and 	$push70=, $pop7, $pop71
	tee_local	$push69=, $5=, $pop70
	i32.const	$push138=, 0
	i32.eq  	$push139=, $pop69, $pop138
	br_if   	1, $pop139      # 1: down to label12
# BB#8:                                 # %if.else.i343
                                        #   in Loop: Header=BB2_7 Depth=2
	i32.add 	$3=, $5, $3
	i32.shl 	$4=, $4, $5
	block
	i32.const	$push75=, 256
	i32.and 	$push8=, $1, $pop75
	i32.const	$push140=, 0
	i32.eq  	$push141=, $pop8, $pop140
	br_if   	0, $pop141      # 0: down to label13
# BB#9:                                 # %if.then1.i347
                                        #   in Loop: Header=BB2_7 Depth=2
	i32.const	$push77=, 1
	i32.shl 	$push9=, $pop77, $5
	i32.const	$push76=, -1
	i32.add 	$push10=, $pop9, $pop76
	i32.or  	$4=, $pop10, $4
.LBB2_10:                               # %if.end.i350
                                        #   in Loop: Header=BB2_7 Depth=2
	end_block                       # label13:
	i32.const	$push78=, 39
	i32.lt_u	$push11=, $3, $pop78
	br_if   	0, $pop11       # 0: up to label11
.LBB2_11:                               # %random_bitstring.exit352
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label12:
	block
	i32.const	$push142=, 0
	i32.eq  	$push143=, $4, $pop142
	br_if   	0, $pop143      # 0: down to label14
# BB#12:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i32.const	$push79=, 2147483647
	i32.and 	$push12=, $2, $pop79
	br_if   	0, $pop12       # 0: down to label15
# BB#13:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push80=, -1
	i32.eq  	$push13=, $4, $pop80
	br_if   	1, $pop13       # 1: down to label14
.LBB2_14:                               # %if.end25
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label15:
	i32.rem_s	$5=, $2, $4
	i32.const	$push86=, 31
	i32.shr_s	$push85=, $5, $pop86
	tee_local	$push84=, $3=, $pop85
	i32.add 	$push16=, $5, $pop84
	i32.xor 	$push17=, $pop16, $3
	i32.const	$push83=, 31
	i32.shr_s	$push82=, $4, $pop83
	tee_local	$push81=, $5=, $pop82
	i32.add 	$push14=, $4, $pop81
	i32.xor 	$push15=, $pop14, $5
	i32.ge_u	$push18=, $pop17, $pop15
	br_if   	4, $pop18       # 4: down to label4
# BB#15:                                # %cleanup.cont47
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push87=, 65535
	i32.and 	$push20=, $4, $pop87
	i32.const	$push144=, 0
	i32.eq  	$push145=, $pop20, $pop144
	br_if   	0, $pop145      # 0: down to label14
# BB#16:                                # %cleanup.cont86
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push106=, 16
	i32.shl 	$push21=, $2, $pop106
	i32.const	$push105=, 16
	i32.shr_s	$push104=, $pop21, $pop105
	tee_local	$push103=, $8=, $pop104
	i32.const	$push102=, 16
	i32.shl 	$push101=, $4, $pop102
	tee_local	$push100=, $7=, $pop101
	i32.const	$push99=, 16
	i32.shr_s	$push98=, $pop100, $pop99
	tee_local	$push97=, $5=, $pop98
	i32.rem_s	$push22=, $pop103, $pop97
	i32.const	$push96=, 16
	i32.shl 	$push95=, $pop22, $pop96
	tee_local	$push94=, $6=, $pop95
	i32.const	$push93=, 16
	i32.shr_s	$3=, $pop94, $pop93
	i32.const	$push92=, 0
	i32.sub 	$push24=, $pop92, $3
	i32.const	$push91=, -65536
	i32.gt_s	$push23=, $6, $pop91
	i32.select	$push25=, $3, $pop24, $pop23
	i32.const	$push90=, 0
	i32.sub 	$push27=, $pop90, $5
	i32.const	$push89=, -65536
	i32.gt_s	$push26=, $7, $pop89
	i32.select	$push28=, $5, $pop27, $pop26
	i32.const	$push88=, 65535
	i32.and 	$push29=, $pop28, $pop88
	i32.ge_s	$push30=, $pop25, $pop29
	br_if   	3, $pop30       # 3: down to label5
# BB#17:                                # %lor.lhs.false125
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push31=, $8, $5
	i32.mul 	$push32=, $pop31, $5
	i32.add 	$push33=, $pop32, $3
	i32.const	$push108=, 16
	i32.shl 	$push34=, $pop33, $pop108
	i32.const	$push107=, 16
	i32.shr_s	$push35=, $pop34, $pop107
	i32.ne  	$push36=, $pop35, $8
	br_if   	3, $pop36       # 3: down to label5
# BB#18:                                # %if.end137
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push109=, 255
	i32.and 	$push38=, $4, $pop109
	i32.const	$push146=, 0
	i32.eq  	$push147=, $pop38, $pop146
	br_if   	0, $pop147      # 0: down to label14
# BB#19:                                # %cleanup.cont177
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push128=, 24
	i32.shl 	$push39=, $2, $pop128
	i32.const	$push127=, 24
	i32.shr_s	$push126=, $pop39, $pop127
	tee_local	$push125=, $2=, $pop126
	i32.const	$push124=, 24
	i32.shl 	$push123=, $4, $pop124
	tee_local	$push122=, $3=, $pop123
	i32.const	$push121=, 24
	i32.shr_s	$push120=, $pop122, $pop121
	tee_local	$push119=, $5=, $pop120
	i32.rem_s	$push40=, $pop125, $pop119
	i32.const	$push118=, 24
	i32.shl 	$push117=, $pop40, $pop118
	tee_local	$push116=, $8=, $pop117
	i32.const	$push115=, 24
	i32.shr_s	$4=, $pop116, $pop115
	i32.const	$push114=, 0
	i32.sub 	$push42=, $pop114, $4
	i32.const	$push113=, -16777216
	i32.gt_s	$push41=, $8, $pop113
	i32.select	$push43=, $4, $pop42, $pop41
	i32.const	$push112=, 0
	i32.sub 	$push45=, $pop112, $5
	i32.const	$push111=, -16777216
	i32.gt_s	$push44=, $3, $pop111
	i32.select	$push46=, $5, $pop45, $pop44
	i32.const	$push110=, 255
	i32.and 	$push47=, $pop46, $pop110
	i32.ge_s	$push48=, $pop43, $pop47
	br_if   	5, $pop48       # 5: down to label3
# BB#20:                                # %lor.lhs.false216
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push49=, $2, $5
	i32.mul 	$push50=, $pop49, $5
	i32.add 	$push51=, $pop50, $4
	i32.const	$push130=, 24
	i32.shl 	$push52=, $pop51, $pop130
	i32.const	$push129=, 24
	i32.shr_s	$push53=, $pop52, $pop129
	i32.ne  	$push54=, $pop53, $2
	br_if   	5, $pop54       # 5: down to label3
.LBB2_21:                               # %cleanup229
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label14:
	i32.const	$push132=, 1
	i32.add 	$0=, $0, $pop132
	i32.const	$push131=, 1000
	i32.lt_s	$push56=, $0, $pop131
	br_if   	0, $pop56       # 0: up to label6
# BB#22:                                # %for.end
	end_loop                        # label7:
	i32.const	$push57=, 0
	i32.store	$discard=, simple_rand.seed($pop57), $1
	i32.const	$push133=, 0
	call    	exit@FUNCTION, $pop133
	unreachable
.LBB2_23:                               # %if.then136
	end_block                       # label5:
	i32.const	$push37=, 0
	i32.store	$discard=, simple_rand.seed($pop37), $1
	call    	abort@FUNCTION
	unreachable
.LBB2_24:                               # %if.then40
	end_block                       # label4:
	i32.const	$push19=, 0
	i32.store	$discard=, simple_rand.seed($pop19), $1
	call    	abort@FUNCTION
	unreachable
.LBB2_25:                               # %if.then227
	end_block                       # label3:
	i32.const	$push55=, 0
	i32.store	$discard=, simple_rand.seed($pop55), $1
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


	.ident	"clang version 3.9.0 "
