	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040709-1.c"
	.section	.text.myrnd,"ax",@progbits
	.hidden	myrnd
	.globl	myrnd
	.type	myrnd,@function
myrnd:                                  # @myrnd
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push11=, 0
	i32.load	$push2=, myrnd.s($pop11)
	i32.const	$push3=, 1103515245
	i32.mul 	$push4=, $pop2, $pop3
	i32.const	$push5=, 12345
	i32.add 	$push6=, $pop4, $pop5
	i32.store	$push0=, myrnd.s($pop1), $pop6
	i32.const	$push7=, 16
	i32.shr_u	$push8=, $pop0, $pop7
	i32.const	$push9=, 2047
	i32.and 	$push10=, $pop8, $pop9
                                        # fallthrough-return: $pop10
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
	i32.store	$drop=, 0($0), $pop0
                                        # fallthrough-return
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
	i32.const	$push2=, 0
	i32.load	$push3=, sA($pop2)
	i32.const	$push0=, 17
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push4=, $pop3, $pop1
	i32.const	$push6=, 17
	i32.shr_u	$push5=, $pop4, $pop6
                                        # fallthrough-return: $pop5
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
                                        # fallthrough-return: $pop8
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
                                        # fallthrough-return: $pop3
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
	i32.const	$push3=, 0
	i32.const	$push8=, 0
	i32.load	$push4=, sA($pop8)
	i32.const	$push1=, 17
	i32.shl 	$push2=, $0, $pop1
	i32.add 	$push5=, $pop4, $pop2
	i32.store	$push0=, sA($pop3), $pop5
	i32.const	$push7=, 17
	i32.shr_u	$push6=, $pop0, $pop7
                                        # fallthrough-return: $pop6
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
	i32.const	$push91=, 0
	i32.const	$push90=, 0
	i32.load	$push4=, myrnd.s($pop90)
	i32.const	$push89=, 1103515245
	i32.mul 	$push5=, $pop4, $pop89
	i32.const	$push88=, 12345
	i32.add 	$push87=, $pop5, $pop88
	tee_local	$push86=, $2=, $pop87
	i32.const	$push85=, 16
	i32.shr_u	$push6=, $pop86, $pop85
	i32.store8	$drop=, sA($pop91), $pop6
	i32.const	$push84=, 0
	i32.const	$push83=, 1103515245
	i32.mul 	$push7=, $2, $pop83
	i32.const	$push82=, 12345
	i32.add 	$push81=, $pop7, $pop82
	tee_local	$push80=, $2=, $pop81
	i32.const	$push79=, 16
	i32.shr_u	$push8=, $pop80, $pop79
	i32.store8	$drop=, sA+1($pop84), $pop8
	i32.const	$push78=, 0
	i32.const	$push77=, 1103515245
	i32.mul 	$push9=, $2, $pop77
	i32.const	$push76=, 12345
	i32.add 	$push75=, $pop9, $pop76
	tee_local	$push74=, $2=, $pop75
	i32.const	$push73=, 16
	i32.shr_u	$push10=, $pop74, $pop73
	i32.store8	$drop=, sA+2($pop78), $pop10
	i32.const	$push72=, 0
	i32.const	$push71=, 1103515245
	i32.mul 	$push11=, $2, $pop71
	i32.const	$push70=, 12345
	i32.add 	$push69=, $pop11, $pop70
	tee_local	$push68=, $2=, $pop69
	i32.const	$push67=, 16
	i32.shr_u	$push12=, $pop68, $pop67
	i32.store8	$drop=, sA+3($pop72), $pop12
	block
	i32.const	$push66=, 0
	i32.const	$push65=, 1103515245
	i32.mul 	$push13=, $2, $pop65
	i32.const	$push64=, 12345
	i32.add 	$push63=, $pop13, $pop64
	tee_local	$push62=, $2=, $pop63
	i32.const	$push61=, 1103515245
	i32.mul 	$push14=, $pop62, $pop61
	i32.const	$push60=, 12345
	i32.add 	$push2=, $pop14, $pop60
	i32.store	$push59=, myrnd.s($pop66), $pop2
	tee_local	$push58=, $0=, $pop59
	i32.const	$push57=, 16
	i32.shr_u	$push18=, $pop58, $pop57
	i32.const	$push56=, 2047
	i32.and 	$push55=, $pop18, $pop56
	tee_local	$push54=, $3=, $pop55
	i32.const	$push53=, 16
	i32.shr_u	$push15=, $2, $pop53
	i32.const	$push52=, 2047
	i32.and 	$push51=, $pop15, $pop52
	tee_local	$push50=, $2=, $pop51
	i32.add 	$push19=, $pop54, $pop50
	i32.const	$push49=, 17
	i32.shl 	$push20=, $3, $pop49
	i32.const	$push48=, 0
	i32.const	$push47=, 17
	i32.shl 	$push16=, $2, $pop47
	i32.const	$push46=, 0
	i32.load	$push45=, sA($pop46)
	tee_local	$push44=, $2=, $pop45
	i32.const	$push43=, 131071
	i32.and 	$push42=, $pop44, $pop43
	tee_local	$push41=, $3=, $pop42
	i32.or  	$push17=, $pop16, $pop41
	i32.store	$push0=, sA($pop48), $pop17
	i32.add 	$push21=, $pop20, $pop0
	i32.const	$push40=, 17
	i32.shr_u	$push22=, $pop21, $pop40
	i32.ne  	$push23=, $pop19, $pop22
	br_if   	0, $pop23       # 0: down to label0
# BB#1:                                 # %if.end87
	i32.const	$push110=, 0
	i32.const	$push109=, 0
	i32.const	$push24=, -2139243339
	i32.mul 	$push25=, $0, $pop24
	i32.const	$push26=, -1492899873
	i32.add 	$push108=, $pop25, $pop26
	tee_local	$push107=, $0=, $pop108
	i32.const	$push106=, 1103515245
	i32.mul 	$push27=, $pop107, $pop106
	i32.const	$push105=, 12345
	i32.add 	$push28=, $pop27, $pop105
	i32.store	$push1=, myrnd.s($pop109), $pop28
	i32.const	$push104=, 16
	i32.shr_u	$push32=, $pop1, $pop104
	i32.const	$push103=, 2047
	i32.and 	$push102=, $pop32, $pop103
	tee_local	$push101=, $1=, $pop102
	i32.const	$push100=, 17
	i32.shl 	$push33=, $pop101, $pop100
	i32.const	$push99=, 16
	i32.shr_u	$push29=, $0, $pop99
	i32.const	$push98=, 2047
	i32.and 	$push97=, $pop29, $pop98
	tee_local	$push96=, $0=, $pop97
	i32.const	$push95=, 17
	i32.shl 	$push30=, $pop96, $pop95
	i32.or  	$push31=, $pop30, $3
	i32.add 	$push3=, $pop33, $pop31
	i32.store	$push94=, sA($pop110), $pop3
	tee_local	$push93=, $3=, $pop94
	i32.xor 	$push34=, $pop93, $2
	i32.const	$push92=, 131071
	i32.and 	$push35=, $pop34, $pop92
	br_if   	0, $pop35       # 0: down to label0
# BB#2:                                 # %lor.lhs.false125
	i32.add 	$push38=, $1, $0
	i32.const	$push36=, 17
	i32.shr_u	$push37=, $3, $pop36
	i32.ne  	$push39=, $pop38, $pop37
	br_if   	0, $pop39       # 0: down to label0
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
	i64.store	$drop=, 0($0):p2align=2, $pop0
                                        # fallthrough-return
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
	i32.const	$push2=, 0
	i32.load	$push3=, sB($pop2)
	i32.const	$push0=, 17
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push4=, $pop3, $pop1
	i32.const	$push6=, 17
	i32.shr_u	$push5=, $pop4, $pop6
                                        # fallthrough-return: $pop5
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
                                        # fallthrough-return: $pop8
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
                                        # fallthrough-return: $pop3
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
	i32.const	$push3=, 0
	i32.const	$push8=, 0
	i32.load	$push4=, sB($pop8)
	i32.const	$push1=, 17
	i32.shl 	$push2=, $0, $pop1
	i32.add 	$push5=, $pop4, $pop2
	i32.store	$push0=, sB($pop3), $pop5
	i32.const	$push7=, 17
	i32.shr_u	$push6=, $pop0, $pop7
                                        # fallthrough-return: $pop6
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
	i32.const	$push129=, 0
	i32.const	$push128=, 0
	i32.load	$push4=, myrnd.s($pop128)
	i32.const	$push127=, 1103515245
	i32.mul 	$push5=, $pop4, $pop127
	i32.const	$push126=, 12345
	i32.add 	$push125=, $pop5, $pop126
	tee_local	$push124=, $2=, $pop125
	i32.const	$push123=, 16
	i32.shr_u	$push6=, $pop124, $pop123
	i32.store8	$drop=, sB($pop129), $pop6
	i32.const	$push122=, 0
	i32.const	$push121=, 1103515245
	i32.mul 	$push7=, $2, $pop121
	i32.const	$push120=, 12345
	i32.add 	$push119=, $pop7, $pop120
	tee_local	$push118=, $2=, $pop119
	i32.const	$push117=, 16
	i32.shr_u	$push8=, $pop118, $pop117
	i32.store8	$drop=, sB+1($pop122), $pop8
	i32.const	$push116=, 0
	i32.const	$push115=, 1103515245
	i32.mul 	$push9=, $2, $pop115
	i32.const	$push114=, 12345
	i32.add 	$push113=, $pop9, $pop114
	tee_local	$push112=, $2=, $pop113
	i32.const	$push111=, 16
	i32.shr_u	$push10=, $pop112, $pop111
	i32.store8	$drop=, sB+2($pop116), $pop10
	i32.const	$push110=, 0
	i32.const	$push109=, 1103515245
	i32.mul 	$push11=, $2, $pop109
	i32.const	$push108=, 12345
	i32.add 	$push107=, $pop11, $pop108
	tee_local	$push106=, $2=, $pop107
	i32.const	$push105=, 16
	i32.shr_u	$push12=, $pop106, $pop105
	i32.store8	$drop=, sB+3($pop110), $pop12
	i32.const	$push104=, 0
	i32.const	$push103=, 1103515245
	i32.mul 	$push13=, $2, $pop103
	i32.const	$push102=, 12345
	i32.add 	$push101=, $pop13, $pop102
	tee_local	$push100=, $2=, $pop101
	i32.const	$push99=, 16
	i32.shr_u	$push14=, $pop100, $pop99
	i32.store8	$drop=, sB+4($pop104), $pop14
	i32.const	$push98=, 0
	i32.const	$push97=, 1103515245
	i32.mul 	$push15=, $2, $pop97
	i32.const	$push96=, 12345
	i32.add 	$push95=, $pop15, $pop96
	tee_local	$push94=, $2=, $pop95
	i32.const	$push93=, 16
	i32.shr_u	$push16=, $pop94, $pop93
	i32.store8	$drop=, sB+5($pop98), $pop16
	i32.const	$push92=, 0
	i32.const	$push91=, 1103515245
	i32.mul 	$push17=, $2, $pop91
	i32.const	$push90=, 12345
	i32.add 	$push89=, $pop17, $pop90
	tee_local	$push88=, $2=, $pop89
	i32.const	$push87=, 16
	i32.shr_u	$push18=, $pop88, $pop87
	i32.store8	$drop=, sB+6($pop92), $pop18
	i32.const	$push86=, 0
	i32.const	$push85=, 1103515245
	i32.mul 	$push19=, $2, $pop85
	i32.const	$push84=, 12345
	i32.add 	$push83=, $pop19, $pop84
	tee_local	$push82=, $2=, $pop83
	i32.const	$push81=, 16
	i32.shr_u	$push20=, $pop82, $pop81
	i32.store8	$drop=, sB+7($pop86), $pop20
	i32.const	$push80=, 0
	i32.load	$3=, sB($pop80)
	block
	i32.const	$push79=, 0
	i32.const	$push78=, 1103515245
	i32.mul 	$push21=, $2, $pop78
	i32.const	$push77=, 12345
	i32.add 	$push76=, $pop21, $pop77
	tee_local	$push75=, $2=, $pop76
	i32.const	$push74=, 1103515245
	i32.mul 	$push22=, $pop75, $pop74
	i32.const	$push73=, 12345
	i32.add 	$push1=, $pop22, $pop73
	i32.store	$push72=, myrnd.s($pop79), $pop1
	tee_local	$push71=, $0=, $pop72
	i32.const	$push70=, 16
	i32.shr_u	$push26=, $pop71, $pop70
	i32.const	$push69=, 2047
	i32.and 	$push68=, $pop26, $pop69
	tee_local	$push67=, $4=, $pop68
	i32.const	$push66=, 16
	i32.shr_u	$push24=, $2, $pop66
	i32.const	$push65=, 2047
	i32.and 	$push64=, $pop24, $pop65
	tee_local	$push63=, $2=, $pop64
	i32.add 	$push27=, $pop67, $pop63
	i32.const	$push62=, 17
	i32.shl 	$push28=, $4, $pop62
	i32.const	$push61=, 0
	i32.const	$push60=, 17
	i32.shl 	$push25=, $2, $pop60
	i32.const	$push59=, 131071
	i32.and 	$push23=, $3, $pop59
	i32.or  	$push2=, $pop25, $pop23
	i32.store	$push58=, sB($pop61), $pop2
	tee_local	$push57=, $2=, $pop58
	i32.add 	$push29=, $pop28, $pop57
	i32.const	$push56=, 17
	i32.shr_u	$push30=, $pop29, $pop56
	i32.ne  	$push31=, $pop27, $pop30
	br_if   	0, $pop31       # 0: down to label1
# BB#1:                                 # %if.end76
	i32.const	$push156=, 0
	i32.const	$push155=, 0
	i32.const	$push154=, 1103515245
	i32.mul 	$push32=, $0, $pop154
	i32.const	$push153=, 12345
	i32.add 	$push152=, $pop32, $pop153
	tee_local	$push151=, $3=, $pop152
	i32.const	$push33=, -1029531031
	i32.mul 	$push34=, $pop151, $pop33
	i32.const	$push35=, -740551042
	i32.add 	$push150=, $pop34, $pop35
	tee_local	$push149=, $4=, $pop150
	i32.const	$push148=, 1103515245
	i32.mul 	$push36=, $pop149, $pop148
	i32.const	$push147=, 12345
	i32.add 	$push37=, $pop36, $pop147
	i32.store	$push0=, myrnd.s($pop155), $pop37
	i32.const	$push146=, 16
	i32.shr_u	$push41=, $pop0, $pop146
	i32.const	$push145=, 2047
	i32.and 	$push144=, $pop41, $pop145
	tee_local	$push143=, $0=, $pop144
	i32.const	$push142=, 17
	i32.shl 	$push42=, $pop143, $pop142
	i32.const	$push141=, 16
	i32.shr_u	$push38=, $4, $pop141
	i32.const	$push140=, 2047
	i32.and 	$push139=, $pop38, $pop140
	tee_local	$push138=, $4=, $pop139
	i32.const	$push137=, 17
	i32.shl 	$push39=, $pop138, $pop137
	i32.const	$push136=, 131071
	i32.and 	$push135=, $2, $pop136
	tee_local	$push134=, $2=, $pop135
	i32.or  	$push40=, $pop39, $pop134
	i32.add 	$push3=, $pop42, $pop40
	i32.store	$push133=, sB($pop156), $pop3
	tee_local	$push132=, $1=, $pop133
	i32.const	$push43=, 1
	i32.shl 	$push44=, $3, $pop43
	i32.const	$push45=, 268304384
	i32.and 	$push46=, $pop44, $pop45
	i32.or  	$push47=, $pop46, $2
	i32.xor 	$push131=, $pop132, $pop47
	tee_local	$push130=, $2=, $pop131
	i32.const	$push48=, 63
	i32.and 	$push49=, $pop130, $pop48
	br_if   	0, $pop49       # 0: down to label1
# BB#2:                                 # %lor.lhs.false91
	i32.add 	$push53=, $0, $4
	i32.const	$push51=, 17
	i32.shr_u	$push52=, $1, $pop51
	i32.ne  	$push54=, $pop53, $pop52
	br_if   	0, $pop54       # 0: down to label1
# BB#3:                                 # %lor.lhs.false91
	i32.const	$push55=, 131008
	i32.and 	$push50=, $2, $pop55
	br_if   	0, $pop50       # 0: down to label1
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
	i64.store	$drop=, 0($0):p2align=2, $pop0
                                        # fallthrough-return
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
	i32.const	$push2=, 0
	i32.load	$push3=, sC+4($pop2)
	i32.const	$push0=, 17
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push4=, $pop3, $pop1
	i32.const	$push6=, 17
	i32.shr_u	$push5=, $pop4, $pop6
                                        # fallthrough-return: $pop5
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
                                        # fallthrough-return: $pop8
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
                                        # fallthrough-return: $pop3
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
	i32.const	$push3=, 0
	i32.const	$push8=, 0
	i32.load	$push4=, sC+4($pop8)
	i32.const	$push1=, 17
	i32.shl 	$push2=, $0, $pop1
	i32.add 	$push5=, $pop4, $pop2
	i32.store	$push0=, sC+4($pop3), $pop5
	i32.const	$push7=, 17
	i32.shr_u	$push6=, $pop0, $pop7
                                        # fallthrough-return: $pop6
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
	i32.const	$push129=, 0
	i32.const	$push128=, 0
	i32.load	$push4=, myrnd.s($pop128)
	i32.const	$push127=, 1103515245
	i32.mul 	$push5=, $pop4, $pop127
	i32.const	$push126=, 12345
	i32.add 	$push125=, $pop5, $pop126
	tee_local	$push124=, $3=, $pop125
	i32.const	$push123=, 16
	i32.shr_u	$push6=, $pop124, $pop123
	i32.store8	$drop=, sC($pop129), $pop6
	i32.const	$push122=, 0
	i32.const	$push121=, 1103515245
	i32.mul 	$push7=, $3, $pop121
	i32.const	$push120=, 12345
	i32.add 	$push119=, $pop7, $pop120
	tee_local	$push118=, $3=, $pop119
	i32.const	$push117=, 16
	i32.shr_u	$push8=, $pop118, $pop117
	i32.store8	$drop=, sC+1($pop122), $pop8
	i32.const	$push116=, 0
	i32.const	$push115=, 1103515245
	i32.mul 	$push9=, $3, $pop115
	i32.const	$push114=, 12345
	i32.add 	$push113=, $pop9, $pop114
	tee_local	$push112=, $3=, $pop113
	i32.const	$push111=, 16
	i32.shr_u	$push10=, $pop112, $pop111
	i32.store8	$drop=, sC+2($pop116), $pop10
	i32.const	$push110=, 0
	i32.const	$push109=, 1103515245
	i32.mul 	$push11=, $3, $pop109
	i32.const	$push108=, 12345
	i32.add 	$push107=, $pop11, $pop108
	tee_local	$push106=, $3=, $pop107
	i32.const	$push105=, 16
	i32.shr_u	$push12=, $pop106, $pop105
	i32.store8	$drop=, sC+3($pop110), $pop12
	i32.const	$push104=, 0
	i32.const	$push103=, 1103515245
	i32.mul 	$push13=, $3, $pop103
	i32.const	$push102=, 12345
	i32.add 	$push101=, $pop13, $pop102
	tee_local	$push100=, $3=, $pop101
	i32.const	$push99=, 16
	i32.shr_u	$push14=, $pop100, $pop99
	i32.store8	$drop=, sC+4($pop104), $pop14
	i32.const	$push98=, 0
	i32.const	$push97=, 1103515245
	i32.mul 	$push15=, $3, $pop97
	i32.const	$push96=, 12345
	i32.add 	$push95=, $pop15, $pop96
	tee_local	$push94=, $3=, $pop95
	i32.const	$push93=, 16
	i32.shr_u	$push16=, $pop94, $pop93
	i32.store8	$drop=, sC+5($pop98), $pop16
	i32.const	$push92=, 0
	i32.const	$push91=, 1103515245
	i32.mul 	$push17=, $3, $pop91
	i32.const	$push90=, 12345
	i32.add 	$push89=, $pop17, $pop90
	tee_local	$push88=, $3=, $pop89
	i32.const	$push87=, 16
	i32.shr_u	$push18=, $pop88, $pop87
	i32.store8	$drop=, sC+6($pop92), $pop18
	i32.const	$push86=, 0
	i32.const	$push85=, 1103515245
	i32.mul 	$push19=, $3, $pop85
	i32.const	$push84=, 12345
	i32.add 	$push83=, $pop19, $pop84
	tee_local	$push82=, $3=, $pop83
	i32.const	$push81=, 16
	i32.shr_u	$push20=, $pop82, $pop81
	i32.store8	$drop=, sC+7($pop86), $pop20
	i32.const	$push80=, 0
	i32.load	$2=, sC+4($pop80)
	block
	i32.const	$push79=, 0
	i32.const	$push78=, 1103515245
	i32.mul 	$push21=, $3, $pop78
	i32.const	$push77=, 12345
	i32.add 	$push76=, $pop21, $pop77
	tee_local	$push75=, $3=, $pop76
	i32.const	$push74=, 1103515245
	i32.mul 	$push22=, $pop75, $pop74
	i32.const	$push73=, 12345
	i32.add 	$push2=, $pop22, $pop73
	i32.store	$push72=, myrnd.s($pop79), $pop2
	tee_local	$push71=, $0=, $pop72
	i32.const	$push70=, 16
	i32.shr_u	$push27=, $pop71, $pop70
	i32.const	$push69=, 2047
	i32.and 	$push68=, $pop27, $pop69
	tee_local	$push67=, $4=, $pop68
	i32.const	$push66=, 16
	i32.shr_u	$push24=, $3, $pop66
	i32.const	$push65=, 2047
	i32.and 	$push64=, $pop24, $pop65
	tee_local	$push63=, $3=, $pop64
	i32.add 	$push28=, $pop67, $pop63
	i32.const	$push62=, 17
	i32.shl 	$push29=, $4, $pop62
	i32.const	$push61=, 0
	i32.const	$push60=, 17
	i32.shl 	$push25=, $3, $pop60
	i32.const	$push23=, 131071
	i32.and 	$push59=, $2, $pop23
	tee_local	$push58=, $3=, $pop59
	i32.or  	$push26=, $pop25, $pop58
	i32.store	$push0=, sC+4($pop61), $pop26
	i32.add 	$push30=, $pop29, $pop0
	i32.const	$push57=, 17
	i32.shr_u	$push31=, $pop30, $pop57
	i32.ne  	$push32=, $pop28, $pop31
	br_if   	0, $pop32       # 0: down to label2
# BB#1:                                 # %if.end80
	i32.const	$push153=, 0
	i32.const	$push152=, 0
	i32.const	$push151=, 1103515245
	i32.mul 	$push33=, $0, $pop151
	i32.const	$push150=, 12345
	i32.add 	$push149=, $pop33, $pop150
	tee_local	$push148=, $2=, $pop149
	i32.const	$push34=, -1029531031
	i32.mul 	$push35=, $pop148, $pop34
	i32.const	$push36=, -740551042
	i32.add 	$push147=, $pop35, $pop36
	tee_local	$push146=, $4=, $pop147
	i32.const	$push145=, 1103515245
	i32.mul 	$push37=, $pop146, $pop145
	i32.const	$push144=, 12345
	i32.add 	$push38=, $pop37, $pop144
	i32.store	$push1=, myrnd.s($pop152), $pop38
	i32.const	$push143=, 16
	i32.shr_u	$push42=, $pop1, $pop143
	i32.const	$push142=, 2047
	i32.and 	$push141=, $pop42, $pop142
	tee_local	$push140=, $0=, $pop141
	i32.const	$push139=, 17
	i32.shl 	$push43=, $pop140, $pop139
	i32.const	$push138=, 16
	i32.shr_u	$push39=, $4, $pop138
	i32.const	$push137=, 2047
	i32.and 	$push136=, $pop39, $pop137
	tee_local	$push135=, $4=, $pop136
	i32.const	$push134=, 17
	i32.shl 	$push40=, $pop135, $pop134
	i32.or  	$push41=, $pop40, $3
	i32.add 	$push3=, $pop43, $pop41
	i32.store	$push133=, sC+4($pop153), $pop3
	tee_local	$push132=, $1=, $pop133
	i32.const	$push44=, 1
	i32.shl 	$push45=, $2, $pop44
	i32.const	$push46=, 268304384
	i32.and 	$push47=, $pop45, $pop46
	i32.or  	$push48=, $pop47, $3
	i32.xor 	$push131=, $pop132, $pop48
	tee_local	$push130=, $3=, $pop131
	i32.const	$push49=, 63
	i32.and 	$push50=, $pop130, $pop49
	br_if   	0, $pop50       # 0: down to label2
# BB#2:                                 # %lor.lhs.false96
	i32.add 	$push54=, $0, $4
	i32.const	$push52=, 17
	i32.shr_u	$push53=, $1, $pop52
	i32.ne  	$push55=, $pop54, $pop53
	br_if   	0, $pop55       # 0: down to label2
# BB#3:                                 # %lor.lhs.false96
	i32.const	$push56=, 131008
	i32.and 	$push51=, $3, $pop56
	br_if   	0, $pop51       # 0: down to label2
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
	i64.store	$drop=, 0($0), $pop0
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop7
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
                                        # fallthrough-return: $pop9
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
                                        # fallthrough-return: $pop4
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
	i64.const	$push3=, 35
	i64.shr_u	$push4=, $pop14, $pop3
	i32.wrap/i64	$push5=, $pop4
	i32.add 	$push13=, $pop5, $0
	tee_local	$push12=, $0=, $pop13
	i64.extend_u/i32	$push6=, $pop12
	i64.const	$push11=, 35
	i64.shl 	$push7=, $pop6, $pop11
	i64.const	$push1=, 34359738367
	i64.and 	$push2=, $1, $pop1
	i64.or  	$push8=, $pop7, $pop2
	i64.store	$drop=, sD($pop0), $pop8
	i32.const	$push9=, 536870911
	i32.and 	$push10=, $0, $pop9
                                        # fallthrough-return: $pop10
	.endfunc
.Lfunc_end23:
	.size	fn3D, .Lfunc_end23-fn3D

	.section	.text.testD,"ax",@progbits
	.hidden	testD
	.globl	testD
	.type	testD,@function
testD:                                  # @testD
	.local  	i32, i64
