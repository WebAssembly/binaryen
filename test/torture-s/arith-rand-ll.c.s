	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/arith-rand-ll.c"
	.section	.text.simple_rand,"ax",@progbits
	.hidden	simple_rand
	.globl	simple_rand
	.type	simple_rand,@function
simple_rand:                            # @simple_rand
	.result 	i64
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i64.load	$push0=, simple_rand.seed($0)
	i64.const	$push1=, 1103515245
	i64.mul 	$push2=, $pop0, $pop1
	i64.const	$push3=, 12345
	i64.add 	$push4=, $pop2, $pop3
	i64.store	$push5=, simple_rand.seed($0), $pop4
	i64.const	$push6=, 8
	i64.shr_u	$push7=, $pop5, $pop6
	return  	$pop7
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
	i32.const	$3=, 0
	i64.load	$2=, simple_rand.seed($3)
	i64.const	$4=, 0
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i64.const	$push0=, 1103515245
	i64.mul 	$push1=, $2, $pop0
	i64.const	$push2=, 12345
	i64.add 	$2=, $pop1, $pop2
	i64.const	$push3=, 9
	i64.shr_u	$0=, $2, $pop3
	i32.wrap/i64	$push4=, $0
	i32.const	$push5=, 15
	i32.and 	$1=, $pop4, $pop5
	i32.const	$push20=, 0
	i32.eq  	$push21=, $1, $pop20
	br_if   	$pop21, 1       # 1: down to label1
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i64.const	$push6=, 15
	i64.and 	$push7=, $0, $pop6
	i64.shl 	$4=, $4, $pop7
	i32.add 	$3=, $1, $3
	block
	i64.const	$push8=, 256
	i64.and 	$push9=, $2, $pop8
	i64.const	$push10=, 0
	i64.eq  	$push11=, $pop9, $pop10
	br_if   	$pop11, 0       # 0: down to label2
# BB#3:                                 # %if.then2
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push12=, 1
	i32.shl 	$push13=, $pop12, $1
	i32.const	$push14=, -1
	i32.add 	$push15=, $pop13, $pop14
	i64.extend_s/i32	$push16=, $pop15
	i64.or  	$4=, $pop16, $4
.LBB1_4:                                # %if.end
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.const	$push17=, 71
	i32.lt_u	$push18=, $3, $pop17
	br_if   	$pop18, 0       # 0: up to label0
.LBB1_5:                                # %cleanup
	end_loop                        # label1:
	i32.const	$push19=, 0
	i64.store	$discard=, simple_rand.seed($pop19), $2
	return  	$4
	.endfunc
.Lfunc_end1:
	.size	random_bitstring, .Lfunc_end1-random_bitstring

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i64, i64, i32, i32, i32, i64, i32, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$8=, 0
	i64.load	$2=, simple_rand.seed($8)
	i64.const	$7=, 0
	copy_local	$0=, $7
	i32.const	$12=, 15
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
                                        #     Child Loop BB2_7 Depth 2
	loop                            # label3:
	copy_local	$20=, $7
	copy_local	$19=, $8
.LBB2_2:                                # %for.cond.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label5:
	i64.const	$9=, 1103515245
	i64.const	$10=, 12345
	i64.mul 	$push0=, $2, $9
	i64.add 	$2=, $pop0, $10
	i64.const	$11=, 9
	i64.shr_u	$21=, $2, $11
	i32.wrap/i64	$push1=, $21
	i32.and 	$1=, $pop1, $12
	i32.const	$push92=, 0
	i32.eq  	$push93=, $1, $pop92
	br_if   	$pop93, 1       # 1: down to label6
# BB#3:                                 # %if.else.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i64.const	$push2=, 15
	i64.and 	$push3=, $21, $pop2
	i64.shl 	$20=, $20, $pop3
	i32.add 	$19=, $1, $19
	block
	i64.const	$push4=, 256
	i64.and 	$push5=, $2, $pop4
	i64.const	$push6=, 0
	i64.eq  	$push7=, $pop5, $pop6
	br_if   	$pop7, 0        # 0: down to label7
# BB#4:                                 # %if.then2.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.const	$push8=, 1
	i32.shl 	$push9=, $pop8, $1
	i32.const	$push10=, -1
	i32.add 	$push11=, $pop9, $pop10
	i64.extend_s/i32	$push12=, $pop11
	i64.or  	$20=, $pop12, $20
.LBB2_5:                                # %if.end.i
                                        #   in Loop: Header=BB2_2 Depth=2
	end_block                       # label7:
	i32.const	$push13=, 71
	i32.lt_u	$push14=, $19, $pop13
	br_if   	$pop14, 0       # 0: up to label5
