	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr47538.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, f64, i32, i32, i32, i32, f64, f64, i32, i32
# BB#0:                                 # %entry
	f64.load	$8=, 8($1)
	i32.load	$2=, 20($1)
	f64.load	$push3=, 0($1)
	f64.store	$9=, 0($0), $pop3
	f64.store	$discard=, 8($0), $8
	block
	block
	i32.const	$push51=, 0
	i32.eq  	$push52=, $2, $pop51
	br_if   	0, $pop52       # 0: down to label1
# BB#1:                                 # %if.else
	f64.sub 	$push4=, $8, $9
	f64.const	$push5=, 0x1p-2
	f64.mul 	$3=, $pop4, $pop5
	block
	i32.const	$push2=, 1
	i32.add 	$push0=, $2, $pop2
	tee_local	$push41=, $10=, $pop0
	i32.const	$push6=, 2
	i32.ne  	$push7=, $pop41, $pop6
	br_if   	0, $pop7        # 0: down to label2
# BB#2:                                 # %if.then6
	i32.load	$0=, 16($0):p2align=3
	i32.load	$push34=, 16($1):p2align=3
	f64.load	$push35=, 0($pop34)
	f64.mul 	$push36=, $3, $pop35
	f64.store	$push37=, 8($0), $pop36
	tee_local	$push44=, $8=, $pop37
	f64.add 	$push38=, $pop44, $8
	f64.store	$discard=, 0($0), $pop38
	br      	2               # 2: down to label0
.LBB0_3:                                # %for.cond.preheader
	end_block                       # label2:
	i32.load	$4=, 16($1):p2align=3
	i32.load	$5=, 16($0):p2align=3
	f64.const	$9=, 0x0p0
	f64.const	$8=, 0x1p0
	block
	i32.const	$push8=, -1
	i32.add 	$push1=, $2, $pop8
	tee_local	$push42=, $11=, $pop1
	i32.const	$push53=, 0
	i32.eq  	$push54=, $pop42, $pop53
	br_if   	0, $pop54       # 0: down to label3
# BB#4:                                 # %for.body.preheader
	f64.const	$9=, 0x0p0
	i32.const	$push43=, 8
	i32.add 	$0=, $5, $pop43
	copy_local	$1=, $4
	i32.const	$7=, 1
	f64.const	$8=, 0x1p0
.LBB0_5:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	f64.load	$push9=, 0($1)
	i32.const	$push48=, 16
	i32.add 	$push10=, $1, $pop48
	f64.load	$push11=, 0($pop10)
	f64.sub 	$push12=, $pop9, $pop11
	f64.mul 	$push13=, $3, $pop12
	f64.convert_u/i32	$push14=, $7
	f64.div 	$push15=, $pop13, $pop14
	f64.store	$push16=, 0($0), $pop15
	f64.mul 	$push17=, $8, $pop16
	f64.add 	$9=, $9, $pop17
	i32.const	$push47=, 1
	i32.add 	$6=, $7, $pop47
	f64.neg 	$8=, $8
	i32.const	$push46=, 8
	i32.add 	$1=, $1, $pop46
	i32.const	$push45=, 8
	i32.add 	$0=, $0, $pop45
	copy_local	$7=, $6
	i32.le_u	$push18=, $6, $11
	br_if   	0, $pop18       # 0: up to label4
.LBB0_6:                                # %for.end
	end_loop                        # label5:
	end_block                       # label3:
	i32.const	$push19=, 3
	i32.shl 	$push28=, $2, $pop19
	i32.add 	$push29=, $5, $pop28
	i32.const	$push50=, 3
	i32.shl 	$push20=, $11, $pop50
	i32.add 	$push21=, $4, $pop20
	f64.load	$push22=, 0($pop21)
	f64.mul 	$push23=, $3, $pop22
	f64.convert_u/i32	$push24=, $10
	f64.const	$push25=, -0x1p0
	f64.add 	$push26=, $pop24, $pop25
	f64.div 	$push27=, $pop23, $pop26
	f64.store	$push30=, 0($pop29), $pop27
	f64.mul 	$push31=, $8, $pop30
	f64.add 	$push32=, $9, $pop31
	tee_local	$push49=, $8=, $pop32
	f64.add 	$push33=, $pop49, $8
	f64.store	$discard=, 0($5), $pop33
	br      	1               # 1: down to label0
.LBB0_7:                                # %if.then
	end_block                       # label1:
	i32.load	$push39=, 16($0):p2align=3
	i64.const	$push40=, 0
	i64.store	$discard=, 0($pop39), $pop40
