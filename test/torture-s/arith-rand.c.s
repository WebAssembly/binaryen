	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/arith-rand.c"
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
	i32.store	$discard=, simple_rand.seed($pop0), $pop7
	i32.const	$push5=, 8
	i32.shr_u	$push6=, $0, $pop5
	return  	$pop6
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
	i32.const	$0=, 0
	i32.const	$push7=, 0
	i32.load	$3=, simple_rand.seed($pop7)
	i32.const	$1=, 0
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push15=, 1103515245
	i32.mul 	$push0=, $3, $pop15
	i32.const	$push14=, 12345
	i32.add 	$push13=, $pop0, $pop14
	tee_local	$push12=, $3=, $pop13
	i32.const	$push11=, 9
	i32.shr_u	$push1=, $pop12, $pop11
	i32.const	$push10=, 15
	i32.and 	$push9=, $pop1, $pop10
	tee_local	$push8=, $2=, $pop9
	i32.eqz 	$push20=, $pop8
	br_if   	1, $pop20       # 1: down to label1
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.add 	$1=, $2, $1
	i32.shl 	$0=, $0, $2
	block
	i32.const	$push16=, 256
	i32.and 	$push2=, $3, $pop16
	i32.eqz 	$push21=, $pop2
	br_if   	0, $pop21       # 0: down to label2
# BB#3:                                 # %if.then1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push18=, 1
	i32.shl 	$push3=, $pop18, $2
	i32.const	$push17=, -1
	i32.add 	$push4=, $pop3, $pop17
	i32.or  	$0=, $pop4, $0
.LBB1_4:                                # %if.end
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.const	$push19=, 39
	i32.lt_u	$push5=, $1, $pop19
	br_if   	0, $pop5        # 0: up to label0
.LBB1_5:                                # %cleanup
	end_loop                        # label1:
	i32.const	$push6=, 0
	i32.store	$discard=, simple_rand.seed($pop6), $3
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push58=, 0
	i32.load	$5=, simple_rand.seed($pop58)
	i32.const	$0=, 0
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
                                        #     Child Loop BB2_7 Depth 2
	block
	block
	block
	loop                            # label6:
	i32.const	$1=, 0
	i32.const	$2=, 0
.LBB2_2:                                # %for.cond.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label8:
	i32.const	$push66=, 1103515245
	i32.mul 	$push0=, $5, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push64=, $pop0, $pop65
	tee_local	$push63=, $5=, $pop64
	i32.const	$push62=, 9
	i32.shr_u	$push1=, $pop63, $pop62
	i32.const	$push61=, 15
	i32.and 	$push60=, $pop1, $pop61
	tee_local	$push59=, $4=, $pop60
	i32.eqz 	$push138=, $pop59
	br_if   	1, $pop138      # 1: down to label9
# BB#3:                                 # %if.else.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.add 	$2=, $4, $2
	i32.shl 	$1=, $1, $4
	block
	i32.const	$push67=, 256
	i32.and 	$push2=, $5, $pop67
	i32.eqz 	$push139=, $pop2
	br_if   	0, $pop139      # 0: down to label10
# BB#4:                                 # %if.then1.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.const	$push69=, 1
	i32.shl 	$push3=, $pop69, $4
	i32.const	$push68=, -1
	i32.add 	$push4=, $pop3, $pop68
	i32.or  	$1=, $pop4, $1
.LBB2_5:                                # %if.end.i
                                        #   in Loop: Header=BB2_2 Depth=2
	end_block                       # label10:
	i32.const	$push70=, 39
	i32.lt_u	$push5=, $2, $pop70
	br_if   	0, $pop5        # 0: up to label8
.LBB2_6:                                # %random_bitstring.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label9:
	i32.const	$2=, 0
	i32.const	$3=, 0
.LBB2_7:                                # %for.cond.i339
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label11:
	i32.const	$push78=, 1103515245
	i32.mul 	$push6=, $5, $pop78
	i32.const	$push77=, 12345
	i32.add 	$push76=, $pop6, $pop77
	tee_local	$push75=, $5=, $pop76
	i32.const	$push74=, 9
	i32.shr_u	$push7=, $pop75, $pop74
	i32.const	$push73=, 15
	i32.and 	$push72=, $pop7, $pop73
	tee_local	$push71=, $4=, $pop72
	i32.eqz 	$push140=, $pop71
	br_if   	1, $pop140      # 1: down to label12
