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
	.local  	f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push121=, __stack_pointer
	i32.load	$push122=, 0($pop121)
	i32.const	$push123=, 576
	i32.sub 	$77=, $pop122, $pop123
	i32.const	$push124=, __stack_pointer
	i32.store	$discard=, 0($pop124), $77
	i32.const	$push0=, 0
	f32.load	$0=, f1($pop0)
	i32.const	$push120=, 0
	f32.load	$1=, f1+4($pop120)
	i32.const	$push119=, 0
	f32.load	$2=, f2($pop119)
	i32.const	$push118=, 0
	f32.load	$3=, f2+4($pop118)
	i32.const	$push117=, 0
	f32.load	$4=, f3($pop117)
	i32.const	$push116=, 0
	f32.load	$5=, f3+4($pop116)
	i32.const	$push115=, 0
	f32.load	$6=, f4($pop115)
	i32.const	$push114=, 0
	f32.load	$7=, f4+4($pop114)
	i32.const	$push113=, 0
	f32.load	$8=, f5($pop113)
	i32.const	$push112=, 0
	f32.load	$9=, f5+4($pop112)
	f32.store	$discard=, 568($77):p2align=3, $0
	f32.store	$discard=, 572($77), $1
	f32.store	$discard=, 560($77):p2align=3, $2
	f32.store	$discard=, 564($77), $3
	f32.store	$discard=, 552($77):p2align=3, $4
	f32.store	$discard=, 556($77), $5
	f32.store	$discard=, 544($77):p2align=3, $6
	f32.store	$discard=, 548($77), $7
	f32.store	$discard=, 536($77):p2align=3, $8
	f32.store	$discard=, 540($77), $9
	i64.load	$push1=, 568($77)
	i64.store	$discard=, 280($77):p2align=2, $pop1
	i64.load	$push2=, 560($77)
	i64.store	$discard=, 272($77):p2align=2, $pop2
	i64.load	$push3=, 552($77)
	i64.store	$discard=, 264($77):p2align=2, $pop3
	i64.load	$push4=, 544($77)
	i64.store	$discard=, 256($77):p2align=2, $pop4
	i64.load	$push5=, 536($77)
	i64.store	$discard=, 248($77):p2align=2, $pop5
	i32.const	$45=, 280
	i32.add 	$45=, $77, $45
	i32.const	$46=, 272
	i32.add 	$46=, $77, $46
	i32.const	$47=, 264
	i32.add 	$47=, $77, $47
	i32.const	$48=, 256
	i32.add 	$48=, $77, $48
	i32.const	$49=, 248
	i32.add 	$49=, $77, $49
	call    	check_float@FUNCTION, $44, $45, $46, $47, $48, $49
	i32.const	$push111=, 0
	f64.load	$10=, d1($pop111)
	i32.const	$push110=, 0
	f64.load	$11=, d1+8($pop110)
	i32.const	$push109=, 0
	f64.load	$12=, d2($pop109)
	i32.const	$push108=, 0
	f64.load	$13=, d2+8($pop108)
	i32.const	$push107=, 0
	f64.load	$14=, d3($pop107)
	i32.const	$push106=, 0
	f64.load	$15=, d3+8($pop106)
	i32.const	$push105=, 0
	f64.load	$16=, d4($pop105)
	i32.const	$push104=, 0
	f64.load	$17=, d4+8($pop104)
	i32.const	$push103=, 0
	f64.load	$18=, d5($pop103)
	i32.const	$push102=, 0
	f64.load	$19=, d5+8($pop102)
	f64.store	$discard=, 520($77), $10
	f64.store	$discard=, 528($77), $11
	f64.store	$discard=, 504($77), $12
	f64.store	$discard=, 512($77), $13
	f64.store	$discard=, 488($77), $14
	f64.store	$discard=, 496($77), $15
	f64.store	$discard=, 472($77), $16
	f64.store	$discard=, 480($77), $17
	f64.store	$discard=, 456($77), $18
	f64.store	$discard=, 464($77), $19
	i32.const	$push6=, 8
	i32.const	$50=, 232
	i32.add 	$50=, $77, $50
	i32.add 	$push7=, $50, $pop6
	i64.load	$push8=, 528($77)
	i64.store	$discard=, 0($pop7), $pop8
	i64.load	$push9=, 520($77)
	i64.store	$discard=, 232($77), $pop9
	i32.const	$push101=, 8
	i32.const	$51=, 216
	i32.add 	$51=, $77, $51
	i32.add 	$push10=, $51, $pop101
	i64.load	$push11=, 512($77)
	i64.store	$discard=, 0($pop10), $pop11
	i64.load	$push12=, 504($77)
	i64.store	$discard=, 216($77), $pop12
	i32.const	$push100=, 8
	i32.const	$52=, 200
	i32.add 	$52=, $77, $52
	i32.add 	$push13=, $52, $pop100
	i64.load	$push14=, 496($77)
	i64.store	$discard=, 0($pop13), $pop14
	i64.load	$push15=, 488($77)
	i64.store	$discard=, 200($77), $pop15
	i32.const	$push99=, 8
	i32.const	$53=, 184
	i32.add 	$53=, $77, $53
	i32.add 	$push16=, $53, $pop99
	i64.load	$push17=, 480($77)
	i64.store	$discard=, 0($pop16), $pop17
	i64.load	$push18=, 472($77)
	i64.store	$discard=, 184($77), $pop18
	i32.const	$push98=, 8
	i32.const	$54=, 168
	i32.add 	$54=, $77, $54
	i32.add 	$push19=, $54, $pop98
	i64.load	$push20=, 464($77)
	i64.store	$discard=, 0($pop19), $pop20
	i64.load	$push21=, 456($77)
	i64.store	$discard=, 168($77), $pop21
	i32.const	$55=, 232
	i32.add 	$55=, $77, $55
	i32.const	$56=, 216
	i32.add 	$56=, $77, $56
	i32.const	$57=, 200
	i32.add 	$57=, $77, $57
	i32.const	$58=, 184
	i32.add 	$58=, $77, $58
	i32.const	$59=, 168
	i32.add 	$59=, $77, $59
	call    	check_double@FUNCTION, $44, $55, $56, $57, $58, $59
	i32.const	$push97=, 0
	i64.load	$20=, ld1($pop97):p2align=4
	i32.const	$push96=, 0
	i64.load	$21=, ld1+8($pop96)
	i32.const	$push95=, 0
	i64.load	$22=, ld1+16($pop95):p2align=4
	i32.const	$push94=, 0
	i64.load	$23=, ld1+24($pop94)
	i32.const	$push93=, 0
	i64.load	$24=, ld2($pop93):p2align=4
	i32.const	$push92=, 0
	i64.load	$25=, ld2+8($pop92)
	i32.const	$push91=, 0
	i64.load	$26=, ld2+16($pop91):p2align=4
	i32.const	$push90=, 0
	i64.load	$27=, ld2+24($pop90)
	i32.const	$push89=, 0
	i64.load	$28=, ld3($pop89):p2align=4
	i32.const	$push88=, 0
	i64.load	$29=, ld3+8($pop88)
	i32.const	$push87=, 0
	i64.load	$30=, ld3+16($pop87):p2align=4
	i32.const	$push86=, 0
	i64.load	$31=, ld3+24($pop86)
	i32.const	$push85=, 0
	i64.load	$32=, ld4($pop85):p2align=4
	i32.const	$push84=, 0
	i64.load	$33=, ld4+8($pop84)
	i32.const	$push83=, 0
	i64.load	$34=, ld4+16($pop83):p2align=4
	i32.const	$push82=, 0
	i64.load	$35=, ld4+24($pop82)
	i32.const	$push81=, 0
	i64.load	$36=, ld5($pop81):p2align=4
	i32.const	$push80=, 0
	i64.load	$37=, ld5+8($pop80)
	i32.const	$push79=, 0
	i64.load	$38=, ld5+16($pop79):p2align=4
	i32.const	$push78=, 0
	i64.load	$39=, ld5+24($pop78)
	i64.store	$discard=, 424($77), $21
	i64.store	$discard=, 416($77):p2align=4, $20
	i32.const	$push22=, 24
	i32.const	$60=, 416
	i32.add 	$60=, $77, $60
	i32.add 	$push77=, $60, $pop22
	tee_local	$push76=, $44=, $pop77
	i64.store	$discard=, 0($pop76), $23
	i64.store	$discard=, 432($77):p2align=4, $22
	i64.store	$discard=, 392($77), $25
	i64.store	$discard=, 384($77):p2align=4, $24
	i32.const	$push75=, 24
	i32.const	$61=, 384
	i32.add 	$61=, $77, $61
	i32.add 	$push74=, $61, $pop75
	tee_local	$push73=, $43=, $pop74
	i64.store	$discard=, 0($pop73), $27
	i64.store	$discard=, 400($77):p2align=4, $26
	i64.store	$discard=, 360($77), $29
	i64.store	$discard=, 352($77):p2align=4, $28
	i32.const	$push72=, 24
	i32.const	$62=, 352
	i32.add 	$62=, $77, $62
	i32.add 	$push71=, $62, $pop72
	tee_local	$push70=, $42=, $pop71
	i64.store	$discard=, 0($pop70), $31
	i64.store	$discard=, 368($77):p2align=4, $30
	i64.store	$discard=, 328($77), $33
	i64.store	$discard=, 320($77):p2align=4, $32
	i32.const	$push69=, 24
	i32.const	$63=, 320
	i32.add 	$63=, $77, $63
	i32.add 	$push68=, $63, $pop69
	tee_local	$push67=, $41=, $pop68
	i64.store	$discard=, 0($pop67), $35
	i64.store	$discard=, 336($77):p2align=4, $34
	i64.store	$discard=, 296($77), $37
	i64.store	$discard=, 288($77):p2align=4, $36
	i32.const	$push66=, 24
	i32.const	$64=, 288
	i32.add 	$64=, $77, $64
	i32.add 	$push65=, $64, $pop66
	tee_local	$push64=, $40=, $pop65
	i64.store	$discard=, 0($pop64), $39
	i64.store	$discard=, 304($77):p2align=4, $38
	i32.const	$push63=, 24
	i32.const	$65=, 128
	i32.add 	$65=, $77, $65
	i32.add 	$push23=, $65, $pop63
	i64.load	$push24=, 0($44)
	i64.store	$discard=, 0($pop23), $pop24
	i32.const	$push25=, 16
	i32.const	$66=, 128
	i32.add 	$66=, $77, $66
	i32.add 	$push26=, $66, $pop25
	i64.load	$push27=, 432($77):p2align=4
	i64.store	$discard=, 0($pop26):p2align=4, $pop27
	i64.load	$push28=, 424($77)
	i64.store	$discard=, 136($77), $pop28
	i64.load	$push29=, 416($77):p2align=4
	i64.store	$discard=, 128($77):p2align=4, $pop29
	i32.const	$push62=, 24
	i32.const	$67=, 96
	i32.add 	$67=, $77, $67
	i32.add 	$push30=, $67, $pop62
	i64.load	$push31=, 0($43)
	i64.store	$discard=, 0($pop30), $pop31
	i32.const	$push61=, 16
	i32.const	$68=, 96
	i32.add 	$68=, $77, $68
	i32.add 	$push32=, $68, $pop61
	i64.load	$push33=, 400($77):p2align=4
	i64.store	$discard=, 0($pop32):p2align=4, $pop33
	i64.load	$push34=, 392($77)
	i64.store	$discard=, 104($77), $pop34
	i64.load	$push35=, 384($77):p2align=4
	i64.store	$discard=, 96($77):p2align=4, $pop35
	i32.const	$push60=, 24
	i32.const	$69=, 64
	i32.add 	$69=, $77, $69
	i32.add 	$push36=, $69, $pop60
	i64.load	$push37=, 0($42)
	i64.store	$discard=, 0($pop36), $pop37
	i32.const	$push59=, 16
	i32.const	$70=, 64
	i32.add 	$70=, $77, $70
	i32.add 	$push38=, $70, $pop59
	i64.load	$push39=, 368($77):p2align=4
	i64.store	$discard=, 0($pop38):p2align=4, $pop39
	i64.load	$push40=, 360($77)
	i64.store	$discard=, 72($77), $pop40
	i64.load	$push41=, 352($77):p2align=4
	i64.store	$discard=, 64($77):p2align=4, $pop41
	i32.const	$push58=, 24
	i32.const	$71=, 32
	i32.add 	$71=, $77, $71
	i32.add 	$push42=, $71, $pop58
	i64.load	$push43=, 0($41)
	i64.store	$discard=, 0($pop42), $pop43
	i32.const	$push57=, 16
	i32.const	$72=, 32
	i32.add 	$72=, $77, $72
	i32.add 	$push44=, $72, $pop57
	i64.load	$push45=, 336($77):p2align=4
	i64.store	$discard=, 0($pop44):p2align=4, $pop45
	i64.load	$push46=, 328($77)
	i64.store	$discard=, 40($77), $pop46
	i64.load	$push47=, 320($77):p2align=4
	i64.store	$discard=, 32($77):p2align=4, $pop47
	i32.const	$push56=, 24
	i32.add 	$push48=, $77, $pop56
	i64.load	$push49=, 0($40)
	i64.store	$discard=, 0($pop48), $pop49
	i32.const	$push55=, 16
	i32.add 	$push50=, $77, $pop55
	i64.load	$push51=, 304($77):p2align=4
	i64.store	$discard=, 0($pop50):p2align=4, $pop51
	i64.load	$push52=, 296($77)
	i64.store	$discard=, 8($77), $pop52
	i64.load	$push53=, 288($77):p2align=4
	i64.store	$discard=, 0($77):p2align=4, $pop53
	i32.const	$73=, 128
	i32.add 	$73=, $77, $73
	i32.const	$74=, 96
	i32.add 	$74=, $77, $74
	i32.const	$75=, 64
	i32.add 	$75=, $77, $75
	i32.const	$76=, 32
	i32.add 	$76=, $77, $76
	call    	check_long_double@FUNCTION, $44, $73, $74, $75, $76, $77
	i32.const	$push54=, 0
	call    	exit@FUNCTION, $pop54
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
