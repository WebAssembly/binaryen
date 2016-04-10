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
	f32.load	$8=, 0($1)
	f32.load	$6=, 4($1)
	i32.const	$push0=, 0
	f32.load	$9=, f1($pop0)
	i32.const	$push15=, 0
	f32.load	$7=, f1+4($pop15)
	block
	f32.ne  	$push1=, $8, $9
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %entry
	f32.ne  	$push2=, $6, $7
	br_if   	0, $pop2        # 0: down to label0
# BB#2:                                 # %lor.lhs.false
	f32.load	$8=, 0($2)
	f32.load	$6=, 4($2)
	i32.const	$push3=, 0
	f32.load	$9=, f2($pop3)
	i32.const	$push16=, 0
	f32.load	$7=, f2+4($pop16)
	f32.ne  	$push4=, $8, $9
	br_if   	0, $pop4        # 0: down to label0
# BB#3:                                 # %lor.lhs.false
	f32.ne  	$push5=, $6, $7
	br_if   	0, $pop5        # 0: down to label0
# BB#4:                                 # %lor.lhs.false4
	f32.load	$8=, 0($3)
	f32.load	$9=, 4($3)
	i32.const	$push6=, 0
	f32.load	$6=, f3($pop6)
	i32.const	$push17=, 0
	f32.load	$7=, f3+4($pop17)
	f32.ne  	$push7=, $8, $6
	br_if   	0, $pop7        # 0: down to label0
# BB#5:                                 # %lor.lhs.false4
	f32.ne  	$push8=, $9, $7
	br_if   	0, $pop8        # 0: down to label0
# BB#6:                                 # %lor.lhs.false8
	f32.load	$8=, 0($4)
	f32.load	$6=, 4($4)
	i32.const	$push9=, 0
	f32.load	$9=, f4($pop9)
	i32.const	$push18=, 0
	f32.load	$7=, f4+4($pop18)
	f32.ne  	$push10=, $8, $9
	br_if   	0, $pop10       # 0: down to label0
# BB#7:                                 # %lor.lhs.false8
	f32.ne  	$push11=, $6, $7
	br_if   	0, $pop11       # 0: down to label0
# BB#8:                                 # %lor.lhs.false12
	f32.load	$8=, 0($5)
	f32.load	$9=, 4($5)
	i32.const	$push12=, 0
	f32.load	$6=, f5($pop12)
	i32.const	$push19=, 0
	f32.load	$7=, f5+4($pop19)
	f32.ne  	$push13=, $8, $6
	br_if   	0, $pop13       # 0: down to label0
# BB#9:                                 # %lor.lhs.false12
	f32.ne  	$push14=, $9, $7
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
	f64.load	$8=, 0($1)
	f64.load	$6=, 8($1)
	i32.const	$push0=, 0
	f64.load	$9=, d1($pop0)
	i32.const	$push15=, 0
	f64.load	$7=, d1+8($pop15)
	block
	f64.ne  	$push1=, $8, $9
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %entry
	f64.ne  	$push2=, $6, $7
	br_if   	0, $pop2        # 0: down to label1
# BB#2:                                 # %lor.lhs.false
	f64.load	$8=, 0($2)
	f64.load	$6=, 8($2)
	i32.const	$push3=, 0
	f64.load	$9=, d2($pop3)
	i32.const	$push16=, 0
	f64.load	$7=, d2+8($pop16)
	f64.ne  	$push4=, $8, $9
	br_if   	0, $pop4        # 0: down to label1
# BB#3:                                 # %lor.lhs.false
	f64.ne  	$push5=, $6, $7
	br_if   	0, $pop5        # 0: down to label1
# BB#4:                                 # %lor.lhs.false4
	f64.load	$8=, 0($3)
	f64.load	$9=, 8($3)
	i32.const	$push6=, 0
	f64.load	$6=, d3($pop6)
	i32.const	$push17=, 0
	f64.load	$7=, d3+8($pop17)
	f64.ne  	$push7=, $8, $6
	br_if   	0, $pop7        # 0: down to label1
# BB#5:                                 # %lor.lhs.false4
	f64.ne  	$push8=, $9, $7
	br_if   	0, $pop8        # 0: down to label1
# BB#6:                                 # %lor.lhs.false8
	f64.load	$8=, 0($4)
	f64.load	$6=, 8($4)
	i32.const	$push9=, 0
	f64.load	$9=, d4($pop9)
	i32.const	$push18=, 0
	f64.load	$7=, d4+8($pop18)
	f64.ne  	$push10=, $8, $9
	br_if   	0, $pop10       # 0: down to label1
