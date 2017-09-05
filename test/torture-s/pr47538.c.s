	.text
	.file	"pr47538.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32, f64, i32, i32, i32, f64, i32, f64, f64
# BB#0:                                 # %entry
	f64.load	$push42=, 0($1)
	tee_local	$push41=, $11=, $pop42
	f64.store	0($0), $pop41
	f64.load	$push40=, 8($1)
	tee_local	$push39=, $10=, $pop40
	f64.store	8($0), $pop39
	block   	
	block   	
	i32.load	$push38=, 20($1)
	tee_local	$push37=, $2=, $pop38
	i32.eqz 	$push72=, $pop37
	br_if   	0, $pop72       # 0: down to label1
# BB#1:                                 # %if.else
	f64.sub 	$push1=, $10, $11
	f64.const	$push2=, 0x1p-2
	f64.mul 	$4=, $pop1, $pop2
	i32.const	$push0=, 1
	i32.add 	$push44=, $2, $pop0
	tee_local	$push43=, $3=, $pop44
	i32.const	$push3=, 2
	i32.ne  	$push4=, $pop43, $pop3
	br_if   	1, $pop4        # 1: down to label0
# BB#2:                                 # %if.then6
	i32.load	$push48=, 16($0)
	tee_local	$push47=, $0=, $pop48
	i32.load	$push32=, 16($1)
	f64.load	$push33=, 0($pop32)
	f64.mul 	$push46=, $4, $pop33
	tee_local	$push45=, $11=, $pop46
	f64.store	8($pop47), $pop45
	f64.add 	$push34=, $11, $11
	f64.store	0($0), $pop34
	return
.LBB0_3:                                # %if.then
	end_block                       # label1:
	i32.load	$push35=, 16($0)
	i64.const	$push36=, 0
	i64.store	0($pop35), $pop36
	return
.LBB0_4:                                # %for.body.lr.ph
	end_block                       # label0:
	i32.load	$push57=, 16($0)
	tee_local	$push56=, $7=, $pop57
	i32.load	$push55=, 16($1)
	tee_local	$push54=, $6=, $pop55
	f64.load	$push6=, 0($pop54)
	f64.load	$push5=, 16($6)
	f64.sub 	$push7=, $pop6, $pop5
	f64.mul 	$push53=, $4, $pop7
	tee_local	$push52=, $11=, $pop53
	f64.store	8($pop56), $pop52
	f64.const	$push8=, 0x0p0
	f64.add 	$10=, $11, $pop8
	block   	
	block   	
	i32.const	$push9=, -1
	i32.add 	$push51=, $2, $pop9
	tee_local	$push50=, $5=, $pop51
	i32.const	$push49=, 1
	i32.ne  	$push10=, $pop50, $pop49
	br_if   	0, $pop10       # 0: down to label3
# BB#5:
	f64.const	$11=, -0x1p0
	br      	1               # 1: down to label2
.LBB0_6:                                # %for.body.preheader
	end_block                       # label3:
	i32.const	$push11=, 16
	i32.add 	$0=, $7, $pop11
	i32.const	$push12=, 24
	i32.add 	$1=, $6, $pop12
	f64.const	$11=, -0x1p0
	i32.const	$9=, 2
.LBB0_7:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label4:
	i32.const	$push65=, -16
	i32.add 	$push13=, $1, $pop65
	f64.load	$push14=, 0($pop13)
	f64.load	$push15=, 0($1)
	f64.sub 	$push16=, $pop14, $pop15
	f64.mul 	$push17=, $4, $pop16
	f64.convert_u/i32	$push18=, $9
	f64.div 	$push64=, $pop17, $pop18
	tee_local	$push63=, $8=, $pop64
	f64.store	0($0), $pop63
	i32.const	$push62=, 8
	i32.add 	$0=, $0, $pop62
	i32.const	$push61=, 8
	i32.add 	$1=, $1, $pop61
	f64.mul 	$push19=, $11, $8
	f64.add 	$10=, $10, $pop19
	f64.neg 	$11=, $11
	i32.const	$push60=, 1
	i32.add 	$push59=, $9, $pop60
	tee_local	$push58=, $9=, $pop59
	i32.le_u	$push20=, $pop58, $5
	br_if   	0, $pop20       # 0: up to label4
