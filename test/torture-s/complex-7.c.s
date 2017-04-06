	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/complex-7.c"
	.section	.text.check_float,"ax",@progbits
	.hidden	check_float
	.globl	check_float
	.type	check_float,@function
check_float:                            # @check_float
	.param  	i32, i32, i32, i32, i32, i32
	.local  	f32, f32, f32, f32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	f32.load	$8=, f1($pop0)
	f32.load	$9=, 0($1)
	f32.load	$6=, 4($1)
	i32.const	$push15=, 0
	f32.load	$7=, f1+4($pop15)
	block   	
	f32.ne  	$push1=, $9, $8
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %entry
	f32.ne  	$push2=, $6, $7
	br_if   	0, $pop2        # 0: down to label0
# BB#2:                                 # %lor.lhs.false
	i32.const	$push3=, 0
	f32.load	$8=, f2($pop3)
	f32.load	$9=, 0($2)
	f32.load	$6=, 4($2)
	i32.const	$push16=, 0
	f32.load	$7=, f2+4($pop16)
	f32.ne  	$push4=, $9, $8
	br_if   	0, $pop4        # 0: down to label0
# BB#3:                                 # %lor.lhs.false
	f32.ne  	$push5=, $6, $7
	br_if   	0, $pop5        # 0: down to label0
# BB#4:                                 # %lor.lhs.false4
	i32.const	$push6=, 0
	f32.load	$8=, f3($pop6)
	f32.load	$9=, 0($3)
	f32.load	$6=, 4($3)
	i32.const	$push17=, 0
	f32.load	$7=, f3+4($pop17)
	f32.ne  	$push7=, $9, $8
	br_if   	0, $pop7        # 0: down to label0
# BB#5:                                 # %lor.lhs.false4
	f32.ne  	$push8=, $6, $7
	br_if   	0, $pop8        # 0: down to label0
# BB#6:                                 # %lor.lhs.false8
	i32.const	$push9=, 0
	f32.load	$8=, f4($pop9)
	f32.load	$9=, 0($4)
	f32.load	$6=, 4($4)
	i32.const	$push18=, 0
	f32.load	$7=, f4+4($pop18)
	f32.ne  	$push10=, $9, $8
	br_if   	0, $pop10       # 0: down to label0
# BB#7:                                 # %lor.lhs.false8
	f32.ne  	$push11=, $6, $7
	br_if   	0, $pop11       # 0: down to label0
# BB#8:                                 # %lor.lhs.false12
	i32.const	$push12=, 0
	f32.load	$8=, f5($pop12)
	f32.load	$9=, 0($5)
	f32.load	$6=, 4($5)
	i32.const	$push19=, 0
	f32.load	$7=, f5+4($pop19)
	f32.ne  	$push13=, $9, $8
	br_if   	0, $pop13       # 0: down to label0
# BB#9:                                 # %lor.lhs.false12
	f32.ne  	$push14=, $6, $7
	br_if   	0, $pop14       # 0: down to label0
# BB#10:                                # %if.end
	return
.LBB0_11:                               # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	check_float, .Lfunc_end0-check_float

	.section	.text.check_double,"ax",@progbits
	.hidden	check_double
	.globl	check_double
	.type	check_double,@function
check_double:                           # @check_double
	.param  	i32, i32, i32, i32, i32, i32
	.local  	f64, f64, f64, f64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	f64.load	$8=, d1($pop0)
	f64.load	$9=, 0($1)
	f64.load	$6=, 8($1)
	i32.const	$push15=, 0
	f64.load	$7=, d1+8($pop15)
	block   	
	f64.ne  	$push1=, $9, $8
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %entry
	f64.ne  	$push2=, $6, $7
	br_if   	0, $pop2        # 0: down to label1
# BB#2:                                 # %lor.lhs.false
	i32.const	$push3=, 0
	f64.load	$8=, d2($pop3)
	f64.load	$9=, 0($2)
	f64.load	$6=, 8($2)
	i32.const	$push16=, 0
	f64.load	$7=, d2+8($pop16)
	f64.ne  	$push4=, $9, $8
	br_if   	0, $pop4        # 0: down to label1
