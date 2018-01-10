	.text
	.file	"strncmp-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test                    # -- Begin function test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.call	$0=, strncmp@FUNCTION, $0, $1, $2
	block   	
	block   	
	i32.const	$push0=, -1
	i32.gt_s	$push1=, $3, $pop0
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %entry
	i32.const	$push2=, 0
	i32.ge_s	$push3=, $0, $pop2
	br_if   	1, $pop3        # 1: down to label0
.LBB0_2:                                # %if.else
	end_block                       # label1:
	block   	
	br_if   	0, $3           # 0: down to label2
# %bb.3:                                # %if.else
	br_if   	1, $0           # 1: down to label0
.LBB0_4:                                # %if.else6
	end_block                       # label2:
	block   	
	i32.const	$push4=, 1
	i32.lt_s	$push5=, $3, $pop4
	br_if   	0, $pop5        # 0: down to label3
# %bb.5:                                # %if.else6
	i32.const	$push6=, 0
	i32.le_s	$push7=, $0, $pop6
	br_if   	1, $pop7        # 1: down to label0
.LBB0_6:                                # %if.end12
	end_block                       # label3:
	return
.LBB0_7:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	test, .Lfunc_end0-test
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$0=, u1
	i32.const	$1=, 0
.LBB1_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
                                        #       Child Loop BB1_3 Depth 3
	block   	
	loop    	                # label5:
	i32.const	$2=, u2
	i32.const	$3=, 0
.LBB1_2:                                # %for.body3
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_3 Depth 3
	loop    	                # label6:
	i32.const	$4=, 0
.LBB1_3:                                # %for.body6
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label7:
	block   	
	block   	
	block   	
	br_if   	0, $1           # 0: down to label10
# %bb.4:                                #   in Loop: Header=BB1_3 Depth=3
	i32.const	$5=, u1
	i32.const	$push32=, u1
	copy_local	$6=, $pop32
	br_if   	1, $4           # 1: down to label9
	br      	2               # 2: down to label8
.LBB1_5:                                # %for.body9.lr.ph
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label10:
	i32.const	$push35=, u1
	i32.const	$push34=, 0
	i32.call	$drop=, memset@FUNCTION, $pop35, $pop34, $1
	copy_local	$5=, $0
	copy_local	$6=, $5
	i32.eqz 	$push84=, $4
	br_if   	1, $pop84       # 1: down to label8
.LBB1_6:                                # %for.body12.lr.ph
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label9:
	i32.const	$push36=, 97
	i32.call	$push0=, memset@FUNCTION, $5, $pop36, $4
	i32.add 	$6=, $pop0, $4
.LBB1_7:                                # %for.end16
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label8:
	i64.const	$push37=, 8680820740569200760
	i64.store	0($6):p2align=0, $pop37
	block   	
	block   	
	block   	
	br_if   	0, $3           # 0: down to label13
# %bb.8:                                #   in Loop: Header=BB1_3 Depth=3
	i32.const	$7=, u2
	i32.const	$push33=, u2
	copy_local	$8=, $pop33
	br_if   	1, $4           # 1: down to label12
	br      	2               # 2: down to label11
.LBB1_9:                                # %for.body26.lr.ph
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label13:
	i32.const	$push39=, u2
	i32.const	$push38=, 0
	i32.call	$drop=, memset@FUNCTION, $pop39, $pop38, $3
	copy_local	$7=, $2
	copy_local	$8=, $7
	i32.eqz 	$push85=, $4
	br_if   	1, $pop85       # 1: down to label11
.LBB1_10:                               # %for.body33.lr.ph
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label12:
	i32.const	$push40=, 97
	i32.call	$push1=, memset@FUNCTION, $7, $pop40, $4
	i32.add 	$8=, $pop1, $4
.LBB1_11:                               # %for.end37
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label11:
	i64.const	$push43=, 8680820740569200640
	i64.store	0($8):p2align=0, $pop43
	i32.const	$push42=, 0
	i32.store8	0($6), $pop42
	i32.const	$push41=, 80
	i32.call	$push2=, strncmp@FUNCTION, $5, $7, $pop41
	br_if   	3, $pop2        # 3: down to label4
# %bb.12:                               # %test.exit
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push3=, strncmp@FUNCTION, $5, $7, $4
	br_if   	3, $pop3        # 3: down to label4
# %bb.13:                               # %test.exit185
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push47=, 97
	i32.store16	0($6):p2align=0, $pop47
	i32.const	$push46=, 0
	i32.store8	0($8), $pop46
	i32.const	$push45=, 80
	i32.call	$push4=, strncmp@FUNCTION, $5, $7, $pop45
	i32.const	$push44=, 0
	i32.le_s	$push5=, $pop4, $pop44
	br_if   	3, $pop5        # 3: down to label4
# %bb.14:                               # %test.exit190
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push6=, strncmp@FUNCTION, $5, $7, $4
	br_if   	3, $pop6        # 3: down to label4
# %bb.15:                               # %test.exit196
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push51=, 0
	i32.store8	0($6), $pop51
	i32.const	$push50=, 97
	i32.store16	0($8):p2align=0, $pop50
	i32.const	$push49=, 80
	i32.call	$push7=, strncmp@FUNCTION, $5, $7, $pop49
	i32.const	$push48=, 0
	i32.ge_s	$push8=, $pop7, $pop48
	br_if   	3, $pop8        # 3: down to label4
