	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040709-1.c"
	.section	.text.myrnd,"ax",@progbits
	.hidden	myrnd
	.globl	myrnd
	.type	myrnd,@function
myrnd:                                  # @myrnd
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push11=, 0
	i32.load	$push1=, myrnd.s($pop11)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push5=, $pop3, $pop4
	i32.store	$push6=, myrnd.s($pop0), $pop5
	i32.const	$push7=, 16
	i32.shr_u	$push8=, $pop6, $pop7
	i32.const	$push9=, 2047
	i32.and 	$push10=, $pop8, $pop9
	return  	$pop10
	.endfunc
.Lfunc_end0:
	.size	myrnd, .Lfunc_end0-myrnd

	.section	.text.retmeA,"ax",@progbits
	.hidden	retmeA
	.globl	retmeA
	.type	retmeA,@function
retmeA:                                 # @retmeA
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($1)
	i32.store	$discard=, 0($0), $pop0
	return
	.endfunc
.Lfunc_end1:
	.size	retmeA, .Lfunc_end1-retmeA

	.section	.text.fn1A,"ax",@progbits
	.hidden	fn1A
	.globl	fn1A
	.type	fn1A,@function
fn1A:                                   # @fn1A
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sA($pop0)
	i32.const	$push2=, 17
	i32.shl 	$push3=, $0, $pop2
	i32.add 	$push4=, $pop1, $pop3
	i32.const	$push6=, 17
	i32.shr_u	$push5=, $pop4, $pop6
	return  	$pop5
	.endfunc
.Lfunc_end2:
	.size	fn1A, .Lfunc_end2-fn1A

	.section	.text.fn2A,"ax",@progbits
	.hidden	fn2A
	.globl	fn2A
	.type	fn2A,@function
fn2A:                                   # @fn2A
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sA($pop0)
	i32.const	$push2=, 17
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 32767
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push7=, 15
	i32.rem_u	$push8=, $pop6, $pop7
	return  	$pop8
	.endfunc
.Lfunc_end3:
	.size	fn2A, .Lfunc_end3-fn2A

	.section	.text.retitA,"ax",@progbits
	.hidden	retitA
	.globl	retitA
	.type	retitA,@function
retitA:                                 # @retitA
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sA($pop0)
	i32.const	$push2=, 17
	i32.shr_u	$push3=, $pop1, $pop2
	return  	$pop3
	.endfunc
.Lfunc_end4:
	.size	retitA, .Lfunc_end4-retitA

	.section	.text.fn3A,"ax",@progbits
	.hidden	fn3A
	.globl	fn3A
	.type	fn3A,@function
fn3A:                                   # @fn3A
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push8=, 0
	i32.load	$push1=, sA($pop8)
	i32.const	$push2=, 17
	i32.shl 	$push3=, $0, $pop2
	i32.add 	$push4=, $pop1, $pop3
	i32.store	$push5=, sA($pop0), $pop4
	i32.const	$push7=, 17
	i32.shr_u	$push6=, $pop5, $pop7
	return  	$pop6
	.endfunc
.Lfunc_end5:
	.size	fn3A, .Lfunc_end5-fn3A

	.section	.text.testA,"ax",@progbits
	.hidden	testA
	.globl	testA
	.type	testA,@function
testA:                                  # @testA
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push95=, 0
	i32.const	$push94=, 0
	i32.load	$push5=, myrnd.s($pop94)
	i32.const	$push93=, 1103515245
	i32.mul 	$push6=, $pop5, $pop93
	i32.const	$push92=, 12345
	i32.add 	$push7=, $pop6, $pop92
	tee_local	$push91=, $2=, $pop7
	i32.const	$push90=, 16
	i32.shr_u	$push8=, $pop91, $pop90
	i32.store8	$discard=, sA($pop95):p2align=2, $pop8
	i32.const	$push89=, 0
	i32.const	$push88=, 1103515245
	i32.mul 	$push9=, $2, $pop88
	i32.const	$push87=, 12345
	i32.add 	$push10=, $pop9, $pop87
	tee_local	$push86=, $2=, $pop10
	i32.const	$push85=, 16
	i32.shr_u	$push11=, $pop86, $pop85
	i32.store8	$discard=, sA+1($pop89), $pop11
	i32.const	$push84=, 0
	i32.const	$push83=, 1103515245
	i32.mul 	$push12=, $2, $pop83
	i32.const	$push82=, 12345
	i32.add 	$push13=, $pop12, $pop82
	tee_local	$push81=, $2=, $pop13
	i32.const	$push80=, 16
	i32.shr_u	$push14=, $pop81, $pop80
	i32.store8	$discard=, sA+2($pop84):p2align=1, $pop14
	i32.const	$push79=, 0
	i32.const	$push78=, 1103515245
	i32.mul 	$push15=, $2, $pop78
	i32.const	$push77=, 12345
	i32.add 	$push16=, $pop15, $pop77
	tee_local	$push76=, $2=, $pop16
	i32.const	$push75=, 16
	i32.shr_u	$push17=, $pop76, $pop75
	i32.store8	$discard=, sA+3($pop79), $pop17
	block
	i32.const	$push74=, 0
	i32.const	$push73=, 1103515245
	i32.mul 	$push18=, $2, $pop73
	i32.const	$push72=, 12345
	i32.add 	$push19=, $pop18, $pop72
	tee_local	$push71=, $2=, $pop19
	i32.const	$push70=, 1103515245
	i32.mul 	$push22=, $pop71, $pop70
	i32.const	$push69=, 12345
	i32.add 	$push1=, $pop22, $pop69
	i32.store	$push23=, myrnd.s($pop74), $pop1
	tee_local	$push68=, $1=, $pop23
	i32.const	$push67=, 16
	i32.shr_u	$push24=, $pop68, $pop67
	i32.const	$push66=, 2047
	i32.and 	$push25=, $pop24, $pop66
	tee_local	$push65=, $0=, $pop25
	i32.const	$push64=, 16
	i32.shr_u	$push20=, $2, $pop64
	i32.const	$push63=, 2047
	i32.and 	$push21=, $pop20, $pop63
	tee_local	$push62=, $2=, $pop21
	i32.add 	$push33=, $pop65, $pop62
	i32.const	$push61=, 17
	i32.shl 	$push30=, $0, $pop61
	i32.const	$push60=, 0
	i32.const	$push59=, 17
	i32.shl 	$push26=, $2, $pop59
	i32.const	$push58=, 0
	i32.load	$push0=, sA($pop58)
	tee_local	$push57=, $2=, $pop0
	i32.const	$push56=, 131071
	i32.and 	$push27=, $pop57, $pop56
	tee_local	$push55=, $0=, $pop27
	i32.or  	$push28=, $pop26, $pop55
	i32.store	$push29=, sA($pop60), $pop28
	i32.add 	$push31=, $pop30, $pop29
	i32.const	$push54=, 17
	i32.shr_u	$push32=, $pop31, $pop54
	i32.ne  	$push34=, $pop33, $pop32
	br_if   	0, $pop34       # 0: down to label0
# BB#1:                                 # %if.end87
	block
	i32.const	$push110=, 0
	i32.const	$push109=, 0
	i32.const	$push35=, -2139243339
	i32.mul 	$push36=, $1, $pop35
	i32.const	$push37=, -1492899873
	i32.add 	$push38=, $pop36, $pop37
	tee_local	$push108=, $1=, $pop38
	i32.const	$push107=, 1103515245
	i32.mul 	$push40=, $pop108, $pop107
	i32.const	$push106=, 12345
	i32.add 	$push41=, $pop40, $pop106
	i32.store	$push42=, myrnd.s($pop109), $pop41
	i32.const	$push105=, 16
	i32.shr_u	$push43=, $pop42, $pop105
	i32.const	$push104=, 2047
	i32.and 	$push3=, $pop43, $pop104
	tee_local	$push103=, $3=, $pop3
	i32.const	$push102=, 17
	i32.shl 	$push46=, $pop103, $pop102
	i32.const	$push101=, 16
	i32.shr_u	$push39=, $1, $pop101
	i32.const	$push100=, 2047
	i32.and 	$push2=, $pop39, $pop100
	tee_local	$push99=, $1=, $pop2
	i32.const	$push98=, 17
	i32.shl 	$push44=, $pop99, $pop98
	i32.or  	$push45=, $pop44, $0
	i32.add 	$push4=, $pop46, $pop45
	i32.store	$push47=, sA($pop110), $pop4
	tee_local	$push97=, $0=, $pop47
	i32.xor 	$push48=, $pop97, $2
	i32.const	$push96=, 131071
	i32.and 	$push49=, $pop48, $pop96
	br_if   	0, $pop49       # 0: down to label1
# BB#2:                                 # %lor.lhs.false125
	i32.add 	$push52=, $3, $1
	i32.const	$push50=, 17
	i32.shr_u	$push51=, $0, $pop50
	i32.ne  	$push53=, $pop52, $pop51
	br_if   	0, $pop53       # 0: down to label1
# BB#3:                                 # %if.end131
	return
.LBB6_4:                                # %if.then130
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB6_5:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end6:
	.size	testA, .Lfunc_end6-testA

	.section	.text.retmeB,"ax",@progbits
	.hidden	retmeB
	.globl	retmeB
	.type	retmeB,@function
retmeB:                                 # @retmeB
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1):p2align=2
	i64.store	$discard=, 0($0):p2align=2, $pop0
	return
	.endfunc
.Lfunc_end7:
	.size	retmeB, .Lfunc_end7-retmeB

	.section	.text.fn1B,"ax",@progbits
	.hidden	fn1B
	.globl	fn1B
	.type	fn1B,@function
fn1B:                                   # @fn1B
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sB($pop0):p2align=3
	i32.const	$push2=, 17
	i32.shl 	$push3=, $0, $pop2
	i32.add 	$push4=, $pop1, $pop3
	i32.const	$push6=, 17
	i32.shr_u	$push5=, $pop4, $pop6
	return  	$pop5
	.endfunc
.Lfunc_end8:
	.size	fn1B, .Lfunc_end8-fn1B

	.section	.text.fn2B,"ax",@progbits
	.hidden	fn2B
	.globl	fn2B
	.type	fn2B,@function
fn2B:                                   # @fn2B
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sB($pop0):p2align=3
	i32.const	$push2=, 17
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 32767
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push7=, 15
	i32.rem_u	$push8=, $pop6, $pop7
	return  	$pop8
	.endfunc
.Lfunc_end9:
	.size	fn2B, .Lfunc_end9-fn2B

	.section	.text.retitB,"ax",@progbits
	.hidden	retitB
	.globl	retitB
	.type	retitB,@function
retitB:                                 # @retitB
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sB($pop0):p2align=3
	i32.const	$push2=, 17
	i32.shr_u	$push3=, $pop1, $pop2
	return  	$pop3
	.endfunc
.Lfunc_end10:
	.size	retitB, .Lfunc_end10-retitB

	.section	.text.fn3B,"ax",@progbits
	.hidden	fn3B
	.globl	fn3B
	.type	fn3B,@function
fn3B:                                   # @fn3B
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push8=, 0
	i32.load	$push1=, sB($pop8):p2align=3
	i32.const	$push2=, 17
	i32.shl 	$push3=, $0, $pop2
	i32.add 	$push4=, $pop1, $pop3
	i32.store	$push5=, sB($pop0):p2align=3, $pop4
	i32.const	$push7=, 17
	i32.shr_u	$push6=, $pop5, $pop7
	return  	$pop6
	.endfunc
.Lfunc_end11:
	.size	fn3B, .Lfunc_end11-fn3B

	.section	.text.testB,"ax",@progbits
	.hidden	testB
	.globl	testB
	.type	testB,@function
testB:                                  # @testB
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push136=, 0
	i32.const	$push135=, 0
	i32.load	$push6=, myrnd.s($pop135)
	i32.const	$push134=, 1103515245
	i32.mul 	$push7=, $pop6, $pop134
	i32.const	$push133=, 12345
	i32.add 	$push8=, $pop7, $pop133
	tee_local	$push132=, $3=, $pop8
	i32.const	$push131=, 16
	i32.shr_u	$push9=, $pop132, $pop131
	i32.store8	$discard=, sB($pop136):p2align=3, $pop9
	i32.const	$push130=, 0
	i32.const	$push129=, 1103515245
	i32.mul 	$push10=, $3, $pop129
	i32.const	$push128=, 12345
	i32.add 	$push11=, $pop10, $pop128
	tee_local	$push127=, $3=, $pop11
	i32.const	$push126=, 16
	i32.shr_u	$push12=, $pop127, $pop126
	i32.store8	$discard=, sB+1($pop130), $pop12
	i32.const	$push125=, 0
	i32.const	$push124=, 1103515245
	i32.mul 	$push13=, $3, $pop124
	i32.const	$push123=, 12345
	i32.add 	$push14=, $pop13, $pop123
	tee_local	$push122=, $3=, $pop14
	i32.const	$push121=, 16
	i32.shr_u	$push15=, $pop122, $pop121
	i32.store8	$discard=, sB+2($pop125):p2align=1, $pop15
	i32.const	$push120=, 0
	i32.const	$push119=, 1103515245
	i32.mul 	$push16=, $3, $pop119
	i32.const	$push118=, 12345
	i32.add 	$push17=, $pop16, $pop118
	tee_local	$push117=, $3=, $pop17
	i32.const	$push116=, 16
	i32.shr_u	$push18=, $pop117, $pop116
	i32.store8	$discard=, sB+3($pop120), $pop18
	i32.const	$push115=, 0
	i32.const	$push114=, 1103515245
	i32.mul 	$push19=, $3, $pop114
	i32.const	$push113=, 12345
	i32.add 	$push20=, $pop19, $pop113
	tee_local	$push112=, $3=, $pop20
	i32.const	$push111=, 16
	i32.shr_u	$push21=, $pop112, $pop111
	i32.store8	$discard=, sB+4($pop115):p2align=2, $pop21
	i32.const	$push110=, 0
	i32.const	$push109=, 1103515245
	i32.mul 	$push22=, $3, $pop109
	i32.const	$push108=, 12345
	i32.add 	$push23=, $pop22, $pop108
	tee_local	$push107=, $3=, $pop23
	i32.const	$push106=, 16
	i32.shr_u	$push24=, $pop107, $pop106
	i32.store8	$discard=, sB+5($pop110), $pop24
	i32.const	$push105=, 0
	i32.const	$push104=, 1103515245
	i32.mul 	$push25=, $3, $pop104
	i32.const	$push103=, 12345
	i32.add 	$push26=, $pop25, $pop103
	tee_local	$push102=, $3=, $pop26
	i32.const	$push101=, 16
	i32.shr_u	$push27=, $pop102, $pop101
	i32.store8	$discard=, sB+6($pop105):p2align=1, $pop27
	i32.const	$push100=, 0
	i32.const	$push99=, 1103515245
	i32.mul 	$push28=, $3, $pop99
	i32.const	$push98=, 12345
	i32.add 	$push29=, $pop28, $pop98
	tee_local	$push97=, $3=, $pop29
	i32.const	$push96=, 16
	i32.shr_u	$push30=, $pop97, $pop96
	i32.store8	$discard=, sB+7($pop100), $pop30
	i32.const	$push95=, 0
	i32.load	$0=, sB($pop95):p2align=3
	block
	i32.const	$push94=, 0
	i32.const	$push93=, 1103515245
	i32.mul 	$push31=, $3, $pop93
	i32.const	$push92=, 12345
	i32.add 	$push32=, $pop31, $pop92
	tee_local	$push91=, $3=, $pop32
	i32.const	$push90=, 1103515245
	i32.mul 	$push35=, $pop91, $pop90
	i32.const	$push89=, 12345
	i32.add 	$push0=, $pop35, $pop89
	i32.store	$push36=, myrnd.s($pop94), $pop0
	tee_local	$push88=, $2=, $pop36
	i32.const	$push87=, 16
	i32.shr_u	$push37=, $pop88, $pop87
	i32.const	$push86=, 2047
	i32.and 	$push38=, $pop37, $pop86
	tee_local	$push85=, $1=, $pop38
	i32.const	$push84=, 16
	i32.shr_u	$push33=, $3, $pop84
	i32.const	$push83=, 2047
	i32.and 	$push34=, $pop33, $pop83
	tee_local	$push82=, $3=, $pop34
	i32.add 	$push45=, $pop85, $pop82
	i32.const	$push81=, 17
	i32.shl 	$push42=, $1, $pop81
	i32.const	$push80=, 0
	i32.const	$push79=, 17
	i32.shl 	$push39=, $3, $pop79
	i32.const	$push78=, 131071
	i32.and 	$push40=, $0, $pop78
	i32.or  	$push1=, $pop39, $pop40
	i32.store	$push41=, sB($pop80):p2align=3, $pop1
	tee_local	$push77=, $3=, $pop41
	i32.add 	$push43=, $pop42, $pop77
	i32.const	$push76=, 17
	i32.shr_u	$push44=, $pop43, $pop76
	i32.ne  	$push46=, $pop45, $pop44
	br_if   	0, $pop46       # 0: down to label2
# BB#1:                                 # %if.end76
	block
	i32.const	$push156=, 0
	i32.const	$push155=, 0
	i32.const	$push154=, 1103515245
	i32.mul 	$push47=, $2, $pop154
	i32.const	$push153=, 12345
	i32.add 	$push48=, $pop47, $pop153
	tee_local	$push152=, $0=, $pop48
	i32.const	$push55=, -1029531031
	i32.mul 	$push56=, $pop152, $pop55
	i32.const	$push57=, -740551042
	i32.add 	$push58=, $pop56, $pop57
	tee_local	$push151=, $1=, $pop58
	i32.const	$push150=, 1103515245
	i32.mul 	$push60=, $pop151, $pop150
	i32.const	$push149=, 12345
	i32.add 	$push61=, $pop60, $pop149
	i32.store	$push62=, myrnd.s($pop155), $pop61
	i32.const	$push148=, 16
	i32.shr_u	$push63=, $pop62, $pop148
	i32.const	$push147=, 2047
	i32.and 	$push3=, $pop63, $pop147
	tee_local	$push146=, $2=, $pop3
	i32.const	$push145=, 17
	i32.shl 	$push66=, $pop146, $pop145
	i32.const	$push144=, 16
	i32.shr_u	$push59=, $1, $pop144
	i32.const	$push143=, 2047
	i32.and 	$push2=, $pop59, $pop143
	tee_local	$push142=, $1=, $pop2
	i32.const	$push141=, 17
	i32.shl 	$push64=, $pop142, $pop141
	i32.const	$push140=, 131071
	i32.and 	$push53=, $3, $pop140
	tee_local	$push139=, $3=, $pop53
	i32.or  	$push65=, $pop64, $pop139
	i32.add 	$push4=, $pop66, $pop65
	i32.store	$push67=, sB($pop156):p2align=3, $pop4
	tee_local	$push138=, $4=, $pop67
	i32.const	$push49=, 1
	i32.shl 	$push50=, $0, $pop49
	i32.const	$push51=, 268304384
	i32.and 	$push52=, $pop50, $pop51
	i32.or  	$push54=, $pop52, $3
	i32.xor 	$push5=, $pop138, $pop54
	tee_local	$push137=, $3=, $pop5
	i32.const	$push68=, 63
	i32.and 	$push69=, $pop137, $pop68
	br_if   	0, $pop69       # 0: down to label3
# BB#2:                                 # %lor.lhs.false91
	i32.add 	$push74=, $2, $1
	i32.const	$push71=, 17
	i32.shr_u	$push72=, $4, $pop71
	i32.ne  	$push75=, $pop74, $pop72
	br_if   	0, $pop75       # 0: down to label3
# BB#3:                                 # %lor.lhs.false91
	i32.const	$push73=, 131008
	i32.and 	$push70=, $3, $pop73
	br_if   	0, $pop70       # 0: down to label3
# BB#4:                                 # %if.end115
	return
.LBB12_5:                               # %if.then114
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB12_6:                               # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end12:
	.size	testB, .Lfunc_end12-testB

	.section	.text.retmeC,"ax",@progbits
	.hidden	retmeC
	.globl	retmeC
	.type	retmeC,@function
retmeC:                                 # @retmeC
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1):p2align=2
	i64.store	$discard=, 0($0):p2align=2, $pop0
	return
	.endfunc
.Lfunc_end13:
	.size	retmeC, .Lfunc_end13-retmeC

	.section	.text.fn1C,"ax",@progbits
	.hidden	fn1C
	.globl	fn1C
	.type	fn1C,@function
fn1C:                                   # @fn1C
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sC+4($pop0)
	i32.const	$push2=, 17
	i32.shl 	$push3=, $0, $pop2
	i32.add 	$push4=, $pop1, $pop3
	i32.const	$push6=, 17
	i32.shr_u	$push5=, $pop4, $pop6
	return  	$pop5
	.endfunc
.Lfunc_end14:
	.size	fn1C, .Lfunc_end14-fn1C

	.section	.text.fn2C,"ax",@progbits
	.hidden	fn2C
	.globl	fn2C
	.type	fn2C,@function
fn2C:                                   # @fn2C
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sC+4($pop0)
	i32.const	$push2=, 17
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 32767
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push7=, 15
	i32.rem_u	$push8=, $pop6, $pop7
	return  	$pop8
	.endfunc
.Lfunc_end15:
	.size	fn2C, .Lfunc_end15-fn2C

	.section	.text.retitC,"ax",@progbits
	.hidden	retitC
	.globl	retitC
	.type	retitC,@function
retitC:                                 # @retitC
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sC+4($pop0)
	i32.const	$push2=, 17
	i32.shr_u	$push3=, $pop1, $pop2
	return  	$pop3
	.endfunc
.Lfunc_end16:
	.size	retitC, .Lfunc_end16-retitC

	.section	.text.fn3C,"ax",@progbits
	.hidden	fn3C
	.globl	fn3C
	.type	fn3C,@function
fn3C:                                   # @fn3C
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push8=, 0
	i32.load	$push1=, sC+4($pop8)
	i32.const	$push2=, 17
	i32.shl 	$push3=, $0, $pop2
	i32.add 	$push4=, $pop1, $pop3
	i32.store	$push5=, sC+4($pop0), $pop4
	i32.const	$push7=, 17
	i32.shr_u	$push6=, $pop5, $pop7
	return  	$pop6
	.endfunc
.Lfunc_end17:
	.size	fn3C, .Lfunc_end17-fn3C

	.section	.text.testC,"ax",@progbits
	.hidden	testC
	.globl	testC
	.type	testC,@function
testC:                                  # @testC
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push135=, 0
	i32.const	$push134=, 0
	i32.load	$push5=, myrnd.s($pop134)
	i32.const	$push133=, 1103515245
	i32.mul 	$push6=, $pop5, $pop133
	i32.const	$push132=, 12345
	i32.add 	$push7=, $pop6, $pop132
	tee_local	$push131=, $1=, $pop7
	i32.const	$push130=, 16
	i32.shr_u	$push8=, $pop131, $pop130
	i32.store8	$discard=, sC($pop135):p2align=3, $pop8
	i32.const	$push129=, 0
	i32.const	$push128=, 1103515245
	i32.mul 	$push9=, $1, $pop128
	i32.const	$push127=, 12345
	i32.add 	$push10=, $pop9, $pop127
	tee_local	$push126=, $1=, $pop10
	i32.const	$push125=, 16
	i32.shr_u	$push11=, $pop126, $pop125
	i32.store8	$discard=, sC+1($pop129), $pop11
	i32.const	$push124=, 0
	i32.const	$push123=, 1103515245
	i32.mul 	$push12=, $1, $pop123
	i32.const	$push122=, 12345
	i32.add 	$push13=, $pop12, $pop122
	tee_local	$push121=, $1=, $pop13
	i32.const	$push120=, 16
	i32.shr_u	$push14=, $pop121, $pop120
	i32.store8	$discard=, sC+2($pop124):p2align=1, $pop14
	i32.const	$push119=, 0
	i32.const	$push118=, 1103515245
	i32.mul 	$push15=, $1, $pop118
	i32.const	$push117=, 12345
	i32.add 	$push16=, $pop15, $pop117
	tee_local	$push116=, $1=, $pop16
	i32.const	$push115=, 1103515245
	i32.mul 	$push18=, $pop116, $pop115
	i32.const	$push114=, 12345
	i32.add 	$push19=, $pop18, $pop114
	tee_local	$push113=, $3=, $pop19
	i32.const	$push112=, 16
	i32.shr_u	$push20=, $pop113, $pop112
	i32.store8	$discard=, sC+4($pop119):p2align=2, $pop20
	i32.const	$push111=, 0
	i32.const	$push110=, 1103515245
	i32.mul 	$push21=, $3, $pop110
	i32.const	$push109=, 12345
	i32.add 	$push22=, $pop21, $pop109
	tee_local	$push108=, $3=, $pop22
	i32.const	$push107=, 16
	i32.shr_u	$push23=, $pop108, $pop107
	i32.store8	$discard=, sC+5($pop111), $pop23
	i32.const	$push106=, 0
	i32.const	$push105=, 1103515245
	i32.mul 	$push24=, $3, $pop105
	i32.const	$push104=, 12345
	i32.add 	$push25=, $pop24, $pop104
	tee_local	$push103=, $3=, $pop25
	i32.const	$push102=, 16
	i32.shr_u	$push26=, $pop103, $pop102
	i32.store8	$discard=, sC+6($pop106):p2align=1, $pop26
	i32.const	$push101=, 0
	i32.const	$push100=, 1103515245
	i32.mul 	$push27=, $3, $pop100
	i32.const	$push99=, 12345
	i32.add 	$push28=, $pop27, $pop99
	tee_local	$push98=, $3=, $pop28
	i32.const	$push97=, 16
	i32.shr_u	$push29=, $pop98, $pop97
	i32.store8	$discard=, sC+7($pop101), $pop29
	i32.const	$push96=, 0
	i32.load	$0=, sC+4($pop96)
	i32.const	$push95=, 0
	i32.const	$push94=, 16
	i32.shr_u	$push17=, $1, $pop94
	i32.store8	$discard=, sC+3($pop95), $pop17
	block
	i32.const	$push93=, 0
	i32.const	$push92=, 1103515245
	i32.mul 	$push30=, $3, $pop92
	i32.const	$push91=, 12345
	i32.add 	$push31=, $pop30, $pop91
	tee_local	$push90=, $1=, $pop31
	i32.const	$push89=, 1103515245
	i32.mul 	$push34=, $pop90, $pop89
	i32.const	$push88=, 12345
	i32.add 	$push0=, $pop34, $pop88
	i32.store	$push35=, myrnd.s($pop93), $pop0
	tee_local	$push87=, $2=, $pop35
	i32.const	$push86=, 16
	i32.shr_u	$push36=, $pop87, $pop86
	i32.const	$push85=, 2047
	i32.and 	$push37=, $pop36, $pop85
	tee_local	$push84=, $3=, $pop37
	i32.const	$push83=, 16
	i32.shr_u	$push32=, $1, $pop83
	i32.const	$push82=, 2047
	i32.and 	$push33=, $pop32, $pop82
	tee_local	$push81=, $1=, $pop33
	i32.add 	$push46=, $pop84, $pop81
	i32.const	$push80=, 17
	i32.shl 	$push43=, $3, $pop80
	i32.const	$push79=, 0
	i32.const	$push78=, 17
	i32.shl 	$push38=, $1, $pop78
	i32.const	$push39=, 131071
	i32.and 	$push40=, $0, $pop39
	tee_local	$push77=, $1=, $pop40
	i32.or  	$push41=, $pop38, $pop77
	i32.store	$push42=, sC+4($pop79), $pop41
	i32.add 	$push44=, $pop43, $pop42
	i32.const	$push76=, 17
	i32.shr_u	$push45=, $pop44, $pop76
	i32.ne  	$push47=, $pop46, $pop45
	br_if   	0, $pop47       # 0: down to label4
# BB#1:                                 # %if.end80
	block
	i32.const	$push153=, 0
	i32.const	$push152=, 0
	i32.const	$push151=, 1103515245
	i32.mul 	$push48=, $2, $pop151
	i32.const	$push150=, 12345
	i32.add 	$push49=, $pop48, $pop150
	tee_local	$push149=, $3=, $pop49
	i32.const	$push55=, -1029531031
	i32.mul 	$push56=, $pop149, $pop55
	i32.const	$push57=, -740551042
	i32.add 	$push58=, $pop56, $pop57
	tee_local	$push148=, $0=, $pop58
	i32.const	$push147=, 1103515245
	i32.mul 	$push60=, $pop148, $pop147
	i32.const	$push146=, 12345
	i32.add 	$push61=, $pop60, $pop146
	i32.store	$push62=, myrnd.s($pop152), $pop61
	i32.const	$push145=, 16
	i32.shr_u	$push63=, $pop62, $pop145
	i32.const	$push144=, 2047
	i32.and 	$push2=, $pop63, $pop144
	tee_local	$push143=, $2=, $pop2
	i32.const	$push142=, 17
	i32.shl 	$push66=, $pop143, $pop142
	i32.const	$push141=, 16
	i32.shr_u	$push59=, $0, $pop141
	i32.const	$push140=, 2047
	i32.and 	$push1=, $pop59, $pop140
	tee_local	$push139=, $0=, $pop1
	i32.const	$push138=, 17
	i32.shl 	$push64=, $pop139, $pop138
	i32.or  	$push65=, $pop64, $1
	i32.add 	$push3=, $pop66, $pop65
	i32.store	$push67=, sC+4($pop153), $pop3
	tee_local	$push137=, $4=, $pop67
	i32.const	$push50=, 1
	i32.shl 	$push51=, $3, $pop50
	i32.const	$push52=, 268304384
	i32.and 	$push53=, $pop51, $pop52
	i32.or  	$push54=, $pop53, $1
	i32.xor 	$push4=, $pop137, $pop54
	tee_local	$push136=, $1=, $pop4
	i32.const	$push68=, 63
	i32.and 	$push69=, $pop136, $pop68
	br_if   	0, $pop69       # 0: down to label5
# BB#2:                                 # %lor.lhs.false96
	i32.add 	$push74=, $2, $0
	i32.const	$push71=, 17
	i32.shr_u	$push72=, $4, $pop71
	i32.ne  	$push75=, $pop74, $pop72
	br_if   	0, $pop75       # 0: down to label5
# BB#3:                                 # %lor.lhs.false96
	i32.const	$push73=, 131008
	i32.and 	$push70=, $1, $pop73
	br_if   	0, $pop70       # 0: down to label5
# BB#4:                                 # %if.end121
	return
.LBB18_5:                               # %if.then120
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB18_6:                               # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end18:
	.size	testC, .Lfunc_end18-testC

	.section	.text.retmeD,"ax",@progbits
	.hidden	retmeD
	.globl	retmeD
	.type	retmeD,@function
retmeD:                                 # @retmeD
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	$discard=, 0($0), $pop0
	return
	.endfunc
.Lfunc_end19:
	.size	retmeD, .Lfunc_end19-retmeD

	.section	.text.fn1D,"ax",@progbits
	.hidden	fn1D
	.globl	fn1D
	.type	fn1D,@function
fn1D:                                   # @fn1D
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i64.load	$push1=, sD($pop0)
	i64.const	$push2=, 35
	i64.shr_u	$push3=, $pop1, $pop2
	i32.wrap/i64	$push4=, $pop3
	i32.add 	$push5=, $pop4, $0
	i32.const	$push6=, 536870911
	i32.and 	$push7=, $pop5, $pop6
	return  	$pop7
	.endfunc
.Lfunc_end20:
	.size	fn1D, .Lfunc_end20-fn1D

	.section	.text.fn2D,"ax",@progbits
	.hidden	fn2D
	.globl	fn2D
	.type	fn2D,@function
fn2D:                                   # @fn2D
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i64.load	$push1=, sD($pop0)
	i64.const	$push2=, 35
	i64.shr_u	$push3=, $pop1, $pop2
	i32.wrap/i64	$push4=, $pop3
	i32.add 	$push5=, $pop4, $0
	i32.const	$push6=, 536870911
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push8=, 15
	i32.rem_u	$push9=, $pop7, $pop8
	return  	$pop9
	.endfunc
.Lfunc_end21:
	.size	fn2D, .Lfunc_end21-fn2D

	.section	.text.retitD,"ax",@progbits
	.hidden	retitD
	.globl	retitD
	.type	retitD,@function
retitD:                                 # @retitD
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i64.load	$push1=, sD($pop0)
	i64.const	$push2=, 35
	i64.shr_u	$push3=, $pop1, $pop2
	i32.wrap/i64	$push4=, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end22:
	.size	retitD, .Lfunc_end22-retitD

	.section	.text.fn3D,"ax",@progbits
	.hidden	fn3D
	.globl	fn3D
	.type	fn3D,@function
fn3D:                                   # @fn3D
	.param  	i32
	.result 	i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push16=, 0
	i64.load	$push1=, sD($pop16)
	tee_local	$push15=, $1=, $pop1
	i64.const	$push2=, 35
	i64.shr_u	$push3=, $pop15, $pop2
	i32.wrap/i64	$push4=, $pop3
	i32.add 	$push5=, $pop4, $0
	tee_local	$push14=, $0=, $pop5
	i64.extend_u/i32	$push6=, $pop14
	i64.const	$push13=, 35
	i64.shl 	$push7=, $pop6, $pop13
	i64.const	$push8=, 34359738367
	i64.and 	$push9=, $1, $pop8
	i64.or  	$push10=, $pop7, $pop9
	i64.store	$discard=, sD($pop0), $pop10
	i32.const	$push11=, 536870911
	i32.and 	$push12=, $0, $pop11
	return  	$pop12
	.endfunc
.Lfunc_end23:
	.size	fn3D, .Lfunc_end23-fn3D

	.section	.text.testD,"ax",@progbits
	.hidden	testD
	.globl	testD
	.type	testD,@function
testD:                                  # @testD
	.local  	i32
