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
	f64.load	$push1=, 0($1)
	f64.store	$9=, 0($0), $pop1
	f64.store	$discard=, 8($0), $8
	block
	block
	block
	i32.const	$push51=, 0
	i32.eq  	$push52=, $2, $pop51
	br_if   	0, $pop52       # 0: down to label2
# BB#1:                                 # %if.else
	f64.sub 	$push2=, $8, $9
	f64.const	$push3=, 0x1p-2
	f64.mul 	$3=, $pop2, $pop3
	i32.const	$push0=, 1
	i32.add 	$push38=, $2, $pop0
	tee_local	$push37=, $10=, $pop38
	i32.const	$push4=, 2
	i32.ne  	$push5=, $pop37, $pop4
	br_if   	1, $pop5        # 1: down to label1
# BB#2:                                 # %if.then6
	i32.load	$0=, 16($0):p2align=3
	i32.load	$push31=, 16($1):p2align=3
	f64.load	$push32=, 0($pop31)
	f64.mul 	$push33=, $3, $pop32
	f64.store	$push43=, 8($0), $pop33
	tee_local	$push42=, $8=, $pop43
	f64.add 	$push34=, $pop42, $8
	f64.store	$discard=, 0($0), $pop34
	br      	2               # 2: down to label0
.LBB0_3:                                # %if.then
	end_block                       # label2:
	i32.load	$push35=, 16($0):p2align=3
	i64.const	$push36=, 0
	i64.store	$discard=, 0($pop35), $pop36
	br      	1               # 1: down to label0
.LBB0_4:                                # %for.cond.preheader
	end_block                       # label1:
	i32.load	$4=, 16($1):p2align=3
	i32.load	$5=, 16($0):p2align=3
	f64.const	$9=, 0x0p0
	f64.const	$8=, 0x1p0
	block
	i32.const	$push6=, -1
	i32.add 	$push40=, $2, $pop6
	tee_local	$push39=, $11=, $pop40
	i32.const	$push53=, 0
	i32.eq  	$push54=, $pop39, $pop53
	br_if   	0, $pop54       # 0: down to label3
# BB#5:                                 # %for.body.preheader
	f64.const	$9=, 0x0p0
	i32.const	$push41=, 8
	i32.add 	$0=, $5, $pop41
	copy_local	$1=, $4
	i32.const	$7=, 1
	f64.const	$8=, 0x1p0
.LBB0_6:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	f64.load	$push7=, 0($1)
	i32.const	$push47=, 16
	i32.add 	$push8=, $1, $pop47
	f64.load	$push9=, 0($pop8)
	f64.sub 	$push10=, $pop7, $pop9
	f64.mul 	$push11=, $3, $pop10
	f64.convert_u/i32	$push12=, $7
	f64.div 	$push13=, $pop11, $pop12
	f64.store	$push14=, 0($0), $pop13
	f64.mul 	$push15=, $8, $pop14
	f64.add 	$9=, $9, $pop15
	i32.const	$push46=, 1
	i32.add 	$6=, $7, $pop46
	f64.neg 	$8=, $8
	i32.const	$push45=, 8
	i32.add 	$1=, $1, $pop45
	i32.const	$push44=, 8
	i32.add 	$0=, $0, $pop44
	copy_local	$7=, $6
	i32.le_u	$push16=, $6, $11
	br_if   	0, $pop16       # 0: up to label4
