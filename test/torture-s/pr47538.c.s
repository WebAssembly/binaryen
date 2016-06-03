	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr47538.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	f64, i32, i32, f64, i32, i32, i32, i32, f64, f64
# BB#0:                                 # %entry
	f64.load	$push1=, 0($1)
	f64.store	$10=, 0($0), $pop1
	f64.load	$push2=, 8($1)
	f64.store	$11=, 8($0), $pop2
	block
	block
	i32.load	$push38=, 20($1)
	tee_local	$push37=, $3=, $pop38
	i32.eqz 	$push57=, $pop37
	br_if   	0, $pop57       # 0: down to label1
# BB#1:                                 # %if.else
	f64.sub 	$push4=, $11, $10
	f64.const	$push5=, 0x1p-2
	f64.mul 	$5=, $pop4, $pop5
	i32.const	$push3=, 1
	i32.add 	$push40=, $3, $pop3
	tee_local	$push39=, $4=, $pop40
	i32.const	$push6=, 2
	i32.ne  	$push7=, $pop39, $pop6
	br_if   	1, $pop7        # 1: down to label0
# BB#2:                                 # %if.then6
	i32.load	$push44=, 16($0)
	tee_local	$push43=, $0=, $pop44
	i32.load	$push31=, 16($1)
	f64.load	$push32=, 0($pop31)
	f64.mul 	$push33=, $5, $pop32
	f64.store	$push42=, 8($0), $pop33
	tee_local	$push41=, $10=, $pop42
	f64.add 	$push34=, $pop41, $10
	f64.store	$drop=, 0($pop43), $pop34
	return
.LBB0_3:                                # %if.then
	end_block                       # label1:
	i32.load	$push35=, 16($0)
	i64.const	$push36=, 0
	i64.store	$drop=, 0($pop35), $pop36
	return
.LBB0_4:                                # %for.cond.preheader
	end_block                       # label0:
	i32.load	$8=, 16($0)
	i32.load	$7=, 16($1)
	block
	block
	i32.const	$push8=, -1
	i32.add 	$push46=, $3, $pop8
	tee_local	$push45=, $6=, $pop46
	i32.eqz 	$push58=, $pop45
	br_if   	0, $pop58       # 0: down to label3
# BB#5:                                 # %for.body.preheader
	i32.const	$push47=, 8
	i32.add 	$0=, $8, $pop47
	f64.const	$11=, 0x0p0
	f64.const	$10=, 0x1p0
	copy_local	$1=, $7
	i32.const	$9=, 1
.LBB0_6:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	f64.load	$push11=, 0($1)
	i32.const	$push53=, 16
	i32.add 	$push9=, $1, $pop53
	f64.load	$push10=, 0($pop9)
	f64.sub 	$push12=, $pop11, $pop10
	f64.mul 	$push13=, $5, $pop12
	f64.convert_u/i32	$push14=, $9
	f64.div 	$push15=, $pop13, $pop14
	f64.store	$2=, 0($0), $pop15
	i32.const	$push52=, 8
	i32.add 	$0=, $0, $pop52
	i32.const	$push51=, 8
	i32.add 	$1=, $1, $pop51
	f64.mul 	$push16=, $10, $2
	f64.add 	$11=, $11, $pop16
	f64.neg 	$10=, $10
	i32.const	$push50=, 1
	i32.add 	$push49=, $9, $pop50
	tee_local	$push48=, $9=, $pop49
	i32.le_u	$push17=, $pop48, $6
	br_if   	0, $pop17       # 0: up to label4
	br      	3               # 3: down to label2
.LBB0_7:
	end_loop                        # label5:
	end_block                       # label3:
	f64.const	$11=, 0x0p0
	f64.const	$10=, 0x1p0
