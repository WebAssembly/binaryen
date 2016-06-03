	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strcmp-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	i32.call	$0=, strcmp@FUNCTION, $0, $1
	block
	block
	i32.const	$push0=, -1
	i32.gt_s	$push1=, $2, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push2=, 0
	i32.ge_s	$push3=, $0, $pop2
	br_if   	1, $pop3        # 1: down to label0
.LBB0_2:                                # %if.else
	end_block                       # label1:
	block
	br_if   	0, $2           # 0: down to label2
# BB#3:                                 # %if.else
	br_if   	1, $0           # 1: down to label0
.LBB0_4:                                # %if.else6
	end_block                       # label2:
	block
	i32.const	$push4=, 1
	i32.lt_s	$push5=, $2, $pop4
	br_if   	0, $pop5        # 0: down to label3
# BB#5:                                 # %if.else6
	i32.const	$push6=, 0
	i32.le_s	$push7=, $0, $pop6
	br_if   	1, $pop7        # 1: down to label0
.LBB0_6:                                # %if.end12
	end_block                       # label3:
	return
.LBB0_7:                                # %if.then10
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, 0
	i32.const	$5=, u1
.LBB1_1:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
                                        #       Child Loop BB1_3 Depth 3
	block
	block
	loop                            # label6:
	i32.const	$6=, 0
	i32.const	$7=, u2
.LBB1_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_3 Depth 3
	loop                            # label8:
	i32.const	$8=, 0
.LBB1_3:                                # %for.cond7.preheader
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label10:
	i32.const	$9=, u1
	block
	i32.eqz 	$push57=, $4
	br_if   	0, $pop57       # 0: down to label12
# BB#4:                                 # %for.body9.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push27=, u1
	i32.const	$push26=, 0
	i32.call	$drop=, memset@FUNCTION, $pop27, $pop26, $4
	copy_local	$9=, $5
.LBB1_5:                                # %for.cond10.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label12:
	copy_local	$10=, $9
	block
	i32.eqz 	$push58=, $8
	br_if   	0, $pop58       # 0: down to label13
# BB#6:                                 # %for.body12.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push28=, 97
	i32.call	$push0=, memset@FUNCTION, $9, $pop28, $8
	i32.add 	$10=, $pop0, $8
.LBB1_7:                                # %for.cond17.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label13:
	i64.const	$push31=, 8680820740569200760
	i64.store	$0=, 0($10):p2align=0, $pop31
	i32.const	$push30=, 8
	i32.add 	$push3=, $10, $pop30
	i32.const	$push29=, 30840
	i32.store16	$drop=, 0($pop3):p2align=0, $pop29
	i32.const	$11=, u2
	block
	i32.eqz 	$push59=, $6
	br_if   	0, $pop59       # 0: down to label14
# BB#8:                                 # %for.body26.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push33=, u2
	i32.const	$push32=, 0
	i32.call	$drop=, memset@FUNCTION, $pop33, $pop32, $6
	copy_local	$11=, $7
.LBB1_9:                                # %for.cond31.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label14:
	copy_local	$12=, $11
	block
	i32.eqz 	$push60=, $8
	br_if   	0, $pop60       # 0: down to label15
# BB#10:                                # %for.body33.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push34=, 97
	i32.call	$push1=, memset@FUNCTION, $11, $pop34, $8
	i32.add 	$12=, $pop1, $8
.LBB1_11:                               # %for.cond38.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label15:
	i64.store	$drop=, 1($12):p2align=0, $0
	i32.const	$push37=, 9
	i32.add 	$push4=, $12, $pop37
	i32.const	$push36=, 120
	i32.store8	$drop=, 0($pop4), $pop36
	i32.const	$push35=, 0
	i32.store8	$push2=, 0($10), $pop35
	i32.store8	$2=, 0($12), $pop2
	i32.call	$push5=, strcmp@FUNCTION, $9, $11
	br_if   	6, $pop5        # 6: down to label5
# BB#12:                                # %test.exit
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push38=, 97
	i32.store16	$1=, 0($10):p2align=0, $pop38
	i32.store8	$drop=, 0($12), $2
	i32.call	$push6=, strcmp@FUNCTION, $9, $11
	i32.le_s	$push7=, $pop6, $2
	br_if   	6, $pop7        # 6: down to label5
