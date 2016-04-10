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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push133=, __stack_pointer
	i32.load	$push134=, 0($pop133)
	i32.const	$push135=, 112
	i32.sub 	$3=, $pop134, $pop135
	i32.const	$push136=, __stack_pointer
	i32.store	$discard=, 0($pop136), $3
	i32.const	$push0=, 24
	i32.add 	$push12=, $3, $pop0
	i32.const	$push2=, 0
	i64.load	$push13=, .Lmain.e+24($pop2)
	i64.store	$discard=, 0($pop12), $pop13
	i32.const	$push14=, 20
	i32.add 	$push15=, $3, $pop14
	i32.const	$push108=, 0
	i32.load	$push16=, .Lmain.e+20($pop108)
	i32.store	$discard=, 0($pop15), $pop16
	i32.const	$push4=, 16
	i32.add 	$push17=, $3, $pop4
	i32.const	$push107=, 0
	i32.load	$push18=, .Lmain.e+16($pop107):p2align=4
	i32.store	$discard=, 0($pop17):p2align=4, $pop18
	i32.const	$push140=, 32
	i32.add 	$push141=, $3, $pop140
	i32.const	$push106=, 24
	i32.add 	$push1=, $pop141, $pop106
	i32.const	$push105=, 0
	i64.load	$push3=, .Lmain.c+24($pop105)
	i64.store	$discard=, 0($pop1), $pop3
	i32.const	$push142=, 32
	i32.add 	$push143=, $3, $pop142
	i32.const	$push104=, 16
	i32.add 	$push5=, $pop143, $pop104
	i32.const	$push103=, 0
	i64.load	$push6=, .Lmain.c+16($pop103):p2align=4
	i64.store	$discard=, 0($pop5):p2align=4, $pop6
	i32.const	$push11=, 3
	i32.store	$discard=, 84($3), $pop11
	i32.const	$push102=, 0
	i32.load	$push19=, .Lmain.e+4($pop102)
	i32.store	$discard=, 4($3), $pop19
	i32.const	$push101=, 0
	i32.load	$push20=, .Lmain.e($pop101):p2align=4
	i32.store	$discard=, 0($3):p2align=4, $pop20
	i32.const	$push100=, 0
	i32.load	$push21=, .Lmain.e+8($pop100):p2align=3
	i32.store	$discard=, 8($3):p2align=3, $pop21
	i32.const	$push99=, 0
	i32.load	$push22=, .Lmain.e+12($pop99)
	i32.store	$discard=, 12($3), $pop22
	i32.const	$push98=, 0
	i64.load	$push7=, .Lmain.c+8($pop98)
	i64.store	$discard=, 40($3), $pop7
	i32.const	$push97=, 0
	i64.load	$push8=, .Lmain.c($pop97):p2align=4
	i64.store	$discard=, 32($3):p2align=4, $pop8
	i64.const	$push9=, 4621819117588971520
	i64.store	$discard=, 64($3), $pop9
	i64.const	$push10=, 4618441417868443648
	i64.store	$discard=, 72($3), $pop10
	i32.const	$push144=, 32
	i32.add 	$push145=, $3, $pop144
	i32.store	$discard=, 80($3):p2align=3, $pop145
	i32.store	$discard=, 104($3):p2align=3, $3
	i32.const	$push146=, 88
	i32.add 	$push147=, $3, $pop146
	i32.const	$push148=, 64
	i32.add 	$push149=, $3, $pop148
	call    	foo@FUNCTION, $pop147, $pop149
	block
	f64.load	$push23=, 0($3):p2align=4
	f64.const	$push24=, 0x0p0
	f64.ne  	$push25=, $pop23, $pop24
	br_if   	0, $pop25       # 0: down to label6
# BB#1:                                 # %lor.lhs.false
	f64.load	$push26=, 8($3)
	f64.const	$push27=, 0x1.4p4
	f64.ne  	$push28=, $pop26, $pop27
	br_if   	0, $pop28       # 0: down to label6