# BB#0:                                 # %if.end158
	i32.const	$push0=, 0
	i32.const	$push94=, 0
	i32.load	$push1=, myrnd.s($pop94)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push5=, $pop3, $pop4
	tee_local	$push93=, $0=, $pop5
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop93, $pop6
	i32.store8	$discard=, sD($pop0):p2align=3, $pop7
	i32.const	$push92=, 0
	i32.const	$push91=, 1103515245
	i32.mul 	$push8=, $0, $pop91
	i32.const	$push90=, 12345
	i32.add 	$push9=, $pop8, $pop90
	tee_local	$push89=, $0=, $pop9
	i32.const	$push88=, 16
	i32.shr_u	$push10=, $pop89, $pop88
	i32.store8	$discard=, sD+1($pop92), $pop10
	i32.const	$push87=, 0
	i32.const	$push86=, 1103515245
	i32.mul 	$push11=, $0, $pop86
	i32.const	$push85=, 12345
	i32.add 	$push12=, $pop11, $pop85
	tee_local	$push84=, $0=, $pop12
	i32.const	$push83=, 16
	i32.shr_u	$push13=, $pop84, $pop83
	i32.store8	$discard=, sD+2($pop87):p2align=1, $pop13
	i32.const	$push82=, 0
	i32.const	$push81=, 1103515245
	i32.mul 	$push14=, $0, $pop81
	i32.const	$push80=, 12345
	i32.add 	$push15=, $pop14, $pop80
	tee_local	$push79=, $0=, $pop15
	i32.const	$push78=, 16
	i32.shr_u	$push16=, $pop79, $pop78
	i32.store8	$discard=, sD+3($pop82), $pop16
	i32.const	$push77=, 0
	i32.const	$push76=, 1103515245
	i32.mul 	$push17=, $0, $pop76
	i32.const	$push75=, 12345
	i32.add 	$push18=, $pop17, $pop75
	tee_local	$push74=, $0=, $pop18
	i32.const	$push73=, 16
	i32.shr_u	$push19=, $pop74, $pop73
	i32.store8	$discard=, sD+4($pop77):p2align=2, $pop19
	i32.const	$push72=, 0
	i32.const	$push71=, 1103515245
	i32.mul 	$push20=, $0, $pop71
	i32.const	$push70=, 12345
	i32.add 	$push21=, $pop20, $pop70
	tee_local	$push69=, $0=, $pop21
	i32.const	$push68=, 16
	i32.shr_u	$push22=, $pop69, $pop68
	i32.store8	$discard=, sD+5($pop72), $pop22
	i32.const	$push67=, 0
	i32.const	$push66=, 1103515245
	i32.mul 	$push23=, $0, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push24=, $pop23, $pop65
	tee_local	$push64=, $0=, $pop24
	i32.const	$push63=, 16
	i32.shr_u	$push25=, $pop64, $pop63
	i32.store8	$discard=, sD+6($pop67):p2align=1, $pop25
	i32.const	$push62=, 0
	i32.const	$push61=, 1103515245
	i32.mul 	$push26=, $0, $pop61
	i32.const	$push60=, 12345
	i32.add 	$push27=, $pop26, $pop60
	tee_local	$push59=, $0=, $pop27
	i32.const	$push58=, 16
	i32.shr_u	$push28=, $pop59, $pop58
	i32.store8	$discard=, sD+7($pop62), $pop28
	i32.const	$push57=, 0
	i32.const	$push56=, 0
	i32.const	$push30=, -341751747
	i32.mul 	$push31=, $0, $pop30
	i32.const	$push32=, 229283573
	i32.add 	$push33=, $pop31, $pop32
	tee_local	$push55=, $0=, $pop33
	i32.const	$push54=, 1103515245
	i32.mul 	$push37=, $pop55, $pop54
	i32.const	$push53=, 12345
	i32.add 	$push38=, $pop37, $pop53
	i32.store	$push39=, myrnd.s($pop56), $pop38
	i32.const	$push52=, 16
	i32.shr_u	$push40=, $pop39, $pop52
	i32.const	$push35=, 2047
	i32.and 	$push41=, $pop40, $pop35
	i32.const	$push51=, 16
	i32.shr_u	$push34=, $0, $pop51
	i32.const	$push50=, 2047
	i32.and 	$push36=, $pop34, $pop50
	i32.add 	$push44=, $pop41, $pop36
	i64.extend_u/i32	$push45=, $pop44
	i64.const	$push46=, 35
	i64.shl 	$push47=, $pop45, $pop46
	i32.const	$push49=, 0
	i64.load	$push29=, sD($pop49)
	i64.const	$push42=, 34359738367
	i64.and 	$push43=, $pop29, $pop42
	i64.or  	$push48=, $pop47, $pop43
	i64.store	$discard=, sD($pop57), $pop48
	return
	.endfunc
.Lfunc_end24:
	.size	testD, .Lfunc_end24-testD

	.section	.text.retmeE,"ax",@progbits
	.hidden	retmeE
	.globl	retmeE
	.type	retmeE,@function
retmeE:                                 # @retmeE
	.param  	i32, i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.add 	$push3=, $1, $pop1
	i64.load	$2=, 0($pop3)
	i64.load	$push0=, 0($1)
	i64.store	$discard=, 0($0), $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i64.store	$discard=, 0($pop2), $2
	return
	.endfunc
.Lfunc_end25:
	.size	retmeE, .Lfunc_end25-retmeE

	.section	.text.fn1E,"ax",@progbits
	.hidden	fn1E
	.globl	fn1E
	.type	fn1E,@function
fn1E:                                   # @fn1E
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i64.load	$push1=, sE+8($pop0)
	i64.const	$push2=, 35
	i64.shr_u	$push3=, $pop1, $pop2
	i32.wrap/i64	$push4=, $pop3
	i32.add 	$push5=, $pop4, $0
	i32.const	$push6=, 536870911
	i32.and 	$push7=, $pop5, $pop6
	return  	$pop7
	.endfunc
.Lfunc_end26:
	.size	fn1E, .Lfunc_end26-fn1E

	.section	.text.fn2E,"ax",@progbits
	.hidden	fn2E
	.globl	fn2E
	.type	fn2E,@function
fn2E:                                   # @fn2E
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i64.load	$push1=, sE+8($pop0)
	i64.const	$push2=, 35
	i64.shr_u	$push3=, $pop1, $pop2
	i32.wrap/i64	$push4=, $pop3
	i32.add 	$push5=, $pop4, $0
	i32.const	$push6=, 536870911
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push8=, 15
	i32.rem_u	$push9=, $pop7, $pop8
	return  	$pop9
	.endfunc
.Lfunc_end27:
	.size	fn2E, .Lfunc_end27-fn2E

	.section	.text.retitE,"ax",@progbits
	.hidden	retitE
	.globl	retitE
	.type	retitE,@function
retitE:                                 # @retitE
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i64.load	$push1=, sE+8($pop0)
	i64.const	$push2=, 35
	i64.shr_u	$push3=, $pop1, $pop2
	i32.wrap/i64	$push4=, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end28:
	.size	retitE, .Lfunc_end28-retitE

	.section	.text.fn3E,"ax",@progbits
	.hidden	fn3E
	.globl	fn3E
	.type	fn3E,@function
fn3E:                                   # @fn3E
	.param  	i32
	.result 	i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push16=, 0
	i64.load	$push1=, sE+8($pop16)
	tee_local	$push15=, $1=, $pop1
	i64.const	$push2=, 35
	i64.shr_u	$push3=, $pop15, $pop2
	i32.wrap/i64	$push4=, $pop3
	i32.add 	$push5=, $pop4, $0
	tee_local	$push14=, $0=, $pop5
	i64.extend_u/i32	$push6=, $pop14
	i64.const	$push13=, 35
	i64.shl 	$push7=, $pop6, $pop13
	i64.const	$push8=, 34359738367
	i64.and 	$push9=, $1, $pop8
	i64.or  	$push10=, $pop7, $pop9
	i64.store	$discard=, sE+8($pop0), $pop10
	i32.const	$push11=, 536870911
	i32.and 	$push12=, $0, $pop11
	return  	$pop12
	.endfunc
.Lfunc_end29:
	.size	fn3E, .Lfunc_end29-fn3E

	.section	.text.testE,"ax",@progbits
	.hidden	testE
	.globl	testE
	.type	testE,@function
testE:                                  # @testE
	.local  	i32
# BB#0:                                 # %if.end142
	i32.const	$push0=, 0
	i32.const	$push158=, 0
	i32.load	$push1=, myrnd.s($pop158)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push5=, $pop3, $pop4
	tee_local	$push157=, $0=, $pop5
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop157, $pop6
	i32.store8	$discard=, sE($pop0):p2align=3, $pop7
	i32.const	$push156=, 0
	i32.const	$push155=, 1103515245
	i32.mul 	$push8=, $0, $pop155
	i32.const	$push154=, 12345
	i32.add 	$push9=, $pop8, $pop154
	tee_local	$push153=, $0=, $pop9
	i32.const	$push152=, 16
	i32.shr_u	$push10=, $pop153, $pop152
	i32.store8	$discard=, sE+1($pop156), $pop10
	i32.const	$push151=, 0
	i32.const	$push150=, 1103515245
	i32.mul 	$push11=, $0, $pop150
	i32.const	$push149=, 12345
	i32.add 	$push12=, $pop11, $pop149
	tee_local	$push148=, $0=, $pop12
	i32.const	$push147=, 16
	i32.shr_u	$push13=, $pop148, $pop147
	i32.store8	$discard=, sE+2($pop151):p2align=1, $pop13
	i32.const	$push146=, 0
	i32.const	$push145=, 1103515245
	i32.mul 	$push14=, $0, $pop145
	i32.const	$push144=, 12345
	i32.add 	$push15=, $pop14, $pop144
	tee_local	$push143=, $0=, $pop15
	i32.const	$push142=, 16
	i32.shr_u	$push16=, $pop143, $pop142
	i32.store8	$discard=, sE+3($pop146), $pop16
	i32.const	$push141=, 0
	i32.const	$push140=, 1103515245
	i32.mul 	$push17=, $0, $pop140
	i32.const	$push139=, 12345
	i32.add 	$push18=, $pop17, $pop139
	tee_local	$push138=, $0=, $pop18
	i32.const	$push137=, 16
	i32.shr_u	$push19=, $pop138, $pop137
	i32.store8	$discard=, sE+4($pop141):p2align=2, $pop19
	i32.const	$push136=, 0
	i32.const	$push135=, 1103515245
	i32.mul 	$push20=, $0, $pop135
	i32.const	$push134=, 12345
	i32.add 	$push21=, $pop20, $pop134
	tee_local	$push133=, $0=, $pop21
	i32.const	$push132=, 16
	i32.shr_u	$push22=, $pop133, $pop132
	i32.store8	$discard=, sE+5($pop136), $pop22
	i32.const	$push131=, 0
	i32.const	$push130=, 1103515245
	i32.mul 	$push23=, $0, $pop130
	i32.const	$push129=, 12345
	i32.add 	$push24=, $pop23, $pop129
	tee_local	$push128=, $0=, $pop24
	i32.const	$push127=, 16
	i32.shr_u	$push25=, $pop128, $pop127
	i32.store8	$discard=, sE+6($pop131):p2align=1, $pop25
	i32.const	$push126=, 0
	i32.const	$push125=, 1103515245
	i32.mul 	$push26=, $0, $pop125
	i32.const	$push124=, 12345
	i32.add 	$push27=, $pop26, $pop124
	tee_local	$push123=, $0=, $pop27
	i32.const	$push122=, 16
	i32.shr_u	$push28=, $pop123, $pop122
	i32.store8	$discard=, sE+7($pop126), $pop28
	i32.const	$push121=, 0
	i32.const	$push120=, 1103515245
	i32.mul 	$push29=, $0, $pop120
	i32.const	$push119=, 12345
	i32.add 	$push30=, $pop29, $pop119
	tee_local	$push118=, $0=, $pop30
	i32.const	$push117=, 16
	i32.shr_u	$push31=, $pop118, $pop117
	i32.store8	$discard=, sE+8($pop121):p2align=3, $pop31
	i32.const	$push116=, 0
	i32.const	$push115=, 1103515245
	i32.mul 	$push32=, $0, $pop115
	i32.const	$push114=, 12345
	i32.add 	$push33=, $pop32, $pop114
	tee_local	$push113=, $0=, $pop33
	i32.const	$push112=, 16
	i32.shr_u	$push34=, $pop113, $pop112
	i32.store8	$discard=, sE+9($pop116), $pop34
	i32.const	$push111=, 0
	i32.const	$push110=, 1103515245
	i32.mul 	$push35=, $0, $pop110
	i32.const	$push109=, 12345
	i32.add 	$push36=, $pop35, $pop109
	tee_local	$push108=, $0=, $pop36
	i32.const	$push107=, 16
	i32.shr_u	$push37=, $pop108, $pop107
	i32.store8	$discard=, sE+10($pop111):p2align=1, $pop37
	i32.const	$push106=, 0
	i32.const	$push105=, 1103515245
	i32.mul 	$push38=, $0, $pop105
	i32.const	$push104=, 12345
	i32.add 	$push39=, $pop38, $pop104
	tee_local	$push103=, $0=, $pop39
	i32.const	$push102=, 16
	i32.shr_u	$push40=, $pop103, $pop102
	i32.store8	$discard=, sE+11($pop106), $pop40
	i32.const	$push101=, 0
	i32.const	$push100=, 1103515245
	i32.mul 	$push41=, $0, $pop100
	i32.const	$push99=, 12345
	i32.add 	$push42=, $pop41, $pop99
	tee_local	$push98=, $0=, $pop42
	i32.const	$push97=, 16
	i32.shr_u	$push43=, $pop98, $pop97
	i32.store8	$discard=, sE+12($pop101):p2align=2, $pop43
	i32.const	$push96=, 0
	i32.const	$push95=, 1103515245
	i32.mul 	$push44=, $0, $pop95
	i32.const	$push94=, 12345
	i32.add 	$push45=, $pop44, $pop94
	tee_local	$push93=, $0=, $pop45
	i32.const	$push92=, 16
	i32.shr_u	$push46=, $pop93, $pop92
	i32.store8	$discard=, sE+13($pop96), $pop46
	i32.const	$push91=, 0
	i32.const	$push90=, 1103515245
	i32.mul 	$push47=, $0, $pop90
	i32.const	$push89=, 12345
	i32.add 	$push48=, $pop47, $pop89
	tee_local	$push88=, $0=, $pop48
	i32.const	$push87=, 16
	i32.shr_u	$push49=, $pop88, $pop87
	i32.store8	$discard=, sE+14($pop91):p2align=1, $pop49
	i32.const	$push86=, 0
	i32.const	$push85=, 1103515245
	i32.mul 	$push50=, $0, $pop85
	i32.const	$push84=, 12345
	i32.add 	$push51=, $pop50, $pop84
	tee_local	$push83=, $0=, $pop51
	i32.const	$push82=, 16
	i32.shr_u	$push52=, $pop83, $pop82
	i32.store8	$discard=, sE+15($pop86), $pop52
	i32.const	$push81=, 0
	i32.const	$push80=, 0
	i32.const	$push54=, -341751747
	i32.mul 	$push55=, $0, $pop54
	i32.const	$push56=, 229283573
	i32.add 	$push57=, $pop55, $pop56
	tee_local	$push79=, $0=, $pop57
	i32.const	$push78=, 1103515245
	i32.mul 	$push61=, $pop79, $pop78
	i32.const	$push77=, 12345
	i32.add 	$push62=, $pop61, $pop77
	i32.store	$push63=, myrnd.s($pop80), $pop62
	i32.const	$push76=, 16
	i32.shr_u	$push64=, $pop63, $pop76
	i32.const	$push59=, 2047
	i32.and 	$push65=, $pop64, $pop59
	i32.const	$push75=, 16
	i32.shr_u	$push58=, $0, $pop75
	i32.const	$push74=, 2047
	i32.and 	$push60=, $pop58, $pop74
	i32.add 	$push68=, $pop65, $pop60
	i64.extend_u/i32	$push69=, $pop68
	i64.const	$push70=, 35
	i64.shl 	$push71=, $pop69, $pop70
	i32.const	$push73=, 0
	i64.load	$push53=, sE+8($pop73)
	i64.const	$push66=, 34359738367
	i64.and 	$push67=, $pop53, $pop66
	i64.or  	$push72=, $pop71, $pop67
	i64.store	$discard=, sE+8($pop81), $pop72
	return
	.endfunc
.Lfunc_end30:
	.size	testE, .Lfunc_end30-testE

	.section	.text.retmeF,"ax",@progbits
	.hidden	retmeF
	.globl	retmeF
	.type	retmeF,@function
retmeF:                                 # @retmeF
	.param  	i32, i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.add 	$push3=, $1, $pop1
	i64.load	$2=, 0($pop3)
	i64.load	$push0=, 0($1)
	i64.store	$discard=, 0($0), $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i64.store	$discard=, 0($pop2), $2
	return
	.endfunc
.Lfunc_end31:
	.size	retmeF, .Lfunc_end31-retmeF

	.section	.text.fn1F,"ax",@progbits
	.hidden	fn1F
	.globl	fn1F
	.type	fn1F,@function
fn1F:                                   # @fn1F
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i64.load	$push1=, sF($pop0)
	i64.const	$push2=, 35
	i64.shr_u	$push3=, $pop1, $pop2
	i32.wrap/i64	$push4=, $pop3
	i32.add 	$push5=, $pop4, $0
	i32.const	$push6=, 536870911
	i32.and 	$push7=, $pop5, $pop6
	return  	$pop7
	.endfunc
.Lfunc_end32:
	.size	fn1F, .Lfunc_end32-fn1F

	.section	.text.fn2F,"ax",@progbits
	.hidden	fn2F
	.globl	fn2F
	.type	fn2F,@function
fn2F:                                   # @fn2F
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i64.load	$push1=, sF($pop0)
	i64.const	$push2=, 35
	i64.shr_u	$push3=, $pop1, $pop2
	i32.wrap/i64	$push4=, $pop3
	i32.add 	$push5=, $pop4, $0
	i32.const	$push6=, 536870911
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push8=, 15
	i32.rem_u	$push9=, $pop7, $pop8
	return  	$pop9
	.endfunc
.Lfunc_end33:
	.size	fn2F, .Lfunc_end33-fn2F

	.section	.text.retitF,"ax",@progbits
	.hidden	retitF
	.globl	retitF
	.type	retitF,@function
retitF:                                 # @retitF
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i64.load	$push1=, sF($pop0)
	i64.const	$push2=, 35
	i64.shr_u	$push3=, $pop1, $pop2
	i32.wrap/i64	$push4=, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end34:
	.size	retitF, .Lfunc_end34-retitF

	.section	.text.fn3F,"ax",@progbits
	.hidden	fn3F
	.globl	fn3F
	.type	fn3F,@function
fn3F:                                   # @fn3F
	.param  	i32
	.result 	i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push16=, 0
	i64.load	$push1=, sF($pop16)
	tee_local	$push15=, $1=, $pop1
	i64.const	$push2=, 35
	i64.shr_u	$push3=, $pop15, $pop2
	i32.wrap/i64	$push4=, $pop3
	i32.add 	$push5=, $pop4, $0
	tee_local	$push14=, $0=, $pop5
	i64.extend_u/i32	$push6=, $pop14
	i64.const	$push13=, 35
	i64.shl 	$push7=, $pop6, $pop13
	i64.const	$push8=, 34359738367
	i64.and 	$push9=, $1, $pop8
	i64.or  	$push10=, $pop7, $pop9
	i64.store	$discard=, sF($pop0), $pop10
	i32.const	$push11=, 536870911
	i32.and 	$push12=, $0, $pop11
	return  	$pop12
	.endfunc
.Lfunc_end35:
	.size	fn3F, .Lfunc_end35-fn3F

	.section	.text.testF,"ax",@progbits
	.hidden	testF
	.globl	testF
	.type	testF,@function
testF:                                  # @testF
	.local  	i32
# BB#0:                                 # %if.end136
	i32.const	$push0=, 0
	i32.const	$push158=, 0
	i32.load	$push1=, myrnd.s($pop158)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push5=, $pop3, $pop4
	tee_local	$push157=, $0=, $pop5
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop157, $pop6
	i32.store8	$discard=, sF($pop0):p2align=3, $pop7
	i32.const	$push156=, 0
	i32.const	$push155=, 1103515245
	i32.mul 	$push8=, $0, $pop155
	i32.const	$push154=, 12345
	i32.add 	$push9=, $pop8, $pop154
	tee_local	$push153=, $0=, $pop9
	i32.const	$push152=, 16
	i32.shr_u	$push10=, $pop153, $pop152
	i32.store8	$discard=, sF+1($pop156), $pop10
	i32.const	$push151=, 0
	i32.const	$push150=, 1103515245
	i32.mul 	$push11=, $0, $pop150
	i32.const	$push149=, 12345
	i32.add 	$push12=, $pop11, $pop149
	tee_local	$push148=, $0=, $pop12
	i32.const	$push147=, 16
	i32.shr_u	$push13=, $pop148, $pop147
	i32.store8	$discard=, sF+2($pop151):p2align=1, $pop13
	i32.const	$push146=, 0
	i32.const	$push145=, 1103515245
	i32.mul 	$push14=, $0, $pop145
	i32.const	$push144=, 12345
	i32.add 	$push15=, $pop14, $pop144
	tee_local	$push143=, $0=, $pop15
	i32.const	$push142=, 16
	i32.shr_u	$push16=, $pop143, $pop142
	i32.store8	$discard=, sF+3($pop146), $pop16
	i32.const	$push141=, 0
	i32.const	$push140=, 1103515245
	i32.mul 	$push17=, $0, $pop140
	i32.const	$push139=, 12345
	i32.add 	$push18=, $pop17, $pop139
	tee_local	$push138=, $0=, $pop18
	i32.const	$push137=, 16
	i32.shr_u	$push19=, $pop138, $pop137
	i32.store8	$discard=, sF+4($pop141):p2align=2, $pop19
	i32.const	$push136=, 0
	i32.const	$push135=, 1103515245
	i32.mul 	$push20=, $0, $pop135
	i32.const	$push134=, 12345
	i32.add 	$push21=, $pop20, $pop134
	tee_local	$push133=, $0=, $pop21
	i32.const	$push132=, 16
	i32.shr_u	$push22=, $pop133, $pop132
	i32.store8	$discard=, sF+5($pop136), $pop22
	i32.const	$push131=, 0
	i32.const	$push130=, 1103515245
	i32.mul 	$push23=, $0, $pop130
	i32.const	$push129=, 12345
	i32.add 	$push24=, $pop23, $pop129
	tee_local	$push128=, $0=, $pop24
	i32.const	$push127=, 16
	i32.shr_u	$push25=, $pop128, $pop127
	i32.store8	$discard=, sF+6($pop131):p2align=1, $pop25
	i32.const	$push126=, 0
	i32.const	$push125=, 1103515245
	i32.mul 	$push26=, $0, $pop125
	i32.const	$push124=, 12345
	i32.add 	$push27=, $pop26, $pop124
	tee_local	$push123=, $0=, $pop27
	i32.const	$push122=, 16
	i32.shr_u	$push28=, $pop123, $pop122
	i32.store8	$discard=, sF+7($pop126), $pop28
	i32.const	$push121=, 0
	i32.const	$push120=, 1103515245
	i32.mul 	$push29=, $0, $pop120
	i32.const	$push119=, 12345
	i32.add 	$push30=, $pop29, $pop119
	tee_local	$push118=, $0=, $pop30
	i32.const	$push117=, 16
	i32.shr_u	$push31=, $pop118, $pop117
	i32.store8	$discard=, sF+8($pop121):p2align=3, $pop31
	i32.const	$push116=, 0
	i32.const	$push115=, 1103515245
	i32.mul 	$push32=, $0, $pop115
	i32.const	$push114=, 12345
	i32.add 	$push33=, $pop32, $pop114
	tee_local	$push113=, $0=, $pop33
	i32.const	$push112=, 16
	i32.shr_u	$push34=, $pop113, $pop112
	i32.store8	$discard=, sF+9($pop116), $pop34
	i32.const	$push111=, 0
	i32.const	$push110=, 1103515245
	i32.mul 	$push35=, $0, $pop110
	i32.const	$push109=, 12345
	i32.add 	$push36=, $pop35, $pop109
	tee_local	$push108=, $0=, $pop36
	i32.const	$push107=, 16
	i32.shr_u	$push37=, $pop108, $pop107
	i32.store8	$discard=, sF+10($pop111):p2align=1, $pop37
	i32.const	$push106=, 0
	i32.const	$push105=, 1103515245
	i32.mul 	$push38=, $0, $pop105
	i32.const	$push104=, 12345
	i32.add 	$push39=, $pop38, $pop104
	tee_local	$push103=, $0=, $pop39
	i32.const	$push102=, 16
	i32.shr_u	$push40=, $pop103, $pop102
	i32.store8	$discard=, sF+11($pop106), $pop40
	i32.const	$push101=, 0
	i32.const	$push100=, 1103515245
	i32.mul 	$push41=, $0, $pop100
	i32.const	$push99=, 12345
	i32.add 	$push42=, $pop41, $pop99
	tee_local	$push98=, $0=, $pop42
	i32.const	$push97=, 16
	i32.shr_u	$push43=, $pop98, $pop97
	i32.store8	$discard=, sF+12($pop101):p2align=2, $pop43
	i32.const	$push96=, 0
	i32.const	$push95=, 1103515245
	i32.mul 	$push44=, $0, $pop95
	i32.const	$push94=, 12345
	i32.add 	$push45=, $pop44, $pop94
	tee_local	$push93=, $0=, $pop45
	i32.const	$push92=, 16
	i32.shr_u	$push46=, $pop93, $pop92
	i32.store8	$discard=, sF+13($pop96), $pop46
	i32.const	$push91=, 0
	i32.const	$push90=, 1103515245
	i32.mul 	$push47=, $0, $pop90
	i32.const	$push89=, 12345
	i32.add 	$push48=, $pop47, $pop89
	tee_local	$push88=, $0=, $pop48
	i32.const	$push87=, 16
	i32.shr_u	$push49=, $pop88, $pop87
	i32.store8	$discard=, sF+14($pop91):p2align=1, $pop49
	i32.const	$push86=, 0
	i32.const	$push85=, 1103515245
	i32.mul 	$push50=, $0, $pop85
	i32.const	$push84=, 12345
	i32.add 	$push51=, $pop50, $pop84
	tee_local	$push83=, $0=, $pop51
	i32.const	$push82=, 16
	i32.shr_u	$push52=, $pop83, $pop82
	i32.store8	$discard=, sF+15($pop86), $pop52
	i32.const	$push81=, 0
	i32.const	$push80=, 0
	i32.const	$push54=, -341751747
	i32.mul 	$push55=, $0, $pop54
	i32.const	$push56=, 229283573
	i32.add 	$push57=, $pop55, $pop56
	tee_local	$push79=, $0=, $pop57
	i32.const	$push78=, 1103515245
	i32.mul 	$push61=, $pop79, $pop78
	i32.const	$push77=, 12345
	i32.add 	$push62=, $pop61, $pop77
	i32.store	$push63=, myrnd.s($pop80), $pop62
	i32.const	$push76=, 16
	i32.shr_u	$push64=, $pop63, $pop76
	i32.const	$push59=, 2047
	i32.and 	$push65=, $pop64, $pop59
	i32.const	$push75=, 16
	i32.shr_u	$push58=, $0, $pop75
	i32.const	$push74=, 2047
	i32.and 	$push60=, $pop58, $pop74
	i32.add 	$push68=, $pop65, $pop60
	i64.extend_u/i32	$push69=, $pop68
	i64.const	$push70=, 35
	i64.shl 	$push71=, $pop69, $pop70
	i32.const	$push73=, 0
	i64.load	$push53=, sF($pop73)
	i64.const	$push66=, 34359738367
	i64.and 	$push67=, $pop53, $pop66
	i64.or  	$push72=, $pop71, $pop67
	i64.store	$discard=, sF($pop81), $pop72
	return
	.endfunc
.Lfunc_end36:
	.size	testF, .Lfunc_end36-testF

	.section	.text.retmeG,"ax",@progbits
	.hidden	retmeG
	.globl	retmeG
	.type	retmeG,@function
retmeG:                                 # @retmeG
	.param  	i32, i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.add 	$push3=, $1, $pop1
	i64.load	$2=, 0($pop3)
	i64.load	$push0=, 0($1)
	i64.store	$discard=, 0($0), $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i64.store	$discard=, 0($pop2), $2
	return
	.endfunc
.Lfunc_end37:
	.size	retmeG, .Lfunc_end37-retmeG

	.section	.text.fn1G,"ax",@progbits
	.hidden	fn1G
	.globl	fn1G
	.type	fn1G,@function
fn1G:                                   # @fn1G
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sG($pop0):p2align=3
	i32.const	$push2=, 25
	i32.shl 	$push3=, $0, $pop2
	i32.add 	$push4=, $pop1, $pop3
	i32.const	$push6=, 25
	i32.shr_u	$push5=, $pop4, $pop6
	return  	$pop5
	.endfunc
.Lfunc_end38:
	.size	fn1G, .Lfunc_end38-fn1G

	.section	.text.fn2G,"ax",@progbits
	.hidden	fn2G
	.globl	fn2G
	.type	fn2G,@function
fn2G:                                   # @fn2G
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sG($pop0):p2align=3
	i32.const	$push2=, 25
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 127
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push7=, 15
	i32.rem_u	$push8=, $pop6, $pop7
	return  	$pop8
	.endfunc
.Lfunc_end39:
	.size	fn2G, .Lfunc_end39-fn2G

	.section	.text.retitG,"ax",@progbits
	.hidden	retitG
	.globl	retitG
	.type	retitG,@function
retitG:                                 # @retitG
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sG($pop0):p2align=3
	i32.const	$push2=, 25
	i32.shr_u	$push3=, $pop1, $pop2
	return  	$pop3
	.endfunc
.Lfunc_end40:
	.size	retitG, .Lfunc_end40-retitG

	.section	.text.fn3G,"ax",@progbits
	.hidden	fn3G
	.globl	fn3G
	.type	fn3G,@function
fn3G:                                   # @fn3G
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push8=, 0
	i32.load	$push1=, sG($pop8):p2align=3
	i32.const	$push2=, 25
	i32.shl 	$push3=, $0, $pop2
	i32.add 	$push4=, $pop1, $pop3
	i32.store	$push5=, sG($pop0):p2align=3, $pop4
	i32.const	$push7=, 25
	i32.shr_u	$push6=, $pop5, $pop7
	return  	$pop6
	.endfunc
.Lfunc_end41:
	.size	fn3G, .Lfunc_end41-fn3G

	.section	.text.testG,"ax",@progbits
	.hidden	testG
	.globl	testG
	.type	testG,@function
testG:                                  # @testG
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push189=, 0
	i32.const	$push188=, 0
	i32.load	$push5=, myrnd.s($pop188)
	i32.const	$push187=, 1103515245
	i32.mul 	$push6=, $pop5, $pop187
	i32.const	$push186=, 12345
	i32.add 	$push7=, $pop6, $pop186
	tee_local	$push185=, $2=, $pop7
	i32.const	$push184=, 16
	i32.shr_u	$push8=, $pop185, $pop184
	i32.store8	$discard=, sG($pop189):p2align=3, $pop8
	i32.const	$push183=, 0
	i32.const	$push182=, 1103515245
	i32.mul 	$push9=, $2, $pop182
	i32.const	$push181=, 12345
	i32.add 	$push10=, $pop9, $pop181
	tee_local	$push180=, $2=, $pop10
	i32.const	$push179=, 16
	i32.shr_u	$push11=, $pop180, $pop179
	i32.store8	$discard=, sG+1($pop183), $pop11
	i32.const	$push178=, 0
	i32.const	$push177=, 1103515245
	i32.mul 	$push12=, $2, $pop177
	i32.const	$push176=, 12345
	i32.add 	$push13=, $pop12, $pop176
	tee_local	$push175=, $2=, $pop13
	i32.const	$push174=, 16
	i32.shr_u	$push14=, $pop175, $pop174
	i32.store8	$discard=, sG+2($pop178):p2align=1, $pop14
	i32.const	$push173=, 0
	i32.const	$push172=, 1103515245
	i32.mul 	$push15=, $2, $pop172
	i32.const	$push171=, 12345
	i32.add 	$push16=, $pop15, $pop171
	tee_local	$push170=, $2=, $pop16
	i32.const	$push169=, 16
	i32.shr_u	$push17=, $pop170, $pop169
	i32.store8	$discard=, sG+3($pop173), $pop17
	i32.const	$push168=, 0
	i32.const	$push167=, 1103515245
	i32.mul 	$push18=, $2, $pop167
	i32.const	$push166=, 12345
	i32.add 	$push19=, $pop18, $pop166
	tee_local	$push165=, $2=, $pop19
	i32.const	$push164=, 16
	i32.shr_u	$push20=, $pop165, $pop164
	i32.store8	$discard=, sG+4($pop168):p2align=2, $pop20
	i32.const	$push163=, 0
	i32.const	$push162=, 1103515245
	i32.mul 	$push21=, $2, $pop162
	i32.const	$push161=, 12345
	i32.add 	$push22=, $pop21, $pop161
	tee_local	$push160=, $2=, $pop22
	i32.const	$push159=, 16
	i32.shr_u	$push23=, $pop160, $pop159
	i32.store8	$discard=, sG+5($pop163), $pop23
	i32.const	$push158=, 0
	i32.const	$push157=, 1103515245
	i32.mul 	$push24=, $2, $pop157
	i32.const	$push156=, 12345
	i32.add 	$push25=, $pop24, $pop156
	tee_local	$push155=, $2=, $pop25
	i32.const	$push154=, 16
	i32.shr_u	$push26=, $pop155, $pop154
	i32.store8	$discard=, sG+6($pop158):p2align=1, $pop26
	i32.const	$push153=, 0
	i32.const	$push152=, 1103515245
	i32.mul 	$push27=, $2, $pop152
	i32.const	$push151=, 12345
	i32.add 	$push28=, $pop27, $pop151
	tee_local	$push150=, $2=, $pop28
	i32.const	$push149=, 16
	i32.shr_u	$push29=, $pop150, $pop149
	i32.store8	$discard=, sG+7($pop153), $pop29
	i32.const	$push148=, 0
	i32.const	$push147=, 1103515245
	i32.mul 	$push30=, $2, $pop147
	i32.const	$push146=, 12345
	i32.add 	$push31=, $pop30, $pop146
	tee_local	$push145=, $2=, $pop31
	i32.const	$push144=, 16
	i32.shr_u	$push32=, $pop145, $pop144
	i32.store8	$discard=, sG+8($pop148):p2align=3, $pop32
	i32.const	$push143=, 0
	i32.const	$push142=, 1103515245
	i32.mul 	$push33=, $2, $pop142
	i32.const	$push141=, 12345
	i32.add 	$push34=, $pop33, $pop141
	tee_local	$push140=, $2=, $pop34
	i32.const	$push139=, 16
	i32.shr_u	$push35=, $pop140, $pop139
	i32.store8	$discard=, sG+9($pop143), $pop35
	i32.const	$push138=, 0
	i32.const	$push137=, 1103515245
	i32.mul 	$push36=, $2, $pop137
	i32.const	$push136=, 12345
	i32.add 	$push37=, $pop36, $pop136
	tee_local	$push135=, $2=, $pop37
	i32.const	$push134=, 16
	i32.shr_u	$push38=, $pop135, $pop134
	i32.store8	$discard=, sG+10($pop138):p2align=1, $pop38
	i32.const	$push133=, 0
	i32.const	$push132=, 1103515245
	i32.mul 	$push39=, $2, $pop132
	i32.const	$push131=, 12345
	i32.add 	$push40=, $pop39, $pop131
	tee_local	$push130=, $2=, $pop40
	i32.const	$push129=, 16
	i32.shr_u	$push41=, $pop130, $pop129
	i32.store8	$discard=, sG+11($pop133), $pop41
	i32.const	$push128=, 0
	i32.const	$push127=, 1103515245
	i32.mul 	$push42=, $2, $pop127
	i32.const	$push126=, 12345
	i32.add 	$push43=, $pop42, $pop126
	tee_local	$push125=, $2=, $pop43
	i32.const	$push124=, 16
	i32.shr_u	$push44=, $pop125, $pop124
	i32.store8	$discard=, sG+12($pop128):p2align=2, $pop44
	i32.const	$push123=, 0
	i32.const	$push122=, 1103515245
	i32.mul 	$push45=, $2, $pop122
	i32.const	$push121=, 12345
	i32.add 	$push46=, $pop45, $pop121
	tee_local	$push120=, $2=, $pop46
	i32.const	$push119=, 16
	i32.shr_u	$push47=, $pop120, $pop119
	i32.store8	$discard=, sG+13($pop123), $pop47
	i32.const	$push118=, 0
	i32.const	$push117=, 1103515245
	i32.mul 	$push48=, $2, $pop117
	i32.const	$push116=, 12345
	i32.add 	$push49=, $pop48, $pop116
	tee_local	$push115=, $2=, $pop49
	i32.const	$push114=, 16
	i32.shr_u	$push50=, $pop115, $pop114
	i32.store8	$discard=, sG+14($pop118):p2align=1, $pop50
	i32.const	$push113=, 0
	i32.const	$push112=, 1103515245
	i32.mul 	$push51=, $2, $pop112
	i32.const	$push111=, 12345
	i32.add 	$push52=, $pop51, $pop111
	tee_local	$push110=, $2=, $pop52
	i32.const	$push109=, 16
	i32.shr_u	$push53=, $pop110, $pop109
	i32.store8	$discard=, sG+15($pop113), $pop53
	block
	i32.const	$push108=, 0
	i32.const	$push107=, 1103515245
	i32.mul 	$push54=, $2, $pop107
	i32.const	$push106=, 12345
	i32.add 	$push55=, $pop54, $pop106
	tee_local	$push105=, $2=, $pop55
	i32.const	$push104=, 1103515245
	i32.mul 	$push57=, $pop105, $pop104
	i32.const	$push103=, 12345
	i32.add 	$push1=, $pop57, $pop103
	i32.store	$push58=, myrnd.s($pop108), $pop1
	tee_local	$push102=, $1=, $pop58
	i32.const	$push101=, 16
	i32.shr_u	$push59=, $pop102, $pop101
	tee_local	$push100=, $0=, $pop59
	i32.const	$push99=, 16
	i32.shr_u	$push56=, $2, $pop99
	tee_local	$push98=, $2=, $pop56
	i32.add 	$push67=, $pop100, $pop98
	i32.const	$push68=, 127
	i32.and 	$push69=, $pop67, $pop68
	i32.const	$push97=, 25
	i32.shl 	$push64=, $0, $pop97
	i32.const	$push96=, 0
	i32.const	$push95=, 25
	i32.shl 	$push60=, $2, $pop95
	i32.const	$push94=, 0
	i32.load	$push0=, sG($pop94):p2align=3
	tee_local	$push93=, $2=, $pop0
	i32.const	$push92=, 33554431
	i32.and 	$push61=, $pop93, $pop92
	tee_local	$push91=, $0=, $pop61
	i32.or  	$push62=, $pop60, $pop91
	i32.store	$push63=, sG($pop96):p2align=3, $pop62
	i32.add 	$push65=, $pop64, $pop63
	i32.const	$push90=, 25
	i32.shr_u	$push66=, $pop65, $pop90
	i32.ne  	$push70=, $pop69, $pop66
	br_if   	0, $pop70       # 0: down to label6
