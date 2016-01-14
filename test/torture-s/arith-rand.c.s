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
	i32.const	$0=, 0
	i32.load	$push0=, simple_rand.seed($0)
	i32.const	$push1=, 1103515245
	i32.mul 	$push2=, $pop0, $pop1
	i32.const	$push3=, 12345
	i32.add 	$push4=, $pop2, $pop3
	i32.store	$push5=, simple_rand.seed($0), $pop4
	i32.const	$push6=, 8
	i32.shr_u	$push7=, $pop5, $pop6
	return  	$pop7
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
	i32.const	$3=, 0
	i32.load	$1=, simple_rand.seed($3)
	copy_local	$2=, $3
.LBB1_1:                                # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label0:
	i32.const	$push0=, 1103515245
	i32.mul 	$push1=, $1, $pop0
	i32.const	$push2=, 12345
	i32.add 	$1=, $pop1, $pop2
	i32.const	$push3=, 9
	i32.shr_u	$push4=, $1, $pop3
	i32.const	$push5=, 15
	i32.and 	$0=, $pop4, $pop5
	i32.const	$push15=, 0
	i32.eq  	$push16=, $0, $pop15
	br_if   	$pop16, 1       # 1: down to label1
# BB#2:                                 # %if.else
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.add 	$2=, $0, $2
	i32.shl 	$3=, $3, $0
	block
	i32.const	$push6=, 256
	i32.and 	$push7=, $1, $pop6
	i32.const	$push17=, 0
	i32.eq  	$push18=, $pop7, $pop17
	br_if   	$pop18, 0       # 0: down to label2
# BB#3:                                 # %if.then1
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push8=, 1
	i32.shl 	$push9=, $pop8, $0
	i32.const	$push10=, -1
	i32.add 	$push11=, $pop9, $pop10
	i32.or  	$3=, $pop11, $3
.LBB1_4:                                # %if.end
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label2:
	i32.const	$push12=, 39
	i32.lt_u	$push13=, $2, $pop12
	br_if   	$pop13, 0       # 0: up to label0
.LBB1_5:                                # %cleanup
	end_loop                        # label1:
	i32.const	$push14=, 0
	i32.store	$discard=, simple_rand.seed($pop14), $1
	return  	$3
	.endfunc
.Lfunc_end1:
	.size	random_bitstring, .Lfunc_end1-random_bitstring

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	i32.load	$2=, simple_rand.seed($3)
	copy_local	$0=, $3
.LBB2_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_2 Depth 2
                                        #     Child Loop BB2_7 Depth 2
	loop                            # label3:
	copy_local	$11=, $3
	copy_local	$13=, $3
.LBB2_2:                                # %for.cond.i
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label5:
	i32.const	$4=, 1103515245
	i32.const	$5=, 12345
	i32.mul 	$push0=, $2, $4
	i32.add 	$2=, $pop0, $5
	i32.const	$6=, 9
	i32.const	$7=, 15
	i32.shr_u	$push1=, $2, $6
	i32.and 	$1=, $pop1, $7
	i32.const	$push67=, 0
	i32.eq  	$push68=, $1, $pop67
	br_if   	$pop68, 1       # 1: down to label6
# BB#3:                                 # %if.else.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.add 	$13=, $1, $13
	i32.shl 	$11=, $11, $1
	block
	i32.const	$push2=, 256
	i32.and 	$push3=, $2, $pop2
	i32.const	$push69=, 0
	i32.eq  	$push70=, $pop3, $pop69
	br_if   	$pop70, 0       # 0: down to label7
# BB#4:                                 # %if.then1.i
                                        #   in Loop: Header=BB2_2 Depth=2
	i32.const	$push4=, 1
	i32.shl 	$push5=, $pop4, $1
	i32.const	$push6=, -1
	i32.add 	$push7=, $pop5, $pop6
	i32.or  	$11=, $pop7, $11
