	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040709-2.c"
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
	i32.store	myrnd.s($pop0), $pop9
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $0, $pop5
	i32.const	$push7=, 2047
	i32.and 	$push8=, $pop6, $pop7
                                        # fallthrough-return: $pop8
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
	i32.load16_u	$push0=, 0($1):p2align=0
	i32.store16	0($0), $pop0
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
	i32.const	$push0=, 0
	i32.load16_u	$push1=, sA($pop0)
	i32.const	$push2=, 5
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 2047
	i32.and 	$push6=, $pop4, $pop5
                                        # fallthrough-return: $pop6
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
	i32.load16_u	$push1=, sA($pop0)
	i32.const	$push2=, 5
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 2047
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
	i32.load16_u	$push1=, sA($pop0)
	i32.const	$push2=, 5
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push14=, 0
	i32.load16_u	$push13=, sA($pop14)
	tee_local	$push12=, $1=, $pop13
	i32.const	$push3=, 5
	i32.shr_u	$push4=, $pop12, $pop3
	i32.add 	$push11=, $pop4, $0
	tee_local	$push10=, $0=, $pop11
	i32.const	$push9=, 5
	i32.shl 	$push5=, $pop10, $pop9
	i32.const	$push1=, 31
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push6=, $pop5, $pop2
	i32.store16	sA($pop0), $pop6
	i32.const	$push7=, 2047
	i32.and 	$push8=, $0, $pop7
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end5:
	.size	fn3A, .Lfunc_end5-fn3A

	.section	.text.testA,"ax",@progbits
	.hidden	testA
	.globl	testA
	.type	testA,@function
testA:                                  # @testA
	.local  	i32, i32
# BB#0:                                 # %if.end106
	i32.const	$push0=, 0
	i32.const	$push41=, 0
	i32.load	$push1=, myrnd.s($pop41)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push40=, $pop3, $pop4
	tee_local	$push39=, $0=, $pop40
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop39, $pop5
	i32.store8	sA($pop0), $pop6
	i32.const	$push38=, 0
	i32.const	$push37=, 1103515245
	i32.mul 	$push7=, $0, $pop37
	i32.const	$push36=, 12345
	i32.add 	$push35=, $pop7, $pop36
	tee_local	$push34=, $0=, $pop35
	i32.const	$push33=, 16
	i32.shr_u	$push8=, $pop34, $pop33
	i32.store8	sA+1($pop38), $pop8
	i32.const	$push32=, 0
	i32.const	$push9=, -341751747
	i32.mul 	$push10=, $0, $pop9
	i32.const	$push11=, 229283573
	i32.add 	$push31=, $pop10, $pop11
	tee_local	$push30=, $0=, $pop31
	i32.const	$push29=, 1103515245
	i32.mul 	$push12=, $pop30, $pop29
	i32.const	$push28=, 12345
	i32.add 	$push27=, $pop12, $pop28
	tee_local	$push26=, $1=, $pop27
	i32.store	myrnd.s($pop32), $pop26
	i32.const	$push25=, 0
	i32.const	$push24=, 16
	i32.shr_u	$push14=, $1, $pop24
	i32.const	$push23=, 16
	i32.shr_u	$push13=, $0, $pop23
	i32.add 	$push15=, $pop14, $pop13
	i32.const	$push16=, 5
	i32.shl 	$push17=, $pop15, $pop16
	i32.const	$push22=, 0
	i32.load16_u	$push18=, sA($pop22)
	i32.const	$push19=, 31
	i32.and 	$push20=, $pop18, $pop19
	i32.or  	$push21=, $pop17, $pop20
	i32.store16	sA($pop25), $pop21
                                        # fallthrough-return
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
	i32.load	$push0=, 0($1):p2align=0
	i32.store	0($0):p2align=0, $pop0
	i32.const	$push1=, 4
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 4
	i32.add 	$push3=, $1, $pop5
	i32.load16_u	$push4=, 0($pop3):p2align=0
	i32.store16	0($pop2):p2align=0, $pop4
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
	i32.const	$push0=, 0
	i32.load16_u	$push1=, sB($pop0)
	i32.const	$push2=, 5
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 2047
	i32.and 	$push6=, $pop4, $pop5
                                        # fallthrough-return: $pop6
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
	i32.load16_u	$push1=, sB($pop0)
	i32.const	$push2=, 5
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 2047
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
	i32.load16_u	$push1=, sB($pop0)
	i32.const	$push2=, 5
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push14=, 0
	i32.load16_u	$push13=, sB($pop14)
	tee_local	$push12=, $1=, $pop13
	i32.const	$push3=, 5
	i32.shr_u	$push4=, $pop12, $pop3
	i32.add 	$push11=, $pop4, $0
	tee_local	$push10=, $0=, $pop11
	i32.const	$push9=, 5
	i32.shl 	$push5=, $pop10, $pop9
	i32.const	$push1=, 31
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push6=, $pop5, $pop2
	i32.store16	sB($pop0), $pop6
	i32.const	$push7=, 2047
	i32.and 	$push8=, $0, $pop7
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end11:
	.size	fn3B, .Lfunc_end11-fn3B

	.section	.text.testB,"ax",@progbits
	.hidden	testB
	.globl	testB
	.type	testB,@function
testB:                                  # @testB
	.local  	i32, i32, i32
# BB#0:                                 # %if.end136
	i32.const	$push0=, 0
	i32.const	$push72=, 0
	i32.load	$push1=, myrnd.s($pop72)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push71=, $pop3, $pop4
	tee_local	$push70=, $0=, $pop71
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop70, $pop5
	i32.store8	sB($pop0), $pop6
	i32.const	$push69=, 0
	i32.const	$push68=, 1103515245
	i32.mul 	$push7=, $0, $pop68
	i32.const	$push67=, 12345
	i32.add 	$push66=, $pop7, $pop67
	tee_local	$push65=, $0=, $pop66
	i32.const	$push64=, 16
	i32.shr_u	$push8=, $pop65, $pop64
	i32.store8	sB+1($pop69), $pop8
	i32.const	$push63=, 0
	i32.const	$push62=, 1103515245
	i32.mul 	$push9=, $0, $pop62
	i32.const	$push61=, 12345
	i32.add 	$push60=, $pop9, $pop61
	tee_local	$push59=, $0=, $pop60
	i32.const	$push58=, 16
	i32.shr_u	$push10=, $pop59, $pop58
	i32.store8	sB+2($pop63), $pop10
	i32.const	$push57=, 0
	i32.const	$push56=, 1103515245
	i32.mul 	$push11=, $0, $pop56
	i32.const	$push55=, 12345
	i32.add 	$push54=, $pop11, $pop55
	tee_local	$push53=, $0=, $pop54
	i32.const	$push52=, 16
	i32.shr_u	$push12=, $pop53, $pop52
	i32.store8	sB+3($pop57), $pop12
	i32.const	$push51=, 0
	i32.const	$push50=, 1103515245
	i32.mul 	$push13=, $0, $pop50
	i32.const	$push49=, 12345
	i32.add 	$push48=, $pop13, $pop49
	tee_local	$push47=, $0=, $pop48
	i32.const	$push46=, 16
	i32.shr_u	$push14=, $pop47, $pop46
	i32.store8	sB+4($pop51), $pop14
	i32.const	$push45=, 0
	i32.const	$push44=, 1103515245
	i32.mul 	$push15=, $0, $pop44
	i32.const	$push43=, 12345
	i32.add 	$push42=, $pop15, $pop43
	tee_local	$push41=, $0=, $pop42
	i32.const	$push40=, 16
	i32.shr_u	$push16=, $pop41, $pop40
	i32.store8	sB+5($pop45), $pop16
	i32.const	$push39=, 0
	i32.load16_u	$2=, sB($pop39)
	i32.const	$push38=, 0
	i32.const	$push17=, -341751747
	i32.mul 	$push18=, $0, $pop17
	i32.const	$push19=, 229283573
	i32.add 	$push37=, $pop18, $pop19
	tee_local	$push36=, $0=, $pop37
	i32.const	$push35=, 1103515245
	i32.mul 	$push20=, $pop36, $pop35
	i32.const	$push34=, 12345
	i32.add 	$push33=, $pop20, $pop34
	tee_local	$push32=, $1=, $pop33
	i32.store	myrnd.s($pop38), $pop32
	i32.const	$push31=, 0
	i32.const	$push30=, 16
	i32.shr_u	$push22=, $1, $pop30
	i32.const	$push29=, 16
	i32.shr_u	$push21=, $0, $pop29
	i32.add 	$push23=, $pop22, $pop21
	i32.const	$push24=, 5
	i32.shl 	$push25=, $pop23, $pop24
	i32.const	$push26=, 31
	i32.and 	$push27=, $2, $pop26
	i32.or  	$push28=, $pop25, $pop27
	i32.store16	sB($pop31), $pop28
                                        # fallthrough-return
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
	i32.load	$push0=, 0($1):p2align=0
	i32.store	0($0):p2align=0, $pop0
	i32.const	$push1=, 4
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 4
	i32.add 	$push3=, $1, $pop5
	i32.load16_u	$push4=, 0($pop3):p2align=0
	i32.store16	0($pop2):p2align=0, $pop4
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
	i32.const	$push0=, 0
	i32.load16_u	$push1=, sC+4($pop0)
	i32.const	$push2=, 5
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 2047
	i32.and 	$push6=, $pop4, $pop5
                                        # fallthrough-return: $pop6
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
	i32.load16_u	$push1=, sC+4($pop0)
	i32.const	$push2=, 5
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 2047
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
	i32.load16_u	$push1=, sC+4($pop0)
	i32.const	$push2=, 5
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push14=, 0
	i32.load16_u	$push13=, sC+4($pop14)
	tee_local	$push12=, $1=, $pop13
	i32.const	$push3=, 5
	i32.shr_u	$push4=, $pop12, $pop3
	i32.add 	$push11=, $pop4, $0
	tee_local	$push10=, $0=, $pop11
	i32.const	$push9=, 5
	i32.shl 	$push5=, $pop10, $pop9
	i32.const	$push1=, 31
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push6=, $pop5, $pop2
	i32.store16	sC+4($pop0), $pop6
	i32.const	$push7=, 2047
	i32.and 	$push8=, $0, $pop7
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end17:
	.size	fn3C, .Lfunc_end17-fn3C

	.section	.text.testC,"ax",@progbits
	.hidden	testC
	.globl	testC
	.type	testC,@function
testC:                                  # @testC
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %if.end142
	i32.const	$push0=, 0
	i32.const	$push72=, 0
	i32.load	$push1=, myrnd.s($pop72)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push71=, $pop3, $pop4
	tee_local	$push70=, $0=, $pop71
	i32.const	$push69=, 1103515245
	i32.mul 	$push5=, $pop70, $pop69
	i32.const	$push68=, 12345
	i32.add 	$push67=, $pop5, $pop68
	tee_local	$push66=, $1=, $pop67
	i32.const	$push65=, 1103515245
	i32.mul 	$push6=, $pop66, $pop65
	i32.const	$push64=, 12345
	i32.add 	$push63=, $pop6, $pop64
	tee_local	$push62=, $2=, $pop63
	i32.const	$push61=, 1103515245
	i32.mul 	$push7=, $pop62, $pop61
	i32.const	$push60=, 12345
	i32.add 	$push59=, $pop7, $pop60
	tee_local	$push58=, $3=, $pop59
	i32.const	$push57=, 1103515245
	i32.mul 	$push8=, $pop58, $pop57
	i32.const	$push56=, 12345
	i32.add 	$push55=, $pop8, $pop56
	tee_local	$push54=, $4=, $pop55
	i32.const	$push9=, 16
	i32.shr_u	$push10=, $pop54, $pop9
	i32.store8	sC+4($pop0), $pop10
	i32.const	$push53=, 0
	i32.const	$push52=, 1103515245
	i32.mul 	$push11=, $4, $pop52
	i32.const	$push51=, 12345
	i32.add 	$push50=, $pop11, $pop51
	tee_local	$push49=, $4=, $pop50
	i32.const	$push48=, 16
	i32.shr_u	$push12=, $pop49, $pop48
	i32.store8	sC+5($pop53), $pop12
	i32.const	$push47=, 0
	i32.const	$push46=, 16
	i32.shr_u	$push13=, $0, $pop46
	i32.store8	sC($pop47), $pop13
	i32.const	$push45=, 0
	i32.const	$push44=, 16
	i32.shr_u	$push14=, $1, $pop44
	i32.store8	sC+1($pop45), $pop14
	i32.const	$push43=, 0
	i32.const	$push42=, 16
	i32.shr_u	$push15=, $2, $pop42
	i32.store8	sC+2($pop43), $pop15
	i32.const	$push41=, 0
	i32.const	$push40=, 16
	i32.shr_u	$push16=, $3, $pop40
	i32.store8	sC+3($pop41), $pop16
	i32.const	$push39=, 0
	i32.load16_u	$0=, sC+4($pop39)
	i32.const	$push38=, 0
	i32.const	$push17=, -341751747
	i32.mul 	$push18=, $4, $pop17
	i32.const	$push19=, 229283573
	i32.add 	$push37=, $pop18, $pop19
	tee_local	$push36=, $1=, $pop37
	i32.const	$push35=, 1103515245
	i32.mul 	$push20=, $pop36, $pop35
	i32.const	$push34=, 12345
	i32.add 	$push33=, $pop20, $pop34
	tee_local	$push32=, $2=, $pop33
	i32.store	myrnd.s($pop38), $pop32
	i32.const	$push31=, 0
	i32.const	$push30=, 16
	i32.shr_u	$push22=, $2, $pop30
	i32.const	$push29=, 16
	i32.shr_u	$push21=, $1, $pop29
	i32.add 	$push23=, $pop22, $pop21
	i32.const	$push24=, 5
	i32.shl 	$push25=, $pop23, $pop24
	i32.const	$push26=, 31
	i32.and 	$push27=, $0, $pop26
	i32.or  	$push28=, $pop25, $pop27
	i32.store16	sC+4($pop31), $pop28
                                        # fallthrough-return
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
	i64.load	$push0=, 0($1):p2align=0
	i64.store	0($0), $pop0
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
	i64.store	sD($pop0), $pop8
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
	.local  	i32, i32, i64
# BB#0:                                 # %if.end158
	i32.const	$push0=, 0
	i32.const	$push93=, 0
	i32.load	$push1=, myrnd.s($pop93)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push92=, $pop3, $pop4
	tee_local	$push91=, $0=, $pop92
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop91, $pop5
	i32.store8	sD($pop0), $pop6
	i32.const	$push90=, 0
	i32.const	$push89=, 1103515245
	i32.mul 	$push7=, $0, $pop89
	i32.const	$push88=, 12345
	i32.add 	$push87=, $pop7, $pop88
	tee_local	$push86=, $0=, $pop87
	i32.const	$push85=, 16
	i32.shr_u	$push8=, $pop86, $pop85
	i32.store8	sD+1($pop90), $pop8
	i32.const	$push84=, 0
	i32.const	$push83=, 1103515245
	i32.mul 	$push9=, $0, $pop83
	i32.const	$push82=, 12345
	i32.add 	$push81=, $pop9, $pop82
	tee_local	$push80=, $0=, $pop81
	i32.const	$push79=, 16
	i32.shr_u	$push10=, $pop80, $pop79
	i32.store8	sD+2($pop84), $pop10
	i32.const	$push78=, 0
	i32.const	$push77=, 1103515245
	i32.mul 	$push11=, $0, $pop77
	i32.const	$push76=, 12345
	i32.add 	$push75=, $pop11, $pop76
	tee_local	$push74=, $0=, $pop75
	i32.const	$push73=, 16
	i32.shr_u	$push12=, $pop74, $pop73
	i32.store8	sD+3($pop78), $pop12
	i32.const	$push72=, 0
	i32.const	$push71=, 1103515245
	i32.mul 	$push13=, $0, $pop71
	i32.const	$push70=, 12345
	i32.add 	$push69=, $pop13, $pop70
	tee_local	$push68=, $0=, $pop69
	i32.const	$push67=, 16
	i32.shr_u	$push14=, $pop68, $pop67
	i32.store8	sD+4($pop72), $pop14
	i32.const	$push66=, 0
	i32.const	$push65=, 1103515245
	i32.mul 	$push15=, $0, $pop65
	i32.const	$push64=, 12345
	i32.add 	$push63=, $pop15, $pop64
	tee_local	$push62=, $0=, $pop63
	i32.const	$push61=, 16
	i32.shr_u	$push16=, $pop62, $pop61
	i32.store8	sD+5($pop66), $pop16
	i32.const	$push60=, 0
	i32.const	$push59=, 1103515245
	i32.mul 	$push17=, $0, $pop59
	i32.const	$push58=, 12345
	i32.add 	$push57=, $pop17, $pop58
	tee_local	$push56=, $0=, $pop57
	i32.const	$push55=, 16
	i32.shr_u	$push18=, $pop56, $pop55
	i32.store8	sD+6($pop60), $pop18
	i32.const	$push54=, 0
	i32.const	$push53=, 1103515245
	i32.mul 	$push19=, $0, $pop53
	i32.const	$push52=, 12345
	i32.add 	$push51=, $pop19, $pop52
	tee_local	$push50=, $0=, $pop51
	i32.const	$push49=, 16
	i32.shr_u	$push20=, $pop50, $pop49
	i32.store8	sD+7($pop54), $pop20
	i32.const	$push48=, 0
	i64.load	$2=, sD($pop48)
	i32.const	$push47=, 0
	i32.const	$push21=, -341751747
	i32.mul 	$push22=, $0, $pop21
	i32.const	$push23=, 229283573
	i32.add 	$push46=, $pop22, $pop23
	tee_local	$push45=, $0=, $pop46
	i32.const	$push44=, 1103515245
	i32.mul 	$push24=, $pop45, $pop44
	i32.const	$push43=, 12345
	i32.add 	$push42=, $pop24, $pop43
	tee_local	$push41=, $1=, $pop42
	i32.store	myrnd.s($pop47), $pop41
	i32.const	$push40=, 0
	i32.const	$push39=, 16
	i32.shr_u	$push28=, $1, $pop39
	i32.const	$push26=, 2047
	i32.and 	$push29=, $pop28, $pop26
	i32.const	$push38=, 16
	i32.shr_u	$push25=, $0, $pop38
	i32.const	$push37=, 2047
	i32.and 	$push27=, $pop25, $pop37
	i32.add 	$push30=, $pop29, $pop27
	i64.extend_u/i32	$push31=, $pop30
	i64.const	$push32=, 35
	i64.shl 	$push33=, $pop31, $pop32
	i64.const	$push34=, 34359738367
	i64.and 	$push35=, $2, $pop34
	i64.or  	$push36=, $pop33, $pop35
	i64.store	sD($pop40), $pop36
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
	i64.load	$push0=, 0($1):p2align=0
	i64.store	0($0):p2align=0, $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3):p2align=0
	i64.store	0($pop2):p2align=0, $pop4
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
	i64.store	sE+8($pop0), $pop8
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
	.local  	i32, i32, i64
