	.text
	.file	"20040709-1.c"
	.section	.text.myrnd,"ax",@progbits
	.hidden	myrnd                   # -- Begin function myrnd
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
	i32.store	myrnd.s($pop0), $pop9
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $0, $pop5
	i32.const	$push7=, 2047
	i32.and 	$push8=, $pop6, $pop7
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end0:
	.size	myrnd, .Lfunc_end0-myrnd
                                        # -- End function
	.section	.text.retmeA,"ax",@progbits
	.hidden	retmeA                  # -- Begin function retmeA
	.globl	retmeA
	.type	retmeA,@function
retmeA:                                 # @retmeA
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($1)
	i32.store	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	retmeA, .Lfunc_end1-retmeA
                                        # -- End function
	.section	.text.fn1A,"ax",@progbits
	.hidden	fn1A                    # -- Begin function fn1A
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
                                        # -- End function
	.section	.text.fn2A,"ax",@progbits
	.hidden	fn2A                    # -- Begin function fn2A
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
                                        # -- End function
	.section	.text.retitA,"ax",@progbits
	.hidden	retitA                  # -- Begin function retitA
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
                                        # -- End function
	.section	.text.fn3A,"ax",@progbits
	.hidden	fn3A                    # -- Begin function fn3A
	.globl	fn3A
	.type	fn3A,@function
fn3A:                                   # @fn3A
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push8=, 0
	i32.load	$push3=, sA($pop8)
	i32.const	$push0=, 17
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push7=, $pop3, $pop1
	tee_local	$push6=, $0=, $pop7
	i32.store	sA($pop2), $pop6
	i32.const	$push5=, 17
	i32.shr_u	$push4=, $0, $pop5
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end5:
	.size	fn3A, .Lfunc_end5-fn3A
                                        # -- End function
	.section	.text.testA,"ax",@progbits
	.hidden	testA                   # -- Begin function testA
	.globl	testA
	.type	testA,@function
testA:                                  # @testA
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push87=, 0
	i32.const	$push86=, 0
	i32.load	$push0=, myrnd.s($pop86)
	i32.const	$push85=, 1103515245
	i32.mul 	$push1=, $pop0, $pop85
	i32.const	$push84=, 12345
	i32.add 	$push83=, $pop1, $pop84
	tee_local	$push82=, $1=, $pop83
	i32.const	$push81=, 16
	i32.shr_u	$push2=, $pop82, $pop81
	i32.store8	sA($pop87), $pop2
	i32.const	$push80=, 0
	i32.const	$push79=, 1103515245
	i32.mul 	$push3=, $1, $pop79
	i32.const	$push78=, 12345
	i32.add 	$push77=, $pop3, $pop78
	tee_local	$push76=, $1=, $pop77
	i32.const	$push75=, 16
	i32.shr_u	$push4=, $pop76, $pop75
	i32.store8	sA+1($pop80), $pop4
	i32.const	$push74=, 0
	i32.const	$push73=, 1103515245
	i32.mul 	$push5=, $1, $pop73
	i32.const	$push72=, 12345
	i32.add 	$push71=, $pop5, $pop72
	tee_local	$push70=, $1=, $pop71
	i32.const	$push69=, 16
	i32.shr_u	$push6=, $pop70, $pop69
	i32.store8	sA+2($pop74), $pop6
	i32.const	$push68=, 0
	i32.const	$push67=, 1103515245
	i32.mul 	$push7=, $1, $pop67
	i32.const	$push66=, 12345
	i32.add 	$push65=, $pop7, $pop66
	tee_local	$push64=, $1=, $pop65
	i32.const	$push63=, 16
	i32.shr_u	$push8=, $pop64, $pop63
	i32.store8	sA+3($pop68), $pop8
	i32.const	$push62=, 0
	i32.const	$push61=, 1103515245
	i32.mul 	$push9=, $1, $pop61
	i32.const	$push60=, 12345
	i32.add 	$push59=, $pop9, $pop60
	tee_local	$push58=, $3=, $pop59
	i32.const	$push57=, 1103515245
	i32.mul 	$push10=, $pop58, $pop57
	i32.const	$push56=, 12345
	i32.add 	$push55=, $pop10, $pop56
	tee_local	$push54=, $1=, $pop55
	i32.store	myrnd.s($pop62), $pop54
	i32.const	$push53=, 0
	i32.const	$push52=, 16
	i32.shr_u	$push11=, $3, $pop52
	i32.const	$push51=, 2047
	i32.and 	$push50=, $pop11, $pop51
	tee_local	$push49=, $3=, $pop50
	i32.const	$push48=, 17
	i32.shl 	$push12=, $pop49, $pop48
	i32.const	$push47=, 0
	i32.load	$push46=, sA($pop47)
	tee_local	$push45=, $0=, $pop46
	i32.const	$push44=, 131071
	i32.and 	$push43=, $pop45, $pop44
	tee_local	$push42=, $2=, $pop43
	i32.or  	$push41=, $pop12, $pop42
	tee_local	$push40=, $4=, $pop41
	i32.store	sA($pop53), $pop40
	block   	
	i32.const	$push39=, 16
	i32.shr_u	$push13=, $1, $pop39
	i32.const	$push38=, 2047
	i32.and 	$push37=, $pop13, $pop38
	tee_local	$push36=, $5=, $pop37
	i32.add 	$push14=, $pop36, $3
	i32.const	$push35=, 17
	i32.shl 	$push15=, $5, $pop35
	i32.add 	$push16=, $pop15, $4
	i32.const	$push34=, 17
	i32.shr_u	$push17=, $pop16, $pop34
	i32.ne  	$push18=, $pop14, $pop17
	br_if   	0, $pop18       # 0: down to label0
# BB#1:                                 # %if.end87
	i32.const	$push108=, 0
	i32.const	$push19=, -2139243339
	i32.mul 	$push20=, $1, $pop19
	i32.const	$push21=, -1492899873
	i32.add 	$push107=, $pop20, $pop21
	tee_local	$push106=, $1=, $pop107
	i32.const	$push105=, 1103515245
	i32.mul 	$push22=, $pop106, $pop105
	i32.const	$push104=, 12345
	i32.add 	$push103=, $pop22, $pop104
	tee_local	$push102=, $3=, $pop103
	i32.store	myrnd.s($pop108), $pop102
	i32.const	$push101=, 0
	i32.const	$push100=, 16
	i32.shr_u	$push26=, $3, $pop100
	i32.const	$push99=, 2047
	i32.and 	$push98=, $pop26, $pop99
	tee_local	$push97=, $3=, $pop98
	i32.const	$push96=, 17
	i32.shl 	$push27=, $pop97, $pop96
	i32.const	$push95=, 16
	i32.shr_u	$push23=, $1, $pop95
	i32.const	$push94=, 2047
	i32.and 	$push93=, $pop23, $pop94
	tee_local	$push92=, $4=, $pop93
	i32.const	$push91=, 17
	i32.shl 	$push24=, $pop92, $pop91
	i32.or  	$push25=, $pop24, $2
	i32.add 	$push90=, $pop27, $pop25
	tee_local	$push89=, $1=, $pop90
	i32.store	sA($pop101), $pop89
	i32.xor 	$push28=, $1, $0
	i32.const	$push88=, 131071
	i32.and 	$push29=, $pop28, $pop88
	br_if   	0, $pop29       # 0: down to label0
# BB#2:                                 # %lor.lhs.false125
	i32.add 	$push32=, $3, $4
	i32.const	$push30=, 17
	i32.shr_u	$push31=, $1, $pop30
	i32.ne  	$push33=, $pop32, $pop31
	br_if   	0, $pop33       # 0: down to label0
# BB#3:                                 # %if.end131
	return
.LBB6_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end6:
	.size	testA, .Lfunc_end6-testA
                                        # -- End function
	.section	.text.retmeB,"ax",@progbits
	.hidden	retmeB                  # -- Begin function retmeB
	.globl	retmeB
	.type	retmeB,@function
retmeB:                                 # @retmeB
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1):p2align=2
	i64.store	0($0):p2align=2, $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end7:
	.size	retmeB, .Lfunc_end7-retmeB
                                        # -- End function
	.section	.text.fn1B,"ax",@progbits
	.hidden	fn1B                    # -- Begin function fn1B
	.globl	fn1B
	.type	fn1B,@function
fn1B:                                   # @fn1B
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 17
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 0
	i32.load	$push3=, sB($pop2)
	i32.add 	$push4=, $pop1, $pop3
	i32.const	$push6=, 17
	i32.shr_u	$push5=, $pop4, $pop6
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end8:
	.size	fn1B, .Lfunc_end8-fn1B
                                        # -- End function
	.section	.text.fn2B,"ax",@progbits
	.hidden	fn2B                    # -- Begin function fn2B
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
                                        # -- End function
	.section	.text.retitB,"ax",@progbits
	.hidden	retitB                  # -- Begin function retitB
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
                                        # -- End function
	.section	.text.fn3B,"ax",@progbits
	.hidden	fn3B                    # -- Begin function fn3B
	.globl	fn3B
	.type	fn3B,@function
fn3B:                                   # @fn3B
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push8=, 0
	i32.load	$push3=, sB($pop8)
	i32.const	$push0=, 17
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push7=, $pop3, $pop1
	tee_local	$push6=, $0=, $pop7
	i32.store	sB($pop2), $pop6
	i32.const	$push5=, 17
	i32.shr_u	$push4=, $0, $pop5
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end11:
	.size	fn3B, .Lfunc_end11-fn3B
                                        # -- End function
	.section	.text.testB,"ax",@progbits
	.hidden	testB                   # -- Begin function testB
	.globl	testB
	.type	testB,@function
testB:                                  # @testB
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push119=, 0
	i32.const	$push118=, 0
	i32.load	$push0=, myrnd.s($pop118)
	i32.const	$push117=, 1103515245
	i32.mul 	$push1=, $pop0, $pop117
	i32.const	$push116=, 12345
	i32.add 	$push115=, $pop1, $pop116
	tee_local	$push114=, $1=, $pop115
	i32.const	$push113=, 16
	i32.shr_u	$push2=, $pop114, $pop113
	i32.store8	sB($pop119), $pop2
	i32.const	$push112=, 0
	i32.const	$push111=, 1103515245
	i32.mul 	$push3=, $1, $pop111
	i32.const	$push110=, 12345
	i32.add 	$push109=, $pop3, $pop110
	tee_local	$push108=, $1=, $pop109
	i32.const	$push107=, 16
	i32.shr_u	$push4=, $pop108, $pop107
	i32.store8	sB+1($pop112), $pop4
	i32.const	$push106=, 0
	i32.const	$push105=, 1103515245
	i32.mul 	$push5=, $1, $pop105
	i32.const	$push104=, 12345
	i32.add 	$push103=, $pop5, $pop104
	tee_local	$push102=, $1=, $pop103
	i32.const	$push101=, 16
	i32.shr_u	$push6=, $pop102, $pop101
	i32.store8	sB+2($pop106), $pop6
	i32.const	$push100=, 0
	i32.const	$push99=, 1103515245
	i32.mul 	$push7=, $1, $pop99
	i32.const	$push98=, 12345
	i32.add 	$push97=, $pop7, $pop98
	tee_local	$push96=, $1=, $pop97
	i32.const	$push95=, 16
	i32.shr_u	$push8=, $pop96, $pop95
	i32.store8	sB+3($pop100), $pop8
	i32.const	$push94=, 0
	i32.const	$push93=, 1103515245
	i32.mul 	$push9=, $1, $pop93
	i32.const	$push92=, 12345
	i32.add 	$push91=, $pop9, $pop92
	tee_local	$push90=, $1=, $pop91
	i32.const	$push89=, 16
	i32.shr_u	$push10=, $pop90, $pop89
	i32.store8	sB+4($pop94), $pop10
	i32.const	$push88=, 0
	i32.const	$push87=, 1103515245
	i32.mul 	$push11=, $1, $pop87
	i32.const	$push86=, 12345
	i32.add 	$push85=, $pop11, $pop86
	tee_local	$push84=, $1=, $pop85
	i32.const	$push83=, 16
	i32.shr_u	$push12=, $pop84, $pop83
	i32.store8	sB+5($pop88), $pop12
	i32.const	$push82=, 0
	i32.const	$push81=, 1103515245
	i32.mul 	$push13=, $1, $pop81
	i32.const	$push80=, 12345
	i32.add 	$push79=, $pop13, $pop80
	tee_local	$push78=, $1=, $pop79
	i32.const	$push77=, 16
	i32.shr_u	$push14=, $pop78, $pop77
	i32.store8	sB+6($pop82), $pop14
	i32.const	$push76=, 0
	i32.const	$push75=, 1103515245
	i32.mul 	$push15=, $1, $pop75
	i32.const	$push74=, 12345
	i32.add 	$push73=, $pop15, $pop74
	tee_local	$push72=, $1=, $pop73
	i32.const	$push71=, 16
	i32.shr_u	$push16=, $pop72, $pop71
	i32.store8	sB+7($pop76), $pop16
	i32.const	$push70=, 0
	i32.const	$push69=, 1103515245
	i32.mul 	$push17=, $1, $pop69
	i32.const	$push68=, 12345
	i32.add 	$push67=, $pop17, $pop68
	tee_local	$push66=, $3=, $pop67
	i32.const	$push65=, 1103515245
	i32.mul 	$push18=, $pop66, $pop65
	i32.const	$push64=, 12345
	i32.add 	$push63=, $pop18, $pop64
	tee_local	$push62=, $1=, $pop63
	i32.store	myrnd.s($pop70), $pop62
	i32.const	$push61=, 0
	i32.const	$push60=, 16
	i32.shr_u	$push19=, $3, $pop60
	i32.const	$push59=, 2047
	i32.and 	$push58=, $pop19, $pop59
	tee_local	$push57=, $3=, $pop58
	i32.const	$push56=, 17
	i32.shl 	$push20=, $pop57, $pop56
	i32.const	$push55=, 0
	i32.load	$push54=, sB($pop55)
	tee_local	$push53=, $0=, $pop54
	i32.const	$push52=, 131071
	i32.and 	$push51=, $pop53, $pop52
	tee_local	$push50=, $2=, $pop51
	i32.or  	$push49=, $pop20, $pop50
	tee_local	$push48=, $4=, $pop49
	i32.store	sB($pop61), $pop48
	block   	
	i32.const	$push47=, 16
	i32.shr_u	$push21=, $1, $pop47
	i32.const	$push46=, 2047
	i32.and 	$push45=, $pop21, $pop46
	tee_local	$push44=, $5=, $pop45
	i32.add 	$push22=, $pop44, $3
	i32.const	$push43=, 17
	i32.shl 	$push23=, $5, $pop43
	i32.add 	$push24=, $pop23, $4
	i32.const	$push42=, 17
	i32.shr_u	$push25=, $pop24, $pop42
	i32.ne  	$push26=, $pop22, $pop25
	br_if   	0, $pop26       # 0: down to label1
# BB#1:                                 # %if.end76
	i32.const	$push140=, 0
	i32.const	$push27=, -2139243339
	i32.mul 	$push28=, $1, $pop27
	i32.const	$push29=, -1492899873
	i32.add 	$push139=, $pop28, $pop29
	tee_local	$push138=, $1=, $pop139
	i32.const	$push137=, 1103515245
	i32.mul 	$push30=, $pop138, $pop137
	i32.const	$push136=, 12345
	i32.add 	$push135=, $pop30, $pop136
	tee_local	$push134=, $3=, $pop135
	i32.store	myrnd.s($pop140), $pop134
	i32.const	$push133=, 0
	i32.const	$push132=, 16
	i32.shr_u	$push34=, $3, $pop132
	i32.const	$push131=, 2047
	i32.and 	$push130=, $pop34, $pop131
	tee_local	$push129=, $3=, $pop130
	i32.const	$push128=, 17
	i32.shl 	$push35=, $pop129, $pop128
	i32.const	$push127=, 16
	i32.shr_u	$push31=, $1, $pop127
	i32.const	$push126=, 2047
	i32.and 	$push125=, $pop31, $pop126
	tee_local	$push124=, $4=, $pop125
	i32.const	$push123=, 17
	i32.shl 	$push32=, $pop124, $pop123
	i32.or  	$push33=, $pop32, $2
	i32.add 	$push122=, $pop35, $pop33
	tee_local	$push121=, $1=, $pop122
	i32.store	sB($pop133), $pop121
	i32.xor 	$push36=, $1, $0
	i32.const	$push120=, 131071
	i32.and 	$push37=, $pop36, $pop120
	br_if   	0, $pop37       # 0: down to label1
# BB#2:                                 # %lor.lhs.false109
	i32.add 	$push40=, $3, $4
	i32.const	$push38=, 17
	i32.shr_u	$push39=, $1, $pop38
	i32.ne  	$push41=, $pop40, $pop39
	br_if   	0, $pop41       # 0: down to label1
# BB#3:                                 # %if.end115
	return
.LBB12_4:                               # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end12:
	.size	testB, .Lfunc_end12-testB
                                        # -- End function
	.section	.text.retmeC,"ax",@progbits
	.hidden	retmeC                  # -- Begin function retmeC
	.globl	retmeC
	.type	retmeC,@function
retmeC:                                 # @retmeC
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1):p2align=2
	i64.store	0($0):p2align=2, $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end13:
	.size	retmeC, .Lfunc_end13-retmeC
                                        # -- End function
	.section	.text.fn1C,"ax",@progbits
	.hidden	fn1C                    # -- Begin function fn1C
	.globl	fn1C
	.type	fn1C,@function
fn1C:                                   # @fn1C
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 17
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 0
	i32.load	$push3=, sC+4($pop2)
	i32.add 	$push4=, $pop1, $pop3
	i32.const	$push6=, 17
	i32.shr_u	$push5=, $pop4, $pop6
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end14:
	.size	fn1C, .Lfunc_end14-fn1C
                                        # -- End function
	.section	.text.fn2C,"ax",@progbits
	.hidden	fn2C                    # -- Begin function fn2C
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
                                        # -- End function
	.section	.text.retitC,"ax",@progbits
	.hidden	retitC                  # -- Begin function retitC
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
                                        # -- End function
	.section	.text.fn3C,"ax",@progbits
	.hidden	fn3C                    # -- Begin function fn3C
	.globl	fn3C
	.type	fn3C,@function
fn3C:                                   # @fn3C
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push8=, 0
	i32.load	$push3=, sC+4($pop8)
	i32.const	$push0=, 17
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push7=, $pop3, $pop1
	tee_local	$push6=, $0=, $pop7
	i32.store	sC+4($pop2), $pop6
	i32.const	$push5=, 17
	i32.shr_u	$push4=, $0, $pop5
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end17:
	.size	fn3C, .Lfunc_end17-fn3C
                                        # -- End function
	.section	.text.testC,"ax",@progbits
	.hidden	testC                   # -- Begin function testC
	.globl	testC
	.type	testC,@function
testC:                                  # @testC
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push119=, 0
	i32.const	$push118=, 0
	i32.load	$push0=, myrnd.s($pop118)
	i32.const	$push117=, 1103515245
	i32.mul 	$push1=, $pop0, $pop117
	i32.const	$push116=, 12345
	i32.add 	$push115=, $pop1, $pop116
	tee_local	$push114=, $0=, $pop115
	i32.const	$push113=, 1103515245
	i32.mul 	$push2=, $pop114, $pop113
	i32.const	$push112=, 12345
	i32.add 	$push111=, $pop2, $pop112
	tee_local	$push110=, $1=, $pop111
	i32.const	$push109=, 1103515245
	i32.mul 	$push3=, $pop110, $pop109
	i32.const	$push108=, 12345
	i32.add 	$push107=, $pop3, $pop108
	tee_local	$push106=, $2=, $pop107
	i32.const	$push105=, 1103515245
	i32.mul 	$push4=, $pop106, $pop105
	i32.const	$push104=, 12345
	i32.add 	$push103=, $pop4, $pop104
	tee_local	$push102=, $3=, $pop103
	i32.const	$push101=, 1103515245
	i32.mul 	$push5=, $pop102, $pop101
	i32.const	$push100=, 12345
	i32.add 	$push99=, $pop5, $pop100
	tee_local	$push98=, $4=, $pop99
	i32.const	$push97=, 16
	i32.shr_u	$push6=, $pop98, $pop97
	i32.store8	sC+4($pop119), $pop6
	i32.const	$push96=, 0
	i32.const	$push95=, 1103515245
	i32.mul 	$push7=, $4, $pop95
	i32.const	$push94=, 12345
	i32.add 	$push93=, $pop7, $pop94
	tee_local	$push92=, $4=, $pop93
	i32.const	$push91=, 16
	i32.shr_u	$push8=, $pop92, $pop91
	i32.store8	sC+5($pop96), $pop8
	i32.const	$push90=, 0
	i32.const	$push89=, 1103515245
	i32.mul 	$push9=, $4, $pop89
	i32.const	$push88=, 12345
	i32.add 	$push87=, $pop9, $pop88
	tee_local	$push86=, $4=, $pop87
	i32.const	$push85=, 16
	i32.shr_u	$push10=, $pop86, $pop85
	i32.store8	sC+6($pop90), $pop10
	i32.const	$push84=, 0
	i32.const	$push83=, 1103515245
	i32.mul 	$push11=, $4, $pop83
	i32.const	$push82=, 12345
	i32.add 	$push81=, $pop11, $pop82
	tee_local	$push80=, $4=, $pop81
	i32.const	$push79=, 16
	i32.shr_u	$push12=, $pop80, $pop79
	i32.store8	sC+7($pop84), $pop12
	i32.const	$push78=, 0
	i32.const	$push77=, 16
	i32.shr_u	$push13=, $0, $pop77
	i32.store8	sC($pop78), $pop13
	i32.const	$push76=, 0
	i32.const	$push75=, 16
	i32.shr_u	$push14=, $1, $pop75
	i32.store8	sC+1($pop76), $pop14
	i32.const	$push74=, 0
	i32.const	$push73=, 16
	i32.shr_u	$push15=, $2, $pop73
	i32.store8	sC+2($pop74), $pop15
	i32.const	$push72=, 0
	i32.const	$push71=, 16
	i32.shr_u	$push16=, $3, $pop71
	i32.store8	sC+3($pop72), $pop16
	i32.const	$push70=, 0
	i32.const	$push69=, 1103515245
	i32.mul 	$push17=, $4, $pop69
	i32.const	$push68=, 12345
	i32.add 	$push67=, $pop17, $pop68
	tee_local	$push66=, $1=, $pop67
	i32.const	$push65=, 1103515245
	i32.mul 	$push18=, $pop66, $pop65
	i32.const	$push64=, 12345
	i32.add 	$push63=, $pop18, $pop64
	tee_local	$push62=, $0=, $pop63
	i32.store	myrnd.s($pop70), $pop62
	i32.const	$push61=, 0
	i32.const	$push60=, 16
	i32.shr_u	$push19=, $1, $pop60
	i32.const	$push59=, 2047
	i32.and 	$push58=, $pop19, $pop59
	tee_local	$push57=, $1=, $pop58
	i32.const	$push56=, 17
	i32.shl 	$push20=, $pop57, $pop56
	i32.const	$push55=, 0
	i32.load	$push54=, sC+4($pop55)
	tee_local	$push53=, $2=, $pop54
	i32.const	$push52=, 131071
	i32.and 	$push51=, $pop53, $pop52
	tee_local	$push50=, $3=, $pop51
	i32.or  	$push49=, $pop20, $pop50
	tee_local	$push48=, $4=, $pop49
	i32.store	sC+4($pop61), $pop48
	block   	
	i32.const	$push47=, 16
	i32.shr_u	$push21=, $0, $pop47
	i32.const	$push46=, 2047
	i32.and 	$push45=, $pop21, $pop46
	tee_local	$push44=, $5=, $pop45
	i32.add 	$push22=, $pop44, $1
	i32.const	$push43=, 17
	i32.shl 	$push23=, $5, $pop43
	i32.add 	$push24=, $pop23, $4
	i32.const	$push42=, 17
	i32.shr_u	$push25=, $pop24, $pop42
	i32.ne  	$push26=, $pop22, $pop25
	br_if   	0, $pop26       # 0: down to label2
# BB#1:                                 # %if.end80
	i32.const	$push140=, 0
	i32.const	$push27=, -2139243339
	i32.mul 	$push28=, $0, $pop27
	i32.const	$push29=, -1492899873
	i32.add 	$push139=, $pop28, $pop29
	tee_local	$push138=, $0=, $pop139
	i32.const	$push137=, 1103515245
	i32.mul 	$push30=, $pop138, $pop137
	i32.const	$push136=, 12345
	i32.add 	$push135=, $pop30, $pop136
	tee_local	$push134=, $1=, $pop135
	i32.store	myrnd.s($pop140), $pop134
	i32.const	$push133=, 0
	i32.const	$push132=, 16
	i32.shr_u	$push34=, $1, $pop132
	i32.const	$push131=, 2047
	i32.and 	$push130=, $pop34, $pop131
	tee_local	$push129=, $1=, $pop130
	i32.const	$push128=, 17
	i32.shl 	$push35=, $pop129, $pop128
	i32.const	$push127=, 16
	i32.shr_u	$push31=, $0, $pop127
	i32.const	$push126=, 2047
	i32.and 	$push125=, $pop31, $pop126
	tee_local	$push124=, $4=, $pop125
	i32.const	$push123=, 17
	i32.shl 	$push32=, $pop124, $pop123
	i32.or  	$push33=, $pop32, $3
	i32.add 	$push122=, $pop35, $pop33
	tee_local	$push121=, $0=, $pop122
	i32.store	sC+4($pop133), $pop121
	i32.xor 	$push36=, $0, $2
	i32.const	$push120=, 131071
	i32.and 	$push37=, $pop36, $pop120
	br_if   	0, $pop37       # 0: down to label2
# BB#2:                                 # %lor.lhs.false115
	i32.add 	$push40=, $1, $4
	i32.const	$push38=, 17
	i32.shr_u	$push39=, $0, $pop38
	i32.ne  	$push41=, $pop40, $pop39
	br_if   	0, $pop41       # 0: down to label2
# BB#3:                                 # %if.end121
	return
.LBB18_4:                               # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end18:
	.size	testC, .Lfunc_end18-testC
                                        # -- End function
	.section	.text.retmeD,"ax",@progbits
	.hidden	retmeD                  # -- Begin function retmeD
	.globl	retmeD
	.type	retmeD,@function
retmeD:                                 # @retmeD
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end19:
	.size	retmeD, .Lfunc_end19-retmeD
                                        # -- End function
	.section	.text.fn1D,"ax",@progbits
	.hidden	fn1D                    # -- Begin function fn1D
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
                                        # -- End function
	.section	.text.fn2D,"ax",@progbits
	.hidden	fn2D                    # -- Begin function fn2D
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
                                        # -- End function
	.section	.text.retitD,"ax",@progbits
	.hidden	retitD                  # -- Begin function retitD
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
                                        # -- End function
	.section	.text.fn3D,"ax",@progbits
	.hidden	fn3D                    # -- Begin function fn3D
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
	i64.store	sD($pop0), $pop8
	i32.const	$push9=, 536870911
	i32.and 	$push10=, $0, $pop9
                                        # fallthrough-return: $pop10
	.endfunc
.Lfunc_end23:
	.size	fn3D, .Lfunc_end23-fn3D
                                        # -- End function
	.section	.text.testD,"ax",@progbits
	.hidden	testD                   # -- Begin function testD
	.globl	testD
	.type	testD,@function
testD:                                  # @testD
	.local  	i32, i32