.LBB2_5:                                # %if.end.i
                                        #   in Loop: Header=BB2_2 Depth=2
	end_block                       # label7:
	i32.const	$push8=, 39
	i32.lt_u	$push9=, $13, $pop8
	br_if   	$pop9, 0        # 0: up to label5
.LBB2_6:                                # %random_bitstring.exit
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label6:
	i32.const	$13=, 0
	copy_local	$12=, $13
.LBB2_7:                                # %for.cond.i339
                                        #   Parent Loop BB2_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label8:
	i32.mul 	$push10=, $2, $4
	i32.add 	$2=, $pop10, $5
	i32.shr_u	$push11=, $2, $6
	i32.and 	$1=, $pop11, $7
	i32.const	$push71=, 0
	i32.eq  	$push72=, $1, $pop71
	br_if   	$pop72, 1       # 1: down to label9
# BB#8:                                 # %if.else.i343
                                        #   in Loop: Header=BB2_7 Depth=2
	i32.add 	$12=, $1, $12
	i32.shl 	$13=, $13, $1
	block
	i32.const	$push12=, 256
	i32.and 	$push13=, $2, $pop12
	i32.const	$push73=, 0
	i32.eq  	$push74=, $pop13, $pop73
	br_if   	$pop74, 0       # 0: down to label10
# BB#9:                                 # %if.then1.i347
                                        #   in Loop: Header=BB2_7 Depth=2
	i32.const	$push14=, 1
	i32.shl 	$push15=, $pop14, $1
	i32.const	$push16=, -1
	i32.add 	$push17=, $pop15, $pop16
	i32.or  	$13=, $pop17, $13
.LBB2_10:                               # %if.end.i350
                                        #   in Loop: Header=BB2_7 Depth=2
	end_block                       # label10:
	i32.const	$push18=, 39
	i32.lt_u	$push19=, $12, $pop18
	br_if   	$pop19, 0       # 0: up to label8
.LBB2_11:                               # %random_bitstring.exit352
                                        #   in Loop: Header=BB2_1 Depth=1
	end_loop                        # label9:
	block
	i32.const	$push75=, 0
	i32.eq  	$push76=, $13, $pop75
	br_if   	$pop76, 0       # 0: down to label11
# BB#12:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	block
	i32.const	$push20=, 2147483647
	i32.and 	$push21=, $11, $pop20
	br_if   	$pop21, 0       # 0: down to label12
# BB#13:                                # %cleanup.cont
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$push22=, -1
	i32.eq  	$push23=, $13, $pop22
	br_if   	$pop23, 1       # 1: down to label11
.LBB2_14:                               # %if.end25
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label12:
	i32.const	$1=, 31
	i32.shr_s	$4=, $13, $1
	i32.rem_s	$5=, $11, $13
	i32.shr_s	$1=, $5, $1
	block
	i32.add 	$push26=, $5, $1
	i32.xor 	$push27=, $pop26, $1
	i32.add 	$push24=, $13, $4
	i32.xor 	$push25=, $pop24, $4
	i32.ge_u	$push28=, $pop27, $pop25
	br_if   	$pop28, 0       # 0: down to label13
# BB#15:                                # %cleanup.cont47
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$6=, 65535
	i32.and 	$push30=, $13, $6
	i32.const	$push77=, 0
	i32.eq  	$push78=, $pop30, $pop77
	br_if   	$pop78, 1       # 1: down to label11
# BB#16:                                # %cleanup.cont86
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$1=, 16
	i32.shl 	$push31=, $11, $1
	i32.shr_s	$12=, $pop31, $1
	i32.shl 	$8=, $13, $1
	i32.shr_s	$4=, $8, $1
	i32.rem_s	$push32=, $12, $4
	i32.shl 	$9=, $pop32, $1
	i32.shr_s	$7=, $9, $1
	i32.const	$10=, -65536
	i32.const	$5=, 0
	block
	i32.gt_s	$push33=, $9, $10
	i32.sub 	$push34=, $5, $7
	i32.select	$push35=, $pop33, $7, $pop34
	i32.gt_s	$push36=, $8, $10
	i32.sub 	$push37=, $5, $4
	i32.select	$push38=, $pop36, $4, $pop37
	i32.and 	$push39=, $pop38, $6
	i32.ge_s	$push40=, $pop35, $pop39
	br_if   	$pop40, 0       # 0: down to label14