.LBB0_8:                                # %for.end
	end_block                       # label2:
	i32.const	$push21=, 3
	i32.shl 	$push27=, $3, $pop21
	i32.add 	$push28=, $8, $pop27
	i32.const	$push56=, 3
	i32.shl 	$push22=, $6, $pop56
	i32.add 	$push23=, $7, $pop22
	f64.load	$push24=, 0($pop23)
	f64.mul 	$push25=, $5, $pop24
	f64.convert_u/i32	$push18=, $4
	f64.const	$push19=, -0x1p0
	f64.add 	$push20=, $pop18, $pop19
	f64.div 	$push26=, $pop25, $pop20
	f64.store	$push0=, 0($pop28), $pop26
	f64.mul 	$push29=, $10, $pop0
	f64.add 	$push55=, $11, $pop29
	tee_local	$push54=, $10=, $pop55
	f64.add 	$push30=, $pop54, $10
	f64.store	$drop=, 0($8), $pop30
                                        # fallthrough-return
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
	i32.const	$push100=, 0
	i32.const	$push97=, 0
	i32.load	$push98=, __stack_pointer($pop97)
	i32.const	$push99=, 112
	i32.sub 	$push126=, $pop98, $pop99
	i32.store	$push142=, __stack_pointer($pop100), $pop126
	tee_local	$push141=, $0=, $pop142
	i32.const	$push104=, 32
	i32.add 	$push105=, $pop141, $pop104
	i32.const	$push0=, 24
	i32.add 	$push1=, $pop105, $pop0
	i32.const	$push2=, 0
	i64.load	$push3=, .Lmain.c+24($pop2)
	i64.store	$drop=, 0($pop1), $pop3
	i32.const	$push106=, 32
	i32.add 	$push107=, $0, $pop106
	i32.const	$push4=, 16
	i32.add 	$push5=, $pop107, $pop4
	i32.const	$push140=, 0
	i64.load	$push6=, .Lmain.c+16($pop140)
	i64.store	$drop=, 0($pop5), $pop6
	i32.const	$push139=, 0
	i64.load	$push7=, .Lmain.c+8($pop139)
	i64.store	$drop=, 40($0), $pop7
	i32.const	$push138=, 0
	i64.load	$push8=, .Lmain.c($pop138)
	i64.store	$drop=, 32($0), $pop8
	i32.const	$push137=, 24
	i32.add 	$push9=, $0, $pop137
	i32.const	$push136=, 0
	i64.load	$push10=, .Lmain.e+24($pop136)
	i64.store	$drop=, 0($pop9), $pop10
	i32.const	$push11=, 3
	i32.store	$drop=, 84($0), $pop11
	i32.const	$push12=, 20
	i32.add 	$push13=, $0, $pop12
	i32.const	$push135=, 0
	i32.load	$push14=, .Lmain.e+20($pop135)
	i32.store	$drop=, 0($pop13), $pop14
	i32.const	$push108=, 32
	i32.add 	$push109=, $0, $pop108
	i32.store	$drop=, 80($0), $pop109
	i32.store	$push134=, 104($0), $0
	tee_local	$push133=, $0=, $pop134
	i32.const	$push132=, 16
	i32.add 	$push15=, $pop133, $pop132
	i32.const	$push131=, 0
	i32.load	$push16=, .Lmain.e+16($pop131)
	i32.store	$drop=, 0($pop15), $pop16
	i64.const	$push17=, 4621819117588971520
	i64.store	$drop=, 64($0), $pop17
	i64.const	$push18=, 4618441417868443648
	i64.store	$drop=, 72($0), $pop18
	i32.const	$push130=, 0
	i32.load	$push19=, .Lmain.e+4($pop130)
	i32.store	$drop=, 4($0), $pop19
	i32.const	$push129=, 0
	i32.load	$push20=, .Lmain.e($pop129)
	i32.store	$drop=, 0($0), $pop20
	i32.const	$push128=, 0
	i32.load	$push21=, .Lmain.e+8($pop128)
	i32.store	$drop=, 8($0), $pop21
	i32.const	$push127=, 0
	i32.load	$push22=, .Lmain.e+12($pop127)
	i32.store	$drop=, 12($0), $pop22
	i32.const	$push110=, 88
	i32.add 	$push111=, $0, $pop110
	i32.const	$push112=, 64
	i32.add 	$push113=, $0, $pop112
	call    	foo@FUNCTION, $pop111, $pop113
	block
	f64.load	$push24=, 0($0)
	f64.const	$push23=, 0x0p0
	f64.ne  	$push25=, $pop24, $pop23
	br_if   	0, $pop25       # 0: down to label6
