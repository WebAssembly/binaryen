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
	.local  	i32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push62=, 0
	i32.const	$push59=, 0
	i32.load	$push60=, __stack_pointer($pop59)
	i32.const	$push61=, 576
	i32.sub 	$push131=, $pop60, $pop61
	i32.store	$0=, __stack_pointer($pop62), $pop131
	i32.const	$push0=, 0
	f32.load	$1=, f1($pop0)
	i32.const	$push199=, 0
	f32.load	$2=, f1+4($pop199)
	i32.const	$push198=, 0
	f32.load	$3=, f2($pop198)
	i32.const	$push197=, 0
	f32.load	$4=, f2+4($pop197)
	i32.const	$push196=, 0
	f32.load	$5=, f3($pop196)
	i32.const	$push195=, 0
	f32.load	$6=, f3+4($pop195)
	i32.const	$push194=, 0
	f32.load	$7=, f4($pop194)
	i32.const	$push193=, 0
	f32.load	$8=, f4+4($pop193)
	i32.const	$push192=, 0
	f32.load	$9=, f5($pop192)
	i32.const	$push191=, 0
	f32.load	$10=, f5+4($pop191)
	f32.store	$drop=, 568($0), $1
	f32.store	$drop=, 572($0), $2
	f32.store	$drop=, 560($0), $3
	f32.store	$drop=, 564($0), $4
	f32.store	$drop=, 552($0), $5
	f32.store	$drop=, 556($0), $6
	f32.store	$drop=, 544($0), $7
	f32.store	$drop=, 548($0), $8
	f32.store	$drop=, 540($0), $10
	f32.store	$drop=, 536($0), $9
	i64.load	$push1=, 568($0)
	i64.store	$drop=, 280($0):p2align=2, $pop1
	i32.const	$push63=, 272
	i32.add 	$push64=, $0, $pop63
	i32.const	$push2=, 4
	i32.add 	$push3=, $pop64, $pop2
	i32.load	$push4=, 564($0)
	i32.store	$drop=, 0($pop3), $pop4
	i32.load	$push5=, 560($0)
	i32.store	$drop=, 272($0), $pop5
	i32.const	$push65=, 264
	i32.add 	$push66=, $0, $pop65
	i32.const	$push190=, 4
	i32.add 	$push6=, $pop66, $pop190
	i32.load	$push7=, 556($0)
	i32.store	$drop=, 0($pop6), $pop7
	i32.load	$push8=, 552($0)
	i32.store	$drop=, 264($0), $pop8
	i64.load	$push9=, 544($0)
	i64.store	$drop=, 256($0):p2align=2, $pop9
	i64.load	$push10=, 536($0)
	i64.store	$drop=, 248($0):p2align=2, $pop10
	i32.const	$push67=, 280
	i32.add 	$push68=, $0, $pop67
	i32.const	$push69=, 272
	i32.add 	$push70=, $0, $pop69
	i32.const	$push71=, 264
	i32.add 	$push72=, $0, $pop71
	i32.const	$push73=, 256
	i32.add 	$push74=, $0, $pop73
	i32.const	$push75=, 248
	i32.add 	$push76=, $0, $pop75
	call    	check_float@FUNCTION, $0, $pop68, $pop70, $pop72, $pop74, $pop76
	i32.const	$push189=, 0
	f64.load	$11=, d1($pop189)
	i32.const	$push188=, 0
	f64.load	$12=, d1+8($pop188)
	i32.const	$push187=, 0
	f64.load	$13=, d2($pop187)
	i32.const	$push186=, 0
	f64.load	$14=, d2+8($pop186)
	i32.const	$push185=, 0
	f64.load	$15=, d3($pop185)
	i32.const	$push184=, 0
	f64.load	$16=, d3+8($pop184)
	i32.const	$push183=, 0
	f64.load	$17=, d4($pop183)
	i32.const	$push182=, 0
	f64.load	$18=, d4+8($pop182)
	i32.const	$push181=, 0
	f64.load	$19=, d5($pop181)
	i32.const	$push180=, 0
	f64.load	$20=, d5+8($pop180)
	f64.store	$drop=, 520($0), $11
	f64.store	$drop=, 528($0), $12
	f64.store	$drop=, 504($0), $13
	f64.store	$drop=, 512($0), $14
	f64.store	$drop=, 488($0), $15
	f64.store	$drop=, 496($0), $16
	f64.store	$drop=, 472($0), $17
	f64.store	$drop=, 480($0), $18
	f64.store	$drop=, 464($0), $20
	f64.store	$drop=, 456($0), $19
	i32.const	$push77=, 232
	i32.add 	$push78=, $0, $pop77
	i32.const	$push11=, 8
	i32.add 	$push12=, $pop78, $pop11
	i64.load	$push13=, 528($0)
	i64.store	$drop=, 0($pop12), $pop13
	i64.load	$push14=, 520($0)
	i64.store	$drop=, 232($0), $pop14
	i32.const	$push79=, 216
	i32.add 	$push80=, $0, $pop79
	i32.const	$push179=, 8
	i32.add 	$push15=, $pop80, $pop179
	i64.load	$push16=, 512($0)
	i64.store	$drop=, 0($pop15), $pop16
	i64.load	$push17=, 504($0)
	i64.store	$drop=, 216($0), $pop17
	i32.const	$push81=, 200
	i32.add 	$push82=, $0, $pop81
	i32.const	$push178=, 8
	i32.add 	$push18=, $pop82, $pop178
	i64.load	$push19=, 496($0)
	i64.store	$drop=, 0($pop18), $pop19
	i64.load	$push20=, 488($0)
	i64.store	$drop=, 200($0), $pop20
	i32.const	$push83=, 184
	i32.add 	$push84=, $0, $pop83
	i32.const	$push177=, 8
	i32.add 	$push21=, $pop84, $pop177
	i64.load	$push22=, 480($0)
	i64.store	$drop=, 0($pop21), $pop22
	i64.load	$push23=, 472($0)
	i64.store	$drop=, 184($0), $pop23
	i32.const	$push85=, 168
	i32.add 	$push86=, $0, $pop85
	i32.const	$push176=, 8
	i32.add 	$push24=, $pop86, $pop176
	i64.load	$push25=, 464($0)
	i64.store	$drop=, 0($pop24), $pop25
	i64.load	$push26=, 456($0)
	i64.store	$drop=, 168($0), $pop26
	i32.const	$push87=, 232
	i32.add 	$push88=, $0, $pop87
	i32.const	$push89=, 216
	i32.add 	$push90=, $0, $pop89
	i32.const	$push91=, 200
	i32.add 	$push92=, $0, $pop91
	i32.const	$push93=, 184
	i32.add 	$push94=, $0, $pop93
	i32.const	$push95=, 168
	i32.add 	$push96=, $0, $pop95
	call    	check_double@FUNCTION, $0, $pop88, $pop90, $pop92, $pop94, $pop96
	i32.const	$push175=, 0
	i64.load	$21=, ld1($pop175)
	i32.const	$push174=, 0
	i64.load	$22=, ld1+8($pop174)
	i32.const	$push173=, 0
	i64.load	$23=, ld1+16($pop173)
	i32.const	$push172=, 0
	i64.load	$24=, ld1+24($pop172)
	i32.const	$push171=, 0
	i64.load	$25=, ld2($pop171)
	i32.const	$push170=, 0
	i64.load	$26=, ld2+8($pop170)
	i32.const	$push169=, 0
	i64.load	$27=, ld2+16($pop169)
	i32.const	$push168=, 0
	i64.load	$28=, ld2+24($pop168)
	i32.const	$push167=, 0
	i64.load	$29=, ld3($pop167)
	i32.const	$push166=, 0
	i64.load	$30=, ld3+8($pop166)
	i32.const	$push165=, 0
	i64.load	$31=, ld3+16($pop165)
	i32.const	$push164=, 0
	i64.load	$32=, ld3+24($pop164)
	i32.const	$push163=, 0
	i64.load	$33=, ld4($pop163)
	i32.const	$push162=, 0
	i64.load	$34=, ld4+8($pop162)
	i32.const	$push161=, 0
	i64.load	$35=, ld4+16($pop161)
	i32.const	$push160=, 0
	i64.load	$36=, ld4+24($pop160)
	i32.const	$push159=, 0
	i64.load	$37=, ld5($pop159)
	i32.const	$push158=, 0
	i64.load	$38=, ld5+8($pop158)
	i32.const	$push157=, 0
	i64.load	$39=, ld5+16($pop157)
	i32.const	$push156=, 0
	i64.load	$40=, ld5+24($pop156)
	i64.store	$drop=, 424($0), $22
	i64.store	$drop=, 416($0), $21
	i32.const	$push97=, 416
	i32.add 	$push98=, $0, $pop97
	i32.const	$push27=, 24
	i32.add 	$push155=, $pop98, $pop27
	tee_local	$push154=, $41=, $pop155
	i64.store	$drop=, 0($pop154), $24
	i64.store	$drop=, 432($0), $23
	i32.const	$push99=, 384
	i32.add 	$push100=, $0, $pop99
	i32.const	$push153=, 24
	i32.add 	$push152=, $pop100, $pop153
	tee_local	$push151=, $42=, $pop152
	i64.store	$drop=, 0($pop151), $28
	i64.store	$drop=, 392($0), $26
	i64.store	$drop=, 384($0), $25
	i64.store	$drop=, 400($0), $27
	i32.const	$push101=, 352
	i32.add 	$push102=, $0, $pop101
	i32.const	$push150=, 24
	i32.add 	$push149=, $pop102, $pop150
	tee_local	$push148=, $43=, $pop149
	i64.store	$drop=, 0($pop148), $32
	i64.store	$drop=, 360($0), $30
	i64.store	$drop=, 352($0), $29
	i64.store	$drop=, 368($0), $31
	i32.const	$push103=, 320
	i32.add 	$push104=, $0, $pop103
	i32.const	$push147=, 24
	i32.add 	$push146=, $pop104, $pop147
	tee_local	$push145=, $44=, $pop146
	i64.store	$drop=, 0($pop145), $36
	i64.store	$drop=, 328($0), $34
	i64.store	$drop=, 320($0), $33
	i64.store	$drop=, 336($0), $35
	i32.const	$push105=, 288
	i32.add 	$push106=, $0, $pop105
	i32.const	$push144=, 24
	i32.add 	$push143=, $pop106, $pop144
	tee_local	$push142=, $45=, $pop143
	i64.store	$drop=, 0($pop142), $40
	i64.store	$drop=, 304($0), $39
	i64.store	$drop=, 296($0), $38
	i64.store	$drop=, 288($0), $37
	i32.const	$push107=, 128
	i32.add 	$push108=, $0, $pop107
	i32.const	$push141=, 24
	i32.add 	$push28=, $pop108, $pop141
	i64.load	$push29=, 0($41)
	i64.store	$drop=, 0($pop28), $pop29
	i32.const	$push109=, 128
	i32.add 	$push110=, $0, $pop109
	i32.const	$push30=, 16
	i32.add 	$push31=, $pop110, $pop30
	i64.load	$push32=, 432($0)
	i64.store	$drop=, 0($pop31), $pop32
	i64.load	$push33=, 424($0)
	i64.store	$drop=, 136($0), $pop33
	i64.load	$push34=, 416($0)
	i64.store	$drop=, 128($0), $pop34
	i32.const	$push111=, 96
	i32.add 	$push112=, $0, $pop111
	i32.const	$push140=, 24
	i32.add 	$push35=, $pop112, $pop140
	i64.load	$push36=, 0($42)
	i64.store	$drop=, 0($pop35), $pop36
	i32.const	$push113=, 96
	i32.add 	$push114=, $0, $pop113
	i32.const	$push139=, 16
	i32.add 	$push37=, $pop114, $pop139
	i64.load	$push38=, 400($0)
	i64.store	$drop=, 0($pop37), $pop38
	i64.load	$push39=, 392($0)
	i64.store	$drop=, 104($0), $pop39
	i64.load	$push40=, 384($0)
	i64.store	$drop=, 96($0), $pop40
	i32.const	$push115=, 64
	i32.add 	$push116=, $0, $pop115
	i32.const	$push138=, 24
	i32.add 	$push41=, $pop116, $pop138
	i64.load	$push42=, 0($43)
	i64.store	$drop=, 0($pop41), $pop42
	i32.const	$push117=, 64
	i32.add 	$push118=, $0, $pop117
	i32.const	$push137=, 16
	i32.add 	$push43=, $pop118, $pop137
	i64.load	$push44=, 368($0)
	i64.store	$drop=, 0($pop43), $pop44
	i64.load	$push45=, 360($0)
	i64.store	$drop=, 72($0), $pop45
	i64.load	$push46=, 352($0)
	i64.store	$drop=, 64($0), $pop46
	i32.const	$push119=, 32
	i32.add 	$push120=, $0, $pop119
	i32.const	$push136=, 24
	i32.add 	$push47=, $pop120, $pop136
	i64.load	$push48=, 0($44)
	i64.store	$drop=, 0($pop47), $pop48
	i32.const	$push121=, 32
	i32.add 	$push122=, $0, $pop121
	i32.const	$push135=, 16
	i32.add 	$push49=, $pop122, $pop135
	i64.load	$push50=, 336($0)
	i64.store	$drop=, 0($pop49), $pop50
	i64.load	$push51=, 320($0)
	i64.store	$drop=, 32($0), $pop51
	i64.load	$push52=, 328($0)
	i64.store	$drop=, 40($0), $pop52
	i32.const	$push134=, 24
	i32.add 	$push53=, $0, $pop134
	i64.load	$push54=, 0($45)
	i64.store	$drop=, 0($pop53), $pop54
	i32.const	$push133=, 16
	i32.add 	$push55=, $0, $pop133
	i64.load	$push56=, 304($0)
	i64.store	$drop=, 0($pop55), $pop56
	i64.load	$push57=, 296($0)
	i64.store	$drop=, 8($0), $pop57
	i64.load	$push58=, 288($0)
	i64.store	$drop=, 0($0), $pop58
	i32.const	$push123=, 128
	i32.add 	$push124=, $0, $pop123
	i32.const	$push125=, 96
	i32.add 	$push126=, $0, $pop125
	i32.const	$push127=, 64
	i32.add 	$push128=, $0, $pop127
	i32.const	$push129=, 32
	i32.add 	$push130=, $0, $pop129
	call    	check_long_double@FUNCTION, $0, $pop124, $pop126, $pop128, $pop130, $0
	i32.const	$push132=, 0
	call    	exit@FUNCTION, $pop132
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


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