# BB#7:                                 # %lor.lhs.false8
	f64.ne  	$push11=, $6, $7
	br_if   	0, $pop11       # 0: down to label1
# BB#8:                                 # %lor.lhs.false12
	f64.load	$8=, 0($5)
	f64.load	$9=, 8($5)
	i32.const	$push12=, 0
	f64.load	$6=, d5($pop12)
	i32.const	$push19=, 0
	f64.load	$7=, d5+8($pop19)
	f64.ne  	$push13=, $8, $6
	br_if   	0, $pop13       # 0: down to label1
# BB#9:                                 # %lor.lhs.false12
	f64.ne  	$push14=, $9, $7
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
	.local  	i64, i64, i64, i64, i64, i64, i64, i64
# BB#0:                                 # %entry
	i32.const	$push0=, 8
	i32.add 	$push1=, $1, $pop0
	i64.load	$10=, 0($pop1)
	i32.const	$push2=, 24
	i32.add 	$push3=, $1, $pop2
	i64.load	$7=, 0($pop3)
	i64.load	$11=, 0($1):p2align=4
	i64.load	$6=, 16($1):p2align=4
	i32.const	$push4=, 0
	i64.load	$12=, ld1+8($pop4)
	i32.const	$push37=, 0
	i64.load	$13=, ld1($pop37):p2align=4
	i32.const	$push36=, 0
	i64.load	$9=, ld1+24($pop36)
	i32.const	$push35=, 0
	i64.load	$8=, ld1+16($pop35):p2align=4
	block
	i32.call	$push5=, __netf2@FUNCTION, $11, $10, $13, $12
	br_if   	0, $pop5        # 0: down to label2
# BB#1:                                 # %entry
	i32.call	$push6=, __netf2@FUNCTION, $6, $7, $8, $9
	br_if   	0, $pop6        # 0: down to label2
# BB#2:                                 # %lor.lhs.false
	i32.const	$push7=, 8
	i32.add 	$push8=, $2, $pop7
	i64.load	$10=, 0($pop8)
	i32.const	$push9=, 24
	i32.add 	$push10=, $2, $pop9
	i64.load	$7=, 0($pop10)
	i64.load	$11=, 0($2):p2align=4
	i64.load	$6=, 16($2):p2align=4
	i32.const	$push11=, 0
	i64.load	$12=, ld2+8($pop11)
	i32.const	$push40=, 0
	i64.load	$13=, ld2($pop40):p2align=4
	i32.const	$push39=, 0
	i64.load	$9=, ld2+24($pop39)
	i32.const	$push38=, 0
	i64.load	$8=, ld2+16($pop38):p2align=4
	i32.call	$push12=, __netf2@FUNCTION, $11, $10, $13, $12
	br_if   	0, $pop12       # 0: down to label2
# BB#3:                                 # %lor.lhs.false
	i32.call	$push13=, __netf2@FUNCTION, $6, $7, $8, $9
	br_if   	0, $pop13       # 0: down to label2
# BB#4:                                 # %lor.lhs.false4
	i32.const	$push14=, 8
	i32.add 	$push15=, $3, $pop14
	i64.load	$10=, 0($pop15)
	i32.const	$push16=, 24
	i32.add 	$push17=, $3, $pop16
	i64.load	$11=, 0($pop17)
	i64.load	$12=, 0($3):p2align=4
	i64.load	$13=, 16($3):p2align=4
	i32.const	$push18=, 0
	i64.load	$7=, ld3+8($pop18)
	i32.const	$push43=, 0
	i64.load	$6=, ld3($pop43):p2align=4
	i32.const	$push42=, 0
	i64.load	$9=, ld3+24($pop42)
	i32.const	$push41=, 0
	i64.load	$8=, ld3+16($pop41):p2align=4
	i32.call	$push19=, __netf2@FUNCTION, $12, $10, $6, $7
	br_if   	0, $pop19       # 0: down to label2
# BB#5:                                 # %lor.lhs.false4
	i32.call	$push20=, __netf2@FUNCTION, $13, $11, $8, $9
	br_if   	0, $pop20       # 0: down to label2