# BB#0:                                 # %if.end158
	i32.const	$push1=, 0
	i32.const	$push93=, 0
	i32.load	$push2=, myrnd.s($pop93)
	i32.const	$push3=, 1103515245
	i32.mul 	$push4=, $pop2, $pop3
	i32.const	$push5=, 12345
	i32.add 	$push92=, $pop4, $pop5
	tee_local	$push91=, $0=, $pop92
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop91, $pop6
	i32.store8	$drop=, sD($pop1), $pop7
	i32.const	$push90=, 0
	i32.const	$push89=, 1103515245
	i32.mul 	$push8=, $0, $pop89
	i32.const	$push88=, 12345
	i32.add 	$push87=, $pop8, $pop88
	tee_local	$push86=, $0=, $pop87
	i32.const	$push85=, 16
	i32.shr_u	$push9=, $pop86, $pop85
	i32.store8	$drop=, sD+1($pop90), $pop9
	i32.const	$push84=, 0
	i32.const	$push83=, 1103515245
	i32.mul 	$push10=, $0, $pop83
	i32.const	$push82=, 12345
	i32.add 	$push81=, $pop10, $pop82
	tee_local	$push80=, $0=, $pop81
	i32.const	$push79=, 16
	i32.shr_u	$push11=, $pop80, $pop79
	i32.store8	$drop=, sD+2($pop84), $pop11
	i32.const	$push78=, 0
	i32.const	$push77=, 1103515245
	i32.mul 	$push12=, $0, $pop77
	i32.const	$push76=, 12345
	i32.add 	$push75=, $pop12, $pop76
	tee_local	$push74=, $0=, $pop75
	i32.const	$push73=, 16
	i32.shr_u	$push13=, $pop74, $pop73
	i32.store8	$drop=, sD+3($pop78), $pop13
	i32.const	$push72=, 0
	i32.const	$push71=, 1103515245
	i32.mul 	$push14=, $0, $pop71
	i32.const	$push70=, 12345
	i32.add 	$push69=, $pop14, $pop70
	tee_local	$push68=, $0=, $pop69
	i32.const	$push67=, 16
	i32.shr_u	$push15=, $pop68, $pop67
	i32.store8	$drop=, sD+4($pop72), $pop15
	i32.const	$push66=, 0
	i32.const	$push65=, 1103515245
	i32.mul 	$push16=, $0, $pop65
	i32.const	$push64=, 12345
	i32.add 	$push63=, $pop16, $pop64
	tee_local	$push62=, $0=, $pop63
	i32.const	$push61=, 16
	i32.shr_u	$push17=, $pop62, $pop61
	i32.store8	$drop=, sD+5($pop66), $pop17
	i32.const	$push60=, 0
	i32.const	$push59=, 1103515245
	i32.mul 	$push18=, $0, $pop59
	i32.const	$push58=, 12345
	i32.add 	$push57=, $pop18, $pop58
	tee_local	$push56=, $0=, $pop57
	i32.const	$push55=, 16
	i32.shr_u	$push19=, $pop56, $pop55
	i32.store8	$drop=, sD+6($pop60), $pop19
	i32.const	$push54=, 0
	i32.const	$push53=, 1103515245
	i32.mul 	$push20=, $0, $pop53
	i32.const	$push52=, 12345
	i32.add 	$push51=, $pop20, $pop52
	tee_local	$push50=, $0=, $pop51
	i32.const	$push49=, 16
	i32.shr_u	$push21=, $pop50, $pop49
	i32.store8	$drop=, sD+7($pop54), $pop21
	i32.const	$push48=, 0
	i64.load	$1=, sD($pop48)
	i32.const	$push47=, 0
	i32.const	$push46=, 0
	i32.const	$push22=, -341751747
	i32.mul 	$push23=, $0, $pop22
	i32.const	$push24=, 229283573
	i32.add 	$push45=, $pop23, $pop24
	tee_local	$push44=, $0=, $pop45
	i32.const	$push43=, 1103515245
	i32.mul 	$push25=, $pop44, $pop43
	i32.const	$push42=, 12345
	i32.add 	$push26=, $pop25, $pop42
	i32.store	$push0=, myrnd.s($pop46), $pop26
	i32.const	$push41=, 16
	i32.shr_u	$push30=, $pop0, $pop41
	i32.const	$push28=, 2047
	i32.and 	$push31=, $pop30, $pop28
	i32.const	$push40=, 16
	i32.shr_u	$push27=, $0, $pop40
	i32.const	$push39=, 2047
	i32.and 	$push29=, $pop27, $pop39
	i32.add 	$push32=, $pop31, $pop29
	i64.extend_u/i32	$push33=, $pop32
	i64.const	$push34=, 35
	i64.shl 	$push35=, $pop33, $pop34
	i64.const	$push36=, 34359738367
	i64.and 	$push37=, $1, $pop36
	i64.or  	$push38=, $pop35, $pop37
	i64.store	$drop=, sD($pop47), $pop38
                                        # fallthrough-return
	.endfunc
.Lfunc_end24:
	.size	testD, .Lfunc_end24-testD

	.section	.text.retmeE,"ax",@progbits
	.hidden	retmeE
	.globl	retmeE
	.type	retmeE,@function
retmeE:                                 # @retmeE
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	$drop=, 0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	$drop=, 0($pop2), $pop4
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop7
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
                                        # fallthrough-return: $pop9
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
                                        # fallthrough-return: $pop4
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
	i64.const	$push3=, 35
	i64.shr_u	$push4=, $pop14, $pop3
	i32.wrap/i64	$push5=, $pop4
	i32.add 	$push13=, $pop5, $0
	tee_local	$push12=, $0=, $pop13
	i64.extend_u/i32	$push6=, $pop12
	i64.const	$push11=, 35
	i64.shl 	$push7=, $pop6, $pop11
	i64.const	$push1=, 34359738367
	i64.and 	$push2=, $1, $pop1
	i64.or  	$push8=, $pop7, $pop2
	i64.store	$drop=, sE+8($pop0), $pop8
	i32.const	$push9=, 536870911
	i32.and 	$push10=, $0, $pop9
                                        # fallthrough-return: $pop10
	.endfunc
.Lfunc_end29:
	.size	fn3E, .Lfunc_end29-fn3E

	.section	.text.testE,"ax",@progbits
	.hidden	testE
	.globl	testE
	.type	testE,@function
testE:                                  # @testE
	.local  	i32, i64
# BB#0:                                 # %if.end142
	i32.const	$push1=, 0
	i32.const	$push157=, 0
	i32.load	$push2=, myrnd.s($pop157)
	i32.const	$push3=, 1103515245
	i32.mul 	$push4=, $pop2, $pop3
	i32.const	$push5=, 12345
	i32.add 	$push156=, $pop4, $pop5
	tee_local	$push155=, $0=, $pop156
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop155, $pop6
	i32.store8	$drop=, sE($pop1), $pop7
	i32.const	$push154=, 0
	i32.const	$push153=, 1103515245
	i32.mul 	$push8=, $0, $pop153
	i32.const	$push152=, 12345
	i32.add 	$push151=, $pop8, $pop152
	tee_local	$push150=, $0=, $pop151
	i32.const	$push149=, 16
	i32.shr_u	$push9=, $pop150, $pop149
	i32.store8	$drop=, sE+1($pop154), $pop9
	i32.const	$push148=, 0
	i32.const	$push147=, 1103515245
	i32.mul 	$push10=, $0, $pop147
	i32.const	$push146=, 12345
	i32.add 	$push145=, $pop10, $pop146
	tee_local	$push144=, $0=, $pop145
	i32.const	$push143=, 16
	i32.shr_u	$push11=, $pop144, $pop143
	i32.store8	$drop=, sE+2($pop148), $pop11
	i32.const	$push142=, 0
	i32.const	$push141=, 1103515245
	i32.mul 	$push12=, $0, $pop141
	i32.const	$push140=, 12345
	i32.add 	$push139=, $pop12, $pop140
	tee_local	$push138=, $0=, $pop139
	i32.const	$push137=, 16
	i32.shr_u	$push13=, $pop138, $pop137
	i32.store8	$drop=, sE+3($pop142), $pop13
	i32.const	$push136=, 0
	i32.const	$push135=, 1103515245
	i32.mul 	$push14=, $0, $pop135
	i32.const	$push134=, 12345
	i32.add 	$push133=, $pop14, $pop134
	tee_local	$push132=, $0=, $pop133
	i32.const	$push131=, 16
	i32.shr_u	$push15=, $pop132, $pop131
	i32.store8	$drop=, sE+4($pop136), $pop15
	i32.const	$push130=, 0
	i32.const	$push129=, 1103515245
	i32.mul 	$push16=, $0, $pop129
	i32.const	$push128=, 12345
	i32.add 	$push127=, $pop16, $pop128
	tee_local	$push126=, $0=, $pop127
	i32.const	$push125=, 16
	i32.shr_u	$push17=, $pop126, $pop125
	i32.store8	$drop=, sE+5($pop130), $pop17
	i32.const	$push124=, 0
	i32.const	$push123=, 1103515245
	i32.mul 	$push18=, $0, $pop123
	i32.const	$push122=, 12345
	i32.add 	$push121=, $pop18, $pop122
	tee_local	$push120=, $0=, $pop121
	i32.const	$push119=, 16
	i32.shr_u	$push19=, $pop120, $pop119
	i32.store8	$drop=, sE+6($pop124), $pop19
	i32.const	$push118=, 0
	i32.const	$push117=, 1103515245
	i32.mul 	$push20=, $0, $pop117
	i32.const	$push116=, 12345
	i32.add 	$push115=, $pop20, $pop116
	tee_local	$push114=, $0=, $pop115
	i32.const	$push113=, 16
	i32.shr_u	$push21=, $pop114, $pop113
	i32.store8	$drop=, sE+7($pop118), $pop21
	i32.const	$push112=, 0
	i32.const	$push111=, 1103515245
	i32.mul 	$push22=, $0, $pop111
	i32.const	$push110=, 12345
	i32.add 	$push109=, $pop22, $pop110
	tee_local	$push108=, $0=, $pop109
	i32.const	$push107=, 16
	i32.shr_u	$push23=, $pop108, $pop107
	i32.store8	$drop=, sE+8($pop112), $pop23
	i32.const	$push106=, 0
	i32.const	$push105=, 1103515245
	i32.mul 	$push24=, $0, $pop105
	i32.const	$push104=, 12345
	i32.add 	$push103=, $pop24, $pop104
	tee_local	$push102=, $0=, $pop103
	i32.const	$push101=, 16
	i32.shr_u	$push25=, $pop102, $pop101
	i32.store8	$drop=, sE+9($pop106), $pop25
	i32.const	$push100=, 0
	i32.const	$push99=, 1103515245
	i32.mul 	$push26=, $0, $pop99
	i32.const	$push98=, 12345
	i32.add 	$push97=, $pop26, $pop98
	tee_local	$push96=, $0=, $pop97
	i32.const	$push95=, 16
	i32.shr_u	$push27=, $pop96, $pop95
	i32.store8	$drop=, sE+10($pop100), $pop27
	i32.const	$push94=, 0
	i32.const	$push93=, 1103515245
	i32.mul 	$push28=, $0, $pop93
	i32.const	$push92=, 12345
	i32.add 	$push91=, $pop28, $pop92
	tee_local	$push90=, $0=, $pop91
	i32.const	$push89=, 16
	i32.shr_u	$push29=, $pop90, $pop89
	i32.store8	$drop=, sE+11($pop94), $pop29
	i32.const	$push88=, 0
	i32.const	$push87=, 1103515245
	i32.mul 	$push30=, $0, $pop87
	i32.const	$push86=, 12345
	i32.add 	$push85=, $pop30, $pop86
	tee_local	$push84=, $0=, $pop85
	i32.const	$push83=, 16
	i32.shr_u	$push31=, $pop84, $pop83
	i32.store8	$drop=, sE+12($pop88), $pop31
	i32.const	$push82=, 0
	i32.const	$push81=, 1103515245
	i32.mul 	$push32=, $0, $pop81
	i32.const	$push80=, 12345
	i32.add 	$push79=, $pop32, $pop80
	tee_local	$push78=, $0=, $pop79
	i32.const	$push77=, 16
	i32.shr_u	$push33=, $pop78, $pop77
	i32.store8	$drop=, sE+13($pop82), $pop33
	i32.const	$push76=, 0
	i32.const	$push75=, 1103515245
	i32.mul 	$push34=, $0, $pop75
	i32.const	$push74=, 12345
	i32.add 	$push73=, $pop34, $pop74
	tee_local	$push72=, $0=, $pop73
	i32.const	$push71=, 16
	i32.shr_u	$push35=, $pop72, $pop71
	i32.store8	$drop=, sE+14($pop76), $pop35
	i32.const	$push70=, 0
	i32.const	$push69=, 1103515245
	i32.mul 	$push36=, $0, $pop69
	i32.const	$push68=, 12345
	i32.add 	$push67=, $pop36, $pop68
	tee_local	$push66=, $0=, $pop67
	i32.const	$push65=, 16
	i32.shr_u	$push37=, $pop66, $pop65
	i32.store8	$drop=, sE+15($pop70), $pop37
	i32.const	$push64=, 0
	i64.load	$1=, sE+8($pop64)
	i32.const	$push63=, 0
	i32.const	$push62=, 0
	i32.const	$push38=, -341751747
	i32.mul 	$push39=, $0, $pop38
	i32.const	$push40=, 229283573
	i32.add 	$push61=, $pop39, $pop40
	tee_local	$push60=, $0=, $pop61
	i32.const	$push59=, 1103515245
	i32.mul 	$push41=, $pop60, $pop59
	i32.const	$push58=, 12345
	i32.add 	$push42=, $pop41, $pop58
	i32.store	$push0=, myrnd.s($pop62), $pop42
	i32.const	$push57=, 16
	i32.shr_u	$push46=, $pop0, $pop57
	i32.const	$push44=, 2047
	i32.and 	$push47=, $pop46, $pop44
	i32.const	$push56=, 16
	i32.shr_u	$push43=, $0, $pop56
	i32.const	$push55=, 2047
	i32.and 	$push45=, $pop43, $pop55
	i32.add 	$push48=, $pop47, $pop45
	i64.extend_u/i32	$push49=, $pop48
	i64.const	$push50=, 35
	i64.shl 	$push51=, $pop49, $pop50
	i64.const	$push52=, 34359738367
	i64.and 	$push53=, $1, $pop52
	i64.or  	$push54=, $pop51, $pop53
	i64.store	$drop=, sE+8($pop63), $pop54
                                        # fallthrough-return
	.endfunc
.Lfunc_end30:
	.size	testE, .Lfunc_end30-testE

	.section	.text.retmeF,"ax",@progbits
	.hidden	retmeF
	.globl	retmeF
	.type	retmeF,@function
retmeF:                                 # @retmeF
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	$drop=, 0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	$drop=, 0($pop2), $pop4
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop7
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
                                        # fallthrough-return: $pop9
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
                                        # fallthrough-return: $pop4
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
	i64.const	$push3=, 35
	i64.shr_u	$push4=, $pop14, $pop3
	i32.wrap/i64	$push5=, $pop4
	i32.add 	$push13=, $pop5, $0
	tee_local	$push12=, $0=, $pop13
	i64.extend_u/i32	$push6=, $pop12
	i64.const	$push11=, 35
	i64.shl 	$push7=, $pop6, $pop11
	i64.const	$push1=, 34359738367
	i64.and 	$push2=, $1, $pop1
	i64.or  	$push8=, $pop7, $pop2
	i64.store	$drop=, sF($pop0), $pop8
	i32.const	$push9=, 536870911
	i32.and 	$push10=, $0, $pop9
                                        # fallthrough-return: $pop10
	.endfunc
.Lfunc_end35:
	.size	fn3F, .Lfunc_end35-fn3F

	.section	.text.testF,"ax",@progbits
	.hidden	testF
	.globl	testF
	.type	testF,@function
testF:                                  # @testF
	.local  	i32, i64
# BB#0:                                 # %if.end136
	i32.const	$push1=, 0
	i32.const	$push157=, 0
	i32.load	$push2=, myrnd.s($pop157)
	i32.const	$push3=, 1103515245
	i32.mul 	$push4=, $pop2, $pop3
	i32.const	$push5=, 12345
	i32.add 	$push156=, $pop4, $pop5
	tee_local	$push155=, $0=, $pop156
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop155, $pop6
	i32.store8	$drop=, sF($pop1), $pop7
	i32.const	$push154=, 0
	i32.const	$push153=, 1103515245
	i32.mul 	$push8=, $0, $pop153
	i32.const	$push152=, 12345
	i32.add 	$push151=, $pop8, $pop152
	tee_local	$push150=, $0=, $pop151
	i32.const	$push149=, 16
	i32.shr_u	$push9=, $pop150, $pop149
	i32.store8	$drop=, sF+1($pop154), $pop9
	i32.const	$push148=, 0
	i32.const	$push147=, 1103515245
	i32.mul 	$push10=, $0, $pop147
	i32.const	$push146=, 12345
	i32.add 	$push145=, $pop10, $pop146
	tee_local	$push144=, $0=, $pop145
	i32.const	$push143=, 16
	i32.shr_u	$push11=, $pop144, $pop143
	i32.store8	$drop=, sF+2($pop148), $pop11
	i32.const	$push142=, 0
	i32.const	$push141=, 1103515245
	i32.mul 	$push12=, $0, $pop141
	i32.const	$push140=, 12345
	i32.add 	$push139=, $pop12, $pop140
	tee_local	$push138=, $0=, $pop139
	i32.const	$push137=, 16
	i32.shr_u	$push13=, $pop138, $pop137
	i32.store8	$drop=, sF+3($pop142), $pop13
	i32.const	$push136=, 0
	i32.const	$push135=, 1103515245
	i32.mul 	$push14=, $0, $pop135
	i32.const	$push134=, 12345
	i32.add 	$push133=, $pop14, $pop134
	tee_local	$push132=, $0=, $pop133
	i32.const	$push131=, 16
	i32.shr_u	$push15=, $pop132, $pop131
	i32.store8	$drop=, sF+4($pop136), $pop15
	i32.const	$push130=, 0
	i32.const	$push129=, 1103515245
	i32.mul 	$push16=, $0, $pop129
	i32.const	$push128=, 12345
	i32.add 	$push127=, $pop16, $pop128
	tee_local	$push126=, $0=, $pop127
	i32.const	$push125=, 16
	i32.shr_u	$push17=, $pop126, $pop125
	i32.store8	$drop=, sF+5($pop130), $pop17
	i32.const	$push124=, 0
	i32.const	$push123=, 1103515245
	i32.mul 	$push18=, $0, $pop123
	i32.const	$push122=, 12345
	i32.add 	$push121=, $pop18, $pop122
	tee_local	$push120=, $0=, $pop121
	i32.const	$push119=, 16
	i32.shr_u	$push19=, $pop120, $pop119
	i32.store8	$drop=, sF+6($pop124), $pop19
	i32.const	$push118=, 0
	i32.const	$push117=, 1103515245
	i32.mul 	$push20=, $0, $pop117
	i32.const	$push116=, 12345
	i32.add 	$push115=, $pop20, $pop116
	tee_local	$push114=, $0=, $pop115
	i32.const	$push113=, 16
	i32.shr_u	$push21=, $pop114, $pop113
	i32.store8	$drop=, sF+7($pop118), $pop21
	i32.const	$push112=, 0
	i32.const	$push111=, 1103515245
	i32.mul 	$push22=, $0, $pop111
	i32.const	$push110=, 12345
	i32.add 	$push109=, $pop22, $pop110
	tee_local	$push108=, $0=, $pop109
	i32.const	$push107=, 16
	i32.shr_u	$push23=, $pop108, $pop107
	i32.store8	$drop=, sF+8($pop112), $pop23
	i32.const	$push106=, 0
	i32.const	$push105=, 1103515245
	i32.mul 	$push24=, $0, $pop105
	i32.const	$push104=, 12345
	i32.add 	$push103=, $pop24, $pop104
	tee_local	$push102=, $0=, $pop103
	i32.const	$push101=, 16
	i32.shr_u	$push25=, $pop102, $pop101
	i32.store8	$drop=, sF+9($pop106), $pop25
	i32.const	$push100=, 0
	i32.const	$push99=, 1103515245
	i32.mul 	$push26=, $0, $pop99
	i32.const	$push98=, 12345
	i32.add 	$push97=, $pop26, $pop98
	tee_local	$push96=, $0=, $pop97
	i32.const	$push95=, 16
	i32.shr_u	$push27=, $pop96, $pop95
	i32.store8	$drop=, sF+10($pop100), $pop27
	i32.const	$push94=, 0
	i32.const	$push93=, 1103515245
	i32.mul 	$push28=, $0, $pop93
	i32.const	$push92=, 12345
	i32.add 	$push91=, $pop28, $pop92
	tee_local	$push90=, $0=, $pop91
	i32.const	$push89=, 16
	i32.shr_u	$push29=, $pop90, $pop89
	i32.store8	$drop=, sF+11($pop94), $pop29
	i32.const	$push88=, 0
	i32.const	$push87=, 1103515245
	i32.mul 	$push30=, $0, $pop87
	i32.const	$push86=, 12345
	i32.add 	$push85=, $pop30, $pop86
	tee_local	$push84=, $0=, $pop85
	i32.const	$push83=, 16
	i32.shr_u	$push31=, $pop84, $pop83
	i32.store8	$drop=, sF+12($pop88), $pop31
	i32.const	$push82=, 0
	i32.const	$push81=, 1103515245
	i32.mul 	$push32=, $0, $pop81
	i32.const	$push80=, 12345
	i32.add 	$push79=, $pop32, $pop80
	tee_local	$push78=, $0=, $pop79
	i32.const	$push77=, 16
	i32.shr_u	$push33=, $pop78, $pop77
	i32.store8	$drop=, sF+13($pop82), $pop33
	i32.const	$push76=, 0
	i32.const	$push75=, 1103515245
	i32.mul 	$push34=, $0, $pop75
	i32.const	$push74=, 12345
	i32.add 	$push73=, $pop34, $pop74
	tee_local	$push72=, $0=, $pop73
	i32.const	$push71=, 16
	i32.shr_u	$push35=, $pop72, $pop71
	i32.store8	$drop=, sF+14($pop76), $pop35
	i32.const	$push70=, 0
	i32.const	$push69=, 1103515245
	i32.mul 	$push36=, $0, $pop69
	i32.const	$push68=, 12345
	i32.add 	$push67=, $pop36, $pop68
	tee_local	$push66=, $0=, $pop67
	i32.const	$push65=, 16
	i32.shr_u	$push37=, $pop66, $pop65
	i32.store8	$drop=, sF+15($pop70), $pop37
	i32.const	$push64=, 0
	i64.load	$1=, sF($pop64)
	i32.const	$push63=, 0
	i32.const	$push62=, 0
	i32.const	$push38=, -341751747
	i32.mul 	$push39=, $0, $pop38
	i32.const	$push40=, 229283573
	i32.add 	$push61=, $pop39, $pop40
	tee_local	$push60=, $0=, $pop61
	i32.const	$push59=, 1103515245
	i32.mul 	$push41=, $pop60, $pop59
	i32.const	$push58=, 12345
	i32.add 	$push42=, $pop41, $pop58
	i32.store	$push0=, myrnd.s($pop62), $pop42
	i32.const	$push57=, 16
	i32.shr_u	$push46=, $pop0, $pop57
	i32.const	$push44=, 2047
	i32.and 	$push47=, $pop46, $pop44
	i32.const	$push56=, 16
	i32.shr_u	$push43=, $0, $pop56
	i32.const	$push55=, 2047
	i32.and 	$push45=, $pop43, $pop55
	i32.add 	$push48=, $pop47, $pop45
	i64.extend_u/i32	$push49=, $pop48
	i64.const	$push50=, 35
	i64.shl 	$push51=, $pop49, $pop50
	i64.const	$push52=, 34359738367
	i64.and 	$push53=, $1, $pop52
	i64.or  	$push54=, $pop51, $pop53
	i64.store	$drop=, sF($pop63), $pop54
                                        # fallthrough-return
	.endfunc
.Lfunc_end36:
	.size	testF, .Lfunc_end36-testF

	.section	.text.retmeG,"ax",@progbits
	.hidden	retmeG
	.globl	retmeG
	.type	retmeG,@function