# BB#3:                                 # %lor.lhs.false
	f64.ne  	$push5=, $6, $7
	br_if   	0, $pop5        # 0: down to label1
# BB#4:                                 # %lor.lhs.false4
	i32.const	$push6=, 0
	f64.load	$8=, d3($pop6)
	f64.load	$9=, 0($3)
	f64.load	$6=, 8($3)
	i32.const	$push17=, 0
	f64.load	$7=, d3+8($pop17)
	f64.ne  	$push7=, $9, $8
	br_if   	0, $pop7        # 0: down to label1
# BB#5:                                 # %lor.lhs.false4
	f64.ne  	$push8=, $6, $7
	br_if   	0, $pop8        # 0: down to label1
# BB#6:                                 # %lor.lhs.false8
	i32.const	$push9=, 0
	f64.load	$8=, d4($pop9)
	f64.load	$9=, 0($4)
	f64.load	$6=, 8($4)
	i32.const	$push18=, 0
	f64.load	$7=, d4+8($pop18)
	f64.ne  	$push10=, $9, $8
	br_if   	0, $pop10       # 0: down to label1
# BB#7:                                 # %lor.lhs.false8
	f64.ne  	$push11=, $6, $7
	br_if   	0, $pop11       # 0: down to label1
# BB#8:                                 # %lor.lhs.false12
	i32.const	$push12=, 0
	f64.load	$8=, d5($pop12)
	f64.load	$9=, 0($5)
	f64.load	$6=, 8($5)
	i32.const	$push19=, 0
	f64.load	$7=, d5+8($pop19)
	f64.ne  	$push13=, $9, $8
	br_if   	0, $pop13       # 0: down to label1
# BB#9:                                 # %lor.lhs.false12
	f64.ne  	$push14=, $6, $7
	br_if   	0, $pop14       # 0: down to label1
# BB#10:                                # %if.end
	return
.LBB1_11:                               # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	check_double, .Lfunc_end1-check_double

	.section	.text.check_long_double,"ax",@progbits
	.hidden	check_long_double
	.globl	check_long_double
	.type	check_long_double,@function
check_long_double:                      # @check_long_double
	.param  	i32, i32, i32, i32, i32, i32
	.local  	i64, i64, i64, i64, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 8
	i32.add 	$push1=, $1, $pop0
	i64.load	$7=, 0($pop1)
	i32.const	$push2=, 0
	i64.load	$8=, ld1+8($pop2)
	i32.const	$push37=, 0
	i64.load	$9=, ld1($pop37)
	i64.load	$push3=, 0($1)
	i32.call	$10=, __netf2@FUNCTION, $pop3, $7, $9, $8
	i32.const	$push4=, 24
	i32.add 	$push5=, $1, $pop4
	i64.load	$7=, 0($pop5)
	i64.load	$8=, 16($1)
	i32.const	$push36=, 0
	i64.load	$9=, ld1+24($pop36)
	i32.const	$push35=, 0
	i64.load	$6=, ld1+16($pop35)
	block   	
	br_if   	0, $10          # 0: down to label2
# BB#1:                                 # %entry
	i32.call	$push6=, __netf2@FUNCTION, $8, $7, $6, $9
	br_if   	0, $pop6        # 0: down to label2
# BB#2:                                 # %lor.lhs.false
	i32.const	$push7=, 8
	i32.add 	$push8=, $2, $pop7
	i64.load	$7=, 0($pop8)
	i32.const	$push9=, 0
	i64.load	$8=, ld2+8($pop9)
	i32.const	$push40=, 0
	i64.load	$9=, ld2($pop40)
	i64.load	$push10=, 0($2)
	i32.call	$1=, __netf2@FUNCTION, $pop10, $7, $9, $8
	i32.const	$push11=, 24
	i32.add 	$push12=, $2, $pop11
	i64.load	$7=, 0($pop12)
	i64.load	$8=, 16($2)
	i32.const	$push39=, 0
	i64.load	$9=, ld2+24($pop39)
	i32.const	$push38=, 0
	i64.load	$6=, ld2+16($pop38)
	br_if   	0, $1           # 0: down to label2
