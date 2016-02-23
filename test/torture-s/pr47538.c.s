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
	i32.const	$push51=, 0
	i32.eq  	$push52=, $2, $pop51
	br_if   	0, $pop52       # 0: down to label1
# BB#1:                                 # %if.else
	f64.sub 	$push2=, $8, $9
	f64.const	$push3=, 0x1p-2
	f64.mul 	$3=, $pop2, $pop3
	i32.const	$push0=, 1
	i32.add 	$push38=, $2, $pop0
	tee_local	$push37=, $10=, $pop38
	i32.const	$push4=, 2
	i32.ne  	$push5=, $pop37, $pop4
	br_if   	1, $pop5        # 1: down to label0
# BB#2:                                 # %if.then6
	i32.load	$0=, 16($0):p2align=3
	i32.load	$push31=, 16($1):p2align=3
	f64.load	$push32=, 0($pop31)
	f64.mul 	$push33=, $3, $pop32
	f64.store	$push43=, 8($0), $pop33
	tee_local	$push42=, $8=, $pop43
	f64.add 	$push34=, $pop42, $8
	f64.store	$discard=, 0($0), $pop34
	return
.LBB0_3:                                # %if.then
	end_block                       # label1:
	i32.load	$push35=, 16($0):p2align=3
	i64.const	$push36=, 0
	i64.store	$discard=, 0($pop35), $pop36
	return
.LBB0_4:                                # %for.cond.preheader
	end_block                       # label0:
	i32.load	$4=, 16($1):p2align=3
	i32.load	$5=, 16($0):p2align=3
	block
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
	br      	3               # 3: down to label2
.LBB0_7:
	end_loop                        # label5:
	end_block                       # label3:
	f64.const	$9=, 0x0p0
	f64.const	$8=, 0x1p0
.LBB0_8:                                # %for.end
	end_block                       # label2:
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push140=, __stack_pointer
	i32.load	$push141=, 0($pop140)
	i32.const	$push142=, 112
	i32.sub 	$17=, $pop141, $pop142
	i32.const	$push143=, __stack_pointer
	i32.store	$discard=, 0($pop143), $17
	i32.const	$push12=, 28
	i32.add 	$push13=, $17, $pop12
	i32.const	$push2=, 0
	i32.load	$push14=, .Lmain.e+28($pop2)
	i32.store	$discard=, 0($pop13), $pop14
	i32.const	$push0=, 24
	i32.add 	$push15=, $17, $pop0
	i32.const	$push113=, 0
	i32.load	$push16=, .Lmain.e+24($pop113):p2align=3
	i32.store	$discard=, 0($pop15):p2align=3, $pop16
	i32.const	$push112=, 24
	i32.const	$3=, 32
	i32.add 	$3=, $17, $3
	i32.add 	$push1=, $3, $pop112
	i32.const	$push111=, 0
	i64.load	$push3=, .Lmain.c+24($pop111)
	i64.store	$discard=, 0($pop1), $pop3
	i32.const	$push4=, 16
	i32.const	$4=, 32
	i32.add 	$4=, $17, $4
	i32.add 	$push5=, $4, $pop4
	i32.const	$push110=, 0
	i64.load	$push6=, .Lmain.c+16($pop110):p2align=4
	i64.store	$discard=, 0($pop5):p2align=4, $pop6
	i32.const	$push11=, 3
	i32.store	$discard=, 84($17), $pop11
	i32.const	$push109=, 16
	i32.add 	$push17=, $17, $pop109
	i32.const	$push108=, 0
	i64.load	$push18=, .Lmain.e+16($pop108):p2align=4
	i64.store	$discard=, 0($pop17):p2align=4, $pop18
	i32.const	$push107=, 0
	i64.load	$push7=, .Lmain.c+8($pop107)
	i64.store	$discard=, 40($17), $pop7
	i32.const	$push106=, 0
	i64.load	$push8=, .Lmain.c($pop106):p2align=4
	i64.store	$discard=, 32($17):p2align=4, $pop8
	i64.const	$push9=, 4621819117588971520
	i64.store	$discard=, 64($17), $pop9
	i64.const	$push10=, 4618441417868443648
	i64.store	$discard=, 72($17), $pop10
	i32.const	$push105=, 0
	i64.load	$push19=, .Lmain.e+8($pop105)
	i64.store	$discard=, 8($17), $pop19
	i32.const	$push104=, 0
	i64.load	$push20=, .Lmain.e($pop104):p2align=4
	i64.store	$discard=, 0($17):p2align=4, $pop20
	i32.const	$5=, 32
	i32.add 	$5=, $17, $5
	i32.store	$discard=, 80($17):p2align=3, $5
	i32.store	$discard=, 104($17):p2align=3, $17
	i32.const	$6=, 88
	i32.add 	$6=, $17, $6
	i32.const	$7=, 64
	i32.add 	$7=, $17, $7
	call    	foo@FUNCTION, $6, $7
	block
	f64.load	$push21=, 0($17):p2align=4
	f64.const	$push22=, 0x0p0
	f64.ne  	$push23=, $pop21, $pop22
	br_if   	0, $pop23       # 0: down to label6