.LBB0_8:                                # %if.end53
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, __stack_pointer
	i32.load	$4=, 0($4)
	i32.const	$5=, 112
	i32.sub 	$22=, $4, $5
	i32.const	$5=, __stack_pointer
	i32.store	$22=, 0($5), $22
	i32.const	$push14=, 28
	i32.add 	$push15=, $22, $pop14
	i32.const	$push2=, 0
	i32.load	$push16=, .Lmain.e+28($pop2)
	i32.store	$discard=, 0($pop15), $pop16
	i32.const	$push0=, 24
	i32.add 	$push17=, $22, $pop0
	i32.const	$push131=, 0
	i32.load	$push18=, .Lmain.e+24($pop131):p2align=3
	i32.store	$discard=, 0($pop17):p2align=3, $pop18
	i32.const	$push130=, 24
	i32.const	$7=, 32
	i32.add 	$7=, $22, $7
	i32.add 	$push1=, $7, $pop130
	i32.const	$push129=, 0
	i64.load	$push3=, .Lmain.c+24($pop129)
	i64.store	$discard=, 0($pop1), $pop3
	i32.const	$push4=, 16
	i32.const	$8=, 32
	i32.add 	$8=, $22, $8
	i32.add 	$push5=, $8, $pop4
	i32.const	$push128=, 0
	i64.load	$push6=, .Lmain.c+16($pop128):p2align=4
	i64.store	$discard=, 0($pop5):p2align=4, $pop6
	i32.const	$push7=, 8
	i32.const	$9=, 32
	i32.add 	$9=, $22, $9
	i32.or  	$push8=, $9, $pop7
	i32.const	$push127=, 0
	i64.load	$push9=, .Lmain.c+8($pop127)
	i64.store	$discard=, 0($pop8), $pop9
	i32.const	$push13=, 3
	i32.store	$discard=, 84($22), $pop13
	i32.const	$push126=, 16
	i32.add 	$push19=, $22, $pop126
	i32.const	$push125=, 0
	i64.load	$push20=, .Lmain.e+16($pop125):p2align=4
	i64.store	$discard=, 0($pop19):p2align=4, $pop20
	i32.const	$push124=, 0
	i64.load	$push10=, .Lmain.c($pop124):p2align=4
	i64.store	$discard=, 32($22):p2align=4, $pop10
	i64.const	$push11=, 4621819117588971520
	i64.store	$discard=, 64($22), $pop11
	i64.const	$push12=, 4618441417868443648
	i64.store	$discard=, 72($22), $pop12
	i32.const	$push123=, 8
	i32.or  	$push21=, $22, $pop123
	tee_local	$push122=, $3=, $pop21
	i32.const	$push121=, 0
	i64.load	$push22=, .Lmain.e+8($pop121)
	i64.store	$discard=, 0($pop122), $pop22
	i32.const	$push120=, 0
	i64.load	$push23=, .Lmain.e($pop120):p2align=4
	i64.store	$discard=, 0($22):p2align=4, $pop23
	i32.const	$10=, 32
	i32.add 	$10=, $22, $10
	i32.store	$discard=, 80($22):p2align=3, $10
	i32.store	$discard=, 104($22):p2align=3, $22
	i32.const	$11=, 88
	i32.add 	$11=, $22, $11
	i32.const	$12=, 64
	i32.add 	$12=, $22, $12
	call    	foo@FUNCTION, $11, $12
	block
	f64.load	$push24=, 0($22):p2align=4
	f64.const	$push25=, 0x0p0
	f64.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label6
# BB#1:                                 # %lor.lhs.false
	f64.load	$push27=, 0($3)
	f64.const	$push28=, 0x1.4p4
	f64.ne  	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label6
# BB#2:                                 # %lor.lhs.false9
	f64.load	$push30=, 16($22):p2align=4
	f64.const	$push31=, 0x1.4p3
	f64.ne  	$push32=, $pop30, $pop31
	br_if   	0, $pop32       # 0: down to label6
# BB#3:                                 # %lor.lhs.false12
	f64.load	$push33=, 24($22)
	f64.const	$push34=, -0x1.4p3
	f64.ne  	$push35=, $pop33, $pop34
	br_if   	0, $pop35       # 0: down to label6