# BB#3:                                 # %lor.lhs.false
	i32.call	$push13=, __netf2@FUNCTION, $8, $7, $6, $9
	br_if   	0, $pop13       # 0: down to label2
# BB#4:                                 # %lor.lhs.false4
	i32.const	$push14=, 8
	i32.add 	$push15=, $3, $pop14
	i64.load	$7=, 0($pop15)
	i32.const	$push16=, 0
	i64.load	$8=, ld3+8($pop16)
	i32.const	$push43=, 0
	i64.load	$9=, ld3($pop43)
	i64.load	$push17=, 0($3)
	i32.call	$1=, __netf2@FUNCTION, $pop17, $7, $9, $8
	i32.const	$push18=, 24
	i32.add 	$push19=, $3, $pop18
	i64.load	$7=, 0($pop19)
	i64.load	$8=, 16($3)
	i32.const	$push42=, 0
	i64.load	$9=, ld3+24($pop42)
	i32.const	$push41=, 0
	i64.load	$6=, ld3+16($pop41)
	br_if   	0, $1           # 0: down to label2
# BB#5:                                 # %lor.lhs.false4
	i32.call	$push20=, __netf2@FUNCTION, $8, $7, $6, $9
	br_if   	0, $pop20       # 0: down to label2
# BB#6:                                 # %lor.lhs.false8
	i32.const	$push21=, 8
	i32.add 	$push22=, $4, $pop21
	i64.load	$7=, 0($pop22)
	i32.const	$push23=, 0
	i64.load	$8=, ld4+8($pop23)
	i32.const	$push46=, 0
	i64.load	$9=, ld4($pop46)
	i64.load	$push24=, 0($4)
	i32.call	$1=, __netf2@FUNCTION, $pop24, $7, $9, $8
	i32.const	$push25=, 24
	i32.add 	$push26=, $4, $pop25
	i64.load	$7=, 0($pop26)
	i64.load	$8=, 16($4)
	i32.const	$push45=, 0
	i64.load	$9=, ld4+24($pop45)
	i32.const	$push44=, 0
	i64.load	$6=, ld4+16($pop44)
	br_if   	0, $1           # 0: down to label2
# BB#7:                                 # %lor.lhs.false8
	i32.call	$push27=, __netf2@FUNCTION, $8, $7, $6, $9
	br_if   	0, $pop27       # 0: down to label2
# BB#8:                                 # %lor.lhs.false12
	i32.const	$push28=, 8
	i32.add 	$push29=, $5, $pop28
	i64.load	$7=, 0($pop29)
	i32.const	$push30=, 0
	i64.load	$8=, ld5+8($pop30)
	i32.const	$push49=, 0
	i64.load	$9=, ld5($pop49)
	i64.load	$push31=, 0($5)
	i32.call	$1=, __netf2@FUNCTION, $pop31, $7, $9, $8
	i32.const	$push32=, 24
	i32.add 	$push33=, $5, $pop32
	i64.load	$7=, 0($pop33)
	i64.load	$8=, 16($5)
	i32.const	$push48=, 0
	i64.load	$9=, ld5+24($pop48)
	i32.const	$push47=, 0
	i64.load	$6=, ld5+16($pop47)
	br_if   	0, $1           # 0: down to label2
# BB#9:                                 # %lor.lhs.false12
	i32.call	$push34=, __eqtf2@FUNCTION, $8, $7, $6, $9
	br_if   	0, $pop34       # 0: down to label2
# BB#10:                                # %if.end
	return