retmeG:                                 # @retmeG
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	$drop=, 0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	$drop=, 0($pop2), $pop4
                                        # fallthrough-return
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
	i32.const	$push2=, 0
	i32.load	$push3=, sG($pop2)
	i32.const	$push0=, 25
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push4=, $pop3, $pop1
	i32.const	$push6=, 25
	i32.shr_u	$push5=, $pop4, $pop6
                                        # fallthrough-return: $pop5
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
                                        # fallthrough-return: $pop8
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
                                        # fallthrough-return: $pop3
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
	i32.const	$push3=, 0
	i32.const	$push8=, 0
	i32.load	$push4=, sG($pop8)
	i32.const	$push1=, 25
	i32.shl 	$push2=, $0, $pop1
	i32.add 	$push5=, $pop4, $pop2
	i32.store	$push0=, sG($pop3), $pop5
	i32.const	$push7=, 25
	i32.shr_u	$push6=, $pop0, $pop7
                                        # fallthrough-return: $pop6
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
	i32.const	$push183=, 0
	i32.const	$push182=, 0
	i32.load	$push4=, myrnd.s($pop182)
	i32.const	$push181=, 1103515245
	i32.mul 	$push5=, $pop4, $pop181
	i32.const	$push180=, 12345
	i32.add 	$push179=, $pop5, $pop180
	tee_local	$push178=, $1=, $pop179
	i32.const	$push177=, 16
	i32.shr_u	$push6=, $pop178, $pop177
	i32.store8	$drop=, sG($pop183), $pop6
	i32.const	$push176=, 0
	i32.const	$push175=, 1103515245
	i32.mul 	$push7=, $1, $pop175
	i32.const	$push174=, 12345
	i32.add 	$push173=, $pop7, $pop174
	tee_local	$push172=, $1=, $pop173
	i32.const	$push171=, 16
	i32.shr_u	$push8=, $pop172, $pop171
	i32.store8	$drop=, sG+1($pop176), $pop8
	i32.const	$push170=, 0
	i32.const	$push169=, 1103515245
	i32.mul 	$push9=, $1, $pop169
	i32.const	$push168=, 12345
	i32.add 	$push167=, $pop9, $pop168
	tee_local	$push166=, $1=, $pop167
	i32.const	$push165=, 16
	i32.shr_u	$push10=, $pop166, $pop165
	i32.store8	$drop=, sG+2($pop170), $pop10
	i32.const	$push164=, 0
	i32.const	$push163=, 1103515245
	i32.mul 	$push11=, $1, $pop163
	i32.const	$push162=, 12345
	i32.add 	$push161=, $pop11, $pop162
	tee_local	$push160=, $1=, $pop161
	i32.const	$push159=, 16
	i32.shr_u	$push12=, $pop160, $pop159
	i32.store8	$drop=, sG+3($pop164), $pop12
	i32.const	$push158=, 0
	i32.const	$push157=, 1103515245
	i32.mul 	$push13=, $1, $pop157
	i32.const	$push156=, 12345
	i32.add 	$push155=, $pop13, $pop156
	tee_local	$push154=, $1=, $pop155
	i32.const	$push153=, 16
	i32.shr_u	$push14=, $pop154, $pop153
	i32.store8	$drop=, sG+4($pop158), $pop14
	i32.const	$push152=, 0
	i32.const	$push151=, 1103515245
	i32.mul 	$push15=, $1, $pop151
	i32.const	$push150=, 12345
	i32.add 	$push149=, $pop15, $pop150
	tee_local	$push148=, $1=, $pop149
	i32.const	$push147=, 16
	i32.shr_u	$push16=, $pop148, $pop147
	i32.store8	$drop=, sG+5($pop152), $pop16
	i32.const	$push146=, 0
	i32.const	$push145=, 1103515245
	i32.mul 	$push17=, $1, $pop145
	i32.const	$push144=, 12345
	i32.add 	$push143=, $pop17, $pop144
	tee_local	$push142=, $1=, $pop143
	i32.const	$push141=, 16
	i32.shr_u	$push18=, $pop142, $pop141
	i32.store8	$drop=, sG+6($pop146), $pop18
	i32.const	$push140=, 0
	i32.const	$push139=, 1103515245
	i32.mul 	$push19=, $1, $pop139
	i32.const	$push138=, 12345
	i32.add 	$push137=, $pop19, $pop138
	tee_local	$push136=, $1=, $pop137
	i32.const	$push135=, 16
	i32.shr_u	$push20=, $pop136, $pop135
	i32.store8	$drop=, sG+7($pop140), $pop20
	i32.const	$push134=, 0
	i32.const	$push133=, 1103515245
	i32.mul 	$push21=, $1, $pop133
	i32.const	$push132=, 12345
	i32.add 	$push131=, $pop21, $pop132
	tee_local	$push130=, $1=, $pop131
	i32.const	$push129=, 16
	i32.shr_u	$push22=, $pop130, $pop129
	i32.store8	$drop=, sG+8($pop134), $pop22
	i32.const	$push128=, 0
	i32.const	$push127=, 1103515245
	i32.mul 	$push23=, $1, $pop127
	i32.const	$push126=, 12345
	i32.add 	$push125=, $pop23, $pop126
	tee_local	$push124=, $1=, $pop125
	i32.const	$push123=, 16
	i32.shr_u	$push24=, $pop124, $pop123
	i32.store8	$drop=, sG+9($pop128), $pop24
	i32.const	$push122=, 0
	i32.const	$push121=, 1103515245
	i32.mul 	$push25=, $1, $pop121
	i32.const	$push120=, 12345
	i32.add 	$push119=, $pop25, $pop120
	tee_local	$push118=, $1=, $pop119
	i32.const	$push117=, 16
	i32.shr_u	$push26=, $pop118, $pop117
	i32.store8	$drop=, sG+10($pop122), $pop26
	i32.const	$push116=, 0
	i32.const	$push115=, 1103515245
	i32.mul 	$push27=, $1, $pop115
	i32.const	$push114=, 12345
	i32.add 	$push113=, $pop27, $pop114
	tee_local	$push112=, $1=, $pop113
	i32.const	$push111=, 16
	i32.shr_u	$push28=, $pop112, $pop111
	i32.store8	$drop=, sG+11($pop116), $pop28
	i32.const	$push110=, 0
	i32.const	$push109=, 1103515245
	i32.mul 	$push29=, $1, $pop109
	i32.const	$push108=, 12345
	i32.add 	$push107=, $pop29, $pop108
	tee_local	$push106=, $1=, $pop107
	i32.const	$push105=, 16
	i32.shr_u	$push30=, $pop106, $pop105
	i32.store8	$drop=, sG+12($pop110), $pop30
	i32.const	$push104=, 0
	i32.const	$push103=, 1103515245
	i32.mul 	$push31=, $1, $pop103
	i32.const	$push102=, 12345
	i32.add 	$push101=, $pop31, $pop102
	tee_local	$push100=, $1=, $pop101
	i32.const	$push99=, 16
	i32.shr_u	$push32=, $pop100, $pop99
	i32.store8	$drop=, sG+13($pop104), $pop32
	i32.const	$push98=, 0
	i32.const	$push97=, 1103515245
	i32.mul 	$push33=, $1, $pop97
	i32.const	$push96=, 12345
	i32.add 	$push95=, $pop33, $pop96
	tee_local	$push94=, $1=, $pop95
	i32.const	$push93=, 16
	i32.shr_u	$push34=, $pop94, $pop93
	i32.store8	$drop=, sG+14($pop98), $pop34
	i32.const	$push92=, 0
	i32.const	$push91=, 1103515245
	i32.mul 	$push35=, $1, $pop91
	i32.const	$push90=, 12345
	i32.add 	$push89=, $pop35, $pop90
	tee_local	$push88=, $2=, $pop89
	i32.const	$push87=, 16
	i32.shr_u	$push36=, $pop88, $pop87
	i32.store8	$drop=, sG+15($pop92), $pop36
	i32.const	$push86=, 0
	i32.load	$1=, sG($pop86)
	block
	i32.const	$push85=, 0
	i32.const	$push84=, 1103515245
	i32.mul 	$push37=, $2, $pop84
	i32.const	$push83=, 12345
	i32.add 	$push82=, $pop37, $pop83
	tee_local	$push81=, $2=, $pop82
	i32.const	$push80=, 1103515245
	i32.mul 	$push38=, $pop81, $pop80
	i32.const	$push79=, 12345
	i32.add 	$push2=, $pop38, $pop79
	i32.store	$push78=, myrnd.s($pop85), $pop2
	tee_local	$push77=, $0=, $pop78
	i32.const	$push76=, 16
	i32.shr_u	$push75=, $pop77, $pop76
	tee_local	$push74=, $3=, $pop75
	i32.const	$push73=, 16
	i32.shr_u	$push72=, $2, $pop73
	tee_local	$push71=, $2=, $pop72
	i32.add 	$push41=, $pop74, $pop71
	i32.const	$push42=, 127
	i32.and 	$push43=, $pop41, $pop42
	i32.const	$push70=, 25
	i32.shl 	$push44=, $3, $pop70
	i32.const	$push69=, 0
	i32.const	$push68=, 25
	i32.shl 	$push39=, $2, $pop68
	i32.const	$push67=, 33554431
	i32.and 	$push66=, $1, $pop67
	tee_local	$push65=, $2=, $pop66
	i32.or  	$push40=, $pop39, $pop65
	i32.store	$push0=, sG($pop69), $pop40
	i32.add 	$push45=, $pop44, $pop0
	i32.const	$push64=, 25
	i32.shr_u	$push46=, $pop45, $pop64
	i32.ne  	$push47=, $pop43, $pop46
	br_if   	0, $pop47       # 0: down to label3
# BB#1:                                 # %if.end76
	i32.const	$push200=, 0
	i32.const	$push199=, 0
	i32.const	$push48=, -2139243339
	i32.mul 	$push49=, $0, $pop48
	i32.const	$push50=, -1492899873
	i32.add 	$push198=, $pop49, $pop50
	tee_local	$push197=, $3=, $pop198
	i32.const	$push196=, 1103515245
	i32.mul 	$push51=, $pop197, $pop196
	i32.const	$push195=, 12345
	i32.add 	$push52=, $pop51, $pop195
	i32.store	$push1=, myrnd.s($pop199), $pop52
	i32.const	$push194=, 16
	i32.shr_u	$push193=, $pop1, $pop194
	tee_local	$push192=, $0=, $pop193
	i32.const	$push191=, 25
	i32.shl 	$push55=, $pop192, $pop191
	i32.const	$push190=, 16
	i32.shr_u	$push189=, $3, $pop190
	tee_local	$push188=, $3=, $pop189
	i32.const	$push187=, 25
	i32.shl 	$push53=, $pop188, $pop187
	i32.or  	$push54=, $pop53, $2
	i32.add 	$push3=, $pop55, $pop54
	i32.store	$push186=, sG($pop200), $pop3
	tee_local	$push185=, $2=, $pop186
	i32.xor 	$push56=, $pop185, $1
	i32.const	$push184=, 33554431
	i32.and 	$push57=, $pop56, $pop184
	br_if   	0, $pop57       # 0: down to label3
# BB#2:                                 # %lor.lhs.false109
	i32.add 	$push60=, $0, $3
	i32.const	$push61=, 127
	i32.and 	$push62=, $pop60, $pop61
	i32.const	$push58=, 25
	i32.shr_u	$push59=, $2, $pop58
	i32.ne  	$push63=, $pop62, $pop59
	br_if   	0, $pop63       # 0: down to label3
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
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	$drop=, 0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	$drop=, 0($pop2), $pop4
                                        # fallthrough-return
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
	i32.const	$push2=, 0
	i32.load	$push3=, sH($pop2)
	i32.const	$push0=, 23
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push4=, $pop3, $pop1
	i32.const	$push6=, 23
	i32.shr_u	$push5=, $pop4, $pop6
                                        # fallthrough-return: $pop5
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
                                        # fallthrough-return: $pop8
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
                                        # fallthrough-return: $pop3
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
	i32.const	$push3=, 0
	i32.const	$push8=, 0
	i32.load	$push4=, sH($pop8)
	i32.const	$push1=, 23
	i32.shl 	$push2=, $0, $pop1
	i32.add 	$push5=, $pop4, $pop2
	i32.store	$push0=, sH($pop3), $pop5
	i32.const	$push7=, 23
	i32.shr_u	$push6=, $pop0, $pop7
                                        # fallthrough-return: $pop6
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
	i32.const	$push183=, 0
	i32.const	$push182=, 0
	i32.load	$push4=, myrnd.s($pop182)
	i32.const	$push181=, 1103515245
	i32.mul 	$push5=, $pop4, $pop181
	i32.const	$push180=, 12345
	i32.add 	$push179=, $pop5, $pop180
	tee_local	$push178=, $1=, $pop179
	i32.const	$push177=, 16
	i32.shr_u	$push6=, $pop178, $pop177
	i32.store8	$drop=, sH($pop183), $pop6
	i32.const	$push176=, 0
	i32.const	$push175=, 1103515245
	i32.mul 	$push7=, $1, $pop175
	i32.const	$push174=, 12345
	i32.add 	$push173=, $pop7, $pop174
	tee_local	$push172=, $1=, $pop173
	i32.const	$push171=, 16
	i32.shr_u	$push8=, $pop172, $pop171
	i32.store8	$drop=, sH+1($pop176), $pop8
	i32.const	$push170=, 0
	i32.const	$push169=, 1103515245
	i32.mul 	$push9=, $1, $pop169
	i32.const	$push168=, 12345
	i32.add 	$push167=, $pop9, $pop168
	tee_local	$push166=, $1=, $pop167
	i32.const	$push165=, 16
	i32.shr_u	$push10=, $pop166, $pop165
	i32.store8	$drop=, sH+2($pop170), $pop10
	i32.const	$push164=, 0
	i32.const	$push163=, 1103515245
	i32.mul 	$push11=, $1, $pop163
	i32.const	$push162=, 12345
	i32.add 	$push161=, $pop11, $pop162
	tee_local	$push160=, $1=, $pop161
	i32.const	$push159=, 16
	i32.shr_u	$push12=, $pop160, $pop159
	i32.store8	$drop=, sH+3($pop164), $pop12
	i32.const	$push158=, 0
	i32.const	$push157=, 1103515245
	i32.mul 	$push13=, $1, $pop157
	i32.const	$push156=, 12345
	i32.add 	$push155=, $pop13, $pop156
	tee_local	$push154=, $1=, $pop155
	i32.const	$push153=, 16
	i32.shr_u	$push14=, $pop154, $pop153
	i32.store8	$drop=, sH+4($pop158), $pop14
	i32.const	$push152=, 0
	i32.const	$push151=, 1103515245
	i32.mul 	$push15=, $1, $pop151
	i32.const	$push150=, 12345
	i32.add 	$push149=, $pop15, $pop150
	tee_local	$push148=, $1=, $pop149
	i32.const	$push147=, 16
	i32.shr_u	$push16=, $pop148, $pop147
	i32.store8	$drop=, sH+5($pop152), $pop16
	i32.const	$push146=, 0
	i32.const	$push145=, 1103515245
	i32.mul 	$push17=, $1, $pop145
	i32.const	$push144=, 12345
	i32.add 	$push143=, $pop17, $pop144
	tee_local	$push142=, $1=, $pop143
	i32.const	$push141=, 16
	i32.shr_u	$push18=, $pop142, $pop141
	i32.store8	$drop=, sH+6($pop146), $pop18
	i32.const	$push140=, 0
	i32.const	$push139=, 1103515245
	i32.mul 	$push19=, $1, $pop139
	i32.const	$push138=, 12345
	i32.add 	$push137=, $pop19, $pop138
	tee_local	$push136=, $1=, $pop137
	i32.const	$push135=, 16
	i32.shr_u	$push20=, $pop136, $pop135
	i32.store8	$drop=, sH+7($pop140), $pop20
	i32.const	$push134=, 0
	i32.const	$push133=, 1103515245
	i32.mul 	$push21=, $1, $pop133
	i32.const	$push132=, 12345
	i32.add 	$push131=, $pop21, $pop132
	tee_local	$push130=, $1=, $pop131
	i32.const	$push129=, 16
	i32.shr_u	$push22=, $pop130, $pop129
	i32.store8	$drop=, sH+8($pop134), $pop22
	i32.const	$push128=, 0
	i32.const	$push127=, 1103515245
	i32.mul 	$push23=, $1, $pop127
	i32.const	$push126=, 12345
	i32.add 	$push125=, $pop23, $pop126
	tee_local	$push124=, $1=, $pop125
	i32.const	$push123=, 16
	i32.shr_u	$push24=, $pop124, $pop123
	i32.store8	$drop=, sH+9($pop128), $pop24
	i32.const	$push122=, 0
	i32.const	$push121=, 1103515245
	i32.mul 	$push25=, $1, $pop121
	i32.const	$push120=, 12345
	i32.add 	$push119=, $pop25, $pop120
	tee_local	$push118=, $1=, $pop119
	i32.const	$push117=, 16
	i32.shr_u	$push26=, $pop118, $pop117
	i32.store8	$drop=, sH+10($pop122), $pop26
	i32.const	$push116=, 0
	i32.const	$push115=, 1103515245
	i32.mul 	$push27=, $1, $pop115
	i32.const	$push114=, 12345
	i32.add 	$push113=, $pop27, $pop114
	tee_local	$push112=, $1=, $pop113
	i32.const	$push111=, 16
	i32.shr_u	$push28=, $pop112, $pop111
	i32.store8	$drop=, sH+11($pop116), $pop28
	i32.const	$push110=, 0
	i32.const	$push109=, 1103515245
	i32.mul 	$push29=, $1, $pop109
	i32.const	$push108=, 12345
	i32.add 	$push107=, $pop29, $pop108
	tee_local	$push106=, $1=, $pop107
	i32.const	$push105=, 16
	i32.shr_u	$push30=, $pop106, $pop105
	i32.store8	$drop=, sH+12($pop110), $pop30
	i32.const	$push104=, 0
	i32.const	$push103=, 1103515245
	i32.mul 	$push31=, $1, $pop103
	i32.const	$push102=, 12345
	i32.add 	$push101=, $pop31, $pop102
	tee_local	$push100=, $1=, $pop101
	i32.const	$push99=, 16
	i32.shr_u	$push32=, $pop100, $pop99
	i32.store8	$drop=, sH+13($pop104), $pop32
	i32.const	$push98=, 0
	i32.const	$push97=, 1103515245
	i32.mul 	$push33=, $1, $pop97
	i32.const	$push96=, 12345
	i32.add 	$push95=, $pop33, $pop96
	tee_local	$push94=, $1=, $pop95
	i32.const	$push93=, 16
	i32.shr_u	$push34=, $pop94, $pop93
	i32.store8	$drop=, sH+14($pop98), $pop34
	i32.const	$push92=, 0
	i32.const	$push91=, 1103515245
	i32.mul 	$push35=, $1, $pop91
	i32.const	$push90=, 12345
	i32.add 	$push89=, $pop35, $pop90
	tee_local	$push88=, $2=, $pop89
	i32.const	$push87=, 16
	i32.shr_u	$push36=, $pop88, $pop87
	i32.store8	$drop=, sH+15($pop92), $pop36
	i32.const	$push86=, 0
	i32.load	$1=, sH($pop86)
	block
	i32.const	$push85=, 0
	i32.const	$push84=, 1103515245
	i32.mul 	$push37=, $2, $pop84
	i32.const	$push83=, 12345
	i32.add 	$push82=, $pop37, $pop83
	tee_local	$push81=, $2=, $pop82
	i32.const	$push80=, 1103515245
	i32.mul 	$push38=, $pop81, $pop80
	i32.const	$push79=, 12345
	i32.add 	$push2=, $pop38, $pop79
	i32.store	$push78=, myrnd.s($pop85), $pop2
	tee_local	$push77=, $0=, $pop78
	i32.const	$push76=, 16
	i32.shr_u	$push75=, $pop77, $pop76
	tee_local	$push74=, $3=, $pop75
	i32.const	$push73=, 16
	i32.shr_u	$push72=, $2, $pop73
	tee_local	$push71=, $2=, $pop72
	i32.add 	$push41=, $pop74, $pop71
	i32.const	$push42=, 511
	i32.and 	$push43=, $pop41, $pop42
	i32.const	$push70=, 23
	i32.shl 	$push44=, $3, $pop70
	i32.const	$push69=, 0
	i32.const	$push68=, 23
	i32.shl 	$push39=, $2, $pop68
	i32.const	$push67=, 8388607
	i32.and 	$push66=, $1, $pop67
	tee_local	$push65=, $2=, $pop66
	i32.or  	$push40=, $pop39, $pop65
	i32.store	$push0=, sH($pop69), $pop40
	i32.add 	$push45=, $pop44, $pop0
	i32.const	$push64=, 23
	i32.shr_u	$push46=, $pop45, $pop64
	i32.ne  	$push47=, $pop43, $pop46
	br_if   	0, $pop47       # 0: down to label4
# BB#1:                                 # %if.end76
	i32.const	$push200=, 0
	i32.const	$push199=, 0
	i32.const	$push48=, -2139243339
	i32.mul 	$push49=, $0, $pop48
	i32.const	$push50=, -1492899873
	i32.add 	$push198=, $pop49, $pop50
	tee_local	$push197=, $3=, $pop198
	i32.const	$push196=, 1103515245
	i32.mul 	$push51=, $pop197, $pop196
	i32.const	$push195=, 12345
	i32.add 	$push52=, $pop51, $pop195
	i32.store	$push1=, myrnd.s($pop199), $pop52
	i32.const	$push194=, 16
	i32.shr_u	$push193=, $pop1, $pop194
	tee_local	$push192=, $0=, $pop193
	i32.const	$push191=, 23
	i32.shl 	$push55=, $pop192, $pop191
	i32.const	$push190=, 16
	i32.shr_u	$push189=, $3, $pop190
	tee_local	$push188=, $3=, $pop189
	i32.const	$push187=, 23
	i32.shl 	$push53=, $pop188, $pop187
	i32.or  	$push54=, $pop53, $2
	i32.add 	$push3=, $pop55, $pop54
	i32.store	$push186=, sH($pop200), $pop3
	tee_local	$push185=, $2=, $pop186
	i32.xor 	$push56=, $pop185, $1
	i32.const	$push184=, 8388607
	i32.and 	$push57=, $pop56, $pop184
	br_if   	0, $pop57       # 0: down to label4
# BB#2:                                 # %lor.lhs.false109
	i32.add 	$push60=, $0, $3
	i32.const	$push61=, 511
	i32.and 	$push62=, $pop60, $pop61
	i32.const	$push58=, 23
	i32.shr_u	$push59=, $2, $pop58
	i32.ne  	$push63=, $pop62, $pop59
	br_if   	0, $pop63       # 0: down to label4
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
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	$drop=, 0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	$drop=, 0($pop2), $pop4
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop6
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
                                        # fallthrough-return: $pop8
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
                                        # fallthrough-return: $pop3
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
	i32.const	$push3=, 7
	i32.shr_u	$push4=, $pop12, $pop3
	i32.add 	$push11=, $pop4, $0
	tee_local	$push10=, $0=, $pop11
	i32.const	$push9=, 7
	i32.shl 	$push5=, $pop10, $pop9
	i32.const	$push1=, 127
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push6=, $pop5, $pop2
	i32.store16	$drop=, sI($pop0), $pop6
	i32.const	$push7=, 511
	i32.and 	$push8=, $0, $pop7
                                        # fallthrough-return: $pop8
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
	tee_local	$push150=, $0=, $pop151
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop150, $pop6
	i32.store8	$drop=, sI($pop1), $pop7
	i32.const	$push149=, 0
	i32.const	$push148=, 1103515245
	i32.mul 	$push8=, $0, $pop148
	i32.const	$push147=, 12345
	i32.add 	$push146=, $pop8, $pop147
	tee_local	$push145=, $0=, $pop146
	i32.const	$push144=, 16
	i32.shr_u	$push9=, $pop145, $pop144
	i32.store8	$drop=, sI+1($pop149), $pop9
	i32.const	$push143=, 0
	i32.const	$push142=, 1103515245
	i32.mul 	$push10=, $0, $pop142
	i32.const	$push141=, 12345
	i32.add 	$push140=, $pop10, $pop141
	tee_local	$push139=, $0=, $pop140
	i32.const	$push138=, 16
	i32.shr_u	$push11=, $pop139, $pop138
	i32.store8	$drop=, sI+2($pop143), $pop11
	i32.const	$push137=, 0
	i32.const	$push136=, 1103515245
	i32.mul 	$push12=, $0, $pop136
	i32.const	$push135=, 12345
	i32.add 	$push134=, $pop12, $pop135
	tee_local	$push133=, $0=, $pop134
	i32.const	$push132=, 16
	i32.shr_u	$push13=, $pop133, $pop132
	i32.store8	$drop=, sI+3($pop137), $pop13
	i32.const	$push131=, 0
	i32.const	$push130=, 1103515245
	i32.mul 	$push14=, $0, $pop130
	i32.const	$push129=, 12345
	i32.add 	$push128=, $pop14, $pop129
	tee_local	$push127=, $0=, $pop128
	i32.const	$push126=, 16
	i32.shr_u	$push15=, $pop127, $pop126
	i32.store8	$drop=, sI+4($pop131), $pop15
	i32.const	$push125=, 0
	i32.const	$push124=, 1103515245
	i32.mul 	$push16=, $0, $pop124
	i32.const	$push123=, 12345
	i32.add 	$push122=, $pop16, $pop123
	tee_local	$push121=, $0=, $pop122
	i32.const	$push120=, 16
	i32.shr_u	$push17=, $pop121, $pop120
	i32.store8	$drop=, sI+5($pop125), $pop17
	i32.const	$push119=, 0
	i32.const	$push118=, 1103515245
	i32.mul 	$push18=, $0, $pop118
	i32.const	$push117=, 12345
	i32.add 	$push116=, $pop18, $pop117
	tee_local	$push115=, $0=, $pop116
	i32.const	$push114=, 16
	i32.shr_u	$push19=, $pop115, $pop114
	i32.store8	$drop=, sI+6($pop119), $pop19
	i32.const	$push113=, 0
	i32.const	$push112=, 1103515245
	i32.mul 	$push20=, $0, $pop112
	i32.const	$push111=, 12345
	i32.add 	$push110=, $pop20, $pop111
	tee_local	$push109=, $0=, $pop110
	i32.const	$push108=, 16
	i32.shr_u	$push21=, $pop109, $pop108
	i32.store8	$drop=, sI+7($pop113), $pop21
	i32.const	$push107=, 0
	i32.const	$push106=, 1103515245
	i32.mul 	$push22=, $0, $pop106
	i32.const	$push105=, 12345
	i32.add 	$push104=, $pop22, $pop105
	tee_local	$push103=, $0=, $pop104
	i32.const	$push102=, 16
	i32.shr_u	$push23=, $pop103, $pop102
	i32.store8	$drop=, sI+8($pop107), $pop23
	i32.const	$push101=, 0
	i32.const	$push100=, 1103515245
	i32.mul 	$push24=, $0, $pop100
	i32.const	$push99=, 12345
	i32.add 	$push98=, $pop24, $pop99
	tee_local	$push97=, $0=, $pop98
	i32.const	$push96=, 16
	i32.shr_u	$push25=, $pop97, $pop96
	i32.store8	$drop=, sI+9($pop101), $pop25
	i32.const	$push95=, 0
	i32.const	$push94=, 1103515245
	i32.mul 	$push26=, $0, $pop94
	i32.const	$push93=, 12345
	i32.add 	$push92=, $pop26, $pop93
	tee_local	$push91=, $0=, $pop92
	i32.const	$push90=, 16
	i32.shr_u	$push27=, $pop91, $pop90
	i32.store8	$drop=, sI+10($pop95), $pop27
	i32.const	$push89=, 0
	i32.const	$push88=, 1103515245
	i32.mul 	$push28=, $0, $pop88
	i32.const	$push87=, 12345
	i32.add 	$push86=, $pop28, $pop87
	tee_local	$push85=, $0=, $pop86
	i32.const	$push84=, 16
	i32.shr_u	$push29=, $pop85, $pop84
	i32.store8	$drop=, sI+11($pop89), $pop29
	i32.const	$push83=, 0
	i32.const	$push82=, 1103515245
	i32.mul 	$push30=, $0, $pop82
	i32.const	$push81=, 12345
	i32.add 	$push80=, $pop30, $pop81
	tee_local	$push79=, $0=, $pop80
	i32.const	$push78=, 16
	i32.shr_u	$push31=, $pop79, $pop78
	i32.store8	$drop=, sI+12($pop83), $pop31
	i32.const	$push77=, 0
	i32.const	$push76=, 1103515245
	i32.mul 	$push32=, $0, $pop76
	i32.const	$push75=, 12345
	i32.add 	$push74=, $pop32, $pop75
	tee_local	$push73=, $0=, $pop74
	i32.const	$push72=, 16
	i32.shr_u	$push33=, $pop73, $pop72
	i32.store8	$drop=, sI+13($pop77), $pop33
	i32.const	$push71=, 0
	i32.const	$push70=, 1103515245
	i32.mul 	$push34=, $0, $pop70
	i32.const	$push69=, 12345
	i32.add 	$push68=, $pop34, $pop69
	tee_local	$push67=, $0=, $pop68
	i32.const	$push66=, 16
	i32.shr_u	$push35=, $pop67, $pop66
	i32.store8	$drop=, sI+14($pop71), $pop35
	i32.const	$push65=, 0
	i32.const	$push64=, 1103515245
	i32.mul 	$push36=, $0, $pop64
	i32.const	$push63=, 12345
	i32.add 	$push62=, $pop36, $pop63
	tee_local	$push61=, $0=, $pop62
	i32.const	$push60=, 16
	i32.shr_u	$push37=, $pop61, $pop60
	i32.store8	$drop=, sI+15($pop65), $pop37
	i32.const	$push59=, 0
	i32.load16_u	$1=, sI($pop59)
	i32.const	$push58=, 0
	i32.const	$push57=, 0
	i32.const	$push38=, -341751747
	i32.mul 	$push39=, $0, $pop38
	i32.const	$push40=, 229283573
	i32.add 	$push56=, $pop39, $pop40
	tee_local	$push55=, $0=, $pop56
	i32.const	$push54=, 1103515245
	i32.mul 	$push41=, $pop55, $pop54
	i32.const	$push53=, 12345
	i32.add 	$push42=, $pop41, $pop53
	i32.store	$push0=, myrnd.s($pop57), $pop42
	i32.const	$push52=, 16
	i32.shr_u	$push44=, $pop0, $pop52
	i32.const	$push51=, 16
	i32.shr_u	$push43=, $0, $pop51
	i32.add 	$push45=, $pop44, $pop43
	i32.const	$push46=, 7
	i32.shl 	$push47=, $pop45, $pop46
	i32.const	$push48=, 127
	i32.and 	$push49=, $1, $pop48
	i32.or  	$push50=, $pop47, $pop49
	i32.store16	$drop=, sI($pop58), $pop50
                                        # fallthrough-return
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
	i32.store	$drop=, 0($0):p2align=1, $pop0
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop6
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
                                        # fallthrough-return: $pop8
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
                                        # fallthrough-return: $pop3
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
	i32.const	$push3=, 9
	i32.shr_u	$push4=, $pop12, $pop3
	i32.add 	$push11=, $pop4, $0
	tee_local	$push10=, $0=, $pop11
	i32.const	$push9=, 9
	i32.shl 	$push5=, $pop10, $pop9
	i32.const	$push1=, 511
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push6=, $pop5, $pop2
	i32.store16	$drop=, sJ($pop0), $pop6
	i32.const	$push7=, 127
	i32.and 	$push8=, $0, $pop7
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end59:
	.size	fn3J, .Lfunc_end59-fn3J

	.section	.text.testJ,"ax",@progbits
	.hidden	testJ
	.globl	testJ
	.type	testJ,@function
