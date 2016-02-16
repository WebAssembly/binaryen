	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strcmp-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	i32.call	$1=, strcmp@FUNCTION, $0, $1
	block
	block
	block
	block
	i32.const	$push0=, -1
	i32.gt_s	$push1=, $2, $pop0
	br_if   	0, $pop1        # 0: down to label3
# BB#1:                                 # %entry
	i32.const	$push2=, 0
	i32.ge_s	$push3=, $1, $pop2
	br_if   	1, $pop3        # 1: down to label2
.LBB0_2:                                # %if.else
	end_block                       # label3:
	block
	br_if   	0, $2           # 0: down to label4
# BB#3:                                 # %if.else
	br_if   	2, $1           # 2: down to label1
.LBB0_4:                                # %if.else6
	end_block                       # label4:
	block
	i32.const	$push4=, 1
	i32.lt_s	$push5=, $2, $pop4
	br_if   	0, $pop5        # 0: down to label5
# BB#5:                                 # %if.else6
	i32.const	$push6=, 0
	i32.le_s	$push7=, $1, $pop6
	br_if   	3, $pop7        # 3: down to label0
.LBB0_6:                                # %if.end12
	end_block                       # label5:
	return
.LBB0_7:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %if.then5
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_9:                                # %if.then10
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$1=, u1
.LBB1_1:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
                                        #       Child Loop BB1_3 Depth 3
	block
	block
	block
	block
	block
	block
	block
	block
	block
	loop                            # label15:
	i32.const	$2=, 0
	i32.const	$3=, u2
.LBB1_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_3 Depth 3
	loop                            # label17:
	i32.const	$4=, 0
.LBB1_3:                                # %for.cond7.preheader
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label19:
	i32.const	$5=, u1
	block
	i32.const	$push50=, 0
	i32.eq  	$push51=, $0, $pop50
	br_if   	0, $pop51       # 0: down to label21
# BB#4:                                 # %for.body9.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push29=, u1
	i32.const	$push28=, 0
	i32.call	$discard=, memset@FUNCTION, $pop29, $pop28, $0
	copy_local	$5=, $1
.LBB1_5:                                # %for.cond10.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label21:
	copy_local	$6=, $5
	block
	i32.const	$push52=, 0
	i32.eq  	$push53=, $4, $pop52
	br_if   	0, $pop53       # 0: down to label22
# BB#6:                                 # %for.body12.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push30=, 97
	i32.call	$push0=, memset@FUNCTION, $5, $pop30, $4
	i32.add 	$6=, $pop0, $4
.LBB1_7:                                # %for.cond17.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label22:
	i64.const	$push33=, 8680820740569200760
	i64.store	$9=, 0($6):p2align=0, $pop33
	i32.const	$push32=, 8
	i32.add 	$push1=, $6, $pop32
	i32.const	$push31=, 30840
	i32.store16	$11=, 0($pop1):p2align=0, $pop31
	i32.const	$7=, u2
	block
	i32.const	$push54=, 0
	i32.eq  	$push55=, $2, $pop54
	br_if   	0, $pop55       # 0: down to label23
# BB#8:                                 # %for.body26.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push35=, u2
	i32.const	$push34=, 0
	i32.call	$discard=, memset@FUNCTION, $pop35, $pop34, $2
	copy_local	$7=, $3
.LBB1_9:                                # %for.cond31.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label23:
	copy_local	$8=, $7
	block
	i32.const	$push56=, 0
	i32.eq  	$push57=, $4, $pop56
	br_if   	0, $pop57       # 0: down to label24
# BB#10:                                # %for.body33.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push36=, 97
	i32.call	$push2=, memset@FUNCTION, $7, $pop36, $4
	i32.add 	$8=, $pop2, $4
.LBB1_11:                               # %for.cond38.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label24:
	i64.store	$discard=, 0($8):p2align=0, $9
	i32.const	$push38=, 8
	i32.add 	$push3=, $8, $pop38
	i32.store16	$discard=, 0($pop3):p2align=0, $11
	i32.const	$push37=, 0
	i32.store8	$push4=, 0($6), $pop37
	i32.store8	$11=, 0($8), $pop4
	i32.call	$push5=, strcmp@FUNCTION, $5, $7
	br_if   	6, $pop5        # 6: down to label14