# BB#0:                                 # %if.end142
	i32.const	$push0=, 0
	i32.const	$push157=, 0
	i32.load	$push1=, myrnd.s($pop157)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push156=, $pop3, $pop4
	tee_local	$push155=, $0=, $pop156
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop155, $pop5
	i32.store8	sE($pop0), $pop6
	i32.const	$push154=, 0
	i32.const	$push153=, 1103515245
	i32.mul 	$push7=, $0, $pop153
	i32.const	$push152=, 12345
	i32.add 	$push151=, $pop7, $pop152
	tee_local	$push150=, $0=, $pop151
	i32.const	$push149=, 16
	i32.shr_u	$push8=, $pop150, $pop149
	i32.store8	sE+1($pop154), $pop8
	i32.const	$push148=, 0
	i32.const	$push147=, 1103515245
	i32.mul 	$push9=, $0, $pop147
	i32.const	$push146=, 12345
	i32.add 	$push145=, $pop9, $pop146
	tee_local	$push144=, $0=, $pop145
	i32.const	$push143=, 16
	i32.shr_u	$push10=, $pop144, $pop143
	i32.store8	sE+2($pop148), $pop10
	i32.const	$push142=, 0
	i32.const	$push141=, 1103515245
	i32.mul 	$push11=, $0, $pop141
	i32.const	$push140=, 12345
	i32.add 	$push139=, $pop11, $pop140
	tee_local	$push138=, $0=, $pop139
	i32.const	$push137=, 16
	i32.shr_u	$push12=, $pop138, $pop137
	i32.store8	sE+3($pop142), $pop12
	i32.const	$push136=, 0
	i32.const	$push135=, 1103515245
	i32.mul 	$push13=, $0, $pop135
	i32.const	$push134=, 12345
	i32.add 	$push133=, $pop13, $pop134
	tee_local	$push132=, $0=, $pop133
	i32.const	$push131=, 16
	i32.shr_u	$push14=, $pop132, $pop131
	i32.store8	sE+4($pop136), $pop14
	i32.const	$push130=, 0
	i32.const	$push129=, 1103515245
	i32.mul 	$push15=, $0, $pop129
	i32.const	$push128=, 12345
	i32.add 	$push127=, $pop15, $pop128
	tee_local	$push126=, $0=, $pop127
	i32.const	$push125=, 16
	i32.shr_u	$push16=, $pop126, $pop125
	i32.store8	sE+5($pop130), $pop16
	i32.const	$push124=, 0
	i32.const	$push123=, 1103515245
	i32.mul 	$push17=, $0, $pop123
	i32.const	$push122=, 12345
	i32.add 	$push121=, $pop17, $pop122
	tee_local	$push120=, $0=, $pop121
	i32.const	$push119=, 16
	i32.shr_u	$push18=, $pop120, $pop119
	i32.store8	sE+6($pop124), $pop18
	i32.const	$push118=, 0
	i32.const	$push117=, 1103515245
	i32.mul 	$push19=, $0, $pop117
	i32.const	$push116=, 12345
	i32.add 	$push115=, $pop19, $pop116
	tee_local	$push114=, $0=, $pop115
	i32.const	$push113=, 16
	i32.shr_u	$push20=, $pop114, $pop113
	i32.store8	sE+7($pop118), $pop20
	i32.const	$push112=, 0
	i32.const	$push111=, 1103515245
	i32.mul 	$push21=, $0, $pop111
	i32.const	$push110=, 12345
	i32.add 	$push109=, $pop21, $pop110
	tee_local	$push108=, $0=, $pop109
	i32.const	$push107=, 16
	i32.shr_u	$push22=, $pop108, $pop107
	i32.store8	sE+8($pop112), $pop22
	i32.const	$push106=, 0
	i32.const	$push105=, 1103515245
	i32.mul 	$push23=, $0, $pop105
	i32.const	$push104=, 12345
	i32.add 	$push103=, $pop23, $pop104
	tee_local	$push102=, $0=, $pop103
	i32.const	$push101=, 16
	i32.shr_u	$push24=, $pop102, $pop101
	i32.store8	sE+9($pop106), $pop24
	i32.const	$push100=, 0
	i32.const	$push99=, 1103515245
	i32.mul 	$push25=, $0, $pop99
	i32.const	$push98=, 12345
	i32.add 	$push97=, $pop25, $pop98
	tee_local	$push96=, $0=, $pop97
	i32.const	$push95=, 16
	i32.shr_u	$push26=, $pop96, $pop95
	i32.store8	sE+10($pop100), $pop26
	i32.const	$push94=, 0
	i32.const	$push93=, 1103515245
	i32.mul 	$push27=, $0, $pop93
	i32.const	$push92=, 12345
	i32.add 	$push91=, $pop27, $pop92
	tee_local	$push90=, $0=, $pop91
	i32.const	$push89=, 16
	i32.shr_u	$push28=, $pop90, $pop89
	i32.store8	sE+11($pop94), $pop28
	i32.const	$push88=, 0
	i32.const	$push87=, 1103515245
	i32.mul 	$push29=, $0, $pop87
	i32.const	$push86=, 12345
	i32.add 	$push85=, $pop29, $pop86
	tee_local	$push84=, $0=, $pop85
	i32.const	$push83=, 16
	i32.shr_u	$push30=, $pop84, $pop83
	i32.store8	sE+12($pop88), $pop30
	i32.const	$push82=, 0
	i32.const	$push81=, 1103515245
	i32.mul 	$push31=, $0, $pop81
	i32.const	$push80=, 12345
	i32.add 	$push79=, $pop31, $pop80
	tee_local	$push78=, $0=, $pop79
	i32.const	$push77=, 16
	i32.shr_u	$push32=, $pop78, $pop77
	i32.store8	sE+13($pop82), $pop32
	i32.const	$push76=, 0
	i32.const	$push75=, 1103515245
	i32.mul 	$push33=, $0, $pop75
	i32.const	$push74=, 12345
	i32.add 	$push73=, $pop33, $pop74
	tee_local	$push72=, $0=, $pop73
	i32.const	$push71=, 16
	i32.shr_u	$push34=, $pop72, $pop71
	i32.store8	sE+14($pop76), $pop34
	i32.const	$push70=, 0
	i32.const	$push69=, 1103515245
	i32.mul 	$push35=, $0, $pop69
	i32.const	$push68=, 12345
	i32.add 	$push67=, $pop35, $pop68
	tee_local	$push66=, $0=, $pop67
	i32.const	$push65=, 16
	i32.shr_u	$push36=, $pop66, $pop65
	i32.store8	sE+15($pop70), $pop36
	i32.const	$push64=, 0
	i64.load	$2=, sE+8($pop64)
	i32.const	$push63=, 0
	i32.const	$push37=, -341751747
	i32.mul 	$push38=, $0, $pop37
	i32.const	$push39=, 229283573
	i32.add 	$push62=, $pop38, $pop39
	tee_local	$push61=, $0=, $pop62
	i32.const	$push60=, 1103515245
	i32.mul 	$push40=, $pop61, $pop60
	i32.const	$push59=, 12345
	i32.add 	$push58=, $pop40, $pop59
	tee_local	$push57=, $1=, $pop58
	i32.store	myrnd.s($pop63), $pop57
	i32.const	$push56=, 0
	i32.const	$push55=, 16
	i32.shr_u	$push44=, $1, $pop55
	i32.const	$push42=, 2047
	i32.and 	$push45=, $pop44, $pop42
	i32.const	$push54=, 16
	i32.shr_u	$push41=, $0, $pop54
	i32.const	$push53=, 2047
	i32.and 	$push43=, $pop41, $pop53
	i32.add 	$push46=, $pop45, $pop43
	i64.extend_u/i32	$push47=, $pop46
	i64.const	$push48=, 35
	i64.shl 	$push49=, $pop47, $pop48
	i64.const	$push50=, 34359738367
	i64.and 	$push51=, $2, $pop50
	i64.or  	$push52=, $pop49, $pop51
	i64.store	sE+8($pop56), $pop52
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
	i64.load	$push0=, 0($1):p2align=0
	i64.store	0($0):p2align=0, $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3):p2align=0
	i64.store	0($pop2):p2align=0, $pop4
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
	i64.store	sF($pop0), $pop8
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
	.local  	i32, i32, i64
# BB#0:                                 # %if.end136
	i32.const	$push0=, 0
	i32.const	$push157=, 0
	i32.load	$push1=, myrnd.s($pop157)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push156=, $pop3, $pop4
	tee_local	$push155=, $0=, $pop156
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop155, $pop5
	i32.store8	sF($pop0), $pop6
	i32.const	$push154=, 0
	i32.const	$push153=, 1103515245
	i32.mul 	$push7=, $0, $pop153
	i32.const	$push152=, 12345
	i32.add 	$push151=, $pop7, $pop152
	tee_local	$push150=, $0=, $pop151
	i32.const	$push149=, 16
	i32.shr_u	$push8=, $pop150, $pop149
	i32.store8	sF+1($pop154), $pop8
	i32.const	$push148=, 0
	i32.const	$push147=, 1103515245
	i32.mul 	$push9=, $0, $pop147
	i32.const	$push146=, 12345
	i32.add 	$push145=, $pop9, $pop146
	tee_local	$push144=, $0=, $pop145
	i32.const	$push143=, 16
	i32.shr_u	$push10=, $pop144, $pop143
	i32.store8	sF+2($pop148), $pop10
	i32.const	$push142=, 0
	i32.const	$push141=, 1103515245
	i32.mul 	$push11=, $0, $pop141
	i32.const	$push140=, 12345
	i32.add 	$push139=, $pop11, $pop140
	tee_local	$push138=, $0=, $pop139
	i32.const	$push137=, 16
	i32.shr_u	$push12=, $pop138, $pop137
	i32.store8	sF+3($pop142), $pop12
	i32.const	$push136=, 0
	i32.const	$push135=, 1103515245
	i32.mul 	$push13=, $0, $pop135
	i32.const	$push134=, 12345
	i32.add 	$push133=, $pop13, $pop134
	tee_local	$push132=, $0=, $pop133
	i32.const	$push131=, 16
	i32.shr_u	$push14=, $pop132, $pop131
	i32.store8	sF+4($pop136), $pop14
	i32.const	$push130=, 0
	i32.const	$push129=, 1103515245
	i32.mul 	$push15=, $0, $pop129
	i32.const	$push128=, 12345
	i32.add 	$push127=, $pop15, $pop128
	tee_local	$push126=, $0=, $pop127
	i32.const	$push125=, 16
	i32.shr_u	$push16=, $pop126, $pop125
	i32.store8	sF+5($pop130), $pop16
	i32.const	$push124=, 0
	i32.const	$push123=, 1103515245
	i32.mul 	$push17=, $0, $pop123
	i32.const	$push122=, 12345
	i32.add 	$push121=, $pop17, $pop122
	tee_local	$push120=, $0=, $pop121
	i32.const	$push119=, 16
	i32.shr_u	$push18=, $pop120, $pop119
	i32.store8	sF+6($pop124), $pop18
	i32.const	$push118=, 0
	i32.const	$push117=, 1103515245
	i32.mul 	$push19=, $0, $pop117
	i32.const	$push116=, 12345
	i32.add 	$push115=, $pop19, $pop116
	tee_local	$push114=, $0=, $pop115
	i32.const	$push113=, 16
	i32.shr_u	$push20=, $pop114, $pop113
	i32.store8	sF+7($pop118), $pop20
	i32.const	$push112=, 0
	i32.const	$push111=, 1103515245
	i32.mul 	$push21=, $0, $pop111
	i32.const	$push110=, 12345
	i32.add 	$push109=, $pop21, $pop110
	tee_local	$push108=, $0=, $pop109
	i32.const	$push107=, 16
	i32.shr_u	$push22=, $pop108, $pop107
	i32.store8	sF+8($pop112), $pop22
	i32.const	$push106=, 0
	i32.const	$push105=, 1103515245
	i32.mul 	$push23=, $0, $pop105
	i32.const	$push104=, 12345
	i32.add 	$push103=, $pop23, $pop104
	tee_local	$push102=, $0=, $pop103
	i32.const	$push101=, 16
	i32.shr_u	$push24=, $pop102, $pop101
	i32.store8	sF+9($pop106), $pop24
	i32.const	$push100=, 0
	i32.const	$push99=, 1103515245
	i32.mul 	$push25=, $0, $pop99
	i32.const	$push98=, 12345
	i32.add 	$push97=, $pop25, $pop98
	tee_local	$push96=, $0=, $pop97
	i32.const	$push95=, 16
	i32.shr_u	$push26=, $pop96, $pop95
	i32.store8	sF+10($pop100), $pop26
	i32.const	$push94=, 0
	i32.const	$push93=, 1103515245
	i32.mul 	$push27=, $0, $pop93
	i32.const	$push92=, 12345
	i32.add 	$push91=, $pop27, $pop92
	tee_local	$push90=, $0=, $pop91
	i32.const	$push89=, 16
	i32.shr_u	$push28=, $pop90, $pop89
	i32.store8	sF+11($pop94), $pop28
	i32.const	$push88=, 0
	i32.const	$push87=, 1103515245
	i32.mul 	$push29=, $0, $pop87
	i32.const	$push86=, 12345
	i32.add 	$push85=, $pop29, $pop86
	tee_local	$push84=, $0=, $pop85
	i32.const	$push83=, 16
	i32.shr_u	$push30=, $pop84, $pop83
	i32.store8	sF+12($pop88), $pop30
	i32.const	$push82=, 0
	i32.const	$push81=, 1103515245
	i32.mul 	$push31=, $0, $pop81
	i32.const	$push80=, 12345
	i32.add 	$push79=, $pop31, $pop80
	tee_local	$push78=, $0=, $pop79
	i32.const	$push77=, 16
	i32.shr_u	$push32=, $pop78, $pop77
	i32.store8	sF+13($pop82), $pop32
	i32.const	$push76=, 0
	i32.const	$push75=, 1103515245
	i32.mul 	$push33=, $0, $pop75
	i32.const	$push74=, 12345
	i32.add 	$push73=, $pop33, $pop74
	tee_local	$push72=, $0=, $pop73
	i32.const	$push71=, 16
	i32.shr_u	$push34=, $pop72, $pop71
	i32.store8	sF+14($pop76), $pop34
	i32.const	$push70=, 0
	i32.const	$push69=, 1103515245
	i32.mul 	$push35=, $0, $pop69
	i32.const	$push68=, 12345
	i32.add 	$push67=, $pop35, $pop68
	tee_local	$push66=, $0=, $pop67
	i32.const	$push65=, 16
	i32.shr_u	$push36=, $pop66, $pop65
	i32.store8	sF+15($pop70), $pop36
	i32.const	$push64=, 0
	i64.load	$2=, sF($pop64)
	i32.const	$push63=, 0
	i32.const	$push37=, -341751747
	i32.mul 	$push38=, $0, $pop37
	i32.const	$push39=, 229283573
	i32.add 	$push62=, $pop38, $pop39
	tee_local	$push61=, $0=, $pop62
	i32.const	$push60=, 1103515245
	i32.mul 	$push40=, $pop61, $pop60
	i32.const	$push59=, 12345
	i32.add 	$push58=, $pop40, $pop59
	tee_local	$push57=, $1=, $pop58
	i32.store	myrnd.s($pop63), $pop57
	i32.const	$push56=, 0
	i32.const	$push55=, 16
	i32.shr_u	$push44=, $1, $pop55
	i32.const	$push42=, 2047
	i32.and 	$push45=, $pop44, $pop42
	i32.const	$push54=, 16
	i32.shr_u	$push41=, $0, $pop54
	i32.const	$push53=, 2047
	i32.and 	$push43=, $pop41, $pop53
	i32.add 	$push46=, $pop45, $pop43
	i64.extend_u/i32	$push47=, $pop46
	i64.const	$push48=, 35
	i64.shl 	$push49=, $pop47, $pop48
	i64.const	$push50=, 34359738367
	i64.and 	$push51=, $2, $pop50
	i64.or  	$push52=, $pop49, $pop51
	i64.store	sF($pop56), $pop52
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
	i64.load	$push0=, 0($1):p2align=0
	i64.store	0($0):p2align=0, $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i32.load8_u	$push4=, 0($pop3)
	i32.store8	0($pop2), $pop4
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
	i32.const	$push0=, 0
	i32.load8_u	$push1=, sG($pop0)
	i32.const	$push2=, 2
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 63
	i32.and 	$push6=, $pop4, $pop5
                                        # fallthrough-return: $pop6
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
	i32.load8_u	$push1=, sG($pop0)
	i32.const	$push2=, 2
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 63
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
	i32.load8_u	$push1=, sG($pop0)
	i32.const	$push2=, 2
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push14=, 0
	i32.load8_u	$push13=, sG($pop14)
	tee_local	$push12=, $1=, $pop13
	i32.const	$push3=, 2
	i32.shr_u	$push4=, $pop12, $pop3
	i32.add 	$push11=, $pop4, $0
	tee_local	$push10=, $0=, $pop11
	i32.const	$push9=, 2
	i32.shl 	$push5=, $pop10, $pop9
	i32.const	$push1=, 3
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push6=, $pop5, $pop2
	i32.store8	sG($pop0), $pop6
	i32.const	$push7=, 63
	i32.and 	$push8=, $0, $pop7
                                        # fallthrough-return: $pop8
	.endfunc
.Lfunc_end41:
	.size	fn3G, .Lfunc_end41-fn3G

	.section	.text.testG,"ax",@progbits
	.hidden	testG
	.globl	testG
	.type	testG,@function
testG:                                  # @testG
	.local  	i32, i32, i32
# BB#0:                                 # %if.end155
	i32.const	$push0=, 0
	i32.const	$push94=, 0
	i32.load	$push1=, myrnd.s($pop94)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push93=, $pop3, $pop4
	tee_local	$push92=, $0=, $pop93
	i32.const	$push91=, 1103515245
	i32.mul 	$push5=, $pop92, $pop91
	i32.const	$push90=, 12345
	i32.add 	$push89=, $pop5, $pop90
	tee_local	$push88=, $1=, $pop89
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop88, $pop6
	i32.store8	sG+1($pop0), $pop7
	i32.const	$push87=, 0
	i32.const	$push86=, 1103515245
	i32.mul 	$push8=, $1, $pop86
	i32.const	$push85=, 12345
	i32.add 	$push84=, $pop8, $pop85
	tee_local	$push83=, $1=, $pop84
	i32.const	$push82=, 16
	i32.shr_u	$push9=, $pop83, $pop82
	i32.store8	sG+2($pop87), $pop9
	i32.const	$push81=, 0
	i32.const	$push80=, 1103515245
	i32.mul 	$push10=, $1, $pop80
	i32.const	$push79=, 12345
	i32.add 	$push78=, $pop10, $pop79
	tee_local	$push77=, $1=, $pop78
	i32.const	$push76=, 16
	i32.shr_u	$push11=, $pop77, $pop76
	i32.store8	sG+3($pop81), $pop11
	i32.const	$push75=, 0
	i32.const	$push74=, 1103515245
	i32.mul 	$push12=, $1, $pop74
	i32.const	$push73=, 12345
	i32.add 	$push72=, $pop12, $pop73
	tee_local	$push71=, $1=, $pop72
	i32.const	$push70=, 16
	i32.shr_u	$push13=, $pop71, $pop70
	i32.store8	sG+4($pop75), $pop13
	i32.const	$push69=, 0
	i32.const	$push68=, 1103515245
	i32.mul 	$push14=, $1, $pop68
	i32.const	$push67=, 12345
	i32.add 	$push66=, $pop14, $pop67
	tee_local	$push65=, $1=, $pop66
	i32.const	$push64=, 16
	i32.shr_u	$push15=, $pop65, $pop64
	i32.store8	sG+5($pop69), $pop15
	i32.const	$push63=, 0
	i32.const	$push62=, 1103515245
	i32.mul 	$push16=, $1, $pop62
	i32.const	$push61=, 12345
	i32.add 	$push60=, $pop16, $pop61
	tee_local	$push59=, $1=, $pop60
	i32.const	$push58=, 16
	i32.shr_u	$push17=, $pop59, $pop58
	i32.store8	sG+6($pop63), $pop17
	i32.const	$push57=, 0
	i32.const	$push56=, 1103515245
	i32.mul 	$push18=, $1, $pop56
	i32.const	$push55=, 12345
	i32.add 	$push54=, $pop18, $pop55
	tee_local	$push53=, $1=, $pop54
	i32.const	$push52=, 16
	i32.shr_u	$push19=, $pop53, $pop52
	i32.store8	sG+7($pop57), $pop19
	i32.const	$push51=, 0
	i32.const	$push50=, 1103515245
	i32.mul 	$push20=, $1, $pop50
	i32.const	$push49=, 12345
	i32.add 	$push48=, $pop20, $pop49
	tee_local	$push47=, $1=, $pop48
	i32.const	$push46=, 16
	i32.shr_u	$push21=, $pop47, $pop46
	i32.store8	sG+8($pop51), $pop21
	i32.const	$push45=, 0
	i32.const	$push22=, -341751747
	i32.mul 	$push23=, $1, $pop22
	i32.const	$push24=, 229283573
	i32.add 	$push44=, $pop23, $pop24
	tee_local	$push43=, $1=, $pop44
	i32.const	$push42=, 1103515245
	i32.mul 	$push25=, $pop43, $pop42
	i32.const	$push41=, 12345
	i32.add 	$push40=, $pop25, $pop41
	tee_local	$push39=, $2=, $pop40
	i32.store	myrnd.s($pop45), $pop39
	i32.const	$push38=, 0
	i32.const	$push37=, 16
	i32.shr_u	$push27=, $2, $pop37
	i32.const	$push36=, 16
	i32.shr_u	$push26=, $1, $pop36
	i32.add 	$push28=, $pop27, $pop26
	i32.const	$push29=, 2
	i32.shl 	$push30=, $pop28, $pop29
	i32.const	$push35=, 16
	i32.shr_u	$push31=, $0, $pop35
	i32.const	$push32=, 3
	i32.and 	$push33=, $pop31, $pop32
	i32.or  	$push34=, $pop30, $pop33
	i32.store8	sG($pop38), $pop34
                                        # fallthrough-return
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
	i64.load	$push0=, 0($1):p2align=0
	i64.store	0($0):p2align=0, $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i32.load16_u	$push4=, 0($pop3):p2align=0
	i32.store16	0($pop2):p2align=0, $pop4
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
	i32.const	$push0=, 0
	i32.load8_u	$push1=, sH+1($pop0)
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 255
	i32.and 	$push4=, $pop2, $pop3
                                        # fallthrough-return: $pop4
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
	i32.load8_u	$push1=, sH+1($pop0)
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 255
	i32.and 	$push4=, $pop2, $pop3
	i32.const	$push5=, 15
	i32.rem_u	$push6=, $pop4, $pop5
                                        # fallthrough-return: $pop6
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
	i32.load8_u	$push1=, sH+1($pop0)
                                        # fallthrough-return: $pop1
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
	i32.const	$push6=, 0
	i32.load8_u	$push1=, sH+1($pop6)
	i32.add 	$push5=, $pop1, $0
	tee_local	$push4=, $0=, $pop5
	i32.store8	sH+1($pop0), $pop4
	i32.const	$push2=, 255
	i32.and 	$push3=, $0, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end47:
	.size	fn3H, .Lfunc_end47-fn3H

	.section	.text.testH,"ax",@progbits
	.hidden	testH
	.globl	testH
	.type	testH,@function
testH:                                  # @testH
	.local  	i32, i32
