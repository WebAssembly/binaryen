	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/complex-7.c"
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
	.local  	f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push62=, 0
	i32.const	$push59=, 0
	i32.load	$push60=, __stack_pointer($pop59)
	i32.const	$push61=, 576
	i32.sub 	$push200=, $pop60, $pop61
	tee_local	$push199=, $45=, $pop200
	i32.store	__stack_pointer($pop62), $pop199
	i32.const	$push0=, 0
	f32.load	$0=, f1($pop0)
	i32.const	$push198=, 0
	f32.load	$1=, f1+4($pop198)
	i32.const	$push197=, 0
	f32.load	$2=, f2($pop197)
	i32.const	$push196=, 0
	f32.load	$3=, f2+4($pop196)
	i32.const	$push195=, 0
	f32.load	$4=, f3($pop195)
	i32.const	$push194=, 0
	f32.load	$5=, f3+4($pop194)
	i32.const	$push193=, 0
	f32.load	$6=, f4($pop193)
	i32.const	$push192=, 0
	f32.load	$7=, f4+4($pop192)
	i32.const	$push191=, 0
	f32.load	$8=, f5($pop191)
	i32.const	$push190=, 0
	f32.load	$9=, f5+4($pop190)
	f32.store	568($45), $0
	f32.store	572($45), $1
	f32.store	560($45), $2
	f32.store	564($45), $3
	f32.store	552($45), $4
	f32.store	556($45), $5
	f32.store	544($45), $6
	f32.store	548($45), $7
	f32.store	540($45), $9
	f32.store	536($45), $8
	i64.load	$push1=, 568($45)
	i64.store	280($45):p2align=2, $pop1
	i32.const	$push63=, 272
	i32.add 	$push64=, $45, $pop63
	i32.const	$push2=, 4
	i32.add 	$push3=, $pop64, $pop2
	i32.load	$push4=, 564($45)
	i32.store	0($pop3), $pop4
	i32.load	$push5=, 560($45)
	i32.store	272($45), $pop5
	i32.const	$push65=, 264
	i32.add 	$push66=, $45, $pop65
	i32.const	$push189=, 4
	i32.add 	$push6=, $pop66, $pop189
	i32.load	$push7=, 556($45)
	i32.store	0($pop6), $pop7
	i32.load	$push8=, 552($45)
	i32.store	264($45), $pop8
	i64.load	$push9=, 544($45)
	i64.store	256($45):p2align=2, $pop9
	i64.load	$push10=, 536($45)
	i64.store	248($45):p2align=2, $pop10
	i32.const	$push67=, 280
	i32.add 	$push68=, $45, $pop67
	i32.const	$push69=, 272
	i32.add 	$push70=, $45, $pop69
	i32.const	$push71=, 264
	i32.add 	$push72=, $45, $pop71
	i32.const	$push73=, 256
	i32.add 	$push74=, $45, $pop73
	i32.const	$push75=, 248
	i32.add 	$push76=, $45, $pop75
	call    	check_float@FUNCTION, $45, $pop68, $pop70, $pop72, $pop74, $pop76
	i32.const	$push188=, 0
	f64.load	$10=, d1($pop188)
	i32.const	$push187=, 0
	f64.load	$11=, d1+8($pop187)
	i32.const	$push186=, 0
	f64.load	$12=, d2($pop186)
	i32.const	$push185=, 0
	f64.load	$13=, d2+8($pop185)
	i32.const	$push184=, 0
	f64.load	$14=, d3($pop184)
	i32.const	$push183=, 0
	f64.load	$15=, d3+8($pop183)
	i32.const	$push182=, 0
	f64.load	$16=, d4($pop182)
	i32.const	$push181=, 0
	f64.load	$17=, d4+8($pop181)
	i32.const	$push180=, 0
	f64.load	$18=, d5($pop180)
	i32.const	$push179=, 0
	f64.load	$19=, d5+8($pop179)
	f64.store	520($45), $10
	f64.store	528($45), $11
	f64.store	504($45), $12
	f64.store	512($45), $13
	f64.store	488($45), $14
	f64.store	496($45), $15
	f64.store	472($45), $16
	f64.store	480($45), $17
	f64.store	464($45), $19
	f64.store	456($45), $18
	i32.const	$push77=, 232
	i32.add 	$push78=, $45, $pop77
	i32.const	$push11=, 8
	i32.add 	$push12=, $pop78, $pop11
	i64.load	$push13=, 528($45)
	i64.store	0($pop12), $pop13
	i32.const	$push79=, 216
	i32.add 	$push80=, $45, $pop79
	i32.const	$push178=, 8
	i32.add 	$push14=, $pop80, $pop178
	i64.load	$push15=, 512($45)
	i64.store	0($pop14), $pop15
	i64.load	$push16=, 520($45)
	i64.store	232($45), $pop16
	i64.load	$push17=, 504($45)
	i64.store	216($45), $pop17
	i32.const	$push81=, 200
	i32.add 	$push82=, $45, $pop81
	i32.const	$push177=, 8
	i32.add 	$push18=, $pop82, $pop177
	i64.load	$push19=, 496($45)
	i64.store	0($pop18), $pop19
	i64.load	$push20=, 488($45)
	i64.store	200($45), $pop20
	i32.const	$push83=, 184
	i32.add 	$push84=, $45, $pop83
	i32.const	$push176=, 8
	i32.add 	$push21=, $pop84, $pop176
	i64.load	$push22=, 480($45)
	i64.store	0($pop21), $pop22
	i64.load	$push23=, 472($45)
	i64.store	184($45), $pop23
	i32.const	$push85=, 168
	i32.add 	$push86=, $45, $pop85
	i32.const	$push175=, 8
	i32.add 	$push24=, $pop86, $pop175
	i64.load	$push25=, 464($45)
	i64.store	0($pop24), $pop25
	i64.load	$push26=, 456($45)
	i64.store	168($45), $pop26
	i32.const	$push87=, 232
	i32.add 	$push88=, $45, $pop87
	i32.const	$push89=, 216
	i32.add 	$push90=, $45, $pop89
	i32.const	$push91=, 200
	i32.add 	$push92=, $45, $pop91
	i32.const	$push93=, 184
	i32.add 	$push94=, $45, $pop93
	i32.const	$push95=, 168
	i32.add 	$push96=, $45, $pop95
	call    	check_double@FUNCTION, $45, $pop88, $pop90, $pop92, $pop94, $pop96
	i32.const	$push174=, 0
	i64.load	$20=, ld1($pop174)
	i32.const	$push173=, 0
	i64.load	$21=, ld1+8($pop173)
	i32.const	$push172=, 0
	i64.load	$22=, ld1+16($pop172)
	i32.const	$push171=, 0
	i64.load	$23=, ld1+24($pop171)
	i32.const	$push170=, 0
	i64.load	$24=, ld2($pop170)
	i32.const	$push169=, 0
	i64.load	$25=, ld2+8($pop169)
	i32.const	$push168=, 0
	i64.load	$26=, ld2+16($pop168)
	i32.const	$push167=, 0
	i64.load	$27=, ld2+24($pop167)
	i32.const	$push166=, 0
	i64.load	$28=, ld3($pop166)
	i32.const	$push165=, 0
	i64.load	$29=, ld3+8($pop165)
	i32.const	$push164=, 0
	i64.load	$30=, ld3+16($pop164)
	i32.const	$push163=, 0
	i64.load	$31=, ld3+24($pop163)
	i32.const	$push162=, 0
	i64.load	$32=, ld4($pop162)
	i32.const	$push161=, 0
	i64.load	$33=, ld4+8($pop161)
	i32.const	$push160=, 0
	i64.load	$34=, ld4+16($pop160)
	i32.const	$push159=, 0
	i64.load	$35=, ld4+24($pop159)
	i32.const	$push158=, 0
	i64.load	$36=, ld5($pop158)
	i32.const	$push157=, 0
	i64.load	$37=, ld5+8($pop157)
	i32.const	$push156=, 0
	i64.load	$38=, ld5+16($pop156)
	i32.const	$push155=, 0
	i64.load	$39=, ld5+24($pop155)
	i64.store	424($45), $21
	i64.store	416($45), $20
	i32.const	$push97=, 416
	i32.add 	$push98=, $45, $pop97
	i32.const	$push27=, 24
	i32.add 	$push154=, $pop98, $pop27
	tee_local	$push153=, $40=, $pop154
	i64.store	0($pop153), $23
	i64.store	432($45), $22
	i32.const	$push99=, 384
	i32.add 	$push100=, $45, $pop99
	i32.const	$push152=, 24
	i32.add 	$push151=, $pop100, $pop152
	tee_local	$push150=, $41=, $pop151
	i64.store	0($pop150), $27
	i64.store	392($45), $25
	i64.store	384($45), $24
	i64.store	400($45), $26
	i32.const	$push101=, 352
	i32.add 	$push102=, $45, $pop101
	i32.const	$push149=, 24
	i32.add 	$push148=, $pop102, $pop149
	tee_local	$push147=, $42=, $pop148
	i64.store	0($pop147), $31
	i64.store	360($45), $29
	i64.store	352($45), $28
	i64.store	368($45), $30
	i32.const	$push103=, 320
	i32.add 	$push104=, $45, $pop103
	i32.const	$push146=, 24
	i32.add 	$push145=, $pop104, $pop146
	tee_local	$push144=, $43=, $pop145
	i64.store	0($pop144), $35
	i64.store	336($45), $34
	i32.const	$push105=, 288
	i32.add 	$push106=, $45, $pop105
	i32.const	$push143=, 24
	i32.add 	$push142=, $pop106, $pop143
	tee_local	$push141=, $44=, $pop142
	i64.store	0($pop141), $39
	i64.store	328($45), $33
	i64.store	320($45), $32
	i64.store	304($45), $38
	i64.store	296($45), $37
	i64.store	288($45), $36
	i32.const	$push107=, 128
	i32.add 	$push108=, $45, $pop107
	i32.const	$push140=, 24
	i32.add 	$push28=, $pop108, $pop140
	i64.load	$push29=, 0($40)
	i64.store	0($pop28), $pop29
	i32.const	$push109=, 128
	i32.add 	$push110=, $45, $pop109
	i32.const	$push30=, 16
	i32.add 	$push31=, $pop110, $pop30
	i64.load	$push32=, 432($45)
	i64.store	0($pop31), $pop32
	i64.load	$push33=, 424($45)
	i64.store	136($45), $pop33
	i64.load	$push34=, 416($45)
	i64.store	128($45), $pop34
	i32.const	$push111=, 96
	i32.add 	$push112=, $45, $pop111
	i32.const	$push139=, 24
	i32.add 	$push35=, $pop112, $pop139
	i64.load	$push36=, 0($41)
	i64.store	0($pop35), $pop36
	i32.const	$push113=, 96
	i32.add 	$push114=, $45, $pop113
	i32.const	$push138=, 16
	i32.add 	$push37=, $pop114, $pop138
	i64.load	$push38=, 400($45)
	i64.store	0($pop37), $pop38
	i64.load	$push39=, 392($45)
	i64.store	104($45), $pop39
	i64.load	$push40=, 384($45)
	i64.store	96($45), $pop40
	i32.const	$push115=, 64
	i32.add 	$push116=, $45, $pop115
	i32.const	$push137=, 24
	i32.add 	$push41=, $pop116, $pop137
	i64.load	$push42=, 0($42)
	i64.store	0($pop41), $pop42
	i32.const	$push117=, 64
	i32.add 	$push118=, $45, $pop117
	i32.const	$push136=, 16
	i32.add 	$push43=, $pop118, $pop136
	i64.load	$push44=, 368($45)
	i64.store	0($pop43), $pop44
	i64.load	$push45=, 360($45)
	i64.store	72($45), $pop45
	i64.load	$push46=, 352($45)
	i64.store	64($45), $pop46
	i32.const	$push119=, 32
	i32.add 	$push120=, $45, $pop119
	i32.const	$push135=, 24
	i32.add 	$push47=, $pop120, $pop135
	i64.load	$push48=, 0($43)
	i64.store	0($pop47), $pop48
	i32.const	$push121=, 32
	i32.add 	$push122=, $45, $pop121
	i32.const	$push134=, 16
	i32.add 	$push49=, $pop122, $pop134
	i64.load	$push50=, 336($45)
	i64.store	0($pop49), $pop50
	i64.load	$push51=, 328($45)
	i64.store	40($45), $pop51
	i64.load	$push52=, 320($45)
	i64.store	32($45), $pop52
	i32.const	$push133=, 24
	i32.add 	$push53=, $45, $pop133
	i64.load	$push54=, 0($44)
	i64.store	0($pop53), $pop54
	i32.const	$push132=, 16
	i32.add 	$push55=, $45, $pop132
	i64.load	$push56=, 304($45)
	i64.store	0($pop55), $pop56
	i64.load	$push57=, 296($45)
	i64.store	8($45), $pop57
	i64.load	$push58=, 288($45)
	i64.store	0($45), $pop58
	i32.const	$push123=, 128
	i32.add 	$push124=, $45, $pop123
	i32.const	$push125=, 96
	i32.add 	$push126=, $45, $pop125
	i32.const	$push127=, 64
	i32.add 	$push128=, $45, $pop127
	i32.const	$push129=, 32
	i32.add 	$push130=, $45, $pop129
	call    	check_long_double@FUNCTION, $45, $pop124, $pop126, $pop128, $pop130, $45
	i32.const	$push131=, 0
	call    	exit@FUNCTION, $pop131
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