# BB#12:                                # %test.exit
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.store8	$discard=, 0($8), $11
	i32.const	$push39=, 97
	i32.store16	$10=, 0($6):p2align=0, $pop39
	i32.call	$push6=, strcmp@FUNCTION, $5, $7
	i32.le_s	$push7=, $pop6, $11
	br_if   	7, $pop7        # 7: down to label13
# BB#13:                                # %test.exit157
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.store16	$discard=, 0($8):p2align=0, $10
	i32.store8	$discard=, 0($6), $11
	i32.call	$push8=, strcmp@FUNCTION, $5, $7
	i32.ge_s	$push9=, $pop8, $11
	br_if   	8, $pop9        # 8: down to label12
# BB#14:                                # %test.exit162
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push41=, 98
	i32.store16	$10=, 0($6):p2align=0, $pop41
	i32.const	$push40=, 99
	i32.store16	$12=, 0($8):p2align=0, $pop40
	i32.call	$push10=, strcmp@FUNCTION, $5, $7
	i32.ge_s	$push11=, $pop10, $11
	br_if   	9, $pop11       # 9: down to label11
# BB#15:                                # %test.exit168
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.store16	$discard=, 0($6):p2align=0, $12
	i32.store16	$discard=, 0($8):p2align=0, $10
	i32.call	$push12=, strcmp@FUNCTION, $5, $7
	i32.le_s	$push13=, $pop12, $11
	br_if   	10, $pop13      # 10: down to label10
# BB#16:                                # %test.exit174
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.store16	$discard=, 0($6):p2align=0, $10
	i32.const	$push42=, 169
	i32.store16	$12=, 0($8):p2align=0, $pop42
	i32.call	$push14=, strcmp@FUNCTION, $5, $7
	i32.ge_s	$push15=, $pop14, $11
	br_if   	11, $pop15      # 11: down to label9
# BB#17:                                # %test.exit180
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.store16	$discard=, 0($8):p2align=0, $10
	i32.store16	$10=, 0($6):p2align=0, $12
	i32.call	$push16=, strcmp@FUNCTION, $5, $7
	i32.le_s	$push17=, $pop16, $11
	br_if   	12, $pop17      # 12: down to label8
# BB#18:                                # %test.exit186
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.store16	$discard=, 0($6):p2align=0, $10
	i32.const	$push43=, 170
	i32.store16	$12=, 0($8):p2align=0, $pop43
	i32.call	$push18=, strcmp@FUNCTION, $5, $7
	i32.ge_s	$push19=, $pop18, $11
	br_if   	13, $pop19      # 13: down to label7
# BB#19:                                # %test.exit192
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.store16	$discard=, 0($6):p2align=0, $12
	i32.store16	$discard=, 0($8):p2align=0, $10
	i32.call	$push20=, strcmp@FUNCTION, $5, $7
	i32.le_s	$push21=, $pop20, $11
	br_if   	14, $pop21      # 14: down to label6
# BB#20:                                # %for.cond4
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push27=, 1
	i32.add 	$4=, $4, $pop27
	i32.const	$push26=, 63
	i32.le_u	$push22=, $4, $pop26
	br_if   	0, $pop22       # 0: up to label19
# BB#21:                                # %for.inc79
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop                        # label20:
	i32.const	$push46=, 1
	i32.add 	$2=, $2, $pop46
	i32.const	$push45=, 1
	i32.add 	$3=, $3, $pop45
	i32.const	$push44=, 8
	i32.lt_u	$push23=, $2, $pop44
	br_if   	0, $pop23       # 0: up to label17
# BB#22:                                # %for.inc82
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label18:
	i32.const	$push49=, 1
	i32.add 	$0=, $0, $pop49
	i32.const	$push48=, 1
	i32.add 	$1=, $1, $pop48
	i32.const	$push47=, 8
	i32.lt_u	$push24=, $0, $pop47
	br_if   	0, $pop24       # 0: up to label15
# BB#23:                                # %for.end84
	end_loop                        # label16:
	i32.const	$push25=, 0
	call    	exit@FUNCTION, $pop25
	unreachable
.LBB1_24:                               # %if.then5.i
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB1_25:                               # %if.then10.i
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB1_26:                               # %if.then.i
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB1_27:                               # %if.then.i165
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB1_28:                               # %if.then10.i173
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB1_29:                               # %if.then.i177
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_30:                               # %if.then10.i185
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_31:                               # %if.then.i189
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_32:                               # %if.then10.i197
	end_block                       # label6:
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