# BB#6:                                 # %lor.lhs.false8
	i32.const	$push21=, 8
	i32.add 	$push22=, $4, $pop21
	i64.load	$10=, 0($pop22)
	i32.const	$push23=, 24
	i32.add 	$push24=, $4, $pop23
	i64.load	$7=, 0($pop24)
	i64.load	$11=, 0($4):p2align=4
	i64.load	$6=, 16($4):p2align=4
	i32.const	$push25=, 0
	i64.load	$12=, ld4+8($pop25)
	i32.const	$push46=, 0
	i64.load	$13=, ld4($pop46):p2align=4
	i32.const	$push45=, 0
	i64.load	$9=, ld4+24($pop45)
	i32.const	$push44=, 0
	i64.load	$8=, ld4+16($pop44):p2align=4
	i32.call	$push26=, __netf2@FUNCTION, $11, $10, $13, $12
	br_if   	0, $pop26       # 0: down to label2
# BB#7:                                 # %lor.lhs.false8
	i32.call	$push27=, __netf2@FUNCTION, $6, $7, $8, $9
	br_if   	0, $pop27       # 0: down to label2
# BB#8:                                 # %lor.lhs.false12
	i32.const	$push28=, 8
	i32.add 	$push29=, $5, $pop28
	i64.load	$10=, 0($pop29)
	i32.const	$push30=, 24
	i32.add 	$push31=, $5, $pop30
	i64.load	$11=, 0($pop31)
	i64.load	$12=, 0($5):p2align=4
	i64.load	$13=, 16($5):p2align=4
	i32.const	$push32=, 0
	i64.load	$7=, ld5+8($pop32)
	i32.const	$push49=, 0
	i64.load	$6=, ld5($pop49):p2align=4
	i32.const	$push48=, 0
	i64.load	$9=, ld5+24($pop48)
	i32.const	$push47=, 0
	i64.load	$8=, ld5+16($pop47):p2align=4
	i32.call	$push33=, __netf2@FUNCTION, $12, $10, $6, $7
	br_if   	0, $pop33       # 0: down to label2