# BB#1:                                 # %if.end76
	block
	i32.const	$push202=, 0
	i32.const	$push201=, 0
	i32.const	$push71=, -2139243339
	i32.mul 	$push72=, $1, $pop71
	i32.const	$push73=, -1492899873
	i32.add 	$push74=, $pop72, $pop73
	tee_local	$push200=, $1=, $pop74
	i32.const	$push199=, 1103515245
	i32.mul 	$push75=, $pop200, $pop199
	i32.const	$push198=, 12345
	i32.add 	$push76=, $pop75, $pop198
	i32.store	$push77=, myrnd.s($pop201), $pop76
	i32.const	$push197=, 16
	i32.shr_u	$push3=, $pop77, $pop197
	tee_local	$push196=, $3=, $pop3
	i32.const	$push195=, 25
	i32.shl 	$push80=, $pop196, $pop195
	i32.const	$push194=, 16
	i32.shr_u	$push2=, $1, $pop194
	tee_local	$push193=, $1=, $pop2
	i32.const	$push192=, 25
	i32.shl 	$push78=, $pop193, $pop192
	i32.or  	$push79=, $pop78, $0
	i32.add 	$push4=, $pop80, $pop79
	i32.store	$push81=, sG($pop202):p2align=3, $pop4
	tee_local	$push191=, $0=, $pop81
	i32.xor 	$push82=, $pop191, $2
	i32.const	$push190=, 33554431
	i32.and 	$push83=, $pop82, $pop190
	br_if   	0, $pop83       # 0: down to label7
# BB#2:                                 # %lor.lhs.false109
	i32.add 	$push86=, $3, $1
	i32.const	$push87=, 127
	i32.and 	$push88=, $pop86, $pop87
	i32.const	$push84=, 25
	i32.shr_u	$push85=, $0, $pop84
	i32.ne  	$push89=, $pop88, $pop85
	br_if   	0, $pop89       # 0: down to label7
# BB#3:                                 # %if.end115
	return
.LBB42_4:                               # %if.then114
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB42_5:                               # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end42:
	.size	testG, .Lfunc_end42-testG

	.section	.text.retmeH,"ax",@progbits
	.hidden	retmeH
	.globl	retmeH
	.type	retmeH,@function
retmeH:                                 # @retmeH
	.param  	i32, i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.add 	$push3=, $1, $pop1
	i64.load	$2=, 0($pop3)
	i64.load	$push0=, 0($1)
	i64.store	$discard=, 0($0), $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i64.store	$discard=, 0($pop2), $2
	return
	.endfunc
.Lfunc_end43:
	.size	retmeH, .Lfunc_end43-retmeH

	.section	.text.fn1H,"ax",@progbits
	.hidden	fn1H
	.globl	fn1H
	.type	fn1H,@function
fn1H:                                   # @fn1H
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sH($pop0):p2align=3
	i32.const	$push2=, 23
	i32.shl 	$push3=, $0, $pop2
	i32.add 	$push4=, $pop1, $pop3
	i32.const	$push6=, 23
	i32.shr_u	$push5=, $pop4, $pop6
	return  	$pop5
	.endfunc
.Lfunc_end44:
	.size	fn1H, .Lfunc_end44-fn1H

	.section	.text.fn2H,"ax",@progbits
	.hidden	fn2H
	.globl	fn2H
	.type	fn2H,@function
fn2H:                                   # @fn2H
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sH($pop0):p2align=3
	i32.const	$push2=, 23
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 511
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push7=, 15
	i32.rem_u	$push8=, $pop6, $pop7
	return  	$pop8
	.endfunc
.Lfunc_end45:
	.size	fn2H, .Lfunc_end45-fn2H

	.section	.text.retitH,"ax",@progbits
	.hidden	retitH
	.globl	retitH
	.type	retitH,@function
retitH:                                 # @retitH
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sH($pop0):p2align=3
	i32.const	$push2=, 23
	i32.shr_u	$push3=, $pop1, $pop2
	return  	$pop3
	.endfunc
.Lfunc_end46:
	.size	retitH, .Lfunc_end46-retitH

	.section	.text.fn3H,"ax",@progbits
	.hidden	fn3H
	.globl	fn3H
	.type	fn3H,@function
fn3H:                                   # @fn3H
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push8=, 0
	i32.load	$push1=, sH($pop8):p2align=3
	i32.const	$push2=, 23
	i32.shl 	$push3=, $0, $pop2
	i32.add 	$push4=, $pop1, $pop3
	i32.store	$push5=, sH($pop0):p2align=3, $pop4
	i32.const	$push7=, 23
	i32.shr_u	$push6=, $pop5, $pop7
	return  	$pop6
	.endfunc
.Lfunc_end47:
	.size	fn3H, .Lfunc_end47-fn3H

	.section	.text.testH,"ax",@progbits
	.hidden	testH
	.globl	testH
	.type	testH,@function
testH:                                  # @testH
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push189=, 0
	i32.const	$push188=, 0
	i32.load	$push5=, myrnd.s($pop188)
	i32.const	$push187=, 1103515245
	i32.mul 	$push6=, $pop5, $pop187
	i32.const	$push186=, 12345
	i32.add 	$push7=, $pop6, $pop186
	tee_local	$push185=, $2=, $pop7
	i32.const	$push184=, 16
	i32.shr_u	$push8=, $pop185, $pop184
	i32.store8	$discard=, sH($pop189):p2align=3, $pop8
	i32.const	$push183=, 0
	i32.const	$push182=, 1103515245
	i32.mul 	$push9=, $2, $pop182
	i32.const	$push181=, 12345
	i32.add 	$push10=, $pop9, $pop181
	tee_local	$push180=, $2=, $pop10
	i32.const	$push179=, 16
	i32.shr_u	$push11=, $pop180, $pop179
	i32.store8	$discard=, sH+1($pop183), $pop11
	i32.const	$push178=, 0
	i32.const	$push177=, 1103515245
	i32.mul 	$push12=, $2, $pop177
	i32.const	$push176=, 12345
	i32.add 	$push13=, $pop12, $pop176
	tee_local	$push175=, $2=, $pop13
	i32.const	$push174=, 16
	i32.shr_u	$push14=, $pop175, $pop174
	i32.store8	$discard=, sH+2($pop178):p2align=1, $pop14
	i32.const	$push173=, 0
	i32.const	$push172=, 1103515245
	i32.mul 	$push15=, $2, $pop172
	i32.const	$push171=, 12345
	i32.add 	$push16=, $pop15, $pop171
	tee_local	$push170=, $2=, $pop16
	i32.const	$push169=, 16
	i32.shr_u	$push17=, $pop170, $pop169
	i32.store8	$discard=, sH+3($pop173), $pop17
	i32.const	$push168=, 0
	i32.const	$push167=, 1103515245
	i32.mul 	$push18=, $2, $pop167
	i32.const	$push166=, 12345
	i32.add 	$push19=, $pop18, $pop166
	tee_local	$push165=, $2=, $pop19
	i32.const	$push164=, 16
	i32.shr_u	$push20=, $pop165, $pop164
	i32.store8	$discard=, sH+4($pop168):p2align=2, $pop20
	i32.const	$push163=, 0
	i32.const	$push162=, 1103515245
	i32.mul 	$push21=, $2, $pop162
	i32.const	$push161=, 12345
	i32.add 	$push22=, $pop21, $pop161
	tee_local	$push160=, $2=, $pop22
	i32.const	$push159=, 16
	i32.shr_u	$push23=, $pop160, $pop159
	i32.store8	$discard=, sH+5($pop163), $pop23
	i32.const	$push158=, 0
	i32.const	$push157=, 1103515245
	i32.mul 	$push24=, $2, $pop157
	i32.const	$push156=, 12345
	i32.add 	$push25=, $pop24, $pop156
	tee_local	$push155=, $2=, $pop25
	i32.const	$push154=, 16
	i32.shr_u	$push26=, $pop155, $pop154
	i32.store8	$discard=, sH+6($pop158):p2align=1, $pop26
	i32.const	$push153=, 0
	i32.const	$push152=, 1103515245
	i32.mul 	$push27=, $2, $pop152
	i32.const	$push151=, 12345
	i32.add 	$push28=, $pop27, $pop151
	tee_local	$push150=, $2=, $pop28
	i32.const	$push149=, 16
	i32.shr_u	$push29=, $pop150, $pop149
	i32.store8	$discard=, sH+7($pop153), $pop29
	i32.const	$push148=, 0
	i32.const	$push147=, 1103515245
	i32.mul 	$push30=, $2, $pop147
	i32.const	$push146=, 12345
	i32.add 	$push31=, $pop30, $pop146
	tee_local	$push145=, $2=, $pop31
	i32.const	$push144=, 16
	i32.shr_u	$push32=, $pop145, $pop144
	i32.store8	$discard=, sH+8($pop148):p2align=3, $pop32
	i32.const	$push143=, 0
	i32.const	$push142=, 1103515245
	i32.mul 	$push33=, $2, $pop142
	i32.const	$push141=, 12345
	i32.add 	$push34=, $pop33, $pop141
	tee_local	$push140=, $2=, $pop34
	i32.const	$push139=, 16
	i32.shr_u	$push35=, $pop140, $pop139
	i32.store8	$discard=, sH+9($pop143), $pop35
	i32.const	$push138=, 0
	i32.const	$push137=, 1103515245
	i32.mul 	$push36=, $2, $pop137
	i32.const	$push136=, 12345
	i32.add 	$push37=, $pop36, $pop136
	tee_local	$push135=, $2=, $pop37
	i32.const	$push134=, 16
	i32.shr_u	$push38=, $pop135, $pop134
	i32.store8	$discard=, sH+10($pop138):p2align=1, $pop38
	i32.const	$push133=, 0
	i32.const	$push132=, 1103515245
	i32.mul 	$push39=, $2, $pop132
	i32.const	$push131=, 12345
	i32.add 	$push40=, $pop39, $pop131
	tee_local	$push130=, $2=, $pop40
	i32.const	$push129=, 16
	i32.shr_u	$push41=, $pop130, $pop129
	i32.store8	$discard=, sH+11($pop133), $pop41
	i32.const	$push128=, 0
	i32.const	$push127=, 1103515245
	i32.mul 	$push42=, $2, $pop127
	i32.const	$push126=, 12345
	i32.add 	$push43=, $pop42, $pop126
	tee_local	$push125=, $2=, $pop43
	i32.const	$push124=, 16
	i32.shr_u	$push44=, $pop125, $pop124
	i32.store8	$discard=, sH+12($pop128):p2align=2, $pop44
	i32.const	$push123=, 0
	i32.const	$push122=, 1103515245
	i32.mul 	$push45=, $2, $pop122
	i32.const	$push121=, 12345
	i32.add 	$push46=, $pop45, $pop121
	tee_local	$push120=, $2=, $pop46
	i32.const	$push119=, 16
	i32.shr_u	$push47=, $pop120, $pop119
	i32.store8	$discard=, sH+13($pop123), $pop47
	i32.const	$push118=, 0
	i32.const	$push117=, 1103515245
	i32.mul 	$push48=, $2, $pop117
	i32.const	$push116=, 12345
	i32.add 	$push49=, $pop48, $pop116
	tee_local	$push115=, $2=, $pop49
	i32.const	$push114=, 16
	i32.shr_u	$push50=, $pop115, $pop114
	i32.store8	$discard=, sH+14($pop118):p2align=1, $pop50
	i32.const	$push113=, 0
	i32.const	$push112=, 1103515245
	i32.mul 	$push51=, $2, $pop112
	i32.const	$push111=, 12345
	i32.add 	$push52=, $pop51, $pop111
	tee_local	$push110=, $2=, $pop52
	i32.const	$push109=, 16
	i32.shr_u	$push53=, $pop110, $pop109
	i32.store8	$discard=, sH+15($pop113), $pop53
	block
	i32.const	$push108=, 0
	i32.const	$push107=, 1103515245
	i32.mul 	$push54=, $2, $pop107
	i32.const	$push106=, 12345
	i32.add 	$push55=, $pop54, $pop106
	tee_local	$push105=, $2=, $pop55
	i32.const	$push104=, 1103515245
	i32.mul 	$push57=, $pop105, $pop104
	i32.const	$push103=, 12345
	i32.add 	$push1=, $pop57, $pop103
	i32.store	$push58=, myrnd.s($pop108), $pop1
	tee_local	$push102=, $1=, $pop58
	i32.const	$push101=, 16
	i32.shr_u	$push59=, $pop102, $pop101
	tee_local	$push100=, $0=, $pop59
	i32.const	$push99=, 16
	i32.shr_u	$push56=, $2, $pop99
	tee_local	$push98=, $2=, $pop56
	i32.add 	$push67=, $pop100, $pop98
	i32.const	$push68=, 511
	i32.and 	$push69=, $pop67, $pop68
	i32.const	$push97=, 23
	i32.shl 	$push64=, $0, $pop97
	i32.const	$push96=, 0
	i32.const	$push95=, 23
	i32.shl 	$push60=, $2, $pop95
	i32.const	$push94=, 0
	i32.load	$push0=, sH($pop94):p2align=3
	tee_local	$push93=, $2=, $pop0
	i32.const	$push92=, 8388607
	i32.and 	$push61=, $pop93, $pop92
	tee_local	$push91=, $0=, $pop61
	i32.or  	$push62=, $pop60, $pop91
	i32.store	$push63=, sH($pop96):p2align=3, $pop62
	i32.add 	$push65=, $pop64, $pop63
	i32.const	$push90=, 23
	i32.shr_u	$push66=, $pop65, $pop90
	i32.ne  	$push70=, $pop69, $pop66
	br_if   	0, $pop70       # 0: down to label8
# BB#1:                                 # %if.end76
	block
	i32.const	$push202=, 0
	i32.const	$push201=, 0
	i32.const	$push71=, -2139243339
	i32.mul 	$push72=, $1, $pop71
	i32.const	$push73=, -1492899873
	i32.add 	$push74=, $pop72, $pop73
	tee_local	$push200=, $1=, $pop74
	i32.const	$push199=, 1103515245
	i32.mul 	$push75=, $pop200, $pop199
	i32.const	$push198=, 12345
	i32.add 	$push76=, $pop75, $pop198
	i32.store	$push77=, myrnd.s($pop201), $pop76
	i32.const	$push197=, 16
	i32.shr_u	$push3=, $pop77, $pop197
	tee_local	$push196=, $3=, $pop3
	i32.const	$push195=, 23
	i32.shl 	$push80=, $pop196, $pop195
	i32.const	$push194=, 16
	i32.shr_u	$push2=, $1, $pop194
	tee_local	$push193=, $1=, $pop2
	i32.const	$push192=, 23
	i32.shl 	$push78=, $pop193, $pop192
	i32.or  	$push79=, $pop78, $0
	i32.add 	$push4=, $pop80, $pop79
	i32.store	$push81=, sH($pop202):p2align=3, $pop4
	tee_local	$push191=, $0=, $pop81
	i32.xor 	$push82=, $pop191, $2
	i32.const	$push190=, 8388607
	i32.and 	$push83=, $pop82, $pop190
	br_if   	0, $pop83       # 0: down to label9
# BB#2:                                 # %lor.lhs.false109
	i32.add 	$push86=, $3, $1
	i32.const	$push87=, 511
	i32.and 	$push88=, $pop86, $pop87
	i32.const	$push84=, 23
	i32.shr_u	$push85=, $0, $pop84
	i32.ne  	$push89=, $pop88, $pop85
	br_if   	0, $pop89       # 0: down to label9
# BB#3:                                 # %if.end115
	return
.LBB48_4:                               # %if.then114
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB48_5:                               # %if.then
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end48:
	.size	testH, .Lfunc_end48-testH

	.section	.text.retmeI,"ax",@progbits
	.hidden	retmeI
	.globl	retmeI
	.type	retmeI,@function
retmeI:                                 # @retmeI
	.param  	i32, i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.add 	$push3=, $1, $pop1
	i64.load	$2=, 0($pop3)
	i64.load	$push0=, 0($1)
	i64.store	$discard=, 0($0), $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i64.store	$discard=, 0($pop2), $2
	return
	.endfunc
.Lfunc_end49:
	.size	retmeI, .Lfunc_end49-retmeI

	.section	.text.fn1I,"ax",@progbits
	.hidden	fn1I
	.globl	fn1I
	.type	fn1I,@function
fn1I:                                   # @fn1I
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_u	$push1=, sI($pop0):p2align=3
	i32.const	$push2=, 7
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 511
	i32.and 	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end50:
	.size	fn1I, .Lfunc_end50-fn1I

	.section	.text.fn2I,"ax",@progbits
	.hidden	fn2I
	.globl	fn2I
	.type	fn2I,@function
fn2I:                                   # @fn2I
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_u	$push1=, sI($pop0):p2align=3
	i32.const	$push2=, 7
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 511
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push7=, 15
	i32.rem_u	$push8=, $pop6, $pop7
	return  	$pop8
	.endfunc
.Lfunc_end51:
	.size	fn2I, .Lfunc_end51-fn2I

	.section	.text.retitI,"ax",@progbits
	.hidden	retitI
	.globl	retitI
	.type	retitI,@function
retitI:                                 # @retitI
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_u	$push1=, sI($pop0):p2align=3
	i32.const	$push2=, 7
	i32.shr_u	$push3=, $pop1, $pop2
	return  	$pop3
	.endfunc
.Lfunc_end52:
	.size	retitI, .Lfunc_end52-retitI

	.section	.text.fn3I,"ax",@progbits
	.hidden	fn3I
	.globl	fn3I
	.type	fn3I,@function
fn3I:                                   # @fn3I
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push14=, 0
	i32.load16_u	$push1=, sI($pop14):p2align=3
	tee_local	$push13=, $1=, $pop1
	i32.const	$push2=, 7
	i32.shr_u	$push3=, $pop13, $pop2
	i32.add 	$push4=, $pop3, $0
	tee_local	$push12=, $0=, $pop4
	i32.const	$push11=, 7
	i32.shl 	$push5=, $pop12, $pop11
	i32.const	$push6=, 127
	i32.and 	$push7=, $1, $pop6
	i32.or  	$push8=, $pop5, $pop7
	i32.store16	$discard=, sI($pop0):p2align=3, $pop8
	i32.const	$push9=, 511
	i32.and 	$push10=, $0, $pop9
	return  	$pop10
	.endfunc
.Lfunc_end53:
	.size	fn3I, .Lfunc_end53-fn3I

	.section	.text.testI,"ax",@progbits
	.hidden	testI
	.globl	testI
	.type	testI,@function
testI:                                  # @testI
	.local  	i32, i32
# BB#0:                                 # %if.end136
	i32.const	$push0=, 0
	i32.const	$push152=, 0
	i32.load	$push1=, myrnd.s($pop152)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push5=, $pop3, $pop4
	tee_local	$push151=, $1=, $pop5
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop151, $pop6
	i32.store8	$discard=, sI($pop0):p2align=3, $pop7
	i32.const	$push150=, 0
	i32.const	$push149=, 1103515245
	i32.mul 	$push8=, $1, $pop149
	i32.const	$push148=, 12345
	i32.add 	$push9=, $pop8, $pop148
	tee_local	$push147=, $1=, $pop9
	i32.const	$push146=, 16
	i32.shr_u	$push10=, $pop147, $pop146
	i32.store8	$discard=, sI+1($pop150), $pop10
	i32.const	$push145=, 0
	i32.const	$push144=, 1103515245
	i32.mul 	$push11=, $1, $pop144
	i32.const	$push143=, 12345
	i32.add 	$push12=, $pop11, $pop143
	tee_local	$push142=, $1=, $pop12
	i32.const	$push141=, 16
	i32.shr_u	$push13=, $pop142, $pop141
	i32.store8	$discard=, sI+2($pop145):p2align=1, $pop13
	i32.const	$push140=, 0
	i32.const	$push139=, 1103515245
	i32.mul 	$push14=, $1, $pop139
	i32.const	$push138=, 12345
	i32.add 	$push15=, $pop14, $pop138
	tee_local	$push137=, $1=, $pop15
	i32.const	$push136=, 16
	i32.shr_u	$push16=, $pop137, $pop136
	i32.store8	$discard=, sI+3($pop140), $pop16
	i32.const	$push135=, 0
	i32.const	$push134=, 1103515245
	i32.mul 	$push17=, $1, $pop134
	i32.const	$push133=, 12345
	i32.add 	$push18=, $pop17, $pop133
	tee_local	$push132=, $1=, $pop18
	i32.const	$push131=, 16
	i32.shr_u	$push19=, $pop132, $pop131
	i32.store8	$discard=, sI+4($pop135):p2align=2, $pop19
	i32.const	$push130=, 0
	i32.const	$push129=, 1103515245
	i32.mul 	$push20=, $1, $pop129
	i32.const	$push128=, 12345
	i32.add 	$push21=, $pop20, $pop128
	tee_local	$push127=, $1=, $pop21
	i32.const	$push126=, 16
	i32.shr_u	$push22=, $pop127, $pop126
	i32.store8	$discard=, sI+5($pop130), $pop22
	i32.const	$push125=, 0
	i32.const	$push124=, 1103515245
	i32.mul 	$push23=, $1, $pop124
	i32.const	$push123=, 12345
	i32.add 	$push24=, $pop23, $pop123
	tee_local	$push122=, $1=, $pop24
	i32.const	$push121=, 16
	i32.shr_u	$push25=, $pop122, $pop121
	i32.store8	$discard=, sI+6($pop125):p2align=1, $pop25
	i32.const	$push120=, 0
	i32.const	$push119=, 1103515245
	i32.mul 	$push26=, $1, $pop119
	i32.const	$push118=, 12345
	i32.add 	$push27=, $pop26, $pop118
	tee_local	$push117=, $1=, $pop27
	i32.const	$push116=, 16
	i32.shr_u	$push28=, $pop117, $pop116
	i32.store8	$discard=, sI+7($pop120), $pop28
	i32.const	$push115=, 0
	i32.const	$push114=, 1103515245
	i32.mul 	$push29=, $1, $pop114
	i32.const	$push113=, 12345
	i32.add 	$push30=, $pop29, $pop113
	tee_local	$push112=, $1=, $pop30
	i32.const	$push111=, 16
	i32.shr_u	$push31=, $pop112, $pop111
	i32.store8	$discard=, sI+8($pop115):p2align=3, $pop31
	i32.const	$push110=, 0
	i32.const	$push109=, 1103515245
	i32.mul 	$push32=, $1, $pop109
	i32.const	$push108=, 12345
	i32.add 	$push33=, $pop32, $pop108
	tee_local	$push107=, $1=, $pop33
	i32.const	$push106=, 16
	i32.shr_u	$push34=, $pop107, $pop106
	i32.store8	$discard=, sI+9($pop110), $pop34
	i32.const	$push105=, 0
	i32.const	$push104=, 1103515245
	i32.mul 	$push35=, $1, $pop104
	i32.const	$push103=, 12345
	i32.add 	$push36=, $pop35, $pop103
	tee_local	$push102=, $1=, $pop36
	i32.const	$push101=, 16
	i32.shr_u	$push37=, $pop102, $pop101
	i32.store8	$discard=, sI+10($pop105):p2align=1, $pop37
	i32.const	$push100=, 0
	i32.const	$push99=, 1103515245
	i32.mul 	$push38=, $1, $pop99
	i32.const	$push98=, 12345
	i32.add 	$push39=, $pop38, $pop98
	tee_local	$push97=, $1=, $pop39
	i32.const	$push96=, 16
	i32.shr_u	$push40=, $pop97, $pop96
	i32.store8	$discard=, sI+11($pop100), $pop40
	i32.const	$push95=, 0
	i32.const	$push94=, 1103515245
	i32.mul 	$push41=, $1, $pop94
	i32.const	$push93=, 12345
	i32.add 	$push42=, $pop41, $pop93
	tee_local	$push92=, $1=, $pop42
	i32.const	$push91=, 16
	i32.shr_u	$push43=, $pop92, $pop91
	i32.store8	$discard=, sI+12($pop95):p2align=2, $pop43
	i32.const	$push90=, 0
	i32.const	$push89=, 1103515245
	i32.mul 	$push44=, $1, $pop89
	i32.const	$push88=, 12345
	i32.add 	$push45=, $pop44, $pop88
	tee_local	$push87=, $1=, $pop45
	i32.const	$push86=, 16
	i32.shr_u	$push46=, $pop87, $pop86
	i32.store8	$discard=, sI+13($pop90), $pop46
	i32.const	$push85=, 0
	i32.const	$push84=, 1103515245
	i32.mul 	$push47=, $1, $pop84
	i32.const	$push83=, 12345
	i32.add 	$push48=, $pop47, $pop83
	tee_local	$push82=, $1=, $pop48
	i32.const	$push81=, 16
	i32.shr_u	$push49=, $pop82, $pop81
	i32.store8	$discard=, sI+14($pop85):p2align=1, $pop49
	i32.const	$push80=, 0
	i32.const	$push79=, 1103515245
	i32.mul 	$push50=, $1, $pop79
	i32.const	$push78=, 12345
	i32.add 	$push51=, $pop50, $pop78
	tee_local	$push77=, $1=, $pop51
	i32.const	$push76=, 16
	i32.shr_u	$push52=, $pop77, $pop76
	i32.store8	$discard=, sI+15($pop80), $pop52
	i32.const	$push75=, 0
	i32.load16_u	$0=, sI($pop75):p2align=3
	i32.const	$push74=, 0
	i32.const	$push73=, 0
	i32.const	$push53=, -341751747
	i32.mul 	$push54=, $1, $pop53
	i32.const	$push55=, 229283573
	i32.add 	$push56=, $pop54, $pop55
	tee_local	$push72=, $1=, $pop56
	i32.const	$push71=, 1103515245
	i32.mul 	$push58=, $pop72, $pop71
	i32.const	$push70=, 12345
	i32.add 	$push59=, $pop58, $pop70
	i32.store	$push60=, myrnd.s($pop73), $pop59
	i32.const	$push69=, 16
	i32.shr_u	$push61=, $pop60, $pop69
	i32.const	$push68=, 16
	i32.shr_u	$push57=, $1, $pop68
	i32.add 	$push64=, $pop61, $pop57
	i32.const	$push65=, 7
	i32.shl 	$push66=, $pop64, $pop65
	i32.const	$push62=, 127
	i32.and 	$push63=, $0, $pop62
	i32.or  	$push67=, $pop66, $pop63
	i32.store16	$discard=, sI($pop74):p2align=3, $pop67
	return
	.endfunc
.Lfunc_end54:
	.size	testI, .Lfunc_end54-testI

	.section	.text.retmeJ,"ax",@progbits
	.hidden	retmeJ
	.globl	retmeJ
	.type	retmeJ,@function
retmeJ:                                 # @retmeJ
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($1):p2align=1
	i32.store	$discard=, 0($0):p2align=1, $pop0
	return
	.endfunc
.Lfunc_end55:
	.size	retmeJ, .Lfunc_end55-retmeJ

	.section	.text.fn1J,"ax",@progbits
	.hidden	fn1J
	.globl	fn1J
	.type	fn1J,@function
fn1J:                                   # @fn1J
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sJ($pop0)
	i32.const	$push2=, 9
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 127
	i32.and 	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end56:
	.size	fn1J, .Lfunc_end56-fn1J

	.section	.text.fn2J,"ax",@progbits
	.hidden	fn2J
	.globl	fn2J
	.type	fn2J,@function
fn2J:                                   # @fn2J
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_u	$push1=, sJ($pop0):p2align=2
	i32.const	$push2=, 9
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 127
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push7=, 15
	i32.rem_u	$push8=, $pop6, $pop7
	return  	$pop8
	.endfunc
.Lfunc_end57:
	.size	fn2J, .Lfunc_end57-fn2J

	.section	.text.retitJ,"ax",@progbits
	.hidden	retitJ
	.globl	retitJ
	.type	retitJ,@function
retitJ:                                 # @retitJ
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_u	$push1=, sJ($pop0):p2align=2
	i32.const	$push2=, 9
	i32.shr_u	$push3=, $pop1, $pop2
	return  	$pop3
	.endfunc
.Lfunc_end58:
	.size	retitJ, .Lfunc_end58-retitJ

	.section	.text.fn3J,"ax",@progbits
	.hidden	fn3J
	.globl	fn3J
	.type	fn3J,@function
fn3J:                                   # @fn3J
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push14=, 0
	i32.load16_u	$push1=, sJ($pop14):p2align=2
	tee_local	$push13=, $1=, $pop1
	i32.const	$push2=, 9
	i32.shr_u	$push3=, $pop13, $pop2
	i32.add 	$push4=, $pop3, $0
	tee_local	$push12=, $0=, $pop4
	i32.const	$push11=, 9
	i32.shl 	$push5=, $pop12, $pop11
	i32.const	$push6=, 511
	i32.and 	$push7=, $1, $pop6
	i32.or  	$push8=, $pop5, $pop7
	i32.store16	$discard=, sJ($pop0):p2align=2, $pop8
	i32.const	$push9=, 127
	i32.and 	$push10=, $0, $pop9
	return  	$pop10
	.endfunc
.Lfunc_end59:
	.size	fn3J, .Lfunc_end59-fn3J

	.section	.text.testJ,"ax",@progbits
	.hidden	testJ
	.globl	testJ
	.type	testJ,@function
testJ:                                  # @testJ
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push80=, 0
	i32.const	$push79=, 0
	i32.load	$push1=, myrnd.s($pop79)
	i32.const	$push78=, 1103515245
	i32.mul 	$push2=, $pop1, $pop78
	i32.const	$push77=, 12345
	i32.add 	$push3=, $pop2, $pop77
	tee_local	$push76=, $0=, $pop3
	i32.const	$push75=, 16
	i32.shr_u	$push4=, $pop76, $pop75
	i32.store8	$discard=, sJ($pop80):p2align=2, $pop4
	i32.const	$push74=, 0
	i32.const	$push73=, 1103515245
	i32.mul 	$push5=, $0, $pop73
	i32.const	$push72=, 12345
	i32.add 	$push6=, $pop5, $pop72
	tee_local	$push71=, $0=, $pop6
	i32.const	$push70=, 16
	i32.shr_u	$push7=, $pop71, $pop70
	i32.store8	$discard=, sJ+1($pop74), $pop7
	i32.const	$push69=, 0
	i32.const	$push68=, 1103515245
	i32.mul 	$push8=, $0, $pop68
	i32.const	$push67=, 12345
	i32.add 	$push9=, $pop8, $pop67
	tee_local	$push66=, $0=, $pop9
	i32.const	$push65=, 16
	i32.shr_u	$push10=, $pop66, $pop65
	i32.store8	$discard=, sJ+2($pop69):p2align=1, $pop10
	i32.const	$push64=, 0
	i32.const	$push63=, 1103515245
	i32.mul 	$push11=, $0, $pop63
	i32.const	$push62=, 12345
	i32.add 	$push12=, $pop11, $pop62
	tee_local	$push61=, $0=, $pop12
	i32.const	$push60=, 16
	i32.shr_u	$push13=, $pop61, $pop60
	i32.store8	$discard=, sJ+3($pop64), $pop13
	i32.const	$push59=, 0
	i32.const	$push58=, 1103515245
	i32.mul 	$push15=, $0, $pop58
	i32.const	$push57=, 12345
	i32.add 	$push16=, $pop15, $pop57
	tee_local	$push56=, $3=, $pop16
	i32.const	$push55=, 16
	i32.shr_u	$push17=, $pop56, $pop55
	tee_local	$push54=, $2=, $pop17
	i32.const	$push53=, 9
	i32.shl 	$push21=, $pop54, $pop53
	i32.const	$push52=, 0
	i32.load16_u	$push14=, sJ($pop52):p2align=2
	i32.const	$push51=, 511
	i32.and 	$push22=, $pop14, $pop51
	i32.or  	$push23=, $pop21, $pop22
	i32.store16	$discard=, sJ($pop59):p2align=2, $pop23
	i32.const	$push50=, 0
	i32.load	$0=, sJ($pop50)
	block
	i32.const	$push49=, 0
	i32.const	$push48=, 1103515245
	i32.mul 	$push18=, $3, $pop48
	i32.const	$push47=, 12345
	i32.add 	$push0=, $pop18, $pop47
	i32.store	$push19=, myrnd.s($pop49), $pop0
	tee_local	$push46=, $1=, $pop19
	i32.const	$push45=, 16
	i32.shr_u	$push20=, $pop46, $pop45
	tee_local	$push44=, $3=, $pop20
	i32.add 	$push26=, $pop44, $2
	i32.const	$push43=, 9
	i32.shr_u	$push24=, $0, $pop43
	i32.add 	$push25=, $pop24, $3
	i32.xor 	$push27=, $pop26, $pop25
	i32.const	$push28=, 127
	i32.and 	$push29=, $pop27, $pop28
	br_if   	0, $pop29       # 0: down to label10