.LBB2_11:                               # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	check_long_double, .Lfunc_end2-check_long_double

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f32, f32, f32, f64, f64, f64, f64, f64, i64, i64, i32, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push93=, 0
	i32.const	$push91=, 0
	i32.load	$push90=, __stack_pointer($pop91)
	i32.const	$push92=, 576
	i32.sub 	$push247=, $pop90, $pop92
	tee_local	$push246=, $29=, $pop247
	i32.store	__stack_pointer($pop93), $pop246
	i32.const	$push0=, 0
	f32.load	$push1=, f1($pop0)
	f32.store	568($29), $pop1
	i32.const	$push245=, 0
	f32.load	$0=, f1+4($pop245)
	i32.const	$push244=, 0
	f32.load	$push2=, f2($pop244)
	f32.store	560($29), $pop2
	i32.const	$push243=, 0
	f32.load	$1=, f2+4($pop243)
	i32.const	$push242=, 0
	f32.load	$push3=, f3($pop242)
	f32.store	552($29), $pop3
	i32.const	$push241=, 0
	f32.load	$2=, f3+4($pop241)
	i32.const	$push240=, 0
	f32.load	$push4=, f4($pop240)
	f32.store	544($29), $pop4
	f32.store	572($29), $0
	f32.store	564($29), $1
	f32.store	556($29), $2
	i32.const	$push239=, 0
	f32.load	$push5=, f4+4($pop239)
	f32.store	548($29), $pop5
	i32.const	$push238=, 0
	f32.load	$push6=, f5($pop238)
	f32.store	536($29), $pop6
	i32.const	$push237=, 0
	f32.load	$push7=, f5+4($pop237)
	f32.store	540($29), $pop7
	i64.load	$push8=, 568($29)
	i64.store	280($29):p2align=2, $pop8
	i64.load	$push9=, 560($29)
	i64.store	272($29):p2align=2, $pop9
	i64.load	$push10=, 552($29)
	i64.store	264($29):p2align=2, $pop10
	i64.load	$push11=, 544($29)
	i64.store	256($29):p2align=2, $pop11
	i32.const	$push12=, 252
	i32.add 	$push13=, $29, $pop12
	i32.load	$push14=, 540($29)
	i32.store	0($pop13), $pop14
	i32.load	$push15=, 536($29)
	i32.store	248($29), $pop15
	i32.const	$push94=, 280
	i32.add 	$push95=, $29, $pop94
	i32.const	$push96=, 272
	i32.add 	$push97=, $29, $pop96
	i32.const	$push98=, 264
	i32.add 	$push99=, $29, $pop98
	i32.const	$push100=, 256
	i32.add 	$push101=, $29, $pop100
	i32.const	$push102=, 248
	i32.add 	$push103=, $29, $pop102
	call    	check_float@FUNCTION, $29, $pop95, $pop97, $pop99, $pop101, $pop103
	i32.const	$push236=, 0
	f64.load	$3=, d1($pop236)
	i32.const	$push235=, 0
	f64.load	$push16=, d1+8($pop235)
	f64.store	528($29), $pop16
	i32.const	$push234=, 0
	f64.load	$4=, d2($pop234)
	i32.const	$push233=, 0
	f64.load	$push17=, d2+8($pop233)
	f64.store	512($29), $pop17
	i32.const	$push232=, 0
	f64.load	$5=, d3($pop232)
	i32.const	$push231=, 0
	f64.load	$push18=, d3+8($pop231)
	f64.store	496($29), $pop18
	i32.const	$push230=, 0
	f64.load	$6=, d4($pop230)
	i32.const	$push229=, 0
	f64.load	$push19=, d4+8($pop229)
	f64.store	480($29), $pop19
	i32.const	$push228=, 0
	f64.load	$7=, d5($pop228)
	i32.const	$push227=, 0
	f64.load	$push20=, d5+8($pop227)
	f64.store	464($29), $pop20
	i32.const	$push104=, 232
	i32.add 	$push105=, $29, $pop104
	i32.const	$push21=, 8
	i32.add 	$push22=, $pop105, $pop21
	i64.load	$push23=, 528($29)
	i64.store	0($pop22), $pop23
	f64.store	520($29), $3
	f64.store	504($29), $4
	f64.store	488($29), $5
	f64.store	472($29), $6
	f64.store	456($29), $7
	i32.const	$push106=, 216
	i32.add 	$push107=, $29, $pop106
	i32.const	$push24=, 12
	i32.add 	$push25=, $pop107, $pop24
	i32.const	$push108=, 504
	i32.add 	$push109=, $29, $pop108
	i32.const	$push226=, 12
	i32.add 	$push26=, $pop109, $pop226
	i32.load	$push27=, 0($pop26)
	i32.store	0($pop25), $pop27
	i32.const	$push110=, 216
	i32.add 	$push111=, $29, $pop110
	i32.const	$push225=, 8
	i32.add 	$push28=, $pop111, $pop225
	i32.load	$push29=, 512($29)
	i32.store	0($pop28), $pop29
	i64.load	$push30=, 520($29)
	i64.store	232($29), $pop30
	i32.const	$push112=, 200
	i32.add 	$push113=, $29, $pop112
	i32.const	$push224=, 12
	i32.add 	$push31=, $pop113, $pop224
	i32.const	$push114=, 488
	i32.add 	$push115=, $29, $pop114
	i32.const	$push223=, 12
	i32.add 	$push32=, $pop115, $pop223
	i32.load	$push33=, 0($pop32)
	i32.store	0($pop31), $pop33
	i32.const	$push116=, 200
	i32.add 	$push117=, $29, $pop116
	i32.const	$push222=, 8
	i32.add 	$push34=, $pop117, $pop222
	i32.load	$push35=, 496($29)
	i32.store	0($pop34), $pop35
	i32.load	$push36=, 508($29)
	i32.store	220($29), $pop36
	i32.load	$push37=, 504($29)
	i32.store	216($29), $pop37
	i32.load	$push38=, 492($29)
	i32.store	204($29), $pop38
	i32.load	$push39=, 488($29)
	i32.store	200($29), $pop39
	i32.const	$push118=, 184
	i32.add 	$push119=, $29, $pop118
	i32.const	$push221=, 8
	i32.add 	$push40=, $pop119, $pop221
	i64.load	$push41=, 480($29)
	i64.store	0($pop40), $pop41
	i64.load	$push42=, 472($29)
	i64.store	184($29), $pop42
	i32.const	$push120=, 168
	i32.add 	$push121=, $29, $pop120
	i32.const	$push220=, 8
	i32.add 	$push43=, $pop121, $pop220
	i64.load	$push44=, 464($29)
	i64.store	0($pop43), $pop44
	i64.load	$push45=, 456($29)
	i64.store	168($29), $pop45
	i32.const	$push122=, 232
	i32.add 	$push123=, $29, $pop122
	i32.const	$push124=, 216
	i32.add 	$push125=, $29, $pop124
	i32.const	$push126=, 200
	i32.add 	$push127=, $29, $pop126
	i32.const	$push128=, 184
	i32.add 	$push129=, $29, $pop128
	i32.const	$push130=, 168
	i32.add 	$push131=, $29, $pop130
	call    	check_double@FUNCTION, $29, $pop123, $pop125, $pop127, $pop129, $pop131
	i32.const	$push219=, 0
	i64.load	$8=, ld1($pop219)
	i32.const	$push218=, 0
	i64.load	$9=, ld1+8($pop218)
	i32.const	$push132=, 416
	i32.add 	$push133=, $29, $pop132
	i32.const	$push46=, 24
	i32.add 	$push217=, $pop133, $pop46
	tee_local	$push216=, $10=, $pop217
	i32.const	$push215=, 0
	i64.load	$push47=, ld1+24($pop215)
	i64.store	0($pop216), $pop47
	i64.store	424($29), $9
	i64.store	416($29), $8
	i32.const	$push214=, 0
	i64.load	$push48=, ld1+16($pop214)
	i64.store	432($29), $pop48
	i32.const	$push213=, 0
	i64.load	$8=, ld2($pop213)
	i32.const	$push212=, 0
	i64.load	$9=, ld2+8($pop212)
	i32.const	$push211=, 0
	i64.load	$11=, ld2+16($pop211)
	i32.const	$push210=, 0
	i64.load	$12=, ld2+24($pop210)
	i32.const	$push209=, 0
	i64.load	$13=, ld3($pop209)
	i32.const	$push208=, 0
	i64.load	$14=, ld3+8($pop208)
	i32.const	$push207=, 0
	i64.load	$15=, ld3+16($pop207)
	i32.const	$push206=, 0
	i64.load	$16=, ld3+24($pop206)
	i32.const	$push205=, 0
	i64.load	$17=, ld4($pop205)
	i32.const	$push204=, 0
	i64.load	$18=, ld4+8($pop204)
	i32.const	$push203=, 0
	i64.load	$19=, ld4+16($pop203)
	i32.const	$push202=, 0
	i64.load	$20=, ld4+24($pop202)
	i32.const	$push201=, 0
	i64.load	$21=, ld5($pop201)
	i32.const	$push200=, 0
	i64.load	$22=, ld5+8($pop200)
	i32.const	$push199=, 0
	i64.load	$23=, ld5+16($pop199)
	i32.const	$push198=, 0
	i64.load	$24=, ld5+24($pop198)
	i32.const	$push134=, 384
	i32.add 	$push135=, $29, $pop134
	i32.const	$push197=, 24
	i32.add 	$push196=, $pop135, $pop197
	tee_local	$push195=, $25=, $pop196
	i64.store	0($pop195), $12
	i64.store	392($29), $9
	i64.store	384($29), $8
	i64.store	400($29), $11
	i32.const	$push136=, 352
	i32.add 	$push137=, $29, $pop136
	i32.const	$push194=, 24
	i32.add 	$push193=, $pop137, $pop194
	tee_local	$push192=, $26=, $pop193
	i64.store	0($pop192), $16
	i64.store	360($29), $14
	i64.store	352($29), $13
	i64.store	368($29), $15
	i32.const	$push138=, 320
	i32.add 	$push139=, $29, $pop138
	i32.const	$push191=, 24
	i32.add 	$push190=, $pop139, $pop191
	tee_local	$push189=, $27=, $pop190
	i64.store	0($pop189), $20
	i64.store	328($29), $18
	i64.store	320($29), $17
	i64.store	336($29), $19
	i32.const	$push140=, 288
	i32.add 	$push141=, $29, $pop140
	i32.const	$push188=, 24
	i32.add 	$push187=, $pop141, $pop188
	tee_local	$push186=, $28=, $pop187
	i64.store	0($pop186), $24
	i64.store	304($29), $23
	i64.store	296($29), $22
	i64.store	288($29), $21
	i32.const	$push142=, 128
	i32.add 	$push143=, $29, $pop142
	i32.const	$push185=, 24
	i32.add 	$push49=, $pop143, $pop185
	i64.load	$push50=, 0($10)
	i64.store	0($pop49), $pop50
	i32.const	$push144=, 128
	i32.add 	$push145=, $29, $pop144
	i32.const	$push51=, 16
	i32.add 	$push52=, $pop145, $pop51
	i64.load	$push53=, 432($29)
	i64.store	0($pop52), $pop53
	i32.const	$push146=, 96
	i32.add 	$push147=, $29, $pop146
	i32.const	$push54=, 28
	i32.add 	$push55=, $pop147, $pop54
	i32.const	$push148=, 384
	i32.add 	$push149=, $29, $pop148
	i32.const	$push184=, 28
	i32.add 	$push56=, $pop149, $pop184
	i32.load	$push57=, 0($pop56)
	i32.store	0($pop55), $pop57
	i32.const	$push150=, 96
	i32.add 	$push151=, $29, $pop150
	i32.const	$push183=, 24
	i32.add 	$push58=, $pop151, $pop183
	i32.load	$push59=, 0($25)
	i32.store	0($pop58), $pop59
	i32.const	$push152=, 96
	i32.add 	$push153=, $29, $pop152
	i32.const	$push60=, 20
	i32.add 	$push61=, $pop153, $pop60
	i32.const	$push154=, 384
	i32.add 	$push155=, $29, $pop154
	i32.const	$push182=, 20
	i32.add 	$push62=, $pop155, $pop182
	i32.load	$push63=, 0($pop62)
	i32.store	0($pop61), $pop63
	i32.const	$push156=, 96
	i32.add 	$push157=, $29, $pop156
	i32.const	$push181=, 16
	i32.add 	$push64=, $pop157, $pop181
	i32.load	$push65=, 400($29)
	i32.store	0($pop64), $pop65
	i64.load	$push66=, 424($29)
	i64.store	136($29), $pop66
	i64.load	$push67=, 416($29)
	i64.store	128($29), $pop67
	i32.load	$push68=, 396($29)
	i32.store	108($29), $pop68
	i32.load	$push69=, 392($29)
	i32.store	104($29), $pop69
	i32.load	$push70=, 388($29)
	i32.store	100($29), $pop70
	i32.load	$push71=, 384($29)
	i32.store	96($29), $pop71
	i32.const	$push158=, 64
	i32.add 	$push159=, $29, $pop158
	i32.const	$push180=, 24
	i32.add 	$push72=, $pop159, $pop180
	i64.load	$push73=, 0($26)
	i64.store	0($pop72), $pop73
	i32.const	$push160=, 64
	i32.add 	$push161=, $29, $pop160
	i32.const	$push179=, 16
	i32.add 	$push74=, $pop161, $pop179
	i64.load	$push75=, 368($29)
	i64.store	0($pop74), $pop75
	i64.load	$push76=, 360($29)
	i64.store	72($29), $pop76
	i64.load	$push77=, 352($29)
	i64.store	64($29), $pop77
	i32.const	$push162=, 32
	i32.add 	$push163=, $29, $pop162
	i32.const	$push178=, 24
	i32.add 	$push78=, $pop163, $pop178
	i64.load	$push79=, 0($27)
	i64.store	0($pop78), $pop79
	i32.const	$push164=, 32
	i32.add 	$push165=, $29, $pop164
	i32.const	$push177=, 16
	i32.add 	$push80=, $pop165, $pop177
	i64.load	$push81=, 336($29)
	i64.store	0($pop80), $pop81
	i64.load	$push82=, 328($29)
	i64.store	40($29), $pop82
	i64.load	$push83=, 320($29)
	i64.store	32($29), $pop83
	i32.const	$push176=, 24
	i32.add 	$push84=, $29, $pop176
	i64.load	$push85=, 0($28)
	i64.store	0($pop84), $pop85
	i32.const	$push175=, 16
	i32.add 	$push86=, $29, $pop175
	i64.load	$push87=, 304($29)
	i64.store	0($pop86), $pop87
	i64.load	$push88=, 296($29)
	i64.store	8($29), $pop88
	i64.load	$push89=, 288($29)
	i64.store	0($29), $pop89
	i32.const	$push166=, 128
	i32.add 	$push167=, $29, $pop166
	i32.const	$push168=, 96
	i32.add 	$push169=, $29, $pop168
	i32.const	$push170=, 64
	i32.add 	$push171=, $29, $pop170
	i32.const	$push172=, 32
	i32.add 	$push173=, $29, $pop172
	call    	check_long_double@FUNCTION, $29, $pop167, $pop169, $pop171, $pop173, $29
	i32.const	$push174=, 0
	call    	exit@FUNCTION, $pop174
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.hidden	f1                      # @f1
	.type	f1,@object
	.section	.data.f1,"aw",@progbits
	.globl	f1
	.p2align	2