.LBB0_8:                                # %for.end
	end_loop
	end_block                       # label2:
	i32.const	$push23=, 3
	i32.shl 	$push28=, $2, $pop23
	i32.add 	$push29=, $7, $pop28
	i32.const	$push71=, 3
	i32.shl 	$push24=, $5, $pop71
	i32.add 	$push25=, $6, $pop24
	f64.load	$push26=, 0($pop25)
	f64.mul 	$push27=, $4, $pop26
	f64.convert_u/i32	$push21=, $3
	f64.const	$push70=, -0x1p0
	f64.add 	$push22=, $pop21, $pop70
	f64.div 	$push69=, $pop27, $pop22
	tee_local	$push68=, $8=, $pop69
	f64.store	0($pop29), $pop68
	f64.mul 	$push30=, $11, $8
	f64.add 	$push67=, $10, $pop30
	tee_local	$push66=, $11=, $pop67
	f64.add 	$push31=, $pop66, $11
	f64.store	0($7), $pop31
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push95=, 0
	i32.const	$push93=, 0
	i32.load	$push92=, __stack_pointer($pop93)
	i32.const	$push94=, 112
	i32.sub 	$push131=, $pop92, $pop94
	tee_local	$push130=, $2=, $pop131
	i32.store	__stack_pointer($pop95), $pop130
	i32.const	$push99=, 32
	i32.add 	$push100=, $2, $pop99
	i32.const	$push0=, 24
	i32.add 	$push1=, $pop100, $pop0
	i32.const	$push2=, 0
	i64.load	$push3=, .Lmain.c+24($pop2)
	i64.store	0($pop1), $pop3
	i32.const	$push101=, 32
	i32.add 	$push102=, $2, $pop101
	i32.const	$push4=, 16
	i32.add 	$push5=, $pop102, $pop4
	i32.const	$push129=, 0
	i64.load	$push6=, .Lmain.c+16($pop129)
	i64.store	0($pop5), $pop6
	i32.const	$push128=, 0
	i64.load	$push7=, .Lmain.c+8($pop128)
	i64.store	40($2), $pop7
	i32.const	$push127=, 0
	i64.load	$push8=, .Lmain.c($pop127)
	i64.store	32($2), $pop8
	i32.const	$push126=, 16
	i32.add 	$push9=, $2, $pop126
	i32.const	$push125=, 0
	i64.load	$push10=, .Lmain.e+16($pop125)
	i64.store	0($pop9), $pop10
	i32.const	$push124=, 24
	i32.add 	$push11=, $2, $pop124
	i32.const	$push123=, 0
	i64.load	$push12=, .Lmain.e+24($pop123)
	i64.store	0($pop11), $pop12
	i64.const	$push13=, 4618441417868443648
	i64.store	72($2), $pop13
	i64.const	$push14=, 4621819117588971520
	i64.store	64($2), $pop14
	i32.const	$push15=, 3
	i32.store	84($2), $pop15
	i32.const	$push122=, 0
	i64.load	$push16=, .Lmain.e($pop122)
	i64.store	0($2), $pop16
	i32.const	$push121=, 0
	i64.load	$push17=, .Lmain.e+8($pop121)
	i64.store	8($2), $pop17
	i32.const	$push103=, 32
	i32.add 	$push104=, $2, $pop103
	i32.store	80($2), $pop104
	i32.store	104($2), $2
	i32.const	$push105=, 88
	i32.add 	$push106=, $2, $pop105
	i32.const	$push107=, 64
	i32.add 	$push108=, $2, $pop107
	call    	foo@FUNCTION, $pop106, $pop108
	block   	
	f64.load	$push19=, 0($2)
	f64.const	$push18=, 0x0p0
	f64.ne  	$push20=, $pop19, $pop18
	br_if   	0, $pop20       # 0: down to label5