# BB#1:                                 # %if.end142
	i32.const	$push89=, 0
	i32.const	$push88=, 0
	i32.const	$push30=, -2139243339
	i32.mul 	$push31=, $1, $pop30
	i32.const	$push32=, -1492899873
	i32.add 	$push33=, $pop31, $pop32
	tee_local	$push87=, $3=, $pop33
	i32.const	$push86=, 1103515245
	i32.mul 	$push35=, $pop87, $pop86
	i32.const	$push85=, 12345
	i32.add 	$push36=, $pop35, $pop85
	i32.store	$push37=, myrnd.s($pop88), $pop36
	i32.const	$push84=, 16
	i32.shr_u	$push38=, $pop37, $pop84
	i32.const	$push83=, 16
	i32.shr_u	$push34=, $3, $pop83
	i32.add 	$push40=, $pop38, $pop34
	i32.const	$push82=, 9
	i32.shl 	$push41=, $pop40, $pop82
	i32.const	$push81=, 511
	i32.and 	$push39=, $0, $pop81
	i32.or  	$push42=, $pop41, $pop39
	i32.store16	$discard=, sJ($pop89):p2align=2, $pop42
	return
.LBB60_2:                               # %if.then
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end60:
	.size	testJ, .Lfunc_end60-testJ

	.section	.text.retmeK,"ax",@progbits
	.hidden	retmeK
	.globl	retmeK
	.type	retmeK,@function
retmeK:                                 # @retmeK
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($1)
	i32.store	$discard=, 0($0), $pop0
	return
	.endfunc
.Lfunc_end61:
	.size	retmeK, .Lfunc_end61-retmeK

	.section	.text.fn1K,"ax",@progbits
	.hidden	fn1K
	.globl	fn1K
	.type	fn1K,@function
fn1K:                                   # @fn1K
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sK($pop0)
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 63
	i32.and 	$push4=, $pop2, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end62:
	.size	fn1K, .Lfunc_end62-fn1K

	.section	.text.fn2K,"ax",@progbits
	.hidden	fn2K
	.globl	fn2K
	.type	fn2K,@function
fn2K:                                   # @fn2K
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sK($pop0)
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 63
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push5=, 15
	i32.rem_u	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end63:
	.size	fn2K, .Lfunc_end63-fn2K

	.section	.text.retitK,"ax",@progbits
	.hidden	retitK
	.globl	retitK
	.type	retitK,@function
retitK:                                 # @retitK
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sK($pop0)
	i32.const	$push2=, 63
	i32.and 	$push3=, $pop1, $pop2
	return  	$pop3
	.endfunc
.Lfunc_end64:
	.size	retitK, .Lfunc_end64-retitK

	.section	.text.fn3K,"ax",@progbits
	.hidden	fn3K
	.globl	fn3K
	.type	fn3K,@function
fn3K:                                   # @fn3K
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push1=, sK($pop10)
	tee_local	$push9=, $1=, $pop1
	i32.add 	$push2=, $pop9, $0
	i32.const	$push3=, 63
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push8=, $0=, $pop4
	i32.const	$push5=, -64
	i32.and 	$push6=, $1, $pop5
	i32.or  	$push7=, $pop8, $pop6
	i32.store	$discard=, sK($pop0), $pop7
	return  	$0
	.endfunc
.Lfunc_end65:
	.size	fn3K, .Lfunc_end65-fn3K

	.section	.text.testK,"ax",@progbits
	.hidden	testK
	.globl	testK
	.type	testK,@function
testK:                                  # @testK
	.local  	i32, i32
# BB#0:                                 # %if.end129
	i32.const	$push0=, 0
	i32.const	$push56=, 0
	i32.load	$push1=, myrnd.s($pop56)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push5=, $pop3, $pop4
	tee_local	$push55=, $1=, $pop5
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop55, $pop6
	i32.store8	$discard=, sK($pop0):p2align=2, $pop7
	i32.const	$push54=, 0
	i32.const	$push53=, 1103515245
	i32.mul 	$push8=, $1, $pop53
	i32.const	$push52=, 12345
	i32.add 	$push9=, $pop8, $pop52
	tee_local	$push51=, $1=, $pop9
	i32.const	$push50=, 16
	i32.shr_u	$push10=, $pop51, $pop50
	i32.store8	$discard=, sK+1($pop54), $pop10
	i32.const	$push49=, 0
	i32.const	$push48=, 1103515245
	i32.mul 	$push11=, $1, $pop48
	i32.const	$push47=, 12345
	i32.add 	$push12=, $pop11, $pop47
	tee_local	$push46=, $1=, $pop12
	i32.const	$push45=, 16
	i32.shr_u	$push13=, $pop46, $pop45
	i32.store8	$discard=, sK+2($pop49):p2align=1, $pop13
	i32.const	$push44=, 0
	i32.const	$push43=, 1103515245
	i32.mul 	$push14=, $1, $pop43
	i32.const	$push42=, 12345
	i32.add 	$push15=, $pop14, $pop42
	tee_local	$push41=, $1=, $pop15
	i32.const	$push40=, 16
	i32.shr_u	$push16=, $pop41, $pop40
	i32.store8	$discard=, sK+3($pop44), $pop16
	i32.const	$push39=, 0
	i32.load	$0=, sK($pop39)
	i32.const	$push38=, 0
	i32.const	$push37=, 0
	i32.const	$push19=, -341751747
	i32.mul 	$push20=, $1, $pop19
	i32.const	$push21=, 229283573
	i32.add 	$push22=, $pop20, $pop21
	tee_local	$push36=, $1=, $pop22
	i32.const	$push35=, 1103515245
	i32.mul 	$push24=, $pop36, $pop35
	i32.const	$push34=, 12345
	i32.add 	$push25=, $pop24, $pop34
	i32.store	$push26=, myrnd.s($pop37), $pop25
	i32.const	$push33=, 16
	i32.shr_u	$push27=, $pop26, $pop33
	i32.const	$push32=, 16
	i32.shr_u	$push23=, $1, $pop32
	i32.add 	$push28=, $pop27, $pop23
	i32.const	$push29=, 63
	i32.and 	$push30=, $pop28, $pop29
	i32.const	$push17=, -64
	i32.and 	$push18=, $0, $pop17
	i32.or  	$push31=, $pop30, $pop18
	i32.store	$discard=, sK($pop38), $pop31
	return
	.endfunc
.Lfunc_end66:
	.size	testK, .Lfunc_end66-testK

	.section	.text.retmeL,"ax",@progbits
	.hidden	retmeL
	.globl	retmeL
	.type	retmeL,@function
retmeL:                                 # @retmeL
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1):p2align=2
	i64.store	$discard=, 0($0):p2align=2, $pop0
	return
	.endfunc
.Lfunc_end67:
	.size	retmeL, .Lfunc_end67-retmeL

	.section	.text.fn1L,"ax",@progbits
	.hidden	fn1L
	.globl	fn1L
	.type	fn1L,@function
fn1L:                                   # @fn1L
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sL($pop0):p2align=3
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 63
	i32.and 	$push4=, $pop2, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end68:
	.size	fn1L, .Lfunc_end68-fn1L

	.section	.text.fn2L,"ax",@progbits
	.hidden	fn2L
	.globl	fn2L
	.type	fn2L,@function
fn2L:                                   # @fn2L
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sL($pop0):p2align=3
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 63
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push5=, 15
	i32.rem_u	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end69:
	.size	fn2L, .Lfunc_end69-fn2L

	.section	.text.retitL,"ax",@progbits
	.hidden	retitL
	.globl	retitL
	.type	retitL,@function
retitL:                                 # @retitL
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sL($pop0):p2align=3
	i32.const	$push2=, 63
	i32.and 	$push3=, $pop1, $pop2
	return  	$pop3
	.endfunc
.Lfunc_end70:
	.size	retitL, .Lfunc_end70-retitL

	.section	.text.fn3L,"ax",@progbits
	.hidden	fn3L
	.globl	fn3L
	.type	fn3L,@function
fn3L:                                   # @fn3L
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push1=, sL($pop10):p2align=3
	tee_local	$push9=, $1=, $pop1
	i32.add 	$push2=, $pop9, $0
	i32.const	$push3=, 63
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push8=, $0=, $pop4
	i32.const	$push5=, -64
	i32.and 	$push6=, $1, $pop5
	i32.or  	$push7=, $pop8, $pop6
	i32.store	$discard=, sL($pop0):p2align=3, $pop7
	return  	$0
	.endfunc
.Lfunc_end71:
	.size	fn3L, .Lfunc_end71-fn3L

	.section	.text.testL,"ax",@progbits
	.hidden	testL
	.globl	testL
	.type	testL,@function
testL:                                  # @testL
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push110=, 0
	i32.const	$push109=, 0
	i32.load	$push2=, myrnd.s($pop109)
	i32.const	$push108=, 1103515245
	i32.mul 	$push3=, $pop2, $pop108
	i32.const	$push107=, 12345
	i32.add 	$push4=, $pop3, $pop107
	tee_local	$push106=, $3=, $pop4
	i32.const	$push105=, 16
	i32.shr_u	$push5=, $pop106, $pop105
	i32.store8	$discard=, sL($pop110):p2align=3, $pop5
	i32.const	$push104=, 0
	i32.const	$push103=, 1103515245
	i32.mul 	$push6=, $3, $pop103
	i32.const	$push102=, 12345
	i32.add 	$push7=, $pop6, $pop102
	tee_local	$push101=, $3=, $pop7
	i32.const	$push100=, 16
	i32.shr_u	$push8=, $pop101, $pop100
	i32.store8	$discard=, sL+1($pop104), $pop8
	i32.const	$push99=, 0
	i32.const	$push98=, 1103515245
	i32.mul 	$push9=, $3, $pop98
	i32.const	$push97=, 12345
	i32.add 	$push10=, $pop9, $pop97
	tee_local	$push96=, $3=, $pop10
	i32.const	$push95=, 16
	i32.shr_u	$push11=, $pop96, $pop95
	i32.store8	$discard=, sL+2($pop99):p2align=1, $pop11
	i32.const	$push94=, 0
	i32.const	$push93=, 1103515245
	i32.mul 	$push12=, $3, $pop93
	i32.const	$push92=, 12345
	i32.add 	$push13=, $pop12, $pop92
	tee_local	$push91=, $3=, $pop13
	i32.const	$push90=, 16
	i32.shr_u	$push14=, $pop91, $pop90
	i32.store8	$discard=, sL+3($pop94), $pop14
	i32.const	$push89=, 0
	i32.const	$push88=, 1103515245
	i32.mul 	$push15=, $3, $pop88
	i32.const	$push87=, 12345
	i32.add 	$push16=, $pop15, $pop87
	tee_local	$push86=, $3=, $pop16
	i32.const	$push85=, 16
	i32.shr_u	$push17=, $pop86, $pop85
	i32.store8	$discard=, sL+4($pop89):p2align=2, $pop17
	i32.const	$push84=, 0
	i32.const	$push83=, 1103515245
	i32.mul 	$push18=, $3, $pop83
	i32.const	$push82=, 12345
	i32.add 	$push19=, $pop18, $pop82
	tee_local	$push81=, $3=, $pop19
	i32.const	$push80=, 16
	i32.shr_u	$push20=, $pop81, $pop80
	i32.store8	$discard=, sL+5($pop84), $pop20
	i32.const	$push79=, 0
	i32.const	$push78=, 1103515245
	i32.mul 	$push21=, $3, $pop78
	i32.const	$push77=, 12345
	i32.add 	$push22=, $pop21, $pop77
	tee_local	$push76=, $3=, $pop22
	i32.const	$push75=, 16
	i32.shr_u	$push23=, $pop76, $pop75
	i32.store8	$discard=, sL+6($pop79):p2align=1, $pop23
	i32.const	$push74=, 0
	i32.const	$push73=, 1103515245
	i32.mul 	$push24=, $3, $pop73
	i32.const	$push72=, 12345
	i32.add 	$push25=, $pop24, $pop72
	tee_local	$push71=, $3=, $pop25
	i32.const	$push70=, 16
	i32.shr_u	$push26=, $pop71, $pop70
	i32.store8	$discard=, sL+7($pop74), $pop26
	i32.const	$push69=, 0
	i32.load	$0=, sL($pop69):p2align=3
	block
	i32.const	$push68=, 0
	i32.const	$push67=, 1103515245
	i32.mul 	$push27=, $3, $pop67
	i32.const	$push66=, 12345
	i32.add 	$push28=, $pop27, $pop66
	tee_local	$push65=, $3=, $pop28
	i32.const	$push64=, 1103515245
	i32.mul 	$push30=, $pop65, $pop64
	i32.const	$push63=, 12345
	i32.add 	$push0=, $pop30, $pop63
	i32.store	$push31=, myrnd.s($pop68), $pop0
	tee_local	$push62=, $2=, $pop31
	i32.const	$push61=, 16
	i32.shr_u	$push32=, $pop62, $pop61
	tee_local	$push60=, $1=, $pop32
	i32.const	$push59=, 16
	i32.shr_u	$push29=, $3, $pop59
	tee_local	$push58=, $3=, $pop29
	i32.add 	$push37=, $pop60, $pop58
	i32.const	$push57=, 0
	i32.const	$push56=, 63
	i32.and 	$push33=, $3, $pop56
	i32.const	$push55=, -64
	i32.and 	$push34=, $0, $pop55
	i32.or  	$push1=, $pop33, $pop34
	i32.store	$push35=, sL($pop57):p2align=3, $pop1
	tee_local	$push54=, $3=, $pop35
	i32.add 	$push36=, $pop54, $1
	i32.xor 	$push38=, $pop37, $pop36
	i32.const	$push53=, 63
	i32.and 	$push39=, $pop38, $pop53
	br_if   	0, $pop39       # 0: down to label11
# BB#1:                                 # %if.end75
	i32.const	$push119=, 0
	i32.const	$push118=, 0
	i32.const	$push41=, -2139243339
	i32.mul 	$push42=, $2, $pop41
	i32.const	$push43=, -1492899873
	i32.add 	$push44=, $pop42, $pop43
	tee_local	$push117=, $0=, $pop44
	i32.const	$push116=, 1103515245
	i32.mul 	$push46=, $pop117, $pop116
	i32.const	$push115=, 12345
	i32.add 	$push47=, $pop46, $pop115
	i32.store	$push48=, myrnd.s($pop118), $pop47
	i32.const	$push114=, 16
	i32.shr_u	$push49=, $pop48, $pop114
	i32.const	$push113=, 16
	i32.shr_u	$push45=, $0, $pop113
	i32.add 	$push50=, $pop49, $pop45
	i32.const	$push112=, 63
	i32.and 	$push51=, $pop50, $pop112
	i32.const	$push111=, -64
	i32.and 	$push40=, $3, $pop111
	i32.or  	$push52=, $pop51, $pop40
	i32.store	$discard=, sL($pop119):p2align=3, $pop52
	return
.LBB72_2:                               # %if.then
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end72:
	.size	testL, .Lfunc_end72-testL

	.section	.text.retmeM,"ax",@progbits
	.hidden	retmeM
	.globl	retmeM
	.type	retmeM,@function
retmeM:                                 # @retmeM
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1):p2align=2
	i64.store	$discard=, 0($0):p2align=2, $pop0
	return
	.endfunc
.Lfunc_end73:
	.size	retmeM, .Lfunc_end73-retmeM

	.section	.text.fn1M,"ax",@progbits
	.hidden	fn1M
	.globl	fn1M
	.type	fn1M,@function
fn1M:                                   # @fn1M
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sM+4($pop0)
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 63
	i32.and 	$push4=, $pop2, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end74:
	.size	fn1M, .Lfunc_end74-fn1M

	.section	.text.fn2M,"ax",@progbits
	.hidden	fn2M
	.globl	fn2M
	.type	fn2M,@function
fn2M:                                   # @fn2M
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sM+4($pop0)
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 63
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push5=, 15
	i32.rem_u	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end75:
	.size	fn2M, .Lfunc_end75-fn2M

	.section	.text.retitM,"ax",@progbits
	.hidden	retitM
	.globl	retitM
	.type	retitM,@function
retitM:                                 # @retitM
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sM+4($pop0)
	i32.const	$push2=, 63
	i32.and 	$push3=, $pop1, $pop2
	return  	$pop3
	.endfunc
.Lfunc_end76:
	.size	retitM, .Lfunc_end76-retitM

	.section	.text.fn3M,"ax",@progbits
	.hidden	fn3M
	.globl	fn3M
	.type	fn3M,@function
fn3M:                                   # @fn3M
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push1=, sM+4($pop10)
	tee_local	$push9=, $1=, $pop1
	i32.add 	$push2=, $pop9, $0
	i32.const	$push3=, 63
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push8=, $0=, $pop4
	i32.const	$push5=, -64
	i32.and 	$push6=, $1, $pop5
	i32.or  	$push7=, $pop8, $pop6
	i32.store	$discard=, sM+4($pop0), $pop7
	return  	$0
	.endfunc
.Lfunc_end77:
	.size	fn3M, .Lfunc_end77-fn3M

	.section	.text.testM,"ax",@progbits
	.hidden	testM
	.globl	testM
	.type	testM,@function
testM:                                  # @testM
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push107=, 0
	i32.const	$push106=, 0
	i32.load	$push2=, myrnd.s($pop106)
	i32.const	$push105=, 1103515245
	i32.mul 	$push3=, $pop2, $pop105
	i32.const	$push104=, 12345
	i32.add 	$push4=, $pop3, $pop104
	tee_local	$push103=, $1=, $pop4
	i32.const	$push102=, 16
	i32.shr_u	$push5=, $pop103, $pop102
	i32.store8	$discard=, sM($pop107):p2align=3, $pop5
	i32.const	$push101=, 0
	i32.const	$push100=, 1103515245
	i32.mul 	$push6=, $1, $pop100
	i32.const	$push99=, 12345
	i32.add 	$push7=, $pop6, $pop99
	tee_local	$push98=, $1=, $pop7
	i32.const	$push97=, 16
	i32.shr_u	$push8=, $pop98, $pop97
	i32.store8	$discard=, sM+1($pop101), $pop8
	i32.const	$push96=, 0
	i32.const	$push95=, 1103515245
	i32.mul 	$push9=, $1, $pop95
	i32.const	$push94=, 12345
	i32.add 	$push10=, $pop9, $pop94
	tee_local	$push93=, $1=, $pop10
	i32.const	$push92=, 16
	i32.shr_u	$push11=, $pop93, $pop92
	i32.store8	$discard=, sM+2($pop96):p2align=1, $pop11
	i32.const	$push91=, 0
	i32.const	$push90=, 1103515245
	i32.mul 	$push12=, $1, $pop90
	i32.const	$push89=, 12345
	i32.add 	$push13=, $pop12, $pop89
	tee_local	$push88=, $1=, $pop13
	i32.const	$push87=, 1103515245
	i32.mul 	$push15=, $pop88, $pop87
	i32.const	$push86=, 12345
	i32.add 	$push16=, $pop15, $pop86
	tee_local	$push85=, $3=, $pop16
	i32.const	$push84=, 16
	i32.shr_u	$push17=, $pop85, $pop84
	i32.store8	$discard=, sM+4($pop91):p2align=2, $pop17
	i32.const	$push83=, 0
	i32.const	$push82=, 1103515245
	i32.mul 	$push18=, $3, $pop82
	i32.const	$push81=, 12345
	i32.add 	$push19=, $pop18, $pop81
	tee_local	$push80=, $3=, $pop19
	i32.const	$push79=, 16
	i32.shr_u	$push20=, $pop80, $pop79
	i32.store8	$discard=, sM+5($pop83), $pop20
	i32.const	$push78=, 0
	i32.const	$push77=, 1103515245
	i32.mul 	$push21=, $3, $pop77
	i32.const	$push76=, 12345
	i32.add 	$push22=, $pop21, $pop76
	tee_local	$push75=, $3=, $pop22
	i32.const	$push74=, 16
	i32.shr_u	$push23=, $pop75, $pop74
	i32.store8	$discard=, sM+6($pop78):p2align=1, $pop23
	i32.const	$push73=, 0
	i32.const	$push72=, 1103515245
	i32.mul 	$push24=, $3, $pop72
	i32.const	$push71=, 12345
	i32.add 	$push25=, $pop24, $pop71
	tee_local	$push70=, $3=, $pop25
	i32.const	$push69=, 16
	i32.shr_u	$push26=, $pop70, $pop69
	i32.store8	$discard=, sM+7($pop73), $pop26
	i32.const	$push68=, 0
	i32.load	$0=, sM+4($pop68)
	i32.const	$push67=, 0
	i32.const	$push66=, 16
	i32.shr_u	$push14=, $1, $pop66
	i32.store8	$discard=, sM+3($pop67), $pop14
	i32.const	$push65=, 0
	i32.const	$push64=, 1103515245
	i32.mul 	$push27=, $3, $pop64
	i32.const	$push63=, 12345
	i32.add 	$push28=, $pop27, $pop63
	tee_local	$push62=, $3=, $pop28
	i32.const	$push61=, 1103515245
	i32.mul 	$push30=, $pop62, $pop61
	i32.const	$push60=, 12345
	i32.add 	$push0=, $pop30, $pop60
	i32.store	$1=, myrnd.s($pop65), $pop0
	block
	i32.const	$push59=, 0
	i32.const	$push58=, 16
	i32.shr_u	$push29=, $3, $pop58
	tee_local	$push57=, $3=, $pop29
	i32.const	$push56=, 63
	i32.and 	$push32=, $pop57, $pop56
	i32.const	$push33=, -64
	i32.and 	$push1=, $0, $pop33
	tee_local	$push55=, $2=, $pop1
	i32.or  	$push34=, $pop32, $pop55
	i32.store	$push35=, sM+4($pop59), $pop34
	i32.const	$push54=, 16
	i32.shr_u	$push31=, $1, $pop54
	tee_local	$push53=, $0=, $pop31
	i32.add 	$push36=, $pop35, $pop53
	i32.add 	$push37=, $0, $3
	i32.xor 	$push38=, $pop36, $pop37
	i32.const	$push52=, 63
	i32.and 	$push39=, $pop38, $pop52
	br_if   	0, $pop39       # 0: down to label12
# BB#1:                                 # %if.end79
	i32.const	$push115=, 0
	i32.const	$push114=, 0
	i32.const	$push40=, -2139243339
	i32.mul 	$push41=, $1, $pop40
	i32.const	$push42=, -1492899873
	i32.add 	$push43=, $pop41, $pop42
	tee_local	$push113=, $1=, $pop43
	i32.const	$push112=, 1103515245
	i32.mul 	$push45=, $pop113, $pop112
	i32.const	$push111=, 12345
	i32.add 	$push46=, $pop45, $pop111
	i32.store	$push47=, myrnd.s($pop114), $pop46
	i32.const	$push110=, 16
	i32.shr_u	$push48=, $pop47, $pop110
	i32.const	$push109=, 16
	i32.shr_u	$push44=, $1, $pop109
	i32.add 	$push49=, $pop48, $pop44
	i32.const	$push108=, 63
	i32.and 	$push50=, $pop49, $pop108
	i32.or  	$push51=, $pop50, $2
	i32.store	$discard=, sM+4($pop115), $pop51
	return
.LBB78_2:                               # %if.then
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end78:
	.size	testM, .Lfunc_end78-testM

	.section	.text.retmeN,"ax",@progbits
	.hidden	retmeN
	.globl	retmeN
	.type	retmeN,@function
retmeN:                                 # @retmeN
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	$discard=, 0($0), $pop0
	return
	.endfunc
.Lfunc_end79:
	.size	retmeN, .Lfunc_end79-retmeN

	.section	.text.fn1N,"ax",@progbits
	.hidden	fn1N
	.globl	fn1N
	.type	fn1N,@function
fn1N:                                   # @fn1N
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sN($pop0):p2align=3
	i32.const	$push2=, 6
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 63
	i32.and 	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end80:
	.size	fn1N, .Lfunc_end80-fn1N

	.section	.text.fn2N,"ax",@progbits
	.hidden	fn2N
	.globl	fn2N
	.type	fn2N,@function
fn2N:                                   # @fn2N
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sN($pop0):p2align=3
	i32.const	$push2=, 6
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 63
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push7=, 15
	i32.rem_u	$push8=, $pop6, $pop7
	return  	$pop8
	.endfunc
.Lfunc_end81:
	.size	fn2N, .Lfunc_end81-fn2N

	.section	.text.retitN,"ax",@progbits
	.hidden	retitN
	.globl	retitN
	.type	retitN,@function
retitN:                                 # @retitN
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sN($pop0):p2align=3
	i32.const	$push2=, 6
	i32.shr_u	$push3=, $pop1, $pop2
	i32.const	$push4=, 63
	i32.and 	$push5=, $pop3, $pop4
	return  	$pop5
	.endfunc
.Lfunc_end82:
	.size	retitN, .Lfunc_end82-retitN

	.section	.text.fn3N,"ax",@progbits
	.hidden	fn3N
	.globl	fn3N
	.type	fn3N,@function
fn3N:                                   # @fn3N
	.param  	i32
	.result 	i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push18=, 0
	i64.load	$push1=, sN($pop18)
	tee_local	$push17=, $1=, $pop1
	i64.const	$push2=, 6
	i64.shr_u	$push3=, $pop17, $pop2
	i32.wrap/i64	$push4=, $pop3
	i32.add 	$push5=, $pop4, $0
	tee_local	$push16=, $0=, $pop5
	i32.const	$push6=, 6
	i32.shl 	$push7=, $pop16, $pop6
	i64.extend_u/i32	$push8=, $pop7
	i64.const	$push9=, 4032
	i64.and 	$push10=, $pop8, $pop9
	i64.const	$push11=, -4033
	i64.and 	$push12=, $1, $pop11
	i64.or  	$push13=, $pop10, $pop12
	i64.store	$discard=, sN($pop0), $pop13
	i32.const	$push14=, 63
	i32.and 	$push15=, $0, $pop14
	return  	$pop15
	.endfunc
.Lfunc_end83:
	.size	fn3N, .Lfunc_end83-fn3N

	.section	.text.testN,"ax",@progbits
	.hidden	testN
	.globl	testN
	.type	testN,@function
testN:                                  # @testN
	.local  	i32, i32, i64, i64, i64, i32, i32, i32
# BB#0:                                 # %lor.lhs.false
	i32.const	$push13=, 0
	i32.const	$push179=, 0
	i32.load	$push14=, myrnd.s($pop179)
	i32.const	$push15=, 1103515245
	i32.mul 	$push16=, $pop14, $pop15
	i32.const	$push17=, 12345
	i32.add 	$push18=, $pop16, $pop17
	tee_local	$push178=, $5=, $pop18
	i32.const	$push177=, 16
	i32.shr_u	$push19=, $pop178, $pop177
	i32.store8	$discard=, sN($pop13):p2align=3, $pop19
	i32.const	$push176=, 0
	i32.const	$push175=, 1103515245
	i32.mul 	$push20=, $5, $pop175
	i32.const	$push174=, 12345
	i32.add 	$push21=, $pop20, $pop174
	tee_local	$push173=, $5=, $pop21
	i32.const	$push172=, 16
	i32.shr_u	$push22=, $pop173, $pop172
	i32.store8	$discard=, sN+1($pop176), $pop22
	i32.const	$push171=, 0
	i32.const	$push170=, 1103515245
	i32.mul 	$push23=, $5, $pop170
	i32.const	$push169=, 12345
	i32.add 	$push24=, $pop23, $pop169
	tee_local	$push168=, $5=, $pop24
	i32.const	$push167=, 16
	i32.shr_u	$push25=, $pop168, $pop167
	i32.store8	$discard=, sN+2($pop171):p2align=1, $pop25
	i32.const	$push166=, 0
	i32.const	$push165=, 1103515245
	i32.mul 	$push26=, $5, $pop165
	i32.const	$push164=, 12345
	i32.add 	$push27=, $pop26, $pop164
	tee_local	$push163=, $5=, $pop27
	i32.const	$push162=, 16
	i32.shr_u	$push28=, $pop163, $pop162
	i32.store8	$discard=, sN+3($pop166), $pop28
	i32.const	$push161=, 0
	i32.const	$push160=, 1103515245
	i32.mul 	$push29=, $5, $pop160
	i32.const	$push159=, 12345
	i32.add 	$push30=, $pop29, $pop159
	tee_local	$push158=, $5=, $pop30
	i32.const	$push157=, 16
	i32.shr_u	$push31=, $pop158, $pop157
	i32.store8	$discard=, sN+4($pop161):p2align=2, $pop31
	i32.const	$push156=, 0
	i32.const	$push155=, 1103515245
	i32.mul 	$push32=, $5, $pop155
	i32.const	$push154=, 12345
	i32.add 	$push33=, $pop32, $pop154
	tee_local	$push153=, $5=, $pop33
	i32.const	$push152=, 16
	i32.shr_u	$push34=, $pop153, $pop152
	i32.store8	$discard=, sN+5($pop156), $pop34
	i32.const	$push151=, 0
	i32.const	$push150=, 1103515245
	i32.mul 	$push35=, $5, $pop150
	i32.const	$push149=, 12345
	i32.add 	$push36=, $pop35, $pop149
	tee_local	$push148=, $5=, $pop36
	i32.const	$push147=, 16
	i32.shr_u	$push37=, $pop148, $pop147
	i32.store8	$discard=, sN+6($pop151):p2align=1, $pop37
	i32.const	$push146=, 0
	i32.const	$push145=, 1103515245
	i32.mul 	$push38=, $5, $pop145
	i32.const	$push144=, 12345
	i32.add 	$push39=, $pop38, $pop144
	tee_local	$push143=, $5=, $pop39
	i32.const	$push142=, 16
	i32.shr_u	$push40=, $pop143, $pop142
	i32.store8	$discard=, sN+7($pop146), $pop40
	i32.const	$push141=, 0
	i32.const	$push140=, 1103515245
	i32.mul 	$push44=, $5, $pop140
	i32.const	$push139=, 12345
	i32.add 	$push45=, $pop44, $pop139
	tee_local	$push138=, $5=, $pop45
	i32.const	$push137=, 1103515245
	i32.mul 	$push46=, $pop138, $pop137
	i32.const	$push136=, 12345
	i32.add 	$push1=, $pop46, $pop136
	i32.store	$1=, myrnd.s($pop141), $pop1
	block
	i32.const	$push135=, 0
	i32.const	$push47=, 10
	i32.shr_u	$push48=, $5, $pop47
	i64.extend_u/i32	$push49=, $pop48
	i64.const	$push42=, 4032
	i64.and 	$push50=, $pop49, $pop42
	i32.const	$push134=, 0
	i64.load	$push41=, sN($pop134)
	tee_local	$push133=, $4=, $pop41
	i64.const	$push51=, -4033
	i64.and 	$push3=, $pop133, $pop51
	tee_local	$push132=, $3=, $pop3
	i64.or  	$push4=, $pop50, $pop132
	i64.store	$push52=, sN($pop135), $pop4
	tee_local	$push131=, $2=, $pop52
	i64.const	$push130=, 4032
	i64.or  	$push43=, $4, $pop130
	i64.xor 	$push7=, $pop131, $pop43
	tee_local	$push129=, $4=, $pop7
	i64.const	$push55=, 34359734272
	i64.and 	$push56=, $pop129, $pop55
	i64.const	$push128=, 0
	i64.ne  	$push57=, $pop56, $pop128
	br_if   	0, $pop57       # 0: down to label13
# BB#1:                                 # %lor.lhs.false29
	i64.const	$push61=, 63
	i64.and 	$push62=, $4, $pop61
	i64.const	$push180=, 0
	i64.ne  	$push63=, $pop62, $pop180
	br_if   	0, $pop63       # 0: down to label13
# BB#2:                                 # %lor.lhs.false29
	i64.const	$push53=, 6
	i64.shr_u	$push54=, $2, $pop53
	i32.wrap/i64	$push5=, $pop54
	tee_local	$push183=, $6=, $pop5
	i32.const	$push182=, 16
	i32.shr_u	$push0=, $5, $pop182
	tee_local	$push181=, $5=, $pop0
	i32.xor 	$push59=, $pop183, $pop181
	i32.const	$push60=, 63
	i32.and 	$push58=, $pop59, $pop60
	br_if   	0, $pop58       # 0: down to label13
# BB#3:                                 # %lor.lhs.false49
	i32.const	$push186=, 16
	i32.shr_u	$push2=, $1, $pop186
	tee_local	$push185=, $7=, $pop2
	i32.add 	$push6=, $6, $pop185
	i32.add 	$push64=, $7, $5
	i32.xor 	$push65=, $pop6, $pop64
	i32.const	$push184=, 63
	i32.and 	$push66=, $pop65, $pop184
	br_if   	0, $pop66       # 0: down to label13
# BB#4:                                 # %lor.lhs.false69
	i32.const	$push72=, 0
	i32.const	$push67=, 1103515245
	i32.mul 	$push68=, $1, $pop67
	i32.const	$push69=, 12345
	i32.add 	$push70=, $pop68, $pop69
	tee_local	$push197=, $5=, $pop70
	i32.const	$push196=, 1103515245
	i32.mul 	$push71=, $pop197, $pop196
	i32.const	$push195=, 12345
	i32.add 	$push9=, $pop71, $pop195
	i32.store	$1=, myrnd.s($pop72), $pop9
	i32.const	$push194=, 0
	i32.const	$push73=, 10
	i32.shr_u	$push74=, $5, $pop73
	i64.extend_u/i32	$push75=, $pop74
	i64.const	$push76=, 4032
	i64.and 	$push77=, $pop75, $pop76
	i64.or  	$push78=, $pop77, $3
	i64.store	$push79=, sN($pop194), $pop78
	tee_local	$push193=, $4=, $pop79
	i64.const	$push80=, 6
	i64.shr_u	$push81=, $pop193, $pop80
	i32.wrap/i64	$push11=, $pop81
	tee_local	$push192=, $6=, $pop11
	i32.const	$push191=, 16
	i32.shr_u	$push10=, $1, $pop191
	tee_local	$push190=, $7=, $pop10
	i32.add 	$push82=, $pop192, $pop190
	i32.const	$push189=, 63
	i32.and 	$push83=, $pop82, $pop189
	i32.const	$push84=, 15
	i32.rem_u	$0=, $pop83, $pop84
	block
	i64.xor 	$push12=, $4, $2
	tee_local	$push188=, $2=, $pop12
	i64.const	$push85=, 34359734272
	i64.and 	$push86=, $pop188, $pop85
	i64.const	$push187=, 0
	i64.ne  	$push87=, $pop86, $pop187
	br_if   	0, $pop87       # 0: down to label14