testJ:                                  # @testJ
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push81=, 0
	i32.const	$push80=, 0
	i32.load	$push2=, myrnd.s($pop80)
	i32.const	$push79=, 1103515245
	i32.mul 	$push3=, $pop2, $pop79
	i32.const	$push78=, 12345
	i32.add 	$push77=, $pop3, $pop78
	tee_local	$push76=, $1=, $pop77
	i32.const	$push75=, 16
	i32.shr_u	$push4=, $pop76, $pop75
	i32.store8	$drop=, sJ($pop81), $pop4
	i32.const	$push74=, 0
	i32.const	$push73=, 1103515245
	i32.mul 	$push5=, $1, $pop73
	i32.const	$push72=, 12345
	i32.add 	$push71=, $pop5, $pop72
	tee_local	$push70=, $1=, $pop71
	i32.const	$push69=, 16
	i32.shr_u	$push6=, $pop70, $pop69
	i32.store8	$drop=, sJ+1($pop74), $pop6
	i32.const	$push68=, 0
	i32.const	$push67=, 1103515245
	i32.mul 	$push7=, $1, $pop67
	i32.const	$push66=, 12345
	i32.add 	$push65=, $pop7, $pop66
	tee_local	$push64=, $1=, $pop65
	i32.const	$push63=, 16
	i32.shr_u	$push8=, $pop64, $pop63
	i32.store8	$drop=, sJ+2($pop68), $pop8
	i32.const	$push62=, 0
	i32.const	$push61=, 1103515245
	i32.mul 	$push9=, $1, $pop61
	i32.const	$push60=, 12345
	i32.add 	$push59=, $pop9, $pop60
	tee_local	$push58=, $1=, $pop59
	i32.const	$push57=, 16
	i32.shr_u	$push10=, $pop58, $pop57
	i32.store8	$drop=, sJ+3($pop62), $pop10
	i32.const	$push56=, 0
	i32.const	$push55=, 1103515245
	i32.mul 	$push13=, $1, $pop55
	i32.const	$push54=, 12345
	i32.add 	$push53=, $pop13, $pop54
	tee_local	$push52=, $1=, $pop53
	i32.const	$push51=, 16
	i32.shr_u	$push50=, $pop52, $pop51
	tee_local	$push49=, $2=, $pop50
	i32.const	$push48=, 9
	i32.shl 	$push14=, $pop49, $pop48
	i32.const	$push47=, 0
	i32.load16_u	$push11=, sJ($pop47)
	i32.const	$push46=, 511
	i32.and 	$push12=, $pop11, $pop46
	i32.or  	$push15=, $pop14, $pop12
	i32.store16	$drop=, sJ($pop56), $pop15
	block
	i32.const	$push45=, 0
	i32.const	$push44=, 1103515245
	i32.mul 	$push16=, $1, $pop44
	i32.const	$push43=, 12345
	i32.add 	$push1=, $pop16, $pop43
	i32.store	$push42=, myrnd.s($pop45), $pop1
	tee_local	$push41=, $0=, $pop42
	i32.const	$push40=, 16
	i32.shr_u	$push39=, $pop41, $pop40
	tee_local	$push38=, $1=, $pop39
	i32.add 	$push17=, $pop38, $2
	i32.const	$push37=, 0
	i32.load	$push36=, sJ($pop37)
	tee_local	$push35=, $2=, $pop36
	i32.const	$push34=, 9
	i32.shr_u	$push18=, $pop35, $pop34
	i32.add 	$push19=, $pop18, $1
	i32.xor 	$push20=, $pop17, $pop19
	i32.const	$push21=, 127
	i32.and 	$push22=, $pop20, $pop21
	br_if   	0, $pop22       # 0: down to label5
# BB#1:                                 # %if.end142
	i32.const	$push91=, 0
	i32.const	$push90=, 0
	i32.const	$push23=, -2139243339
	i32.mul 	$push24=, $0, $pop23
	i32.const	$push25=, -1492899873
	i32.add 	$push89=, $pop24, $pop25
	tee_local	$push88=, $1=, $pop89
	i32.const	$push87=, 1103515245
	i32.mul 	$push26=, $pop88, $pop87
	i32.const	$push86=, 12345
	i32.add 	$push27=, $pop26, $pop86
	i32.store	$push0=, myrnd.s($pop90), $pop27
	i32.const	$push85=, 16
	i32.shr_u	$push29=, $pop0, $pop85
	i32.const	$push84=, 16
	i32.shr_u	$push28=, $1, $pop84
	i32.add 	$push30=, $pop29, $pop28
	i32.const	$push83=, 9
	i32.shl 	$push31=, $pop30, $pop83
	i32.const	$push82=, 511
	i32.and 	$push32=, $2, $pop82
	i32.or  	$push33=, $pop31, $pop32
	i32.store16	$drop=, sJ($pop91), $pop33
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
	i32.store	$drop=, 0($0), $pop0
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop4
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
                                        # fallthrough-return: $pop6
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
                                        # fallthrough-return: $pop3
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
	i32.add 	$push3=, $pop8, $0
	i32.const	$push4=, 63
	i32.and 	$push7=, $pop3, $pop4
	tee_local	$push6=, $0=, $pop7
	i32.const	$push1=, -64
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push5=, $pop6, $pop2
	i32.store	$drop=, sK($pop0), $pop5
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end65:
	.size	fn3K, .Lfunc_end65-fn3K

	.section	.text.testK,"ax",@progbits
	.hidden	testK
	.globl	testK
	.type	testK,@function
testK:                                  # @testK
	.local  	i32
# BB#0:                                 # %if.end129
	i32.const	$push1=, 0
	i32.const	$push57=, 0
	i32.load	$push2=, myrnd.s($pop57)
	i32.const	$push3=, 1103515245
	i32.mul 	$push4=, $pop2, $pop3
	i32.const	$push5=, 12345
	i32.add 	$push56=, $pop4, $pop5
	tee_local	$push55=, $0=, $pop56
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop55, $pop6
	i32.store8	$drop=, sK($pop1), $pop7
	i32.const	$push54=, 0
	i32.const	$push53=, 1103515245
	i32.mul 	$push8=, $0, $pop53
	i32.const	$push52=, 12345
	i32.add 	$push51=, $pop8, $pop52
	tee_local	$push50=, $0=, $pop51
	i32.const	$push49=, 16
	i32.shr_u	$push9=, $pop50, $pop49
	i32.store8	$drop=, sK+1($pop54), $pop9
	i32.const	$push48=, 0
	i32.const	$push47=, 1103515245
	i32.mul 	$push10=, $0, $pop47
	i32.const	$push46=, 12345
	i32.add 	$push45=, $pop10, $pop46
	tee_local	$push44=, $0=, $pop45
	i32.const	$push43=, 16
	i32.shr_u	$push11=, $pop44, $pop43
	i32.store8	$drop=, sK+2($pop48), $pop11
	i32.const	$push42=, 0
	i32.const	$push41=, 1103515245
	i32.mul 	$push12=, $0, $pop41
	i32.const	$push40=, 12345
	i32.add 	$push39=, $pop12, $pop40
	tee_local	$push38=, $0=, $pop39
	i32.const	$push37=, 16
	i32.shr_u	$push13=, $pop38, $pop37
	i32.store8	$drop=, sK+3($pop42), $pop13
	i32.const	$push36=, 0
	i32.const	$push35=, 0
	i32.const	$push14=, -341751747
	i32.mul 	$push15=, $0, $pop14
	i32.const	$push16=, 229283573
	i32.add 	$push34=, $pop15, $pop16
	tee_local	$push33=, $0=, $pop34
	i32.const	$push32=, 1103515245
	i32.mul 	$push17=, $pop33, $pop32
	i32.const	$push31=, 12345
	i32.add 	$push18=, $pop17, $pop31
	i32.store	$push0=, myrnd.s($pop35), $pop18
	i32.const	$push30=, 16
	i32.shr_u	$push20=, $pop0, $pop30
	i32.const	$push29=, 16
	i32.shr_u	$push19=, $0, $pop29
	i32.add 	$push21=, $pop20, $pop19
	i32.const	$push22=, 63
	i32.and 	$push23=, $pop21, $pop22
	i32.const	$push28=, 0
	i32.load	$push24=, sK($pop28)
	i32.const	$push25=, -64
	i32.and 	$push26=, $pop24, $pop25
	i32.or  	$push27=, $pop23, $pop26
	i32.store	$drop=, sK($pop36), $pop27
                                        # fallthrough-return
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
	i64.store	$drop=, 0($0):p2align=2, $pop0
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop4
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
                                        # fallthrough-return: $pop6
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
                                        # fallthrough-return: $pop3
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
	i32.add 	$push3=, $pop8, $0
	i32.const	$push4=, 63
	i32.and 	$push7=, $pop3, $pop4
	tee_local	$push6=, $0=, $pop7
	i32.const	$push1=, -64
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push5=, $pop6, $pop2
	i32.store	$drop=, sL($pop0), $pop5
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
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
	i32.const	$push109=, 0
	i32.const	$push108=, 0
	i32.load	$push3=, myrnd.s($pop108)
	i32.const	$push107=, 1103515245
	i32.mul 	$push4=, $pop3, $pop107
	i32.const	$push106=, 12345
	i32.add 	$push105=, $pop4, $pop106
	tee_local	$push104=, $1=, $pop105
	i32.const	$push103=, 16
	i32.shr_u	$push5=, $pop104, $pop103
	i32.store8	$drop=, sL($pop109), $pop5
	i32.const	$push102=, 0
	i32.const	$push101=, 1103515245
	i32.mul 	$push6=, $1, $pop101
	i32.const	$push100=, 12345
	i32.add 	$push99=, $pop6, $pop100
	tee_local	$push98=, $1=, $pop99
	i32.const	$push97=, 16
	i32.shr_u	$push7=, $pop98, $pop97
	i32.store8	$drop=, sL+1($pop102), $pop7
	i32.const	$push96=, 0
	i32.const	$push95=, 1103515245
	i32.mul 	$push8=, $1, $pop95
	i32.const	$push94=, 12345
	i32.add 	$push93=, $pop8, $pop94
	tee_local	$push92=, $1=, $pop93
	i32.const	$push91=, 16
	i32.shr_u	$push9=, $pop92, $pop91
	i32.store8	$drop=, sL+2($pop96), $pop9
	i32.const	$push90=, 0
	i32.const	$push89=, 1103515245
	i32.mul 	$push10=, $1, $pop89
	i32.const	$push88=, 12345
	i32.add 	$push87=, $pop10, $pop88
	tee_local	$push86=, $1=, $pop87
	i32.const	$push85=, 16
	i32.shr_u	$push11=, $pop86, $pop85
	i32.store8	$drop=, sL+3($pop90), $pop11
	i32.const	$push84=, 0
	i32.const	$push83=, 1103515245
	i32.mul 	$push12=, $1, $pop83
	i32.const	$push82=, 12345
	i32.add 	$push81=, $pop12, $pop82
	tee_local	$push80=, $1=, $pop81
	i32.const	$push79=, 16
	i32.shr_u	$push13=, $pop80, $pop79
	i32.store8	$drop=, sL+4($pop84), $pop13
	i32.const	$push78=, 0
	i32.const	$push77=, 1103515245
	i32.mul 	$push14=, $1, $pop77
	i32.const	$push76=, 12345
	i32.add 	$push75=, $pop14, $pop76
	tee_local	$push74=, $1=, $pop75
	i32.const	$push73=, 16
	i32.shr_u	$push15=, $pop74, $pop73
	i32.store8	$drop=, sL+5($pop78), $pop15
	i32.const	$push72=, 0
	i32.const	$push71=, 1103515245
	i32.mul 	$push16=, $1, $pop71
	i32.const	$push70=, 12345
	i32.add 	$push69=, $pop16, $pop70
	tee_local	$push68=, $1=, $pop69
	i32.const	$push67=, 16
	i32.shr_u	$push17=, $pop68, $pop67
	i32.store8	$drop=, sL+6($pop72), $pop17
	i32.const	$push66=, 0
	i32.const	$push65=, 1103515245
	i32.mul 	$push18=, $1, $pop65
	i32.const	$push64=, 12345
	i32.add 	$push63=, $pop18, $pop64
	tee_local	$push62=, $1=, $pop63
	i32.const	$push61=, 16
	i32.shr_u	$push19=, $pop62, $pop61
	i32.store8	$drop=, sL+7($pop66), $pop19
	i32.const	$push60=, 0
	i32.load	$2=, sL($pop60)
	block
	i32.const	$push59=, 0
	i32.const	$push58=, 1103515245
	i32.mul 	$push20=, $1, $pop58
	i32.const	$push57=, 12345
	i32.add 	$push56=, $pop20, $pop57
	tee_local	$push55=, $1=, $pop56
	i32.const	$push54=, 1103515245
	i32.mul 	$push21=, $pop55, $pop54
	i32.const	$push53=, 12345
	i32.add 	$push1=, $pop21, $pop53
	i32.store	$push52=, myrnd.s($pop59), $pop1
	tee_local	$push51=, $0=, $pop52
	i32.const	$push50=, 16
	i32.shr_u	$push49=, $pop51, $pop50
	tee_local	$push48=, $3=, $pop49
	i32.const	$push47=, 16
	i32.shr_u	$push46=, $1, $pop47
	tee_local	$push45=, $1=, $pop46
	i32.add 	$push25=, $pop48, $pop45
	i32.const	$push44=, 0
	i32.const	$push43=, 63
	i32.and 	$push23=, $1, $pop43
	i32.const	$push42=, -64
	i32.and 	$push22=, $2, $pop42
	i32.or  	$push2=, $pop23, $pop22
	i32.store	$push41=, sL($pop44), $pop2
	tee_local	$push40=, $1=, $pop41
	i32.add 	$push24=, $pop40, $3
	i32.xor 	$push26=, $pop25, $pop24
	i32.const	$push39=, 63
	i32.and 	$push27=, $pop26, $pop39
	br_if   	0, $pop27       # 0: down to label6
# BB#1:                                 # %if.end75
	i32.const	$push119=, 0
	i32.const	$push118=, 0
	i32.const	$push28=, -2139243339
	i32.mul 	$push29=, $0, $pop28
	i32.const	$push30=, -1492899873
	i32.add 	$push117=, $pop29, $pop30
	tee_local	$push116=, $2=, $pop117
	i32.const	$push115=, 1103515245
	i32.mul 	$push31=, $pop116, $pop115
	i32.const	$push114=, 12345
	i32.add 	$push32=, $pop31, $pop114
	i32.store	$push0=, myrnd.s($pop118), $pop32
	i32.const	$push113=, 16
	i32.shr_u	$push34=, $pop0, $pop113
	i32.const	$push112=, 16
	i32.shr_u	$push33=, $2, $pop112
	i32.add 	$push35=, $pop34, $pop33
	i32.const	$push111=, 63
	i32.and 	$push36=, $pop35, $pop111
	i32.const	$push110=, -64
	i32.and 	$push37=, $1, $pop110
	i32.or  	$push38=, $pop36, $pop37
	i32.store	$drop=, sL($pop119), $pop38
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
	i64.store	$drop=, 0($0):p2align=2, $pop0
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop4
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
                                        # fallthrough-return: $pop6
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
                                        # fallthrough-return: $pop3
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
	i32.add 	$push3=, $pop8, $0
	i32.const	$push4=, 63
	i32.and 	$push7=, $pop3, $pop4
	tee_local	$push6=, $0=, $pop7
	i32.const	$push1=, -64
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push5=, $pop6, $pop2
	i32.store	$drop=, sM+4($pop0), $pop5
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
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
	i32.const	$push106=, 0
	i32.const	$push105=, 0
	i32.load	$push3=, myrnd.s($pop105)
	i32.const	$push104=, 1103515245
	i32.mul 	$push4=, $pop3, $pop104
	i32.const	$push103=, 12345
	i32.add 	$push102=, $pop4, $pop103
	tee_local	$push101=, $0=, $pop102
	i32.const	$push100=, 16
	i32.shr_u	$push5=, $pop101, $pop100
	i32.store8	$drop=, sM($pop106), $pop5
	i32.const	$push99=, 0
	i32.const	$push98=, 1103515245
	i32.mul 	$push6=, $0, $pop98
	i32.const	$push97=, 12345
	i32.add 	$push96=, $pop6, $pop97
	tee_local	$push95=, $0=, $pop96
	i32.const	$push94=, 16
	i32.shr_u	$push7=, $pop95, $pop94
	i32.store8	$drop=, sM+1($pop99), $pop7
	i32.const	$push93=, 0
	i32.const	$push92=, 1103515245
	i32.mul 	$push8=, $0, $pop92
	i32.const	$push91=, 12345
	i32.add 	$push90=, $pop8, $pop91
	tee_local	$push89=, $0=, $pop90
	i32.const	$push88=, 16
	i32.shr_u	$push9=, $pop89, $pop88
	i32.store8	$drop=, sM+2($pop93), $pop9
	i32.const	$push87=, 0
	i32.const	$push86=, 1103515245
	i32.mul 	$push10=, $0, $pop86
	i32.const	$push85=, 12345
	i32.add 	$push84=, $pop10, $pop85
	tee_local	$push83=, $0=, $pop84
	i32.const	$push82=, 16
	i32.shr_u	$push11=, $pop83, $pop82
	i32.store8	$drop=, sM+3($pop87), $pop11
	i32.const	$push81=, 0
	i32.const	$push80=, 1103515245
	i32.mul 	$push12=, $0, $pop80
	i32.const	$push79=, 12345
	i32.add 	$push78=, $pop12, $pop79
	tee_local	$push77=, $0=, $pop78
	i32.const	$push76=, 16
	i32.shr_u	$push13=, $pop77, $pop76
	i32.store8	$drop=, sM+4($pop81), $pop13
	i32.const	$push75=, 0
	i32.const	$push74=, 1103515245
	i32.mul 	$push14=, $0, $pop74
	i32.const	$push73=, 12345
	i32.add 	$push72=, $pop14, $pop73
	tee_local	$push71=, $0=, $pop72
	i32.const	$push70=, 16
	i32.shr_u	$push15=, $pop71, $pop70
	i32.store8	$drop=, sM+5($pop75), $pop15
	i32.const	$push69=, 0
	i32.const	$push68=, 1103515245
	i32.mul 	$push16=, $0, $pop68
	i32.const	$push67=, 12345
	i32.add 	$push66=, $pop16, $pop67
	tee_local	$push65=, $0=, $pop66
	i32.const	$push64=, 16
	i32.shr_u	$push17=, $pop65, $pop64
	i32.store8	$drop=, sM+6($pop69), $pop17
	i32.const	$push63=, 0
	i32.const	$push62=, 1103515245
	i32.mul 	$push18=, $0, $pop62
	i32.const	$push61=, 12345
	i32.add 	$push60=, $pop18, $pop61
	tee_local	$push59=, $0=, $pop60
	i32.const	$push58=, 16
	i32.shr_u	$push19=, $pop59, $pop58
	i32.store8	$drop=, sM+7($pop63), $pop19
	i32.const	$push57=, 0
	i32.load	$3=, sM+4($pop57)
	i32.const	$push56=, 0
	i32.const	$push55=, 1103515245
	i32.mul 	$push20=, $0, $pop55
	i32.const	$push54=, 12345
	i32.add 	$push53=, $pop20, $pop54
	tee_local	$push52=, $2=, $pop53
	i32.const	$push51=, 1103515245
	i32.mul 	$push21=, $pop52, $pop51
	i32.const	$push50=, 12345
	i32.add 	$push2=, $pop21, $pop50
	i32.store	$0=, myrnd.s($pop56), $pop2
	block
	i32.const	$push49=, 0
	i32.const	$push48=, 16
	i32.shr_u	$push47=, $2, $pop48
	tee_local	$push46=, $2=, $pop47
	i32.const	$push45=, 63
	i32.and 	$push23=, $pop46, $pop45
	i32.const	$push22=, -64
	i32.and 	$push44=, $3, $pop22
	tee_local	$push43=, $1=, $pop44
	i32.or  	$push24=, $pop23, $pop43
	i32.store	$push0=, sM+4($pop49), $pop24
	i32.const	$push42=, 16
	i32.shr_u	$push41=, $0, $pop42
	tee_local	$push40=, $3=, $pop41
	i32.add 	$push26=, $pop0, $pop40
	i32.add 	$push25=, $3, $2
	i32.xor 	$push27=, $pop26, $pop25
	i32.const	$push39=, 63
	i32.and 	$push28=, $pop27, $pop39
	br_if   	0, $pop28       # 0: down to label7
# BB#1:                                 # %if.end79
	i32.const	$push115=, 0
	i32.const	$push114=, 0
	i32.const	$push29=, -2139243339
	i32.mul 	$push30=, $0, $pop29
	i32.const	$push31=, -1492899873
	i32.add 	$push113=, $pop30, $pop31
	tee_local	$push112=, $0=, $pop113
	i32.const	$push111=, 1103515245
	i32.mul 	$push32=, $pop112, $pop111
	i32.const	$push110=, 12345
	i32.add 	$push33=, $pop32, $pop110
	i32.store	$push1=, myrnd.s($pop114), $pop33
	i32.const	$push109=, 16
	i32.shr_u	$push35=, $pop1, $pop109
	i32.const	$push108=, 16
	i32.shr_u	$push34=, $0, $pop108
	i32.add 	$push36=, $pop35, $pop34
	i32.const	$push107=, 63
	i32.and 	$push37=, $pop36, $pop107
	i32.or  	$push38=, $pop37, $1
	i32.store	$drop=, sM+4($pop115), $pop38
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
	i64.store	$drop=, 0($0), $pop0
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop6
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
                                        # fallthrough-return: $pop8
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
                                        # fallthrough-return: $pop5
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
	i64.const	$push3=, 6
	i64.shr_u	$push4=, $pop16, $pop3
	i32.wrap/i64	$push5=, $pop4
	i32.add 	$push15=, $pop5, $0
	tee_local	$push14=, $0=, $pop15
	i32.const	$push6=, 6
	i32.shl 	$push7=, $pop14, $pop6
	i64.extend_u/i32	$push8=, $pop7
	i64.const	$push9=, 4032
	i64.and 	$push10=, $pop8, $pop9
	i64.const	$push1=, -4033
	i64.and 	$push2=, $1, $pop1
	i64.or  	$push11=, $pop10, $pop2
	i64.store	$drop=, sN($pop0), $pop11
	i32.const	$push12=, 63
	i32.and 	$push13=, $0, $pop12
                                        # fallthrough-return: $pop13
	.endfunc
.Lfunc_end83:
	.size	fn3N, .Lfunc_end83-fn3N

	.section	.text.testN,"ax",@progbits
	.hidden	testN
	.globl	testN
	.type	testN,@function
testN:                                  # @testN
	.local  	i32, i64, i32, i64, i32, i32, i32, i64
# BB#0:                                 # %lor.lhs.false
	i32.const	$push5=, 0
	i32.const	$push165=, 0
	i32.load	$push6=, myrnd.s($pop165)
	i32.const	$push7=, 1103515245
	i32.mul 	$push8=, $pop6, $pop7
	i32.const	$push9=, 12345
	i32.add 	$push164=, $pop8, $pop9
	tee_local	$push163=, $6=, $pop164
	i32.const	$push162=, 16
	i32.shr_u	$push10=, $pop163, $pop162
	i32.store8	$drop=, sN($pop5), $pop10
	i32.const	$push161=, 0
	i32.const	$push160=, 1103515245
	i32.mul 	$push11=, $6, $pop160
	i32.const	$push159=, 12345
	i32.add 	$push158=, $pop11, $pop159
	tee_local	$push157=, $6=, $pop158
	i32.const	$push156=, 16
	i32.shr_u	$push12=, $pop157, $pop156
	i32.store8	$drop=, sN+1($pop161), $pop12
	i32.const	$push155=, 0
	i32.const	$push154=, 1103515245
	i32.mul 	$push13=, $6, $pop154
	i32.const	$push153=, 12345
	i32.add 	$push152=, $pop13, $pop153
	tee_local	$push151=, $6=, $pop152
	i32.const	$push150=, 16
	i32.shr_u	$push14=, $pop151, $pop150
	i32.store8	$drop=, sN+2($pop155), $pop14
	i32.const	$push149=, 0
	i32.const	$push148=, 1103515245
	i32.mul 	$push15=, $6, $pop148
	i32.const	$push147=, 12345
	i32.add 	$push146=, $pop15, $pop147
	tee_local	$push145=, $6=, $pop146
	i32.const	$push144=, 16
	i32.shr_u	$push16=, $pop145, $pop144
	i32.store8	$drop=, sN+3($pop149), $pop16
	i32.const	$push143=, 0
	i32.const	$push142=, 1103515245
	i32.mul 	$push17=, $6, $pop142
	i32.const	$push141=, 12345
	i32.add 	$push140=, $pop17, $pop141
	tee_local	$push139=, $6=, $pop140
	i32.const	$push138=, 16
	i32.shr_u	$push18=, $pop139, $pop138
	i32.store8	$drop=, sN+4($pop143), $pop18
	i32.const	$push137=, 0
	i32.const	$push136=, 1103515245
	i32.mul 	$push19=, $6, $pop136
	i32.const	$push135=, 12345
	i32.add 	$push134=, $pop19, $pop135
	tee_local	$push133=, $6=, $pop134
	i32.const	$push132=, 16
	i32.shr_u	$push20=, $pop133, $pop132
	i32.store8	$drop=, sN+5($pop137), $pop20
	i32.const	$push131=, 0
	i32.const	$push130=, 1103515245
	i32.mul 	$push21=, $6, $pop130
	i32.const	$push129=, 12345
	i32.add 	$push128=, $pop21, $pop129
	tee_local	$push127=, $6=, $pop128
	i32.const	$push126=, 16
	i32.shr_u	$push22=, $pop127, $pop126
	i32.store8	$drop=, sN+6($pop131), $pop22
	i32.const	$push125=, 0
	i32.const	$push124=, 1103515245
	i32.mul 	$push23=, $6, $pop124
	i32.const	$push123=, 12345
	i32.add 	$push122=, $pop23, $pop123
	tee_local	$push121=, $6=, $pop122
	i32.const	$push120=, 16
	i32.shr_u	$push24=, $pop121, $pop120
	i32.store8	$drop=, sN+7($pop125), $pop24
	i32.const	$push119=, 0
	i64.load	$7=, sN($pop119)
	i32.const	$push118=, 0
	i32.const	$push117=, 1103515245
	i32.mul 	$push25=, $6, $pop117
	i32.const	$push116=, 12345
	i32.add 	$push115=, $pop25, $pop116
	tee_local	$push114=, $6=, $pop115
	i32.const	$push113=, 1103515245
	i32.mul 	$push26=, $pop114, $pop113
	i32.const	$push112=, 12345
	i32.add 	$push1=, $pop26, $pop112
	i32.store	$0=, myrnd.s($pop118), $pop1
	block
	i32.const	$push111=, 0
	i32.const	$push28=, 10
	i32.shr_u	$push29=, $6, $pop28
	i64.extend_u/i32	$push30=, $pop29
	i64.const	$push31=, 4032
	i64.and 	$push32=, $pop30, $pop31
	i64.const	$push27=, -4033
	i64.and 	$push110=, $7, $pop27
	tee_local	$push109=, $3=, $pop110
	i64.or  	$push2=, $pop32, $pop109
	i64.store	$push108=, sN($pop111), $pop2
	tee_local	$push107=, $1=, $pop108
	i64.const	$push106=, 4032
	i64.or  	$push35=, $7, $pop106
	i64.xor 	$push105=, $pop107, $pop35
	tee_local	$push104=, $7=, $pop105
	i64.const	$push36=, 34359734272
	i64.and 	$push37=, $pop104, $pop36
	i64.const	$push103=, 0
	i64.ne  	$push38=, $pop37, $pop103
	br_if   	0, $pop38       # 0: down to label8