# BB#1:                                 # %lor.lhs.false
	f64.load	$push22=, 8($2)
	f64.const	$push21=, 0x1.4p4
	f64.ne  	$push23=, $pop22, $pop21
	br_if   	0, $pop23       # 0: down to label5
# BB#2:                                 # %lor.lhs.false9
	f64.load	$push25=, 16($2)
	f64.const	$push24=, 0x1.4p3
	f64.ne  	$push26=, $pop25, $pop24
	br_if   	0, $pop26       # 0: down to label5
# BB#3:                                 # %lor.lhs.false12
	f64.load	$push28=, 24($2)
	f64.const	$push27=, -0x1.4p3
	f64.ne  	$push29=, $pop28, $pop27
	br_if   	0, $pop29       # 0: down to label5
# BB#4:                                 # %if.end
	i32.const	$push33=, 84
	i32.add 	$push34=, $2, $pop33
	i32.const	$push35=, 2
	i32.store	0($pop34), $pop35
	i32.const	$push38=, 16
	i32.add 	$push138=, $2, $pop38
	tee_local	$push137=, $0=, $pop138
	i32.const	$push36=, 0
	i64.load	$push37=, .Lmain.e+16($pop36)
	i64.store	0($pop137), $pop37
	i32.const	$push40=, 24
	i32.add 	$push136=, $2, $pop40
	tee_local	$push135=, $1=, $pop136
	i32.const	$push134=, 0
	i64.load	$push39=, .Lmain.e+24($pop134)
	i64.store	0($pop135), $pop39
	i32.const	$push133=, 0
	i64.load	$push41=, .Lmain.e($pop133)
	i64.store	0($2), $pop41
	i32.const	$push132=, 0
	i64.load	$push42=, .Lmain.e+8($pop132)
	i64.store	8($2), $pop42
	i32.const	$push109=, 88
	i32.add 	$push110=, $2, $pop109
	i32.const	$push111=, 64
	i32.add 	$push112=, $2, $pop111
	call    	foo@FUNCTION, $pop110, $pop112
	f64.load	$push44=, 0($2)
	f64.const	$push43=, 0x1.ep5
	f64.ne  	$push45=, $pop44, $pop43
	br_if   	0, $pop45       # 0: down to label5
# BB#5:                                 # %if.end
	f64.load	$push30=, 8($2)
	f64.const	$push46=, 0x1.4p4
	f64.ne  	$push47=, $pop30, $pop46
	br_if   	0, $pop47       # 0: down to label5
# BB#6:                                 # %if.end
	f64.load	$push31=, 0($0)
	f64.const	$push48=, -0x1.4p3
	f64.ne  	$push49=, $pop31, $pop48
	br_if   	0, $pop49       # 0: down to label5
# BB#7:                                 # %if.end
	f64.load	$push32=, 0($1)
	f64.const	$push50=, 0x1.d8p6
	f64.ne  	$push51=, $pop32, $pop50
	br_if   	0, $pop51       # 0: down to label5
# BB#8:                                 # %if.end30
	i32.const	$push55=, 84
	i32.add 	$push56=, $2, $pop55
	i32.const	$push57=, 1
	i32.store	0($pop56), $pop57
	i32.const	$push60=, 16
	i32.add 	$push145=, $2, $pop60
	tee_local	$push144=, $0=, $pop145
	i32.const	$push58=, 0
	i64.load	$push59=, .Lmain.e+16($pop58)
	i64.store	0($pop144), $pop59
	i32.const	$push62=, 24
	i32.add 	$push143=, $2, $pop62
	tee_local	$push142=, $1=, $pop143
	i32.const	$push141=, 0
	i64.load	$push61=, .Lmain.e+24($pop141)
	i64.store	0($pop142), $pop61
	i32.const	$push140=, 0
	i64.load	$push63=, .Lmain.e($pop140)
	i64.store	0($2), $pop63
	i32.const	$push139=, 0
	i64.load	$push64=, .Lmain.e+8($pop139)
	i64.store	8($2), $pop64
	i32.const	$push113=, 88
	i32.add 	$push114=, $2, $pop113
	i32.const	$push115=, 64
	i32.add 	$push116=, $2, $pop115
	call    	foo@FUNCTION, $pop114, $pop116
	f64.load	$push66=, 0($2)
	f64.const	$push65=, -0x1.4p4
	f64.ne  	$push67=, $pop66, $pop65
	br_if   	0, $pop67       # 0: down to label5
