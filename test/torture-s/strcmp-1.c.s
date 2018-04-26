	.text
	.file	"strcmp-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test                    # -- Begin function test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32, i32
# %bb.0:                                # %entry
	i32.call	$0=, strcmp@FUNCTION, $0, $1
	block   	
	block   	
	i32.const	$push0=, -1
	i32.gt_s	$push1=, $2, $pop0
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %entry
	i32.const	$push2=, 0
	i32.ge_s	$push3=, $0, $pop2
	br_if   	1, $pop3        # 1: down to label0
.LBB0_2:                                # %if.else
	end_block                       # label1:
	block   	
	br_if   	0, $2           # 0: down to label2
# %bb.3:                                # %if.else
	br_if   	1, $0           # 1: down to label0
.LBB0_4:                                # %if.else6
	end_block                       # label2:
	block   	
	i32.const	$push4=, 1
	i32.lt_s	$push5=, $2, $pop4
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
	i32.const	$push25=, u1
	copy_local	$6=, $pop25
	br_if   	1, $4           # 1: down to label9
	br      	2               # 2: down to label8
.LBB1_5:                                # %for.body9.lr.ph
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label10:
	i32.const	$push28=, u1
	i32.const	$push27=, 0
	i32.call	$drop=, memset@FUNCTION, $pop28, $pop27, $1
	copy_local	$5=, $0
	copy_local	$6=, $5
	i32.eqz 	$push73=, $4
	br_if   	1, $pop73       # 1: down to label8
.LBB1_6:                                # %for.body12.lr.ph
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label9:
	i32.const	$push29=, 97
	i32.call	$push0=, memset@FUNCTION, $5, $pop29, $4
	i32.add 	$6=, $pop0, $4
.LBB1_7:                                # %for.end16
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label8:
	i64.const	$push32=, 8680820740569200760
	i64.store	0($6):p2align=0, $pop32
	i32.const	$push31=, 8
	i32.add 	$push2=, $6, $pop31
	i32.const	$push30=, 30840
	i32.store16	0($pop2):p2align=0, $pop30
	block   	
	block   	
	block   	
	br_if   	0, $3           # 0: down to label13
# %bb.8:                                #   in Loop: Header=BB1_3 Depth=3
	i32.const	$7=, u2
	i32.const	$push26=, u2
	copy_local	$8=, $pop26
	br_if   	1, $4           # 1: down to label12
	br      	2               # 2: down to label11
.LBB1_9:                                # %for.body26.lr.ph
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label13:
	i32.const	$push34=, u2
	i32.const	$push33=, 0
	i32.call	$drop=, memset@FUNCTION, $pop34, $pop33, $3
	copy_local	$7=, $2
	copy_local	$8=, $7
	i32.eqz 	$push74=, $4
	br_if   	1, $pop74       # 1: down to label11
.LBB1_10:                               # %for.body33.lr.ph
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label12:
	i32.const	$push35=, 97
	i32.call	$push1=, memset@FUNCTION, $7, $pop35, $4
	i32.add 	$8=, $pop1, $4
.LBB1_11:                               # %for.end37
                                        #   in Loop: Header=BB1_3 Depth=3
	end_block                       # label11:
	i64.const	$push40=, 8680820740569200760
	i64.store	1($8):p2align=0, $pop40
	i32.const	$push39=, 9
	i32.add 	$push3=, $8, $pop39
	i32.const	$push38=, 120
	i32.store8	0($pop3), $pop38
	i32.const	$push37=, 0
	i32.store8	0($6), $pop37
	i32.const	$push36=, 0
	i32.store8	0($8), $pop36
	i32.call	$push4=, strcmp@FUNCTION, $5, $7
	br_if   	3, $pop4        # 3: down to label4
# %bb.12:                               # %test.exit
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push43=, 97
	i32.store16	0($6):p2align=0, $pop43
	i32.const	$push42=, 0
	i32.store8	0($8), $pop42
	i32.call	$push5=, strcmp@FUNCTION, $5, $7
	i32.const	$push41=, 0
	i32.le_s	$push6=, $pop5, $pop41
	br_if   	3, $pop6        # 3: down to label4
