	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040709-1.c"
	.section	.text.myrnd,"ax",@progbits
	.hidden	myrnd
	.globl	myrnd
	.type	myrnd,@function
myrnd:                                  # @myrnd
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push11=, 0
	i32.load	$push1=, myrnd.s($pop11)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push10=, $pop3, $pop4
	tee_local	$push9=, $0=, $pop10
	i32.store	$discard=, myrnd.s($pop0), $pop9
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $0, $pop5
	i32.const	$push7=, 2047
	i32.and 	$push8=, $pop6, $pop7
	return  	$pop8
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
	i32.add 	$push7=, $pop1, $pop3
	tee_local	$push6=, $0=, $pop7
	i32.store	$discard=, sA($pop0), $pop6
	i32.const	$push5=, 17
	i32.shr_u	$push4=, $0, $pop5
	return  	$pop4
	.endfunc
.Lfunc_end5:
	.size	fn3A, .Lfunc_end5-fn3A

	.section	.text.testA,"ax",@progbits
	.hidden	testA
	.globl	testA
	.type	testA,@function
testA:                                  # @testA
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push89=, 0
	i32.const	$push88=, 0
	i32.load	$push2=, myrnd.s($pop88)
	i32.const	$push87=, 1103515245
	i32.mul 	$push3=, $pop2, $pop87
	i32.const	$push86=, 12345
	i32.add 	$push85=, $pop3, $pop86
	tee_local	$push84=, $5=, $pop85
	i32.const	$push83=, 16
	i32.shr_u	$push4=, $pop84, $pop83
	i32.store8	$discard=, sA($pop89), $pop4
	i32.const	$push82=, 0
	i32.const	$push81=, 1103515245
	i32.mul 	$push5=, $5, $pop81
	i32.const	$push80=, 12345
	i32.add 	$push79=, $pop5, $pop80
	tee_local	$push78=, $5=, $pop79
	i32.const	$push77=, 16
	i32.shr_u	$push6=, $pop78, $pop77
	i32.store8	$discard=, sA+1($pop82), $pop6
	i32.const	$push76=, 0
	i32.const	$push75=, 1103515245
	i32.mul 	$push7=, $5, $pop75
	i32.const	$push74=, 12345
	i32.add 	$push73=, $pop7, $pop74
	tee_local	$push72=, $5=, $pop73
	i32.const	$push71=, 16
	i32.shr_u	$push8=, $pop72, $pop71
	i32.store8	$discard=, sA+2($pop76), $pop8
	i32.const	$push70=, 0
	i32.const	$push69=, 1103515245
	i32.mul 	$push9=, $5, $pop69
	i32.const	$push68=, 12345
	i32.add 	$push67=, $pop9, $pop68
	tee_local	$push66=, $5=, $pop67
	i32.const	$push65=, 16
	i32.shr_u	$push10=, $pop66, $pop65
	i32.store8	$discard=, sA+3($pop70), $pop10
	i32.const	$push64=, 0
	i32.const	$push63=, 1103515245
	i32.mul 	$push11=, $5, $pop63
	i32.const	$push62=, 12345
	i32.add 	$push61=, $pop11, $pop62
	tee_local	$push60=, $5=, $pop61
	i32.const	$push59=, 16
	i32.shr_u	$push12=, $pop60, $pop59
	i32.const	$push58=, 2047
	i32.and 	$push57=, $pop12, $pop58
	tee_local	$push56=, $4=, $pop57
	i32.const	$push55=, 17
	i32.shl 	$push15=, $pop56, $pop55
	i32.const	$push54=, 0
	i32.load	$push53=, sA($pop54)
	tee_local	$push52=, $3=, $pop53
	i32.const	$push51=, 131071
	i32.and 	$push50=, $pop52, $pop51
	tee_local	$push49=, $2=, $pop50
	i32.or  	$push16=, $pop15, $pop49
	i32.store	$1=, sA($pop64), $pop16
	i32.const	$push48=, 0
	i32.const	$push47=, 1103515245
	i32.mul 	$push13=, $5, $pop47
	i32.const	$push46=, 12345
	i32.add 	$push45=, $pop13, $pop46
	tee_local	$push44=, $5=, $pop45
	i32.store	$0=, myrnd.s($pop48), $pop44
	block
	i32.const	$push43=, 16
	i32.shr_u	$push14=, $5, $pop43
	i32.const	$push42=, 2047
	i32.and 	$push41=, $pop14, $pop42
	tee_local	$push40=, $5=, $pop41
	i32.add 	$push20=, $pop40, $4
	i32.const	$push39=, 17
	i32.shl 	$push17=, $5, $pop39
	i32.add 	$push18=, $1, $pop17
	i32.const	$push38=, 17
	i32.shr_u	$push19=, $pop18, $pop38
	i32.ne  	$push21=, $pop20, $pop19
	br_if   	0, $pop21       # 0: down to label0
# BB#1:                                 # %if.end87
	i32.const	$push108=, 0
	i32.const	$push107=, 0
	i32.const	$push22=, -2139243339
	i32.mul 	$push23=, $0, $pop22
	i32.const	$push24=, -1492899873
	i32.add 	$push106=, $pop23, $pop24
	tee_local	$push105=, $5=, $pop106
	i32.const	$push104=, 1103515245
	i32.mul 	$push26=, $pop105, $pop104
	i32.const	$push103=, 12345
	i32.add 	$push27=, $pop26, $pop103
	i32.store	$push0=, myrnd.s($pop107), $pop27
	i32.const	$push102=, 16
	i32.shr_u	$push28=, $pop0, $pop102
	i32.const	$push101=, 2047
	i32.and 	$push100=, $pop28, $pop101
	tee_local	$push99=, $4=, $pop100
	i32.const	$push98=, 17
	i32.shl 	$push31=, $pop99, $pop98
	i32.const	$push97=, 16
	i32.shr_u	$push25=, $5, $pop97
	i32.const	$push96=, 2047
	i32.and 	$push95=, $pop25, $pop96
	tee_local	$push94=, $5=, $pop95
	i32.const	$push93=, 17
	i32.shl 	$push29=, $pop94, $pop93
	i32.or  	$push30=, $pop29, $2
	i32.add 	$push1=, $pop31, $pop30
	i32.store	$push92=, sA($pop108), $pop1
	tee_local	$push91=, $1=, $pop92
	i32.xor 	$push32=, $pop91, $3
	i32.const	$push90=, 131071
	i32.and 	$push33=, $pop32, $pop90
	br_if   	0, $pop33       # 0: down to label0
# BB#2:                                 # %lor.lhs.false125
	i32.add 	$push36=, $4, $5
	i32.const	$push34=, 17
	i32.shr_u	$push35=, $1, $pop34
	i32.ne  	$push37=, $pop36, $pop35
	br_if   	0, $pop37       # 0: down to label0
# BB#3:                                 # %if.end131
	return
.LBB6_4:                                # %if.then130
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
	i32.load	$push1=, sB($pop0)
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
	i32.load	$push1=, sB($pop0)
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
	i32.load	$push1=, sB($pop0)
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
	i32.load	$push1=, sB($pop8)
	i32.const	$push2=, 17
	i32.shl 	$push3=, $0, $pop2
	i32.add 	$push7=, $pop1, $pop3
	tee_local	$push6=, $0=, $pop7
	i32.store	$discard=, sB($pop0), $pop6
	i32.const	$push5=, 17
	i32.shr_u	$push4=, $0, $pop5
	return  	$pop4
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
	i32.const	$push127=, 0
	i32.const	$push126=, 0
	i32.load	$push2=, myrnd.s($pop126)
	i32.const	$push125=, 1103515245
	i32.mul 	$push3=, $pop2, $pop125
	i32.const	$push124=, 12345
	i32.add 	$push123=, $pop3, $pop124
	tee_local	$push122=, $4=, $pop123
	i32.const	$push121=, 16
	i32.shr_u	$push4=, $pop122, $pop121
	i32.store8	$discard=, sB($pop127), $pop4
	i32.const	$push120=, 0
	i32.const	$push119=, 1103515245
	i32.mul 	$push5=, $4, $pop119
	i32.const	$push118=, 12345
	i32.add 	$push117=, $pop5, $pop118
	tee_local	$push116=, $4=, $pop117
	i32.const	$push115=, 16
	i32.shr_u	$push6=, $pop116, $pop115
	i32.store8	$discard=, sB+1($pop120), $pop6
	i32.const	$push114=, 0
	i32.const	$push113=, 1103515245
	i32.mul 	$push7=, $4, $pop113
	i32.const	$push112=, 12345
	i32.add 	$push111=, $pop7, $pop112
	tee_local	$push110=, $4=, $pop111
	i32.const	$push109=, 16
	i32.shr_u	$push8=, $pop110, $pop109
	i32.store8	$discard=, sB+2($pop114), $pop8
	i32.const	$push108=, 0
	i32.const	$push107=, 1103515245
	i32.mul 	$push9=, $4, $pop107
	i32.const	$push106=, 12345
	i32.add 	$push105=, $pop9, $pop106
	tee_local	$push104=, $4=, $pop105
	i32.const	$push103=, 16
	i32.shr_u	$push10=, $pop104, $pop103
	i32.store8	$discard=, sB+3($pop108), $pop10
	i32.const	$push102=, 0
	i32.const	$push101=, 1103515245
	i32.mul 	$push11=, $4, $pop101
	i32.const	$push100=, 12345
	i32.add 	$push99=, $pop11, $pop100
	tee_local	$push98=, $4=, $pop99
	i32.const	$push97=, 16
	i32.shr_u	$push12=, $pop98, $pop97
	i32.store8	$discard=, sB+4($pop102), $pop12
	i32.const	$push96=, 0
	i32.const	$push95=, 1103515245
	i32.mul 	$push13=, $4, $pop95
	i32.const	$push94=, 12345
	i32.add 	$push93=, $pop13, $pop94
	tee_local	$push92=, $4=, $pop93
	i32.const	$push91=, 16
	i32.shr_u	$push14=, $pop92, $pop91
	i32.store8	$discard=, sB+5($pop96), $pop14
	i32.const	$push90=, 0
	i32.const	$push89=, 1103515245
	i32.mul 	$push15=, $4, $pop89
	i32.const	$push88=, 12345
	i32.add 	$push87=, $pop15, $pop88
	tee_local	$push86=, $4=, $pop87
	i32.const	$push85=, 16
	i32.shr_u	$push16=, $pop86, $pop85
	i32.store8	$discard=, sB+6($pop90), $pop16
	i32.const	$push84=, 0
	i32.const	$push83=, 1103515245
	i32.mul 	$push17=, $4, $pop83
	i32.const	$push82=, 12345
	i32.add 	$push81=, $pop17, $pop82
	tee_local	$push80=, $4=, $pop81
	i32.const	$push79=, 16
	i32.shr_u	$push18=, $pop80, $pop79
	i32.store8	$discard=, sB+7($pop84), $pop18
	i32.const	$push78=, 0
	i32.load	$2=, sB($pop78)
	i32.const	$push77=, 0
	i32.const	$push76=, 1103515245
	i32.mul 	$push19=, $4, $pop76
	i32.const	$push75=, 12345
	i32.add 	$push74=, $pop19, $pop75
	tee_local	$push73=, $4=, $pop74
	i32.const	$push72=, 1103515245
	i32.mul 	$push21=, $pop73, $pop72
	i32.const	$push71=, 12345
	i32.add 	$push70=, $pop21, $pop71
	tee_local	$push69=, $3=, $pop70
	i32.store	$0=, myrnd.s($pop77), $pop69
	i32.const	$push68=, 0
	i32.const	$push67=, 16
	i32.shr_u	$push20=, $4, $pop67
	i32.const	$push66=, 2047
	i32.and 	$push65=, $pop20, $pop66
	tee_local	$push64=, $4=, $pop65
	i32.const	$push63=, 17
	i32.shl 	$push23=, $pop64, $pop63
	i32.const	$push62=, 131071
	i32.and 	$push24=, $2, $pop62
	i32.or  	$push61=, $pop23, $pop24
	tee_local	$push60=, $2=, $pop61
	i32.store	$1=, sB($pop68), $pop60
	block
	i32.const	$push59=, 16
	i32.shr_u	$push22=, $3, $pop59
	i32.const	$push58=, 2047
	i32.and 	$push57=, $pop22, $pop58
	tee_local	$push56=, $3=, $pop57
	i32.add 	$push28=, $pop56, $4
	i32.const	$push55=, 17
	i32.shl 	$push25=, $3, $pop55
	i32.add 	$push26=, $pop25, $2
	i32.const	$push54=, 17
	i32.shr_u	$push27=, $pop26, $pop54
	i32.ne  	$push29=, $pop28, $pop27
	br_if   	0, $pop29       # 0: down to label1
# BB#1:                                 # %if.end76
	i32.const	$push154=, 0
	i32.const	$push153=, 0
	i32.const	$push152=, 1103515245
	i32.mul 	$push30=, $0, $pop152
	i32.const	$push151=, 12345
	i32.add 	$push150=, $pop30, $pop151
	tee_local	$push149=, $4=, $pop150
	i32.const	$push36=, -1029531031
	i32.mul 	$push37=, $pop149, $pop36
	i32.const	$push38=, -740551042
	i32.add 	$push148=, $pop37, $pop38
	tee_local	$push147=, $2=, $pop148
	i32.const	$push146=, 1103515245
	i32.mul 	$push40=, $pop147, $pop146
	i32.const	$push145=, 12345
	i32.add 	$push41=, $pop40, $pop145
	i32.store	$push0=, myrnd.s($pop153), $pop41
	i32.const	$push144=, 16
	i32.shr_u	$push42=, $pop0, $pop144
	i32.const	$push143=, 2047
	i32.and 	$push142=, $pop42, $pop143
	tee_local	$push141=, $3=, $pop142
	i32.const	$push140=, 17
	i32.shl 	$push45=, $pop141, $pop140
	i32.const	$push139=, 16
	i32.shr_u	$push39=, $2, $pop139
	i32.const	$push138=, 2047
	i32.and 	$push137=, $pop39, $pop138
	tee_local	$push136=, $0=, $pop137
	i32.const	$push135=, 17
	i32.shl 	$push43=, $pop136, $pop135
	i32.const	$push134=, 131071
	i32.and 	$push133=, $1, $pop134
	tee_local	$push132=, $2=, $pop133
	i32.or  	$push44=, $pop43, $pop132
	i32.add 	$push1=, $pop45, $pop44
	i32.store	$push131=, sB($pop154), $pop1
	tee_local	$push130=, $1=, $pop131
	i32.const	$push31=, 1
	i32.shl 	$push32=, $4, $pop31
	i32.const	$push33=, 268304384
	i32.and 	$push34=, $pop32, $pop33
	i32.or  	$push35=, $pop34, $2
	i32.xor 	$push129=, $pop130, $pop35
	tee_local	$push128=, $4=, $pop129
	i32.const	$push46=, 63
	i32.and 	$push47=, $pop128, $pop46
	br_if   	0, $pop47       # 0: down to label1
# BB#2:                                 # %lor.lhs.false91
	i32.add 	$push52=, $3, $0
	i32.const	$push49=, 17
	i32.shr_u	$push50=, $1, $pop49
	i32.ne  	$push53=, $pop52, $pop50
	br_if   	0, $pop53       # 0: down to label1
# BB#3:                                 # %lor.lhs.false91
	i32.const	$push51=, 131008
	i32.and 	$push48=, $4, $pop51
	br_if   	0, $pop48       # 0: down to label1
# BB#4:                                 # %if.end115
	return
.LBB12_5:                               # %if.then114
	end_block                       # label1:
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
	i32.add 	$push7=, $pop1, $pop3
	tee_local	$push6=, $0=, $pop7
	i32.store	$discard=, sC+4($pop0), $pop6
	i32.const	$push5=, 17
	i32.shr_u	$push4=, $0, $pop5
	return  	$pop4
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
	i32.const	$push127=, 0
	i32.const	$push126=, 0
	i32.load	$push2=, myrnd.s($pop126)
	i32.const	$push125=, 1103515245
	i32.mul 	$push3=, $pop2, $pop125
	i32.const	$push124=, 12345
	i32.add 	$push123=, $pop3, $pop124
	tee_local	$push122=, $2=, $pop123
	i32.const	$push121=, 16
	i32.shr_u	$push4=, $pop122, $pop121
	i32.store8	$discard=, sC($pop127), $pop4
	i32.const	$push120=, 0
	i32.const	$push119=, 1103515245
	i32.mul 	$push5=, $2, $pop119
	i32.const	$push118=, 12345
	i32.add 	$push117=, $pop5, $pop118
	tee_local	$push116=, $2=, $pop117
	i32.const	$push115=, 16
	i32.shr_u	$push6=, $pop116, $pop115
	i32.store8	$discard=, sC+1($pop120), $pop6
	i32.const	$push114=, 0
	i32.const	$push113=, 1103515245
	i32.mul 	$push7=, $2, $pop113
	i32.const	$push112=, 12345
	i32.add 	$push111=, $pop7, $pop112
	tee_local	$push110=, $2=, $pop111
	i32.const	$push109=, 16
	i32.shr_u	$push8=, $pop110, $pop109
	i32.store8	$discard=, sC+2($pop114), $pop8
	i32.const	$push108=, 0
	i32.const	$push107=, 1103515245
	i32.mul 	$push9=, $2, $pop107
	i32.const	$push106=, 12345
	i32.add 	$push105=, $pop9, $pop106
	tee_local	$push104=, $2=, $pop105
	i32.const	$push103=, 1103515245
	i32.mul 	$push11=, $pop104, $pop103
	i32.const	$push102=, 12345
	i32.add 	$push101=, $pop11, $pop102
	tee_local	$push100=, $4=, $pop101
	i32.const	$push99=, 16
	i32.shr_u	$push12=, $pop100, $pop99
	i32.store8	$discard=, sC+4($pop108), $pop12
	i32.const	$push98=, 0
	i32.const	$push97=, 1103515245
	i32.mul 	$push13=, $4, $pop97
	i32.const	$push96=, 12345
	i32.add 	$push95=, $pop13, $pop96
	tee_local	$push94=, $4=, $pop95
	i32.const	$push93=, 16
	i32.shr_u	$push14=, $pop94, $pop93
	i32.store8	$discard=, sC+5($pop98), $pop14
	i32.const	$push92=, 0
	i32.const	$push91=, 1103515245
	i32.mul 	$push15=, $4, $pop91
	i32.const	$push90=, 12345
	i32.add 	$push89=, $pop15, $pop90
	tee_local	$push88=, $4=, $pop89
	i32.const	$push87=, 16
	i32.shr_u	$push16=, $pop88, $pop87
	i32.store8	$discard=, sC+6($pop92), $pop16
	i32.const	$push86=, 0
	i32.const	$push85=, 1103515245
	i32.mul 	$push17=, $4, $pop85
	i32.const	$push84=, 12345
	i32.add 	$push83=, $pop17, $pop84
	tee_local	$push82=, $4=, $pop83
	i32.const	$push81=, 16
	i32.shr_u	$push18=, $pop82, $pop81
	i32.store8	$discard=, sC+7($pop86), $pop18
	i32.const	$push80=, 0
	i32.load	$1=, sC+4($pop80)
	i32.const	$push79=, 0
	i32.const	$push78=, 16
	i32.shr_u	$push10=, $2, $pop78
	i32.store8	$discard=, sC+3($pop79), $pop10
	i32.const	$push77=, 0
	i32.const	$push76=, 1103515245
	i32.mul 	$push19=, $4, $pop76
	i32.const	$push75=, 12345
	i32.add 	$push74=, $pop19, $pop75
	tee_local	$push73=, $4=, $pop74
	i32.const	$push72=, 16
	i32.shr_u	$push20=, $pop73, $pop72
	i32.const	$push71=, 2047
	i32.and 	$push70=, $pop20, $pop71
	tee_local	$push69=, $3=, $pop70
	i32.const	$push68=, 17
	i32.shl 	$push23=, $pop69, $pop68
	i32.const	$push24=, 131071
	i32.and 	$push67=, $1, $pop24
	tee_local	$push66=, $2=, $pop67
	i32.or  	$push25=, $pop23, $pop66
	i32.store	$1=, sC+4($pop77), $pop25
	i32.const	$push65=, 0
	i32.const	$push64=, 1103515245
	i32.mul 	$push21=, $4, $pop64
	i32.const	$push63=, 12345
	i32.add 	$push62=, $pop21, $pop63
	tee_local	$push61=, $4=, $pop62
	i32.store	$0=, myrnd.s($pop65), $pop61
	block
	i32.const	$push60=, 16
	i32.shr_u	$push22=, $4, $pop60
	i32.const	$push59=, 2047
	i32.and 	$push58=, $pop22, $pop59
	tee_local	$push57=, $4=, $pop58
	i32.add 	$push29=, $pop57, $3
	i32.const	$push56=, 17
	i32.shl 	$push26=, $4, $pop56
	i32.add 	$push27=, $1, $pop26
	i32.const	$push55=, 17
	i32.shr_u	$push28=, $pop27, $pop55
	i32.ne  	$push30=, $pop29, $pop28
	br_if   	0, $pop30       # 0: down to label2
# BB#1:                                 # %if.end80
	i32.const	$push151=, 0
	i32.const	$push150=, 0
	i32.const	$push149=, 1103515245
	i32.mul 	$push31=, $0, $pop149
	i32.const	$push148=, 12345
	i32.add 	$push147=, $pop31, $pop148
	tee_local	$push146=, $4=, $pop147
	i32.const	$push37=, -1029531031
	i32.mul 	$push38=, $pop146, $pop37
	i32.const	$push39=, -740551042
	i32.add 	$push145=, $pop38, $pop39
	tee_local	$push144=, $1=, $pop145
	i32.const	$push143=, 1103515245
	i32.mul 	$push41=, $pop144, $pop143
	i32.const	$push142=, 12345
	i32.add 	$push42=, $pop41, $pop142
	i32.store	$push0=, myrnd.s($pop150), $pop42
	i32.const	$push141=, 16
	i32.shr_u	$push43=, $pop0, $pop141
	i32.const	$push140=, 2047
	i32.and 	$push139=, $pop43, $pop140
	tee_local	$push138=, $3=, $pop139
	i32.const	$push137=, 17
	i32.shl 	$push46=, $pop138, $pop137
	i32.const	$push136=, 16
	i32.shr_u	$push40=, $1, $pop136
	i32.const	$push135=, 2047
	i32.and 	$push134=, $pop40, $pop135
	tee_local	$push133=, $1=, $pop134
	i32.const	$push132=, 17
	i32.shl 	$push44=, $pop133, $pop132
	i32.or  	$push45=, $pop44, $2
	i32.add 	$push1=, $pop46, $pop45
	i32.store	$push131=, sC+4($pop151), $pop1
	tee_local	$push130=, $0=, $pop131
	i32.const	$push32=, 1
	i32.shl 	$push33=, $4, $pop32
	i32.const	$push34=, 268304384
	i32.and 	$push35=, $pop33, $pop34
	i32.or  	$push36=, $pop35, $2
	i32.xor 	$push129=, $pop130, $pop36
	tee_local	$push128=, $2=, $pop129
	i32.const	$push47=, 63
	i32.and 	$push48=, $pop128, $pop47
	br_if   	0, $pop48       # 0: down to label2
# BB#2:                                 # %lor.lhs.false96
	i32.add 	$push53=, $3, $1
	i32.const	$push50=, 17
	i32.shr_u	$push51=, $0, $pop50
	i32.ne  	$push54=, $pop53, $pop51
	br_if   	0, $pop54       # 0: down to label2
# BB#3:                                 # %lor.lhs.false96
	i32.const	$push52=, 131008
	i32.and 	$push49=, $2, $pop52
	br_if   	0, $pop49       # 0: down to label2
# BB#4:                                 # %if.end121
	return