# BB#2:                                 # %lor.lhs.false9
	f64.load	$push29=, 16($3):p2align=4
	f64.const	$push30=, 0x1.4p3
	f64.ne  	$push31=, $pop29, $pop30
	br_if   	0, $pop31       # 0: down to label6
# BB#3:                                 # %lor.lhs.false12
	f64.load	$push32=, 24($3)
	f64.const	$push33=, -0x1.4p3
	f64.ne  	$push34=, $pop32, $pop33
	br_if   	0, $pop34       # 0: down to label6
# BB#4:                                 # %if.end
	i32.const	$push150=, 64
	i32.add 	$push151=, $3, $pop150
	i32.const	$push38=, 20
	i32.add 	$push39=, $pop151, $pop38
	i32.const	$push40=, 2
	i32.store	$discard=, 0($pop39), $pop40
	i32.const	$push43=, 24
	i32.add 	$push115=, $3, $pop43
	tee_local	$push114=, $0=, $pop115
	i32.const	$push41=, 0
	i64.load	$push42=, .Lmain.e+24($pop41)
	i64.store	$discard=, 0($pop114), $pop42
	i32.const	$push45=, 16
	i32.add 	$push113=, $3, $pop45
	tee_local	$push112=, $1=, $pop113
	i32.const	$push111=, 0
	i64.load	$push44=, .Lmain.e+16($pop111):p2align=4
	i64.store	$discard=, 0($pop112):p2align=4, $pop44
	i32.const	$push110=, 0
	i64.load	$push46=, .Lmain.e($pop110):p2align=4
	i64.store	$discard=, 0($3):p2align=4, $pop46
	i32.const	$push109=, 0
	i64.load	$push47=, .Lmain.e+8($pop109)
	i64.store	$discard=, 8($3), $pop47
	i32.const	$push152=, 88
	i32.add 	$push153=, $3, $pop152
	i32.const	$push154=, 64
	i32.add 	$push155=, $3, $pop154
	call    	foo@FUNCTION, $pop153, $pop155
	f64.load	$push48=, 0($3):p2align=4
	f64.const	$push49=, 0x1.ep5
	f64.ne  	$push50=, $pop48, $pop49
	br_if   	0, $pop50       # 0: down to label6
# BB#5:                                 # %if.end
	f64.load	$push35=, 8($3)
	f64.const	$push51=, 0x1.4p4
	f64.ne  	$push52=, $pop35, $pop51
	br_if   	0, $pop52       # 0: down to label6
# BB#6:                                 # %if.end
	f64.load	$push36=, 0($1):p2align=4
	f64.const	$push53=, -0x1.4p3
	f64.ne  	$push54=, $pop36, $pop53
	br_if   	0, $pop54       # 0: down to label6
# BB#7:                                 # %if.end
	f64.load	$push37=, 0($0)
	f64.const	$push55=, 0x1.d8p6
	f64.ne  	$push56=, $pop37, $pop55
	br_if   	0, $pop56       # 0: down to label6
# BB#8:                                 # %if.end30
	i32.const	$push156=, 64
	i32.add 	$push157=, $3, $pop156
	i32.const	$push60=, 20
	i32.add 	$push61=, $pop157, $pop60
	i32.const	$push62=, 1
	i32.store	$discard=, 0($pop61), $pop62
	i32.const	$push65=, 24
	i32.add 	$push122=, $3, $pop65
	tee_local	$push121=, $0=, $pop122
	i32.const	$push63=, 0
	i64.load	$push64=, .Lmain.e+24($pop63)
	i64.store	$discard=, 0($pop121), $pop64
	i32.const	$push67=, 16
	i32.add 	$push120=, $3, $pop67
	tee_local	$push119=, $1=, $pop120
	i32.const	$push118=, 0
	i64.load	$push66=, .Lmain.e+16($pop118):p2align=4
	i64.store	$discard=, 0($pop119):p2align=4, $pop66
	i32.const	$push117=, 0
	i64.load	$push68=, .Lmain.e($pop117):p2align=4
	i64.store	$discard=, 0($3):p2align=4, $pop68
	i32.const	$push116=, 0
	i64.load	$push69=, .Lmain.e+8($pop116)
	i64.store	$discard=, 8($3), $pop69
	i32.const	$push158=, 88
	i32.add 	$push159=, $3, $pop158
	i32.const	$push160=, 64
	i32.add 	$push161=, $3, $pop160
	call    	foo@FUNCTION, $pop159, $pop161
	f64.load	$push70=, 0($3):p2align=4
	f64.const	$push71=, -0x1.4p4
	f64.ne  	$push72=, $pop70, $pop71
	br_if   	0, $pop72       # 0: down to label6