# BB#17:                                # %lor.lhs.false125
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push41=, $12, $4
	i32.mul 	$push42=, $pop41, $4
	i32.add 	$push43=, $pop42, $7
	i32.shl 	$push44=, $pop43, $1
	i32.shr_s	$push45=, $pop44, $1
	i32.ne  	$push46=, $pop45, $12
	br_if   	$pop46, 0       # 0: down to label14
# BB#18:                                # %if.end137
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$4=, 255
	i32.and 	$push47=, $13, $4
	i32.const	$push79=, 0
	i32.eq  	$push80=, $pop47, $pop79
	br_if   	$pop80, 2       # 2: down to label11
# BB#19:                                # %cleanup.cont177
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.const	$1=, 24
	i32.shl 	$push48=, $11, $1
	i32.shr_s	$6=, $pop48, $1
	i32.shl 	$7=, $13, $1
	i32.shr_s	$13=, $7, $1
	i32.rem_s	$push49=, $6, $13
	i32.shl 	$12=, $pop49, $1
	i32.shr_s	$11=, $12, $1
	i32.const	$8=, -16777216
	block
	i32.gt_s	$push50=, $12, $8
	i32.sub 	$push51=, $5, $11
	i32.select	$push52=, $pop50, $11, $pop51
	i32.gt_s	$push53=, $7, $8
	i32.sub 	$push54=, $5, $13
	i32.select	$push55=, $pop53, $13, $pop54
	i32.and 	$push56=, $pop55, $4
	i32.ge_s	$push57=, $pop52, $pop56
	br_if   	$pop57, 0       # 0: down to label15
# BB#20:                                # %lor.lhs.false216
                                        #   in Loop: Header=BB2_1 Depth=1
	i32.div_s	$push58=, $6, $13
	i32.mul 	$push59=, $pop58, $13
	i32.add 	$push60=, $pop59, $11
	i32.shl 	$push61=, $pop60, $1
	i32.shr_s	$push62=, $pop61, $1
	i32.eq  	$push63=, $pop62, $6
	br_if   	$pop63, 3       # 3: down to label11
.LBB2_21:                               # %if.then227
	end_block                       # label15:
	i32.store	$discard=, simple_rand.seed($5), $2
	call    	abort@FUNCTION
	unreachable
.LBB2_22:                               # %if.then136
	end_block                       # label14:
	i32.store	$discard=, simple_rand.seed($5), $2
	call    	abort@FUNCTION
	unreachable
.LBB2_23:                               # %if.then40
	end_block                       # label13:
	i32.const	$push29=, 0
	i32.store	$discard=, simple_rand.seed($pop29), $2
	call    	abort@FUNCTION
	unreachable
.LBB2_24:                               # %cleanup229
                                        #   in Loop: Header=BB2_1 Depth=1
	end_block                       # label11:
	i32.const	$push64=, 1
	i32.add 	$0=, $0, $pop64
	i32.const	$push65=, 1000
	i32.lt_s	$push66=, $0, $pop65
	br_if   	$pop66, 0       # 0: up to label3
# BB#25:                                # %for.end
	end_loop                        # label4:
	i32.const	$1=, 0
	i32.store	$discard=, simple_rand.seed($1), $2
	call    	exit@FUNCTION, $1
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	simple_rand.seed,@object # @simple_rand.seed
	.section	.data.simple_rand.seed,"aw",@progbits
	.align	2
simple_rand.seed:
	.int32	47114711                # 0x2cee9d7
	.size	simple_rand.seed, 4


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