.LBB0_7:                                # %for.end
	end_loop                        # label5:
	end_block                       # label3:
	i32.const	$push17=, 3
	i32.shl 	$push26=, $2, $pop17
	i32.add 	$push27=, $5, $pop26
	i32.const	$push50=, 3
	i32.shl 	$push18=, $11, $pop50
	i32.add 	$push19=, $4, $pop18
	f64.load	$push20=, 0($pop19)
	f64.mul 	$push21=, $3, $pop20
	f64.convert_u/i32	$push22=, $10
	f64.const	$push23=, -0x1p0
	f64.add 	$push24=, $pop22, $pop23
	f64.div 	$push25=, $pop21, $pop24
	f64.store	$push28=, 0($pop27), $pop25
	f64.mul 	$push29=, $8, $pop28
	f64.add 	$push49=, $9, $pop29
	tee_local	$push48=, $8=, $pop49
	f64.add 	$push30=, $pop48, $8
	f64.store	$discard=, 0($5), $pop30
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
	i32.const	$push121=, 0
	i32.load	$push18=, .Lmain.e+24($pop121):p2align=3
	i32.store	$discard=, 0($pop17):p2align=3, $pop18
	i32.const	$push120=, 24
	i32.const	$7=, 32
	i32.add 	$7=, $22, $7
	i32.add 	$push1=, $7, $pop120
	i32.const	$push119=, 0
	i64.load	$push3=, .Lmain.c+24($pop119)
	i64.store	$discard=, 0($pop1), $pop3
	i32.const	$push4=, 16
	i32.const	$8=, 32
	i32.add 	$8=, $22, $8
	i32.add 	$push5=, $8, $pop4
	i32.const	$push118=, 0
	i64.load	$push6=, .Lmain.c+16($pop118):p2align=4
	i64.store	$discard=, 0($pop5):p2align=4, $pop6
	i32.const	$push7=, 8
	i32.const	$9=, 32
	i32.add 	$9=, $22, $9
	i32.or  	$push8=, $9, $pop7
	i32.const	$push117=, 0
	i64.load	$push9=, .Lmain.c+8($pop117)
	i64.store	$discard=, 0($pop8), $pop9
	i32.const	$push13=, 3
	i32.store	$discard=, 84($22), $pop13
	i32.const	$push116=, 16
	i32.add 	$push19=, $22, $pop116
	i32.const	$push115=, 0
	i64.load	$push20=, .Lmain.e+16($pop115):p2align=4
	i64.store	$discard=, 0($pop19):p2align=4, $pop20
	i32.const	$push114=, 0
	i64.load	$push10=, .Lmain.c($pop114):p2align=4
	i64.store	$discard=, 32($22):p2align=4, $pop10
	i64.const	$push11=, 4621819117588971520
	i64.store	$discard=, 64($22), $pop11
	i64.const	$push12=, 4618441417868443648
	i64.store	$discard=, 72($22), $pop12
	i32.const	$push113=, 8
	i32.or  	$push112=, $22, $pop113
	tee_local	$push111=, $3=, $pop112
	i32.const	$push110=, 0
	i64.load	$push21=, .Lmain.e+8($pop110)
	i64.store	$discard=, 0($pop111), $pop21
	i32.const	$push109=, 0
	i64.load	$push22=, .Lmain.e($pop109):p2align=4
	i64.store	$discard=, 0($22):p2align=4, $pop22
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
	block
	block
	block
	f64.load	$push23=, 0($22):p2align=4
	f64.const	$push24=, 0x0p0
	f64.ne  	$push25=, $pop23, $pop24
	br_if   	0, $pop25       # 0: down to label9
# BB#1:                                 # %lor.lhs.false
	f64.load	$push26=, 0($3)
	f64.const	$push27=, 0x1.4p4
	f64.ne  	$push28=, $pop26, $pop27
	br_if   	0, $pop28       # 0: down to label9
# BB#2:                                 # %lor.lhs.false9
	f64.load	$push29=, 16($22):p2align=4
	f64.const	$push30=, 0x1.4p3
	f64.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label9
# BB#3:                                 # %lor.lhs.false12
	f64.load	$push32=, 24($22)
	f64.const	$push33=, -0x1.4p3
	f64.ne  	$push34=, $pop32, $pop33
	br_if   	0, $pop34       # 0: down to label9