# BB#0:                                 # %if.end136
	i32.const	$push0=, 0
	i32.const	$push98=, 0
	i32.load	$push1=, myrnd.s($pop98)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push97=, $pop3, $pop4
	tee_local	$push96=, $0=, $pop97
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop96, $pop5
	i32.store8	sH($pop0), $pop6
	i32.const	$push95=, 0
	i32.const	$push94=, 1103515245
	i32.mul 	$push7=, $0, $pop94
	i32.const	$push93=, 12345
	i32.add 	$push92=, $pop7, $pop93
	tee_local	$push91=, $0=, $pop92
	i32.const	$push90=, 16
	i32.shr_u	$push8=, $pop91, $pop90
	i32.store8	sH+1($pop95), $pop8
	i32.const	$push89=, 0
	i32.const	$push88=, 1103515245
	i32.mul 	$push9=, $0, $pop88
	i32.const	$push87=, 12345
	i32.add 	$push86=, $pop9, $pop87
	tee_local	$push85=, $0=, $pop86
	i32.const	$push84=, 16
	i32.shr_u	$push10=, $pop85, $pop84
	i32.store8	sH+2($pop89), $pop10
	i32.const	$push83=, 0
	i32.const	$push82=, 1103515245
	i32.mul 	$push11=, $0, $pop82
	i32.const	$push81=, 12345
	i32.add 	$push80=, $pop11, $pop81
	tee_local	$push79=, $0=, $pop80
	i32.const	$push78=, 16
	i32.shr_u	$push12=, $pop79, $pop78
	i32.store8	sH+3($pop83), $pop12
	i32.const	$push77=, 0
	i32.const	$push76=, 1103515245
	i32.mul 	$push13=, $0, $pop76
	i32.const	$push75=, 12345
	i32.add 	$push74=, $pop13, $pop75
	tee_local	$push73=, $0=, $pop74
	i32.const	$push72=, 16
	i32.shr_u	$push14=, $pop73, $pop72
	i32.store8	sH+4($pop77), $pop14
	i32.const	$push71=, 0
	i32.const	$push70=, 1103515245
	i32.mul 	$push15=, $0, $pop70
	i32.const	$push69=, 12345
	i32.add 	$push68=, $pop15, $pop69
	tee_local	$push67=, $0=, $pop68
	i32.const	$push66=, 16
	i32.shr_u	$push16=, $pop67, $pop66
	i32.store8	sH+5($pop71), $pop16
	i32.const	$push65=, 0
	i32.const	$push64=, 1103515245
	i32.mul 	$push17=, $0, $pop64
	i32.const	$push63=, 12345
	i32.add 	$push62=, $pop17, $pop63
	tee_local	$push61=, $0=, $pop62
	i32.const	$push60=, 16
	i32.shr_u	$push18=, $pop61, $pop60
	i32.store8	sH+6($pop65), $pop18
	i32.const	$push59=, 0
	i32.const	$push58=, 1103515245
	i32.mul 	$push19=, $0, $pop58
	i32.const	$push57=, 12345
	i32.add 	$push56=, $pop19, $pop57
	tee_local	$push55=, $0=, $pop56
	i32.const	$push54=, 16
	i32.shr_u	$push20=, $pop55, $pop54
	i32.store8	sH+7($pop59), $pop20
	i32.const	$push53=, 0
	i32.const	$push52=, 1103515245
	i32.mul 	$push21=, $0, $pop52
	i32.const	$push51=, 12345
	i32.add 	$push50=, $pop21, $pop51
	tee_local	$push49=, $0=, $pop50
	i32.const	$push48=, 16
	i32.shr_u	$push22=, $pop49, $pop48
	i32.store8	sH+8($pop53), $pop22
	i32.const	$push47=, 0
	i32.const	$push46=, 1103515245
	i32.mul 	$push23=, $0, $pop46
	i32.const	$push45=, 12345
	i32.add 	$push44=, $pop23, $pop45
	tee_local	$push43=, $0=, $pop44
	i32.const	$push42=, 16
	i32.shr_u	$push24=, $pop43, $pop42
	i32.store8	sH+9($pop47), $pop24
	i32.const	$push41=, 0
	i32.const	$push25=, -341751747
	i32.mul 	$push26=, $0, $pop25
	i32.const	$push27=, 229283573
	i32.add 	$push40=, $pop26, $pop27
	tee_local	$push39=, $0=, $pop40
	i32.const	$push38=, 1103515245
	i32.mul 	$push28=, $pop39, $pop38
	i32.const	$push37=, 12345
	i32.add 	$push36=, $pop28, $pop37
	tee_local	$push35=, $1=, $pop36
	i32.store	myrnd.s($pop41), $pop35
	i32.const	$push34=, 0
	i32.const	$push33=, 16
	i32.shr_u	$push30=, $1, $pop33
	i32.const	$push32=, 16
	i32.shr_u	$push29=, $0, $pop32
	i32.add 	$push31=, $pop30, $pop29
	i32.store8	sH+1($pop34), $pop31
                                        # fallthrough-return
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
	i64.load	$push0=, 0($1):p2align=0
	i64.store	0($0):p2align=0, $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i32.load8_u	$push4=, 0($pop3)
	i32.store8	0($pop2), $pop4
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
	i32.load8_u	$push1=, sI($pop0)
	i32.const	$push2=, 7
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 1
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
	i32.load8_u	$push1=, sI($pop0)
	i32.const	$push2=, 7
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 1
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
	i32.load8_u	$push1=, sI($pop0)
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
	i32.load8_u	$push13=, sI($pop14)
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
	i32.store8	sI($pop0), $pop6
	i32.const	$push7=, 1
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
	.local  	i32, i32, i32
# BB#0:                                 # %if.end155
	i32.const	$push0=, 0
	i32.const	$push94=, 0
	i32.load	$push1=, myrnd.s($pop94)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push93=, $pop3, $pop4
	tee_local	$push92=, $0=, $pop93
	i32.const	$push91=, 1103515245
	i32.mul 	$push5=, $pop92, $pop91
	i32.const	$push90=, 12345
	i32.add 	$push89=, $pop5, $pop90
	tee_local	$push88=, $1=, $pop89
	i32.const	$push6=, 16
	i32.shr_u	$push7=, $pop88, $pop6
	i32.store8	sI+1($pop0), $pop7
	i32.const	$push87=, 0
	i32.const	$push86=, 1103515245
	i32.mul 	$push8=, $1, $pop86
	i32.const	$push85=, 12345
	i32.add 	$push84=, $pop8, $pop85
	tee_local	$push83=, $1=, $pop84
	i32.const	$push82=, 16
	i32.shr_u	$push9=, $pop83, $pop82
	i32.store8	sI+2($pop87), $pop9
	i32.const	$push81=, 0
	i32.const	$push80=, 1103515245
	i32.mul 	$push10=, $1, $pop80
	i32.const	$push79=, 12345
	i32.add 	$push78=, $pop10, $pop79
	tee_local	$push77=, $1=, $pop78
	i32.const	$push76=, 16
	i32.shr_u	$push11=, $pop77, $pop76
	i32.store8	sI+3($pop81), $pop11
	i32.const	$push75=, 0
	i32.const	$push74=, 1103515245
	i32.mul 	$push12=, $1, $pop74
	i32.const	$push73=, 12345
	i32.add 	$push72=, $pop12, $pop73
	tee_local	$push71=, $1=, $pop72
	i32.const	$push70=, 16
	i32.shr_u	$push13=, $pop71, $pop70
	i32.store8	sI+4($pop75), $pop13
	i32.const	$push69=, 0
	i32.const	$push68=, 1103515245
	i32.mul 	$push14=, $1, $pop68
	i32.const	$push67=, 12345
	i32.add 	$push66=, $pop14, $pop67
	tee_local	$push65=, $1=, $pop66
	i32.const	$push64=, 16
	i32.shr_u	$push15=, $pop65, $pop64
	i32.store8	sI+5($pop69), $pop15
	i32.const	$push63=, 0
	i32.const	$push62=, 1103515245
	i32.mul 	$push16=, $1, $pop62
	i32.const	$push61=, 12345
	i32.add 	$push60=, $pop16, $pop61
	tee_local	$push59=, $1=, $pop60
	i32.const	$push58=, 16
	i32.shr_u	$push17=, $pop59, $pop58
	i32.store8	sI+6($pop63), $pop17
	i32.const	$push57=, 0
	i32.const	$push56=, 1103515245
	i32.mul 	$push18=, $1, $pop56
	i32.const	$push55=, 12345
	i32.add 	$push54=, $pop18, $pop55
	tee_local	$push53=, $1=, $pop54
	i32.const	$push52=, 16
	i32.shr_u	$push19=, $pop53, $pop52
	i32.store8	sI+7($pop57), $pop19
	i32.const	$push51=, 0
	i32.const	$push50=, 1103515245
	i32.mul 	$push20=, $1, $pop50
	i32.const	$push49=, 12345
	i32.add 	$push48=, $pop20, $pop49
	tee_local	$push47=, $1=, $pop48
	i32.const	$push46=, 16
	i32.shr_u	$push21=, $pop47, $pop46
	i32.store8	sI+8($pop51), $pop21
	i32.const	$push45=, 0
	i32.const	$push22=, -341751747
	i32.mul 	$push23=, $1, $pop22
	i32.const	$push24=, 229283573
	i32.add 	$push44=, $pop23, $pop24
	tee_local	$push43=, $1=, $pop44
	i32.const	$push42=, 1103515245
	i32.mul 	$push25=, $pop43, $pop42
	i32.const	$push41=, 12345
	i32.add 	$push40=, $pop25, $pop41
	tee_local	$push39=, $2=, $pop40
	i32.store	myrnd.s($pop45), $pop39
	i32.const	$push38=, 0
	i32.const	$push37=, 16
	i32.shr_u	$push27=, $2, $pop37
	i32.const	$push36=, 16
	i32.shr_u	$push26=, $1, $pop36
	i32.add 	$push28=, $pop27, $pop26
	i32.const	$push29=, 7
	i32.shl 	$push30=, $pop28, $pop29
	i32.const	$push35=, 16
	i32.shr_u	$push31=, $0, $pop35
	i32.const	$push32=, 127
	i32.and 	$push33=, $pop31, $pop32
	i32.or  	$push34=, $pop30, $pop33
	i32.store8	sI($pop38), $pop34
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
	i32.load	$push0=, 0($1):p2align=0
	i32.store	0($0):p2align=1, $pop0
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
	i32.store16	sJ($pop0), $pop6
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
	i32.const	$push78=, 0
	i32.const	$push77=, 0
	i32.load	$push0=, myrnd.s($pop77)
	i32.const	$push76=, 1103515245
	i32.mul 	$push1=, $pop0, $pop76
	i32.const	$push75=, 12345
	i32.add 	$push74=, $pop1, $pop75
	tee_local	$push73=, $0=, $pop74
	i32.const	$push72=, 16
	i32.shr_u	$push2=, $pop73, $pop72
	i32.store8	sJ($pop78), $pop2
	i32.const	$push71=, 0
	i32.const	$push70=, 1103515245
	i32.mul 	$push3=, $0, $pop70
	i32.const	$push69=, 12345
	i32.add 	$push68=, $pop3, $pop69
	tee_local	$push67=, $0=, $pop68
	i32.const	$push66=, 16
	i32.shr_u	$push4=, $pop67, $pop66
	i32.store8	sJ+1($pop71), $pop4
	i32.const	$push65=, 0
	i32.const	$push64=, 1103515245
	i32.mul 	$push5=, $0, $pop64
	i32.const	$push63=, 12345
	i32.add 	$push62=, $pop5, $pop63
	tee_local	$push61=, $0=, $pop62
	i32.const	$push60=, 16
	i32.shr_u	$push6=, $pop61, $pop60
	i32.store8	sJ+2($pop65), $pop6
	i32.const	$push59=, 0
	i32.const	$push58=, 1103515245
	i32.mul 	$push7=, $0, $pop58
	i32.const	$push57=, 12345
	i32.add 	$push56=, $pop7, $pop57
	tee_local	$push55=, $0=, $pop56
	i32.const	$push54=, 16
	i32.shr_u	$push8=, $pop55, $pop54
	i32.store8	sJ+3($pop59), $pop8
	i32.const	$push53=, 0
	i32.const	$push52=, 1103515245
	i32.mul 	$push11=, $0, $pop52
	i32.const	$push51=, 12345
	i32.add 	$push50=, $pop11, $pop51
	tee_local	$push49=, $0=, $pop50
	i32.const	$push48=, 16
	i32.shr_u	$push47=, $pop49, $pop48
	tee_local	$push46=, $1=, $pop47
	i32.const	$push45=, 9
	i32.shl 	$push12=, $pop46, $pop45
	i32.const	$push44=, 0
	i32.load16_u	$push9=, sJ($pop44)
	i32.const	$push43=, 511
	i32.and 	$push10=, $pop9, $pop43
	i32.or  	$push13=, $pop12, $pop10
	i32.store16	sJ($pop53), $pop13
	i32.const	$push42=, 0
	i32.const	$push41=, 1103515245
	i32.mul 	$push14=, $0, $pop41
	i32.const	$push40=, 12345
	i32.add 	$push39=, $pop14, $pop40
	tee_local	$push38=, $0=, $pop39
	i32.store	myrnd.s($pop42), $pop38
	block   	
	i32.const	$push37=, 16
	i32.shr_u	$push36=, $0, $pop37
	tee_local	$push35=, $2=, $pop36
	i32.add 	$push15=, $pop35, $1
	i32.const	$push34=, 0
	i32.load	$push33=, sJ($pop34)
	tee_local	$push32=, $1=, $pop33
	i32.const	$push31=, 9
	i32.shr_u	$push16=, $pop32, $pop31
	i32.add 	$push17=, $pop16, $2
	i32.xor 	$push18=, $pop15, $pop17
	i32.const	$push19=, 127
	i32.and 	$push20=, $pop18, $pop19
	br_if   	0, $pop20       # 0: down to label0
# BB#1:                                 # %if.end142
	i32.const	$push90=, 0
	i32.const	$push21=, -2139243339
	i32.mul 	$push22=, $0, $pop21
	i32.const	$push23=, -1492899873
	i32.add 	$push89=, $pop22, $pop23
	tee_local	$push88=, $0=, $pop89
	i32.const	$push87=, 1103515245
	i32.mul 	$push24=, $pop88, $pop87
	i32.const	$push86=, 12345
	i32.add 	$push85=, $pop24, $pop86
	tee_local	$push84=, $2=, $pop85
	i32.store	myrnd.s($pop90), $pop84
	i32.const	$push83=, 0
	i32.const	$push82=, 16
	i32.shr_u	$push26=, $2, $pop82
	i32.const	$push81=, 16
	i32.shr_u	$push25=, $0, $pop81
	i32.add 	$push27=, $pop26, $pop25
	i32.const	$push80=, 9
	i32.shl 	$push28=, $pop27, $pop80
	i32.const	$push79=, 511
	i32.and 	$push29=, $1, $pop79
	i32.or  	$push30=, $pop28, $pop29
	i32.store16	sJ($pop83), $pop30
	return
.LBB60_2:                               # %if.then
	end_block                       # label0:
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
	i32.load	$push0=, 0($1):p2align=0
	i32.store	0($0), $pop0
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
	i32.store	sK($pop0), $pop5
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

	.section	.text.retmeL,"ax",@progbits
	.hidden	retmeL
	.globl	retmeL
	.type	retmeL,@function
retmeL:                                 # @retmeL
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1):p2align=0
	i64.store	0($0):p2align=2, $pop0
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
	i32.store	sL($pop0), $pop5
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
	i32.const	$push105=, 0
	i32.const	$push104=, 0
	i32.load	$push0=, myrnd.s($pop104)
	i32.const	$push103=, 1103515245
	i32.mul 	$push1=, $pop0, $pop103
	i32.const	$push102=, 12345
	i32.add 	$push101=, $pop1, $pop102
	tee_local	$push100=, $0=, $pop101
	i32.const	$push99=, 16
	i32.shr_u	$push2=, $pop100, $pop99
	i32.store8	sL($pop105), $pop2
	i32.const	$push98=, 0
	i32.const	$push97=, 1103515245
	i32.mul 	$push3=, $0, $pop97
	i32.const	$push96=, 12345
	i32.add 	$push95=, $pop3, $pop96
	tee_local	$push94=, $0=, $pop95
	i32.const	$push93=, 16
	i32.shr_u	$push4=, $pop94, $pop93
	i32.store8	sL+1($pop98), $pop4
	i32.const	$push92=, 0
	i32.const	$push91=, 1103515245
	i32.mul 	$push5=, $0, $pop91
	i32.const	$push90=, 12345
	i32.add 	$push89=, $pop5, $pop90
	tee_local	$push88=, $0=, $pop89
	i32.const	$push87=, 16
	i32.shr_u	$push6=, $pop88, $pop87
	i32.store8	sL+2($pop92), $pop6
	i32.const	$push86=, 0
	i32.const	$push85=, 1103515245
	i32.mul 	$push7=, $0, $pop85
	i32.const	$push84=, 12345
	i32.add 	$push83=, $pop7, $pop84
	tee_local	$push82=, $0=, $pop83
	i32.const	$push81=, 16
	i32.shr_u	$push8=, $pop82, $pop81
	i32.store8	sL+3($pop86), $pop8
	i32.const	$push80=, 0
	i32.const	$push79=, 1103515245
	i32.mul 	$push9=, $0, $pop79
	i32.const	$push78=, 12345
	i32.add 	$push77=, $pop9, $pop78
	tee_local	$push76=, $0=, $pop77
	i32.const	$push75=, 16
	i32.shr_u	$push10=, $pop76, $pop75
	i32.store8	sL+4($pop80), $pop10
	i32.const	$push74=, 0
	i32.const	$push73=, 1103515245
	i32.mul 	$push11=, $0, $pop73
	i32.const	$push72=, 12345
	i32.add 	$push71=, $pop11, $pop72
	tee_local	$push70=, $0=, $pop71
	i32.const	$push69=, 16
	i32.shr_u	$push12=, $pop70, $pop69
	i32.store8	sL+5($pop74), $pop12
	i32.const	$push68=, 0
	i32.const	$push67=, 1103515245
	i32.mul 	$push13=, $0, $pop67
	i32.const	$push66=, 12345
	i32.add 	$push65=, $pop13, $pop66
	tee_local	$push64=, $0=, $pop65
	i32.const	$push63=, 16
	i32.shr_u	$push14=, $pop64, $pop63
	i32.store8	sL+6($pop68), $pop14
	i32.const	$push62=, 0
	i32.const	$push61=, 1103515245
	i32.mul 	$push15=, $0, $pop61
	i32.const	$push60=, 12345
	i32.add 	$push59=, $pop15, $pop60
	tee_local	$push58=, $0=, $pop59
	i32.const	$push57=, 16
	i32.shr_u	$push16=, $pop58, $pop57
	i32.store8	sL+7($pop62), $pop16
	i32.const	$push56=, 0
	i32.load	$1=, sL($pop56)
	i32.const	$push55=, 0
	i32.const	$push54=, 1103515245
	i32.mul 	$push17=, $0, $pop54
	i32.const	$push53=, 12345
	i32.add 	$push52=, $pop17, $pop53
	tee_local	$push51=, $2=, $pop52
	i32.const	$push50=, 1103515245
	i32.mul 	$push18=, $pop51, $pop50
	i32.const	$push49=, 12345
	i32.add 	$push48=, $pop18, $pop49
	tee_local	$push47=, $0=, $pop48
	i32.store	myrnd.s($pop55), $pop47
	i32.const	$push46=, 0
	i32.const	$push45=, 16
	i32.shr_u	$push44=, $2, $pop45
	tee_local	$push43=, $2=, $pop44
	i32.const	$push42=, 63
	i32.and 	$push20=, $pop43, $pop42
	i32.const	$push41=, -64
	i32.and 	$push19=, $1, $pop41
	i32.or  	$push40=, $pop20, $pop19
	tee_local	$push39=, $1=, $pop40
	i32.store	sL($pop46), $pop39
	block   	
	i32.const	$push38=, 16
	i32.shr_u	$push37=, $0, $pop38
	tee_local	$push36=, $3=, $pop37
	i32.add 	$push22=, $pop36, $2
	i32.add 	$push21=, $1, $3
	i32.xor 	$push23=, $pop22, $pop21
	i32.const	$push35=, 63
	i32.and 	$push24=, $pop23, $pop35
	br_if   	0, $pop24       # 0: down to label1
# BB#1:                                 # %if.end75
	i32.const	$push117=, 0
	i32.const	$push25=, -2139243339
	i32.mul 	$push26=, $0, $pop25
	i32.const	$push27=, -1492899873
	i32.add 	$push116=, $pop26, $pop27
	tee_local	$push115=, $0=, $pop116
	i32.const	$push114=, 1103515245
	i32.mul 	$push28=, $pop115, $pop114
	i32.const	$push113=, 12345
	i32.add 	$push112=, $pop28, $pop113
	tee_local	$push111=, $2=, $pop112
	i32.store	myrnd.s($pop117), $pop111
	i32.const	$push110=, 0
	i32.const	$push109=, 16
	i32.shr_u	$push30=, $2, $pop109
	i32.const	$push108=, 16
	i32.shr_u	$push29=, $0, $pop108
	i32.add 	$push31=, $pop30, $pop29
	i32.const	$push107=, 63
	i32.and 	$push32=, $pop31, $pop107
	i32.const	$push106=, -64
	i32.and 	$push33=, $1, $pop106
	i32.or  	$push34=, $pop32, $pop33
	i32.store	sL($pop110), $pop34
	return