.LBB18_5:                               # %if.then120
	end_block                       # label2:
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
	i64.load	$push15=, sD($pop16)
	tee_local	$push14=, $1=, $pop15
	i64.const	$push1=, 35
	i64.shr_u	$push2=, $pop14, $pop1
	i32.wrap/i64	$push3=, $pop2
	i32.add 	$push13=, $pop3, $0
	tee_local	$push12=, $0=, $pop13
	i64.extend_u/i32	$push4=, $pop12
	i64.const	$push11=, 35
	i64.shl 	$push5=, $pop4, $pop11
	i64.const	$push6=, 34359738367
	i64.and 	$push7=, $1, $pop6
	i64.or  	$push8=, $pop5, $pop7
	i64.store	$discard=, sD($pop0), $pop8
	i32.const	$push9=, 536870911
	i32.and 	$push10=, $0, $pop9
	return  	$pop10
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
	i32.const	$push1=, 0
	i32.const	$push94=, 0
	i32.load	$push2=, myrnd.s($pop94)
	i32.const	$push3=, 1103515245
	i32.mul 	$push4=, $pop2, $pop3
	i32.const	$push5=, 12345
	i32.add 	$push93=, $pop4, $pop5
	tee_local	$push92=, $0=, $pop93
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop92, $pop6
	i32.store8	$discard=, sD($pop1), $pop7
	i32.const	$push91=, 0
	i32.const	$push90=, 1103515245
	i32.mul 	$push8=, $0, $pop90
	i32.const	$push89=, 12345
	i32.add 	$push88=, $pop8, $pop89
	tee_local	$push87=, $0=, $pop88
	i32.const	$push86=, 16
	i32.shr_u	$push9=, $pop87, $pop86
	i32.store8	$discard=, sD+1($pop91), $pop9
	i32.const	$push85=, 0
	i32.const	$push84=, 1103515245
	i32.mul 	$push10=, $0, $pop84
	i32.const	$push83=, 12345
	i32.add 	$push82=, $pop10, $pop83
	tee_local	$push81=, $0=, $pop82
	i32.const	$push80=, 16
	i32.shr_u	$push11=, $pop81, $pop80
	i32.store8	$discard=, sD+2($pop85), $pop11
	i32.const	$push79=, 0
	i32.const	$push78=, 1103515245
	i32.mul 	$push12=, $0, $pop78
	i32.const	$push77=, 12345
	i32.add 	$push76=, $pop12, $pop77
	tee_local	$push75=, $0=, $pop76
	i32.const	$push74=, 16
	i32.shr_u	$push13=, $pop75, $pop74
	i32.store8	$discard=, sD+3($pop79), $pop13
	i32.const	$push73=, 0
	i32.const	$push72=, 1103515245
	i32.mul 	$push14=, $0, $pop72
	i32.const	$push71=, 12345
	i32.add 	$push70=, $pop14, $pop71
	tee_local	$push69=, $0=, $pop70
	i32.const	$push68=, 16
	i32.shr_u	$push15=, $pop69, $pop68
	i32.store8	$discard=, sD+4($pop73), $pop15
	i32.const	$push67=, 0
	i32.const	$push66=, 1103515245
	i32.mul 	$push16=, $0, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push64=, $pop16, $pop65
	tee_local	$push63=, $0=, $pop64
	i32.const	$push62=, 16
	i32.shr_u	$push17=, $pop63, $pop62
	i32.store8	$discard=, sD+5($pop67), $pop17
	i32.const	$push61=, 0
	i32.const	$push60=, 1103515245
	i32.mul 	$push18=, $0, $pop60
	i32.const	$push59=, 12345
	i32.add 	$push58=, $pop18, $pop59
	tee_local	$push57=, $0=, $pop58
	i32.const	$push56=, 16
	i32.shr_u	$push19=, $pop57, $pop56
	i32.store8	$discard=, sD+6($pop61), $pop19
	i32.const	$push55=, 0
	i32.const	$push54=, 1103515245
	i32.mul 	$push20=, $0, $pop54
	i32.const	$push53=, 12345
	i32.add 	$push52=, $pop20, $pop53
	tee_local	$push51=, $0=, $pop52
	i32.const	$push50=, 16
	i32.shr_u	$push21=, $pop51, $pop50
	i32.store8	$discard=, sD+7($pop55), $pop21
	i32.const	$push49=, 0
	i32.const	$push48=, 0
	i32.const	$push23=, -341751747
	i32.mul 	$push24=, $0, $pop23
	i32.const	$push25=, 229283573
	i32.add 	$push47=, $pop24, $pop25
	tee_local	$push46=, $0=, $pop47
	i32.const	$push45=, 1103515245
	i32.mul 	$push29=, $pop46, $pop45
	i32.const	$push44=, 12345
	i32.add 	$push30=, $pop29, $pop44
	i32.store	$push0=, myrnd.s($pop48), $pop30
	i32.const	$push43=, 16
	i32.shr_u	$push31=, $pop0, $pop43
	i32.const	$push27=, 2047
	i32.and 	$push32=, $pop31, $pop27
	i32.const	$push42=, 16
	i32.shr_u	$push26=, $0, $pop42
	i32.const	$push41=, 2047
	i32.and 	$push28=, $pop26, $pop41
	i32.add 	$push35=, $pop32, $pop28
	i64.extend_u/i32	$push36=, $pop35
	i64.const	$push37=, 35
	i64.shl 	$push38=, $pop36, $pop37
	i32.const	$push40=, 0
	i64.load	$push22=, sD($pop40)
	i64.const	$push33=, 34359738367
	i64.and 	$push34=, $pop22, $pop33
	i64.or  	$push39=, $pop38, $pop34
	i64.store	$discard=, sD($pop49), $pop39
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
	i64.load	$push15=, sE+8($pop16)
	tee_local	$push14=, $1=, $pop15
	i64.const	$push1=, 35
	i64.shr_u	$push2=, $pop14, $pop1
	i32.wrap/i64	$push3=, $pop2
	i32.add 	$push13=, $pop3, $0
	tee_local	$push12=, $0=, $pop13
	i64.extend_u/i32	$push4=, $pop12
	i64.const	$push11=, 35
	i64.shl 	$push5=, $pop4, $pop11
	i64.const	$push6=, 34359738367
	i64.and 	$push7=, $1, $pop6
	i64.or  	$push8=, $pop5, $pop7
	i64.store	$discard=, sE+8($pop0), $pop8
	i32.const	$push9=, 536870911
	i32.and 	$push10=, $0, $pop9
	return  	$pop10
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
	i32.const	$push1=, 0
	i32.const	$push158=, 0
	i32.load	$push2=, myrnd.s($pop158)
	i32.const	$push3=, 1103515245
	i32.mul 	$push4=, $pop2, $pop3
	i32.const	$push5=, 12345
	i32.add 	$push157=, $pop4, $pop5
	tee_local	$push156=, $0=, $pop157
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop156, $pop6
	i32.store8	$discard=, sE($pop1), $pop7
	i32.const	$push155=, 0
	i32.const	$push154=, 1103515245
	i32.mul 	$push8=, $0, $pop154
	i32.const	$push153=, 12345
	i32.add 	$push152=, $pop8, $pop153
	tee_local	$push151=, $0=, $pop152
	i32.const	$push150=, 16
	i32.shr_u	$push9=, $pop151, $pop150
	i32.store8	$discard=, sE+1($pop155), $pop9
	i32.const	$push149=, 0
	i32.const	$push148=, 1103515245
	i32.mul 	$push10=, $0, $pop148
	i32.const	$push147=, 12345
	i32.add 	$push146=, $pop10, $pop147
	tee_local	$push145=, $0=, $pop146
	i32.const	$push144=, 16
	i32.shr_u	$push11=, $pop145, $pop144
	i32.store8	$discard=, sE+2($pop149), $pop11
	i32.const	$push143=, 0
	i32.const	$push142=, 1103515245
	i32.mul 	$push12=, $0, $pop142
	i32.const	$push141=, 12345
	i32.add 	$push140=, $pop12, $pop141
	tee_local	$push139=, $0=, $pop140
	i32.const	$push138=, 16
	i32.shr_u	$push13=, $pop139, $pop138
	i32.store8	$discard=, sE+3($pop143), $pop13
	i32.const	$push137=, 0
	i32.const	$push136=, 1103515245
	i32.mul 	$push14=, $0, $pop136
	i32.const	$push135=, 12345
	i32.add 	$push134=, $pop14, $pop135
	tee_local	$push133=, $0=, $pop134
	i32.const	$push132=, 16
	i32.shr_u	$push15=, $pop133, $pop132
	i32.store8	$discard=, sE+4($pop137), $pop15
	i32.const	$push131=, 0
	i32.const	$push130=, 1103515245
	i32.mul 	$push16=, $0, $pop130
	i32.const	$push129=, 12345
	i32.add 	$push128=, $pop16, $pop129
	tee_local	$push127=, $0=, $pop128
	i32.const	$push126=, 16
	i32.shr_u	$push17=, $pop127, $pop126
	i32.store8	$discard=, sE+5($pop131), $pop17
	i32.const	$push125=, 0
	i32.const	$push124=, 1103515245
	i32.mul 	$push18=, $0, $pop124
	i32.const	$push123=, 12345
	i32.add 	$push122=, $pop18, $pop123
	tee_local	$push121=, $0=, $pop122
	i32.const	$push120=, 16
	i32.shr_u	$push19=, $pop121, $pop120
	i32.store8	$discard=, sE+6($pop125), $pop19
	i32.const	$push119=, 0
	i32.const	$push118=, 1103515245
	i32.mul 	$push20=, $0, $pop118
	i32.const	$push117=, 12345
	i32.add 	$push116=, $pop20, $pop117
	tee_local	$push115=, $0=, $pop116
	i32.const	$push114=, 16
	i32.shr_u	$push21=, $pop115, $pop114
	i32.store8	$discard=, sE+7($pop119), $pop21
	i32.const	$push113=, 0
	i32.const	$push112=, 1103515245
	i32.mul 	$push22=, $0, $pop112
	i32.const	$push111=, 12345
	i32.add 	$push110=, $pop22, $pop111
	tee_local	$push109=, $0=, $pop110
	i32.const	$push108=, 16
	i32.shr_u	$push23=, $pop109, $pop108
	i32.store8	$discard=, sE+8($pop113), $pop23
	i32.const	$push107=, 0
	i32.const	$push106=, 1103515245
	i32.mul 	$push24=, $0, $pop106
	i32.const	$push105=, 12345
	i32.add 	$push104=, $pop24, $pop105
	tee_local	$push103=, $0=, $pop104
	i32.const	$push102=, 16
	i32.shr_u	$push25=, $pop103, $pop102
	i32.store8	$discard=, sE+9($pop107), $pop25
	i32.const	$push101=, 0
	i32.const	$push100=, 1103515245
	i32.mul 	$push26=, $0, $pop100
	i32.const	$push99=, 12345
	i32.add 	$push98=, $pop26, $pop99
	tee_local	$push97=, $0=, $pop98
	i32.const	$push96=, 16
	i32.shr_u	$push27=, $pop97, $pop96
	i32.store8	$discard=, sE+10($pop101), $pop27
	i32.const	$push95=, 0
	i32.const	$push94=, 1103515245
	i32.mul 	$push28=, $0, $pop94
	i32.const	$push93=, 12345
	i32.add 	$push92=, $pop28, $pop93
	tee_local	$push91=, $0=, $pop92
	i32.const	$push90=, 16
	i32.shr_u	$push29=, $pop91, $pop90
	i32.store8	$discard=, sE+11($pop95), $pop29
	i32.const	$push89=, 0
	i32.const	$push88=, 1103515245
	i32.mul 	$push30=, $0, $pop88
	i32.const	$push87=, 12345
	i32.add 	$push86=, $pop30, $pop87
	tee_local	$push85=, $0=, $pop86
	i32.const	$push84=, 16
	i32.shr_u	$push31=, $pop85, $pop84
	i32.store8	$discard=, sE+12($pop89), $pop31
	i32.const	$push83=, 0
	i32.const	$push82=, 1103515245
	i32.mul 	$push32=, $0, $pop82
	i32.const	$push81=, 12345
	i32.add 	$push80=, $pop32, $pop81
	tee_local	$push79=, $0=, $pop80
	i32.const	$push78=, 16
	i32.shr_u	$push33=, $pop79, $pop78
	i32.store8	$discard=, sE+13($pop83), $pop33
	i32.const	$push77=, 0
	i32.const	$push76=, 1103515245
	i32.mul 	$push34=, $0, $pop76
	i32.const	$push75=, 12345
	i32.add 	$push74=, $pop34, $pop75
	tee_local	$push73=, $0=, $pop74
	i32.const	$push72=, 16
	i32.shr_u	$push35=, $pop73, $pop72
	i32.store8	$discard=, sE+14($pop77), $pop35
	i32.const	$push71=, 0
	i32.const	$push70=, 1103515245
	i32.mul 	$push36=, $0, $pop70
	i32.const	$push69=, 12345
	i32.add 	$push68=, $pop36, $pop69
	tee_local	$push67=, $0=, $pop68
	i32.const	$push66=, 16
	i32.shr_u	$push37=, $pop67, $pop66
	i32.store8	$discard=, sE+15($pop71), $pop37
	i32.const	$push65=, 0
	i32.const	$push64=, 0
	i32.const	$push39=, -341751747
	i32.mul 	$push40=, $0, $pop39
	i32.const	$push41=, 229283573
	i32.add 	$push63=, $pop40, $pop41
	tee_local	$push62=, $0=, $pop63
	i32.const	$push61=, 1103515245
	i32.mul 	$push45=, $pop62, $pop61
	i32.const	$push60=, 12345
	i32.add 	$push46=, $pop45, $pop60
	i32.store	$push0=, myrnd.s($pop64), $pop46
	i32.const	$push59=, 16
	i32.shr_u	$push47=, $pop0, $pop59
	i32.const	$push43=, 2047
	i32.and 	$push48=, $pop47, $pop43
	i32.const	$push58=, 16
	i32.shr_u	$push42=, $0, $pop58
	i32.const	$push57=, 2047
	i32.and 	$push44=, $pop42, $pop57
	i32.add 	$push51=, $pop48, $pop44
	i64.extend_u/i32	$push52=, $pop51
	i64.const	$push53=, 35
	i64.shl 	$push54=, $pop52, $pop53
	i32.const	$push56=, 0
	i64.load	$push38=, sE+8($pop56)
	i64.const	$push49=, 34359738367
	i64.and 	$push50=, $pop38, $pop49
	i64.or  	$push55=, $pop54, $pop50
	i64.store	$discard=, sE+8($pop65), $pop55
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
	i64.load	$push15=, sF($pop16)
	tee_local	$push14=, $1=, $pop15
	i64.const	$push1=, 35
	i64.shr_u	$push2=, $pop14, $pop1
	i32.wrap/i64	$push3=, $pop2
	i32.add 	$push13=, $pop3, $0
	tee_local	$push12=, $0=, $pop13
	i64.extend_u/i32	$push4=, $pop12
	i64.const	$push11=, 35
	i64.shl 	$push5=, $pop4, $pop11
	i64.const	$push6=, 34359738367
	i64.and 	$push7=, $1, $pop6
	i64.or  	$push8=, $pop5, $pop7
	i64.store	$discard=, sF($pop0), $pop8
	i32.const	$push9=, 536870911
	i32.and 	$push10=, $0, $pop9
	return  	$pop10
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
	i32.const	$push1=, 0
	i32.const	$push158=, 0
	i32.load	$push2=, myrnd.s($pop158)
	i32.const	$push3=, 1103515245
	i32.mul 	$push4=, $pop2, $pop3
	i32.const	$push5=, 12345
	i32.add 	$push157=, $pop4, $pop5
	tee_local	$push156=, $0=, $pop157
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop156, $pop6
	i32.store8	$discard=, sF($pop1), $pop7
	i32.const	$push155=, 0
	i32.const	$push154=, 1103515245
	i32.mul 	$push8=, $0, $pop154
	i32.const	$push153=, 12345
	i32.add 	$push152=, $pop8, $pop153
	tee_local	$push151=, $0=, $pop152
	i32.const	$push150=, 16
	i32.shr_u	$push9=, $pop151, $pop150
	i32.store8	$discard=, sF+1($pop155), $pop9
	i32.const	$push149=, 0
	i32.const	$push148=, 1103515245
	i32.mul 	$push10=, $0, $pop148
	i32.const	$push147=, 12345
	i32.add 	$push146=, $pop10, $pop147
	tee_local	$push145=, $0=, $pop146
	i32.const	$push144=, 16
	i32.shr_u	$push11=, $pop145, $pop144
	i32.store8	$discard=, sF+2($pop149), $pop11
	i32.const	$push143=, 0
	i32.const	$push142=, 1103515245
	i32.mul 	$push12=, $0, $pop142
	i32.const	$push141=, 12345
	i32.add 	$push140=, $pop12, $pop141
	tee_local	$push139=, $0=, $pop140
	i32.const	$push138=, 16
	i32.shr_u	$push13=, $pop139, $pop138
	i32.store8	$discard=, sF+3($pop143), $pop13
	i32.const	$push137=, 0
	i32.const	$push136=, 1103515245
	i32.mul 	$push14=, $0, $pop136
	i32.const	$push135=, 12345
	i32.add 	$push134=, $pop14, $pop135
	tee_local	$push133=, $0=, $pop134
	i32.const	$push132=, 16
	i32.shr_u	$push15=, $pop133, $pop132
	i32.store8	$discard=, sF+4($pop137), $pop15
	i32.const	$push131=, 0
	i32.const	$push130=, 1103515245
	i32.mul 	$push16=, $0, $pop130
	i32.const	$push129=, 12345
	i32.add 	$push128=, $pop16, $pop129
	tee_local	$push127=, $0=, $pop128
	i32.const	$push126=, 16
	i32.shr_u	$push17=, $pop127, $pop126
	i32.store8	$discard=, sF+5($pop131), $pop17
	i32.const	$push125=, 0
	i32.const	$push124=, 1103515245
	i32.mul 	$push18=, $0, $pop124
	i32.const	$push123=, 12345
	i32.add 	$push122=, $pop18, $pop123
	tee_local	$push121=, $0=, $pop122
	i32.const	$push120=, 16
	i32.shr_u	$push19=, $pop121, $pop120
	i32.store8	$discard=, sF+6($pop125), $pop19
	i32.const	$push119=, 0
	i32.const	$push118=, 1103515245
	i32.mul 	$push20=, $0, $pop118
	i32.const	$push117=, 12345
	i32.add 	$push116=, $pop20, $pop117
	tee_local	$push115=, $0=, $pop116
	i32.const	$push114=, 16
	i32.shr_u	$push21=, $pop115, $pop114
	i32.store8	$discard=, sF+7($pop119), $pop21
	i32.const	$push113=, 0
	i32.const	$push112=, 1103515245
	i32.mul 	$push22=, $0, $pop112
	i32.const	$push111=, 12345
	i32.add 	$push110=, $pop22, $pop111
	tee_local	$push109=, $0=, $pop110
	i32.const	$push108=, 16
	i32.shr_u	$push23=, $pop109, $pop108
	i32.store8	$discard=, sF+8($pop113), $pop23
	i32.const	$push107=, 0
	i32.const	$push106=, 1103515245
	i32.mul 	$push24=, $0, $pop106
	i32.const	$push105=, 12345
	i32.add 	$push104=, $pop24, $pop105
	tee_local	$push103=, $0=, $pop104
	i32.const	$push102=, 16
	i32.shr_u	$push25=, $pop103, $pop102
	i32.store8	$discard=, sF+9($pop107), $pop25
	i32.const	$push101=, 0
	i32.const	$push100=, 1103515245
	i32.mul 	$push26=, $0, $pop100
	i32.const	$push99=, 12345
	i32.add 	$push98=, $pop26, $pop99
	tee_local	$push97=, $0=, $pop98
	i32.const	$push96=, 16
	i32.shr_u	$push27=, $pop97, $pop96
	i32.store8	$discard=, sF+10($pop101), $pop27
	i32.const	$push95=, 0
	i32.const	$push94=, 1103515245
	i32.mul 	$push28=, $0, $pop94
	i32.const	$push93=, 12345
	i32.add 	$push92=, $pop28, $pop93
	tee_local	$push91=, $0=, $pop92
	i32.const	$push90=, 16
	i32.shr_u	$push29=, $pop91, $pop90
	i32.store8	$discard=, sF+11($pop95), $pop29
	i32.const	$push89=, 0
	i32.const	$push88=, 1103515245
	i32.mul 	$push30=, $0, $pop88
	i32.const	$push87=, 12345
	i32.add 	$push86=, $pop30, $pop87
	tee_local	$push85=, $0=, $pop86
	i32.const	$push84=, 16
	i32.shr_u	$push31=, $pop85, $pop84
	i32.store8	$discard=, sF+12($pop89), $pop31
	i32.const	$push83=, 0
	i32.const	$push82=, 1103515245
	i32.mul 	$push32=, $0, $pop82
	i32.const	$push81=, 12345
	i32.add 	$push80=, $pop32, $pop81
	tee_local	$push79=, $0=, $pop80
	i32.const	$push78=, 16
	i32.shr_u	$push33=, $pop79, $pop78
	i32.store8	$discard=, sF+13($pop83), $pop33
	i32.const	$push77=, 0
	i32.const	$push76=, 1103515245
	i32.mul 	$push34=, $0, $pop76
	i32.const	$push75=, 12345
	i32.add 	$push74=, $pop34, $pop75
	tee_local	$push73=, $0=, $pop74
	i32.const	$push72=, 16
	i32.shr_u	$push35=, $pop73, $pop72
	i32.store8	$discard=, sF+14($pop77), $pop35
	i32.const	$push71=, 0
	i32.const	$push70=, 1103515245
	i32.mul 	$push36=, $0, $pop70
	i32.const	$push69=, 12345
	i32.add 	$push68=, $pop36, $pop69
	tee_local	$push67=, $0=, $pop68
	i32.const	$push66=, 16
	i32.shr_u	$push37=, $pop67, $pop66
	i32.store8	$discard=, sF+15($pop71), $pop37
	i32.const	$push65=, 0
	i32.const	$push64=, 0
	i32.const	$push39=, -341751747
	i32.mul 	$push40=, $0, $pop39
	i32.const	$push41=, 229283573
	i32.add 	$push63=, $pop40, $pop41
	tee_local	$push62=, $0=, $pop63
	i32.const	$push61=, 1103515245
	i32.mul 	$push45=, $pop62, $pop61
	i32.const	$push60=, 12345
	i32.add 	$push46=, $pop45, $pop60
	i32.store	$push0=, myrnd.s($pop64), $pop46
	i32.const	$push59=, 16
	i32.shr_u	$push47=, $pop0, $pop59
	i32.const	$push43=, 2047
	i32.and 	$push48=, $pop47, $pop43
	i32.const	$push58=, 16
	i32.shr_u	$push42=, $0, $pop58
	i32.const	$push57=, 2047
	i32.and 	$push44=, $pop42, $pop57
	i32.add 	$push51=, $pop48, $pop44
	i64.extend_u/i32	$push52=, $pop51
	i64.const	$push53=, 35
	i64.shl 	$push54=, $pop52, $pop53
	i32.const	$push56=, 0
	i64.load	$push38=, sF($pop56)
	i64.const	$push49=, 34359738367
	i64.and 	$push50=, $pop38, $pop49
	i64.or  	$push55=, $pop54, $pop50
	i64.store	$discard=, sF($pop65), $pop55
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
	i32.load	$push1=, sG($pop0)
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
	i32.load	$push1=, sG($pop0)
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
	i32.load	$push1=, sG($pop0)
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
	i32.load	$push1=, sG($pop8)
	i32.const	$push2=, 25
	i32.shl 	$push3=, $0, $pop2
	i32.add 	$push7=, $pop1, $pop3
	tee_local	$push6=, $0=, $pop7
	i32.store	$discard=, sG($pop0), $pop6
	i32.const	$push5=, 25
	i32.shr_u	$push4=, $0, $pop5
	return  	$pop4
	.endfunc
.Lfunc_end41:
	.size	fn3G, .Lfunc_end41-fn3G

	.section	.text.testG,"ax",@progbits
	.hidden	testG
	.globl	testG
	.type	testG,@function
testG:                                  # @testG
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push183=, 0
	i32.const	$push182=, 0
	i32.load	$push2=, myrnd.s($pop182)
	i32.const	$push181=, 1103515245
	i32.mul 	$push3=, $pop2, $pop181
	i32.const	$push180=, 12345
	i32.add 	$push179=, $pop3, $pop180
	tee_local	$push178=, $5=, $pop179
	i32.const	$push177=, 16
	i32.shr_u	$push4=, $pop178, $pop177
	i32.store8	$discard=, sG($pop183), $pop4
	i32.const	$push176=, 0
	i32.const	$push175=, 1103515245
	i32.mul 	$push5=, $5, $pop175
	i32.const	$push174=, 12345
	i32.add 	$push173=, $pop5, $pop174
	tee_local	$push172=, $5=, $pop173
	i32.const	$push171=, 16
	i32.shr_u	$push6=, $pop172, $pop171
	i32.store8	$discard=, sG+1($pop176), $pop6
	i32.const	$push170=, 0
	i32.const	$push169=, 1103515245
	i32.mul 	$push7=, $5, $pop169
	i32.const	$push168=, 12345
	i32.add 	$push167=, $pop7, $pop168
	tee_local	$push166=, $5=, $pop167
	i32.const	$push165=, 16
	i32.shr_u	$push8=, $pop166, $pop165
	i32.store8	$discard=, sG+2($pop170), $pop8
	i32.const	$push164=, 0
	i32.const	$push163=, 1103515245
	i32.mul 	$push9=, $5, $pop163
	i32.const	$push162=, 12345
	i32.add 	$push161=, $pop9, $pop162
	tee_local	$push160=, $5=, $pop161
	i32.const	$push159=, 16
	i32.shr_u	$push10=, $pop160, $pop159
	i32.store8	$discard=, sG+3($pop164), $pop10
	i32.const	$push158=, 0
	i32.const	$push157=, 1103515245
	i32.mul 	$push11=, $5, $pop157
	i32.const	$push156=, 12345
	i32.add 	$push155=, $pop11, $pop156
	tee_local	$push154=, $5=, $pop155
	i32.const	$push153=, 16
	i32.shr_u	$push12=, $pop154, $pop153
	i32.store8	$discard=, sG+4($pop158), $pop12
	i32.const	$push152=, 0
	i32.const	$push151=, 1103515245
	i32.mul 	$push13=, $5, $pop151
	i32.const	$push150=, 12345
	i32.add 	$push149=, $pop13, $pop150
	tee_local	$push148=, $5=, $pop149
	i32.const	$push147=, 16
	i32.shr_u	$push14=, $pop148, $pop147
	i32.store8	$discard=, sG+5($pop152), $pop14
	i32.const	$push146=, 0
	i32.const	$push145=, 1103515245
	i32.mul 	$push15=, $5, $pop145
	i32.const	$push144=, 12345
	i32.add 	$push143=, $pop15, $pop144
	tee_local	$push142=, $5=, $pop143
	i32.const	$push141=, 16
	i32.shr_u	$push16=, $pop142, $pop141
	i32.store8	$discard=, sG+6($pop146), $pop16
	i32.const	$push140=, 0
	i32.const	$push139=, 1103515245
	i32.mul 	$push17=, $5, $pop139
	i32.const	$push138=, 12345
	i32.add 	$push137=, $pop17, $pop138
	tee_local	$push136=, $5=, $pop137
	i32.const	$push135=, 16
	i32.shr_u	$push18=, $pop136, $pop135
	i32.store8	$discard=, sG+7($pop140), $pop18
	i32.const	$push134=, 0
	i32.const	$push133=, 1103515245
	i32.mul 	$push19=, $5, $pop133
	i32.const	$push132=, 12345
	i32.add 	$push131=, $pop19, $pop132
	tee_local	$push130=, $5=, $pop131
	i32.const	$push129=, 16
	i32.shr_u	$push20=, $pop130, $pop129
	i32.store8	$discard=, sG+8($pop134), $pop20
	i32.const	$push128=, 0
	i32.const	$push127=, 1103515245
	i32.mul 	$push21=, $5, $pop127
	i32.const	$push126=, 12345
	i32.add 	$push125=, $pop21, $pop126
	tee_local	$push124=, $5=, $pop125
	i32.const	$push123=, 16
	i32.shr_u	$push22=, $pop124, $pop123
	i32.store8	$discard=, sG+9($pop128), $pop22
	i32.const	$push122=, 0
	i32.const	$push121=, 1103515245
	i32.mul 	$push23=, $5, $pop121
	i32.const	$push120=, 12345
	i32.add 	$push119=, $pop23, $pop120
	tee_local	$push118=, $5=, $pop119
	i32.const	$push117=, 16
	i32.shr_u	$push24=, $pop118, $pop117
	i32.store8	$discard=, sG+10($pop122), $pop24
	i32.const	$push116=, 0
	i32.const	$push115=, 1103515245
	i32.mul 	$push25=, $5, $pop115
	i32.const	$push114=, 12345
	i32.add 	$push113=, $pop25, $pop114
	tee_local	$push112=, $5=, $pop113
	i32.const	$push111=, 16
	i32.shr_u	$push26=, $pop112, $pop111
	i32.store8	$discard=, sG+11($pop116), $pop26
	i32.const	$push110=, 0
	i32.const	$push109=, 1103515245
	i32.mul 	$push27=, $5, $pop109
	i32.const	$push108=, 12345
	i32.add 	$push107=, $pop27, $pop108
	tee_local	$push106=, $5=, $pop107
	i32.const	$push105=, 16
	i32.shr_u	$push28=, $pop106, $pop105
	i32.store8	$discard=, sG+12($pop110), $pop28
	i32.const	$push104=, 0
	i32.const	$push103=, 1103515245
	i32.mul 	$push29=, $5, $pop103
	i32.const	$push102=, 12345
	i32.add 	$push101=, $pop29, $pop102
	tee_local	$push100=, $5=, $pop101
	i32.const	$push99=, 16
	i32.shr_u	$push30=, $pop100, $pop99
	i32.store8	$discard=, sG+13($pop104), $pop30
	i32.const	$push98=, 0
	i32.const	$push97=, 1103515245
	i32.mul 	$push31=, $5, $pop97
	i32.const	$push96=, 12345
	i32.add 	$push95=, $pop31, $pop96
	tee_local	$push94=, $5=, $pop95
	i32.const	$push93=, 16
	i32.shr_u	$push32=, $pop94, $pop93
	i32.store8	$discard=, sG+14($pop98), $pop32
	i32.const	$push92=, 0
	i32.const	$push91=, 1103515245
	i32.mul 	$push33=, $5, $pop91
	i32.const	$push90=, 12345
	i32.add 	$push89=, $pop33, $pop90
	tee_local	$push88=, $5=, $pop89
	i32.const	$push87=, 16
	i32.shr_u	$push34=, $pop88, $pop87
	i32.store8	$discard=, sG+15($pop92), $pop34
	i32.const	$push86=, 0
	i32.const	$push85=, 1103515245
	i32.mul 	$push35=, $5, $pop85
	i32.const	$push84=, 12345
	i32.add 	$push83=, $pop35, $pop84
	tee_local	$push82=, $5=, $pop83
	i32.const	$push81=, 16
	i32.shr_u	$push80=, $pop82, $pop81
	tee_local	$push79=, $4=, $pop80
	i32.const	$push78=, 25
	i32.shl 	$push37=, $pop79, $pop78
	i32.const	$push77=, 0
	i32.load	$push76=, sG($pop77)
	tee_local	$push75=, $3=, $pop76
	i32.const	$push74=, 33554431
	i32.and 	$push73=, $pop75, $pop74
	tee_local	$push72=, $2=, $pop73
	i32.or  	$push38=, $pop37, $pop72
	i32.store	$1=, sG($pop86), $pop38
	i32.const	$push71=, 0
	i32.const	$push70=, 1103515245
	i32.mul 	$push36=, $5, $pop70
	i32.const	$push69=, 12345
	i32.add 	$push68=, $pop36, $pop69
	tee_local	$push67=, $5=, $pop68
	i32.store	$0=, myrnd.s($pop71), $pop67
	block
	i32.const	$push66=, 16
	i32.shr_u	$push65=, $5, $pop66
	tee_local	$push64=, $5=, $pop65
	i32.add 	$push42=, $pop64, $4
	i32.const	$push43=, 127
	i32.and 	$push44=, $pop42, $pop43
	i32.const	$push63=, 25
	i32.shl 	$push39=, $5, $pop63
	i32.add 	$push40=, $1, $pop39
	i32.const	$push62=, 25
	i32.shr_u	$push41=, $pop40, $pop62
	i32.ne  	$push45=, $pop44, $pop41
	br_if   	0, $pop45       # 0: down to label3