# BB#13:                                # %test.exit157
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.store8	$drop=, 0($10), $2
	i32.store16	$drop=, 0($12):p2align=0, $1
	i32.call	$push8=, strcmp@FUNCTION, $9, $11
	i32.ge_s	$push9=, $pop8, $2
	br_if   	6, $pop9        # 6: down to label5
# BB#14:                                # %test.exit162
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push40=, 98
	i32.store16	$1=, 0($10):p2align=0, $pop40
	i32.const	$push39=, 99
	i32.store16	$3=, 0($12):p2align=0, $pop39
	i32.call	$push10=, strcmp@FUNCTION, $9, $11
	i32.ge_s	$push11=, $pop10, $2
	br_if   	6, $pop11       # 6: down to label5
# BB#15:                                # %test.exit168
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.store16	$drop=, 0($10):p2align=0, $3
	i32.store16	$drop=, 0($12):p2align=0, $1
	i32.call	$push12=, strcmp@FUNCTION, $9, $11
	i32.le_s	$push13=, $pop12, $2
	br_if   	6, $pop13       # 6: down to label5
# BB#16:                                # %test.exit174
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.store16	$drop=, 0($10):p2align=0, $1
	i32.const	$push41=, 169
	i32.store16	$3=, 0($12):p2align=0, $pop41
	i32.call	$push14=, strcmp@FUNCTION, $9, $11
	i32.ge_s	$push15=, $pop14, $2
	br_if   	6, $pop15       # 6: down to label5
# BB#17:                                # %test.exit180
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.store16	$drop=, 0($10):p2align=0, $3
	i32.store16	$drop=, 0($12):p2align=0, $1
	i32.call	$push16=, strcmp@FUNCTION, $9, $11
	i32.le_s	$push17=, $pop16, $2
	br_if   	6, $pop17       # 6: down to label5
# BB#18:                                # %test.exit186
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.store16	$1=, 0($10):p2align=0, $3
	i32.const	$push42=, 170
	i32.store16	$3=, 0($12):p2align=0, $pop42
	i32.call	$push18=, strcmp@FUNCTION, $9, $11
	i32.ge_s	$push19=, $pop18, $2
	br_if   	6, $pop19       # 6: down to label5
# BB#19:                                # %test.exit192
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.store16	$drop=, 0($10):p2align=0, $3
	i32.store16	$drop=, 0($12):p2align=0, $1
	i32.call	$push20=, strcmp@FUNCTION, $9, $11
	i32.le_s	$push21=, $pop20, $2
	br_if   	7, $pop21       # 7: down to label4
# BB#20:                                # %for.cond4
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push46=, 1
	i32.add 	$push45=, $8, $pop46
	tee_local	$push44=, $8=, $pop45
	i32.const	$push43=, 63
	i32.le_u	$push22=, $pop44, $pop43
	br_if   	0, $pop22       # 0: up to label10
# BB#21:                                # %for.inc79
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop                        # label11:
	i32.const	$push51=, 1
	i32.add 	$7=, $7, $pop51
	i32.const	$push50=, 1
	i32.add 	$push49=, $6, $pop50
	tee_local	$push48=, $6=, $pop49
	i32.const	$push47=, 8
	i32.lt_u	$push23=, $pop48, $pop47
	br_if   	0, $pop23       # 0: up to label8
# BB#22:                                # %for.inc82
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label9:
	i32.const	$push56=, 1
	i32.add 	$5=, $5, $pop56
	i32.const	$push55=, 1
	i32.add 	$push54=, $4, $pop55
	tee_local	$push53=, $4=, $pop54
	i32.const	$push52=, 8
	i32.lt_u	$push24=, $pop53, $pop52
	br_if   	0, $pop24       # 0: up to label6
# BB#23:                                # %for.end84
	end_loop                        # label7:
	i32.const	$push25=, 0
	call    	exit@FUNCTION, $pop25
	unreachable
.LBB1_24:                               # %if.then.i189
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_25:                               # %if.then10.i197
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	u1,@object              # @u1
	.lcomm	u1,96,4
	.type	u2,@object              # @u2
	.lcomm	u2,96,4

	.ident	"clang version 3.9.0 "
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