# BB#5:                                 # %lor.lhs.false80
	i64.const	$push91=, 63
	i64.and 	$push92=, $2, $pop91
	i64.const	$push198=, 0
	i64.ne  	$push93=, $pop92, $pop198
	br_if   	0, $pop93       # 0: down to label14
# BB#6:                                 # %lor.lhs.false80
	i32.const	$push200=, 16
	i32.shr_u	$push8=, $5, $pop200
	tee_local	$push199=, $5=, $pop8
	i32.xor 	$push89=, $6, $pop199
	i32.const	$push90=, 63
	i32.and 	$push88=, $pop89, $pop90
	br_if   	0, $pop88       # 0: down to label14
# BB#7:                                 # %lor.lhs.false100
	i32.add 	$push94=, $7, $5
	i32.const	$push201=, 63
	i32.and 	$push95=, $pop94, $pop201
	i32.const	$push96=, 15
	i32.rem_u	$push97=, $pop95, $pop96
	i32.ne  	$push98=, $pop97, $0
	br_if   	0, $pop98       # 0: down to label14
# BB#8:                                 # %lor.lhs.false125
	i32.const	$push107=, 0
	i32.const	$push99=, 1103515245
	i32.mul 	$push100=, $1, $pop99
	i32.const	$push101=, 12345
	i32.add 	$push102=, $pop100, $pop101
	tee_local	$push210=, $5=, $pop102
	i32.const	$push110=, 10
	i32.shr_u	$push111=, $pop210, $pop110
	i64.extend_u/i32	$push112=, $pop111
	i64.const	$push113=, 4032
	i64.and 	$push114=, $pop112, $pop113
	i64.or  	$push115=, $pop114, $3
	i64.const	$push116=, 6
	i64.shr_u	$push117=, $pop115, $pop116
	i32.wrap/i64	$push118=, $pop117
	i32.const	$push209=, 0
	i32.const	$push208=, 1103515245
	i32.mul 	$push105=, $5, $pop208
	i32.const	$push207=, 12345
	i32.add 	$push106=, $pop105, $pop207
	i32.store	$push108=, myrnd.s($pop209), $pop106
	i32.const	$push103=, 16
	i32.shr_u	$push109=, $pop108, $pop103
	tee_local	$push206=, $1=, $pop109
	i32.add 	$push119=, $pop118, $pop206
	tee_local	$push205=, $6=, $pop119
	i32.const	$push120=, 6
	i32.shl 	$push121=, $pop205, $pop120
	i64.extend_u/i32	$push122=, $pop121
	i64.const	$push204=, 4032
	i64.and 	$push123=, $pop122, $pop204
	i64.or  	$push124=, $pop123, $3
	i64.store	$discard=, sN($pop107), $pop124
	block
	i32.const	$push203=, 16
	i32.shr_u	$push104=, $5, $pop203
	i32.add 	$push125=, $1, $pop104
	i32.xor 	$push126=, $pop125, $6
	i32.const	$push202=, 63
	i32.and 	$push127=, $pop126, $pop202
	br_if   	0, $pop127      # 0: down to label15
# BB#9:                                 # %if.end158
	return
.LBB84_10:                              # %if.then157
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB84_11:                              # %if.then106
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB84_12:                              # %if.then
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end84:
	.size	testN, .Lfunc_end84-testN

	.section	.text.retmeO,"ax",@progbits
	.hidden	retmeO
	.globl	retmeO
	.type	retmeO,@function
retmeO:                                 # @retmeO
	.param  	i32, i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.add 	$push3=, $1, $pop1
	i64.load	$2=, 0($pop3)
	i64.load	$push0=, 0($1)
	i64.store	$discard=, 0($0), $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i64.store	$discard=, 0($pop2), $2
	return
	.endfunc
.Lfunc_end85:
	.size	retmeO, .Lfunc_end85-retmeO

	.section	.text.fn1O,"ax",@progbits
	.hidden	fn1O
	.globl	fn1O
	.type	fn1O,@function
fn1O:                                   # @fn1O
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sO+8($pop0):p2align=3
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 4095
	i32.and 	$push4=, $pop2, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end86:
	.size	fn1O, .Lfunc_end86-fn1O

	.section	.text.fn2O,"ax",@progbits
	.hidden	fn2O
	.globl	fn2O
	.type	fn2O,@function
fn2O:                                   # @fn2O
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sO+8($pop0):p2align=3
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 4095
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push5=, 15
	i32.rem_u	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end87:
	.size	fn2O, .Lfunc_end87-fn2O

	.section	.text.retitO,"ax",@progbits
	.hidden	retitO
	.globl	retitO
	.type	retitO,@function
retitO:                                 # @retitO
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sO+8($pop0):p2align=3
	i32.const	$push2=, 4095
	i32.and 	$push3=, $pop1, $pop2
	return  	$pop3
	.endfunc
.Lfunc_end88:
	.size	retitO, .Lfunc_end88-retitO

	.section	.text.fn3O,"ax",@progbits
	.hidden	fn3O
	.globl	fn3O
	.type	fn3O,@function
fn3O:                                   # @fn3O
	.param  	i32
	.result 	i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push14=, 0
	i64.load	$push1=, sO+8($pop14)
	tee_local	$push13=, $1=, $pop1
	i32.wrap/i64	$push2=, $pop13
	i32.add 	$push3=, $pop2, $0
	tee_local	$push12=, $0=, $pop3
	i64.extend_u/i32	$push4=, $pop12
	i64.const	$push5=, 4095
	i64.and 	$push6=, $pop4, $pop5
	i64.const	$push7=, -4096
	i64.and 	$push8=, $1, $pop7
	i64.or  	$push9=, $pop6, $pop8
	i64.store	$discard=, sO+8($pop0), $pop9
	i32.const	$push10=, 4095
	i32.and 	$push11=, $0, $pop10
	return  	$pop11
	.endfunc
.Lfunc_end89:
	.size	fn3O, .Lfunc_end89-fn3O

	.section	.text.testO,"ax",@progbits
	.hidden	testO
	.globl	testO
	.type	testO,@function
testO:                                  # @testO
	.local  	i64, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push213=, 0
	i32.load	$push7=, myrnd.s($pop213)
	i32.const	$push8=, 1103515245
	i32.mul 	$push9=, $pop7, $pop8
	i32.const	$push10=, 12345
	i32.add 	$push11=, $pop9, $pop10
	tee_local	$push212=, $1=, $pop11
	i32.const	$push211=, 16
	i32.shr_u	$push12=, $pop212, $pop211
	i32.store8	$discard=, sO($pop6):p2align=3, $pop12
	i32.const	$push210=, 0
	i32.const	$push209=, 1103515245
	i32.mul 	$push13=, $1, $pop209
	i32.const	$push208=, 12345
	i32.add 	$push14=, $pop13, $pop208
	tee_local	$push207=, $1=, $pop14
	i32.const	$push206=, 16
	i32.shr_u	$push15=, $pop207, $pop206
	i32.store8	$discard=, sO+1($pop210), $pop15
	i32.const	$push205=, 0
	i32.const	$push204=, 1103515245
	i32.mul 	$push16=, $1, $pop204
	i32.const	$push203=, 12345
	i32.add 	$push17=, $pop16, $pop203
	tee_local	$push202=, $1=, $pop17
	i32.const	$push201=, 16
	i32.shr_u	$push18=, $pop202, $pop201
	i32.store8	$discard=, sO+2($pop205):p2align=1, $pop18
	i32.const	$push200=, 0
	i32.const	$push199=, 1103515245
	i32.mul 	$push19=, $1, $pop199
	i32.const	$push198=, 12345
	i32.add 	$push20=, $pop19, $pop198
	tee_local	$push197=, $1=, $pop20
	i32.const	$push196=, 16
	i32.shr_u	$push21=, $pop197, $pop196
	i32.store8	$discard=, sO+3($pop200), $pop21
	i32.const	$push195=, 0
	i32.const	$push194=, 1103515245
	i32.mul 	$push22=, $1, $pop194
	i32.const	$push193=, 12345
	i32.add 	$push23=, $pop22, $pop193
	tee_local	$push192=, $1=, $pop23
	i32.const	$push191=, 16
	i32.shr_u	$push24=, $pop192, $pop191
	i32.store8	$discard=, sO+4($pop195):p2align=2, $pop24
	i32.const	$push190=, 0
	i32.const	$push189=, 1103515245
	i32.mul 	$push25=, $1, $pop189
	i32.const	$push188=, 12345
	i32.add 	$push26=, $pop25, $pop188
	tee_local	$push187=, $1=, $pop26
	i32.const	$push186=, 16
	i32.shr_u	$push27=, $pop187, $pop186
	i32.store8	$discard=, sO+5($pop190), $pop27
	i32.const	$push185=, 0
	i32.const	$push184=, 1103515245
	i32.mul 	$push28=, $1, $pop184
	i32.const	$push183=, 12345
	i32.add 	$push29=, $pop28, $pop183
	tee_local	$push182=, $1=, $pop29
	i32.const	$push181=, 16
	i32.shr_u	$push30=, $pop182, $pop181
	i32.store8	$discard=, sO+6($pop185):p2align=1, $pop30
	i32.const	$push180=, 0
	i32.const	$push179=, 1103515245
	i32.mul 	$push31=, $1, $pop179
	i32.const	$push178=, 12345
	i32.add 	$push32=, $pop31, $pop178
	tee_local	$push177=, $1=, $pop32
	i32.const	$push176=, 16
	i32.shr_u	$push33=, $pop177, $pop176
	i32.store8	$discard=, sO+7($pop180), $pop33
	i32.const	$push175=, 0
	i32.const	$push174=, 1103515245
	i32.mul 	$push34=, $1, $pop174
	i32.const	$push173=, 12345
	i32.add 	$push35=, $pop34, $pop173
	tee_local	$push172=, $1=, $pop35
	i32.const	$push171=, 16
	i32.shr_u	$push36=, $pop172, $pop171
	i32.store8	$discard=, sO+8($pop175):p2align=3, $pop36
	i32.const	$push170=, 0
	i32.const	$push169=, 1103515245
	i32.mul 	$push37=, $1, $pop169
	i32.const	$push168=, 12345
	i32.add 	$push38=, $pop37, $pop168
	tee_local	$push167=, $1=, $pop38
	i32.const	$push166=, 16
	i32.shr_u	$push39=, $pop167, $pop166
	i32.store8	$discard=, sO+9($pop170), $pop39
	i32.const	$push165=, 0
	i32.const	$push164=, 1103515245
	i32.mul 	$push40=, $1, $pop164
	i32.const	$push163=, 12345
	i32.add 	$push41=, $pop40, $pop163
	tee_local	$push162=, $1=, $pop41
	i32.const	$push161=, 16
	i32.shr_u	$push42=, $pop162, $pop161
	i32.store8	$discard=, sO+10($pop165):p2align=1, $pop42
	i32.const	$push160=, 0
	i32.const	$push159=, 1103515245
	i32.mul 	$push43=, $1, $pop159
	i32.const	$push158=, 12345
	i32.add 	$push44=, $pop43, $pop158
	tee_local	$push157=, $1=, $pop44
	i32.const	$push156=, 16
	i32.shr_u	$push45=, $pop157, $pop156
	i32.store8	$discard=, sO+11($pop160), $pop45
	i32.const	$push155=, 0
	i32.const	$push154=, 1103515245
	i32.mul 	$push46=, $1, $pop154
	i32.const	$push153=, 12345
	i32.add 	$push47=, $pop46, $pop153
	tee_local	$push152=, $1=, $pop47
	i32.const	$push151=, 16
	i32.shr_u	$push48=, $pop152, $pop151
	i32.store8	$discard=, sO+12($pop155):p2align=2, $pop48
	i32.const	$push150=, 0
	i32.const	$push149=, 1103515245
	i32.mul 	$push49=, $1, $pop149
	i32.const	$push148=, 12345
	i32.add 	$push50=, $pop49, $pop148
	tee_local	$push147=, $1=, $pop50
	i32.const	$push146=, 16
	i32.shr_u	$push51=, $pop147, $pop146
	i32.store8	$discard=, sO+13($pop150), $pop51
	i32.const	$push145=, 0
	i32.const	$push144=, 1103515245
	i32.mul 	$push52=, $1, $pop144
	i32.const	$push143=, 12345
	i32.add 	$push53=, $pop52, $pop143
	tee_local	$push142=, $1=, $pop53
	i32.const	$push141=, 16
	i32.shr_u	$push54=, $pop142, $pop141
	i32.store8	$discard=, sO+14($pop145):p2align=1, $pop54
	i32.const	$push140=, 0
	i32.const	$push139=, 1103515245
	i32.mul 	$push55=, $1, $pop139
	i32.const	$push138=, 12345
	i32.add 	$push56=, $pop55, $pop138
	tee_local	$push137=, $1=, $pop56
	i32.const	$push136=, 16
	i32.shr_u	$push57=, $pop137, $pop136
	i32.store8	$discard=, sO+15($pop140), $pop57
	i32.const	$push135=, 0
	i64.load	$0=, sO+8($pop135)
	i32.const	$push134=, 1103515245
	i32.mul 	$push58=, $1, $pop134
	i32.const	$push133=, 12345
	i32.add 	$push59=, $pop58, $pop133
	tee_local	$push132=, $2=, $pop59
	i32.const	$push131=, 16
	i32.shr_u	$push60=, $pop132, $pop131
	i32.const	$push130=, 2047
	i32.and 	$1=, $pop60, $pop130
	i32.const	$push129=, 0
	i32.const	$push128=, 1103515245
	i32.mul 	$push61=, $2, $pop128
	i32.const	$push127=, 12345
	i32.add 	$push0=, $pop61, $pop127
	i32.store	$2=, myrnd.s($pop129), $pop0
	block
	i32.const	$push126=, 0
	i64.extend_u/i32	$push64=, $1
	i64.const	$push65=, -4096
	i64.and 	$push66=, $0, $pop65
	i64.or  	$push67=, $pop64, $pop66
	i64.store	$push68=, sO+8($pop126), $pop67
	i32.wrap/i64	$push69=, $pop68
	tee_local	$push125=, $3=, $pop69
	i32.const	$push124=, 2047
	i32.and 	$push72=, $pop125, $pop124
	i32.ne  	$push73=, $1, $pop72
	br_if   	0, $pop73       # 0: down to label16
# BB#1:                                 # %entry
	i32.const	$push216=, 16
	i32.shr_u	$push62=, $2, $pop216
	i32.const	$push215=, 2047
	i32.and 	$push63=, $pop62, $pop215
	tee_local	$push214=, $4=, $pop63
	i32.add 	$push4=, $pop214, $1
	i32.add 	$push70=, $3, $4
	i32.const	$push71=, 4095
	i32.and 	$push5=, $pop70, $pop71
	i32.ne  	$push74=, $pop4, $pop5
	br_if   	0, $pop74       # 0: down to label16
# BB#2:                                 # %if.end
	i32.const	$push75=, 1103515245
	i32.mul 	$push76=, $2, $pop75
	i32.const	$push77=, 12345
	i32.add 	$push78=, $pop76, $pop77
	tee_local	$push224=, $2=, $pop78
	i32.const	$push223=, 16
	i32.shr_u	$push79=, $pop224, $pop223
	i32.const	$push222=, 2047
	i32.and 	$1=, $pop79, $pop222
	i32.const	$push81=, 0
	i32.const	$push221=, 1103515245
	i32.mul 	$push80=, $2, $pop221
	i32.const	$push220=, 12345
	i32.add 	$push1=, $pop80, $pop220
	i32.store	$2=, myrnd.s($pop81), $pop1
	block
	i32.const	$push219=, 0
	i64.extend_u/i32	$push83=, $1
	i64.const	$push84=, -4096
	i64.and 	$push85=, $0, $pop84
	i64.or  	$push86=, $pop83, $pop85
	i64.store	$push87=, sO+8($pop219), $pop86
	i32.wrap/i64	$push3=, $pop87
	tee_local	$push218=, $3=, $pop3
	i32.const	$push217=, 2047
	i32.and 	$push88=, $pop218, $pop217
	i32.ne  	$push89=, $1, $pop88
	br_if   	0, $pop89       # 0: down to label17
# BB#3:                                 # %lor.lhs.false87
	i32.const	$push229=, 16
	i32.shr_u	$push82=, $2, $pop229
	i32.const	$push228=, 2047
	i32.and 	$push2=, $pop82, $pop228
	tee_local	$push227=, $4=, $pop2
	i32.add 	$push90=, $3, $pop227
	i32.const	$push226=, 4095
	i32.and 	$push91=, $pop90, $pop226
	i32.const	$push92=, 15
	i32.rem_u	$push93=, $pop91, $pop92
	i32.add 	$push94=, $4, $1
	i32.const	$push225=, 15
	i32.rem_u	$push95=, $pop94, $pop225
	i32.ne  	$push96=, $pop93, $pop95
	br_if   	0, $pop96       # 0: down to label17
# BB#4:                                 # %lor.lhs.false124
	i32.const	$push107=, 0
	i32.const	$push97=, 1103515245
	i32.mul 	$push98=, $2, $pop97
	i32.const	$push99=, 12345
	i32.add 	$push100=, $pop98, $pop99
	tee_local	$push240=, $1=, $pop100
	i32.const	$push101=, 16
	i32.shr_u	$push102=, $pop240, $pop101
	i32.const	$push103=, 2047
	i32.and 	$push104=, $pop102, $pop103
	tee_local	$push239=, $2=, $pop104
	i64.extend_u/i32	$push111=, $pop239
	i64.const	$push112=, -4096
	i64.and 	$push113=, $0, $pop112
	tee_local	$push238=, $0=, $pop113
	i64.or  	$push114=, $pop111, $pop238
	i32.wrap/i64	$push115=, $pop114
	i32.const	$push237=, 0
	i32.const	$push236=, 1103515245
	i32.mul 	$push105=, $1, $pop236
	i32.const	$push235=, 12345
	i32.add 	$push106=, $pop105, $pop235
	i32.store	$push108=, myrnd.s($pop237), $pop106
	i32.const	$push234=, 16
	i32.shr_u	$push109=, $pop108, $pop234
	i32.const	$push233=, 2047
	i32.and 	$push110=, $pop109, $pop233
	tee_local	$push232=, $1=, $pop110
	i32.add 	$push116=, $pop115, $pop232
	tee_local	$push231=, $3=, $pop116
	i64.extend_u/i32	$push117=, $pop231
	i64.const	$push118=, 4095
	i64.and 	$push119=, $pop117, $pop118
	i64.or  	$push120=, $pop119, $0
	i64.store	$discard=, sO+8($pop107), $pop120
	block
	i32.add 	$push122=, $1, $2
	i32.const	$push230=, 4095
	i32.and 	$push121=, $3, $pop230
	i32.ne  	$push123=, $pop122, $pop121
	br_if   	0, $pop123      # 0: down to label18
# BB#5:                                 # %if.end140
	return
.LBB90_6:                               # %if.then139
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
.LBB90_7:                               # %if.then93
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB90_8:                               # %if.then
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end90:
	.size	testO, .Lfunc_end90-testO

	.section	.text.retmeP,"ax",@progbits
	.hidden	retmeP
	.globl	retmeP
	.type	retmeP,@function
retmeP:                                 # @retmeP
	.param  	i32, i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.add 	$push3=, $1, $pop1
	i64.load	$2=, 0($pop3)
	i64.load	$push0=, 0($1)
	i64.store	$discard=, 0($0), $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i64.store	$discard=, 0($pop2), $2
	return
	.endfunc
.Lfunc_end91:
	.size	retmeP, .Lfunc_end91-retmeP

	.section	.text.fn1P,"ax",@progbits
	.hidden	fn1P
	.globl	fn1P
	.type	fn1P,@function
fn1P:                                   # @fn1P
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sP($pop0):p2align=3
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 4095
	i32.and 	$push4=, $pop2, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end92:
	.size	fn1P, .Lfunc_end92-fn1P

	.section	.text.fn2P,"ax",@progbits
	.hidden	fn2P
	.globl	fn2P
	.type	fn2P,@function
fn2P:                                   # @fn2P
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sP($pop0):p2align=3
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 4095
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push5=, 15
	i32.rem_u	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end93:
	.size	fn2P, .Lfunc_end93-fn2P

	.section	.text.retitP,"ax",@progbits
	.hidden	retitP
	.globl	retitP
	.type	retitP,@function
retitP:                                 # @retitP
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sP($pop0):p2align=3
	i32.const	$push2=, 4095
	i32.and 	$push3=, $pop1, $pop2
	return  	$pop3
	.endfunc
.Lfunc_end94:
	.size	retitP, .Lfunc_end94-retitP

	.section	.text.fn3P,"ax",@progbits
	.hidden	fn3P
	.globl	fn3P
	.type	fn3P,@function
fn3P:                                   # @fn3P
	.param  	i32
	.result 	i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push14=, 0
	i64.load	$push1=, sP($pop14)
	tee_local	$push13=, $1=, $pop1
	i32.wrap/i64	$push2=, $pop13
	i32.add 	$push3=, $pop2, $0
	tee_local	$push12=, $0=, $pop3
	i64.extend_u/i32	$push4=, $pop12
	i64.const	$push5=, 4095
	i64.and 	$push6=, $pop4, $pop5
	i64.const	$push7=, -4096
	i64.and 	$push8=, $1, $pop7
	i64.or  	$push9=, $pop6, $pop8
	i64.store	$discard=, sP($pop0), $pop9
	i32.const	$push10=, 4095
	i32.and 	$push11=, $0, $pop10
	return  	$pop11
	.endfunc
.Lfunc_end95:
	.size	fn3P, .Lfunc_end95-fn3P

	.section	.text.testP,"ax",@progbits
	.hidden	testP
	.globl	testP
	.type	testP,@function
testP:                                  # @testP
	.local  	i64, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push213=, 0
	i32.load	$push7=, myrnd.s($pop213)
	i32.const	$push8=, 1103515245
	i32.mul 	$push9=, $pop7, $pop8
	i32.const	$push10=, 12345
	i32.add 	$push11=, $pop9, $pop10
	tee_local	$push212=, $1=, $pop11
	i32.const	$push211=, 16
	i32.shr_u	$push12=, $pop212, $pop211
	i32.store8	$discard=, sP($pop6):p2align=3, $pop12
	i32.const	$push210=, 0
	i32.const	$push209=, 1103515245
	i32.mul 	$push13=, $1, $pop209
	i32.const	$push208=, 12345
	i32.add 	$push14=, $pop13, $pop208
	tee_local	$push207=, $1=, $pop14
	i32.const	$push206=, 16
	i32.shr_u	$push15=, $pop207, $pop206
	i32.store8	$discard=, sP+1($pop210), $pop15
	i32.const	$push205=, 0
	i32.const	$push204=, 1103515245
	i32.mul 	$push16=, $1, $pop204
	i32.const	$push203=, 12345
	i32.add 	$push17=, $pop16, $pop203
	tee_local	$push202=, $1=, $pop17
	i32.const	$push201=, 16
	i32.shr_u	$push18=, $pop202, $pop201
	i32.store8	$discard=, sP+2($pop205):p2align=1, $pop18
	i32.const	$push200=, 0
	i32.const	$push199=, 1103515245
	i32.mul 	$push19=, $1, $pop199
	i32.const	$push198=, 12345
	i32.add 	$push20=, $pop19, $pop198
	tee_local	$push197=, $1=, $pop20
	i32.const	$push196=, 16
	i32.shr_u	$push21=, $pop197, $pop196
	i32.store8	$discard=, sP+3($pop200), $pop21
	i32.const	$push195=, 0
	i32.const	$push194=, 1103515245
	i32.mul 	$push22=, $1, $pop194
	i32.const	$push193=, 12345
	i32.add 	$push23=, $pop22, $pop193
	tee_local	$push192=, $1=, $pop23
	i32.const	$push191=, 16
	i32.shr_u	$push24=, $pop192, $pop191
	i32.store8	$discard=, sP+4($pop195):p2align=2, $pop24
	i32.const	$push190=, 0
	i32.const	$push189=, 1103515245
	i32.mul 	$push25=, $1, $pop189
	i32.const	$push188=, 12345
	i32.add 	$push26=, $pop25, $pop188
	tee_local	$push187=, $1=, $pop26
	i32.const	$push186=, 16
	i32.shr_u	$push27=, $pop187, $pop186
	i32.store8	$discard=, sP+5($pop190), $pop27
	i32.const	$push185=, 0
	i32.const	$push184=, 1103515245
	i32.mul 	$push28=, $1, $pop184
	i32.const	$push183=, 12345
	i32.add 	$push29=, $pop28, $pop183
	tee_local	$push182=, $1=, $pop29
	i32.const	$push181=, 16
	i32.shr_u	$push30=, $pop182, $pop181
	i32.store8	$discard=, sP+6($pop185):p2align=1, $pop30
	i32.const	$push180=, 0
	i32.const	$push179=, 1103515245
	i32.mul 	$push31=, $1, $pop179
	i32.const	$push178=, 12345
	i32.add 	$push32=, $pop31, $pop178
	tee_local	$push177=, $1=, $pop32
	i32.const	$push176=, 16
	i32.shr_u	$push33=, $pop177, $pop176
	i32.store8	$discard=, sP+7($pop180), $pop33
	i32.const	$push175=, 0
	i32.const	$push174=, 1103515245
	i32.mul 	$push34=, $1, $pop174
	i32.const	$push173=, 12345
	i32.add 	$push35=, $pop34, $pop173
	tee_local	$push172=, $1=, $pop35
	i32.const	$push171=, 16
	i32.shr_u	$push36=, $pop172, $pop171
	i32.store8	$discard=, sP+8($pop175):p2align=3, $pop36
	i32.const	$push170=, 0
	i32.const	$push169=, 1103515245
	i32.mul 	$push37=, $1, $pop169
	i32.const	$push168=, 12345
	i32.add 	$push38=, $pop37, $pop168
	tee_local	$push167=, $1=, $pop38
	i32.const	$push166=, 16
	i32.shr_u	$push39=, $pop167, $pop166
	i32.store8	$discard=, sP+9($pop170), $pop39
	i32.const	$push165=, 0
	i32.const	$push164=, 1103515245
	i32.mul 	$push40=, $1, $pop164
	i32.const	$push163=, 12345
	i32.add 	$push41=, $pop40, $pop163
	tee_local	$push162=, $1=, $pop41
	i32.const	$push161=, 16
	i32.shr_u	$push42=, $pop162, $pop161
	i32.store8	$discard=, sP+10($pop165):p2align=1, $pop42
	i32.const	$push160=, 0
	i32.const	$push159=, 1103515245
	i32.mul 	$push43=, $1, $pop159
	i32.const	$push158=, 12345
	i32.add 	$push44=, $pop43, $pop158
	tee_local	$push157=, $1=, $pop44
	i32.const	$push156=, 16
	i32.shr_u	$push45=, $pop157, $pop156
	i32.store8	$discard=, sP+11($pop160), $pop45
	i32.const	$push155=, 0
	i32.const	$push154=, 1103515245
	i32.mul 	$push46=, $1, $pop154
	i32.const	$push153=, 12345
	i32.add 	$push47=, $pop46, $pop153
	tee_local	$push152=, $1=, $pop47
	i32.const	$push151=, 16
	i32.shr_u	$push48=, $pop152, $pop151
	i32.store8	$discard=, sP+12($pop155):p2align=2, $pop48
	i32.const	$push150=, 0
	i32.const	$push149=, 1103515245
	i32.mul 	$push49=, $1, $pop149
	i32.const	$push148=, 12345
	i32.add 	$push50=, $pop49, $pop148
	tee_local	$push147=, $1=, $pop50
	i32.const	$push146=, 16
	i32.shr_u	$push51=, $pop147, $pop146
	i32.store8	$discard=, sP+13($pop150), $pop51
	i32.const	$push145=, 0
	i32.const	$push144=, 1103515245
	i32.mul 	$push52=, $1, $pop144
	i32.const	$push143=, 12345
	i32.add 	$push53=, $pop52, $pop143
	tee_local	$push142=, $1=, $pop53
	i32.const	$push141=, 16
	i32.shr_u	$push54=, $pop142, $pop141
	i32.store8	$discard=, sP+14($pop145):p2align=1, $pop54
	i32.const	$push140=, 0
	i32.const	$push139=, 1103515245
	i32.mul 	$push55=, $1, $pop139
	i32.const	$push138=, 12345
	i32.add 	$push56=, $pop55, $pop138
	tee_local	$push137=, $1=, $pop56
	i32.const	$push136=, 16
	i32.shr_u	$push57=, $pop137, $pop136
	i32.store8	$discard=, sP+15($pop140), $pop57
	i32.const	$push135=, 0
	i64.load	$0=, sP($pop135)
	i32.const	$push134=, 1103515245
	i32.mul 	$push58=, $1, $pop134
	i32.const	$push133=, 12345
	i32.add 	$push59=, $pop58, $pop133
	tee_local	$push132=, $2=, $pop59
	i32.const	$push131=, 16
	i32.shr_u	$push60=, $pop132, $pop131
	i32.const	$push130=, 2047
	i32.and 	$1=, $pop60, $pop130
	i32.const	$push129=, 0
	i32.const	$push128=, 1103515245
	i32.mul 	$push61=, $2, $pop128
	i32.const	$push127=, 12345
	i32.add 	$push0=, $pop61, $pop127
	i32.store	$2=, myrnd.s($pop129), $pop0
	block
	i32.const	$push126=, 0
	i64.extend_u/i32	$push64=, $1
	i64.const	$push65=, -4096
	i64.and 	$push66=, $0, $pop65
	i64.or  	$push67=, $pop64, $pop66
	i64.store	$push68=, sP($pop126), $pop67
	i32.wrap/i64	$push69=, $pop68
	tee_local	$push125=, $3=, $pop69
	i32.const	$push124=, 2047
	i32.and 	$push72=, $pop125, $pop124
	i32.ne  	$push73=, $1, $pop72
	br_if   	0, $pop73       # 0: down to label19
# BB#1:                                 # %entry
	i32.const	$push216=, 16
	i32.shr_u	$push62=, $2, $pop216
	i32.const	$push215=, 2047
	i32.and 	$push63=, $pop62, $pop215
	tee_local	$push214=, $4=, $pop63
	i32.add 	$push4=, $pop214, $1
	i32.add 	$push70=, $3, $4
	i32.const	$push71=, 4095
	i32.and 	$push5=, $pop70, $pop71
	i32.ne  	$push74=, $pop4, $pop5
	br_if   	0, $pop74       # 0: down to label19
# BB#2:                                 # %if.end
	i32.const	$push75=, 1103515245
	i32.mul 	$push76=, $2, $pop75
	i32.const	$push77=, 12345
	i32.add 	$push78=, $pop76, $pop77
	tee_local	$push224=, $2=, $pop78
	i32.const	$push223=, 16
	i32.shr_u	$push79=, $pop224, $pop223
	i32.const	$push222=, 2047
	i32.and 	$1=, $pop79, $pop222
	i32.const	$push81=, 0
	i32.const	$push221=, 1103515245
	i32.mul 	$push80=, $2, $pop221
	i32.const	$push220=, 12345
	i32.add 	$push1=, $pop80, $pop220
	i32.store	$2=, myrnd.s($pop81), $pop1
	block
	i32.const	$push219=, 0
	i64.extend_u/i32	$push83=, $1
	i64.const	$push84=, -4096
	i64.and 	$push85=, $0, $pop84
	i64.or  	$push86=, $pop83, $pop85
	i64.store	$push87=, sP($pop219), $pop86
	i32.wrap/i64	$push3=, $pop87
	tee_local	$push218=, $3=, $pop3
	i32.const	$push217=, 2047
	i32.and 	$push88=, $pop218, $pop217
	i32.ne  	$push89=, $1, $pop88
	br_if   	0, $pop89       # 0: down to label20
# BB#3:                                 # %lor.lhs.false83
	i32.const	$push229=, 16
	i32.shr_u	$push82=, $2, $pop229
	i32.const	$push228=, 2047
	i32.and 	$push2=, $pop82, $pop228
	tee_local	$push227=, $4=, $pop2
	i32.add 	$push90=, $3, $pop227
	i32.const	$push226=, 4095
	i32.and 	$push91=, $pop90, $pop226
	i32.const	$push92=, 15
	i32.rem_u	$push93=, $pop91, $pop92
	i32.add 	$push94=, $4, $1
	i32.const	$push225=, 15
	i32.rem_u	$push95=, $pop94, $pop225
	i32.ne  	$push96=, $pop93, $pop95
	br_if   	0, $pop96       # 0: down to label20
# BB#4:                                 # %lor.lhs.false118
	i32.const	$push107=, 0
	i32.const	$push97=, 1103515245
	i32.mul 	$push98=, $2, $pop97
	i32.const	$push99=, 12345
	i32.add 	$push100=, $pop98, $pop99
	tee_local	$push240=, $1=, $pop100
	i32.const	$push101=, 16
	i32.shr_u	$push102=, $pop240, $pop101
	i32.const	$push103=, 2047
	i32.and 	$push104=, $pop102, $pop103
	tee_local	$push239=, $2=, $pop104
	i64.extend_u/i32	$push111=, $pop239
	i64.const	$push112=, -4096
	i64.and 	$push113=, $0, $pop112
	tee_local	$push238=, $0=, $pop113
	i64.or  	$push114=, $pop111, $pop238
	i32.wrap/i64	$push115=, $pop114
	i32.const	$push237=, 0
	i32.const	$push236=, 1103515245
	i32.mul 	$push105=, $1, $pop236
	i32.const	$push235=, 12345
	i32.add 	$push106=, $pop105, $pop235
	i32.store	$push108=, myrnd.s($pop237), $pop106
	i32.const	$push234=, 16
	i32.shr_u	$push109=, $pop108, $pop234
	i32.const	$push233=, 2047
	i32.and 	$push110=, $pop109, $pop233
	tee_local	$push232=, $1=, $pop110
	i32.add 	$push116=, $pop115, $pop232
	tee_local	$push231=, $3=, $pop116
	i64.extend_u/i32	$push117=, $pop231
	i64.const	$push118=, 4095
	i64.and 	$push119=, $pop117, $pop118
	i64.or  	$push120=, $pop119, $0
	i64.store	$discard=, sP($pop107), $pop120
	block
	i32.add 	$push122=, $1, $2
	i32.const	$push230=, 4095
	i32.and 	$push121=, $3, $pop230
	i32.ne  	$push123=, $pop122, $pop121
	br_if   	0, $pop123      # 0: down to label21