# BB#1:                                 # %lor.lhs.false29
	i64.const	$push42=, 63
	i64.and 	$push43=, $7, $pop42
	i64.const	$push166=, 0
	i64.ne  	$push44=, $pop43, $pop166
	br_if   	0, $pop44       # 0: down to label8
# BB#2:                                 # %lor.lhs.false29
	i64.const	$push33=, 6
	i64.shr_u	$push34=, $1, $pop33
	i32.wrap/i64	$push171=, $pop34
	tee_local	$push170=, $4=, $pop171
	i32.const	$push169=, 16
	i32.shr_u	$push168=, $6, $pop169
	tee_local	$push167=, $6=, $pop168
	i32.xor 	$push40=, $pop170, $pop167
	i32.const	$push41=, 63
	i32.and 	$push39=, $pop40, $pop41
	br_if   	0, $pop39       # 0: down to label8
# BB#3:                                 # %lor.lhs.false49
	i32.const	$push175=, 16
	i32.shr_u	$push174=, $0, $pop175
	tee_local	$push173=, $2=, $pop174
	i32.add 	$push3=, $4, $pop173
	i32.add 	$push45=, $2, $6
	i32.xor 	$push46=, $pop3, $pop45
	i32.const	$push172=, 63
	i32.and 	$push47=, $pop46, $pop172
	br_if   	0, $pop47       # 0: down to label8
# BB#4:                                 # %lor.lhs.false69
	i32.const	$push52=, 0
	i32.const	$push48=, 1103515245
	i32.mul 	$push49=, $0, $pop48
	i32.const	$push50=, 12345
	i32.add 	$push191=, $pop49, $pop50
	tee_local	$push190=, $6=, $pop191
	i32.const	$push189=, 1103515245
	i32.mul 	$push51=, $pop190, $pop189
	i32.const	$push188=, 12345
	i32.add 	$push4=, $pop51, $pop188
	i32.store	$0=, myrnd.s($pop52), $pop4
	i32.const	$push187=, 0
	i32.const	$push53=, 10
	i32.shr_u	$push54=, $6, $pop53
	i64.extend_u/i32	$push55=, $pop54
	i64.const	$push56=, 4032
	i64.and 	$push57=, $pop55, $pop56
	i64.or  	$push58=, $pop57, $3
	i64.store	$push186=, sN($pop187), $pop58
	tee_local	$push185=, $7=, $pop186
	i64.const	$push59=, 6
	i64.shr_u	$push60=, $pop185, $pop59
	i32.wrap/i64	$push184=, $pop60
	tee_local	$push183=, $4=, $pop184
	i32.const	$push182=, 16
	i32.shr_u	$push181=, $0, $pop182
	tee_local	$push180=, $2=, $pop181
	i32.add 	$push61=, $pop183, $pop180
	i32.const	$push179=, 63
	i32.and 	$push62=, $pop61, $pop179
	i32.const	$push63=, 15
	i32.rem_u	$5=, $pop62, $pop63
	i64.xor 	$push178=, $7, $1
	tee_local	$push177=, $7=, $pop178
	i64.const	$push64=, 34359734272
	i64.and 	$push65=, $pop177, $pop64
	i64.const	$push176=, 0
	i64.ne  	$push66=, $pop65, $pop176
	br_if   	0, $pop66       # 0: down to label8
# BB#5:                                 # %lor.lhs.false80
	i64.const	$push70=, 63
	i64.and 	$push71=, $7, $pop70
	i64.const	$push192=, 0
	i64.ne  	$push72=, $pop71, $pop192
	br_if   	0, $pop72       # 0: down to label8
# BB#6:                                 # %lor.lhs.false80
	i32.const	$push195=, 16
	i32.shr_u	$push194=, $6, $pop195
	tee_local	$push193=, $6=, $pop194
	i32.xor 	$push68=, $4, $pop193
	i32.const	$push69=, 63
	i32.and 	$push67=, $pop68, $pop69
	br_if   	0, $pop67       # 0: down to label8
# BB#7:                                 # %lor.lhs.false100
	i32.add 	$push73=, $2, $6
	i32.const	$push196=, 63
	i32.and 	$push74=, $pop73, $pop196
	i32.const	$push75=, 15
	i32.rem_u	$push76=, $pop74, $pop75
	i32.ne  	$push77=, $pop76, $5
	br_if   	0, $pop77       # 0: down to label8
# BB#8:                                 # %lor.lhs.false125
	i32.const	$push83=, 0
	i32.const	$push78=, 1103515245
	i32.mul 	$push79=, $0, $pop78
	i32.const	$push80=, 12345
	i32.add 	$push208=, $pop79, $pop80
	tee_local	$push207=, $6=, $pop208
	i32.const	$push85=, 10
	i32.shr_u	$push86=, $pop207, $pop85
	i64.extend_u/i32	$push87=, $pop86
	i64.const	$push88=, 4032
	i64.and 	$push89=, $pop87, $pop88
	i64.or  	$push90=, $pop89, $3
	i64.const	$push91=, 6
	i64.shr_u	$push92=, $pop90, $pop91
	i32.wrap/i64	$push93=, $pop92
	i32.const	$push206=, 0
	i32.const	$push205=, 1103515245
	i32.mul 	$push81=, $6, $pop205
	i32.const	$push204=, 12345
	i32.add 	$push82=, $pop81, $pop204
	i32.store	$push0=, myrnd.s($pop206), $pop82
	i32.const	$push84=, 16
	i32.shr_u	$push203=, $pop0, $pop84
	tee_local	$push202=, $0=, $pop203
	i32.add 	$push201=, $pop93, $pop202
	tee_local	$push200=, $4=, $pop201
	i32.const	$push94=, 6
	i32.shl 	$push95=, $pop200, $pop94
	i64.extend_u/i32	$push96=, $pop95
	i64.const	$push199=, 4032
	i64.and 	$push97=, $pop96, $pop199
	i64.or  	$push98=, $pop97, $3
	i64.store	$drop=, sN($pop83), $pop98
	i32.const	$push198=, 16
	i32.shr_u	$push99=, $6, $pop198
	i32.add 	$push100=, $0, $pop99
	i32.xor 	$push101=, $pop100, $4
	i32.const	$push197=, 63
	i32.and 	$push102=, $pop101, $pop197
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
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	$drop=, 0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	$drop=, 0($pop2), $pop4
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop4
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
                                        # fallthrough-return: $pop6
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
                                        # fallthrough-return: $pop3
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
	i32.wrap/i64	$push3=, $pop12
	i32.add 	$push11=, $pop3, $0
	tee_local	$push10=, $0=, $pop11
	i64.extend_u/i32	$push4=, $pop10
	i64.const	$push5=, 4095
	i64.and 	$push6=, $pop4, $pop5
	i64.const	$push1=, -4096
	i64.and 	$push2=, $1, $pop1
	i64.or  	$push7=, $pop6, $pop2
	i64.store	$drop=, sO+8($pop0), $pop7
	i32.const	$push8=, 4095
	i32.and 	$push9=, $0, $pop8
                                        # fallthrough-return: $pop9
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
	i32.const	$push206=, 0
	i32.load	$push8=, myrnd.s($pop206)
	i32.const	$push9=, 1103515245
	i32.mul 	$push10=, $pop8, $pop9
	i32.const	$push11=, 12345
	i32.add 	$push205=, $pop10, $pop11
	tee_local	$push204=, $2=, $pop205
	i32.const	$push203=, 16
	i32.shr_u	$push12=, $pop204, $pop203
	i32.store8	$drop=, sO($pop7), $pop12
	i32.const	$push202=, 0
	i32.const	$push201=, 1103515245
	i32.mul 	$push13=, $2, $pop201
	i32.const	$push200=, 12345
	i32.add 	$push199=, $pop13, $pop200
	tee_local	$push198=, $2=, $pop199
	i32.const	$push197=, 16
	i32.shr_u	$push14=, $pop198, $pop197
	i32.store8	$drop=, sO+1($pop202), $pop14
	i32.const	$push196=, 0
	i32.const	$push195=, 1103515245
	i32.mul 	$push15=, $2, $pop195
	i32.const	$push194=, 12345
	i32.add 	$push193=, $pop15, $pop194
	tee_local	$push192=, $2=, $pop193
	i32.const	$push191=, 16
	i32.shr_u	$push16=, $pop192, $pop191
	i32.store8	$drop=, sO+2($pop196), $pop16
	i32.const	$push190=, 0
	i32.const	$push189=, 1103515245
	i32.mul 	$push17=, $2, $pop189
	i32.const	$push188=, 12345
	i32.add 	$push187=, $pop17, $pop188
	tee_local	$push186=, $2=, $pop187
	i32.const	$push185=, 16
	i32.shr_u	$push18=, $pop186, $pop185
	i32.store8	$drop=, sO+3($pop190), $pop18
	i32.const	$push184=, 0
	i32.const	$push183=, 1103515245
	i32.mul 	$push19=, $2, $pop183
	i32.const	$push182=, 12345
	i32.add 	$push181=, $pop19, $pop182
	tee_local	$push180=, $2=, $pop181
	i32.const	$push179=, 16
	i32.shr_u	$push20=, $pop180, $pop179
	i32.store8	$drop=, sO+4($pop184), $pop20
	i32.const	$push178=, 0
	i32.const	$push177=, 1103515245
	i32.mul 	$push21=, $2, $pop177
	i32.const	$push176=, 12345
	i32.add 	$push175=, $pop21, $pop176
	tee_local	$push174=, $2=, $pop175
	i32.const	$push173=, 16
	i32.shr_u	$push22=, $pop174, $pop173
	i32.store8	$drop=, sO+5($pop178), $pop22
	i32.const	$push172=, 0
	i32.const	$push171=, 1103515245
	i32.mul 	$push23=, $2, $pop171
	i32.const	$push170=, 12345
	i32.add 	$push169=, $pop23, $pop170
	tee_local	$push168=, $2=, $pop169
	i32.const	$push167=, 16
	i32.shr_u	$push24=, $pop168, $pop167
	i32.store8	$drop=, sO+6($pop172), $pop24
	i32.const	$push166=, 0
	i32.const	$push165=, 1103515245
	i32.mul 	$push25=, $2, $pop165
	i32.const	$push164=, 12345
	i32.add 	$push163=, $pop25, $pop164
	tee_local	$push162=, $2=, $pop163
	i32.const	$push161=, 16
	i32.shr_u	$push26=, $pop162, $pop161
	i32.store8	$drop=, sO+7($pop166), $pop26
	i32.const	$push160=, 0
	i32.const	$push159=, 1103515245
	i32.mul 	$push27=, $2, $pop159
	i32.const	$push158=, 12345
	i32.add 	$push157=, $pop27, $pop158
	tee_local	$push156=, $2=, $pop157
	i32.const	$push155=, 16
	i32.shr_u	$push28=, $pop156, $pop155
	i32.store8	$drop=, sO+8($pop160), $pop28
	i32.const	$push154=, 0
	i32.const	$push153=, 1103515245
	i32.mul 	$push29=, $2, $pop153
	i32.const	$push152=, 12345
	i32.add 	$push151=, $pop29, $pop152
	tee_local	$push150=, $2=, $pop151
	i32.const	$push149=, 16
	i32.shr_u	$push30=, $pop150, $pop149
	i32.store8	$drop=, sO+9($pop154), $pop30
	i32.const	$push148=, 0
	i32.const	$push147=, 1103515245
	i32.mul 	$push31=, $2, $pop147
	i32.const	$push146=, 12345
	i32.add 	$push145=, $pop31, $pop146
	tee_local	$push144=, $2=, $pop145
	i32.const	$push143=, 16
	i32.shr_u	$push32=, $pop144, $pop143
	i32.store8	$drop=, sO+10($pop148), $pop32
	i32.const	$push142=, 0
	i32.const	$push141=, 1103515245
	i32.mul 	$push33=, $2, $pop141
	i32.const	$push140=, 12345
	i32.add 	$push139=, $pop33, $pop140
	tee_local	$push138=, $2=, $pop139
	i32.const	$push137=, 16
	i32.shr_u	$push34=, $pop138, $pop137
	i32.store8	$drop=, sO+11($pop142), $pop34
	i32.const	$push136=, 0
	i32.const	$push135=, 1103515245
	i32.mul 	$push35=, $2, $pop135
	i32.const	$push134=, 12345
	i32.add 	$push133=, $pop35, $pop134
	tee_local	$push132=, $2=, $pop133
	i32.const	$push131=, 16
	i32.shr_u	$push36=, $pop132, $pop131
	i32.store8	$drop=, sO+12($pop136), $pop36
	i32.const	$push130=, 0
	i32.const	$push129=, 1103515245
	i32.mul 	$push37=, $2, $pop129
	i32.const	$push128=, 12345
	i32.add 	$push127=, $pop37, $pop128
	tee_local	$push126=, $2=, $pop127
	i32.const	$push125=, 16
	i32.shr_u	$push38=, $pop126, $pop125
	i32.store8	$drop=, sO+13($pop130), $pop38
	i32.const	$push124=, 0
	i32.const	$push123=, 1103515245
	i32.mul 	$push39=, $2, $pop123
	i32.const	$push122=, 12345
	i32.add 	$push121=, $pop39, $pop122
	tee_local	$push120=, $2=, $pop121
	i32.const	$push119=, 16
	i32.shr_u	$push40=, $pop120, $pop119
	i32.store8	$drop=, sO+14($pop124), $pop40
	i32.const	$push118=, 0
	i32.const	$push117=, 1103515245
	i32.mul 	$push41=, $2, $pop117
	i32.const	$push116=, 12345
	i32.add 	$push115=, $pop41, $pop116
	tee_local	$push114=, $2=, $pop115
	i32.const	$push113=, 16
	i32.shr_u	$push42=, $pop114, $pop113
	i32.store8	$drop=, sO+15($pop118), $pop42
	i32.const	$push112=, 0
	i64.load	$1=, sO+8($pop112)
	i32.const	$push111=, 0
	i32.const	$push110=, 1103515245
	i32.mul 	$push43=, $2, $pop110
	i32.const	$push109=, 12345
	i32.add 	$push108=, $pop43, $pop109
	tee_local	$push107=, $2=, $pop108
	i32.const	$push106=, 1103515245
	i32.mul 	$push44=, $pop107, $pop106
	i32.const	$push105=, 12345
	i32.add 	$push3=, $pop44, $pop105
	i32.store	$0=, myrnd.s($pop111), $pop3
	block
	i32.const	$push104=, 16
	i32.shr_u	$push47=, $2, $pop104
	i32.const	$push103=, 2047
	i32.and 	$push102=, $pop47, $pop103
	tee_local	$push101=, $2=, $pop102
	i32.const	$push100=, 0
	i64.extend_u/i32	$push48=, $2
	i64.const	$push45=, -4096
	i64.and 	$push46=, $1, $pop45
	i64.or  	$push49=, $pop48, $pop46
	i64.store	$push0=, sO+8($pop100), $pop49
	i32.wrap/i64	$push99=, $pop0
	tee_local	$push98=, $4=, $pop99
	i32.const	$push97=, 2047
	i32.and 	$push53=, $pop98, $pop97
	i32.ne  	$push54=, $pop101, $pop53
	br_if   	0, $pop54       # 0: down to label9
# BB#1:                                 # %entry
	i32.const	$push210=, 16
	i32.shr_u	$push50=, $0, $pop210
	i32.const	$push209=, 2047
	i32.and 	$push208=, $pop50, $pop209
	tee_local	$push207=, $3=, $pop208
	i32.add 	$push5=, $pop207, $2
	i32.add 	$push51=, $4, $3
	i32.const	$push52=, 4095
	i32.and 	$push6=, $pop51, $pop52
	i32.ne  	$push55=, $pop5, $pop6
	br_if   	0, $pop55       # 0: down to label9
# BB#2:                                 # %if.end
	i32.const	$push60=, 0
	i32.const	$push56=, 1103515245
	i32.mul 	$push57=, $0, $pop56
	i32.const	$push58=, 12345
	i32.add 	$push222=, $pop57, $pop58
	tee_local	$push221=, $2=, $pop222
	i32.const	$push220=, 1103515245
	i32.mul 	$push59=, $pop221, $pop220
	i32.const	$push219=, 12345
	i32.add 	$push4=, $pop59, $pop219
	i32.store	$0=, myrnd.s($pop60), $pop4
	i32.const	$push218=, 16
	i32.shr_u	$push63=, $2, $pop218
	i32.const	$push217=, 2047
	i32.and 	$push216=, $pop63, $pop217
	tee_local	$push215=, $2=, $pop216
	i32.const	$push214=, 0
	i64.extend_u/i32	$push64=, $2
	i64.const	$push61=, -4096
	i64.and 	$push62=, $1, $pop61
	i64.or  	$push65=, $pop64, $pop62
	i64.store	$push1=, sO+8($pop214), $pop65
	i32.wrap/i64	$push213=, $pop1
	tee_local	$push212=, $4=, $pop213
	i32.const	$push211=, 2047
	i32.and 	$push66=, $pop212, $pop211
	i32.ne  	$push67=, $pop215, $pop66
	br_if   	0, $pop67       # 0: down to label9
# BB#3:                                 # %lor.lhs.false87
	i32.const	$push228=, 16
	i32.shr_u	$push68=, $0, $pop228
	i32.const	$push227=, 2047
	i32.and 	$push226=, $pop68, $pop227
	tee_local	$push225=, $3=, $pop226
	i32.add 	$push69=, $pop225, $2
	i32.const	$push70=, 15
	i32.rem_u	$push71=, $pop69, $pop70
	i32.add 	$push72=, $4, $3
	i32.const	$push224=, 4095
	i32.and 	$push73=, $pop72, $pop224
	i32.const	$push223=, 15
	i32.rem_u	$push74=, $pop73, $pop223
	i32.ne  	$push75=, $pop71, $pop74
	br_if   	0, $pop75       # 0: down to label9
# BB#4:                                 # %lor.lhs.false124
	i32.const	$push81=, 0
	i32.const	$push76=, 1103515245
	i32.mul 	$push77=, $0, $pop76
	i32.const	$push78=, 12345
	i32.add 	$push244=, $pop77, $pop78
	tee_local	$push243=, $2=, $pop244
	i32.const	$push83=, 16
	i32.shr_u	$push84=, $pop243, $pop83
	i32.const	$push85=, 2047
	i32.and 	$push242=, $pop84, $pop85
	tee_local	$push241=, $0=, $pop242
	i64.extend_u/i32	$push86=, $pop241
	i64.const	$push82=, -4096
	i64.and 	$push240=, $1, $pop82
	tee_local	$push239=, $1=, $pop240
	i64.or  	$push87=, $pop86, $pop239
	i32.wrap/i64	$push88=, $pop87
	i32.const	$push238=, 0
	i32.const	$push237=, 1103515245
	i32.mul 	$push79=, $2, $pop237
	i32.const	$push236=, 12345
	i32.add 	$push80=, $pop79, $pop236
	i32.store	$push2=, myrnd.s($pop238), $pop80
	i32.const	$push235=, 16
	i32.shr_u	$push89=, $pop2, $pop235
	i32.const	$push234=, 2047
	i32.and 	$push233=, $pop89, $pop234
	tee_local	$push232=, $2=, $pop233
	i32.add 	$push231=, $pop88, $pop232
	tee_local	$push230=, $4=, $pop231
	i64.extend_u/i32	$push90=, $pop230
	i64.const	$push91=, 4095
	i64.and 	$push92=, $pop90, $pop91
	i64.or  	$push93=, $pop92, $1
	i64.store	$drop=, sO+8($pop81), $pop93
	i32.add 	$push94=, $2, $0
	i32.const	$push229=, 4095
	i32.and 	$push95=, $4, $pop229
	i32.ne  	$push96=, $pop94, $pop95
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
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	$drop=, 0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	$drop=, 0($pop2), $pop4
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop4
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
                                        # fallthrough-return: $pop6
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
                                        # fallthrough-return: $pop3
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
	i32.wrap/i64	$push3=, $pop12
	i32.add 	$push11=, $pop3, $0
	tee_local	$push10=, $0=, $pop11
	i64.extend_u/i32	$push4=, $pop10
	i64.const	$push5=, 4095
	i64.and 	$push6=, $pop4, $pop5
	i64.const	$push1=, -4096
	i64.and 	$push2=, $1, $pop1
	i64.or  	$push7=, $pop6, $pop2
	i64.store	$drop=, sP($pop0), $pop7
	i32.const	$push8=, 4095
	i32.and 	$push9=, $0, $pop8
                                        # fallthrough-return: $pop9
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
	i32.const	$push206=, 0
	i32.load	$push8=, myrnd.s($pop206)
	i32.const	$push9=, 1103515245
	i32.mul 	$push10=, $pop8, $pop9
	i32.const	$push11=, 12345
	i32.add 	$push205=, $pop10, $pop11
	tee_local	$push204=, $2=, $pop205
	i32.const	$push203=, 16
	i32.shr_u	$push12=, $pop204, $pop203
	i32.store8	$drop=, sP($pop7), $pop12
	i32.const	$push202=, 0
	i32.const	$push201=, 1103515245
	i32.mul 	$push13=, $2, $pop201
	i32.const	$push200=, 12345
	i32.add 	$push199=, $pop13, $pop200
	tee_local	$push198=, $2=, $pop199
	i32.const	$push197=, 16
	i32.shr_u	$push14=, $pop198, $pop197
	i32.store8	$drop=, sP+1($pop202), $pop14
	i32.const	$push196=, 0
	i32.const	$push195=, 1103515245
	i32.mul 	$push15=, $2, $pop195
	i32.const	$push194=, 12345
	i32.add 	$push193=, $pop15, $pop194
	tee_local	$push192=, $2=, $pop193
	i32.const	$push191=, 16
	i32.shr_u	$push16=, $pop192, $pop191
	i32.store8	$drop=, sP+2($pop196), $pop16
	i32.const	$push190=, 0
	i32.const	$push189=, 1103515245
	i32.mul 	$push17=, $2, $pop189
	i32.const	$push188=, 12345
	i32.add 	$push187=, $pop17, $pop188
	tee_local	$push186=, $2=, $pop187
	i32.const	$push185=, 16
	i32.shr_u	$push18=, $pop186, $pop185
	i32.store8	$drop=, sP+3($pop190), $pop18
	i32.const	$push184=, 0
	i32.const	$push183=, 1103515245
	i32.mul 	$push19=, $2, $pop183
	i32.const	$push182=, 12345
	i32.add 	$push181=, $pop19, $pop182
	tee_local	$push180=, $2=, $pop181
	i32.const	$push179=, 16
	i32.shr_u	$push20=, $pop180, $pop179
	i32.store8	$drop=, sP+4($pop184), $pop20
	i32.const	$push178=, 0
	i32.const	$push177=, 1103515245
	i32.mul 	$push21=, $2, $pop177
	i32.const	$push176=, 12345
	i32.add 	$push175=, $pop21, $pop176
	tee_local	$push174=, $2=, $pop175
	i32.const	$push173=, 16
	i32.shr_u	$push22=, $pop174, $pop173
	i32.store8	$drop=, sP+5($pop178), $pop22
	i32.const	$push172=, 0
	i32.const	$push171=, 1103515245
	i32.mul 	$push23=, $2, $pop171
	i32.const	$push170=, 12345
	i32.add 	$push169=, $pop23, $pop170
	tee_local	$push168=, $2=, $pop169
	i32.const	$push167=, 16
	i32.shr_u	$push24=, $pop168, $pop167
	i32.store8	$drop=, sP+6($pop172), $pop24
	i32.const	$push166=, 0
	i32.const	$push165=, 1103515245
	i32.mul 	$push25=, $2, $pop165
	i32.const	$push164=, 12345
	i32.add 	$push163=, $pop25, $pop164
	tee_local	$push162=, $2=, $pop163
	i32.const	$push161=, 16
	i32.shr_u	$push26=, $pop162, $pop161
	i32.store8	$drop=, sP+7($pop166), $pop26
	i32.const	$push160=, 0
	i32.const	$push159=, 1103515245
	i32.mul 	$push27=, $2, $pop159
	i32.const	$push158=, 12345
	i32.add 	$push157=, $pop27, $pop158
	tee_local	$push156=, $2=, $pop157
	i32.const	$push155=, 16
	i32.shr_u	$push28=, $pop156, $pop155
	i32.store8	$drop=, sP+8($pop160), $pop28
	i32.const	$push154=, 0
	i32.const	$push153=, 1103515245
	i32.mul 	$push29=, $2, $pop153
	i32.const	$push152=, 12345
	i32.add 	$push151=, $pop29, $pop152
	tee_local	$push150=, $2=, $pop151
	i32.const	$push149=, 16
	i32.shr_u	$push30=, $pop150, $pop149
	i32.store8	$drop=, sP+9($pop154), $pop30
	i32.const	$push148=, 0
	i32.const	$push147=, 1103515245
	i32.mul 	$push31=, $2, $pop147
	i32.const	$push146=, 12345
	i32.add 	$push145=, $pop31, $pop146
	tee_local	$push144=, $2=, $pop145
	i32.const	$push143=, 16
	i32.shr_u	$push32=, $pop144, $pop143
	i32.store8	$drop=, sP+10($pop148), $pop32
	i32.const	$push142=, 0
	i32.const	$push141=, 1103515245
	i32.mul 	$push33=, $2, $pop141
	i32.const	$push140=, 12345
	i32.add 	$push139=, $pop33, $pop140
	tee_local	$push138=, $2=, $pop139
	i32.const	$push137=, 16
	i32.shr_u	$push34=, $pop138, $pop137
	i32.store8	$drop=, sP+11($pop142), $pop34
	i32.const	$push136=, 0
	i32.const	$push135=, 1103515245
	i32.mul 	$push35=, $2, $pop135
	i32.const	$push134=, 12345
	i32.add 	$push133=, $pop35, $pop134
	tee_local	$push132=, $2=, $pop133
	i32.const	$push131=, 16
	i32.shr_u	$push36=, $pop132, $pop131
	i32.store8	$drop=, sP+12($pop136), $pop36
	i32.const	$push130=, 0
	i32.const	$push129=, 1103515245
	i32.mul 	$push37=, $2, $pop129
	i32.const	$push128=, 12345
	i32.add 	$push127=, $pop37, $pop128
	tee_local	$push126=, $2=, $pop127
	i32.const	$push125=, 16
	i32.shr_u	$push38=, $pop126, $pop125
	i32.store8	$drop=, sP+13($pop130), $pop38
	i32.const	$push124=, 0
	i32.const	$push123=, 1103515245
	i32.mul 	$push39=, $2, $pop123
	i32.const	$push122=, 12345
	i32.add 	$push121=, $pop39, $pop122
	tee_local	$push120=, $2=, $pop121
	i32.const	$push119=, 16
	i32.shr_u	$push40=, $pop120, $pop119
	i32.store8	$drop=, sP+14($pop124), $pop40
	i32.const	$push118=, 0
	i32.const	$push117=, 1103515245
	i32.mul 	$push41=, $2, $pop117
	i32.const	$push116=, 12345
	i32.add 	$push115=, $pop41, $pop116
	tee_local	$push114=, $2=, $pop115
	i32.const	$push113=, 16
	i32.shr_u	$push42=, $pop114, $pop113
	i32.store8	$drop=, sP+15($pop118), $pop42
	i32.const	$push112=, 0
	i64.load	$1=, sP($pop112)
	i32.const	$push111=, 0
	i32.const	$push110=, 1103515245
	i32.mul 	$push43=, $2, $pop110
	i32.const	$push109=, 12345
	i32.add 	$push108=, $pop43, $pop109
	tee_local	$push107=, $2=, $pop108
	i32.const	$push106=, 1103515245
	i32.mul 	$push44=, $pop107, $pop106
	i32.const	$push105=, 12345
	i32.add 	$push3=, $pop44, $pop105
	i32.store	$0=, myrnd.s($pop111), $pop3
	block
	i32.const	$push104=, 16
	i32.shr_u	$push47=, $2, $pop104
	i32.const	$push103=, 2047
	i32.and 	$push102=, $pop47, $pop103
	tee_local	$push101=, $2=, $pop102
	i32.const	$push100=, 0
	i64.extend_u/i32	$push48=, $2
	i64.const	$push45=, -4096
	i64.and 	$push46=, $1, $pop45
	i64.or  	$push49=, $pop48, $pop46
	i64.store	$push0=, sP($pop100), $pop49
	i32.wrap/i64	$push99=, $pop0
	tee_local	$push98=, $4=, $pop99
	i32.const	$push97=, 2047
	i32.and 	$push53=, $pop98, $pop97
	i32.ne  	$push54=, $pop101, $pop53
	br_if   	0, $pop54       # 0: down to label10