# BB#4:                                 # %if.end
	i32.const	$push39=, 20
	i32.const	$13=, 64
	i32.add 	$13=, $22, $13
	i32.add 	$push40=, $13, $pop39
	i32.const	$push41=, 2
	i32.store	$discard=, 0($pop40), $pop41
	i32.const	$push42=, 28
	i32.add 	$push43=, $22, $pop42
	i32.const	$push44=, 0
	i32.load	$push45=, .Lmain.e+28($pop44)
	i32.store	$discard=, 0($pop43), $pop45
	i32.const	$push46=, 24
	i32.add 	$push47=, $22, $pop46
	tee_local	$push138=, $1=, $pop47
	i32.const	$push137=, 0
	i32.load	$push48=, .Lmain.e+24($pop137):p2align=3
	i32.store	$discard=, 0($pop138):p2align=3, $pop48
	i32.const	$push49=, 16
	i32.add 	$push50=, $22, $pop49
	tee_local	$push136=, $0=, $pop50
	i32.const	$push135=, 0
	i64.load	$push51=, .Lmain.e+16($pop135):p2align=4
	i64.store	$discard=, 0($pop136):p2align=4, $pop51
	i32.const	$push52=, 8
	i32.or  	$push53=, $22, $pop52
	tee_local	$push134=, $3=, $pop53
	i32.const	$push133=, 0
	i64.load	$push54=, .Lmain.e+8($pop133)
	i64.store	$discard=, 0($pop134), $pop54
	i32.const	$push132=, 0
	i64.load	$push55=, .Lmain.e($pop132):p2align=4
	i64.store	$discard=, 0($22):p2align=4, $pop55
	i32.const	$14=, 88
	i32.add 	$14=, $22, $14
	i32.const	$15=, 64
	i32.add 	$15=, $22, $15
	call    	foo@FUNCTION, $14, $15
	block
	f64.load	$push56=, 0($22):p2align=4
	f64.const	$push57=, 0x1.ep5
	f64.ne  	$push58=, $pop56, $pop57
	br_if   	0, $pop58       # 0: down to label7
# BB#5:                                 # %if.end
	f64.load	$push36=, 0($3)
	f64.const	$push59=, 0x1.4p4
	f64.ne  	$push60=, $pop36, $pop59
	br_if   	0, $pop60       # 0: down to label7
# BB#6:                                 # %if.end
	f64.load	$push37=, 0($0):p2align=4
	f64.const	$push61=, -0x1.4p3
	f64.ne  	$push62=, $pop37, $pop61
	br_if   	0, $pop62       # 0: down to label7
# BB#7:                                 # %if.end
	f64.load	$push38=, 0($1)
	f64.const	$push63=, 0x1.d8p6
	f64.ne  	$push64=, $pop38, $pop63
	br_if   	0, $pop64       # 0: down to label7
# BB#8:                                 # %if.end30
	i32.const	$push68=, 20
	i32.const	$16=, 64
	i32.add 	$16=, $22, $16
	i32.add 	$push69=, $16, $pop68
	i32.const	$push70=, 1
	i32.store	$discard=, 0($pop69), $pop70
	i32.const	$push71=, 28
	i32.add 	$push72=, $22, $pop71
	i32.const	$push73=, 0
	i32.load	$push74=, .Lmain.e+28($pop73)
	i32.store	$discard=, 0($pop72), $pop74
	i32.const	$push75=, 24
	i32.add 	$push76=, $22, $pop75
	tee_local	$push145=, $1=, $pop76
	i32.const	$push144=, 0
	i32.load	$push77=, .Lmain.e+24($pop144):p2align=3
	i32.store	$discard=, 0($pop145):p2align=3, $pop77
	i32.const	$push78=, 16
	i32.add 	$push79=, $22, $pop78
	tee_local	$push143=, $0=, $pop79
	i32.const	$push142=, 0
	i64.load	$push80=, .Lmain.e+16($pop142):p2align=4
	i64.store	$discard=, 0($pop143):p2align=4, $pop80
	i32.const	$push81=, 8
	i32.or  	$push82=, $22, $pop81
	tee_local	$push141=, $3=, $pop82
	i32.const	$push140=, 0
	i64.load	$push83=, .Lmain.e+8($pop140)
	i64.store	$discard=, 0($pop141), $pop83
	i32.const	$push139=, 0
	i64.load	$push84=, .Lmain.e($pop139):p2align=4
	i64.store	$discard=, 0($22):p2align=4, $pop84
	i32.const	$17=, 88
	i32.add 	$17=, $22, $17
	i32.const	$18=, 64
	i32.add 	$18=, $22, $18
	call    	foo@FUNCTION, $17, $18
	block
	f64.load	$push85=, 0($22):p2align=4
	f64.const	$push86=, -0x1.4p4
	f64.ne  	$push87=, $pop85, $pop86
	br_if   	0, $pop87       # 0: down to label8