.LBB2_6:                                # %random_bitstring.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label6:
	i64.const	$21=, 0
	i32.const	$19=, 0
.LBB2_7:                                # %for.cond.i452
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label8:
	i64.mul 	$push15=, $2, $9
	i64.add 	$2=, $pop15, $10
	i64.shr_u	$3=, $2, $11
	i32.wrap/i64	$push16=, $3
	i32.and 	$1=, $pop16, $12
	i32.const	$push94=, 0
	i32.eq  	$push95=, $1, $pop94
	br_if   	$pop95, 1       # 1: down to label9
# BB#8:                                 # %if.else.i457
                                        #   in Loop: Header=BB2_7 Depth=2
	i64.const	$push17=, 15
	i64.and 	$push18=, $3, $pop17
	i64.shl 	$21=, $21, $pop18
	i32.add 	$19=, $1, $19
	block
	i64.const	$push19=, 256
	i64.and 	$push20=, $2, $pop19
	i64.const	$push21=, 0
	i64.eq  	$push22=, $pop20, $pop21
	br_if   	$pop22, 0       # 0: down to label10
# BB#9:                                 # %if.then2.i462
                                        #   in Loop: Header=BB2_7 Depth=2
	i32.const	$push23=, 1
	i32.shl 	$push24=, $pop23, $1
	i32.const	$push25=, -1
	i32.add 	$push26=, $pop24, $pop25
	i64.extend_s/i32	$push27=, $pop26
	i64.or  	$21=, $pop27, $21
.LBB2_10:                               # %if.end.i465
                                        #   in Loop: Header=BB2_7 Depth=2
	end_block                       # label10:
	i32.const	$push28=, 71
	i32.lt_u	$push29=, $19, $pop28
	br_if   	$pop29, 0       # 0: up to label8
.LBB2_11:                               # %random_bitstring.exit467
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label9:
	i64.const	$9=, 0
	block
	i64.eq  	$push30=, $21, $9
	br_if   	$pop30, 0       # 0: down to label11
# BB#12:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i64.const	$push31=, 9223372036854775807
	i64.and 	$push32=, $20, $pop31
	i64.ne  	$push33=, $pop32, $9
	br_if   	$pop33, 0       # 0: down to label12
# BB#13:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	i64.const	$push34=, -1
	i64.eq  	$push35=, $21, $pop34
	br_if   	$pop35, 1       # 1: down to label11
.LBB2_14:                               # %if.end17
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label12:
	i64.const	$9=, 63
	i64.shr_s	$10=, $21, $9
	i64.rem_s	$11=, $20, $21
	i64.shr_s	$9=, $11, $9
	block
	i64.add 	$push38=, $11, $9
	i64.xor 	$push39=, $pop38, $9
	i64.add 	$push36=, $21, $10
	i64.xor 	$push37=, $pop36, $10
	i64.ge_u	$push40=, $pop39, $pop37
	br_if   	$pop40, 0       # 0: down to label13
# BB#15:                                # %save_time
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.wrap/i64	$1=, $21
	i32.const	$push96=, 0
	i32.eq  	$push97=, $1, $pop96
	br_if   	$pop97, 1       # 1: down to label11
# BB#16:                                # %cleanup.cont65
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.wrap/i64	$19=, $20
	block
	i32.const	$push42=, 2147483647
	i32.and 	$push43=, $19, $pop42
	br_if   	$pop43, 0       # 0: down to label14
# BB#17:                                # %cleanup.cont65
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push44=, -1
	i32.eq  	$push45=, $1, $pop44
	br_if   	$pop45, 2       # 2: down to label11
.LBB2_18:                               # %if.end79
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label14:
	i32.const	$5=, 31
	i32.shr_s	$13=, $1, $5
	i32.rem_s	$15=, $19, $1
	i32.shr_s	$5=, $15, $5
	block
	i32.add 	$push48=, $15, $5
	i32.xor 	$push49=, $pop48, $5
	i32.add 	$push46=, $1, $13
	i32.xor 	$push47=, $pop46, $13
	i32.ge_u	$push50=, $pop49, $pop47
	br_if   	$pop50, 0       # 0: down to label15
# BB#19:                                # %lor.lhs.false103
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i32.const	$push98=, 0
	i32.eq  	$push99=, $15, $pop98
	br_if   	$pop99, 0       # 0: down to label16
# BB#20:                                # %lor.lhs.false103
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.xor 	$push51=, $15, $19
	i32.const	$push52=, -1
	i32.le_s	$push53=, $pop51, $pop52
	br_if   	$pop53, 1       # 1: down to label15