# BB#1:                                 # %lor.lhs.false
	f64.load	$push27=, 8($0)
	f64.const	$push26=, 0x1.4p4
	f64.ne  	$push28=, $pop27, $pop26
	br_if   	0, $pop28       # 0: down to label6
# BB#2:                                 # %lor.lhs.false9
	f64.load	$push30=, 16($0)
	f64.const	$push29=, 0x1.4p3
	f64.ne  	$push31=, $pop30, $pop29
	br_if   	0, $pop31       # 0: down to label6
# BB#3:                                 # %lor.lhs.false12
	f64.load	$push33=, 24($0)
	f64.const	$push32=, -0x1.4p3
	f64.ne  	$push34=, $pop33, $pop32
	br_if   	0, $pop34       # 0: down to label6
# BB#4:                                 # %if.end
	i32.const	$push38=, 84
	i32.add 	$push39=, $0, $pop38
	i32.const	$push40=, 2
	i32.store	$drop=, 0($pop39), $pop40
	i32.const	$push43=, 24
	i32.add 	$push149=, $0, $pop43
	tee_local	$push148=, $1=, $pop149
	i32.const	$push41=, 0
	i64.load	$push42=, .Lmain.e+24($pop41)
	i64.store	$drop=, 0($pop148), $pop42
	i32.const	$push45=, 16
	i32.add 	$push147=, $0, $pop45
	tee_local	$push146=, $2=, $pop147
	i32.const	$push145=, 0
	i64.load	$push44=, .Lmain.e+16($pop145)
	i64.store	$drop=, 0($pop146), $pop44
	i32.const	$push144=, 0
	i64.load	$push46=, .Lmain.e($pop144)
	i64.store	$drop=, 0($0), $pop46
	i32.const	$push143=, 0
	i64.load	$push47=, .Lmain.e+8($pop143)
	i64.store	$drop=, 8($0), $pop47
	i32.const	$push114=, 88
	i32.add 	$push115=, $0, $pop114
	i32.const	$push116=, 64
	i32.add 	$push117=, $0, $pop116
	call    	foo@FUNCTION, $pop115, $pop117
	f64.load	$push49=, 0($0)
	f64.const	$push48=, 0x1.ep5
	f64.ne  	$push50=, $pop49, $pop48
	br_if   	0, $pop50       # 0: down to label6
# BB#5:                                 # %if.end
	f64.load	$push35=, 8($0)
	f64.const	$push51=, 0x1.4p4
	f64.ne  	$push52=, $pop35, $pop51
	br_if   	0, $pop52       # 0: down to label6
# BB#6:                                 # %if.end
	f64.load	$push36=, 0($2)
	f64.const	$push53=, -0x1.4p3
	f64.ne  	$push54=, $pop36, $pop53
	br_if   	0, $pop54       # 0: down to label6
# BB#7:                                 # %if.end
	f64.load	$push37=, 0($1)
	f64.const	$push55=, 0x1.d8p6
	f64.ne  	$push56=, $pop37, $pop55
	br_if   	0, $pop56       # 0: down to label6