# BB#1:                                 # %entry
	i32.const	$push210=, 16
	i32.shr_u	$push50=, $0, $pop210
	i32.const	$push209=, 2047
	i32.and 	$push208=, $pop50, $pop209
	tee_local	$push207=, $3=, $pop208
	i32.add 	$push5=, $pop207, $2
	i32.add 	$push51=, $4, $3
	i32.const	$push52=, 4095
	i32.and 	$push6=, $pop51, $pop52
	i32.ne  	$push55=, $pop5, $pop6
	br_if   	0, $pop55       # 0: down to label10
# BB#2:                                 # %if.end
	i32.const	$push60=, 0
	i32.const	$push56=, 1103515245
	i32.mul 	$push57=, $0, $pop56
	i32.const	$push58=, 12345
	i32.add 	$push222=, $pop57, $pop58
	tee_local	$push221=, $2=, $pop222
	i32.const	$push220=, 1103515245
	i32.mul 	$push59=, $pop221, $pop220
	i32.const	$push219=, 12345
	i32.add 	$push4=, $pop59, $pop219
	i32.store	$0=, myrnd.s($pop60), $pop4
	i32.const	$push218=, 16
	i32.shr_u	$push63=, $2, $pop218
	i32.const	$push217=, 2047
	i32.and 	$push216=, $pop63, $pop217
	tee_local	$push215=, $2=, $pop216
	i32.const	$push214=, 0
	i64.extend_u/i32	$push64=, $2
	i64.const	$push61=, -4096
	i64.and 	$push62=, $1, $pop61
	i64.or  	$push65=, $pop64, $pop62
	i64.store	$push1=, sP($pop214), $pop65
	i32.wrap/i64	$push213=, $pop1
	tee_local	$push212=, $4=, $pop213
	i32.const	$push211=, 2047
	i32.and 	$push66=, $pop212, $pop211
	i32.ne  	$push67=, $pop215, $pop66
	br_if   	0, $pop67       # 0: down to label10
# BB#3:                                 # %lor.lhs.false83
	i32.const	$push228=, 16
	i32.shr_u	$push68=, $0, $pop228
	i32.const	$push227=, 2047
	i32.and 	$push226=, $pop68, $pop227
	tee_local	$push225=, $3=, $pop226
	i32.add 	$push69=, $pop225, $2
	i32.const	$push70=, 15
	i32.rem_u	$push71=, $pop69, $pop70
	i32.add 	$push72=, $4, $3
	i32.const	$push224=, 4095
	i32.and 	$push73=, $pop72, $pop224
	i32.const	$push223=, 15
	i32.rem_u	$push74=, $pop73, $pop223
	i32.ne  	$push75=, $pop71, $pop74
	br_if   	0, $pop75       # 0: down to label10
# BB#4:                                 # %lor.lhs.false118
	i32.const	$push81=, 0
	i32.const	$push76=, 1103515245
	i32.mul 	$push77=, $0, $pop76
	i32.const	$push78=, 12345
	i32.add 	$push244=, $pop77, $pop78
	tee_local	$push243=, $2=, $pop244
	i32.const	$push83=, 16
	i32.shr_u	$push84=, $pop243, $pop83
	i32.const	$push85=, 2047
	i32.and 	$push242=, $pop84, $pop85
	tee_local	$push241=, $0=, $pop242
	i64.extend_u/i32	$push86=, $pop241
	i64.const	$push82=, -4096
	i64.and 	$push240=, $1, $pop82
	tee_local	$push239=, $1=, $pop240
	i64.or  	$push87=, $pop86, $pop239
	i32.wrap/i64	$push88=, $pop87
	i32.const	$push238=, 0
	i32.const	$push237=, 1103515245
	i32.mul 	$push79=, $2, $pop237
	i32.const	$push236=, 12345
	i32.add 	$push80=, $pop79, $pop236
	i32.store	$push2=, myrnd.s($pop238), $pop80
	i32.const	$push235=, 16
	i32.shr_u	$push89=, $pop2, $pop235
	i32.const	$push234=, 2047
	i32.and 	$push233=, $pop89, $pop234
	tee_local	$push232=, $2=, $pop233
	i32.add 	$push231=, $pop88, $pop232
	tee_local	$push230=, $4=, $pop231
	i64.extend_u/i32	$push90=, $pop230
	i64.const	$push91=, 4095
	i64.and 	$push92=, $pop90, $pop91
	i64.or  	$push93=, $pop92, $1
	i64.store	$drop=, sP($pop81), $pop93
	i32.add 	$push94=, $2, $0
	i32.const	$push229=, 4095
	i32.and 	$push95=, $4, $pop229
	i32.ne  	$push96=, $pop94, $pop95
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
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	$drop=, 0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	$drop=, 0($pop2), $pop4
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop4
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
                                        # fallthrough-return: $pop6
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
                                        # fallthrough-return: $pop3
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
	i32.add 	$push3=, $pop8, $0
	i32.const	$push4=, 4095
	i32.and 	$push7=, $pop3, $pop4
	tee_local	$push6=, $0=, $pop7
	i32.const	$push1=, -4096
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push5=, $pop6, $pop2
	i32.store	$drop=, sQ($pop0), $pop5
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
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
	tee_local	$push152=, $0=, $pop153
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop152, $pop6
	i32.store8	$drop=, sQ($pop1), $pop7
	i32.const	$push151=, 0
	i32.const	$push150=, 1103515245
	i32.mul 	$push8=, $0, $pop150
	i32.const	$push149=, 12345
	i32.add 	$push148=, $pop8, $pop149
	tee_local	$push147=, $0=, $pop148
	i32.const	$push146=, 16
	i32.shr_u	$push9=, $pop147, $pop146
	i32.store8	$drop=, sQ+1($pop151), $pop9
	i32.const	$push145=, 0
	i32.const	$push144=, 1103515245
	i32.mul 	$push10=, $0, $pop144
	i32.const	$push143=, 12345
	i32.add 	$push142=, $pop10, $pop143
	tee_local	$push141=, $0=, $pop142
	i32.const	$push140=, 16
	i32.shr_u	$push11=, $pop141, $pop140
	i32.store8	$drop=, sQ+2($pop145), $pop11
	i32.const	$push139=, 0
	i32.const	$push138=, 1103515245
	i32.mul 	$push12=, $0, $pop138
	i32.const	$push137=, 12345
	i32.add 	$push136=, $pop12, $pop137
	tee_local	$push135=, $0=, $pop136
	i32.const	$push134=, 16
	i32.shr_u	$push13=, $pop135, $pop134
	i32.store8	$drop=, sQ+3($pop139), $pop13
	i32.const	$push133=, 0
	i32.const	$push132=, 1103515245
	i32.mul 	$push14=, $0, $pop132
	i32.const	$push131=, 12345
	i32.add 	$push130=, $pop14, $pop131
	tee_local	$push129=, $0=, $pop130
	i32.const	$push128=, 16
	i32.shr_u	$push15=, $pop129, $pop128
	i32.store8	$drop=, sQ+4($pop133), $pop15
	i32.const	$push127=, 0
	i32.const	$push126=, 1103515245
	i32.mul 	$push16=, $0, $pop126
	i32.const	$push125=, 12345
	i32.add 	$push124=, $pop16, $pop125
	tee_local	$push123=, $0=, $pop124
	i32.const	$push122=, 16
	i32.shr_u	$push17=, $pop123, $pop122
	i32.store8	$drop=, sQ+5($pop127), $pop17
	i32.const	$push121=, 0
	i32.const	$push120=, 1103515245
	i32.mul 	$push18=, $0, $pop120
	i32.const	$push119=, 12345
	i32.add 	$push118=, $pop18, $pop119
	tee_local	$push117=, $0=, $pop118
	i32.const	$push116=, 16
	i32.shr_u	$push19=, $pop117, $pop116
	i32.store8	$drop=, sQ+6($pop121), $pop19
	i32.const	$push115=, 0
	i32.const	$push114=, 1103515245
	i32.mul 	$push20=, $0, $pop114
	i32.const	$push113=, 12345
	i32.add 	$push112=, $pop20, $pop113
	tee_local	$push111=, $0=, $pop112
	i32.const	$push110=, 16
	i32.shr_u	$push21=, $pop111, $pop110
	i32.store8	$drop=, sQ+7($pop115), $pop21
	i32.const	$push109=, 0
	i32.const	$push108=, 1103515245
	i32.mul 	$push22=, $0, $pop108
	i32.const	$push107=, 12345
	i32.add 	$push106=, $pop22, $pop107
	tee_local	$push105=, $0=, $pop106
	i32.const	$push104=, 16
	i32.shr_u	$push23=, $pop105, $pop104
	i32.store8	$drop=, sQ+8($pop109), $pop23
	i32.const	$push103=, 0
	i32.const	$push102=, 1103515245
	i32.mul 	$push24=, $0, $pop102
	i32.const	$push101=, 12345
	i32.add 	$push100=, $pop24, $pop101
	tee_local	$push99=, $0=, $pop100
	i32.const	$push98=, 16
	i32.shr_u	$push25=, $pop99, $pop98
	i32.store8	$drop=, sQ+9($pop103), $pop25
	i32.const	$push97=, 0
	i32.const	$push96=, 1103515245
	i32.mul 	$push26=, $0, $pop96
	i32.const	$push95=, 12345
	i32.add 	$push94=, $pop26, $pop95
	tee_local	$push93=, $0=, $pop94
	i32.const	$push92=, 16
	i32.shr_u	$push27=, $pop93, $pop92
	i32.store8	$drop=, sQ+10($pop97), $pop27
	i32.const	$push91=, 0
	i32.const	$push90=, 1103515245
	i32.mul 	$push28=, $0, $pop90
	i32.const	$push89=, 12345
	i32.add 	$push88=, $pop28, $pop89
	tee_local	$push87=, $0=, $pop88
	i32.const	$push86=, 16
	i32.shr_u	$push29=, $pop87, $pop86
	i32.store8	$drop=, sQ+11($pop91), $pop29
	i32.const	$push85=, 0
	i32.const	$push84=, 1103515245
	i32.mul 	$push30=, $0, $pop84
	i32.const	$push83=, 12345
	i32.add 	$push82=, $pop30, $pop83
	tee_local	$push81=, $0=, $pop82
	i32.const	$push80=, 16
	i32.shr_u	$push31=, $pop81, $pop80
	i32.store8	$drop=, sQ+12($pop85), $pop31
	i32.const	$push79=, 0
	i32.const	$push78=, 1103515245
	i32.mul 	$push32=, $0, $pop78
	i32.const	$push77=, 12345
	i32.add 	$push76=, $pop32, $pop77
	tee_local	$push75=, $0=, $pop76
	i32.const	$push74=, 16
	i32.shr_u	$push33=, $pop75, $pop74
	i32.store8	$drop=, sQ+13($pop79), $pop33
	i32.const	$push73=, 0
	i32.const	$push72=, 1103515245
	i32.mul 	$push34=, $0, $pop72
	i32.const	$push71=, 12345
	i32.add 	$push70=, $pop34, $pop71
	tee_local	$push69=, $0=, $pop70
	i32.const	$push68=, 16
	i32.shr_u	$push35=, $pop69, $pop68
	i32.store8	$drop=, sQ+14($pop73), $pop35
	i32.const	$push67=, 0
	i32.const	$push66=, 1103515245
	i32.mul 	$push36=, $0, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push64=, $pop36, $pop65
	tee_local	$push63=, $0=, $pop64
	i32.const	$push62=, 16
	i32.shr_u	$push37=, $pop63, $pop62
	i32.store8	$drop=, sQ+15($pop67), $pop37
	i32.const	$push61=, 0
	i32.load	$1=, sQ($pop61)
	i32.const	$push60=, 0
	i32.const	$push59=, 0
	i32.const	$push38=, -341751747
	i32.mul 	$push39=, $0, $pop38
	i32.const	$push40=, 229283573
	i32.add 	$push58=, $pop39, $pop40
	tee_local	$push57=, $0=, $pop58
	i32.const	$push56=, 1103515245
	i32.mul 	$push41=, $pop57, $pop56
	i32.const	$push55=, 12345
	i32.add 	$push42=, $pop41, $pop55
	i32.store	$push0=, myrnd.s($pop59), $pop42
	i32.const	$push54=, 16
	i32.shr_u	$push46=, $pop0, $pop54
	i32.const	$push44=, 2047
	i32.and 	$push47=, $pop46, $pop44
	i32.const	$push53=, 16
	i32.shr_u	$push43=, $0, $pop53
	i32.const	$push52=, 2047
	i32.and 	$push45=, $pop43, $pop52
	i32.add 	$push48=, $pop47, $pop45
	i32.const	$push49=, -4096
	i32.and 	$push50=, $1, $pop49
	i32.or  	$push51=, $pop48, $pop50
	i32.store	$drop=, sQ($pop60), $pop51
                                        # fallthrough-return
	.endfunc
.Lfunc_end102:
	.size	testQ, .Lfunc_end102-testQ

	.section	.text.retmeR,"ax",@progbits
	.hidden	retmeR
	.globl	retmeR
	.type	retmeR,@function
retmeR:                                 # @retmeR
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	$drop=, 0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	$drop=, 0($pop2), $pop4
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop4
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
                                        # fallthrough-return: $pop6
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
                                        # fallthrough-return: $pop3
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
	i32.add 	$push3=, $pop8, $0
	i32.const	$push4=, 4095
	i32.and 	$push7=, $pop3, $pop4
	tee_local	$push6=, $0=, $pop7
	i32.const	$push1=, -4096
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push5=, $pop6, $pop2
	i32.store	$drop=, sR($pop0), $pop5
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
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
	tee_local	$push152=, $0=, $pop153
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop152, $pop6
	i32.store8	$drop=, sR($pop1), $pop7
	i32.const	$push151=, 0
	i32.const	$push150=, 1103515245
	i32.mul 	$push8=, $0, $pop150
	i32.const	$push149=, 12345
	i32.add 	$push148=, $pop8, $pop149
	tee_local	$push147=, $0=, $pop148
	i32.const	$push146=, 16
	i32.shr_u	$push9=, $pop147, $pop146
	i32.store8	$drop=, sR+1($pop151), $pop9
	i32.const	$push145=, 0
	i32.const	$push144=, 1103515245
	i32.mul 	$push10=, $0, $pop144
	i32.const	$push143=, 12345
	i32.add 	$push142=, $pop10, $pop143
	tee_local	$push141=, $0=, $pop142
	i32.const	$push140=, 16
	i32.shr_u	$push11=, $pop141, $pop140
	i32.store8	$drop=, sR+2($pop145), $pop11
	i32.const	$push139=, 0
	i32.const	$push138=, 1103515245
	i32.mul 	$push12=, $0, $pop138
	i32.const	$push137=, 12345
	i32.add 	$push136=, $pop12, $pop137
	tee_local	$push135=, $0=, $pop136
	i32.const	$push134=, 16
	i32.shr_u	$push13=, $pop135, $pop134
	i32.store8	$drop=, sR+3($pop139), $pop13
	i32.const	$push133=, 0
	i32.const	$push132=, 1103515245
	i32.mul 	$push14=, $0, $pop132
	i32.const	$push131=, 12345
	i32.add 	$push130=, $pop14, $pop131
	tee_local	$push129=, $0=, $pop130
	i32.const	$push128=, 16
	i32.shr_u	$push15=, $pop129, $pop128
	i32.store8	$drop=, sR+4($pop133), $pop15
	i32.const	$push127=, 0
	i32.const	$push126=, 1103515245
	i32.mul 	$push16=, $0, $pop126
	i32.const	$push125=, 12345
	i32.add 	$push124=, $pop16, $pop125
	tee_local	$push123=, $0=, $pop124
	i32.const	$push122=, 16
	i32.shr_u	$push17=, $pop123, $pop122
	i32.store8	$drop=, sR+5($pop127), $pop17
	i32.const	$push121=, 0
	i32.const	$push120=, 1103515245
	i32.mul 	$push18=, $0, $pop120
	i32.const	$push119=, 12345
	i32.add 	$push118=, $pop18, $pop119
	tee_local	$push117=, $0=, $pop118
	i32.const	$push116=, 16
	i32.shr_u	$push19=, $pop117, $pop116
	i32.store8	$drop=, sR+6($pop121), $pop19
	i32.const	$push115=, 0
	i32.const	$push114=, 1103515245
	i32.mul 	$push20=, $0, $pop114
	i32.const	$push113=, 12345
	i32.add 	$push112=, $pop20, $pop113
	tee_local	$push111=, $0=, $pop112
	i32.const	$push110=, 16
	i32.shr_u	$push21=, $pop111, $pop110
	i32.store8	$drop=, sR+7($pop115), $pop21
	i32.const	$push109=, 0
	i32.const	$push108=, 1103515245
	i32.mul 	$push22=, $0, $pop108
	i32.const	$push107=, 12345
	i32.add 	$push106=, $pop22, $pop107
	tee_local	$push105=, $0=, $pop106
	i32.const	$push104=, 16
	i32.shr_u	$push23=, $pop105, $pop104
	i32.store8	$drop=, sR+8($pop109), $pop23
	i32.const	$push103=, 0
	i32.const	$push102=, 1103515245
	i32.mul 	$push24=, $0, $pop102
	i32.const	$push101=, 12345
	i32.add 	$push100=, $pop24, $pop101
	tee_local	$push99=, $0=, $pop100
	i32.const	$push98=, 16
	i32.shr_u	$push25=, $pop99, $pop98
	i32.store8	$drop=, sR+9($pop103), $pop25
	i32.const	$push97=, 0
	i32.const	$push96=, 1103515245
	i32.mul 	$push26=, $0, $pop96
	i32.const	$push95=, 12345
	i32.add 	$push94=, $pop26, $pop95
	tee_local	$push93=, $0=, $pop94
	i32.const	$push92=, 16
	i32.shr_u	$push27=, $pop93, $pop92
	i32.store8	$drop=, sR+10($pop97), $pop27
	i32.const	$push91=, 0
	i32.const	$push90=, 1103515245
	i32.mul 	$push28=, $0, $pop90
	i32.const	$push89=, 12345
	i32.add 	$push88=, $pop28, $pop89
	tee_local	$push87=, $0=, $pop88
	i32.const	$push86=, 16
	i32.shr_u	$push29=, $pop87, $pop86
	i32.store8	$drop=, sR+11($pop91), $pop29
	i32.const	$push85=, 0
	i32.const	$push84=, 1103515245
	i32.mul 	$push30=, $0, $pop84
	i32.const	$push83=, 12345
	i32.add 	$push82=, $pop30, $pop83
	tee_local	$push81=, $0=, $pop82
	i32.const	$push80=, 16
	i32.shr_u	$push31=, $pop81, $pop80
	i32.store8	$drop=, sR+12($pop85), $pop31
	i32.const	$push79=, 0
	i32.const	$push78=, 1103515245
	i32.mul 	$push32=, $0, $pop78
	i32.const	$push77=, 12345
	i32.add 	$push76=, $pop32, $pop77
	tee_local	$push75=, $0=, $pop76
	i32.const	$push74=, 16
	i32.shr_u	$push33=, $pop75, $pop74
	i32.store8	$drop=, sR+13($pop79), $pop33
	i32.const	$push73=, 0
	i32.const	$push72=, 1103515245
	i32.mul 	$push34=, $0, $pop72
	i32.const	$push71=, 12345
	i32.add 	$push70=, $pop34, $pop71
	tee_local	$push69=, $0=, $pop70
	i32.const	$push68=, 16
	i32.shr_u	$push35=, $pop69, $pop68
	i32.store8	$drop=, sR+14($pop73), $pop35
	i32.const	$push67=, 0
	i32.const	$push66=, 1103515245
	i32.mul 	$push36=, $0, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push64=, $pop36, $pop65
	tee_local	$push63=, $0=, $pop64
	i32.const	$push62=, 16
	i32.shr_u	$push37=, $pop63, $pop62
	i32.store8	$drop=, sR+15($pop67), $pop37
	i32.const	$push61=, 0
	i32.load	$1=, sR($pop61)
	i32.const	$push60=, 0
	i32.const	$push59=, 0
	i32.const	$push38=, -341751747
	i32.mul 	$push39=, $0, $pop38
	i32.const	$push40=, 229283573
	i32.add 	$push58=, $pop39, $pop40
	tee_local	$push57=, $0=, $pop58
	i32.const	$push56=, 1103515245
	i32.mul 	$push41=, $pop57, $pop56
	i32.const	$push55=, 12345
	i32.add 	$push42=, $pop41, $pop55
	i32.store	$push0=, myrnd.s($pop59), $pop42
	i32.const	$push54=, 16
	i32.shr_u	$push46=, $pop0, $pop54
	i32.const	$push44=, 2047
	i32.and 	$push47=, $pop46, $pop44
	i32.const	$push53=, 16
	i32.shr_u	$push43=, $0, $pop53
	i32.const	$push52=, 2047
	i32.and 	$push45=, $pop43, $pop52
	i32.add 	$push48=, $pop47, $pop45
	i32.const	$push49=, -4096
	i32.and 	$push50=, $1, $pop49
	i32.or  	$push51=, $pop48, $pop50
	i32.store	$drop=, sR($pop60), $pop51
                                        # fallthrough-return
	.endfunc
.Lfunc_end108:
	.size	testR, .Lfunc_end108-testR

	.section	.text.retmeS,"ax",@progbits
	.hidden	retmeS
	.globl	retmeS
	.type	retmeS,@function
retmeS:                                 # @retmeS
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	$drop=, 0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	$drop=, 0($pop2), $pop4
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop4
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
                                        # fallthrough-return: $pop6
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
                                        # fallthrough-return: $pop3
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
	i32.add 	$push3=, $pop8, $0
	i32.const	$push4=, 1
	i32.and 	$push7=, $pop3, $pop4
	tee_local	$push6=, $0=, $pop7
	i32.const	$push1=, 65534
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push5=, $pop6, $pop2
	i32.store16	$drop=, sS($pop0), $pop5
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
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
	tee_local	$push151=, $0=, $pop152
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop151, $pop6
	i32.store8	$drop=, sS($pop1), $pop7
	i32.const	$push150=, 0
	i32.const	$push149=, 1103515245
	i32.mul 	$push8=, $0, $pop149
	i32.const	$push148=, 12345
	i32.add 	$push147=, $pop8, $pop148
	tee_local	$push146=, $0=, $pop147
	i32.const	$push145=, 16
	i32.shr_u	$push9=, $pop146, $pop145
	i32.store8	$drop=, sS+1($pop150), $pop9
	i32.const	$push144=, 0
	i32.const	$push143=, 1103515245
	i32.mul 	$push10=, $0, $pop143
	i32.const	$push142=, 12345
	i32.add 	$push141=, $pop10, $pop142
	tee_local	$push140=, $0=, $pop141
	i32.const	$push139=, 16
	i32.shr_u	$push11=, $pop140, $pop139
	i32.store8	$drop=, sS+2($pop144), $pop11
	i32.const	$push138=, 0
	i32.const	$push137=, 1103515245
	i32.mul 	$push12=, $0, $pop137
	i32.const	$push136=, 12345
	i32.add 	$push135=, $pop12, $pop136
	tee_local	$push134=, $0=, $pop135
	i32.const	$push133=, 16
	i32.shr_u	$push13=, $pop134, $pop133
	i32.store8	$drop=, sS+3($pop138), $pop13
	i32.const	$push132=, 0
	i32.const	$push131=, 1103515245
	i32.mul 	$push14=, $0, $pop131
	i32.const	$push130=, 12345
	i32.add 	$push129=, $pop14, $pop130
	tee_local	$push128=, $0=, $pop129
	i32.const	$push127=, 16
	i32.shr_u	$push15=, $pop128, $pop127
	i32.store8	$drop=, sS+4($pop132), $pop15
	i32.const	$push126=, 0
	i32.const	$push125=, 1103515245
	i32.mul 	$push16=, $0, $pop125
	i32.const	$push124=, 12345
	i32.add 	$push123=, $pop16, $pop124
	tee_local	$push122=, $0=, $pop123
	i32.const	$push121=, 16
	i32.shr_u	$push17=, $pop122, $pop121
	i32.store8	$drop=, sS+5($pop126), $pop17
	i32.const	$push120=, 0
	i32.const	$push119=, 1103515245
	i32.mul 	$push18=, $0, $pop119
	i32.const	$push118=, 12345
	i32.add 	$push117=, $pop18, $pop118
	tee_local	$push116=, $0=, $pop117
	i32.const	$push115=, 16
	i32.shr_u	$push19=, $pop116, $pop115
	i32.store8	$drop=, sS+6($pop120), $pop19
	i32.const	$push114=, 0
	i32.const	$push113=, 1103515245
	i32.mul 	$push20=, $0, $pop113
	i32.const	$push112=, 12345
	i32.add 	$push111=, $pop20, $pop112
	tee_local	$push110=, $0=, $pop111
	i32.const	$push109=, 16
	i32.shr_u	$push21=, $pop110, $pop109
	i32.store8	$drop=, sS+7($pop114), $pop21
	i32.const	$push108=, 0
	i32.const	$push107=, 1103515245
	i32.mul 	$push22=, $0, $pop107
	i32.const	$push106=, 12345
	i32.add 	$push105=, $pop22, $pop106
	tee_local	$push104=, $0=, $pop105
	i32.const	$push103=, 16
	i32.shr_u	$push23=, $pop104, $pop103
	i32.store8	$drop=, sS+8($pop108), $pop23
	i32.const	$push102=, 0
	i32.const	$push101=, 1103515245
	i32.mul 	$push24=, $0, $pop101
	i32.const	$push100=, 12345
	i32.add 	$push99=, $pop24, $pop100
	tee_local	$push98=, $0=, $pop99
	i32.const	$push97=, 16
	i32.shr_u	$push25=, $pop98, $pop97
	i32.store8	$drop=, sS+9($pop102), $pop25
	i32.const	$push96=, 0
	i32.const	$push95=, 1103515245
	i32.mul 	$push26=, $0, $pop95
	i32.const	$push94=, 12345
	i32.add 	$push93=, $pop26, $pop94
	tee_local	$push92=, $0=, $pop93
	i32.const	$push91=, 16
	i32.shr_u	$push27=, $pop92, $pop91
	i32.store8	$drop=, sS+10($pop96), $pop27
	i32.const	$push90=, 0
	i32.const	$push89=, 1103515245
	i32.mul 	$push28=, $0, $pop89
	i32.const	$push88=, 12345
	i32.add 	$push87=, $pop28, $pop88
	tee_local	$push86=, $0=, $pop87
	i32.const	$push85=, 16
	i32.shr_u	$push29=, $pop86, $pop85
	i32.store8	$drop=, sS+11($pop90), $pop29
	i32.const	$push84=, 0
	i32.const	$push83=, 1103515245
	i32.mul 	$push30=, $0, $pop83
	i32.const	$push82=, 12345
	i32.add 	$push81=, $pop30, $pop82
	tee_local	$push80=, $0=, $pop81
	i32.const	$push79=, 16
	i32.shr_u	$push31=, $pop80, $pop79
	i32.store8	$drop=, sS+12($pop84), $pop31
	i32.const	$push78=, 0
	i32.const	$push77=, 1103515245
	i32.mul 	$push32=, $0, $pop77
	i32.const	$push76=, 12345
	i32.add 	$push75=, $pop32, $pop76
	tee_local	$push74=, $0=, $pop75
	i32.const	$push73=, 16
	i32.shr_u	$push33=, $pop74, $pop73
	i32.store8	$drop=, sS+13($pop78), $pop33
	i32.const	$push72=, 0
	i32.const	$push71=, 1103515245
	i32.mul 	$push34=, $0, $pop71
	i32.const	$push70=, 12345
	i32.add 	$push69=, $pop34, $pop70
	tee_local	$push68=, $0=, $pop69
	i32.const	$push67=, 16
	i32.shr_u	$push35=, $pop68, $pop67
	i32.store8	$drop=, sS+14($pop72), $pop35
	i32.const	$push66=, 0
	i32.const	$push65=, 1103515245
	i32.mul 	$push36=, $0, $pop65
	i32.const	$push64=, 12345
	i32.add 	$push63=, $pop36, $pop64
	tee_local	$push62=, $0=, $pop63
	i32.const	$push61=, 16
	i32.shr_u	$push37=, $pop62, $pop61
	i32.store8	$drop=, sS+15($pop66), $pop37
	i32.const	$push60=, 0
	i32.load16_u	$1=, sS($pop60)
	i32.const	$push59=, 0
	i32.const	$push58=, 0
	i32.const	$push38=, -341751747
	i32.mul 	$push39=, $0, $pop38
	i32.const	$push40=, 229283573
	i32.add 	$push57=, $pop39, $pop40
	tee_local	$push56=, $0=, $pop57
	i32.const	$push55=, 1103515245
	i32.mul 	$push41=, $pop56, $pop55
	i32.const	$push54=, 12345
	i32.add 	$push42=, $pop41, $pop54
	i32.store	$push0=, myrnd.s($pop58), $pop42
	i32.const	$push53=, 16
	i32.shr_u	$push44=, $pop0, $pop53
	i32.const	$push52=, 16
	i32.shr_u	$push43=, $0, $pop52
	i32.add 	$push45=, $pop44, $pop43
	i32.const	$push46=, 1
	i32.and 	$push47=, $pop45, $pop46
	i32.const	$push48=, 65534
	i32.and 	$push49=, $1, $pop48
	i32.or  	$push50=, $pop47, $pop49
	i32.store16	$drop=, sS($pop59), $pop50
	block
	i32.const	$push51=, 1
	i32.eqz 	$push154=, $pop51
	br_if   	0, $pop154      # 0: down to label11
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
	i32.store	$drop=, 0($0):p2align=1, $pop0
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop4
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
                                        # fallthrough-return: $pop6
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
                                        # fallthrough-return: $pop3
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
	i32.add 	$push3=, $pop8, $0
	i32.const	$push4=, 1
	i32.and 	$push7=, $pop3, $pop4
	tee_local	$push6=, $0=, $pop7
	i32.const	$push1=, 65534
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push5=, $pop6, $pop2
	i32.store16	$drop=, sT($pop0), $pop5
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end119:
	.size	fn3T, .Lfunc_end119-fn3T

	.section	.text.testT,"ax",@progbits
	.hidden	testT
	.globl	testT
	.type	testT,@function