.LBB2_21:                               # %cleanup.cont118
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label16:
	i32.const	$14=, 65535
	i32.and 	$push54=, $1, $14
	i32.const	$push100=, 0
	i32.eq  	$push101=, $pop54, $pop100
	br_if   	$pop101, 2      # 2: down to label11
# BB#22:                                # %cleanup.cont158
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$15=, 16
	i32.shl 	$push55=, $19, $15
	i32.shr_s	$4=, $pop55, $15
	i32.shl 	$16=, $1, $15
	i32.shr_s	$5=, $16, $15
	i32.rem_s	$push56=, $4, $5
	i32.shl 	$17=, $pop56, $15
	i32.shr_s	$6=, $17, $15
	i32.const	$18=, -65536
	i32.const	$13=, 0
	block
	i32.gt_s	$push57=, $17, $18
	i32.sub 	$push58=, $13, $6
	i32.select	$push59=, $pop57, $6, $pop58
	i32.gt_s	$push60=, $16, $18
	i32.sub 	$push61=, $13, $5
	i32.select	$push62=, $pop60, $5, $pop61
	i32.and 	$push63=, $pop62, $14
	i32.ge_s	$push64=, $pop59, $pop63
	br_if   	$pop64, 0       # 0: down to label17
# BB#23:                                # %lor.lhs.false197
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push65=, $4, $5
	i32.mul 	$push66=, $pop65, $5
	i32.add 	$push67=, $pop66, $6
	i32.shl 	$push68=, $pop67, $15
	i32.shr_s	$push69=, $pop68, $15
	i32.ne  	$push70=, $pop69, $4
	br_if   	$pop70, 0       # 0: down to label17
# BB#24:                                # %if.end209
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$5=, 255
	i32.and 	$push71=, $1, $5
	i32.const	$push102=, 0
	i32.eq  	$push103=, $pop71, $pop102
	br_if   	$pop103, 3      # 3: down to label11
# BB#25:                                # %cleanup.cont249
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$15=, 24
	i32.shl 	$push72=, $19, $15
	i32.shr_s	$14=, $pop72, $15
	i32.shl 	$6=, $1, $15
	i32.shr_s	$1=, $6, $15
	i32.rem_s	$push73=, $14, $1
	i32.shl 	$4=, $pop73, $15
	i32.shr_s	$19=, $4, $15
	i32.const	$16=, -16777216
	block
	i32.gt_s	$push74=, $4, $16
	i32.sub 	$push75=, $13, $19
	i32.select	$push76=, $pop74, $19, $pop75
	i32.gt_s	$push77=, $6, $16
	i32.sub 	$push78=, $13, $1
	i32.select	$push79=, $pop77, $1, $pop78
	i32.and 	$push80=, $pop79, $5
	i32.ge_s	$push81=, $pop76, $pop80
	br_if   	$pop81, 0       # 0: down to label18
# BB#26:                                # %lor.lhs.false288
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push82=, $14, $1
	i32.mul 	$push83=, $pop82, $1
	i32.add 	$push84=, $pop83, $19
	i32.shl 	$push85=, $pop84, $15
	i32.shr_s	$push86=, $pop85, $15
	i32.eq  	$push87=, $pop86, $14
	br_if   	$pop87, 4       # 4: down to label11
.LBB2_27:                               # %if.then299
	end_block                       # label18:
	i64.store	$discard=, simple_rand.seed($13), $2
	call    	abort@FUNCTION
	unreachable
.LBB2_28:                               # %if.then208
	end_block                       # label17:
	i64.store	$discard=, simple_rand.seed($13), $2
	call    	abort@FUNCTION
	unreachable
.LBB2_29:                               # %if.then111
	end_block                       # label15:
	i32.const	$push88=, 0
	i64.store	$discard=, simple_rand.seed($pop88), $2
	call    	abort@FUNCTION
	unreachable
.LBB2_30:                               # %if.then32
	end_block                       # label13:
	i32.const	$push41=, 0
	i64.store	$discard=, simple_rand.seed($pop41), $2
	call    	abort@FUNCTION
	unreachable
.LBB2_31:                               # %cleanup301
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label11:
	i64.const	$push89=, 1
	i64.add 	$0=, $0, $pop89
	i64.const	$push90=, 10000
	i64.lt_s	$push91=, $0, $pop90
	br_if   	$pop91, 0       # 0: up to label3
# BB#32:                                # %for.end
	end_loop                        # label4:
	i32.const	$1=, 0
	i64.store	$discard=, simple_rand.seed($1), $2
	call    	exit@FUNCTION, $1
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	simple_rand.seed,@object # @simple_rand.seed
	.section	.data.simple_rand.seed,"aw",@progbits
	.align	3
simple_rand.seed:
	.int64	47114711                # 0x2cee9d7
	.size	simple_rand.seed, 8


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