# %bb.13:                               # %test.exit157
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push46=, 0
	i32.store8	0($6), $pop46
	i32.const	$push45=, 97
	i32.store16	0($8):p2align=0, $pop45
	i32.call	$push7=, strcmp@FUNCTION, $5, $7
	i32.const	$push44=, 0
	i32.ge_s	$push8=, $pop7, $pop44
	br_if   	3, $pop8        # 3: down to label4
# %bb.14:                               # %test.exit162
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push49=, 98
	i32.store16	0($6):p2align=0, $pop49
	i32.const	$push48=, 99
	i32.store16	0($8):p2align=0, $pop48
	i32.call	$push9=, strcmp@FUNCTION, $5, $7
	i32.const	$push47=, 0
	i32.ge_s	$push10=, $pop9, $pop47
	br_if   	3, $pop10       # 3: down to label4
# %bb.15:                               # %test.exit168
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push52=, 99
	i32.store16	0($6):p2align=0, $pop52
	i32.const	$push51=, 98
	i32.store16	0($8):p2align=0, $pop51
	i32.call	$push11=, strcmp@FUNCTION, $5, $7
	i32.const	$push50=, 0
	i32.le_s	$push12=, $pop11, $pop50
	br_if   	3, $pop12       # 3: down to label4
# %bb.16:                               # %test.exit174
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push55=, 98
	i32.store16	0($6):p2align=0, $pop55
	i32.const	$push54=, 169
	i32.store16	0($8):p2align=0, $pop54
	i32.call	$push13=, strcmp@FUNCTION, $5, $7
	i32.const	$push53=, 0
	i32.ge_s	$push14=, $pop13, $pop53
	br_if   	3, $pop14       # 3: down to label4
# %bb.17:                               # %test.exit180
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push58=, 169
	i32.store16	0($6):p2align=0, $pop58
	i32.const	$push57=, 98
	i32.store16	0($8):p2align=0, $pop57
	i32.call	$push15=, strcmp@FUNCTION, $5, $7
	i32.const	$push56=, 0
	i32.le_s	$push16=, $pop15, $pop56
	br_if   	3, $pop16       # 3: down to label4
# %bb.18:                               # %test.exit186
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push61=, 169
	i32.store16	0($6):p2align=0, $pop61
	i32.const	$push60=, 170
	i32.store16	0($8):p2align=0, $pop60
	i32.call	$push17=, strcmp@FUNCTION, $5, $7
	i32.const	$push59=, 0
	i32.ge_s	$push18=, $pop17, $pop59
	br_if   	3, $pop18       # 3: down to label4
# %bb.19:                               # %test.exit192
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push64=, 170
	i32.store16	0($6):p2align=0, $pop64
	i32.const	$push63=, 169
	i32.store16	0($8):p2align=0, $pop63
	i32.call	$push19=, strcmp@FUNCTION, $5, $7
	i32.const	$push62=, 0
	i32.le_s	$push20=, $pop19, $pop62
	br_if   	3, $pop20       # 3: down to label4
# %bb.20:                               # %for.cond4
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push66=, 1
	i32.add 	$4=, $4, $pop66
	i32.const	$push65=, 63
	i32.le_u	$push21=, $4, $pop65
	br_if   	0, $pop21       # 0: up to label7
# %bb.21:                               # %for.inc79
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop
	i32.const	$push69=, 1
	i32.add 	$2=, $2, $pop69
	i32.const	$push68=, 1
	i32.add 	$3=, $3, $pop68
	i32.const	$push67=, 8
	i32.lt_u	$push22=, $3, $pop67
	br_if   	0, $pop22       # 0: up to label6
# %bb.22:                               # %for.inc82
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop
	i32.const	$push72=, 1
	i32.add 	$0=, $0, $pop72
	i32.const	$push71=, 1
	i32.add 	$1=, $1, $pop71
	i32.const	$push70=, 8
	i32.lt_u	$push23=, $1, $pop70
	br_if   	0, $pop23       # 0: up to label5
# %bb.23:                               # %for.end84
	end_loop
	i32.const	$push24=, 0
	call    	exit@FUNCTION, $pop24
	unreachable
.LBB1_24:                               # %if.then5.i
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
	.skip	96
	.size	u1, 96

	.type	u2,@object              # @u2
	.section	.bss.u2,"aw",@nobits
	.p2align	4
u2:
	.skip	96
	.size	u2, 96


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	strcmp, i32, i32, i32
	.functype	abort, void
	.functype	exit, void, i32
