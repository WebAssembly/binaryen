	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strncmp-1.c"
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
	loop    	                # label6:
	i32.const	$2=, 0
	i32.const	$3=, u2
.LBB1_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_3 Depth 3
	loop    	                # label7:
	i32.const	$4=, 0
.LBB1_3:                                # %for.cond7.preheader
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label8:
	block   	
	block   	
	block   	
	i32.eqz 	$push95=, $0
	br_if   	0, $pop95       # 0: down to label11
# BB#4:                                 # %for.body9.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push35=, u1
	i32.const	$push34=, 0
	i32.call	$drop=, memset@FUNCTION, $pop35, $pop34, $0
	copy_local	$push33=, $1
	tee_local	$push32=, $5=, $pop33
	copy_local	$6=, $pop32
	br_if   	1, $4           # 1: down to label10
	br      	2               # 2: down to label9
.LBB1_5:                                #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label11:
	i32.const	$5=, u1
	i32.const	$push36=, u1
	copy_local	$6=, $pop36
	i32.eqz 	$push96=, $4
	br_if   	1, $pop96       # 1: down to label9
.LBB1_6:                                # %for.body12.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label10:
	i32.const	$push37=, 97
	i32.call	$push0=, memset@FUNCTION, $5, $pop37, $4
	i32.add 	$6=, $pop0, $4
.LBB1_7:                                # %for.cond17.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label9:
	i64.const	$push38=, 8680820740569200760
	i64.store	0($6):p2align=0, $pop38
	block   	
	block   	
	block   	
	i32.eqz 	$push97=, $2
	br_if   	0, $pop97       # 0: down to label14
# BB#8:                                 # %for.body26.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push42=, u2
	i32.const	$push41=, 0
	i32.call	$drop=, memset@FUNCTION, $pop42, $pop41, $2
	copy_local	$push40=, $3
	tee_local	$push39=, $7=, $pop40
	copy_local	$8=, $pop39
	br_if   	1, $4           # 1: down to label13
	br      	2               # 2: down to label12
.LBB1_9:                                #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label14:
	i32.const	$7=, u2
	i32.const	$push43=, u2
	copy_local	$8=, $pop43
	i32.eqz 	$push98=, $4
	br_if   	1, $pop98       # 1: down to label12
.LBB1_10:                               # %for.body33.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label13:
	i32.const	$push44=, 97
	i32.call	$push1=, memset@FUNCTION, $7, $pop44, $4
	i32.add 	$8=, $pop1, $4
.LBB1_11:                               # %for.cond38.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label12:
	i64.const	$push48=, 8680820740569200760
	i64.store	0($8):p2align=0, $pop48
	i32.const	$push47=, 0
	i32.store8	0($6), $pop47
	i32.const	$push46=, 0
	i32.store8	0($8), $pop46
	i32.const	$push45=, 80
	i32.call	$push2=, strncmp@FUNCTION, $5, $7, $pop45
	br_if   	3, $pop2        # 3: down to label5
# BB#12:                                # %test.exit
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push3=, strncmp@FUNCTION, $5, $7, $4
	br_if   	3, $pop3        # 3: down to label5
# BB#13:                                # %test.exit185
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push52=, 97
	i32.store16	0($6):p2align=0, $pop52
	i32.const	$push51=, 0
	i32.store8	0($8), $pop51
	i32.const	$push50=, 80
	i32.call	$push4=, strncmp@FUNCTION, $5, $7, $pop50
	i32.const	$push49=, 0
	i32.le_s	$push5=, $pop4, $pop49
	br_if   	3, $pop5        # 3: down to label5
# BB#14:                                # %test.exit190
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push6=, strncmp@FUNCTION, $5, $7, $4
	br_if   	3, $pop6        # 3: down to label5
# BB#15:                                # %test.exit196
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push56=, 0
	i32.store8	0($6), $pop56
	i32.const	$push55=, 97
	i32.store16	0($8):p2align=0, $pop55
	i32.const	$push54=, 80
	i32.call	$push7=, strncmp@FUNCTION, $5, $7, $pop54
	i32.const	$push53=, 0
	i32.ge_s	$push8=, $pop7, $pop53
	br_if   	3, $pop8        # 3: down to label5
# BB#16:                                # %test.exit201
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push9=, strncmp@FUNCTION, $5, $7, $4
	br_if   	3, $pop9        # 3: down to label5
# BB#17:                                # %test.exit207
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push60=, 98
	i32.store16	0($6):p2align=0, $pop60
	i32.const	$push59=, 99
	i32.store16	0($8):p2align=0, $pop59
	i32.const	$push58=, 80
	i32.call	$push10=, strncmp@FUNCTION, $5, $7, $pop58
	i32.const	$push57=, 0
	i32.ge_s	$push11=, $pop10, $pop57
	br_if   	3, $pop11       # 3: down to label5