# BB#8:                                 # %if.end30
	i32.const	$push60=, 84
	i32.add 	$push61=, $0, $pop60
	i32.const	$push62=, 1
	i32.store	$drop=, 0($pop61), $pop62
	i32.const	$push65=, 24
	i32.add 	$push156=, $0, $pop65
	tee_local	$push155=, $2=, $pop156
	i32.const	$push63=, 0
	i64.load	$push64=, .Lmain.e+24($pop63)
	i64.store	$drop=, 0($pop155), $pop64
	i32.const	$push67=, 16
	i32.add 	$push154=, $0, $pop67
	tee_local	$push153=, $1=, $pop154
	i32.const	$push152=, 0
	i64.load	$push66=, .Lmain.e+16($pop152)
	i64.store	$drop=, 0($pop153), $pop66
	i32.const	$push151=, 0
	i64.load	$push68=, .Lmain.e($pop151)
	i64.store	$drop=, 0($0), $pop68
	i32.const	$push150=, 0
	i64.load	$push69=, .Lmain.e+8($pop150)
	i64.store	$drop=, 8($0), $pop69
	i32.const	$push118=, 88
	i32.add 	$push119=, $0, $pop118
	i32.const	$push120=, 64
	i32.add 	$push121=, $0, $pop120
	call    	foo@FUNCTION, $pop119, $pop121
	f64.load	$push71=, 0($0)
	f64.const	$push70=, -0x1.4p4
	f64.ne  	$push72=, $pop71, $pop70
	br_if   	0, $pop72       # 0: down to label6
# BB#9:                                 # %if.end30
	f64.load	$push57=, 8($0)
	f64.const	$push73=, -0x1.4p3
	f64.ne  	$push74=, $pop57, $pop73
	br_if   	0, $pop74       # 0: down to label6
# BB#10:                                # %if.end30
	f64.load	$push58=, 0($1)
	f64.const	$push157=, 0x1.d8p6
	f64.ne  	$push75=, $pop58, $pop157
	br_if   	0, $pop75       # 0: down to label6
# BB#11:                                # %if.end30
	f64.load	$push59=, 0($2)
	f64.const	$push158=, 0x1.d8p6
	f64.ne  	$push76=, $pop59, $pop158
	br_if   	0, $pop76       # 0: down to label6
# BB#12:                                # %if.end46
	i32.const	$push84=, 24
	i32.add 	$push164=, $0, $pop84
	tee_local	$push163=, $3=, $pop164
	i32.const	$push80=, 84
	i32.add 	$push81=, $0, $pop80
	i32.const	$push82=, 0
	i32.store	$push162=, 0($pop81), $pop82
	tee_local	$push161=, $1=, $pop162
	i64.load	$push83=, .Lmain.e+24($pop161)
	i64.store	$drop=, 0($pop163), $pop83
	i32.const	$push86=, 16
	i32.add 	$push160=, $0, $pop86
	tee_local	$push159=, $2=, $pop160
	i64.load	$push85=, .Lmain.e+16($1)
	i64.store	$drop=, 0($pop159), $pop85
	i64.load	$push87=, .Lmain.e($1)
	i64.store	$drop=, 0($0), $pop87
	i64.load	$push88=, .Lmain.e+8($1)
	i64.store	$drop=, 8($0), $pop88
	i32.const	$push122=, 88
	i32.add 	$push123=, $0, $pop122
	i32.const	$push124=, 64
	i32.add 	$push125=, $0, $pop124
	call    	foo@FUNCTION, $pop123, $pop125
	f64.load	$push90=, 0($0)
	f64.const	$push89=, 0x0p0
	f64.ne  	$push91=, $pop90, $pop89
	br_if   	0, $pop91       # 0: down to label6
# BB#13:                                # %if.end46
	f64.load	$push77=, 8($0)
	f64.const	$push165=, 0x1.d8p6
	f64.ne  	$push92=, $pop77, $pop165
	br_if   	0, $pop92       # 0: down to label6
# BB#14:                                # %if.end46
	f64.load	$push78=, 0($2)
	f64.const	$push166=, 0x1.d8p6
	f64.ne  	$push93=, $pop78, $pop166
	br_if   	0, $pop93       # 0: down to label6
# BB#15:                                # %if.end46
	f64.load	$push79=, 0($3)
	f64.const	$push94=, 0x1.d8p6
	f64.ne  	$push95=, $pop79, $pop94
	br_if   	0, $pop95       # 0: down to label6
# BB#16:                                # %if.end62
	i32.const	$push103=, 0
	i32.const	$push101=, 112
	i32.add 	$push102=, $0, $pop101
	i32.store	$drop=, __stack_pointer($pop103), $pop102
	i32.const	$push96=, 0
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
	.functype	abort, void