# BB#8:                                 # %if.else.i343
                                        #   in Loop: Header=BB2_7 Depth=2
	i32.add 	$3=, $4, $3
	i32.shl 	$2=, $2, $4
	block
	i32.const	$push79=, 256
	i32.and 	$push8=, $5, $pop79
	i32.eqz 	$push141=, $pop8
	br_if   	0, $pop141      # 0: down to label13
# BB#9:                                 # %if.then1.i347
                                        #   in Loop: Header=BB2_7 Depth=2
	i32.const	$push81=, 1
	i32.shl 	$push9=, $pop81, $4
	i32.const	$push80=, -1
	i32.add 	$push10=, $pop9, $pop80
	i32.or  	$2=, $pop10, $2
.LBB2_10:                               # %if.end.i350
                                        #   in Loop: Header=BB2_7 Depth=2
	end_block                       # label13:
	i32.const	$push82=, 39
	i32.lt_u	$push11=, $3, $pop82
	br_if   	0, $pop11       # 0: up to label11
.LBB2_11:                               # %random_bitstring.exit352
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label12:
	block
	i32.eqz 	$push142=, $2
	br_if   	0, $pop142      # 0: down to label14
# BB#12:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i32.const	$push83=, 2147483647
	i32.and 	$push12=, $1, $pop83
	br_if   	0, $pop12       # 0: down to label15
# BB#13:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push84=, -1
	i32.eq  	$push13=, $2, $pop84
	br_if   	1, $pop13       # 1: down to label14
.LBB2_14:                               # %if.end25
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label15:
	i32.rem_s	$4=, $1, $2
	i32.const	$push90=, 31
	i32.shr_s	$push89=, $4, $pop90
	tee_local	$push88=, $3=, $pop89
	i32.add 	$push16=, $4, $pop88
	i32.xor 	$push17=, $pop16, $3
	i32.const	$push87=, 31
	i32.shr_s	$push86=, $2, $pop87
	tee_local	$push85=, $4=, $pop86
	i32.add 	$push14=, $2, $pop85
	i32.xor 	$push15=, $pop14, $4
	i32.ge_u	$push18=, $pop17, $pop15
	br_if   	4, $pop18       # 4: down to label4
# BB#15:                                # %cleanup.cont47
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push91=, 65535
	i32.and 	$push20=, $2, $pop91
	i32.eqz 	$push143=, $pop20
	br_if   	0, $pop143      # 0: down to label14
# BB#16:                                # %cleanup.cont86
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push110=, 16
	i32.shl 	$push21=, $1, $pop110
	i32.const	$push109=, 16
	i32.shr_s	$push108=, $pop21, $pop109
	tee_local	$push107=, $8=, $pop108
	i32.const	$push106=, 16
	i32.shl 	$push105=, $2, $pop106
	tee_local	$push104=, $7=, $pop105
	i32.const	$push103=, 16
	i32.shr_s	$push102=, $pop104, $pop103
	tee_local	$push101=, $4=, $pop102
	i32.rem_s	$push22=, $pop107, $pop101
	i32.const	$push100=, 16
	i32.shl 	$push99=, $pop22, $pop100
	tee_local	$push98=, $6=, $pop99
	i32.const	$push97=, 16
	i32.shr_s	$3=, $pop98, $pop97
	i32.const	$push96=, 0
	i32.sub 	$push24=, $pop96, $3
	i32.const	$push95=, -65536
	i32.gt_s	$push23=, $6, $pop95
	i32.select	$push25=, $3, $pop24, $pop23
	i32.const	$push94=, 0
	i32.sub 	$push27=, $pop94, $4
	i32.const	$push93=, -65536
	i32.gt_s	$push26=, $7, $pop93
	i32.select	$push28=, $4, $pop27, $pop26
	i32.const	$push92=, 65535
	i32.and 	$push29=, $pop28, $pop92
	i32.ge_s	$push30=, $pop25, $pop29
	br_if   	3, $pop30       # 3: down to label5