f1:
	.int32	1066192077              # float 1.10000002
	.int32	1074580685              # float 2.20000005
	.size	f1, 8

	.hidden	f2                      # @f2
	.type	f2,@object
	.section	.data.f2,"aw",@progbits
	.globl	f2
	.p2align	2
f2:
	.int32	1079194419              # float 3.29999995
	.int32	1082969293              # float 4.4000001
	.size	f2, 8

	.hidden	f3                      # @f3
	.type	f3,@object
	.section	.data.f3,"aw",@progbits
	.globl	f3
	.p2align	2
f3:
	.int32	1085276160              # float 5.5
	.int32	1087583027              # float 6.5999999
	.size	f3, 8

	.hidden	f4                      # @f4
	.type	f4,@object
	.section	.data.f4,"aw",@progbits
	.globl	f4
	.p2align	2
f4:
	.int32	1089889894              # float 7.6999998
	.int32	1091357901              # float 8.80000019
	.size	f4, 8

	.hidden	f5                      # @f5
	.type	f5,@object
	.section	.data.f5,"aw",@progbits
	.globl	f5
	.p2align	2
f5:
	.int32	1092511334              # float 9.89999961
	.int32	1092721050              # float 10.1000004
	.size	f5, 8

	.hidden	d1                      # @d1
	.type	d1,@object
	.section	.data.d1,"aw",@progbits
	.globl	d1
	.p2align	3
