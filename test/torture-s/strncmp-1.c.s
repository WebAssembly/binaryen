	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strncmp-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.call	$0=, strncmp@FUNCTION, $0, $1, $2
	block
	block
	i32.const	$push0=, -1
	i32.gt_s	$push1=, $3, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push2=, 0
	i32.ge_s	$push3=, $0, $pop2
	br_if   	1, $pop3        # 1: down to label0
.LBB0_2:                                # %if.else
	end_block                       # label1:
	block
	br_if   	0, $3           # 0: down to label2
# BB#3:                                 # %if.else
	br_if   	1, $0           # 1: down to label0
.LBB0_4:                                # %if.else6
	end_block                       # label2:
	block
	i32.const	$push4=, 1
	i32.lt_s	$push5=, $3, $pop4
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$1=, u1
.LBB1_1:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
                                        #       Child Loop BB1_3 Depth 3
	block
	block
	loop                            # label6:
	i32.const	$2=, 0
	i32.const	$3=, u2
.LBB1_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_3 Depth 3
	loop                            # label8:
	i32.const	$4=, 0
.LBB1_3:                                # %for.cond7.preheader
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label10:
	i32.const	$5=, u1
	block
	i32.eqz 	$push89=, $0
	br_if   	0, $pop89       # 0: down to label12
# BB#4:                                 # %for.body9.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push33=, u1
	i32.const	$push32=, 0
	i32.call	$drop=, memset@FUNCTION, $pop33, $pop32, $0
	copy_local	$5=, $1
.LBB1_5:                                # %for.cond10.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label12:
	copy_local	$6=, $5
	block
	i32.eqz 	$push90=, $4
	br_if   	0, $pop90       # 0: down to label13
# BB#6:                                 # %for.body12.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push34=, 97
	i32.call	$push0=, memset@FUNCTION, $5, $pop34, $4
	i32.add 	$6=, $pop0, $4
.LBB1_7:                                # %for.cond17.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label13:
	i64.const	$push35=, 8680820740569200760
	i64.store	0($6):p2align=0, $pop35
	i32.const	$7=, u2
	block
	i32.eqz 	$push91=, $2
	br_if   	0, $pop91       # 0: down to label14
# BB#8:                                 # %for.body26.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push37=, u2
	i32.const	$push36=, 0
	i32.call	$drop=, memset@FUNCTION, $pop37, $pop36, $2
	copy_local	$7=, $3
.LBB1_9:                                # %for.cond31.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label14:
	copy_local	$8=, $7
	block
	i32.eqz 	$push92=, $4
	br_if   	0, $pop92       # 0: down to label15
# BB#10:                                # %for.body33.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push38=, 97
	i32.call	$push1=, memset@FUNCTION, $7, $pop38, $4
	i32.add 	$8=, $pop1, $4
.LBB1_11:                               # %for.cond38.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label15:
	i64.const	$push42=, 8680820740569200760
	i64.store	0($8):p2align=0, $pop42
	i32.const	$push41=, 0
	i32.store8	0($6), $pop41
	i32.const	$push40=, 0
	i32.store8	0($8), $pop40
	i32.const	$push39=, 80
	i32.call	$push2=, strncmp@FUNCTION, $5, $7, $pop39
	br_if   	6, $pop2        # 6: down to label5
# BB#12:                                # %test.exit
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push3=, strncmp@FUNCTION, $5, $7, $4
	br_if   	6, $pop3        # 6: down to label5
# BB#13:                                # %test.exit185
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push46=, 97
	i32.store16	0($6):p2align=0, $pop46
	i32.const	$push45=, 0
	i32.store8	0($8), $pop45
	i32.const	$push44=, 80
	i32.call	$push4=, strncmp@FUNCTION, $5, $7, $pop44
	i32.const	$push43=, 0
	i32.le_s	$push5=, $pop4, $pop43
	br_if   	6, $pop5        # 6: down to label5
# BB#14:                                # %test.exit190
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push6=, strncmp@FUNCTION, $5, $7, $4
	br_if   	6, $pop6        # 6: down to label5
# BB#15:                                # %test.exit196
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push50=, 0
	i32.store8	0($6), $pop50
	i32.const	$push49=, 97
	i32.store16	0($8):p2align=0, $pop49
	i32.const	$push48=, 80
	i32.call	$push7=, strncmp@FUNCTION, $5, $7, $pop48
	i32.const	$push47=, 0
	i32.ge_s	$push8=, $pop7, $pop47
	br_if   	6, $pop8        # 6: down to label5
# BB#16:                                # %test.exit201
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push9=, strncmp@FUNCTION, $5, $7, $4
	br_if   	6, $pop9        # 6: down to label5
# BB#17:                                # %test.exit207
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push54=, 98
	i32.store16	0($6):p2align=0, $pop54
	i32.const	$push53=, 99
	i32.store16	0($8):p2align=0, $pop53
	i32.const	$push52=, 80
	i32.call	$push10=, strncmp@FUNCTION, $5, $7, $pop52
	i32.const	$push51=, 0
	i32.ge_s	$push11=, $pop10, $pop51
	br_if   	6, $pop11       # 6: down to label5