# %bb.16:                               # %test.exit201
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push9=, strncmp@FUNCTION, $5, $7, $4
	br_if   	3, $pop9        # 3: down to label4
# %bb.17:                               # %test.exit207
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push55=, 98
	i32.store16	0($6):p2align=0, $pop55
	i32.const	$push54=, 99
	i32.store16	0($8):p2align=0, $pop54
	i32.const	$push53=, 80
	i32.call	$push10=, strncmp@FUNCTION, $5, $7, $pop53
	i32.const	$push52=, 0
	i32.ge_s	$push11=, $pop10, $pop52
	br_if   	3, $pop11       # 3: down to label4
# %bb.18:                               # %test.exit213
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push12=, strncmp@FUNCTION, $5, $7, $4
	br_if   	3, $pop12       # 3: down to label4
# %bb.19:                               # %test.exit219
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push59=, 99
	i32.store16	0($6):p2align=0, $pop59
	i32.const	$push58=, 98
	i32.store16	0($8):p2align=0, $pop58
	i32.const	$push57=, 80
	i32.call	$push13=, strncmp@FUNCTION, $5, $7, $pop57
	i32.const	$push56=, 0
	i32.le_s	$push14=, $pop13, $pop56
	br_if   	3, $pop14       # 3: down to label4
# %bb.20:                               # %test.exit225
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push15=, strncmp@FUNCTION, $5, $7, $4
	br_if   	3, $pop15       # 3: down to label4
# %bb.21:                               # %test.exit231
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push63=, 98
	i32.store16	0($6):p2align=0, $pop63
	i32.const	$push62=, 169
	i32.store16	0($8):p2align=0, $pop62
	i32.const	$push61=, 80
	i32.call	$push16=, strncmp@FUNCTION, $5, $7, $pop61
	i32.const	$push60=, 0
	i32.ge_s	$push17=, $pop16, $pop60
	br_if   	3, $pop17       # 3: down to label4
# %bb.22:                               # %test.exit237
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push18=, strncmp@FUNCTION, $5, $7, $4
	br_if   	3, $pop18       # 3: down to label4
# %bb.23:                               # %test.exit243
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push67=, 169
	i32.store16	0($6):p2align=0, $pop67
	i32.const	$push66=, 98
	i32.store16	0($8):p2align=0, $pop66
	i32.const	$push65=, 80
	i32.call	$push19=, strncmp@FUNCTION, $5, $7, $pop65
	i32.const	$push64=, 0
	i32.le_s	$push20=, $pop19, $pop64
	br_if   	3, $pop20       # 3: down to label4
# %bb.24:                               # %test.exit249
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push21=, strncmp@FUNCTION, $5, $7, $4
	br_if   	3, $pop21       # 3: down to label4
# %bb.25:                               # %test.exit255
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push71=, 169
	i32.store16	0($6):p2align=0, $pop71
	i32.const	$push70=, 170
	i32.store16	0($8):p2align=0, $pop70
	i32.const	$push69=, 80
	i32.call	$push22=, strncmp@FUNCTION, $5, $7, $pop69
	i32.const	$push68=, 0
	i32.ge_s	$push23=, $pop22, $pop68
	br_if   	3, $pop23       # 3: down to label4
# %bb.26:                               # %test.exit261
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push24=, strncmp@FUNCTION, $5, $7, $4
	br_if   	3, $pop24       # 3: down to label4
# %bb.27:                               # %test.exit267
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push75=, 170
	i32.store16	0($6):p2align=0, $pop75
	i32.const	$push74=, 169
	i32.store16	0($8):p2align=0, $pop74
	i32.const	$push73=, 80
	i32.call	$push25=, strncmp@FUNCTION, $5, $7, $pop73
	i32.const	$push72=, 0
	i32.le_s	$push26=, $pop25, $pop72
	br_if   	3, $pop26       # 3: down to label4
# %bb.28:                               # %test.exit273
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push27=, strncmp@FUNCTION, $5, $7, $4
	br_if   	3, $pop27       # 3: down to label4
# %bb.29:                               # %for.cond4
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push77=, 1
	i32.add 	$4=, $4, $pop77
	i32.const	$push76=, 63
	i32.le_u	$push28=, $4, $pop76
	br_if   	0, $pop28       # 0: up to label7
# %bb.30:                               # %for.inc79
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop
	i32.const	$push80=, 1
	i32.add 	$2=, $2, $pop80
	i32.const	$push79=, 1
	i32.add 	$3=, $3, $pop79
	i32.const	$push78=, 8
	i32.lt_u	$push29=, $3, $pop78
	br_if   	0, $pop29       # 0: up to label6
# %bb.31:                               # %for.inc82
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop
	i32.const	$push83=, 1
	i32.add 	$0=, $0, $pop83
	i32.const	$push82=, 1
	i32.add 	$1=, $1, $pop82
	i32.const	$push81=, 8
	i32.lt_u	$push30=, $1, $pop81
	br_if   	0, $pop30       # 0: up to label5
# %bb.32:                               # %for.end84
	end_loop
	i32.const	$push31=, 0
	call    	exit@FUNCTION, $pop31
	unreachable
.LBB1_33:                               # %if.then5.i
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	strncmp, i32, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