testT:                                  # @testT
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push79=, 0
	i32.const	$push78=, 0
	i32.load	$push2=, myrnd.s($pop78)
	i32.const	$push77=, 1103515245
	i32.mul 	$push3=, $pop2, $pop77
	i32.const	$push76=, 12345
	i32.add 	$push75=, $pop3, $pop76
	tee_local	$push74=, $1=, $pop75
	i32.const	$push73=, 16
	i32.shr_u	$push4=, $pop74, $pop73
	i32.store8	$drop=, sT($pop79), $pop4
	i32.const	$push72=, 0
	i32.const	$push71=, 1103515245
	i32.mul 	$push5=, $1, $pop71
	i32.const	$push70=, 12345
	i32.add 	$push69=, $pop5, $pop70
	tee_local	$push68=, $1=, $pop69
	i32.const	$push67=, 16
	i32.shr_u	$push6=, $pop68, $pop67
	i32.store8	$drop=, sT+1($pop72), $pop6
	i32.const	$push66=, 0
	i32.const	$push65=, 1103515245
	i32.mul 	$push7=, $1, $pop65
	i32.const	$push64=, 12345
	i32.add 	$push63=, $pop7, $pop64
	tee_local	$push62=, $1=, $pop63
	i32.const	$push61=, 16
	i32.shr_u	$push8=, $pop62, $pop61
	i32.store8	$drop=, sT+2($pop66), $pop8
	i32.const	$push60=, 0
	i32.const	$push59=, 1103515245
	i32.mul 	$push9=, $1, $pop59
	i32.const	$push58=, 12345
	i32.add 	$push57=, $pop9, $pop58
	tee_local	$push56=, $1=, $pop57
	i32.const	$push55=, 16
	i32.shr_u	$push10=, $pop56, $pop55
	i32.store8	$drop=, sT+3($pop60), $pop10
	i32.const	$push54=, 0
	i32.const	$push53=, 1103515245
	i32.mul 	$push13=, $1, $pop53
	i32.const	$push52=, 12345
	i32.add 	$push51=, $pop13, $pop52
	tee_local	$push50=, $1=, $pop51
	i32.const	$push49=, 16
	i32.shr_u	$push48=, $pop50, $pop49
	tee_local	$push47=, $2=, $pop48
	i32.const	$push46=, 1
	i32.and 	$push14=, $pop47, $pop46
	i32.const	$push45=, 0
	i32.load16_u	$push11=, sT($pop45)
	i32.const	$push44=, 65534
	i32.and 	$push12=, $pop11, $pop44
	i32.or  	$push15=, $pop14, $pop12
	i32.store16	$drop=, sT($pop54), $pop15
	block
	i32.const	$push43=, 0
	i32.const	$push42=, 1103515245
	i32.mul 	$push16=, $1, $pop42
	i32.const	$push41=, 12345
	i32.add 	$push1=, $pop16, $pop41
	i32.store	$push40=, myrnd.s($pop43), $pop1
	tee_local	$push39=, $0=, $pop40
	i32.const	$push38=, 16
	i32.shr_u	$push37=, $pop39, $pop38
	tee_local	$push36=, $1=, $pop37
	i32.add 	$push17=, $pop36, $2
	i32.const	$push35=, 0
	i32.load	$push34=, sT($pop35)
	tee_local	$push33=, $2=, $pop34
	i32.add 	$push18=, $1, $pop33
	i32.xor 	$push19=, $pop17, $pop18
	i32.const	$push32=, 1
	i32.and 	$push20=, $pop19, $pop32
	br_if   	0, $pop20       # 0: down to label12
# BB#1:                                 # %if.end94
	i32.const	$push90=, 0
	i32.const	$push89=, 0
	i32.const	$push21=, -2139243339
	i32.mul 	$push22=, $0, $pop21
	i32.const	$push23=, -1492899873
	i32.add 	$push88=, $pop22, $pop23
	tee_local	$push87=, $1=, $pop88
	i32.const	$push86=, 1103515245
	i32.mul 	$push24=, $pop87, $pop86
	i32.const	$push85=, 12345
	i32.add 	$push25=, $pop24, $pop85
	i32.store	$push0=, myrnd.s($pop89), $pop25
	i32.const	$push84=, 16
	i32.shr_u	$push27=, $pop0, $pop84
	i32.const	$push83=, 16
	i32.shr_u	$push26=, $1, $pop83
	i32.add 	$push28=, $pop27, $pop26
	i32.const	$push82=, 1
	i32.and 	$push29=, $pop28, $pop82
	i32.const	$push81=, 65534
	i32.and 	$push30=, $2, $pop81
	i32.or  	$push31=, $pop29, $pop30
	i32.store16	$drop=, sT($pop90), $pop31
	i32.const	$push80=, 1
	i32.eqz 	$push91=, $pop80
	br_if   	0, $pop91       # 0: down to label12
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
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	$drop=, 0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	$drop=, 0($pop2), $pop4
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop6
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
                                        # fallthrough-return: $pop8
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
                                        # fallthrough-return: $pop5
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
	i32.const	$push3=, 6
	i32.shr_u	$push4=, $pop14, $pop3
	i32.add 	$push13=, $pop4, $0
	tee_local	$push12=, $0=, $pop13
	i32.const	$push11=, 6
	i32.shl 	$push5=, $pop12, $pop11
	i32.const	$push6=, 64
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push1=, 65471
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push8=, $pop7, $pop2
	i32.store16	$drop=, sU($pop0), $pop8
	i32.const	$push9=, 1
	i32.and 	$push10=, $0, $pop9
                                        # fallthrough-return: $pop10
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
	i32.store8	$drop=, sU($pop5), $pop10
	i32.const	$push214=, 0
	i32.const	$push213=, 1103515245
	i32.mul 	$push11=, $2, $pop213
	i32.const	$push212=, 12345
	i32.add 	$push211=, $pop11, $pop212
	tee_local	$push210=, $2=, $pop211
	i32.const	$push209=, 16
	i32.shr_u	$push12=, $pop210, $pop209
	i32.store8	$drop=, sU+1($pop214), $pop12
	i32.const	$push208=, 0
	i32.const	$push207=, 1103515245
	i32.mul 	$push13=, $2, $pop207
	i32.const	$push206=, 12345
	i32.add 	$push205=, $pop13, $pop206
	tee_local	$push204=, $2=, $pop205
	i32.const	$push203=, 16
	i32.shr_u	$push14=, $pop204, $pop203
	i32.store8	$drop=, sU+2($pop208), $pop14
	i32.const	$push202=, 0
	i32.const	$push201=, 1103515245
	i32.mul 	$push15=, $2, $pop201
	i32.const	$push200=, 12345
	i32.add 	$push199=, $pop15, $pop200
	tee_local	$push198=, $2=, $pop199
	i32.const	$push197=, 16
	i32.shr_u	$push16=, $pop198, $pop197
	i32.store8	$drop=, sU+3($pop202), $pop16
	i32.const	$push196=, 0
	i32.const	$push195=, 1103515245
	i32.mul 	$push17=, $2, $pop195
	i32.const	$push194=, 12345
	i32.add 	$push193=, $pop17, $pop194
	tee_local	$push192=, $2=, $pop193
	i32.const	$push191=, 16
	i32.shr_u	$push18=, $pop192, $pop191
	i32.store8	$drop=, sU+4($pop196), $pop18
	i32.const	$push190=, 0
	i32.const	$push189=, 1103515245
	i32.mul 	$push19=, $2, $pop189
	i32.const	$push188=, 12345
	i32.add 	$push187=, $pop19, $pop188
	tee_local	$push186=, $2=, $pop187
	i32.const	$push185=, 16
	i32.shr_u	$push20=, $pop186, $pop185
	i32.store8	$drop=, sU+5($pop190), $pop20
	i32.const	$push184=, 0
	i32.const	$push183=, 1103515245
	i32.mul 	$push21=, $2, $pop183
	i32.const	$push182=, 12345
	i32.add 	$push181=, $pop21, $pop182
	tee_local	$push180=, $2=, $pop181
	i32.const	$push179=, 16
	i32.shr_u	$push22=, $pop180, $pop179
	i32.store8	$drop=, sU+6($pop184), $pop22
	i32.const	$push178=, 0
	i32.const	$push177=, 1103515245
	i32.mul 	$push23=, $2, $pop177
	i32.const	$push176=, 12345
	i32.add 	$push175=, $pop23, $pop176
	tee_local	$push174=, $2=, $pop175
	i32.const	$push173=, 16
	i32.shr_u	$push24=, $pop174, $pop173
	i32.store8	$drop=, sU+7($pop178), $pop24
	i32.const	$push172=, 0
	i32.const	$push171=, 1103515245
	i32.mul 	$push25=, $2, $pop171
	i32.const	$push170=, 12345
	i32.add 	$push169=, $pop25, $pop170
	tee_local	$push168=, $2=, $pop169
	i32.const	$push167=, 16
	i32.shr_u	$push26=, $pop168, $pop167
	i32.store8	$drop=, sU+8($pop172), $pop26
	i32.const	$push166=, 0
	i32.const	$push165=, 1103515245
	i32.mul 	$push27=, $2, $pop165
	i32.const	$push164=, 12345
	i32.add 	$push163=, $pop27, $pop164
	tee_local	$push162=, $2=, $pop163
	i32.const	$push161=, 16
	i32.shr_u	$push28=, $pop162, $pop161
	i32.store8	$drop=, sU+9($pop166), $pop28
	i32.const	$push160=, 0
	i32.const	$push159=, 1103515245
	i32.mul 	$push29=, $2, $pop159
	i32.const	$push158=, 12345
	i32.add 	$push157=, $pop29, $pop158
	tee_local	$push156=, $2=, $pop157
	i32.const	$push155=, 16
	i32.shr_u	$push30=, $pop156, $pop155
	i32.store8	$drop=, sU+10($pop160), $pop30
	i32.const	$push154=, 0
	i32.const	$push153=, 1103515245
	i32.mul 	$push31=, $2, $pop153
	i32.const	$push152=, 12345
	i32.add 	$push151=, $pop31, $pop152
	tee_local	$push150=, $2=, $pop151
	i32.const	$push149=, 16
	i32.shr_u	$push32=, $pop150, $pop149
	i32.store8	$drop=, sU+11($pop154), $pop32
	i32.const	$push148=, 0
	i32.const	$push147=, 1103515245
	i32.mul 	$push33=, $2, $pop147
	i32.const	$push146=, 12345
	i32.add 	$push145=, $pop33, $pop146
	tee_local	$push144=, $2=, $pop145
	i32.const	$push143=, 16
	i32.shr_u	$push34=, $pop144, $pop143
	i32.store8	$drop=, sU+12($pop148), $pop34
	i32.const	$push142=, 0
	i32.const	$push141=, 1103515245
	i32.mul 	$push35=, $2, $pop141
	i32.const	$push140=, 12345
	i32.add 	$push139=, $pop35, $pop140
	tee_local	$push138=, $2=, $pop139
	i32.const	$push137=, 16
	i32.shr_u	$push36=, $pop138, $pop137
	i32.store8	$drop=, sU+13($pop142), $pop36
	i32.const	$push136=, 0
	i32.const	$push135=, 1103515245
	i32.mul 	$push37=, $2, $pop135
	i32.const	$push134=, 12345
	i32.add 	$push133=, $pop37, $pop134
	tee_local	$push132=, $2=, $pop133
	i32.const	$push131=, 16
	i32.shr_u	$push38=, $pop132, $pop131
	i32.store8	$drop=, sU+14($pop136), $pop38
	i32.const	$push130=, 0
	i32.const	$push129=, 1103515245
	i32.mul 	$push39=, $2, $pop129
	i32.const	$push128=, 12345
	i32.add 	$push127=, $pop39, $pop128
	tee_local	$push126=, $2=, $pop127
	i32.const	$push125=, 16
	i32.shr_u	$push40=, $pop126, $pop125
	i32.store8	$drop=, sU+15($pop130), $pop40
	i32.const	$push124=, 0
	i32.load16_u	$3=, sU($pop124)
	i32.const	$push123=, 0
	i32.const	$push122=, 1103515245
	i32.mul 	$push41=, $2, $pop122
	i32.const	$push121=, 12345
	i32.add 	$push120=, $pop41, $pop121
	tee_local	$push119=, $2=, $pop120
	i32.const	$push118=, 1103515245
	i32.mul 	$push42=, $pop119, $pop118
	i32.const	$push117=, 12345
	i32.add 	$push3=, $pop42, $pop117
	i32.store	$0=, myrnd.s($pop123), $pop3
	block
	i32.const	$push116=, 0
	i32.const	$push115=, 16
	i32.shr_u	$push114=, $2, $pop115
	tee_local	$push113=, $1=, $pop114
	i32.const	$push44=, 2047
	i32.and 	$push112=, $pop113, $pop44
	tee_local	$push111=, $4=, $pop112
	i32.const	$push45=, 6
	i32.shl 	$push46=, $pop111, $pop45
	i32.const	$push47=, 64
	i32.and 	$push48=, $pop46, $pop47
	i32.const	$push43=, -65
	i32.and 	$push110=, $3, $pop43
	tee_local	$push109=, $2=, $pop110
	i32.or  	$push49=, $pop48, $pop109
	i32.store16	$push0=, sU($pop116), $pop49
	i32.const	$push50=, 65472
	i32.and 	$push51=, $pop0, $pop50
	i32.const	$push108=, 6
	i32.shr_u	$push107=, $pop51, $pop108
	tee_local	$push106=, $3=, $pop107
	i32.xor 	$push52=, $pop106, $4
	i32.const	$push105=, 1
	i32.and 	$push53=, $pop52, $pop105
	br_if   	0, $pop53       # 0: down to label13
# BB#1:                                 # %lor.lhs.false41
	i32.const	$push222=, 16
	i32.shr_u	$push221=, $0, $pop222
	tee_local	$push220=, $4=, $pop221
	i32.add 	$push55=, $3, $pop220
	i32.add 	$push54=, $4, $1
	i32.xor 	$push56=, $pop55, $pop54
	i32.const	$push219=, 1
	i32.and 	$push57=, $pop56, $pop219
	br_if   	0, $pop57       # 0: down to label13
# BB#2:                                 # %if.end
	i32.const	$push62=, 0
	i32.const	$push58=, 1103515245
	i32.mul 	$push59=, $0, $pop58
	i32.const	$push60=, 12345
	i32.add 	$push236=, $pop59, $pop60
	tee_local	$push235=, $3=, $pop236
	i32.const	$push234=, 1103515245
	i32.mul 	$push61=, $pop235, $pop234
	i32.const	$push233=, 12345
	i32.add 	$push4=, $pop61, $pop233
	i32.store	$0=, myrnd.s($pop62), $pop4
	i32.const	$push232=, 0
	i32.const	$push231=, 16
	i32.shr_u	$push230=, $3, $pop231
	tee_local	$push229=, $4=, $pop230
	i32.const	$push63=, 2047
	i32.and 	$push228=, $pop229, $pop63
	tee_local	$push227=, $3=, $pop228
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
	tee_local	$push224=, $1=, $pop225
	i32.xor 	$push71=, $pop224, $3
	i32.const	$push223=, 1
	i32.and 	$push72=, $pop71, $pop223
	br_if   	0, $pop72       # 0: down to label13
# BB#3:                                 # %lor.lhs.false85
	i32.const	$push242=, 16
	i32.shr_u	$push241=, $0, $pop242
	tee_local	$push240=, $3=, $pop241
	i32.add 	$push77=, $pop240, $4
	i32.const	$push239=, 1
	i32.and 	$push78=, $pop77, $pop239
	i32.const	$push75=, 15
	i32.rem_u	$push79=, $pop78, $pop75
	i32.add 	$push73=, $1, $3
	i32.const	$push238=, 1
	i32.and 	$push74=, $pop73, $pop238
	i32.const	$push237=, 15
	i32.rem_u	$push76=, $pop74, $pop237
	i32.ne  	$push80=, $pop79, $pop76
	br_if   	0, $pop80       # 0: down to label13
# BB#4:                                 # %lor.lhs.false130
	i32.const	$push86=, 0
	i32.const	$push81=, 1103515245
	i32.mul 	$push82=, $0, $pop81
	i32.const	$push83=, 12345
	i32.add 	$push254=, $pop82, $pop83
	tee_local	$push253=, $0=, $pop254
	i32.const	$push88=, 10
	i32.shr_u	$push89=, $pop253, $pop88
	i32.const	$push90=, 64
	i32.and 	$push91=, $pop89, $pop90
	i32.or  	$push92=, $pop91, $2
	i32.const	$push93=, 65472
	i32.and 	$push94=, $pop92, $pop93
	i32.const	$push95=, 6
	i32.shr_u	$push96=, $pop94, $pop95
	i32.const	$push252=, 0
	i32.const	$push251=, 1103515245
	i32.mul 	$push84=, $0, $pop251
	i32.const	$push250=, 12345
	i32.add 	$push85=, $pop84, $pop250
	i32.store	$push2=, myrnd.s($pop252), $pop85
	i32.const	$push87=, 16
	i32.shr_u	$push249=, $pop2, $pop87
	tee_local	$push248=, $3=, $pop249
	i32.add 	$push247=, $pop96, $pop248
	tee_local	$push246=, $4=, $pop247
	i32.const	$push245=, 6
	i32.shl 	$push97=, $pop246, $pop245
	i32.const	$push244=, 64
	i32.and 	$push98=, $pop97, $pop244
	i32.or  	$push99=, $pop98, $2
	i32.store16	$drop=, sU($pop86), $pop99
	i32.const	$push243=, 16
	i32.shr_u	$push100=, $0, $pop243
	i32.add 	$push101=, $3, $pop100
	i32.xor 	$push102=, $pop101, $4
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
	i32.store	$drop=, 0($0):p2align=1, $pop0
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop6
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
                                        # fallthrough-return: $pop6
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
                                        # fallthrough-return: $pop3
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
	i32.const	$push3=, 8
	i32.shr_u	$push4=, $pop14, $pop3
	i32.add 	$push13=, $pop4, $0
	tee_local	$push12=, $0=, $pop13
	i32.const	$push11=, 8
	i32.shl 	$push5=, $pop12, $pop11
	i32.const	$push6=, 256
	i32.and 	$push7=, $pop5, $pop6
	i32.const	$push1=, 65279
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push8=, $pop7, $pop2
	i32.store16	$drop=, sV($pop0), $pop8
	i32.const	$push9=, 1
	i32.and 	$push10=, $0, $pop9
                                        # fallthrough-return: $pop10
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
	i32.const	$push113=, 0
	i32.const	$push112=, 0
	i32.load	$push4=, myrnd.s($pop112)
	i32.const	$push111=, 1103515245
	i32.mul 	$push5=, $pop4, $pop111
	i32.const	$push110=, 12345
	i32.add 	$push109=, $pop5, $pop110
	tee_local	$push108=, $4=, $pop109
	i32.const	$push107=, 16
	i32.shr_u	$push6=, $pop108, $pop107
	i32.store8	$drop=, sV($pop113), $pop6
	i32.const	$push106=, 0
	i32.const	$push105=, 1103515245
	i32.mul 	$push7=, $4, $pop105
	i32.const	$push104=, 12345
	i32.add 	$push103=, $pop7, $pop104
	tee_local	$push102=, $4=, $pop103
	i32.const	$push101=, 16
	i32.shr_u	$push8=, $pop102, $pop101
	i32.store8	$drop=, sV+1($pop106), $pop8
	i32.const	$push100=, 0
	i32.const	$push99=, 1103515245
	i32.mul 	$push9=, $4, $pop99
	i32.const	$push98=, 12345
	i32.add 	$push97=, $pop9, $pop98
	tee_local	$push96=, $4=, $pop97
	i32.const	$push95=, 16
	i32.shr_u	$push10=, $pop96, $pop95
	i32.store8	$drop=, sV+2($pop100), $pop10
	i32.const	$push94=, 0
	i32.const	$push93=, 1103515245
	i32.mul 	$push11=, $4, $pop93
	i32.const	$push92=, 12345
	i32.add 	$push91=, $pop11, $pop92
	tee_local	$push90=, $4=, $pop91
	i32.const	$push89=, 16
	i32.shr_u	$push12=, $pop90, $pop89
	i32.store8	$drop=, sV+3($pop94), $pop12
	i32.const	$push88=, 0
	i32.const	$push87=, 1103515245
	i32.mul 	$push15=, $4, $pop87
	i32.const	$push86=, 12345
	i32.add 	$push85=, $pop15, $pop86
	tee_local	$push84=, $4=, $pop85
	i32.const	$push83=, 8
	i32.shr_u	$push16=, $pop84, $pop83
	i32.const	$push82=, 256
	i32.and 	$push17=, $pop16, $pop82
	i32.const	$push81=, 0
	i32.load16_u	$push13=, sV($pop81)
	i32.const	$push80=, 65279
	i32.and 	$push14=, $pop13, $pop80
	i32.or  	$push18=, $pop17, $pop14
	i32.store16	$drop=, sV($pop88), $pop18
	block
	i32.const	$push79=, 0
	i32.const	$push78=, 1103515245
	i32.mul 	$push19=, $4, $pop78
	i32.const	$push77=, 12345
	i32.add 	$push2=, $pop19, $pop77
	i32.store	$push76=, myrnd.s($pop79), $pop2
	tee_local	$push75=, $0=, $pop76
	i32.const	$push74=, 16
	i32.shr_u	$push73=, $pop75, $pop74
	tee_local	$push72=, $1=, $pop73
	i32.const	$push71=, 16
	i32.shr_u	$push20=, $4, $pop71
	i32.add 	$push21=, $pop72, $pop20
	i32.const	$push70=, 0
	i32.load	$push69=, sV($pop70)
	tee_local	$push68=, $4=, $pop69
	i32.const	$push67=, 8
	i32.shr_u	$push22=, $pop68, $pop67
	i32.add 	$push23=, $pop22, $1
	i32.xor 	$push24=, $pop21, $pop23
	i32.const	$push66=, 1
	i32.and 	$push25=, $pop24, $pop66
	br_if   	0, $pop25       # 0: down to label14
# BB#1:                                 # %if.end
	i32.const	$push132=, 0
	i32.const	$push131=, 1103515245
	i32.mul 	$push26=, $0, $pop131
	i32.const	$push130=, 12345
	i32.add 	$push129=, $pop26, $pop130
	tee_local	$push128=, $0=, $pop129
	i32.const	$push127=, 1103515245
	i32.mul 	$push27=, $pop128, $pop127
	i32.const	$push126=, 12345
	i32.add 	$push3=, $pop27, $pop126
	i32.store	$1=, myrnd.s($pop132), $pop3
	i32.const	$push125=, 0
	i32.const	$push124=, 16
	i32.shr_u	$push123=, $0, $pop124
	tee_local	$push122=, $2=, $pop123
	i32.const	$push30=, 2047
	i32.and 	$push121=, $pop122, $pop30
	tee_local	$push120=, $0=, $pop121
	i32.const	$push119=, 8
	i32.shl 	$push31=, $pop120, $pop119
	i32.const	$push118=, 256
	i32.and 	$push32=, $pop31, $pop118
	i32.const	$push28=, -257
	i32.and 	$push29=, $4, $pop28
	i32.or  	$push33=, $pop32, $pop29
	i32.store16	$push0=, sV($pop125), $pop33
	i32.const	$push34=, 65280
	i32.and 	$push35=, $pop0, $pop34
	i32.const	$push117=, 8
	i32.shr_u	$push116=, $pop35, $pop117
	tee_local	$push115=, $3=, $pop116
	i32.xor 	$push36=, $pop115, $0
	i32.const	$push114=, 1
	i32.and 	$push37=, $pop36, $pop114
	br_if   	0, $pop37       # 0: down to label14