# BB#18:                                # %test.exit213
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push12=, strncmp@FUNCTION, $5, $7, $4
	br_if   	6, $pop12       # 6: down to label5
# BB#19:                                # %test.exit219
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push58=, 99
	i32.store16	0($6):p2align=0, $pop58
	i32.const	$push57=, 98
	i32.store16	0($8):p2align=0, $pop57
	i32.const	$push56=, 80
	i32.call	$push13=, strncmp@FUNCTION, $5, $7, $pop56
	i32.const	$push55=, 0
	i32.le_s	$push14=, $pop13, $pop55
	br_if   	6, $pop14       # 6: down to label5
# BB#20:                                # %test.exit225
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push15=, strncmp@FUNCTION, $5, $7, $4
	br_if   	6, $pop15       # 6: down to label5
# BB#21:                                # %test.exit231
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push62=, 98
	i32.store16	0($6):p2align=0, $pop62
	i32.const	$push61=, 169
	i32.store16	0($8):p2align=0, $pop61
	i32.const	$push60=, 80
	i32.call	$push16=, strncmp@FUNCTION, $5, $7, $pop60
	i32.const	$push59=, 0
	i32.ge_s	$push17=, $pop16, $pop59
	br_if   	6, $pop17       # 6: down to label5
# BB#22:                                # %test.exit237
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push18=, strncmp@FUNCTION, $5, $7, $4
	br_if   	6, $pop18       # 6: down to label5
# BB#23:                                # %test.exit243
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push66=, 169
	i32.store16	0($6):p2align=0, $pop66
	i32.const	$push65=, 98
	i32.store16	0($8):p2align=0, $pop65
	i32.const	$push64=, 80
	i32.call	$push19=, strncmp@FUNCTION, $5, $7, $pop64
	i32.const	$push63=, 0
	i32.le_s	$push20=, $pop19, $pop63
	br_if   	6, $pop20       # 6: down to label5
# BB#24:                                # %test.exit249
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push21=, strncmp@FUNCTION, $5, $7, $4
	br_if   	6, $pop21       # 6: down to label5
# BB#25:                                # %test.exit255
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push70=, 169
	i32.store16	0($6):p2align=0, $pop70
	i32.const	$push69=, 170
	i32.store16	0($8):p2align=0, $pop69
	i32.const	$push68=, 80
	i32.call	$push22=, strncmp@FUNCTION, $5, $7, $pop68
	i32.const	$push67=, 0
	i32.ge_s	$push23=, $pop22, $pop67
	br_if   	6, $pop23       # 6: down to label5
# BB#26:                                # %test.exit261
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push24=, strncmp@FUNCTION, $5, $7, $4
	br_if   	6, $pop24       # 6: down to label5
# BB#27:                                # %test.exit267
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push74=, 170
	i32.store16	0($6):p2align=0, $pop74
	i32.const	$push73=, 169
	i32.store16	0($8):p2align=0, $pop73
	i32.const	$push72=, 80
	i32.call	$push25=, strncmp@FUNCTION, $5, $7, $pop72
	i32.const	$push71=, 0
	i32.le_s	$push26=, $pop25, $pop71
	br_if   	6, $pop26       # 6: down to label5
# BB#28:                                # %test.exit273
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push27=, strncmp@FUNCTION, $5, $7, $4
	br_if   	7, $pop27       # 7: down to label4
# BB#29:                                # %for.cond4
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push78=, 1
	i32.add 	$push77=, $4, $pop78
	tee_local	$push76=, $4=, $pop77
	i32.const	$push75=, 63
	i32.le_u	$push28=, $pop76, $pop75
	br_if   	0, $pop28       # 0: up to label10
# BB#30:                                # %for.inc79
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop                        # label11:
	i32.const	$push83=, 1
	i32.add 	$3=, $3, $pop83
	i32.const	$push82=, 1
	i32.add 	$push81=, $2, $pop82
	tee_local	$push80=, $2=, $pop81
	i32.const	$push79=, 8
	i32.lt_u	$push29=, $pop80, $pop79
	br_if   	0, $pop29       # 0: up to label8
# BB#31:                                # %for.inc82
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label9:
	i32.const	$push88=, 1
	i32.add 	$1=, $1, $pop88
	i32.const	$push87=, 1
	i32.add 	$push86=, $0, $pop87
	tee_local	$push85=, $0=, $pop86
	i32.const	$push84=, 8
	i32.lt_u	$push30=, $pop85, $pop84
	br_if   	0, $pop30       # 0: up to label6
# BB#32:                                # %for.end84
	end_loop                        # label7:
	i32.const	$push31=, 0
	call    	exit@FUNCTION, $pop31
	unreachable
.LBB1_33:                               # %if.then10.i272
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB1_34:                               # %if.then5.i277
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	u1,@object              # @u1
	.section	.bss.u1,"aw",@nobits
	.p2align	4
u1:
	.skip	80
	.size	u1, 80

	.type	u2,@object              # @u2
	.section	.bss.u2,"aw",@nobits
	.p2align	4
u2:
	.skip	80
	.size	u2, 80


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283501)"
	.functype	strncmp, i32, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
