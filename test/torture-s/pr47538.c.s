	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr47538.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32, f64, i32, i32, i32, f64, i32, f64, f64
# BB#0:                                 # %entry
	f64.load	$push43=, 0($1)
	tee_local	$push42=, $11=, $pop43
	f64.store	0($0), $pop42
	f64.load	$push41=, 8($1)
	tee_local	$push40=, $10=, $pop41
	f64.store	8($0), $pop40
	block   	
	block   	
	i32.load	$push39=, 20($1)
	tee_local	$push38=, $2=, $pop39
	i32.eqz 	$push68=, $pop38
	br_if   	0, $pop68       # 0: down to label1
# BB#1:                                 # %if.else
	f64.sub 	$push1=, $10, $11
	f64.const	$push2=, 0x1p-2
	f64.mul 	$4=, $pop1, $pop2
	i32.const	$push0=, 1
	i32.add 	$push45=, $2, $pop0
	tee_local	$push44=, $3=, $pop45
	i32.const	$push3=, 2
	i32.ne  	$push4=, $pop44, $pop3
	br_if   	1, $pop4        # 1: down to label0
# BB#2:                                 # %if.then6
	i32.load	$push49=, 16($0)
	tee_local	$push48=, $0=, $pop49
	i32.load	$push33=, 16($1)
	f64.load	$push34=, 0($pop33)
	f64.mul 	$push47=, $4, $pop34
	tee_local	$push46=, $11=, $pop47
	f64.store	8($pop48), $pop46
	f64.add 	$push35=, $11, $11
	f64.store	0($0), $pop35
	return
.LBB0_3:                                # %if.then
	end_block                       # label1:
	i32.load	$push36=, 16($0)
	i64.const	$push37=, 0
	i64.store	0($pop36), $pop37
	return
.LBB0_4:                                # %for.cond.preheader
	end_block                       # label0:
	i32.load	$7=, 16($0)
	i32.load	$6=, 16($1)
	block   	
	block   	
	i32.const	$push5=, -1
	i32.add 	$push51=, $2, $pop5
	tee_local	$push50=, $5=, $pop51
	i32.eqz 	$push69=, $pop50
	br_if   	0, $pop69       # 0: down to label3
# BB#5:                                 # %for.body.lr.ph
	f64.load	$push7=, 0($6)
	f64.load	$push6=, 16($6)
	f64.sub 	$push8=, $pop7, $pop6
	f64.mul 	$push54=, $4, $pop8
	tee_local	$push53=, $11=, $pop54
	f64.store	8($7), $pop53
	f64.const	$push9=, 0x0p0
	f64.add 	$10=, $11, $pop9
	f64.const	$11=, -0x1p0
	i32.const	$push52=, 1
	i32.eq  	$push10=, $5, $pop52
	br_if   	1, $pop10       # 1: down to label2
# BB#6:                                 # %for.body.preheader
	i32.const	$push11=, 16
	i32.add 	$0=, $7, $pop11
	i32.const	$push12=, 24
	i32.add 	$1=, $6, $pop12
	f64.const	$11=, -0x1p0
	i32.const	$9=, 2
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label4:
	i32.const	$push62=, -16
	i32.add 	$push13=, $1, $pop62
	f64.load	$push14=, 0($pop13)
	f64.load	$push15=, 0($1)
	f64.sub 	$push16=, $pop14, $pop15
	f64.mul 	$push17=, $4, $pop16
	f64.convert_u/i32	$push18=, $9
	f64.div 	$push61=, $pop17, $pop18
	tee_local	$push60=, $8=, $pop61
	f64.store	0($0), $pop60
	i32.const	$push59=, 8
	i32.add 	$0=, $0, $pop59
	i32.const	$push58=, 8
	i32.add 	$1=, $1, $pop58
	f64.mul 	$push19=, $11, $8
	f64.add 	$10=, $10, $pop19
	f64.neg 	$11=, $11
	i32.const	$push57=, 1
	i32.add 	$push56=, $9, $pop57
	tee_local	$push55=, $9=, $pop56
	i32.le_u	$push20=, $pop55, $5
	br_if   	0, $pop20       # 0: up to label4
	br      	2               # 2: down to label2