# BB#0:                                 # %if.end158
	i32.const	$push0=, 0
	i32.const	$push94=, 0
	i32.load	$push1=, myrnd.s($pop94)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push93=, $pop3, $pop4
	tee_local	$push92=, $0=, $pop93
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop92, $pop5
	i32.store8	sD($pop0), $pop6
	i32.const	$push91=, 0
	i32.const	$push90=, 1103515245
	i32.mul 	$push7=, $0, $pop90
	i32.const	$push89=, 12345
	i32.add 	$push88=, $pop7, $pop89
	tee_local	$push87=, $0=, $pop88
	i32.const	$push86=, 16
	i32.shr_u	$push8=, $pop87, $pop86
	i32.store8	sD+1($pop91), $pop8
	i32.const	$push85=, 0
	i32.const	$push84=, 1103515245
	i32.mul 	$push9=, $0, $pop84
	i32.const	$push83=, 12345
	i32.add 	$push82=, $pop9, $pop83
	tee_local	$push81=, $0=, $pop82
	i32.const	$push80=, 16
	i32.shr_u	$push10=, $pop81, $pop80
	i32.store8	sD+2($pop85), $pop10
	i32.const	$push79=, 0
	i32.const	$push78=, 1103515245
	i32.mul 	$push11=, $0, $pop78
	i32.const	$push77=, 12345
	i32.add 	$push76=, $pop11, $pop77
	tee_local	$push75=, $0=, $pop76
	i32.const	$push74=, 16
	i32.shr_u	$push12=, $pop75, $pop74
	i32.store8	sD+3($pop79), $pop12
	i32.const	$push73=, 0
	i32.const	$push72=, 1103515245
	i32.mul 	$push13=, $0, $pop72
	i32.const	$push71=, 12345
	i32.add 	$push70=, $pop13, $pop71
	tee_local	$push69=, $0=, $pop70
	i32.const	$push68=, 16
	i32.shr_u	$push14=, $pop69, $pop68
	i32.store8	sD+4($pop73), $pop14
	i32.const	$push67=, 0
	i32.const	$push66=, 1103515245
	i32.mul 	$push15=, $0, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push64=, $pop15, $pop65
	tee_local	$push63=, $0=, $pop64
	i32.const	$push62=, 16
	i32.shr_u	$push16=, $pop63, $pop62
	i32.store8	sD+5($pop67), $pop16
	i32.const	$push61=, 0
	i32.const	$push60=, 1103515245
	i32.mul 	$push17=, $0, $pop60
	i32.const	$push59=, 12345
	i32.add 	$push58=, $pop17, $pop59
	tee_local	$push57=, $0=, $pop58
	i32.const	$push56=, 16
	i32.shr_u	$push18=, $pop57, $pop56
	i32.store8	sD+6($pop61), $pop18
	i32.const	$push55=, 0
	i32.const	$push54=, 1103515245
	i32.mul 	$push19=, $0, $pop54
	i32.const	$push53=, 12345
	i32.add 	$push52=, $pop19, $pop53
	tee_local	$push51=, $0=, $pop52
	i32.const	$push50=, 16
	i32.shr_u	$push20=, $pop51, $pop50
	i32.store8	sD+7($pop55), $pop20
	i32.const	$push49=, 0
	i32.const	$push21=, -341751747
	i32.mul 	$push22=, $0, $pop21
	i32.const	$push23=, 229283573
	i32.add 	$push48=, $pop22, $pop23
	tee_local	$push47=, $0=, $pop48
	i32.const	$push46=, 1103515245
	i32.mul 	$push24=, $pop47, $pop46
	i32.const	$push45=, 12345
	i32.add 	$push44=, $pop24, $pop45
	tee_local	$push43=, $1=, $pop44
	i32.store	myrnd.s($pop49), $pop43
	i32.const	$push42=, 0
	i32.const	$push41=, 16
	i32.shr_u	$push28=, $1, $pop41
	i32.const	$push26=, 2047
	i32.and 	$push29=, $pop28, $pop26
	i32.const	$push40=, 16
	i32.shr_u	$push25=, $0, $pop40
	i32.const	$push39=, 2047
	i32.and 	$push27=, $pop25, $pop39
	i32.add 	$push30=, $pop29, $pop27
	i64.extend_u/i32	$push31=, $pop30
	i64.const	$push32=, 35
	i64.shl 	$push33=, $pop31, $pop32
	i32.const	$push38=, 0
	i64.load	$push34=, sD($pop38)
	i64.const	$push35=, 34359738367
	i64.and 	$push36=, $pop34, $pop35
	i64.or  	$push37=, $pop33, $pop36
	i64.store	sD($pop42), $pop37
                                        # fallthrough-return
	.endfunc
.Lfunc_end24:
	.size	testD, .Lfunc_end24-testD
                                        # -- End function
	.section	.text.retmeE,"ax",@progbits
	.hidden	retmeE                  # -- Begin function retmeE
	.globl	retmeE
	.type	retmeE,@function