# BB#9:                                 # %if.end30
	f64.load	$push52=, 8($2)
	f64.const	$push68=, -0x1.4p3
	f64.ne  	$push69=, $pop52, $pop68
	br_if   	0, $pop69       # 0: down to label5
# BB#10:                                # %if.end30
	f64.load	$push53=, 0($0)
	f64.const	$push146=, 0x1.d8p6
	f64.ne  	$push70=, $pop53, $pop146
	br_if   	0, $pop70       # 0: down to label5
# BB#11:                                # %if.end30
	f64.load	$push54=, 0($1)
	f64.const	$push147=, 0x1.d8p6
	f64.ne  	$push71=, $pop54, $pop147
	br_if   	0, $pop71       # 0: down to label5
# BB#12:                                # %if.end46
	i32.const	$push75=, 84
	i32.add 	$push76=, $2, $pop75
	i32.const	$push77=, 0
	i32.store	0($pop76), $pop77
	i32.const	$push79=, 16
	i32.add 	$push155=, $2, $pop79
	tee_local	$push154=, $0=, $pop155
	i32.const	$push153=, 0
	i64.load	$push78=, .Lmain.e+16($pop153)
	i64.store	0($pop154), $pop78
	i32.const	$push81=, 24
	i32.add 	$push152=, $2, $pop81
	tee_local	$push151=, $1=, $pop152
	i32.const	$push150=, 0
	i64.load	$push80=, .Lmain.e+24($pop150)
	i64.store	0($pop151), $pop80
	i32.const	$push149=, 0
	i64.load	$push82=, .Lmain.e($pop149)
	i64.store	0($2), $pop82
	i32.const	$push148=, 0
	i64.load	$push83=, .Lmain.e+8($pop148)
	i64.store	8($2), $pop83
	i32.const	$push117=, 88
	i32.add 	$push118=, $2, $pop117
	i32.const	$push119=, 64
	i32.add 	$push120=, $2, $pop119
	call    	foo@FUNCTION, $pop118, $pop120
	f64.load	$push85=, 0($2)
	f64.const	$push84=, 0x0p0
	f64.ne  	$push86=, $pop85, $pop84
	br_if   	0, $pop86       # 0: down to label5
# BB#13:                                # %if.end46
	f64.load	$push72=, 8($2)
	f64.const	$push156=, 0x1.d8p6
	f64.ne  	$push87=, $pop72, $pop156
	br_if   	0, $pop87       # 0: down to label5
# BB#14:                                # %if.end46
	f64.load	$push73=, 0($0)
	f64.const	$push157=, 0x1.d8p6
	f64.ne  	$push88=, $pop73, $pop157
	br_if   	0, $pop88       # 0: down to label5
# BB#15:                                # %if.end46
	f64.load	$push74=, 0($1)
	f64.const	$push89=, 0x1.d8p6
	f64.ne  	$push90=, $pop74, $pop89
	br_if   	0, $pop90       # 0: down to label5
# BB#16:                                # %if.end62
	i32.const	$push98=, 0
	i32.const	$push96=, 112
	i32.add 	$push97=, $2, $pop96
	i32.store	__stack_pointer($pop98), $pop97
	i32.const	$push91=, 0
	return  	$pop91
.LBB1_17:                               # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