.LBB0_8:
	end_loop
	end_block                       # label3:
	f64.const	$11=, 0x1p0
	f64.const	$10=, 0x0p0
.LBB0_9:                                # %for.end
	end_block                       # label2:
	i32.const	$push24=, 3
	i32.shl 	$push29=, $2, $pop24
	i32.add 	$push30=, $7, $pop29
	i32.const	$push67=, 3
	i32.shl 	$push25=, $5, $pop67
	i32.add 	$push26=, $6, $pop25
	f64.load	$push27=, 0($pop26)
	f64.mul 	$push28=, $4, $pop27
	f64.convert_u/i32	$push21=, $3
	f64.const	$push22=, -0x1p0
	f64.add 	$push23=, $pop21, $pop22
	f64.div 	$push66=, $pop28, $pop23
	tee_local	$push65=, $8=, $pop66
	f64.store	0($pop30), $pop65
	f64.mul 	$push31=, $11, $8
	f64.add 	$push64=, $10, $pop31
	tee_local	$push63=, $11=, $pop64
	f64.add 	$push32=, $pop63, $11
	f64.store	0($7), $pop32
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push100=, 0
	i32.const	$push98=, 0
	i32.load	$push97=, __stack_pointer($pop98)
	i32.const	$push99=, 112
	i32.sub 	$push139=, $pop97, $pop99
	tee_local	$push138=, $2=, $pop139
	i32.store	__stack_pointer($pop100), $pop138
	i32.const	$push104=, 32
	i32.add 	$push105=, $2, $pop104
	i32.const	$push0=, 24
	i32.add 	$push1=, $pop105, $pop0
	i32.const	$push2=, 0
	i64.load	$push3=, .Lmain.c+24($pop2)
	i64.store	0($pop1), $pop3
	i32.const	$push106=, 32
	i32.add 	$push107=, $2, $pop106
	i32.const	$push4=, 16
	i32.add 	$push5=, $pop107, $pop4
	i32.const	$push137=, 0
	i64.load	$push6=, .Lmain.c+16($pop137)
	i64.store	0($pop5), $pop6
	i32.const	$push136=, 0
	i64.load	$push7=, .Lmain.c+8($pop136)
	i64.store	40($2), $pop7
	i32.const	$push135=, 0
	i64.load	$push8=, .Lmain.c($pop135)
	i64.store	32($2), $pop8
	i32.const	$push134=, 24
	i32.add 	$push9=, $2, $pop134
	i32.const	$push133=, 0
	i64.load	$push10=, .Lmain.e+24($pop133)
	i64.store	0($pop9), $pop10
	i32.const	$push11=, 3
	i32.store	84($2), $pop11
	i32.const	$push12=, 20
	i32.add 	$push13=, $2, $pop12
	i32.const	$push132=, 0
	i32.load	$push14=, .Lmain.e+20($pop132)
	i32.store	0($pop13), $pop14
	i32.const	$push108=, 32
	i32.add 	$push109=, $2, $pop108
	i32.store	80($2), $pop109
	i32.store	104($2), $2
	i32.const	$push131=, 16
	i32.add 	$push15=, $2, $pop131
	i32.const	$push130=, 0
	i32.load	$push16=, .Lmain.e+16($pop130)
	i32.store	0($pop15), $pop16
	i64.const	$push17=, 4621819117588971520
	i64.store	64($2), $pop17
	i64.const	$push18=, 4618441417868443648
	i64.store	72($2), $pop18
	i32.const	$push129=, 0
	i32.load	$push19=, .Lmain.e+4($pop129)
	i32.store	4($2), $pop19
	i32.const	$push128=, 0
	i32.load	$push20=, .Lmain.e($pop128)
	i32.store	0($2), $pop20
	i32.const	$push127=, 0
	i32.load	$push21=, .Lmain.e+8($pop127)
	i32.store	8($2), $pop21
	i32.const	$push126=, 0
	i32.load	$push22=, .Lmain.e+12($pop126)
	i32.store	12($2), $pop22
	i32.const	$push110=, 88
	i32.add 	$push111=, $2, $pop110
	i32.const	$push112=, 64
	i32.add 	$push113=, $2, $pop112
	call    	foo@FUNCTION, $pop111, $pop113
	block   	
	f64.load	$push24=, 0($2)
	f64.const	$push23=, 0x0p0
	f64.ne  	$push25=, $pop24, $pop23
	br_if   	0, $pop25       # 0: down to label5