# BB#5:                                 # %if.end134
	return
.LBB96_6:                               # %if.then133
	end_block                       # label21:
	call    	abort@FUNCTION
	unreachable
.LBB96_7:                               # %if.then89
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
.LBB96_8:                               # %if.then
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end96:
	.size	testP, .Lfunc_end96-testP

	.section	.text.retmeQ,"ax",@progbits
	.hidden	retmeQ
	.globl	retmeQ
	.type	retmeQ,@function
retmeQ:                                 # @retmeQ
	.param  	i32, i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.add 	$push3=, $1, $pop1
	i64.load	$2=, 0($pop3)
	i64.load	$push0=, 0($1)
	i64.store	$discard=, 0($0), $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i64.store	$discard=, 0($pop2), $2
	return
	.endfunc
.Lfunc_end97:
	.size	retmeQ, .Lfunc_end97-retmeQ

	.section	.text.fn1Q,"ax",@progbits
	.hidden	fn1Q
	.globl	fn1Q
	.type	fn1Q,@function
fn1Q:                                   # @fn1Q
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sQ($pop0):p2align=3
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 4095
	i32.and 	$push4=, $pop2, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end98:
	.size	fn1Q, .Lfunc_end98-fn1Q

	.section	.text.fn2Q,"ax",@progbits
	.hidden	fn2Q
	.globl	fn2Q
	.type	fn2Q,@function
fn2Q:                                   # @fn2Q
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sQ($pop0):p2align=3
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 4095
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push5=, 15
	i32.rem_u	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end99:
	.size	fn2Q, .Lfunc_end99-fn2Q

	.section	.text.retitQ,"ax",@progbits
	.hidden	retitQ
	.globl	retitQ
	.type	retitQ,@function
retitQ:                                 # @retitQ
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sQ($pop0):p2align=3
	i32.const	$push2=, 4095
	i32.and 	$push3=, $pop1, $pop2
	return  	$pop3
	.endfunc
.Lfunc_end100:
	.size	retitQ, .Lfunc_end100-retitQ

	.section	.text.fn3Q,"ax",@progbits
	.hidden	fn3Q
	.globl	fn3Q
	.type	fn3Q,@function
fn3Q:                                   # @fn3Q
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push1=, sQ($pop10):p2align=3
	tee_local	$push9=, $1=, $pop1
	i32.add 	$push2=, $pop9, $0
	i32.const	$push3=, 4095
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push8=, $0=, $pop4
	i32.const	$push5=, -4096
	i32.and 	$push6=, $1, $pop5
	i32.or  	$push7=, $pop8, $pop6
	i32.store	$discard=, sQ($pop0):p2align=3, $pop7
	return  	$0
	.endfunc
.Lfunc_end101:
	.size	fn3Q, .Lfunc_end101-fn3Q

	.section	.text.testQ,"ax",@progbits
	.hidden	testQ
	.globl	testQ
	.type	testQ,@function
testQ:                                  # @testQ
	.local  	i32, i32
# BB#0:                                 # %if.end75
	i32.const	$push0=, 0
	i32.const	$push154=, 0
	i32.load	$push1=, myrnd.s($pop154)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push5=, $pop3, $pop4
	tee_local	$push153=, $1=, $pop5
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop153, $pop6
	i32.store8	$discard=, sQ($pop0):p2align=3, $pop7
	i32.const	$push152=, 0
	i32.const	$push151=, 1103515245
	i32.mul 	$push8=, $1, $pop151
	i32.const	$push150=, 12345
	i32.add 	$push9=, $pop8, $pop150
	tee_local	$push149=, $1=, $pop9
	i32.const	$push148=, 16
	i32.shr_u	$push10=, $pop149, $pop148
	i32.store8	$discard=, sQ+1($pop152), $pop10
	i32.const	$push147=, 0
	i32.const	$push146=, 1103515245
	i32.mul 	$push11=, $1, $pop146
	i32.const	$push145=, 12345
	i32.add 	$push12=, $pop11, $pop145
	tee_local	$push144=, $1=, $pop12
	i32.const	$push143=, 16
	i32.shr_u	$push13=, $pop144, $pop143
	i32.store8	$discard=, sQ+2($pop147):p2align=1, $pop13
	i32.const	$push142=, 0
	i32.const	$push141=, 1103515245
	i32.mul 	$push14=, $1, $pop141
	i32.const	$push140=, 12345
	i32.add 	$push15=, $pop14, $pop140
	tee_local	$push139=, $1=, $pop15
	i32.const	$push138=, 16
	i32.shr_u	$push16=, $pop139, $pop138
	i32.store8	$discard=, sQ+3($pop142), $pop16
	i32.const	$push137=, 0
	i32.const	$push136=, 1103515245
	i32.mul 	$push17=, $1, $pop136
	i32.const	$push135=, 12345
	i32.add 	$push18=, $pop17, $pop135
	tee_local	$push134=, $1=, $pop18
	i32.const	$push133=, 16
	i32.shr_u	$push19=, $pop134, $pop133
	i32.store8	$discard=, sQ+4($pop137):p2align=2, $pop19
	i32.const	$push132=, 0
	i32.const	$push131=, 1103515245
	i32.mul 	$push20=, $1, $pop131
	i32.const	$push130=, 12345
	i32.add 	$push21=, $pop20, $pop130
	tee_local	$push129=, $1=, $pop21
	i32.const	$push128=, 16
	i32.shr_u	$push22=, $pop129, $pop128
	i32.store8	$discard=, sQ+5($pop132), $pop22
	i32.const	$push127=, 0
	i32.const	$push126=, 1103515245
	i32.mul 	$push23=, $1, $pop126
	i32.const	$push125=, 12345
	i32.add 	$push24=, $pop23, $pop125
	tee_local	$push124=, $1=, $pop24
	i32.const	$push123=, 16
	i32.shr_u	$push25=, $pop124, $pop123
	i32.store8	$discard=, sQ+6($pop127):p2align=1, $pop25
	i32.const	$push122=, 0
	i32.const	$push121=, 1103515245
	i32.mul 	$push26=, $1, $pop121
	i32.const	$push120=, 12345
	i32.add 	$push27=, $pop26, $pop120
	tee_local	$push119=, $1=, $pop27
	i32.const	$push118=, 16
	i32.shr_u	$push28=, $pop119, $pop118
	i32.store8	$discard=, sQ+7($pop122), $pop28
	i32.const	$push117=, 0
	i32.const	$push116=, 1103515245
	i32.mul 	$push29=, $1, $pop116
	i32.const	$push115=, 12345
	i32.add 	$push30=, $pop29, $pop115
	tee_local	$push114=, $1=, $pop30
	i32.const	$push113=, 16
	i32.shr_u	$push31=, $pop114, $pop113
	i32.store8	$discard=, sQ+8($pop117):p2align=3, $pop31
	i32.const	$push112=, 0
	i32.const	$push111=, 1103515245
	i32.mul 	$push32=, $1, $pop111
	i32.const	$push110=, 12345
	i32.add 	$push33=, $pop32, $pop110
	tee_local	$push109=, $1=, $pop33
	i32.const	$push108=, 16
	i32.shr_u	$push34=, $pop109, $pop108
	i32.store8	$discard=, sQ+9($pop112), $pop34
	i32.const	$push107=, 0
	i32.const	$push106=, 1103515245
	i32.mul 	$push35=, $1, $pop106
	i32.const	$push105=, 12345
	i32.add 	$push36=, $pop35, $pop105
	tee_local	$push104=, $1=, $pop36
	i32.const	$push103=, 16
	i32.shr_u	$push37=, $pop104, $pop103
	i32.store8	$discard=, sQ+10($pop107):p2align=1, $pop37
	i32.const	$push102=, 0
	i32.const	$push101=, 1103515245
	i32.mul 	$push38=, $1, $pop101
	i32.const	$push100=, 12345
	i32.add 	$push39=, $pop38, $pop100
	tee_local	$push99=, $1=, $pop39
	i32.const	$push98=, 16
	i32.shr_u	$push40=, $pop99, $pop98
	i32.store8	$discard=, sQ+11($pop102), $pop40
	i32.const	$push97=, 0
	i32.const	$push96=, 1103515245
	i32.mul 	$push41=, $1, $pop96
	i32.const	$push95=, 12345
	i32.add 	$push42=, $pop41, $pop95
	tee_local	$push94=, $1=, $pop42
	i32.const	$push93=, 16
	i32.shr_u	$push43=, $pop94, $pop93
	i32.store8	$discard=, sQ+12($pop97):p2align=2, $pop43
	i32.const	$push92=, 0
	i32.const	$push91=, 1103515245
	i32.mul 	$push44=, $1, $pop91
	i32.const	$push90=, 12345
	i32.add 	$push45=, $pop44, $pop90
	tee_local	$push89=, $1=, $pop45
	i32.const	$push88=, 16
	i32.shr_u	$push46=, $pop89, $pop88
	i32.store8	$discard=, sQ+13($pop92), $pop46
	i32.const	$push87=, 0
	i32.const	$push86=, 1103515245
	i32.mul 	$push47=, $1, $pop86
	i32.const	$push85=, 12345
	i32.add 	$push48=, $pop47, $pop85
	tee_local	$push84=, $1=, $pop48
	i32.const	$push83=, 16
	i32.shr_u	$push49=, $pop84, $pop83
	i32.store8	$discard=, sQ+14($pop87):p2align=1, $pop49
	i32.const	$push82=, 0
	i32.load	$0=, sQ($pop82):p2align=3
	i32.const	$push81=, 0
	i32.const	$push80=, 1103515245
	i32.mul 	$push50=, $1, $pop80
	i32.const	$push79=, 12345
	i32.add 	$push51=, $pop50, $pop79
	tee_local	$push78=, $1=, $pop51
	i32.const	$push77=, 16
	i32.shr_u	$push52=, $pop78, $pop77
	i32.store8	$discard=, sQ+15($pop81), $pop52
	i32.const	$push76=, 0
	i32.const	$push75=, 0
	i32.const	$push55=, -341751747
	i32.mul 	$push56=, $1, $pop55
	i32.const	$push57=, 229283573
	i32.add 	$push58=, $pop56, $pop57
	tee_local	$push74=, $1=, $pop58
	i32.const	$push73=, 1103515245
	i32.mul 	$push62=, $pop74, $pop73
	i32.const	$push72=, 12345
	i32.add 	$push63=, $pop62, $pop72
	i32.store	$push64=, myrnd.s($pop75), $pop63
	i32.const	$push71=, 16
	i32.shr_u	$push65=, $pop64, $pop71
	i32.const	$push60=, 2047
	i32.and 	$push66=, $pop65, $pop60
	i32.const	$push70=, 16
	i32.shr_u	$push59=, $1, $pop70
	i32.const	$push69=, 2047
	i32.and 	$push61=, $pop59, $pop69
	i32.add 	$push67=, $pop66, $pop61
	i32.const	$push53=, -4096
	i32.and 	$push54=, $0, $pop53
	i32.or  	$push68=, $pop67, $pop54
	i32.store	$discard=, sQ($pop76):p2align=3, $pop68
	return
	.endfunc
.Lfunc_end102:
	.size	testQ, .Lfunc_end102-testQ

	.section	.text.retmeR,"ax",@progbits
	.hidden	retmeR
	.globl	retmeR
	.type	retmeR,@function
retmeR:                                 # @retmeR
	.param  	i32, i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.add 	$push3=, $1, $pop1
	i64.load	$2=, 0($pop3)
	i64.load	$push0=, 0($1)
	i64.store	$discard=, 0($0), $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i64.store	$discard=, 0($pop2), $2
	return
	.endfunc
.Lfunc_end103:
	.size	retmeR, .Lfunc_end103-retmeR

	.section	.text.fn1R,"ax",@progbits
	.hidden	fn1R
	.globl	fn1R
	.type	fn1R,@function
fn1R:                                   # @fn1R
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sR($pop0):p2align=3
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 4095
	i32.and 	$push4=, $pop2, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end104:
	.size	fn1R, .Lfunc_end104-fn1R

	.section	.text.fn2R,"ax",@progbits
	.hidden	fn2R
	.globl	fn2R
	.type	fn2R,@function
fn2R:                                   # @fn2R
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sR($pop0):p2align=3
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 4095
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push5=, 15
	i32.rem_u	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end105:
	.size	fn2R, .Lfunc_end105-fn2R

	.section	.text.retitR,"ax",@progbits
	.hidden	retitR
	.globl	retitR
	.type	retitR,@function
retitR:                                 # @retitR
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sR($pop0):p2align=3
	i32.const	$push2=, 4095
	i32.and 	$push3=, $pop1, $pop2
	return  	$pop3
	.endfunc
.Lfunc_end106:
	.size	retitR, .Lfunc_end106-retitR

	.section	.text.fn3R,"ax",@progbits
	.hidden	fn3R
	.globl	fn3R
	.type	fn3R,@function
fn3R:                                   # @fn3R
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push1=, sR($pop10):p2align=3
	tee_local	$push9=, $1=, $pop1
	i32.add 	$push2=, $pop9, $0
	i32.const	$push3=, 4095
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push8=, $0=, $pop4
	i32.const	$push5=, -4096
	i32.and 	$push6=, $1, $pop5
	i32.or  	$push7=, $pop8, $pop6
	i32.store	$discard=, sR($pop0):p2align=3, $pop7
	return  	$0
	.endfunc
.Lfunc_end107:
	.size	fn3R, .Lfunc_end107-fn3R

	.section	.text.testR,"ax",@progbits
	.hidden	testR
	.globl	testR
	.type	testR,@function
testR:                                  # @testR
	.local  	i32, i32
# BB#0:                                 # %if.end75
	i32.const	$push0=, 0
	i32.const	$push154=, 0
	i32.load	$push1=, myrnd.s($pop154)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push5=, $pop3, $pop4
	tee_local	$push153=, $1=, $pop5
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop153, $pop6
	i32.store8	$discard=, sR($pop0):p2align=3, $pop7
	i32.const	$push152=, 0
	i32.const	$push151=, 1103515245
	i32.mul 	$push8=, $1, $pop151
	i32.const	$push150=, 12345
	i32.add 	$push9=, $pop8, $pop150
	tee_local	$push149=, $1=, $pop9
	i32.const	$push148=, 16
	i32.shr_u	$push10=, $pop149, $pop148
	i32.store8	$discard=, sR+1($pop152), $pop10
	i32.const	$push147=, 0
	i32.const	$push146=, 1103515245
	i32.mul 	$push11=, $1, $pop146
	i32.const	$push145=, 12345
	i32.add 	$push12=, $pop11, $pop145
	tee_local	$push144=, $1=, $pop12
	i32.const	$push143=, 16
	i32.shr_u	$push13=, $pop144, $pop143
	i32.store8	$discard=, sR+2($pop147):p2align=1, $pop13
	i32.const	$push142=, 0
	i32.const	$push141=, 1103515245
	i32.mul 	$push14=, $1, $pop141
	i32.const	$push140=, 12345
	i32.add 	$push15=, $pop14, $pop140
	tee_local	$push139=, $1=, $pop15
	i32.const	$push138=, 16
	i32.shr_u	$push16=, $pop139, $pop138
	i32.store8	$discard=, sR+3($pop142), $pop16
	i32.const	$push137=, 0
	i32.const	$push136=, 1103515245
	i32.mul 	$push17=, $1, $pop136
	i32.const	$push135=, 12345
	i32.add 	$push18=, $pop17, $pop135
	tee_local	$push134=, $1=, $pop18
	i32.const	$push133=, 16
	i32.shr_u	$push19=, $pop134, $pop133
	i32.store8	$discard=, sR+4($pop137):p2align=2, $pop19
	i32.const	$push132=, 0
	i32.const	$push131=, 1103515245
	i32.mul 	$push20=, $1, $pop131
	i32.const	$push130=, 12345
	i32.add 	$push21=, $pop20, $pop130
	tee_local	$push129=, $1=, $pop21
	i32.const	$push128=, 16
	i32.shr_u	$push22=, $pop129, $pop128
	i32.store8	$discard=, sR+5($pop132), $pop22
	i32.const	$push127=, 0
	i32.const	$push126=, 1103515245
	i32.mul 	$push23=, $1, $pop126
	i32.const	$push125=, 12345
	i32.add 	$push24=, $pop23, $pop125
	tee_local	$push124=, $1=, $pop24
	i32.const	$push123=, 16
	i32.shr_u	$push25=, $pop124, $pop123
	i32.store8	$discard=, sR+6($pop127):p2align=1, $pop25
	i32.const	$push122=, 0
	i32.const	$push121=, 1103515245
	i32.mul 	$push26=, $1, $pop121
	i32.const	$push120=, 12345
	i32.add 	$push27=, $pop26, $pop120
	tee_local	$push119=, $1=, $pop27
	i32.const	$push118=, 16
	i32.shr_u	$push28=, $pop119, $pop118
	i32.store8	$discard=, sR+7($pop122), $pop28
	i32.const	$push117=, 0
	i32.const	$push116=, 1103515245
	i32.mul 	$push29=, $1, $pop116
	i32.const	$push115=, 12345
	i32.add 	$push30=, $pop29, $pop115
	tee_local	$push114=, $1=, $pop30
	i32.const	$push113=, 16
	i32.shr_u	$push31=, $pop114, $pop113
	i32.store8	$discard=, sR+8($pop117):p2align=3, $pop31
	i32.const	$push112=, 0
	i32.const	$push111=, 1103515245
	i32.mul 	$push32=, $1, $pop111
	i32.const	$push110=, 12345
	i32.add 	$push33=, $pop32, $pop110
	tee_local	$push109=, $1=, $pop33
	i32.const	$push108=, 16
	i32.shr_u	$push34=, $pop109, $pop108
	i32.store8	$discard=, sR+9($pop112), $pop34
	i32.const	$push107=, 0
	i32.const	$push106=, 1103515245
	i32.mul 	$push35=, $1, $pop106
	i32.const	$push105=, 12345
	i32.add 	$push36=, $pop35, $pop105
	tee_local	$push104=, $1=, $pop36
	i32.const	$push103=, 16
	i32.shr_u	$push37=, $pop104, $pop103
	i32.store8	$discard=, sR+10($pop107):p2align=1, $pop37
	i32.const	$push102=, 0
	i32.const	$push101=, 1103515245
	i32.mul 	$push38=, $1, $pop101
	i32.const	$push100=, 12345
	i32.add 	$push39=, $pop38, $pop100
	tee_local	$push99=, $1=, $pop39
	i32.const	$push98=, 16
	i32.shr_u	$push40=, $pop99, $pop98
	i32.store8	$discard=, sR+11($pop102), $pop40
	i32.const	$push97=, 0
	i32.const	$push96=, 1103515245
	i32.mul 	$push41=, $1, $pop96
	i32.const	$push95=, 12345
	i32.add 	$push42=, $pop41, $pop95
	tee_local	$push94=, $1=, $pop42
	i32.const	$push93=, 16
	i32.shr_u	$push43=, $pop94, $pop93
	i32.store8	$discard=, sR+12($pop97):p2align=2, $pop43
	i32.const	$push92=, 0
	i32.const	$push91=, 1103515245
	i32.mul 	$push44=, $1, $pop91
	i32.const	$push90=, 12345
	i32.add 	$push45=, $pop44, $pop90
	tee_local	$push89=, $1=, $pop45
	i32.const	$push88=, 16
	i32.shr_u	$push46=, $pop89, $pop88
	i32.store8	$discard=, sR+13($pop92), $pop46
	i32.const	$push87=, 0
	i32.const	$push86=, 1103515245
	i32.mul 	$push47=, $1, $pop86
	i32.const	$push85=, 12345
	i32.add 	$push48=, $pop47, $pop85
	tee_local	$push84=, $1=, $pop48
	i32.const	$push83=, 16
	i32.shr_u	$push49=, $pop84, $pop83
	i32.store8	$discard=, sR+14($pop87):p2align=1, $pop49
	i32.const	$push82=, 0
	i32.load	$0=, sR($pop82):p2align=3
	i32.const	$push81=, 0
	i32.const	$push80=, 1103515245
	i32.mul 	$push50=, $1, $pop80
	i32.const	$push79=, 12345
	i32.add 	$push51=, $pop50, $pop79
	tee_local	$push78=, $1=, $pop51
	i32.const	$push77=, 16
	i32.shr_u	$push52=, $pop78, $pop77
	i32.store8	$discard=, sR+15($pop81), $pop52
	i32.const	$push76=, 0
	i32.const	$push75=, 0
	i32.const	$push55=, -341751747
	i32.mul 	$push56=, $1, $pop55
	i32.const	$push57=, 229283573
	i32.add 	$push58=, $pop56, $pop57
	tee_local	$push74=, $1=, $pop58
	i32.const	$push73=, 1103515245
	i32.mul 	$push62=, $pop74, $pop73
	i32.const	$push72=, 12345
	i32.add 	$push63=, $pop62, $pop72
	i32.store	$push64=, myrnd.s($pop75), $pop63
	i32.const	$push71=, 16
	i32.shr_u	$push65=, $pop64, $pop71
	i32.const	$push60=, 2047
	i32.and 	$push66=, $pop65, $pop60
	i32.const	$push70=, 16
	i32.shr_u	$push59=, $1, $pop70
	i32.const	$push69=, 2047
	i32.and 	$push61=, $pop59, $pop69
	i32.add 	$push67=, $pop66, $pop61
	i32.const	$push53=, -4096
	i32.and 	$push54=, $0, $pop53
	i32.or  	$push68=, $pop67, $pop54
	i32.store	$discard=, sR($pop76):p2align=3, $pop68
	return
	.endfunc
.Lfunc_end108:
	.size	testR, .Lfunc_end108-testR

	.section	.text.retmeS,"ax",@progbits
	.hidden	retmeS
	.globl	retmeS
	.type	retmeS,@function
retmeS:                                 # @retmeS
	.param  	i32, i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.add 	$push3=, $1, $pop1
	i64.load	$2=, 0($pop3)
	i64.load	$push0=, 0($1)
	i64.store	$discard=, 0($0), $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i64.store	$discard=, 0($pop2), $2
	return
	.endfunc
.Lfunc_end109:
	.size	retmeS, .Lfunc_end109-retmeS

	.section	.text.fn1S,"ax",@progbits
	.hidden	fn1S
	.globl	fn1S
	.type	fn1S,@function
fn1S:                                   # @fn1S
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_u	$push1=, sS($pop0):p2align=3
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 1
	i32.and 	$push4=, $pop2, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end110:
	.size	fn1S, .Lfunc_end110-fn1S

	.section	.text.fn2S,"ax",@progbits
	.hidden	fn2S
	.globl	fn2S
	.type	fn2S,@function
fn2S:                                   # @fn2S
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_u	$push1=, sS($pop0):p2align=3
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 1
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push5=, 15
	i32.rem_u	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end111:
	.size	fn2S, .Lfunc_end111-fn2S

	.section	.text.retitS,"ax",@progbits
	.hidden	retitS
	.globl	retitS
	.type	retitS,@function
retitS:                                 # @retitS
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_u	$push1=, sS($pop0):p2align=3
	i32.const	$push2=, 1
	i32.and 	$push3=, $pop1, $pop2
	return  	$pop3
	.endfunc
.Lfunc_end112:
	.size	retitS, .Lfunc_end112-retitS

	.section	.text.fn3S,"ax",@progbits
	.hidden	fn3S
	.globl	fn3S
	.type	fn3S,@function
fn3S:                                   # @fn3S
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load16_u	$push1=, sS($pop10):p2align=3
	tee_local	$push9=, $1=, $pop1
	i32.add 	$push2=, $pop9, $0
	i32.const	$push5=, 1
	i32.and 	$push6=, $pop2, $pop5
	tee_local	$push8=, $0=, $pop6
	i32.const	$push3=, 65534
	i32.and 	$push4=, $1, $pop3
	i32.or  	$push7=, $pop8, $pop4
	i32.store16	$discard=, sS($pop0):p2align=3, $pop7
	return  	$0
	.endfunc
.Lfunc_end113:
	.size	fn3S, .Lfunc_end113-fn3S

	.section	.text.testS,"ax",@progbits
	.hidden	testS
	.globl	testS
	.type	testS,@function
testS:                                  # @testS
	.local  	i32, i32
# BB#0:                                 # %if.end90
	i32.const	$push0=, 0
	i32.const	$push153=, 0
	i32.load	$push1=, myrnd.s($pop153)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push5=, $pop3, $pop4
	tee_local	$push152=, $1=, $pop5
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop152, $pop6
	i32.store8	$discard=, sS($pop0):p2align=3, $pop7
	i32.const	$push151=, 0
	i32.const	$push150=, 1103515245
	i32.mul 	$push8=, $1, $pop150
	i32.const	$push149=, 12345
	i32.add 	$push9=, $pop8, $pop149
	tee_local	$push148=, $1=, $pop9
	i32.const	$push147=, 16
	i32.shr_u	$push10=, $pop148, $pop147
	i32.store8	$discard=, sS+1($pop151), $pop10
	i32.const	$push146=, 0
	i32.const	$push145=, 1103515245
	i32.mul 	$push11=, $1, $pop145
	i32.const	$push144=, 12345
	i32.add 	$push12=, $pop11, $pop144
	tee_local	$push143=, $1=, $pop12
	i32.const	$push142=, 16
	i32.shr_u	$push13=, $pop143, $pop142
	i32.store8	$discard=, sS+2($pop146):p2align=1, $pop13
	i32.const	$push141=, 0
	i32.const	$push140=, 1103515245
	i32.mul 	$push14=, $1, $pop140
	i32.const	$push139=, 12345
	i32.add 	$push15=, $pop14, $pop139
	tee_local	$push138=, $1=, $pop15
	i32.const	$push137=, 16
	i32.shr_u	$push16=, $pop138, $pop137
	i32.store8	$discard=, sS+3($pop141), $pop16
	i32.const	$push136=, 0
	i32.const	$push135=, 1103515245
	i32.mul 	$push17=, $1, $pop135
	i32.const	$push134=, 12345
	i32.add 	$push18=, $pop17, $pop134
	tee_local	$push133=, $1=, $pop18
	i32.const	$push132=, 16
	i32.shr_u	$push19=, $pop133, $pop132
	i32.store8	$discard=, sS+4($pop136):p2align=2, $pop19
	i32.const	$push131=, 0
	i32.const	$push130=, 1103515245
	i32.mul 	$push20=, $1, $pop130
	i32.const	$push129=, 12345
	i32.add 	$push21=, $pop20, $pop129
	tee_local	$push128=, $1=, $pop21
	i32.const	$push127=, 16
	i32.shr_u	$push22=, $pop128, $pop127
	i32.store8	$discard=, sS+5($pop131), $pop22
	i32.const	$push126=, 0
	i32.const	$push125=, 1103515245
	i32.mul 	$push23=, $1, $pop125
	i32.const	$push124=, 12345
	i32.add 	$push24=, $pop23, $pop124
	tee_local	$push123=, $1=, $pop24
	i32.const	$push122=, 16
	i32.shr_u	$push25=, $pop123, $pop122
	i32.store8	$discard=, sS+6($pop126):p2align=1, $pop25
	i32.const	$push121=, 0
	i32.const	$push120=, 1103515245
	i32.mul 	$push26=, $1, $pop120
	i32.const	$push119=, 12345
	i32.add 	$push27=, $pop26, $pop119
	tee_local	$push118=, $1=, $pop27
	i32.const	$push117=, 16
	i32.shr_u	$push28=, $pop118, $pop117
	i32.store8	$discard=, sS+7($pop121), $pop28
	i32.const	$push116=, 0
	i32.const	$push115=, 1103515245
	i32.mul 	$push29=, $1, $pop115
	i32.const	$push114=, 12345
	i32.add 	$push30=, $pop29, $pop114
	tee_local	$push113=, $1=, $pop30
	i32.const	$push112=, 16
	i32.shr_u	$push31=, $pop113, $pop112
	i32.store8	$discard=, sS+8($pop116):p2align=3, $pop31
	i32.const	$push111=, 0
	i32.const	$push110=, 1103515245
	i32.mul 	$push32=, $1, $pop110
	i32.const	$push109=, 12345
	i32.add 	$push33=, $pop32, $pop109
	tee_local	$push108=, $1=, $pop33
	i32.const	$push107=, 16
	i32.shr_u	$push34=, $pop108, $pop107
	i32.store8	$discard=, sS+9($pop111), $pop34
	i32.const	$push106=, 0
	i32.const	$push105=, 1103515245
	i32.mul 	$push35=, $1, $pop105
	i32.const	$push104=, 12345
	i32.add 	$push36=, $pop35, $pop104
	tee_local	$push103=, $1=, $pop36
	i32.const	$push102=, 16
	i32.shr_u	$push37=, $pop103, $pop102
	i32.store8	$discard=, sS+10($pop106):p2align=1, $pop37
	i32.const	$push101=, 0
	i32.const	$push100=, 1103515245
	i32.mul 	$push38=, $1, $pop100
	i32.const	$push99=, 12345
	i32.add 	$push39=, $pop38, $pop99
	tee_local	$push98=, $1=, $pop39
	i32.const	$push97=, 16
	i32.shr_u	$push40=, $pop98, $pop97
	i32.store8	$discard=, sS+11($pop101), $pop40
	i32.const	$push96=, 0
	i32.const	$push95=, 1103515245
	i32.mul 	$push41=, $1, $pop95
	i32.const	$push94=, 12345
	i32.add 	$push42=, $pop41, $pop94
	tee_local	$push93=, $1=, $pop42
	i32.const	$push92=, 16
	i32.shr_u	$push43=, $pop93, $pop92
	i32.store8	$discard=, sS+12($pop96):p2align=2, $pop43
	i32.const	$push91=, 0
	i32.const	$push90=, 1103515245
	i32.mul 	$push44=, $1, $pop90
	i32.const	$push89=, 12345
	i32.add 	$push45=, $pop44, $pop89
	tee_local	$push88=, $1=, $pop45
	i32.const	$push87=, 16
	i32.shr_u	$push46=, $pop88, $pop87
	i32.store8	$discard=, sS+13($pop91), $pop46
	i32.const	$push86=, 0
	i32.const	$push85=, 1103515245
	i32.mul 	$push47=, $1, $pop85
	i32.const	$push84=, 12345
	i32.add 	$push48=, $pop47, $pop84
	tee_local	$push83=, $1=, $pop48
	i32.const	$push82=, 16
	i32.shr_u	$push49=, $pop83, $pop82
	i32.store8	$discard=, sS+14($pop86):p2align=1, $pop49
	i32.const	$push81=, 0
	i32.load16_u	$0=, sS($pop81):p2align=3
	i32.const	$push80=, 0
	i32.const	$push79=, 1103515245
	i32.mul 	$push50=, $1, $pop79
	i32.const	$push78=, 12345
	i32.add 	$push51=, $pop50, $pop78
	tee_local	$push77=, $1=, $pop51
	i32.const	$push76=, 16
	i32.shr_u	$push52=, $pop77, $pop76
	i32.store8	$discard=, sS+15($pop80), $pop52
	i32.const	$push75=, 0
	i32.const	$push74=, 0
	i32.const	$push55=, -341751747
	i32.mul 	$push56=, $1, $pop55
	i32.const	$push57=, 229283573
	i32.add 	$push58=, $pop56, $pop57
	tee_local	$push73=, $1=, $pop58
	i32.const	$push72=, 1103515245
	i32.mul 	$push60=, $pop73, $pop72
	i32.const	$push71=, 12345
	i32.add 	$push61=, $pop60, $pop71
	i32.store	$push62=, myrnd.s($pop74), $pop61
	i32.const	$push70=, 16
	i32.shr_u	$push63=, $pop62, $pop70
	i32.const	$push69=, 16
	i32.shr_u	$push59=, $1, $pop69
	i32.add 	$push64=, $pop63, $pop59
	i32.const	$push65=, 1
	i32.and 	$push66=, $pop64, $pop65
	i32.const	$push53=, 65534
	i32.and 	$push54=, $0, $pop53
	i32.or  	$push67=, $pop66, $pop54
	i32.store16	$discard=, sS($pop75):p2align=3, $pop67
	block
	i32.const	$push68=, 1
	i32.const	$push154=, 0
	i32.eq  	$push155=, $pop68, $pop154
	br_if   	0, $pop155      # 0: down to label22
# BB#1:                                 # %if.end134
	return
.LBB114_2:                              # %if.then133
	end_block                       # label22:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end114:
	.size	testS, .Lfunc_end114-testS

	.section	.text.retmeT,"ax",@progbits
	.hidden	retmeT
	.globl	retmeT
	.type	retmeT,@function
retmeT:                                 # @retmeT
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($1):p2align=1
	i32.store	$discard=, 0($0):p2align=1, $pop0
	return
	.endfunc
.Lfunc_end115:
	.size	retmeT, .Lfunc_end115-retmeT

	.section	.text.fn1T,"ax",@progbits
	.hidden	fn1T
	.globl	fn1T
	.type	fn1T,@function
fn1T:                                   # @fn1T
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sT($pop0)
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 1
	i32.and 	$push4=, $pop2, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end116:
	.size	fn1T, .Lfunc_end116-fn1T

	.section	.text.fn2T,"ax",@progbits
	.hidden	fn2T
	.globl	fn2T
	.type	fn2T,@function
fn2T:                                   # @fn2T
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_u	$push1=, sT($pop0):p2align=2
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 1
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push5=, 15
	i32.rem_u	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end117:
	.size	fn2T, .Lfunc_end117-fn2T

	.section	.text.retitT,"ax",@progbits
	.hidden	retitT
	.globl	retitT
	.type	retitT,@function
retitT:                                 # @retitT
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_u	$push1=, sT($pop0):p2align=2
	i32.const	$push2=, 1
	i32.and 	$push3=, $pop1, $pop2
	return  	$pop3
	.endfunc
.Lfunc_end118:
	.size	retitT, .Lfunc_end118-retitT

	.section	.text.fn3T,"ax",@progbits
	.hidden	fn3T
	.globl	fn3T
	.type	fn3T,@function
fn3T:                                   # @fn3T
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load16_u	$push1=, sT($pop10):p2align=2
	tee_local	$push9=, $1=, $pop1
	i32.add 	$push2=, $pop9, $0
	i32.const	$push5=, 1
	i32.and 	$push6=, $pop2, $pop5
	tee_local	$push8=, $0=, $pop6
	i32.const	$push3=, 65534
	i32.and 	$push4=, $1, $pop3
	i32.or  	$push7=, $pop8, $pop4
	i32.store16	$discard=, sT($pop0):p2align=2, $pop7
	return  	$0
	.endfunc
.Lfunc_end119:
	.size	fn3T, .Lfunc_end119-fn3T

	.section	.text.testT,"ax",@progbits
	.hidden	testT
	.globl	testT
	.type	testT,@function