# BB#1:                                 # %if.end76
	i32.const	$push200=, 0
	i32.const	$push199=, 0
	i32.const	$push46=, -2139243339
	i32.mul 	$push47=, $0, $pop46
	i32.const	$push48=, -1492899873
	i32.add 	$push198=, $pop47, $pop48
	tee_local	$push197=, $5=, $pop198
	i32.const	$push196=, 1103515245
	i32.mul 	$push49=, $pop197, $pop196
	i32.const	$push195=, 12345
	i32.add 	$push50=, $pop49, $pop195
	i32.store	$push0=, myrnd.s($pop199), $pop50
	i32.const	$push194=, 16
	i32.shr_u	$push193=, $pop0, $pop194
	tee_local	$push192=, $4=, $pop193
	i32.const	$push191=, 25
	i32.shl 	$push53=, $pop192, $pop191
	i32.const	$push190=, 16
	i32.shr_u	$push189=, $5, $pop190
	tee_local	$push188=, $5=, $pop189
	i32.const	$push187=, 25
	i32.shl 	$push51=, $pop188, $pop187
	i32.or  	$push52=, $pop51, $2
	i32.add 	$push1=, $pop53, $pop52
	i32.store	$push186=, sG($pop200), $pop1
	tee_local	$push185=, $1=, $pop186
	i32.xor 	$push54=, $pop185, $3
	i32.const	$push184=, 33554431
	i32.and 	$push55=, $pop54, $pop184
	br_if   	0, $pop55       # 0: down to label3
# BB#2:                                 # %lor.lhs.false109
	i32.add 	$push58=, $4, $5
	i32.const	$push59=, 127
	i32.and 	$push60=, $pop58, $pop59
	i32.const	$push56=, 25
	i32.shr_u	$push57=, $1, $pop56
	i32.ne  	$push61=, $pop60, $pop57
	br_if   	0, $pop61       # 0: down to label3
# BB#3:                                 # %if.end115
	return
.LBB42_4:                               # %if.then114
	end_block                       # label3:
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
	i32.load	$push1=, sH($pop0)
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
	i32.load	$push1=, sH($pop0)
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
	i32.load	$push1=, sH($pop0)
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
	i32.load	$push1=, sH($pop8)
	i32.const	$push2=, 23
	i32.shl 	$push3=, $0, $pop2
	i32.add 	$push7=, $pop1, $pop3
	tee_local	$push6=, $0=, $pop7
	i32.store	$discard=, sH($pop0), $pop6
	i32.const	$push5=, 23
	i32.shr_u	$push4=, $0, $pop5
	return  	$pop4
	.endfunc
.Lfunc_end47:
	.size	fn3H, .Lfunc_end47-fn3H

	.section	.text.testH,"ax",@progbits
	.hidden	testH
	.globl	testH
	.type	testH,@function
testH:                                  # @testH
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push183=, 0
	i32.const	$push182=, 0
	i32.load	$push2=, myrnd.s($pop182)
	i32.const	$push181=, 1103515245
	i32.mul 	$push3=, $pop2, $pop181
	i32.const	$push180=, 12345
	i32.add 	$push179=, $pop3, $pop180
	tee_local	$push178=, $5=, $pop179
	i32.const	$push177=, 16
	i32.shr_u	$push4=, $pop178, $pop177
	i32.store8	$discard=, sH($pop183), $pop4
	i32.const	$push176=, 0
	i32.const	$push175=, 1103515245
	i32.mul 	$push5=, $5, $pop175
	i32.const	$push174=, 12345
	i32.add 	$push173=, $pop5, $pop174
	tee_local	$push172=, $5=, $pop173
	i32.const	$push171=, 16
	i32.shr_u	$push6=, $pop172, $pop171
	i32.store8	$discard=, sH+1($pop176), $pop6
	i32.const	$push170=, 0
	i32.const	$push169=, 1103515245
	i32.mul 	$push7=, $5, $pop169
	i32.const	$push168=, 12345
	i32.add 	$push167=, $pop7, $pop168
	tee_local	$push166=, $5=, $pop167
	i32.const	$push165=, 16
	i32.shr_u	$push8=, $pop166, $pop165
	i32.store8	$discard=, sH+2($pop170), $pop8
	i32.const	$push164=, 0
	i32.const	$push163=, 1103515245
	i32.mul 	$push9=, $5, $pop163
	i32.const	$push162=, 12345
	i32.add 	$push161=, $pop9, $pop162
	tee_local	$push160=, $5=, $pop161
	i32.const	$push159=, 16
	i32.shr_u	$push10=, $pop160, $pop159
	i32.store8	$discard=, sH+3($pop164), $pop10
	i32.const	$push158=, 0
	i32.const	$push157=, 1103515245
	i32.mul 	$push11=, $5, $pop157
	i32.const	$push156=, 12345
	i32.add 	$push155=, $pop11, $pop156
	tee_local	$push154=, $5=, $pop155
	i32.const	$push153=, 16
	i32.shr_u	$push12=, $pop154, $pop153
	i32.store8	$discard=, sH+4($pop158), $pop12
	i32.const	$push152=, 0
	i32.const	$push151=, 1103515245
	i32.mul 	$push13=, $5, $pop151
	i32.const	$push150=, 12345
	i32.add 	$push149=, $pop13, $pop150
	tee_local	$push148=, $5=, $pop149
	i32.const	$push147=, 16
	i32.shr_u	$push14=, $pop148, $pop147
	i32.store8	$discard=, sH+5($pop152), $pop14
	i32.const	$push146=, 0
	i32.const	$push145=, 1103515245
	i32.mul 	$push15=, $5, $pop145
	i32.const	$push144=, 12345
	i32.add 	$push143=, $pop15, $pop144
	tee_local	$push142=, $5=, $pop143
	i32.const	$push141=, 16
	i32.shr_u	$push16=, $pop142, $pop141
	i32.store8	$discard=, sH+6($pop146), $pop16
	i32.const	$push140=, 0
	i32.const	$push139=, 1103515245
	i32.mul 	$push17=, $5, $pop139
	i32.const	$push138=, 12345
	i32.add 	$push137=, $pop17, $pop138
	tee_local	$push136=, $5=, $pop137
	i32.const	$push135=, 16
	i32.shr_u	$push18=, $pop136, $pop135
	i32.store8	$discard=, sH+7($pop140), $pop18
	i32.const	$push134=, 0
	i32.const	$push133=, 1103515245
	i32.mul 	$push19=, $5, $pop133
	i32.const	$push132=, 12345
	i32.add 	$push131=, $pop19, $pop132
	tee_local	$push130=, $5=, $pop131
	i32.const	$push129=, 16
	i32.shr_u	$push20=, $pop130, $pop129
	i32.store8	$discard=, sH+8($pop134), $pop20
	i32.const	$push128=, 0
	i32.const	$push127=, 1103515245
	i32.mul 	$push21=, $5, $pop127
	i32.const	$push126=, 12345
	i32.add 	$push125=, $pop21, $pop126
	tee_local	$push124=, $5=, $pop125
	i32.const	$push123=, 16
	i32.shr_u	$push22=, $pop124, $pop123
	i32.store8	$discard=, sH+9($pop128), $pop22
	i32.const	$push122=, 0
	i32.const	$push121=, 1103515245
	i32.mul 	$push23=, $5, $pop121
	i32.const	$push120=, 12345
	i32.add 	$push119=, $pop23, $pop120
	tee_local	$push118=, $5=, $pop119
	i32.const	$push117=, 16
	i32.shr_u	$push24=, $pop118, $pop117
	i32.store8	$discard=, sH+10($pop122), $pop24
	i32.const	$push116=, 0
	i32.const	$push115=, 1103515245
	i32.mul 	$push25=, $5, $pop115
	i32.const	$push114=, 12345
	i32.add 	$push113=, $pop25, $pop114
	tee_local	$push112=, $5=, $pop113
	i32.const	$push111=, 16
	i32.shr_u	$push26=, $pop112, $pop111
	i32.store8	$discard=, sH+11($pop116), $pop26
	i32.const	$push110=, 0
	i32.const	$push109=, 1103515245
	i32.mul 	$push27=, $5, $pop109
	i32.const	$push108=, 12345
	i32.add 	$push107=, $pop27, $pop108
	tee_local	$push106=, $5=, $pop107
	i32.const	$push105=, 16
	i32.shr_u	$push28=, $pop106, $pop105
	i32.store8	$discard=, sH+12($pop110), $pop28
	i32.const	$push104=, 0
	i32.const	$push103=, 1103515245
	i32.mul 	$push29=, $5, $pop103
	i32.const	$push102=, 12345
	i32.add 	$push101=, $pop29, $pop102
	tee_local	$push100=, $5=, $pop101
	i32.const	$push99=, 16
	i32.shr_u	$push30=, $pop100, $pop99
	i32.store8	$discard=, sH+13($pop104), $pop30
	i32.const	$push98=, 0
	i32.const	$push97=, 1103515245
	i32.mul 	$push31=, $5, $pop97
	i32.const	$push96=, 12345
	i32.add 	$push95=, $pop31, $pop96
	tee_local	$push94=, $5=, $pop95
	i32.const	$push93=, 16
	i32.shr_u	$push32=, $pop94, $pop93
	i32.store8	$discard=, sH+14($pop98), $pop32
	i32.const	$push92=, 0
	i32.const	$push91=, 1103515245
	i32.mul 	$push33=, $5, $pop91
	i32.const	$push90=, 12345
	i32.add 	$push89=, $pop33, $pop90
	tee_local	$push88=, $5=, $pop89
	i32.const	$push87=, 16
	i32.shr_u	$push34=, $pop88, $pop87
	i32.store8	$discard=, sH+15($pop92), $pop34
	i32.const	$push86=, 0
	i32.const	$push85=, 1103515245
	i32.mul 	$push35=, $5, $pop85
	i32.const	$push84=, 12345
	i32.add 	$push83=, $pop35, $pop84
	tee_local	$push82=, $5=, $pop83
	i32.const	$push81=, 16
	i32.shr_u	$push80=, $pop82, $pop81
	tee_local	$push79=, $4=, $pop80
	i32.const	$push78=, 23
	i32.shl 	$push37=, $pop79, $pop78
	i32.const	$push77=, 0
	i32.load	$push76=, sH($pop77)
	tee_local	$push75=, $3=, $pop76
	i32.const	$push74=, 8388607
	i32.and 	$push73=, $pop75, $pop74
	tee_local	$push72=, $2=, $pop73
	i32.or  	$push38=, $pop37, $pop72
	i32.store	$1=, sH($pop86), $pop38
	i32.const	$push71=, 0
	i32.const	$push70=, 1103515245
	i32.mul 	$push36=, $5, $pop70
	i32.const	$push69=, 12345
	i32.add 	$push68=, $pop36, $pop69
	tee_local	$push67=, $5=, $pop68
	i32.store	$0=, myrnd.s($pop71), $pop67
	block
	i32.const	$push66=, 16
	i32.shr_u	$push65=, $5, $pop66
	tee_local	$push64=, $5=, $pop65
	i32.add 	$push42=, $pop64, $4
	i32.const	$push43=, 511
	i32.and 	$push44=, $pop42, $pop43
	i32.const	$push63=, 23
	i32.shl 	$push39=, $5, $pop63
	i32.add 	$push40=, $1, $pop39
	i32.const	$push62=, 23
	i32.shr_u	$push41=, $pop40, $pop62
	i32.ne  	$push45=, $pop44, $pop41
	br_if   	0, $pop45       # 0: down to label4
# BB#1:                                 # %if.end76
	i32.const	$push200=, 0
	i32.const	$push199=, 0
	i32.const	$push46=, -2139243339
	i32.mul 	$push47=, $0, $pop46
	i32.const	$push48=, -1492899873
	i32.add 	$push198=, $pop47, $pop48
	tee_local	$push197=, $5=, $pop198
	i32.const	$push196=, 1103515245
	i32.mul 	$push49=, $pop197, $pop196
	i32.const	$push195=, 12345
	i32.add 	$push50=, $pop49, $pop195
	i32.store	$push0=, myrnd.s($pop199), $pop50
	i32.const	$push194=, 16
	i32.shr_u	$push193=, $pop0, $pop194
	tee_local	$push192=, $4=, $pop193
	i32.const	$push191=, 23
	i32.shl 	$push53=, $pop192, $pop191
	i32.const	$push190=, 16
	i32.shr_u	$push189=, $5, $pop190
	tee_local	$push188=, $5=, $pop189
	i32.const	$push187=, 23
	i32.shl 	$push51=, $pop188, $pop187
	i32.or  	$push52=, $pop51, $2
	i32.add 	$push1=, $pop53, $pop52
	i32.store	$push186=, sH($pop200), $pop1
	tee_local	$push185=, $1=, $pop186
	i32.xor 	$push54=, $pop185, $3
	i32.const	$push184=, 8388607
	i32.and 	$push55=, $pop54, $pop184
	br_if   	0, $pop55       # 0: down to label4
# BB#2:                                 # %lor.lhs.false109
	i32.add 	$push58=, $4, $5
	i32.const	$push59=, 511
	i32.and 	$push60=, $pop58, $pop59
	i32.const	$push56=, 23
	i32.shr_u	$push57=, $1, $pop56
	i32.ne  	$push61=, $pop60, $pop57
	br_if   	0, $pop61       # 0: down to label4
# BB#3:                                 # %if.end115
	return
.LBB48_4:                               # %if.then114
	end_block                       # label4:
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
	i32.load16_u	$push1=, sI($pop0)
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
	i32.load16_u	$push1=, sI($pop0)
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
	i32.load16_u	$push1=, sI($pop0)
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
	i32.load16_u	$push13=, sI($pop14)
	tee_local	$push12=, $1=, $pop13
	i32.const	$push1=, 7
	i32.shr_u	$push2=, $pop12, $pop1
	i32.add 	$push11=, $pop2, $0
	tee_local	$push10=, $0=, $pop11
	i32.const	$push9=, 7
	i32.shl 	$push3=, $pop10, $pop9
	i32.const	$push4=, 127
	i32.and 	$push5=, $1, $pop4
	i32.or  	$push6=, $pop3, $pop5
	i32.store16	$discard=, sI($pop0), $pop6
	i32.const	$push7=, 511
	i32.and 	$push8=, $0, $pop7
	return  	$pop8
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
	i32.const	$push1=, 0
	i32.const	$push152=, 0
	i32.load	$push2=, myrnd.s($pop152)
	i32.const	$push3=, 1103515245
	i32.mul 	$push4=, $pop2, $pop3
	i32.const	$push5=, 12345
	i32.add 	$push151=, $pop4, $pop5
	tee_local	$push150=, $1=, $pop151
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop150, $pop6
	i32.store8	$discard=, sI($pop1), $pop7
	i32.const	$push149=, 0
	i32.const	$push148=, 1103515245
	i32.mul 	$push8=, $1, $pop148
	i32.const	$push147=, 12345
	i32.add 	$push146=, $pop8, $pop147
	tee_local	$push145=, $1=, $pop146
	i32.const	$push144=, 16
	i32.shr_u	$push9=, $pop145, $pop144
	i32.store8	$discard=, sI+1($pop149), $pop9
	i32.const	$push143=, 0
	i32.const	$push142=, 1103515245
	i32.mul 	$push10=, $1, $pop142
	i32.const	$push141=, 12345
	i32.add 	$push140=, $pop10, $pop141
	tee_local	$push139=, $1=, $pop140
	i32.const	$push138=, 16
	i32.shr_u	$push11=, $pop139, $pop138
	i32.store8	$discard=, sI+2($pop143), $pop11
	i32.const	$push137=, 0
	i32.const	$push136=, 1103515245
	i32.mul 	$push12=, $1, $pop136
	i32.const	$push135=, 12345
	i32.add 	$push134=, $pop12, $pop135
	tee_local	$push133=, $1=, $pop134
	i32.const	$push132=, 16
	i32.shr_u	$push13=, $pop133, $pop132
	i32.store8	$discard=, sI+3($pop137), $pop13
	i32.const	$push131=, 0
	i32.const	$push130=, 1103515245
	i32.mul 	$push14=, $1, $pop130
	i32.const	$push129=, 12345
	i32.add 	$push128=, $pop14, $pop129
	tee_local	$push127=, $1=, $pop128
	i32.const	$push126=, 16
	i32.shr_u	$push15=, $pop127, $pop126
	i32.store8	$discard=, sI+4($pop131), $pop15
	i32.const	$push125=, 0
	i32.const	$push124=, 1103515245
	i32.mul 	$push16=, $1, $pop124
	i32.const	$push123=, 12345
	i32.add 	$push122=, $pop16, $pop123
	tee_local	$push121=, $1=, $pop122
	i32.const	$push120=, 16
	i32.shr_u	$push17=, $pop121, $pop120
	i32.store8	$discard=, sI+5($pop125), $pop17
	i32.const	$push119=, 0
	i32.const	$push118=, 1103515245
	i32.mul 	$push18=, $1, $pop118
	i32.const	$push117=, 12345
	i32.add 	$push116=, $pop18, $pop117
	tee_local	$push115=, $1=, $pop116
	i32.const	$push114=, 16
	i32.shr_u	$push19=, $pop115, $pop114
	i32.store8	$discard=, sI+6($pop119), $pop19
	i32.const	$push113=, 0
	i32.const	$push112=, 1103515245
	i32.mul 	$push20=, $1, $pop112
	i32.const	$push111=, 12345
	i32.add 	$push110=, $pop20, $pop111
	tee_local	$push109=, $1=, $pop110
	i32.const	$push108=, 16
	i32.shr_u	$push21=, $pop109, $pop108
	i32.store8	$discard=, sI+7($pop113), $pop21
	i32.const	$push107=, 0
	i32.const	$push106=, 1103515245
	i32.mul 	$push22=, $1, $pop106
	i32.const	$push105=, 12345
	i32.add 	$push104=, $pop22, $pop105
	tee_local	$push103=, $1=, $pop104
	i32.const	$push102=, 16
	i32.shr_u	$push23=, $pop103, $pop102
	i32.store8	$discard=, sI+8($pop107), $pop23
	i32.const	$push101=, 0
	i32.const	$push100=, 1103515245
	i32.mul 	$push24=, $1, $pop100
	i32.const	$push99=, 12345
	i32.add 	$push98=, $pop24, $pop99
	tee_local	$push97=, $1=, $pop98
	i32.const	$push96=, 16
	i32.shr_u	$push25=, $pop97, $pop96
	i32.store8	$discard=, sI+9($pop101), $pop25
	i32.const	$push95=, 0
	i32.const	$push94=, 1103515245
	i32.mul 	$push26=, $1, $pop94
	i32.const	$push93=, 12345
	i32.add 	$push92=, $pop26, $pop93
	tee_local	$push91=, $1=, $pop92
	i32.const	$push90=, 16
	i32.shr_u	$push27=, $pop91, $pop90
	i32.store8	$discard=, sI+10($pop95), $pop27
	i32.const	$push89=, 0
	i32.const	$push88=, 1103515245
	i32.mul 	$push28=, $1, $pop88
	i32.const	$push87=, 12345
	i32.add 	$push86=, $pop28, $pop87
	tee_local	$push85=, $1=, $pop86
	i32.const	$push84=, 16
	i32.shr_u	$push29=, $pop85, $pop84
	i32.store8	$discard=, sI+11($pop89), $pop29
	i32.const	$push83=, 0
	i32.const	$push82=, 1103515245
	i32.mul 	$push30=, $1, $pop82
	i32.const	$push81=, 12345
	i32.add 	$push80=, $pop30, $pop81
	tee_local	$push79=, $1=, $pop80
	i32.const	$push78=, 16
	i32.shr_u	$push31=, $pop79, $pop78
	i32.store8	$discard=, sI+12($pop83), $pop31
	i32.const	$push77=, 0
	i32.const	$push76=, 1103515245
	i32.mul 	$push32=, $1, $pop76
	i32.const	$push75=, 12345
	i32.add 	$push74=, $pop32, $pop75
	tee_local	$push73=, $1=, $pop74
	i32.const	$push72=, 16
	i32.shr_u	$push33=, $pop73, $pop72
	i32.store8	$discard=, sI+13($pop77), $pop33
	i32.const	$push71=, 0
	i32.const	$push70=, 1103515245
	i32.mul 	$push34=, $1, $pop70
	i32.const	$push69=, 12345
	i32.add 	$push68=, $pop34, $pop69
	tee_local	$push67=, $1=, $pop68
	i32.const	$push66=, 16
	i32.shr_u	$push35=, $pop67, $pop66
	i32.store8	$discard=, sI+14($pop71), $pop35
	i32.const	$push65=, 0
	i32.const	$push64=, 1103515245
	i32.mul 	$push36=, $1, $pop64
	i32.const	$push63=, 12345
	i32.add 	$push62=, $pop36, $pop63
	tee_local	$push61=, $1=, $pop62
	i32.const	$push60=, 16
	i32.shr_u	$push37=, $pop61, $pop60
	i32.store8	$discard=, sI+15($pop65), $pop37
	i32.const	$push59=, 0
	i32.load16_u	$0=, sI($pop59)
	i32.const	$push58=, 0
	i32.const	$push57=, 0
	i32.const	$push38=, -341751747
	i32.mul 	$push39=, $1, $pop38
	i32.const	$push40=, 229283573
	i32.add 	$push56=, $pop39, $pop40
	tee_local	$push55=, $1=, $pop56
	i32.const	$push54=, 1103515245
	i32.mul 	$push42=, $pop55, $pop54
	i32.const	$push53=, 12345
	i32.add 	$push43=, $pop42, $pop53
	i32.store	$push0=, myrnd.s($pop57), $pop43
	i32.const	$push52=, 16
	i32.shr_u	$push44=, $pop0, $pop52
	i32.const	$push51=, 16
	i32.shr_u	$push41=, $1, $pop51
	i32.add 	$push47=, $pop44, $pop41
	i32.const	$push48=, 7
	i32.shl 	$push49=, $pop47, $pop48
	i32.const	$push45=, 127
	i32.and 	$push46=, $0, $pop45
	i32.or  	$push50=, $pop49, $pop46
	i32.store16	$discard=, sI($pop58), $pop50
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
	i32.load16_u	$push1=, sJ($pop0)
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
	i32.load16_u	$push1=, sJ($pop0)
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
	i32.load16_u	$push13=, sJ($pop14)
	tee_local	$push12=, $1=, $pop13
	i32.const	$push1=, 9
	i32.shr_u	$push2=, $pop12, $pop1
	i32.add 	$push11=, $pop2, $0
	tee_local	$push10=, $0=, $pop11
	i32.const	$push9=, 9
	i32.shl 	$push3=, $pop10, $pop9
	i32.const	$push4=, 511
	i32.and 	$push5=, $1, $pop4
	i32.or  	$push6=, $pop3, $pop5
	i32.store16	$discard=, sJ($pop0), $pop6
	i32.const	$push7=, 127
	i32.and 	$push8=, $0, $pop7
	return  	$pop8
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
	i32.const	$push78=, 0
	i32.const	$push77=, 0
	i32.load	$push1=, myrnd.s($pop77)
	i32.const	$push76=, 1103515245
	i32.mul 	$push2=, $pop1, $pop76
	i32.const	$push75=, 12345
	i32.add 	$push74=, $pop2, $pop75
	tee_local	$push73=, $1=, $pop74
	i32.const	$push72=, 16
	i32.shr_u	$push3=, $pop73, $pop72
	i32.store8	$discard=, sJ($pop78), $pop3
	i32.const	$push71=, 0
	i32.const	$push70=, 1103515245
	i32.mul 	$push4=, $1, $pop70
	i32.const	$push69=, 12345
	i32.add 	$push68=, $pop4, $pop69
	tee_local	$push67=, $1=, $pop68
	i32.const	$push66=, 16
	i32.shr_u	$push5=, $pop67, $pop66
	i32.store8	$discard=, sJ+1($pop71), $pop5
	i32.const	$push65=, 0
	i32.const	$push64=, 1103515245
	i32.mul 	$push6=, $1, $pop64
	i32.const	$push63=, 12345
	i32.add 	$push62=, $pop6, $pop63
	tee_local	$push61=, $1=, $pop62
	i32.const	$push60=, 16
	i32.shr_u	$push7=, $pop61, $pop60
	i32.store8	$discard=, sJ+2($pop65), $pop7
	i32.const	$push59=, 0
	i32.const	$push58=, 1103515245
	i32.mul 	$push8=, $1, $pop58
	i32.const	$push57=, 12345
	i32.add 	$push56=, $pop8, $pop57
	tee_local	$push55=, $1=, $pop56
	i32.const	$push54=, 16
	i32.shr_u	$push9=, $pop55, $pop54
	i32.store8	$discard=, sJ+3($pop59), $pop9
	i32.const	$push53=, 0
	i32.const	$push52=, 1103515245
	i32.mul 	$push11=, $1, $pop52
	i32.const	$push51=, 12345
	i32.add 	$push50=, $pop11, $pop51
	tee_local	$push49=, $3=, $pop50
	i32.const	$push48=, 16
	i32.shr_u	$push47=, $pop49, $pop48
	tee_local	$push46=, $2=, $pop47
	i32.const	$push45=, 9
	i32.shl 	$push13=, $pop46, $pop45
	i32.const	$push44=, 0
	i32.load16_u	$push10=, sJ($pop44)
	i32.const	$push43=, 511
	i32.and 	$push14=, $pop10, $pop43
	i32.or  	$push15=, $pop13, $pop14
	i32.store16	$discard=, sJ($pop53), $pop15
	i32.const	$push42=, 0
	i32.load	$1=, sJ($pop42)
	i32.const	$push41=, 0
	i32.const	$push40=, 1103515245
	i32.mul 	$push12=, $3, $pop40
	i32.const	$push39=, 12345
	i32.add 	$push38=, $pop12, $pop39
	tee_local	$push37=, $3=, $pop38
	i32.store	$0=, myrnd.s($pop41), $pop37
	block
	i32.const	$push36=, 16
	i32.shr_u	$push35=, $3, $pop36
	tee_local	$push34=, $3=, $pop35
	i32.add 	$push18=, $pop34, $2
	i32.const	$push33=, 9
	i32.shr_u	$push16=, $1, $pop33
	i32.add 	$push17=, $pop16, $3
	i32.xor 	$push19=, $pop18, $pop17
	i32.const	$push20=, 127
	i32.and 	$push21=, $pop19, $pop20
	br_if   	0, $pop21       # 0: down to label5