retmeE:                                 # @retmeE
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	0($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end25:
	.size	retmeE, .Lfunc_end25-retmeE
                                        # -- End function
	.section	.text.fn1E,"ax",@progbits
	.hidden	fn1E                    # -- Begin function fn1E
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
                                        # -- End function
	.section	.text.fn2E,"ax",@progbits
	.hidden	fn2E                    # -- Begin function fn2E
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
                                        # -- End function
	.section	.text.retitE,"ax",@progbits
	.hidden	retitE                  # -- Begin function retitE
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
                                        # -- End function
	.section	.text.fn3E,"ax",@progbits
	.hidden	fn3E                    # -- Begin function fn3E
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
	i64.store	sE+8($pop0), $pop8
	i32.const	$push9=, 536870911
	i32.and 	$push10=, $0, $pop9
                                        # fallthrough-return: $pop10
	.endfunc
.Lfunc_end29:
	.size	fn3E, .Lfunc_end29-fn3E
                                        # -- End function
	.section	.text.testE,"ax",@progbits
	.hidden	testE                   # -- Begin function testE
	.globl	testE
	.type	testE,@function
testE:                                  # @testE
	.local  	i32, i32
# BB#0:                                 # %if.end95
	i32.const	$push0=, 0
	i32.const	$push158=, 0
	i32.load	$push1=, myrnd.s($pop158)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push157=, $pop3, $pop4
	tee_local	$push156=, $0=, $pop157
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop156, $pop5
	i32.store8	sE($pop0), $pop6
	i32.const	$push155=, 0
	i32.const	$push154=, 1103515245
	i32.mul 	$push7=, $0, $pop154
	i32.const	$push153=, 12345
	i32.add 	$push152=, $pop7, $pop153
	tee_local	$push151=, $0=, $pop152
	i32.const	$push150=, 16
	i32.shr_u	$push8=, $pop151, $pop150
	i32.store8	sE+1($pop155), $pop8
	i32.const	$push149=, 0
	i32.const	$push148=, 1103515245
	i32.mul 	$push9=, $0, $pop148
	i32.const	$push147=, 12345
	i32.add 	$push146=, $pop9, $pop147
	tee_local	$push145=, $0=, $pop146
	i32.const	$push144=, 16
	i32.shr_u	$push10=, $pop145, $pop144
	i32.store8	sE+2($pop149), $pop10
	i32.const	$push143=, 0
	i32.const	$push142=, 1103515245
	i32.mul 	$push11=, $0, $pop142
	i32.const	$push141=, 12345
	i32.add 	$push140=, $pop11, $pop141
	tee_local	$push139=, $0=, $pop140
	i32.const	$push138=, 16
	i32.shr_u	$push12=, $pop139, $pop138
	i32.store8	sE+3($pop143), $pop12
	i32.const	$push137=, 0
	i32.const	$push136=, 1103515245
	i32.mul 	$push13=, $0, $pop136
	i32.const	$push135=, 12345
	i32.add 	$push134=, $pop13, $pop135
	tee_local	$push133=, $0=, $pop134
	i32.const	$push132=, 16
	i32.shr_u	$push14=, $pop133, $pop132
	i32.store8	sE+4($pop137), $pop14
	i32.const	$push131=, 0
	i32.const	$push130=, 1103515245
	i32.mul 	$push15=, $0, $pop130
	i32.const	$push129=, 12345
	i32.add 	$push128=, $pop15, $pop129
	tee_local	$push127=, $0=, $pop128
	i32.const	$push126=, 16
	i32.shr_u	$push16=, $pop127, $pop126
	i32.store8	sE+5($pop131), $pop16
	i32.const	$push125=, 0
	i32.const	$push124=, 1103515245
	i32.mul 	$push17=, $0, $pop124
	i32.const	$push123=, 12345
	i32.add 	$push122=, $pop17, $pop123
	tee_local	$push121=, $0=, $pop122
	i32.const	$push120=, 16
	i32.shr_u	$push18=, $pop121, $pop120
	i32.store8	sE+6($pop125), $pop18
	i32.const	$push119=, 0
	i32.const	$push118=, 1103515245
	i32.mul 	$push19=, $0, $pop118
	i32.const	$push117=, 12345
	i32.add 	$push116=, $pop19, $pop117
	tee_local	$push115=, $0=, $pop116
	i32.const	$push114=, 16
	i32.shr_u	$push20=, $pop115, $pop114
	i32.store8	sE+7($pop119), $pop20
	i32.const	$push113=, 0
	i32.const	$push112=, 1103515245
	i32.mul 	$push21=, $0, $pop112
	i32.const	$push111=, 12345
	i32.add 	$push110=, $pop21, $pop111
	tee_local	$push109=, $0=, $pop110
	i32.const	$push108=, 16
	i32.shr_u	$push22=, $pop109, $pop108
	i32.store8	sE+8($pop113), $pop22
	i32.const	$push107=, 0
	i32.const	$push106=, 1103515245
	i32.mul 	$push23=, $0, $pop106
	i32.const	$push105=, 12345
	i32.add 	$push104=, $pop23, $pop105
	tee_local	$push103=, $0=, $pop104
	i32.const	$push102=, 16
	i32.shr_u	$push24=, $pop103, $pop102
	i32.store8	sE+9($pop107), $pop24
	i32.const	$push101=, 0
	i32.const	$push100=, 1103515245
	i32.mul 	$push25=, $0, $pop100
	i32.const	$push99=, 12345
	i32.add 	$push98=, $pop25, $pop99
	tee_local	$push97=, $0=, $pop98
	i32.const	$push96=, 16
	i32.shr_u	$push26=, $pop97, $pop96
	i32.store8	sE+10($pop101), $pop26
	i32.const	$push95=, 0
	i32.const	$push94=, 1103515245
	i32.mul 	$push27=, $0, $pop94
	i32.const	$push93=, 12345
	i32.add 	$push92=, $pop27, $pop93
	tee_local	$push91=, $0=, $pop92
	i32.const	$push90=, 16
	i32.shr_u	$push28=, $pop91, $pop90
	i32.store8	sE+11($pop95), $pop28
	i32.const	$push89=, 0
	i32.const	$push88=, 1103515245
	i32.mul 	$push29=, $0, $pop88
	i32.const	$push87=, 12345
	i32.add 	$push86=, $pop29, $pop87
	tee_local	$push85=, $0=, $pop86
	i32.const	$push84=, 16
	i32.shr_u	$push30=, $pop85, $pop84
	i32.store8	sE+12($pop89), $pop30
	i32.const	$push83=, 0
	i32.const	$push82=, 1103515245
	i32.mul 	$push31=, $0, $pop82
	i32.const	$push81=, 12345
	i32.add 	$push80=, $pop31, $pop81
	tee_local	$push79=, $0=, $pop80
	i32.const	$push78=, 16
	i32.shr_u	$push32=, $pop79, $pop78
	i32.store8	sE+13($pop83), $pop32
	i32.const	$push77=, 0
	i32.const	$push76=, 1103515245
	i32.mul 	$push33=, $0, $pop76
	i32.const	$push75=, 12345
	i32.add 	$push74=, $pop33, $pop75
	tee_local	$push73=, $0=, $pop74
	i32.const	$push72=, 16
	i32.shr_u	$push34=, $pop73, $pop72
	i32.store8	sE+14($pop77), $pop34
	i32.const	$push71=, 0
	i32.const	$push70=, 1103515245
	i32.mul 	$push35=, $0, $pop70
	i32.const	$push69=, 12345
	i32.add 	$push68=, $pop35, $pop69
	tee_local	$push67=, $0=, $pop68
	i32.const	$push66=, 16
	i32.shr_u	$push36=, $pop67, $pop66
	i32.store8	sE+15($pop71), $pop36
	i32.const	$push65=, 0
	i32.const	$push37=, -341751747
	i32.mul 	$push38=, $0, $pop37
	i32.const	$push39=, 229283573
	i32.add 	$push64=, $pop38, $pop39
	tee_local	$push63=, $0=, $pop64
	i32.const	$push62=, 1103515245
	i32.mul 	$push40=, $pop63, $pop62
	i32.const	$push61=, 12345
	i32.add 	$push60=, $pop40, $pop61
	tee_local	$push59=, $1=, $pop60
	i32.store	myrnd.s($pop65), $pop59
	i32.const	$push58=, 0
	i32.const	$push57=, 16
	i32.shr_u	$push44=, $1, $pop57
	i32.const	$push42=, 2047
	i32.and 	$push45=, $pop44, $pop42
	i32.const	$push56=, 16
	i32.shr_u	$push41=, $0, $pop56
	i32.const	$push55=, 2047
	i32.and 	$push43=, $pop41, $pop55
	i32.add 	$push46=, $pop45, $pop43
	i64.extend_u/i32	$push47=, $pop46
	i64.const	$push48=, 35
	i64.shl 	$push49=, $pop47, $pop48
	i32.const	$push54=, 0
	i64.load	$push50=, sE+8($pop54)
	i64.const	$push51=, 34359738367
	i64.and 	$push52=, $pop50, $pop51
	i64.or  	$push53=, $pop49, $pop52
	i64.store	sE+8($pop58), $pop53
                                        # fallthrough-return
	.endfunc
.Lfunc_end30:
	.size	testE, .Lfunc_end30-testE
                                        # -- End function
	.section	.text.retmeF,"ax",@progbits
	.hidden	retmeF                  # -- Begin function retmeF
	.globl	retmeF
	.type	retmeF,@function
retmeF:                                 # @retmeF
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	0($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end31:
	.size	retmeF, .Lfunc_end31-retmeF
                                        # -- End function
	.section	.text.fn1F,"ax",@progbits
	.hidden	fn1F                    # -- Begin function fn1F
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
                                        # -- End function
	.section	.text.fn2F,"ax",@progbits
	.hidden	fn2F                    # -- Begin function fn2F
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
                                        # -- End function
	.section	.text.retitF,"ax",@progbits
	.hidden	retitF                  # -- Begin function retitF
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
                                        # -- End function
	.section	.text.fn3F,"ax",@progbits
	.hidden	fn3F                    # -- Begin function fn3F
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
	i64.store	sF($pop0), $pop8
	i32.const	$push9=, 536870911
	i32.and 	$push10=, $0, $pop9
                                        # fallthrough-return: $pop10
	.endfunc
.Lfunc_end35:
	.size	fn3F, .Lfunc_end35-fn3F
                                        # -- End function
	.section	.text.testF,"ax",@progbits
	.hidden	testF                   # -- Begin function testF
	.globl	testF
	.type	testF,@function
testF:                                  # @testF
	.local  	i32, i32
# BB#0:                                 # %if.end91
	i32.const	$push0=, 0
	i32.const	$push158=, 0
	i32.load	$push1=, myrnd.s($pop158)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push157=, $pop3, $pop4
	tee_local	$push156=, $0=, $pop157
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop156, $pop5
	i32.store8	sF($pop0), $pop6
	i32.const	$push155=, 0
	i32.const	$push154=, 1103515245
	i32.mul 	$push7=, $0, $pop154
	i32.const	$push153=, 12345
	i32.add 	$push152=, $pop7, $pop153
	tee_local	$push151=, $0=, $pop152
	i32.const	$push150=, 16
	i32.shr_u	$push8=, $pop151, $pop150
	i32.store8	sF+1($pop155), $pop8
	i32.const	$push149=, 0
	i32.const	$push148=, 1103515245
	i32.mul 	$push9=, $0, $pop148
	i32.const	$push147=, 12345
	i32.add 	$push146=, $pop9, $pop147
	tee_local	$push145=, $0=, $pop146
	i32.const	$push144=, 16
	i32.shr_u	$push10=, $pop145, $pop144
	i32.store8	sF+2($pop149), $pop10
	i32.const	$push143=, 0
	i32.const	$push142=, 1103515245
	i32.mul 	$push11=, $0, $pop142
	i32.const	$push141=, 12345
	i32.add 	$push140=, $pop11, $pop141
	tee_local	$push139=, $0=, $pop140
	i32.const	$push138=, 16
	i32.shr_u	$push12=, $pop139, $pop138
	i32.store8	sF+3($pop143), $pop12
	i32.const	$push137=, 0
	i32.const	$push136=, 1103515245
	i32.mul 	$push13=, $0, $pop136
	i32.const	$push135=, 12345
	i32.add 	$push134=, $pop13, $pop135
	tee_local	$push133=, $0=, $pop134
	i32.const	$push132=, 16
	i32.shr_u	$push14=, $pop133, $pop132
	i32.store8	sF+4($pop137), $pop14
	i32.const	$push131=, 0
	i32.const	$push130=, 1103515245
	i32.mul 	$push15=, $0, $pop130
	i32.const	$push129=, 12345
	i32.add 	$push128=, $pop15, $pop129
	tee_local	$push127=, $0=, $pop128
	i32.const	$push126=, 16
	i32.shr_u	$push16=, $pop127, $pop126
	i32.store8	sF+5($pop131), $pop16
	i32.const	$push125=, 0
	i32.const	$push124=, 1103515245
	i32.mul 	$push17=, $0, $pop124
	i32.const	$push123=, 12345
	i32.add 	$push122=, $pop17, $pop123
	tee_local	$push121=, $0=, $pop122
	i32.const	$push120=, 16
	i32.shr_u	$push18=, $pop121, $pop120
	i32.store8	sF+6($pop125), $pop18
	i32.const	$push119=, 0
	i32.const	$push118=, 1103515245
	i32.mul 	$push19=, $0, $pop118
	i32.const	$push117=, 12345
	i32.add 	$push116=, $pop19, $pop117
	tee_local	$push115=, $0=, $pop116
	i32.const	$push114=, 16
	i32.shr_u	$push20=, $pop115, $pop114
	i32.store8	sF+7($pop119), $pop20
	i32.const	$push113=, 0
	i32.const	$push112=, 1103515245
	i32.mul 	$push21=, $0, $pop112
	i32.const	$push111=, 12345
	i32.add 	$push110=, $pop21, $pop111
	tee_local	$push109=, $0=, $pop110
	i32.const	$push108=, 16
	i32.shr_u	$push22=, $pop109, $pop108
	i32.store8	sF+8($pop113), $pop22
	i32.const	$push107=, 0
	i32.const	$push106=, 1103515245
	i32.mul 	$push23=, $0, $pop106
	i32.const	$push105=, 12345
	i32.add 	$push104=, $pop23, $pop105
	tee_local	$push103=, $0=, $pop104
	i32.const	$push102=, 16
	i32.shr_u	$push24=, $pop103, $pop102
	i32.store8	sF+9($pop107), $pop24
	i32.const	$push101=, 0
	i32.const	$push100=, 1103515245
	i32.mul 	$push25=, $0, $pop100
	i32.const	$push99=, 12345
	i32.add 	$push98=, $pop25, $pop99
	tee_local	$push97=, $0=, $pop98
	i32.const	$push96=, 16
	i32.shr_u	$push26=, $pop97, $pop96
	i32.store8	sF+10($pop101), $pop26
	i32.const	$push95=, 0
	i32.const	$push94=, 1103515245
	i32.mul 	$push27=, $0, $pop94
	i32.const	$push93=, 12345
	i32.add 	$push92=, $pop27, $pop93
	tee_local	$push91=, $0=, $pop92
	i32.const	$push90=, 16
	i32.shr_u	$push28=, $pop91, $pop90
	i32.store8	sF+11($pop95), $pop28
	i32.const	$push89=, 0
	i32.const	$push88=, 1103515245
	i32.mul 	$push29=, $0, $pop88
	i32.const	$push87=, 12345
	i32.add 	$push86=, $pop29, $pop87
	tee_local	$push85=, $0=, $pop86
	i32.const	$push84=, 16
	i32.shr_u	$push30=, $pop85, $pop84
	i32.store8	sF+12($pop89), $pop30
	i32.const	$push83=, 0
	i32.const	$push82=, 1103515245
	i32.mul 	$push31=, $0, $pop82
	i32.const	$push81=, 12345
	i32.add 	$push80=, $pop31, $pop81
	tee_local	$push79=, $0=, $pop80
	i32.const	$push78=, 16
	i32.shr_u	$push32=, $pop79, $pop78
	i32.store8	sF+13($pop83), $pop32
	i32.const	$push77=, 0
	i32.const	$push76=, 1103515245
	i32.mul 	$push33=, $0, $pop76
	i32.const	$push75=, 12345
	i32.add 	$push74=, $pop33, $pop75
	tee_local	$push73=, $0=, $pop74
	i32.const	$push72=, 16
	i32.shr_u	$push34=, $pop73, $pop72
	i32.store8	sF+14($pop77), $pop34
	i32.const	$push71=, 0
	i32.const	$push70=, 1103515245
	i32.mul 	$push35=, $0, $pop70
	i32.const	$push69=, 12345
	i32.add 	$push68=, $pop35, $pop69
	tee_local	$push67=, $0=, $pop68
	i32.const	$push66=, 16
	i32.shr_u	$push36=, $pop67, $pop66
	i32.store8	sF+15($pop71), $pop36
	i32.const	$push65=, 0
	i32.const	$push37=, -341751747
	i32.mul 	$push38=, $0, $pop37
	i32.const	$push39=, 229283573
	i32.add 	$push64=, $pop38, $pop39
	tee_local	$push63=, $0=, $pop64
	i32.const	$push62=, 1103515245
	i32.mul 	$push40=, $pop63, $pop62
	i32.const	$push61=, 12345
	i32.add 	$push60=, $pop40, $pop61
	tee_local	$push59=, $1=, $pop60
	i32.store	myrnd.s($pop65), $pop59
	i32.const	$push58=, 0
	i32.const	$push57=, 16
	i32.shr_u	$push44=, $1, $pop57
	i32.const	$push42=, 2047
	i32.and 	$push45=, $pop44, $pop42
	i32.const	$push56=, 16
	i32.shr_u	$push41=, $0, $pop56
	i32.const	$push55=, 2047
	i32.and 	$push43=, $pop41, $pop55
	i32.add 	$push46=, $pop45, $pop43
	i64.extend_u/i32	$push47=, $pop46
	i64.const	$push48=, 35
	i64.shl 	$push49=, $pop47, $pop48
	i32.const	$push54=, 0
	i64.load	$push50=, sF($pop54)
	i64.const	$push51=, 34359738367
	i64.and 	$push52=, $pop50, $pop51
	i64.or  	$push53=, $pop49, $pop52
	i64.store	sF($pop58), $pop53
                                        # fallthrough-return
	.endfunc
.Lfunc_end36:
	.size	testF, .Lfunc_end36-testF
                                        # -- End function
	.section	.text.retmeG,"ax",@progbits
	.hidden	retmeG                  # -- Begin function retmeG
	.globl	retmeG
	.type	retmeG,@function
retmeG:                                 # @retmeG
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	0($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end37:
	.size	retmeG, .Lfunc_end37-retmeG
                                        # -- End function
	.section	.text.fn1G,"ax",@progbits
	.hidden	fn1G                    # -- Begin function fn1G
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
                                        # -- End function
	.section	.text.fn2G,"ax",@progbits
	.hidden	fn2G                    # -- Begin function fn2G
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
                                        # -- End function
	.section	.text.retitG,"ax",@progbits
	.hidden	retitG                  # -- Begin function retitG
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
                                        # -- End function
	.section	.text.fn3G,"ax",@progbits
	.hidden	fn3G                    # -- Begin function fn3G
	.globl	fn3G
	.type	fn3G,@function
fn3G:                                   # @fn3G
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push8=, 0
	i32.load	$push3=, sG($pop8)
	i32.const	$push0=, 25
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push7=, $pop3, $pop1
	tee_local	$push6=, $0=, $pop7
	i32.store	sG($pop2), $pop6
	i32.const	$push5=, 25
	i32.shr_u	$push4=, $0, $pop5
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end41:
	.size	fn3G, .Lfunc_end41-fn3G
                                        # -- End function
	.section	.text.testG,"ax",@progbits
	.hidden	testG                   # -- Begin function testG
	.globl	testG
	.type	testG,@function
testG:                                  # @testG
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push181=, 0
	i32.const	$push180=, 0
	i32.load	$push0=, myrnd.s($pop180)
	i32.const	$push179=, 1103515245
	i32.mul 	$push1=, $pop0, $pop179
	i32.const	$push178=, 12345
	i32.add 	$push177=, $pop1, $pop178
	tee_local	$push176=, $1=, $pop177
	i32.const	$push175=, 16
	i32.shr_u	$push2=, $pop176, $pop175
	i32.store8	sG($pop181), $pop2
	i32.const	$push174=, 0
	i32.const	$push173=, 1103515245
	i32.mul 	$push3=, $1, $pop173
	i32.const	$push172=, 12345
	i32.add 	$push171=, $pop3, $pop172
	tee_local	$push170=, $1=, $pop171
	i32.const	$push169=, 16
	i32.shr_u	$push4=, $pop170, $pop169
	i32.store8	sG+1($pop174), $pop4
	i32.const	$push168=, 0
	i32.const	$push167=, 1103515245
	i32.mul 	$push5=, $1, $pop167
	i32.const	$push166=, 12345
	i32.add 	$push165=, $pop5, $pop166
	tee_local	$push164=, $1=, $pop165
	i32.const	$push163=, 16
	i32.shr_u	$push6=, $pop164, $pop163
	i32.store8	sG+2($pop168), $pop6
	i32.const	$push162=, 0
	i32.const	$push161=, 1103515245
	i32.mul 	$push7=, $1, $pop161
	i32.const	$push160=, 12345
	i32.add 	$push159=, $pop7, $pop160
	tee_local	$push158=, $1=, $pop159
	i32.const	$push157=, 16
	i32.shr_u	$push8=, $pop158, $pop157
	i32.store8	sG+3($pop162), $pop8
	i32.const	$push156=, 0
	i32.const	$push155=, 1103515245
	i32.mul 	$push9=, $1, $pop155
	i32.const	$push154=, 12345
	i32.add 	$push153=, $pop9, $pop154
	tee_local	$push152=, $1=, $pop153
	i32.const	$push151=, 16
	i32.shr_u	$push10=, $pop152, $pop151
	i32.store8	sG+4($pop156), $pop10
	i32.const	$push150=, 0
	i32.const	$push149=, 1103515245
	i32.mul 	$push11=, $1, $pop149
	i32.const	$push148=, 12345
	i32.add 	$push147=, $pop11, $pop148
	tee_local	$push146=, $1=, $pop147
	i32.const	$push145=, 16
	i32.shr_u	$push12=, $pop146, $pop145
	i32.store8	sG+5($pop150), $pop12
	i32.const	$push144=, 0
	i32.const	$push143=, 1103515245
	i32.mul 	$push13=, $1, $pop143
	i32.const	$push142=, 12345
	i32.add 	$push141=, $pop13, $pop142
	tee_local	$push140=, $1=, $pop141
	i32.const	$push139=, 16
	i32.shr_u	$push14=, $pop140, $pop139
	i32.store8	sG+6($pop144), $pop14
	i32.const	$push138=, 0
	i32.const	$push137=, 1103515245
	i32.mul 	$push15=, $1, $pop137
	i32.const	$push136=, 12345
	i32.add 	$push135=, $pop15, $pop136
	tee_local	$push134=, $1=, $pop135
	i32.const	$push133=, 16
	i32.shr_u	$push16=, $pop134, $pop133
	i32.store8	sG+7($pop138), $pop16
	i32.const	$push132=, 0
	i32.const	$push131=, 1103515245
	i32.mul 	$push17=, $1, $pop131
	i32.const	$push130=, 12345
	i32.add 	$push129=, $pop17, $pop130
	tee_local	$push128=, $1=, $pop129
	i32.const	$push127=, 16
	i32.shr_u	$push18=, $pop128, $pop127
	i32.store8	sG+8($pop132), $pop18
	i32.const	$push126=, 0
	i32.const	$push125=, 1103515245
	i32.mul 	$push19=, $1, $pop125
	i32.const	$push124=, 12345
	i32.add 	$push123=, $pop19, $pop124
	tee_local	$push122=, $1=, $pop123
	i32.const	$push121=, 16
	i32.shr_u	$push20=, $pop122, $pop121
	i32.store8	sG+9($pop126), $pop20
	i32.const	$push120=, 0
	i32.const	$push119=, 1103515245
	i32.mul 	$push21=, $1, $pop119
	i32.const	$push118=, 12345
	i32.add 	$push117=, $pop21, $pop118
	tee_local	$push116=, $1=, $pop117
	i32.const	$push115=, 16
	i32.shr_u	$push22=, $pop116, $pop115
	i32.store8	sG+10($pop120), $pop22
	i32.const	$push114=, 0
	i32.const	$push113=, 1103515245
	i32.mul 	$push23=, $1, $pop113
	i32.const	$push112=, 12345
	i32.add 	$push111=, $pop23, $pop112
	tee_local	$push110=, $1=, $pop111
	i32.const	$push109=, 16
	i32.shr_u	$push24=, $pop110, $pop109
	i32.store8	sG+11($pop114), $pop24
	i32.const	$push108=, 0
	i32.const	$push107=, 1103515245
	i32.mul 	$push25=, $1, $pop107
	i32.const	$push106=, 12345
	i32.add 	$push105=, $pop25, $pop106
	tee_local	$push104=, $1=, $pop105
	i32.const	$push103=, 16
	i32.shr_u	$push26=, $pop104, $pop103
	i32.store8	sG+12($pop108), $pop26
	i32.const	$push102=, 0
	i32.const	$push101=, 1103515245
	i32.mul 	$push27=, $1, $pop101
	i32.const	$push100=, 12345
	i32.add 	$push99=, $pop27, $pop100
	tee_local	$push98=, $1=, $pop99
	i32.const	$push97=, 16
	i32.shr_u	$push28=, $pop98, $pop97
	i32.store8	sG+13($pop102), $pop28
	i32.const	$push96=, 0
	i32.const	$push95=, 1103515245
	i32.mul 	$push29=, $1, $pop95
	i32.const	$push94=, 12345
	i32.add 	$push93=, $pop29, $pop94
	tee_local	$push92=, $1=, $pop93
	i32.const	$push91=, 16
	i32.shr_u	$push30=, $pop92, $pop91
	i32.store8	sG+14($pop96), $pop30
	i32.const	$push90=, 0
	i32.const	$push89=, 1103515245
	i32.mul 	$push31=, $1, $pop89
	i32.const	$push88=, 12345
	i32.add 	$push87=, $pop31, $pop88
	tee_local	$push86=, $1=, $pop87
	i32.const	$push85=, 16
	i32.shr_u	$push32=, $pop86, $pop85
	i32.store8	sG+15($pop90), $pop32
	i32.const	$push84=, 0
	i32.const	$push83=, 1103515245
	i32.mul 	$push33=, $1, $pop83
	i32.const	$push82=, 12345
	i32.add 	$push81=, $pop33, $pop82
	tee_local	$push80=, $3=, $pop81
	i32.const	$push79=, 1103515245
	i32.mul 	$push34=, $pop80, $pop79
	i32.const	$push78=, 12345
	i32.add 	$push77=, $pop34, $pop78
	tee_local	$push76=, $1=, $pop77
	i32.store	myrnd.s($pop84), $pop76
	i32.const	$push75=, 0
	i32.const	$push74=, 16
	i32.shr_u	$push73=, $3, $pop74
	tee_local	$push72=, $3=, $pop73
	i32.const	$push71=, 25
	i32.shl 	$push35=, $pop72, $pop71
	i32.const	$push70=, 0
	i32.load	$push69=, sG($pop70)
	tee_local	$push68=, $0=, $pop69
	i32.const	$push67=, 33554431
	i32.and 	$push66=, $pop68, $pop67
	tee_local	$push65=, $2=, $pop66
	i32.or  	$push64=, $pop35, $pop65
	tee_local	$push63=, $4=, $pop64
	i32.store	sG($pop75), $pop63
	block   	
	i32.const	$push62=, 16
	i32.shr_u	$push61=, $1, $pop62
	tee_local	$push60=, $5=, $pop61
	i32.add 	$push36=, $pop60, $3
	i32.const	$push37=, 127
	i32.and 	$push38=, $pop36, $pop37
	i32.const	$push59=, 25
	i32.shl 	$push39=, $5, $pop59
	i32.add 	$push40=, $pop39, $4
	i32.const	$push58=, 25
	i32.shr_u	$push41=, $pop40, $pop58
	i32.ne  	$push42=, $pop38, $pop41
	br_if   	0, $pop42       # 0: down to label3
# BB#1:                                 # %if.end76
	i32.const	$push200=, 0
	i32.const	$push43=, -2139243339
	i32.mul 	$push44=, $1, $pop43
	i32.const	$push45=, -1492899873
	i32.add 	$push199=, $pop44, $pop45
	tee_local	$push198=, $1=, $pop199
	i32.const	$push197=, 1103515245
	i32.mul 	$push46=, $pop198, $pop197
	i32.const	$push196=, 12345
	i32.add 	$push195=, $pop46, $pop196
	tee_local	$push194=, $3=, $pop195
	i32.store	myrnd.s($pop200), $pop194
	i32.const	$push193=, 0
	i32.const	$push192=, 16
	i32.shr_u	$push191=, $3, $pop192
	tee_local	$push190=, $3=, $pop191
	i32.const	$push189=, 25
	i32.shl 	$push49=, $pop190, $pop189
	i32.const	$push188=, 16
	i32.shr_u	$push187=, $1, $pop188
	tee_local	$push186=, $4=, $pop187
	i32.const	$push185=, 25
	i32.shl 	$push47=, $pop186, $pop185
	i32.or  	$push48=, $pop47, $2
	i32.add 	$push184=, $pop49, $pop48
	tee_local	$push183=, $1=, $pop184
	i32.store	sG($pop193), $pop183
	i32.xor 	$push50=, $1, $0
	i32.const	$push182=, 33554431
	i32.and 	$push51=, $pop50, $pop182
	br_if   	0, $pop51       # 0: down to label3
# BB#2:                                 # %lor.lhs.false109
	i32.add 	$push54=, $3, $4
	i32.const	$push55=, 127
	i32.and 	$push56=, $pop54, $pop55
	i32.const	$push52=, 25
	i32.shr_u	$push53=, $1, $pop52
	i32.ne  	$push57=, $pop56, $pop53
	br_if   	0, $pop57       # 0: down to label3
# BB#3:                                 # %if.end115
	return
.LBB42_4:                               # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end42:
	.size	testG, .Lfunc_end42-testG
                                        # -- End function
	.section	.text.retmeH,"ax",@progbits
	.hidden	retmeH                  # -- Begin function retmeH
	.globl	retmeH
	.type	retmeH,@function
retmeH:                                 # @retmeH
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	0($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end43:
	.size	retmeH, .Lfunc_end43-retmeH
                                        # -- End function
	.section	.text.fn1H,"ax",@progbits
	.hidden	fn1H                    # -- Begin function fn1H
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
                                        # -- End function
	.section	.text.fn2H,"ax",@progbits
	.hidden	fn2H                    # -- Begin function fn2H
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
                                        # -- End function
	.section	.text.retitH,"ax",@progbits
	.hidden	retitH                  # -- Begin function retitH
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
                                        # -- End function
	.section	.text.fn3H,"ax",@progbits
	.hidden	fn3H                    # -- Begin function fn3H
	.globl	fn3H
	.type	fn3H,@function
fn3H:                                   # @fn3H
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push8=, 0
	i32.load	$push3=, sH($pop8)
	i32.const	$push0=, 23
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push7=, $pop3, $pop1
	tee_local	$push6=, $0=, $pop7
	i32.store	sH($pop2), $pop6
	i32.const	$push5=, 23
	i32.shr_u	$push4=, $0, $pop5
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end47:
	.size	fn3H, .Lfunc_end47-fn3H
                                        # -- End function
	.section	.text.testH,"ax",@progbits
	.hidden	testH                   # -- Begin function testH
	.globl	testH
	.type	testH,@function
testH:                                  # @testH
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push181=, 0
	i32.const	$push180=, 0
	i32.load	$push0=, myrnd.s($pop180)
	i32.const	$push179=, 1103515245
	i32.mul 	$push1=, $pop0, $pop179
	i32.const	$push178=, 12345
	i32.add 	$push177=, $pop1, $pop178
	tee_local	$push176=, $1=, $pop177
	i32.const	$push175=, 16
	i32.shr_u	$push2=, $pop176, $pop175
	i32.store8	sH($pop181), $pop2
	i32.const	$push174=, 0
	i32.const	$push173=, 1103515245
	i32.mul 	$push3=, $1, $pop173
	i32.const	$push172=, 12345
	i32.add 	$push171=, $pop3, $pop172
	tee_local	$push170=, $1=, $pop171
	i32.const	$push169=, 16
	i32.shr_u	$push4=, $pop170, $pop169
	i32.store8	sH+1($pop174), $pop4
	i32.const	$push168=, 0
	i32.const	$push167=, 1103515245
	i32.mul 	$push5=, $1, $pop167
	i32.const	$push166=, 12345
	i32.add 	$push165=, $pop5, $pop166
	tee_local	$push164=, $1=, $pop165
	i32.const	$push163=, 16
	i32.shr_u	$push6=, $pop164, $pop163
	i32.store8	sH+2($pop168), $pop6
	i32.const	$push162=, 0
	i32.const	$push161=, 1103515245
	i32.mul 	$push7=, $1, $pop161
	i32.const	$push160=, 12345
	i32.add 	$push159=, $pop7, $pop160
	tee_local	$push158=, $1=, $pop159
	i32.const	$push157=, 16
	i32.shr_u	$push8=, $pop158, $pop157
	i32.store8	sH+3($pop162), $pop8
	i32.const	$push156=, 0
	i32.const	$push155=, 1103515245
	i32.mul 	$push9=, $1, $pop155
	i32.const	$push154=, 12345
	i32.add 	$push153=, $pop9, $pop154
	tee_local	$push152=, $1=, $pop153
	i32.const	$push151=, 16
	i32.shr_u	$push10=, $pop152, $pop151
	i32.store8	sH+4($pop156), $pop10
	i32.const	$push150=, 0
	i32.const	$push149=, 1103515245
	i32.mul 	$push11=, $1, $pop149
	i32.const	$push148=, 12345
	i32.add 	$push147=, $pop11, $pop148
	tee_local	$push146=, $1=, $pop147
	i32.const	$push145=, 16
	i32.shr_u	$push12=, $pop146, $pop145
	i32.store8	sH+5($pop150), $pop12
	i32.const	$push144=, 0
	i32.const	$push143=, 1103515245
	i32.mul 	$push13=, $1, $pop143
	i32.const	$push142=, 12345
	i32.add 	$push141=, $pop13, $pop142
	tee_local	$push140=, $1=, $pop141
	i32.const	$push139=, 16
	i32.shr_u	$push14=, $pop140, $pop139
	i32.store8	sH+6($pop144), $pop14
	i32.const	$push138=, 0
	i32.const	$push137=, 1103515245
	i32.mul 	$push15=, $1, $pop137
	i32.const	$push136=, 12345
	i32.add 	$push135=, $pop15, $pop136
	tee_local	$push134=, $1=, $pop135
	i32.const	$push133=, 16
	i32.shr_u	$push16=, $pop134, $pop133
	i32.store8	sH+7($pop138), $pop16
	i32.const	$push132=, 0
	i32.const	$push131=, 1103515245
	i32.mul 	$push17=, $1, $pop131
	i32.const	$push130=, 12345
	i32.add 	$push129=, $pop17, $pop130
	tee_local	$push128=, $1=, $pop129
	i32.const	$push127=, 16
	i32.shr_u	$push18=, $pop128, $pop127
	i32.store8	sH+8($pop132), $pop18
	i32.const	$push126=, 0
	i32.const	$push125=, 1103515245
	i32.mul 	$push19=, $1, $pop125
	i32.const	$push124=, 12345
	i32.add 	$push123=, $pop19, $pop124
	tee_local	$push122=, $1=, $pop123
	i32.const	$push121=, 16
	i32.shr_u	$push20=, $pop122, $pop121
	i32.store8	sH+9($pop126), $pop20
	i32.const	$push120=, 0
	i32.const	$push119=, 1103515245
	i32.mul 	$push21=, $1, $pop119
	i32.const	$push118=, 12345
	i32.add 	$push117=, $pop21, $pop118
	tee_local	$push116=, $1=, $pop117
	i32.const	$push115=, 16
	i32.shr_u	$push22=, $pop116, $pop115
	i32.store8	sH+10($pop120), $pop22
	i32.const	$push114=, 0
	i32.const	$push113=, 1103515245
	i32.mul 	$push23=, $1, $pop113
	i32.const	$push112=, 12345
	i32.add 	$push111=, $pop23, $pop112
	tee_local	$push110=, $1=, $pop111
	i32.const	$push109=, 16
	i32.shr_u	$push24=, $pop110, $pop109
	i32.store8	sH+11($pop114), $pop24
	i32.const	$push108=, 0
	i32.const	$push107=, 1103515245
	i32.mul 	$push25=, $1, $pop107
	i32.const	$push106=, 12345
	i32.add 	$push105=, $pop25, $pop106
	tee_local	$push104=, $1=, $pop105
	i32.const	$push103=, 16
	i32.shr_u	$push26=, $pop104, $pop103
	i32.store8	sH+12($pop108), $pop26
	i32.const	$push102=, 0
	i32.const	$push101=, 1103515245
	i32.mul 	$push27=, $1, $pop101
	i32.const	$push100=, 12345
	i32.add 	$push99=, $pop27, $pop100
	tee_local	$push98=, $1=, $pop99
	i32.const	$push97=, 16
	i32.shr_u	$push28=, $pop98, $pop97
	i32.store8	sH+13($pop102), $pop28
	i32.const	$push96=, 0
	i32.const	$push95=, 1103515245
	i32.mul 	$push29=, $1, $pop95
	i32.const	$push94=, 12345
	i32.add 	$push93=, $pop29, $pop94
	tee_local	$push92=, $1=, $pop93
	i32.const	$push91=, 16
	i32.shr_u	$push30=, $pop92, $pop91
	i32.store8	sH+14($pop96), $pop30
	i32.const	$push90=, 0
	i32.const	$push89=, 1103515245
	i32.mul 	$push31=, $1, $pop89
	i32.const	$push88=, 12345
	i32.add 	$push87=, $pop31, $pop88
	tee_local	$push86=, $1=, $pop87
	i32.const	$push85=, 16
	i32.shr_u	$push32=, $pop86, $pop85
	i32.store8	sH+15($pop90), $pop32
	i32.const	$push84=, 0
	i32.const	$push83=, 1103515245
	i32.mul 	$push33=, $1, $pop83
	i32.const	$push82=, 12345
	i32.add 	$push81=, $pop33, $pop82
	tee_local	$push80=, $3=, $pop81
	i32.const	$push79=, 1103515245
	i32.mul 	$push34=, $pop80, $pop79
	i32.const	$push78=, 12345
	i32.add 	$push77=, $pop34, $pop78
	tee_local	$push76=, $1=, $pop77
	i32.store	myrnd.s($pop84), $pop76
	i32.const	$push75=, 0
	i32.const	$push74=, 16
	i32.shr_u	$push73=, $3, $pop74
	tee_local	$push72=, $3=, $pop73
	i32.const	$push71=, 23
	i32.shl 	$push35=, $pop72, $pop71
	i32.const	$push70=, 0
	i32.load	$push69=, sH($pop70)
	tee_local	$push68=, $0=, $pop69
	i32.const	$push67=, 8388607
	i32.and 	$push66=, $pop68, $pop67
	tee_local	$push65=, $2=, $pop66
	i32.or  	$push64=, $pop35, $pop65
	tee_local	$push63=, $4=, $pop64
	i32.store	sH($pop75), $pop63
	block   	
	i32.const	$push62=, 16
	i32.shr_u	$push61=, $1, $pop62
	tee_local	$push60=, $5=, $pop61
	i32.add 	$push36=, $pop60, $3
	i32.const	$push37=, 511
	i32.and 	$push38=, $pop36, $pop37
	i32.const	$push59=, 23
	i32.shl 	$push39=, $5, $pop59
	i32.add 	$push40=, $pop39, $4
	i32.const	$push58=, 23
	i32.shr_u	$push41=, $pop40, $pop58
	i32.ne  	$push42=, $pop38, $pop41
	br_if   	0, $pop42       # 0: down to label4
# BB#1:                                 # %if.end76
	i32.const	$push200=, 0
	i32.const	$push43=, -2139243339
	i32.mul 	$push44=, $1, $pop43
	i32.const	$push45=, -1492899873
	i32.add 	$push199=, $pop44, $pop45
	tee_local	$push198=, $1=, $pop199
	i32.const	$push197=, 1103515245
	i32.mul 	$push46=, $pop198, $pop197
	i32.const	$push196=, 12345
	i32.add 	$push195=, $pop46, $pop196
	tee_local	$push194=, $3=, $pop195
	i32.store	myrnd.s($pop200), $pop194
	i32.const	$push193=, 0
	i32.const	$push192=, 16
	i32.shr_u	$push191=, $3, $pop192
	tee_local	$push190=, $3=, $pop191
	i32.const	$push189=, 23
	i32.shl 	$push49=, $pop190, $pop189
	i32.const	$push188=, 16
	i32.shr_u	$push187=, $1, $pop188
	tee_local	$push186=, $4=, $pop187
	i32.const	$push185=, 23
	i32.shl 	$push47=, $pop186, $pop185
	i32.or  	$push48=, $pop47, $2
	i32.add 	$push184=, $pop49, $pop48
	tee_local	$push183=, $1=, $pop184
	i32.store	sH($pop193), $pop183
	i32.xor 	$push50=, $1, $0
	i32.const	$push182=, 8388607
	i32.and 	$push51=, $pop50, $pop182
	br_if   	0, $pop51       # 0: down to label4
# BB#2:                                 # %lor.lhs.false109
	i32.add 	$push54=, $3, $4
	i32.const	$push55=, 511
	i32.and 	$push56=, $pop54, $pop55
	i32.const	$push52=, 23
	i32.shr_u	$push53=, $1, $pop52
	i32.ne  	$push57=, $pop56, $pop53
	br_if   	0, $pop57       # 0: down to label4
# BB#3:                                 # %if.end115
	return
.LBB48_4:                               # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end48:
	.size	testH, .Lfunc_end48-testH
                                        # -- End function
	.section	.text.retmeI,"ax",@progbits
	.hidden	retmeI                  # -- Begin function retmeI
	.globl	retmeI
	.type	retmeI,@function
retmeI:                                 # @retmeI
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	0($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end49:
	.size	retmeI, .Lfunc_end49-retmeI
                                        # -- End function
	.section	.text.fn1I,"ax",@progbits
	.hidden	fn1I                    # -- Begin function fn1I
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
                                        # -- End function
	.section	.text.fn2I,"ax",@progbits
	.hidden	fn2I                    # -- Begin function fn2I
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
                                        # -- End function
	.section	.text.retitI,"ax",@progbits
	.hidden	retitI                  # -- Begin function retitI
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
                                        # -- End function
	.section	.text.fn3I,"ax",@progbits
	.hidden	fn3I                    # -- Begin function fn3I
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
	i32.store16	sI($pop0), $pop6
	i32.const	$push7=, 511
	i32.and 	$push8=, $0, $pop7
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end53:
	.size	fn3I, .Lfunc_end53-fn3I
                                        # -- End function
	.section	.text.testI,"ax",@progbits
	.hidden	testI                   # -- Begin function testI
	.globl	testI
	.type	testI,@function
testI:                                  # @testI
	.local  	i32, i32, i32
# BB#0:                                 # %lor.lhs.false130
	i32.const	$push0=, 0
	i32.const	$push164=, 0
	i32.load	$push1=, myrnd.s($pop164)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push163=, $pop3, $pop4
	tee_local	$push162=, $0=, $pop163
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop162, $pop5
	i32.store8	sI($pop0), $pop6
	i32.const	$push161=, 0
	i32.const	$push160=, 1103515245
	i32.mul 	$push7=, $0, $pop160
	i32.const	$push159=, 12345
	i32.add 	$push158=, $pop7, $pop159
	tee_local	$push157=, $0=, $pop158
	i32.const	$push156=, 16
	i32.shr_u	$push8=, $pop157, $pop156
	i32.store8	sI+1($pop161), $pop8
	i32.const	$push155=, 0
	i32.const	$push154=, 1103515245
	i32.mul 	$push9=, $0, $pop154
	i32.const	$push153=, 12345
	i32.add 	$push152=, $pop9, $pop153
	tee_local	$push151=, $0=, $pop152
	i32.const	$push150=, 16
	i32.shr_u	$push10=, $pop151, $pop150
	i32.store8	sI+2($pop155), $pop10
	i32.const	$push149=, 0
	i32.const	$push148=, 1103515245
	i32.mul 	$push11=, $0, $pop148
	i32.const	$push147=, 12345
	i32.add 	$push146=, $pop11, $pop147
	tee_local	$push145=, $0=, $pop146
	i32.const	$push144=, 16
	i32.shr_u	$push12=, $pop145, $pop144
	i32.store8	sI+3($pop149), $pop12
	i32.const	$push143=, 0
	i32.const	$push142=, 1103515245
	i32.mul 	$push13=, $0, $pop142
	i32.const	$push141=, 12345
	i32.add 	$push140=, $pop13, $pop141
	tee_local	$push139=, $0=, $pop140
	i32.const	$push138=, 16
	i32.shr_u	$push14=, $pop139, $pop138
	i32.store8	sI+4($pop143), $pop14
	i32.const	$push137=, 0
	i32.const	$push136=, 1103515245
	i32.mul 	$push15=, $0, $pop136
	i32.const	$push135=, 12345
	i32.add 	$push134=, $pop15, $pop135
	tee_local	$push133=, $0=, $pop134
	i32.const	$push132=, 16
	i32.shr_u	$push16=, $pop133, $pop132
	i32.store8	sI+5($pop137), $pop16
	i32.const	$push131=, 0
	i32.const	$push130=, 1103515245
	i32.mul 	$push17=, $0, $pop130
	i32.const	$push129=, 12345
	i32.add 	$push128=, $pop17, $pop129
	tee_local	$push127=, $0=, $pop128
	i32.const	$push126=, 16
	i32.shr_u	$push18=, $pop127, $pop126
	i32.store8	sI+6($pop131), $pop18
	i32.const	$push125=, 0
	i32.const	$push124=, 1103515245
	i32.mul 	$push19=, $0, $pop124
	i32.const	$push123=, 12345
	i32.add 	$push122=, $pop19, $pop123
	tee_local	$push121=, $0=, $pop122
	i32.const	$push120=, 16
	i32.shr_u	$push20=, $pop121, $pop120
	i32.store8	sI+7($pop125), $pop20
	i32.const	$push119=, 0
	i32.const	$push118=, 1103515245
	i32.mul 	$push21=, $0, $pop118
	i32.const	$push117=, 12345
	i32.add 	$push116=, $pop21, $pop117
	tee_local	$push115=, $0=, $pop116
	i32.const	$push114=, 16
	i32.shr_u	$push22=, $pop115, $pop114
	i32.store8	sI+8($pop119), $pop22
	i32.const	$push113=, 0
	i32.const	$push112=, 1103515245
	i32.mul 	$push23=, $0, $pop112
	i32.const	$push111=, 12345
	i32.add 	$push110=, $pop23, $pop111
	tee_local	$push109=, $0=, $pop110
	i32.const	$push108=, 16
	i32.shr_u	$push24=, $pop109, $pop108
	i32.store8	sI+9($pop113), $pop24
	i32.const	$push107=, 0
	i32.const	$push106=, 1103515245
	i32.mul 	$push25=, $0, $pop106
	i32.const	$push105=, 12345
	i32.add 	$push104=, $pop25, $pop105
	tee_local	$push103=, $0=, $pop104
	i32.const	$push102=, 16
	i32.shr_u	$push26=, $pop103, $pop102
	i32.store8	sI+10($pop107), $pop26
	i32.const	$push101=, 0
	i32.const	$push100=, 1103515245
	i32.mul 	$push27=, $0, $pop100
	i32.const	$push99=, 12345
	i32.add 	$push98=, $pop27, $pop99
	tee_local	$push97=, $0=, $pop98
	i32.const	$push96=, 16
	i32.shr_u	$push28=, $pop97, $pop96
	i32.store8	sI+11($pop101), $pop28
	i32.const	$push95=, 0
	i32.const	$push94=, 1103515245
	i32.mul 	$push29=, $0, $pop94
	i32.const	$push93=, 12345
	i32.add 	$push92=, $pop29, $pop93
	tee_local	$push91=, $0=, $pop92
	i32.const	$push90=, 16
	i32.shr_u	$push30=, $pop91, $pop90
	i32.store8	sI+12($pop95), $pop30
	i32.const	$push89=, 0
	i32.const	$push88=, 1103515245
	i32.mul 	$push31=, $0, $pop88
	i32.const	$push87=, 12345
	i32.add 	$push86=, $pop31, $pop87
	tee_local	$push85=, $0=, $pop86
	i32.const	$push84=, 16
	i32.shr_u	$push32=, $pop85, $pop84
	i32.store8	sI+13($pop89), $pop32
	i32.const	$push83=, 0
	i32.const	$push82=, 1103515245
	i32.mul 	$push33=, $0, $pop82
	i32.const	$push81=, 12345
	i32.add 	$push80=, $pop33, $pop81
	tee_local	$push79=, $0=, $pop80
	i32.const	$push78=, 16
	i32.shr_u	$push34=, $pop79, $pop78
	i32.store8	sI+14($pop83), $pop34
	i32.const	$push77=, 0
	i32.const	$push76=, 1103515245
	i32.mul 	$push35=, $0, $pop76
	i32.const	$push75=, 12345
	i32.add 	$push74=, $pop35, $pop75
	tee_local	$push73=, $0=, $pop74
	i32.const	$push72=, 16
	i32.shr_u	$push36=, $pop73, $pop72
	i32.store8	sI+15($pop77), $pop36
	i32.const	$push71=, 0
	i32.const	$push37=, -341751747
	i32.mul 	$push38=, $0, $pop37
	i32.const	$push39=, 229283573
	i32.add 	$push70=, $pop38, $pop39
	tee_local	$push69=, $0=, $pop70
	i32.const	$push68=, 1103515245
	i32.mul 	$push40=, $pop69, $pop68
	i32.const	$push67=, 12345
	i32.add 	$push66=, $pop40, $pop67
	tee_local	$push65=, $1=, $pop66
	i32.store	myrnd.s($pop71), $pop65
	i32.const	$push64=, 0
	i32.const	$push63=, 16
	i32.shr_u	$push62=, $1, $pop63
	tee_local	$push61=, $1=, $pop62
	i32.const	$push43=, 2047
	i32.and 	$push44=, $pop61, $pop43
	i32.const	$push60=, 16
	i32.shr_u	$push59=, $0, $pop60
	tee_local	$push58=, $0=, $pop59
	i32.const	$push41=, 511
	i32.and 	$push42=, $pop58, $pop41
	i32.add 	$push57=, $pop44, $pop42
	tee_local	$push56=, $2=, $pop57
	i32.const	$push45=, 7
	i32.shl 	$push46=, $pop56, $pop45
	i32.const	$push55=, 0
	i32.load16_u	$push47=, sI($pop55)
	i32.const	$push48=, 127
	i32.and 	$push49=, $pop47, $pop48
	i32.or  	$push50=, $pop46, $pop49
	i32.store16	sI($pop64), $pop50
	block   	
	i32.add 	$push51=, $1, $0
	i32.xor 	$push52=, $pop51, $2
	i32.const	$push54=, 511
	i32.and 	$push53=, $pop52, $pop54
	br_if   	0, $pop53       # 0: down to label5
# BB#1:                                 # %if.end136
	return
.LBB54_2:                               # %if.then135
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end54:
	.size	testI, .Lfunc_end54-testI
                                        # -- End function
	.section	.text.retmeJ,"ax",@progbits
	.hidden	retmeJ                  # -- Begin function retmeJ
	.globl	retmeJ
	.type	retmeJ,@function
retmeJ:                                 # @retmeJ
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($1):p2align=1
	i32.store	0($0):p2align=1, $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end55:
	.size	retmeJ, .Lfunc_end55-retmeJ
                                        # -- End function
	.section	.text.fn1J,"ax",@progbits
	.hidden	fn1J                    # -- Begin function fn1J
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
                                        # -- End function
	.section	.text.fn2J,"ax",@progbits
	.hidden	fn2J                    # -- Begin function fn2J
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
                                        # -- End function
	.section	.text.retitJ,"ax",@progbits
	.hidden	retitJ                  # -- Begin function retitJ
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
                                        # -- End function
	.section	.text.fn3J,"ax",@progbits
	.hidden	fn3J                    # -- Begin function fn3J
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
	i32.store16	sJ($pop0), $pop6
	i32.const	$push7=, 127
	i32.and 	$push8=, $0, $pop7
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end59:
	.size	fn3J, .Lfunc_end59-fn3J
                                        # -- End function
	.section	.text.testJ,"ax",@progbits
	.hidden	testJ                   # -- Begin function testJ
	.globl	testJ
	.type	testJ,@function
testJ:                                  # @testJ
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push80=, 0
	i32.const	$push79=, 0
	i32.load	$push0=, myrnd.s($pop79)
	i32.const	$push78=, 1103515245
	i32.mul 	$push1=, $pop0, $pop78
	i32.const	$push77=, 12345
	i32.add 	$push76=, $pop1, $pop77
	tee_local	$push75=, $0=, $pop76
	i32.const	$push74=, 16
	i32.shr_u	$push2=, $pop75, $pop74
	i32.store8	sJ($pop80), $pop2
	i32.const	$push73=, 0
	i32.const	$push72=, 1103515245
	i32.mul 	$push3=, $0, $pop72
	i32.const	$push71=, 12345
	i32.add 	$push70=, $pop3, $pop71
	tee_local	$push69=, $0=, $pop70
	i32.const	$push68=, 16
	i32.shr_u	$push4=, $pop69, $pop68
	i32.store8	sJ+1($pop73), $pop4
	i32.const	$push67=, 0
	i32.const	$push66=, 1103515245
	i32.mul 	$push5=, $0, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push64=, $pop5, $pop65
	tee_local	$push63=, $0=, $pop64
	i32.const	$push62=, 16
	i32.shr_u	$push6=, $pop63, $pop62
	i32.store8	sJ+2($pop67), $pop6
	i32.const	$push61=, 0
	i32.const	$push60=, 1103515245
	i32.mul 	$push7=, $0, $pop60
	i32.const	$push59=, 12345
	i32.add 	$push58=, $pop7, $pop59
	tee_local	$push57=, $0=, $pop58
	i32.const	$push56=, 16
	i32.shr_u	$push8=, $pop57, $pop56
	i32.store8	sJ+3($pop61), $pop8
	i32.const	$push55=, 0
	i32.const	$push54=, 0
	i32.load16_u	$push9=, sJ($pop54)
	i32.const	$push10=, 511
	i32.and 	$push53=, $pop9, $pop10
	tee_local	$push52=, $1=, $pop53
	i32.const	$push51=, 1103515245
	i32.mul 	$push11=, $0, $pop51
	i32.const	$push50=, 12345
	i32.add 	$push49=, $pop11, $pop50
	tee_local	$push48=, $0=, $pop49
	i32.const	$push47=, 16
	i32.shr_u	$push46=, $pop48, $pop47
	tee_local	$push45=, $2=, $pop46
	i32.const	$push44=, 9
	i32.shl 	$push12=, $pop45, $pop44
	i32.or  	$push13=, $pop52, $pop12
	i32.store16	sJ($pop55), $pop13
	i32.const	$push43=, 0
	i32.const	$push42=, 1103515245
	i32.mul 	$push14=, $0, $pop42
	i32.const	$push41=, 12345
	i32.add 	$push40=, $pop14, $pop41
	tee_local	$push39=, $0=, $pop40
	i32.store	myrnd.s($pop43), $pop39
	block   	
	i32.const	$push38=, 16
	i32.shr_u	$push37=, $0, $pop38
	tee_local	$push36=, $3=, $pop37
	i32.add 	$push15=, $pop36, $2
	i32.const	$push35=, 0
	i32.load	$push16=, sJ($pop35)
	i32.const	$push34=, 9
	i32.shr_u	$push17=, $pop16, $pop34
	i32.add 	$push18=, $3, $pop17
	i32.xor 	$push19=, $pop15, $pop18
	i32.const	$push33=, 127
	i32.and 	$push20=, $pop19, $pop33
	br_if   	0, $pop20       # 0: down to label6
# BB#1:                                 # %lor.lhs.false136
	i32.const	$push99=, 0
	i32.const	$push21=, -2139243339
	i32.mul 	$push22=, $0, $pop21
	i32.const	$push23=, -1492899873
	i32.add 	$push98=, $pop22, $pop23
	tee_local	$push97=, $0=, $pop98
	i32.const	$push96=, 1103515245
	i32.mul 	$push24=, $pop97, $pop96
	i32.const	$push95=, 12345
	i32.add 	$push94=, $pop24, $pop95
	tee_local	$push93=, $2=, $pop94
	i32.store	myrnd.s($pop99), $pop93
	i32.const	$push92=, 0
	i32.const	$push91=, 16
	i32.shr_u	$push90=, $2, $pop91
	tee_local	$push89=, $2=, $pop90
	i32.const	$push26=, 2047
	i32.and 	$push27=, $pop89, $pop26
	i32.const	$push88=, 16
	i32.shr_u	$push87=, $0, $pop88
	tee_local	$push86=, $0=, $pop87
	i32.const	$push85=, 127
	i32.and 	$push25=, $pop86, $pop85
	i32.add 	$push84=, $pop27, $pop25
	tee_local	$push83=, $3=, $pop84
	i32.const	$push82=, 9
	i32.shl 	$push28=, $pop83, $pop82
	i32.or  	$push29=, $pop28, $1
	i32.store16	sJ($pop92), $pop29
	i32.add 	$push30=, $2, $0
	i32.xor 	$push31=, $pop30, $3
	i32.const	$push81=, 127
	i32.and 	$push32=, $pop31, $pop81
	br_if   	0, $pop32       # 0: down to label6
# BB#2:                                 # %if.end142
	return
.LBB60_3:                               # %if.then
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end60:
	.size	testJ, .Lfunc_end60-testJ
                                        # -- End function
	.section	.text.retmeK,"ax",@progbits
	.hidden	retmeK                  # -- Begin function retmeK
	.globl	retmeK
	.type	retmeK,@function
retmeK:                                 # @retmeK
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($1)
	i32.store	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end61:
	.size	retmeK, .Lfunc_end61-retmeK
                                        # -- End function
	.section	.text.fn1K,"ax",@progbits
	.hidden	fn1K                    # -- Begin function fn1K
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
                                        # -- End function
	.section	.text.fn2K,"ax",@progbits
	.hidden	fn2K                    # -- Begin function fn2K
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
                                        # -- End function
	.section	.text.retitK,"ax",@progbits
	.hidden	retitK                  # -- Begin function retitK
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
                                        # -- End function
	.section	.text.fn3K,"ax",@progbits
	.hidden	fn3K                    # -- Begin function fn3K
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
	i32.store	sK($pop0), $pop5
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end65:
	.size	fn3K, .Lfunc_end65-fn3K
                                        # -- End function
	.section	.text.testK,"ax",@progbits
	.hidden	testK                   # -- Begin function testK
	.globl	testK
	.type	testK,@function
testK:                                  # @testK
	.local  	i32, i32
# BB#0:                                 # %if.end129
	i32.const	$push0=, 0
	i32.const	$push57=, 0
	i32.load	$push1=, myrnd.s($pop57)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push56=, $pop3, $pop4
	tee_local	$push55=, $0=, $pop56
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop55, $pop5
	i32.store8	sK($pop0), $pop6
	i32.const	$push54=, 0
	i32.const	$push53=, 1103515245
	i32.mul 	$push7=, $0, $pop53
	i32.const	$push52=, 12345
	i32.add 	$push51=, $pop7, $pop52
	tee_local	$push50=, $0=, $pop51
	i32.const	$push49=, 16
	i32.shr_u	$push8=, $pop50, $pop49
	i32.store8	sK+1($pop54), $pop8
	i32.const	$push48=, 0
	i32.const	$push47=, 1103515245
	i32.mul 	$push9=, $0, $pop47
	i32.const	$push46=, 12345
	i32.add 	$push45=, $pop9, $pop46
	tee_local	$push44=, $0=, $pop45
	i32.const	$push43=, 16
	i32.shr_u	$push10=, $pop44, $pop43
	i32.store8	sK+2($pop48), $pop10
	i32.const	$push42=, 0
	i32.const	$push41=, 1103515245
	i32.mul 	$push11=, $0, $pop41
	i32.const	$push40=, 12345
	i32.add 	$push39=, $pop11, $pop40
	tee_local	$push38=, $0=, $pop39
	i32.const	$push37=, 16
	i32.shr_u	$push12=, $pop38, $pop37
	i32.store8	sK+3($pop42), $pop12
	i32.const	$push36=, 0
	i32.const	$push13=, -341751747
	i32.mul 	$push14=, $0, $pop13
	i32.const	$push15=, 229283573
	i32.add 	$push35=, $pop14, $pop15
	tee_local	$push34=, $0=, $pop35
	i32.const	$push33=, 1103515245
	i32.mul 	$push16=, $pop34, $pop33
	i32.const	$push32=, 12345
	i32.add 	$push31=, $pop16, $pop32
	tee_local	$push30=, $1=, $pop31
	i32.store	myrnd.s($pop36), $pop30
	i32.const	$push29=, 0
	i32.const	$push28=, 16
	i32.shr_u	$push18=, $1, $pop28
	i32.const	$push27=, 16
	i32.shr_u	$push17=, $0, $pop27
	i32.add 	$push19=, $pop18, $pop17
	i32.const	$push20=, 63
	i32.and 	$push21=, $pop19, $pop20
	i32.const	$push26=, 0
	i32.load	$push22=, sK($pop26)
	i32.const	$push23=, -64
	i32.and 	$push24=, $pop22, $pop23
	i32.or  	$push25=, $pop21, $pop24
	i32.store	sK($pop29), $pop25
                                        # fallthrough-return
	.endfunc
.Lfunc_end66:
	.size	testK, .Lfunc_end66-testK
                                        # -- End function
	.section	.text.retmeL,"ax",@progbits
	.hidden	retmeL                  # -- Begin function retmeL
	.globl	retmeL
	.type	retmeL,@function
retmeL:                                 # @retmeL
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1):p2align=2
	i64.store	0($0):p2align=2, $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end67:
	.size	retmeL, .Lfunc_end67-retmeL
                                        # -- End function
	.section	.text.fn1L,"ax",@progbits
	.hidden	fn1L                    # -- Begin function fn1L
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
                                        # -- End function
	.section	.text.fn2L,"ax",@progbits
	.hidden	fn2L                    # -- Begin function fn2L
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
                                        # -- End function
	.section	.text.retitL,"ax",@progbits
	.hidden	retitL                  # -- Begin function retitL
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
                                        # -- End function
	.section	.text.fn3L,"ax",@progbits
	.hidden	fn3L                    # -- Begin function fn3L
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
	i32.store	sL($pop0), $pop5
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end71:
	.size	fn3L, .Lfunc_end71-fn3L
                                        # -- End function
	.section	.text.testL,"ax",@progbits
	.hidden	testL                   # -- Begin function testL
	.globl	testL
	.type	testL,@function
testL:                                  # @testL
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push106=, 0
	i32.const	$push105=, 0
	i32.load	$push0=, myrnd.s($pop105)
	i32.const	$push104=, 1103515245
	i32.mul 	$push1=, $pop0, $pop104
	i32.const	$push103=, 12345
	i32.add 	$push102=, $pop1, $pop103
	tee_local	$push101=, $0=, $pop102
	i32.const	$push100=, 16
	i32.shr_u	$push2=, $pop101, $pop100
	i32.store8	sL($pop106), $pop2
	i32.const	$push99=, 0
	i32.const	$push98=, 1103515245
	i32.mul 	$push3=, $0, $pop98
	i32.const	$push97=, 12345
	i32.add 	$push96=, $pop3, $pop97
	tee_local	$push95=, $0=, $pop96
	i32.const	$push94=, 16
	i32.shr_u	$push4=, $pop95, $pop94
	i32.store8	sL+1($pop99), $pop4
	i32.const	$push93=, 0
	i32.const	$push92=, 1103515245
	i32.mul 	$push5=, $0, $pop92
	i32.const	$push91=, 12345
	i32.add 	$push90=, $pop5, $pop91
	tee_local	$push89=, $0=, $pop90
	i32.const	$push88=, 16
	i32.shr_u	$push6=, $pop89, $pop88
	i32.store8	sL+2($pop93), $pop6
	i32.const	$push87=, 0
	i32.const	$push86=, 1103515245
	i32.mul 	$push7=, $0, $pop86
	i32.const	$push85=, 12345
	i32.add 	$push84=, $pop7, $pop85
	tee_local	$push83=, $0=, $pop84
	i32.const	$push82=, 16
	i32.shr_u	$push8=, $pop83, $pop82
	i32.store8	sL+3($pop87), $pop8
	i32.const	$push81=, 0
	i32.const	$push80=, 1103515245
	i32.mul 	$push9=, $0, $pop80
	i32.const	$push79=, 12345
	i32.add 	$push78=, $pop9, $pop79
	tee_local	$push77=, $0=, $pop78
	i32.const	$push76=, 16
	i32.shr_u	$push10=, $pop77, $pop76
	i32.store8	sL+4($pop81), $pop10
	i32.const	$push75=, 0
	i32.const	$push74=, 1103515245
	i32.mul 	$push11=, $0, $pop74
	i32.const	$push73=, 12345
	i32.add 	$push72=, $pop11, $pop73
	tee_local	$push71=, $0=, $pop72
	i32.const	$push70=, 16
	i32.shr_u	$push12=, $pop71, $pop70
	i32.store8	sL+5($pop75), $pop12
	i32.const	$push69=, 0
	i32.const	$push68=, 1103515245
	i32.mul 	$push13=, $0, $pop68
	i32.const	$push67=, 12345
	i32.add 	$push66=, $pop13, $pop67
	tee_local	$push65=, $0=, $pop66
	i32.const	$push64=, 16
	i32.shr_u	$push14=, $pop65, $pop64
	i32.store8	sL+6($pop69), $pop14
	i32.const	$push63=, 0
	i32.const	$push62=, 1103515245
	i32.mul 	$push15=, $0, $pop62
	i32.const	$push61=, 12345
	i32.add 	$push60=, $pop15, $pop61
	tee_local	$push59=, $0=, $pop60
	i32.const	$push58=, 16
	i32.shr_u	$push16=, $pop59, $pop58
	i32.store8	sL+7($pop63), $pop16
	i32.const	$push57=, 0
	i32.const	$push56=, 1103515245
	i32.mul 	$push17=, $0, $pop56
	i32.const	$push55=, 12345
	i32.add 	$push54=, $pop17, $pop55
	tee_local	$push53=, $2=, $pop54
	i32.const	$push52=, 1103515245
	i32.mul 	$push18=, $pop53, $pop52
	i32.const	$push51=, 12345
	i32.add 	$push50=, $pop18, $pop51
	tee_local	$push49=, $0=, $pop50
	i32.store	myrnd.s($pop57), $pop49
	i32.const	$push48=, 0
	i32.const	$push47=, 16
	i32.shr_u	$push46=, $2, $pop47
	tee_local	$push45=, $2=, $pop46
	i32.const	$push44=, 63
	i32.and 	$push21=, $pop45, $pop44
	i32.const	$push43=, 0
	i32.load	$push19=, sL($pop43)
	i32.const	$push20=, -64
	i32.and 	$push42=, $pop19, $pop20
	tee_local	$push41=, $1=, $pop42
	i32.or  	$push40=, $pop21, $pop41
	tee_local	$push39=, $3=, $pop40
	i32.store	sL($pop48), $pop39
	block   	
	i32.const	$push38=, 16
	i32.shr_u	$push37=, $0, $pop38
	tee_local	$push36=, $4=, $pop37
	i32.add 	$push23=, $pop36, $2
	i32.add 	$push22=, $4, $3
	i32.xor 	$push24=, $pop23, $pop22
	i32.const	$push35=, 63
	i32.and 	$push25=, $pop24, $pop35
	br_if   	0, $pop25       # 0: down to label7
# BB#1:                                 # %if.end113
	i32.const	$push117=, 0
	i32.const	$push26=, -2139243339
	i32.mul 	$push27=, $0, $pop26
	i32.const	$push28=, -1492899873
	i32.add 	$push116=, $pop27, $pop28
	tee_local	$push115=, $0=, $pop116
	i32.const	$push114=, 1103515245
	i32.mul 	$push29=, $pop115, $pop114
	i32.const	$push113=, 12345
	i32.add 	$push112=, $pop29, $pop113
	tee_local	$push111=, $2=, $pop112
	i32.store	myrnd.s($pop117), $pop111
	i32.const	$push110=, 0
	i32.const	$push109=, 16
	i32.shr_u	$push31=, $2, $pop109
	i32.const	$push108=, 16
	i32.shr_u	$push30=, $0, $pop108
	i32.add 	$push32=, $pop31, $pop30
	i32.const	$push107=, 63
	i32.and 	$push33=, $pop32, $pop107
	i32.or  	$push34=, $pop33, $1
	i32.store	sL($pop110), $pop34
	return
.LBB72_2:                               # %if.then
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end72:
	.size	testL, .Lfunc_end72-testL
                                        # -- End function
	.section	.text.retmeM,"ax",@progbits
	.hidden	retmeM                  # -- Begin function retmeM
	.globl	retmeM
	.type	retmeM,@function
retmeM:                                 # @retmeM
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1):p2align=2
	i64.store	0($0):p2align=2, $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end73:
	.size	retmeM, .Lfunc_end73-retmeM
                                        # -- End function
	.section	.text.fn1M,"ax",@progbits
	.hidden	fn1M                    # -- Begin function fn1M
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
                                        # -- End function
	.section	.text.fn2M,"ax",@progbits
	.hidden	fn2M                    # -- Begin function fn2M
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
                                        # -- End function
	.section	.text.retitM,"ax",@progbits
	.hidden	retitM                  # -- Begin function retitM
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
                                        # -- End function
	.section	.text.fn3M,"ax",@progbits
	.hidden	fn3M                    # -- Begin function fn3M
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
	i32.store	sM+4($pop0), $pop5
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end77:
	.size	fn3M, .Lfunc_end77-fn3M
                                        # -- End function
	.section	.text.testM,"ax",@progbits
	.hidden	testM                   # -- Begin function testM
	.globl	testM
	.type	testM,@function
testM:                                  # @testM
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push106=, 0
	i32.const	$push105=, 0
	i32.load	$push0=, myrnd.s($pop105)
	i32.const	$push104=, 1103515245
	i32.mul 	$push1=, $pop0, $pop104
	i32.const	$push103=, 12345
	i32.add 	$push102=, $pop1, $pop103
	tee_local	$push101=, $0=, $pop102
	i32.const	$push100=, 1103515245
	i32.mul 	$push2=, $pop101, $pop100
	i32.const	$push99=, 12345
	i32.add 	$push98=, $pop2, $pop99
	tee_local	$push97=, $1=, $pop98
	i32.const	$push96=, 1103515245
	i32.mul 	$push3=, $pop97, $pop96
	i32.const	$push95=, 12345
	i32.add 	$push94=, $pop3, $pop95
	tee_local	$push93=, $2=, $pop94
	i32.const	$push92=, 1103515245
	i32.mul 	$push4=, $pop93, $pop92
	i32.const	$push91=, 12345
	i32.add 	$push90=, $pop4, $pop91
	tee_local	$push89=, $3=, $pop90
	i32.const	$push88=, 1103515245
	i32.mul 	$push5=, $pop89, $pop88
	i32.const	$push87=, 12345
	i32.add 	$push86=, $pop5, $pop87
	tee_local	$push85=, $4=, $pop86
	i32.const	$push84=, 16
	i32.shr_u	$push6=, $pop85, $pop84
	i32.store8	sM+4($pop106), $pop6
	i32.const	$push83=, 0
	i32.const	$push82=, 1103515245
	i32.mul 	$push7=, $4, $pop82
	i32.const	$push81=, 12345
	i32.add 	$push80=, $pop7, $pop81
	tee_local	$push79=, $4=, $pop80
	i32.const	$push78=, 16
	i32.shr_u	$push8=, $pop79, $pop78
	i32.store8	sM+5($pop83), $pop8
	i32.const	$push77=, 0
	i32.const	$push76=, 1103515245
	i32.mul 	$push9=, $4, $pop76
	i32.const	$push75=, 12345
	i32.add 	$push74=, $pop9, $pop75
	tee_local	$push73=, $4=, $pop74
	i32.const	$push72=, 16
	i32.shr_u	$push10=, $pop73, $pop72
	i32.store8	sM+6($pop77), $pop10
	i32.const	$push71=, 0
	i32.const	$push70=, 1103515245
	i32.mul 	$push11=, $4, $pop70
	i32.const	$push69=, 12345
	i32.add 	$push68=, $pop11, $pop69
	tee_local	$push67=, $4=, $pop68
	i32.const	$push66=, 16
	i32.shr_u	$push12=, $pop67, $pop66
	i32.store8	sM+7($pop71), $pop12
	i32.const	$push65=, 0
	i32.const	$push64=, 16
	i32.shr_u	$push13=, $0, $pop64
	i32.store8	sM($pop65), $pop13
	i32.const	$push63=, 0
	i32.const	$push62=, 16
	i32.shr_u	$push14=, $1, $pop62
	i32.store8	sM+1($pop63), $pop14
	i32.const	$push61=, 0
	i32.const	$push60=, 16
	i32.shr_u	$push15=, $2, $pop60
	i32.store8	sM+2($pop61), $pop15
	i32.const	$push59=, 0
	i32.const	$push58=, 16
	i32.shr_u	$push16=, $3, $pop58
	i32.store8	sM+3($pop59), $pop16
	i32.const	$push57=, 0
	i32.const	$push56=, 1103515245
	i32.mul 	$push17=, $4, $pop56
	i32.const	$push55=, 12345
	i32.add 	$push54=, $pop17, $pop55
	tee_local	$push53=, $1=, $pop54
	i32.const	$push52=, 1103515245
	i32.mul 	$push18=, $pop53, $pop52
	i32.const	$push51=, 12345
	i32.add 	$push50=, $pop18, $pop51
	tee_local	$push49=, $0=, $pop50
	i32.store	myrnd.s($pop57), $pop49
	i32.const	$push48=, 0
	i32.const	$push47=, 16
	i32.shr_u	$push46=, $1, $pop47
	tee_local	$push45=, $1=, $pop46
	i32.const	$push44=, 63
	i32.and 	$push21=, $pop45, $pop44
	i32.const	$push43=, 0
	i32.load	$push19=, sM+4($pop43)
	i32.const	$push20=, -64
	i32.and 	$push42=, $pop19, $pop20
	tee_local	$push41=, $2=, $pop42
	i32.or  	$push40=, $pop21, $pop41
	tee_local	$push39=, $3=, $pop40
	i32.store	sM+4($pop48), $pop39
	block   	
	i32.const	$push38=, 16
	i32.shr_u	$push37=, $0, $pop38
	tee_local	$push36=, $4=, $pop37
	i32.add 	$push23=, $pop36, $1
	i32.add 	$push22=, $4, $3
	i32.xor 	$push24=, $pop23, $pop22
	i32.const	$push35=, 63
	i32.and 	$push25=, $pop24, $pop35
	br_if   	0, $pop25       # 0: down to label8
# BB#1:                                 # %if.end119
	i32.const	$push117=, 0
	i32.const	$push26=, -2139243339
	i32.mul 	$push27=, $0, $pop26
	i32.const	$push28=, -1492899873
	i32.add 	$push116=, $pop27, $pop28
	tee_local	$push115=, $0=, $pop116
	i32.const	$push114=, 1103515245
	i32.mul 	$push29=, $pop115, $pop114
	i32.const	$push113=, 12345
	i32.add 	$push112=, $pop29, $pop113
	tee_local	$push111=, $1=, $pop112
	i32.store	myrnd.s($pop117), $pop111
	i32.const	$push110=, 0
	i32.const	$push109=, 16
	i32.shr_u	$push31=, $1, $pop109
	i32.const	$push108=, 16
	i32.shr_u	$push30=, $0, $pop108
	i32.add 	$push32=, $pop31, $pop30
	i32.const	$push107=, 63
	i32.and 	$push33=, $pop32, $pop107
	i32.or  	$push34=, $pop33, $2
	i32.store	sM+4($pop110), $pop34
	return
.LBB78_2:                               # %if.then
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end78:
	.size	testM, .Lfunc_end78-testM
                                        # -- End function
	.section	.text.retmeN,"ax",@progbits
	.hidden	retmeN                  # -- Begin function retmeN
	.globl	retmeN
	.type	retmeN,@function
retmeN:                                 # @retmeN
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	0($0), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end79:
	.size	retmeN, .Lfunc_end79-retmeN
                                        # -- End function
	.section	.text.fn1N,"ax",@progbits
	.hidden	fn1N                    # -- Begin function fn1N
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
                                        # -- End function
	.section	.text.fn2N,"ax",@progbits
	.hidden	fn2N                    # -- Begin function fn2N
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
                                        # -- End function
	.section	.text.retitN,"ax",@progbits
	.hidden	retitN                  # -- Begin function retitN
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
                                        # -- End function
	.section	.text.fn3N,"ax",@progbits
	.hidden	fn3N                    # -- Begin function fn3N
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
	i64.const	$push1=, -4033
	i64.and 	$push2=, $pop16, $pop1
	i64.const	$push3=, 6
	i64.shr_u	$push4=, $1, $pop3
	i32.wrap/i64	$push5=, $pop4
	i32.add 	$push15=, $pop5, $0
	tee_local	$push14=, $0=, $pop15
	i32.const	$push6=, 6
	i32.shl 	$push7=, $pop14, $pop6
	i32.const	$push8=, 4032
	i32.and 	$push9=, $pop7, $pop8
	i64.extend_u/i32	$push10=, $pop9
	i64.or  	$push11=, $pop2, $pop10
	i64.store	sN($pop0), $pop11
	i32.const	$push12=, 63
	i32.and 	$push13=, $0, $pop12
                                        # fallthrough-return: $pop13
	.endfunc
.Lfunc_end83:
	.size	fn3N, .Lfunc_end83-fn3N
                                        # -- End function
	.section	.text.testN,"ax",@progbits
	.hidden	testN                   # -- Begin function testN
	.globl	testN
	.type	testN,@function
testN:                                  # @testN
	.local  	i64, i32, i32, i32, i64, i64, i32, i32, i32, i64
# BB#0:                                 # %lor.lhs.false
	i32.const	$push3=, 0
	i32.const	$push173=, 0
	i32.load	$push4=, myrnd.s($pop173)
	i32.const	$push5=, 1103515245
	i32.mul 	$push6=, $pop4, $pop5
	i32.const	$push7=, 12345
	i32.add 	$push172=, $pop6, $pop7
	tee_local	$push171=, $8=, $pop172
	i32.const	$push170=, 16
	i32.shr_u	$push8=, $pop171, $pop170
	i32.store8	sN($pop3), $pop8
	i32.const	$push169=, 0
	i32.const	$push168=, 1103515245
	i32.mul 	$push9=, $8, $pop168
	i32.const	$push167=, 12345
	i32.add 	$push166=, $pop9, $pop167
	tee_local	$push165=, $8=, $pop166
	i32.const	$push164=, 16
	i32.shr_u	$push10=, $pop165, $pop164
	i32.store8	sN+1($pop169), $pop10
	i32.const	$push163=, 0
	i32.const	$push162=, 1103515245
	i32.mul 	$push11=, $8, $pop162
	i32.const	$push161=, 12345
	i32.add 	$push160=, $pop11, $pop161
	tee_local	$push159=, $8=, $pop160
	i32.const	$push158=, 16
	i32.shr_u	$push12=, $pop159, $pop158
	i32.store8	sN+2($pop163), $pop12
	i32.const	$push157=, 0
	i32.const	$push156=, 1103515245
	i32.mul 	$push13=, $8, $pop156
	i32.const	$push155=, 12345
	i32.add 	$push154=, $pop13, $pop155
	tee_local	$push153=, $8=, $pop154
	i32.const	$push152=, 16
	i32.shr_u	$push14=, $pop153, $pop152
	i32.store8	sN+3($pop157), $pop14
	i32.const	$push151=, 0
	i32.const	$push150=, 1103515245
	i32.mul 	$push15=, $8, $pop150
	i32.const	$push149=, 12345
	i32.add 	$push148=, $pop15, $pop149
	tee_local	$push147=, $8=, $pop148
	i32.const	$push146=, 16
	i32.shr_u	$push16=, $pop147, $pop146
	i32.store8	sN+4($pop151), $pop16
	i32.const	$push145=, 0
	i32.const	$push144=, 1103515245
	i32.mul 	$push17=, $8, $pop144
	i32.const	$push143=, 12345
	i32.add 	$push142=, $pop17, $pop143
	tee_local	$push141=, $8=, $pop142
	i32.const	$push140=, 16
	i32.shr_u	$push18=, $pop141, $pop140
	i32.store8	sN+5($pop145), $pop18
	i32.const	$push139=, 0
	i32.const	$push138=, 1103515245
	i32.mul 	$push19=, $8, $pop138
	i32.const	$push137=, 12345
	i32.add 	$push136=, $pop19, $pop137
	tee_local	$push135=, $8=, $pop136
	i32.const	$push134=, 16
	i32.shr_u	$push20=, $pop135, $pop134
	i32.store8	sN+6($pop139), $pop20
	i32.const	$push133=, 0
	i32.const	$push132=, 1103515245
	i32.mul 	$push21=, $8, $pop132
	i32.const	$push131=, 12345
	i32.add 	$push130=, $pop21, $pop131
	tee_local	$push129=, $8=, $pop130
	i32.const	$push128=, 16
	i32.shr_u	$push22=, $pop129, $pop128
	i32.store8	sN+7($pop133), $pop22
	i32.const	$push127=, 0
	i32.const	$push126=, 1103515245
	i32.mul 	$push23=, $8, $pop126
	i32.const	$push125=, 12345
	i32.add 	$push124=, $pop23, $pop125
	tee_local	$push123=, $8=, $pop124
	i32.const	$push122=, 1103515245
	i32.mul 	$push24=, $pop123, $pop122
	i32.const	$push121=, 12345
	i32.add 	$push120=, $pop24, $pop121
	tee_local	$push119=, $1=, $pop120
	i32.store	myrnd.s($pop127), $pop119
	i32.const	$push118=, 0
	i32.const	$push117=, 0
	i64.load	$push116=, sN($pop117)
	tee_local	$push115=, $0=, $pop116
	i64.const	$push25=, -4033
	i64.and 	$push114=, $pop115, $pop25
	tee_local	$push113=, $4=, $pop114
	i32.const	$push26=, 10
	i32.shr_u	$push27=, $8, $pop26
	i32.const	$push28=, 4032
	i32.and 	$push112=, $pop27, $pop28
	tee_local	$push111=, $3=, $pop112
	i64.extend_u/i32	$push29=, $pop111
	i64.or  	$push110=, $pop113, $pop29
	tee_local	$push109=, $5=, $pop110
	i64.store	sN($pop118), $pop109
	block   	
	i64.const	$push32=, 4032
	i64.or  	$push33=, $0, $pop32
	i64.xor 	$push108=, $5, $pop33
	tee_local	$push107=, $9=, $pop108
	i64.const	$push34=, 34359734272
	i64.and 	$push35=, $pop107, $pop34
	i64.const	$push106=, 0
	i64.ne  	$push36=, $pop35, $pop106
	br_if   	0, $pop36       # 0: down to label9
# BB#1:                                 # %lor.lhs.false29
	i64.const	$push41=, 63
	i64.and 	$push42=, $9, $pop41
	i64.const	$push174=, 0
	i64.ne  	$push43=, $pop42, $pop174
	br_if   	0, $pop43       # 0: down to label9
# BB#2:                                 # %lor.lhs.false29
	i32.const	$push40=, 6
	i32.shr_u	$push37=, $3, $pop40
	i64.const	$push30=, 6
	i64.shr_u	$push31=, $5, $pop30
	i32.wrap/i64	$push176=, $pop31
	tee_local	$push175=, $3=, $pop176
	i32.const	$push39=, 63
	i32.and 	$push38=, $pop175, $pop39
	i32.ne  	$push44=, $pop37, $pop38
	br_if   	0, $pop44       # 0: down to label9
# BB#3:                                 # %lor.lhs.false49
	i32.const	$push181=, 16
	i32.shr_u	$push180=, $1, $pop181
	tee_local	$push179=, $2=, $pop180
	i32.add 	$push1=, $pop179, $3
	i32.const	$push178=, 16
	i32.shr_u	$push0=, $8, $pop178
	i32.add 	$push45=, $2, $pop0
	i32.xor 	$push46=, $pop1, $pop45
	i32.const	$push177=, 63
	i32.and 	$push47=, $pop46, $pop177
	br_if   	0, $pop47       # 0: down to label9
# BB#4:                                 # %lor.lhs.false69
	i32.const	$push52=, 0
	i32.const	$push48=, 1103515245
	i32.mul 	$push49=, $1, $pop48
	i32.const	$push50=, 12345
	i32.add 	$push201=, $pop49, $pop50
	tee_local	$push200=, $8=, $pop201
	i32.const	$push199=, 1103515245
	i32.mul 	$push51=, $pop200, $pop199
	i32.const	$push198=, 12345
	i32.add 	$push197=, $pop51, $pop198
	tee_local	$push196=, $1=, $pop197
	i32.store	myrnd.s($pop52), $pop196
	i32.const	$push195=, 0
	i32.const	$push53=, 10
	i32.shr_u	$push54=, $8, $pop53
	i32.const	$push55=, 4032
	i32.and 	$push194=, $pop54, $pop55
	tee_local	$push193=, $3=, $pop194
	i64.extend_u/i32	$push56=, $pop193
	i64.or  	$push192=, $4, $pop56
	tee_local	$push191=, $9=, $pop192
	i64.store	sN($pop195), $pop191
	i32.const	$push190=, 16
	i32.shr_u	$push189=, $1, $pop190
	tee_local	$push188=, $2=, $pop189
	i64.const	$push57=, 6
	i64.shr_u	$push58=, $9, $pop57
	i32.wrap/i64	$push187=, $pop58
	tee_local	$push186=, $6=, $pop187
	i32.add 	$push59=, $pop188, $pop186
	i32.const	$push185=, 63
	i32.and 	$push60=, $pop59, $pop185
	i32.const	$push61=, 15
	i32.rem_u	$7=, $pop60, $pop61
	i64.xor 	$push184=, $9, $5
	tee_local	$push183=, $5=, $pop184
	i64.const	$push62=, 34359734272
	i64.and 	$push63=, $pop183, $pop62
	i64.const	$push182=, 0
	i64.ne  	$push64=, $pop63, $pop182
	br_if   	0, $pop64       # 0: down to label9
# BB#5:                                 # %lor.lhs.false80
	i64.const	$push69=, 63
	i64.and 	$push70=, $5, $pop69
	i64.const	$push202=, 0
	i64.ne  	$push71=, $pop70, $pop202
	br_if   	0, $pop71       # 0: down to label9
# BB#6:                                 # %lor.lhs.false80
	i32.const	$push68=, 6
	i32.shr_u	$push65=, $3, $pop68
	i32.const	$push67=, 63
	i32.and 	$push66=, $6, $pop67
	i32.ne  	$push72=, $pop65, $pop66
	br_if   	0, $pop72       # 0: down to label9
# BB#7:                                 # %lor.lhs.false100
	i32.const	$push204=, 16
	i32.shr_u	$push2=, $8, $pop204
	i32.add 	$push73=, $2, $pop2
	i32.const	$push203=, 63
	i32.and 	$push74=, $pop73, $pop203
	i32.const	$push75=, 15
	i32.rem_u	$push76=, $pop74, $pop75
	i32.ne  	$push77=, $pop76, $7
	br_if   	0, $pop77       # 0: down to label9
# BB#8:                                 # %lor.lhs.false125
	i32.const	$push82=, 0
	i32.const	$push78=, 1103515245
	i32.mul 	$push79=, $1, $pop78
	i32.const	$push80=, 12345
	i32.add 	$push218=, $pop79, $pop80
	tee_local	$push217=, $8=, $pop218
	i32.const	$push216=, 1103515245
	i32.mul 	$push81=, $pop217, $pop216
	i32.const	$push215=, 12345
	i32.add 	$push214=, $pop81, $pop215
	tee_local	$push213=, $1=, $pop214
	i32.store	myrnd.s($pop82), $pop213
	i32.const	$push212=, 0
	i32.const	$push94=, 16
	i32.shr_u	$push211=, $1, $pop94
	tee_local	$push210=, $1=, $pop211
	i32.const	$push95=, 2047
	i32.and 	$push96=, $pop210, $pop95
	i64.const	$push83=, 274877902848
	i64.and 	$push84=, $0, $pop83
	i32.const	$push85=, 10
	i32.shr_u	$push86=, $8, $pop85
	i32.const	$push87=, 4032
	i32.and 	$push88=, $pop86, $pop87
	i64.extend_u/i32	$push89=, $pop88
	i64.or  	$push90=, $pop84, $pop89
	i64.const	$push91=, 6
	i64.shr_u	$push92=, $pop90, $pop91
	i32.wrap/i64	$push93=, $pop92
	i32.add 	$push209=, $pop96, $pop93
	tee_local	$push208=, $3=, $pop209
	i32.const	$push97=, 6
	i32.shl 	$push98=, $pop208, $pop97
	i32.const	$push207=, 4032
	i32.and 	$push99=, $pop98, $pop207
	i64.extend_u/i32	$push100=, $pop99
	i64.or  	$push101=, $4, $pop100
	i64.store	sN($pop212), $pop101
	i32.const	$push206=, 16
	i32.shr_u	$push102=, $8, $pop206
	i32.add 	$push103=, $1, $pop102
	i32.xor 	$push104=, $pop103, $3
	i32.const	$push205=, 63
	i32.and 	$push105=, $pop104, $pop205
	br_if   	0, $pop105      # 0: down to label9
# BB#9:                                 # %if.end158
	return
.LBB84_10:                              # %if.then
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end84:
	.size	testN, .Lfunc_end84-testN
                                        # -- End function
	.section	.text.retmeO,"ax",@progbits
	.hidden	retmeO                  # -- Begin function retmeO
	.globl	retmeO
	.type	retmeO,@function
retmeO:                                 # @retmeO
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	0($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end85:
	.size	retmeO, .Lfunc_end85-retmeO
                                        # -- End function
	.section	.text.fn1O,"ax",@progbits
	.hidden	fn1O                    # -- Begin function fn1O
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
                                        # -- End function
	.section	.text.fn2O,"ax",@progbits
	.hidden	fn2O                    # -- Begin function fn2O
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
                                        # -- End function
	.section	.text.retitO,"ax",@progbits
	.hidden	retitO                  # -- Begin function retitO
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
                                        # -- End function
	.section	.text.fn3O,"ax",@progbits
	.hidden	fn3O                    # -- Begin function fn3O
	.globl	fn3O
	.type	fn3O,@function
fn3O:                                   # @fn3O
	.param  	i32
	.result 	i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push12=, 0
	i64.load	$push11=, sO+8($pop12)
	tee_local	$push10=, $1=, $pop11
	i64.const	$push1=, -4096
	i64.and 	$push2=, $pop10, $pop1
	i32.wrap/i64	$push3=, $1
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 4095
	i32.and 	$push9=, $pop4, $pop5
	tee_local	$push8=, $0=, $pop9
	i64.extend_u/i32	$push6=, $pop8
	i64.or  	$push7=, $pop2, $pop6
	i64.store	sO+8($pop0), $pop7
	copy_local	$push13=, $0
                                        # fallthrough-return: $pop13
	.endfunc
.Lfunc_end89:
	.size	fn3O, .Lfunc_end89-fn3O
                                        # -- End function
	.section	.text.testO,"ax",@progbits
	.hidden	testO                   # -- Begin function testO
	.globl	testO
	.type	testO,@function
testO:                                  # @testO
	.local  	i32, i64, i32, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push197=, 0
	i32.load	$push3=, myrnd.s($pop197)
	i32.const	$push4=, 1103515245
	i32.mul 	$push5=, $pop3, $pop4
	i32.const	$push6=, 12345
	i32.add 	$push196=, $pop5, $pop6
	tee_local	$push195=, $0=, $pop196
	i32.const	$push194=, 16
	i32.shr_u	$push7=, $pop195, $pop194
	i32.store8	sO($pop2), $pop7
	i32.const	$push193=, 0
	i32.const	$push192=, 1103515245
	i32.mul 	$push8=, $0, $pop192
	i32.const	$push191=, 12345
	i32.add 	$push190=, $pop8, $pop191
	tee_local	$push189=, $0=, $pop190
	i32.const	$push188=, 16
	i32.shr_u	$push9=, $pop189, $pop188
	i32.store8	sO+1($pop193), $pop9
	i32.const	$push187=, 0
	i32.const	$push186=, 1103515245
	i32.mul 	$push10=, $0, $pop186
	i32.const	$push185=, 12345
	i32.add 	$push184=, $pop10, $pop185
	tee_local	$push183=, $0=, $pop184
	i32.const	$push182=, 16
	i32.shr_u	$push11=, $pop183, $pop182
	i32.store8	sO+2($pop187), $pop11
	i32.const	$push181=, 0
	i32.const	$push180=, 1103515245
	i32.mul 	$push12=, $0, $pop180
	i32.const	$push179=, 12345
	i32.add 	$push178=, $pop12, $pop179
	tee_local	$push177=, $0=, $pop178
	i32.const	$push176=, 16
	i32.shr_u	$push13=, $pop177, $pop176
	i32.store8	sO+3($pop181), $pop13
	i32.const	$push175=, 0
	i32.const	$push174=, 1103515245
	i32.mul 	$push14=, $0, $pop174
	i32.const	$push173=, 12345
	i32.add 	$push172=, $pop14, $pop173
	tee_local	$push171=, $0=, $pop172
	i32.const	$push170=, 16
	i32.shr_u	$push15=, $pop171, $pop170
	i32.store8	sO+4($pop175), $pop15
	i32.const	$push169=, 0
	i32.const	$push168=, 1103515245
	i32.mul 	$push16=, $0, $pop168
	i32.const	$push167=, 12345
	i32.add 	$push166=, $pop16, $pop167
	tee_local	$push165=, $0=, $pop166
	i32.const	$push164=, 16
	i32.shr_u	$push17=, $pop165, $pop164
	i32.store8	sO+5($pop169), $pop17
	i32.const	$push163=, 0
	i32.const	$push162=, 1103515245
	i32.mul 	$push18=, $0, $pop162
	i32.const	$push161=, 12345
	i32.add 	$push160=, $pop18, $pop161
	tee_local	$push159=, $0=, $pop160
	i32.const	$push158=, 16
	i32.shr_u	$push19=, $pop159, $pop158
	i32.store8	sO+6($pop163), $pop19
	i32.const	$push157=, 0
	i32.const	$push156=, 1103515245
	i32.mul 	$push20=, $0, $pop156
	i32.const	$push155=, 12345
	i32.add 	$push154=, $pop20, $pop155
	tee_local	$push153=, $0=, $pop154
	i32.const	$push152=, 16
	i32.shr_u	$push21=, $pop153, $pop152
	i32.store8	sO+7($pop157), $pop21
	i32.const	$push151=, 0
	i32.const	$push150=, 1103515245
	i32.mul 	$push22=, $0, $pop150
	i32.const	$push149=, 12345
	i32.add 	$push148=, $pop22, $pop149
	tee_local	$push147=, $0=, $pop148
	i32.const	$push146=, 16
	i32.shr_u	$push23=, $pop147, $pop146
	i32.store8	sO+8($pop151), $pop23
	i32.const	$push145=, 0
	i32.const	$push144=, 1103515245
	i32.mul 	$push24=, $0, $pop144
	i32.const	$push143=, 12345
	i32.add 	$push142=, $pop24, $pop143
	tee_local	$push141=, $0=, $pop142
	i32.const	$push140=, 16
	i32.shr_u	$push25=, $pop141, $pop140
	i32.store8	sO+9($pop145), $pop25
	i32.const	$push139=, 0
	i32.const	$push138=, 1103515245
	i32.mul 	$push26=, $0, $pop138
	i32.const	$push137=, 12345
	i32.add 	$push136=, $pop26, $pop137
	tee_local	$push135=, $0=, $pop136
	i32.const	$push134=, 16
	i32.shr_u	$push27=, $pop135, $pop134
	i32.store8	sO+10($pop139), $pop27
	i32.const	$push133=, 0
	i32.const	$push132=, 1103515245
	i32.mul 	$push28=, $0, $pop132
	i32.const	$push131=, 12345
	i32.add 	$push130=, $pop28, $pop131
	tee_local	$push129=, $0=, $pop130
	i32.const	$push128=, 16
	i32.shr_u	$push29=, $pop129, $pop128
	i32.store8	sO+11($pop133), $pop29
	i32.const	$push127=, 0
	i32.const	$push126=, 1103515245
	i32.mul 	$push30=, $0, $pop126
	i32.const	$push125=, 12345
	i32.add 	$push124=, $pop30, $pop125
	tee_local	$push123=, $0=, $pop124
	i32.const	$push122=, 16
	i32.shr_u	$push31=, $pop123, $pop122
	i32.store8	sO+12($pop127), $pop31
	i32.const	$push121=, 0
	i32.const	$push120=, 1103515245
	i32.mul 	$push32=, $0, $pop120
	i32.const	$push119=, 12345
	i32.add 	$push118=, $pop32, $pop119
	tee_local	$push117=, $0=, $pop118
	i32.const	$push116=, 16
	i32.shr_u	$push33=, $pop117, $pop116
	i32.store8	sO+13($pop121), $pop33
	i32.const	$push115=, 0
	i32.const	$push114=, 1103515245
	i32.mul 	$push34=, $0, $pop114
	i32.const	$push113=, 12345
	i32.add 	$push112=, $pop34, $pop113
	tee_local	$push111=, $0=, $pop112
	i32.const	$push110=, 16
	i32.shr_u	$push35=, $pop111, $pop110
	i32.store8	sO+14($pop115), $pop35
	i32.const	$push109=, 0
	i32.const	$push108=, 1103515245
	i32.mul 	$push36=, $0, $pop108
	i32.const	$push107=, 12345
	i32.add 	$push106=, $pop36, $pop107
	tee_local	$push105=, $0=, $pop106
	i32.const	$push104=, 16
	i32.shr_u	$push37=, $pop105, $pop104
	i32.store8	sO+15($pop109), $pop37
	i32.const	$push103=, 0
	i32.const	$push102=, 1103515245
	i32.mul 	$push38=, $0, $pop102
	i32.const	$push101=, 12345
	i32.add 	$push100=, $pop38, $pop101
	tee_local	$push99=, $2=, $pop100
	i32.const	$push98=, 1103515245
	i32.mul 	$push39=, $pop99, $pop98
	i32.const	$push97=, 12345
	i32.add 	$push96=, $pop39, $pop97
	tee_local	$push95=, $0=, $pop96
	i32.store	myrnd.s($pop103), $pop95
	i32.const	$push94=, 0
	i32.const	$push93=, 0
	i64.load	$push40=, sO+8($pop93)
	i64.const	$push41=, -4096
	i64.and 	$push92=, $pop40, $pop41
	tee_local	$push91=, $1=, $pop92
	i32.const	$push90=, 16
	i32.shr_u	$push42=, $2, $pop90
	i32.const	$push89=, 2047
	i32.and 	$push88=, $pop42, $pop89
	tee_local	$push87=, $2=, $pop88
	i64.extend_u/i32	$push43=, $pop87
	i64.or  	$push86=, $pop91, $pop43
	tee_local	$push85=, $3=, $pop86
	i64.store	sO+8($pop94), $pop85
	block   	
	i32.wrap/i64	$push84=, $3
	tee_local	$push83=, $5=, $pop84
	i32.const	$push82=, 2047
	i32.and 	$push47=, $pop83, $pop82
	i32.ne  	$push48=, $2, $pop47
	br_if   	0, $pop48       # 0: down to label10
# BB#1:                                 # %entry
	i32.const	$push201=, 16
	i32.shr_u	$push44=, $0, $pop201
	i32.const	$push200=, 2047
	i32.and 	$push199=, $pop44, $pop200
	tee_local	$push198=, $4=, $pop199
	i32.add 	$push0=, $pop198, $2
	i32.add 	$push45=, $4, $5
	i32.const	$push46=, 4095
	i32.and 	$push1=, $pop45, $pop46
	i32.ne  	$push49=, $pop0, $pop1
	br_if   	0, $pop49       # 0: down to label10
# BB#2:                                 # %if.end
	i32.const	$push54=, 0
	i32.const	$push50=, 1103515245
	i32.mul 	$push51=, $0, $pop50
	i32.const	$push52=, 12345
	i32.add 	$push217=, $pop51, $pop52
	tee_local	$push216=, $2=, $pop217
	i32.const	$push215=, 1103515245
	i32.mul 	$push53=, $pop216, $pop215
	i32.const	$push214=, 12345
	i32.add 	$push213=, $pop53, $pop214
	tee_local	$push212=, $0=, $pop213
	i32.store	myrnd.s($pop54), $pop212
	i32.const	$push211=, 0
	i32.const	$push210=, 16
	i32.shr_u	$push55=, $2, $pop210
	i32.const	$push209=, 2047
	i32.and 	$push208=, $pop55, $pop209
	tee_local	$push207=, $2=, $pop208
	i64.extend_u/i32	$push56=, $pop207
	i64.or  	$push206=, $1, $pop56
	tee_local	$push205=, $3=, $pop206
	i64.store	sO+8($pop211), $pop205
	i32.wrap/i64	$push204=, $3
	tee_local	$push203=, $5=, $pop204
	i32.const	$push202=, 2047
	i32.and 	$push57=, $pop203, $pop202
	i32.ne  	$push58=, $2, $pop57
	br_if   	0, $pop58       # 0: down to label10
# BB#3:                                 # %lor.lhs.false87
	i32.const	$push222=, 16
	i32.shr_u	$push59=, $0, $pop222
	i32.const	$push221=, 2047
	i32.and 	$push220=, $pop59, $pop221
	tee_local	$push219=, $4=, $pop220
	i32.add 	$push60=, $pop219, $2
	i32.const	$push61=, 15
	i32.rem_u	$push62=, $pop60, $pop61
	i32.add 	$push63=, $4, $5
	i32.const	$push64=, 4095
	i32.and 	$push65=, $pop63, $pop64
	i32.const	$push218=, 15
	i32.rem_u	$push66=, $pop65, $pop218
	i32.ne  	$push67=, $pop62, $pop66
	br_if   	0, $pop67       # 0: down to label10
# BB#4:                                 # %if.end140
	i32.const	$push72=, 0
	i32.const	$push68=, 1103515245
	i32.mul 	$push69=, $0, $pop68
	i32.const	$push70=, 12345
	i32.add 	$push231=, $pop69, $pop70
	tee_local	$push230=, $0=, $pop231
	i32.const	$push229=, 1103515245
	i32.mul 	$push71=, $pop230, $pop229
	i32.const	$push228=, 12345
	i32.add 	$push227=, $pop71, $pop228
	tee_local	$push226=, $2=, $pop227
	i32.store	myrnd.s($pop72), $pop226
	i32.const	$push225=, 0
	i32.const	$push73=, 16
	i32.shr_u	$push77=, $2, $pop73
	i32.const	$push75=, 2047
	i32.and 	$push78=, $pop77, $pop75
	i32.const	$push224=, 16
	i32.shr_u	$push74=, $0, $pop224
	i32.const	$push223=, 2047
	i32.and 	$push76=, $pop74, $pop223
	i32.add 	$push79=, $pop78, $pop76
	i64.extend_u/i32	$push80=, $pop79
	i64.or  	$push81=, $1, $pop80
	i64.store	sO+8($pop225), $pop81
	return
.LBB90_5:                               # %if.then
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end90:
	.size	testO, .Lfunc_end90-testO
                                        # -- End function
	.section	.text.retmeP,"ax",@progbits
	.hidden	retmeP                  # -- Begin function retmeP
	.globl	retmeP
	.type	retmeP,@function
retmeP:                                 # @retmeP
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	0($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end91:
	.size	retmeP, .Lfunc_end91-retmeP
                                        # -- End function
	.section	.text.fn1P,"ax",@progbits
	.hidden	fn1P                    # -- Begin function fn1P
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
                                        # -- End function
	.section	.text.fn2P,"ax",@progbits
	.hidden	fn2P                    # -- Begin function fn2P
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
                                        # -- End function
	.section	.text.retitP,"ax",@progbits
	.hidden	retitP                  # -- Begin function retitP
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
                                        # -- End function
	.section	.text.fn3P,"ax",@progbits
	.hidden	fn3P                    # -- Begin function fn3P
	.globl	fn3P
	.type	fn3P,@function
fn3P:                                   # @fn3P
	.param  	i32
	.result 	i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push12=, 0
	i64.load	$push11=, sP($pop12)
	tee_local	$push10=, $1=, $pop11
	i64.const	$push1=, -4096
	i64.and 	$push2=, $pop10, $pop1
	i32.wrap/i64	$push3=, $1
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 4095
	i32.and 	$push9=, $pop4, $pop5
	tee_local	$push8=, $0=, $pop9
	i64.extend_u/i32	$push6=, $pop8
	i64.or  	$push7=, $pop2, $pop6
	i64.store	sP($pop0), $pop7
	copy_local	$push13=, $0
                                        # fallthrough-return: $pop13
	.endfunc
.Lfunc_end95:
	.size	fn3P, .Lfunc_end95-fn3P
                                        # -- End function
	.section	.text.testP,"ax",@progbits
	.hidden	testP                   # -- Begin function testP
	.globl	testP
	.type	testP,@function
testP:                                  # @testP
	.local  	i32, i64, i32, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push197=, 0
	i32.load	$push3=, myrnd.s($pop197)
	i32.const	$push4=, 1103515245
	i32.mul 	$push5=, $pop3, $pop4
	i32.const	$push6=, 12345
	i32.add 	$push196=, $pop5, $pop6
	tee_local	$push195=, $0=, $pop196
	i32.const	$push194=, 16
	i32.shr_u	$push7=, $pop195, $pop194
	i32.store8	sP($pop2), $pop7
	i32.const	$push193=, 0
	i32.const	$push192=, 1103515245
	i32.mul 	$push8=, $0, $pop192
	i32.const	$push191=, 12345
	i32.add 	$push190=, $pop8, $pop191
	tee_local	$push189=, $0=, $pop190
	i32.const	$push188=, 16
	i32.shr_u	$push9=, $pop189, $pop188
	i32.store8	sP+1($pop193), $pop9
	i32.const	$push187=, 0
	i32.const	$push186=, 1103515245
	i32.mul 	$push10=, $0, $pop186
	i32.const	$push185=, 12345
	i32.add 	$push184=, $pop10, $pop185
	tee_local	$push183=, $0=, $pop184
	i32.const	$push182=, 16
	i32.shr_u	$push11=, $pop183, $pop182
	i32.store8	sP+2($pop187), $pop11
	i32.const	$push181=, 0
	i32.const	$push180=, 1103515245
	i32.mul 	$push12=, $0, $pop180
	i32.const	$push179=, 12345
	i32.add 	$push178=, $pop12, $pop179
	tee_local	$push177=, $0=, $pop178
	i32.const	$push176=, 16
	i32.shr_u	$push13=, $pop177, $pop176
	i32.store8	sP+3($pop181), $pop13
	i32.const	$push175=, 0
	i32.const	$push174=, 1103515245
	i32.mul 	$push14=, $0, $pop174
	i32.const	$push173=, 12345
	i32.add 	$push172=, $pop14, $pop173
	tee_local	$push171=, $0=, $pop172
	i32.const	$push170=, 16
	i32.shr_u	$push15=, $pop171, $pop170
	i32.store8	sP+4($pop175), $pop15
	i32.const	$push169=, 0
	i32.const	$push168=, 1103515245
	i32.mul 	$push16=, $0, $pop168
	i32.const	$push167=, 12345
	i32.add 	$push166=, $pop16, $pop167
	tee_local	$push165=, $0=, $pop166
	i32.const	$push164=, 16
	i32.shr_u	$push17=, $pop165, $pop164
	i32.store8	sP+5($pop169), $pop17
	i32.const	$push163=, 0
	i32.const	$push162=, 1103515245
	i32.mul 	$push18=, $0, $pop162
	i32.const	$push161=, 12345
	i32.add 	$push160=, $pop18, $pop161
	tee_local	$push159=, $0=, $pop160
	i32.const	$push158=, 16
	i32.shr_u	$push19=, $pop159, $pop158
	i32.store8	sP+6($pop163), $pop19
	i32.const	$push157=, 0
	i32.const	$push156=, 1103515245
	i32.mul 	$push20=, $0, $pop156
	i32.const	$push155=, 12345
	i32.add 	$push154=, $pop20, $pop155
	tee_local	$push153=, $0=, $pop154
	i32.const	$push152=, 16
	i32.shr_u	$push21=, $pop153, $pop152
	i32.store8	sP+7($pop157), $pop21
	i32.const	$push151=, 0
	i32.const	$push150=, 1103515245
	i32.mul 	$push22=, $0, $pop150
	i32.const	$push149=, 12345
	i32.add 	$push148=, $pop22, $pop149
	tee_local	$push147=, $0=, $pop148
	i32.const	$push146=, 16
	i32.shr_u	$push23=, $pop147, $pop146
	i32.store8	sP+8($pop151), $pop23
	i32.const	$push145=, 0
	i32.const	$push144=, 1103515245
	i32.mul 	$push24=, $0, $pop144
	i32.const	$push143=, 12345
	i32.add 	$push142=, $pop24, $pop143
	tee_local	$push141=, $0=, $pop142
	i32.const	$push140=, 16
	i32.shr_u	$push25=, $pop141, $pop140
	i32.store8	sP+9($pop145), $pop25
	i32.const	$push139=, 0
	i32.const	$push138=, 1103515245
	i32.mul 	$push26=, $0, $pop138
	i32.const	$push137=, 12345
	i32.add 	$push136=, $pop26, $pop137
	tee_local	$push135=, $0=, $pop136
	i32.const	$push134=, 16
	i32.shr_u	$push27=, $pop135, $pop134
	i32.store8	sP+10($pop139), $pop27
	i32.const	$push133=, 0
	i32.const	$push132=, 1103515245
	i32.mul 	$push28=, $0, $pop132
	i32.const	$push131=, 12345
	i32.add 	$push130=, $pop28, $pop131
	tee_local	$push129=, $0=, $pop130
	i32.const	$push128=, 16
	i32.shr_u	$push29=, $pop129, $pop128
	i32.store8	sP+11($pop133), $pop29
	i32.const	$push127=, 0
	i32.const	$push126=, 1103515245
	i32.mul 	$push30=, $0, $pop126
	i32.const	$push125=, 12345
	i32.add 	$push124=, $pop30, $pop125
	tee_local	$push123=, $0=, $pop124
	i32.const	$push122=, 16
	i32.shr_u	$push31=, $pop123, $pop122
	i32.store8	sP+12($pop127), $pop31
	i32.const	$push121=, 0
	i32.const	$push120=, 1103515245
	i32.mul 	$push32=, $0, $pop120
	i32.const	$push119=, 12345
	i32.add 	$push118=, $pop32, $pop119
	tee_local	$push117=, $0=, $pop118
	i32.const	$push116=, 16
	i32.shr_u	$push33=, $pop117, $pop116
	i32.store8	sP+13($pop121), $pop33
	i32.const	$push115=, 0
	i32.const	$push114=, 1103515245
	i32.mul 	$push34=, $0, $pop114
	i32.const	$push113=, 12345
	i32.add 	$push112=, $pop34, $pop113
	tee_local	$push111=, $0=, $pop112
	i32.const	$push110=, 16
	i32.shr_u	$push35=, $pop111, $pop110
	i32.store8	sP+14($pop115), $pop35
	i32.const	$push109=, 0
	i32.const	$push108=, 1103515245
	i32.mul 	$push36=, $0, $pop108
	i32.const	$push107=, 12345
	i32.add 	$push106=, $pop36, $pop107
	tee_local	$push105=, $0=, $pop106
	i32.const	$push104=, 16
	i32.shr_u	$push37=, $pop105, $pop104
	i32.store8	sP+15($pop109), $pop37
	i32.const	$push103=, 0
	i32.const	$push102=, 1103515245
	i32.mul 	$push38=, $0, $pop102
	i32.const	$push101=, 12345
	i32.add 	$push100=, $pop38, $pop101
	tee_local	$push99=, $2=, $pop100
	i32.const	$push98=, 1103515245
	i32.mul 	$push39=, $pop99, $pop98
	i32.const	$push97=, 12345
	i32.add 	$push96=, $pop39, $pop97
	tee_local	$push95=, $0=, $pop96
	i32.store	myrnd.s($pop103), $pop95
	i32.const	$push94=, 0
	i32.const	$push93=, 0
	i64.load	$push40=, sP($pop93)
	i64.const	$push41=, -4096
	i64.and 	$push92=, $pop40, $pop41
	tee_local	$push91=, $1=, $pop92
	i32.const	$push90=, 16
	i32.shr_u	$push42=, $2, $pop90
	i32.const	$push89=, 2047
	i32.and 	$push88=, $pop42, $pop89
	tee_local	$push87=, $2=, $pop88
	i64.extend_u/i32	$push43=, $pop87
	i64.or  	$push86=, $pop91, $pop43
	tee_local	$push85=, $3=, $pop86
	i64.store	sP($pop94), $pop85
	block   	
	i32.wrap/i64	$push84=, $3
	tee_local	$push83=, $5=, $pop84
	i32.const	$push82=, 2047
	i32.and 	$push47=, $pop83, $pop82
	i32.ne  	$push48=, $2, $pop47
	br_if   	0, $pop48       # 0: down to label11
# BB#1:                                 # %entry
	i32.const	$push201=, 16
	i32.shr_u	$push44=, $0, $pop201
	i32.const	$push200=, 2047
	i32.and 	$push199=, $pop44, $pop200
	tee_local	$push198=, $4=, $pop199
	i32.add 	$push0=, $pop198, $2
	i32.add 	$push45=, $4, $5
	i32.const	$push46=, 4095
	i32.and 	$push1=, $pop45, $pop46
	i32.ne  	$push49=, $pop0, $pop1
	br_if   	0, $pop49       # 0: down to label11
# BB#2:                                 # %if.end
	i32.const	$push54=, 0
	i32.const	$push50=, 1103515245
	i32.mul 	$push51=, $0, $pop50
	i32.const	$push52=, 12345
	i32.add 	$push217=, $pop51, $pop52
	tee_local	$push216=, $2=, $pop217
	i32.const	$push215=, 1103515245
	i32.mul 	$push53=, $pop216, $pop215
	i32.const	$push214=, 12345
	i32.add 	$push213=, $pop53, $pop214
	tee_local	$push212=, $0=, $pop213
	i32.store	myrnd.s($pop54), $pop212
	i32.const	$push211=, 0
	i32.const	$push210=, 16
	i32.shr_u	$push55=, $2, $pop210
	i32.const	$push209=, 2047
	i32.and 	$push208=, $pop55, $pop209
	tee_local	$push207=, $2=, $pop208
	i64.extend_u/i32	$push56=, $pop207
	i64.or  	$push206=, $1, $pop56
	tee_local	$push205=, $3=, $pop206
	i64.store	sP($pop211), $pop205
	i32.wrap/i64	$push204=, $3
	tee_local	$push203=, $5=, $pop204
	i32.const	$push202=, 2047
	i32.and 	$push57=, $pop203, $pop202
	i32.ne  	$push58=, $2, $pop57
	br_if   	0, $pop58       # 0: down to label11
# BB#3:                                 # %lor.lhs.false83
	i32.const	$push222=, 16
	i32.shr_u	$push59=, $0, $pop222
	i32.const	$push221=, 2047
	i32.and 	$push220=, $pop59, $pop221
	tee_local	$push219=, $4=, $pop220
	i32.add 	$push60=, $pop219, $2
	i32.const	$push61=, 15
	i32.rem_u	$push62=, $pop60, $pop61
	i32.add 	$push63=, $4, $5
	i32.const	$push64=, 4095
	i32.and 	$push65=, $pop63, $pop64
	i32.const	$push218=, 15
	i32.rem_u	$push66=, $pop65, $pop218
	i32.ne  	$push67=, $pop62, $pop66
	br_if   	0, $pop67       # 0: down to label11
# BB#4:                                 # %if.end134
	i32.const	$push72=, 0
	i32.const	$push68=, 1103515245
	i32.mul 	$push69=, $0, $pop68
	i32.const	$push70=, 12345
	i32.add 	$push231=, $pop69, $pop70
	tee_local	$push230=, $0=, $pop231
	i32.const	$push229=, 1103515245
	i32.mul 	$push71=, $pop230, $pop229
	i32.const	$push228=, 12345
	i32.add 	$push227=, $pop71, $pop228
	tee_local	$push226=, $2=, $pop227
	i32.store	myrnd.s($pop72), $pop226
	i32.const	$push225=, 0
	i32.const	$push73=, 16
	i32.shr_u	$push77=, $2, $pop73
	i32.const	$push75=, 2047
	i32.and 	$push78=, $pop77, $pop75
	i32.const	$push224=, 16
	i32.shr_u	$push74=, $0, $pop224
	i32.const	$push223=, 2047
	i32.and 	$push76=, $pop74, $pop223
	i32.add 	$push79=, $pop78, $pop76
	i64.extend_u/i32	$push80=, $pop79
	i64.or  	$push81=, $1, $pop80
	i64.store	sP($pop225), $pop81
	return
.LBB96_5:                               # %if.then
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end96:
	.size	testP, .Lfunc_end96-testP
                                        # -- End function
	.section	.text.retmeQ,"ax",@progbits
	.hidden	retmeQ                  # -- Begin function retmeQ
	.globl	retmeQ
	.type	retmeQ,@function
retmeQ:                                 # @retmeQ
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	0($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end97:
	.size	retmeQ, .Lfunc_end97-retmeQ
                                        # -- End function
	.section	.text.fn1Q,"ax",@progbits
	.hidden	fn1Q                    # -- Begin function fn1Q
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
                                        # -- End function
	.section	.text.fn2Q,"ax",@progbits
	.hidden	fn2Q                    # -- Begin function fn2Q
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
                                        # -- End function
	.section	.text.retitQ,"ax",@progbits
	.hidden	retitQ                  # -- Begin function retitQ
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
                                        # -- End function
	.section	.text.fn3Q,"ax",@progbits
	.hidden	fn3Q                    # -- Begin function fn3Q
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
	i32.store	sQ($pop0), $pop5
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end101:
	.size	fn3Q, .Lfunc_end101-fn3Q
                                        # -- End function
	.section	.text.testQ,"ax",@progbits
	.hidden	testQ                   # -- Begin function testQ
	.globl	testQ
	.type	testQ,@function
testQ:                                  # @testQ
	.local  	i32, i32
# BB#0:                                 # %if.end75
	i32.const	$push0=, 0
	i32.const	$push155=, 0
	i32.load	$push1=, myrnd.s($pop155)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push154=, $pop3, $pop4
	tee_local	$push153=, $0=, $pop154
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop153, $pop5
	i32.store8	sQ($pop0), $pop6
	i32.const	$push152=, 0
	i32.const	$push151=, 1103515245
	i32.mul 	$push7=, $0, $pop151
	i32.const	$push150=, 12345
	i32.add 	$push149=, $pop7, $pop150
	tee_local	$push148=, $0=, $pop149
	i32.const	$push147=, 16
	i32.shr_u	$push8=, $pop148, $pop147
	i32.store8	sQ+1($pop152), $pop8
	i32.const	$push146=, 0
	i32.const	$push145=, 1103515245
	i32.mul 	$push9=, $0, $pop145
	i32.const	$push144=, 12345
	i32.add 	$push143=, $pop9, $pop144
	tee_local	$push142=, $0=, $pop143
	i32.const	$push141=, 16
	i32.shr_u	$push10=, $pop142, $pop141
	i32.store8	sQ+2($pop146), $pop10
	i32.const	$push140=, 0
	i32.const	$push139=, 1103515245
	i32.mul 	$push11=, $0, $pop139
	i32.const	$push138=, 12345
	i32.add 	$push137=, $pop11, $pop138
	tee_local	$push136=, $0=, $pop137
	i32.const	$push135=, 16
	i32.shr_u	$push12=, $pop136, $pop135
	i32.store8	sQ+3($pop140), $pop12
	i32.const	$push134=, 0
	i32.const	$push133=, 1103515245
	i32.mul 	$push13=, $0, $pop133
	i32.const	$push132=, 12345
	i32.add 	$push131=, $pop13, $pop132
	tee_local	$push130=, $0=, $pop131
	i32.const	$push129=, 16
	i32.shr_u	$push14=, $pop130, $pop129
	i32.store8	sQ+4($pop134), $pop14
	i32.const	$push128=, 0
	i32.const	$push127=, 1103515245
	i32.mul 	$push15=, $0, $pop127
	i32.const	$push126=, 12345
	i32.add 	$push125=, $pop15, $pop126
	tee_local	$push124=, $0=, $pop125
	i32.const	$push123=, 16
	i32.shr_u	$push16=, $pop124, $pop123
	i32.store8	sQ+5($pop128), $pop16
	i32.const	$push122=, 0
	i32.const	$push121=, 1103515245
	i32.mul 	$push17=, $0, $pop121
	i32.const	$push120=, 12345
	i32.add 	$push119=, $pop17, $pop120
	tee_local	$push118=, $0=, $pop119
	i32.const	$push117=, 16
	i32.shr_u	$push18=, $pop118, $pop117
	i32.store8	sQ+6($pop122), $pop18
	i32.const	$push116=, 0
	i32.const	$push115=, 1103515245
	i32.mul 	$push19=, $0, $pop115
	i32.const	$push114=, 12345
	i32.add 	$push113=, $pop19, $pop114
	tee_local	$push112=, $0=, $pop113
	i32.const	$push111=, 16
	i32.shr_u	$push20=, $pop112, $pop111
	i32.store8	sQ+7($pop116), $pop20
	i32.const	$push110=, 0
	i32.const	$push109=, 1103515245
	i32.mul 	$push21=, $0, $pop109
	i32.const	$push108=, 12345
	i32.add 	$push107=, $pop21, $pop108
	tee_local	$push106=, $0=, $pop107
	i32.const	$push105=, 16
	i32.shr_u	$push22=, $pop106, $pop105
	i32.store8	sQ+8($pop110), $pop22
	i32.const	$push104=, 0
	i32.const	$push103=, 1103515245
	i32.mul 	$push23=, $0, $pop103
	i32.const	$push102=, 12345
	i32.add 	$push101=, $pop23, $pop102
	tee_local	$push100=, $0=, $pop101
	i32.const	$push99=, 16
	i32.shr_u	$push24=, $pop100, $pop99
	i32.store8	sQ+9($pop104), $pop24
	i32.const	$push98=, 0
	i32.const	$push97=, 1103515245
	i32.mul 	$push25=, $0, $pop97
	i32.const	$push96=, 12345
	i32.add 	$push95=, $pop25, $pop96
	tee_local	$push94=, $0=, $pop95
	i32.const	$push93=, 16
	i32.shr_u	$push26=, $pop94, $pop93
	i32.store8	sQ+10($pop98), $pop26
	i32.const	$push92=, 0
	i32.const	$push91=, 1103515245
	i32.mul 	$push27=, $0, $pop91
	i32.const	$push90=, 12345
	i32.add 	$push89=, $pop27, $pop90
	tee_local	$push88=, $0=, $pop89
	i32.const	$push87=, 16
	i32.shr_u	$push28=, $pop88, $pop87
	i32.store8	sQ+11($pop92), $pop28
	i32.const	$push86=, 0
	i32.const	$push85=, 1103515245
	i32.mul 	$push29=, $0, $pop85
	i32.const	$push84=, 12345
	i32.add 	$push83=, $pop29, $pop84
	tee_local	$push82=, $0=, $pop83
	i32.const	$push81=, 16
	i32.shr_u	$push30=, $pop82, $pop81
	i32.store8	sQ+12($pop86), $pop30
	i32.const	$push80=, 0
	i32.const	$push79=, 1103515245
	i32.mul 	$push31=, $0, $pop79
	i32.const	$push78=, 12345
	i32.add 	$push77=, $pop31, $pop78
	tee_local	$push76=, $0=, $pop77
	i32.const	$push75=, 16
	i32.shr_u	$push32=, $pop76, $pop75
	i32.store8	sQ+13($pop80), $pop32
	i32.const	$push74=, 0
	i32.const	$push73=, 1103515245
	i32.mul 	$push33=, $0, $pop73
	i32.const	$push72=, 12345
	i32.add 	$push71=, $pop33, $pop72
	tee_local	$push70=, $0=, $pop71
	i32.const	$push69=, 16
	i32.shr_u	$push34=, $pop70, $pop69
	i32.store8	sQ+14($pop74), $pop34
	i32.const	$push68=, 0
	i32.const	$push67=, 1103515245
	i32.mul 	$push35=, $0, $pop67
	i32.const	$push66=, 12345
	i32.add 	$push65=, $pop35, $pop66
	tee_local	$push64=, $0=, $pop65
	i32.const	$push63=, 16
	i32.shr_u	$push36=, $pop64, $pop63
	i32.store8	sQ+15($pop68), $pop36
	i32.const	$push62=, 0
	i32.const	$push37=, -341751747
	i32.mul 	$push38=, $0, $pop37
	i32.const	$push39=, 229283573
	i32.add 	$push61=, $pop38, $pop39
	tee_local	$push60=, $0=, $pop61
	i32.const	$push59=, 1103515245
	i32.mul 	$push40=, $pop60, $pop59
	i32.const	$push58=, 12345
	i32.add 	$push57=, $pop40, $pop58
	tee_local	$push56=, $1=, $pop57
	i32.store	myrnd.s($pop62), $pop56
	i32.const	$push55=, 0
	i32.const	$push54=, 16
	i32.shr_u	$push44=, $1, $pop54
	i32.const	$push42=, 2047
	i32.and 	$push45=, $pop44, $pop42
	i32.const	$push53=, 16
	i32.shr_u	$push41=, $0, $pop53
	i32.const	$push52=, 2047
	i32.and 	$push43=, $pop41, $pop52
	i32.add 	$push46=, $pop45, $pop43
	i32.const	$push51=, 0
	i32.load	$push47=, sQ($pop51)
	i32.const	$push48=, -4096
	i32.and 	$push49=, $pop47, $pop48
	i32.or  	$push50=, $pop46, $pop49
	i32.store	sQ($pop55), $pop50
                                        # fallthrough-return
	.endfunc
.Lfunc_end102:
	.size	testQ, .Lfunc_end102-testQ
                                        # -- End function
	.section	.text.retmeR,"ax",@progbits
	.hidden	retmeR                  # -- Begin function retmeR
	.globl	retmeR
	.type	retmeR,@function
retmeR:                                 # @retmeR
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	0($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end103:
	.size	retmeR, .Lfunc_end103-retmeR
                                        # -- End function
	.section	.text.fn1R,"ax",@progbits
	.hidden	fn1R                    # -- Begin function fn1R
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
                                        # -- End function
	.section	.text.fn2R,"ax",@progbits
	.hidden	fn2R                    # -- Begin function fn2R
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
                                        # -- End function
	.section	.text.retitR,"ax",@progbits
	.hidden	retitR                  # -- Begin function retitR
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
                                        # -- End function
	.section	.text.fn3R,"ax",@progbits
	.hidden	fn3R                    # -- Begin function fn3R
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
	i32.store	sR($pop0), $pop5
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end107:
	.size	fn3R, .Lfunc_end107-fn3R
                                        # -- End function
	.section	.text.testR,"ax",@progbits
	.hidden	testR                   # -- Begin function testR
	.globl	testR
	.type	testR,@function
testR:                                  # @testR
	.local  	i32, i32
# BB#0:                                 # %if.end75
	i32.const	$push0=, 0
	i32.const	$push155=, 0
	i32.load	$push1=, myrnd.s($pop155)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push154=, $pop3, $pop4
	tee_local	$push153=, $0=, $pop154
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop153, $pop5
	i32.store8	sR($pop0), $pop6
	i32.const	$push152=, 0
	i32.const	$push151=, 1103515245
	i32.mul 	$push7=, $0, $pop151
	i32.const	$push150=, 12345
	i32.add 	$push149=, $pop7, $pop150
	tee_local	$push148=, $0=, $pop149
	i32.const	$push147=, 16
	i32.shr_u	$push8=, $pop148, $pop147
	i32.store8	sR+1($pop152), $pop8
	i32.const	$push146=, 0
	i32.const	$push145=, 1103515245
	i32.mul 	$push9=, $0, $pop145
	i32.const	$push144=, 12345
	i32.add 	$push143=, $pop9, $pop144
	tee_local	$push142=, $0=, $pop143
	i32.const	$push141=, 16
	i32.shr_u	$push10=, $pop142, $pop141
	i32.store8	sR+2($pop146), $pop10
	i32.const	$push140=, 0
	i32.const	$push139=, 1103515245
	i32.mul 	$push11=, $0, $pop139
	i32.const	$push138=, 12345
	i32.add 	$push137=, $pop11, $pop138
	tee_local	$push136=, $0=, $pop137
	i32.const	$push135=, 16
	i32.shr_u	$push12=, $pop136, $pop135
	i32.store8	sR+3($pop140), $pop12
	i32.const	$push134=, 0
	i32.const	$push133=, 1103515245
	i32.mul 	$push13=, $0, $pop133
	i32.const	$push132=, 12345
	i32.add 	$push131=, $pop13, $pop132
	tee_local	$push130=, $0=, $pop131
	i32.const	$push129=, 16
	i32.shr_u	$push14=, $pop130, $pop129
	i32.store8	sR+4($pop134), $pop14
	i32.const	$push128=, 0
	i32.const	$push127=, 1103515245
	i32.mul 	$push15=, $0, $pop127
	i32.const	$push126=, 12345
	i32.add 	$push125=, $pop15, $pop126
	tee_local	$push124=, $0=, $pop125
	i32.const	$push123=, 16
	i32.shr_u	$push16=, $pop124, $pop123
	i32.store8	sR+5($pop128), $pop16
	i32.const	$push122=, 0
	i32.const	$push121=, 1103515245
	i32.mul 	$push17=, $0, $pop121
	i32.const	$push120=, 12345
	i32.add 	$push119=, $pop17, $pop120
	tee_local	$push118=, $0=, $pop119
	i32.const	$push117=, 16
	i32.shr_u	$push18=, $pop118, $pop117
	i32.store8	sR+6($pop122), $pop18
	i32.const	$push116=, 0
	i32.const	$push115=, 1103515245
	i32.mul 	$push19=, $0, $pop115
	i32.const	$push114=, 12345
	i32.add 	$push113=, $pop19, $pop114
	tee_local	$push112=, $0=, $pop113
	i32.const	$push111=, 16
	i32.shr_u	$push20=, $pop112, $pop111
	i32.store8	sR+7($pop116), $pop20
	i32.const	$push110=, 0
	i32.const	$push109=, 1103515245
	i32.mul 	$push21=, $0, $pop109
	i32.const	$push108=, 12345
	i32.add 	$push107=, $pop21, $pop108
	tee_local	$push106=, $0=, $pop107
	i32.const	$push105=, 16
	i32.shr_u	$push22=, $pop106, $pop105
	i32.store8	sR+8($pop110), $pop22
	i32.const	$push104=, 0
	i32.const	$push103=, 1103515245
	i32.mul 	$push23=, $0, $pop103
	i32.const	$push102=, 12345
	i32.add 	$push101=, $pop23, $pop102
	tee_local	$push100=, $0=, $pop101
	i32.const	$push99=, 16
	i32.shr_u	$push24=, $pop100, $pop99
	i32.store8	sR+9($pop104), $pop24
	i32.const	$push98=, 0
	i32.const	$push97=, 1103515245
	i32.mul 	$push25=, $0, $pop97
	i32.const	$push96=, 12345
	i32.add 	$push95=, $pop25, $pop96
	tee_local	$push94=, $0=, $pop95
	i32.const	$push93=, 16
	i32.shr_u	$push26=, $pop94, $pop93
	i32.store8	sR+10($pop98), $pop26
	i32.const	$push92=, 0
	i32.const	$push91=, 1103515245
	i32.mul 	$push27=, $0, $pop91
	i32.const	$push90=, 12345
	i32.add 	$push89=, $pop27, $pop90
	tee_local	$push88=, $0=, $pop89
	i32.const	$push87=, 16
	i32.shr_u	$push28=, $pop88, $pop87
	i32.store8	sR+11($pop92), $pop28
	i32.const	$push86=, 0
	i32.const	$push85=, 1103515245
	i32.mul 	$push29=, $0, $pop85
	i32.const	$push84=, 12345
	i32.add 	$push83=, $pop29, $pop84
	tee_local	$push82=, $0=, $pop83
	i32.const	$push81=, 16
	i32.shr_u	$push30=, $pop82, $pop81
	i32.store8	sR+12($pop86), $pop30
	i32.const	$push80=, 0
	i32.const	$push79=, 1103515245
	i32.mul 	$push31=, $0, $pop79
	i32.const	$push78=, 12345
	i32.add 	$push77=, $pop31, $pop78
	tee_local	$push76=, $0=, $pop77
	i32.const	$push75=, 16
	i32.shr_u	$push32=, $pop76, $pop75
	i32.store8	sR+13($pop80), $pop32
	i32.const	$push74=, 0
	i32.const	$push73=, 1103515245
	i32.mul 	$push33=, $0, $pop73
	i32.const	$push72=, 12345
	i32.add 	$push71=, $pop33, $pop72
	tee_local	$push70=, $0=, $pop71
	i32.const	$push69=, 16
	i32.shr_u	$push34=, $pop70, $pop69
	i32.store8	sR+14($pop74), $pop34
	i32.const	$push68=, 0
	i32.const	$push67=, 1103515245
	i32.mul 	$push35=, $0, $pop67
	i32.const	$push66=, 12345
	i32.add 	$push65=, $pop35, $pop66
	tee_local	$push64=, $0=, $pop65
	i32.const	$push63=, 16
	i32.shr_u	$push36=, $pop64, $pop63
	i32.store8	sR+15($pop68), $pop36
	i32.const	$push62=, 0
	i32.const	$push37=, -341751747
	i32.mul 	$push38=, $0, $pop37
	i32.const	$push39=, 229283573
	i32.add 	$push61=, $pop38, $pop39
	tee_local	$push60=, $0=, $pop61
	i32.const	$push59=, 1103515245
	i32.mul 	$push40=, $pop60, $pop59
	i32.const	$push58=, 12345
	i32.add 	$push57=, $pop40, $pop58
	tee_local	$push56=, $1=, $pop57
	i32.store	myrnd.s($pop62), $pop56
	i32.const	$push55=, 0
	i32.const	$push54=, 16
	i32.shr_u	$push44=, $1, $pop54
	i32.const	$push42=, 2047
	i32.and 	$push45=, $pop44, $pop42
	i32.const	$push53=, 16
	i32.shr_u	$push41=, $0, $pop53
	i32.const	$push52=, 2047
	i32.and 	$push43=, $pop41, $pop52
	i32.add 	$push46=, $pop45, $pop43
	i32.const	$push51=, 0
	i32.load	$push47=, sR($pop51)
	i32.const	$push48=, -4096
	i32.and 	$push49=, $pop47, $pop48
	i32.or  	$push50=, $pop46, $pop49
	i32.store	sR($pop55), $pop50
                                        # fallthrough-return
	.endfunc
.Lfunc_end108:
	.size	testR, .Lfunc_end108-testR
                                        # -- End function
	.section	.text.retmeS,"ax",@progbits
	.hidden	retmeS                  # -- Begin function retmeS
	.globl	retmeS
	.type	retmeS,@function
retmeS:                                 # @retmeS
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	0($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end109:
	.size	retmeS, .Lfunc_end109-retmeS
                                        # -- End function
	.section	.text.fn1S,"ax",@progbits
	.hidden	fn1S                    # -- Begin function fn1S
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
                                        # -- End function
	.section	.text.fn2S,"ax",@progbits
	.hidden	fn2S                    # -- Begin function fn2S
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
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end111:
	.size	fn2S, .Lfunc_end111-fn2S
                                        # -- End function
	.section	.text.retitS,"ax",@progbits
	.hidden	retitS                  # -- Begin function retitS
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
                                        # -- End function
	.section	.text.fn3S,"ax",@progbits
	.hidden	fn3S                    # -- Begin function fn3S
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
	i32.store16	sS($pop0), $pop5
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end113:
	.size	fn3S, .Lfunc_end113-fn3S
                                        # -- End function
	.section	.text.testS,"ax",@progbits
	.hidden	testS                   # -- Begin function testS
	.globl	testS
	.type	testS,@function
testS:                                  # @testS
	.local  	i32, i32
# BB#0:                                 # %if.end90
	i32.const	$push0=, 0
	i32.const	$push154=, 0
	i32.load	$push1=, myrnd.s($pop154)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push153=, $pop3, $pop4
	tee_local	$push152=, $0=, $pop153
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop152, $pop5
	i32.store8	sS($pop0), $pop6
	i32.const	$push151=, 0
	i32.const	$push150=, 1103515245
	i32.mul 	$push7=, $0, $pop150
	i32.const	$push149=, 12345
	i32.add 	$push148=, $pop7, $pop149
	tee_local	$push147=, $0=, $pop148
	i32.const	$push146=, 16
	i32.shr_u	$push8=, $pop147, $pop146
	i32.store8	sS+1($pop151), $pop8
	i32.const	$push145=, 0
	i32.const	$push144=, 1103515245
	i32.mul 	$push9=, $0, $pop144
	i32.const	$push143=, 12345
	i32.add 	$push142=, $pop9, $pop143
	tee_local	$push141=, $0=, $pop142
	i32.const	$push140=, 16
	i32.shr_u	$push10=, $pop141, $pop140
	i32.store8	sS+2($pop145), $pop10
	i32.const	$push139=, 0
	i32.const	$push138=, 1103515245
	i32.mul 	$push11=, $0, $pop138
	i32.const	$push137=, 12345
	i32.add 	$push136=, $pop11, $pop137
	tee_local	$push135=, $0=, $pop136
	i32.const	$push134=, 16
	i32.shr_u	$push12=, $pop135, $pop134
	i32.store8	sS+3($pop139), $pop12
	i32.const	$push133=, 0
	i32.const	$push132=, 1103515245
	i32.mul 	$push13=, $0, $pop132
	i32.const	$push131=, 12345
	i32.add 	$push130=, $pop13, $pop131
	tee_local	$push129=, $0=, $pop130
	i32.const	$push128=, 16
	i32.shr_u	$push14=, $pop129, $pop128
	i32.store8	sS+4($pop133), $pop14
	i32.const	$push127=, 0
	i32.const	$push126=, 1103515245
	i32.mul 	$push15=, $0, $pop126
	i32.const	$push125=, 12345
	i32.add 	$push124=, $pop15, $pop125
	tee_local	$push123=, $0=, $pop124
	i32.const	$push122=, 16
	i32.shr_u	$push16=, $pop123, $pop122
	i32.store8	sS+5($pop127), $pop16
	i32.const	$push121=, 0
	i32.const	$push120=, 1103515245
	i32.mul 	$push17=, $0, $pop120
	i32.const	$push119=, 12345
	i32.add 	$push118=, $pop17, $pop119
	tee_local	$push117=, $0=, $pop118
	i32.const	$push116=, 16
	i32.shr_u	$push18=, $pop117, $pop116
	i32.store8	sS+6($pop121), $pop18
	i32.const	$push115=, 0
	i32.const	$push114=, 1103515245
	i32.mul 	$push19=, $0, $pop114
	i32.const	$push113=, 12345
	i32.add 	$push112=, $pop19, $pop113
	tee_local	$push111=, $0=, $pop112
	i32.const	$push110=, 16
	i32.shr_u	$push20=, $pop111, $pop110
	i32.store8	sS+7($pop115), $pop20
	i32.const	$push109=, 0
	i32.const	$push108=, 1103515245
	i32.mul 	$push21=, $0, $pop108
	i32.const	$push107=, 12345
	i32.add 	$push106=, $pop21, $pop107
	tee_local	$push105=, $0=, $pop106
	i32.const	$push104=, 16
	i32.shr_u	$push22=, $pop105, $pop104
	i32.store8	sS+8($pop109), $pop22
	i32.const	$push103=, 0
	i32.const	$push102=, 1103515245
	i32.mul 	$push23=, $0, $pop102
	i32.const	$push101=, 12345
	i32.add 	$push100=, $pop23, $pop101
	tee_local	$push99=, $0=, $pop100
	i32.const	$push98=, 16
	i32.shr_u	$push24=, $pop99, $pop98
	i32.store8	sS+9($pop103), $pop24
	i32.const	$push97=, 0
	i32.const	$push96=, 1103515245
	i32.mul 	$push25=, $0, $pop96
	i32.const	$push95=, 12345
	i32.add 	$push94=, $pop25, $pop95
	tee_local	$push93=, $0=, $pop94
	i32.const	$push92=, 16
	i32.shr_u	$push26=, $pop93, $pop92
	i32.store8	sS+10($pop97), $pop26
	i32.const	$push91=, 0
	i32.const	$push90=, 1103515245
	i32.mul 	$push27=, $0, $pop90
	i32.const	$push89=, 12345
	i32.add 	$push88=, $pop27, $pop89
	tee_local	$push87=, $0=, $pop88
	i32.const	$push86=, 16
	i32.shr_u	$push28=, $pop87, $pop86
	i32.store8	sS+11($pop91), $pop28
	i32.const	$push85=, 0
	i32.const	$push84=, 1103515245
	i32.mul 	$push29=, $0, $pop84
	i32.const	$push83=, 12345
	i32.add 	$push82=, $pop29, $pop83
	tee_local	$push81=, $0=, $pop82
	i32.const	$push80=, 16
	i32.shr_u	$push30=, $pop81, $pop80
	i32.store8	sS+12($pop85), $pop30
	i32.const	$push79=, 0
	i32.const	$push78=, 1103515245
	i32.mul 	$push31=, $0, $pop78
	i32.const	$push77=, 12345
	i32.add 	$push76=, $pop31, $pop77
	tee_local	$push75=, $0=, $pop76
	i32.const	$push74=, 16
	i32.shr_u	$push32=, $pop75, $pop74
	i32.store8	sS+13($pop79), $pop32
	i32.const	$push73=, 0
	i32.const	$push72=, 1103515245
	i32.mul 	$push33=, $0, $pop72
	i32.const	$push71=, 12345
	i32.add 	$push70=, $pop33, $pop71
	tee_local	$push69=, $0=, $pop70
	i32.const	$push68=, 16
	i32.shr_u	$push34=, $pop69, $pop68
	i32.store8	sS+14($pop73), $pop34
	i32.const	$push67=, 0
	i32.const	$push66=, 1103515245
	i32.mul 	$push35=, $0, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push64=, $pop35, $pop65
	tee_local	$push63=, $0=, $pop64
	i32.const	$push62=, 16
	i32.shr_u	$push36=, $pop63, $pop62
	i32.store8	sS+15($pop67), $pop36
	i32.const	$push61=, 0
	i32.const	$push37=, -341751747
	i32.mul 	$push38=, $0, $pop37
	i32.const	$push39=, 229283573
	i32.add 	$push60=, $pop38, $pop39
	tee_local	$push59=, $0=, $pop60
	i32.const	$push58=, 1103515245
	i32.mul 	$push40=, $pop59, $pop58
	i32.const	$push57=, 12345
	i32.add 	$push56=, $pop40, $pop57
	tee_local	$push55=, $1=, $pop56
	i32.store	myrnd.s($pop61), $pop55
	i32.const	$push54=, 0
	i32.const	$push53=, 16
	i32.shr_u	$push42=, $1, $pop53
	i32.const	$push52=, 16
	i32.shr_u	$push41=, $0, $pop52
	i32.add 	$push43=, $pop42, $pop41
	i32.const	$push44=, 1
	i32.and 	$push45=, $pop43, $pop44
	i32.const	$push51=, 0
	i32.load16_u	$push46=, sS($pop51)
	i32.const	$push47=, 65534
	i32.and 	$push48=, $pop46, $pop47
	i32.or  	$push49=, $pop45, $pop48
	i32.store16	sS($pop54), $pop49
	block   	
	i32.const	$push50=, 1
	i32.eqz 	$push155=, $pop50
	br_if   	0, $pop155      # 0: down to label12
# BB#1:                                 # %if.end134
	return
.LBB114_2:                              # %if.then133
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end114:
	.size	testS, .Lfunc_end114-testS
                                        # -- End function
	.section	.text.retmeT,"ax",@progbits
	.hidden	retmeT                  # -- Begin function retmeT
	.globl	retmeT
	.type	retmeT,@function
retmeT:                                 # @retmeT
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($1):p2align=1
	i32.store	0($0):p2align=1, $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end115:
	.size	retmeT, .Lfunc_end115-retmeT
                                        # -- End function
	.section	.text.fn1T,"ax",@progbits
	.hidden	fn1T                    # -- Begin function fn1T
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
                                        # -- End function
	.section	.text.fn2T,"ax",@progbits
	.hidden	fn2T                    # -- Begin function fn2T
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
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end117:
	.size	fn2T, .Lfunc_end117-fn2T
                                        # -- End function
	.section	.text.retitT,"ax",@progbits
	.hidden	retitT                  # -- Begin function retitT
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
                                        # -- End function
	.section	.text.fn3T,"ax",@progbits
	.hidden	fn3T                    # -- Begin function fn3T
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
	i32.store16	sT($pop0), $pop5
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end119:
	.size	fn3T, .Lfunc_end119-fn3T
                                        # -- End function
	.section	.text.testT,"ax",@progbits
	.hidden	testT                   # -- Begin function testT
	.globl	testT
	.type	testT,@function
testT:                                  # @testT
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push75=, 0
	i32.const	$push74=, 0
	i32.load	$push0=, myrnd.s($pop74)
	i32.const	$push73=, 1103515245
	i32.mul 	$push1=, $pop0, $pop73
	i32.const	$push72=, 12345
	i32.add 	$push71=, $pop1, $pop72
	tee_local	$push70=, $0=, $pop71
	i32.const	$push69=, 16
	i32.shr_u	$push2=, $pop70, $pop69
	i32.store8	sT($pop75), $pop2
	i32.const	$push68=, 0
	i32.const	$push67=, 1103515245
	i32.mul 	$push3=, $0, $pop67
	i32.const	$push66=, 12345
	i32.add 	$push65=, $pop3, $pop66
	tee_local	$push64=, $0=, $pop65
	i32.const	$push63=, 16
	i32.shr_u	$push4=, $pop64, $pop63
	i32.store8	sT+1($pop68), $pop4
	i32.const	$push62=, 0
	i32.const	$push61=, 1103515245
	i32.mul 	$push5=, $0, $pop61
	i32.const	$push60=, 12345
	i32.add 	$push59=, $pop5, $pop60
	tee_local	$push58=, $0=, $pop59
	i32.const	$push57=, 16
	i32.shr_u	$push6=, $pop58, $pop57
	i32.store8	sT+2($pop62), $pop6
	i32.const	$push56=, 0
	i32.const	$push55=, 1103515245
	i32.mul 	$push7=, $0, $pop55
	i32.const	$push54=, 12345
	i32.add 	$push53=, $pop7, $pop54
	tee_local	$push52=, $0=, $pop53
	i32.const	$push51=, 16
	i32.shr_u	$push8=, $pop52, $pop51
	i32.store8	sT+3($pop56), $pop8
	i32.const	$push50=, 0
	i32.const	$push49=, 1103515245
	i32.mul 	$push11=, $0, $pop49
	i32.const	$push48=, 12345
	i32.add 	$push47=, $pop11, $pop48
	tee_local	$push46=, $0=, $pop47
	i32.const	$push45=, 16
	i32.shr_u	$push44=, $pop46, $pop45
	tee_local	$push43=, $2=, $pop44
	i32.const	$push42=, 1
	i32.and 	$push12=, $pop43, $pop42
	i32.const	$push41=, 0
	i32.load16_u	$push9=, sT($pop41)
	i32.const	$push10=, -2
	i32.and 	$push40=, $pop9, $pop10
	tee_local	$push39=, $1=, $pop40
	i32.or  	$push13=, $pop12, $pop39
	i32.store16	sT($pop50), $pop13
	i32.const	$push38=, 0
	i32.const	$push37=, 1103515245
	i32.mul 	$push14=, $0, $pop37
	i32.const	$push36=, 12345
	i32.add 	$push35=, $pop14, $pop36
	tee_local	$push34=, $0=, $pop35
	i32.store	myrnd.s($pop38), $pop34
	block   	
	i32.const	$push33=, 16
	i32.shr_u	$push32=, $0, $pop33
	tee_local	$push31=, $3=, $pop32
	i32.add 	$push15=, $pop31, $2
	i32.const	$push30=, 0
	i32.load	$push16=, sT($pop30)
	i32.add 	$push17=, $3, $pop16
	i32.xor 	$push18=, $pop15, $pop17
	i32.const	$push29=, 1
	i32.and 	$push19=, $pop18, $pop29
	br_if   	0, $pop19       # 0: down to label13
# BB#1:                                 # %if.end94
	i32.const	$push87=, 0
	i32.const	$push20=, -2139243339
	i32.mul 	$push21=, $0, $pop20
	i32.const	$push22=, -1492899873
	i32.add 	$push86=, $pop21, $pop22
	tee_local	$push85=, $0=, $pop86
	i32.const	$push84=, 1103515245
	i32.mul 	$push23=, $pop85, $pop84
	i32.const	$push83=, 12345
	i32.add 	$push82=, $pop23, $pop83
	tee_local	$push81=, $2=, $pop82
	i32.store	myrnd.s($pop87), $pop81
	i32.const	$push80=, 0
	i32.const	$push79=, 16
	i32.shr_u	$push25=, $2, $pop79
	i32.const	$push78=, 16
	i32.shr_u	$push24=, $0, $pop78
	i32.add 	$push26=, $pop25, $pop24
	i32.const	$push77=, 1
	i32.and 	$push27=, $pop26, $pop77
	i32.or  	$push28=, $pop27, $1
	i32.store16	sT($pop80), $pop28
	i32.const	$push76=, 1
	i32.eqz 	$push88=, $pop76
	br_if   	0, $pop88       # 0: down to label13
# BB#2:                                 # %if.end140
	return
.LBB120_3:                              # %if.then
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end120:
	.size	testT, .Lfunc_end120-testT
                                        # -- End function
	.section	.text.retmeU,"ax",@progbits
	.hidden	retmeU                  # -- Begin function retmeU
	.globl	retmeU
	.type	retmeU,@function
retmeU:                                 # @retmeU
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	0($0), $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3)
	i64.store	0($pop2), $pop4
                                        # fallthrough-return
	.endfunc
.Lfunc_end121:
	.size	retmeU, .Lfunc_end121-retmeU
                                        # -- End function
	.section	.text.fn1U,"ax",@progbits
	.hidden	fn1U                    # -- Begin function fn1U
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
                                        # -- End function
	.section	.text.fn2U,"ax",@progbits
	.hidden	fn2U                    # -- Begin function fn2U
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
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end123:
	.size	fn2U, .Lfunc_end123-fn2U
                                        # -- End function
	.section	.text.retitU,"ax",@progbits
	.hidden	retitU                  # -- Begin function retitU
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
                                        # -- End function
	.section	.text.fn3U,"ax",@progbits
	.hidden	fn3U                    # -- Begin function fn3U
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
	i32.store16	sU($pop0), $pop8
	i32.const	$push9=, 1
	i32.and 	$push10=, $0, $pop9
                                        # fallthrough-return: $pop10
	.endfunc
.Lfunc_end125:
	.size	fn3U, .Lfunc_end125-fn3U
                                        # -- End function
	.section	.text.testU,"ax",@progbits
	.hidden	testU                   # -- Begin function testU
	.globl	testU
	.type	testU,@function
testU:                                  # @testU
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push213=, 0
	i32.load	$push1=, myrnd.s($pop213)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push212=, $pop3, $pop4
	tee_local	$push211=, $2=, $pop212
	i32.const	$push210=, 16
	i32.shr_u	$push5=, $pop211, $pop210
	i32.store8	sU($pop0), $pop5
	i32.const	$push209=, 0
	i32.const	$push208=, 1103515245
	i32.mul 	$push6=, $2, $pop208
	i32.const	$push207=, 12345
	i32.add 	$push206=, $pop6, $pop207
	tee_local	$push205=, $2=, $pop206
	i32.const	$push204=, 16
	i32.shr_u	$push7=, $pop205, $pop204
	i32.store8	sU+1($pop209), $pop7
	i32.const	$push203=, 0
	i32.const	$push202=, 1103515245
	i32.mul 	$push8=, $2, $pop202
	i32.const	$push201=, 12345
	i32.add 	$push200=, $pop8, $pop201
	tee_local	$push199=, $2=, $pop200
	i32.const	$push198=, 16
	i32.shr_u	$push9=, $pop199, $pop198
	i32.store8	sU+2($pop203), $pop9
	i32.const	$push197=, 0
	i32.const	$push196=, 1103515245
	i32.mul 	$push10=, $2, $pop196
	i32.const	$push195=, 12345
	i32.add 	$push194=, $pop10, $pop195
	tee_local	$push193=, $2=, $pop194
	i32.const	$push192=, 16
	i32.shr_u	$push11=, $pop193, $pop192
	i32.store8	sU+3($pop197), $pop11
	i32.const	$push191=, 0
	i32.const	$push190=, 1103515245
	i32.mul 	$push12=, $2, $pop190
	i32.const	$push189=, 12345
	i32.add 	$push188=, $pop12, $pop189
	tee_local	$push187=, $2=, $pop188
	i32.const	$push186=, 16
	i32.shr_u	$push13=, $pop187, $pop186
	i32.store8	sU+4($pop191), $pop13
	i32.const	$push185=, 0
	i32.const	$push184=, 1103515245
	i32.mul 	$push14=, $2, $pop184
	i32.const	$push183=, 12345
	i32.add 	$push182=, $pop14, $pop183
	tee_local	$push181=, $2=, $pop182
	i32.const	$push180=, 16
	i32.shr_u	$push15=, $pop181, $pop180
	i32.store8	sU+5($pop185), $pop15
	i32.const	$push179=, 0
	i32.const	$push178=, 1103515245
	i32.mul 	$push16=, $2, $pop178
	i32.const	$push177=, 12345
	i32.add 	$push176=, $pop16, $pop177
	tee_local	$push175=, $2=, $pop176
	i32.const	$push174=, 16
	i32.shr_u	$push17=, $pop175, $pop174
	i32.store8	sU+6($pop179), $pop17
	i32.const	$push173=, 0
	i32.const	$push172=, 1103515245
	i32.mul 	$push18=, $2, $pop172
	i32.const	$push171=, 12345
	i32.add 	$push170=, $pop18, $pop171
	tee_local	$push169=, $2=, $pop170
	i32.const	$push168=, 16
	i32.shr_u	$push19=, $pop169, $pop168
	i32.store8	sU+7($pop173), $pop19
	i32.const	$push167=, 0
	i32.const	$push166=, 1103515245
	i32.mul 	$push20=, $2, $pop166
	i32.const	$push165=, 12345
	i32.add 	$push164=, $pop20, $pop165
	tee_local	$push163=, $2=, $pop164
	i32.const	$push162=, 16
	i32.shr_u	$push21=, $pop163, $pop162
	i32.store8	sU+8($pop167), $pop21
	i32.const	$push161=, 0
	i32.const	$push160=, 1103515245
	i32.mul 	$push22=, $2, $pop160
	i32.const	$push159=, 12345
	i32.add 	$push158=, $pop22, $pop159
	tee_local	$push157=, $2=, $pop158
	i32.const	$push156=, 16
	i32.shr_u	$push23=, $pop157, $pop156
	i32.store8	sU+9($pop161), $pop23
	i32.const	$push155=, 0
	i32.const	$push154=, 1103515245
	i32.mul 	$push24=, $2, $pop154
	i32.const	$push153=, 12345
	i32.add 	$push152=, $pop24, $pop153
	tee_local	$push151=, $2=, $pop152
	i32.const	$push150=, 16
	i32.shr_u	$push25=, $pop151, $pop150
	i32.store8	sU+10($pop155), $pop25
	i32.const	$push149=, 0
	i32.const	$push148=, 1103515245
	i32.mul 	$push26=, $2, $pop148
	i32.const	$push147=, 12345
	i32.add 	$push146=, $pop26, $pop147
	tee_local	$push145=, $2=, $pop146
	i32.const	$push144=, 16
	i32.shr_u	$push27=, $pop145, $pop144
	i32.store8	sU+11($pop149), $pop27
	i32.const	$push143=, 0
	i32.const	$push142=, 1103515245
	i32.mul 	$push28=, $2, $pop142
	i32.const	$push141=, 12345
	i32.add 	$push140=, $pop28, $pop141
	tee_local	$push139=, $2=, $pop140
	i32.const	$push138=, 16
	i32.shr_u	$push29=, $pop139, $pop138
	i32.store8	sU+12($pop143), $pop29
	i32.const	$push137=, 0
	i32.const	$push136=, 1103515245
	i32.mul 	$push30=, $2, $pop136
	i32.const	$push135=, 12345
	i32.add 	$push134=, $pop30, $pop135
	tee_local	$push133=, $2=, $pop134
	i32.const	$push132=, 16
	i32.shr_u	$push31=, $pop133, $pop132
	i32.store8	sU+13($pop137), $pop31
	i32.const	$push131=, 0
	i32.const	$push130=, 1103515245
	i32.mul 	$push32=, $2, $pop130
	i32.const	$push129=, 12345
	i32.add 	$push128=, $pop32, $pop129
	tee_local	$push127=, $2=, $pop128
	i32.const	$push126=, 16
	i32.shr_u	$push33=, $pop127, $pop126
	i32.store8	sU+14($pop131), $pop33
	i32.const	$push125=, 0
	i32.const	$push124=, 1103515245
	i32.mul 	$push34=, $2, $pop124
	i32.const	$push123=, 12345
	i32.add 	$push122=, $pop34, $pop123
	tee_local	$push121=, $2=, $pop122
	i32.const	$push120=, 16
	i32.shr_u	$push35=, $pop121, $pop120
	i32.store8	sU+15($pop125), $pop35
	i32.const	$push119=, 0
	i32.const	$push118=, 1103515245
	i32.mul 	$push36=, $2, $pop118
	i32.const	$push117=, 12345
	i32.add 	$push116=, $pop36, $pop117
	tee_local	$push115=, $2=, $pop116
	i32.const	$push114=, 1103515245
	i32.mul 	$push37=, $pop115, $pop114
	i32.const	$push113=, 12345
	i32.add 	$push112=, $pop37, $pop113
	tee_local	$push111=, $1=, $pop112
	i32.store	myrnd.s($pop119), $pop111
	i32.const	$push110=, 0
	i32.const	$push109=, 16
	i32.shr_u	$push108=, $2, $pop109
	tee_local	$push107=, $0=, $pop108
	i32.const	$push40=, 2047
	i32.and 	$push106=, $pop107, $pop40
	tee_local	$push105=, $3=, $pop106
	i32.const	$push41=, 6
	i32.shl 	$push42=, $pop105, $pop41
	i32.const	$push43=, 64
	i32.and 	$push44=, $pop42, $pop43
	i32.const	$push104=, 0
	i32.load16_u	$push38=, sU($pop104)
	i32.const	$push39=, -65
	i32.and 	$push103=, $pop38, $pop39
	tee_local	$push102=, $2=, $pop103
	i32.or  	$push101=, $pop44, $pop102
	tee_local	$push100=, $4=, $pop101
	i32.store16	sU($pop110), $pop100
	block   	
	i32.const	$push45=, 65472
	i32.and 	$push46=, $4, $pop45
	i32.const	$push99=, 6
	i32.shr_u	$push98=, $pop46, $pop99
	tee_local	$push97=, $4=, $pop98
	i32.xor 	$push47=, $pop97, $3
	i32.const	$push96=, 1
	i32.and 	$push48=, $pop47, $pop96
	br_if   	0, $pop48       # 0: down to label14
# BB#1:                                 # %lor.lhs.false41
	i32.const	$push217=, 16
	i32.shr_u	$push216=, $1, $pop217
	tee_local	$push215=, $3=, $pop216
	i32.add 	$push50=, $pop215, $4
	i32.add 	$push49=, $3, $0
	i32.xor 	$push51=, $pop50, $pop49
	i32.const	$push214=, 1
	i32.and 	$push52=, $pop51, $pop214
	br_if   	0, $pop52       # 0: down to label14
# BB#2:                                 # %if.end
	i32.const	$push57=, 0
	i32.const	$push53=, 1103515245
	i32.mul 	$push54=, $1, $pop53
	i32.const	$push55=, 12345
	i32.add 	$push235=, $pop54, $pop55
	tee_local	$push234=, $0=, $pop235
	i32.const	$push233=, 1103515245
	i32.mul 	$push56=, $pop234, $pop233
	i32.const	$push232=, 12345
	i32.add 	$push231=, $pop56, $pop232
	tee_local	$push230=, $1=, $pop231
	i32.store	myrnd.s($pop57), $pop230
	i32.const	$push229=, 0
	i32.const	$push228=, 16
	i32.shr_u	$push227=, $0, $pop228
	tee_local	$push226=, $0=, $pop227
	i32.const	$push58=, 2047
	i32.and 	$push225=, $pop226, $pop58
	tee_local	$push224=, $3=, $pop225
	i32.const	$push59=, 6
	i32.shl 	$push60=, $pop224, $pop59
	i32.const	$push61=, 64
	i32.and 	$push62=, $pop60, $pop61
	i32.or  	$push223=, $pop62, $2
	tee_local	$push222=, $4=, $pop223
	i32.store16	sU($pop229), $pop222
	i32.const	$push63=, 65472
	i32.and 	$push64=, $4, $pop63
	i32.const	$push221=, 6
	i32.shr_u	$push220=, $pop64, $pop221
	tee_local	$push219=, $4=, $pop220
	i32.xor 	$push65=, $pop219, $3
	i32.const	$push218=, 1
	i32.and 	$push66=, $pop65, $pop218
	br_if   	0, $pop66       # 0: down to label14
# BB#3:                                 # %lor.lhs.false85
	i32.const	$push239=, 16
	i32.shr_u	$push238=, $1, $pop239
	tee_local	$push237=, $3=, $pop238
	i32.add 	$push68=, $pop237, $4
	i32.add 	$push67=, $3, $0
	i32.xor 	$push69=, $pop68, $pop67
	i32.const	$push236=, 1
	i32.and 	$push70=, $pop69, $pop236
	br_if   	0, $pop70       # 0: down to label14
# BB#4:                                 # %lor.lhs.false130
	i32.const	$push75=, 0
	i32.const	$push71=, 1103515245
	i32.mul 	$push72=, $1, $pop71
	i32.const	$push73=, 12345
	i32.add 	$push253=, $pop72, $pop73
	tee_local	$push252=, $1=, $pop253
	i32.const	$push251=, 1103515245
	i32.mul 	$push74=, $pop252, $pop251
	i32.const	$push250=, 12345
	i32.add 	$push249=, $pop74, $pop250
	tee_local	$push248=, $0=, $pop249
	i32.store	myrnd.s($pop75), $pop248
	i32.const	$push247=, 0
	i32.const	$push76=, 16
	i32.shr_u	$push246=, $0, $pop76
	tee_local	$push245=, $0=, $pop246
	i32.const	$push77=, 2047
	i32.and 	$push78=, $pop245, $pop77
	i32.const	$push79=, 10
	i32.shr_u	$push80=, $1, $pop79
	i32.const	$push81=, 64
	i32.and 	$push82=, $pop80, $pop81
	i32.or  	$push83=, $pop82, $2
	i32.const	$push84=, 65472
	i32.and 	$push85=, $pop83, $pop84
	i32.const	$push86=, 6
	i32.shr_u	$push87=, $pop85, $pop86
	i32.add 	$push244=, $pop78, $pop87
	tee_local	$push243=, $3=, $pop244
	i32.const	$push242=, 6
	i32.shl 	$push88=, $pop243, $pop242
	i32.const	$push241=, 64
	i32.and 	$push89=, $pop88, $pop241
	i32.or  	$push90=, $pop89, $2
	i32.store16	sU($pop247), $pop90
	i32.const	$push240=, 16
	i32.shr_u	$push91=, $1, $pop240
	i32.add 	$push92=, $0, $pop91
	i32.xor 	$push93=, $pop92, $3
	i32.const	$push94=, 1
	i32.and 	$push95=, $pop93, $pop94
	br_if   	0, $pop95       # 0: down to label14
# BB#5:                                 # %if.end136
	return
.LBB126_6:                              # %if.then
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end126:
	.size	testU, .Lfunc_end126-testU
                                        # -- End function
	.section	.text.retmeV,"ax",@progbits
	.hidden	retmeV                  # -- Begin function retmeV
	.globl	retmeV
	.type	retmeV,@function
retmeV:                                 # @retmeV
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($1):p2align=1
	i32.store	0($0):p2align=1, $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end127:
	.size	retmeV, .Lfunc_end127-retmeV
                                        # -- End function
	.section	.text.fn1V,"ax",@progbits
	.hidden	fn1V                    # -- Begin function fn1V
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
                                        # -- End function
	.section	.text.fn2V,"ax",@progbits
	.hidden	fn2V                    # -- Begin function fn2V
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
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end129:
	.size	fn2V, .Lfunc_end129-fn2V
                                        # -- End function
	.section	.text.retitV,"ax",@progbits
	.hidden	retitV                  # -- Begin function retitV
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
                                        # -- End function
	.section	.text.fn3V,"ax",@progbits
	.hidden	fn3V                    # -- Begin function fn3V
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
	i32.store16	sV($pop0), $pop8
	i32.const	$push9=, 1
	i32.and 	$push10=, $0, $pop9
                                        # fallthrough-return: $pop10
	.endfunc
.Lfunc_end131:
	.size	fn3V, .Lfunc_end131-fn3V
                                        # -- End function
	.section	.text.testV,"ax",@progbits
	.hidden	testV                   # -- Begin function testV
	.globl	testV
	.type	testV,@function
testV:                                  # @testV
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push105=, 0
	i32.const	$push104=, 0
	i32.load	$push0=, myrnd.s($pop104)
	i32.const	$push103=, 1103515245
	i32.mul 	$push1=, $pop0, $pop103
	i32.const	$push102=, 12345
	i32.add 	$push101=, $pop1, $pop102
	tee_local	$push100=, $1=, $pop101
	i32.const	$push99=, 16
	i32.shr_u	$push2=, $pop100, $pop99
	i32.store8	sV($pop105), $pop2
	i32.const	$push98=, 0
	i32.const	$push97=, 1103515245
	i32.mul 	$push3=, $1, $pop97
	i32.const	$push96=, 12345
	i32.add 	$push95=, $pop3, $pop96
	tee_local	$push94=, $1=, $pop95
	i32.const	$push93=, 16
	i32.shr_u	$push4=, $pop94, $pop93
	i32.store8	sV+1($pop98), $pop4
	i32.const	$push92=, 0
	i32.const	$push91=, 1103515245
	i32.mul 	$push5=, $1, $pop91
	i32.const	$push90=, 12345
	i32.add 	$push89=, $pop5, $pop90
	tee_local	$push88=, $1=, $pop89
	i32.const	$push87=, 16
	i32.shr_u	$push6=, $pop88, $pop87
	i32.store8	sV+2($pop92), $pop6
	i32.const	$push86=, 0
	i32.const	$push85=, 1103515245
	i32.mul 	$push7=, $1, $pop85
	i32.const	$push84=, 12345
	i32.add 	$push83=, $pop7, $pop84
	tee_local	$push82=, $1=, $pop83
	i32.const	$push81=, 16
	i32.shr_u	$push8=, $pop82, $pop81
	i32.store8	sV+3($pop86), $pop8
	i32.const	$push80=, 0
	i32.const	$push79=, 1103515245
	i32.mul 	$push11=, $1, $pop79
	i32.const	$push78=, 12345
	i32.add 	$push77=, $pop11, $pop78
	tee_local	$push76=, $2=, $pop77
	i32.const	$push75=, 8
	i32.shr_u	$push12=, $pop76, $pop75
	i32.const	$push74=, 256
	i32.and 	$push13=, $pop12, $pop74
	i32.const	$push73=, 0
	i32.load16_u	$push9=, sV($pop73)
	i32.const	$push10=, -257
	i32.and 	$push72=, $pop9, $pop10
	tee_local	$push71=, $1=, $pop72
	i32.or  	$push14=, $pop13, $pop71
	i32.store16	sV($pop80), $pop14
	i32.const	$push70=, 0
	i32.const	$push69=, 1103515245
	i32.mul 	$push15=, $2, $pop69
	i32.const	$push68=, 12345
	i32.add 	$push67=, $pop15, $pop68
	tee_local	$push66=, $0=, $pop67
	i32.store	myrnd.s($pop70), $pop66
	block   	
	i32.const	$push65=, 16
	i32.shr_u	$push64=, $0, $pop65
	tee_local	$push63=, $3=, $pop64
	i32.const	$push62=, 16
	i32.shr_u	$push16=, $2, $pop62
	i32.add 	$push17=, $pop63, $pop16
	i32.const	$push61=, 0
	i32.load	$push18=, sV($pop61)
	i32.const	$push60=, 8
	i32.shr_u	$push19=, $pop18, $pop60
	i32.add 	$push20=, $3, $pop19
	i32.xor 	$push21=, $pop17, $pop20
	i32.const	$push59=, 1
	i32.and 	$push22=, $pop21, $pop59
	br_if   	0, $pop22       # 0: down to label15
# BB#1:                                 # %if.end
	i32.const	$push128=, 0
	i32.const	$push127=, 1103515245
	i32.mul 	$push23=, $0, $pop127
	i32.const	$push126=, 12345
	i32.add 	$push125=, $pop23, $pop126
	tee_local	$push124=, $0=, $pop125
	i32.const	$push123=, 1103515245
	i32.mul 	$push24=, $pop124, $pop123
	i32.const	$push122=, 12345
	i32.add 	$push121=, $pop24, $pop122
	tee_local	$push120=, $2=, $pop121
	i32.store	myrnd.s($pop128), $pop120
	i32.const	$push119=, 0
	i32.const	$push118=, 16
	i32.shr_u	$push117=, $0, $pop118
	tee_local	$push116=, $0=, $pop117
	i32.const	$push25=, 2047
	i32.and 	$push115=, $pop116, $pop25
	tee_local	$push114=, $3=, $pop115
	i32.const	$push113=, 8
	i32.shl 	$push26=, $pop114, $pop113
	i32.const	$push112=, 256
	i32.and 	$push27=, $pop26, $pop112
	i32.or  	$push111=, $pop27, $1
	tee_local	$push110=, $4=, $pop111
	i32.store16	sV($pop119), $pop110
	i32.const	$push28=, 65280
	i32.and 	$push29=, $4, $pop28
	i32.const	$push109=, 8
	i32.shr_u	$push108=, $pop29, $pop109
	tee_local	$push107=, $4=, $pop108
	i32.xor 	$push30=, $pop107, $3
	i32.const	$push106=, 1
	i32.and 	$push31=, $pop30, $pop106
	br_if   	0, $pop31       # 0: down to label15
# BB#2:                                 # %lor.lhs.false89
	i32.const	$push132=, 16
	i32.shr_u	$push131=, $2, $pop132
	tee_local	$push130=, $3=, $pop131
	i32.add 	$push33=, $pop130, $4
	i32.add 	$push32=, $3, $0
	i32.xor 	$push34=, $pop33, $pop32
	i32.const	$push129=, 1
	i32.and 	$push35=, $pop34, $pop129
	br_if   	0, $pop35       # 0: down to label15
# BB#3:                                 # %lor.lhs.false136
	i32.const	$push40=, 0
	i32.const	$push36=, 1103515245
	i32.mul 	$push37=, $2, $pop36
	i32.const	$push38=, 12345
	i32.add 	$push148=, $pop37, $pop38
	tee_local	$push147=, $2=, $pop148
	i32.const	$push146=, 1103515245
	i32.mul 	$push39=, $pop147, $pop146
	i32.const	$push145=, 12345
	i32.add 	$push144=, $pop39, $pop145
	tee_local	$push143=, $0=, $pop144
	i32.store	myrnd.s($pop40), $pop143
	i32.const	$push142=, 0
	i32.const	$push41=, 16
	i32.shr_u	$push141=, $0, $pop41
	tee_local	$push140=, $0=, $pop141
	i32.const	$push42=, 2047
	i32.and 	$push43=, $pop140, $pop42
	i32.const	$push44=, 8
	i32.shr_u	$push45=, $2, $pop44
	i32.const	$push46=, 256
	i32.and 	$push47=, $pop45, $pop46
	i32.or  	$push48=, $pop47, $1
	i32.const	$push49=, 65280
	i32.and 	$push50=, $pop48, $pop49
	i32.const	$push139=, 8
	i32.shr_u	$push51=, $pop50, $pop139
	i32.add 	$push138=, $pop43, $pop51
	tee_local	$push137=, $3=, $pop138
	i32.const	$push136=, 8
	i32.shl 	$push52=, $pop137, $pop136
	i32.const	$push135=, 256
	i32.and 	$push53=, $pop52, $pop135
	i32.or  	$push54=, $pop53, $1
	i32.store16	sV($pop142), $pop54
	i32.const	$push134=, 16
	i32.shr_u	$push55=, $2, $pop134
	i32.add 	$push56=, $0, $pop55
	i32.xor 	$push57=, $pop56, $3
	i32.const	$push133=, 1
	i32.and 	$push58=, $pop57, $pop133
	br_if   	0, $pop58       # 0: down to label15
# BB#4:                                 # %if.end142
	return
.LBB132_5:                              # %if.then
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end132:
	.size	testV, .Lfunc_end132-testV
                                        # -- End function
	.section	.text.retmeW,"ax",@progbits
	.hidden	retmeW                  # -- Begin function retmeW
	.globl	retmeW
	.type	retmeW,@function
retmeW:                                 # @retmeW
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	0($0), $pop0
	i32.const	$push1=, 24
	i32.add 	$push2=, $0, $pop1
	i32.const	$push15=, 24
	i32.add 	$push3=, $1, $pop15
	i64.load	$push4=, 0($pop3)
	i64.store	0($pop2), $pop4
	i32.const	$push5=, 16
	i32.add 	$push6=, $0, $pop5
	i32.const	$push14=, 16
	i32.add 	$push7=, $1, $pop14
	i64.load	$push8=, 0($pop7)
	i64.store	0($pop6), $pop8
	i32.const	$push9=, 8
	i32.add 	$push10=, $0, $pop9
	i32.const	$push13=, 8
	i32.add 	$push11=, $1, $pop13
	i64.load	$push12=, 0($pop11)
	i64.store	0($pop10), $pop12
                                        # fallthrough-return
	.endfunc
.Lfunc_end133:
	.size	retmeW, .Lfunc_end133-retmeW
                                        # -- End function
	.section	.text.fn1W,"ax",@progbits
	.hidden	fn1W                    # -- Begin function fn1W
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
                                        # -- End function
	.section	.text.fn2W,"ax",@progbits
	.hidden	fn2W                    # -- Begin function fn2W
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
                                        # -- End function
	.section	.text.retitW,"ax",@progbits
	.hidden	retitW                  # -- Begin function retitW
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
                                        # -- End function
	.section	.text.fn3W,"ax",@progbits
	.hidden	fn3W                    # -- Begin function fn3W
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
	i32.store	sW+16($pop0), $pop5
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end137:
	.size	fn3W, .Lfunc_end137-fn3W
                                        # -- End function
	.section	.text.testW,"ax",@progbits
	.hidden	testW                   # -- Begin function testW
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
	loop    	                # label16:
	i32.const	$push32=, sW+32
	i32.add 	$push1=, $0, $pop32
	i32.const	$push31=, 1103515245
	i32.mul 	$push2=, $1, $pop31
	i32.const	$push30=, 12345
	i32.add 	$push29=, $pop2, $pop30
	tee_local	$push28=, $1=, $pop29
	i32.const	$push27=, 16
	i32.shr_u	$push3=, $pop28, $pop27
	i32.store8	0($pop1), $pop3
	i32.const	$push26=, 1
	i32.add 	$push25=, $0, $pop26
	tee_local	$push24=, $0=, $pop25
	br_if   	0, $pop24       # 0: up to label16
# BB#2:                                 # %if.end119
	end_loop
	i32.const	$push5=, 0
	i64.const	$push4=, 4612055454334320640
	i64.store	sW+8($pop5), $pop4
	i32.const	$push42=, 0
	i64.const	$push6=, 0
	i64.store	sW($pop42), $pop6
	i32.const	$push41=, 0
	i32.const	$push7=, -341751747
	i32.mul 	$push8=, $1, $pop7
	i32.const	$push9=, 229283573
	i32.add 	$push40=, $pop8, $pop9
	tee_local	$push39=, $0=, $pop40
	i32.const	$push10=, 1103515245
	i32.mul 	$push11=, $pop39, $pop10
	i32.const	$push12=, 12345
	i32.add 	$push38=, $pop11, $pop12
	tee_local	$push37=, $1=, $pop38
	i32.store	myrnd.s($pop41), $pop37
	i32.const	$push36=, 0
	i32.const	$push13=, 16
	i32.shr_u	$push17=, $1, $pop13
	i32.const	$push15=, 2047
	i32.and 	$push18=, $pop17, $pop15
	i32.const	$push35=, 16
	i32.shr_u	$push14=, $0, $pop35
	i32.const	$push34=, 2047
	i32.and 	$push16=, $pop14, $pop34
	i32.add 	$push19=, $pop18, $pop16
	i32.const	$push33=, 0
	i32.load	$push20=, sW+16($pop33)
	i32.const	$push21=, -4096
	i32.and 	$push22=, $pop20, $pop21
	i32.or  	$push23=, $pop19, $pop22
	i32.store	sW+16($pop36), $pop23
                                        # fallthrough-return
	.endfunc
.Lfunc_end138:
	.size	testW, .Lfunc_end138-testW
                                        # -- End function
	.section	.text.retmeX,"ax",@progbits
	.hidden	retmeX                  # -- Begin function retmeX
	.globl	retmeX
	.type	retmeX,@function
retmeX:                                 # @retmeX
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	0($0), $pop0
	i32.const	$push1=, 24
	i32.add 	$push2=, $0, $pop1
	i32.const	$push15=, 24
	i32.add 	$push3=, $1, $pop15
	i64.load	$push4=, 0($pop3)
	i64.store	0($pop2), $pop4
	i32.const	$push5=, 16
	i32.add 	$push6=, $0, $pop5
	i32.const	$push14=, 16
	i32.add 	$push7=, $1, $pop14
	i64.load	$push8=, 0($pop7)
	i64.store	0($pop6), $pop8
	i32.const	$push9=, 8
	i32.add 	$push10=, $0, $pop9
	i32.const	$push13=, 8
	i32.add 	$push11=, $1, $pop13
	i64.load	$push12=, 0($pop11)
	i64.store	0($pop10), $pop12
                                        # fallthrough-return
	.endfunc
.Lfunc_end139:
	.size	retmeX, .Lfunc_end139-retmeX
                                        # -- End function
	.section	.text.fn1X,"ax",@progbits
	.hidden	fn1X                    # -- Begin function fn1X
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
                                        # -- End function
	.section	.text.fn2X,"ax",@progbits
	.hidden	fn2X                    # -- Begin function fn2X
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
                                        # -- End function
	.section	.text.retitX,"ax",@progbits
	.hidden	retitX                  # -- Begin function retitX
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
                                        # -- End function
	.section	.text.fn3X,"ax",@progbits
	.hidden	fn3X                    # -- Begin function fn3X
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
	i32.store	sX($pop0), $pop5
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end143:
	.size	fn3X, .Lfunc_end143-fn3X
                                        # -- End function
	.section	.text.testX,"ax",@progbits
	.hidden	testX                   # -- Begin function testX
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
	loop    	                # label17:
	i32.const	$push32=, sX+32
	i32.add 	$push1=, $0, $pop32
	i32.const	$push31=, 1103515245
	i32.mul 	$push2=, $1, $pop31
	i32.const	$push30=, 12345
	i32.add 	$push29=, $pop2, $pop30
	tee_local	$push28=, $1=, $pop29
	i32.const	$push27=, 16
	i32.shr_u	$push3=, $pop28, $pop27
	i32.store8	0($pop1), $pop3
	i32.const	$push26=, 1
	i32.add 	$push25=, $0, $pop26
	tee_local	$push24=, $0=, $pop25
	br_if   	0, $pop24       # 0: up to label17
# BB#2:                                 # %if.end113
	end_loop
	i32.const	$push5=, 0
	i64.const	$push4=, 4612055454334320640
	i64.store	sX+24($pop5), $pop4
	i32.const	$push42=, 0
	i64.const	$push6=, 0
	i64.store	sX+16($pop42), $pop6
	i32.const	$push41=, 0
	i32.const	$push7=, -341751747
	i32.mul 	$push8=, $1, $pop7
	i32.const	$push9=, 229283573
	i32.add 	$push40=, $pop8, $pop9
	tee_local	$push39=, $0=, $pop40
	i32.const	$push10=, 1103515245
	i32.mul 	$push11=, $pop39, $pop10
	i32.const	$push12=, 12345
	i32.add 	$push38=, $pop11, $pop12
	tee_local	$push37=, $1=, $pop38
	i32.store	myrnd.s($pop41), $pop37
	i32.const	$push36=, 0
	i32.const	$push13=, 16
	i32.shr_u	$push17=, $1, $pop13
	i32.const	$push15=, 2047
	i32.and 	$push18=, $pop17, $pop15
	i32.const	$push35=, 16
	i32.shr_u	$push14=, $0, $pop35
	i32.const	$push34=, 2047
	i32.and 	$push16=, $pop14, $pop34
	i32.add 	$push19=, $pop18, $pop16
	i32.const	$push33=, 0
	i32.load	$push20=, sX($pop33)
	i32.const	$push21=, -4096
	i32.and 	$push22=, $pop20, $pop21
	i32.or  	$push23=, $pop19, $pop22
	i32.store	sX($pop36), $pop23
                                        # fallthrough-return
	.endfunc
.Lfunc_end144:
	.size	testX, .Lfunc_end144-testX
                                        # -- End function
	.section	.text.retmeY,"ax",@progbits
	.hidden	retmeY                  # -- Begin function retmeY
	.globl	retmeY
	.type	retmeY,@function
retmeY:                                 # @retmeY
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	0($0), $pop0
	i32.const	$push1=, 24
	i32.add 	$push2=, $0, $pop1
	i32.const	$push15=, 24
	i32.add 	$push3=, $1, $pop15
	i64.load	$push4=, 0($pop3)
	i64.store	0($pop2), $pop4
	i32.const	$push5=, 16
	i32.add 	$push6=, $0, $pop5
	i32.const	$push14=, 16
	i32.add 	$push7=, $1, $pop14
	i64.load	$push8=, 0($pop7)
	i64.store	0($pop6), $pop8
	i32.const	$push9=, 8
	i32.add 	$push10=, $0, $pop9
	i32.const	$push13=, 8
	i32.add 	$push11=, $1, $pop13
	i64.load	$push12=, 0($pop11)
	i64.store	0($pop10), $pop12
                                        # fallthrough-return
	.endfunc
.Lfunc_end145:
	.size	retmeY, .Lfunc_end145-retmeY
                                        # -- End function
	.section	.text.fn1Y,"ax",@progbits
	.hidden	fn1Y                    # -- Begin function fn1Y
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
                                        # -- End function
	.section	.text.fn2Y,"ax",@progbits
	.hidden	fn2Y                    # -- Begin function fn2Y
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
                                        # -- End function
	.section	.text.retitY,"ax",@progbits
	.hidden	retitY                  # -- Begin function retitY
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
                                        # -- End function
	.section	.text.fn3Y,"ax",@progbits
	.hidden	fn3Y                    # -- Begin function fn3Y
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
	i32.store	sY($pop0), $pop5
	copy_local	$push11=, $0
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end149:
	.size	fn3Y, .Lfunc_end149-fn3Y
                                        # -- End function
	.section	.text.testY,"ax",@progbits
	.hidden	testY                   # -- Begin function testY
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
	loop    	                # label18:
	i32.const	$push32=, sY+32
	i32.add 	$push1=, $0, $pop32
	i32.const	$push31=, 1103515245
	i32.mul 	$push2=, $1, $pop31
	i32.const	$push30=, 12345
	i32.add 	$push29=, $pop2, $pop30
	tee_local	$push28=, $1=, $pop29
	i32.const	$push27=, 16
	i32.shr_u	$push3=, $pop28, $pop27
	i32.store8	0($pop1), $pop3
	i32.const	$push26=, 1
	i32.add 	$push25=, $0, $pop26
	tee_local	$push24=, $0=, $pop25
	br_if   	0, $pop24       # 0: up to label18
# BB#2:                                 # %if.end113
	end_loop
	i32.const	$push5=, 0
	i64.const	$push4=, 4612055454334320640
	i64.store	sY+24($pop5), $pop4
	i32.const	$push42=, 0
	i64.const	$push6=, 0
	i64.store	sY+16($pop42), $pop6
	i32.const	$push41=, 0
	i32.const	$push7=, -341751747
	i32.mul 	$push8=, $1, $pop7
	i32.const	$push9=, 229283573
	i32.add 	$push40=, $pop8, $pop9
	tee_local	$push39=, $0=, $pop40
	i32.const	$push10=, 1103515245
	i32.mul 	$push11=, $pop39, $pop10
	i32.const	$push12=, 12345
	i32.add 	$push38=, $pop11, $pop12
	tee_local	$push37=, $1=, $pop38
	i32.store	myrnd.s($pop41), $pop37
	i32.const	$push36=, 0
	i32.const	$push13=, 16
	i32.shr_u	$push17=, $1, $pop13
	i32.const	$push15=, 2047
	i32.and 	$push18=, $pop17, $pop15
	i32.const	$push35=, 16
	i32.shr_u	$push14=, $0, $pop35
	i32.const	$push34=, 2047
	i32.and 	$push16=, $pop14, $pop34
	i32.add 	$push19=, $pop18, $pop16
	i32.const	$push33=, 0
	i32.load	$push20=, sY($pop33)
	i32.const	$push21=, -4096
	i32.and 	$push22=, $pop20, $pop21
	i32.or  	$push23=, $pop19, $pop22
	i32.store	sY($pop36), $pop23
                                        # fallthrough-return
	.endfunc
.Lfunc_end150:
	.size	testY, .Lfunc_end150-testY
                                        # -- End function
	.section	.text.retmeZ,"ax",@progbits
	.hidden	retmeZ                  # -- Begin function retmeZ
	.globl	retmeZ
	.type	retmeZ,@function
retmeZ:                                 # @retmeZ
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	0($0), $pop0
	i32.const	$push1=, 24
	i32.add 	$push2=, $0, $pop1
	i32.const	$push15=, 24
	i32.add 	$push3=, $1, $pop15
	i64.load	$push4=, 0($pop3)
	i64.store	0($pop2), $pop4
	i32.const	$push5=, 16
	i32.add 	$push6=, $0, $pop5
	i32.const	$push14=, 16
	i32.add 	$push7=, $1, $pop14
	i64.load	$push8=, 0($pop7)
	i64.store	0($pop6), $pop8
	i32.const	$push9=, 8
	i32.add 	$push10=, $0, $pop9
	i32.const	$push13=, 8
	i32.add 	$push11=, $1, $pop13
	i64.load	$push12=, 0($pop11)
	i64.store	0($pop10), $pop12
                                        # fallthrough-return
	.endfunc
.Lfunc_end151:
	.size	retmeZ, .Lfunc_end151-retmeZ
                                        # -- End function
	.section	.text.fn1Z,"ax",@progbits
	.hidden	fn1Z                    # -- Begin function fn1Z
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
                                        # -- End function
	.section	.text.fn2Z,"ax",@progbits
	.hidden	fn2Z                    # -- Begin function fn2Z
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
                                        # -- End function
	.section	.text.retitZ,"ax",@progbits
	.hidden	retitZ                  # -- Begin function retitZ
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
                                        # -- End function
	.section	.text.fn3Z,"ax",@progbits
	.hidden	fn3Z                    # -- Begin function fn3Z
	.globl	fn3Z
	.type	fn3Z,@function
fn3Z:                                   # @fn3Z
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push8=, 0
	i32.load	$push3=, sZ+16($pop8)
	i32.const	$push0=, 20
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push7=, $pop3, $pop1
	tee_local	$push6=, $0=, $pop7
	i32.store	sZ+16($pop2), $pop6
	i32.const	$push5=, 20
	i32.shr_u	$push4=, $0, $pop5
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end155:
	.size	fn3Z, .Lfunc_end155-fn3Z
                                        # -- End function
	.section	.text.testZ,"ax",@progbits
	.hidden	testZ                   # -- Begin function testZ
	.globl	testZ
	.type	testZ,@function
testZ:                                  # @testZ
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$5=, myrnd.s($pop0)
	i32.const	$4=, -32
.LBB156_1:                              # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label19:
	i32.const	$push38=, sZ+32
	i32.add 	$push1=, $4, $pop38
	i32.const	$push37=, 1103515245
	i32.mul 	$push2=, $5, $pop37
	i32.const	$push36=, 12345
	i32.add 	$push35=, $pop2, $pop36
	tee_local	$push34=, $5=, $pop35
	i32.const	$push33=, 16
	i32.shr_u	$push3=, $pop34, $pop33
	i32.store8	0($pop1), $pop3
	i32.const	$push32=, 1
	i32.add 	$push31=, $4, $pop32
	tee_local	$push30=, $4=, $pop31
	br_if   	0, $pop30       # 0: up to label19
# BB#2:                                 # %for.end
	end_loop
	i32.const	$push69=, 0
	i64.const	$push4=, 4612055454334320640
	i64.store	sZ+8($pop69), $pop4
	i32.const	$push68=, 0
	i64.const	$push5=, 0
	i64.store	sZ($pop68), $pop5
	i32.const	$push67=, 0
	i32.const	$push66=, 1103515245
	i32.mul 	$push6=, $5, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push64=, $pop6, $pop65
	tee_local	$push63=, $5=, $pop64
	i32.const	$push62=, 1103515245
	i32.mul 	$push7=, $pop63, $pop62
	i32.const	$push61=, 12345
	i32.add 	$push60=, $pop7, $pop61
	tee_local	$push59=, $4=, $pop60
	i32.store	myrnd.s($pop67), $pop59
	i32.const	$push58=, 0
	i32.const	$push57=, 16
	i32.shr_u	$push8=, $5, $pop57
	i32.const	$push56=, 2047
	i32.and 	$push55=, $pop8, $pop56
	tee_local	$push54=, $5=, $pop55
	i32.const	$push53=, 20
	i32.shl 	$push9=, $pop54, $pop53
	i32.const	$push52=, 0
	i32.load	$push51=, sZ+16($pop52)
	tee_local	$push50=, $0=, $pop51
	i32.const	$push49=, 1048575
	i32.and 	$push48=, $pop50, $pop49
	tee_local	$push47=, $1=, $pop48
	i32.or  	$push46=, $pop9, $pop47
	tee_local	$push45=, $2=, $pop46
	i32.store	sZ+16($pop58), $pop45
	block   	
	i32.const	$push44=, 16
	i32.shr_u	$push10=, $4, $pop44
	i32.const	$push43=, 2047
	i32.and 	$push42=, $pop10, $pop43
	tee_local	$push41=, $3=, $pop42
	i32.add 	$push11=, $pop41, $5
	i32.const	$push40=, 20
	i32.shl 	$push12=, $3, $pop40
	i32.add 	$push13=, $pop12, $2
	i32.const	$push39=, 20
	i32.shr_u	$push14=, $pop13, $pop39
	i32.ne  	$push15=, $pop11, $pop14
	br_if   	0, $pop15       # 0: down to label20
# BB#3:                                 # %if.end80
	i32.const	$push90=, 0
	i32.const	$push17=, -2139243339
	i32.mul 	$push18=, $4, $pop17
	i32.const	$push19=, -1492899873
	i32.add 	$push89=, $pop18, $pop19
	tee_local	$push88=, $4=, $pop89
	i32.const	$push87=, 1103515245
	i32.mul 	$push20=, $pop88, $pop87
	i32.const	$push86=, 12345
	i32.add 	$push85=, $pop20, $pop86
	tee_local	$push84=, $5=, $pop85
	i32.store	myrnd.s($pop90), $pop84
	i32.const	$push83=, 0
	i32.const	$push82=, 16
	i32.shr_u	$push24=, $5, $pop82
	i32.const	$push81=, 2047
	i32.and 	$push80=, $pop24, $pop81
	tee_local	$push79=, $5=, $pop80
	i32.const	$push78=, 20
	i32.shl 	$push25=, $pop79, $pop78
	i32.const	$push77=, 16
	i32.shr_u	$push21=, $4, $pop77
	i32.const	$push76=, 2047
	i32.and 	$push75=, $pop21, $pop76
	tee_local	$push74=, $2=, $pop75
	i32.const	$push73=, 20
	i32.shl 	$push22=, $pop74, $pop73
	i32.or  	$push23=, $pop22, $1
	i32.add 	$push72=, $pop25, $pop23
	tee_local	$push71=, $4=, $pop72
	i32.store	sZ+16($pop83), $pop71
	i32.add 	$push26=, $5, $2
	i32.const	$push70=, 20
	i32.shr_u	$push27=, $4, $pop70
	i32.ne  	$push28=, $pop26, $pop27
	br_if   	0, $pop28       # 0: down to label20
# BB#4:                                 # %if.end80
	i32.xor 	$push29=, $4, $0
	i32.const	$push91=, 1048575
	i32.and 	$push16=, $pop29, $pop91
	br_if   	0, $pop16       # 0: down to label20
# BB#5:                                 # %if.end121
	return
.LBB156_6:                              # %if.then
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end156:
	.size	testZ, .Lfunc_end156-testZ
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
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
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
	.functype	exit, void, i32