.LBB72_2:                               # %if.then
	end_block                       # label1:
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
	i64.load	$push0=, 0($1):p2align=0
	i64.store	0($0):p2align=2, $pop0
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
	i32.store	sM+4($pop0), $pop5
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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push105=, 0
	i32.const	$push104=, 0
	i32.load	$push0=, myrnd.s($pop104)
	i32.const	$push103=, 1103515245
	i32.mul 	$push1=, $pop0, $pop103
	i32.const	$push102=, 12345
	i32.add 	$push101=, $pop1, $pop102
	tee_local	$push100=, $0=, $pop101
	i32.const	$push99=, 16
	i32.shr_u	$push2=, $pop100, $pop99
	i32.store8	sM($pop105), $pop2
	i32.const	$push98=, 0
	i32.const	$push97=, 1103515245
	i32.mul 	$push3=, $0, $pop97
	i32.const	$push96=, 12345
	i32.add 	$push95=, $pop3, $pop96
	tee_local	$push94=, $0=, $pop95
	i32.const	$push93=, 16
	i32.shr_u	$push4=, $pop94, $pop93
	i32.store8	sM+1($pop98), $pop4
	i32.const	$push92=, 0
	i32.const	$push91=, 1103515245
	i32.mul 	$push5=, $0, $pop91
	i32.const	$push90=, 12345
	i32.add 	$push89=, $pop5, $pop90
	tee_local	$push88=, $0=, $pop89
	i32.const	$push87=, 16
	i32.shr_u	$push6=, $pop88, $pop87
	i32.store8	sM+2($pop92), $pop6
	i32.const	$push86=, 0
	i32.const	$push85=, 1103515245
	i32.mul 	$push7=, $0, $pop85
	i32.const	$push84=, 12345
	i32.add 	$push83=, $pop7, $pop84
	tee_local	$push82=, $0=, $pop83
	i32.const	$push81=, 16
	i32.shr_u	$push8=, $pop82, $pop81
	i32.store8	sM+3($pop86), $pop8
	i32.const	$push80=, 0
	i32.const	$push79=, 1103515245
	i32.mul 	$push9=, $0, $pop79
	i32.const	$push78=, 12345
	i32.add 	$push77=, $pop9, $pop78
	tee_local	$push76=, $0=, $pop77
	i32.const	$push75=, 16
	i32.shr_u	$push10=, $pop76, $pop75
	i32.store8	sM+4($pop80), $pop10
	i32.const	$push74=, 0
	i32.const	$push73=, 1103515245
	i32.mul 	$push11=, $0, $pop73
	i32.const	$push72=, 12345
	i32.add 	$push71=, $pop11, $pop72
	tee_local	$push70=, $0=, $pop71
	i32.const	$push69=, 16
	i32.shr_u	$push12=, $pop70, $pop69
	i32.store8	sM+5($pop74), $pop12
	i32.const	$push68=, 0
	i32.const	$push67=, 1103515245
	i32.mul 	$push13=, $0, $pop67
	i32.const	$push66=, 12345
	i32.add 	$push65=, $pop13, $pop66
	tee_local	$push64=, $0=, $pop65
	i32.const	$push63=, 16
	i32.shr_u	$push14=, $pop64, $pop63
	i32.store8	sM+6($pop68), $pop14
	i32.const	$push62=, 0
	i32.const	$push61=, 1103515245
	i32.mul 	$push15=, $0, $pop61
	i32.const	$push60=, 12345
	i32.add 	$push59=, $pop15, $pop60
	tee_local	$push58=, $0=, $pop59
	i32.const	$push57=, 16
	i32.shr_u	$push16=, $pop58, $pop57
	i32.store8	sM+7($pop62), $pop16
	i32.const	$push56=, 0
	i32.load	$3=, sM+4($pop56)
	i32.const	$push55=, 0
	i32.const	$push54=, 1103515245
	i32.mul 	$push17=, $0, $pop54
	i32.const	$push53=, 12345
	i32.add 	$push52=, $pop17, $pop53
	tee_local	$push51=, $2=, $pop52
	i32.const	$push50=, 1103515245
	i32.mul 	$push18=, $pop51, $pop50
	i32.const	$push49=, 12345
	i32.add 	$push48=, $pop18, $pop49
	tee_local	$push47=, $0=, $pop48
	i32.store	myrnd.s($pop55), $pop47
	i32.const	$push46=, 0
	i32.const	$push45=, 16
	i32.shr_u	$push44=, $2, $pop45
	tee_local	$push43=, $2=, $pop44
	i32.const	$push42=, 63
	i32.and 	$push20=, $pop43, $pop42
	i32.const	$push19=, -64
	i32.and 	$push41=, $3, $pop19
	tee_local	$push40=, $1=, $pop41
	i32.or  	$push39=, $pop20, $pop40
	tee_local	$push38=, $3=, $pop39
	i32.store	sM+4($pop46), $pop38
	block   	
	i32.const	$push37=, 16
	i32.shr_u	$push36=, $0, $pop37
	tee_local	$push35=, $4=, $pop36
	i32.add 	$push22=, $3, $pop35
	i32.add 	$push21=, $4, $2
	i32.xor 	$push23=, $pop22, $pop21
	i32.const	$push34=, 63
	i32.and 	$push24=, $pop23, $pop34
	br_if   	0, $pop24       # 0: down to label2
# BB#1:                                 # %if.end107
	i32.const	$push116=, 0
	i32.const	$push25=, -2139243339
	i32.mul 	$push26=, $0, $pop25
	i32.const	$push27=, -1492899873
	i32.add 	$push115=, $pop26, $pop27
	tee_local	$push114=, $0=, $pop115
	i32.const	$push113=, 1103515245
	i32.mul 	$push28=, $pop114, $pop113
	i32.const	$push112=, 12345
	i32.add 	$push111=, $pop28, $pop112
	tee_local	$push110=, $3=, $pop111
	i32.store	myrnd.s($pop116), $pop110
	i32.const	$push109=, 0
	i32.const	$push108=, 16
	i32.shr_u	$push30=, $3, $pop108
	i32.const	$push107=, 16
	i32.shr_u	$push29=, $0, $pop107
	i32.add 	$push31=, $pop30, $pop29
	i32.const	$push106=, 63
	i32.and 	$push32=, $pop31, $pop106
	i32.or  	$push33=, $pop32, $1
	i32.store	sM+4($pop109), $pop33
	return
.LBB78_2:                               # %if.then
	end_block                       # label2:
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
	i64.load	$push0=, 0($1):p2align=0
	i64.store	0($0), $pop0
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
	i32.const	$push16=, 0
	i64.load	$push15=, sN($pop16)
	tee_local	$push14=, $1=, $pop15
	i32.wrap/i64	$push3=, $pop14
	i32.const	$push4=, 6
	i32.shr_u	$push5=, $pop3, $pop4
	i32.add 	$push6=, $pop5, $0
	i32.const	$push7=, 63
	i32.and 	$push13=, $pop6, $pop7
	tee_local	$push12=, $0=, $pop13
	i64.extend_u/i32	$push8=, $pop12
	i64.const	$push9=, 6
	i64.shl 	$push10=, $pop8, $pop9
	i64.const	$push1=, -4033
	i64.and 	$push2=, $1, $pop1
	i64.or  	$push11=, $pop10, $pop2
	i64.store	sN($pop0), $pop11
	copy_local	$push17=, $0
                                        # fallthrough-return: $pop17
	.endfunc
.Lfunc_end83:
	.size	fn3N, .Lfunc_end83-fn3N

	.section	.text.testN,"ax",@progbits
	.hidden	testN
	.globl	testN
	.type	testN,@function
testN:                                  # @testN
	.local  	i64, i32, i32, i32, i32, i64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push140=, 0
	i32.load	$push1=, myrnd.s($pop140)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push139=, $pop3, $pop4
	tee_local	$push138=, $2=, $pop139
	i32.const	$push137=, 16
	i32.shr_u	$push5=, $pop138, $pop137
	i32.store8	sN($pop0), $pop5
	i32.const	$push136=, 0
	i32.const	$push135=, 1103515245
	i32.mul 	$push6=, $2, $pop135
	i32.const	$push134=, 12345
	i32.add 	$push133=, $pop6, $pop134
	tee_local	$push132=, $2=, $pop133
	i32.const	$push131=, 16
	i32.shr_u	$push7=, $pop132, $pop131
	i32.store8	sN+1($pop136), $pop7
	i32.const	$push130=, 0
	i32.const	$push129=, 1103515245
	i32.mul 	$push8=, $2, $pop129
	i32.const	$push128=, 12345
	i32.add 	$push127=, $pop8, $pop128
	tee_local	$push126=, $2=, $pop127
	i32.const	$push125=, 16
	i32.shr_u	$push9=, $pop126, $pop125
	i32.store8	sN+2($pop130), $pop9
	i32.const	$push124=, 0
	i32.const	$push123=, 1103515245
	i32.mul 	$push10=, $2, $pop123
	i32.const	$push122=, 12345
	i32.add 	$push121=, $pop10, $pop122
	tee_local	$push120=, $2=, $pop121
	i32.const	$push119=, 16
	i32.shr_u	$push11=, $pop120, $pop119
	i32.store8	sN+3($pop124), $pop11
	i32.const	$push118=, 0
	i32.const	$push117=, 1103515245
	i32.mul 	$push12=, $2, $pop117
	i32.const	$push116=, 12345
	i32.add 	$push115=, $pop12, $pop116
	tee_local	$push114=, $2=, $pop115
	i32.const	$push113=, 16
	i32.shr_u	$push13=, $pop114, $pop113
	i32.store8	sN+4($pop118), $pop13
	i32.const	$push112=, 0
	i32.const	$push111=, 1103515245
	i32.mul 	$push14=, $2, $pop111
	i32.const	$push110=, 12345
	i32.add 	$push109=, $pop14, $pop110
	tee_local	$push108=, $2=, $pop109
	i32.const	$push107=, 16
	i32.shr_u	$push15=, $pop108, $pop107
	i32.store8	sN+5($pop112), $pop15
	i32.const	$push106=, 0
	i32.const	$push105=, 1103515245
	i32.mul 	$push16=, $2, $pop105
	i32.const	$push104=, 12345
	i32.add 	$push103=, $pop16, $pop104
	tee_local	$push102=, $2=, $pop103
	i32.const	$push101=, 16
	i32.shr_u	$push17=, $pop102, $pop101
	i32.store8	sN+6($pop106), $pop17
	i32.const	$push100=, 0
	i32.const	$push99=, 1103515245
	i32.mul 	$push18=, $2, $pop99
	i32.const	$push98=, 12345
	i32.add 	$push97=, $pop18, $pop98
	tee_local	$push96=, $2=, $pop97
	i32.const	$push95=, 16
	i32.shr_u	$push19=, $pop96, $pop95
	i32.store8	sN+7($pop100), $pop19
	i32.const	$push94=, 0
	i64.load	$0=, sN($pop94)
	i32.const	$push93=, 0
	i32.const	$push92=, 1103515245
	i32.mul 	$push20=, $2, $pop92
	i32.const	$push91=, 12345
	i32.add 	$push90=, $pop20, $pop91
	tee_local	$push89=, $4=, $pop90
	i32.const	$push88=, 1103515245
	i32.mul 	$push21=, $pop89, $pop88
	i32.const	$push87=, 12345
	i32.add 	$push86=, $pop21, $pop87
	tee_local	$push85=, $2=, $pop86
	i32.store	myrnd.s($pop93), $pop85
	i32.const	$push84=, 0
	i32.const	$push83=, 16
	i32.shr_u	$push82=, $4, $pop83
	tee_local	$push81=, $1=, $pop82
	i32.const	$push80=, 63
	i32.and 	$push79=, $pop81, $pop80
	tee_local	$push78=, $4=, $pop79
	i64.extend_u/i32	$push24=, $pop78
	i64.const	$push25=, 6
	i64.shl 	$push26=, $pop24, $pop25
	i64.const	$push22=, -4033
	i64.and 	$push23=, $0, $pop22
	i64.or  	$push77=, $pop26, $pop23
	tee_local	$push76=, $5=, $pop77
	i64.store	sN($pop84), $pop76
	block   	
	i64.const	$push75=, 6
	i64.shr_u	$push27=, $5, $pop75
	i32.wrap/i64	$push74=, $pop27
	tee_local	$push73=, $3=, $pop74
	i32.const	$push72=, 63
	i32.and 	$push28=, $pop73, $pop72
	i32.ne  	$push29=, $4, $pop28
	br_if   	0, $pop29       # 0: down to label3
# BB#1:                                 # %lor.lhs.false49
	i32.const	$push144=, 16
	i32.shr_u	$push143=, $2, $pop144
	tee_local	$push142=, $4=, $pop143
	i32.add 	$push31=, $3, $pop142
	i32.add 	$push30=, $4, $1
	i32.xor 	$push32=, $pop31, $pop30
	i32.const	$push141=, 63
	i32.and 	$push33=, $pop32, $pop141
	br_if   	0, $pop33       # 0: down to label3
# BB#2:                                 # %if.end
	i32.const	$push38=, 0
	i32.const	$push34=, 1103515245
	i32.mul 	$push35=, $2, $pop34
	i32.const	$push36=, 12345
	i32.add 	$push163=, $pop35, $pop36
	tee_local	$push162=, $4=, $pop163
	i32.const	$push161=, 1103515245
	i32.mul 	$push37=, $pop162, $pop161
	i32.const	$push160=, 12345
	i32.add 	$push159=, $pop37, $pop160
	tee_local	$push158=, $2=, $pop159
	i32.store	myrnd.s($pop38), $pop158
	i32.const	$push157=, 0
	i32.const	$push156=, 16
	i32.shr_u	$push155=, $4, $pop156
	tee_local	$push154=, $1=, $pop155
	i32.const	$push153=, 63
	i32.and 	$push152=, $pop154, $pop153
	tee_local	$push151=, $4=, $pop152
	i64.extend_u/i32	$push41=, $pop151
	i64.const	$push42=, 6
	i64.shl 	$push43=, $pop41, $pop42
	i64.const	$push39=, -4033
	i64.and 	$push40=, $0, $pop39
	i64.or  	$push150=, $pop43, $pop40
	tee_local	$push149=, $5=, $pop150
	i64.store	sN($pop157), $pop149
	i64.const	$push148=, 6
	i64.shr_u	$push44=, $5, $pop148
	i32.wrap/i64	$push147=, $pop44
	tee_local	$push146=, $3=, $pop147
	i32.const	$push145=, 63
	i32.and 	$push45=, $pop146, $pop145
	i32.ne  	$push46=, $4, $pop45
	br_if   	0, $pop46       # 0: down to label3
# BB#3:                                 # %lor.lhs.false100
	i32.const	$push169=, 16
	i32.shr_u	$push168=, $2, $pop169
	tee_local	$push167=, $4=, $pop168
	i32.add 	$push51=, $pop167, $1
	i32.const	$push166=, 63
	i32.and 	$push52=, $pop51, $pop166
	i32.const	$push49=, 15
	i32.rem_u	$push53=, $pop52, $pop49
	i32.add 	$push47=, $3, $4
	i32.const	$push165=, 63
	i32.and 	$push48=, $pop47, $pop165
	i32.const	$push164=, 15
	i32.rem_u	$push50=, $pop48, $pop164
	i32.ne  	$push54=, $pop53, $pop50
	br_if   	0, $pop54       # 0: down to label3
# BB#4:                                 # %if.end158
	i32.const	$push59=, 0
	i32.const	$push55=, 1103515245
	i32.mul 	$push56=, $2, $pop55
	i32.const	$push57=, 12345
	i32.add 	$push177=, $pop56, $pop57
	tee_local	$push176=, $2=, $pop177
	i32.const	$push175=, 1103515245
	i32.mul 	$push58=, $pop176, $pop175
	i32.const	$push174=, 12345
	i32.add 	$push173=, $pop58, $pop174
	tee_local	$push172=, $4=, $pop173
	i32.store	myrnd.s($pop59), $pop172
	i32.const	$push171=, 0
	i32.const	$push60=, 16
	i32.shr_u	$push62=, $4, $pop60
	i32.const	$push170=, 16
	i32.shr_u	$push61=, $2, $pop170
	i32.add 	$push63=, $pop62, $pop61
	i32.const	$push64=, 63
	i32.and 	$push65=, $pop63, $pop64
	i64.extend_u/i32	$push66=, $pop65
	i64.const	$push67=, 6
	i64.shl 	$push68=, $pop66, $pop67
	i64.const	$push69=, -4033
	i64.and 	$push70=, $0, $pop69
	i64.or  	$push71=, $pop68, $pop70
	i64.store	sN($pop171), $pop71
	return
.LBB84_5:                               # %if.then106
	end_block                       # label3:
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
	i64.load	$push0=, 0($1):p2align=0
	i64.store	0($0):p2align=0, $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3):p2align=0
	i64.store	0($pop2):p2align=0, $pop4
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
	i32.const	$push12=, 0
	i64.load	$push11=, sO+8($pop12)
	tee_local	$push10=, $1=, $pop11
	i32.wrap/i64	$push3=, $pop10
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 4095
	i32.and 	$push9=, $pop4, $pop5
	tee_local	$push8=, $0=, $pop9
	i64.extend_u/i32	$push6=, $pop8
	i64.const	$push1=, -4096
	i64.and 	$push2=, $1, $pop1
	i64.or  	$push7=, $pop6, $pop2
	i64.store	sO+8($pop0), $pop7
	copy_local	$push13=, $0
                                        # fallthrough-return: $pop13
	.endfunc
.Lfunc_end89:
	.size	fn3O, .Lfunc_end89-fn3O

	.section	.text.testO,"ax",@progbits
	.hidden	testO
	.globl	testO
	.type	testO,@function
testO:                                  # @testO
	.local  	i64, i32, i32, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push199=, 0
	i32.load	$push3=, myrnd.s($pop199)
	i32.const	$push4=, 1103515245
	i32.mul 	$push5=, $pop3, $pop4
	i32.const	$push6=, 12345
	i32.add 	$push198=, $pop5, $pop6
	tee_local	$push197=, $2=, $pop198
	i32.const	$push196=, 16
	i32.shr_u	$push7=, $pop197, $pop196
	i32.store8	sO($pop2), $pop7
	i32.const	$push195=, 0
	i32.const	$push194=, 1103515245
	i32.mul 	$push8=, $2, $pop194
	i32.const	$push193=, 12345
	i32.add 	$push192=, $pop8, $pop193
	tee_local	$push191=, $2=, $pop192
	i32.const	$push190=, 16
	i32.shr_u	$push9=, $pop191, $pop190
	i32.store8	sO+1($pop195), $pop9
	i32.const	$push189=, 0
	i32.const	$push188=, 1103515245
	i32.mul 	$push10=, $2, $pop188
	i32.const	$push187=, 12345
	i32.add 	$push186=, $pop10, $pop187
	tee_local	$push185=, $2=, $pop186
	i32.const	$push184=, 16
	i32.shr_u	$push11=, $pop185, $pop184
	i32.store8	sO+2($pop189), $pop11
	i32.const	$push183=, 0
	i32.const	$push182=, 1103515245
	i32.mul 	$push12=, $2, $pop182
	i32.const	$push181=, 12345
	i32.add 	$push180=, $pop12, $pop181
	tee_local	$push179=, $2=, $pop180
	i32.const	$push178=, 16
	i32.shr_u	$push13=, $pop179, $pop178
	i32.store8	sO+3($pop183), $pop13
	i32.const	$push177=, 0
	i32.const	$push176=, 1103515245
	i32.mul 	$push14=, $2, $pop176
	i32.const	$push175=, 12345
	i32.add 	$push174=, $pop14, $pop175
	tee_local	$push173=, $2=, $pop174
	i32.const	$push172=, 16
	i32.shr_u	$push15=, $pop173, $pop172
	i32.store8	sO+4($pop177), $pop15
	i32.const	$push171=, 0
	i32.const	$push170=, 1103515245
	i32.mul 	$push16=, $2, $pop170
	i32.const	$push169=, 12345
	i32.add 	$push168=, $pop16, $pop169
	tee_local	$push167=, $2=, $pop168
	i32.const	$push166=, 16
	i32.shr_u	$push17=, $pop167, $pop166
	i32.store8	sO+5($pop171), $pop17
	i32.const	$push165=, 0
	i32.const	$push164=, 1103515245
	i32.mul 	$push18=, $2, $pop164
	i32.const	$push163=, 12345
	i32.add 	$push162=, $pop18, $pop163
	tee_local	$push161=, $2=, $pop162
	i32.const	$push160=, 16
	i32.shr_u	$push19=, $pop161, $pop160
	i32.store8	sO+6($pop165), $pop19
	i32.const	$push159=, 0
	i32.const	$push158=, 1103515245
	i32.mul 	$push20=, $2, $pop158
	i32.const	$push157=, 12345
	i32.add 	$push156=, $pop20, $pop157
	tee_local	$push155=, $2=, $pop156
	i32.const	$push154=, 16
	i32.shr_u	$push21=, $pop155, $pop154
	i32.store8	sO+7($pop159), $pop21
	i32.const	$push153=, 0
	i32.const	$push152=, 1103515245
	i32.mul 	$push22=, $2, $pop152
	i32.const	$push151=, 12345
	i32.add 	$push150=, $pop22, $pop151
	tee_local	$push149=, $2=, $pop150
	i32.const	$push148=, 16
	i32.shr_u	$push23=, $pop149, $pop148
	i32.store8	sO+8($pop153), $pop23
	i32.const	$push147=, 0
	i32.const	$push146=, 1103515245
	i32.mul 	$push24=, $2, $pop146
	i32.const	$push145=, 12345
	i32.add 	$push144=, $pop24, $pop145
	tee_local	$push143=, $2=, $pop144
	i32.const	$push142=, 16
	i32.shr_u	$push25=, $pop143, $pop142
	i32.store8	sO+9($pop147), $pop25
	i32.const	$push141=, 0
	i32.const	$push140=, 1103515245
	i32.mul 	$push26=, $2, $pop140
	i32.const	$push139=, 12345
	i32.add 	$push138=, $pop26, $pop139
	tee_local	$push137=, $2=, $pop138
	i32.const	$push136=, 16
	i32.shr_u	$push27=, $pop137, $pop136
	i32.store8	sO+10($pop141), $pop27
	i32.const	$push135=, 0
	i32.const	$push134=, 1103515245
	i32.mul 	$push28=, $2, $pop134
	i32.const	$push133=, 12345
	i32.add 	$push132=, $pop28, $pop133
	tee_local	$push131=, $2=, $pop132
	i32.const	$push130=, 16
	i32.shr_u	$push29=, $pop131, $pop130
	i32.store8	sO+11($pop135), $pop29
	i32.const	$push129=, 0
	i32.const	$push128=, 1103515245
	i32.mul 	$push30=, $2, $pop128
	i32.const	$push127=, 12345
	i32.add 	$push126=, $pop30, $pop127
	tee_local	$push125=, $2=, $pop126
	i32.const	$push124=, 16
	i32.shr_u	$push31=, $pop125, $pop124
	i32.store8	sO+12($pop129), $pop31
	i32.const	$push123=, 0
	i32.const	$push122=, 1103515245
	i32.mul 	$push32=, $2, $pop122
	i32.const	$push121=, 12345
	i32.add 	$push120=, $pop32, $pop121
	tee_local	$push119=, $2=, $pop120
	i32.const	$push118=, 16
	i32.shr_u	$push33=, $pop119, $pop118
	i32.store8	sO+13($pop123), $pop33
	i32.const	$push117=, 0
	i32.const	$push116=, 1103515245
	i32.mul 	$push34=, $2, $pop116
	i32.const	$push115=, 12345
	i32.add 	$push114=, $pop34, $pop115
	tee_local	$push113=, $2=, $pop114
	i32.const	$push112=, 16
	i32.shr_u	$push35=, $pop113, $pop112
	i32.store8	sO+14($pop117), $pop35
	i32.const	$push111=, 0
	i32.const	$push110=, 1103515245
	i32.mul 	$push36=, $2, $pop110
	i32.const	$push109=, 12345
	i32.add 	$push108=, $pop36, $pop109
	tee_local	$push107=, $2=, $pop108
	i32.const	$push106=, 16
	i32.shr_u	$push37=, $pop107, $pop106
	i32.store8	sO+15($pop111), $pop37
	i32.const	$push105=, 0
	i64.load	$0=, sO+8($pop105)
	i32.const	$push104=, 0
	i32.const	$push103=, 1103515245
	i32.mul 	$push38=, $2, $pop103
	i32.const	$push102=, 12345
	i32.add 	$push101=, $pop38, $pop102
	tee_local	$push100=, $2=, $pop101
	i32.const	$push99=, 1103515245
	i32.mul 	$push39=, $pop100, $pop99
	i32.const	$push98=, 12345
	i32.add 	$push97=, $pop39, $pop98
	tee_local	$push96=, $1=, $pop97
	i32.store	myrnd.s($pop104), $pop96
	i32.const	$push95=, 0
	i32.const	$push94=, 16
	i32.shr_u	$push42=, $2, $pop94
	i32.const	$push93=, 2047
	i32.and 	$push92=, $pop42, $pop93
	tee_local	$push91=, $2=, $pop92
	i64.extend_u/i32	$push43=, $pop91
	i64.const	$push40=, -4096
	i64.and 	$push41=, $0, $pop40
	i64.or  	$push90=, $pop43, $pop41
	tee_local	$push89=, $3=, $pop90
	i64.store	sO+8($pop95), $pop89
	block   	
	i32.wrap/i64	$push88=, $3
	tee_local	$push87=, $5=, $pop88
	i32.const	$push86=, 2047
	i32.and 	$push47=, $pop87, $pop86
	i32.ne  	$push48=, $2, $pop47
	br_if   	0, $pop48       # 0: down to label4