# BB#1:                                 # %if.end142
	i32.const	$push88=, 0
	i32.const	$push87=, 0
	i32.const	$push22=, -2139243339
	i32.mul 	$push23=, $0, $pop22
	i32.const	$push24=, -1492899873
	i32.add 	$push86=, $pop23, $pop24
	tee_local	$push85=, $3=, $pop86
	i32.const	$push84=, 1103515245
	i32.mul 	$push26=, $pop85, $pop84
	i32.const	$push83=, 12345
	i32.add 	$push27=, $pop26, $pop83
	i32.store	$push0=, myrnd.s($pop87), $pop27
	i32.const	$push82=, 16
	i32.shr_u	$push28=, $pop0, $pop82
	i32.const	$push81=, 16
	i32.shr_u	$push25=, $3, $pop81
	i32.add 	$push30=, $pop28, $pop25
	i32.const	$push80=, 9
	i32.shl 	$push31=, $pop30, $pop80
	i32.const	$push79=, 511
	i32.and 	$push29=, $1, $pop79
	i32.or  	$push32=, $pop31, $pop29
	i32.store16	$discard=, sJ($pop88), $pop32
	return
.LBB60_2:                               # %if.then
	end_block                       # label5:
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
	i32.load	$push9=, sK($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.add 	$push1=, $pop8, $0
	i32.const	$push2=, 63
	i32.and 	$push7=, $pop1, $pop2
	tee_local	$push6=, $0=, $pop7
	i32.const	$push3=, -64
	i32.and 	$push4=, $1, $pop3
	i32.or  	$push5=, $pop6, $pop4
	i32.store	$discard=, sK($pop0), $pop5
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
	i32.const	$push1=, 0
	i32.const	$push56=, 0
	i32.load	$push2=, myrnd.s($pop56)
	i32.const	$push3=, 1103515245
	i32.mul 	$push4=, $pop2, $pop3
	i32.const	$push5=, 12345
	i32.add 	$push55=, $pop4, $pop5
	tee_local	$push54=, $1=, $pop55
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop54, $pop6
	i32.store8	$discard=, sK($pop1), $pop7
	i32.const	$push53=, 0
	i32.const	$push52=, 1103515245
	i32.mul 	$push8=, $1, $pop52
	i32.const	$push51=, 12345
	i32.add 	$push50=, $pop8, $pop51
	tee_local	$push49=, $1=, $pop50
	i32.const	$push48=, 16
	i32.shr_u	$push9=, $pop49, $pop48
	i32.store8	$discard=, sK+1($pop53), $pop9
	i32.const	$push47=, 0
	i32.const	$push46=, 1103515245
	i32.mul 	$push10=, $1, $pop46
	i32.const	$push45=, 12345
	i32.add 	$push44=, $pop10, $pop45
	tee_local	$push43=, $1=, $pop44
	i32.const	$push42=, 16
	i32.shr_u	$push11=, $pop43, $pop42
	i32.store8	$discard=, sK+2($pop47), $pop11
	i32.const	$push41=, 0
	i32.const	$push40=, 1103515245
	i32.mul 	$push12=, $1, $pop40
	i32.const	$push39=, 12345
	i32.add 	$push38=, $pop12, $pop39
	tee_local	$push37=, $1=, $pop38
	i32.const	$push36=, 16
	i32.shr_u	$push13=, $pop37, $pop36
	i32.store8	$discard=, sK+3($pop41), $pop13
	i32.const	$push35=, 0
	i32.load	$0=, sK($pop35)
	i32.const	$push34=, 0
	i32.const	$push33=, 0
	i32.const	$push16=, -341751747
	i32.mul 	$push17=, $1, $pop16
	i32.const	$push18=, 229283573
	i32.add 	$push32=, $pop17, $pop18
	tee_local	$push31=, $1=, $pop32
	i32.const	$push30=, 1103515245
	i32.mul 	$push20=, $pop31, $pop30
	i32.const	$push29=, 12345
	i32.add 	$push21=, $pop20, $pop29
	i32.store	$push0=, myrnd.s($pop33), $pop21
	i32.const	$push28=, 16
	i32.shr_u	$push22=, $pop0, $pop28
	i32.const	$push27=, 16
	i32.shr_u	$push19=, $1, $pop27
	i32.add 	$push23=, $pop22, $pop19
	i32.const	$push24=, 63
	i32.and 	$push25=, $pop23, $pop24
	i32.const	$push14=, -64
	i32.and 	$push15=, $0, $pop14
	i32.or  	$push26=, $pop25, $pop15
	i32.store	$discard=, sK($pop34), $pop26
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
	i32.load	$push1=, sL($pop0)
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
	i32.load	$push1=, sL($pop0)
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
	i32.load	$push1=, sL($pop0)
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
	i32.load	$push9=, sL($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.add 	$push1=, $pop8, $0
	i32.const	$push2=, 63
	i32.and 	$push7=, $pop1, $pop2
	tee_local	$push6=, $0=, $pop7
	i32.const	$push3=, -64
	i32.and 	$push4=, $1, $pop3
	i32.or  	$push5=, $pop6, $pop4
	i32.store	$discard=, sL($pop0), $pop5
	return  	$0
	.endfunc
.Lfunc_end71:
	.size	fn3L, .Lfunc_end71-fn3L

	.section	.text.testL,"ax",@progbits
	.hidden	testL
	.globl	testL
	.type	testL,@function
testL:                                  # @testL
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push107=, 0
	i32.const	$push106=, 0
	i32.load	$push1=, myrnd.s($pop106)
	i32.const	$push105=, 1103515245
	i32.mul 	$push2=, $pop1, $pop105
	i32.const	$push104=, 12345
	i32.add 	$push103=, $pop2, $pop104
	tee_local	$push102=, $4=, $pop103
	i32.const	$push101=, 16
	i32.shr_u	$push3=, $pop102, $pop101
	i32.store8	$discard=, sL($pop107), $pop3
	i32.const	$push100=, 0
	i32.const	$push99=, 1103515245
	i32.mul 	$push4=, $4, $pop99
	i32.const	$push98=, 12345
	i32.add 	$push97=, $pop4, $pop98
	tee_local	$push96=, $4=, $pop97
	i32.const	$push95=, 16
	i32.shr_u	$push5=, $pop96, $pop95
	i32.store8	$discard=, sL+1($pop100), $pop5
	i32.const	$push94=, 0
	i32.const	$push93=, 1103515245
	i32.mul 	$push6=, $4, $pop93
	i32.const	$push92=, 12345
	i32.add 	$push91=, $pop6, $pop92
	tee_local	$push90=, $4=, $pop91
	i32.const	$push89=, 16
	i32.shr_u	$push7=, $pop90, $pop89
	i32.store8	$discard=, sL+2($pop94), $pop7
	i32.const	$push88=, 0
	i32.const	$push87=, 1103515245
	i32.mul 	$push8=, $4, $pop87
	i32.const	$push86=, 12345
	i32.add 	$push85=, $pop8, $pop86
	tee_local	$push84=, $4=, $pop85
	i32.const	$push83=, 16
	i32.shr_u	$push9=, $pop84, $pop83
	i32.store8	$discard=, sL+3($pop88), $pop9
	i32.const	$push82=, 0
	i32.const	$push81=, 1103515245
	i32.mul 	$push10=, $4, $pop81
	i32.const	$push80=, 12345
	i32.add 	$push79=, $pop10, $pop80
	tee_local	$push78=, $4=, $pop79
	i32.const	$push77=, 16
	i32.shr_u	$push11=, $pop78, $pop77
	i32.store8	$discard=, sL+4($pop82), $pop11
	i32.const	$push76=, 0
	i32.const	$push75=, 1103515245
	i32.mul 	$push12=, $4, $pop75
	i32.const	$push74=, 12345
	i32.add 	$push73=, $pop12, $pop74
	tee_local	$push72=, $4=, $pop73
	i32.const	$push71=, 16
	i32.shr_u	$push13=, $pop72, $pop71
	i32.store8	$discard=, sL+5($pop76), $pop13
	i32.const	$push70=, 0
	i32.const	$push69=, 1103515245
	i32.mul 	$push14=, $4, $pop69
	i32.const	$push68=, 12345
	i32.add 	$push67=, $pop14, $pop68
	tee_local	$push66=, $4=, $pop67
	i32.const	$push65=, 16
	i32.shr_u	$push15=, $pop66, $pop65
	i32.store8	$discard=, sL+6($pop70), $pop15
	i32.const	$push64=, 0
	i32.const	$push63=, 1103515245
	i32.mul 	$push16=, $4, $pop63
	i32.const	$push62=, 12345
	i32.add 	$push61=, $pop16, $pop62
	tee_local	$push60=, $4=, $pop61
	i32.const	$push59=, 16
	i32.shr_u	$push17=, $pop60, $pop59
	i32.store8	$discard=, sL+7($pop64), $pop17
	i32.const	$push58=, 0
	i32.load	$2=, sL($pop58)
	i32.const	$push57=, 0
	i32.const	$push56=, 1103515245
	i32.mul 	$push18=, $4, $pop56
	i32.const	$push55=, 12345
	i32.add 	$push54=, $pop18, $pop55
	tee_local	$push53=, $4=, $pop54
	i32.const	$push52=, 1103515245
	i32.mul 	$push19=, $pop53, $pop52
	i32.const	$push51=, 12345
	i32.add 	$push50=, $pop19, $pop51
	tee_local	$push49=, $3=, $pop50
	i32.store	$0=, myrnd.s($pop57), $pop49
	i32.const	$push48=, 0
	i32.const	$push47=, 16
	i32.shr_u	$push46=, $4, $pop47
	tee_local	$push45=, $4=, $pop46
	i32.const	$push44=, 63
	i32.and 	$push20=, $pop45, $pop44
	i32.const	$push43=, -64
	i32.and 	$push21=, $2, $pop43
	i32.or  	$push42=, $pop20, $pop21
	tee_local	$push41=, $2=, $pop42
	i32.store	$1=, sL($pop48), $pop41
	block
	i32.const	$push40=, 16
	i32.shr_u	$push39=, $3, $pop40
	tee_local	$push38=, $3=, $pop39
	i32.add 	$push23=, $pop38, $4
	i32.add 	$push22=, $2, $3
	i32.xor 	$push24=, $pop23, $pop22
	i32.const	$push37=, 63
	i32.and 	$push25=, $pop24, $pop37
	br_if   	0, $pop25       # 0: down to label6
# BB#1:                                 # %if.end75
	i32.const	$push117=, 0
	i32.const	$push116=, 0
	i32.const	$push27=, -2139243339
	i32.mul 	$push28=, $0, $pop27
	i32.const	$push29=, -1492899873
	i32.add 	$push115=, $pop28, $pop29
	tee_local	$push114=, $4=, $pop115
	i32.const	$push113=, 1103515245
	i32.mul 	$push31=, $pop114, $pop113
	i32.const	$push112=, 12345
	i32.add 	$push32=, $pop31, $pop112
	i32.store	$push0=, myrnd.s($pop116), $pop32
	i32.const	$push111=, 16
	i32.shr_u	$push33=, $pop0, $pop111
	i32.const	$push110=, 16
	i32.shr_u	$push30=, $4, $pop110
	i32.add 	$push34=, $pop33, $pop30
	i32.const	$push109=, 63
	i32.and 	$push35=, $pop34, $pop109
	i32.const	$push108=, -64
	i32.and 	$push26=, $1, $pop108
	i32.or  	$push36=, $pop35, $pop26
	i32.store	$discard=, sL($pop117), $pop36
	return
.LBB72_2:                               # %if.then
	end_block                       # label6:
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
	i32.load	$push9=, sM+4($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.add 	$push1=, $pop8, $0
	i32.const	$push2=, 63
	i32.and 	$push7=, $pop1, $pop2
	tee_local	$push6=, $0=, $pop7
	i32.const	$push3=, -64
	i32.and 	$push4=, $1, $pop3
	i32.or  	$push5=, $pop6, $pop4
	i32.store	$discard=, sM+4($pop0), $pop5
	return  	$0
	.endfunc
.Lfunc_end77:
	.size	fn3M, .Lfunc_end77-fn3M

	.section	.text.testM,"ax",@progbits
	.hidden	testM
	.globl	testM
	.type	testM,@function
testM:                                  # @testM
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push106=, 0
	i32.const	$push105=, 0
	i32.load	$push1=, myrnd.s($pop105)
	i32.const	$push104=, 1103515245
	i32.mul 	$push2=, $pop1, $pop104
	i32.const	$push103=, 12345
	i32.add 	$push102=, $pop2, $pop103
	tee_local	$push101=, $4=, $pop102
	i32.const	$push100=, 16
	i32.shr_u	$push3=, $pop101, $pop100
	i32.store8	$discard=, sM($pop106), $pop3
	i32.const	$push99=, 0
	i32.const	$push98=, 1103515245
	i32.mul 	$push4=, $4, $pop98
	i32.const	$push97=, 12345
	i32.add 	$push96=, $pop4, $pop97
	tee_local	$push95=, $4=, $pop96
	i32.const	$push94=, 16
	i32.shr_u	$push5=, $pop95, $pop94
	i32.store8	$discard=, sM+1($pop99), $pop5
	i32.const	$push93=, 0
	i32.const	$push92=, 1103515245
	i32.mul 	$push6=, $4, $pop92
	i32.const	$push91=, 12345
	i32.add 	$push90=, $pop6, $pop91
	tee_local	$push89=, $4=, $pop90
	i32.const	$push88=, 16
	i32.shr_u	$push7=, $pop89, $pop88
	i32.store8	$discard=, sM+2($pop93), $pop7
	i32.const	$push87=, 0
	i32.const	$push86=, 1103515245
	i32.mul 	$push8=, $4, $pop86
	i32.const	$push85=, 12345
	i32.add 	$push84=, $pop8, $pop85
	tee_local	$push83=, $4=, $pop84
	i32.const	$push82=, 1103515245
	i32.mul 	$push10=, $pop83, $pop82
	i32.const	$push81=, 12345
	i32.add 	$push80=, $pop10, $pop81
	tee_local	$push79=, $3=, $pop80
	i32.const	$push78=, 16
	i32.shr_u	$push11=, $pop79, $pop78
	i32.store8	$discard=, sM+4($pop87), $pop11
	i32.const	$push77=, 0
	i32.const	$push76=, 1103515245
	i32.mul 	$push12=, $3, $pop76
	i32.const	$push75=, 12345
	i32.add 	$push74=, $pop12, $pop75
	tee_local	$push73=, $3=, $pop74
	i32.const	$push72=, 16
	i32.shr_u	$push13=, $pop73, $pop72
	i32.store8	$discard=, sM+5($pop77), $pop13
	i32.const	$push71=, 0
	i32.const	$push70=, 1103515245
	i32.mul 	$push14=, $3, $pop70
	i32.const	$push69=, 12345
	i32.add 	$push68=, $pop14, $pop69
	tee_local	$push67=, $3=, $pop68
	i32.const	$push66=, 16
	i32.shr_u	$push15=, $pop67, $pop66
	i32.store8	$discard=, sM+6($pop71), $pop15
	i32.const	$push65=, 0
	i32.const	$push64=, 1103515245
	i32.mul 	$push16=, $3, $pop64
	i32.const	$push63=, 12345
	i32.add 	$push62=, $pop16, $pop63
	tee_local	$push61=, $3=, $pop62
	i32.const	$push60=, 16
	i32.shr_u	$push17=, $pop61, $pop60
	i32.store8	$discard=, sM+7($pop65), $pop17
	i32.const	$push59=, 0
	i32.load	$1=, sM+4($pop59)
	i32.const	$push58=, 0
	i32.const	$push57=, 16
	i32.shr_u	$push9=, $4, $pop57
	i32.store8	$discard=, sM+3($pop58), $pop9
	i32.const	$push56=, 0
	i32.const	$push55=, 1103515245
	i32.mul 	$push18=, $3, $pop55
	i32.const	$push54=, 12345
	i32.add 	$push53=, $pop18, $pop54
	tee_local	$push52=, $4=, $pop53
	i32.const	$push51=, 16
	i32.shr_u	$push50=, $pop52, $pop51
	tee_local	$push49=, $3=, $pop50
	i32.const	$push48=, 63
	i32.and 	$push20=, $pop49, $pop48
	i32.const	$push21=, -64
	i32.and 	$push47=, $1, $pop21
	tee_local	$push46=, $2=, $pop47
	i32.or  	$push22=, $pop20, $pop46
	i32.store	$1=, sM+4($pop56), $pop22
	i32.const	$push45=, 0
	i32.const	$push44=, 1103515245
	i32.mul 	$push19=, $4, $pop44
	i32.const	$push43=, 12345
	i32.add 	$push42=, $pop19, $pop43
	tee_local	$push41=, $4=, $pop42
	i32.store	$0=, myrnd.s($pop45), $pop41
	block
	i32.const	$push40=, 16
	i32.shr_u	$push39=, $4, $pop40
	tee_local	$push38=, $4=, $pop39
	i32.add 	$push23=, $1, $pop38
	i32.add 	$push24=, $4, $3
	i32.xor 	$push25=, $pop23, $pop24
	i32.const	$push37=, 63
	i32.and 	$push26=, $pop25, $pop37
	br_if   	0, $pop26       # 0: down to label7
# BB#1:                                 # %if.end79
	i32.const	$push115=, 0
	i32.const	$push114=, 0
	i32.const	$push27=, -2139243339
	i32.mul 	$push28=, $0, $pop27
	i32.const	$push29=, -1492899873
	i32.add 	$push113=, $pop28, $pop29
	tee_local	$push112=, $4=, $pop113
	i32.const	$push111=, 1103515245
	i32.mul 	$push31=, $pop112, $pop111
	i32.const	$push110=, 12345
	i32.add 	$push32=, $pop31, $pop110
	i32.store	$push0=, myrnd.s($pop114), $pop32
	i32.const	$push109=, 16
	i32.shr_u	$push33=, $pop0, $pop109
	i32.const	$push108=, 16
	i32.shr_u	$push30=, $4, $pop108
	i32.add 	$push34=, $pop33, $pop30
	i32.const	$push107=, 63
	i32.and 	$push35=, $pop34, $pop107
	i32.or  	$push36=, $pop35, $2
	i32.store	$discard=, sM+4($pop115), $pop36
	return
.LBB78_2:                               # %if.then
	end_block                       # label7:
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
	i32.load	$push1=, sN($pop0)
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
	i32.load	$push1=, sN($pop0)
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
	i32.load	$push1=, sN($pop0)
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
	i64.load	$push17=, sN($pop18)
	tee_local	$push16=, $1=, $pop17
	i64.const	$push1=, 6
	i64.shr_u	$push2=, $pop16, $pop1
	i32.wrap/i64	$push3=, $pop2
	i32.add 	$push15=, $pop3, $0
	tee_local	$push14=, $0=, $pop15
	i32.const	$push4=, 6
	i32.shl 	$push5=, $pop14, $pop4
	i64.extend_u/i32	$push6=, $pop5
	i64.const	$push7=, 4032
	i64.and 	$push8=, $pop6, $pop7
	i64.const	$push9=, -4033
	i64.and 	$push10=, $1, $pop9
	i64.or  	$push11=, $pop8, $pop10
	i64.store	$discard=, sN($pop0), $pop11
	i32.const	$push12=, 63
	i32.and 	$push13=, $0, $pop12
	return  	$pop13
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
	i32.const	$push5=, 0
	i32.const	$push167=, 0
	i32.load	$push6=, myrnd.s($pop167)
	i32.const	$push7=, 1103515245
	i32.mul 	$push8=, $pop6, $pop7
	i32.const	$push9=, 12345
	i32.add 	$push166=, $pop8, $pop9
	tee_local	$push165=, $5=, $pop166
	i32.const	$push164=, 16
	i32.shr_u	$push10=, $pop165, $pop164
	i32.store8	$discard=, sN($pop5), $pop10
	i32.const	$push163=, 0
	i32.const	$push162=, 1103515245
	i32.mul 	$push11=, $5, $pop162
	i32.const	$push161=, 12345
	i32.add 	$push160=, $pop11, $pop161
	tee_local	$push159=, $5=, $pop160
	i32.const	$push158=, 16
	i32.shr_u	$push12=, $pop159, $pop158
	i32.store8	$discard=, sN+1($pop163), $pop12
	i32.const	$push157=, 0
	i32.const	$push156=, 1103515245
	i32.mul 	$push13=, $5, $pop156
	i32.const	$push155=, 12345
	i32.add 	$push154=, $pop13, $pop155
	tee_local	$push153=, $5=, $pop154
	i32.const	$push152=, 16
	i32.shr_u	$push14=, $pop153, $pop152
	i32.store8	$discard=, sN+2($pop157), $pop14
	i32.const	$push151=, 0
	i32.const	$push150=, 1103515245
	i32.mul 	$push15=, $5, $pop150
	i32.const	$push149=, 12345
	i32.add 	$push148=, $pop15, $pop149
	tee_local	$push147=, $5=, $pop148
	i32.const	$push146=, 16
	i32.shr_u	$push16=, $pop147, $pop146
	i32.store8	$discard=, sN+3($pop151), $pop16
	i32.const	$push145=, 0
	i32.const	$push144=, 1103515245
	i32.mul 	$push17=, $5, $pop144
	i32.const	$push143=, 12345
	i32.add 	$push142=, $pop17, $pop143
	tee_local	$push141=, $5=, $pop142
	i32.const	$push140=, 16
	i32.shr_u	$push18=, $pop141, $pop140
	i32.store8	$discard=, sN+4($pop145), $pop18
	i32.const	$push139=, 0
	i32.const	$push138=, 1103515245
	i32.mul 	$push19=, $5, $pop138
	i32.const	$push137=, 12345
	i32.add 	$push136=, $pop19, $pop137
	tee_local	$push135=, $5=, $pop136
	i32.const	$push134=, 16
	i32.shr_u	$push20=, $pop135, $pop134
	i32.store8	$discard=, sN+5($pop139), $pop20
	i32.const	$push133=, 0
	i32.const	$push132=, 1103515245
	i32.mul 	$push21=, $5, $pop132
	i32.const	$push131=, 12345
	i32.add 	$push130=, $pop21, $pop131
	tee_local	$push129=, $5=, $pop130
	i32.const	$push128=, 16
	i32.shr_u	$push22=, $pop129, $pop128
	i32.store8	$discard=, sN+6($pop133), $pop22
	i32.const	$push127=, 0
	i32.const	$push126=, 1103515245
	i32.mul 	$push23=, $5, $pop126
	i32.const	$push125=, 12345
	i32.add 	$push124=, $pop23, $pop125
	tee_local	$push123=, $5=, $pop124
	i32.const	$push122=, 16
	i32.shr_u	$push24=, $pop123, $pop122
	i32.store8	$discard=, sN+7($pop127), $pop24
	i32.const	$push121=, 0
	i32.const	$push120=, 1103515245
	i32.mul 	$push27=, $5, $pop120
	i32.const	$push119=, 12345
	i32.add 	$push118=, $pop27, $pop119
	tee_local	$push117=, $5=, $pop118
	i32.const	$push116=, 1103515245
	i32.mul 	$push28=, $pop117, $pop116
	i32.const	$push115=, 12345
	i32.add 	$push1=, $pop28, $pop115
	i32.store	$0=, myrnd.s($pop121), $pop1
	block
	i32.const	$push114=, 0
	i32.const	$push29=, 10
	i32.shr_u	$push30=, $5, $pop29
	i64.extend_u/i32	$push31=, $pop30
	i64.const	$push25=, 4032
	i64.and 	$push32=, $pop31, $pop25
	i32.const	$push113=, 0
	i64.load	$push112=, sN($pop113)
	tee_local	$push111=, $4=, $pop112
	i64.const	$push33=, -4033
	i64.and 	$push110=, $pop111, $pop33
	tee_local	$push109=, $3=, $pop110
	i64.or  	$push2=, $pop32, $pop109
	i64.store	$push108=, sN($pop114), $pop2
	tee_local	$push107=, $2=, $pop108
	i64.const	$push106=, 4032
	i64.or  	$push26=, $4, $pop106
	i64.xor 	$push105=, $pop107, $pop26
	tee_local	$push104=, $4=, $pop105
	i64.const	$push36=, 34359734272
	i64.and 	$push37=, $pop104, $pop36
	i64.const	$push103=, 0
	i64.ne  	$push38=, $pop37, $pop103
	br_if   	0, $pop38       # 0: down to label8
# BB#1:                                 # %lor.lhs.false29
	i64.const	$push42=, 63
	i64.and 	$push43=, $4, $pop42
	i64.const	$push168=, 0
	i64.ne  	$push44=, $pop43, $pop168
	br_if   	0, $pop44       # 0: down to label8
# BB#2:                                 # %lor.lhs.false29
	i64.const	$push34=, 6
	i64.shr_u	$push35=, $2, $pop34
	i32.wrap/i64	$push173=, $pop35
	tee_local	$push172=, $6=, $pop173
	i32.const	$push171=, 16
	i32.shr_u	$push170=, $5, $pop171
	tee_local	$push169=, $5=, $pop170
	i32.xor 	$push40=, $pop172, $pop169
	i32.const	$push41=, 63
	i32.and 	$push39=, $pop40, $pop41
	br_if   	0, $pop39       # 0: down to label8
# BB#3:                                 # %lor.lhs.false49
	i32.const	$push177=, 16
	i32.shr_u	$push176=, $0, $pop177
	tee_local	$push175=, $7=, $pop176
	i32.add 	$push3=, $6, $pop175
	i32.add 	$push45=, $7, $5
	i32.xor 	$push46=, $pop3, $pop45
	i32.const	$push174=, 63
	i32.and 	$push47=, $pop46, $pop174
	br_if   	0, $pop47       # 0: down to label8
# BB#4:                                 # %lor.lhs.false69
	i32.const	$push52=, 0
	i32.const	$push48=, 1103515245
	i32.mul 	$push49=, $0, $pop48
	i32.const	$push50=, 12345
	i32.add 	$push193=, $pop49, $pop50
	tee_local	$push192=, $5=, $pop193
	i32.const	$push191=, 1103515245
	i32.mul 	$push51=, $pop192, $pop191
	i32.const	$push190=, 12345
	i32.add 	$push4=, $pop51, $pop190
	i32.store	$0=, myrnd.s($pop52), $pop4
	i32.const	$push189=, 0
	i32.const	$push53=, 10
	i32.shr_u	$push54=, $5, $pop53
	i64.extend_u/i32	$push55=, $pop54
	i64.const	$push56=, 4032
	i64.and 	$push57=, $pop55, $pop56
	i64.or  	$push58=, $pop57, $3
	i64.store	$push188=, sN($pop189), $pop58
	tee_local	$push187=, $4=, $pop188
	i64.const	$push59=, 6
	i64.shr_u	$push60=, $pop187, $pop59
	i32.wrap/i64	$push186=, $pop60
	tee_local	$push185=, $6=, $pop186
	i32.const	$push184=, 16
	i32.shr_u	$push183=, $0, $pop184
	tee_local	$push182=, $7=, $pop183
	i32.add 	$push61=, $pop185, $pop182
	i32.const	$push181=, 63
	i32.and 	$push62=, $pop61, $pop181
	i32.const	$push63=, 15
	i32.rem_u	$1=, $pop62, $pop63
	i64.xor 	$push180=, $4, $2
	tee_local	$push179=, $2=, $pop180
	i64.const	$push64=, 34359734272
	i64.and 	$push65=, $pop179, $pop64
	i64.const	$push178=, 0
	i64.ne  	$push66=, $pop65, $pop178
	br_if   	0, $pop66       # 0: down to label8
# BB#5:                                 # %lor.lhs.false80
	i64.const	$push70=, 63
	i64.and 	$push71=, $2, $pop70
	i64.const	$push194=, 0
	i64.ne  	$push72=, $pop71, $pop194
	br_if   	0, $pop72       # 0: down to label8
# BB#6:                                 # %lor.lhs.false80
	i32.const	$push197=, 16
	i32.shr_u	$push196=, $5, $pop197
	tee_local	$push195=, $5=, $pop196
	i32.xor 	$push68=, $6, $pop195
	i32.const	$push69=, 63
	i32.and 	$push67=, $pop68, $pop69
	br_if   	0, $pop67       # 0: down to label8
# BB#7:                                 # %lor.lhs.false100
	i32.add 	$push73=, $7, $5
	i32.const	$push198=, 63
	i32.and 	$push74=, $pop73, $pop198
	i32.const	$push75=, 15
	i32.rem_u	$push76=, $pop74, $pop75
	i32.ne  	$push77=, $pop76, $1
	br_if   	0, $pop77       # 0: down to label8
# BB#8:                                 # %lor.lhs.false125
	i32.const	$push85=, 0
	i32.const	$push78=, 1103515245
	i32.mul 	$push79=, $0, $pop78
	i32.const	$push80=, 12345
	i32.add 	$push210=, $pop79, $pop80
	tee_local	$push209=, $5=, $pop210
	i32.const	$push86=, 10
	i32.shr_u	$push87=, $pop209, $pop86
	i64.extend_u/i32	$push88=, $pop87
	i64.const	$push89=, 4032
	i64.and 	$push90=, $pop88, $pop89
	i64.or  	$push91=, $pop90, $3
	i64.const	$push92=, 6
	i64.shr_u	$push93=, $pop91, $pop92
	i32.wrap/i64	$push94=, $pop93
	i32.const	$push208=, 0
	i32.const	$push207=, 1103515245
	i32.mul 	$push83=, $5, $pop207
	i32.const	$push206=, 12345
	i32.add 	$push84=, $pop83, $pop206
	i32.store	$push0=, myrnd.s($pop208), $pop84
	i32.const	$push81=, 16
	i32.shr_u	$push205=, $pop0, $pop81
	tee_local	$push204=, $0=, $pop205
	i32.add 	$push203=, $pop94, $pop204
	tee_local	$push202=, $6=, $pop203
	i32.const	$push95=, 6
	i32.shl 	$push96=, $pop202, $pop95
	i64.extend_u/i32	$push97=, $pop96
	i64.const	$push201=, 4032
	i64.and 	$push98=, $pop97, $pop201
	i64.or  	$push99=, $pop98, $3
	i64.store	$discard=, sN($pop85), $pop99
	i32.const	$push200=, 16
	i32.shr_u	$push82=, $5, $pop200
	i32.add 	$push100=, $0, $pop82
	i32.xor 	$push101=, $pop100, $6
	i32.const	$push199=, 63
	i32.and 	$push102=, $pop101, $pop199
	br_if   	0, $pop102      # 0: down to label8
# BB#9:                                 # %if.end158
	return
.LBB84_10:                              # %if.then157
	end_block                       # label8:
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
	i32.load	$push1=, sO+8($pop0)
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
	i32.load	$push1=, sO+8($pop0)
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
	i32.load	$push1=, sO+8($pop0)
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
	i64.load	$push13=, sO+8($pop14)
	tee_local	$push12=, $1=, $pop13
	i32.wrap/i64	$push1=, $pop12
	i32.add 	$push11=, $pop1, $0
	tee_local	$push10=, $0=, $pop11
	i64.extend_u/i32	$push2=, $pop10
	i64.const	$push3=, 4095
	i64.and 	$push4=, $pop2, $pop3
	i64.const	$push5=, -4096
	i64.and 	$push6=, $1, $pop5
	i64.or  	$push7=, $pop4, $pop6
	i64.store	$discard=, sO+8($pop0), $pop7
	i32.const	$push8=, 4095
	i32.and 	$push9=, $0, $pop8
	return  	$pop9
	.endfunc
.Lfunc_end89:
	.size	fn3O, .Lfunc_end89-fn3O

	.section	.text.testO,"ax",@progbits
	.hidden	testO
	.globl	testO
	.type	testO,@function
testO:                                  # @testO
	.local  	i32, i64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push204=, 0
	i32.load	$push8=, myrnd.s($pop204)
	i32.const	$push9=, 1103515245
	i32.mul 	$push10=, $pop8, $pop9
	i32.const	$push11=, 12345
	i32.add 	$push203=, $pop10, $pop11
	tee_local	$push202=, $2=, $pop203
	i32.const	$push201=, 16
	i32.shr_u	$push12=, $pop202, $pop201
	i32.store8	$discard=, sO($pop7), $pop12
	i32.const	$push200=, 0
	i32.const	$push199=, 1103515245
	i32.mul 	$push13=, $2, $pop199
	i32.const	$push198=, 12345
	i32.add 	$push197=, $pop13, $pop198
	tee_local	$push196=, $2=, $pop197
	i32.const	$push195=, 16
	i32.shr_u	$push14=, $pop196, $pop195
	i32.store8	$discard=, sO+1($pop200), $pop14
	i32.const	$push194=, 0
	i32.const	$push193=, 1103515245
	i32.mul 	$push15=, $2, $pop193
	i32.const	$push192=, 12345
	i32.add 	$push191=, $pop15, $pop192
	tee_local	$push190=, $2=, $pop191
	i32.const	$push189=, 16
	i32.shr_u	$push16=, $pop190, $pop189
	i32.store8	$discard=, sO+2($pop194), $pop16
	i32.const	$push188=, 0
	i32.const	$push187=, 1103515245
	i32.mul 	$push17=, $2, $pop187
	i32.const	$push186=, 12345
	i32.add 	$push185=, $pop17, $pop186
	tee_local	$push184=, $2=, $pop185
	i32.const	$push183=, 16
	i32.shr_u	$push18=, $pop184, $pop183
	i32.store8	$discard=, sO+3($pop188), $pop18
	i32.const	$push182=, 0
	i32.const	$push181=, 1103515245
	i32.mul 	$push19=, $2, $pop181
	i32.const	$push180=, 12345
	i32.add 	$push179=, $pop19, $pop180
	tee_local	$push178=, $2=, $pop179
	i32.const	$push177=, 16
	i32.shr_u	$push20=, $pop178, $pop177
	i32.store8	$discard=, sO+4($pop182), $pop20
	i32.const	$push176=, 0
	i32.const	$push175=, 1103515245
	i32.mul 	$push21=, $2, $pop175
	i32.const	$push174=, 12345
	i32.add 	$push173=, $pop21, $pop174
	tee_local	$push172=, $2=, $pop173
	i32.const	$push171=, 16
	i32.shr_u	$push22=, $pop172, $pop171
	i32.store8	$discard=, sO+5($pop176), $pop22
	i32.const	$push170=, 0
	i32.const	$push169=, 1103515245
	i32.mul 	$push23=, $2, $pop169
	i32.const	$push168=, 12345
	i32.add 	$push167=, $pop23, $pop168
	tee_local	$push166=, $2=, $pop167
	i32.const	$push165=, 16
	i32.shr_u	$push24=, $pop166, $pop165
	i32.store8	$discard=, sO+6($pop170), $pop24
	i32.const	$push164=, 0
	i32.const	$push163=, 1103515245
	i32.mul 	$push25=, $2, $pop163
	i32.const	$push162=, 12345
	i32.add 	$push161=, $pop25, $pop162
	tee_local	$push160=, $2=, $pop161
	i32.const	$push159=, 16
	i32.shr_u	$push26=, $pop160, $pop159
	i32.store8	$discard=, sO+7($pop164), $pop26
	i32.const	$push158=, 0
	i32.const	$push157=, 1103515245
	i32.mul 	$push27=, $2, $pop157
	i32.const	$push156=, 12345
	i32.add 	$push155=, $pop27, $pop156
	tee_local	$push154=, $2=, $pop155
	i32.const	$push153=, 16
	i32.shr_u	$push28=, $pop154, $pop153
	i32.store8	$discard=, sO+8($pop158), $pop28
	i32.const	$push152=, 0
	i32.const	$push151=, 1103515245
	i32.mul 	$push29=, $2, $pop151
	i32.const	$push150=, 12345
	i32.add 	$push149=, $pop29, $pop150
	tee_local	$push148=, $2=, $pop149
	i32.const	$push147=, 16
	i32.shr_u	$push30=, $pop148, $pop147
	i32.store8	$discard=, sO+9($pop152), $pop30
	i32.const	$push146=, 0
	i32.const	$push145=, 1103515245
	i32.mul 	$push31=, $2, $pop145
	i32.const	$push144=, 12345
	i32.add 	$push143=, $pop31, $pop144
	tee_local	$push142=, $2=, $pop143
	i32.const	$push141=, 16
	i32.shr_u	$push32=, $pop142, $pop141
	i32.store8	$discard=, sO+10($pop146), $pop32
	i32.const	$push140=, 0
	i32.const	$push139=, 1103515245
	i32.mul 	$push33=, $2, $pop139
	i32.const	$push138=, 12345
	i32.add 	$push137=, $pop33, $pop138
	tee_local	$push136=, $2=, $pop137
	i32.const	$push135=, 16
	i32.shr_u	$push34=, $pop136, $pop135
	i32.store8	$discard=, sO+11($pop140), $pop34
	i32.const	$push134=, 0
	i32.const	$push133=, 1103515245
	i32.mul 	$push35=, $2, $pop133
	i32.const	$push132=, 12345
	i32.add 	$push131=, $pop35, $pop132
	tee_local	$push130=, $2=, $pop131
	i32.const	$push129=, 16
	i32.shr_u	$push36=, $pop130, $pop129
	i32.store8	$discard=, sO+12($pop134), $pop36
	i32.const	$push128=, 0
	i32.const	$push127=, 1103515245
	i32.mul 	$push37=, $2, $pop127
	i32.const	$push126=, 12345
	i32.add 	$push125=, $pop37, $pop126
	tee_local	$push124=, $2=, $pop125
	i32.const	$push123=, 16
	i32.shr_u	$push38=, $pop124, $pop123
	i32.store8	$discard=, sO+13($pop128), $pop38
	i32.const	$push122=, 0
	i32.const	$push121=, 1103515245
	i32.mul 	$push39=, $2, $pop121
	i32.const	$push120=, 12345
	i32.add 	$push119=, $pop39, $pop120
	tee_local	$push118=, $2=, $pop119
	i32.const	$push117=, 16
	i32.shr_u	$push40=, $pop118, $pop117
	i32.store8	$discard=, sO+14($pop122), $pop40
	i32.const	$push116=, 0
	i32.const	$push115=, 1103515245
	i32.mul 	$push41=, $2, $pop115
	i32.const	$push114=, 12345
	i32.add 	$push113=, $pop41, $pop114
	tee_local	$push112=, $2=, $pop113
	i32.const	$push111=, 16
	i32.shr_u	$push42=, $pop112, $pop111
	i32.store8	$discard=, sO+15($pop116), $pop42
	i32.const	$push110=, 0
	i64.load	$1=, sO+8($pop110)
	i32.const	$push109=, 1103515245
	i32.mul 	$push43=, $2, $pop109
	i32.const	$push108=, 12345
	i32.add 	$push107=, $pop43, $pop108
	tee_local	$push106=, $0=, $pop107
	i32.const	$push105=, 16
	i32.shr_u	$push44=, $pop106, $pop105
	i32.const	$push104=, 2047
	i32.and 	$2=, $pop44, $pop104
	i32.const	$push103=, 0
	i32.const	$push102=, 1103515245
	i32.mul 	$push45=, $0, $pop102
	i32.const	$push101=, 12345
	i32.add 	$push3=, $pop45, $pop101
	i32.store	$0=, myrnd.s($pop103), $pop3
	block
	i32.const	$push100=, 0
	i64.extend_u/i32	$push47=, $2
	i64.const	$push48=, -4096
	i64.and 	$push49=, $1, $pop48
	i64.or  	$push50=, $pop47, $pop49
	i64.store	$push0=, sO+8($pop100), $pop50
	i32.wrap/i64	$push99=, $pop0
	tee_local	$push98=, $3=, $pop99
	i32.const	$push97=, 2047
	i32.and 	$push53=, $pop98, $pop97
	i32.ne  	$push54=, $2, $pop53
	br_if   	0, $pop54       # 0: down to label9
# BB#1:                                 # %entry
	i32.const	$push208=, 16
	i32.shr_u	$push46=, $0, $pop208
	i32.const	$push207=, 2047
	i32.and 	$push206=, $pop46, $pop207
	tee_local	$push205=, $4=, $pop206
	i32.add 	$push5=, $pop205, $2
	i32.add 	$push51=, $3, $4
	i32.const	$push52=, 4095
	i32.and 	$push6=, $pop51, $pop52
	i32.ne  	$push55=, $pop5, $pop6
	br_if   	0, $pop55       # 0: down to label9
# BB#2:                                 # %if.end
	i32.const	$push56=, 1103515245
	i32.mul 	$push57=, $0, $pop56
	i32.const	$push58=, 12345
	i32.add 	$push218=, $pop57, $pop58
	tee_local	$push217=, $0=, $pop218
	i32.const	$push216=, 16
	i32.shr_u	$push59=, $pop217, $pop216
	i32.const	$push215=, 2047
	i32.and 	$2=, $pop59, $pop215
	i32.const	$push61=, 0
	i32.const	$push214=, 1103515245
	i32.mul 	$push60=, $0, $pop214
	i32.const	$push213=, 12345
	i32.add 	$push4=, $pop60, $pop213
	i32.store	$0=, myrnd.s($pop61), $pop4
	i32.const	$push212=, 0
	i64.extend_u/i32	$push63=, $2
	i64.const	$push64=, -4096
	i64.and 	$push65=, $1, $pop64
	i64.or  	$push66=, $pop63, $pop65
	i64.store	$push1=, sO+8($pop212), $pop66
	i32.wrap/i64	$push211=, $pop1
	tee_local	$push210=, $3=, $pop211
	i32.const	$push209=, 2047
	i32.and 	$push67=, $pop210, $pop209
	i32.ne  	$push68=, $2, $pop67
	br_if   	0, $pop68       # 0: down to label9
# BB#3:                                 # %lor.lhs.false87
	i32.const	$push224=, 16
	i32.shr_u	$push62=, $0, $pop224
	i32.const	$push223=, 2047
	i32.and 	$push222=, $pop62, $pop223
	tee_local	$push221=, $4=, $pop222
	i32.add 	$push69=, $3, $pop221
	i32.const	$push220=, 4095
	i32.and 	$push70=, $pop69, $pop220
	i32.const	$push71=, 15
	i32.rem_u	$push72=, $pop70, $pop71
	i32.add 	$push73=, $4, $2
	i32.const	$push219=, 15
	i32.rem_u	$push74=, $pop73, $pop219
	i32.ne  	$push75=, $pop72, $pop74
	br_if   	0, $pop75       # 0: down to label9
# BB#4:                                 # %lor.lhs.false124
	i32.const	$push84=, 0
	i32.const	$push76=, 1103515245
	i32.mul 	$push77=, $0, $pop76
	i32.const	$push78=, 12345
	i32.add 	$push240=, $pop77, $pop78
	tee_local	$push239=, $2=, $pop240
	i32.const	$push79=, 16
	i32.shr_u	$push80=, $pop239, $pop79
	i32.const	$push81=, 2047
	i32.and 	$push238=, $pop80, $pop81
	tee_local	$push237=, $0=, $pop238
	i64.extend_u/i32	$push86=, $pop237
	i64.const	$push87=, -4096
	i64.and 	$push236=, $1, $pop87
	tee_local	$push235=, $1=, $pop236
	i64.or  	$push88=, $pop86, $pop235
	i32.wrap/i64	$push89=, $pop88
	i32.const	$push234=, 0
	i32.const	$push233=, 1103515245
	i32.mul 	$push82=, $2, $pop233
	i32.const	$push232=, 12345
	i32.add 	$push83=, $pop82, $pop232
	i32.store	$push2=, myrnd.s($pop234), $pop83
	i32.const	$push231=, 16
	i32.shr_u	$push85=, $pop2, $pop231
	i32.const	$push230=, 2047
	i32.and 	$push229=, $pop85, $pop230
	tee_local	$push228=, $2=, $pop229
	i32.add 	$push227=, $pop89, $pop228
	tee_local	$push226=, $3=, $pop227
	i64.extend_u/i32	$push90=, $pop226
	i64.const	$push91=, 4095
	i64.and 	$push92=, $pop90, $pop91
	i64.or  	$push93=, $pop92, $1
	i64.store	$discard=, sO+8($pop84), $pop93
	i32.add 	$push95=, $2, $0
	i32.const	$push225=, 4095
	i32.and 	$push94=, $3, $pop225
	i32.ne  	$push96=, $pop95, $pop94
	br_if   	0, $pop96       # 0: down to label9
# BB#5:                                 # %if.end140
	return
.LBB90_6:                               # %if.then139
	end_block                       # label9:
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
	i32.load	$push1=, sP($pop0)
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
	i32.load	$push1=, sP($pop0)
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
	i32.load	$push1=, sP($pop0)
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
	i64.load	$push13=, sP($pop14)
	tee_local	$push12=, $1=, $pop13
	i32.wrap/i64	$push1=, $pop12
	i32.add 	$push11=, $pop1, $0
	tee_local	$push10=, $0=, $pop11
	i64.extend_u/i32	$push2=, $pop10
	i64.const	$push3=, 4095
	i64.and 	$push4=, $pop2, $pop3
	i64.const	$push5=, -4096
	i64.and 	$push6=, $1, $pop5
	i64.or  	$push7=, $pop4, $pop6
	i64.store	$discard=, sP($pop0), $pop7
	i32.const	$push8=, 4095
	i32.and 	$push9=, $0, $pop8
	return  	$pop9
	.endfunc
.Lfunc_end95:
	.size	fn3P, .Lfunc_end95-fn3P

	.section	.text.testP,"ax",@progbits
	.hidden	testP
	.globl	testP
	.type	testP,@function
testP:                                  # @testP
	.local  	i32, i64, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push7=, 0
	i32.const	$push204=, 0
	i32.load	$push8=, myrnd.s($pop204)
	i32.const	$push9=, 1103515245
	i32.mul 	$push10=, $pop8, $pop9
	i32.const	$push11=, 12345
	i32.add 	$push203=, $pop10, $pop11
	tee_local	$push202=, $2=, $pop203
	i32.const	$push201=, 16
	i32.shr_u	$push12=, $pop202, $pop201
	i32.store8	$discard=, sP($pop7), $pop12
	i32.const	$push200=, 0
	i32.const	$push199=, 1103515245
	i32.mul 	$push13=, $2, $pop199
	i32.const	$push198=, 12345
	i32.add 	$push197=, $pop13, $pop198
	tee_local	$push196=, $2=, $pop197
	i32.const	$push195=, 16
	i32.shr_u	$push14=, $pop196, $pop195
	i32.store8	$discard=, sP+1($pop200), $pop14
	i32.const	$push194=, 0
	i32.const	$push193=, 1103515245
	i32.mul 	$push15=, $2, $pop193
	i32.const	$push192=, 12345
	i32.add 	$push191=, $pop15, $pop192
	tee_local	$push190=, $2=, $pop191
	i32.const	$push189=, 16
	i32.shr_u	$push16=, $pop190, $pop189
	i32.store8	$discard=, sP+2($pop194), $pop16
	i32.const	$push188=, 0
	i32.const	$push187=, 1103515245
	i32.mul 	$push17=, $2, $pop187
	i32.const	$push186=, 12345
	i32.add 	$push185=, $pop17, $pop186
	tee_local	$push184=, $2=, $pop185
	i32.const	$push183=, 16
	i32.shr_u	$push18=, $pop184, $pop183
	i32.store8	$discard=, sP+3($pop188), $pop18
	i32.const	$push182=, 0
	i32.const	$push181=, 1103515245
	i32.mul 	$push19=, $2, $pop181
	i32.const	$push180=, 12345
	i32.add 	$push179=, $pop19, $pop180
	tee_local	$push178=, $2=, $pop179
	i32.const	$push177=, 16
	i32.shr_u	$push20=, $pop178, $pop177
	i32.store8	$discard=, sP+4($pop182), $pop20
	i32.const	$push176=, 0
	i32.const	$push175=, 1103515245
	i32.mul 	$push21=, $2, $pop175
	i32.const	$push174=, 12345
	i32.add 	$push173=, $pop21, $pop174
	tee_local	$push172=, $2=, $pop173
	i32.const	$push171=, 16
	i32.shr_u	$push22=, $pop172, $pop171
	i32.store8	$discard=, sP+5($pop176), $pop22
	i32.const	$push170=, 0
	i32.const	$push169=, 1103515245
	i32.mul 	$push23=, $2, $pop169
	i32.const	$push168=, 12345
	i32.add 	$push167=, $pop23, $pop168
	tee_local	$push166=, $2=, $pop167
	i32.const	$push165=, 16
	i32.shr_u	$push24=, $pop166, $pop165
	i32.store8	$discard=, sP+6($pop170), $pop24
	i32.const	$push164=, 0
	i32.const	$push163=, 1103515245
	i32.mul 	$push25=, $2, $pop163
	i32.const	$push162=, 12345
	i32.add 	$push161=, $pop25, $pop162
	tee_local	$push160=, $2=, $pop161
	i32.const	$push159=, 16
	i32.shr_u	$push26=, $pop160, $pop159
	i32.store8	$discard=, sP+7($pop164), $pop26
	i32.const	$push158=, 0
	i32.const	$push157=, 1103515245
	i32.mul 	$push27=, $2, $pop157
	i32.const	$push156=, 12345
	i32.add 	$push155=, $pop27, $pop156
	tee_local	$push154=, $2=, $pop155
	i32.const	$push153=, 16
	i32.shr_u	$push28=, $pop154, $pop153
	i32.store8	$discard=, sP+8($pop158), $pop28
	i32.const	$push152=, 0
	i32.const	$push151=, 1103515245
	i32.mul 	$push29=, $2, $pop151
	i32.const	$push150=, 12345
	i32.add 	$push149=, $pop29, $pop150
	tee_local	$push148=, $2=, $pop149
	i32.const	$push147=, 16
	i32.shr_u	$push30=, $pop148, $pop147
	i32.store8	$discard=, sP+9($pop152), $pop30
	i32.const	$push146=, 0
	i32.const	$push145=, 1103515245
	i32.mul 	$push31=, $2, $pop145
	i32.const	$push144=, 12345
	i32.add 	$push143=, $pop31, $pop144
	tee_local	$push142=, $2=, $pop143
	i32.const	$push141=, 16
	i32.shr_u	$push32=, $pop142, $pop141
	i32.store8	$discard=, sP+10($pop146), $pop32
	i32.const	$push140=, 0
	i32.const	$push139=, 1103515245
	i32.mul 	$push33=, $2, $pop139
	i32.const	$push138=, 12345
	i32.add 	$push137=, $pop33, $pop138
	tee_local	$push136=, $2=, $pop137
	i32.const	$push135=, 16
	i32.shr_u	$push34=, $pop136, $pop135
	i32.store8	$discard=, sP+11($pop140), $pop34
	i32.const	$push134=, 0
	i32.const	$push133=, 1103515245
	i32.mul 	$push35=, $2, $pop133
	i32.const	$push132=, 12345
	i32.add 	$push131=, $pop35, $pop132
	tee_local	$push130=, $2=, $pop131
	i32.const	$push129=, 16
	i32.shr_u	$push36=, $pop130, $pop129
	i32.store8	$discard=, sP+12($pop134), $pop36
	i32.const	$push128=, 0
	i32.const	$push127=, 1103515245
	i32.mul 	$push37=, $2, $pop127
	i32.const	$push126=, 12345
	i32.add 	$push125=, $pop37, $pop126
	tee_local	$push124=, $2=, $pop125
	i32.const	$push123=, 16
	i32.shr_u	$push38=, $pop124, $pop123
	i32.store8	$discard=, sP+13($pop128), $pop38
	i32.const	$push122=, 0
	i32.const	$push121=, 1103515245
	i32.mul 	$push39=, $2, $pop121
	i32.const	$push120=, 12345
	i32.add 	$push119=, $pop39, $pop120
	tee_local	$push118=, $2=, $pop119
	i32.const	$push117=, 16
	i32.shr_u	$push40=, $pop118, $pop117
	i32.store8	$discard=, sP+14($pop122), $pop40
	i32.const	$push116=, 0
	i32.const	$push115=, 1103515245
	i32.mul 	$push41=, $2, $pop115
	i32.const	$push114=, 12345
	i32.add 	$push113=, $pop41, $pop114
	tee_local	$push112=, $2=, $pop113
	i32.const	$push111=, 16
	i32.shr_u	$push42=, $pop112, $pop111
	i32.store8	$discard=, sP+15($pop116), $pop42
	i32.const	$push110=, 0
	i64.load	$1=, sP($pop110)
	i32.const	$push109=, 1103515245
	i32.mul 	$push43=, $2, $pop109
	i32.const	$push108=, 12345
	i32.add 	$push107=, $pop43, $pop108
	tee_local	$push106=, $0=, $pop107
	i32.const	$push105=, 16
	i32.shr_u	$push44=, $pop106, $pop105
	i32.const	$push104=, 2047
	i32.and 	$2=, $pop44, $pop104
	i32.const	$push103=, 0
	i32.const	$push102=, 1103515245
	i32.mul 	$push45=, $0, $pop102
	i32.const	$push101=, 12345
	i32.add 	$push3=, $pop45, $pop101
	i32.store	$0=, myrnd.s($pop103), $pop3
	block
	i32.const	$push100=, 0
	i64.extend_u/i32	$push47=, $2
	i64.const	$push48=, -4096
	i64.and 	$push49=, $1, $pop48
	i64.or  	$push50=, $pop47, $pop49
	i64.store	$push0=, sP($pop100), $pop50
	i32.wrap/i64	$push99=, $pop0
	tee_local	$push98=, $3=, $pop99
	i32.const	$push97=, 2047
	i32.and 	$push53=, $pop98, $pop97
	i32.ne  	$push54=, $2, $pop53
	br_if   	0, $pop54       # 0: down to label10
# BB#1:                                 # %entry
	i32.const	$push208=, 16
	i32.shr_u	$push46=, $0, $pop208
	i32.const	$push207=, 2047
	i32.and 	$push206=, $pop46, $pop207
	tee_local	$push205=, $4=, $pop206
	i32.add 	$push5=, $pop205, $2
	i32.add 	$push51=, $3, $4
	i32.const	$push52=, 4095
	i32.and 	$push6=, $pop51, $pop52
	i32.ne  	$push55=, $pop5, $pop6
	br_if   	0, $pop55       # 0: down to label10
# BB#2:                                 # %if.end
	i32.const	$push56=, 1103515245
	i32.mul 	$push57=, $0, $pop56
	i32.const	$push58=, 12345
	i32.add 	$push218=, $pop57, $pop58
	tee_local	$push217=, $0=, $pop218
	i32.const	$push216=, 16
	i32.shr_u	$push59=, $pop217, $pop216
	i32.const	$push215=, 2047
	i32.and 	$2=, $pop59, $pop215
	i32.const	$push61=, 0
	i32.const	$push214=, 1103515245
	i32.mul 	$push60=, $0, $pop214
	i32.const	$push213=, 12345
	i32.add 	$push4=, $pop60, $pop213
	i32.store	$0=, myrnd.s($pop61), $pop4
	i32.const	$push212=, 0
	i64.extend_u/i32	$push63=, $2
	i64.const	$push64=, -4096
	i64.and 	$push65=, $1, $pop64
	i64.or  	$push66=, $pop63, $pop65
	i64.store	$push1=, sP($pop212), $pop66
	i32.wrap/i64	$push211=, $pop1
	tee_local	$push210=, $3=, $pop211
	i32.const	$push209=, 2047
	i32.and 	$push67=, $pop210, $pop209
	i32.ne  	$push68=, $2, $pop67
	br_if   	0, $pop68       # 0: down to label10
# BB#3:                                 # %lor.lhs.false83
	i32.const	$push224=, 16
	i32.shr_u	$push62=, $0, $pop224
	i32.const	$push223=, 2047
	i32.and 	$push222=, $pop62, $pop223
	tee_local	$push221=, $4=, $pop222
	i32.add 	$push69=, $3, $pop221
	i32.const	$push220=, 4095
	i32.and 	$push70=, $pop69, $pop220
	i32.const	$push71=, 15
	i32.rem_u	$push72=, $pop70, $pop71
	i32.add 	$push73=, $4, $2
	i32.const	$push219=, 15
	i32.rem_u	$push74=, $pop73, $pop219
	i32.ne  	$push75=, $pop72, $pop74
	br_if   	0, $pop75       # 0: down to label10
# BB#4:                                 # %lor.lhs.false118
	i32.const	$push84=, 0
	i32.const	$push76=, 1103515245
	i32.mul 	$push77=, $0, $pop76
	i32.const	$push78=, 12345
	i32.add 	$push240=, $pop77, $pop78
	tee_local	$push239=, $2=, $pop240
	i32.const	$push79=, 16
	i32.shr_u	$push80=, $pop239, $pop79
	i32.const	$push81=, 2047
	i32.and 	$push238=, $pop80, $pop81
	tee_local	$push237=, $0=, $pop238
	i64.extend_u/i32	$push86=, $pop237
	i64.const	$push87=, -4096
	i64.and 	$push236=, $1, $pop87
	tee_local	$push235=, $1=, $pop236
	i64.or  	$push88=, $pop86, $pop235
	i32.wrap/i64	$push89=, $pop88
	i32.const	$push234=, 0
	i32.const	$push233=, 1103515245
	i32.mul 	$push82=, $2, $pop233
	i32.const	$push232=, 12345
	i32.add 	$push83=, $pop82, $pop232
	i32.store	$push2=, myrnd.s($pop234), $pop83
	i32.const	$push231=, 16
	i32.shr_u	$push85=, $pop2, $pop231
	i32.const	$push230=, 2047
	i32.and 	$push229=, $pop85, $pop230
	tee_local	$push228=, $2=, $pop229
	i32.add 	$push227=, $pop89, $pop228
	tee_local	$push226=, $3=, $pop227
	i64.extend_u/i32	$push90=, $pop226
	i64.const	$push91=, 4095
	i64.and 	$push92=, $pop90, $pop91
	i64.or  	$push93=, $pop92, $1
	i64.store	$discard=, sP($pop84), $pop93
	i32.add 	$push95=, $2, $0
	i32.const	$push225=, 4095
	i32.and 	$push94=, $3, $pop225
	i32.ne  	$push96=, $pop95, $pop94
	br_if   	0, $pop96       # 0: down to label10
# BB#5:                                 # %if.end134
	return
.LBB96_6:                               # %if.then133
	end_block                       # label10:
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
	i32.load	$push1=, sQ($pop0)
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
	i32.load	$push1=, sQ($pop0)
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
	i32.load	$push1=, sQ($pop0)
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
	i32.load	$push9=, sQ($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.add 	$push1=, $pop8, $0
	i32.const	$push2=, 4095
	i32.and 	$push7=, $pop1, $pop2
	tee_local	$push6=, $0=, $pop7
	i32.const	$push3=, -4096
	i32.and 	$push4=, $1, $pop3
	i32.or  	$push5=, $pop6, $pop4
	i32.store	$discard=, sQ($pop0), $pop5
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
	i32.const	$push1=, 0
	i32.const	$push154=, 0
	i32.load	$push2=, myrnd.s($pop154)
	i32.const	$push3=, 1103515245
	i32.mul 	$push4=, $pop2, $pop3
	i32.const	$push5=, 12345
	i32.add 	$push153=, $pop4, $pop5
	tee_local	$push152=, $1=, $pop153
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop152, $pop6
	i32.store8	$discard=, sQ($pop1), $pop7
	i32.const	$push151=, 0
	i32.const	$push150=, 1103515245
	i32.mul 	$push8=, $1, $pop150
	i32.const	$push149=, 12345
	i32.add 	$push148=, $pop8, $pop149
	tee_local	$push147=, $1=, $pop148
	i32.const	$push146=, 16
	i32.shr_u	$push9=, $pop147, $pop146
	i32.store8	$discard=, sQ+1($pop151), $pop9
	i32.const	$push145=, 0
	i32.const	$push144=, 1103515245
	i32.mul 	$push10=, $1, $pop144
	i32.const	$push143=, 12345
	i32.add 	$push142=, $pop10, $pop143
	tee_local	$push141=, $1=, $pop142
	i32.const	$push140=, 16
	i32.shr_u	$push11=, $pop141, $pop140
	i32.store8	$discard=, sQ+2($pop145), $pop11
	i32.const	$push139=, 0
	i32.const	$push138=, 1103515245
	i32.mul 	$push12=, $1, $pop138
	i32.const	$push137=, 12345
	i32.add 	$push136=, $pop12, $pop137
	tee_local	$push135=, $1=, $pop136
	i32.const	$push134=, 16
	i32.shr_u	$push13=, $pop135, $pop134
	i32.store8	$discard=, sQ+3($pop139), $pop13
	i32.const	$push133=, 0
	i32.const	$push132=, 1103515245
	i32.mul 	$push14=, $1, $pop132
	i32.const	$push131=, 12345
	i32.add 	$push130=, $pop14, $pop131
	tee_local	$push129=, $1=, $pop130
	i32.const	$push128=, 16
	i32.shr_u	$push15=, $pop129, $pop128
	i32.store8	$discard=, sQ+4($pop133), $pop15
	i32.const	$push127=, 0
	i32.const	$push126=, 1103515245
	i32.mul 	$push16=, $1, $pop126
	i32.const	$push125=, 12345
	i32.add 	$push124=, $pop16, $pop125
	tee_local	$push123=, $1=, $pop124
	i32.const	$push122=, 16
	i32.shr_u	$push17=, $pop123, $pop122
	i32.store8	$discard=, sQ+5($pop127), $pop17
	i32.const	$push121=, 0
	i32.const	$push120=, 1103515245
	i32.mul 	$push18=, $1, $pop120
	i32.const	$push119=, 12345
	i32.add 	$push118=, $pop18, $pop119
	tee_local	$push117=, $1=, $pop118
	i32.const	$push116=, 16
	i32.shr_u	$push19=, $pop117, $pop116
	i32.store8	$discard=, sQ+6($pop121), $pop19
	i32.const	$push115=, 0
	i32.const	$push114=, 1103515245
	i32.mul 	$push20=, $1, $pop114
	i32.const	$push113=, 12345
	i32.add 	$push112=, $pop20, $pop113
	tee_local	$push111=, $1=, $pop112
	i32.const	$push110=, 16
	i32.shr_u	$push21=, $pop111, $pop110
	i32.store8	$discard=, sQ+7($pop115), $pop21
	i32.const	$push109=, 0
	i32.const	$push108=, 1103515245
	i32.mul 	$push22=, $1, $pop108
	i32.const	$push107=, 12345
	i32.add 	$push106=, $pop22, $pop107
	tee_local	$push105=, $1=, $pop106
	i32.const	$push104=, 16
	i32.shr_u	$push23=, $pop105, $pop104
	i32.store8	$discard=, sQ+8($pop109), $pop23
	i32.const	$push103=, 0
	i32.const	$push102=, 1103515245
	i32.mul 	$push24=, $1, $pop102
	i32.const	$push101=, 12345
	i32.add 	$push100=, $pop24, $pop101
	tee_local	$push99=, $1=, $pop100
	i32.const	$push98=, 16
	i32.shr_u	$push25=, $pop99, $pop98
	i32.store8	$discard=, sQ+9($pop103), $pop25
	i32.const	$push97=, 0
	i32.const	$push96=, 1103515245
	i32.mul 	$push26=, $1, $pop96
	i32.const	$push95=, 12345
	i32.add 	$push94=, $pop26, $pop95
	tee_local	$push93=, $1=, $pop94
	i32.const	$push92=, 16
	i32.shr_u	$push27=, $pop93, $pop92
	i32.store8	$discard=, sQ+10($pop97), $pop27
	i32.const	$push91=, 0
	i32.const	$push90=, 1103515245
	i32.mul 	$push28=, $1, $pop90
	i32.const	$push89=, 12345
	i32.add 	$push88=, $pop28, $pop89
	tee_local	$push87=, $1=, $pop88
	i32.const	$push86=, 16
	i32.shr_u	$push29=, $pop87, $pop86
	i32.store8	$discard=, sQ+11($pop91), $pop29
	i32.const	$push85=, 0
	i32.const	$push84=, 1103515245
	i32.mul 	$push30=, $1, $pop84
	i32.const	$push83=, 12345
	i32.add 	$push82=, $pop30, $pop83
	tee_local	$push81=, $1=, $pop82
	i32.const	$push80=, 16
	i32.shr_u	$push31=, $pop81, $pop80
	i32.store8	$discard=, sQ+12($pop85), $pop31
	i32.const	$push79=, 0
	i32.const	$push78=, 1103515245
	i32.mul 	$push32=, $1, $pop78
	i32.const	$push77=, 12345
	i32.add 	$push76=, $pop32, $pop77
	tee_local	$push75=, $1=, $pop76
	i32.const	$push74=, 16
	i32.shr_u	$push33=, $pop75, $pop74
	i32.store8	$discard=, sQ+13($pop79), $pop33
	i32.const	$push73=, 0
	i32.const	$push72=, 1103515245
	i32.mul 	$push34=, $1, $pop72
	i32.const	$push71=, 12345
	i32.add 	$push70=, $pop34, $pop71
	tee_local	$push69=, $1=, $pop70
	i32.const	$push68=, 16
	i32.shr_u	$push35=, $pop69, $pop68
	i32.store8	$discard=, sQ+14($pop73), $pop35
	i32.const	$push67=, 0
	i32.load	$0=, sQ($pop67)
	i32.const	$push66=, 0
	i32.const	$push65=, 1103515245
	i32.mul 	$push36=, $1, $pop65
	i32.const	$push64=, 12345
	i32.add 	$push63=, $pop36, $pop64
	tee_local	$push62=, $1=, $pop63
	i32.const	$push61=, 16
	i32.shr_u	$push37=, $pop62, $pop61
	i32.store8	$discard=, sQ+15($pop66), $pop37
	i32.const	$push60=, 0
	i32.const	$push59=, 0
	i32.const	$push40=, -341751747
	i32.mul 	$push41=, $1, $pop40
	i32.const	$push42=, 229283573
	i32.add 	$push58=, $pop41, $pop42
	tee_local	$push57=, $1=, $pop58
	i32.const	$push56=, 1103515245
	i32.mul 	$push46=, $pop57, $pop56
	i32.const	$push55=, 12345
	i32.add 	$push47=, $pop46, $pop55
	i32.store	$push0=, myrnd.s($pop59), $pop47
	i32.const	$push54=, 16
	i32.shr_u	$push48=, $pop0, $pop54
	i32.const	$push44=, 2047
	i32.and 	$push49=, $pop48, $pop44
	i32.const	$push53=, 16
	i32.shr_u	$push43=, $1, $pop53
	i32.const	$push52=, 2047
	i32.and 	$push45=, $pop43, $pop52
	i32.add 	$push50=, $pop49, $pop45
	i32.const	$push38=, -4096
	i32.and 	$push39=, $0, $pop38
	i32.or  	$push51=, $pop50, $pop39
	i32.store	$discard=, sQ($pop60), $pop51
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
	i32.load	$push1=, sR($pop0)
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
	i32.load	$push1=, sR($pop0)
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
	i32.load	$push1=, sR($pop0)
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
	i32.load	$push9=, sR($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.add 	$push1=, $pop8, $0
	i32.const	$push2=, 4095
	i32.and 	$push7=, $pop1, $pop2
	tee_local	$push6=, $0=, $pop7
	i32.const	$push3=, -4096
	i32.and 	$push4=, $1, $pop3
	i32.or  	$push5=, $pop6, $pop4
	i32.store	$discard=, sR($pop0), $pop5
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
	i32.const	$push1=, 0
	i32.const	$push154=, 0
	i32.load	$push2=, myrnd.s($pop154)
	i32.const	$push3=, 1103515245
	i32.mul 	$push4=, $pop2, $pop3
	i32.const	$push5=, 12345
	i32.add 	$push153=, $pop4, $pop5
	tee_local	$push152=, $1=, $pop153
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop152, $pop6
	i32.store8	$discard=, sR($pop1), $pop7
	i32.const	$push151=, 0
	i32.const	$push150=, 1103515245
	i32.mul 	$push8=, $1, $pop150
	i32.const	$push149=, 12345
	i32.add 	$push148=, $pop8, $pop149
	tee_local	$push147=, $1=, $pop148
	i32.const	$push146=, 16
	i32.shr_u	$push9=, $pop147, $pop146
	i32.store8	$discard=, sR+1($pop151), $pop9
	i32.const	$push145=, 0
	i32.const	$push144=, 1103515245
	i32.mul 	$push10=, $1, $pop144
	i32.const	$push143=, 12345
	i32.add 	$push142=, $pop10, $pop143
	tee_local	$push141=, $1=, $pop142
	i32.const	$push140=, 16
	i32.shr_u	$push11=, $pop141, $pop140
	i32.store8	$discard=, sR+2($pop145), $pop11
	i32.const	$push139=, 0
	i32.const	$push138=, 1103515245
	i32.mul 	$push12=, $1, $pop138
	i32.const	$push137=, 12345
	i32.add 	$push136=, $pop12, $pop137
	tee_local	$push135=, $1=, $pop136
	i32.const	$push134=, 16
	i32.shr_u	$push13=, $pop135, $pop134
	i32.store8	$discard=, sR+3($pop139), $pop13
	i32.const	$push133=, 0
	i32.const	$push132=, 1103515245
	i32.mul 	$push14=, $1, $pop132
	i32.const	$push131=, 12345
	i32.add 	$push130=, $pop14, $pop131
	tee_local	$push129=, $1=, $pop130
	i32.const	$push128=, 16
	i32.shr_u	$push15=, $pop129, $pop128
	i32.store8	$discard=, sR+4($pop133), $pop15
	i32.const	$push127=, 0
	i32.const	$push126=, 1103515245
	i32.mul 	$push16=, $1, $pop126
	i32.const	$push125=, 12345
	i32.add 	$push124=, $pop16, $pop125
	tee_local	$push123=, $1=, $pop124
	i32.const	$push122=, 16
	i32.shr_u	$push17=, $pop123, $pop122
	i32.store8	$discard=, sR+5($pop127), $pop17
	i32.const	$push121=, 0
	i32.const	$push120=, 1103515245
	i32.mul 	$push18=, $1, $pop120
	i32.const	$push119=, 12345
	i32.add 	$push118=, $pop18, $pop119
	tee_local	$push117=, $1=, $pop118
	i32.const	$push116=, 16
	i32.shr_u	$push19=, $pop117, $pop116
	i32.store8	$discard=, sR+6($pop121), $pop19
	i32.const	$push115=, 0
	i32.const	$push114=, 1103515245
	i32.mul 	$push20=, $1, $pop114
	i32.const	$push113=, 12345
	i32.add 	$push112=, $pop20, $pop113
	tee_local	$push111=, $1=, $pop112
	i32.const	$push110=, 16
	i32.shr_u	$push21=, $pop111, $pop110
	i32.store8	$discard=, sR+7($pop115), $pop21
	i32.const	$push109=, 0
	i32.const	$push108=, 1103515245
	i32.mul 	$push22=, $1, $pop108
	i32.const	$push107=, 12345
	i32.add 	$push106=, $pop22, $pop107
	tee_local	$push105=, $1=, $pop106
	i32.const	$push104=, 16
	i32.shr_u	$push23=, $pop105, $pop104
	i32.store8	$discard=, sR+8($pop109), $pop23
	i32.const	$push103=, 0
	i32.const	$push102=, 1103515245
	i32.mul 	$push24=, $1, $pop102
	i32.const	$push101=, 12345
	i32.add 	$push100=, $pop24, $pop101
	tee_local	$push99=, $1=, $pop100
	i32.const	$push98=, 16
	i32.shr_u	$push25=, $pop99, $pop98
	i32.store8	$discard=, sR+9($pop103), $pop25
	i32.const	$push97=, 0
	i32.const	$push96=, 1103515245
	i32.mul 	$push26=, $1, $pop96
	i32.const	$push95=, 12345
	i32.add 	$push94=, $pop26, $pop95
	tee_local	$push93=, $1=, $pop94
	i32.const	$push92=, 16
	i32.shr_u	$push27=, $pop93, $pop92
	i32.store8	$discard=, sR+10($pop97), $pop27
	i32.const	$push91=, 0
	i32.const	$push90=, 1103515245
	i32.mul 	$push28=, $1, $pop90
	i32.const	$push89=, 12345
	i32.add 	$push88=, $pop28, $pop89
	tee_local	$push87=, $1=, $pop88
	i32.const	$push86=, 16
	i32.shr_u	$push29=, $pop87, $pop86
	i32.store8	$discard=, sR+11($pop91), $pop29
	i32.const	$push85=, 0
	i32.const	$push84=, 1103515245
	i32.mul 	$push30=, $1, $pop84
	i32.const	$push83=, 12345
	i32.add 	$push82=, $pop30, $pop83
	tee_local	$push81=, $1=, $pop82
	i32.const	$push80=, 16
	i32.shr_u	$push31=, $pop81, $pop80
	i32.store8	$discard=, sR+12($pop85), $pop31
	i32.const	$push79=, 0
	i32.const	$push78=, 1103515245
	i32.mul 	$push32=, $1, $pop78
	i32.const	$push77=, 12345
	i32.add 	$push76=, $pop32, $pop77
	tee_local	$push75=, $1=, $pop76
	i32.const	$push74=, 16
	i32.shr_u	$push33=, $pop75, $pop74
	i32.store8	$discard=, sR+13($pop79), $pop33
	i32.const	$push73=, 0
	i32.const	$push72=, 1103515245
	i32.mul 	$push34=, $1, $pop72
	i32.const	$push71=, 12345
	i32.add 	$push70=, $pop34, $pop71
	tee_local	$push69=, $1=, $pop70
	i32.const	$push68=, 16
	i32.shr_u	$push35=, $pop69, $pop68
	i32.store8	$discard=, sR+14($pop73), $pop35
	i32.const	$push67=, 0
	i32.load	$0=, sR($pop67)
	i32.const	$push66=, 0
	i32.const	$push65=, 1103515245
	i32.mul 	$push36=, $1, $pop65
	i32.const	$push64=, 12345
	i32.add 	$push63=, $pop36, $pop64
	tee_local	$push62=, $1=, $pop63
	i32.const	$push61=, 16
	i32.shr_u	$push37=, $pop62, $pop61
	i32.store8	$discard=, sR+15($pop66), $pop37
	i32.const	$push60=, 0
	i32.const	$push59=, 0
	i32.const	$push40=, -341751747
	i32.mul 	$push41=, $1, $pop40
	i32.const	$push42=, 229283573
	i32.add 	$push58=, $pop41, $pop42
	tee_local	$push57=, $1=, $pop58
	i32.const	$push56=, 1103515245
	i32.mul 	$push46=, $pop57, $pop56
	i32.const	$push55=, 12345
	i32.add 	$push47=, $pop46, $pop55
	i32.store	$push0=, myrnd.s($pop59), $pop47
	i32.const	$push54=, 16
	i32.shr_u	$push48=, $pop0, $pop54
	i32.const	$push44=, 2047
	i32.and 	$push49=, $pop48, $pop44
	i32.const	$push53=, 16
	i32.shr_u	$push43=, $1, $pop53
	i32.const	$push52=, 2047
	i32.and 	$push45=, $pop43, $pop52
	i32.add 	$push50=, $pop49, $pop45
	i32.const	$push38=, -4096
	i32.and 	$push39=, $0, $pop38
	i32.or  	$push51=, $pop50, $pop39
	i32.store	$discard=, sR($pop60), $pop51
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
	i32.load16_u	$push1=, sS($pop0)
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
	i32.load16_u	$push1=, sS($pop0)
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
	i32.load16_u	$push1=, sS($pop0)
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
	i32.load16_u	$push9=, sS($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.add 	$push1=, $pop8, $0
	i32.const	$push4=, 1
	i32.and 	$push7=, $pop1, $pop4
	tee_local	$push6=, $0=, $pop7
	i32.const	$push2=, 65534
	i32.and 	$push3=, $1, $pop2
	i32.or  	$push5=, $pop6, $pop3
	i32.store16	$discard=, sS($pop0), $pop5
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
	i32.const	$push1=, 0
	i32.const	$push153=, 0
	i32.load	$push2=, myrnd.s($pop153)
	i32.const	$push3=, 1103515245
	i32.mul 	$push4=, $pop2, $pop3
	i32.const	$push5=, 12345
	i32.add 	$push152=, $pop4, $pop5
	tee_local	$push151=, $1=, $pop152
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop151, $pop6
	i32.store8	$discard=, sS($pop1), $pop7
	i32.const	$push150=, 0
	i32.const	$push149=, 1103515245
	i32.mul 	$push8=, $1, $pop149
	i32.const	$push148=, 12345
	i32.add 	$push147=, $pop8, $pop148
	tee_local	$push146=, $1=, $pop147
	i32.const	$push145=, 16
	i32.shr_u	$push9=, $pop146, $pop145
	i32.store8	$discard=, sS+1($pop150), $pop9
	i32.const	$push144=, 0
	i32.const	$push143=, 1103515245
	i32.mul 	$push10=, $1, $pop143
	i32.const	$push142=, 12345
	i32.add 	$push141=, $pop10, $pop142
	tee_local	$push140=, $1=, $pop141
	i32.const	$push139=, 16
	i32.shr_u	$push11=, $pop140, $pop139
	i32.store8	$discard=, sS+2($pop144), $pop11
	i32.const	$push138=, 0
	i32.const	$push137=, 1103515245
	i32.mul 	$push12=, $1, $pop137
	i32.const	$push136=, 12345
	i32.add 	$push135=, $pop12, $pop136
	tee_local	$push134=, $1=, $pop135
	i32.const	$push133=, 16
	i32.shr_u	$push13=, $pop134, $pop133
	i32.store8	$discard=, sS+3($pop138), $pop13
	i32.const	$push132=, 0
	i32.const	$push131=, 1103515245
	i32.mul 	$push14=, $1, $pop131
	i32.const	$push130=, 12345
	i32.add 	$push129=, $pop14, $pop130
	tee_local	$push128=, $1=, $pop129
	i32.const	$push127=, 16
	i32.shr_u	$push15=, $pop128, $pop127
	i32.store8	$discard=, sS+4($pop132), $pop15
	i32.const	$push126=, 0
	i32.const	$push125=, 1103515245
	i32.mul 	$push16=, $1, $pop125
	i32.const	$push124=, 12345
	i32.add 	$push123=, $pop16, $pop124
	tee_local	$push122=, $1=, $pop123
	i32.const	$push121=, 16
	i32.shr_u	$push17=, $pop122, $pop121
	i32.store8	$discard=, sS+5($pop126), $pop17
	i32.const	$push120=, 0
	i32.const	$push119=, 1103515245
	i32.mul 	$push18=, $1, $pop119
	i32.const	$push118=, 12345
	i32.add 	$push117=, $pop18, $pop118
	tee_local	$push116=, $1=, $pop117
	i32.const	$push115=, 16
	i32.shr_u	$push19=, $pop116, $pop115
	i32.store8	$discard=, sS+6($pop120), $pop19
	i32.const	$push114=, 0
	i32.const	$push113=, 1103515245
	i32.mul 	$push20=, $1, $pop113
	i32.const	$push112=, 12345
	i32.add 	$push111=, $pop20, $pop112
	tee_local	$push110=, $1=, $pop111
	i32.const	$push109=, 16
	i32.shr_u	$push21=, $pop110, $pop109
	i32.store8	$discard=, sS+7($pop114), $pop21
	i32.const	$push108=, 0
	i32.const	$push107=, 1103515245
	i32.mul 	$push22=, $1, $pop107
	i32.const	$push106=, 12345
	i32.add 	$push105=, $pop22, $pop106
	tee_local	$push104=, $1=, $pop105
	i32.const	$push103=, 16
	i32.shr_u	$push23=, $pop104, $pop103
	i32.store8	$discard=, sS+8($pop108), $pop23
	i32.const	$push102=, 0
	i32.const	$push101=, 1103515245
	i32.mul 	$push24=, $1, $pop101
	i32.const	$push100=, 12345
	i32.add 	$push99=, $pop24, $pop100
	tee_local	$push98=, $1=, $pop99
	i32.const	$push97=, 16
	i32.shr_u	$push25=, $pop98, $pop97
	i32.store8	$discard=, sS+9($pop102), $pop25
	i32.const	$push96=, 0
	i32.const	$push95=, 1103515245
	i32.mul 	$push26=, $1, $pop95
	i32.const	$push94=, 12345
	i32.add 	$push93=, $pop26, $pop94
	tee_local	$push92=, $1=, $pop93
	i32.const	$push91=, 16
	i32.shr_u	$push27=, $pop92, $pop91
	i32.store8	$discard=, sS+10($pop96), $pop27
	i32.const	$push90=, 0
	i32.const	$push89=, 1103515245
	i32.mul 	$push28=, $1, $pop89
	i32.const	$push88=, 12345
	i32.add 	$push87=, $pop28, $pop88
	tee_local	$push86=, $1=, $pop87
	i32.const	$push85=, 16
	i32.shr_u	$push29=, $pop86, $pop85
	i32.store8	$discard=, sS+11($pop90), $pop29
	i32.const	$push84=, 0
	i32.const	$push83=, 1103515245
	i32.mul 	$push30=, $1, $pop83
	i32.const	$push82=, 12345
	i32.add 	$push81=, $pop30, $pop82
	tee_local	$push80=, $1=, $pop81
	i32.const	$push79=, 16
	i32.shr_u	$push31=, $pop80, $pop79
	i32.store8	$discard=, sS+12($pop84), $pop31
	i32.const	$push78=, 0
	i32.const	$push77=, 1103515245
	i32.mul 	$push32=, $1, $pop77
	i32.const	$push76=, 12345
	i32.add 	$push75=, $pop32, $pop76
	tee_local	$push74=, $1=, $pop75
	i32.const	$push73=, 16
	i32.shr_u	$push33=, $pop74, $pop73
	i32.store8	$discard=, sS+13($pop78), $pop33
	i32.const	$push72=, 0
	i32.const	$push71=, 1103515245
	i32.mul 	$push34=, $1, $pop71
	i32.const	$push70=, 12345
	i32.add 	$push69=, $pop34, $pop70
	tee_local	$push68=, $1=, $pop69
	i32.const	$push67=, 16
	i32.shr_u	$push35=, $pop68, $pop67
	i32.store8	$discard=, sS+14($pop72), $pop35
	i32.const	$push66=, 0
	i32.load16_u	$0=, sS($pop66)
	i32.const	$push65=, 0
	i32.const	$push64=, 1103515245
	i32.mul 	$push36=, $1, $pop64
	i32.const	$push63=, 12345
	i32.add 	$push62=, $pop36, $pop63
	tee_local	$push61=, $1=, $pop62
	i32.const	$push60=, 16
	i32.shr_u	$push37=, $pop61, $pop60
	i32.store8	$discard=, sS+15($pop65), $pop37
	i32.const	$push59=, 0
	i32.const	$push58=, 0
	i32.const	$push40=, -341751747
	i32.mul 	$push41=, $1, $pop40
	i32.const	$push42=, 229283573
	i32.add 	$push57=, $pop41, $pop42
	tee_local	$push56=, $1=, $pop57
	i32.const	$push55=, 1103515245
	i32.mul 	$push44=, $pop56, $pop55
	i32.const	$push54=, 12345
	i32.add 	$push45=, $pop44, $pop54
	i32.store	$push0=, myrnd.s($pop58), $pop45
	i32.const	$push53=, 16
	i32.shr_u	$push46=, $pop0, $pop53
	i32.const	$push52=, 16
	i32.shr_u	$push43=, $1, $pop52
	i32.add 	$push47=, $pop46, $pop43
	i32.const	$push48=, 1
	i32.and 	$push49=, $pop47, $pop48
	i32.const	$push38=, 65534
	i32.and 	$push39=, $0, $pop38
	i32.or  	$push50=, $pop49, $pop39
	i32.store16	$discard=, sS($pop59), $pop50
	block
	i32.const	$push51=, 1
	i32.const	$push154=, 0
	i32.eq  	$push155=, $pop51, $pop154
	br_if   	0, $pop155      # 0: down to label11
# BB#1:                                 # %if.end134
	return
.LBB114_2:                              # %if.then133
	end_block                       # label11:
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
	i32.load16_u	$push1=, sT($pop0)
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
	i32.load16_u	$push1=, sT($pop0)
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
	i32.load16_u	$push9=, sT($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.add 	$push1=, $pop8, $0
	i32.const	$push4=, 1
	i32.and 	$push7=, $pop1, $pop4
	tee_local	$push6=, $0=, $pop7
	i32.const	$push2=, 65534
	i32.and 	$push3=, $1, $pop2
	i32.or  	$push5=, $pop6, $pop3
	i32.store16	$discard=, sT($pop0), $pop5
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
	i32.const	$push76=, 0
	i32.const	$push75=, 0
	i32.load	$push1=, myrnd.s($pop75)
	i32.const	$push74=, 1103515245
	i32.mul 	$push2=, $pop1, $pop74
	i32.const	$push73=, 12345
	i32.add 	$push72=, $pop2, $pop73
	tee_local	$push71=, $1=, $pop72
	i32.const	$push70=, 16
	i32.shr_u	$push3=, $pop71, $pop70
	i32.store8	$discard=, sT($pop76), $pop3
	i32.const	$push69=, 0
	i32.const	$push68=, 1103515245
	i32.mul 	$push4=, $1, $pop68
	i32.const	$push67=, 12345
	i32.add 	$push66=, $pop4, $pop67
	tee_local	$push65=, $1=, $pop66
	i32.const	$push64=, 16
	i32.shr_u	$push5=, $pop65, $pop64
	i32.store8	$discard=, sT+1($pop69), $pop5
	i32.const	$push63=, 0
	i32.const	$push62=, 1103515245
	i32.mul 	$push6=, $1, $pop62
	i32.const	$push61=, 12345
	i32.add 	$push60=, $pop6, $pop61
	tee_local	$push59=, $1=, $pop60
	i32.const	$push58=, 16
	i32.shr_u	$push7=, $pop59, $pop58
	i32.store8	$discard=, sT+2($pop63), $pop7
	i32.const	$push57=, 0
	i32.const	$push56=, 1103515245
	i32.mul 	$push8=, $1, $pop56
	i32.const	$push55=, 12345
	i32.add 	$push54=, $pop8, $pop55
	tee_local	$push53=, $1=, $pop54
	i32.const	$push52=, 16
	i32.shr_u	$push9=, $pop53, $pop52
	i32.store8	$discard=, sT+3($pop57), $pop9
	i32.const	$push51=, 0
	i32.const	$push50=, 1103515245
	i32.mul 	$push11=, $1, $pop50
	i32.const	$push49=, 12345
	i32.add 	$push48=, $pop11, $pop49
	tee_local	$push47=, $3=, $pop48
	i32.const	$push46=, 16
	i32.shr_u	$push45=, $pop47, $pop46
	tee_local	$push44=, $2=, $pop45
	i32.const	$push43=, 1
	i32.and 	$push13=, $pop44, $pop43
	i32.const	$push42=, 0
	i32.load16_u	$push10=, sT($pop42)
	i32.const	$push41=, 65534
	i32.and 	$push14=, $pop10, $pop41
	i32.or  	$push15=, $pop13, $pop14
	i32.store16	$discard=, sT($pop51), $pop15
	i32.const	$push40=, 0
	i32.load	$1=, sT($pop40)
	i32.const	$push39=, 0
	i32.const	$push38=, 1103515245
	i32.mul 	$push12=, $3, $pop38
	i32.const	$push37=, 12345
	i32.add 	$push36=, $pop12, $pop37
	tee_local	$push35=, $3=, $pop36
	i32.store	$0=, myrnd.s($pop39), $pop35
	block
	i32.const	$push34=, 16
	i32.shr_u	$push33=, $3, $pop34
	tee_local	$push32=, $3=, $pop33
	i32.add 	$push17=, $pop32, $2
	i32.add 	$push16=, $3, $1
	i32.xor 	$push18=, $pop17, $pop16
	i32.const	$push31=, 1
	i32.and 	$push19=, $pop18, $pop31
	br_if   	0, $pop19       # 0: down to label12
# BB#1:                                 # %if.end94
	i32.const	$push87=, 0
	i32.const	$push86=, 0
	i32.const	$push21=, -2139243339
	i32.mul 	$push22=, $0, $pop21
	i32.const	$push23=, -1492899873
	i32.add 	$push85=, $pop22, $pop23
	tee_local	$push84=, $3=, $pop85
	i32.const	$push83=, 1103515245
	i32.mul 	$push25=, $pop84, $pop83
	i32.const	$push82=, 12345
	i32.add 	$push26=, $pop25, $pop82
	i32.store	$push0=, myrnd.s($pop86), $pop26
	i32.const	$push81=, 16
	i32.shr_u	$push27=, $pop0, $pop81
	i32.const	$push80=, 16
	i32.shr_u	$push24=, $3, $pop80
	i32.add 	$push28=, $pop27, $pop24
	i32.const	$push79=, 1
	i32.and 	$push29=, $pop28, $pop79
	i32.const	$push78=, 65534
	i32.and 	$push20=, $1, $pop78
	i32.or  	$push30=, $pop29, $pop20
	i32.store16	$discard=, sT($pop87), $pop30
	i32.const	$push77=, 1
	i32.const	$push88=, 0
	i32.eq  	$push89=, $pop77, $pop88
	br_if   	0, $pop89       # 0: down to label12
# BB#2:                                 # %if.end140
	return
.LBB120_3:                              # %if.then139
	end_block                       # label12:
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
	i32.load16_u	$push1=, sU($pop0)
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
	i32.load16_u	$push1=, sU($pop0)
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
	i32.load16_u	$push1=, sU($pop0)
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
	i32.load16_u	$push15=, sU($pop16)
	tee_local	$push14=, $1=, $pop15
	i32.const	$push1=, 6
	i32.shr_u	$push2=, $pop14, $pop1
	i32.add 	$push13=, $pop2, $0
	tee_local	$push12=, $0=, $pop13
	i32.const	$push11=, 6
	i32.shl 	$push3=, $pop12, $pop11
	i32.const	$push4=, 64
	i32.and 	$push5=, $pop3, $pop4
	i32.const	$push6=, 65471
	i32.and 	$push7=, $1, $pop6
	i32.or  	$push8=, $pop5, $pop7
	i32.store16	$discard=, sU($pop0), $pop8
	i32.const	$push9=, 1
	i32.and 	$push10=, $0, $pop9
	return  	$pop10
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
	i32.const	$push5=, 0
	i32.const	$push218=, 0
	i32.load	$push6=, myrnd.s($pop218)
	i32.const	$push7=, 1103515245
	i32.mul 	$push8=, $pop6, $pop7
	i32.const	$push9=, 12345
	i32.add 	$push217=, $pop8, $pop9
	tee_local	$push216=, $2=, $pop217
	i32.const	$push215=, 16
	i32.shr_u	$push10=, $pop216, $pop215
	i32.store8	$discard=, sU($pop5), $pop10
	i32.const	$push214=, 0
	i32.const	$push213=, 1103515245
	i32.mul 	$push11=, $2, $pop213
	i32.const	$push212=, 12345
	i32.add 	$push211=, $pop11, $pop212
	tee_local	$push210=, $2=, $pop211
	i32.const	$push209=, 16
	i32.shr_u	$push12=, $pop210, $pop209
	i32.store8	$discard=, sU+1($pop214), $pop12
	i32.const	$push208=, 0
	i32.const	$push207=, 1103515245
	i32.mul 	$push13=, $2, $pop207
	i32.const	$push206=, 12345
	i32.add 	$push205=, $pop13, $pop206
	tee_local	$push204=, $2=, $pop205
	i32.const	$push203=, 16
	i32.shr_u	$push14=, $pop204, $pop203
	i32.store8	$discard=, sU+2($pop208), $pop14
	i32.const	$push202=, 0
	i32.const	$push201=, 1103515245
	i32.mul 	$push15=, $2, $pop201
	i32.const	$push200=, 12345
	i32.add 	$push199=, $pop15, $pop200
	tee_local	$push198=, $2=, $pop199
	i32.const	$push197=, 16
	i32.shr_u	$push16=, $pop198, $pop197
	i32.store8	$discard=, sU+3($pop202), $pop16
	i32.const	$push196=, 0
	i32.const	$push195=, 1103515245
	i32.mul 	$push17=, $2, $pop195
	i32.const	$push194=, 12345
	i32.add 	$push193=, $pop17, $pop194
	tee_local	$push192=, $2=, $pop193
	i32.const	$push191=, 16
	i32.shr_u	$push18=, $pop192, $pop191
	i32.store8	$discard=, sU+4($pop196), $pop18
	i32.const	$push190=, 0
	i32.const	$push189=, 1103515245
	i32.mul 	$push19=, $2, $pop189
	i32.const	$push188=, 12345
	i32.add 	$push187=, $pop19, $pop188
	tee_local	$push186=, $2=, $pop187
	i32.const	$push185=, 16
	i32.shr_u	$push20=, $pop186, $pop185
	i32.store8	$discard=, sU+5($pop190), $pop20
	i32.const	$push184=, 0
	i32.const	$push183=, 1103515245
	i32.mul 	$push21=, $2, $pop183
	i32.const	$push182=, 12345
	i32.add 	$push181=, $pop21, $pop182
	tee_local	$push180=, $2=, $pop181
	i32.const	$push179=, 16
	i32.shr_u	$push22=, $pop180, $pop179
	i32.store8	$discard=, sU+6($pop184), $pop22
	i32.const	$push178=, 0
	i32.const	$push177=, 1103515245
	i32.mul 	$push23=, $2, $pop177
	i32.const	$push176=, 12345
	i32.add 	$push175=, $pop23, $pop176
	tee_local	$push174=, $2=, $pop175
	i32.const	$push173=, 16
	i32.shr_u	$push24=, $pop174, $pop173
	i32.store8	$discard=, sU+7($pop178), $pop24
	i32.const	$push172=, 0
	i32.const	$push171=, 1103515245
	i32.mul 	$push25=, $2, $pop171
	i32.const	$push170=, 12345
	i32.add 	$push169=, $pop25, $pop170
	tee_local	$push168=, $2=, $pop169
	i32.const	$push167=, 16
	i32.shr_u	$push26=, $pop168, $pop167
	i32.store8	$discard=, sU+8($pop172), $pop26
	i32.const	$push166=, 0
	i32.const	$push165=, 1103515245
	i32.mul 	$push27=, $2, $pop165
	i32.const	$push164=, 12345
	i32.add 	$push163=, $pop27, $pop164
	tee_local	$push162=, $2=, $pop163
	i32.const	$push161=, 16
	i32.shr_u	$push28=, $pop162, $pop161
	i32.store8	$discard=, sU+9($pop166), $pop28
	i32.const	$push160=, 0
	i32.const	$push159=, 1103515245
	i32.mul 	$push29=, $2, $pop159
	i32.const	$push158=, 12345
	i32.add 	$push157=, $pop29, $pop158
	tee_local	$push156=, $2=, $pop157
	i32.const	$push155=, 16
	i32.shr_u	$push30=, $pop156, $pop155
	i32.store8	$discard=, sU+10($pop160), $pop30
	i32.const	$push154=, 0
	i32.const	$push153=, 1103515245
	i32.mul 	$push31=, $2, $pop153
	i32.const	$push152=, 12345
	i32.add 	$push151=, $pop31, $pop152
	tee_local	$push150=, $2=, $pop151
	i32.const	$push149=, 16
	i32.shr_u	$push32=, $pop150, $pop149
	i32.store8	$discard=, sU+11($pop154), $pop32
	i32.const	$push148=, 0
	i32.const	$push147=, 1103515245
	i32.mul 	$push33=, $2, $pop147
	i32.const	$push146=, 12345
	i32.add 	$push145=, $pop33, $pop146
	tee_local	$push144=, $2=, $pop145
	i32.const	$push143=, 16
	i32.shr_u	$push34=, $pop144, $pop143
	i32.store8	$discard=, sU+12($pop148), $pop34
	i32.const	$push142=, 0
	i32.const	$push141=, 1103515245
	i32.mul 	$push35=, $2, $pop141
	i32.const	$push140=, 12345
	i32.add 	$push139=, $pop35, $pop140
	tee_local	$push138=, $2=, $pop139
	i32.const	$push137=, 16
	i32.shr_u	$push36=, $pop138, $pop137
	i32.store8	$discard=, sU+13($pop142), $pop36
	i32.const	$push136=, 0
	i32.const	$push135=, 1103515245
	i32.mul 	$push37=, $2, $pop135
	i32.const	$push134=, 12345
	i32.add 	$push133=, $pop37, $pop134
	tee_local	$push132=, $2=, $pop133
	i32.const	$push131=, 16
	i32.shr_u	$push38=, $pop132, $pop131
	i32.store8	$discard=, sU+14($pop136), $pop38
	i32.const	$push130=, 0
	i32.const	$push129=, 1103515245
	i32.mul 	$push39=, $2, $pop129
	i32.const	$push128=, 12345
	i32.add 	$push127=, $pop39, $pop128
	tee_local	$push126=, $2=, $pop127
	i32.const	$push125=, 16
	i32.shr_u	$push40=, $pop126, $pop125
	i32.store8	$discard=, sU+15($pop130), $pop40
	i32.const	$push124=, 0
	i32.load16_u	$1=, sU($pop124)
	i32.const	$push123=, 0
	i32.const	$push122=, 1103515245
	i32.mul 	$push41=, $2, $pop122
	i32.const	$push121=, 12345
	i32.add 	$push120=, $pop41, $pop121
	tee_local	$push119=, $2=, $pop120
	i32.const	$push118=, 1103515245
	i32.mul 	$push43=, $pop119, $pop118
	i32.const	$push117=, 12345
	i32.add 	$push3=, $pop43, $pop117
	i32.store	$0=, myrnd.s($pop123), $pop3
	block
	i32.const	$push116=, 0
	i32.const	$push115=, 16
	i32.shr_u	$push114=, $2, $pop115
	tee_local	$push113=, $4=, $pop114
	i32.const	$push42=, 2047
	i32.and 	$push112=, $pop113, $pop42
	tee_local	$push111=, $3=, $pop112
	i32.const	$push44=, 6
	i32.shl 	$push45=, $pop111, $pop44
	i32.const	$push46=, 64
	i32.and 	$push47=, $pop45, $pop46
	i32.const	$push48=, -65
	i32.and 	$push110=, $1, $pop48
	tee_local	$push109=, $2=, $pop110
	i32.or  	$push49=, $pop47, $pop109
	i32.store16	$push0=, sU($pop116), $pop49
	i32.const	$push50=, 65472
	i32.and 	$push51=, $pop0, $pop50
	i32.const	$push108=, 6
	i32.shr_u	$push107=, $pop51, $pop108
	tee_local	$push106=, $1=, $pop107
	i32.xor 	$push52=, $pop106, $3
	i32.const	$push105=, 1
	i32.and 	$push53=, $pop52, $pop105
	br_if   	0, $pop53       # 0: down to label13
# BB#1:                                 # %lor.lhs.false41
	i32.const	$push222=, 16
	i32.shr_u	$push221=, $0, $pop222
	tee_local	$push220=, $3=, $pop221
	i32.add 	$push54=, $1, $pop220
	i32.add 	$push55=, $3, $4
	i32.xor 	$push56=, $pop54, $pop55
	i32.const	$push219=, 1
	i32.and 	$push57=, $pop56, $pop219
	br_if   	0, $pop57       # 0: down to label13
# BB#2:                                 # %if.end
	i32.const	$push63=, 0
	i32.const	$push58=, 1103515245
	i32.mul 	$push59=, $0, $pop58
	i32.const	$push60=, 12345
	i32.add 	$push236=, $pop59, $pop60
	tee_local	$push235=, $1=, $pop236
	i32.const	$push234=, 1103515245
	i32.mul 	$push62=, $pop235, $pop234
	i32.const	$push233=, 12345
	i32.add 	$push4=, $pop62, $pop233
	i32.store	$0=, myrnd.s($pop63), $pop4
	i32.const	$push232=, 0
	i32.const	$push231=, 16
	i32.shr_u	$push230=, $1, $pop231
	tee_local	$push229=, $3=, $pop230
	i32.const	$push61=, 2047
	i32.and 	$push228=, $pop229, $pop61
	tee_local	$push227=, $1=, $pop228
	i32.const	$push64=, 6
	i32.shl 	$push65=, $pop227, $pop64
	i32.const	$push66=, 64
	i32.and 	$push67=, $pop65, $pop66
	i32.or  	$push68=, $pop67, $2
	i32.store16	$push1=, sU($pop232), $pop68
	i32.const	$push69=, 65472
	i32.and 	$push70=, $pop1, $pop69
	i32.const	$push226=, 6
	i32.shr_u	$push225=, $pop70, $pop226
	tee_local	$push224=, $4=, $pop225
	i32.xor 	$push71=, $pop224, $1
	i32.const	$push223=, 1
	i32.and 	$push72=, $pop71, $pop223
	br_if   	0, $pop72       # 0: down to label13
# BB#3:                                 # %lor.lhs.false85
	i32.const	$push242=, 16
	i32.shr_u	$push241=, $0, $pop242
	tee_local	$push240=, $1=, $pop241
	i32.add 	$push73=, $4, $pop240
	i32.const	$push239=, 1
	i32.and 	$push74=, $pop73, $pop239
	i32.const	$push75=, 15
	i32.rem_u	$push76=, $pop74, $pop75
	i32.add 	$push77=, $1, $3
	i32.const	$push238=, 1
	i32.and 	$push78=, $pop77, $pop238
	i32.const	$push237=, 15
	i32.rem_u	$push79=, $pop78, $pop237
	i32.ne  	$push80=, $pop76, $pop79
	br_if   	0, $pop80       # 0: down to label13
# BB#4:                                 # %lor.lhs.false130
	i32.const	$push88=, 0
	i32.const	$push81=, 1103515245
	i32.mul 	$push82=, $0, $pop81
	i32.const	$push83=, 12345
	i32.add 	$push254=, $pop82, $pop83
	tee_local	$push253=, $0=, $pop254
	i32.const	$push89=, 10
	i32.shr_u	$push90=, $pop253, $pop89
	i32.const	$push91=, 64
	i32.and 	$push92=, $pop90, $pop91
	i32.or  	$push93=, $pop92, $2
	i32.const	$push94=, 65472
	i32.and 	$push95=, $pop93, $pop94
	i32.const	$push96=, 6
	i32.shr_u	$push97=, $pop95, $pop96
	i32.const	$push252=, 0
	i32.const	$push251=, 1103515245
	i32.mul 	$push86=, $0, $pop251
	i32.const	$push250=, 12345
	i32.add 	$push87=, $pop86, $pop250
	i32.store	$push2=, myrnd.s($pop252), $pop87
	i32.const	$push84=, 16
	i32.shr_u	$push249=, $pop2, $pop84
	tee_local	$push248=, $1=, $pop249
	i32.add 	$push247=, $pop97, $pop248
	tee_local	$push246=, $3=, $pop247
	i32.const	$push245=, 6
	i32.shl 	$push98=, $pop246, $pop245
	i32.const	$push244=, 64
	i32.and 	$push99=, $pop98, $pop244
	i32.or  	$push100=, $pop99, $2
	i32.store16	$discard=, sU($pop88), $pop100
	i32.const	$push243=, 16
	i32.shr_u	$push85=, $0, $pop243
	i32.add 	$push101=, $1, $pop85
	i32.xor 	$push102=, $pop101, $3
	i32.const	$push103=, 1
	i32.and 	$push104=, $pop102, $pop103
	br_if   	0, $pop104      # 0: down to label13
# BB#5:                                 # %if.end136
	return
.LBB126_6:                              # %if.then135
	end_block                       # label13:
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
	i32.load16_u	$push15=, sV($pop16)
	tee_local	$push14=, $1=, $pop15
	i32.const	$push1=, 8
	i32.shr_u	$push2=, $pop14, $pop1
	i32.add 	$push13=, $pop2, $0
	tee_local	$push12=, $0=, $pop13
	i32.const	$push11=, 8
	i32.shl 	$push3=, $pop12, $pop11
	i32.const	$push4=, 256
	i32.and 	$push5=, $pop3, $pop4
	i32.const	$push6=, 65279
	i32.and 	$push7=, $1, $pop6
	i32.or  	$push8=, $pop5, $pop7
	i32.store16	$discard=, sV($pop0), $pop8
	i32.const	$push9=, 1
	i32.and 	$push10=, $0, $pop9
	return  	$pop10
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
	i32.const	$push110=, 0
	i32.const	$push109=, 0
	i32.load	$push3=, myrnd.s($pop109)
	i32.const	$push108=, 1103515245
	i32.mul 	$push4=, $pop3, $pop108
	i32.const	$push107=, 12345
	i32.add 	$push106=, $pop4, $pop107
	tee_local	$push105=, $1=, $pop106
	i32.const	$push104=, 16
	i32.shr_u	$push5=, $pop105, $pop104
	i32.store8	$discard=, sV($pop110), $pop5
	i32.const	$push103=, 0
	i32.const	$push102=, 1103515245
	i32.mul 	$push6=, $1, $pop102
	i32.const	$push101=, 12345
	i32.add 	$push100=, $pop6, $pop101
	tee_local	$push99=, $1=, $pop100
	i32.const	$push98=, 16
	i32.shr_u	$push7=, $pop99, $pop98
	i32.store8	$discard=, sV+1($pop103), $pop7
	i32.const	$push97=, 0
	i32.const	$push96=, 1103515245
	i32.mul 	$push8=, $1, $pop96
	i32.const	$push95=, 12345
	i32.add 	$push94=, $pop8, $pop95
	tee_local	$push93=, $1=, $pop94
	i32.const	$push92=, 16
	i32.shr_u	$push9=, $pop93, $pop92
	i32.store8	$discard=, sV+2($pop97), $pop9
	i32.const	$push91=, 0
	i32.const	$push90=, 1103515245
	i32.mul 	$push10=, $1, $pop90
	i32.const	$push89=, 12345
	i32.add 	$push88=, $pop10, $pop89
	tee_local	$push87=, $1=, $pop88
	i32.const	$push86=, 16
	i32.shr_u	$push11=, $pop87, $pop86
	i32.store8	$discard=, sV+3($pop91), $pop11
	i32.const	$push85=, 0
	i32.const	$push84=, 1103515245
	i32.mul 	$push13=, $1, $pop84
	i32.const	$push83=, 12345
	i32.add 	$push82=, $pop13, $pop83
	tee_local	$push81=, $3=, $pop82
	i32.const	$push80=, 8
	i32.shr_u	$push16=, $pop81, $pop80
	i32.const	$push79=, 256
	i32.and 	$push17=, $pop16, $pop79
	i32.const	$push78=, 0
	i32.load16_u	$push12=, sV($pop78)
	i32.const	$push77=, 65279
	i32.and 	$push18=, $pop12, $pop77
	i32.or  	$push19=, $pop17, $pop18
	i32.store16	$discard=, sV($pop85), $pop19
	i32.const	$push76=, 0
	i32.load	$1=, sV($pop76)
	i32.const	$push75=, 0
	i32.const	$push74=, 1103515245
	i32.mul 	$push15=, $3, $pop74
	i32.const	$push73=, 12345
	i32.add 	$push72=, $pop15, $pop73
	tee_local	$push71=, $2=, $pop72
	i32.store	$0=, myrnd.s($pop75), $pop71
	block
	i32.const	$push70=, 16
	i32.shr_u	$push69=, $2, $pop70
	tee_local	$push68=, $2=, $pop69
	i32.const	$push67=, 16
	i32.shr_u	$push14=, $3, $pop67
	i32.add 	$push22=, $pop68, $pop14
	i32.const	$push66=, 8
	i32.shr_u	$push20=, $1, $pop66
	i32.add 	$push21=, $pop20, $2
	i32.xor 	$push23=, $pop22, $pop21
	i32.const	$push65=, 1
	i32.and 	$push24=, $pop23, $pop65
	br_if   	0, $pop24       # 0: down to label14
# BB#1:                                 # %if.end
	i32.const	$push129=, 0
	i32.const	$push128=, 1103515245
	i32.mul 	$push25=, $0, $pop128
	i32.const	$push127=, 12345
	i32.add 	$push126=, $pop25, $pop127
	tee_local	$push125=, $2=, $pop126
	i32.const	$push124=, 1103515245
	i32.mul 	$push27=, $pop125, $pop124
	i32.const	$push123=, 12345
	i32.add 	$push2=, $pop27, $pop123
	i32.store	$3=, myrnd.s($pop129), $pop2
	i32.const	$push122=, 0
	i32.const	$push121=, 16
	i32.shr_u	$push120=, $2, $pop121
	tee_local	$push119=, $0=, $pop120
	i32.const	$push26=, 2047
	i32.and 	$push118=, $pop119, $pop26
	tee_local	$push117=, $2=, $pop118
	i32.const	$push116=, 8
	i32.shl 	$push28=, $pop117, $pop116
	i32.const	$push115=, 256
	i32.and 	$push29=, $pop28, $pop115
	i32.const	$push30=, -257
	i32.and 	$push31=, $1, $pop30
	i32.or  	$push32=, $pop29, $pop31
	i32.store16	$push0=, sV($pop122), $pop32
	i32.const	$push33=, 65280
	i32.and 	$push34=, $pop0, $pop33
	i32.const	$push114=, 8
	i32.shr_u	$push113=, $pop34, $pop114
	tee_local	$push112=, $4=, $pop113
	i32.xor 	$push35=, $pop112, $2
	i32.const	$push111=, 1
	i32.and 	$push36=, $pop35, $pop111
	br_if   	0, $pop36       # 0: down to label14
# BB#2:                                 # %lor.lhs.false89
	i32.const	$push135=, 16
	i32.shr_u	$push134=, $3, $pop135
	tee_local	$push133=, $2=, $pop134
	i32.add 	$push37=, $4, $pop133
	i32.const	$push132=, 1
	i32.and 	$push38=, $pop37, $pop132
	i32.const	$push39=, 15
	i32.rem_u	$push40=, $pop38, $pop39
	i32.add 	$push41=, $2, $0
	i32.const	$push131=, 1
	i32.and 	$push42=, $pop41, $pop131
	i32.const	$push130=, 15
	i32.rem_u	$push43=, $pop42, $pop130
	i32.ne  	$push44=, $pop40, $pop43
	br_if   	0, $pop44       # 0: down to label14
# BB#3:                                 # %lor.lhs.false136
	i32.const	$push52=, 0
	i32.const	$push45=, 1103515245
	i32.mul 	$push46=, $3, $pop45
	i32.const	$push47=, 12345
	i32.add 	$push152=, $pop46, $pop47
	tee_local	$push151=, $3=, $pop152
	i32.const	$push53=, 8
	i32.shr_u	$push54=, $pop151, $pop53
	i32.const	$push55=, 256
	i32.and 	$push56=, $pop54, $pop55
	i32.const	$push150=, 65279
	i32.and 	$push149=, $1, $pop150
	tee_local	$push148=, $1=, $pop149
	i32.or  	$push57=, $pop56, $pop148
	i32.const	$push147=, 8
	i32.shr_u	$push58=, $pop57, $pop147
	i32.const	$push146=, 0
	i32.const	$push145=, 1103515245
	i32.mul 	$push50=, $3, $pop145
	i32.const	$push144=, 12345
	i32.add 	$push51=, $pop50, $pop144
	i32.store	$push1=, myrnd.s($pop146), $pop51
	i32.const	$push48=, 16
	i32.shr_u	$push143=, $pop1, $pop48
	tee_local	$push142=, $2=, $pop143
	i32.add 	$push141=, $pop58, $pop142
	tee_local	$push140=, $0=, $pop141
	i32.const	$push139=, 8
	i32.shl 	$push59=, $pop140, $pop139
	i32.const	$push138=, 256
	i32.and 	$push60=, $pop59, $pop138
	i32.or  	$push61=, $pop60, $1
	i32.store16	$discard=, sV($pop52), $pop61
	i32.const	$push137=, 16
	i32.shr_u	$push49=, $3, $pop137
	i32.add 	$push62=, $2, $pop49
	i32.xor 	$push63=, $pop62, $0
	i32.const	$push136=, 1
	i32.and 	$push64=, $pop63, $pop136
	br_if   	0, $pop64       # 0: down to label14
# BB#4:                                 # %if.end142
	return
.LBB132_5:                              # %if.then141
	end_block                       # label14:
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
	i64.load	$push0=, 0($1)
	i64.store	$discard=, 0($0), $pop0
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
	i64.load	$push7=, 0($pop6)
	i64.store	$discard=, 0($pop5), $pop7
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
	i32.load	$push1=, sW+16($pop0)
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
	i32.load	$push1=, sW+16($pop0)
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
	i32.load	$push1=, sW+16($pop0)
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
	i32.load	$push9=, sW+16($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.add 	$push1=, $pop8, $0
	i32.const	$push2=, 4095
	i32.and 	$push7=, $pop1, $pop2
	tee_local	$push6=, $0=, $pop7
	i32.const	$push3=, -4096
	i32.and 	$push4=, $1, $pop3
	i32.or  	$push5=, $pop6, $pop4
	i32.store	$discard=, sW+16($pop0), $pop5
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
	i32.const	$push3=, 0
	i32.load	$1=, myrnd.s($pop3)
	i32.const	$0=, -32
.LBB138_1:                              # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label15:
	i32.const	$push41=, 1103515245
	i32.mul 	$push4=, $1, $pop41
	i32.const	$push40=, 12345
	i32.add 	$push39=, $pop4, $pop40
	tee_local	$push38=, $1=, $pop39
	i32.const	$push37=, 16
	i32.shr_u	$push5=, $pop38, $pop37
	i32.store8	$discard=, sW+32($0), $pop5
	i32.const	$push36=, 1
	i32.add 	$0=, $0, $pop36
	br_if   	0, $0           # 0: up to label15
# BB#2:                                 # %for.end
	end_loop                        # label16:
	i32.const	$push6=, 0
	i32.const	$push10=, 1103515245
	i32.mul 	$push11=, $1, $pop10
	i32.const	$push12=, 12345
	i32.add 	$push73=, $pop11, $pop12
	tee_local	$push72=, $1=, $pop73
	i32.const	$push13=, 16
	i32.shr_u	$push14=, $pop72, $pop13
	i32.const	$push15=, 2047
	i32.and 	$push16=, $pop14, $pop15
	i32.const	$push71=, 0
	i32.load	$push9=, sW+16($pop71)
	i32.const	$push19=, -4096
	i32.and 	$push70=, $pop9, $pop19
	tee_local	$push69=, $0=, $pop70
	i32.or  	$push20=, $pop16, $pop69
	i32.store	$discard=, sW+16($pop6), $pop20
	i32.const	$push68=, 0
	i32.const	$push67=, 0
	i32.const	$push66=, 1103515245
	i32.mul 	$push17=, $1, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push18=, $pop17, $pop65
	i32.store	$push0=, myrnd.s($pop67), $pop18
	i32.const	$push64=, 1103515245
	i32.mul 	$push21=, $pop0, $pop64
	i32.const	$push63=, 12345
	i32.add 	$push62=, $pop21, $pop63
	tee_local	$push61=, $1=, $pop62
	i32.const	$push60=, 16
	i32.shr_u	$push22=, $pop61, $pop60
	i32.const	$push59=, 2047
	i32.and 	$push23=, $pop22, $pop59
	i32.or  	$push26=, $pop23, $0
	i32.store	$discard=, sW+16($pop68), $pop26
	i32.const	$push58=, 0
	i32.const	$push57=, 0
	i32.const	$push56=, 0
	i32.const	$push55=, 1103515245
	i32.mul 	$push24=, $1, $pop55
	i32.const	$push54=, 12345
	i32.add 	$push25=, $pop24, $pop54
	i32.store	$push1=, myrnd.s($pop56), $pop25
	i32.const	$push53=, 1103515245
	i32.mul 	$push27=, $pop1, $pop53
	i32.const	$push52=, 12345
	i32.add 	$push51=, $pop27, $pop52
	tee_local	$push50=, $1=, $pop51
	i32.const	$push49=, 1103515245
	i32.mul 	$push30=, $pop50, $pop49
	i32.const	$push48=, 12345
	i32.add 	$push31=, $pop30, $pop48
	i32.store	$push2=, myrnd.s($pop57), $pop31
	i32.const	$push47=, 16
	i32.shr_u	$push32=, $pop2, $pop47
	i32.const	$push46=, 2047
	i32.and 	$push33=, $pop32, $pop46
	i32.const	$push45=, 16
	i32.shr_u	$push28=, $1, $pop45
	i32.const	$push44=, 2047
	i32.and 	$push29=, $pop28, $pop44
	i32.add 	$push34=, $pop33, $pop29
	i32.or  	$push35=, $pop34, $0
	i32.store	$discard=, sW+16($pop58), $pop35
	i32.const	$push43=, 0
	i64.const	$push7=, 4612055454334320640
	i64.store	$discard=, sW+8($pop43), $pop7
	i32.const	$push42=, 0
	i64.const	$push8=, 0
	i64.store	$discard=, sW($pop42), $pop8
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
	i64.load	$push0=, 0($1)
	i64.store	$discard=, 0($0), $pop0
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
	i64.load	$push7=, 0($pop6)
	i64.store	$discard=, 0($pop5), $pop7
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
	i32.load	$push1=, sX($pop0)
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
	i32.load	$push1=, sX($pop0)
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
	i32.load	$push1=, sX($pop0)
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
	i32.load	$push9=, sX($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.add 	$push1=, $pop8, $0
	i32.const	$push2=, 4095
	i32.and 	$push7=, $pop1, $pop2
	tee_local	$push6=, $0=, $pop7
	i32.const	$push3=, -4096
	i32.and 	$push4=, $1, $pop3
	i32.or  	$push5=, $pop6, $pop4
	i32.store	$discard=, sX($pop0), $pop5
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
	i32.const	$push3=, 0
	i32.load	$1=, myrnd.s($pop3)
	i32.const	$0=, -32
.LBB144_1:                              # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label17:
	i32.const	$push41=, 1103515245
	i32.mul 	$push4=, $1, $pop41
	i32.const	$push40=, 12345
	i32.add 	$push39=, $pop4, $pop40
	tee_local	$push38=, $1=, $pop39
	i32.const	$push37=, 16
	i32.shr_u	$push5=, $pop38, $pop37
	i32.store8	$discard=, sX+32($0), $pop5
	i32.const	$push36=, 1
	i32.add 	$0=, $0, $pop36
	br_if   	0, $0           # 0: up to label17
# BB#2:                                 # %for.end
	end_loop                        # label18:
	i32.const	$push6=, 0
	i32.const	$push10=, 1103515245
	i32.mul 	$push11=, $1, $pop10
	i32.const	$push12=, 12345
	i32.add 	$push73=, $pop11, $pop12
	tee_local	$push72=, $1=, $pop73
	i32.const	$push13=, 16
	i32.shr_u	$push14=, $pop72, $pop13
	i32.const	$push15=, 2047
	i32.and 	$push16=, $pop14, $pop15
	i32.const	$push71=, 0
	i32.load	$push9=, sX($pop71)
	i32.const	$push19=, -4096
	i32.and 	$push70=, $pop9, $pop19
	tee_local	$push69=, $0=, $pop70
	i32.or  	$push20=, $pop16, $pop69
	i32.store	$discard=, sX($pop6), $pop20
	i32.const	$push68=, 0
	i32.const	$push67=, 0
	i32.const	$push66=, 1103515245
	i32.mul 	$push17=, $1, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push18=, $pop17, $pop65
	i32.store	$push0=, myrnd.s($pop67), $pop18
	i32.const	$push64=, 1103515245
	i32.mul 	$push21=, $pop0, $pop64
	i32.const	$push63=, 12345
	i32.add 	$push62=, $pop21, $pop63
	tee_local	$push61=, $1=, $pop62
	i32.const	$push60=, 16
	i32.shr_u	$push22=, $pop61, $pop60
	i32.const	$push59=, 2047
	i32.and 	$push23=, $pop22, $pop59
	i32.or  	$push26=, $pop23, $0
	i32.store	$discard=, sX($pop68), $pop26
	i32.const	$push58=, 0
	i32.const	$push57=, 0
	i32.const	$push56=, 0
	i32.const	$push55=, 1103515245
	i32.mul 	$push24=, $1, $pop55
	i32.const	$push54=, 12345
	i32.add 	$push25=, $pop24, $pop54
	i32.store	$push1=, myrnd.s($pop56), $pop25
	i32.const	$push53=, 1103515245
	i32.mul 	$push27=, $pop1, $pop53
	i32.const	$push52=, 12345
	i32.add 	$push51=, $pop27, $pop52
	tee_local	$push50=, $1=, $pop51
	i32.const	$push49=, 1103515245
	i32.mul 	$push30=, $pop50, $pop49
	i32.const	$push48=, 12345
	i32.add 	$push31=, $pop30, $pop48
	i32.store	$push2=, myrnd.s($pop57), $pop31
	i32.const	$push47=, 16
	i32.shr_u	$push32=, $pop2, $pop47
	i32.const	$push46=, 2047
	i32.and 	$push33=, $pop32, $pop46
	i32.const	$push45=, 16
	i32.shr_u	$push28=, $1, $pop45
	i32.const	$push44=, 2047
	i32.and 	$push29=, $pop28, $pop44
	i32.add 	$push34=, $pop33, $pop29
	i32.or  	$push35=, $pop34, $0
	i32.store	$discard=, sX($pop58), $pop35
	i32.const	$push43=, 0
	i64.const	$push7=, 4612055454334320640
	i64.store	$discard=, sX+24($pop43), $pop7
	i32.const	$push42=, 0
	i64.const	$push8=, 0
	i64.store	$discard=, sX+16($pop42), $pop8
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
	i64.load	$push0=, 0($1)
	i64.store	$discard=, 0($0), $pop0
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
	i64.load	$push7=, 0($pop6)
	i64.store	$discard=, 0($pop5), $pop7
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
	i32.load	$push1=, sY($pop0)
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
	i32.load	$push1=, sY($pop0)
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
	i32.load	$push1=, sY($pop0)
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
	i32.load	$push9=, sY($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.add 	$push1=, $pop8, $0
	i32.const	$push2=, 4095
	i32.and 	$push7=, $pop1, $pop2
	tee_local	$push6=, $0=, $pop7
	i32.const	$push3=, -4096
	i32.and 	$push4=, $1, $pop3
	i32.or  	$push5=, $pop6, $pop4
	i32.store	$discard=, sY($pop0), $pop5
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
	i32.const	$push3=, 0
	i32.load	$1=, myrnd.s($pop3)
	i32.const	$0=, -32
.LBB150_1:                              # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label19:
	i32.const	$push41=, 1103515245
	i32.mul 	$push4=, $1, $pop41
	i32.const	$push40=, 12345
	i32.add 	$push39=, $pop4, $pop40
	tee_local	$push38=, $1=, $pop39
	i32.const	$push37=, 16
	i32.shr_u	$push5=, $pop38, $pop37
	i32.store8	$discard=, sY+32($0), $pop5
	i32.const	$push36=, 1
	i32.add 	$0=, $0, $pop36
	br_if   	0, $0           # 0: up to label19
# BB#2:                                 # %for.end
	end_loop                        # label20:
	i32.const	$push6=, 0
	i32.const	$push10=, 1103515245
	i32.mul 	$push11=, $1, $pop10
	i32.const	$push12=, 12345
	i32.add 	$push73=, $pop11, $pop12
	tee_local	$push72=, $1=, $pop73
	i32.const	$push13=, 16
	i32.shr_u	$push14=, $pop72, $pop13
	i32.const	$push15=, 2047
	i32.and 	$push16=, $pop14, $pop15
	i32.const	$push71=, 0
	i32.load	$push9=, sY($pop71)
	i32.const	$push19=, -4096
	i32.and 	$push70=, $pop9, $pop19
	tee_local	$push69=, $0=, $pop70
	i32.or  	$push20=, $pop16, $pop69
	i32.store	$discard=, sY($pop6), $pop20
	i32.const	$push68=, 0
	i32.const	$push67=, 0
	i32.const	$push66=, 1103515245
	i32.mul 	$push17=, $1, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push18=, $pop17, $pop65
	i32.store	$push0=, myrnd.s($pop67), $pop18
	i32.const	$push64=, 1103515245
	i32.mul 	$push21=, $pop0, $pop64
	i32.const	$push63=, 12345
	i32.add 	$push62=, $pop21, $pop63
	tee_local	$push61=, $1=, $pop62
	i32.const	$push60=, 16
	i32.shr_u	$push22=, $pop61, $pop60
	i32.const	$push59=, 2047
	i32.and 	$push23=, $pop22, $pop59
	i32.or  	$push26=, $pop23, $0
	i32.store	$discard=, sY($pop68), $pop26
	i32.const	$push58=, 0
	i32.const	$push57=, 0
	i32.const	$push56=, 0
	i32.const	$push55=, 1103515245
	i32.mul 	$push24=, $1, $pop55
	i32.const	$push54=, 12345
	i32.add 	$push25=, $pop24, $pop54
	i32.store	$push1=, myrnd.s($pop56), $pop25
	i32.const	$push53=, 1103515245
	i32.mul 	$push27=, $pop1, $pop53
	i32.const	$push52=, 12345
	i32.add 	$push51=, $pop27, $pop52
	tee_local	$push50=, $1=, $pop51
	i32.const	$push49=, 1103515245
	i32.mul 	$push30=, $pop50, $pop49
	i32.const	$push48=, 12345
	i32.add 	$push31=, $pop30, $pop48
	i32.store	$push2=, myrnd.s($pop57), $pop31
	i32.const	$push47=, 16
	i32.shr_u	$push32=, $pop2, $pop47
	i32.const	$push46=, 2047
	i32.and 	$push33=, $pop32, $pop46
	i32.const	$push45=, 16
	i32.shr_u	$push28=, $1, $pop45
	i32.const	$push44=, 2047
	i32.and 	$push29=, $pop28, $pop44
	i32.add 	$push34=, $pop33, $pop29
	i32.or  	$push35=, $pop34, $0
	i32.store	$discard=, sY($pop58), $pop35
	i32.const	$push43=, 0
	i64.const	$push7=, 4612055454334320640
	i64.store	$discard=, sY+24($pop43), $pop7
	i32.const	$push42=, 0
	i64.const	$push8=, 0
	i64.store	$discard=, sY+16($pop42), $pop8
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
	i64.load	$push0=, 0($1)
	i64.store	$discard=, 0($0), $pop0
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
	i64.load	$push7=, 0($pop6)
	i64.store	$discard=, 0($pop5), $pop7
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
	i32.load	$push1=, sZ+16($pop0)
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
	i32.load	$push1=, sZ+16($pop0)
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
	i32.load	$push1=, sZ+16($pop0)
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
	i32.load	$push1=, sZ+16($pop8)
	i32.const	$push2=, 20
	i32.shl 	$push3=, $0, $pop2
	i32.add 	$push7=, $pop1, $pop3
	tee_local	$push6=, $0=, $pop7
	i32.store	$discard=, sZ+16($pop0), $pop6
	i32.const	$push5=, 20
	i32.shr_u	$push4=, $0, $pop5
	return  	$pop4
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
	i32.const	$push3=, 0
	i32.load	$3=, myrnd.s($pop3)
	i32.const	$2=, -32
.LBB156_1:                              # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label21:
	i32.const	$push49=, 1103515245
	i32.mul 	$push4=, $3, $pop49
	i32.const	$push48=, 12345
	i32.add 	$push47=, $pop4, $pop48
	tee_local	$push46=, $3=, $pop47
	i32.const	$push45=, 16
	i32.shr_u	$push5=, $pop46, $pop45
	i32.store8	$discard=, sZ+32($2), $pop5
	i32.const	$push44=, 1
	i32.add 	$2=, $2, $pop44
	br_if   	0, $2           # 0: up to label21
# BB#2:                                 # %for.end
	end_loop                        # label22:
	i32.const	$push75=, 0
	i32.const	$push74=, 1103515245
	i32.mul 	$push8=, $3, $pop74
	i32.const	$push73=, 12345
	i32.add 	$push72=, $pop8, $pop73
	tee_local	$push71=, $3=, $pop72
	i32.const	$push70=, 16
	i32.shr_u	$push9=, $pop71, $pop70
	i32.const	$push69=, 2047
	i32.and 	$push68=, $pop9, $pop69
	tee_local	$push67=, $4=, $pop68
	i32.const	$push66=, 20
	i32.shl 	$push12=, $pop67, $pop66
	i32.const	$push65=, 0
	i32.load	$push1=, sZ+16($pop65)
	i32.const	$push13=, 1048575
	i32.and 	$push64=, $pop1, $pop13
	tee_local	$push63=, $2=, $pop64
	i32.or  	$push14=, $pop12, $pop63
	i32.store	$1=, sZ+16($pop75), $pop14
	i32.const	$push62=, 0
	i64.const	$push6=, 4612055454334320640
	i64.store	$discard=, sZ+8($pop62), $pop6
	i32.const	$push61=, 0
	i64.const	$push7=, 0
	i64.store	$discard=, sZ($pop61), $pop7
	i32.const	$push60=, 0
	i32.const	$push59=, 1103515245
	i32.mul 	$push10=, $3, $pop59
	i32.const	$push58=, 12345
	i32.add 	$push57=, $pop10, $pop58
	tee_local	$push56=, $3=, $pop57
	i32.store	$0=, myrnd.s($pop60), $pop56
	block
	i32.const	$push55=, 16
	i32.shr_u	$push11=, $3, $pop55
	i32.const	$push54=, 2047
	i32.and 	$push53=, $pop11, $pop54
	tee_local	$push52=, $3=, $pop53
	i32.add 	$push18=, $pop52, $4
	i32.const	$push51=, 20
	i32.shl 	$push15=, $3, $pop51
	i32.add 	$push16=, $1, $pop15
	i32.const	$push50=, 20
	i32.shr_u	$push17=, $pop16, $pop50
	i32.ne  	$push19=, $pop18, $pop17
	br_if   	0, $pop19       # 0: down to label23
# BB#3:                                 # %if.end80
	i32.const	$push99=, 0
	i32.const	$push98=, 0
	i32.const	$push97=, 1103515245
	i32.mul 	$push20=, $0, $pop97
	i32.const	$push96=, 12345
	i32.add 	$push95=, $pop20, $pop96
	tee_local	$push94=, $3=, $pop95
	i32.const	$push26=, -1029531031
	i32.mul 	$push27=, $pop94, $pop26
	i32.const	$push28=, -740551042
	i32.add 	$push93=, $pop27, $pop28
	tee_local	$push92=, $4=, $pop93
	i32.const	$push91=, 1103515245
	i32.mul 	$push30=, $pop92, $pop91
	i32.const	$push90=, 12345
	i32.add 	$push31=, $pop30, $pop90
	i32.store	$push0=, myrnd.s($pop98), $pop31
	i32.const	$push89=, 16
	i32.shr_u	$push32=, $pop0, $pop89
	i32.const	$push88=, 2047
	i32.and 	$push87=, $pop32, $pop88
	tee_local	$push86=, $1=, $pop87
	i32.const	$push85=, 20
	i32.shl 	$push35=, $pop86, $pop85
	i32.const	$push84=, 16
	i32.shr_u	$push29=, $4, $pop84
	i32.const	$push83=, 2047
	i32.and 	$push82=, $pop29, $pop83
	tee_local	$push81=, $4=, $pop82
	i32.const	$push80=, 20
	i32.shl 	$push33=, $pop81, $pop80
	i32.or  	$push34=, $pop33, $2
	i32.add 	$push2=, $pop35, $pop34
	i32.store	$push79=, sZ+16($pop99), $pop2
	tee_local	$push78=, $0=, $pop79
	i32.const	$push21=, 4
	i32.shl 	$push22=, $3, $pop21
	i32.const	$push23=, 2146435072
	i32.and 	$push24=, $pop22, $pop23
	i32.or  	$push25=, $pop24, $2
	i32.xor 	$push77=, $pop78, $pop25
	tee_local	$push76=, $2=, $pop77
	i32.const	$push36=, 1040384
	i32.and 	$push37=, $pop76, $pop36
	br_if   	0, $pop37       # 0: down to label23
# BB#4:                                 # %lor.lhs.false98
	i32.add 	$push42=, $1, $4
	i32.const	$push39=, 20
	i32.shr_u	$push40=, $0, $pop39
	i32.ne  	$push43=, $pop42, $pop40
	br_if   	0, $pop43       # 0: down to label23
# BB#5:                                 # %lor.lhs.false98
	i32.const	$push41=, 8191
	i32.and 	$push38=, $2, $pop41
	br_if   	0, $pop38       # 0: down to label23
# BB#6:                                 # %if.end121
	return
.LBB156_7:                              # %if.then120
	end_block                       # label23:
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