testT:                                  # @testT
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push78=, 0
	i32.const	$push77=, 0
	i32.load	$push1=, myrnd.s($pop77)
	i32.const	$push76=, 1103515245
	i32.mul 	$push2=, $pop1, $pop76
	i32.const	$push75=, 12345
	i32.add 	$push3=, $pop2, $pop75
	tee_local	$push74=, $0=, $pop3
	i32.const	$push73=, 16
	i32.shr_u	$push4=, $pop74, $pop73
	i32.store8	$discard=, sT($pop78):p2align=2, $pop4
	i32.const	$push72=, 0
	i32.const	$push71=, 1103515245
	i32.mul 	$push5=, $0, $pop71
	i32.const	$push70=, 12345
	i32.add 	$push6=, $pop5, $pop70
	tee_local	$push69=, $0=, $pop6
	i32.const	$push68=, 16
	i32.shr_u	$push7=, $pop69, $pop68
	i32.store8	$discard=, sT+1($pop72), $pop7
	i32.const	$push67=, 0
	i32.const	$push66=, 1103515245
	i32.mul 	$push8=, $0, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push9=, $pop8, $pop65
	tee_local	$push64=, $0=, $pop9
	i32.const	$push63=, 16
	i32.shr_u	$push10=, $pop64, $pop63
	i32.store8	$discard=, sT+2($pop67):p2align=1, $pop10
	i32.const	$push62=, 0
	i32.const	$push61=, 1103515245
	i32.mul 	$push11=, $0, $pop61
	i32.const	$push60=, 12345
	i32.add 	$push12=, $pop11, $pop60
	tee_local	$push59=, $0=, $pop12
	i32.const	$push58=, 16
	i32.shr_u	$push13=, $pop59, $pop58
	i32.store8	$discard=, sT+3($pop62), $pop13
	i32.const	$push57=, 0
	i32.const	$push56=, 1103515245
	i32.mul 	$push15=, $0, $pop56
	i32.const	$push55=, 12345
	i32.add 	$push16=, $pop15, $pop55
	tee_local	$push54=, $3=, $pop16
	i32.const	$push53=, 16
	i32.shr_u	$push17=, $pop54, $pop53
	tee_local	$push52=, $2=, $pop17
	i32.const	$push51=, 1
	i32.and 	$push21=, $pop52, $pop51
	i32.const	$push50=, 0
	i32.load16_u	$push14=, sT($pop50):p2align=2
	i32.const	$push49=, 65534
	i32.and 	$push22=, $pop14, $pop49
	i32.or  	$push23=, $pop21, $pop22
	i32.store16	$discard=, sT($pop57):p2align=2, $pop23
	i32.const	$push48=, 0
	i32.load	$0=, sT($pop48)
	block
	i32.const	$push47=, 0
	i32.const	$push46=, 1103515245
	i32.mul 	$push18=, $3, $pop46
	i32.const	$push45=, 12345
	i32.add 	$push0=, $pop18, $pop45
	i32.store	$push19=, myrnd.s($pop47), $pop0
	tee_local	$push44=, $1=, $pop19
	i32.const	$push43=, 16
	i32.shr_u	$push20=, $pop44, $pop43
	tee_local	$push42=, $3=, $pop20
	i32.add 	$push25=, $pop42, $2
	i32.add 	$push24=, $3, $0
	i32.xor 	$push26=, $pop25, $pop24
	i32.const	$push41=, 1
	i32.and 	$push27=, $pop26, $pop41
	br_if   	0, $pop27       # 0: down to label23
# BB#1:                                 # %if.end94
	i32.const	$push88=, 0
	i32.const	$push87=, 0
	i32.const	$push29=, -2139243339
	i32.mul 	$push30=, $1, $pop29
	i32.const	$push31=, -1492899873
	i32.add 	$push32=, $pop30, $pop31
	tee_local	$push86=, $3=, $pop32
	i32.const	$push85=, 1103515245
	i32.mul 	$push34=, $pop86, $pop85
	i32.const	$push84=, 12345
	i32.add 	$push35=, $pop34, $pop84
	i32.store	$push36=, myrnd.s($pop87), $pop35
	i32.const	$push83=, 16
	i32.shr_u	$push37=, $pop36, $pop83
	i32.const	$push82=, 16
	i32.shr_u	$push33=, $3, $pop82
	i32.add 	$push38=, $pop37, $pop33
	i32.const	$push81=, 1
	i32.and 	$push39=, $pop38, $pop81
	i32.const	$push80=, 65534
	i32.and 	$push28=, $0, $pop80
	i32.or  	$push40=, $pop39, $pop28
	i32.store16	$discard=, sT($pop88):p2align=2, $pop40
	block
	i32.const	$push79=, 1
	i32.const	$push89=, 0
	i32.eq  	$push90=, $pop79, $pop89
	br_if   	0, $pop90       # 0: down to label24
# BB#2:                                 # %if.end140
	return
.LBB120_3:                              # %if.then139
	end_block                       # label24:
	call    	abort@FUNCTION
	unreachable
.LBB120_4:                              # %if.then
	end_block                       # label23:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end120:
	.size	testT, .Lfunc_end120-testT

	.section	.text.retmeU,"ax",@progbits
	.hidden	retmeU
	.globl	retmeU
	.type	retmeU,@function
retmeU:                                 # @retmeU
	.param  	i32, i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.add 	$push3=, $1, $pop1
	i64.load	$2=, 0($pop3)
	i64.load	$push0=, 0($1)
	i64.store	$discard=, 0($0), $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i64.store	$discard=, 0($pop2), $2
	return
	.endfunc
.Lfunc_end121:
	.size	retmeU, .Lfunc_end121-retmeU

	.section	.text.fn1U,"ax",@progbits
	.hidden	fn1U
	.globl	fn1U
	.type	fn1U,@function
fn1U:                                   # @fn1U
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_u	$push1=, sU($pop0):p2align=3
	i32.const	$push2=, 6
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 1
	i32.and 	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end122:
	.size	fn1U, .Lfunc_end122-fn1U

	.section	.text.fn2U,"ax",@progbits
	.hidden	fn2U
	.globl	fn2U
	.type	fn2U,@function
fn2U:                                   # @fn2U
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_u	$push1=, sU($pop0):p2align=3
	i32.const	$push2=, 6
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 1
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push7=, 15
	i32.rem_u	$push8=, $pop6, $pop7
	return  	$pop8
	.endfunc
.Lfunc_end123:
	.size	fn2U, .Lfunc_end123-fn2U

	.section	.text.retitU,"ax",@progbits
	.hidden	retitU
	.globl	retitU
	.type	retitU,@function
retitU:                                 # @retitU
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_u	$push1=, sU($pop0):p2align=3
	i32.const	$push2=, 6
	i32.shr_u	$push3=, $pop1, $pop2
	i32.const	$push4=, 1
	i32.and 	$push5=, $pop3, $pop4
	return  	$pop5
	.endfunc
.Lfunc_end124:
	.size	retitU, .Lfunc_end124-retitU

	.section	.text.fn3U,"ax",@progbits
	.hidden	fn3U
	.globl	fn3U
	.type	fn3U,@function
fn3U:                                   # @fn3U
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push16=, 0
	i32.load16_u	$push1=, sU($pop16):p2align=3
	tee_local	$push15=, $1=, $pop1
	i32.const	$push2=, 6
	i32.shr_u	$push3=, $pop15, $pop2
	i32.add 	$push4=, $pop3, $0
	tee_local	$push14=, $0=, $pop4
	i32.const	$push13=, 6
	i32.shl 	$push5=, $pop14, $pop13
	i32.const	$push6=, 64
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push8=, 65471
	i32.and 	$push9=, $1, $pop8
	i32.or  	$push10=, $pop7, $pop9
	i32.store16	$discard=, sU($pop0):p2align=3, $pop10
	i32.const	$push11=, 1
	i32.and 	$push12=, $0, $pop11
	return  	$pop12
	.endfunc
.Lfunc_end125:
	.size	fn3U, .Lfunc_end125-fn3U

	.section	.text.testU,"ax",@progbits
	.hidden	testU
	.globl	testU
	.type	testU,@function
testU:                                  # @testU
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push226=, 0
	i32.load	$push10=, myrnd.s($pop226)
	i32.const	$push11=, 1103515245
	i32.mul 	$push12=, $pop10, $pop11
	i32.const	$push13=, 12345
	i32.add 	$push14=, $pop12, $pop13
	tee_local	$push225=, $2=, $pop14
	i32.const	$push224=, 16
	i32.shr_u	$push15=, $pop225, $pop224
	i32.store8	$discard=, sU($pop9):p2align=3, $pop15
	i32.const	$push223=, 0
	i32.const	$push222=, 1103515245
	i32.mul 	$push16=, $2, $pop222
	i32.const	$push221=, 12345
	i32.add 	$push17=, $pop16, $pop221
	tee_local	$push220=, $2=, $pop17
	i32.const	$push219=, 16
	i32.shr_u	$push18=, $pop220, $pop219
	i32.store8	$discard=, sU+1($pop223), $pop18
	i32.const	$push218=, 0
	i32.const	$push217=, 1103515245
	i32.mul 	$push19=, $2, $pop217
	i32.const	$push216=, 12345
	i32.add 	$push20=, $pop19, $pop216
	tee_local	$push215=, $2=, $pop20
	i32.const	$push214=, 16
	i32.shr_u	$push21=, $pop215, $pop214
	i32.store8	$discard=, sU+2($pop218):p2align=1, $pop21
	i32.const	$push213=, 0
	i32.const	$push212=, 1103515245
	i32.mul 	$push22=, $2, $pop212
	i32.const	$push211=, 12345
	i32.add 	$push23=, $pop22, $pop211
	tee_local	$push210=, $2=, $pop23
	i32.const	$push209=, 16
	i32.shr_u	$push24=, $pop210, $pop209
	i32.store8	$discard=, sU+3($pop213), $pop24
	i32.const	$push208=, 0
	i32.const	$push207=, 1103515245
	i32.mul 	$push25=, $2, $pop207
	i32.const	$push206=, 12345
	i32.add 	$push26=, $pop25, $pop206
	tee_local	$push205=, $2=, $pop26
	i32.const	$push204=, 16
	i32.shr_u	$push27=, $pop205, $pop204
	i32.store8	$discard=, sU+4($pop208):p2align=2, $pop27
	i32.const	$push203=, 0
	i32.const	$push202=, 1103515245
	i32.mul 	$push28=, $2, $pop202
	i32.const	$push201=, 12345
	i32.add 	$push29=, $pop28, $pop201
	tee_local	$push200=, $2=, $pop29
	i32.const	$push199=, 16
	i32.shr_u	$push30=, $pop200, $pop199
	i32.store8	$discard=, sU+5($pop203), $pop30
	i32.const	$push198=, 0
	i32.const	$push197=, 1103515245
	i32.mul 	$push31=, $2, $pop197
	i32.const	$push196=, 12345
	i32.add 	$push32=, $pop31, $pop196
	tee_local	$push195=, $2=, $pop32
	i32.const	$push194=, 16
	i32.shr_u	$push33=, $pop195, $pop194
	i32.store8	$discard=, sU+6($pop198):p2align=1, $pop33
	i32.const	$push193=, 0
	i32.const	$push192=, 1103515245
	i32.mul 	$push34=, $2, $pop192
	i32.const	$push191=, 12345
	i32.add 	$push35=, $pop34, $pop191
	tee_local	$push190=, $2=, $pop35
	i32.const	$push189=, 16
	i32.shr_u	$push36=, $pop190, $pop189
	i32.store8	$discard=, sU+7($pop193), $pop36
	i32.const	$push188=, 0
	i32.const	$push187=, 1103515245
	i32.mul 	$push37=, $2, $pop187
	i32.const	$push186=, 12345
	i32.add 	$push38=, $pop37, $pop186
	tee_local	$push185=, $2=, $pop38
	i32.const	$push184=, 16
	i32.shr_u	$push39=, $pop185, $pop184
	i32.store8	$discard=, sU+8($pop188):p2align=3, $pop39
	i32.const	$push183=, 0
	i32.const	$push182=, 1103515245
	i32.mul 	$push40=, $2, $pop182
	i32.const	$push181=, 12345
	i32.add 	$push41=, $pop40, $pop181
	tee_local	$push180=, $2=, $pop41
	i32.const	$push179=, 16
	i32.shr_u	$push42=, $pop180, $pop179
	i32.store8	$discard=, sU+9($pop183), $pop42
	i32.const	$push178=, 0
	i32.const	$push177=, 1103515245
	i32.mul 	$push43=, $2, $pop177
	i32.const	$push176=, 12345
	i32.add 	$push44=, $pop43, $pop176
	tee_local	$push175=, $2=, $pop44
	i32.const	$push174=, 16
	i32.shr_u	$push45=, $pop175, $pop174
	i32.store8	$discard=, sU+10($pop178):p2align=1, $pop45
	i32.const	$push173=, 0
	i32.const	$push172=, 1103515245
	i32.mul 	$push46=, $2, $pop172
	i32.const	$push171=, 12345
	i32.add 	$push47=, $pop46, $pop171
	tee_local	$push170=, $2=, $pop47
	i32.const	$push169=, 16
	i32.shr_u	$push48=, $pop170, $pop169
	i32.store8	$discard=, sU+11($pop173), $pop48
	i32.const	$push168=, 0
	i32.const	$push167=, 1103515245
	i32.mul 	$push49=, $2, $pop167
	i32.const	$push166=, 12345
	i32.add 	$push50=, $pop49, $pop166
	tee_local	$push165=, $2=, $pop50
	i32.const	$push164=, 16
	i32.shr_u	$push51=, $pop165, $pop164
	i32.store8	$discard=, sU+12($pop168):p2align=2, $pop51
	i32.const	$push163=, 0
	i32.const	$push162=, 1103515245
	i32.mul 	$push52=, $2, $pop162
	i32.const	$push161=, 12345
	i32.add 	$push53=, $pop52, $pop161
	tee_local	$push160=, $2=, $pop53
	i32.const	$push159=, 16
	i32.shr_u	$push54=, $pop160, $pop159
	i32.store8	$discard=, sU+13($pop163), $pop54
	i32.const	$push158=, 0
	i32.const	$push157=, 1103515245
	i32.mul 	$push55=, $2, $pop157
	i32.const	$push156=, 12345
	i32.add 	$push56=, $pop55, $pop156
	tee_local	$push155=, $2=, $pop56
	i32.const	$push154=, 16
	i32.shr_u	$push57=, $pop155, $pop154
	i32.store8	$discard=, sU+14($pop158):p2align=1, $pop57
	i32.const	$push153=, 0
	i32.const	$push152=, 1103515245
	i32.mul 	$push58=, $2, $pop152
	i32.const	$push151=, 12345
	i32.add 	$push59=, $pop58, $pop151
	tee_local	$push150=, $2=, $pop59
	i32.const	$push149=, 16
	i32.shr_u	$push60=, $pop150, $pop149
	i32.store8	$discard=, sU+15($pop153), $pop60
	i32.const	$push148=, 0
	i32.load16_u	$0=, sU($pop148):p2align=3
	i32.const	$push147=, 0
	i32.const	$push146=, 1103515245
	i32.mul 	$push61=, $2, $pop146
	i32.const	$push145=, 12345
	i32.add 	$push62=, $pop61, $pop145
	tee_local	$push144=, $2=, $pop62
	i32.const	$push143=, 1103515245
	i32.mul 	$push65=, $pop144, $pop143
	i32.const	$push142=, 12345
	i32.add 	$push1=, $pop65, $pop142
	i32.store	$1=, myrnd.s($pop147), $pop1
	i32.const	$push141=, 0
	i32.const	$push140=, 16
	i32.shr_u	$push0=, $2, $pop140
	tee_local	$push139=, $4=, $pop0
	i32.const	$push63=, 2047
	i32.and 	$push64=, $pop139, $pop63
	tee_local	$push138=, $3=, $pop64
	i32.const	$push66=, 6
	i32.shl 	$push67=, $pop138, $pop66
	i32.const	$push68=, 64
	i32.and 	$push69=, $pop67, $pop68
	i32.const	$push70=, -65
	i32.and 	$push3=, $0, $pop70
	tee_local	$push137=, $2=, $pop3
	i32.or  	$push71=, $pop69, $pop137
	tee_local	$push136=, $0=, $pop71
	i32.store16	$discard=, sU($pop141):p2align=3, $pop136
	block
	i32.const	$push72=, 65472
	i32.and 	$push73=, $0, $pop72
	i32.const	$push135=, 6
	i32.shr_u	$push4=, $pop73, $pop135
	tee_local	$push134=, $0=, $pop4
	i32.xor 	$push74=, $pop134, $3
	i32.const	$push133=, 1
	i32.and 	$push75=, $pop74, $pop133
	br_if   	0, $pop75       # 0: down to label25
# BB#1:                                 # %lor.lhs.false41
	i32.const	$push229=, 16
	i32.shr_u	$push2=, $1, $pop229
	tee_local	$push228=, $3=, $pop2
	i32.add 	$push76=, $0, $pop228
	i32.add 	$push77=, $3, $4
	i32.xor 	$push78=, $pop76, $pop77
	i32.const	$push227=, 1
	i32.and 	$push79=, $pop78, $pop227
	br_if   	0, $pop79       # 0: down to label25
# BB#2:                                 # %if.end
	i32.const	$push87=, 0
	i32.const	$push80=, 1103515245
	i32.mul 	$push81=, $1, $pop80
	i32.const	$push82=, 12345
	i32.add 	$push83=, $pop81, $pop82
	tee_local	$push240=, $0=, $pop83
	i32.const	$push239=, 1103515245
	i32.mul 	$push86=, $pop240, $pop239
	i32.const	$push238=, 12345
	i32.add 	$push6=, $pop86, $pop238
	i32.store	$1=, myrnd.s($pop87), $pop6
	i32.const	$push237=, 0
	i32.const	$push236=, 16
	i32.shr_u	$push5=, $0, $pop236
	tee_local	$push235=, $4=, $pop5
	i32.const	$push84=, 2047
	i32.and 	$push85=, $pop235, $pop84
	tee_local	$push234=, $0=, $pop85
	i32.const	$push88=, 6
	i32.shl 	$push89=, $pop234, $pop88
	i32.const	$push90=, 64
	i32.and 	$push91=, $pop89, $pop90
	i32.or  	$push92=, $pop91, $2
	tee_local	$push233=, $3=, $pop92
	i32.store16	$discard=, sU($pop237):p2align=3, $pop233
	block
	i32.const	$push93=, 65472
	i32.and 	$push94=, $3, $pop93
	i32.const	$push232=, 6
	i32.shr_u	$push8=, $pop94, $pop232
	tee_local	$push231=, $3=, $pop8
	i32.xor 	$push95=, $pop231, $0
	i32.const	$push230=, 1
	i32.and 	$push96=, $pop95, $pop230
	br_if   	0, $pop96       # 0: down to label26
# BB#3:                                 # %lor.lhs.false85
	i32.const	$push245=, 16
	i32.shr_u	$push7=, $1, $pop245
	tee_local	$push244=, $0=, $pop7
	i32.add 	$push97=, $3, $pop244
	i32.const	$push243=, 1
	i32.and 	$push98=, $pop97, $pop243
	i32.const	$push99=, 15
	i32.rem_u	$push100=, $pop98, $pop99
	i32.add 	$push101=, $0, $4
	i32.const	$push242=, 1
	i32.and 	$push102=, $pop101, $pop242
	i32.const	$push241=, 15
	i32.rem_u	$push103=, $pop102, $pop241
	i32.ne  	$push104=, $pop100, $pop103
	br_if   	0, $pop104      # 0: down to label26
# BB#4:                                 # %lor.lhs.false130
	i32.const	$push113=, 0
	i32.const	$push105=, 1103515245
	i32.mul 	$push106=, $1, $pop105
	i32.const	$push107=, 12345
	i32.add 	$push108=, $pop106, $pop107
	tee_local	$push254=, $1=, $pop108
	i32.const	$push116=, 10
	i32.shr_u	$push117=, $pop254, $pop116
	i32.const	$push118=, 64
	i32.and 	$push119=, $pop117, $pop118
	i32.or  	$push120=, $pop119, $2
	i32.const	$push121=, 65472
	i32.and 	$push122=, $pop120, $pop121
	i32.const	$push123=, 6
	i32.shr_u	$push124=, $pop122, $pop123
	i32.const	$push253=, 0
	i32.const	$push252=, 1103515245
	i32.mul 	$push111=, $1, $pop252
	i32.const	$push251=, 12345
	i32.add 	$push112=, $pop111, $pop251
	i32.store	$push114=, myrnd.s($pop253), $pop112
	i32.const	$push109=, 16
	i32.shr_u	$push115=, $pop114, $pop109
	tee_local	$push250=, $0=, $pop115
	i32.add 	$push125=, $pop124, $pop250
	tee_local	$push249=, $3=, $pop125
	i32.const	$push248=, 6
	i32.shl 	$push126=, $pop249, $pop248
	i32.const	$push247=, 64
	i32.and 	$push127=, $pop126, $pop247
	i32.or  	$push128=, $pop127, $2
	i32.store16	$discard=, sU($pop113):p2align=3, $pop128
	block
	i32.const	$push246=, 16
	i32.shr_u	$push110=, $1, $pop246
	i32.add 	$push129=, $0, $pop110
	i32.xor 	$push130=, $pop129, $3
	i32.const	$push131=, 1
	i32.and 	$push132=, $pop130, $pop131
	br_if   	0, $pop132      # 0: down to label27
# BB#5:                                 # %if.end136
	return
.LBB126_6:                              # %if.then135
	end_block                       # label27:
	call    	abort@FUNCTION
	unreachable
.LBB126_7:                              # %if.then91
	end_block                       # label26:
	call    	abort@FUNCTION
	unreachable
.LBB126_8:                              # %if.then
	end_block                       # label25:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end126:
	.size	testU, .Lfunc_end126-testU

	.section	.text.retmeV,"ax",@progbits
	.hidden	retmeV
	.globl	retmeV
	.type	retmeV,@function
retmeV:                                 # @retmeV
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($1):p2align=1
	i32.store	$discard=, 0($0):p2align=1, $pop0
	return
	.endfunc
.Lfunc_end127:
	.size	retmeV, .Lfunc_end127-retmeV

	.section	.text.fn1V,"ax",@progbits
	.hidden	fn1V
	.globl	fn1V
	.type	fn1V,@function
fn1V:                                   # @fn1V
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sV($pop0)
	i32.const	$push2=, 8
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 1
	i32.and 	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end128:
	.size	fn1V, .Lfunc_end128-fn1V

	.section	.text.fn2V,"ax",@progbits
	.hidden	fn2V
	.globl	fn2V
	.type	fn2V,@function
fn2V:                                   # @fn2V
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load8_u	$push1=, sV+1($pop0)
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 1
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push5=, 15
	i32.rem_u	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end129:
	.size	fn2V, .Lfunc_end129-fn2V

	.section	.text.retitV,"ax",@progbits
	.hidden	retitV
	.globl	retitV
	.type	retitV,@function
retitV:                                 # @retitV
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load8_u	$push1=, sV+1($pop0)
	i32.const	$push2=, 1
	i32.and 	$push3=, $pop1, $pop2
	return  	$pop3
	.endfunc
.Lfunc_end130:
	.size	retitV, .Lfunc_end130-retitV

	.section	.text.fn3V,"ax",@progbits
	.hidden	fn3V
	.globl	fn3V
	.type	fn3V,@function
fn3V:                                   # @fn3V
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push16=, 0
	i32.load16_u	$push1=, sV($pop16):p2align=2
	tee_local	$push15=, $1=, $pop1
	i32.const	$push2=, 8
	i32.shr_u	$push3=, $pop15, $pop2
	i32.add 	$push4=, $pop3, $0
	tee_local	$push14=, $0=, $pop4
	i32.const	$push13=, 8
	i32.shl 	$push5=, $pop14, $pop13
	i32.const	$push6=, 256
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push8=, 65279
	i32.and 	$push9=, $1, $pop8
	i32.or  	$push10=, $pop7, $pop9
	i32.store16	$discard=, sV($pop0):p2align=2, $pop10
	i32.const	$push11=, 1
	i32.and 	$push12=, $0, $pop11
	return  	$pop12
	.endfunc
.Lfunc_end131:
	.size	fn3V, .Lfunc_end131-fn3V

	.section	.text.testV,"ax",@progbits
	.hidden	testV
	.globl	testV
	.type	testV,@function
testV:                                  # @testV
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push119=, 0
	i32.const	$push118=, 0
	i32.load	$push6=, myrnd.s($pop118)
	i32.const	$push117=, 1103515245
	i32.mul 	$push7=, $pop6, $pop117
	i32.const	$push116=, 12345
	i32.add 	$push8=, $pop7, $pop116
	tee_local	$push115=, $0=, $pop8
	i32.const	$push114=, 16
	i32.shr_u	$push9=, $pop115, $pop114
	i32.store8	$discard=, sV($pop119):p2align=2, $pop9
	i32.const	$push113=, 0
	i32.const	$push112=, 1103515245
	i32.mul 	$push10=, $0, $pop112
	i32.const	$push111=, 12345
	i32.add 	$push11=, $pop10, $pop111
	tee_local	$push110=, $0=, $pop11
	i32.const	$push109=, 16
	i32.shr_u	$push12=, $pop110, $pop109
	i32.store8	$discard=, sV+1($pop113), $pop12
	i32.const	$push108=, 0
	i32.const	$push107=, 1103515245
	i32.mul 	$push13=, $0, $pop107
	i32.const	$push106=, 12345
	i32.add 	$push14=, $pop13, $pop106
	tee_local	$push105=, $0=, $pop14
	i32.const	$push104=, 16
	i32.shr_u	$push15=, $pop105, $pop104
	i32.store8	$discard=, sV+2($pop108):p2align=1, $pop15
	i32.const	$push103=, 0
	i32.const	$push102=, 1103515245
	i32.mul 	$push16=, $0, $pop102
	i32.const	$push101=, 12345
	i32.add 	$push17=, $pop16, $pop101
	tee_local	$push100=, $0=, $pop17
	i32.const	$push99=, 16
	i32.shr_u	$push18=, $pop100, $pop99
	i32.store8	$discard=, sV+3($pop103), $pop18
	i32.const	$push98=, 0
	i32.const	$push97=, 1103515245
	i32.mul 	$push20=, $0, $pop97
	i32.const	$push96=, 12345
	i32.add 	$push21=, $pop20, $pop96
	tee_local	$push95=, $3=, $pop21
	i32.const	$push94=, 8
	i32.shr_u	$push26=, $pop95, $pop94
	i32.const	$push93=, 256
	i32.and 	$push27=, $pop26, $pop93
	i32.const	$push92=, 0
	i32.load16_u	$push19=, sV($pop92):p2align=2
	i32.const	$push91=, 65279
	i32.and 	$push28=, $pop19, $pop91
	i32.or  	$push29=, $pop27, $pop28
	i32.store16	$discard=, sV($pop98):p2align=2, $pop29
	i32.const	$push90=, 0
	i32.load	$0=, sV($pop90)
	block
	i32.const	$push89=, 0
	i32.const	$push88=, 1103515245
	i32.mul 	$push23=, $3, $pop88
	i32.const	$push87=, 12345
	i32.add 	$push0=, $pop23, $pop87
	i32.store	$push24=, myrnd.s($pop89), $pop0
	tee_local	$push86=, $2=, $pop24
	i32.const	$push85=, 16
	i32.shr_u	$push25=, $pop86, $pop85
	tee_local	$push84=, $1=, $pop25
	i32.const	$push83=, 16
	i32.shr_u	$push22=, $3, $pop83
	i32.add 	$push32=, $pop84, $pop22
	i32.const	$push82=, 8
	i32.shr_u	$push30=, $0, $pop82
	i32.add 	$push31=, $pop30, $1
	i32.xor 	$push33=, $pop32, $pop31
	i32.const	$push81=, 1
	i32.and 	$push34=, $pop33, $pop81
	br_if   	0, $pop34       # 0: down to label28
# BB#1:                                 # %if.end
	i32.const	$push135=, 0
	i32.const	$push134=, 1103515245
	i32.mul 	$push35=, $2, $pop134
	i32.const	$push133=, 12345
	i32.add 	$push36=, $pop35, $pop133
	tee_local	$push132=, $1=, $pop36
	i32.const	$push131=, 1103515245
	i32.mul 	$push39=, $pop132, $pop131
	i32.const	$push130=, 12345
	i32.add 	$push2=, $pop39, $pop130
	i32.store	$3=, myrnd.s($pop135), $pop2
	i32.const	$push129=, 0
	i32.const	$push128=, 16
	i32.shr_u	$push1=, $1, $pop128
	tee_local	$push127=, $4=, $pop1
	i32.const	$push37=, 2047
	i32.and 	$push38=, $pop127, $pop37
	tee_local	$push126=, $1=, $pop38
	i32.const	$push125=, 8
	i32.shl 	$push40=, $pop126, $pop125
	i32.const	$push124=, 256
	i32.and 	$push41=, $pop40, $pop124
	i32.const	$push42=, -257
	i32.and 	$push43=, $0, $pop42
	i32.or  	$push44=, $pop41, $pop43
	tee_local	$push123=, $2=, $pop44
	i32.store16	$discard=, sV($pop129):p2align=2, $pop123
	block
	i32.const	$push45=, 65280
	i32.and 	$push46=, $2, $pop45
	i32.const	$push122=, 8
	i32.shr_u	$push5=, $pop46, $pop122
	tee_local	$push121=, $2=, $pop5
	i32.xor 	$push47=, $pop121, $1
	i32.const	$push120=, 1
	i32.and 	$push48=, $pop47, $pop120
	br_if   	0, $pop48       # 0: down to label29
# BB#2:                                 # %lor.lhs.false89
	i32.const	$push140=, 16
	i32.shr_u	$push3=, $3, $pop140
	tee_local	$push139=, $1=, $pop3
	i32.add 	$push49=, $2, $pop139
	i32.const	$push138=, 1
	i32.and 	$push50=, $pop49, $pop138
	i32.const	$push51=, 15
	i32.rem_u	$push52=, $pop50, $pop51
	i32.add 	$push53=, $1, $4
	i32.const	$push137=, 1
	i32.and 	$push54=, $pop53, $pop137
	i32.const	$push136=, 15
	i32.rem_u	$push55=, $pop54, $pop136
	i32.ne  	$push56=, $pop52, $pop55
	br_if   	0, $pop56       # 0: down to label29
# BB#3:                                 # %lor.lhs.false136
	i32.const	$push65=, 0
	i32.const	$push57=, 1103515245
	i32.mul 	$push58=, $3, $pop57
	i32.const	$push59=, 12345
	i32.add 	$push60=, $pop58, $pop59
	tee_local	$push153=, $3=, $pop60
	i32.const	$push68=, 8
	i32.shr_u	$push69=, $pop153, $pop68
	i32.const	$push70=, 256
	i32.and 	$push71=, $pop69, $pop70
	i32.const	$push152=, 65279
	i32.and 	$push4=, $0, $pop152
	tee_local	$push151=, $0=, $pop4
	i32.or  	$push72=, $pop71, $pop151
	i32.const	$push150=, 8
	i32.shr_u	$push73=, $pop72, $pop150
	i32.const	$push149=, 0
	i32.const	$push148=, 1103515245
	i32.mul 	$push63=, $3, $pop148
	i32.const	$push147=, 12345
	i32.add 	$push64=, $pop63, $pop147
	i32.store	$push66=, myrnd.s($pop149), $pop64
	i32.const	$push61=, 16
	i32.shr_u	$push67=, $pop66, $pop61
	tee_local	$push146=, $1=, $pop67
	i32.add 	$push74=, $pop73, $pop146
	tee_local	$push145=, $2=, $pop74
	i32.const	$push144=, 8
	i32.shl 	$push75=, $pop145, $pop144
	i32.const	$push143=, 256
	i32.and 	$push76=, $pop75, $pop143
	i32.or  	$push77=, $pop76, $0
	i32.store16	$discard=, sV($pop65):p2align=2, $pop77
	block
	i32.const	$push142=, 16
	i32.shr_u	$push62=, $3, $pop142
	i32.add 	$push78=, $1, $pop62
	i32.xor 	$push79=, $pop78, $2
	i32.const	$push141=, 1
	i32.and 	$push80=, $pop79, $pop141
	br_if   	0, $pop80       # 0: down to label30
# BB#4:                                 # %if.end142
	return
.LBB132_5:                              # %if.then141
	end_block                       # label30:
	call    	abort@FUNCTION
	unreachable
.LBB132_6:                              # %if.then95
	end_block                       # label29:
	call    	abort@FUNCTION
	unreachable
.LBB132_7:                              # %if.then
	end_block                       # label28:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end132:
	.size	testV, .Lfunc_end132-testV

	.section	.text.retmeW,"ax",@progbits
	.hidden	retmeW
	.globl	retmeW
	.type	retmeW,@function
retmeW:                                 # @retmeW
	.param  	i32, i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push1=, 24
	i32.add 	$push3=, $1, $pop1
	i64.load	$2=, 0($pop3)
	i64.load	$push0=, 0($1):p2align=4
	i64.store	$discard=, 0($0):p2align=4, $pop0
	i32.const	$push13=, 24
	i32.add 	$push2=, $0, $pop13
	i64.store	$discard=, 0($pop2), $2
	i32.const	$push8=, 8
	i32.add 	$push10=, $1, $pop8
	i64.load	$2=, 0($pop10)
	i32.const	$push4=, 16
	i32.add 	$push5=, $0, $pop4
	i32.const	$push12=, 16
	i32.add 	$push6=, $1, $pop12
	i64.load	$push7=, 0($pop6):p2align=4
	i64.store	$discard=, 0($pop5):p2align=4, $pop7
	i32.const	$push11=, 8
	i32.add 	$push9=, $0, $pop11
	i64.store	$discard=, 0($pop9), $2
	return
	.endfunc
.Lfunc_end133:
	.size	retmeW, .Lfunc_end133-retmeW

	.section	.text.fn1W,"ax",@progbits
	.hidden	fn1W
	.globl	fn1W
	.type	fn1W,@function
fn1W:                                   # @fn1W
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sW+16($pop0):p2align=4
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 4095
	i32.and 	$push4=, $pop2, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end134:
	.size	fn1W, .Lfunc_end134-fn1W

	.section	.text.fn2W,"ax",@progbits
	.hidden	fn2W
	.globl	fn2W
	.type	fn2W,@function
fn2W:                                   # @fn2W
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sW+16($pop0):p2align=4
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 4095
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push5=, 15
	i32.rem_u	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end135:
	.size	fn2W, .Lfunc_end135-fn2W

	.section	.text.retitW,"ax",@progbits
	.hidden	retitW
	.globl	retitW
	.type	retitW,@function
retitW:                                 # @retitW
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sW+16($pop0):p2align=4
	i32.const	$push2=, 4095
	i32.and 	$push3=, $pop1, $pop2
	return  	$pop3
	.endfunc