# BB#1:                                 # %entry
	i32.const	$push203=, 16
	i32.shr_u	$push44=, $1, $pop203
	i32.const	$push202=, 2047
	i32.and 	$push201=, $pop44, $pop202
	tee_local	$push200=, $4=, $pop201
	i32.add 	$push0=, $pop200, $2
	i32.add 	$push45=, $5, $4
	i32.const	$push46=, 4095
	i32.and 	$push1=, $pop45, $pop46
	i32.ne  	$push49=, $pop0, $pop1
	br_if   	0, $pop49       # 0: down to label4
# BB#2:                                 # %if.end
	i32.const	$push54=, 0
	i32.const	$push50=, 1103515245
	i32.mul 	$push51=, $1, $pop50
	i32.const	$push52=, 12345
	i32.add 	$push219=, $pop51, $pop52
	tee_local	$push218=, $2=, $pop219
	i32.const	$push217=, 1103515245
	i32.mul 	$push53=, $pop218, $pop217
	i32.const	$push216=, 12345
	i32.add 	$push215=, $pop53, $pop216
	tee_local	$push214=, $1=, $pop215
	i32.store	myrnd.s($pop54), $pop214
	i32.const	$push213=, 0
	i32.const	$push212=, 16
	i32.shr_u	$push57=, $2, $pop212
	i32.const	$push211=, 2047
	i32.and 	$push210=, $pop57, $pop211
	tee_local	$push209=, $2=, $pop210
	i64.extend_u/i32	$push58=, $pop209
	i64.const	$push55=, -4096
	i64.and 	$push56=, $0, $pop55
	i64.or  	$push208=, $pop58, $pop56
	tee_local	$push207=, $3=, $pop208
	i64.store	sO+8($pop213), $pop207
	i32.wrap/i64	$push206=, $3
	tee_local	$push205=, $5=, $pop206
	i32.const	$push204=, 2047
	i32.and 	$push59=, $pop205, $pop204
	i32.ne  	$push60=, $2, $pop59
	br_if   	0, $pop60       # 0: down to label4
# BB#3:                                 # %lor.lhs.false87
	i32.const	$push224=, 16
	i32.shr_u	$push61=, $1, $pop224
	i32.const	$push223=, 2047
	i32.and 	$push222=, $pop61, $pop223
	tee_local	$push221=, $4=, $pop222
	i32.add 	$push62=, $pop221, $2
	i32.const	$push63=, 15
	i32.rem_u	$push64=, $pop62, $pop63
	i32.add 	$push65=, $5, $4
	i32.const	$push66=, 4095
	i32.and 	$push67=, $pop65, $pop66
	i32.const	$push220=, 15
	i32.rem_u	$push68=, $pop67, $pop220
	i32.ne  	$push69=, $pop64, $pop68
	br_if   	0, $pop69       # 0: down to label4
# BB#4:                                 # %if.end140
	i32.const	$push74=, 0
	i32.const	$push70=, 1103515245
	i32.mul 	$push71=, $1, $pop70
	i32.const	$push72=, 12345
	i32.add 	$push233=, $pop71, $pop72
	tee_local	$push232=, $2=, $pop233
	i32.const	$push231=, 1103515245
	i32.mul 	$push73=, $pop232, $pop231
	i32.const	$push230=, 12345
	i32.add 	$push229=, $pop73, $pop230
	tee_local	$push228=, $1=, $pop229
	i32.store	myrnd.s($pop74), $pop228
	i32.const	$push227=, 0
	i32.const	$push75=, 16
	i32.shr_u	$push79=, $1, $pop75
	i32.const	$push77=, 2047
	i32.and 	$push80=, $pop79, $pop77
	i32.const	$push226=, 16
	i32.shr_u	$push76=, $2, $pop226
	i32.const	$push225=, 2047
	i32.and 	$push78=, $pop76, $pop225
	i32.add 	$push81=, $pop80, $pop78
	i64.extend_u/i32	$push82=, $pop81
	i64.const	$push83=, -4096
	i64.and 	$push84=, $0, $pop83
	i64.or  	$push85=, $pop82, $pop84
	i64.store	sO+8($pop227), $pop85
	return
.LBB90_5:                               # %if.then93
	end_block                       # label4:
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
	i64.load	$push0=, 0($1):p2align=0
	i64.store	0($0):p2align=0, $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i64.load	$push4=, 0($pop3):p2align=0
	i64.store	0($pop2):p2align=0, $pop4
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
	i32.const	$push12=, 0
	i64.load	$push11=, sP($pop12)
	tee_local	$push10=, $1=, $pop11
	i32.wrap/i64	$push3=, $pop10
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 4095
	i32.and 	$push9=, $pop4, $pop5
	tee_local	$push8=, $0=, $pop9
	i64.extend_u/i32	$push6=, $pop8
	i64.const	$push1=, -4096
	i64.and 	$push2=, $1, $pop1
	i64.or  	$push7=, $pop6, $pop2
	i64.store	sP($pop0), $pop7
	copy_local	$push13=, $0
                                        # fallthrough-return: $pop13
	.endfunc
.Lfunc_end95:
	.size	fn3P, .Lfunc_end95-fn3P

	.section	.text.testP,"ax",@progbits
	.hidden	testP
	.globl	testP
	.type	testP,@function
testP:                                  # @testP
	.local  	i64, i32, i32, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push199=, 0
	i32.load	$push3=, myrnd.s($pop199)
	i32.const	$push4=, 1103515245
	i32.mul 	$push5=, $pop3, $pop4
	i32.const	$push6=, 12345
	i32.add 	$push198=, $pop5, $pop6
	tee_local	$push197=, $2=, $pop198
	i32.const	$push196=, 16
	i32.shr_u	$push7=, $pop197, $pop196
	i32.store8	sP($pop2), $pop7
	i32.const	$push195=, 0
	i32.const	$push194=, 1103515245
	i32.mul 	$push8=, $2, $pop194
	i32.const	$push193=, 12345
	i32.add 	$push192=, $pop8, $pop193
	tee_local	$push191=, $2=, $pop192
	i32.const	$push190=, 16
	i32.shr_u	$push9=, $pop191, $pop190
	i32.store8	sP+1($pop195), $pop9
	i32.const	$push189=, 0
	i32.const	$push188=, 1103515245
	i32.mul 	$push10=, $2, $pop188
	i32.const	$push187=, 12345
	i32.add 	$push186=, $pop10, $pop187
	tee_local	$push185=, $2=, $pop186
	i32.const	$push184=, 16
	i32.shr_u	$push11=, $pop185, $pop184
	i32.store8	sP+2($pop189), $pop11
	i32.const	$push183=, 0
	i32.const	$push182=, 1103515245
	i32.mul 	$push12=, $2, $pop182
	i32.const	$push181=, 12345
	i32.add 	$push180=, $pop12, $pop181
	tee_local	$push179=, $2=, $pop180
	i32.const	$push178=, 16
	i32.shr_u	$push13=, $pop179, $pop178
	i32.store8	sP+3($pop183), $pop13
	i32.const	$push177=, 0
	i32.const	$push176=, 1103515245
	i32.mul 	$push14=, $2, $pop176
	i32.const	$push175=, 12345
	i32.add 	$push174=, $pop14, $pop175
	tee_local	$push173=, $2=, $pop174
	i32.const	$push172=, 16
	i32.shr_u	$push15=, $pop173, $pop172
	i32.store8	sP+4($pop177), $pop15
	i32.const	$push171=, 0
	i32.const	$push170=, 1103515245
	i32.mul 	$push16=, $2, $pop170
	i32.const	$push169=, 12345
	i32.add 	$push168=, $pop16, $pop169
	tee_local	$push167=, $2=, $pop168
	i32.const	$push166=, 16
	i32.shr_u	$push17=, $pop167, $pop166
	i32.store8	sP+5($pop171), $pop17
	i32.const	$push165=, 0
	i32.const	$push164=, 1103515245
	i32.mul 	$push18=, $2, $pop164
	i32.const	$push163=, 12345
	i32.add 	$push162=, $pop18, $pop163
	tee_local	$push161=, $2=, $pop162
	i32.const	$push160=, 16
	i32.shr_u	$push19=, $pop161, $pop160
	i32.store8	sP+6($pop165), $pop19
	i32.const	$push159=, 0
	i32.const	$push158=, 1103515245
	i32.mul 	$push20=, $2, $pop158
	i32.const	$push157=, 12345
	i32.add 	$push156=, $pop20, $pop157
	tee_local	$push155=, $2=, $pop156
	i32.const	$push154=, 16
	i32.shr_u	$push21=, $pop155, $pop154
	i32.store8	sP+7($pop159), $pop21
	i32.const	$push153=, 0
	i32.const	$push152=, 1103515245
	i32.mul 	$push22=, $2, $pop152
	i32.const	$push151=, 12345
	i32.add 	$push150=, $pop22, $pop151
	tee_local	$push149=, $2=, $pop150
	i32.const	$push148=, 16
	i32.shr_u	$push23=, $pop149, $pop148
	i32.store8	sP+8($pop153), $pop23
	i32.const	$push147=, 0
	i32.const	$push146=, 1103515245
	i32.mul 	$push24=, $2, $pop146
	i32.const	$push145=, 12345
	i32.add 	$push144=, $pop24, $pop145
	tee_local	$push143=, $2=, $pop144
	i32.const	$push142=, 16
	i32.shr_u	$push25=, $pop143, $pop142
	i32.store8	sP+9($pop147), $pop25
	i32.const	$push141=, 0
	i32.const	$push140=, 1103515245
	i32.mul 	$push26=, $2, $pop140
	i32.const	$push139=, 12345
	i32.add 	$push138=, $pop26, $pop139
	tee_local	$push137=, $2=, $pop138
	i32.const	$push136=, 16
	i32.shr_u	$push27=, $pop137, $pop136
	i32.store8	sP+10($pop141), $pop27
	i32.const	$push135=, 0
	i32.const	$push134=, 1103515245
	i32.mul 	$push28=, $2, $pop134
	i32.const	$push133=, 12345
	i32.add 	$push132=, $pop28, $pop133
	tee_local	$push131=, $2=, $pop132
	i32.const	$push130=, 16
	i32.shr_u	$push29=, $pop131, $pop130
	i32.store8	sP+11($pop135), $pop29
	i32.const	$push129=, 0
	i32.const	$push128=, 1103515245
	i32.mul 	$push30=, $2, $pop128
	i32.const	$push127=, 12345
	i32.add 	$push126=, $pop30, $pop127
	tee_local	$push125=, $2=, $pop126
	i32.const	$push124=, 16
	i32.shr_u	$push31=, $pop125, $pop124
	i32.store8	sP+12($pop129), $pop31
	i32.const	$push123=, 0
	i32.const	$push122=, 1103515245
	i32.mul 	$push32=, $2, $pop122
	i32.const	$push121=, 12345
	i32.add 	$push120=, $pop32, $pop121
	tee_local	$push119=, $2=, $pop120
	i32.const	$push118=, 16
	i32.shr_u	$push33=, $pop119, $pop118
	i32.store8	sP+13($pop123), $pop33
	i32.const	$push117=, 0
	i32.const	$push116=, 1103515245
	i32.mul 	$push34=, $2, $pop116
	i32.const	$push115=, 12345
	i32.add 	$push114=, $pop34, $pop115
	tee_local	$push113=, $2=, $pop114
	i32.const	$push112=, 16
	i32.shr_u	$push35=, $pop113, $pop112
	i32.store8	sP+14($pop117), $pop35
	i32.const	$push111=, 0
	i32.const	$push110=, 1103515245
	i32.mul 	$push36=, $2, $pop110
	i32.const	$push109=, 12345
	i32.add 	$push108=, $pop36, $pop109
	tee_local	$push107=, $2=, $pop108
	i32.const	$push106=, 16
	i32.shr_u	$push37=, $pop107, $pop106
	i32.store8	sP+15($pop111), $pop37
	i32.const	$push105=, 0
	i64.load	$0=, sP($pop105)
	i32.const	$push104=, 0
	i32.const	$push103=, 1103515245
	i32.mul 	$push38=, $2, $pop103
	i32.const	$push102=, 12345
	i32.add 	$push101=, $pop38, $pop102
	tee_local	$push100=, $2=, $pop101
	i32.const	$push99=, 1103515245
	i32.mul 	$push39=, $pop100, $pop99
	i32.const	$push98=, 12345
	i32.add 	$push97=, $pop39, $pop98
	tee_local	$push96=, $1=, $pop97
	i32.store	myrnd.s($pop104), $pop96
	i32.const	$push95=, 0
	i32.const	$push94=, 16
	i32.shr_u	$push42=, $2, $pop94
	i32.const	$push93=, 2047
	i32.and 	$push92=, $pop42, $pop93
	tee_local	$push91=, $2=, $pop92
	i64.extend_u/i32	$push43=, $pop91
	i64.const	$push40=, -4096
	i64.and 	$push41=, $0, $pop40
	i64.or  	$push90=, $pop43, $pop41
	tee_local	$push89=, $3=, $pop90
	i64.store	sP($pop95), $pop89
	block   	
	i32.wrap/i64	$push88=, $3
	tee_local	$push87=, $5=, $pop88
	i32.const	$push86=, 2047
	i32.and 	$push47=, $pop87, $pop86
	i32.ne  	$push48=, $2, $pop47
	br_if   	0, $pop48       # 0: down to label5
# BB#1:                                 # %entry
	i32.const	$push203=, 16
	i32.shr_u	$push44=, $1, $pop203
	i32.const	$push202=, 2047
	i32.and 	$push201=, $pop44, $pop202
	tee_local	$push200=, $4=, $pop201
	i32.add 	$push0=, $pop200, $2
	i32.add 	$push45=, $5, $4
	i32.const	$push46=, 4095
	i32.and 	$push1=, $pop45, $pop46
	i32.ne  	$push49=, $pop0, $pop1
	br_if   	0, $pop49       # 0: down to label5
# BB#2:                                 # %if.end
	i32.const	$push54=, 0
	i32.const	$push50=, 1103515245
	i32.mul 	$push51=, $1, $pop50
	i32.const	$push52=, 12345
	i32.add 	$push219=, $pop51, $pop52
	tee_local	$push218=, $2=, $pop219
	i32.const	$push217=, 1103515245
	i32.mul 	$push53=, $pop218, $pop217
	i32.const	$push216=, 12345
	i32.add 	$push215=, $pop53, $pop216
	tee_local	$push214=, $1=, $pop215
	i32.store	myrnd.s($pop54), $pop214
	i32.const	$push213=, 0
	i32.const	$push212=, 16
	i32.shr_u	$push57=, $2, $pop212
	i32.const	$push211=, 2047
	i32.and 	$push210=, $pop57, $pop211
	tee_local	$push209=, $2=, $pop210
	i64.extend_u/i32	$push58=, $pop209
	i64.const	$push55=, -4096
	i64.and 	$push56=, $0, $pop55
	i64.or  	$push208=, $pop58, $pop56
	tee_local	$push207=, $3=, $pop208
	i64.store	sP($pop213), $pop207
	i32.wrap/i64	$push206=, $3
	tee_local	$push205=, $5=, $pop206
	i32.const	$push204=, 2047
	i32.and 	$push59=, $pop205, $pop204
	i32.ne  	$push60=, $2, $pop59
	br_if   	0, $pop60       # 0: down to label5
# BB#3:                                 # %lor.lhs.false83
	i32.const	$push224=, 16
	i32.shr_u	$push61=, $1, $pop224
	i32.const	$push223=, 2047
	i32.and 	$push222=, $pop61, $pop223
	tee_local	$push221=, $4=, $pop222
	i32.add 	$push62=, $pop221, $2
	i32.const	$push63=, 15
	i32.rem_u	$push64=, $pop62, $pop63
	i32.add 	$push65=, $5, $4
	i32.const	$push66=, 4095
	i32.and 	$push67=, $pop65, $pop66
	i32.const	$push220=, 15
	i32.rem_u	$push68=, $pop67, $pop220
	i32.ne  	$push69=, $pop64, $pop68
	br_if   	0, $pop69       # 0: down to label5
# BB#4:                                 # %if.end134
	i32.const	$push74=, 0
	i32.const	$push70=, 1103515245
	i32.mul 	$push71=, $1, $pop70
	i32.const	$push72=, 12345
	i32.add 	$push233=, $pop71, $pop72
	tee_local	$push232=, $2=, $pop233
	i32.const	$push231=, 1103515245
	i32.mul 	$push73=, $pop232, $pop231
	i32.const	$push230=, 12345
	i32.add 	$push229=, $pop73, $pop230
	tee_local	$push228=, $1=, $pop229
	i32.store	myrnd.s($pop74), $pop228
	i32.const	$push227=, 0
	i32.const	$push75=, 16
	i32.shr_u	$push79=, $1, $pop75
	i32.const	$push77=, 2047
	i32.and 	$push80=, $pop79, $pop77
	i32.const	$push226=, 16
	i32.shr_u	$push76=, $2, $pop226
	i32.const	$push225=, 2047
	i32.and 	$push78=, $pop76, $pop225
	i32.add 	$push81=, $pop80, $pop78
	i64.extend_u/i32	$push82=, $pop81
	i64.const	$push83=, -4096
	i64.and 	$push84=, $0, $pop83
	i64.or  	$push85=, $pop82, $pop84
	i64.store	sP($pop227), $pop85
	return