# BB#4:                                 # %if.end
	i32.const	$push38=, 20
	i32.const	$13=, 64
	i32.add 	$13=, $22, $13
	i32.add 	$push39=, $13, $pop38
	i32.const	$push40=, 2
	i32.store	$discard=, 0($pop39), $pop40
	i32.const	$push41=, 28
	i32.add 	$push42=, $22, $pop41
	i32.const	$push43=, 0
	i32.load	$push44=, .Lmain.e+28($pop43)
	i32.store	$discard=, 0($pop42), $pop44
	i32.const	$push45=, 24
	i32.add 	$push131=, $22, $pop45
	tee_local	$push130=, $1=, $pop131
	i32.const	$push129=, 0
	i32.load	$push46=, .Lmain.e+24($pop129):p2align=3
	i32.store	$discard=, 0($pop130):p2align=3, $pop46
	i32.const	$push47=, 16
	i32.add 	$push128=, $22, $pop47
	tee_local	$push127=, $0=, $pop128
	i32.const	$push126=, 0
	i64.load	$push48=, .Lmain.e+16($pop126):p2align=4
	i64.store	$discard=, 0($pop127):p2align=4, $pop48
	i32.const	$push49=, 8
	i32.or  	$push125=, $22, $pop49
	tee_local	$push124=, $3=, $pop125
	i32.const	$push123=, 0
	i64.load	$push50=, .Lmain.e+8($pop123)
	i64.store	$discard=, 0($pop124), $pop50
	i32.const	$push122=, 0
	i64.load	$push51=, .Lmain.e($pop122):p2align=4
	i64.store	$discard=, 0($22):p2align=4, $pop51
	i32.const	$14=, 88
	i32.add 	$14=, $22, $14
	i32.const	$15=, 64
	i32.add 	$15=, $22, $15
	call    	foo@FUNCTION, $14, $15
	f64.load	$push52=, 0($22):p2align=4
	f64.const	$push53=, 0x1.ep5
	f64.ne  	$push54=, $pop52, $pop53
	br_if   	1, $pop54       # 1: down to label8
# BB#5:                                 # %if.end
	f64.load	$push35=, 0($3)
	f64.const	$push55=, 0x1.4p4
	f64.ne  	$push56=, $pop35, $pop55
	br_if   	1, $pop56       # 1: down to label8
# BB#6:                                 # %if.end
	f64.load	$push36=, 0($0):p2align=4
	f64.const	$push57=, -0x1.4p3
	f64.ne  	$push58=, $pop36, $pop57
	br_if   	1, $pop58       # 1: down to label8
# BB#7:                                 # %if.end
	f64.load	$push37=, 0($1)
	f64.const	$push59=, 0x1.d8p6
	f64.ne  	$push60=, $pop37, $pop59
	br_if   	1, $pop60       # 1: down to label8
# BB#8:                                 # %if.end30
	i32.const	$push64=, 20
	i32.const	$16=, 64
	i32.add 	$16=, $22, $16
	i32.add 	$push65=, $16, $pop64
	i32.const	$push66=, 1
	i32.store	$discard=, 0($pop65), $pop66
	i32.const	$push67=, 28
	i32.add 	$push68=, $22, $pop67
	i32.const	$push69=, 0
	i32.load	$push70=, .Lmain.e+28($pop69)
	i32.store	$discard=, 0($pop68), $pop70
	i32.const	$push71=, 24
	i32.add 	$push141=, $22, $pop71
	tee_local	$push140=, $1=, $pop141
	i32.const	$push139=, 0
	i32.load	$push72=, .Lmain.e+24($pop139):p2align=3
	i32.store	$discard=, 0($pop140):p2align=3, $pop72
	i32.const	$push73=, 16
	i32.add 	$push138=, $22, $pop73
	tee_local	$push137=, $0=, $pop138
	i32.const	$push136=, 0
	i64.load	$push74=, .Lmain.e+16($pop136):p2align=4
	i64.store	$discard=, 0($pop137):p2align=4, $pop74
	i32.const	$push75=, 8
	i32.or  	$push135=, $22, $pop75
	tee_local	$push134=, $3=, $pop135
	i32.const	$push133=, 0
	i64.load	$push76=, .Lmain.e+8($pop133)
	i64.store	$discard=, 0($pop134), $pop76
	i32.const	$push132=, 0
	i64.load	$push77=, .Lmain.e($pop132):p2align=4
	i64.store	$discard=, 0($22):p2align=4, $pop77
	i32.const	$17=, 88
	i32.add 	$17=, $22, $17
	i32.const	$18=, 64
	i32.add 	$18=, $22, $18
	call    	foo@FUNCTION, $17, $18
	f64.load	$push78=, 0($22):p2align=4
	f64.const	$push79=, -0x1.4p4
	f64.ne  	$push80=, $pop78, $pop79
	br_if   	2, $pop80       # 2: down to label7