d1:
	.int64	4607632778762754458     # double 1.1000000000000001
	.int64	4612136378390124954     # double 2.2000000000000002
	.size	d1, 16

	.hidden	d2                      # @d2
	.type	d2,@object
	.section	.data.d2,"aw",@progbits
	.globl	d2
	.p2align	3
d2:
	.int64	4614613358185178726     # double 3.2999999999999998
	.int64	4616639978017495450     # double 4.4000000000000004
	.size	d2, 16

	.hidden	d3                      # @d3
	.type	d3,@object
	.section	.data.d3,"aw",@progbits
	.globl	d3
	.p2align	3
d3:
	.int64	4617878467915022336     # double 5.5
	.int64	4619116957812549222     # double 6.5999999999999996
	.size	d3, 16

	.hidden	d4                      # @d4
	.type	d4,@object
	.section	.data.d4,"aw",@progbits
	.globl	d4
	.p2align	3
d4:
	.int64	4620355447710076109     # double 7.7000000000000001
	.int64	4621143577644865946     # double 8.8000000000000007
	.size	d4, 16

	.hidden	d5                      # @d5
	.type	d5,@object
	.section	.data.d5,"aw",@progbits
	.globl	d5
	.p2align	3
d5:
	.int64	4621762822593629389     # double 9.9000000000000003
	.int64	4621875412584313651     # double 10.1
	.size	d5, 16

	.hidden	ld1                     # @ld1
	.type	ld1,@object
	.section	.data.ld1,"aw",@progbits
	.globl	ld1
	.p2align	4