.LBB96_5:                               # %if.then89
	end_block                       # label5:
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
	i64.load	$push0=, 0($1):p2align=0
	i64.store	0($0):p2align=0, $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i32.load16_u	$push4=, 0($pop3):p2align=0
	i32.store16	0($pop2):p2align=0, $pop4
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
	i32.load16_u	$push1=, sQ($pop0)
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
	i32.load16_u	$push1=, sQ($pop0)
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
	i32.load16_u	$push1=, sQ($pop0)
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
	i32.load16_u	$push9=, sQ($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.add 	$push3=, $pop8, $0
	i32.const	$push4=, 4095
	i32.and 	$push7=, $pop3, $pop4
	tee_local	$push6=, $0=, $pop7
	i32.const	$push1=, 61440
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push5=, $pop6, $pop2
	i32.store16	sQ($pop0), $pop5
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
	.local  	i32, i32, i32
# BB#0:                                 # %if.end90
	i32.const	$push0=, 0
	i32.const	$push106=, 0
	i32.load	$push1=, myrnd.s($pop106)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push105=, $pop3, $pop4
	tee_local	$push104=, $0=, $pop105
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop104, $pop5
	i32.store8	sQ($pop0), $pop6
	i32.const	$push103=, 0
	i32.const	$push102=, 1103515245
	i32.mul 	$push7=, $0, $pop102
	i32.const	$push101=, 12345
	i32.add 	$push100=, $pop7, $pop101
	tee_local	$push99=, $0=, $pop100
	i32.const	$push98=, 16
	i32.shr_u	$push8=, $pop99, $pop98
	i32.store8	sQ+1($pop103), $pop8
	i32.const	$push97=, 0
	i32.const	$push96=, 1103515245
	i32.mul 	$push9=, $0, $pop96
	i32.const	$push95=, 12345
	i32.add 	$push94=, $pop9, $pop95
	tee_local	$push93=, $0=, $pop94
	i32.const	$push92=, 16
	i32.shr_u	$push10=, $pop93, $pop92
	i32.store8	sQ+2($pop97), $pop10
	i32.const	$push91=, 0
	i32.const	$push90=, 1103515245
	i32.mul 	$push11=, $0, $pop90
	i32.const	$push89=, 12345
	i32.add 	$push88=, $pop11, $pop89
	tee_local	$push87=, $0=, $pop88
	i32.const	$push86=, 16
	i32.shr_u	$push12=, $pop87, $pop86
	i32.store8	sQ+3($pop91), $pop12
	i32.const	$push85=, 0
	i32.const	$push84=, 1103515245
	i32.mul 	$push13=, $0, $pop84
	i32.const	$push83=, 12345
	i32.add 	$push82=, $pop13, $pop83
	tee_local	$push81=, $0=, $pop82
	i32.const	$push80=, 16
	i32.shr_u	$push14=, $pop81, $pop80
	i32.store8	sQ+4($pop85), $pop14
	i32.const	$push79=, 0
	i32.const	$push78=, 1103515245
	i32.mul 	$push15=, $0, $pop78
	i32.const	$push77=, 12345
	i32.add 	$push76=, $pop15, $pop77
	tee_local	$push75=, $0=, $pop76
	i32.const	$push74=, 16
	i32.shr_u	$push16=, $pop75, $pop74
	i32.store8	sQ+5($pop79), $pop16
	i32.const	$push73=, 0
	i32.const	$push72=, 1103515245
	i32.mul 	$push17=, $0, $pop72
	i32.const	$push71=, 12345
	i32.add 	$push70=, $pop17, $pop71
	tee_local	$push69=, $0=, $pop70
	i32.const	$push68=, 16
	i32.shr_u	$push18=, $pop69, $pop68
	i32.store8	sQ+6($pop73), $pop18
	i32.const	$push67=, 0
	i32.const	$push66=, 1103515245
	i32.mul 	$push19=, $0, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push64=, $pop19, $pop65
	tee_local	$push63=, $0=, $pop64
	i32.const	$push62=, 16
	i32.shr_u	$push20=, $pop63, $pop62
	i32.store8	sQ+7($pop67), $pop20
	i32.const	$push61=, 0
	i32.const	$push60=, 1103515245
	i32.mul 	$push21=, $0, $pop60
	i32.const	$push59=, 12345
	i32.add 	$push58=, $pop21, $pop59
	tee_local	$push57=, $0=, $pop58
	i32.const	$push56=, 16
	i32.shr_u	$push22=, $pop57, $pop56
	i32.store8	sQ+8($pop61), $pop22
	i32.const	$push55=, 0
	i32.const	$push54=, 1103515245
	i32.mul 	$push23=, $0, $pop54
	i32.const	$push53=, 12345
	i32.add 	$push52=, $pop23, $pop53
	tee_local	$push51=, $0=, $pop52
	i32.const	$push50=, 16
	i32.shr_u	$push24=, $pop51, $pop50
	i32.store8	sQ+9($pop55), $pop24
	i32.const	$push49=, 0
	i32.load16_u	$2=, sQ($pop49)
	i32.const	$push48=, 0
	i32.const	$push25=, -341751747
	i32.mul 	$push26=, $0, $pop25
	i32.const	$push27=, 229283573
	i32.add 	$push47=, $pop26, $pop27
	tee_local	$push46=, $0=, $pop47
	i32.const	$push45=, 1103515245
	i32.mul 	$push28=, $pop46, $pop45
	i32.const	$push44=, 12345
	i32.add 	$push43=, $pop28, $pop44
	tee_local	$push42=, $1=, $pop43
	i32.store	myrnd.s($pop48), $pop42
	i32.const	$push41=, 0
	i32.const	$push40=, 16
	i32.shr_u	$push32=, $1, $pop40
	i32.const	$push30=, 2047
	i32.and 	$push33=, $pop32, $pop30
	i32.const	$push39=, 16
	i32.shr_u	$push29=, $0, $pop39
	i32.const	$push38=, 2047
	i32.and 	$push31=, $pop29, $pop38
	i32.add 	$push34=, $pop33, $pop31
	i32.const	$push35=, 61440
	i32.and 	$push36=, $2, $pop35
	i32.or  	$push37=, $pop34, $pop36
	i32.store16	sQ($pop41), $pop37
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
	i64.load	$push0=, 0($1):p2align=0
	i64.store	0($0):p2align=0, $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i32.load16_u	$push4=, 0($pop3):p2align=0
	i32.store16	0($pop2):p2align=0, $pop4
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
	i32.load16_u	$push1=, sR($pop0)
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 3
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
	i32.load16_u	$push1=, sR($pop0)
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 3
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
	i32.load16_u	$push1=, sR($pop0)
	i32.const	$push2=, 3
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
	i32.load16_u	$push9=, sR($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.add 	$push3=, $pop8, $0
	i32.const	$push4=, 3
	i32.and 	$push7=, $pop3, $pop4
	tee_local	$push6=, $0=, $pop7
	i32.const	$push1=, 65532
	i32.and 	$push2=, $1, $pop1
	i32.or  	$push5=, $pop6, $pop2
	i32.store16	sR($pop0), $pop5
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
	.local  	i32, i32, i32
# BB#0:                                 # %if.end90
	i32.const	$push0=, 0
	i32.const	$push105=, 0
	i32.load	$push1=, myrnd.s($pop105)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push104=, $pop3, $pop4
	tee_local	$push103=, $0=, $pop104
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop103, $pop5
	i32.store8	sR($pop0), $pop6
	i32.const	$push102=, 0
	i32.const	$push101=, 1103515245
	i32.mul 	$push7=, $0, $pop101
	i32.const	$push100=, 12345
	i32.add 	$push99=, $pop7, $pop100
	tee_local	$push98=, $0=, $pop99
	i32.const	$push97=, 16
	i32.shr_u	$push8=, $pop98, $pop97
	i32.store8	sR+1($pop102), $pop8
	i32.const	$push96=, 0
	i32.const	$push95=, 1103515245
	i32.mul 	$push9=, $0, $pop95
	i32.const	$push94=, 12345
	i32.add 	$push93=, $pop9, $pop94
	tee_local	$push92=, $0=, $pop93
	i32.const	$push91=, 16
	i32.shr_u	$push10=, $pop92, $pop91
	i32.store8	sR+2($pop96), $pop10
	i32.const	$push90=, 0
	i32.const	$push89=, 1103515245
	i32.mul 	$push11=, $0, $pop89
	i32.const	$push88=, 12345
	i32.add 	$push87=, $pop11, $pop88
	tee_local	$push86=, $0=, $pop87
	i32.const	$push85=, 16
	i32.shr_u	$push12=, $pop86, $pop85
	i32.store8	sR+3($pop90), $pop12
	i32.const	$push84=, 0
	i32.const	$push83=, 1103515245
	i32.mul 	$push13=, $0, $pop83
	i32.const	$push82=, 12345
	i32.add 	$push81=, $pop13, $pop82
	tee_local	$push80=, $0=, $pop81
	i32.const	$push79=, 16
	i32.shr_u	$push14=, $pop80, $pop79
	i32.store8	sR+4($pop84), $pop14
	i32.const	$push78=, 0
	i32.const	$push77=, 1103515245
	i32.mul 	$push15=, $0, $pop77
	i32.const	$push76=, 12345
	i32.add 	$push75=, $pop15, $pop76
	tee_local	$push74=, $0=, $pop75
	i32.const	$push73=, 16
	i32.shr_u	$push16=, $pop74, $pop73
	i32.store8	sR+5($pop78), $pop16
	i32.const	$push72=, 0
	i32.const	$push71=, 1103515245
	i32.mul 	$push17=, $0, $pop71
	i32.const	$push70=, 12345
	i32.add 	$push69=, $pop17, $pop70
	tee_local	$push68=, $0=, $pop69
	i32.const	$push67=, 16
	i32.shr_u	$push18=, $pop68, $pop67
	i32.store8	sR+6($pop72), $pop18
	i32.const	$push66=, 0
	i32.const	$push65=, 1103515245
	i32.mul 	$push19=, $0, $pop65
	i32.const	$push64=, 12345
	i32.add 	$push63=, $pop19, $pop64
	tee_local	$push62=, $0=, $pop63
	i32.const	$push61=, 16
	i32.shr_u	$push20=, $pop62, $pop61
	i32.store8	sR+7($pop66), $pop20
	i32.const	$push60=, 0
	i32.const	$push59=, 1103515245
	i32.mul 	$push21=, $0, $pop59
	i32.const	$push58=, 12345
	i32.add 	$push57=, $pop21, $pop58
	tee_local	$push56=, $0=, $pop57
	i32.const	$push55=, 16
	i32.shr_u	$push22=, $pop56, $pop55
	i32.store8	sR+8($pop60), $pop22
	i32.const	$push54=, 0
	i32.const	$push53=, 1103515245
	i32.mul 	$push23=, $0, $pop53
	i32.const	$push52=, 12345
	i32.add 	$push51=, $pop23, $pop52
	tee_local	$push50=, $0=, $pop51
	i32.const	$push49=, 16
	i32.shr_u	$push24=, $pop50, $pop49
	i32.store8	sR+9($pop54), $pop24
	i32.const	$push48=, 0
	i32.load16_u	$2=, sR($pop48)
	i32.const	$push47=, 0
	i32.const	$push25=, -341751747
	i32.mul 	$push26=, $0, $pop25
	i32.const	$push27=, 229283573
	i32.add 	$push46=, $pop26, $pop27
	tee_local	$push45=, $0=, $pop46
	i32.const	$push44=, 1103515245
	i32.mul 	$push28=, $pop45, $pop44
	i32.const	$push43=, 12345
	i32.add 	$push42=, $pop28, $pop43
	tee_local	$push41=, $1=, $pop42
	i32.store	myrnd.s($pop47), $pop41
	i32.const	$push40=, 0
	i32.const	$push39=, 16
	i32.shr_u	$push30=, $1, $pop39
	i32.const	$push38=, 16
	i32.shr_u	$push29=, $0, $pop38
	i32.add 	$push31=, $pop30, $pop29
	i32.const	$push32=, 3
	i32.and 	$push33=, $pop31, $pop32
	i32.const	$push34=, 65532
	i32.and 	$push35=, $2, $pop34
	i32.or  	$push36=, $pop33, $pop35
	i32.store16	sR($pop40), $pop36
	block   	
	i32.const	$push37=, 1
	i32.eqz 	$push106=, $pop37
	br_if   	0, $pop106      # 0: down to label6
# BB#1:                                 # %if.end134
	return
.LBB108_2:                              # %if.then133
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
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
	i64.load	$push0=, 0($1):p2align=0
	i64.store	0($0):p2align=0, $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i32.load16_u	$push4=, 0($pop3):p2align=0
	i32.store16	0($pop2):p2align=0, $pop4
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
	i32.store16	sS($pop0), $pop5
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
	.local  	i32, i32, i32
# BB#0:                                 # %if.end90
	i32.const	$push0=, 0
	i32.const	$push105=, 0
	i32.load	$push1=, myrnd.s($pop105)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push104=, $pop3, $pop4
	tee_local	$push103=, $0=, $pop104
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop103, $pop5
	i32.store8	sS($pop0), $pop6
	i32.const	$push102=, 0
	i32.const	$push101=, 1103515245
	i32.mul 	$push7=, $0, $pop101
	i32.const	$push100=, 12345
	i32.add 	$push99=, $pop7, $pop100
	tee_local	$push98=, $0=, $pop99
	i32.const	$push97=, 16
	i32.shr_u	$push8=, $pop98, $pop97
	i32.store8	sS+1($pop102), $pop8
	i32.const	$push96=, 0
	i32.const	$push95=, 1103515245
	i32.mul 	$push9=, $0, $pop95
	i32.const	$push94=, 12345
	i32.add 	$push93=, $pop9, $pop94
	tee_local	$push92=, $0=, $pop93
	i32.const	$push91=, 16
	i32.shr_u	$push10=, $pop92, $pop91
	i32.store8	sS+2($pop96), $pop10
	i32.const	$push90=, 0
	i32.const	$push89=, 1103515245
	i32.mul 	$push11=, $0, $pop89
	i32.const	$push88=, 12345
	i32.add 	$push87=, $pop11, $pop88
	tee_local	$push86=, $0=, $pop87
	i32.const	$push85=, 16
	i32.shr_u	$push12=, $pop86, $pop85
	i32.store8	sS+3($pop90), $pop12
	i32.const	$push84=, 0
	i32.const	$push83=, 1103515245
	i32.mul 	$push13=, $0, $pop83
	i32.const	$push82=, 12345
	i32.add 	$push81=, $pop13, $pop82
	tee_local	$push80=, $0=, $pop81
	i32.const	$push79=, 16
	i32.shr_u	$push14=, $pop80, $pop79
	i32.store8	sS+4($pop84), $pop14
	i32.const	$push78=, 0
	i32.const	$push77=, 1103515245
	i32.mul 	$push15=, $0, $pop77
	i32.const	$push76=, 12345
	i32.add 	$push75=, $pop15, $pop76
	tee_local	$push74=, $0=, $pop75
	i32.const	$push73=, 16
	i32.shr_u	$push16=, $pop74, $pop73
	i32.store8	sS+5($pop78), $pop16
	i32.const	$push72=, 0
	i32.const	$push71=, 1103515245
	i32.mul 	$push17=, $0, $pop71
	i32.const	$push70=, 12345
	i32.add 	$push69=, $pop17, $pop70
	tee_local	$push68=, $0=, $pop69
	i32.const	$push67=, 16
	i32.shr_u	$push18=, $pop68, $pop67
	i32.store8	sS+6($pop72), $pop18
	i32.const	$push66=, 0
	i32.const	$push65=, 1103515245
	i32.mul 	$push19=, $0, $pop65
	i32.const	$push64=, 12345
	i32.add 	$push63=, $pop19, $pop64
	tee_local	$push62=, $0=, $pop63
	i32.const	$push61=, 16
	i32.shr_u	$push20=, $pop62, $pop61
	i32.store8	sS+7($pop66), $pop20
	i32.const	$push60=, 0
	i32.const	$push59=, 1103515245
	i32.mul 	$push21=, $0, $pop59
	i32.const	$push58=, 12345
	i32.add 	$push57=, $pop21, $pop58
	tee_local	$push56=, $0=, $pop57
	i32.const	$push55=, 16
	i32.shr_u	$push22=, $pop56, $pop55
	i32.store8	sS+8($pop60), $pop22
	i32.const	$push54=, 0
	i32.const	$push53=, 1103515245
	i32.mul 	$push23=, $0, $pop53
	i32.const	$push52=, 12345
	i32.add 	$push51=, $pop23, $pop52
	tee_local	$push50=, $0=, $pop51
	i32.const	$push49=, 16
	i32.shr_u	$push24=, $pop50, $pop49
	i32.store8	sS+9($pop54), $pop24
	i32.const	$push48=, 0
	i32.load16_u	$2=, sS($pop48)
	i32.const	$push47=, 0
	i32.const	$push25=, -341751747
	i32.mul 	$push26=, $0, $pop25
	i32.const	$push27=, 229283573
	i32.add 	$push46=, $pop26, $pop27
	tee_local	$push45=, $0=, $pop46
	i32.const	$push44=, 1103515245
	i32.mul 	$push28=, $pop45, $pop44
	i32.const	$push43=, 12345
	i32.add 	$push42=, $pop28, $pop43
	tee_local	$push41=, $1=, $pop42
	i32.store	myrnd.s($pop47), $pop41
	i32.const	$push40=, 0
	i32.const	$push39=, 16
	i32.shr_u	$push30=, $1, $pop39
	i32.const	$push38=, 16
	i32.shr_u	$push29=, $0, $pop38
	i32.add 	$push31=, $pop30, $pop29
	i32.const	$push32=, 1
	i32.and 	$push33=, $pop31, $pop32
	i32.const	$push34=, 65534
	i32.and 	$push35=, $2, $pop34
	i32.or  	$push36=, $pop33, $pop35
	i32.store16	sS($pop40), $pop36
	block   	
	i32.const	$push37=, 1
	i32.eqz 	$push106=, $pop37
	br_if   	0, $pop106      # 0: down to label7
# BB#1:                                 # %if.end134
	return
.LBB114_2:                              # %if.then133
	end_block                       # label7:
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
	i32.load	$push0=, 0($1):p2align=0
	i32.store	0($0):p2align=1, $pop0
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
	i32.store16	sT($pop0), $pop5
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
	i32.const	$push76=, 0
	i32.const	$push75=, 0
	i32.load	$push0=, myrnd.s($pop75)
	i32.const	$push74=, 1103515245
	i32.mul 	$push1=, $pop0, $pop74
	i32.const	$push73=, 12345
	i32.add 	$push72=, $pop1, $pop73
	tee_local	$push71=, $0=, $pop72
	i32.const	$push70=, 16
	i32.shr_u	$push2=, $pop71, $pop70
	i32.store8	sT($pop76), $pop2
	i32.const	$push69=, 0
	i32.const	$push68=, 1103515245
	i32.mul 	$push3=, $0, $pop68
	i32.const	$push67=, 12345
	i32.add 	$push66=, $pop3, $pop67
	tee_local	$push65=, $0=, $pop66
	i32.const	$push64=, 16
	i32.shr_u	$push4=, $pop65, $pop64
	i32.store8	sT+1($pop69), $pop4
	i32.const	$push63=, 0
	i32.const	$push62=, 1103515245
	i32.mul 	$push5=, $0, $pop62
	i32.const	$push61=, 12345
	i32.add 	$push60=, $pop5, $pop61
	tee_local	$push59=, $0=, $pop60
	i32.const	$push58=, 16
	i32.shr_u	$push6=, $pop59, $pop58
	i32.store8	sT+2($pop63), $pop6
	i32.const	$push57=, 0
	i32.const	$push56=, 1103515245
	i32.mul 	$push7=, $0, $pop56
	i32.const	$push55=, 12345
	i32.add 	$push54=, $pop7, $pop55
	tee_local	$push53=, $0=, $pop54
	i32.const	$push52=, 16
	i32.shr_u	$push8=, $pop53, $pop52
	i32.store8	sT+3($pop57), $pop8
	i32.const	$push51=, 0
	i32.const	$push50=, 1103515245
	i32.mul 	$push11=, $0, $pop50
	i32.const	$push49=, 12345
	i32.add 	$push48=, $pop11, $pop49
	tee_local	$push47=, $0=, $pop48
	i32.const	$push46=, 16
	i32.shr_u	$push45=, $pop47, $pop46
	tee_local	$push44=, $1=, $pop45
	i32.const	$push43=, 1
	i32.and 	$push12=, $pop44, $pop43
	i32.const	$push42=, 0
	i32.load16_u	$push9=, sT($pop42)
	i32.const	$push41=, 65534
	i32.and 	$push10=, $pop9, $pop41
	i32.or  	$push13=, $pop12, $pop10
	i32.store16	sT($pop51), $pop13
	i32.const	$push40=, 0
	i32.const	$push39=, 1103515245
	i32.mul 	$push14=, $0, $pop39
	i32.const	$push38=, 12345
	i32.add 	$push37=, $pop14, $pop38
	tee_local	$push36=, $0=, $pop37
	i32.store	myrnd.s($pop40), $pop36
	block   	
	i32.const	$push35=, 16
	i32.shr_u	$push34=, $0, $pop35
	tee_local	$push33=, $2=, $pop34
	i32.add 	$push15=, $pop33, $1
	i32.const	$push32=, 0
	i32.load	$push31=, sT($pop32)
	tee_local	$push30=, $1=, $pop31
	i32.add 	$push16=, $2, $pop30
	i32.xor 	$push17=, $pop15, $pop16
	i32.const	$push29=, 1
	i32.and 	$push18=, $pop17, $pop29
	br_if   	0, $pop18       # 0: down to label8
# BB#1:                                 # %if.end94
	i32.const	$push89=, 0
	i32.const	$push19=, -2139243339
	i32.mul 	$push20=, $0, $pop19
	i32.const	$push21=, -1492899873
	i32.add 	$push88=, $pop20, $pop21
	tee_local	$push87=, $0=, $pop88
	i32.const	$push86=, 1103515245
	i32.mul 	$push22=, $pop87, $pop86
	i32.const	$push85=, 12345
	i32.add 	$push84=, $pop22, $pop85
	tee_local	$push83=, $2=, $pop84
	i32.store	myrnd.s($pop89), $pop83
	i32.const	$push82=, 0
	i32.const	$push81=, 16
	i32.shr_u	$push24=, $2, $pop81
	i32.const	$push80=, 16
	i32.shr_u	$push23=, $0, $pop80
	i32.add 	$push25=, $pop24, $pop23
	i32.const	$push79=, 1
	i32.and 	$push26=, $pop25, $pop79
	i32.const	$push78=, 65534
	i32.and 	$push27=, $1, $pop78
	i32.or  	$push28=, $pop26, $pop27
	i32.store16	sT($pop82), $pop28
	i32.const	$push77=, 1
	i32.eqz 	$push90=, $pop77
	br_if   	0, $pop90       # 0: down to label8
# BB#2:                                 # %if.end140
	return
.LBB120_3:                              # %if.then139
	end_block                       # label8:
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
	i64.load	$push0=, 0($1):p2align=0
	i64.store	0($0):p2align=0, $pop0
	i32.const	$push1=, 8
	i32.add 	$push2=, $0, $pop1
	i32.const	$push5=, 8
	i32.add 	$push3=, $1, $pop5
	i32.load16_u	$push4=, 0($pop3):p2align=0
	i32.store16	0($pop2):p2align=0, $pop4
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
	i32.store16	sU($pop0), $pop8
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
	i32.const	$push0=, 0
	i32.const	$push166=, 0
	i32.load	$push1=, myrnd.s($pop166)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push165=, $pop3, $pop4
	tee_local	$push164=, $2=, $pop165
	i32.const	$push163=, 16
	i32.shr_u	$push5=, $pop164, $pop163
	i32.store8	sU($pop0), $pop5
	i32.const	$push162=, 0
	i32.const	$push161=, 1103515245
	i32.mul 	$push6=, $2, $pop161
	i32.const	$push160=, 12345
	i32.add 	$push159=, $pop6, $pop160
	tee_local	$push158=, $2=, $pop159
	i32.const	$push157=, 16
	i32.shr_u	$push7=, $pop158, $pop157
	i32.store8	sU+1($pop162), $pop7
	i32.const	$push156=, 0
	i32.const	$push155=, 1103515245
	i32.mul 	$push8=, $2, $pop155
	i32.const	$push154=, 12345
	i32.add 	$push153=, $pop8, $pop154
	tee_local	$push152=, $2=, $pop153
	i32.const	$push151=, 16
	i32.shr_u	$push9=, $pop152, $pop151
	i32.store8	sU+2($pop156), $pop9
	i32.const	$push150=, 0
	i32.const	$push149=, 1103515245
	i32.mul 	$push10=, $2, $pop149
	i32.const	$push148=, 12345
	i32.add 	$push147=, $pop10, $pop148
	tee_local	$push146=, $2=, $pop147
	i32.const	$push145=, 16
	i32.shr_u	$push11=, $pop146, $pop145
	i32.store8	sU+3($pop150), $pop11
	i32.const	$push144=, 0
	i32.const	$push143=, 1103515245
	i32.mul 	$push12=, $2, $pop143
	i32.const	$push142=, 12345
	i32.add 	$push141=, $pop12, $pop142
	tee_local	$push140=, $2=, $pop141
	i32.const	$push139=, 16
	i32.shr_u	$push13=, $pop140, $pop139
	i32.store8	sU+4($pop144), $pop13
	i32.const	$push138=, 0
	i32.const	$push137=, 1103515245
	i32.mul 	$push14=, $2, $pop137
	i32.const	$push136=, 12345
	i32.add 	$push135=, $pop14, $pop136
	tee_local	$push134=, $2=, $pop135
	i32.const	$push133=, 16
	i32.shr_u	$push15=, $pop134, $pop133
	i32.store8	sU+5($pop138), $pop15
	i32.const	$push132=, 0
	i32.const	$push131=, 1103515245
	i32.mul 	$push16=, $2, $pop131
	i32.const	$push130=, 12345
	i32.add 	$push129=, $pop16, $pop130
	tee_local	$push128=, $2=, $pop129
	i32.const	$push127=, 16
	i32.shr_u	$push17=, $pop128, $pop127
	i32.store8	sU+6($pop132), $pop17
	i32.const	$push126=, 0
	i32.const	$push125=, 1103515245
	i32.mul 	$push18=, $2, $pop125
	i32.const	$push124=, 12345
	i32.add 	$push123=, $pop18, $pop124
	tee_local	$push122=, $2=, $pop123
	i32.const	$push121=, 16
	i32.shr_u	$push19=, $pop122, $pop121
	i32.store8	sU+7($pop126), $pop19
	i32.const	$push120=, 0
	i32.const	$push119=, 1103515245
	i32.mul 	$push20=, $2, $pop119
	i32.const	$push118=, 12345
	i32.add 	$push117=, $pop20, $pop118
	tee_local	$push116=, $2=, $pop117
	i32.const	$push115=, 16
	i32.shr_u	$push21=, $pop116, $pop115
	i32.store8	sU+8($pop120), $pop21
	i32.const	$push114=, 0
	i32.const	$push113=, 1103515245
	i32.mul 	$push22=, $2, $pop113
	i32.const	$push112=, 12345
	i32.add 	$push111=, $pop22, $pop112
	tee_local	$push110=, $2=, $pop111
	i32.const	$push109=, 16
	i32.shr_u	$push23=, $pop110, $pop109
	i32.store8	sU+9($pop114), $pop23
	i32.const	$push108=, 0
	i32.load16_u	$3=, sU($pop108)
	i32.const	$push107=, 0
	i32.const	$push106=, 1103515245
	i32.mul 	$push24=, $2, $pop106
	i32.const	$push105=, 12345
	i32.add 	$push104=, $pop24, $pop105
	tee_local	$push103=, $2=, $pop104
	i32.const	$push102=, 1103515245
	i32.mul 	$push25=, $pop103, $pop102
	i32.const	$push101=, 12345
	i32.add 	$push100=, $pop25, $pop101
	tee_local	$push99=, $1=, $pop100
	i32.store	myrnd.s($pop107), $pop99
	i32.const	$push98=, 0
	i32.const	$push97=, 16
	i32.shr_u	$push96=, $2, $pop97
	tee_local	$push95=, $0=, $pop96
	i32.const	$push27=, 2047
	i32.and 	$push94=, $pop95, $pop27
	tee_local	$push93=, $4=, $pop94
	i32.const	$push28=, 6
	i32.shl 	$push29=, $pop93, $pop28
	i32.const	$push30=, 64
	i32.and 	$push31=, $pop29, $pop30
	i32.const	$push26=, -65
	i32.and 	$push92=, $3, $pop26
	tee_local	$push91=, $2=, $pop92
	i32.or  	$push90=, $pop31, $pop91
	tee_local	$push89=, $3=, $pop90
	i32.store16	sU($pop98), $pop89
	block   	
	i32.const	$push32=, 65472
	i32.and 	$push33=, $3, $pop32
	i32.const	$push88=, 6
	i32.shr_u	$push87=, $pop33, $pop88
	tee_local	$push86=, $3=, $pop87
	i32.xor 	$push34=, $pop86, $4
	i32.const	$push85=, 1
	i32.and 	$push35=, $pop34, $pop85
	br_if   	0, $pop35       # 0: down to label9
# BB#1:                                 # %lor.lhs.false41
	i32.const	$push170=, 16
	i32.shr_u	$push169=, $1, $pop170
	tee_local	$push168=, $4=, $pop169
	i32.add 	$push37=, $3, $pop168
	i32.add 	$push36=, $4, $0
	i32.xor 	$push38=, $pop37, $pop36
	i32.const	$push167=, 1
	i32.and 	$push39=, $pop38, $pop167
	br_if   	0, $pop39       # 0: down to label9
# BB#2:                                 # %if.end
	i32.const	$push44=, 0
	i32.const	$push40=, 1103515245
	i32.mul 	$push41=, $1, $pop40
	i32.const	$push42=, 12345
	i32.add 	$push188=, $pop41, $pop42
	tee_local	$push187=, $3=, $pop188
	i32.const	$push186=, 1103515245
	i32.mul 	$push43=, $pop187, $pop186
	i32.const	$push185=, 12345
	i32.add 	$push184=, $pop43, $pop185
	tee_local	$push183=, $1=, $pop184
	i32.store	myrnd.s($pop44), $pop183
	i32.const	$push182=, 0
	i32.const	$push181=, 16
	i32.shr_u	$push180=, $3, $pop181
	tee_local	$push179=, $0=, $pop180
	i32.const	$push45=, 2047
	i32.and 	$push178=, $pop179, $pop45
	tee_local	$push177=, $3=, $pop178
	i32.const	$push46=, 6
	i32.shl 	$push47=, $pop177, $pop46
	i32.const	$push48=, 64
	i32.and 	$push49=, $pop47, $pop48
	i32.or  	$push176=, $pop49, $2
	tee_local	$push175=, $4=, $pop176
	i32.store16	sU($pop182), $pop175
	i32.const	$push50=, 65472
	i32.and 	$push51=, $4, $pop50
	i32.const	$push174=, 6
	i32.shr_u	$push173=, $pop51, $pop174
	tee_local	$push172=, $4=, $pop173
	i32.xor 	$push52=, $pop172, $3
	i32.const	$push171=, 1
	i32.and 	$push53=, $pop52, $pop171
	br_if   	0, $pop53       # 0: down to label9
# BB#3:                                 # %lor.lhs.false85
	i32.const	$push194=, 16
	i32.shr_u	$push193=, $1, $pop194
	tee_local	$push192=, $3=, $pop193
	i32.add 	$push58=, $pop192, $0
	i32.const	$push191=, 1
	i32.and 	$push59=, $pop58, $pop191
	i32.const	$push56=, 15
	i32.rem_u	$push60=, $pop59, $pop56
	i32.add 	$push54=, $4, $3
	i32.const	$push190=, 1
	i32.and 	$push55=, $pop54, $pop190
	i32.const	$push189=, 15
	i32.rem_u	$push57=, $pop55, $pop189
	i32.ne  	$push61=, $pop60, $pop57
	br_if   	0, $pop61       # 0: down to label9
# BB#4:                                 # %lor.lhs.false130
	i32.const	$push66=, 0
	i32.const	$push62=, 1103515245
	i32.mul 	$push63=, $1, $pop62
	i32.const	$push64=, 12345
	i32.add 	$push208=, $pop63, $pop64
	tee_local	$push207=, $1=, $pop208
	i32.const	$push206=, 1103515245
	i32.mul 	$push65=, $pop207, $pop206
	i32.const	$push205=, 12345
	i32.add 	$push204=, $pop65, $pop205
	tee_local	$push203=, $3=, $pop204
	i32.store	myrnd.s($pop66), $pop203
	i32.const	$push202=, 0
	i32.const	$push68=, 10
	i32.shr_u	$push69=, $1, $pop68
	i32.const	$push70=, 64
	i32.and 	$push71=, $pop69, $pop70
	i32.or  	$push72=, $pop71, $2
	i32.const	$push73=, 65472
	i32.and 	$push74=, $pop72, $pop73
	i32.const	$push75=, 6
	i32.shr_u	$push76=, $pop74, $pop75
	i32.const	$push67=, 16
	i32.shr_u	$push201=, $3, $pop67
	tee_local	$push200=, $3=, $pop201
	i32.add 	$push199=, $pop76, $pop200
	tee_local	$push198=, $4=, $pop199
	i32.const	$push197=, 6
	i32.shl 	$push77=, $pop198, $pop197
	i32.const	$push196=, 64
	i32.and 	$push78=, $pop77, $pop196
	i32.or  	$push79=, $pop78, $2
	i32.store16	sU($pop202), $pop79
	i32.const	$push195=, 16
	i32.shr_u	$push80=, $1, $pop195
	i32.add 	$push81=, $3, $pop80
	i32.xor 	$push82=, $pop81, $4
	i32.const	$push83=, 1
	i32.and 	$push84=, $pop82, $pop83
	br_if   	0, $pop84       # 0: down to label9
# BB#5:                                 # %if.end136
	return
.LBB126_6:                              # %if.then135
	end_block                       # label9:
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
	i32.load	$push0=, 0($1):p2align=0
	i32.store	0($0):p2align=1, $pop0
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
	i32.store16	sV($pop0), $pop8
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
	i32.const	$push107=, 0
	i32.const	$push106=, 0
	i32.load	$push0=, myrnd.s($pop106)
	i32.const	$push105=, 1103515245
	i32.mul 	$push1=, $pop0, $pop105
	i32.const	$push104=, 12345
	i32.add 	$push103=, $pop1, $pop104
	tee_local	$push102=, $2=, $pop103
	i32.const	$push101=, 16
	i32.shr_u	$push2=, $pop102, $pop101
	i32.store8	sV($pop107), $pop2
	i32.const	$push100=, 0
	i32.const	$push99=, 1103515245
	i32.mul 	$push3=, $2, $pop99
	i32.const	$push98=, 12345
	i32.add 	$push97=, $pop3, $pop98
	tee_local	$push96=, $2=, $pop97
	i32.const	$push95=, 16
	i32.shr_u	$push4=, $pop96, $pop95
	i32.store8	sV+1($pop100), $pop4
	i32.const	$push94=, 0
	i32.const	$push93=, 1103515245
	i32.mul 	$push5=, $2, $pop93
	i32.const	$push92=, 12345
	i32.add 	$push91=, $pop5, $pop92
	tee_local	$push90=, $2=, $pop91
	i32.const	$push89=, 16
	i32.shr_u	$push6=, $pop90, $pop89
	i32.store8	sV+2($pop94), $pop6
	i32.const	$push88=, 0
	i32.const	$push87=, 1103515245
	i32.mul 	$push7=, $2, $pop87
	i32.const	$push86=, 12345
	i32.add 	$push85=, $pop7, $pop86
	tee_local	$push84=, $2=, $pop85
	i32.const	$push83=, 16
	i32.shr_u	$push8=, $pop84, $pop83
	i32.store8	sV+3($pop88), $pop8
	i32.const	$push82=, 0
	i32.const	$push81=, 1103515245
	i32.mul 	$push11=, $2, $pop81
	i32.const	$push80=, 12345
	i32.add 	$push79=, $pop11, $pop80
	tee_local	$push78=, $2=, $pop79
	i32.const	$push77=, 8
	i32.shr_u	$push12=, $pop78, $pop77
	i32.const	$push76=, 256
	i32.and 	$push13=, $pop12, $pop76
	i32.const	$push75=, 0
	i32.load16_u	$push9=, sV($pop75)
	i32.const	$push74=, 65279
	i32.and 	$push10=, $pop9, $pop74
	i32.or  	$push14=, $pop13, $pop10
	i32.store16	sV($pop82), $pop14
	i32.const	$push73=, 0
	i32.const	$push72=, 1103515245
	i32.mul 	$push15=, $2, $pop72
	i32.const	$push71=, 12345
	i32.add 	$push70=, $pop15, $pop71
	tee_local	$push69=, $0=, $pop70
	i32.store	myrnd.s($pop73), $pop69
	block   	
	i32.const	$push68=, 16
	i32.shr_u	$push67=, $0, $pop68
	tee_local	$push66=, $3=, $pop67
	i32.const	$push65=, 16
	i32.shr_u	$push16=, $2, $pop65
	i32.add 	$push17=, $pop66, $pop16
	i32.const	$push64=, 0
	i32.load	$push63=, sV($pop64)
	tee_local	$push62=, $2=, $pop63
	i32.const	$push61=, 8
	i32.shr_u	$push18=, $pop62, $pop61
	i32.add 	$push19=, $pop18, $3
	i32.xor 	$push20=, $pop17, $pop19
	i32.const	$push60=, 1
	i32.and 	$push21=, $pop20, $pop60
	br_if   	0, $pop21       # 0: down to label10
# BB#1:                                 # %if.end
	i32.const	$push130=, 0
	i32.const	$push129=, 1103515245
	i32.mul 	$push22=, $0, $pop129
	i32.const	$push128=, 12345
	i32.add 	$push127=, $pop22, $pop128
	tee_local	$push126=, $3=, $pop127
	i32.const	$push125=, 1103515245
	i32.mul 	$push23=, $pop126, $pop125
	i32.const	$push124=, 12345
	i32.add 	$push123=, $pop23, $pop124
	tee_local	$push122=, $0=, $pop123
	i32.store	myrnd.s($pop130), $pop122
	i32.const	$push121=, 0
	i32.const	$push120=, 16
	i32.shr_u	$push119=, $3, $pop120
	tee_local	$push118=, $1=, $pop119
	i32.const	$push26=, 2047
	i32.and 	$push117=, $pop118, $pop26
	tee_local	$push116=, $3=, $pop117
	i32.const	$push115=, 8
	i32.shl 	$push27=, $pop116, $pop115
	i32.const	$push114=, 256
	i32.and 	$push28=, $pop27, $pop114
	i32.const	$push24=, -257
	i32.and 	$push25=, $2, $pop24
	i32.or  	$push113=, $pop28, $pop25
	tee_local	$push112=, $4=, $pop113
	i32.store16	sV($pop121), $pop112
	i32.const	$push29=, 65280
	i32.and 	$push30=, $4, $pop29
	i32.const	$push111=, 8
	i32.shr_u	$push110=, $pop30, $pop111
	tee_local	$push109=, $4=, $pop110
	i32.xor 	$push31=, $pop109, $3
	i32.const	$push108=, 1
	i32.and 	$push32=, $pop31, $pop108
	br_if   	0, $pop32       # 0: down to label10
# BB#2:                                 # %lor.lhs.false89
	i32.const	$push136=, 16
	i32.shr_u	$push135=, $0, $pop136
	tee_local	$push134=, $3=, $pop135
	i32.add 	$push37=, $pop134, $1
	i32.const	$push133=, 1
	i32.and 	$push38=, $pop37, $pop133
	i32.const	$push35=, 15
	i32.rem_u	$push39=, $pop38, $pop35
	i32.add 	$push33=, $4, $3
	i32.const	$push132=, 1
	i32.and 	$push34=, $pop33, $pop132
	i32.const	$push131=, 15
	i32.rem_u	$push36=, $pop34, $pop131
	i32.ne  	$push40=, $pop39, $pop36
	br_if   	0, $pop40       # 0: down to label10
# BB#3:                                 # %lor.lhs.false136
	i32.const	$push45=, 0
	i32.const	$push41=, 1103515245
	i32.mul 	$push42=, $0, $pop41
	i32.const	$push43=, 12345
	i32.add 	$push155=, $pop42, $pop43
	tee_local	$push154=, $0=, $pop155
	i32.const	$push153=, 1103515245
	i32.mul 	$push44=, $pop154, $pop153
	i32.const	$push152=, 12345
	i32.add 	$push151=, $pop44, $pop152
	tee_local	$push150=, $3=, $pop151
	i32.store	myrnd.s($pop45), $pop150
	i32.const	$push149=, 0
	i32.const	$push47=, 8
	i32.shr_u	$push48=, $0, $pop47
	i32.const	$push49=, 256
	i32.and 	$push50=, $pop48, $pop49
	i32.const	$push148=, 65279
	i32.and 	$push147=, $2, $pop148
	tee_local	$push146=, $2=, $pop147
	i32.or  	$push51=, $pop50, $pop146
	i32.const	$push145=, 8
	i32.shr_u	$push52=, $pop51, $pop145
	i32.const	$push46=, 16
	i32.shr_u	$push144=, $3, $pop46
	tee_local	$push143=, $3=, $pop144
	i32.add 	$push142=, $pop52, $pop143
	tee_local	$push141=, $4=, $pop142
	i32.const	$push140=, 8
	i32.shl 	$push53=, $pop141, $pop140
	i32.const	$push139=, 256
	i32.and 	$push54=, $pop53, $pop139
	i32.or  	$push55=, $pop54, $2
	i32.store16	sV($pop149), $pop55
	i32.const	$push138=, 16
	i32.shr_u	$push56=, $0, $pop138
	i32.add 	$push57=, $3, $pop56
	i32.xor 	$push58=, $pop57, $4
	i32.const	$push137=, 1
	i32.and 	$push59=, $pop58, $pop137
	br_if   	0, $pop59       # 0: down to label10
# BB#4:                                 # %if.end142
	return
.LBB132_5:                              # %if.then141
	end_block                       # label10:
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
	i64.load	$push0=, 0($1):p2align=0
	i64.store	0($0):p2align=0, $pop0
	i32.const	$push1=, 16
	i32.add 	$push2=, $0, $pop1
	i32.const	$push10=, 16
	i32.add 	$push3=, $1, $pop10
	i32.load	$push4=, 0($pop3):p2align=0
	i32.store	0($pop2):p2align=0, $pop4
	i32.const	$push5=, 8
	i32.add 	$push6=, $0, $pop5
	i32.const	$push9=, 8
	i32.add 	$push7=, $1, $pop9
	i64.load	$push8=, 0($pop7):p2align=0
	i64.store	0($pop6):p2align=0, $pop8
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
	i32.store	sW+16($pop0), $pop5
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
	i32.const	$push0=, 0
	i32.const	$push98=, 0
	i32.load	$push1=, myrnd.s($pop98)
	i32.const	$push2=, 1670464429
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 2121308585
	i32.add 	$push97=, $pop3, $pop4
	tee_local	$push96=, $1=, $pop97
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop96, $pop5
	i32.store8	sW+16($pop0), $pop6
	i32.const	$push95=, 0
	i32.const	$push7=, 1103515245
	i32.mul 	$push8=, $1, $pop7
	i32.const	$push9=, 12345
	i32.add 	$push94=, $pop8, $pop9
	tee_local	$push93=, $1=, $pop94
	i32.const	$push92=, 16
	i32.shr_u	$push10=, $pop93, $pop92
	i32.store8	sW+17($pop95), $pop10
	i32.const	$push91=, 0
	i32.const	$push90=, 1103515245
	i32.mul 	$push11=, $1, $pop90
	i32.const	$push89=, 12345
	i32.add 	$push88=, $pop11, $pop89
	tee_local	$push87=, $1=, $pop88
	i32.const	$push86=, 16
	i32.shr_u	$push12=, $pop87, $pop86
	i32.store8	sW+18($pop91), $pop12
	i32.const	$push85=, 0
	i32.const	$push84=, 1103515245
	i32.mul 	$push13=, $1, $pop84
	i32.const	$push83=, 12345
	i32.add 	$push82=, $pop13, $pop83
	tee_local	$push81=, $1=, $pop82
	i32.const	$push80=, 16
	i32.shr_u	$push14=, $pop81, $pop80
	i32.store8	sW+19($pop85), $pop14
	i32.const	$push79=, 0
	i64.const	$push15=, 4612055454334320640
	i64.store	sW+8($pop79), $pop15
	i32.const	$push78=, 0
	i64.const	$push16=, 0
	i64.store	sW($pop78), $pop16
	i32.const	$push77=, 0
	i32.const	$push76=, 1103515245
	i32.mul 	$push17=, $1, $pop76
	i32.const	$push75=, 12345
	i32.add 	$push74=, $pop17, $pop75
	tee_local	$push73=, $1=, $pop74
	i32.const	$push72=, 1103515245
	i32.mul 	$push18=, $pop73, $pop72
	i32.const	$push71=, 12345
	i32.add 	$push70=, $pop18, $pop71
	tee_local	$push69=, $0=, $pop70
	i32.store	myrnd.s($pop77), $pop69
	i32.const	$push68=, 0
	i32.const	$push67=, 16
	i32.shr_u	$push21=, $1, $pop67
	i32.const	$push22=, 2047
	i32.and 	$push23=, $pop21, $pop22
	i32.const	$push66=, 0
	i32.load	$push19=, sW+16($pop66)
	i32.const	$push20=, -4096
	i32.and 	$push65=, $pop19, $pop20
	tee_local	$push64=, $1=, $pop65
	i32.or  	$push24=, $pop23, $pop64
	i32.store	sW+16($pop68), $pop24
	i32.const	$push63=, 0
	i32.const	$push62=, 1103515245
	i32.mul 	$push25=, $0, $pop62
	i32.const	$push61=, 12345
	i32.add 	$push60=, $pop25, $pop61
	tee_local	$push59=, $0=, $pop60
	i32.const	$push58=, 1103515245
	i32.mul 	$push26=, $pop59, $pop58
	i32.const	$push57=, 12345
	i32.add 	$push56=, $pop26, $pop57
	tee_local	$push55=, $2=, $pop56
	i32.store	myrnd.s($pop63), $pop55
	i32.const	$push54=, 0
	i32.const	$push53=, 16
	i32.shr_u	$push27=, $0, $pop53
	i32.const	$push52=, 2047
	i32.and 	$push28=, $pop27, $pop52
	i32.or  	$push29=, $pop28, $1
	i32.store	sW+16($pop54), $pop29
	i32.const	$push51=, 0
	i32.const	$push50=, 1103515245
	i32.mul 	$push30=, $2, $pop50
	i32.const	$push49=, 12345
	i32.add 	$push48=, $pop30, $pop49
	tee_local	$push47=, $0=, $pop48
	i32.const	$push46=, 1103515245
	i32.mul 	$push31=, $pop47, $pop46
	i32.const	$push45=, 12345
	i32.add 	$push44=, $pop31, $pop45
	tee_local	$push43=, $2=, $pop44
	i32.store	myrnd.s($pop51), $pop43
	i32.const	$push42=, 0
	i32.const	$push41=, 16
	i32.shr_u	$push34=, $2, $pop41
	i32.const	$push40=, 2047
	i32.and 	$push35=, $pop34, $pop40
	i32.const	$push39=, 16
	i32.shr_u	$push32=, $0, $pop39
	i32.const	$push38=, 2047
	i32.and 	$push33=, $pop32, $pop38
	i32.add 	$push36=, $pop35, $pop33
	i32.or  	$push37=, $pop36, $1
	i32.store	sW+16($pop42), $pop37
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
	i64.load	$push0=, 0($1):p2align=0
	i64.store	0($0):p2align=0, $pop0
	i32.const	$push1=, 16
	i32.add 	$push2=, $0, $pop1
	i32.const	$push10=, 16
	i32.add 	$push3=, $1, $pop10
	i32.load	$push4=, 0($pop3):p2align=0
	i32.store	0($pop2):p2align=0, $pop4
	i32.const	$push5=, 8
	i32.add 	$push6=, $0, $pop5
	i32.const	$push9=, 8
	i32.add 	$push7=, $1, $pop9
	i64.load	$push8=, 0($pop7):p2align=0
	i64.store	0($pop6):p2align=0, $pop8
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
	i32.store	sX($pop0), $pop5
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
	i32.const	$push0=, 0
	i32.const	$push98=, 0
	i32.load	$push1=, myrnd.s($pop98)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push97=, $pop3, $pop4
	tee_local	$push96=, $1=, $pop97
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop96, $pop5
	i32.store8	sX($pop0), $pop6
	i32.const	$push95=, 0
	i32.const	$push94=, 1103515245
	i32.mul 	$push7=, $1, $pop94
	i32.const	$push93=, 12345
	i32.add 	$push92=, $pop7, $pop93
	tee_local	$push91=, $1=, $pop92
	i32.const	$push90=, 16
	i32.shr_u	$push8=, $pop91, $pop90
	i32.store8	sX+1($pop95), $pop8
	i32.const	$push89=, 0
	i32.const	$push88=, 1103515245
	i32.mul 	$push9=, $1, $pop88
	i32.const	$push87=, 12345
	i32.add 	$push86=, $pop9, $pop87
	tee_local	$push85=, $1=, $pop86
	i32.const	$push84=, 16
	i32.shr_u	$push10=, $pop85, $pop84
	i32.store8	sX+2($pop89), $pop10
	i32.const	$push83=, 0
	i32.const	$push82=, 1103515245
	i32.mul 	$push11=, $1, $pop82
	i32.const	$push81=, 12345
	i32.add 	$push80=, $pop11, $pop81
	tee_local	$push79=, $1=, $pop80
	i32.const	$push78=, 16
	i32.shr_u	$push12=, $pop79, $pop78
	i32.store8	sX+3($pop83), $pop12
	i32.const	$push77=, 0
	i64.const	$push13=, 4612055454334320640
	i64.store	sX+12($pop77):p2align=2, $pop13
	i32.const	$push76=, 0
	i64.const	$push14=, 0
	i64.store	sX+4($pop76):p2align=2, $pop14
	i32.const	$push75=, 0
	i32.const	$push15=, 1670464429
	i32.mul 	$push16=, $1, $pop15
	i32.const	$push17=, 2121308585
	i32.add 	$push74=, $pop16, $pop17
	tee_local	$push73=, $1=, $pop74
	i32.const	$push72=, 1103515245
	i32.mul 	$push18=, $pop73, $pop72
	i32.const	$push71=, 12345
	i32.add 	$push70=, $pop18, $pop71
	tee_local	$push69=, $0=, $pop70
	i32.store	myrnd.s($pop75), $pop69
	i32.const	$push68=, 0
	i32.const	$push67=, 16
	i32.shr_u	$push21=, $1, $pop67
	i32.const	$push22=, 2047
	i32.and 	$push23=, $pop21, $pop22
	i32.const	$push66=, 0
	i32.load	$push19=, sX($pop66)
	i32.const	$push20=, -4096
	i32.and 	$push65=, $pop19, $pop20
	tee_local	$push64=, $1=, $pop65
	i32.or  	$push24=, $pop23, $pop64
	i32.store	sX($pop68), $pop24
	i32.const	$push63=, 0
	i32.const	$push62=, 1103515245
	i32.mul 	$push25=, $0, $pop62
	i32.const	$push61=, 12345
	i32.add 	$push60=, $pop25, $pop61
	tee_local	$push59=, $0=, $pop60
	i32.const	$push58=, 1103515245
	i32.mul 	$push26=, $pop59, $pop58
	i32.const	$push57=, 12345
	i32.add 	$push56=, $pop26, $pop57
	tee_local	$push55=, $2=, $pop56
	i32.store	myrnd.s($pop63), $pop55
	i32.const	$push54=, 0
	i32.const	$push53=, 16
	i32.shr_u	$push27=, $0, $pop53
	i32.const	$push52=, 2047
	i32.and 	$push28=, $pop27, $pop52
	i32.or  	$push29=, $pop28, $1
	i32.store	sX($pop54), $pop29
	i32.const	$push51=, 0
	i32.const	$push50=, 1103515245
	i32.mul 	$push30=, $2, $pop50
	i32.const	$push49=, 12345
	i32.add 	$push48=, $pop30, $pop49
	tee_local	$push47=, $0=, $pop48
	i32.const	$push46=, 1103515245
	i32.mul 	$push31=, $pop47, $pop46
	i32.const	$push45=, 12345
	i32.add 	$push44=, $pop31, $pop45
	tee_local	$push43=, $2=, $pop44
	i32.store	myrnd.s($pop51), $pop43
	i32.const	$push42=, 0
	i32.const	$push41=, 16
	i32.shr_u	$push34=, $2, $pop41
	i32.const	$push40=, 2047
	i32.and 	$push35=, $pop34, $pop40
	i32.const	$push39=, 16
	i32.shr_u	$push32=, $0, $pop39
	i32.const	$push38=, 2047
	i32.and 	$push33=, $pop32, $pop38
	i32.add 	$push36=, $pop35, $pop33
	i32.or  	$push37=, $pop36, $1
	i32.store	sX($pop42), $pop37
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
	i64.load	$push0=, 0($1):p2align=0
	i64.store	0($0):p2align=0, $pop0
	i32.const	$push1=, 16
	i32.add 	$push2=, $0, $pop1
	i32.const	$push10=, 16
	i32.add 	$push3=, $1, $pop10
	i32.load	$push4=, 0($pop3):p2align=0
	i32.store	0($pop2):p2align=0, $pop4
	i32.const	$push5=, 8
	i32.add 	$push6=, $0, $pop5
	i32.const	$push9=, 8
	i32.add 	$push7=, $1, $pop9
	i64.load	$push8=, 0($pop7):p2align=0
	i64.store	0($pop6):p2align=0, $pop8
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
	i32.store	sY($pop0), $pop5
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
	i32.const	$push0=, 0
	i32.const	$push98=, 0
	i32.load	$push1=, myrnd.s($pop98)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push97=, $pop3, $pop4
	tee_local	$push96=, $1=, $pop97
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop96, $pop5
	i32.store8	sY($pop0), $pop6
	i32.const	$push95=, 0
	i32.const	$push94=, 1103515245
	i32.mul 	$push7=, $1, $pop94
	i32.const	$push93=, 12345
	i32.add 	$push92=, $pop7, $pop93
	tee_local	$push91=, $1=, $pop92
	i32.const	$push90=, 16
	i32.shr_u	$push8=, $pop91, $pop90
	i32.store8	sY+1($pop95), $pop8
	i32.const	$push89=, 0
	i32.const	$push88=, 1103515245
	i32.mul 	$push9=, $1, $pop88
	i32.const	$push87=, 12345
	i32.add 	$push86=, $pop9, $pop87
	tee_local	$push85=, $1=, $pop86
	i32.const	$push84=, 16
	i32.shr_u	$push10=, $pop85, $pop84
	i32.store8	sY+2($pop89), $pop10
	i32.const	$push83=, 0
	i32.const	$push82=, 1103515245
	i32.mul 	$push11=, $1, $pop82
	i32.const	$push81=, 12345
	i32.add 	$push80=, $pop11, $pop81
	tee_local	$push79=, $1=, $pop80
	i32.const	$push78=, 16
	i32.shr_u	$push12=, $pop79, $pop78
	i32.store8	sY+3($pop83), $pop12
	i32.const	$push77=, 0
	i64.const	$push13=, 4612055454334320640
	i64.store	sY+12($pop77):p2align=2, $pop13
	i32.const	$push76=, 0
	i64.const	$push14=, 0
	i64.store	sY+4($pop76):p2align=2, $pop14
	i32.const	$push75=, 0
	i32.const	$push15=, 1670464429
	i32.mul 	$push16=, $1, $pop15
	i32.const	$push17=, 2121308585
	i32.add 	$push74=, $pop16, $pop17
	tee_local	$push73=, $1=, $pop74
	i32.const	$push72=, 1103515245
	i32.mul 	$push18=, $pop73, $pop72
	i32.const	$push71=, 12345
	i32.add 	$push70=, $pop18, $pop71
	tee_local	$push69=, $0=, $pop70
	i32.store	myrnd.s($pop75), $pop69
	i32.const	$push68=, 0
	i32.const	$push67=, 16
	i32.shr_u	$push21=, $1, $pop67
	i32.const	$push22=, 2047
	i32.and 	$push23=, $pop21, $pop22
	i32.const	$push66=, 0
	i32.load	$push19=, sY($pop66)
	i32.const	$push20=, -4096
	i32.and 	$push65=, $pop19, $pop20
	tee_local	$push64=, $1=, $pop65
	i32.or  	$push24=, $pop23, $pop64
	i32.store	sY($pop68), $pop24
	i32.const	$push63=, 0
	i32.const	$push62=, 1103515245
	i32.mul 	$push25=, $0, $pop62
	i32.const	$push61=, 12345
	i32.add 	$push60=, $pop25, $pop61
	tee_local	$push59=, $0=, $pop60
	i32.const	$push58=, 1103515245
	i32.mul 	$push26=, $pop59, $pop58
	i32.const	$push57=, 12345
	i32.add 	$push56=, $pop26, $pop57
	tee_local	$push55=, $2=, $pop56
	i32.store	myrnd.s($pop63), $pop55
	i32.const	$push54=, 0
	i32.const	$push53=, 16
	i32.shr_u	$push27=, $0, $pop53
	i32.const	$push52=, 2047
	i32.and 	$push28=, $pop27, $pop52
	i32.or  	$push29=, $pop28, $1
	i32.store	sY($pop54), $pop29
	i32.const	$push51=, 0
	i32.const	$push50=, 1103515245
	i32.mul 	$push30=, $2, $pop50
	i32.const	$push49=, 12345
	i32.add 	$push48=, $pop30, $pop49
	tee_local	$push47=, $0=, $pop48
	i32.const	$push46=, 1103515245
	i32.mul 	$push31=, $pop47, $pop46
	i32.const	$push45=, 12345
	i32.add 	$push44=, $pop31, $pop45
	tee_local	$push43=, $2=, $pop44
	i32.store	myrnd.s($pop51), $pop43
	i32.const	$push42=, 0
	i32.const	$push41=, 16
	i32.shr_u	$push34=, $2, $pop41
	i32.const	$push40=, 2047
	i32.and 	$push35=, $pop34, $pop40
	i32.const	$push39=, 16
	i32.shr_u	$push32=, $0, $pop39
	i32.const	$push38=, 2047
	i32.and 	$push33=, $pop32, $pop38
	i32.add 	$push36=, $pop35, $pop33
	i32.or  	$push37=, $pop36, $1
	i32.store	sY($pop42), $pop37
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
	i64.load	$push0=, 0($1):p2align=0
	i64.store	0($0):p2align=0, $pop0
	i32.const	$push1=, 16
	i32.add 	$push2=, $0, $pop1
	i32.const	$push10=, 16
	i32.add 	$push3=, $1, $pop10
	i32.load	$push4=, 0($pop3):p2align=0
	i32.store	0($pop2):p2align=0, $pop4
	i32.const	$push5=, 8
	i32.add 	$push6=, $0, $pop5
	i32.const	$push9=, 8
	i32.add 	$push7=, $1, $pop9
	i64.load	$push8=, 0($pop7):p2align=0
	i64.store	0($pop6):p2align=0, $pop8
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

	.section	.text.testZ,"ax",@progbits
	.hidden	testZ
	.globl	testZ
	.type	testZ,@function
testZ:                                  # @testZ
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push98=, 0
	i32.const	$push97=, 0
	i32.load	$push1=, myrnd.s($pop97)
	i32.const	$push2=, 1670464429
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 2121308585
	i32.add 	$push96=, $pop3, $pop4
	tee_local	$push95=, $0=, $pop96
	i32.const	$push94=, 16
	i32.shr_u	$push5=, $pop95, $pop94
	i32.store8	sZ+16($pop98), $pop5
	i32.const	$push93=, 0
	i32.const	$push92=, 1103515245
	i32.mul 	$push6=, $0, $pop92
	i32.const	$push91=, 12345
	i32.add 	$push90=, $pop6, $pop91
	tee_local	$push89=, $0=, $pop90
	i32.const	$push88=, 16
	i32.shr_u	$push7=, $pop89, $pop88
	i32.store8	sZ+17($pop93), $pop7
	i32.const	$push87=, 0
	i32.const	$push86=, 1103515245
	i32.mul 	$push8=, $0, $pop86
	i32.const	$push85=, 12345
	i32.add 	$push84=, $pop8, $pop85
	tee_local	$push83=, $0=, $pop84
	i32.const	$push82=, 16
	i32.shr_u	$push9=, $pop83, $pop82
	i32.store8	sZ+18($pop87), $pop9
	i32.const	$push81=, 0
	i32.const	$push80=, 1103515245
	i32.mul 	$push10=, $0, $pop80
	i32.const	$push79=, 12345
	i32.add 	$push78=, $pop10, $pop79
	tee_local	$push77=, $0=, $pop78
	i32.const	$push76=, 16
	i32.shr_u	$push11=, $pop77, $pop76
	i32.store8	sZ+19($pop81), $pop11
	i32.const	$push75=, 0
	i64.const	$push12=, 4612055454334320640
	i64.store	sZ+8($pop75), $pop12
	i32.const	$push74=, 0
	i64.const	$push13=, 0
	i64.store	sZ($pop74), $pop13
	i32.const	$push73=, 0
	i32.const	$push72=, 1103515245
	i32.mul 	$push14=, $0, $pop72
	i32.const	$push71=, 12345
	i32.add 	$push70=, $pop14, $pop71
	tee_local	$push69=, $1=, $pop70
	i32.const	$push68=, 1103515245
	i32.mul 	$push15=, $pop69, $pop68
	i32.const	$push67=, 12345
	i32.add 	$push66=, $pop15, $pop67
	tee_local	$push65=, $0=, $pop66
	i32.store	myrnd.s($pop73), $pop65
	i32.const	$push64=, 0
	i32.const	$push63=, 16
	i32.shr_u	$push17=, $1, $pop63
	i32.const	$push62=, 2047
	i32.and 	$push61=, $pop17, $pop62
	tee_local	$push60=, $2=, $pop61
	i32.const	$push59=, 20
	i32.shl 	$push18=, $pop60, $pop59
	i32.const	$push58=, 0
	i32.load	$push0=, sZ+16($pop58)
	i32.const	$push16=, 1048575
	i32.and 	$push57=, $pop0, $pop16
	tee_local	$push56=, $1=, $pop57
	i32.or  	$push55=, $pop18, $pop56
	tee_local	$push54=, $3=, $pop55
	i32.store	sZ+16($pop64), $pop54
	block   	
	i32.const	$push53=, 16
	i32.shr_u	$push19=, $0, $pop53
	i32.const	$push52=, 2047
	i32.and 	$push51=, $pop19, $pop52
	tee_local	$push50=, $4=, $pop51
	i32.add 	$push20=, $pop50, $2
	i32.const	$push49=, 20
	i32.shl 	$push21=, $4, $pop49
	i32.add 	$push22=, $pop21, $3
	i32.const	$push48=, 20
	i32.shr_u	$push23=, $pop22, $pop48
	i32.ne  	$push24=, $pop20, $pop23
	br_if   	0, $pop24       # 0: down to label11
# BB#1:                                 # %if.end80
	i32.const	$push124=, 0
	i32.const	$push123=, 1103515245
	i32.mul 	$push25=, $0, $pop123
	i32.const	$push122=, 12345
	i32.add 	$push121=, $pop25, $pop122
	tee_local	$push120=, $2=, $pop121
	i32.const	$push26=, -1029531031
	i32.mul 	$push27=, $pop120, $pop26
	i32.const	$push28=, -740551042
	i32.add 	$push119=, $pop27, $pop28
	tee_local	$push118=, $0=, $pop119
	i32.const	$push117=, 1103515245
	i32.mul 	$push29=, $pop118, $pop117
	i32.const	$push116=, 12345
	i32.add 	$push115=, $pop29, $pop116
	tee_local	$push114=, $3=, $pop115
	i32.store	myrnd.s($pop124), $pop114
	i32.const	$push113=, 0
	i32.const	$push112=, 16
	i32.shr_u	$push33=, $3, $pop112
	i32.const	$push111=, 2047
	i32.and 	$push110=, $pop33, $pop111
	tee_local	$push109=, $3=, $pop110
	i32.const	$push108=, 20
	i32.shl 	$push34=, $pop109, $pop108
	i32.const	$push107=, 16
	i32.shr_u	$push30=, $0, $pop107
	i32.const	$push106=, 2047
	i32.and 	$push105=, $pop30, $pop106
	tee_local	$push104=, $4=, $pop105
	i32.const	$push103=, 20
	i32.shl 	$push31=, $pop104, $pop103
	i32.or  	$push32=, $pop31, $1
	i32.add 	$push102=, $pop34, $pop32
	tee_local	$push101=, $0=, $pop102
	i32.store	sZ+16($pop113), $pop101
	i32.const	$push35=, 4
	i32.shl 	$push36=, $2, $pop35
	i32.const	$push37=, 2146435072
	i32.and 	$push38=, $pop36, $pop37
	i32.or  	$push39=, $pop38, $1
	i32.xor 	$push100=, $0, $pop39
	tee_local	$push99=, $1=, $pop100
	i32.const	$push40=, 1040384
	i32.and 	$push41=, $pop99, $pop40
	br_if   	0, $pop41       # 0: down to label11
# BB#2:                                 # %lor.lhs.false98
	i32.add 	$push45=, $3, $4
	i32.const	$push43=, 20
	i32.shr_u	$push44=, $0, $pop43
	i32.ne  	$push46=, $pop45, $pop44
	br_if   	0, $pop46       # 0: down to label11
# BB#3:                                 # %lor.lhs.false98
	i32.const	$push47=, 8191
	i32.and 	$push42=, $1, $pop47
	br_if   	0, $pop42       # 0: down to label11
# BB#4:                                 # %if.end121
	return
.LBB156_5:                              # %if.then120
	end_block                       # label11:
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
	.p2align	1
sA:
	.skip	2
	.size	sA, 2

	.hidden	sB                      # @sB
	.type	sB,@object
	.section	.bss.sB,"aw",@nobits
	.globl	sB
	.p2align	1
sB:
	.skip	6
	.size	sB, 6

	.hidden	sC                      # @sC
	.type	sC,@object
	.section	.bss.sC,"aw",@nobits
	.globl	sC
	.p2align	2
sC:
	.skip	6
	.size	sC, 6

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
sG:
	.skip	9
	.size	sG, 9

	.hidden	sH                      # @sH
	.type	sH,@object
	.section	.bss.sH,"aw",@nobits
	.globl	sH
	.p2align	1
sH:
	.skip	10
	.size	sH, 10

	.hidden	sI                      # @sI
	.type	sI,@object
	.section	.bss.sI,"aw",@nobits
	.globl	sI
sI:
	.skip	9
	.size	sI, 9

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
	.p2align	1
sQ:
	.skip	10
	.size	sQ, 10

	.hidden	sR                      # @sR
	.type	sR,@object
	.section	.bss.sR,"aw",@nobits
	.globl	sR
	.p2align	1
sR:
	.skip	10
	.size	sR, 10

	.hidden	sS                      # @sS
	.type	sS,@object
	.section	.bss.sS,"aw",@nobits
	.globl	sS
	.p2align	1
sS:
	.skip	10
	.size	sS, 10

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
	.p2align	1
sU:
	.skip	10
	.size	sU, 10

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
	.skip	20
	.size	sW, 20

	.hidden	sX                      # @sX
	.type	sX,@object
	.section	.bss.sX,"aw",@nobits
	.globl	sX
	.p2align	2
sX:
	.skip	20
	.size	sX, 20

	.hidden	sY                      # @sY
	.type	sY,@object
	.section	.bss.sY,"aw",@nobits
	.globl	sY
	.p2align	2
sY:
	.skip	20
	.size	sY, 20

	.hidden	sZ                      # @sZ
	.type	sZ,@object
	.section	.bss.sZ,"aw",@nobits
	.globl	sZ
	.p2align	4
sZ:
	.skip	20
	.size	sZ, 20


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