# BB#18:                                # %test.exit213
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push12=, strncmp@FUNCTION, $5, $7, $4
	br_if   	3, $pop12       # 3: down to label5
# BB#19:                                # %test.exit219
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push64=, 99
	i32.store16	0($6):p2align=0, $pop64
	i32.const	$push63=, 98
	i32.store16	0($8):p2align=0, $pop63
	i32.const	$push62=, 80
	i32.call	$push13=, strncmp@FUNCTION, $5, $7, $pop62
	i32.const	$push61=, 0
	i32.le_s	$push14=, $pop13, $pop61
	br_if   	3, $pop14       # 3: down to label5
# BB#20:                                # %test.exit225
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push15=, strncmp@FUNCTION, $5, $7, $4
	br_if   	3, $pop15       # 3: down to label5
# BB#21:                                # %test.exit231
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push68=, 98
	i32.store16	0($6):p2align=0, $pop68
	i32.const	$push67=, 169
	i32.store16	0($8):p2align=0, $pop67
	i32.const	$push66=, 80
	i32.call	$push16=, strncmp@FUNCTION, $5, $7, $pop66
	i32.const	$push65=, 0
	i32.ge_s	$push17=, $pop16, $pop65
	br_if   	3, $pop17       # 3: down to label5
# BB#22:                                # %test.exit237
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push18=, strncmp@FUNCTION, $5, $7, $4
	br_if   	3, $pop18       # 3: down to label5
# BB#23:                                # %test.exit243
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push72=, 169
	i32.store16	0($6):p2align=0, $pop72
	i32.const	$push71=, 98
	i32.store16	0($8):p2align=0, $pop71
	i32.const	$push70=, 80
	i32.call	$push19=, strncmp@FUNCTION, $5, $7, $pop70
	i32.const	$push69=, 0
	i32.le_s	$push20=, $pop19, $pop69
	br_if   	3, $pop20       # 3: down to label5
# BB#24:                                # %test.exit249
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push21=, strncmp@FUNCTION, $5, $7, $4
	br_if   	3, $pop21       # 3: down to label5
# BB#25:                                # %test.exit255
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push76=, 169
	i32.store16	0($6):p2align=0, $pop76
	i32.const	$push75=, 170
	i32.store16	0($8):p2align=0, $pop75
	i32.const	$push74=, 80
	i32.call	$push22=, strncmp@FUNCTION, $5, $7, $pop74
	i32.const	$push73=, 0
	i32.ge_s	$push23=, $pop22, $pop73
	br_if   	3, $pop23       # 3: down to label5
# BB#26:                                # %test.exit261
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push24=, strncmp@FUNCTION, $5, $7, $4
	br_if   	3, $pop24       # 3: down to label5
# BB#27:                                # %test.exit267
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push80=, 170
	i32.store16	0($6):p2align=0, $pop80
	i32.const	$push79=, 169
	i32.store16	0($8):p2align=0, $pop79
	i32.const	$push78=, 80
	i32.call	$push25=, strncmp@FUNCTION, $5, $7, $pop78
	i32.const	$push77=, 0
	i32.le_s	$push26=, $pop25, $pop77
	br_if   	3, $pop26       # 3: down to label5
# BB#28:                                # %test.exit273
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push27=, strncmp@FUNCTION, $5, $7, $4
	br_if   	4, $pop27       # 4: down to label4
# BB#29:                                # %for.cond4
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push84=, 1
	i32.add 	$push83=, $4, $pop84
	tee_local	$push82=, $4=, $pop83
	i32.const	$push81=, 63
	i32.le_u	$push28=, $pop82, $pop81
	br_if   	0, $pop28       # 0: up to label8
# BB#30:                                # %for.inc79
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop
	i32.const	$push89=, 1
	i32.add 	$3=, $3, $pop89
	i32.const	$push88=, 1
	i32.add 	$push87=, $2, $pop88
	tee_local	$push86=, $2=, $pop87
	i32.const	$push85=, 8
	i32.lt_u	$push29=, $pop86, $pop85
	br_if   	0, $pop29       # 0: up to label7
# BB#31:                                # %for.inc82
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop
	i32.const	$push94=, 1
	i32.add 	$1=, $1, $pop94
	i32.const	$push93=, 1
	i32.add 	$push92=, $0, $pop93
	tee_local	$push91=, $0=, $pop92
	i32.const	$push90=, 8
	i32.lt_u	$push30=, $pop91, $pop90
	br_if   	0, $pop30       # 0: up to label6
# BB#32:                                # %for.end84
	end_loop
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


	.ident	"clang version 4.0.0 "
	.functype	strncmp, i32, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