# BB#1:                                 # %lor.lhs.false
	f64.load	$push27=, 8($2)
	f64.const	$push26=, 0x1.4p4
	f64.ne  	$push28=, $pop27, $pop26
	br_if   	0, $pop28       # 0: down to label5
# BB#2:                                 # %lor.lhs.false9
	f64.load	$push30=, 16($2)
	f64.const	$push29=, 0x1.4p3
	f64.ne  	$push31=, $pop30, $pop29
	br_if   	0, $pop31       # 0: down to label5
# BB#3:                                 # %lor.lhs.false12
	f64.load	$push33=, 24($2)
	f64.const	$push32=, -0x1.4p3
	f64.ne  	$push34=, $pop33, $pop32
	br_if   	0, $pop34       # 0: down to label5
# BB#4:                                 # %if.end
	i32.const	$push38=, 84
	i32.add 	$push39=, $2, $pop38
	i32.const	$push40=, 2
	i32.store	0($pop39), $pop40
	i32.const	$push43=, 24
	i32.add 	$push146=, $2, $pop43
	tee_local	$push145=, $0=, $pop146
	i32.const	$push41=, 0
	i64.load	$push42=, .Lmain.e+24($pop41)
	i64.store	0($pop145), $pop42
	i32.const	$push45=, 16
	i32.add 	$push144=, $2, $pop45
	tee_local	$push143=, $1=, $pop144
	i32.const	$push142=, 0
	i64.load	$push44=, .Lmain.e+16($pop142)
	i64.store	0($pop143), $pop44
	i32.const	$push141=, 0
	i64.load	$push46=, .Lmain.e($pop141)
	i64.store	0($2), $pop46
	i32.const	$push140=, 0
	i64.load	$push47=, .Lmain.e+8($pop140)
	i64.store	8($2), $pop47
	i32.const	$push114=, 88
	i32.add 	$push115=, $2, $pop114
	i32.const	$push116=, 64
	i32.add 	$push117=, $2, $pop116
	call    	foo@FUNCTION, $pop115, $pop117
	f64.load	$push49=, 0($2)
	f64.const	$push48=, 0x1.ep5
	f64.ne  	$push50=, $pop49, $pop48
	br_if   	0, $pop50       # 0: down to label5
# BB#5:                                 # %if.end
	f64.load	$push35=, 8($2)
	f64.const	$push51=, 0x1.4p4
	f64.ne  	$push52=, $pop35, $pop51
	br_if   	0, $pop52       # 0: down to label5
# BB#6:                                 # %if.end
	f64.load	$push36=, 0($1)
	f64.const	$push53=, -0x1.4p3
	f64.ne  	$push54=, $pop36, $pop53
	br_if   	0, $pop54       # 0: down to label5
# BB#7:                                 # %if.end
	f64.load	$push37=, 0($0)
	f64.const	$push55=, 0x1.d8p6
	f64.ne  	$push56=, $pop37, $pop55
	br_if   	0, $pop56       # 0: down to label5