ld1:
	.int64	-7378697629483820646    # fp128 1.10000000000000000000000000000000008
	.int64	4611432690948348313
	.int64	-7378697629483820646    # fp128 2.20000000000000000000000000000000015
	.int64	4611714165925058969
	.size	ld1, 32

	.hidden	ld2                     # @ld2
	.type	ld2,@object
	.section	.data.ld2,"aw",@progbits
	.globl	ld2
	.p2align	4
ld2:
	.int64	7378697629483820646     # fp128 3.29999999999999999999999999999999985
	.int64	4611868977162249830
	.int64	-7378697629483820646    # fp128 4.40000000000000000000000000000000031
	.int64	4611995640901769625
	.size	ld2, 32

	.hidden	ld3                     # @ld3
	.type	ld3,@object
	.section	.data.ld3,"aw",@progbits
	.globl	ld3
	.p2align	4
ld3:
	.int64	0                       # fp128 5.5
	.int64	4612073046520365056
	.int64	7378697629483820646     # fp128 6.59999999999999999999999999999999969
	.int64	4612150452138960486
	.size	ld3, 32

	.hidden	ld4                     # @ld4
	.type	ld4,@object
	.section	.data.ld4,"aw",@progbits
	.globl	ld4
	.p2align	4
ld4:
	.int64	-3689348814741910323    # fp128 7.70000000000000000000000000000000015
	.int64	4612227857757555916
	.int64	-7378697629483820646    # fp128 8.80000000000000000000000000000000062
	.int64	4612277115878480281
	.size	ld4, 32

	.hidden	ld5                     # @ld5
	.type	ld5,@object
	.section	.data.ld5,"aw",@progbits
	.globl	ld5
	.p2align	4
ld5:
	.int64	-3689348814741910323    # fp128 9.9000000000000000000000000000000003
	.int64	4612315818687777996
	.int64	3689348814741910323     # fp128 10.0999999999999999999999999999999997
	.int64	4612322855562195763
	.size	ld5, 32


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
	.functype	exit, void, i32