# BB#17:                                # %lor.lhs.false125
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push31=, $8, $4
	i32.mul 	$push32=, $pop31, $4
	i32.add 	$push33=, $pop32, $3
	i32.const	$push112=, 16
	i32.shl 	$push34=, $pop33, $pop112
	i32.const	$push111=, 16
	i32.shr_s	$push35=, $pop34, $pop111
	i32.ne  	$push36=, $pop35, $8
	br_if   	3, $pop36       # 3: down to label5
# BB#18:                                # %if.end137
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push113=, 255
	i32.and 	$push38=, $2, $pop113
	i32.eqz 	$push144=, $pop38
	br_if   	0, $pop144      # 0: down to label14
# BB#19:                                # %cleanup.cont177
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push132=, 24
	i32.shl 	$push39=, $1, $pop132
	i32.const	$push131=, 24
	i32.shr_s	$push130=, $pop39, $pop131
	tee_local	$push129=, $1=, $pop130
	i32.const	$push128=, 24
	i32.shl 	$push127=, $2, $pop128
	tee_local	$push126=, $3=, $pop127
	i32.const	$push125=, 24
	i32.shr_s	$push124=, $pop126, $pop125
	tee_local	$push123=, $4=, $pop124
	i32.rem_s	$push40=, $pop129, $pop123
	i32.const	$push122=, 24
	i32.shl 	$push121=, $pop40, $pop122
	tee_local	$push120=, $8=, $pop121
	i32.const	$push119=, 24
	i32.shr_s	$2=, $pop120, $pop119
	i32.const	$push118=, 0
	i32.sub 	$push42=, $pop118, $2
	i32.const	$push117=, -16777216
	i32.gt_s	$push41=, $8, $pop117
	i32.select	$push43=, $2, $pop42, $pop41
	i32.const	$push116=, 0
	i32.sub 	$push45=, $pop116, $4
	i32.const	$push115=, -16777216
	i32.gt_s	$push44=, $3, $pop115
	i32.select	$push46=, $4, $pop45, $pop44
	i32.const	$push114=, 255
	i32.and 	$push47=, $pop46, $pop114
	i32.ge_s	$push48=, $pop43, $pop47
	br_if   	5, $pop48       # 5: down to label3
# BB#20:                                # %lor.lhs.false216
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push49=, $1, $4
	i32.mul 	$push50=, $pop49, $4
	i32.add 	$push51=, $pop50, $2
	i32.const	$push134=, 24
	i32.shl 	$push52=, $pop51, $pop134
	i32.const	$push133=, 24
	i32.shr_s	$push53=, $pop52, $pop133
	i32.ne  	$push54=, $pop53, $1
	br_if   	5, $pop54       # 5: down to label3
.LBB2_21:                               # %cleanup229
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label14:
	i32.const	$push136=, 1
	i32.add 	$0=, $0, $pop136
	i32.const	$push135=, 1000
	i32.lt_s	$push56=, $0, $pop135
	br_if   	0, $pop56       # 0: up to label6
# BB#22:                                # %for.end
	end_loop                        # label7:
	i32.const	$push57=, 0
	i32.store	$discard=, simple_rand.seed($pop57), $5
	i32.const	$push137=, 0
	call    	exit@FUNCTION, $pop137
	unreachable
.LBB2_23:                               # %if.then136
	end_block                       # label5:
	i32.const	$push37=, 0
	i32.store	$discard=, simple_rand.seed($pop37), $5
	call    	abort@FUNCTION
	unreachable
.LBB2_24:                               # %if.then40
	end_block                       # label4:
	i32.const	$push19=, 0
	i32.store	$discard=, simple_rand.seed($pop19), $5
	call    	abort@FUNCTION
	unreachable
.LBB2_25:                               # %if.then227
	end_block                       # label3:
	i32.const	$push55=, 0
	i32.store	$discard=, simple_rand.seed($pop55), $5
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