# BB#2:                                 # %lor.lhs.false89
	i32.const	$push138=, 16
	i32.shr_u	$push137=, $1, $pop138
	tee_local	$push136=, $0=, $pop137
	i32.add 	$push42=, $pop136, $2
	i32.const	$push135=, 1
	i32.and 	$push43=, $pop42, $pop135
	i32.const	$push40=, 15
	i32.rem_u	$push44=, $pop43, $pop40
	i32.add 	$push38=, $3, $0
	i32.const	$push134=, 1
	i32.and 	$push39=, $pop38, $pop134
	i32.const	$push133=, 15
	i32.rem_u	$push41=, $pop39, $pop133
	i32.ne  	$push45=, $pop44, $pop41
	br_if   	0, $pop45       # 0: down to label14
# BB#3:                                 # %lor.lhs.false136
	i32.const	$push51=, 0
	i32.const	$push46=, 1103515245
	i32.mul 	$push47=, $1, $pop46
	i32.const	$push48=, 12345
	i32.add 	$push155=, $pop47, $pop48
	tee_local	$push154=, $1=, $pop155
	i32.const	$push53=, 8
	i32.shr_u	$push54=, $pop154, $pop53
	i32.const	$push55=, 256
	i32.and 	$push56=, $pop54, $pop55
	i32.const	$push153=, 65279
	i32.and 	$push152=, $4, $pop153
	tee_local	$push151=, $4=, $pop152
	i32.or  	$push57=, $pop56, $pop151
	i32.const	$push150=, 8
	i32.shr_u	$push58=, $pop57, $pop150
	i32.const	$push149=, 0
	i32.const	$push148=, 1103515245
	i32.mul 	$push49=, $1, $pop148
	i32.const	$push147=, 12345
	i32.add 	$push50=, $pop49, $pop147
	i32.store	$push1=, myrnd.s($pop149), $pop50
	i32.const	$push52=, 16
	i32.shr_u	$push146=, $pop1, $pop52
	tee_local	$push145=, $0=, $pop146
	i32.add 	$push144=, $pop58, $pop145
	tee_local	$push143=, $2=, $pop144
	i32.const	$push142=, 8
	i32.shl 	$push59=, $pop143, $pop142
	i32.const	$push141=, 256
	i32.and 	$push60=, $pop59, $pop141
	i32.or  	$push61=, $pop60, $4
	i32.store16	$drop=, sV($pop51), $pop61
	i32.const	$push140=, 16
	i32.shr_u	$push62=, $1, $pop140
	i32.add 	$push63=, $0, $pop62
	i32.xor 	$push64=, $pop63, $2
	i32.const	$push139=, 1
	i32.and 	$push65=, $pop64, $pop139
	br_if   	0, $pop65       # 0: down to label14
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
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	$drop=, 0($0), $pop0
	i32.const	$push1=, 24
	i32.add 	$push2=, $0, $pop1
	i32.const	$push15=, 24
	i32.add 	$push3=, $1, $pop15
	i64.load	$push4=, 0($pop3)
	i64.store	$drop=, 0($pop2), $pop4
	i32.const	$push5=, 16
	i32.add 	$push6=, $0, $pop5
	i32.const	$push14=, 16
	i32.add 	$push7=, $1, $pop14
	i64.load	$push8=, 0($pop7)
	i64.store	$drop=, 0($pop6), $pop8
	i32.const	$push9=, 8
	i32.add 	$push10=, $0, $pop9
	i32.const	$push13=, 8
	i32.add 	$push11=, $1, $pop13
	i64.load	$push12=, 0($pop11)
	i64.store	$drop=, 0($pop10), $pop12
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop4
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
                                        # fallthrough-return: $pop6
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
                                        # fallthrough-return: $pop3
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
	i32.add 	$push3=, $pop8, $0
	i32.const	$push4=, 4095
	i32.and 	$push7=, $pop3, $pop4
	tee_local	$push6=, $0=, $pop7
	i32.const	$push1=, -4096
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push5=, $pop6, $pop2
	i32.store	$drop=, sW+16($pop0), $pop5
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end137:
	.size	fn3W, .Lfunc_end137-fn3W

	.section	.text.testW,"ax",@progbits
	.hidden	testW
	.globl	testW
	.type	testW,@function
testW:                                  # @testW
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.load	$2=, myrnd.s($pop1)
	i32.const	$1=, -32
.LBB138_1:                              # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label15:
	i32.const	$push41=, 1103515245
	i32.mul 	$push2=, $2, $pop41
	i32.const	$push40=, 12345
	i32.add 	$push39=, $pop2, $pop40
	tee_local	$push38=, $2=, $pop39
	i32.const	$push37=, 16
	i32.shr_u	$push3=, $pop38, $pop37
	i32.store8	$drop=, sW+32($1), $pop3
	i32.const	$push36=, 1
	i32.add 	$push35=, $1, $pop36
	tee_local	$push34=, $1=, $pop35
	br_if   	0, $pop34       # 0: up to label15
# BB#2:                                 # %for.end
	end_loop                        # label16:
	i32.const	$push9=, 0
	i32.const	$push4=, 1103515245
	i32.mul 	$push5=, $2, $pop4
	i32.const	$push6=, 12345
	i32.add 	$push73=, $pop5, $pop6
	tee_local	$push72=, $1=, $pop73
	i32.const	$push71=, 1103515245
	i32.mul 	$push7=, $pop72, $pop71
	i32.const	$push70=, 12345
	i32.add 	$push8=, $pop7, $pop70
	i32.store	$2=, myrnd.s($pop9), $pop8
	i32.const	$push69=, 0
	i64.const	$push10=, 4612055454334320640
	i64.store	$drop=, sW+8($pop69), $pop10
	i32.const	$push68=, 0
	i64.const	$push11=, 0
	i64.store	$drop=, sW($pop68), $pop11
	i32.const	$push67=, 0
	i32.const	$push14=, 16
	i32.shr_u	$push15=, $1, $pop14
	i32.const	$push16=, 2047
	i32.and 	$push17=, $pop15, $pop16
	i32.const	$push66=, 0
	i32.load	$push12=, sW+16($pop66)
	i32.const	$push13=, -4096
	i32.and 	$push65=, $pop12, $pop13
	tee_local	$push64=, $1=, $pop65
	i32.or  	$push18=, $pop17, $pop64
	i32.store	$drop=, sW+16($pop67), $pop18
	i32.const	$push63=, 0
	i32.const	$push62=, 1103515245
	i32.mul 	$push19=, $2, $pop62
	i32.const	$push61=, 12345
	i32.add 	$push60=, $pop19, $pop61
	tee_local	$push59=, $2=, $pop60
	i32.const	$push58=, 1103515245
	i32.mul 	$push20=, $pop59, $pop58
	i32.const	$push57=, 12345
	i32.add 	$push21=, $pop20, $pop57
	i32.store	$0=, myrnd.s($pop63), $pop21
	i32.const	$push56=, 0
	i32.const	$push55=, 16
	i32.shr_u	$push22=, $2, $pop55
	i32.const	$push54=, 2047
	i32.and 	$push23=, $pop22, $pop54
	i32.or  	$push24=, $pop23, $1
	i32.store	$drop=, sW+16($pop56), $pop24
	i32.const	$push53=, 0
	i32.const	$push52=, 0
	i32.const	$push51=, 1103515245
	i32.mul 	$push25=, $0, $pop51
	i32.const	$push50=, 12345
	i32.add 	$push49=, $pop25, $pop50
	tee_local	$push48=, $2=, $pop49
	i32.const	$push47=, 1103515245
	i32.mul 	$push26=, $pop48, $pop47
	i32.const	$push46=, 12345
	i32.add 	$push27=, $pop26, $pop46
	i32.store	$push0=, myrnd.s($pop52), $pop27
	i32.const	$push45=, 16
	i32.shr_u	$push30=, $pop0, $pop45
	i32.const	$push44=, 2047
	i32.and 	$push31=, $pop30, $pop44
	i32.const	$push43=, 16
	i32.shr_u	$push28=, $2, $pop43
	i32.const	$push42=, 2047
	i32.and 	$push29=, $pop28, $pop42
	i32.add 	$push32=, $pop31, $pop29
	i32.or  	$push33=, $pop32, $1
	i32.store	$drop=, sW+16($pop53), $pop33
                                        # fallthrough-return
	.endfunc
.Lfunc_end138:
	.size	testW, .Lfunc_end138-testW

	.section	.text.retmeX,"ax",@progbits
	.hidden	retmeX
	.globl	retmeX
	.type	retmeX,@function
retmeX:                                 # @retmeX
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	$drop=, 0($0), $pop0
	i32.const	$push1=, 24
	i32.add 	$push2=, $0, $pop1
	i32.const	$push15=, 24
	i32.add 	$push3=, $1, $pop15
	i64.load	$push4=, 0($pop3)
	i64.store	$drop=, 0($pop2), $pop4
	i32.const	$push5=, 16
	i32.add 	$push6=, $0, $pop5
	i32.const	$push14=, 16
	i32.add 	$push7=, $1, $pop14
	i64.load	$push8=, 0($pop7)
	i64.store	$drop=, 0($pop6), $pop8
	i32.const	$push9=, 8
	i32.add 	$push10=, $0, $pop9
	i32.const	$push13=, 8
	i32.add 	$push11=, $1, $pop13
	i64.load	$push12=, 0($pop11)
	i64.store	$drop=, 0($pop10), $pop12
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop4
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
                                        # fallthrough-return: $pop6
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
                                        # fallthrough-return: $pop3
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
	i32.add 	$push3=, $pop8, $0
	i32.const	$push4=, 4095
	i32.and 	$push7=, $pop3, $pop4
	tee_local	$push6=, $0=, $pop7
	i32.const	$push1=, -4096
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push5=, $pop6, $pop2
	i32.store	$drop=, sX($pop0), $pop5
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end143:
	.size	fn3X, .Lfunc_end143-fn3X

	.section	.text.testX,"ax",@progbits
	.hidden	testX
	.globl	testX
	.type	testX,@function
testX:                                  # @testX
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.load	$2=, myrnd.s($pop1)
	i32.const	$1=, -32
.LBB144_1:                              # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label17:
	i32.const	$push41=, 1103515245
	i32.mul 	$push2=, $2, $pop41
	i32.const	$push40=, 12345
	i32.add 	$push39=, $pop2, $pop40
	tee_local	$push38=, $2=, $pop39
	i32.const	$push37=, 16
	i32.shr_u	$push3=, $pop38, $pop37
	i32.store8	$drop=, sX+32($1), $pop3
	i32.const	$push36=, 1
	i32.add 	$push35=, $1, $pop36
	tee_local	$push34=, $1=, $pop35
	br_if   	0, $pop34       # 0: up to label17
# BB#2:                                 # %for.end
	end_loop                        # label18:
	i32.const	$push9=, 0
	i32.const	$push4=, 1103515245
	i32.mul 	$push5=, $2, $pop4
	i32.const	$push6=, 12345
	i32.add 	$push73=, $pop5, $pop6
	tee_local	$push72=, $1=, $pop73
	i32.const	$push71=, 1103515245
	i32.mul 	$push7=, $pop72, $pop71
	i32.const	$push70=, 12345
	i32.add 	$push8=, $pop7, $pop70
	i32.store	$2=, myrnd.s($pop9), $pop8
	i32.const	$push69=, 0
	i64.const	$push10=, 4612055454334320640
	i64.store	$drop=, sX+24($pop69), $pop10
	i32.const	$push68=, 0
	i64.const	$push11=, 0
	i64.store	$drop=, sX+16($pop68), $pop11
	i32.const	$push67=, 0
	i32.const	$push14=, 16
	i32.shr_u	$push15=, $1, $pop14
	i32.const	$push16=, 2047
	i32.and 	$push17=, $pop15, $pop16
	i32.const	$push66=, 0
	i32.load	$push12=, sX($pop66)
	i32.const	$push13=, -4096
	i32.and 	$push65=, $pop12, $pop13
	tee_local	$push64=, $1=, $pop65
	i32.or  	$push18=, $pop17, $pop64
	i32.store	$drop=, sX($pop67), $pop18
	i32.const	$push63=, 0
	i32.const	$push62=, 1103515245
	i32.mul 	$push19=, $2, $pop62
	i32.const	$push61=, 12345
	i32.add 	$push60=, $pop19, $pop61
	tee_local	$push59=, $2=, $pop60
	i32.const	$push58=, 1103515245
	i32.mul 	$push20=, $pop59, $pop58
	i32.const	$push57=, 12345
	i32.add 	$push21=, $pop20, $pop57
	i32.store	$0=, myrnd.s($pop63), $pop21
	i32.const	$push56=, 0
	i32.const	$push55=, 16
	i32.shr_u	$push22=, $2, $pop55
	i32.const	$push54=, 2047
	i32.and 	$push23=, $pop22, $pop54
	i32.or  	$push24=, $pop23, $1
	i32.store	$drop=, sX($pop56), $pop24
	i32.const	$push53=, 0
	i32.const	$push52=, 0
	i32.const	$push51=, 1103515245
	i32.mul 	$push25=, $0, $pop51
	i32.const	$push50=, 12345
	i32.add 	$push49=, $pop25, $pop50
	tee_local	$push48=, $2=, $pop49
	i32.const	$push47=, 1103515245
	i32.mul 	$push26=, $pop48, $pop47
	i32.const	$push46=, 12345
	i32.add 	$push27=, $pop26, $pop46
	i32.store	$push0=, myrnd.s($pop52), $pop27
	i32.const	$push45=, 16
	i32.shr_u	$push30=, $pop0, $pop45
	i32.const	$push44=, 2047
	i32.and 	$push31=, $pop30, $pop44
	i32.const	$push43=, 16
	i32.shr_u	$push28=, $2, $pop43
	i32.const	$push42=, 2047
	i32.and 	$push29=, $pop28, $pop42
	i32.add 	$push32=, $pop31, $pop29
	i32.or  	$push33=, $pop32, $1
	i32.store	$drop=, sX($pop53), $pop33
                                        # fallthrough-return
	.endfunc
.Lfunc_end144:
	.size	testX, .Lfunc_end144-testX

	.section	.text.retmeY,"ax",@progbits
	.hidden	retmeY
	.globl	retmeY
	.type	retmeY,@function
retmeY:                                 # @retmeY
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	$drop=, 0($0), $pop0
	i32.const	$push1=, 24
	i32.add 	$push2=, $0, $pop1
	i32.const	$push15=, 24
	i32.add 	$push3=, $1, $pop15
	i64.load	$push4=, 0($pop3)
	i64.store	$drop=, 0($pop2), $pop4
	i32.const	$push5=, 16
	i32.add 	$push6=, $0, $pop5
	i32.const	$push14=, 16
	i32.add 	$push7=, $1, $pop14
	i64.load	$push8=, 0($pop7)
	i64.store	$drop=, 0($pop6), $pop8
	i32.const	$push9=, 8
	i32.add 	$push10=, $0, $pop9
	i32.const	$push13=, 8
	i32.add 	$push11=, $1, $pop13
	i64.load	$push12=, 0($pop11)
	i64.store	$drop=, 0($pop10), $pop12
                                        # fallthrough-return
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
                                        # fallthrough-return: $pop4
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
                                        # fallthrough-return: $pop6
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
                                        # fallthrough-return: $pop3
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
	i32.add 	$push3=, $pop8, $0
	i32.const	$push4=, 4095
	i32.and 	$push7=, $pop3, $pop4
	tee_local	$push6=, $0=, $pop7
	i32.const	$push1=, -4096
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push5=, $pop6, $pop2
	i32.store	$drop=, sY($pop0), $pop5
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end149:
	.size	fn3Y, .Lfunc_end149-fn3Y

	.section	.text.testY,"ax",@progbits
	.hidden	testY
	.globl	testY
	.type	testY,@function
testY:                                  # @testY
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.load	$2=, myrnd.s($pop1)
	i32.const	$1=, -32
.LBB150_1:                              # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label19:
	i32.const	$push41=, 1103515245
	i32.mul 	$push2=, $2, $pop41
	i32.const	$push40=, 12345
	i32.add 	$push39=, $pop2, $pop40
	tee_local	$push38=, $2=, $pop39
	i32.const	$push37=, 16
	i32.shr_u	$push3=, $pop38, $pop37
	i32.store8	$drop=, sY+32($1), $pop3
	i32.const	$push36=, 1
	i32.add 	$push35=, $1, $pop36
	tee_local	$push34=, $1=, $pop35
	br_if   	0, $pop34       # 0: up to label19
# BB#2:                                 # %for.end
	end_loop                        # label20:
	i32.const	$push9=, 0
	i32.const	$push4=, 1103515245
	i32.mul 	$push5=, $2, $pop4
	i32.const	$push6=, 12345
	i32.add 	$push73=, $pop5, $pop6
	tee_local	$push72=, $1=, $pop73
	i32.const	$push71=, 1103515245
	i32.mul 	$push7=, $pop72, $pop71
	i32.const	$push70=, 12345
	i32.add 	$push8=, $pop7, $pop70
	i32.store	$2=, myrnd.s($pop9), $pop8
	i32.const	$push69=, 0
	i64.const	$push10=, 4612055454334320640
	i64.store	$drop=, sY+24($pop69), $pop10
	i32.const	$push68=, 0
	i64.const	$push11=, 0
	i64.store	$drop=, sY+16($pop68), $pop11
	i32.const	$push67=, 0
	i32.const	$push14=, 16
	i32.shr_u	$push15=, $1, $pop14
	i32.const	$push16=, 2047
	i32.and 	$push17=, $pop15, $pop16
	i32.const	$push66=, 0
	i32.load	$push12=, sY($pop66)
	i32.const	$push13=, -4096
	i32.and 	$push65=, $pop12, $pop13
	tee_local	$push64=, $1=, $pop65
	i32.or  	$push18=, $pop17, $pop64
	i32.store	$drop=, sY($pop67), $pop18
	i32.const	$push63=, 0
	i32.const	$push62=, 1103515245
	i32.mul 	$push19=, $2, $pop62
	i32.const	$push61=, 12345
	i32.add 	$push60=, $pop19, $pop61
	tee_local	$push59=, $2=, $pop60
	i32.const	$push58=, 1103515245
	i32.mul 	$push20=, $pop59, $pop58
	i32.const	$push57=, 12345
	i32.add 	$push21=, $pop20, $pop57
	i32.store	$0=, myrnd.s($pop63), $pop21
	i32.const	$push56=, 0
	i32.const	$push55=, 16
	i32.shr_u	$push22=, $2, $pop55
	i32.const	$push54=, 2047
	i32.and 	$push23=, $pop22, $pop54
	i32.or  	$push24=, $pop23, $1
	i32.store	$drop=, sY($pop56), $pop24
	i32.const	$push53=, 0
	i32.const	$push52=, 0
	i32.const	$push51=, 1103515245
	i32.mul 	$push25=, $0, $pop51
	i32.const	$push50=, 12345
	i32.add 	$push49=, $pop25, $pop50
	tee_local	$push48=, $2=, $pop49
	i32.const	$push47=, 1103515245
	i32.mul 	$push26=, $pop48, $pop47
	i32.const	$push46=, 12345
	i32.add 	$push27=, $pop26, $pop46
	i32.store	$push0=, myrnd.s($pop52), $pop27
	i32.const	$push45=, 16
	i32.shr_u	$push30=, $pop0, $pop45
	i32.const	$push44=, 2047
	i32.and 	$push31=, $pop30, $pop44
	i32.const	$push43=, 16
	i32.shr_u	$push28=, $2, $pop43
	i32.const	$push42=, 2047
	i32.and 	$push29=, $pop28, $pop42
	i32.add 	$push32=, $pop31, $pop29
	i32.or  	$push33=, $pop32, $1
	i32.store	$drop=, sY($pop53), $pop33
                                        # fallthrough-return
	.endfunc
.Lfunc_end150:
	.size	testY, .Lfunc_end150-testY

	.section	.text.retmeZ,"ax",@progbits
	.hidden	retmeZ
	.globl	retmeZ
	.type	retmeZ,@function
retmeZ:                                 # @retmeZ
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	$drop=, 0($0), $pop0
	i32.const	$push1=, 24
	i32.add 	$push2=, $0, $pop1
	i32.const	$push15=, 24
	i32.add 	$push3=, $1, $pop15
	i64.load	$push4=, 0($pop3)
	i64.store	$drop=, 0($pop2), $pop4
	i32.const	$push5=, 16
	i32.add 	$push6=, $0, $pop5
	i32.const	$push14=, 16
	i32.add 	$push7=, $1, $pop14
	i64.load	$push8=, 0($pop7)
	i64.store	$drop=, 0($pop6), $pop8
	i32.const	$push9=, 8
	i32.add 	$push10=, $0, $pop9
	i32.const	$push13=, 8
	i32.add 	$push11=, $1, $pop13
	i64.load	$push12=, 0($pop11)
	i64.store	$drop=, 0($pop10), $pop12
                                        # fallthrough-return
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
	i32.const	$push2=, 0
	i32.load	$push3=, sZ+16($pop2)
	i32.const	$push0=, 20
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push4=, $pop3, $pop1
	i32.const	$push6=, 20
	i32.shr_u	$push5=, $pop4, $pop6
                                        # fallthrough-return: $pop5
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
                                        # fallthrough-return: $pop8
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
                                        # fallthrough-return: $pop3
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
	i32.const	$push3=, 0
	i32.const	$push8=, 0
	i32.load	$push4=, sZ+16($pop8)
	i32.const	$push1=, 20
	i32.shl 	$push2=, $0, $pop1
	i32.add 	$push5=, $pop4, $pop2
	i32.store	$push0=, sZ+16($pop3), $pop5
	i32.const	$push7=, 20
	i32.shr_u	$push6=, $pop0, $pop7
                                        # fallthrough-return: $pop6
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
	i32.load	$4=, myrnd.s($pop5)
	i32.const	$3=, -32
.LBB156_1:                              # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label21:
	i32.const	$push53=, 1103515245
	i32.mul 	$push6=, $4, $pop53
	i32.const	$push52=, 12345
	i32.add 	$push51=, $pop6, $pop52
	tee_local	$push50=, $4=, $pop51
	i32.const	$push49=, 16
	i32.shr_u	$push7=, $pop50, $pop49
	i32.store8	$drop=, sZ+32($3), $pop7
	i32.const	$push48=, 1
	i32.add 	$push47=, $3, $pop48
	tee_local	$push46=, $3=, $pop47
	br_if   	0, $pop46       # 0: up to label21
# BB#2:                                 # %for.end
	end_loop                        # label22:
	i32.const	$push79=, 0
	i64.const	$push8=, 4612055454334320640
	i64.store	$drop=, sZ+8($pop79), $pop8
	i32.const	$push78=, 0
	i64.const	$push9=, 0
	i64.store	$drop=, sZ($pop78), $pop9
	block
	i32.const	$push77=, 0
	i32.const	$push76=, 1103515245
	i32.mul 	$push10=, $4, $pop76
	i32.const	$push75=, 12345
	i32.add 	$push74=, $pop10, $pop75
	tee_local	$push73=, $3=, $pop74
	i32.const	$push72=, 1103515245
	i32.mul 	$push11=, $pop73, $pop72
	i32.const	$push71=, 12345
	i32.add 	$push3=, $pop11, $pop71
	i32.store	$push70=, myrnd.s($pop77), $pop3
	tee_local	$push69=, $0=, $pop70
	i32.const	$push68=, 16
	i32.shr_u	$push16=, $pop69, $pop68
	i32.const	$push67=, 2047
	i32.and 	$push66=, $pop16, $pop67
	tee_local	$push65=, $4=, $pop66
	i32.const	$push64=, 16
	i32.shr_u	$push13=, $3, $pop64
	i32.const	$push63=, 2047
	i32.and 	$push62=, $pop13, $pop63
	tee_local	$push61=, $3=, $pop62
	i32.add 	$push17=, $pop65, $pop61
	i32.const	$push60=, 20
	i32.shl 	$push18=, $4, $pop60
	i32.const	$push59=, 0
	i32.const	$push58=, 20
	i32.shl 	$push14=, $3, $pop58
	i32.const	$push57=, 0
	i32.load	$push2=, sZ+16($pop57)
	i32.const	$push12=, 1048575
	i32.and 	$push56=, $pop2, $pop12
	tee_local	$push55=, $3=, $pop56
	i32.or  	$push15=, $pop14, $pop55
	i32.store	$push0=, sZ+16($pop59), $pop15
	i32.add 	$push19=, $pop18, $pop0
	i32.const	$push54=, 20
	i32.shr_u	$push20=, $pop19, $pop54
	i32.ne  	$push21=, $pop17, $pop20
	br_if   	0, $pop21       # 0: down to label23
# BB#3:                                 # %if.end80
	i32.const	$push103=, 0
	i32.const	$push102=, 0
	i32.const	$push101=, 1103515245
	i32.mul 	$push22=, $0, $pop101
	i32.const	$push100=, 12345
	i32.add 	$push99=, $pop22, $pop100
	tee_local	$push98=, $4=, $pop99
	i32.const	$push23=, -1029531031
	i32.mul 	$push24=, $pop98, $pop23
	i32.const	$push25=, -740551042
	i32.add 	$push97=, $pop24, $pop25
	tee_local	$push96=, $0=, $pop97
	i32.const	$push95=, 1103515245
	i32.mul 	$push26=, $pop96, $pop95
	i32.const	$push94=, 12345
	i32.add 	$push27=, $pop26, $pop94
	i32.store	$push1=, myrnd.s($pop102), $pop27
	i32.const	$push93=, 16
	i32.shr_u	$push31=, $pop1, $pop93
	i32.const	$push92=, 2047
	i32.and 	$push91=, $pop31, $pop92
	tee_local	$push90=, $2=, $pop91
	i32.const	$push89=, 20
	i32.shl 	$push32=, $pop90, $pop89
	i32.const	$push88=, 16
	i32.shr_u	$push28=, $0, $pop88
	i32.const	$push87=, 2047
	i32.and 	$push86=, $pop28, $pop87
	tee_local	$push85=, $0=, $pop86
	i32.const	$push84=, 20
	i32.shl 	$push29=, $pop85, $pop84
	i32.or  	$push30=, $pop29, $3
	i32.add 	$push4=, $pop32, $pop30
	i32.store	$push83=, sZ+16($pop103), $pop4
	tee_local	$push82=, $1=, $pop83
	i32.const	$push33=, 4
	i32.shl 	$push34=, $4, $pop33
	i32.const	$push35=, 2146435072
	i32.and 	$push36=, $pop34, $pop35
	i32.or  	$push37=, $pop36, $3
	i32.xor 	$push81=, $pop82, $pop37
	tee_local	$push80=, $3=, $pop81
	i32.const	$push38=, 1040384
	i32.and 	$push39=, $pop80, $pop38
	br_if   	0, $pop39       # 0: down to label23
# BB#4:                                 # %lor.lhs.false98
	i32.add 	$push43=, $2, $0
	i32.const	$push41=, 20
	i32.shr_u	$push42=, $1, $pop41
	i32.ne  	$push44=, $pop43, $pop42
	br_if   	0, $pop44       # 0: down to label23
# BB#5:                                 # %lor.lhs.false98
	i32.const	$push45=, 8191
	i32.and 	$push40=, $3, $pop45
	br_if   	0, $pop40       # 0: down to label23
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
	.functype	abort, void
	.functype	exit, void, i32