# BB#1:                                 # %lor.lhs.false
	f64.load	$push24=, 8($17)
	f64.const	$push25=, 0x1.4p4
	f64.ne  	$push26=, $pop24, $pop25
	br_if   	0, $pop26       # 0: down to label6
# BB#2:                                 # %lor.lhs.false9
	f64.load	$push27=, 16($17):p2align=4
	f64.const	$push28=, 0x1.4p3
	f64.ne  	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label6
# BB#3:                                 # %lor.lhs.false12
	f64.load	$push30=, 24($17)
	f64.const	$push31=, -0x1.4p3
	f64.ne  	$push32=, $pop30, $pop31
	br_if   	0, $pop32       # 0: down to label6
# BB#4:                                 # %if.end
	i32.const	$push36=, 20
	i32.const	$8=, 64
	i32.add 	$8=, $17, $8
	i32.add 	$push37=, $8, $pop36
	i32.const	$push38=, 2
	i32.store	$discard=, 0($pop37), $pop38
	i32.const	$push39=, 28
	i32.add 	$push40=, $17, $pop39
	i32.const	$push41=, 0
	i32.load	$push42=, .Lmain.e+28($pop41)
	i32.store	$discard=, 0($pop40), $pop42
	i32.const	$push43=, 24
	i32.add 	$push121=, $17, $pop43
	tee_local	$push120=, $0=, $pop121
	i32.const	$push119=, 0
	i32.load	$push44=, .Lmain.e+24($pop119):p2align=3
	i32.store	$discard=, 0($pop120):p2align=3, $pop44
	i32.const	$push45=, 16
	i32.add 	$push118=, $17, $pop45
	tee_local	$push117=, $2=, $pop118
	i32.const	$push116=, 0
	i64.load	$push46=, .Lmain.e+16($pop116):p2align=4
	i64.store	$discard=, 0($pop117):p2align=4, $pop46
	i32.const	$push115=, 0
	i64.load	$push47=, .Lmain.e+8($pop115)
	i64.store	$discard=, 8($17), $pop47
	i32.const	$push114=, 0
	i64.load	$push48=, .Lmain.e($pop114):p2align=4
	i64.store	$discard=, 0($17):p2align=4, $pop48
	i32.const	$9=, 88
	i32.add 	$9=, $17, $9
	i32.const	$10=, 64
	i32.add 	$10=, $17, $10
	call    	foo@FUNCTION, $9, $10
	f64.load	$push49=, 0($17):p2align=4
	f64.const	$push50=, 0x1.ep5
	f64.ne  	$push51=, $pop49, $pop50
	br_if   	0, $pop51       # 0: down to label6
# BB#5:                                 # %if.end
	f64.load	$push33=, 8($17)
	f64.const	$push52=, 0x1.4p4
	f64.ne  	$push53=, $pop33, $pop52
	br_if   	0, $pop53       # 0: down to label6
# BB#6:                                 # %if.end
	f64.load	$push34=, 0($2):p2align=4
	f64.const	$push54=, -0x1.4p3
	f64.ne  	$push55=, $pop34, $pop54
	br_if   	0, $pop55       # 0: down to label6
# BB#7:                                 # %if.end
	f64.load	$push35=, 0($0)
	f64.const	$push56=, 0x1.d8p6
	f64.ne  	$push57=, $pop35, $pop56
	br_if   	0, $pop57       # 0: down to label6
# BB#8:                                 # %if.end30
	i32.const	$push61=, 20
	i32.const	$11=, 64
	i32.add 	$11=, $17, $11
	i32.add 	$push62=, $11, $pop61
	i32.const	$push63=, 1
	i32.store	$discard=, 0($pop62), $pop63
	i32.const	$push64=, 28
	i32.add 	$push65=, $17, $pop64
	i32.const	$push66=, 0
	i32.load	$push67=, .Lmain.e+28($pop66)
	i32.store	$discard=, 0($pop65), $pop67
	i32.const	$push68=, 24
	i32.add 	$push129=, $17, $pop68
	tee_local	$push128=, $0=, $pop129
	i32.const	$push127=, 0
	i32.load	$push69=, .Lmain.e+24($pop127):p2align=3
	i32.store	$discard=, 0($pop128):p2align=3, $pop69
	i32.const	$push70=, 16
	i32.add 	$push126=, $17, $pop70
	tee_local	$push125=, $2=, $pop126
	i32.const	$push124=, 0
	i64.load	$push71=, .Lmain.e+16($pop124):p2align=4
	i64.store	$discard=, 0($pop125):p2align=4, $pop71
	i32.const	$push123=, 0
	i64.load	$push72=, .Lmain.e+8($pop123)
	i64.store	$discard=, 8($17), $pop72
	i32.const	$push122=, 0
	i64.load	$push73=, .Lmain.e($pop122):p2align=4
	i64.store	$discard=, 0($17):p2align=4, $pop73
	i32.const	$12=, 88
	i32.add 	$12=, $17, $12
	i32.const	$13=, 64
	i32.add 	$13=, $17, $13
	call    	foo@FUNCTION, $12, $13
	f64.load	$push74=, 0($17):p2align=4
	f64.const	$push75=, -0x1.4p4
	f64.ne  	$push76=, $pop74, $pop75
	br_if   	0, $pop76       # 0: down to label6