.Lfunc_end136:
	.size	retitW, .Lfunc_end136-retitW

	.section	.text.fn3W,"ax",@progbits
	.hidden	fn3W
	.globl	fn3W
	.type	fn3W,@function
fn3W:                                   # @fn3W
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push1=, sW+16($pop10):p2align=4
	tee_local	$push9=, $1=, $pop1
	i32.add 	$push2=, $pop9, $0
	i32.const	$push3=, 4095
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push8=, $0=, $pop4
	i32.const	$push5=, -4096
	i32.and 	$push6=, $1, $pop5
	i32.or  	$push7=, $pop8, $pop6
	i32.store	$discard=, sW+16($pop0):p2align=4, $pop7
	return  	$0
	.endfunc
.Lfunc_end137:
	.size	fn3W, .Lfunc_end137-fn3W

	.section	.text.testW,"ax",@progbits
	.hidden	testW
	.globl	testW
	.type	testW,@function
testW:                                  # @testW
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$1=, myrnd.s($pop0)
	i32.const	$0=, -32
.LBB138_1:                              # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label31:
	i32.const	$push43=, 1103515245
	i32.mul 	$push1=, $1, $pop43
	i32.const	$push42=, 12345
	i32.add 	$1=, $pop1, $pop42
	i32.const	$push41=, 16
	i32.shr_u	$push2=, $1, $pop41
	i32.store8	$discard=, sW+32($0), $pop2
	i32.const	$push40=, 1
	i32.add 	$0=, $0, $pop40
	br_if   	0, $0           # 0: up to label31
# BB#2:                                 # %for.end
	end_loop                        # label32:
	i32.const	$push3=, 0
	i32.const	$push7=, 1103515245
	i32.mul 	$push8=, $1, $pop7
	i32.const	$push9=, 12345
	i32.add 	$push10=, $pop8, $pop9
	tee_local	$push71=, $1=, $pop10
	i32.const	$push11=, 16
	i32.shr_u	$push12=, $pop71, $pop11
	i32.const	$push13=, 2047
	i32.and 	$push14=, $pop12, $pop13
	i32.const	$push70=, 0
	i32.load	$push6=, sW+16($pop70):p2align=4
	i32.const	$push18=, -4096
	i32.and 	$push19=, $pop6, $pop18
	tee_local	$push69=, $0=, $pop19
	i32.or  	$push20=, $pop14, $pop69
	i32.store	$discard=, sW+16($pop3):p2align=4, $pop20
	i32.const	$push68=, 0
	i32.const	$push67=, 0
	i32.const	$push66=, 1103515245
	i32.mul 	$push15=, $1, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push16=, $pop15, $pop65
	i32.store	$push17=, myrnd.s($pop67), $pop16
	i32.const	$push64=, 1103515245
	i32.mul 	$push21=, $pop17, $pop64
	i32.const	$push63=, 12345
	i32.add 	$push22=, $pop21, $pop63
	tee_local	$push62=, $1=, $pop22
	i32.const	$push61=, 16
	i32.shr_u	$push23=, $pop62, $pop61
	i32.const	$push60=, 2047
	i32.and 	$push24=, $pop23, $pop60
	i32.or  	$push28=, $pop24, $0
	i32.store	$discard=, sW+16($pop68):p2align=4, $pop28
	i32.const	$push59=, 0
	i32.const	$push58=, 0
	i32.const	$push57=, 0
	i32.const	$push56=, 1103515245
	i32.mul 	$push25=, $1, $pop56
	i32.const	$push55=, 12345
	i32.add 	$push26=, $pop25, $pop55
	i32.store	$push27=, myrnd.s($pop57), $pop26
	i32.const	$push54=, 1103515245
	i32.mul 	$push29=, $pop27, $pop54
	i32.const	$push53=, 12345
	i32.add 	$push30=, $pop29, $pop53
	tee_local	$push52=, $1=, $pop30
	i32.const	$push51=, 1103515245
	i32.mul 	$push33=, $pop52, $pop51
	i32.const	$push50=, 12345
	i32.add 	$push34=, $pop33, $pop50
	i32.store	$push35=, myrnd.s($pop58), $pop34
	i32.const	$push49=, 16
	i32.shr_u	$push36=, $pop35, $pop49
	i32.const	$push48=, 2047
	i32.and 	$push37=, $pop36, $pop48
	i32.const	$push47=, 16
	i32.shr_u	$push31=, $1, $pop47
	i32.const	$push46=, 2047
	i32.and 	$push32=, $pop31, $pop46
	i32.add 	$push38=, $pop37, $pop32
	i32.or  	$push39=, $pop38, $0
	i32.store	$discard=, sW+16($pop59):p2align=4, $pop39
	i32.const	$push45=, 0
	i64.const	$push4=, 4612055454334320640
	i64.store	$discard=, sW+8($pop45), $pop4
	i32.const	$push44=, 0
	i64.const	$push5=, 0
	i64.store	$discard=, sW($pop44):p2align=4, $pop5
	return
	.endfunc
.Lfunc_end138:
	.size	testW, .Lfunc_end138-testW

	.section	.text.retmeX,"ax",@progbits
	.hidden	retmeX
	.globl	retmeX
	.type	retmeX,@function
retmeX:                                 # @retmeX
	.param  	i32, i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push1=, 24
	i32.add 	$push3=, $1, $pop1
	i64.load	$2=, 0($pop3)
	i64.load	$push0=, 0($1):p2align=4
	i64.store	$discard=, 0($0):p2align=4, $pop0
	i32.const	$push13=, 24
	i32.add 	$push2=, $0, $pop13
	i64.store	$discard=, 0($pop2), $2
	i32.const	$push8=, 8
	i32.add 	$push10=, $1, $pop8
	i64.load	$2=, 0($pop10)
	i32.const	$push4=, 16
	i32.add 	$push5=, $0, $pop4
	i32.const	$push12=, 16
	i32.add 	$push6=, $1, $pop12
	i64.load	$push7=, 0($pop6):p2align=4
	i64.store	$discard=, 0($pop5):p2align=4, $pop7
	i32.const	$push11=, 8
	i32.add 	$push9=, $0, $pop11
	i64.store	$discard=, 0($pop9), $2
	return
	.endfunc
.Lfunc_end139:
	.size	retmeX, .Lfunc_end139-retmeX

	.section	.text.fn1X,"ax",@progbits
	.hidden	fn1X
	.globl	fn1X
	.type	fn1X,@function
fn1X:                                   # @fn1X
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sX($pop0):p2align=4
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 4095
	i32.and 	$push4=, $pop2, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end140:
	.size	fn1X, .Lfunc_end140-fn1X

	.section	.text.fn2X,"ax",@progbits
	.hidden	fn2X
	.globl	fn2X
	.type	fn2X,@function
fn2X:                                   # @fn2X
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sX($pop0):p2align=4
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 4095
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push5=, 15
	i32.rem_u	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end141:
	.size	fn2X, .Lfunc_end141-fn2X

	.section	.text.retitX,"ax",@progbits
	.hidden	retitX
	.globl	retitX
	.type	retitX,@function
retitX:                                 # @retitX
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sX($pop0):p2align=4
	i32.const	$push2=, 4095
	i32.and 	$push3=, $pop1, $pop2
	return  	$pop3
	.endfunc
.Lfunc_end142:
	.size	retitX, .Lfunc_end142-retitX

	.section	.text.fn3X,"ax",@progbits
	.hidden	fn3X
	.globl	fn3X
	.type	fn3X,@function
fn3X:                                   # @fn3X
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push1=, sX($pop10):p2align=4
	tee_local	$push9=, $1=, $pop1
	i32.add 	$push2=, $pop9, $0
	i32.const	$push3=, 4095
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push8=, $0=, $pop4
	i32.const	$push5=, -4096
	i32.and 	$push6=, $1, $pop5
	i32.or  	$push7=, $pop8, $pop6
	i32.store	$discard=, sX($pop0):p2align=4, $pop7
	return  	$0
	.endfunc
.Lfunc_end143:
	.size	fn3X, .Lfunc_end143-fn3X

	.section	.text.testX,"ax",@progbits
	.hidden	testX
	.globl	testX
	.type	testX,@function
testX:                                  # @testX
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$1=, myrnd.s($pop0)
	i32.const	$0=, -32
.LBB144_1:                              # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label33:
	i32.const	$push43=, 1103515245
	i32.mul 	$push1=, $1, $pop43
	i32.const	$push42=, 12345
	i32.add 	$1=, $pop1, $pop42
	i32.const	$push41=, 16
	i32.shr_u	$push2=, $1, $pop41
	i32.store8	$discard=, sX+32($0), $pop2
	i32.const	$push40=, 1
	i32.add 	$0=, $0, $pop40
	br_if   	0, $0           # 0: up to label33
# BB#2:                                 # %for.end
	end_loop                        # label34:
	i32.const	$push3=, 0
	i32.const	$push7=, 1103515245
	i32.mul 	$push8=, $1, $pop7
	i32.const	$push9=, 12345
	i32.add 	$push10=, $pop8, $pop9
	tee_local	$push71=, $1=, $pop10
	i32.const	$push11=, 16
	i32.shr_u	$push12=, $pop71, $pop11
	i32.const	$push13=, 2047
	i32.and 	$push14=, $pop12, $pop13
	i32.const	$push70=, 0
	i32.load	$push6=, sX($pop70):p2align=4
	i32.const	$push18=, -4096
	i32.and 	$push19=, $pop6, $pop18
	tee_local	$push69=, $0=, $pop19
	i32.or  	$push20=, $pop14, $pop69
	i32.store	$discard=, sX($pop3):p2align=4, $pop20
	i32.const	$push68=, 0
	i32.const	$push67=, 0
	i32.const	$push66=, 1103515245
	i32.mul 	$push15=, $1, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push16=, $pop15, $pop65
	i32.store	$push17=, myrnd.s($pop67), $pop16
	i32.const	$push64=, 1103515245
	i32.mul 	$push21=, $pop17, $pop64
	i32.const	$push63=, 12345
	i32.add 	$push22=, $pop21, $pop63
	tee_local	$push62=, $1=, $pop22
	i32.const	$push61=, 16
	i32.shr_u	$push23=, $pop62, $pop61
	i32.const	$push60=, 2047
	i32.and 	$push24=, $pop23, $pop60
	i32.or  	$push28=, $pop24, $0
	i32.store	$discard=, sX($pop68):p2align=4, $pop28
	i32.const	$push59=, 0
	i32.const	$push58=, 0
	i32.const	$push57=, 0
	i32.const	$push56=, 1103515245
	i32.mul 	$push25=, $1, $pop56
	i32.const	$push55=, 12345
	i32.add 	$push26=, $pop25, $pop55
	i32.store	$push27=, myrnd.s($pop57), $pop26
	i32.const	$push54=, 1103515245
	i32.mul 	$push29=, $pop27, $pop54
	i32.const	$push53=, 12345
	i32.add 	$push30=, $pop29, $pop53
	tee_local	$push52=, $1=, $pop30
	i32.const	$push51=, 1103515245
	i32.mul 	$push33=, $pop52, $pop51
	i32.const	$push50=, 12345
	i32.add 	$push34=, $pop33, $pop50
	i32.store	$push35=, myrnd.s($pop58), $pop34
	i32.const	$push49=, 16
	i32.shr_u	$push36=, $pop35, $pop49
	i32.const	$push48=, 2047
	i32.and 	$push37=, $pop36, $pop48
	i32.const	$push47=, 16
	i32.shr_u	$push31=, $1, $pop47
	i32.const	$push46=, 2047
	i32.and 	$push32=, $pop31, $pop46
	i32.add 	$push38=, $pop37, $pop32
	i32.or  	$push39=, $pop38, $0
	i32.store	$discard=, sX($pop59):p2align=4, $pop39
	i32.const	$push45=, 0
	i64.const	$push4=, 4612055454334320640
	i64.store	$discard=, sX+24($pop45), $pop4
	i32.const	$push44=, 0
	i64.const	$push5=, 0
	i64.store	$discard=, sX+16($pop44):p2align=4, $pop5
	return
	.endfunc
.Lfunc_end144:
	.size	testX, .Lfunc_end144-testX

	.section	.text.retmeY,"ax",@progbits
	.hidden	retmeY
	.globl	retmeY
	.type	retmeY,@function
retmeY:                                 # @retmeY
	.param  	i32, i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push1=, 24
	i32.add 	$push3=, $1, $pop1
	i64.load	$2=, 0($pop3)
	i64.load	$push0=, 0($1):p2align=4
	i64.store	$discard=, 0($0):p2align=4, $pop0
	i32.const	$push13=, 24
	i32.add 	$push2=, $0, $pop13
	i64.store	$discard=, 0($pop2), $2
	i32.const	$push8=, 8
	i32.add 	$push10=, $1, $pop8
	i64.load	$2=, 0($pop10)
	i32.const	$push4=, 16
	i32.add 	$push5=, $0, $pop4
	i32.const	$push12=, 16
	i32.add 	$push6=, $1, $pop12
	i64.load	$push7=, 0($pop6):p2align=4
	i64.store	$discard=, 0($pop5):p2align=4, $pop7
	i32.const	$push11=, 8
	i32.add 	$push9=, $0, $pop11
	i64.store	$discard=, 0($pop9), $2
	return
	.endfunc
.Lfunc_end145:
	.size	retmeY, .Lfunc_end145-retmeY

	.section	.text.fn1Y,"ax",@progbits
	.hidden	fn1Y
	.globl	fn1Y
	.type	fn1Y,@function
fn1Y:                                   # @fn1Y
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sY($pop0):p2align=4
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 4095
	i32.and 	$push4=, $pop2, $pop3
	return  	$pop4
	.endfunc
.Lfunc_end146:
	.size	fn1Y, .Lfunc_end146-fn1Y

	.section	.text.fn2Y,"ax",@progbits
	.hidden	fn2Y
	.globl	fn2Y
	.type	fn2Y,@function
fn2Y:                                   # @fn2Y
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sY($pop0):p2align=4
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 4095
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push5=, 15
	i32.rem_u	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end147:
	.size	fn2Y, .Lfunc_end147-fn2Y

	.section	.text.retitY,"ax",@progbits
	.hidden	retitY
	.globl	retitY
	.type	retitY,@function
retitY:                                 # @retitY
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sY($pop0):p2align=4
	i32.const	$push2=, 4095
	i32.and 	$push3=, $pop1, $pop2
	return  	$pop3
	.endfunc
.Lfunc_end148:
	.size	retitY, .Lfunc_end148-retitY

	.section	.text.fn3Y,"ax",@progbits
	.hidden	fn3Y
	.globl	fn3Y
	.type	fn3Y,@function
fn3Y:                                   # @fn3Y
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push1=, sY($pop10):p2align=4
	tee_local	$push9=, $1=, $pop1
	i32.add 	$push2=, $pop9, $0
	i32.const	$push3=, 4095
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push8=, $0=, $pop4
	i32.const	$push5=, -4096
	i32.and 	$push6=, $1, $pop5
	i32.or  	$push7=, $pop8, $pop6
	i32.store	$discard=, sY($pop0):p2align=4, $pop7
	return  	$0
	.endfunc
.Lfunc_end149:
	.size	fn3Y, .Lfunc_end149-fn3Y

	.section	.text.testY,"ax",@progbits
	.hidden	testY
	.globl	testY
	.type	testY,@function
testY:                                  # @testY
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$1=, myrnd.s($pop0)
	i32.const	$0=, -32
.LBB150_1:                              # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label35:
	i32.const	$push43=, 1103515245
	i32.mul 	$push1=, $1, $pop43
	i32.const	$push42=, 12345
	i32.add 	$1=, $pop1, $pop42
	i32.const	$push41=, 16
	i32.shr_u	$push2=, $1, $pop41
	i32.store8	$discard=, sY+32($0), $pop2
	i32.const	$push40=, 1
	i32.add 	$0=, $0, $pop40
	br_if   	0, $0           # 0: up to label35
# BB#2:                                 # %for.end
	end_loop                        # label36:
	i32.const	$push3=, 0
	i32.const	$push7=, 1103515245
	i32.mul 	$push8=, $1, $pop7
	i32.const	$push9=, 12345
	i32.add 	$push10=, $pop8, $pop9
	tee_local	$push71=, $1=, $pop10
	i32.const	$push11=, 16
	i32.shr_u	$push12=, $pop71, $pop11
	i32.const	$push13=, 2047
	i32.and 	$push14=, $pop12, $pop13
	i32.const	$push70=, 0
	i32.load	$push6=, sY($pop70):p2align=4
	i32.const	$push18=, -4096
	i32.and 	$push19=, $pop6, $pop18
	tee_local	$push69=, $0=, $pop19
	i32.or  	$push20=, $pop14, $pop69
	i32.store	$discard=, sY($pop3):p2align=4, $pop20
	i32.const	$push68=, 0
	i32.const	$push67=, 0
	i32.const	$push66=, 1103515245
	i32.mul 	$push15=, $1, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push16=, $pop15, $pop65
	i32.store	$push17=, myrnd.s($pop67), $pop16
	i32.const	$push64=, 1103515245
	i32.mul 	$push21=, $pop17, $pop64
	i32.const	$push63=, 12345
	i32.add 	$push22=, $pop21, $pop63
	tee_local	$push62=, $1=, $pop22
	i32.const	$push61=, 16
	i32.shr_u	$push23=, $pop62, $pop61
	i32.const	$push60=, 2047
	i32.and 	$push24=, $pop23, $pop60
	i32.or  	$push28=, $pop24, $0
	i32.store	$discard=, sY($pop68):p2align=4, $pop28
	i32.const	$push59=, 0
	i32.const	$push58=, 0
	i32.const	$push57=, 0
	i32.const	$push56=, 1103515245
	i32.mul 	$push25=, $1, $pop56
	i32.const	$push55=, 12345
	i32.add 	$push26=, $pop25, $pop55
	i32.store	$push27=, myrnd.s($pop57), $pop26
	i32.const	$push54=, 1103515245
	i32.mul 	$push29=, $pop27, $pop54
	i32.const	$push53=, 12345
	i32.add 	$push30=, $pop29, $pop53
	tee_local	$push52=, $1=, $pop30
	i32.const	$push51=, 1103515245
	i32.mul 	$push33=, $pop52, $pop51
	i32.const	$push50=, 12345
	i32.add 	$push34=, $pop33, $pop50
	i32.store	$push35=, myrnd.s($pop58), $pop34
	i32.const	$push49=, 16
	i32.shr_u	$push36=, $pop35, $pop49
	i32.const	$push48=, 2047
	i32.and 	$push37=, $pop36, $pop48
	i32.const	$push47=, 16
	i32.shr_u	$push31=, $1, $pop47
	i32.const	$push46=, 2047
	i32.and 	$push32=, $pop31, $pop46
	i32.add 	$push38=, $pop37, $pop32
	i32.or  	$push39=, $pop38, $0
	i32.store	$discard=, sY($pop59):p2align=4, $pop39
	i32.const	$push45=, 0
	i64.const	$push4=, 4612055454334320640
	i64.store	$discard=, sY+24($pop45), $pop4
	i32.const	$push44=, 0
	i64.const	$push5=, 0
	i64.store	$discard=, sY+16($pop44):p2align=4, $pop5
	return
	.endfunc
.Lfunc_end150:
	.size	testY, .Lfunc_end150-testY

	.section	.text.retmeZ,"ax",@progbits
	.hidden	retmeZ
	.globl	retmeZ
	.type	retmeZ,@function
retmeZ:                                 # @retmeZ
	.param  	i32, i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push1=, 24
	i32.add 	$push3=, $1, $pop1
	i64.load	$2=, 0($pop3)
	i64.load	$push0=, 0($1):p2align=4
	i64.store	$discard=, 0($0):p2align=4, $pop0
	i32.const	$push13=, 24
	i32.add 	$push2=, $0, $pop13
	i64.store	$discard=, 0($pop2), $2
	i32.const	$push8=, 8
	i32.add 	$push10=, $1, $pop8
	i64.load	$2=, 0($pop10)
	i32.const	$push4=, 16
	i32.add 	$push5=, $0, $pop4
	i32.const	$push12=, 16
	i32.add 	$push6=, $1, $pop12
	i64.load	$push7=, 0($pop6):p2align=4
	i64.store	$discard=, 0($pop5):p2align=4, $pop7
	i32.const	$push11=, 8
	i32.add 	$push9=, $0, $pop11
	i64.store	$discard=, 0($pop9), $2
	return
	.endfunc
.Lfunc_end151:
	.size	retmeZ, .Lfunc_end151-retmeZ

	.section	.text.fn1Z,"ax",@progbits
	.hidden	fn1Z
	.globl	fn1Z
	.type	fn1Z,@function
fn1Z:                                   # @fn1Z
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sZ+16($pop0):p2align=4
	i32.const	$push2=, 20
	i32.shl 	$push3=, $0, $pop2
	i32.add 	$push4=, $pop1, $pop3
	i32.const	$push6=, 20
	i32.shr_u	$push5=, $pop4, $pop6
	return  	$pop5
	.endfunc
.Lfunc_end152:
	.size	fn1Z, .Lfunc_end152-fn1Z

	.section	.text.fn2Z,"ax",@progbits
	.hidden	fn2Z
	.globl	fn2Z
	.type	fn2Z,@function
fn2Z:                                   # @fn2Z
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sZ+16($pop0):p2align=4
	i32.const	$push2=, 20
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 4095
	i32.and 	$push6=, $pop4, $pop5
	i32.const	$push7=, 15
	i32.rem_u	$push8=, $pop6, $pop7
	return  	$pop8
	.endfunc
.Lfunc_end153:
	.size	fn2Z, .Lfunc_end153-fn2Z

	.section	.text.retitZ,"ax",@progbits
	.hidden	retitZ
	.globl	retitZ
	.type	retitZ,@function
retitZ:                                 # @retitZ
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, sZ+16($pop0):p2align=4
	i32.const	$push2=, 20
	i32.shr_u	$push3=, $pop1, $pop2
	return  	$pop3
	.endfunc
.Lfunc_end154:
	.size	retitZ, .Lfunc_end154-retitZ

	.section	.text.fn3Z,"ax",@progbits
	.hidden	fn3Z
	.globl	fn3Z
	.type	fn3Z,@function
fn3Z:                                   # @fn3Z
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push8=, 0
	i32.load	$push1=, sZ+16($pop8):p2align=4
	i32.const	$push2=, 20
	i32.shl 	$push3=, $0, $pop2
	i32.add 	$push4=, $pop1, $pop3
	i32.store	$push5=, sZ+16($pop0):p2align=4, $pop4
	i32.const	$push7=, 20
	i32.shr_u	$push6=, $pop5, $pop7
	return  	$pop6
	.endfunc
.Lfunc_end155:
	.size	fn3Z, .Lfunc_end155-fn3Z

	.section	.text.testZ,"ax",@progbits
	.hidden	testZ
	.globl	testZ
	.type	testZ,@function
testZ:                                  # @testZ
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.load	$2=, myrnd.s($pop5)
	i32.const	$1=, -32
.LBB156_1:                              # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label37:
	i32.const	$push57=, 1103515245
	i32.mul 	$push6=, $2, $pop57
	i32.const	$push56=, 12345
	i32.add 	$2=, $pop6, $pop56
	i32.const	$push55=, 16
	i32.shr_u	$push7=, $2, $pop55
	i32.store8	$discard=, sZ+32($1), $pop7
	i32.const	$push54=, 1
	i32.add 	$1=, $1, $pop54
	br_if   	0, $1           # 0: up to label37
# BB#2:                                 # %for.end
	end_loop                        # label38:
	i32.const	$push77=, 0
	i32.load	$0=, sZ+16($pop77):p2align=4
	i32.const	$push76=, 0
	i32.const	$push75=, 1103515245
	i32.mul 	$push10=, $2, $pop75
	i32.const	$push74=, 12345
	i32.add 	$push11=, $pop10, $pop74
	tee_local	$push73=, $2=, $pop11
	i32.const	$push72=, 1103515245
	i32.mul 	$push14=, $pop73, $pop72
	i32.const	$push71=, 12345
	i32.add 	$push0=, $pop14, $pop71
	i32.store	$1=, myrnd.s($pop76), $pop0
	i32.const	$push70=, 0
	i32.const	$push69=, 16
	i32.shr_u	$push12=, $2, $pop69
	i32.const	$push68=, 2047
	i32.and 	$push13=, $pop12, $pop68
	tee_local	$push67=, $4=, $pop13
	i32.const	$push66=, 20
	i32.shl 	$push17=, $pop67, $pop66
	i32.const	$push18=, 1048575
	i32.and 	$push19=, $0, $pop18
	tee_local	$push65=, $2=, $pop19
	i32.or  	$push20=, $pop17, $pop65
	i32.store	$0=, sZ+16($pop70):p2align=4, $pop20
	i32.const	$push64=, 0
	i64.const	$push8=, 4612055454334320640
	i64.store	$discard=, sZ+8($pop64), $pop8
	i32.const	$push63=, 0
	i64.const	$push9=, 0
	i64.store	$discard=, sZ($pop63):p2align=4, $pop9
	block
	i32.const	$push62=, 16
	i32.shr_u	$push15=, $1, $pop62
	i32.const	$push61=, 2047
	i32.and 	$push16=, $pop15, $pop61
	tee_local	$push60=, $3=, $pop16
	i32.add 	$push24=, $pop60, $4
	i32.const	$push59=, 20
	i32.shl 	$push21=, $3, $pop59
	i32.add 	$push22=, $0, $pop21
	i32.const	$push58=, 20
	i32.shr_u	$push23=, $pop22, $pop58
	i32.ne  	$push25=, $pop24, $pop23
	br_if   	0, $pop25       # 0: down to label39
# BB#3:                                 # %if.end80
	block
	i32.const	$push95=, 0
	i32.const	$push94=, 0
	i32.const	$push93=, 1103515245
	i32.mul 	$push26=, $1, $pop93
	i32.const	$push92=, 12345
	i32.add 	$push27=, $pop26, $pop92
	tee_local	$push91=, $1=, $pop27
	i32.const	$push33=, -1029531031
	i32.mul 	$push34=, $pop91, $pop33
	i32.const	$push35=, -740551042
	i32.add 	$push36=, $pop34, $pop35
	tee_local	$push90=, $0=, $pop36
	i32.const	$push89=, 1103515245
	i32.mul 	$push38=, $pop90, $pop89
	i32.const	$push88=, 12345
	i32.add 	$push39=, $pop38, $pop88
	i32.store	$push40=, myrnd.s($pop94), $pop39
	i32.const	$push87=, 16
	i32.shr_u	$push41=, $pop40, $pop87
	i32.const	$push86=, 2047
	i32.and 	$push2=, $pop41, $pop86
	tee_local	$push85=, $4=, $pop2
	i32.const	$push84=, 20
	i32.shl 	$push44=, $pop85, $pop84
	i32.const	$push83=, 16
	i32.shr_u	$push37=, $0, $pop83
	i32.const	$push82=, 2047
	i32.and 	$push1=, $pop37, $pop82
	tee_local	$push81=, $0=, $pop1
	i32.const	$push80=, 20
	i32.shl 	$push42=, $pop81, $pop80
	i32.or  	$push43=, $pop42, $2
	i32.add 	$push3=, $pop44, $pop43
	i32.store	$push45=, sZ+16($pop95):p2align=4, $pop3
	tee_local	$push79=, $3=, $pop45
	i32.const	$push28=, 4
	i32.shl 	$push29=, $1, $pop28
	i32.const	$push30=, 2146435072
	i32.and 	$push31=, $pop29, $pop30
	i32.or  	$push32=, $pop31, $2
	i32.xor 	$push4=, $pop79, $pop32
	tee_local	$push78=, $1=, $pop4
	i32.const	$push46=, 1040384
	i32.and 	$push47=, $pop78, $pop46
	br_if   	0, $pop47       # 0: down to label40
# BB#4:                                 # %lor.lhs.false98
	i32.add 	$push52=, $4, $0
	i32.const	$push49=, 20
	i32.shr_u	$push50=, $3, $pop49
	i32.ne  	$push53=, $pop52, $pop50
	br_if   	0, $pop53       # 0: down to label40
# BB#5:                                 # %lor.lhs.false98
	i32.const	$push51=, 8191
	i32.and 	$push48=, $1, $pop51
	br_if   	0, $pop48       # 0: down to label40
# BB#6:                                 # %if.end121
	return
.LBB156_7:                              # %if.then120
	end_block                       # label40:
	call    	abort@FUNCTION
	unreachable
.LBB156_8:                              # %if.then
	end_block                       # label39:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end156:
	.size	testZ, .Lfunc_end156-testZ

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	call    	testA@FUNCTION
	call    	testB@FUNCTION
	call    	testC@FUNCTION
	call    	testD@FUNCTION
	call    	testE@FUNCTION
	call    	testF@FUNCTION
	call    	testG@FUNCTION
	call    	testH@FUNCTION
	call    	testI@FUNCTION
	call    	testJ@FUNCTION
	call    	testK@FUNCTION
	call    	testL@FUNCTION
	call    	testM@FUNCTION
	call    	testN@FUNCTION
	call    	testO@FUNCTION
	call    	testP@FUNCTION
	call    	testQ@FUNCTION
	call    	testR@FUNCTION
	call    	testS@FUNCTION
	call    	testT@FUNCTION
	call    	testU@FUNCTION
	call    	testV@FUNCTION
	call    	testW@FUNCTION
	call    	testX@FUNCTION
	call    	testY@FUNCTION
	call    	testZ@FUNCTION
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end157:
	.size	main, .Lfunc_end157-main

	.type	myrnd.s,@object         # @myrnd.s
	.section	.data.myrnd.s,"aw",@progbits
	.p2align	2
myrnd.s:
	.int32	1388815473              # 0x52c7a471
	.size	myrnd.s, 4

	.hidden	sA                      # @sA
	.type	sA,@object
	.section	.bss.sA,"aw",@nobits
	.globl	sA
	.p2align	2
sA:
	.skip	4
	.size	sA, 4

	.hidden	sB                      # @sB
	.type	sB,@object
	.section	.bss.sB,"aw",@nobits
	.globl	sB
	.p2align	3
sB:
	.skip	8
	.size	sB, 8

	.hidden	sC                      # @sC
	.type	sC,@object
	.section	.bss.sC,"aw",@nobits
	.globl	sC
	.p2align	3
sC:
	.skip	8
	.size	sC, 8

	.hidden	sD                      # @sD
	.type	sD,@object
	.section	.bss.sD,"aw",@nobits
	.globl	sD
	.p2align	3
sD:
	.skip	8
	.size	sD, 8

	.hidden	sE                      # @sE
	.type	sE,@object
	.section	.bss.sE,"aw",@nobits
	.globl	sE
	.p2align	3
sE:
	.skip	16
	.size	sE, 16

	.hidden	sF                      # @sF
	.type	sF,@object
	.section	.bss.sF,"aw",@nobits
	.globl	sF
	.p2align	3
sF:
	.skip	16
	.size	sF, 16

	.hidden	sG                      # @sG
	.type	sG,@object
	.section	.bss.sG,"aw",@nobits
	.globl	sG
	.p2align	3
sG:
	.skip	16
	.size	sG, 16

	.hidden	sH                      # @sH
	.type	sH,@object
	.section	.bss.sH,"aw",@nobits
	.globl	sH
	.p2align	3
sH:
	.skip	16
	.size	sH, 16

	.hidden	sI                      # @sI
	.type	sI,@object
	.section	.bss.sI,"aw",@nobits
	.globl	sI
	.p2align	3
sI:
	.skip	16
	.size	sI, 16

	.hidden	sJ                      # @sJ
	.type	sJ,@object
	.section	.bss.sJ,"aw",@nobits
	.globl	sJ
	.p2align	2
sJ:
	.skip	4
	.size	sJ, 4

	.hidden	sK                      # @sK
	.type	sK,@object
	.section	.bss.sK,"aw",@nobits
	.globl	sK
	.p2align	2
sK:
	.skip	4
	.size	sK, 4

	.hidden	sL                      # @sL
	.type	sL,@object
	.section	.bss.sL,"aw",@nobits
	.globl	sL
	.p2align	3
sL:
	.skip	8
	.size	sL, 8

	.hidden	sM                      # @sM
	.type	sM,@object
	.section	.bss.sM,"aw",@nobits
	.globl	sM
	.p2align	3
sM:
	.skip	8
	.size	sM, 8

	.hidden	sN                      # @sN
	.type	sN,@object
	.section	.bss.sN,"aw",@nobits
	.globl	sN
	.p2align	3
sN:
	.skip	8
	.size	sN, 8

	.hidden	sO                      # @sO
	.type	sO,@object
	.section	.bss.sO,"aw",@nobits
	.globl	sO
	.p2align	3
sO:
	.skip	16
	.size	sO, 16

	.hidden	sP                      # @sP
	.type	sP,@object
	.section	.bss.sP,"aw",@nobits
	.globl	sP
	.p2align	3
sP:
	.skip	16
	.size	sP, 16

	.hidden	sQ                      # @sQ
	.type	sQ,@object
	.section	.bss.sQ,"aw",@nobits
	.globl	sQ
	.p2align	3
sQ:
	.skip	16
	.size	sQ, 16

	.hidden	sR                      # @sR
	.type	sR,@object
	.section	.bss.sR,"aw",@nobits
	.globl	sR
	.p2align	3
sR:
	.skip	16
	.size	sR, 16

	.hidden	sS                      # @sS
	.type	sS,@object
	.section	.bss.sS,"aw",@nobits
	.globl	sS
	.p2align	3
sS:
	.skip	16
	.size	sS, 16

	.hidden	sT                      # @sT
	.type	sT,@object
	.section	.bss.sT,"aw",@nobits
	.globl	sT
	.p2align	2
sT:
	.skip	4
	.size	sT, 4

	.hidden	sU                      # @sU
	.type	sU,@object
	.section	.bss.sU,"aw",@nobits
	.globl	sU
	.p2align	3
sU:
	.skip	16
	.size	sU, 16

	.hidden	sV                      # @sV
	.type	sV,@object
	.section	.bss.sV,"aw",@nobits
	.globl	sV
	.p2align	2
sV:
	.skip	4
	.size	sV, 4

	.hidden	sW                      # @sW
	.type	sW,@object
	.section	.bss.sW,"aw",@nobits
	.globl	sW
	.p2align	4
sW:
	.skip	32
	.size	sW, 32

	.hidden	sX                      # @sX
	.type	sX,@object
	.section	.bss.sX,"aw",@nobits
	.globl	sX
	.p2align	4
sX:
	.skip	32
	.size	sX, 32

	.hidden	sY                      # @sY
	.type	sY,@object
	.section	.bss.sY,"aw",@nobits
	.globl	sY
	.p2align	4
sY:
	.skip	32
	.size	sY, 32

	.hidden	sZ                      # @sZ
	.type	sZ,@object
	.section	.bss.sZ,"aw",@nobits
	.globl	sZ
	.p2align	4
sZ:
	.skip	32
	.size	sZ, 32


	.ident	"clang version 3.9.0 "
