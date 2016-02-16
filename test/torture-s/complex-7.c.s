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
	.local  	f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$50=, __stack_pointer
	i32.load	$50=, 0($50)
	i32.const	$51=, 576
	i32.sub 	$98=, $50, $51
	i32.const	$51=, __stack_pointer
	i32.store	$98=, 0($51), $98
	i32.const	$push0=, 0
	f32.load	$0=, f1($pop0)
	i32.const	$push155=, 0
	f32.load	$1=, f1+4($pop155)
	i32.const	$push154=, 0
	f32.load	$2=, f2($pop154)
	i32.const	$push153=, 0
	f32.load	$3=, f2+4($pop153)
	i32.const	$push152=, 0
	f32.load	$4=, f3($pop152)
	i32.const	$push151=, 0
	f32.load	$5=, f3+4($pop151)
	i32.const	$push150=, 0
	f32.load	$6=, f4($pop150)
	i32.const	$push149=, 0
	f32.load	$7=, f4+4($pop149)
	i32.const	$push148=, 0
	f32.load	$8=, f5($pop148)
	i32.const	$push147=, 0
	f32.load	$9=, f5+4($pop147)
	f32.store	$discard=, 568($98):p2align=3, $0
	i32.const	$push1=, 4
	i32.const	$52=, 568
	i32.add 	$52=, $98, $52
	i32.or  	$push2=, $52, $pop1
	f32.store	$discard=, 0($pop2), $1
	f32.store	$discard=, 560($98):p2align=3, $2
	i32.const	$push146=, 4
	i32.const	$53=, 560
	i32.add 	$53=, $98, $53
	i32.or  	$push3=, $53, $pop146
	f32.store	$discard=, 0($pop3), $3
	f32.store	$discard=, 552($98):p2align=3, $4
	i32.const	$push145=, 4
	i32.const	$54=, 552
	i32.add 	$54=, $98, $54
	i32.or  	$push4=, $54, $pop145
	f32.store	$discard=, 0($pop4), $5
	f32.store	$discard=, 544($98):p2align=3, $6
	i32.const	$push144=, 4
	i32.const	$55=, 544
	i32.add 	$55=, $98, $55
	i32.or  	$push5=, $55, $pop144
	f32.store	$discard=, 0($pop5), $7
	i32.const	$push143=, 4
	i32.const	$56=, 536
	i32.add 	$56=, $98, $56
	i32.or  	$push6=, $56, $pop143
	f32.store	$discard=, 0($pop6), $9
	f32.store	$discard=, 536($98):p2align=3, $8
	i64.load	$push7=, 568($98)
	i64.store	$discard=, 280($98):p2align=2, $pop7
	i64.load	$push8=, 560($98)
	i64.store	$discard=, 272($98):p2align=2, $pop8
	i64.load	$push9=, 552($98)
	i64.store	$discard=, 264($98):p2align=2, $pop9
	i64.load	$push10=, 544($98)
	i64.store	$discard=, 256($98):p2align=2, $pop10
	i64.load	$push11=, 536($98)
	i64.store	$discard=, 248($98):p2align=2, $pop11
	i32.const	$57=, 280
	i32.add 	$57=, $98, $57
	i32.const	$58=, 272
	i32.add 	$58=, $98, $58
	i32.const	$59=, 264
	i32.add 	$59=, $98, $59
	i32.const	$60=, 256
	i32.add 	$60=, $98, $60
	i32.const	$61=, 248
	i32.add 	$61=, $98, $61
	call    	check_float@FUNCTION, $49, $57, $58, $59, $60, $61
	i32.const	$push142=, 0
	f64.load	$10=, d1($pop142)
	i32.const	$push141=, 0
	f64.load	$11=, d1+8($pop141)
	i32.const	$push140=, 0
	f64.load	$12=, d2($pop140)
	i32.const	$push139=, 0
	f64.load	$13=, d2+8($pop139)
	i32.const	$push138=, 0
	f64.load	$14=, d3($pop138)
	i32.const	$push137=, 0
	f64.load	$15=, d3+8($pop137)
	i32.const	$push136=, 0
	f64.load	$16=, d4($pop136)
	i32.const	$push135=, 0
	f64.load	$17=, d4+8($pop135)
	i32.const	$push134=, 0
	f64.load	$18=, d5($pop134)
	i32.const	$push133=, 0
	f64.load	$19=, d5+8($pop133)
	f64.store	$discard=, 520($98), $10
	f64.store	$discard=, 528($98), $11
	f64.store	$discard=, 504($98), $12
	f64.store	$discard=, 512($98), $13
	f64.store	$discard=, 488($98), $14
	f64.store	$discard=, 496($98), $15
	f64.store	$discard=, 472($98), $16
	f64.store	$discard=, 480($98), $17
	f64.store	$discard=, 456($98), $18
	f64.store	$discard=, 464($98), $19
	i32.const	$push12=, 8
	i32.const	$62=, 232
	i32.add 	$62=, $98, $62
	i32.add 	$push13=, $62, $pop12
	i64.load	$push14=, 528($98)
	i64.store	$discard=, 0($pop13), $pop14
	i64.load	$push15=, 520($98)
	i64.store	$discard=, 232($98), $pop15
	i32.const	$push132=, 8
	i32.const	$63=, 216
	i32.add 	$63=, $98, $63
	i32.add 	$push16=, $63, $pop132
	i64.load	$push17=, 512($98)
	i64.store	$discard=, 0($pop16), $pop17
	i64.load	$push18=, 504($98)
	i64.store	$discard=, 216($98), $pop18
	i32.const	$push131=, 8
	i32.const	$64=, 200
	i32.add 	$64=, $98, $64
	i32.add 	$push19=, $64, $pop131
	i64.load	$push20=, 496($98)
	i64.store	$discard=, 0($pop19), $pop20
	i64.load	$push21=, 488($98)
	i64.store	$discard=, 200($98), $pop21
	i32.const	$push130=, 8
	i32.const	$65=, 184
	i32.add 	$65=, $98, $65
	i32.add 	$push22=, $65, $pop130
	i64.load	$push23=, 480($98)
	i64.store	$discard=, 0($pop22), $pop23
	i64.load	$push24=, 472($98)
	i64.store	$discard=, 184($98), $pop24
	i32.const	$push129=, 8
	i32.const	$66=, 168
	i32.add 	$66=, $98, $66
	i32.add 	$push25=, $66, $pop129
	i64.load	$push26=, 464($98)
	i64.store	$discard=, 0($pop25), $pop26
	i64.load	$push27=, 456($98)
	i64.store	$discard=, 168($98), $pop27
	i32.const	$67=, 232
	i32.add 	$67=, $98, $67
	i32.const	$68=, 216
	i32.add 	$68=, $98, $68
	i32.const	$69=, 200
	i32.add 	$69=, $98, $69
	i32.const	$70=, 184
	i32.add 	$70=, $98, $70
	i32.const	$71=, 168
	i32.add 	$71=, $98, $71
	call    	check_double@FUNCTION, $49, $67, $68, $69, $70, $71
	i32.const	$push128=, 0
	i64.load	$20=, ld1($pop128):p2align=4
	i32.const	$push127=, 0
	i64.load	$21=, ld1+8($pop127)
	i32.const	$push126=, 0
	i64.load	$22=, ld1+16($pop126):p2align=4
	i32.const	$push125=, 0
	i64.load	$23=, ld1+24($pop125)
	i32.const	$push124=, 0
	i64.load	$24=, ld2($pop124):p2align=4
	i32.const	$push123=, 0
	i64.load	$25=, ld2+8($pop123)
	i32.const	$push122=, 0
	i64.load	$26=, ld2+16($pop122):p2align=4
	i32.const	$push121=, 0
	i64.load	$27=, ld2+24($pop121)
	i32.const	$push120=, 0
	i64.load	$28=, ld3($pop120):p2align=4
	i32.const	$push119=, 0
	i64.load	$29=, ld3+8($pop119)
	i32.const	$push118=, 0
	i64.load	$30=, ld3+16($pop118):p2align=4
	i32.const	$push117=, 0
	i64.load	$31=, ld3+24($pop117)
	i32.const	$push116=, 0
	i64.load	$32=, ld4($pop116):p2align=4
	i32.const	$push115=, 0
	i64.load	$33=, ld4+8($pop115)
	i32.const	$push114=, 0
	i64.load	$34=, ld4+16($pop114):p2align=4
	i32.const	$push113=, 0
	i64.load	$35=, ld4+24($pop113)
	i32.const	$push112=, 0
	i64.load	$36=, ld5($pop112):p2align=4
	i32.const	$push111=, 0
	i64.load	$37=, ld5+8($pop111)
	i32.const	$push110=, 0
	i64.load	$38=, ld5+16($pop110):p2align=4
	i32.const	$push109=, 0
	i64.load	$39=, ld5+24($pop109)
	i32.const	$push108=, 8
	i32.const	$72=, 416
	i32.add 	$72=, $98, $72
	i32.or  	$push107=, $72, $pop108
	tee_local	$push106=, $49=, $pop107
	i64.store	$discard=, 0($pop106), $21
	i64.store	$discard=, 416($98):p2align=4, $20
	i32.const	$push28=, 24
	i32.const	$73=, 416
	i32.add 	$73=, $98, $73
	i32.add 	$push105=, $73, $pop28
	tee_local	$push104=, $48=, $pop105
	i64.store	$discard=, 0($pop104), $23
	i64.store	$discard=, 432($98):p2align=4, $22
	i32.const	$push103=, 8
	i32.const	$74=, 384
	i32.add 	$74=, $98, $74
	i32.or  	$push102=, $74, $pop103
	tee_local	$push101=, $47=, $pop102
	i64.store	$discard=, 0($pop101), $25
	i64.store	$discard=, 384($98):p2align=4, $24
	i32.const	$push100=, 24
	i32.const	$75=, 384
	i32.add 	$75=, $98, $75
	i32.add 	$push99=, $75, $pop100
	tee_local	$push98=, $46=, $pop99
	i64.store	$discard=, 0($pop98), $27
	i64.store	$discard=, 400($98):p2align=4, $26
	i32.const	$push97=, 8
	i32.const	$76=, 352
	i32.add 	$76=, $98, $76
	i32.or  	$push96=, $76, $pop97
	tee_local	$push95=, $45=, $pop96
	i64.store	$discard=, 0($pop95), $29
	i64.store	$discard=, 352($98):p2align=4, $28
	i32.const	$push94=, 24
	i32.const	$77=, 352
	i32.add 	$77=, $98, $77
	i32.add 	$push93=, $77, $pop94
	tee_local	$push92=, $44=, $pop93
	i64.store	$discard=, 0($pop92), $31
	i64.store	$discard=, 368($98):p2align=4, $30
	i32.const	$push91=, 8
	i32.const	$78=, 320
	i32.add 	$78=, $98, $78
	i32.or  	$push90=, $78, $pop91
	tee_local	$push89=, $43=, $pop90
	i64.store	$discard=, 0($pop89), $33
	i64.store	$discard=, 320($98):p2align=4, $32
	i32.const	$push88=, 24
	i32.const	$79=, 320
	i32.add 	$79=, $98, $79
	i32.add 	$push87=, $79, $pop88
	tee_local	$push86=, $42=, $pop87
	i64.store	$discard=, 0($pop86), $35
	i64.store	$discard=, 336($98):p2align=4, $34
	i32.const	$push85=, 8
	i32.const	$80=, 288
	i32.add 	$80=, $98, $80
	i32.or  	$push84=, $80, $pop85
	tee_local	$push83=, $41=, $pop84
	i64.store	$discard=, 0($pop83), $37
	i64.store	$discard=, 288($98):p2align=4, $36
	i32.const	$push82=, 24
	i32.const	$81=, 288
	i32.add 	$81=, $98, $81
	i32.add 	$push81=, $81, $pop82
	tee_local	$push80=, $40=, $pop81
	i64.store	$discard=, 0($pop80), $39
	i64.store	$discard=, 304($98):p2align=4, $38
	i32.const	$push79=, 24
	i32.const	$82=, 128
	i32.add 	$82=, $98, $82
	i32.add 	$push29=, $82, $pop79
	i64.load	$push30=, 0($48)
	i64.store	$discard=, 0($pop29), $pop30
	i32.const	$push31=, 16
	i32.const	$83=, 128
	i32.add 	$83=, $98, $83
	i32.add 	$push32=, $83, $pop31
	i64.load	$push33=, 432($98):p2align=4
	i64.store	$discard=, 0($pop32):p2align=4, $pop33
	i32.const	$push78=, 8
	i32.const	$84=, 128
	i32.add 	$84=, $98, $84
	i32.or  	$push34=, $84, $pop78
	i64.load	$push35=, 0($49)
	i64.store	$discard=, 0($pop34), $pop35
	i64.load	$push36=, 416($98):p2align=4
	i64.store	$discard=, 128($98):p2align=4, $pop36
	i32.const	$push77=, 24
	i32.const	$85=, 96
	i32.add 	$85=, $98, $85
	i32.add 	$push37=, $85, $pop77
	i64.load	$push38=, 0($46)
	i64.store	$discard=, 0($pop37), $pop38
	i32.const	$push76=, 16
	i32.const	$86=, 96
	i32.add 	$86=, $98, $86
	i32.add 	$push39=, $86, $pop76
	i64.load	$push40=, 400($98):p2align=4
	i64.store	$discard=, 0($pop39):p2align=4, $pop40
	i32.const	$push75=, 8
	i32.const	$87=, 96
	i32.add 	$87=, $98, $87
	i32.or  	$push41=, $87, $pop75
	i64.load	$push42=, 0($47)
	i64.store	$discard=, 0($pop41), $pop42
	i64.load	$push43=, 384($98):p2align=4
	i64.store	$discard=, 96($98):p2align=4, $pop43
	i32.const	$push74=, 24
	i32.const	$88=, 64
	i32.add 	$88=, $98, $88
	i32.add 	$push44=, $88, $pop74
	i64.load	$push45=, 0($44)
	i64.store	$discard=, 0($pop44), $pop45
	i32.const	$push73=, 16
	i32.const	$89=, 64
	i32.add 	$89=, $98, $89
	i32.add 	$push46=, $89, $pop73
	i64.load	$push47=, 368($98):p2align=4
	i64.store	$discard=, 0($pop46):p2align=4, $pop47
	i32.const	$push72=, 8
	i32.const	$90=, 64
	i32.add 	$90=, $98, $90
	i32.or  	$push48=, $90, $pop72
	i64.load	$push49=, 0($45)
	i64.store	$discard=, 0($pop48), $pop49
	i64.load	$push50=, 352($98):p2align=4
	i64.store	$discard=, 64($98):p2align=4, $pop50
	i32.const	$push71=, 24
	i32.const	$91=, 32
	i32.add 	$91=, $98, $91
	i32.add 	$push51=, $91, $pop71
	i64.load	$push52=, 0($42)
	i64.store	$discard=, 0($pop51), $pop52
	i32.const	$push70=, 16
	i32.const	$92=, 32
	i32.add 	$92=, $98, $92
	i32.add 	$push53=, $92, $pop70
	i64.load	$push54=, 336($98):p2align=4
	i64.store	$discard=, 0($pop53):p2align=4, $pop54
	i32.const	$push69=, 8
	i32.const	$93=, 32
	i32.add 	$93=, $98, $93
	i32.or  	$push55=, $93, $pop69
	i64.load	$push56=, 0($43)
	i64.store	$discard=, 0($pop55), $pop56
	i64.load	$push57=, 320($98):p2align=4
	i64.store	$discard=, 32($98):p2align=4, $pop57
	i32.const	$push68=, 24
	i32.add 	$push58=, $98, $pop68
	i64.load	$push59=, 0($40)
	i64.store	$discard=, 0($pop58), $pop59
	i32.const	$push67=, 16
	i32.add 	$push60=, $98, $pop67
	i64.load	$push61=, 304($98):p2align=4
	i64.store	$discard=, 0($pop60):p2align=4, $pop61
	i32.const	$push66=, 8
	i32.or  	$push62=, $98, $pop66
	i64.load	$push63=, 0($41)
	i64.store	$discard=, 0($pop62), $pop63
	i64.load	$push64=, 288($98):p2align=4
	i64.store	$discard=, 0($98):p2align=4, $pop64
	i32.const	$94=, 128
	i32.add 	$94=, $98, $94
	i32.const	$95=, 96
	i32.add 	$95=, $98, $95
	i32.const	$96=, 64
	i32.add 	$96=, $98, $96
	i32.const	$97=, 32
	i32.add 	$97=, $98, $97
	call    	check_long_double@FUNCTION, $49, $94, $95, $96, $97, $98
	i32.const	$push65=, 0
	call    	exit@FUNCTION, $pop65
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