# BB#9:                                 # %if.end30
	f64.load	$push61=, 0($3)
	f64.const	$push81=, -0x1.4p3
	f64.ne  	$push82=, $pop61, $pop81
	br_if   	2, $pop82       # 2: down to label7
# BB#10:                                # %if.end30
	f64.load	$push62=, 0($0):p2align=4
	f64.const	$push142=, 0x1.d8p6
	f64.ne  	$push83=, $pop62, $pop142
	br_if   	2, $pop83       # 2: down to label7
# BB#11:                                # %if.end30
	f64.load	$push63=, 0($1)
	f64.const	$push143=, 0x1.d8p6
	f64.ne  	$push84=, $pop63, $pop143
	br_if   	2, $pop84       # 2: down to label7
# BB#12:                                # %if.end46
	i32.const	$push91=, 28
	i32.add 	$push92=, $22, $pop91
	i32.const	$push88=, 20
	i32.const	$19=, 64
	i32.add 	$19=, $22, $19
	i32.add 	$push89=, $19, $pop88
	i32.const	$push90=, 0
	i32.store	$push151=, 0($pop89), $pop90
	tee_local	$push150=, $3=, $pop151
	i32.load	$push93=, .Lmain.e+28($pop150)
	i32.store	$discard=, 0($pop92), $pop93
	i32.const	$push94=, 24
	i32.add 	$push149=, $22, $pop94
	tee_local	$push148=, $2=, $pop149
	i32.load	$push95=, .Lmain.e+24($3):p2align=3
	i32.store	$discard=, 0($pop148):p2align=3, $pop95
	i32.const	$push96=, 16
	i32.add 	$push147=, $22, $pop96
	tee_local	$push146=, $1=, $pop147
	i64.load	$push97=, .Lmain.e+16($3):p2align=4
	i64.store	$discard=, 0($pop146):p2align=4, $pop97
	i32.const	$push98=, 8
	i32.or  	$push145=, $22, $pop98
	tee_local	$push144=, $0=, $pop145
	i64.load	$push99=, .Lmain.e+8($3)
	i64.store	$discard=, 0($pop144), $pop99
	i64.load	$push100=, .Lmain.e($3):p2align=4
	i64.store	$discard=, 0($22):p2align=4, $pop100
	i32.const	$20=, 88
	i32.add 	$20=, $22, $20
	i32.const	$21=, 64
	i32.add 	$21=, $22, $21
	call    	foo@FUNCTION, $20, $21
	f64.load	$push101=, 0($22):p2align=4
	f64.const	$push102=, 0x0p0
	f64.ne  	$push103=, $pop101, $pop102
	br_if   	3, $pop103      # 3: down to label6
# BB#13:                                # %if.end46
	f64.load	$push85=, 0($0)
	f64.const	$push152=, 0x1.d8p6
	f64.ne  	$push104=, $pop85, $pop152
	br_if   	3, $pop104      # 3: down to label6
# BB#14:                                # %if.end46
	f64.load	$push86=, 0($1):p2align=4
	f64.const	$push153=, 0x1.d8p6
	f64.ne  	$push105=, $pop86, $pop153
	br_if   	3, $pop105      # 3: down to label6
# BB#15:                                # %if.end46
	f64.load	$push87=, 0($2)
	f64.const	$push106=, 0x1.d8p6
	f64.ne  	$push107=, $pop87, $pop106
	br_if   	3, $pop107      # 3: down to label6
# BB#16:                                # %if.end62
	i32.const	$push108=, 0
	i32.const	$6=, 112
	i32.add 	$22=, $22, $6
	i32.const	$6=, __stack_pointer
	i32.store	$22=, 0($6), $22
	return  	$pop108
.LBB1_17:                               # %if.then
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB1_18:                               # %if.then29
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB1_19:                               # %if.then45
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB1_20:                               # %if.then61
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