# BB#9:                                 # %if.end30
	f64.load	$push57=, 8($3)
	f64.const	$push73=, -0x1.4p3
	f64.ne  	$push74=, $pop57, $pop73
	br_if   	0, $pop74       # 0: down to label6
# BB#10:                                # %if.end30
	f64.load	$push58=, 0($1):p2align=4
	f64.const	$push123=, 0x1.d8p6
	f64.ne  	$push75=, $pop58, $pop123
	br_if   	0, $pop75       # 0: down to label6
# BB#11:                                # %if.end30
	f64.load	$push59=, 0($0)
	f64.const	$push124=, 0x1.d8p6
	f64.ne  	$push76=, $pop59, $pop124
	br_if   	0, $pop76       # 0: down to label6
# BB#12:                                # %if.end46
	i32.const	$push84=, 24
	i32.add 	$push130=, $3, $pop84
	tee_local	$push129=, $2=, $pop130
	i32.const	$push162=, 64
	i32.add 	$push163=, $3, $pop162
	i32.const	$push80=, 20
	i32.add 	$push81=, $pop163, $pop80
	i32.const	$push82=, 0
	i32.store	$push128=, 0($pop81), $pop82
	tee_local	$push127=, $1=, $pop128
	i64.load	$push83=, .Lmain.e+24($pop127)
	i64.store	$discard=, 0($pop129), $pop83
	i32.const	$push86=, 16
	i32.add 	$push126=, $3, $pop86
	tee_local	$push125=, $0=, $pop126
	i64.load	$push85=, .Lmain.e+16($1):p2align=4
	i64.store	$discard=, 0($pop125):p2align=4, $pop85
	i64.load	$push87=, .Lmain.e($1):p2align=4
	i64.store	$discard=, 0($3):p2align=4, $pop87
	i64.load	$push88=, .Lmain.e+8($1)
	i64.store	$discard=, 8($3), $pop88
	i32.const	$push164=, 88
	i32.add 	$push165=, $3, $pop164
	i32.const	$push166=, 64
	i32.add 	$push167=, $3, $pop166
	call    	foo@FUNCTION, $pop165, $pop167
	f64.load	$push89=, 0($3):p2align=4
	f64.const	$push90=, 0x0p0
	f64.ne  	$push91=, $pop89, $pop90
	br_if   	0, $pop91       # 0: down to label6
# BB#13:                                # %if.end46
	f64.load	$push77=, 8($3)
	f64.const	$push131=, 0x1.d8p6
	f64.ne  	$push92=, $pop77, $pop131
	br_if   	0, $pop92       # 0: down to label6
# BB#14:                                # %if.end46
	f64.load	$push78=, 0($0):p2align=4
	f64.const	$push132=, 0x1.d8p6
	f64.ne  	$push93=, $pop78, $pop132
	br_if   	0, $pop93       # 0: down to label6
# BB#15:                                # %if.end46
	f64.load	$push79=, 0($2)
	f64.const	$push94=, 0x1.d8p6
	f64.ne  	$push95=, $pop79, $pop94
	br_if   	0, $pop95       # 0: down to label6
# BB#16:                                # %if.end62
	i32.const	$push96=, 0
	i32.const	$push139=, __stack_pointer
	i32.const	$push137=, 112
	i32.add 	$push138=, $3, $pop137
	i32.store	$discard=, 0($pop139), $pop138
	return  	$pop96
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