# BB#8:                                 # %if.end30
	i32.const	$push60=, 84
	i32.add 	$push61=, $2, $pop60
	i32.const	$push62=, 1
	i32.store	0($pop61), $pop62
	i32.const	$push65=, 24
	i32.add 	$push153=, $2, $pop65
	tee_local	$push152=, $1=, $pop153
	i32.const	$push63=, 0
	i64.load	$push64=, .Lmain.e+24($pop63)
	i64.store	0($pop152), $pop64
	i32.const	$push67=, 16
	i32.add 	$push151=, $2, $pop67
	tee_local	$push150=, $0=, $pop151
	i32.const	$push149=, 0
	i64.load	$push66=, .Lmain.e+16($pop149)
	i64.store	0($pop150), $pop66
	i32.const	$push148=, 0
	i64.load	$push68=, .Lmain.e($pop148)
	i64.store	0($2), $pop68
	i32.const	$push147=, 0
	i64.load	$push69=, .Lmain.e+8($pop147)
	i64.store	8($2), $pop69
	i32.const	$push118=, 88
	i32.add 	$push119=, $2, $pop118
	i32.const	$push120=, 64
	i32.add 	$push121=, $2, $pop120
	call    	foo@FUNCTION, $pop119, $pop121
	f64.load	$push71=, 0($2)
	f64.const	$push70=, -0x1.4p4
	f64.ne  	$push72=, $pop71, $pop70
	br_if   	0, $pop72       # 0: down to label5
# BB#9:                                 # %if.end30
	f64.load	$push57=, 8($2)
	f64.const	$push73=, -0x1.4p3
	f64.ne  	$push74=, $pop57, $pop73
	br_if   	0, $pop74       # 0: down to label5
# BB#10:                                # %if.end30
	f64.load	$push58=, 0($0)
	f64.const	$push154=, 0x1.d8p6
	f64.ne  	$push75=, $pop58, $pop154
	br_if   	0, $pop75       # 0: down to label5
# BB#11:                                # %if.end30
	f64.load	$push59=, 0($1)
	f64.const	$push155=, 0x1.d8p6
	f64.ne  	$push76=, $pop59, $pop155
	br_if   	0, $pop76       # 0: down to label5
# BB#12:                                # %if.end46
	i32.const	$push80=, 84
	i32.add 	$push81=, $2, $pop80
	i32.const	$push82=, 0
	i32.store	0($pop81), $pop82
	i32.const	$push84=, 24
	i32.add 	$push163=, $2, $pop84
	tee_local	$push162=, $1=, $pop163
	i32.const	$push161=, 0
	i64.load	$push83=, .Lmain.e+24($pop161)
	i64.store	0($pop162), $pop83
	i32.const	$push86=, 16
	i32.add 	$push160=, $2, $pop86
	tee_local	$push159=, $0=, $pop160
	i32.const	$push158=, 0
	i64.load	$push85=, .Lmain.e+16($pop158)
	i64.store	0($pop159), $pop85
	i32.const	$push157=, 0
	i64.load	$push87=, .Lmain.e($pop157)
	i64.store	0($2), $pop87
	i32.const	$push156=, 0
	i64.load	$push88=, .Lmain.e+8($pop156)
	i64.store	8($2), $pop88
	i32.const	$push122=, 88
	i32.add 	$push123=, $2, $pop122
	i32.const	$push124=, 64
	i32.add 	$push125=, $2, $pop124
	call    	foo@FUNCTION, $pop123, $pop125
	f64.load	$push90=, 0($2)
	f64.const	$push89=, 0x0p0
	f64.ne  	$push91=, $pop90, $pop89
	br_if   	0, $pop91       # 0: down to label5
# BB#13:                                # %if.end46
	f64.load	$push77=, 8($2)
	f64.const	$push164=, 0x1.d8p6
	f64.ne  	$push92=, $pop77, $pop164
	br_if   	0, $pop92       # 0: down to label5
# BB#14:                                # %if.end46
	f64.load	$push78=, 0($0)
	f64.const	$push165=, 0x1.d8p6
	f64.ne  	$push93=, $pop78, $pop165
	br_if   	0, $pop93       # 0: down to label5
# BB#15:                                # %if.end46
	f64.load	$push79=, 0($1)
	f64.const	$push94=, 0x1.d8p6
	f64.ne  	$push95=, $pop79, $pop94
	br_if   	0, $pop95       # 0: down to label5
# BB#16:                                # %if.end62
	i32.const	$push103=, 0
	i32.const	$push101=, 112
	i32.add 	$push102=, $2, $pop101
	i32.store	__stack_pointer($pop103), $pop102
	i32.const	$push96=, 0
	return  	$pop96
.LBB1_17:                               # %if.then
	end_block                       # label5:
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


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