# BB#9:                                 # %if.end30
	f64.load	$push65=, 0($3)
	f64.const	$push88=, -0x1.4p3
	f64.ne  	$push89=, $pop65, $pop88
	br_if   	0, $pop89       # 0: down to label8
# BB#10:                                # %if.end30
	f64.load	$push66=, 0($0):p2align=4
	f64.const	$push146=, 0x1.d8p6
	f64.ne  	$push90=, $pop66, $pop146
	br_if   	0, $pop90       # 0: down to label8
# BB#11:                                # %if.end30
	f64.load	$push67=, 0($1)
	f64.const	$push147=, 0x1.d8p6
	f64.ne  	$push91=, $pop67, $pop147
	br_if   	0, $pop91       # 0: down to label8
# BB#12:                                # %if.end46
	i32.const	$push99=, 28
	i32.add 	$push100=, $22, $pop99
	i32.const	$push95=, 20
	i32.const	$19=, 64
	i32.add 	$19=, $22, $19
	i32.add 	$push96=, $19, $pop95
	i32.const	$push97=, 0
	i32.store	$push98=, 0($pop96), $pop97
	tee_local	$push151=, $3=, $pop98
	i32.load	$push101=, .Lmain.e+28($pop151)
	i32.store	$discard=, 0($pop100), $pop101
	i32.const	$push102=, 24
	i32.add 	$push103=, $22, $pop102
	tee_local	$push150=, $2=, $pop103
	i32.load	$push104=, .Lmain.e+24($3):p2align=3
	i32.store	$discard=, 0($pop150):p2align=3, $pop104
	i32.const	$push105=, 16
	i32.add 	$push106=, $22, $pop105
	tee_local	$push149=, $1=, $pop106
	i64.load	$push107=, .Lmain.e+16($3):p2align=4
	i64.store	$discard=, 0($pop149):p2align=4, $pop107
	i32.const	$push108=, 8
	i32.or  	$push109=, $22, $pop108
	tee_local	$push148=, $0=, $pop109
	i64.load	$push110=, .Lmain.e+8($3)
	i64.store	$discard=, 0($pop148), $pop110
	i64.load	$push111=, .Lmain.e($3):p2align=4
	i64.store	$discard=, 0($22):p2align=4, $pop111
	i32.const	$20=, 88
	i32.add 	$20=, $22, $20
	i32.const	$21=, 64
	i32.add 	$21=, $22, $21
	call    	foo@FUNCTION, $20, $21
	block
	f64.load	$push112=, 0($22):p2align=4
	f64.const	$push113=, 0x0p0
	f64.ne  	$push114=, $pop112, $pop113
	br_if   	0, $pop114      # 0: down to label9
# BB#13:                                # %if.end46
	f64.load	$push92=, 0($0)
	f64.const	$push152=, 0x1.d8p6
	f64.ne  	$push115=, $pop92, $pop152
	br_if   	0, $pop115      # 0: down to label9
# BB#14:                                # %if.end46
	f64.load	$push93=, 0($1):p2align=4
	f64.const	$push153=, 0x1.d8p6
	f64.ne  	$push116=, $pop93, $pop153
	br_if   	0, $pop116      # 0: down to label9
# BB#15:                                # %if.end46
	f64.load	$push94=, 0($2)
	f64.const	$push117=, 0x1.d8p6
	f64.ne  	$push118=, $pop94, $pop117
	br_if   	0, $pop118      # 0: down to label9
# BB#16:                                # %if.end62
	i32.const	$push119=, 0
	i32.const	$6=, 112
	i32.add 	$22=, $22, $6
	i32.const	$6=, __stack_pointer
	i32.store	$22=, 0($6), $22
	return  	$pop119
.LBB1_17:                               # %if.then61
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_18:                               # %if.then45
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_19:                               # %if.then29
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_20:                               # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.c,@object        # @main.c
	.section	.rodata..Lmain.c,"a",@progbits
	.p2align	4
.Lmain.c:
	.int64	4621819117588971520     # double 10
	.int64	4626322717216342016     # double 20
	.int64	4629137466983448576     # double 30
	.int64	4630826316843712512     # double 40
	.size	.Lmain.c, 32

	.type	.Lmain.e,@object        # @main.e
	.section	.rodata..Lmain.e,"a",@progbits
	.p2align	4
.Lmain.e:
	.int64	4638003928749834240     # double 118
	.int64	4638003928749834240     # double 118
	.int64	4638003928749834240     # double 118
	.int64	4638003928749834240     # double 118
	.size	.Lmain.e, 32


	.ident	"clang version 3.9.0 "