# BB#9:                                 # %lor.lhs.false12
	i32.call	$push34=, __eqtf2@FUNCTION, $13, $11, $8, $9
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
	.local  	f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, i64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push126=, __stack_pointer
	i32.load	$push127=, 0($pop126)
	i32.const	$push128=, 576
	i32.sub 	$45=, $pop127, $pop128
	i32.const	$push129=, __stack_pointer
	i32.store	$discard=, 0($pop129), $45
	i32.const	$push0=, 0
	f32.load	$0=, f1($pop0)
	i32.const	$push125=, 0
	f32.load	$1=, f1+4($pop125)
	i32.const	$push124=, 0
	f32.load	$2=, f2($pop124)
	i32.const	$push123=, 0
	f32.load	$3=, f2+4($pop123)
	i32.const	$push122=, 0
	f32.load	$4=, f3($pop122)
	i32.const	$push121=, 0
	f32.load	$5=, f3+4($pop121)
	i32.const	$push120=, 0
	f32.load	$6=, f4($pop120)
	i32.const	$push119=, 0
	f32.load	$7=, f4+4($pop119)
	i32.const	$push118=, 0
	f32.load	$8=, f5($pop118)
	i32.const	$push117=, 0
	f32.load	$9=, f5+4($pop117)
	f32.store	$discard=, 568($45):p2align=3, $0
	f32.store	$discard=, 572($45), $1
	f32.store	$discard=, 560($45):p2align=3, $2
	f32.store	$discard=, 564($45), $3
	f32.store	$discard=, 552($45):p2align=3, $4
	f32.store	$discard=, 556($45), $5
	f32.store	$discard=, 544($45):p2align=3, $6
	f32.store	$discard=, 548($45), $7
	f32.store	$discard=, 536($45):p2align=3, $8
	f32.store	$discard=, 540($45), $9
	i64.load	$10=, 568($45)
	i32.const	$push130=, 272
	i32.add 	$push131=, $45, $pop130
	i32.const	$push1=, 4
	i32.add 	$push2=, $pop131, $pop1
	i32.load	$push3=, 564($45)
	i32.store	$discard=, 0($pop2), $pop3
	i64.store	$discard=, 280($45):p2align=2, $10
	i32.load	$push4=, 560($45):p2align=3
	i32.store	$discard=, 272($45), $pop4
	i32.const	$push132=, 264
	i32.add 	$push133=, $45, $pop132
	i32.const	$push116=, 4
	i32.add 	$push5=, $pop133, $pop116
	i32.load	$push6=, 556($45)
	i32.store	$discard=, 0($pop5), $pop6
	i32.load	$push7=, 552($45):p2align=3
	i32.store	$discard=, 264($45), $pop7
	i64.load	$push8=, 544($45)
	i64.store	$discard=, 256($45):p2align=2, $pop8
	i64.load	$push9=, 536($45)
	i64.store	$discard=, 248($45):p2align=2, $pop9
	i32.const	$push134=, 280
	i32.add 	$push135=, $45, $pop134
	i32.const	$push136=, 272
	i32.add 	$push137=, $45, $pop136
	i32.const	$push138=, 264
	i32.add 	$push139=, $45, $pop138
	i32.const	$push140=, 256
	i32.add 	$push141=, $45, $pop140
	i32.const	$push142=, 248
	i32.add 	$push143=, $45, $pop142
	call    	check_float@FUNCTION, $44, $pop135, $pop137, $pop139, $pop141, $pop143
	i32.const	$push115=, 0
	f64.load	$11=, d1($pop115)
	i32.const	$push114=, 0
	f64.load	$12=, d1+8($pop114)
	i32.const	$push113=, 0
	f64.load	$13=, d2($pop113)
	i32.const	$push112=, 0
	f64.load	$14=, d2+8($pop112)
	i32.const	$push111=, 0
	f64.load	$15=, d3($pop111)
	i32.const	$push110=, 0
	f64.load	$16=, d3+8($pop110)
	i32.const	$push109=, 0
	f64.load	$17=, d4($pop109)
	i32.const	$push108=, 0
	f64.load	$18=, d4+8($pop108)
	i32.const	$push107=, 0
	f64.load	$19=, d5($pop107)
	i32.const	$push106=, 0
	f64.load	$20=, d5+8($pop106)
	f64.store	$discard=, 520($45), $11
	f64.store	$discard=, 528($45), $12
	f64.store	$discard=, 504($45), $13
	f64.store	$discard=, 512($45), $14
	f64.store	$discard=, 488($45), $15
	f64.store	$discard=, 496($45), $16
	f64.store	$discard=, 472($45), $17
	f64.store	$discard=, 480($45), $18
	f64.store	$discard=, 456($45), $19
	f64.store	$discard=, 464($45), $20
	i32.const	$push144=, 232
	i32.add 	$push145=, $45, $pop144
	i32.const	$push10=, 8
	i32.add 	$push11=, $pop145, $pop10
	i64.load	$push12=, 528($45)
	i64.store	$discard=, 0($pop11), $pop12
	i64.load	$push13=, 520($45)
	i64.store	$discard=, 232($45), $pop13
	i32.const	$push146=, 216
	i32.add 	$push147=, $45, $pop146
	i32.const	$push105=, 8
	i32.add 	$push14=, $pop147, $pop105
	i64.load	$push15=, 512($45)
	i64.store	$discard=, 0($pop14), $pop15
	i64.load	$push16=, 504($45)
	i64.store	$discard=, 216($45), $pop16
	i32.const	$push148=, 200
	i32.add 	$push149=, $45, $pop148
	i32.const	$push104=, 8
	i32.add 	$push17=, $pop149, $pop104
	i64.load	$push18=, 496($45)
	i64.store	$discard=, 0($pop17), $pop18
	i64.load	$push19=, 488($45)
	i64.store	$discard=, 200($45), $pop19
	i32.const	$push150=, 184
	i32.add 	$push151=, $45, $pop150
	i32.const	$push103=, 8
	i32.add 	$push20=, $pop151, $pop103
	i64.load	$push21=, 480($45)
	i64.store	$discard=, 0($pop20), $pop21
	i64.load	$push22=, 472($45)
	i64.store	$discard=, 184($45), $pop22
	i32.const	$push152=, 168
	i32.add 	$push153=, $45, $pop152
	i32.const	$push102=, 8
	i32.add 	$push23=, $pop153, $pop102
	i64.load	$push24=, 464($45)
	i64.store	$discard=, 0($pop23), $pop24
	i64.load	$push25=, 456($45)
	i64.store	$discard=, 168($45), $pop25
	i32.const	$push154=, 232
	i32.add 	$push155=, $45, $pop154
	i32.const	$push156=, 216
	i32.add 	$push157=, $45, $pop156
	i32.const	$push158=, 200
	i32.add 	$push159=, $45, $pop158
	i32.const	$push160=, 184
	i32.add 	$push161=, $45, $pop160
	i32.const	$push162=, 168
	i32.add 	$push163=, $45, $pop162
	call    	check_double@FUNCTION, $44, $pop155, $pop157, $pop159, $pop161, $pop163
	i32.const	$push101=, 0
	i64.load	$10=, ld1($pop101):p2align=4
	i32.const	$push100=, 0
	i64.load	$21=, ld1+8($pop100)
	i32.const	$push99=, 0
	i64.load	$22=, ld1+16($pop99):p2align=4
	i32.const	$push98=, 0
	i64.load	$23=, ld1+24($pop98)
	i32.const	$push97=, 0
	i64.load	$24=, ld2($pop97):p2align=4
	i32.const	$push96=, 0
	i64.load	$25=, ld2+8($pop96)
	i32.const	$push95=, 0
	i64.load	$26=, ld2+16($pop95):p2align=4
	i32.const	$push94=, 0
	i64.load	$27=, ld2+24($pop94)
	i32.const	$push93=, 0
	i64.load	$28=, ld3($pop93):p2align=4
	i32.const	$push92=, 0
	i64.load	$29=, ld3+8($pop92)
	i32.const	$push91=, 0
	i64.load	$30=, ld3+16($pop91):p2align=4
	i32.const	$push90=, 0
	i64.load	$31=, ld3+24($pop90)
	i32.const	$push89=, 0
	i64.load	$32=, ld4($pop89):p2align=4
	i32.const	$push88=, 0
	i64.load	$33=, ld4+8($pop88)
	i32.const	$push87=, 0
	i64.load	$34=, ld4+16($pop87):p2align=4
	i32.const	$push86=, 0
	i64.load	$35=, ld4+24($pop86)
	i32.const	$push85=, 0
	i64.load	$36=, ld5($pop85):p2align=4
	i32.const	$push84=, 0
	i64.load	$37=, ld5+8($pop84)
	i32.const	$push83=, 0
	i64.load	$38=, ld5+16($pop83):p2align=4
	i32.const	$push82=, 0
	i64.load	$39=, ld5+24($pop82)
	i64.store	$discard=, 424($45), $21
	i64.store	$discard=, 416($45):p2align=4, $10
	i32.const	$push164=, 416
	i32.add 	$push165=, $45, $pop164
	i32.const	$push26=, 24
	i32.add 	$push81=, $pop165, $pop26
	tee_local	$push80=, $44=, $pop81
	i64.store	$discard=, 0($pop80), $23
	i64.store	$discard=, 432($45):p2align=4, $22
	i64.store	$discard=, 392($45), $25
	i64.store	$discard=, 384($45):p2align=4, $24
	i32.const	$push166=, 384
	i32.add 	$push167=, $45, $pop166
	i32.const	$push79=, 24
	i32.add 	$push78=, $pop167, $pop79
	tee_local	$push77=, $43=, $pop78
	i64.store	$discard=, 0($pop77), $27
	i64.store	$discard=, 400($45):p2align=4, $26
	i64.store	$discard=, 360($45), $29
	i64.store	$discard=, 352($45):p2align=4, $28
	i32.const	$push168=, 352
	i32.add 	$push169=, $45, $pop168
	i32.const	$push76=, 24
	i32.add 	$push75=, $pop169, $pop76
	tee_local	$push74=, $42=, $pop75
	i64.store	$discard=, 0($pop74), $31
	i64.store	$discard=, 368($45):p2align=4, $30
	i64.store	$discard=, 328($45), $33
	i64.store	$discard=, 320($45):p2align=4, $32
	i32.const	$push170=, 320
	i32.add 	$push171=, $45, $pop170
	i32.const	$push73=, 24
	i32.add 	$push72=, $pop171, $pop73
	tee_local	$push71=, $41=, $pop72
	i64.store	$discard=, 0($pop71), $35
	i64.store	$discard=, 336($45):p2align=4, $34
	i64.store	$discard=, 296($45), $37
	i64.store	$discard=, 288($45):p2align=4, $36
	i32.const	$push172=, 288
	i32.add 	$push173=, $45, $pop172
	i32.const	$push70=, 24
	i32.add 	$push69=, $pop173, $pop70
	tee_local	$push68=, $40=, $pop69
	i64.store	$discard=, 0($pop68), $39
	i64.store	$discard=, 304($45):p2align=4, $38
	i32.const	$push174=, 128
	i32.add 	$push175=, $45, $pop174
	i32.const	$push67=, 24
	i32.add 	$push27=, $pop175, $pop67
	i64.load	$push28=, 0($44)
	i64.store	$discard=, 0($pop27), $pop28
	i32.const	$push176=, 128
	i32.add 	$push177=, $45, $pop176
	i32.const	$push29=, 16
	i32.add 	$push30=, $pop177, $pop29
	i64.load	$push31=, 432($45):p2align=4
	i64.store	$discard=, 0($pop30):p2align=4, $pop31
	i64.load	$push32=, 424($45)
	i64.store	$discard=, 136($45), $pop32
	i64.load	$push33=, 416($45):p2align=4
	i64.store	$discard=, 128($45):p2align=4, $pop33
	i32.const	$push178=, 96
	i32.add 	$push179=, $45, $pop178
	i32.const	$push66=, 24
	i32.add 	$push34=, $pop179, $pop66
	i64.load	$push35=, 0($43)
	i64.store	$discard=, 0($pop34), $pop35
	i32.const	$push180=, 96
	i32.add 	$push181=, $45, $pop180
	i32.const	$push65=, 16
	i32.add 	$push36=, $pop181, $pop65
	i64.load	$push37=, 400($45):p2align=4
	i64.store	$discard=, 0($pop36):p2align=4, $pop37
	i64.load	$push38=, 392($45)
	i64.store	$discard=, 104($45), $pop38
	i64.load	$push39=, 384($45):p2align=4
	i64.store	$discard=, 96($45):p2align=4, $pop39
	i32.const	$push182=, 64
	i32.add 	$push183=, $45, $pop182
	i32.const	$push64=, 24
	i32.add 	$push40=, $pop183, $pop64
	i64.load	$push41=, 0($42)
	i64.store	$discard=, 0($pop40), $pop41
	i32.const	$push184=, 64
	i32.add 	$push185=, $45, $pop184
	i32.const	$push63=, 16
	i32.add 	$push42=, $pop185, $pop63
	i64.load	$push43=, 368($45):p2align=4
	i64.store	$discard=, 0($pop42):p2align=4, $pop43
	i64.load	$push44=, 360($45)
	i64.store	$discard=, 72($45), $pop44
	i64.load	$push45=, 352($45):p2align=4
	i64.store	$discard=, 64($45):p2align=4, $pop45
	i32.const	$push186=, 32
	i32.add 	$push187=, $45, $pop186
	i32.const	$push62=, 24
	i32.add 	$push46=, $pop187, $pop62
	i64.load	$push47=, 0($41)
	i64.store	$discard=, 0($pop46), $pop47
	i32.const	$push188=, 32
	i32.add 	$push189=, $45, $pop188
	i32.const	$push61=, 16
	i32.add 	$push48=, $pop189, $pop61
	i64.load	$push49=, 336($45):p2align=4
	i64.store	$discard=, 0($pop48):p2align=4, $pop49
	i64.load	$push50=, 328($45)
	i64.store	$discard=, 40($45), $pop50
	i64.load	$push51=, 320($45):p2align=4
	i64.store	$discard=, 32($45):p2align=4, $pop51
	i32.const	$push60=, 24
	i32.add 	$push52=, $45, $pop60
	i64.load	$push53=, 0($40)
	i64.store	$discard=, 0($pop52), $pop53
	i32.const	$push59=, 16
	i32.add 	$push54=, $45, $pop59
	i64.load	$push55=, 304($45):p2align=4
	i64.store	$discard=, 0($pop54):p2align=4, $pop55
	i64.load	$push56=, 296($45)
	i64.store	$discard=, 8($45), $pop56
	i64.load	$push57=, 288($45):p2align=4
	i64.store	$discard=, 0($45):p2align=4, $pop57
	i32.const	$push190=, 128
	i32.add 	$push191=, $45, $pop190
	i32.const	$push192=, 96
	i32.add 	$push193=, $45, $pop192
	i32.const	$push194=, 64
	i32.add 	$push195=, $45, $pop194
	i32.const	$push196=, 32
	i32.add 	$push197=, $45, $pop196
	call    	check_long_double@FUNCTION, $44, $pop191, $pop193, $pop195, $pop197, $45
	i32.const	$push58=, 0
	call    	exit@FUNCTION, $pop58
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