# BB#9:                                 # %if.end30
	f64.load	$push58=, 8($17)
	f64.const	$push77=, -0x1.4p3
	f64.ne  	$push78=, $pop58, $pop77
	br_if   	0, $pop78       # 0: down to label6
# BB#10:                                # %if.end30
	f64.load	$push59=, 0($2):p2align=4
	f64.const	$push130=, 0x1.d8p6
	f64.ne  	$push79=, $pop59, $pop130
	br_if   	0, $pop79       # 0: down to label6
# BB#11:                                # %if.end30
	f64.load	$push60=, 0($0)
	f64.const	$push131=, 0x1.d8p6
	f64.ne  	$push80=, $pop60, $pop131
	br_if   	0, $pop80       # 0: down to label6
# BB#12:                                # %if.end46
	i32.const	$push87=, 28
	i32.add 	$push88=, $17, $pop87
	i32.const	$push84=, 20
	i32.const	$14=, 64
	i32.add 	$14=, $17, $14
	i32.add 	$push85=, $14, $pop84
	i32.const	$push86=, 0
	i32.store	$push137=, 0($pop85), $pop86
	tee_local	$push136=, $2=, $pop137
	i32.load	$push89=, .Lmain.e+28($pop136)
	i32.store	$discard=, 0($pop88), $pop89
	i32.const	$push90=, 24
	i32.add 	$push135=, $17, $pop90
	tee_local	$push134=, $1=, $pop135
	i32.load	$push91=, .Lmain.e+24($2):p2align=3
	i32.store	$discard=, 0($pop134):p2align=3, $pop91
	i32.const	$push92=, 16
	i32.add 	$push133=, $17, $pop92
	tee_local	$push132=, $0=, $pop133
	i64.load	$push93=, .Lmain.e+16($2):p2align=4
	i64.store	$discard=, 0($pop132):p2align=4, $pop93
	i64.load	$push94=, .Lmain.e+8($2)
	i64.store	$discard=, 8($17), $pop94
	i64.load	$push95=, .Lmain.e($2):p2align=4
	i64.store	$discard=, 0($17):p2align=4, $pop95
	i32.const	$15=, 88
	i32.add 	$15=, $17, $15
	i32.const	$16=, 64
	i32.add 	$16=, $17, $16
	call    	foo@FUNCTION, $15, $16
	f64.load	$push96=, 0($17):p2align=4
	f64.const	$push97=, 0x0p0
	f64.ne  	$push98=, $pop96, $pop97
	br_if   	0, $pop98       # 0: down to label6
# BB#13:                                # %if.end46
	f64.load	$push81=, 8($17)
	f64.const	$push138=, 0x1.d8p6
	f64.ne  	$push99=, $pop81, $pop138
	br_if   	0, $pop99       # 0: down to label6
# BB#14:                                # %if.end46
	f64.load	$push82=, 0($0):p2align=4
	f64.const	$push139=, 0x1.d8p6
	f64.ne  	$push100=, $pop82, $pop139
	br_if   	0, $pop100      # 0: down to label6
# BB#15:                                # %if.end46
	f64.load	$push83=, 0($1)
	f64.const	$push101=, 0x1.d8p6
	f64.ne  	$push102=, $pop83, $pop101
	br_if   	0, $pop102      # 0: down to label6
# BB#16:                                # %if.end62
	i32.const	$push103=, 0
	i32.const	$push144=, 112
	i32.add 	$17=, $17, $pop144
	i32.const	$push145=, __stack_pointer
	i32.store	$discard=, 0($pop145), $17
	return  	$pop103
.LBB1_17:                               # %if.then61
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.c,@object        # @main.c
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	4
.Lmain.c:
	.int64	4621819117588971520     # double 10
	.int64	4626322717216342016     # double 20
	.int64	4629137466983448576     # double 30
	.int64	4630826316843712512     # double 40
	.size	.Lmain.c, 32

	.type	.Lmain.e,@object        # @main.e
	.p2align	4
.Lmain.e:
	.int64	4638003928749834240     # double 118
	.int64	4638003928749834240     # double 118
	.int64	4638003928749834240     # double 118
	.int64	4638003928749834240     # double 118
	.size	.Lmain.e, 32


	.ident	"clang version 3.9.0 "
