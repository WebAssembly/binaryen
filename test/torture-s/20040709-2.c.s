	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040709-2.c"
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
	i32.load16_u	$push0=, 0($1):p2align=0
	i32.store16	$discard=, 0($0), $pop0
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
	i32.load16_u	$push1=, sA($pop0)
	i32.const	$push2=, 5
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 2047
	i32.and 	$push6=, $pop4, $pop5
	return  	$pop6
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
	i32.load16_u	$push1=, sA($pop0)
	i32.const	$push2=, 5
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push14=, 0
	i32.load16_u	$push13=, sA($pop14)
	tee_local	$push12=, $1=, $pop13
	i32.const	$push1=, 5
	i32.shr_u	$push2=, $pop12, $pop1
	i32.add 	$push11=, $pop2, $0
	tee_local	$push10=, $0=, $pop11
	i32.const	$push9=, 5
	i32.shl 	$push3=, $pop10, $pop9
	i32.const	$push4=, 31
	i32.and 	$push5=, $1, $pop4
	i32.or  	$push6=, $pop3, $pop5
	i32.store16	$discard=, sA($pop0), $pop6
	i32.const	$push7=, 2047
	i32.and 	$push8=, $0, $pop7
	return  	$pop8
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
	i32.const	$push40=, 0
	i32.load	$push1=, myrnd.s($pop40)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push39=, $pop3, $pop4
	tee_local	$push38=, $1=, $pop39
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop38, $pop5
	i32.store8	$discard=, sA($pop0):p2align=1, $pop6
	i32.const	$push37=, 0
	i32.const	$push36=, 1103515245
	i32.mul 	$push7=, $1, $pop36
	i32.const	$push35=, 12345
	i32.add 	$push34=, $pop7, $pop35
	tee_local	$push33=, $1=, $pop34
	i32.const	$push32=, 16
	i32.shr_u	$push8=, $pop33, $pop32
	i32.store8	$discard=, sA+1($pop37), $pop8
	i32.const	$push31=, 0
	i32.load16_u	$0=, sA($pop31)
	i32.const	$push30=, 0
	i32.const	$push29=, 0
	i32.const	$push9=, -341751747
	i32.mul 	$push10=, $1, $pop9
	i32.const	$push11=, 229283573
	i32.add 	$push28=, $pop10, $pop11
	tee_local	$push27=, $1=, $pop28
	i32.const	$push26=, 1103515245
	i32.mul 	$push13=, $pop27, $pop26
	i32.const	$push25=, 12345
	i32.add 	$push14=, $pop13, $pop25
	i32.store	$push15=, myrnd.s($pop29), $pop14
	i32.const	$push24=, 16
	i32.shr_u	$push16=, $pop15, $pop24
	i32.const	$push23=, 16
	i32.shr_u	$push12=, $1, $pop23
	i32.add 	$push19=, $pop16, $pop12
	i32.const	$push20=, 5
	i32.shl 	$push21=, $pop19, $pop20
	i32.const	$push17=, 31
	i32.and 	$push18=, $0, $pop17
	i32.or  	$push22=, $pop21, $pop18
	i32.store16	$discard=, sA($pop30), $pop22
	return
	.endfunc
.Lfunc_end6:
	.size	testA, .Lfunc_end6-testA

	.section	.text.retmeB,"ax",@progbits
	.hidden	retmeB
	.globl	retmeB
	.type	retmeB,@function
retmeB:                                 # @retmeB
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 4
	i32.add 	$push3=, $1, $pop1
	i32.load16_u	$2=, 0($pop3):p2align=0
	i32.load	$push0=, 0($1):p2align=0
	i32.store	$discard=, 0($0):p2align=0, $pop0
	i32.const	$push4=, 4
	i32.add 	$push2=, $0, $pop4
	i32.store16	$discard=, 0($pop2):p2align=0, $2
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
	i32.load16_u	$push1=, sB($pop0)
	i32.const	$push2=, 5
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 2047
	i32.and 	$push6=, $pop4, $pop5
	return  	$pop6
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
	i32.load16_u	$push1=, sB($pop0)
	i32.const	$push2=, 5
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push14=, 0
	i32.load16_u	$push13=, sB($pop14)
	tee_local	$push12=, $1=, $pop13
	i32.const	$push1=, 5
	i32.shr_u	$push2=, $pop12, $pop1
	i32.add 	$push11=, $pop2, $0
	tee_local	$push10=, $0=, $pop11
	i32.const	$push9=, 5
	i32.shl 	$push3=, $pop10, $pop9
	i32.const	$push4=, 31
	i32.and 	$push5=, $1, $pop4
	i32.or  	$push6=, $pop3, $pop5
	i32.store16	$discard=, sB($pop0), $pop6
	i32.const	$push7=, 2047
	i32.and 	$push8=, $0, $pop7
	return  	$pop8
	.endfunc
.Lfunc_end11:
	.size	fn3B, .Lfunc_end11-fn3B

	.section	.text.testB,"ax",@progbits
	.hidden	testB
	.globl	testB
	.type	testB,@function
testB:                                  # @testB
	.local  	i32, i32
# BB#0:                                 # %if.end136
	i32.const	$push0=, 0
	i32.const	$push72=, 0
	i32.load	$push1=, myrnd.s($pop72)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push71=, $pop3, $pop4
	tee_local	$push70=, $1=, $pop71
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop70, $pop5
	i32.store8	$discard=, sB($pop0):p2align=1, $pop6
	i32.const	$push69=, 0
	i32.const	$push68=, 1103515245
	i32.mul 	$push7=, $1, $pop68
	i32.const	$push67=, 12345
	i32.add 	$push66=, $pop7, $pop67
	tee_local	$push65=, $1=, $pop66
	i32.const	$push64=, 16
	i32.shr_u	$push8=, $pop65, $pop64
	i32.store8	$discard=, sB+1($pop69), $pop8
	i32.const	$push63=, 0
	i32.const	$push62=, 1103515245
	i32.mul 	$push9=, $1, $pop62
	i32.const	$push61=, 12345
	i32.add 	$push60=, $pop9, $pop61
	tee_local	$push59=, $1=, $pop60
	i32.const	$push58=, 16
	i32.shr_u	$push10=, $pop59, $pop58
	i32.store8	$discard=, sB+2($pop63):p2align=1, $pop10
	i32.const	$push57=, 0
	i32.const	$push56=, 1103515245
	i32.mul 	$push11=, $1, $pop56
	i32.const	$push55=, 12345
	i32.add 	$push54=, $pop11, $pop55
	tee_local	$push53=, $1=, $pop54
	i32.const	$push52=, 16
	i32.shr_u	$push12=, $pop53, $pop52
	i32.store8	$discard=, sB+3($pop57), $pop12
	i32.const	$push51=, 0
	i32.const	$push50=, 1103515245
	i32.mul 	$push13=, $1, $pop50
	i32.const	$push49=, 12345
	i32.add 	$push48=, $pop13, $pop49
	tee_local	$push47=, $1=, $pop48
	i32.const	$push46=, 16
	i32.shr_u	$push14=, $pop47, $pop46
	i32.store8	$discard=, sB+4($pop51):p2align=1, $pop14
	i32.const	$push45=, 0
	i32.const	$push44=, 1103515245
	i32.mul 	$push15=, $1, $pop44
	i32.const	$push43=, 12345
	i32.add 	$push42=, $pop15, $pop43
	tee_local	$push41=, $1=, $pop42
	i32.const	$push40=, 16
	i32.shr_u	$push16=, $pop41, $pop40
	i32.store8	$discard=, sB+5($pop45), $pop16
	i32.const	$push39=, 0
	i32.load16_u	$0=, sB($pop39)
	i32.const	$push38=, 0
	i32.const	$push37=, 0
	i32.const	$push17=, -341751747
	i32.mul 	$push18=, $1, $pop17
	i32.const	$push19=, 229283573
	i32.add 	$push36=, $pop18, $pop19
	tee_local	$push35=, $1=, $pop36
	i32.const	$push34=, 1103515245
	i32.mul 	$push21=, $pop35, $pop34
	i32.const	$push33=, 12345
	i32.add 	$push22=, $pop21, $pop33
	i32.store	$push23=, myrnd.s($pop37), $pop22
	i32.const	$push32=, 16
	i32.shr_u	$push24=, $pop23, $pop32
	i32.const	$push31=, 16
	i32.shr_u	$push20=, $1, $pop31
	i32.add 	$push27=, $pop24, $pop20
	i32.const	$push28=, 5
	i32.shl 	$push29=, $pop27, $pop28
	i32.const	$push25=, 31
	i32.and 	$push26=, $0, $pop25
	i32.or  	$push30=, $pop29, $pop26
	i32.store16	$discard=, sB($pop38), $pop30
	return
	.endfunc
.Lfunc_end12:
	.size	testB, .Lfunc_end12-testB

	.section	.text.retmeC,"ax",@progbits
	.hidden	retmeC
	.globl	retmeC
	.type	retmeC,@function
retmeC:                                 # @retmeC
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 4
	i32.add 	$push3=, $1, $pop1
	i32.load16_u	$2=, 0($pop3):p2align=0
	i32.load	$push0=, 0($1):p2align=0
	i32.store	$discard=, 0($0):p2align=0, $pop0
	i32.const	$push4=, 4
	i32.add 	$push2=, $0, $pop4
	i32.store16	$discard=, 0($pop2):p2align=0, $2
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
	i32.load16_u	$push1=, sC+4($pop0):p2align=2
	i32.const	$push2=, 5
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 2047
	i32.and 	$push6=, $pop4, $pop5
	return  	$pop6
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
	i32.load16_u	$push1=, sC+4($pop0):p2align=2
	i32.const	$push2=, 5
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 2047
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
	i32.load16_u	$push1=, sC+4($pop0):p2align=2
	i32.const	$push2=, 5
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push14=, 0
	i32.load16_u	$push13=, sC+4($pop14):p2align=2
	tee_local	$push12=, $1=, $pop13
	i32.const	$push1=, 5
	i32.shr_u	$push2=, $pop12, $pop1
	i32.add 	$push11=, $pop2, $0
	tee_local	$push10=, $0=, $pop11
	i32.const	$push9=, 5
	i32.shl 	$push3=, $pop10, $pop9
	i32.const	$push4=, 31
	i32.and 	$push5=, $1, $pop4
	i32.or  	$push6=, $pop3, $pop5
	i32.store16	$discard=, sC+4($pop0):p2align=2, $pop6
	i32.const	$push7=, 2047
	i32.and 	$push8=, $0, $pop7
	return  	$pop8
	.endfunc
.Lfunc_end17:
	.size	fn3C, .Lfunc_end17-fn3C

	.section	.text.testC,"ax",@progbits
	.hidden	testC
	.globl	testC
	.type	testC,@function
testC:                                  # @testC
	.local  	i32, i32
# BB#0:                                 # %if.end142
	i32.const	$push0=, 0
	i32.const	$push72=, 0
	i32.load	$push1=, myrnd.s($pop72)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push71=, $pop3, $pop4
	tee_local	$push70=, $1=, $pop71
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop70, $pop5
	i32.store8	$discard=, sC($pop0):p2align=2, $pop6
	i32.const	$push69=, 0
	i32.const	$push68=, 1103515245
	i32.mul 	$push7=, $1, $pop68
	i32.const	$push67=, 12345
	i32.add 	$push66=, $pop7, $pop67
	tee_local	$push65=, $1=, $pop66
	i32.const	$push64=, 16
	i32.shr_u	$push8=, $pop65, $pop64
	i32.store8	$discard=, sC+1($pop69), $pop8
	i32.const	$push63=, 0
	i32.const	$push62=, 1103515245
	i32.mul 	$push9=, $1, $pop62
	i32.const	$push61=, 12345
	i32.add 	$push60=, $pop9, $pop61
	tee_local	$push59=, $1=, $pop60
	i32.const	$push58=, 16
	i32.shr_u	$push10=, $pop59, $pop58
	i32.store8	$discard=, sC+2($pop63):p2align=1, $pop10
	i32.const	$push57=, 0
	i32.const	$push56=, 1103515245
	i32.mul 	$push11=, $1, $pop56
	i32.const	$push55=, 12345
	i32.add 	$push54=, $pop11, $pop55
	tee_local	$push53=, $1=, $pop54
	i32.const	$push52=, 16
	i32.shr_u	$push12=, $pop53, $pop52
	i32.store8	$discard=, sC+3($pop57), $pop12
	i32.const	$push51=, 0
	i32.const	$push50=, 1103515245
	i32.mul 	$push13=, $1, $pop50
	i32.const	$push49=, 12345
	i32.add 	$push48=, $pop13, $pop49
	tee_local	$push47=, $1=, $pop48
	i32.const	$push46=, 16
	i32.shr_u	$push14=, $pop47, $pop46
	i32.store8	$discard=, sC+4($pop51):p2align=2, $pop14
	i32.const	$push45=, 0
	i32.const	$push44=, 1103515245
	i32.mul 	$push15=, $1, $pop44
	i32.const	$push43=, 12345
	i32.add 	$push42=, $pop15, $pop43
	tee_local	$push41=, $1=, $pop42
	i32.const	$push40=, 16
	i32.shr_u	$push16=, $pop41, $pop40
	i32.store8	$discard=, sC+5($pop45), $pop16
	i32.const	$push39=, 0
	i32.load16_u	$0=, sC+4($pop39):p2align=2
	i32.const	$push38=, 0
	i32.const	$push37=, 0
	i32.const	$push17=, -341751747
	i32.mul 	$push18=, $1, $pop17
	i32.const	$push19=, 229283573
	i32.add 	$push36=, $pop18, $pop19
	tee_local	$push35=, $1=, $pop36
	i32.const	$push34=, 1103515245
	i32.mul 	$push21=, $pop35, $pop34
	i32.const	$push33=, 12345
	i32.add 	$push22=, $pop21, $pop33
	i32.store	$push23=, myrnd.s($pop37), $pop22
	i32.const	$push32=, 16
	i32.shr_u	$push24=, $pop23, $pop32
	i32.const	$push31=, 16
	i32.shr_u	$push20=, $1, $pop31
	i32.add 	$push27=, $pop24, $pop20
	i32.const	$push28=, 5
	i32.shl 	$push29=, $pop27, $pop28
	i32.const	$push25=, 31
	i32.and 	$push26=, $0, $pop25
	i32.or  	$push30=, $pop29, $pop26
	i32.store16	$discard=, sC+4($pop38):p2align=2, $pop30
	return
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
	i32.store8	$discard=, sD($pop0):p2align=3, $pop6
	i32.const	$push91=, 0
	i32.const	$push90=, 1103515245
	i32.mul 	$push7=, $0, $pop90
	i32.const	$push89=, 12345
	i32.add 	$push88=, $pop7, $pop89
	tee_local	$push87=, $0=, $pop88
	i32.const	$push86=, 16
	i32.shr_u	$push8=, $pop87, $pop86
	i32.store8	$discard=, sD+1($pop91), $pop8
	i32.const	$push85=, 0
	i32.const	$push84=, 1103515245
	i32.mul 	$push9=, $0, $pop84
	i32.const	$push83=, 12345
	i32.add 	$push82=, $pop9, $pop83
	tee_local	$push81=, $0=, $pop82
	i32.const	$push80=, 16
	i32.shr_u	$push10=, $pop81, $pop80
	i32.store8	$discard=, sD+2($pop85):p2align=1, $pop10
	i32.const	$push79=, 0
	i32.const	$push78=, 1103515245
	i32.mul 	$push11=, $0, $pop78
	i32.const	$push77=, 12345
	i32.add 	$push76=, $pop11, $pop77
	tee_local	$push75=, $0=, $pop76
	i32.const	$push74=, 16
	i32.shr_u	$push12=, $pop75, $pop74
	i32.store8	$discard=, sD+3($pop79), $pop12
	i32.const	$push73=, 0
	i32.const	$push72=, 1103515245
	i32.mul 	$push13=, $0, $pop72
	i32.const	$push71=, 12345
	i32.add 	$push70=, $pop13, $pop71
	tee_local	$push69=, $0=, $pop70
	i32.const	$push68=, 16
	i32.shr_u	$push14=, $pop69, $pop68
	i32.store8	$discard=, sD+4($pop73):p2align=2, $pop14
	i32.const	$push67=, 0
	i32.const	$push66=, 1103515245
	i32.mul 	$push15=, $0, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push64=, $pop15, $pop65
	tee_local	$push63=, $0=, $pop64
	i32.const	$push62=, 16
	i32.shr_u	$push16=, $pop63, $pop62
	i32.store8	$discard=, sD+5($pop67), $pop16
	i32.const	$push61=, 0
	i32.const	$push60=, 1103515245
	i32.mul 	$push17=, $0, $pop60
	i32.const	$push59=, 12345
	i32.add 	$push58=, $pop17, $pop59
	tee_local	$push57=, $0=, $pop58
	i32.const	$push56=, 16
	i32.shr_u	$push18=, $pop57, $pop56
	i32.store8	$discard=, sD+6($pop61):p2align=1, $pop18
	i32.const	$push55=, 0
	i32.const	$push54=, 1103515245
	i32.mul 	$push19=, $0, $pop54
	i32.const	$push53=, 12345
	i32.add 	$push52=, $pop19, $pop53
	tee_local	$push51=, $0=, $pop52
	i32.const	$push50=, 16
	i32.shr_u	$push20=, $pop51, $pop50
	i32.store8	$discard=, sD+7($pop55), $pop20
	i32.const	$push49=, 0
	i32.const	$push48=, 0
	i32.const	$push22=, -341751747
	i32.mul 	$push23=, $0, $pop22
	i32.const	$push24=, 229283573
	i32.add 	$push47=, $pop23, $pop24
	tee_local	$push46=, $0=, $pop47
	i32.const	$push45=, 1103515245
	i32.mul 	$push28=, $pop46, $pop45
	i32.const	$push44=, 12345
	i32.add 	$push29=, $pop28, $pop44
	i32.store	$push30=, myrnd.s($pop48), $pop29
	i32.const	$push43=, 16
	i32.shr_u	$push31=, $pop30, $pop43
	i32.const	$push26=, 2047
	i32.and 	$push32=, $pop31, $pop26
	i32.const	$push42=, 16
	i32.shr_u	$push25=, $0, $pop42
	i32.const	$push41=, 2047
	i32.and 	$push27=, $pop25, $pop41
	i32.add 	$push35=, $pop32, $pop27
	i64.extend_u/i32	$push36=, $pop35
	i64.const	$push37=, 35
	i64.shl 	$push38=, $pop36, $pop37
	i32.const	$push40=, 0
	i64.load	$push21=, sD($pop40)
	i64.const	$push33=, 34359738367
	i64.and 	$push34=, $pop21, $pop33
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
	i64.load	$2=, 0($pop3):p2align=0
	i64.load	$push0=, 0($1):p2align=0
	i64.store	$discard=, 0($0):p2align=0, $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i64.store	$discard=, 0($pop2):p2align=0, $2
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
	i32.store8	$discard=, sE($pop0):p2align=3, $pop6
	i32.const	$push155=, 0
	i32.const	$push154=, 1103515245
	i32.mul 	$push7=, $0, $pop154
	i32.const	$push153=, 12345
	i32.add 	$push152=, $pop7, $pop153
	tee_local	$push151=, $0=, $pop152
	i32.const	$push150=, 16
	i32.shr_u	$push8=, $pop151, $pop150
	i32.store8	$discard=, sE+1($pop155), $pop8
	i32.const	$push149=, 0
	i32.const	$push148=, 1103515245
	i32.mul 	$push9=, $0, $pop148
	i32.const	$push147=, 12345
	i32.add 	$push146=, $pop9, $pop147
	tee_local	$push145=, $0=, $pop146
	i32.const	$push144=, 16
	i32.shr_u	$push10=, $pop145, $pop144
	i32.store8	$discard=, sE+2($pop149):p2align=1, $pop10
	i32.const	$push143=, 0
	i32.const	$push142=, 1103515245
	i32.mul 	$push11=, $0, $pop142
	i32.const	$push141=, 12345
	i32.add 	$push140=, $pop11, $pop141
	tee_local	$push139=, $0=, $pop140
	i32.const	$push138=, 16
	i32.shr_u	$push12=, $pop139, $pop138
	i32.store8	$discard=, sE+3($pop143), $pop12
	i32.const	$push137=, 0
	i32.const	$push136=, 1103515245
	i32.mul 	$push13=, $0, $pop136
	i32.const	$push135=, 12345
	i32.add 	$push134=, $pop13, $pop135
	tee_local	$push133=, $0=, $pop134
	i32.const	$push132=, 16
	i32.shr_u	$push14=, $pop133, $pop132
	i32.store8	$discard=, sE+4($pop137):p2align=2, $pop14
	i32.const	$push131=, 0
	i32.const	$push130=, 1103515245
	i32.mul 	$push15=, $0, $pop130
	i32.const	$push129=, 12345
	i32.add 	$push128=, $pop15, $pop129
	tee_local	$push127=, $0=, $pop128
	i32.const	$push126=, 16
	i32.shr_u	$push16=, $pop127, $pop126
	i32.store8	$discard=, sE+5($pop131), $pop16
	i32.const	$push125=, 0
	i32.const	$push124=, 1103515245
	i32.mul 	$push17=, $0, $pop124
	i32.const	$push123=, 12345
	i32.add 	$push122=, $pop17, $pop123
	tee_local	$push121=, $0=, $pop122
	i32.const	$push120=, 16
	i32.shr_u	$push18=, $pop121, $pop120
	i32.store8	$discard=, sE+6($pop125):p2align=1, $pop18
	i32.const	$push119=, 0
	i32.const	$push118=, 1103515245
	i32.mul 	$push19=, $0, $pop118
	i32.const	$push117=, 12345
	i32.add 	$push116=, $pop19, $pop117
	tee_local	$push115=, $0=, $pop116
	i32.const	$push114=, 16
	i32.shr_u	$push20=, $pop115, $pop114
	i32.store8	$discard=, sE+7($pop119), $pop20
	i32.const	$push113=, 0
	i32.const	$push112=, 1103515245
	i32.mul 	$push21=, $0, $pop112
	i32.const	$push111=, 12345
	i32.add 	$push110=, $pop21, $pop111
	tee_local	$push109=, $0=, $pop110
	i32.const	$push108=, 16
	i32.shr_u	$push22=, $pop109, $pop108
	i32.store8	$discard=, sE+8($pop113):p2align=3, $pop22
	i32.const	$push107=, 0
	i32.const	$push106=, 1103515245
	i32.mul 	$push23=, $0, $pop106
	i32.const	$push105=, 12345
	i32.add 	$push104=, $pop23, $pop105
	tee_local	$push103=, $0=, $pop104
	i32.const	$push102=, 16
	i32.shr_u	$push24=, $pop103, $pop102
	i32.store8	$discard=, sE+9($pop107), $pop24
	i32.const	$push101=, 0
	i32.const	$push100=, 1103515245
	i32.mul 	$push25=, $0, $pop100
	i32.const	$push99=, 12345
	i32.add 	$push98=, $pop25, $pop99
	tee_local	$push97=, $0=, $pop98
	i32.const	$push96=, 16
	i32.shr_u	$push26=, $pop97, $pop96
	i32.store8	$discard=, sE+10($pop101):p2align=1, $pop26
	i32.const	$push95=, 0
	i32.const	$push94=, 1103515245
	i32.mul 	$push27=, $0, $pop94
	i32.const	$push93=, 12345
	i32.add 	$push92=, $pop27, $pop93
	tee_local	$push91=, $0=, $pop92
	i32.const	$push90=, 16
	i32.shr_u	$push28=, $pop91, $pop90
	i32.store8	$discard=, sE+11($pop95), $pop28
	i32.const	$push89=, 0
	i32.const	$push88=, 1103515245
	i32.mul 	$push29=, $0, $pop88
	i32.const	$push87=, 12345
	i32.add 	$push86=, $pop29, $pop87
	tee_local	$push85=, $0=, $pop86
	i32.const	$push84=, 16
	i32.shr_u	$push30=, $pop85, $pop84
	i32.store8	$discard=, sE+12($pop89):p2align=2, $pop30
	i32.const	$push83=, 0
	i32.const	$push82=, 1103515245
	i32.mul 	$push31=, $0, $pop82
	i32.const	$push81=, 12345
	i32.add 	$push80=, $pop31, $pop81
	tee_local	$push79=, $0=, $pop80
	i32.const	$push78=, 16
	i32.shr_u	$push32=, $pop79, $pop78
	i32.store8	$discard=, sE+13($pop83), $pop32
	i32.const	$push77=, 0
	i32.const	$push76=, 1103515245
	i32.mul 	$push33=, $0, $pop76
	i32.const	$push75=, 12345
	i32.add 	$push74=, $pop33, $pop75
	tee_local	$push73=, $0=, $pop74
	i32.const	$push72=, 16
	i32.shr_u	$push34=, $pop73, $pop72
	i32.store8	$discard=, sE+14($pop77):p2align=1, $pop34
	i32.const	$push71=, 0
	i32.const	$push70=, 1103515245
	i32.mul 	$push35=, $0, $pop70
	i32.const	$push69=, 12345
	i32.add 	$push68=, $pop35, $pop69
	tee_local	$push67=, $0=, $pop68
	i32.const	$push66=, 16
	i32.shr_u	$push36=, $pop67, $pop66
	i32.store8	$discard=, sE+15($pop71), $pop36
	i32.const	$push65=, 0
	i32.const	$push64=, 0
	i32.const	$push38=, -341751747
	i32.mul 	$push39=, $0, $pop38
	i32.const	$push40=, 229283573
	i32.add 	$push63=, $pop39, $pop40
	tee_local	$push62=, $0=, $pop63
	i32.const	$push61=, 1103515245
	i32.mul 	$push44=, $pop62, $pop61
	i32.const	$push60=, 12345
	i32.add 	$push45=, $pop44, $pop60
	i32.store	$push46=, myrnd.s($pop64), $pop45
	i32.const	$push59=, 16
	i32.shr_u	$push47=, $pop46, $pop59
	i32.const	$push42=, 2047
	i32.and 	$push48=, $pop47, $pop42
	i32.const	$push58=, 16
	i32.shr_u	$push41=, $0, $pop58
	i32.const	$push57=, 2047
	i32.and 	$push43=, $pop41, $pop57
	i32.add 	$push51=, $pop48, $pop43
	i64.extend_u/i32	$push52=, $pop51
	i64.const	$push53=, 35
	i64.shl 	$push54=, $pop52, $pop53
	i32.const	$push56=, 0
	i64.load	$push37=, sE+8($pop56)
	i64.const	$push49=, 34359738367
	i64.and 	$push50=, $pop37, $pop49
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
	i64.load	$2=, 0($pop3):p2align=0
	i64.load	$push0=, 0($1):p2align=0
	i64.store	$discard=, 0($0):p2align=0, $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i64.store	$discard=, 0($pop2):p2align=0, $2
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
	i32.store8	$discard=, sF($pop0):p2align=3, $pop6
	i32.const	$push155=, 0
	i32.const	$push154=, 1103515245
	i32.mul 	$push7=, $0, $pop154
	i32.const	$push153=, 12345
	i32.add 	$push152=, $pop7, $pop153
	tee_local	$push151=, $0=, $pop152
	i32.const	$push150=, 16
	i32.shr_u	$push8=, $pop151, $pop150
	i32.store8	$discard=, sF+1($pop155), $pop8
	i32.const	$push149=, 0
	i32.const	$push148=, 1103515245
	i32.mul 	$push9=, $0, $pop148
	i32.const	$push147=, 12345
	i32.add 	$push146=, $pop9, $pop147
	tee_local	$push145=, $0=, $pop146
	i32.const	$push144=, 16
	i32.shr_u	$push10=, $pop145, $pop144
	i32.store8	$discard=, sF+2($pop149):p2align=1, $pop10
	i32.const	$push143=, 0
	i32.const	$push142=, 1103515245
	i32.mul 	$push11=, $0, $pop142
	i32.const	$push141=, 12345
	i32.add 	$push140=, $pop11, $pop141
	tee_local	$push139=, $0=, $pop140
	i32.const	$push138=, 16
	i32.shr_u	$push12=, $pop139, $pop138
	i32.store8	$discard=, sF+3($pop143), $pop12
	i32.const	$push137=, 0
	i32.const	$push136=, 1103515245
	i32.mul 	$push13=, $0, $pop136
	i32.const	$push135=, 12345
	i32.add 	$push134=, $pop13, $pop135
	tee_local	$push133=, $0=, $pop134
	i32.const	$push132=, 16
	i32.shr_u	$push14=, $pop133, $pop132
	i32.store8	$discard=, sF+4($pop137):p2align=2, $pop14
	i32.const	$push131=, 0
	i32.const	$push130=, 1103515245
	i32.mul 	$push15=, $0, $pop130
	i32.const	$push129=, 12345
	i32.add 	$push128=, $pop15, $pop129
	tee_local	$push127=, $0=, $pop128
	i32.const	$push126=, 16
	i32.shr_u	$push16=, $pop127, $pop126
	i32.store8	$discard=, sF+5($pop131), $pop16
	i32.const	$push125=, 0
	i32.const	$push124=, 1103515245
	i32.mul 	$push17=, $0, $pop124
	i32.const	$push123=, 12345
	i32.add 	$push122=, $pop17, $pop123
	tee_local	$push121=, $0=, $pop122
	i32.const	$push120=, 16
	i32.shr_u	$push18=, $pop121, $pop120
	i32.store8	$discard=, sF+6($pop125):p2align=1, $pop18
	i32.const	$push119=, 0
	i32.const	$push118=, 1103515245
	i32.mul 	$push19=, $0, $pop118
	i32.const	$push117=, 12345
	i32.add 	$push116=, $pop19, $pop117
	tee_local	$push115=, $0=, $pop116
	i32.const	$push114=, 16
	i32.shr_u	$push20=, $pop115, $pop114
	i32.store8	$discard=, sF+7($pop119), $pop20
	i32.const	$push113=, 0
	i32.const	$push112=, 1103515245
	i32.mul 	$push21=, $0, $pop112
	i32.const	$push111=, 12345
	i32.add 	$push110=, $pop21, $pop111
	tee_local	$push109=, $0=, $pop110
	i32.const	$push108=, 16
	i32.shr_u	$push22=, $pop109, $pop108
	i32.store8	$discard=, sF+8($pop113):p2align=3, $pop22
	i32.const	$push107=, 0
	i32.const	$push106=, 1103515245
	i32.mul 	$push23=, $0, $pop106
	i32.const	$push105=, 12345
	i32.add 	$push104=, $pop23, $pop105
	tee_local	$push103=, $0=, $pop104
	i32.const	$push102=, 16
	i32.shr_u	$push24=, $pop103, $pop102
	i32.store8	$discard=, sF+9($pop107), $pop24
	i32.const	$push101=, 0
	i32.const	$push100=, 1103515245
	i32.mul 	$push25=, $0, $pop100
	i32.const	$push99=, 12345
	i32.add 	$push98=, $pop25, $pop99
	tee_local	$push97=, $0=, $pop98
	i32.const	$push96=, 16
	i32.shr_u	$push26=, $pop97, $pop96
	i32.store8	$discard=, sF+10($pop101):p2align=1, $pop26
	i32.const	$push95=, 0
	i32.const	$push94=, 1103515245
	i32.mul 	$push27=, $0, $pop94
	i32.const	$push93=, 12345
	i32.add 	$push92=, $pop27, $pop93
	tee_local	$push91=, $0=, $pop92
	i32.const	$push90=, 16
	i32.shr_u	$push28=, $pop91, $pop90
	i32.store8	$discard=, sF+11($pop95), $pop28
	i32.const	$push89=, 0
	i32.const	$push88=, 1103515245
	i32.mul 	$push29=, $0, $pop88
	i32.const	$push87=, 12345
	i32.add 	$push86=, $pop29, $pop87
	tee_local	$push85=, $0=, $pop86
	i32.const	$push84=, 16
	i32.shr_u	$push30=, $pop85, $pop84
	i32.store8	$discard=, sF+12($pop89):p2align=2, $pop30
	i32.const	$push83=, 0
	i32.const	$push82=, 1103515245
	i32.mul 	$push31=, $0, $pop82
	i32.const	$push81=, 12345
	i32.add 	$push80=, $pop31, $pop81
	tee_local	$push79=, $0=, $pop80
	i32.const	$push78=, 16
	i32.shr_u	$push32=, $pop79, $pop78
	i32.store8	$discard=, sF+13($pop83), $pop32
	i32.const	$push77=, 0
	i32.const	$push76=, 1103515245
	i32.mul 	$push33=, $0, $pop76
	i32.const	$push75=, 12345
	i32.add 	$push74=, $pop33, $pop75
	tee_local	$push73=, $0=, $pop74
	i32.const	$push72=, 16
	i32.shr_u	$push34=, $pop73, $pop72
	i32.store8	$discard=, sF+14($pop77):p2align=1, $pop34
	i32.const	$push71=, 0
	i32.const	$push70=, 1103515245
	i32.mul 	$push35=, $0, $pop70
	i32.const	$push69=, 12345
	i32.add 	$push68=, $pop35, $pop69
	tee_local	$push67=, $0=, $pop68
	i32.const	$push66=, 16
	i32.shr_u	$push36=, $pop67, $pop66
	i32.store8	$discard=, sF+15($pop71), $pop36
	i32.const	$push65=, 0
	i32.const	$push64=, 0
	i32.const	$push38=, -341751747
	i32.mul 	$push39=, $0, $pop38
	i32.const	$push40=, 229283573
	i32.add 	$push63=, $pop39, $pop40
	tee_local	$push62=, $0=, $pop63
	i32.const	$push61=, 1103515245
	i32.mul 	$push44=, $pop62, $pop61
	i32.const	$push60=, 12345
	i32.add 	$push45=, $pop44, $pop60
	i32.store	$push46=, myrnd.s($pop64), $pop45
	i32.const	$push59=, 16
	i32.shr_u	$push47=, $pop46, $pop59
	i32.const	$push42=, 2047
	i32.and 	$push48=, $pop47, $pop42
	i32.const	$push58=, 16
	i32.shr_u	$push41=, $0, $pop58
	i32.const	$push57=, 2047
	i32.and 	$push43=, $pop41, $pop57
	i32.add 	$push51=, $pop48, $pop43
	i64.extend_u/i32	$push52=, $pop51
	i64.const	$push53=, 35
	i64.shl 	$push54=, $pop52, $pop53
	i32.const	$push56=, 0
	i64.load	$push37=, sF($pop56)
	i64.const	$push49=, 34359738367
	i64.and 	$push50=, $pop37, $pop49
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.add 	$push3=, $1, $pop1
	i32.load8_u	$2=, 0($pop3)
	i64.load	$push0=, 0($1):p2align=0
	i64.store	$discard=, 0($0):p2align=0, $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i32.store8	$discard=, 0($pop2), $2
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
	i32.load8_u	$push1=, sG($pop0)
	i32.const	$push2=, 2
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 63
	i32.and 	$push6=, $pop4, $pop5
	return  	$pop6
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
	i32.load8_u	$push1=, sG($pop0)
	i32.const	$push2=, 2
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push14=, 0
	i32.load8_u	$push13=, sG($pop14)
	tee_local	$push12=, $1=, $pop13
	i32.const	$push1=, 2
	i32.shr_u	$push2=, $pop12, $pop1
	i32.add 	$push11=, $pop2, $0
	tee_local	$push10=, $0=, $pop11
	i32.const	$push9=, 2
	i32.shl 	$push3=, $pop10, $pop9
	i32.const	$push4=, 3
	i32.and 	$push5=, $1, $pop4
	i32.or  	$push6=, $pop3, $pop5
	i32.store8	$discard=, sG($pop0), $pop6
	i32.const	$push7=, 63
	i32.and 	$push8=, $0, $pop7
	return  	$pop8
	.endfunc
.Lfunc_end41:
	.size	fn3G, .Lfunc_end41-fn3G

	.section	.text.testG,"ax",@progbits
	.hidden	testG
	.globl	testG
	.type	testG,@function
testG:                                  # @testG
	.local  	i32, i32
# BB#0:                                 # %if.end155
	i32.const	$push0=, 0
	i32.const	$push94=, 0
	i32.load	$push1=, myrnd.s($pop94)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push93=, $pop3, $pop4
	tee_local	$push92=, $1=, $pop93
	i32.const	$push91=, 1103515245
	i32.mul 	$push7=, $pop92, $pop91
	i32.const	$push90=, 12345
	i32.add 	$push89=, $pop7, $pop90
	tee_local	$push88=, $0=, $pop89
	i32.const	$push5=, 16
	i32.shr_u	$push8=, $pop88, $pop5
	i32.store8	$discard=, sG+1($pop0), $pop8
	i32.const	$push87=, 0
	i32.const	$push86=, 1103515245
	i32.mul 	$push9=, $0, $pop86
	i32.const	$push85=, 12345
	i32.add 	$push84=, $pop9, $pop85
	tee_local	$push83=, $0=, $pop84
	i32.const	$push82=, 16
	i32.shr_u	$push10=, $pop83, $pop82
	i32.store8	$discard=, sG+2($pop87), $pop10
	i32.const	$push81=, 0
	i32.const	$push80=, 1103515245
	i32.mul 	$push11=, $0, $pop80
	i32.const	$push79=, 12345
	i32.add 	$push78=, $pop11, $pop79
	tee_local	$push77=, $0=, $pop78
	i32.const	$push76=, 16
	i32.shr_u	$push12=, $pop77, $pop76
	i32.store8	$discard=, sG+3($pop81), $pop12
	i32.const	$push75=, 0
	i32.const	$push74=, 1103515245
	i32.mul 	$push13=, $0, $pop74
	i32.const	$push73=, 12345
	i32.add 	$push72=, $pop13, $pop73
	tee_local	$push71=, $0=, $pop72
	i32.const	$push70=, 16
	i32.shr_u	$push14=, $pop71, $pop70
	i32.store8	$discard=, sG+4($pop75), $pop14
	i32.const	$push69=, 0
	i32.const	$push68=, 1103515245
	i32.mul 	$push15=, $0, $pop68
	i32.const	$push67=, 12345
	i32.add 	$push66=, $pop15, $pop67
	tee_local	$push65=, $0=, $pop66
	i32.const	$push64=, 16
	i32.shr_u	$push16=, $pop65, $pop64
	i32.store8	$discard=, sG+5($pop69), $pop16
	i32.const	$push63=, 0
	i32.const	$push62=, 1103515245
	i32.mul 	$push17=, $0, $pop62
	i32.const	$push61=, 12345
	i32.add 	$push60=, $pop17, $pop61
	tee_local	$push59=, $0=, $pop60
	i32.const	$push58=, 16
	i32.shr_u	$push18=, $pop59, $pop58
	i32.store8	$discard=, sG+6($pop63), $pop18
	i32.const	$push57=, 0
	i32.const	$push56=, 1103515245
	i32.mul 	$push19=, $0, $pop56
	i32.const	$push55=, 12345
	i32.add 	$push54=, $pop19, $pop55
	tee_local	$push53=, $0=, $pop54
	i32.const	$push52=, 16
	i32.shr_u	$push20=, $pop53, $pop52
	i32.store8	$discard=, sG+7($pop57), $pop20
	i32.const	$push51=, 0
	i32.const	$push50=, 1103515245
	i32.mul 	$push21=, $0, $pop50
	i32.const	$push49=, 12345
	i32.add 	$push48=, $pop21, $pop49
	tee_local	$push47=, $0=, $pop48
	i32.const	$push46=, 16
	i32.shr_u	$push22=, $pop47, $pop46
	i32.store8	$discard=, sG+8($pop51), $pop22
	i32.const	$push45=, 0
	i32.const	$push44=, 0
	i32.const	$push23=, -341751747
	i32.mul 	$push24=, $0, $pop23
	i32.const	$push25=, 229283573
	i32.add 	$push43=, $pop24, $pop25
	tee_local	$push42=, $0=, $pop43
	i32.const	$push41=, 1103515245
	i32.mul 	$push27=, $pop42, $pop41
	i32.const	$push40=, 12345
	i32.add 	$push28=, $pop27, $pop40
	i32.store	$push29=, myrnd.s($pop44), $pop28
	i32.const	$push39=, 16
	i32.shr_u	$push30=, $pop29, $pop39
	i32.const	$push38=, 16
	i32.shr_u	$push26=, $0, $pop38
	i32.add 	$push33=, $pop30, $pop26
	i32.const	$push34=, 2
	i32.shl 	$push35=, $pop33, $pop34
	i32.const	$push37=, 16
	i32.shr_u	$push6=, $1, $pop37
	i32.const	$push31=, 3
	i32.and 	$push32=, $pop6, $pop31
	i32.or  	$push36=, $pop35, $pop32
	i32.store8	$discard=, sG($pop45), $pop36
	return
	.endfunc
.Lfunc_end42:
	.size	testG, .Lfunc_end42-testG

	.section	.text.retmeH,"ax",@progbits
	.hidden	retmeH
	.globl	retmeH
	.type	retmeH,@function
retmeH:                                 # @retmeH
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.add 	$push3=, $1, $pop1
	i32.load16_u	$2=, 0($pop3):p2align=0
	i64.load	$push0=, 0($1):p2align=0
	i64.store	$discard=, 0($0):p2align=0, $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i32.store16	$discard=, 0($pop2):p2align=0, $2
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
	i32.load8_u	$push1=, sH+1($pop0)
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 255
	i32.and 	$push4=, $pop2, $pop3
	return  	$pop4
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
	return  	$pop6
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
	return  	$pop1
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
	i32.add 	$push2=, $pop1, $0
	i32.store8	$push3=, sH+1($pop0), $pop2
	i32.const	$push4=, 255
	i32.and 	$push5=, $pop3, $pop4
	return  	$pop5
	.endfunc
.Lfunc_end47:
	.size	fn3H, .Lfunc_end47-fn3H

	.section	.text.testH,"ax",@progbits
	.hidden	testH
	.globl	testH
	.type	testH,@function
testH:                                  # @testH
	.local  	i32
# BB#0:                                 # %if.end136
	i32.const	$push0=, 0
	i32.const	$push103=, 0
	i32.load	$push1=, myrnd.s($pop103)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push102=, $pop3, $pop4
	tee_local	$push101=, $0=, $pop102
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop101, $pop5
	i32.store8	$discard=, sH($pop0):p2align=1, $pop6
	i32.const	$push100=, 0
	i32.const	$push99=, 1103515245
	i32.mul 	$push7=, $0, $pop99
	i32.const	$push98=, 12345
	i32.add 	$push97=, $pop7, $pop98
	tee_local	$push96=, $0=, $pop97
	i32.const	$push95=, 16
	i32.shr_u	$push8=, $pop96, $pop95
	i32.store8	$discard=, sH+1($pop100), $pop8
	i32.const	$push94=, 0
	i32.const	$push93=, 1103515245
	i32.mul 	$push9=, $0, $pop93
	i32.const	$push92=, 12345
	i32.add 	$push91=, $pop9, $pop92
	tee_local	$push90=, $0=, $pop91
	i32.const	$push89=, 16
	i32.shr_u	$push10=, $pop90, $pop89
	i32.store8	$discard=, sH+2($pop94):p2align=1, $pop10
	i32.const	$push88=, 0
	i32.const	$push87=, 1103515245
	i32.mul 	$push11=, $0, $pop87
	i32.const	$push86=, 12345
	i32.add 	$push85=, $pop11, $pop86
	tee_local	$push84=, $0=, $pop85
	i32.const	$push83=, 16
	i32.shr_u	$push12=, $pop84, $pop83
	i32.store8	$discard=, sH+3($pop88), $pop12
	i32.const	$push82=, 0
	i32.const	$push81=, 1103515245
	i32.mul 	$push13=, $0, $pop81
	i32.const	$push80=, 12345
	i32.add 	$push79=, $pop13, $pop80
	tee_local	$push78=, $0=, $pop79
	i32.const	$push77=, 16
	i32.shr_u	$push14=, $pop78, $pop77
	i32.store8	$discard=, sH+4($pop82):p2align=1, $pop14
	i32.const	$push76=, 0
	i32.const	$push75=, 1103515245
	i32.mul 	$push15=, $0, $pop75
	i32.const	$push74=, 12345
	i32.add 	$push73=, $pop15, $pop74
	tee_local	$push72=, $0=, $pop73
	i32.const	$push71=, 16
	i32.shr_u	$push16=, $pop72, $pop71
	i32.store8	$discard=, sH+5($pop76), $pop16
	i32.const	$push70=, 0
	i32.const	$push69=, 1103515245
	i32.mul 	$push17=, $0, $pop69
	i32.const	$push68=, 12345
	i32.add 	$push67=, $pop17, $pop68
	tee_local	$push66=, $0=, $pop67
	i32.const	$push65=, 16
	i32.shr_u	$push18=, $pop66, $pop65
	i32.store8	$discard=, sH+6($pop70):p2align=1, $pop18
	i32.const	$push64=, 0
	i32.const	$push63=, 1103515245
	i32.mul 	$push19=, $0, $pop63
	i32.const	$push62=, 12345
	i32.add 	$push61=, $pop19, $pop62
	tee_local	$push60=, $0=, $pop61
	i32.const	$push59=, 16
	i32.shr_u	$push20=, $pop60, $pop59
	i32.store8	$discard=, sH+7($pop64), $pop20
	i32.const	$push58=, 0
	i32.const	$push57=, 1103515245
	i32.mul 	$push21=, $0, $pop57
	i32.const	$push56=, 12345
	i32.add 	$push55=, $pop21, $pop56
	tee_local	$push54=, $0=, $pop55
	i32.const	$push53=, 16
	i32.shr_u	$push22=, $pop54, $pop53
	i32.store8	$discard=, sH+8($pop58):p2align=1, $pop22
	i32.const	$push52=, 0
	i32.const	$push51=, 1103515245
	i32.mul 	$push23=, $0, $pop51
	i32.const	$push50=, 12345
	i32.add 	$push49=, $pop23, $pop50
	tee_local	$push48=, $0=, $pop49
	i32.const	$push47=, 16
	i32.shr_u	$push24=, $pop48, $pop47
	i32.store8	$discard=, sH+9($pop52), $pop24
	i32.const	$push46=, 0
	i32.const	$push45=, 0
	i32.const	$push26=, -341751747
	i32.mul 	$push27=, $0, $pop26
	i32.const	$push28=, 229283573
	i32.add 	$push44=, $pop27, $pop28
	tee_local	$push43=, $0=, $pop44
	i32.const	$push42=, 1103515245
	i32.mul 	$push30=, $pop43, $pop42
	i32.const	$push41=, 12345
	i32.add 	$push31=, $pop30, $pop41
	i32.store	$push32=, myrnd.s($pop45), $pop31
	i32.const	$push40=, 16
	i32.shr_u	$push33=, $pop32, $pop40
	i32.const	$push39=, 16
	i32.shr_u	$push29=, $0, $pop39
	i32.add 	$push34=, $pop33, $pop29
	i32.const	$push35=, 8
	i32.shl 	$push36=, $pop34, $pop35
	i32.const	$push38=, 0
	i32.load8_u	$push25=, sH($pop38):p2align=1
	i32.or  	$push37=, $pop36, $pop25
	i32.store16	$discard=, sH($pop46), $pop37
	return
	.endfunc
.Lfunc_end48:
	.size	testH, .Lfunc_end48-testH

	.section	.text.retmeI,"ax",@progbits
	.hidden	retmeI
	.globl	retmeI
	.type	retmeI,@function
retmeI:                                 # @retmeI
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.add 	$push3=, $1, $pop1
	i32.load8_u	$2=, 0($pop3)
	i64.load	$push0=, 0($1):p2align=0
	i64.store	$discard=, 0($0):p2align=0, $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i32.store8	$discard=, 0($pop2), $2
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
	i32.load8_u	$push1=, sI($pop0)
	i32.const	$push2=, 7
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 1
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
	i32.load8_u	$push1=, sI($pop0)
	i32.const	$push2=, 7
	i32.shr_u	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop3, $0
	i32.const	$push5=, 1
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
	i32.load8_u	$push1=, sI($pop0)
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
	i32.load8_u	$push13=, sI($pop14)
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
	i32.store8	$discard=, sI($pop0), $pop6
	i32.const	$push7=, 1
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
# BB#0:                                 # %if.end155
	i32.const	$push0=, 0
	i32.const	$push94=, 0
	i32.load	$push1=, myrnd.s($pop94)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push93=, $pop3, $pop4
	tee_local	$push92=, $1=, $pop93
	i32.const	$push91=, 1103515245
	i32.mul 	$push7=, $pop92, $pop91
	i32.const	$push90=, 12345
	i32.add 	$push89=, $pop7, $pop90
	tee_local	$push88=, $0=, $pop89
	i32.const	$push5=, 16
	i32.shr_u	$push8=, $pop88, $pop5
	i32.store8	$discard=, sI+1($pop0), $pop8
	i32.const	$push87=, 0
	i32.const	$push86=, 1103515245
	i32.mul 	$push9=, $0, $pop86
	i32.const	$push85=, 12345
	i32.add 	$push84=, $pop9, $pop85
	tee_local	$push83=, $0=, $pop84
	i32.const	$push82=, 16
	i32.shr_u	$push10=, $pop83, $pop82
	i32.store8	$discard=, sI+2($pop87), $pop10
	i32.const	$push81=, 0
	i32.const	$push80=, 1103515245
	i32.mul 	$push11=, $0, $pop80
	i32.const	$push79=, 12345
	i32.add 	$push78=, $pop11, $pop79
	tee_local	$push77=, $0=, $pop78
	i32.const	$push76=, 16
	i32.shr_u	$push12=, $pop77, $pop76
	i32.store8	$discard=, sI+3($pop81), $pop12
	i32.const	$push75=, 0
	i32.const	$push74=, 1103515245
	i32.mul 	$push13=, $0, $pop74
	i32.const	$push73=, 12345
	i32.add 	$push72=, $pop13, $pop73
	tee_local	$push71=, $0=, $pop72
	i32.const	$push70=, 16
	i32.shr_u	$push14=, $pop71, $pop70
	i32.store8	$discard=, sI+4($pop75), $pop14
	i32.const	$push69=, 0
	i32.const	$push68=, 1103515245
	i32.mul 	$push15=, $0, $pop68
	i32.const	$push67=, 12345
	i32.add 	$push66=, $pop15, $pop67
	tee_local	$push65=, $0=, $pop66
	i32.const	$push64=, 16
	i32.shr_u	$push16=, $pop65, $pop64
	i32.store8	$discard=, sI+5($pop69), $pop16
	i32.const	$push63=, 0
	i32.const	$push62=, 1103515245
	i32.mul 	$push17=, $0, $pop62
	i32.const	$push61=, 12345
	i32.add 	$push60=, $pop17, $pop61
	tee_local	$push59=, $0=, $pop60
	i32.const	$push58=, 16
	i32.shr_u	$push18=, $pop59, $pop58
	i32.store8	$discard=, sI+6($pop63), $pop18
	i32.const	$push57=, 0
	i32.const	$push56=, 1103515245
	i32.mul 	$push19=, $0, $pop56
	i32.const	$push55=, 12345
	i32.add 	$push54=, $pop19, $pop55
	tee_local	$push53=, $0=, $pop54
	i32.const	$push52=, 16
	i32.shr_u	$push20=, $pop53, $pop52
	i32.store8	$discard=, sI+7($pop57), $pop20
	i32.const	$push51=, 0
	i32.const	$push50=, 1103515245
	i32.mul 	$push21=, $0, $pop50
	i32.const	$push49=, 12345
	i32.add 	$push48=, $pop21, $pop49
	tee_local	$push47=, $0=, $pop48
	i32.const	$push46=, 16
	i32.shr_u	$push22=, $pop47, $pop46
	i32.store8	$discard=, sI+8($pop51), $pop22
	i32.const	$push45=, 0
	i32.const	$push44=, 0
	i32.const	$push23=, -341751747
	i32.mul 	$push24=, $0, $pop23
	i32.const	$push25=, 229283573
	i32.add 	$push43=, $pop24, $pop25
	tee_local	$push42=, $0=, $pop43
	i32.const	$push41=, 1103515245
	i32.mul 	$push27=, $pop42, $pop41
	i32.const	$push40=, 12345
	i32.add 	$push28=, $pop27, $pop40
	i32.store	$push29=, myrnd.s($pop44), $pop28
	i32.const	$push39=, 16
	i32.shr_u	$push30=, $pop29, $pop39
	i32.const	$push38=, 16
	i32.shr_u	$push26=, $0, $pop38
	i32.add 	$push33=, $pop30, $pop26
	i32.const	$push34=, 7
	i32.shl 	$push35=, $pop33, $pop34
	i32.const	$push37=, 16
	i32.shr_u	$push6=, $1, $pop37
	i32.const	$push31=, 127
	i32.and 	$push32=, $pop6, $pop31
	i32.or  	$push36=, $pop35, $pop32
	i32.store8	$discard=, sI($pop45), $pop36
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
	i32.load	$push0=, 0($1):p2align=0
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
	i32.load16_u	$push13=, sJ($pop14):p2align=2
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
	i32.store16	$discard=, sJ($pop0):p2align=2, $pop6
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
	i32.const	$push79=, 0
	i32.const	$push78=, 0
	i32.load	$push1=, myrnd.s($pop78)
	i32.const	$push77=, 1103515245
	i32.mul 	$push2=, $pop1, $pop77
	i32.const	$push76=, 12345
	i32.add 	$push75=, $pop2, $pop76
	tee_local	$push74=, $0=, $pop75
	i32.const	$push73=, 16
	i32.shr_u	$push3=, $pop74, $pop73
	i32.store8	$discard=, sJ($pop79):p2align=2, $pop3
	i32.const	$push72=, 0
	i32.const	$push71=, 1103515245
	i32.mul 	$push4=, $0, $pop71
	i32.const	$push70=, 12345
	i32.add 	$push69=, $pop4, $pop70
	tee_local	$push68=, $0=, $pop69
	i32.const	$push67=, 16
	i32.shr_u	$push5=, $pop68, $pop67
	i32.store8	$discard=, sJ+1($pop72), $pop5
	i32.const	$push66=, 0
	i32.const	$push65=, 1103515245
	i32.mul 	$push6=, $0, $pop65
	i32.const	$push64=, 12345
	i32.add 	$push63=, $pop6, $pop64
	tee_local	$push62=, $0=, $pop63
	i32.const	$push61=, 16
	i32.shr_u	$push7=, $pop62, $pop61
	i32.store8	$discard=, sJ+2($pop66):p2align=1, $pop7
	i32.const	$push60=, 0
	i32.const	$push59=, 1103515245
	i32.mul 	$push8=, $0, $pop59
	i32.const	$push58=, 12345
	i32.add 	$push57=, $pop8, $pop58
	tee_local	$push56=, $0=, $pop57
	i32.const	$push55=, 16
	i32.shr_u	$push9=, $pop56, $pop55
	i32.store8	$discard=, sJ+3($pop60), $pop9
	i32.const	$push54=, 0
	i32.const	$push53=, 1103515245
	i32.mul 	$push11=, $0, $pop53
	i32.const	$push52=, 12345
	i32.add 	$push51=, $pop11, $pop52
	tee_local	$push50=, $3=, $pop51
	i32.const	$push49=, 16
	i32.shr_u	$push48=, $pop50, $pop49
	tee_local	$push47=, $2=, $pop48
	i32.const	$push46=, 9
	i32.shl 	$push13=, $pop47, $pop46
	i32.const	$push45=, 0
	i32.load16_u	$push10=, sJ($pop45):p2align=2
	i32.const	$push44=, 511
	i32.and 	$push14=, $pop10, $pop44
	i32.or  	$push15=, $pop13, $pop14
	i32.store16	$discard=, sJ($pop54):p2align=2, $pop15
	i32.const	$push43=, 0
	i32.load	$0=, sJ($pop43)
	block
	i32.const	$push42=, 0
	i32.const	$push41=, 1103515245
	i32.mul 	$push12=, $3, $pop41
	i32.const	$push40=, 12345
	i32.add 	$push0=, $pop12, $pop40
	i32.store	$push39=, myrnd.s($pop42), $pop0
	tee_local	$push38=, $1=, $pop39
	i32.const	$push37=, 16
	i32.shr_u	$push36=, $pop38, $pop37
	tee_local	$push35=, $3=, $pop36
	i32.add 	$push18=, $pop35, $2
	i32.const	$push34=, 9
	i32.shr_u	$push16=, $0, $pop34
	i32.add 	$push17=, $pop16, $3
	i32.xor 	$push19=, $pop18, $pop17
	i32.const	$push20=, 127
	i32.and 	$push21=, $pop19, $pop20
	br_if   	0, $pop21       # 0: down to label0
# BB#1:                                 # %if.end142
	i32.const	$push89=, 0
	i32.const	$push88=, 0
	i32.const	$push22=, -2139243339
	i32.mul 	$push23=, $1, $pop22
	i32.const	$push24=, -1492899873
	i32.add 	$push87=, $pop23, $pop24
	tee_local	$push86=, $3=, $pop87
	i32.const	$push85=, 1103515245
	i32.mul 	$push26=, $pop86, $pop85
	i32.const	$push84=, 12345
	i32.add 	$push27=, $pop26, $pop84
	i32.store	$push28=, myrnd.s($pop88), $pop27
	i32.const	$push83=, 16
	i32.shr_u	$push29=, $pop28, $pop83
	i32.const	$push82=, 16
	i32.shr_u	$push25=, $3, $pop82
	i32.add 	$push31=, $pop29, $pop25
	i32.const	$push81=, 9
	i32.shl 	$push32=, $pop31, $pop81
	i32.const	$push80=, 511
	i32.and 	$push30=, $0, $pop80
	i32.or  	$push33=, $pop32, $pop30
	i32.store16	$discard=, sJ($pop89):p2align=2, $pop33
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
	i32.const	$push0=, 0
	i32.const	$push56=, 0
	i32.load	$push1=, myrnd.s($pop56)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push55=, $pop3, $pop4
	tee_local	$push54=, $1=, $pop55
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop54, $pop5
	i32.store8	$discard=, sK($pop0):p2align=2, $pop6
	i32.const	$push53=, 0
	i32.const	$push52=, 1103515245
	i32.mul 	$push7=, $1, $pop52
	i32.const	$push51=, 12345
	i32.add 	$push50=, $pop7, $pop51
	tee_local	$push49=, $1=, $pop50
	i32.const	$push48=, 16
	i32.shr_u	$push8=, $pop49, $pop48
	i32.store8	$discard=, sK+1($pop53), $pop8
	i32.const	$push47=, 0
	i32.const	$push46=, 1103515245
	i32.mul 	$push9=, $1, $pop46
	i32.const	$push45=, 12345
	i32.add 	$push44=, $pop9, $pop45
	tee_local	$push43=, $1=, $pop44
	i32.const	$push42=, 16
	i32.shr_u	$push10=, $pop43, $pop42
	i32.store8	$discard=, sK+2($pop47):p2align=1, $pop10
	i32.const	$push41=, 0
	i32.const	$push40=, 1103515245
	i32.mul 	$push11=, $1, $pop40
	i32.const	$push39=, 12345
	i32.add 	$push38=, $pop11, $pop39
	tee_local	$push37=, $1=, $pop38
	i32.const	$push36=, 16
	i32.shr_u	$push12=, $pop37, $pop36
	i32.store8	$discard=, sK+3($pop41), $pop12
	i32.const	$push35=, 0
	i32.load	$0=, sK($pop35)
	i32.const	$push34=, 0
	i32.const	$push33=, 0
	i32.const	$push15=, -341751747
	i32.mul 	$push16=, $1, $pop15
	i32.const	$push17=, 229283573
	i32.add 	$push32=, $pop16, $pop17
	tee_local	$push31=, $1=, $pop32
	i32.const	$push30=, 1103515245
	i32.mul 	$push19=, $pop31, $pop30
	i32.const	$push29=, 12345
	i32.add 	$push20=, $pop19, $pop29
	i32.store	$push21=, myrnd.s($pop33), $pop20
	i32.const	$push28=, 16
	i32.shr_u	$push22=, $pop21, $pop28
	i32.const	$push27=, 16
	i32.shr_u	$push18=, $1, $pop27
	i32.add 	$push23=, $pop22, $pop18
	i32.const	$push24=, 63
	i32.and 	$push25=, $pop23, $pop24
	i32.const	$push13=, -64
	i32.and 	$push14=, $0, $pop13
	i32.or  	$push26=, $pop25, $pop14
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
	i64.load	$push0=, 0($1):p2align=0
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
	i32.load	$push9=, sL($pop10):p2align=3
	tee_local	$push8=, $1=, $pop9
	i32.add 	$push1=, $pop8, $0
	i32.const	$push2=, 63
	i32.and 	$push7=, $pop1, $pop2
	tee_local	$push6=, $0=, $pop7
	i32.const	$push3=, -64
	i32.and 	$push4=, $1, $pop3
	i32.or  	$push5=, $pop6, $pop4
	i32.store	$discard=, sL($pop0):p2align=3, $pop5
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
	i32.const	$push109=, 0
	i32.const	$push108=, 0
	i32.load	$push2=, myrnd.s($pop108)
	i32.const	$push107=, 1103515245
	i32.mul 	$push3=, $pop2, $pop107
	i32.const	$push106=, 12345
	i32.add 	$push105=, $pop3, $pop106
	tee_local	$push104=, $3=, $pop105
	i32.const	$push103=, 16
	i32.shr_u	$push4=, $pop104, $pop103
	i32.store8	$discard=, sL($pop109):p2align=3, $pop4
	i32.const	$push102=, 0
	i32.const	$push101=, 1103515245
	i32.mul 	$push5=, $3, $pop101
	i32.const	$push100=, 12345
	i32.add 	$push99=, $pop5, $pop100
	tee_local	$push98=, $3=, $pop99
	i32.const	$push97=, 16
	i32.shr_u	$push6=, $pop98, $pop97
	i32.store8	$discard=, sL+1($pop102), $pop6
	i32.const	$push96=, 0
	i32.const	$push95=, 1103515245
	i32.mul 	$push7=, $3, $pop95
	i32.const	$push94=, 12345
	i32.add 	$push93=, $pop7, $pop94
	tee_local	$push92=, $3=, $pop93
	i32.const	$push91=, 16
	i32.shr_u	$push8=, $pop92, $pop91
	i32.store8	$discard=, sL+2($pop96):p2align=1, $pop8
	i32.const	$push90=, 0
	i32.const	$push89=, 1103515245
	i32.mul 	$push9=, $3, $pop89
	i32.const	$push88=, 12345
	i32.add 	$push87=, $pop9, $pop88
	tee_local	$push86=, $3=, $pop87
	i32.const	$push85=, 16
	i32.shr_u	$push10=, $pop86, $pop85
	i32.store8	$discard=, sL+3($pop90), $pop10
	i32.const	$push84=, 0
	i32.const	$push83=, 1103515245
	i32.mul 	$push11=, $3, $pop83
	i32.const	$push82=, 12345
	i32.add 	$push81=, $pop11, $pop82
	tee_local	$push80=, $3=, $pop81
	i32.const	$push79=, 16
	i32.shr_u	$push12=, $pop80, $pop79
	i32.store8	$discard=, sL+4($pop84):p2align=2, $pop12
	i32.const	$push78=, 0
	i32.const	$push77=, 1103515245
	i32.mul 	$push13=, $3, $pop77
	i32.const	$push76=, 12345
	i32.add 	$push75=, $pop13, $pop76
	tee_local	$push74=, $3=, $pop75
	i32.const	$push73=, 16
	i32.shr_u	$push14=, $pop74, $pop73
	i32.store8	$discard=, sL+5($pop78), $pop14
	i32.const	$push72=, 0
	i32.const	$push71=, 1103515245
	i32.mul 	$push15=, $3, $pop71
	i32.const	$push70=, 12345
	i32.add 	$push69=, $pop15, $pop70
	tee_local	$push68=, $3=, $pop69
	i32.const	$push67=, 16
	i32.shr_u	$push16=, $pop68, $pop67
	i32.store8	$discard=, sL+6($pop72):p2align=1, $pop16
	i32.const	$push66=, 0
	i32.const	$push65=, 1103515245
	i32.mul 	$push17=, $3, $pop65
	i32.const	$push64=, 12345
	i32.add 	$push63=, $pop17, $pop64
	tee_local	$push62=, $3=, $pop63
	i32.const	$push61=, 16
	i32.shr_u	$push18=, $pop62, $pop61
	i32.store8	$discard=, sL+7($pop66), $pop18
	i32.const	$push60=, 0
	i32.load	$0=, sL($pop60):p2align=3
	block
	i32.const	$push59=, 0
	i32.const	$push58=, 1103515245
	i32.mul 	$push19=, $3, $pop58
	i32.const	$push57=, 12345
	i32.add 	$push56=, $pop19, $pop57
	tee_local	$push55=, $3=, $pop56
	i32.const	$push54=, 1103515245
	i32.mul 	$push20=, $pop55, $pop54
	i32.const	$push53=, 12345
	i32.add 	$push0=, $pop20, $pop53
	i32.store	$push52=, myrnd.s($pop59), $pop0
	tee_local	$push51=, $2=, $pop52
	i32.const	$push50=, 16
	i32.shr_u	$push49=, $pop51, $pop50
	tee_local	$push48=, $1=, $pop49
	i32.const	$push47=, 16
	i32.shr_u	$push46=, $3, $pop47
	tee_local	$push45=, $3=, $pop46
	i32.add 	$push24=, $pop48, $pop45
	i32.const	$push44=, 0
	i32.const	$push43=, 63
	i32.and 	$push21=, $3, $pop43
	i32.const	$push42=, -64
	i32.and 	$push22=, $0, $pop42
	i32.or  	$push1=, $pop21, $pop22
	i32.store	$push41=, sL($pop44):p2align=3, $pop1
	tee_local	$push40=, $3=, $pop41
	i32.add 	$push23=, $pop40, $1
	i32.xor 	$push25=, $pop24, $pop23
	i32.const	$push39=, 63
	i32.and 	$push26=, $pop25, $pop39
	br_if   	0, $pop26       # 0: down to label1
# BB#1:                                 # %if.end75
	i32.const	$push119=, 0
	i32.const	$push118=, 0
	i32.const	$push28=, -2139243339
	i32.mul 	$push29=, $2, $pop28
	i32.const	$push30=, -1492899873
	i32.add 	$push117=, $pop29, $pop30
	tee_local	$push116=, $0=, $pop117
	i32.const	$push115=, 1103515245
	i32.mul 	$push32=, $pop116, $pop115
	i32.const	$push114=, 12345
	i32.add 	$push33=, $pop32, $pop114
	i32.store	$push34=, myrnd.s($pop118), $pop33
	i32.const	$push113=, 16
	i32.shr_u	$push35=, $pop34, $pop113
	i32.const	$push112=, 16
	i32.shr_u	$push31=, $0, $pop112
	i32.add 	$push36=, $pop35, $pop31
	i32.const	$push111=, 63
	i32.and 	$push37=, $pop36, $pop111
	i32.const	$push110=, -64
	i32.and 	$push27=, $3, $pop110
	i32.or  	$push38=, $pop37, $pop27
	i32.store	$discard=, sL($pop119):p2align=3, $pop38
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push106=, 0
	i32.const	$push105=, 0
	i32.load	$push1=, myrnd.s($pop105)
	i32.const	$push104=, 1103515245
	i32.mul 	$push2=, $pop1, $pop104
	i32.const	$push103=, 12345
	i32.add 	$push102=, $pop2, $pop103
	tee_local	$push101=, $1=, $pop102
	i32.const	$push100=, 16
	i32.shr_u	$push3=, $pop101, $pop100
	i32.store8	$discard=, sM($pop106):p2align=3, $pop3
	i32.const	$push99=, 0
	i32.const	$push98=, 1103515245
	i32.mul 	$push4=, $1, $pop98
	i32.const	$push97=, 12345
	i32.add 	$push96=, $pop4, $pop97
	tee_local	$push95=, $1=, $pop96
	i32.const	$push94=, 16
	i32.shr_u	$push5=, $pop95, $pop94
	i32.store8	$discard=, sM+1($pop99), $pop5
	i32.const	$push93=, 0
	i32.const	$push92=, 1103515245
	i32.mul 	$push6=, $1, $pop92
	i32.const	$push91=, 12345
	i32.add 	$push90=, $pop6, $pop91
	tee_local	$push89=, $1=, $pop90
	i32.const	$push88=, 16
	i32.shr_u	$push7=, $pop89, $pop88
	i32.store8	$discard=, sM+2($pop93):p2align=1, $pop7
	i32.const	$push87=, 0
	i32.const	$push86=, 1103515245
	i32.mul 	$push8=, $1, $pop86
	i32.const	$push85=, 12345
	i32.add 	$push84=, $pop8, $pop85
	tee_local	$push83=, $1=, $pop84
	i32.const	$push82=, 1103515245
	i32.mul 	$push10=, $pop83, $pop82
	i32.const	$push81=, 12345
	i32.add 	$push80=, $pop10, $pop81
	tee_local	$push79=, $3=, $pop80
	i32.const	$push78=, 16
	i32.shr_u	$push11=, $pop79, $pop78
	i32.store8	$discard=, sM+4($pop87):p2align=2, $pop11
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
	i32.store8	$discard=, sM+6($pop71):p2align=1, $pop15
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
	i32.load	$0=, sM+4($pop59)
	i32.const	$push58=, 0
	i32.const	$push57=, 16
	i32.shr_u	$push9=, $1, $pop57
	i32.store8	$discard=, sM+3($pop58), $pop9
	i32.const	$push56=, 0
	i32.const	$push55=, 1103515245
	i32.mul 	$push18=, $3, $pop55
	i32.const	$push54=, 12345
	i32.add 	$push53=, $pop18, $pop54
	tee_local	$push52=, $3=, $pop53
	i32.const	$push51=, 1103515245
	i32.mul 	$push19=, $pop52, $pop51
	i32.const	$push50=, 12345
	i32.add 	$push0=, $pop19, $pop50
	i32.store	$1=, myrnd.s($pop56), $pop0
	block
	i32.const	$push49=, 0
	i32.const	$push48=, 16
	i32.shr_u	$push47=, $3, $pop48
	tee_local	$push46=, $3=, $pop47
	i32.const	$push45=, 63
	i32.and 	$push20=, $pop46, $pop45
	i32.const	$push21=, -64
	i32.and 	$push44=, $0, $pop21
	tee_local	$push43=, $2=, $pop44
	i32.or  	$push22=, $pop20, $pop43
	i32.store	$push23=, sM+4($pop49), $pop22
	i32.const	$push42=, 16
	i32.shr_u	$push41=, $1, $pop42
	tee_local	$push40=, $0=, $pop41
	i32.add 	$push24=, $pop23, $pop40
	i32.add 	$push25=, $0, $3
	i32.xor 	$push26=, $pop24, $pop25
	i32.const	$push39=, 63
	i32.and 	$push27=, $pop26, $pop39
	br_if   	0, $pop27       # 0: down to label2
# BB#1:                                 # %if.end107
	i32.const	$push115=, 0
	i32.const	$push114=, 0
	i32.const	$push28=, -2139243339
	i32.mul 	$push29=, $1, $pop28
	i32.const	$push30=, -1492899873
	i32.add 	$push113=, $pop29, $pop30
	tee_local	$push112=, $1=, $pop113
	i32.const	$push111=, 1103515245
	i32.mul 	$push32=, $pop112, $pop111
	i32.const	$push110=, 12345
	i32.add 	$push33=, $pop32, $pop110
	i32.store	$push34=, myrnd.s($pop114), $pop33
	i32.const	$push109=, 16
	i32.shr_u	$push35=, $pop34, $pop109
	i32.const	$push108=, 16
	i32.shr_u	$push31=, $1, $pop108
	i32.add 	$push36=, $pop35, $pop31
	i32.const	$push107=, 63
	i32.and 	$push37=, $pop36, $pop107
	i32.or  	$push38=, $pop37, $2
	i32.store	$discard=, sM+4($pop115), $pop38
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
	i32.const	$push4=, 0
	i32.const	$push167=, 0
	i32.load	$push5=, myrnd.s($pop167)
	i32.const	$push6=, 1103515245
	i32.mul 	$push7=, $pop5, $pop6
	i32.const	$push8=, 12345
	i32.add 	$push166=, $pop7, $pop8
	tee_local	$push165=, $5=, $pop166
	i32.const	$push164=, 16
	i32.shr_u	$push9=, $pop165, $pop164
	i32.store8	$discard=, sN($pop4):p2align=3, $pop9
	i32.const	$push163=, 0
	i32.const	$push162=, 1103515245
	i32.mul 	$push10=, $5, $pop162
	i32.const	$push161=, 12345
	i32.add 	$push160=, $pop10, $pop161
	tee_local	$push159=, $5=, $pop160
	i32.const	$push158=, 16
	i32.shr_u	$push11=, $pop159, $pop158
	i32.store8	$discard=, sN+1($pop163), $pop11
	i32.const	$push157=, 0
	i32.const	$push156=, 1103515245
	i32.mul 	$push12=, $5, $pop156
	i32.const	$push155=, 12345
	i32.add 	$push154=, $pop12, $pop155
	tee_local	$push153=, $5=, $pop154
	i32.const	$push152=, 16
	i32.shr_u	$push13=, $pop153, $pop152
	i32.store8	$discard=, sN+2($pop157):p2align=1, $pop13
	i32.const	$push151=, 0
	i32.const	$push150=, 1103515245
	i32.mul 	$push14=, $5, $pop150
	i32.const	$push149=, 12345
	i32.add 	$push148=, $pop14, $pop149
	tee_local	$push147=, $5=, $pop148
	i32.const	$push146=, 16
	i32.shr_u	$push15=, $pop147, $pop146
	i32.store8	$discard=, sN+3($pop151), $pop15
	i32.const	$push145=, 0
	i32.const	$push144=, 1103515245
	i32.mul 	$push16=, $5, $pop144
	i32.const	$push143=, 12345
	i32.add 	$push142=, $pop16, $pop143
	tee_local	$push141=, $5=, $pop142
	i32.const	$push140=, 16
	i32.shr_u	$push17=, $pop141, $pop140
	i32.store8	$discard=, sN+4($pop145):p2align=2, $pop17
	i32.const	$push139=, 0
	i32.const	$push138=, 1103515245
	i32.mul 	$push18=, $5, $pop138
	i32.const	$push137=, 12345
	i32.add 	$push136=, $pop18, $pop137
	tee_local	$push135=, $5=, $pop136
	i32.const	$push134=, 16
	i32.shr_u	$push19=, $pop135, $pop134
	i32.store8	$discard=, sN+5($pop139), $pop19
	i32.const	$push133=, 0
	i32.const	$push132=, 1103515245
	i32.mul 	$push20=, $5, $pop132
	i32.const	$push131=, 12345
	i32.add 	$push130=, $pop20, $pop131
	tee_local	$push129=, $5=, $pop130
	i32.const	$push128=, 16
	i32.shr_u	$push21=, $pop129, $pop128
	i32.store8	$discard=, sN+6($pop133):p2align=1, $pop21
	i32.const	$push127=, 0
	i32.const	$push126=, 1103515245
	i32.mul 	$push22=, $5, $pop126
	i32.const	$push125=, 12345
	i32.add 	$push124=, $pop22, $pop125
	tee_local	$push123=, $5=, $pop124
	i32.const	$push122=, 16
	i32.shr_u	$push23=, $pop123, $pop122
	i32.store8	$discard=, sN+7($pop127), $pop23
	i32.const	$push121=, 0
	i32.const	$push120=, 1103515245
	i32.mul 	$push26=, $5, $pop120
	i32.const	$push119=, 12345
	i32.add 	$push118=, $pop26, $pop119
	tee_local	$push117=, $5=, $pop118
	i32.const	$push116=, 1103515245
	i32.mul 	$push27=, $pop117, $pop116
	i32.const	$push115=, 12345
	i32.add 	$push0=, $pop27, $pop115
	i32.store	$1=, myrnd.s($pop121), $pop0
	block
	block
	block
	i32.const	$push114=, 0
	i32.const	$push28=, 10
	i32.shr_u	$push29=, $5, $pop28
	i64.extend_u/i32	$push30=, $pop29
	i64.const	$push24=, 4032
	i64.and 	$push31=, $pop30, $pop24
	i32.const	$push113=, 0
	i64.load	$push112=, sN($pop113)
	tee_local	$push111=, $4=, $pop112
	i64.const	$push32=, -4033
	i64.and 	$push110=, $pop111, $pop32
	tee_local	$push109=, $3=, $pop110
	i64.or  	$push1=, $pop31, $pop109
	i64.store	$push108=, sN($pop114), $pop1
	tee_local	$push107=, $2=, $pop108
	i64.const	$push106=, 4032
	i64.or  	$push25=, $4, $pop106
	i64.xor 	$push105=, $pop107, $pop25
	tee_local	$push104=, $4=, $pop105
	i64.const	$push35=, 34359734272
	i64.and 	$push36=, $pop104, $pop35
	i64.const	$push103=, 0
	i64.ne  	$push37=, $pop36, $pop103
	br_if   	0, $pop37       # 0: down to label5
# BB#1:                                 # %lor.lhs.false29
	i64.const	$push41=, 63
	i64.and 	$push42=, $4, $pop41
	i64.const	$push168=, 0
	i64.ne  	$push43=, $pop42, $pop168
	br_if   	0, $pop43       # 0: down to label5
# BB#2:                                 # %lor.lhs.false29
	i64.const	$push33=, 6
	i64.shr_u	$push34=, $2, $pop33
	i32.wrap/i64	$push173=, $pop34
	tee_local	$push172=, $6=, $pop173
	i32.const	$push171=, 16
	i32.shr_u	$push170=, $5, $pop171
	tee_local	$push169=, $5=, $pop170
	i32.xor 	$push39=, $pop172, $pop169
	i32.const	$push40=, 63
	i32.and 	$push38=, $pop39, $pop40
	br_if   	0, $pop38       # 0: down to label5
# BB#3:                                 # %lor.lhs.false49
	i32.const	$push177=, 16
	i32.shr_u	$push176=, $1, $pop177
	tee_local	$push175=, $7=, $pop176
	i32.add 	$push2=, $6, $pop175
	i32.add 	$push44=, $7, $5
	i32.xor 	$push45=, $pop2, $pop44
	i32.const	$push174=, 63
	i32.and 	$push46=, $pop45, $pop174
	br_if   	0, $pop46       # 0: down to label5
# BB#4:                                 # %lor.lhs.false69
	i32.const	$push51=, 0
	i32.const	$push47=, 1103515245
	i32.mul 	$push48=, $1, $pop47
	i32.const	$push49=, 12345
	i32.add 	$push193=, $pop48, $pop49
	tee_local	$push192=, $5=, $pop193
	i32.const	$push191=, 1103515245
	i32.mul 	$push50=, $pop192, $pop191
	i32.const	$push190=, 12345
	i32.add 	$push3=, $pop50, $pop190
	i32.store	$1=, myrnd.s($pop51), $pop3
	i32.const	$push189=, 0
	i32.const	$push52=, 10
	i32.shr_u	$push53=, $5, $pop52
	i64.extend_u/i32	$push54=, $pop53
	i64.const	$push55=, 4032
	i64.and 	$push56=, $pop54, $pop55
	i64.or  	$push57=, $pop56, $3
	i64.store	$push188=, sN($pop189), $pop57
	tee_local	$push187=, $4=, $pop188
	i64.const	$push58=, 6
	i64.shr_u	$push59=, $pop187, $pop58
	i32.wrap/i64	$push186=, $pop59
	tee_local	$push185=, $6=, $pop186
	i32.const	$push184=, 16
	i32.shr_u	$push183=, $1, $pop184
	tee_local	$push182=, $7=, $pop183
	i32.add 	$push60=, $pop185, $pop182
	i32.const	$push181=, 63
	i32.and 	$push61=, $pop60, $pop181
	i32.const	$push62=, 15
	i32.rem_u	$0=, $pop61, $pop62
	i64.xor 	$push180=, $4, $2
	tee_local	$push179=, $2=, $pop180
	i64.const	$push63=, 34359734272
	i64.and 	$push64=, $pop179, $pop63
	i64.const	$push178=, 0
	i64.ne  	$push65=, $pop64, $pop178
	br_if   	1, $pop65       # 1: down to label4
# BB#5:                                 # %lor.lhs.false80
	i64.const	$push69=, 63
	i64.and 	$push70=, $2, $pop69
	i64.const	$push194=, 0
	i64.ne  	$push71=, $pop70, $pop194
	br_if   	1, $pop71       # 1: down to label4
# BB#6:                                 # %lor.lhs.false80
	i32.const	$push197=, 16
	i32.shr_u	$push196=, $5, $pop197
	tee_local	$push195=, $5=, $pop196
	i32.xor 	$push67=, $6, $pop195
	i32.const	$push68=, 63
	i32.and 	$push66=, $pop67, $pop68
	br_if   	1, $pop66       # 1: down to label4
# BB#7:                                 # %lor.lhs.false100
	i32.add 	$push72=, $7, $5
	i32.const	$push198=, 63
	i32.and 	$push73=, $pop72, $pop198
	i32.const	$push74=, 15
	i32.rem_u	$push75=, $pop73, $pop74
	i32.ne  	$push76=, $pop75, $0
	br_if   	1, $pop76       # 1: down to label4
# BB#8:                                 # %lor.lhs.false125
	i32.const	$push84=, 0
	i32.const	$push77=, 1103515245
	i32.mul 	$push78=, $1, $pop77
	i32.const	$push79=, 12345
	i32.add 	$push210=, $pop78, $pop79
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
	i32.mul 	$push82=, $5, $pop207
	i32.const	$push206=, 12345
	i32.add 	$push83=, $pop82, $pop206
	i32.store	$push85=, myrnd.s($pop208), $pop83
	i32.const	$push80=, 16
	i32.shr_u	$push205=, $pop85, $pop80
	tee_local	$push204=, $1=, $pop205
	i32.add 	$push203=, $pop94, $pop204
	tee_local	$push202=, $6=, $pop203
	i32.const	$push95=, 6
	i32.shl 	$push96=, $pop202, $pop95
	i64.extend_u/i32	$push97=, $pop96
	i64.const	$push201=, 4032
	i64.and 	$push98=, $pop97, $pop201
	i64.or  	$push99=, $pop98, $3
	i64.store	$discard=, sN($pop84), $pop99
	i32.const	$push200=, 16
	i32.shr_u	$push81=, $5, $pop200
	i32.add 	$push100=, $1, $pop81
	i32.xor 	$push101=, $pop100, $6
	i32.const	$push199=, 63
	i32.and 	$push102=, $pop101, $pop199
	br_if   	2, $pop102      # 2: down to label3
# BB#9:                                 # %if.end158
	return
.LBB84_10:                              # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB84_11:                              # %if.then106
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB84_12:                              # %if.then157
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
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.add 	$push3=, $1, $pop1
	i64.load	$2=, 0($pop3):p2align=0
	i64.load	$push0=, 0($1):p2align=0
	i64.store	$discard=, 0($0):p2align=0, $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i64.store	$discard=, 0($pop2):p2align=0, $2
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
	.local  	i64, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push204=, 0
	i32.load	$push5=, myrnd.s($pop204)
	i32.const	$push6=, 1103515245
	i32.mul 	$push7=, $pop5, $pop6
	i32.const	$push8=, 12345
	i32.add 	$push203=, $pop7, $pop8
	tee_local	$push202=, $1=, $pop203
	i32.const	$push201=, 16
	i32.shr_u	$push9=, $pop202, $pop201
	i32.store8	$discard=, sO($pop4):p2align=3, $pop9
	i32.const	$push200=, 0
	i32.const	$push199=, 1103515245
	i32.mul 	$push10=, $1, $pop199
	i32.const	$push198=, 12345
	i32.add 	$push197=, $pop10, $pop198
	tee_local	$push196=, $1=, $pop197
	i32.const	$push195=, 16
	i32.shr_u	$push11=, $pop196, $pop195
	i32.store8	$discard=, sO+1($pop200), $pop11
	i32.const	$push194=, 0
	i32.const	$push193=, 1103515245
	i32.mul 	$push12=, $1, $pop193
	i32.const	$push192=, 12345
	i32.add 	$push191=, $pop12, $pop192
	tee_local	$push190=, $1=, $pop191
	i32.const	$push189=, 16
	i32.shr_u	$push13=, $pop190, $pop189
	i32.store8	$discard=, sO+2($pop194):p2align=1, $pop13
	i32.const	$push188=, 0
	i32.const	$push187=, 1103515245
	i32.mul 	$push14=, $1, $pop187
	i32.const	$push186=, 12345
	i32.add 	$push185=, $pop14, $pop186
	tee_local	$push184=, $1=, $pop185
	i32.const	$push183=, 16
	i32.shr_u	$push15=, $pop184, $pop183
	i32.store8	$discard=, sO+3($pop188), $pop15
	i32.const	$push182=, 0
	i32.const	$push181=, 1103515245
	i32.mul 	$push16=, $1, $pop181
	i32.const	$push180=, 12345
	i32.add 	$push179=, $pop16, $pop180
	tee_local	$push178=, $1=, $pop179
	i32.const	$push177=, 16
	i32.shr_u	$push17=, $pop178, $pop177
	i32.store8	$discard=, sO+4($pop182):p2align=2, $pop17
	i32.const	$push176=, 0
	i32.const	$push175=, 1103515245
	i32.mul 	$push18=, $1, $pop175
	i32.const	$push174=, 12345
	i32.add 	$push173=, $pop18, $pop174
	tee_local	$push172=, $1=, $pop173
	i32.const	$push171=, 16
	i32.shr_u	$push19=, $pop172, $pop171
	i32.store8	$discard=, sO+5($pop176), $pop19
	i32.const	$push170=, 0
	i32.const	$push169=, 1103515245
	i32.mul 	$push20=, $1, $pop169
	i32.const	$push168=, 12345
	i32.add 	$push167=, $pop20, $pop168
	tee_local	$push166=, $1=, $pop167
	i32.const	$push165=, 16
	i32.shr_u	$push21=, $pop166, $pop165
	i32.store8	$discard=, sO+6($pop170):p2align=1, $pop21
	i32.const	$push164=, 0
	i32.const	$push163=, 1103515245
	i32.mul 	$push22=, $1, $pop163
	i32.const	$push162=, 12345
	i32.add 	$push161=, $pop22, $pop162
	tee_local	$push160=, $1=, $pop161
	i32.const	$push159=, 16
	i32.shr_u	$push23=, $pop160, $pop159
	i32.store8	$discard=, sO+7($pop164), $pop23
	i32.const	$push158=, 0
	i32.const	$push157=, 1103515245
	i32.mul 	$push24=, $1, $pop157
	i32.const	$push156=, 12345
	i32.add 	$push155=, $pop24, $pop156
	tee_local	$push154=, $1=, $pop155
	i32.const	$push153=, 16
	i32.shr_u	$push25=, $pop154, $pop153
	i32.store8	$discard=, sO+8($pop158):p2align=3, $pop25
	i32.const	$push152=, 0
	i32.const	$push151=, 1103515245
	i32.mul 	$push26=, $1, $pop151
	i32.const	$push150=, 12345
	i32.add 	$push149=, $pop26, $pop150
	tee_local	$push148=, $1=, $pop149
	i32.const	$push147=, 16
	i32.shr_u	$push27=, $pop148, $pop147
	i32.store8	$discard=, sO+9($pop152), $pop27
	i32.const	$push146=, 0
	i32.const	$push145=, 1103515245
	i32.mul 	$push28=, $1, $pop145
	i32.const	$push144=, 12345
	i32.add 	$push143=, $pop28, $pop144
	tee_local	$push142=, $1=, $pop143
	i32.const	$push141=, 16
	i32.shr_u	$push29=, $pop142, $pop141
	i32.store8	$discard=, sO+10($pop146):p2align=1, $pop29
	i32.const	$push140=, 0
	i32.const	$push139=, 1103515245
	i32.mul 	$push30=, $1, $pop139
	i32.const	$push138=, 12345
	i32.add 	$push137=, $pop30, $pop138
	tee_local	$push136=, $1=, $pop137
	i32.const	$push135=, 16
	i32.shr_u	$push31=, $pop136, $pop135
	i32.store8	$discard=, sO+11($pop140), $pop31
	i32.const	$push134=, 0
	i32.const	$push133=, 1103515245
	i32.mul 	$push32=, $1, $pop133
	i32.const	$push132=, 12345
	i32.add 	$push131=, $pop32, $pop132
	tee_local	$push130=, $1=, $pop131
	i32.const	$push129=, 16
	i32.shr_u	$push33=, $pop130, $pop129
	i32.store8	$discard=, sO+12($pop134):p2align=2, $pop33
	i32.const	$push128=, 0
	i32.const	$push127=, 1103515245
	i32.mul 	$push34=, $1, $pop127
	i32.const	$push126=, 12345
	i32.add 	$push125=, $pop34, $pop126
	tee_local	$push124=, $1=, $pop125
	i32.const	$push123=, 16
	i32.shr_u	$push35=, $pop124, $pop123
	i32.store8	$discard=, sO+13($pop128), $pop35
	i32.const	$push122=, 0
	i32.const	$push121=, 1103515245
	i32.mul 	$push36=, $1, $pop121
	i32.const	$push120=, 12345
	i32.add 	$push119=, $pop36, $pop120
	tee_local	$push118=, $1=, $pop119
	i32.const	$push117=, 16
	i32.shr_u	$push37=, $pop118, $pop117
	i32.store8	$discard=, sO+14($pop122):p2align=1, $pop37
	i32.const	$push116=, 0
	i32.const	$push115=, 1103515245
	i32.mul 	$push38=, $1, $pop115
	i32.const	$push114=, 12345
	i32.add 	$push113=, $pop38, $pop114
	tee_local	$push112=, $1=, $pop113
	i32.const	$push111=, 16
	i32.shr_u	$push39=, $pop112, $pop111
	i32.store8	$discard=, sO+15($pop116), $pop39
	i32.const	$push110=, 0
	i64.load	$0=, sO+8($pop110)
	i32.const	$push109=, 1103515245
	i32.mul 	$push40=, $1, $pop109
	i32.const	$push108=, 12345
	i32.add 	$push107=, $pop40, $pop108
	tee_local	$push106=, $2=, $pop107
	i32.const	$push105=, 16
	i32.shr_u	$push41=, $pop106, $pop105
	i32.const	$push104=, 2047
	i32.and 	$1=, $pop41, $pop104
	i32.const	$push103=, 0
	i32.const	$push102=, 1103515245
	i32.mul 	$push42=, $2, $pop102
	i32.const	$push101=, 12345
	i32.add 	$push0=, $pop42, $pop101
	i32.store	$2=, myrnd.s($pop103), $pop0
	block
	block
	i32.const	$push100=, 0
	i64.extend_u/i32	$push44=, $1
	i64.const	$push45=, -4096
	i64.and 	$push46=, $0, $pop45
	i64.or  	$push47=, $pop44, $pop46
	i64.store	$push48=, sO+8($pop100), $pop47
	i32.wrap/i64	$push99=, $pop48
	tee_local	$push98=, $3=, $pop99
	i32.const	$push97=, 2047
	i32.and 	$push51=, $pop98, $pop97
	i32.ne  	$push52=, $1, $pop51
	br_if   	0, $pop52       # 0: down to label7
# BB#1:                                 # %entry
	i32.const	$push208=, 16
	i32.shr_u	$push43=, $2, $pop208
	i32.const	$push207=, 2047
	i32.and 	$push206=, $pop43, $pop207
	tee_local	$push205=, $4=, $pop206
	i32.add 	$push2=, $pop205, $1
	i32.add 	$push49=, $3, $4
	i32.const	$push50=, 4095
	i32.and 	$push3=, $pop49, $pop50
	i32.ne  	$push53=, $pop2, $pop3
	br_if   	0, $pop53       # 0: down to label7
# BB#2:                                 # %if.end
	i32.const	$push54=, 1103515245
	i32.mul 	$push55=, $2, $pop54
	i32.const	$push56=, 12345
	i32.add 	$push218=, $pop55, $pop56
	tee_local	$push217=, $2=, $pop218
	i32.const	$push216=, 16
	i32.shr_u	$push57=, $pop217, $pop216
	i32.const	$push215=, 2047
	i32.and 	$1=, $pop57, $pop215
	i32.const	$push59=, 0
	i32.const	$push214=, 1103515245
	i32.mul 	$push58=, $2, $pop214
	i32.const	$push213=, 12345
	i32.add 	$push1=, $pop58, $pop213
	i32.store	$2=, myrnd.s($pop59), $pop1
	block
	i32.const	$push212=, 0
	i64.extend_u/i32	$push61=, $1
	i64.const	$push62=, -4096
	i64.and 	$push63=, $0, $pop62
	i64.or  	$push64=, $pop61, $pop63
	i64.store	$push65=, sO+8($pop212), $pop64
	i32.wrap/i64	$push211=, $pop65
	tee_local	$push210=, $3=, $pop211
	i32.const	$push209=, 2047
	i32.and 	$push66=, $pop210, $pop209
	i32.ne  	$push67=, $1, $pop66
	br_if   	0, $pop67       # 0: down to label8
# BB#3:                                 # %lor.lhs.false87
	i32.const	$push224=, 16
	i32.shr_u	$push60=, $2, $pop224
	i32.const	$push223=, 2047
	i32.and 	$push222=, $pop60, $pop223
	tee_local	$push221=, $4=, $pop222
	i32.add 	$push68=, $3, $pop221
	i32.const	$push220=, 4095
	i32.and 	$push69=, $pop68, $pop220
	i32.const	$push70=, 15
	i32.rem_u	$push71=, $pop69, $pop70
	i32.add 	$push72=, $4, $1
	i32.const	$push219=, 15
	i32.rem_u	$push73=, $pop72, $pop219
	i32.ne  	$push74=, $pop71, $pop73
	br_if   	0, $pop74       # 0: down to label8
# BB#4:                                 # %lor.lhs.false124
	i32.const	$push83=, 0
	i32.const	$push75=, 1103515245
	i32.mul 	$push76=, $2, $pop75
	i32.const	$push77=, 12345
	i32.add 	$push240=, $pop76, $pop77
	tee_local	$push239=, $1=, $pop240
	i32.const	$push78=, 16
	i32.shr_u	$push79=, $pop239, $pop78
	i32.const	$push80=, 2047
	i32.and 	$push238=, $pop79, $pop80
	tee_local	$push237=, $2=, $pop238
	i64.extend_u/i32	$push86=, $pop237
	i64.const	$push87=, -4096
	i64.and 	$push236=, $0, $pop87
	tee_local	$push235=, $0=, $pop236
	i64.or  	$push88=, $pop86, $pop235
	i32.wrap/i64	$push89=, $pop88
	i32.const	$push234=, 0
	i32.const	$push233=, 1103515245
	i32.mul 	$push81=, $1, $pop233
	i32.const	$push232=, 12345
	i32.add 	$push82=, $pop81, $pop232
	i32.store	$push84=, myrnd.s($pop234), $pop82
	i32.const	$push231=, 16
	i32.shr_u	$push85=, $pop84, $pop231
	i32.const	$push230=, 2047
	i32.and 	$push229=, $pop85, $pop230
	tee_local	$push228=, $1=, $pop229
	i32.add 	$push227=, $pop89, $pop228
	tee_local	$push226=, $3=, $pop227
	i64.extend_u/i32	$push90=, $pop226
	i64.const	$push91=, 4095
	i64.and 	$push92=, $pop90, $pop91
	i64.or  	$push93=, $pop92, $0
	i64.store	$discard=, sO+8($pop83), $pop93
	i32.add 	$push95=, $1, $2
	i32.const	$push225=, 4095
	i32.and 	$push94=, $3, $pop225
	i32.ne  	$push96=, $pop95, $pop94
	br_if   	2, $pop96       # 2: down to label6
# BB#5:                                 # %if.end140
	return
.LBB90_6:                               # %if.then93
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB90_7:                               # %if.then
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB90_8:                               # %if.then139
	end_block                       # label6:
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
	i64.load	$2=, 0($pop3):p2align=0
	i64.load	$push0=, 0($1):p2align=0
	i64.store	$discard=, 0($0):p2align=0, $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i64.store	$discard=, 0($pop2):p2align=0, $2
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
	.local  	i64, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push204=, 0
	i32.load	$push5=, myrnd.s($pop204)
	i32.const	$push6=, 1103515245
	i32.mul 	$push7=, $pop5, $pop6
	i32.const	$push8=, 12345
	i32.add 	$push203=, $pop7, $pop8
	tee_local	$push202=, $1=, $pop203
	i32.const	$push201=, 16
	i32.shr_u	$push9=, $pop202, $pop201
	i32.store8	$discard=, sP($pop4):p2align=3, $pop9
	i32.const	$push200=, 0
	i32.const	$push199=, 1103515245
	i32.mul 	$push10=, $1, $pop199
	i32.const	$push198=, 12345
	i32.add 	$push197=, $pop10, $pop198
	tee_local	$push196=, $1=, $pop197
	i32.const	$push195=, 16
	i32.shr_u	$push11=, $pop196, $pop195
	i32.store8	$discard=, sP+1($pop200), $pop11
	i32.const	$push194=, 0
	i32.const	$push193=, 1103515245
	i32.mul 	$push12=, $1, $pop193
	i32.const	$push192=, 12345
	i32.add 	$push191=, $pop12, $pop192
	tee_local	$push190=, $1=, $pop191
	i32.const	$push189=, 16
	i32.shr_u	$push13=, $pop190, $pop189
	i32.store8	$discard=, sP+2($pop194):p2align=1, $pop13
	i32.const	$push188=, 0
	i32.const	$push187=, 1103515245
	i32.mul 	$push14=, $1, $pop187
	i32.const	$push186=, 12345
	i32.add 	$push185=, $pop14, $pop186
	tee_local	$push184=, $1=, $pop185
	i32.const	$push183=, 16
	i32.shr_u	$push15=, $pop184, $pop183
	i32.store8	$discard=, sP+3($pop188), $pop15
	i32.const	$push182=, 0
	i32.const	$push181=, 1103515245
	i32.mul 	$push16=, $1, $pop181
	i32.const	$push180=, 12345
	i32.add 	$push179=, $pop16, $pop180
	tee_local	$push178=, $1=, $pop179
	i32.const	$push177=, 16
	i32.shr_u	$push17=, $pop178, $pop177
	i32.store8	$discard=, sP+4($pop182):p2align=2, $pop17
	i32.const	$push176=, 0
	i32.const	$push175=, 1103515245
	i32.mul 	$push18=, $1, $pop175
	i32.const	$push174=, 12345
	i32.add 	$push173=, $pop18, $pop174
	tee_local	$push172=, $1=, $pop173
	i32.const	$push171=, 16
	i32.shr_u	$push19=, $pop172, $pop171
	i32.store8	$discard=, sP+5($pop176), $pop19
	i32.const	$push170=, 0
	i32.const	$push169=, 1103515245
	i32.mul 	$push20=, $1, $pop169
	i32.const	$push168=, 12345
	i32.add 	$push167=, $pop20, $pop168
	tee_local	$push166=, $1=, $pop167
	i32.const	$push165=, 16
	i32.shr_u	$push21=, $pop166, $pop165
	i32.store8	$discard=, sP+6($pop170):p2align=1, $pop21
	i32.const	$push164=, 0
	i32.const	$push163=, 1103515245
	i32.mul 	$push22=, $1, $pop163
	i32.const	$push162=, 12345
	i32.add 	$push161=, $pop22, $pop162
	tee_local	$push160=, $1=, $pop161
	i32.const	$push159=, 16
	i32.shr_u	$push23=, $pop160, $pop159
	i32.store8	$discard=, sP+7($pop164), $pop23
	i32.const	$push158=, 0
	i32.const	$push157=, 1103515245
	i32.mul 	$push24=, $1, $pop157
	i32.const	$push156=, 12345
	i32.add 	$push155=, $pop24, $pop156
	tee_local	$push154=, $1=, $pop155
	i32.const	$push153=, 16
	i32.shr_u	$push25=, $pop154, $pop153
	i32.store8	$discard=, sP+8($pop158):p2align=3, $pop25
	i32.const	$push152=, 0
	i32.const	$push151=, 1103515245
	i32.mul 	$push26=, $1, $pop151
	i32.const	$push150=, 12345
	i32.add 	$push149=, $pop26, $pop150
	tee_local	$push148=, $1=, $pop149
	i32.const	$push147=, 16
	i32.shr_u	$push27=, $pop148, $pop147
	i32.store8	$discard=, sP+9($pop152), $pop27
	i32.const	$push146=, 0
	i32.const	$push145=, 1103515245
	i32.mul 	$push28=, $1, $pop145
	i32.const	$push144=, 12345
	i32.add 	$push143=, $pop28, $pop144
	tee_local	$push142=, $1=, $pop143
	i32.const	$push141=, 16
	i32.shr_u	$push29=, $pop142, $pop141
	i32.store8	$discard=, sP+10($pop146):p2align=1, $pop29
	i32.const	$push140=, 0
	i32.const	$push139=, 1103515245
	i32.mul 	$push30=, $1, $pop139
	i32.const	$push138=, 12345
	i32.add 	$push137=, $pop30, $pop138
	tee_local	$push136=, $1=, $pop137
	i32.const	$push135=, 16
	i32.shr_u	$push31=, $pop136, $pop135
	i32.store8	$discard=, sP+11($pop140), $pop31
	i32.const	$push134=, 0
	i32.const	$push133=, 1103515245
	i32.mul 	$push32=, $1, $pop133
	i32.const	$push132=, 12345
	i32.add 	$push131=, $pop32, $pop132
	tee_local	$push130=, $1=, $pop131
	i32.const	$push129=, 16
	i32.shr_u	$push33=, $pop130, $pop129
	i32.store8	$discard=, sP+12($pop134):p2align=2, $pop33
	i32.const	$push128=, 0
	i32.const	$push127=, 1103515245
	i32.mul 	$push34=, $1, $pop127
	i32.const	$push126=, 12345
	i32.add 	$push125=, $pop34, $pop126
	tee_local	$push124=, $1=, $pop125
	i32.const	$push123=, 16
	i32.shr_u	$push35=, $pop124, $pop123
	i32.store8	$discard=, sP+13($pop128), $pop35
	i32.const	$push122=, 0
	i32.const	$push121=, 1103515245
	i32.mul 	$push36=, $1, $pop121
	i32.const	$push120=, 12345
	i32.add 	$push119=, $pop36, $pop120
	tee_local	$push118=, $1=, $pop119
	i32.const	$push117=, 16
	i32.shr_u	$push37=, $pop118, $pop117
	i32.store8	$discard=, sP+14($pop122):p2align=1, $pop37
	i32.const	$push116=, 0
	i32.const	$push115=, 1103515245
	i32.mul 	$push38=, $1, $pop115
	i32.const	$push114=, 12345
	i32.add 	$push113=, $pop38, $pop114
	tee_local	$push112=, $1=, $pop113
	i32.const	$push111=, 16
	i32.shr_u	$push39=, $pop112, $pop111
	i32.store8	$discard=, sP+15($pop116), $pop39
	i32.const	$push110=, 0
	i64.load	$0=, sP($pop110)
	i32.const	$push109=, 1103515245
	i32.mul 	$push40=, $1, $pop109
	i32.const	$push108=, 12345
	i32.add 	$push107=, $pop40, $pop108
	tee_local	$push106=, $2=, $pop107
	i32.const	$push105=, 16
	i32.shr_u	$push41=, $pop106, $pop105
	i32.const	$push104=, 2047
	i32.and 	$1=, $pop41, $pop104
	i32.const	$push103=, 0
	i32.const	$push102=, 1103515245
	i32.mul 	$push42=, $2, $pop102
	i32.const	$push101=, 12345
	i32.add 	$push0=, $pop42, $pop101
	i32.store	$2=, myrnd.s($pop103), $pop0
	block
	block
	i32.const	$push100=, 0
	i64.extend_u/i32	$push44=, $1
	i64.const	$push45=, -4096
	i64.and 	$push46=, $0, $pop45
	i64.or  	$push47=, $pop44, $pop46
	i64.store	$push48=, sP($pop100), $pop47
	i32.wrap/i64	$push99=, $pop48
	tee_local	$push98=, $3=, $pop99
	i32.const	$push97=, 2047
	i32.and 	$push51=, $pop98, $pop97
	i32.ne  	$push52=, $1, $pop51
	br_if   	0, $pop52       # 0: down to label10
# BB#1:                                 # %entry
	i32.const	$push208=, 16
	i32.shr_u	$push43=, $2, $pop208
	i32.const	$push207=, 2047
	i32.and 	$push206=, $pop43, $pop207
	tee_local	$push205=, $4=, $pop206
	i32.add 	$push2=, $pop205, $1
	i32.add 	$push49=, $3, $4
	i32.const	$push50=, 4095
	i32.and 	$push3=, $pop49, $pop50
	i32.ne  	$push53=, $pop2, $pop3
	br_if   	0, $pop53       # 0: down to label10
# BB#2:                                 # %if.end
	i32.const	$push54=, 1103515245
	i32.mul 	$push55=, $2, $pop54
	i32.const	$push56=, 12345
	i32.add 	$push218=, $pop55, $pop56
	tee_local	$push217=, $2=, $pop218
	i32.const	$push216=, 16
	i32.shr_u	$push57=, $pop217, $pop216
	i32.const	$push215=, 2047
	i32.and 	$1=, $pop57, $pop215
	i32.const	$push59=, 0
	i32.const	$push214=, 1103515245
	i32.mul 	$push58=, $2, $pop214
	i32.const	$push213=, 12345
	i32.add 	$push1=, $pop58, $pop213
	i32.store	$2=, myrnd.s($pop59), $pop1
	block
	i32.const	$push212=, 0
	i64.extend_u/i32	$push61=, $1
	i64.const	$push62=, -4096
	i64.and 	$push63=, $0, $pop62
	i64.or  	$push64=, $pop61, $pop63
	i64.store	$push65=, sP($pop212), $pop64
	i32.wrap/i64	$push211=, $pop65
	tee_local	$push210=, $3=, $pop211
	i32.const	$push209=, 2047
	i32.and 	$push66=, $pop210, $pop209
	i32.ne  	$push67=, $1, $pop66
	br_if   	0, $pop67       # 0: down to label11
# BB#3:                                 # %lor.lhs.false83
	i32.const	$push224=, 16
	i32.shr_u	$push60=, $2, $pop224
	i32.const	$push223=, 2047
	i32.and 	$push222=, $pop60, $pop223
	tee_local	$push221=, $4=, $pop222
	i32.add 	$push68=, $3, $pop221
	i32.const	$push220=, 4095
	i32.and 	$push69=, $pop68, $pop220
	i32.const	$push70=, 15
	i32.rem_u	$push71=, $pop69, $pop70
	i32.add 	$push72=, $4, $1
	i32.const	$push219=, 15
	i32.rem_u	$push73=, $pop72, $pop219
	i32.ne  	$push74=, $pop71, $pop73
	br_if   	0, $pop74       # 0: down to label11
# BB#4:                                 # %lor.lhs.false118
	i32.const	$push83=, 0
	i32.const	$push75=, 1103515245
	i32.mul 	$push76=, $2, $pop75
	i32.const	$push77=, 12345
	i32.add 	$push240=, $pop76, $pop77
	tee_local	$push239=, $1=, $pop240
	i32.const	$push78=, 16
	i32.shr_u	$push79=, $pop239, $pop78
	i32.const	$push80=, 2047
	i32.and 	$push238=, $pop79, $pop80
	tee_local	$push237=, $2=, $pop238
	i64.extend_u/i32	$push86=, $pop237
	i64.const	$push87=, -4096
	i64.and 	$push236=, $0, $pop87
	tee_local	$push235=, $0=, $pop236
	i64.or  	$push88=, $pop86, $pop235
	i32.wrap/i64	$push89=, $pop88
	i32.const	$push234=, 0
	i32.const	$push233=, 1103515245
	i32.mul 	$push81=, $1, $pop233
	i32.const	$push232=, 12345
	i32.add 	$push82=, $pop81, $pop232
	i32.store	$push84=, myrnd.s($pop234), $pop82
	i32.const	$push231=, 16
	i32.shr_u	$push85=, $pop84, $pop231
	i32.const	$push230=, 2047
	i32.and 	$push229=, $pop85, $pop230
	tee_local	$push228=, $1=, $pop229
	i32.add 	$push227=, $pop89, $pop228
	tee_local	$push226=, $3=, $pop227
	i64.extend_u/i32	$push90=, $pop226
	i64.const	$push91=, 4095
	i64.and 	$push92=, $pop90, $pop91
	i64.or  	$push93=, $pop92, $0
	i64.store	$discard=, sP($pop83), $pop93
	i32.add 	$push95=, $1, $2
	i32.const	$push225=, 4095
	i32.and 	$push94=, $3, $pop225
	i32.ne  	$push96=, $pop95, $pop94
	br_if   	2, $pop96       # 2: down to label9
# BB#5:                                 # %if.end134
	return
.LBB96_6:                               # %if.then89
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB96_7:                               # %if.then
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB96_8:                               # %if.then133
	end_block                       # label9:
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.add 	$push3=, $1, $pop1
	i32.load16_u	$2=, 0($pop3):p2align=0
	i64.load	$push0=, 0($1):p2align=0
	i64.store	$discard=, 0($0):p2align=0, $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i32.store16	$discard=, 0($pop2):p2align=0, $2
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
	i32.load16_u	$push1=, sQ($pop0)
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
	i32.load16_u	$push1=, sQ($pop0)
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
	i32.load16_u	$push1=, sQ($pop0)
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
	i32.load16_u	$push9=, sQ($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.add 	$push1=, $pop8, $0
	i32.const	$push4=, 4095
	i32.and 	$push7=, $pop1, $pop4
	tee_local	$push6=, $0=, $pop7
	i32.const	$push2=, 61440
	i32.and 	$push3=, $1, $pop2
	i32.or  	$push5=, $pop6, $pop3
	i32.store16	$discard=, sQ($pop0), $pop5
	return  	$0
	.endfunc
.Lfunc_end101:
	.size	fn3Q, .Lfunc_end101-fn3Q

	.section	.text.testQ,"ax",@progbits
	.hidden	testQ
	.globl	testQ
	.type	testQ,@function
testQ:                                  # @testQ
	.local  	i32
# BB#0:                                 # %if.end90
	i32.const	$push0=, 0
	i32.const	$push107=, 0
	i32.load	$push1=, myrnd.s($pop107)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push106=, $pop3, $pop4
	tee_local	$push105=, $0=, $pop106
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop105, $pop5
	i32.store8	$discard=, sQ($pop0):p2align=1, $pop6
	i32.const	$push104=, 0
	i32.const	$push103=, 1103515245
	i32.mul 	$push7=, $0, $pop103
	i32.const	$push102=, 12345
	i32.add 	$push101=, $pop7, $pop102
	tee_local	$push100=, $0=, $pop101
	i32.const	$push99=, 16
	i32.shr_u	$push8=, $pop100, $pop99
	i32.store8	$discard=, sQ+1($pop104), $pop8
	i32.const	$push98=, 0
	i32.const	$push97=, 1103515245
	i32.mul 	$push9=, $0, $pop97
	i32.const	$push96=, 12345
	i32.add 	$push95=, $pop9, $pop96
	tee_local	$push94=, $0=, $pop95
	i32.const	$push93=, 16
	i32.shr_u	$push10=, $pop94, $pop93
	i32.store8	$discard=, sQ+2($pop98):p2align=1, $pop10
	i32.const	$push92=, 0
	i32.const	$push91=, 1103515245
	i32.mul 	$push11=, $0, $pop91
	i32.const	$push90=, 12345
	i32.add 	$push89=, $pop11, $pop90
	tee_local	$push88=, $0=, $pop89
	i32.const	$push87=, 16
	i32.shr_u	$push12=, $pop88, $pop87
	i32.store8	$discard=, sQ+3($pop92), $pop12
	i32.const	$push86=, 0
	i32.const	$push85=, 1103515245
	i32.mul 	$push13=, $0, $pop85
	i32.const	$push84=, 12345
	i32.add 	$push83=, $pop13, $pop84
	tee_local	$push82=, $0=, $pop83
	i32.const	$push81=, 16
	i32.shr_u	$push14=, $pop82, $pop81
	i32.store8	$discard=, sQ+4($pop86):p2align=1, $pop14
	i32.const	$push80=, 0
	i32.const	$push79=, 1103515245
	i32.mul 	$push15=, $0, $pop79
	i32.const	$push78=, 12345
	i32.add 	$push77=, $pop15, $pop78
	tee_local	$push76=, $0=, $pop77
	i32.const	$push75=, 16
	i32.shr_u	$push16=, $pop76, $pop75
	i32.store8	$discard=, sQ+5($pop80), $pop16
	i32.const	$push74=, 0
	i32.const	$push73=, 1103515245
	i32.mul 	$push17=, $0, $pop73
	i32.const	$push72=, 12345
	i32.add 	$push71=, $pop17, $pop72
	tee_local	$push70=, $0=, $pop71
	i32.const	$push69=, 16
	i32.shr_u	$push18=, $pop70, $pop69
	i32.store8	$discard=, sQ+6($pop74):p2align=1, $pop18
	i32.const	$push68=, 0
	i32.const	$push67=, 1103515245
	i32.mul 	$push19=, $0, $pop67
	i32.const	$push66=, 12345
	i32.add 	$push65=, $pop19, $pop66
	tee_local	$push64=, $0=, $pop65
	i32.const	$push63=, 16
	i32.shr_u	$push20=, $pop64, $pop63
	i32.store8	$discard=, sQ+7($pop68), $pop20
	i32.const	$push62=, 0
	i32.const	$push61=, 1103515245
	i32.mul 	$push21=, $0, $pop61
	i32.const	$push60=, 12345
	i32.add 	$push59=, $pop21, $pop60
	tee_local	$push58=, $0=, $pop59
	i32.const	$push57=, 16
	i32.shr_u	$push22=, $pop58, $pop57
	i32.store8	$discard=, sQ+8($pop62):p2align=1, $pop22
	i32.const	$push56=, 0
	i32.const	$push55=, 1103515245
	i32.mul 	$push23=, $0, $pop55
	i32.const	$push54=, 12345
	i32.add 	$push53=, $pop23, $pop54
	tee_local	$push52=, $0=, $pop53
	i32.const	$push51=, 16
	i32.shr_u	$push24=, $pop52, $pop51
	i32.store8	$discard=, sQ+9($pop56), $pop24
	i32.const	$push50=, 0
	i32.const	$push49=, 0
	i32.const	$push26=, -341751747
	i32.mul 	$push27=, $0, $pop26
	i32.const	$push28=, 229283573
	i32.add 	$push48=, $pop27, $pop28
	tee_local	$push47=, $0=, $pop48
	i32.const	$push46=, 1103515245
	i32.mul 	$push32=, $pop47, $pop46
	i32.const	$push45=, 12345
	i32.add 	$push33=, $pop32, $pop45
	i32.store	$push34=, myrnd.s($pop49), $pop33
	i32.const	$push44=, 16
	i32.shr_u	$push35=, $pop34, $pop44
	i32.const	$push30=, 2047
	i32.and 	$push36=, $pop35, $pop30
	i32.const	$push43=, 16
	i32.shr_u	$push29=, $0, $pop43
	i32.const	$push42=, 2047
	i32.and 	$push31=, $pop29, $pop42
	i32.add 	$push39=, $pop36, $pop31
	i32.const	$push41=, 0
	i32.load16_u	$push25=, sQ($pop41)
	i32.const	$push37=, 61440
	i32.and 	$push38=, $pop25, $pop37
	i32.or  	$push40=, $pop39, $pop38
	i32.store16	$discard=, sQ($pop50), $pop40
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.add 	$push3=, $1, $pop1
	i32.load16_u	$2=, 0($pop3):p2align=0
	i64.load	$push0=, 0($1):p2align=0
	i64.store	$discard=, 0($0):p2align=0, $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i32.store16	$discard=, 0($pop2):p2align=0, $2
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
	i32.load16_u	$push1=, sR($pop0)
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 3
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
	i32.load16_u	$push1=, sR($pop0)
	i32.add 	$push2=, $pop1, $0
	i32.const	$push3=, 3
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
	i32.load16_u	$push1=, sR($pop0)
	i32.const	$push2=, 3
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
	i32.load16_u	$push9=, sR($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.add 	$push1=, $pop8, $0
	i32.const	$push4=, 3
	i32.and 	$push7=, $pop1, $pop4
	tee_local	$push6=, $0=, $pop7
	i32.const	$push2=, 65532
	i32.and 	$push3=, $1, $pop2
	i32.or  	$push5=, $pop6, $pop3
	i32.store16	$discard=, sR($pop0), $pop5
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
# BB#0:                                 # %if.end90
	i32.const	$push0=, 0
	i32.const	$push105=, 0
	i32.load	$push1=, myrnd.s($pop105)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push104=, $pop3, $pop4
	tee_local	$push103=, $1=, $pop104
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop103, $pop5
	i32.store8	$discard=, sR($pop0):p2align=1, $pop6
	i32.const	$push102=, 0
	i32.const	$push101=, 1103515245
	i32.mul 	$push7=, $1, $pop101
	i32.const	$push100=, 12345
	i32.add 	$push99=, $pop7, $pop100
	tee_local	$push98=, $1=, $pop99
	i32.const	$push97=, 16
	i32.shr_u	$push8=, $pop98, $pop97
	i32.store8	$discard=, sR+1($pop102), $pop8
	i32.const	$push96=, 0
	i32.const	$push95=, 1103515245
	i32.mul 	$push9=, $1, $pop95
	i32.const	$push94=, 12345
	i32.add 	$push93=, $pop9, $pop94
	tee_local	$push92=, $1=, $pop93
	i32.const	$push91=, 16
	i32.shr_u	$push10=, $pop92, $pop91
	i32.store8	$discard=, sR+2($pop96):p2align=1, $pop10
	i32.const	$push90=, 0
	i32.const	$push89=, 1103515245
	i32.mul 	$push11=, $1, $pop89
	i32.const	$push88=, 12345
	i32.add 	$push87=, $pop11, $pop88
	tee_local	$push86=, $1=, $pop87
	i32.const	$push85=, 16
	i32.shr_u	$push12=, $pop86, $pop85
	i32.store8	$discard=, sR+3($pop90), $pop12
	i32.const	$push84=, 0
	i32.const	$push83=, 1103515245
	i32.mul 	$push13=, $1, $pop83
	i32.const	$push82=, 12345
	i32.add 	$push81=, $pop13, $pop82
	tee_local	$push80=, $1=, $pop81
	i32.const	$push79=, 16
	i32.shr_u	$push14=, $pop80, $pop79
	i32.store8	$discard=, sR+4($pop84):p2align=1, $pop14
	i32.const	$push78=, 0
	i32.const	$push77=, 1103515245
	i32.mul 	$push15=, $1, $pop77
	i32.const	$push76=, 12345
	i32.add 	$push75=, $pop15, $pop76
	tee_local	$push74=, $1=, $pop75
	i32.const	$push73=, 16
	i32.shr_u	$push16=, $pop74, $pop73
	i32.store8	$discard=, sR+5($pop78), $pop16
	i32.const	$push72=, 0
	i32.const	$push71=, 1103515245
	i32.mul 	$push17=, $1, $pop71
	i32.const	$push70=, 12345
	i32.add 	$push69=, $pop17, $pop70
	tee_local	$push68=, $1=, $pop69
	i32.const	$push67=, 16
	i32.shr_u	$push18=, $pop68, $pop67
	i32.store8	$discard=, sR+6($pop72):p2align=1, $pop18
	i32.const	$push66=, 0
	i32.const	$push65=, 1103515245
	i32.mul 	$push19=, $1, $pop65
	i32.const	$push64=, 12345
	i32.add 	$push63=, $pop19, $pop64
	tee_local	$push62=, $1=, $pop63
	i32.const	$push61=, 16
	i32.shr_u	$push20=, $pop62, $pop61
	i32.store8	$discard=, sR+7($pop66), $pop20
	i32.const	$push60=, 0
	i32.const	$push59=, 1103515245
	i32.mul 	$push21=, $1, $pop59
	i32.const	$push58=, 12345
	i32.add 	$push57=, $pop21, $pop58
	tee_local	$push56=, $1=, $pop57
	i32.const	$push55=, 16
	i32.shr_u	$push22=, $pop56, $pop55
	i32.store8	$discard=, sR+8($pop60):p2align=1, $pop22
	i32.const	$push54=, 0
	i32.load16_u	$0=, sR($pop54)
	i32.const	$push53=, 0
	i32.const	$push52=, 1103515245
	i32.mul 	$push23=, $1, $pop52
	i32.const	$push51=, 12345
	i32.add 	$push50=, $pop23, $pop51
	tee_local	$push49=, $1=, $pop50
	i32.const	$push48=, 16
	i32.shr_u	$push24=, $pop49, $pop48
	i32.store8	$discard=, sR+9($pop53), $pop24
	i32.const	$push47=, 0
	i32.const	$push46=, 0
	i32.const	$push27=, -341751747
	i32.mul 	$push28=, $1, $pop27
	i32.const	$push29=, 229283573
	i32.add 	$push45=, $pop28, $pop29
	tee_local	$push44=, $1=, $pop45
	i32.const	$push43=, 1103515245
	i32.mul 	$push31=, $pop44, $pop43
	i32.const	$push42=, 12345
	i32.add 	$push32=, $pop31, $pop42
	i32.store	$push33=, myrnd.s($pop46), $pop32
	i32.const	$push41=, 16
	i32.shr_u	$push34=, $pop33, $pop41
	i32.const	$push40=, 16
	i32.shr_u	$push30=, $1, $pop40
	i32.add 	$push35=, $pop34, $pop30
	i32.const	$push36=, 3
	i32.and 	$push37=, $pop35, $pop36
	i32.const	$push25=, 65532
	i32.and 	$push26=, $0, $pop25
	i32.or  	$push38=, $pop37, $pop26
	i32.store16	$discard=, sR($pop47), $pop38
	block
	i32.const	$push39=, 1
	i32.const	$push106=, 0
	i32.eq  	$push107=, $pop39, $pop106
	br_if   	0, $pop107      # 0: down to label12
# BB#1:                                 # %if.end134
	return
.LBB108_2:                              # %if.then133
	end_block                       # label12:
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.add 	$push3=, $1, $pop1
	i32.load16_u	$2=, 0($pop3):p2align=0
	i64.load	$push0=, 0($1):p2align=0
	i64.store	$discard=, 0($0):p2align=0, $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i32.store16	$discard=, 0($pop2):p2align=0, $2
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
	i32.const	$push0=, 0
	i32.const	$push105=, 0
	i32.load	$push1=, myrnd.s($pop105)
	i32.const	$push2=, 1103515245
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 12345
	i32.add 	$push104=, $pop3, $pop4
	tee_local	$push103=, $1=, $pop104
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop103, $pop5
	i32.store8	$discard=, sS($pop0):p2align=1, $pop6
	i32.const	$push102=, 0
	i32.const	$push101=, 1103515245
	i32.mul 	$push7=, $1, $pop101
	i32.const	$push100=, 12345
	i32.add 	$push99=, $pop7, $pop100
	tee_local	$push98=, $1=, $pop99
	i32.const	$push97=, 16
	i32.shr_u	$push8=, $pop98, $pop97
	i32.store8	$discard=, sS+1($pop102), $pop8
	i32.const	$push96=, 0
	i32.const	$push95=, 1103515245
	i32.mul 	$push9=, $1, $pop95
	i32.const	$push94=, 12345
	i32.add 	$push93=, $pop9, $pop94
	tee_local	$push92=, $1=, $pop93
	i32.const	$push91=, 16
	i32.shr_u	$push10=, $pop92, $pop91
	i32.store8	$discard=, sS+2($pop96):p2align=1, $pop10
	i32.const	$push90=, 0
	i32.const	$push89=, 1103515245
	i32.mul 	$push11=, $1, $pop89
	i32.const	$push88=, 12345
	i32.add 	$push87=, $pop11, $pop88
	tee_local	$push86=, $1=, $pop87
	i32.const	$push85=, 16
	i32.shr_u	$push12=, $pop86, $pop85
	i32.store8	$discard=, sS+3($pop90), $pop12
	i32.const	$push84=, 0
	i32.const	$push83=, 1103515245
	i32.mul 	$push13=, $1, $pop83
	i32.const	$push82=, 12345
	i32.add 	$push81=, $pop13, $pop82
	tee_local	$push80=, $1=, $pop81
	i32.const	$push79=, 16
	i32.shr_u	$push14=, $pop80, $pop79
	i32.store8	$discard=, sS+4($pop84):p2align=1, $pop14
	i32.const	$push78=, 0
	i32.const	$push77=, 1103515245
	i32.mul 	$push15=, $1, $pop77
	i32.const	$push76=, 12345
	i32.add 	$push75=, $pop15, $pop76
	tee_local	$push74=, $1=, $pop75
	i32.const	$push73=, 16
	i32.shr_u	$push16=, $pop74, $pop73
	i32.store8	$discard=, sS+5($pop78), $pop16
	i32.const	$push72=, 0
	i32.const	$push71=, 1103515245
	i32.mul 	$push17=, $1, $pop71
	i32.const	$push70=, 12345
	i32.add 	$push69=, $pop17, $pop70
	tee_local	$push68=, $1=, $pop69
	i32.const	$push67=, 16
	i32.shr_u	$push18=, $pop68, $pop67
	i32.store8	$discard=, sS+6($pop72):p2align=1, $pop18
	i32.const	$push66=, 0
	i32.const	$push65=, 1103515245
	i32.mul 	$push19=, $1, $pop65
	i32.const	$push64=, 12345
	i32.add 	$push63=, $pop19, $pop64
	tee_local	$push62=, $1=, $pop63
	i32.const	$push61=, 16
	i32.shr_u	$push20=, $pop62, $pop61
	i32.store8	$discard=, sS+7($pop66), $pop20
	i32.const	$push60=, 0
	i32.const	$push59=, 1103515245
	i32.mul 	$push21=, $1, $pop59
	i32.const	$push58=, 12345
	i32.add 	$push57=, $pop21, $pop58
	tee_local	$push56=, $1=, $pop57
	i32.const	$push55=, 16
	i32.shr_u	$push22=, $pop56, $pop55
	i32.store8	$discard=, sS+8($pop60):p2align=1, $pop22
	i32.const	$push54=, 0
	i32.load16_u	$0=, sS($pop54)
	i32.const	$push53=, 0
	i32.const	$push52=, 1103515245
	i32.mul 	$push23=, $1, $pop52
	i32.const	$push51=, 12345
	i32.add 	$push50=, $pop23, $pop51
	tee_local	$push49=, $1=, $pop50
	i32.const	$push48=, 16
	i32.shr_u	$push24=, $pop49, $pop48
	i32.store8	$discard=, sS+9($pop53), $pop24
	i32.const	$push47=, 0
	i32.const	$push46=, 0
	i32.const	$push27=, -341751747
	i32.mul 	$push28=, $1, $pop27
	i32.const	$push29=, 229283573
	i32.add 	$push45=, $pop28, $pop29
	tee_local	$push44=, $1=, $pop45
	i32.const	$push43=, 1103515245
	i32.mul 	$push31=, $pop44, $pop43
	i32.const	$push42=, 12345
	i32.add 	$push32=, $pop31, $pop42
	i32.store	$push33=, myrnd.s($pop46), $pop32
	i32.const	$push41=, 16
	i32.shr_u	$push34=, $pop33, $pop41
	i32.const	$push40=, 16
	i32.shr_u	$push30=, $1, $pop40
	i32.add 	$push35=, $pop34, $pop30
	i32.const	$push36=, 1
	i32.and 	$push37=, $pop35, $pop36
	i32.const	$push25=, 65534
	i32.and 	$push26=, $0, $pop25
	i32.or  	$push38=, $pop37, $pop26
	i32.store16	$discard=, sS($pop47), $pop38
	block
	i32.const	$push39=, 1
	i32.const	$push106=, 0
	i32.eq  	$push107=, $pop39, $pop106
	br_if   	0, $pop107      # 0: down to label13
# BB#1:                                 # %if.end134
	return
.LBB114_2:                              # %if.then133
	end_block                       # label13:
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
	i32.load16_u	$push9=, sT($pop10):p2align=2
	tee_local	$push8=, $1=, $pop9
	i32.add 	$push1=, $pop8, $0
	i32.const	$push4=, 1
	i32.and 	$push7=, $pop1, $pop4
	tee_local	$push6=, $0=, $pop7
	i32.const	$push2=, 65534
	i32.and 	$push3=, $1, $pop2
	i32.or  	$push5=, $pop6, $pop3
	i32.store16	$discard=, sT($pop0):p2align=2, $pop5
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
	i32.const	$push77=, 0
	i32.const	$push76=, 0
	i32.load	$push1=, myrnd.s($pop76)
	i32.const	$push75=, 1103515245
	i32.mul 	$push2=, $pop1, $pop75
	i32.const	$push74=, 12345
	i32.add 	$push73=, $pop2, $pop74
	tee_local	$push72=, $0=, $pop73
	i32.const	$push71=, 16
	i32.shr_u	$push3=, $pop72, $pop71
	i32.store8	$discard=, sT($pop77):p2align=2, $pop3
	i32.const	$push70=, 0
	i32.const	$push69=, 1103515245
	i32.mul 	$push4=, $0, $pop69
	i32.const	$push68=, 12345
	i32.add 	$push67=, $pop4, $pop68
	tee_local	$push66=, $0=, $pop67
	i32.const	$push65=, 16
	i32.shr_u	$push5=, $pop66, $pop65
	i32.store8	$discard=, sT+1($pop70), $pop5
	i32.const	$push64=, 0
	i32.const	$push63=, 1103515245
	i32.mul 	$push6=, $0, $pop63
	i32.const	$push62=, 12345
	i32.add 	$push61=, $pop6, $pop62
	tee_local	$push60=, $0=, $pop61
	i32.const	$push59=, 16
	i32.shr_u	$push7=, $pop60, $pop59
	i32.store8	$discard=, sT+2($pop64):p2align=1, $pop7
	i32.const	$push58=, 0
	i32.const	$push57=, 1103515245
	i32.mul 	$push8=, $0, $pop57
	i32.const	$push56=, 12345
	i32.add 	$push55=, $pop8, $pop56
	tee_local	$push54=, $0=, $pop55
	i32.const	$push53=, 16
	i32.shr_u	$push9=, $pop54, $pop53
	i32.store8	$discard=, sT+3($pop58), $pop9
	i32.const	$push52=, 0
	i32.const	$push51=, 1103515245
	i32.mul 	$push11=, $0, $pop51
	i32.const	$push50=, 12345
	i32.add 	$push49=, $pop11, $pop50
	tee_local	$push48=, $3=, $pop49
	i32.const	$push47=, 16
	i32.shr_u	$push46=, $pop48, $pop47
	tee_local	$push45=, $2=, $pop46
	i32.const	$push44=, 1
	i32.and 	$push13=, $pop45, $pop44
	i32.const	$push43=, 0
	i32.load16_u	$push10=, sT($pop43):p2align=2
	i32.const	$push42=, 65534
	i32.and 	$push14=, $pop10, $pop42
	i32.or  	$push15=, $pop13, $pop14
	i32.store16	$discard=, sT($pop52):p2align=2, $pop15
	i32.const	$push41=, 0
	i32.load	$0=, sT($pop41)
	block
	block
	i32.const	$push40=, 0
	i32.const	$push39=, 1103515245
	i32.mul 	$push12=, $3, $pop39
	i32.const	$push38=, 12345
	i32.add 	$push0=, $pop12, $pop38
	i32.store	$push37=, myrnd.s($pop40), $pop0
	tee_local	$push36=, $1=, $pop37
	i32.const	$push35=, 16
	i32.shr_u	$push34=, $pop36, $pop35
	tee_local	$push33=, $3=, $pop34
	i32.add 	$push17=, $pop33, $2
	i32.add 	$push16=, $3, $0
	i32.xor 	$push18=, $pop17, $pop16
	i32.const	$push32=, 1
	i32.and 	$push19=, $pop18, $pop32
	br_if   	0, $pop19       # 0: down to label15
# BB#1:                                 # %if.end94
	i32.const	$push88=, 0
	i32.const	$push87=, 0
	i32.const	$push21=, -2139243339
	i32.mul 	$push22=, $1, $pop21
	i32.const	$push23=, -1492899873
	i32.add 	$push86=, $pop22, $pop23
	tee_local	$push85=, $3=, $pop86
	i32.const	$push84=, 1103515245
	i32.mul 	$push25=, $pop85, $pop84
	i32.const	$push83=, 12345
	i32.add 	$push26=, $pop25, $pop83
	i32.store	$push27=, myrnd.s($pop87), $pop26
	i32.const	$push82=, 16
	i32.shr_u	$push28=, $pop27, $pop82
	i32.const	$push81=, 16
	i32.shr_u	$push24=, $3, $pop81
	i32.add 	$push29=, $pop28, $pop24
	i32.const	$push80=, 1
	i32.and 	$push30=, $pop29, $pop80
	i32.const	$push79=, 65534
	i32.and 	$push20=, $0, $pop79
	i32.or  	$push31=, $pop30, $pop20
	i32.store16	$discard=, sT($pop88):p2align=2, $pop31
	i32.const	$push78=, 1
	i32.const	$push89=, 0
	i32.eq  	$push90=, $pop78, $pop89
	br_if   	1, $pop90       # 1: down to label14
# BB#2:                                 # %if.end140
	return
.LBB120_3:                              # %if.then
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB120_4:                              # %if.then139
	end_block                       # label14:
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 8
	i32.add 	$push3=, $1, $pop1
	i32.load16_u	$2=, 0($pop3):p2align=0
	i64.load	$push0=, 0($1):p2align=0
	i64.store	$discard=, 0($0):p2align=0, $pop0
	i32.const	$push4=, 8
	i32.add 	$push2=, $0, $pop4
	i32.store16	$discard=, 0($pop2):p2align=0, $2
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
	i32.const	$push2=, 0
	i32.const	$push168=, 0
	i32.load	$push3=, myrnd.s($pop168)
	i32.const	$push4=, 1103515245
	i32.mul 	$push5=, $pop3, $pop4
	i32.const	$push6=, 12345
	i32.add 	$push167=, $pop5, $pop6
	tee_local	$push166=, $2=, $pop167
	i32.const	$push165=, 16
	i32.shr_u	$push7=, $pop166, $pop165
	i32.store8	$discard=, sU($pop2):p2align=1, $pop7
	i32.const	$push164=, 0
	i32.const	$push163=, 1103515245
	i32.mul 	$push8=, $2, $pop163
	i32.const	$push162=, 12345
	i32.add 	$push161=, $pop8, $pop162
	tee_local	$push160=, $2=, $pop161
	i32.const	$push159=, 16
	i32.shr_u	$push9=, $pop160, $pop159
	i32.store8	$discard=, sU+1($pop164), $pop9
	i32.const	$push158=, 0
	i32.const	$push157=, 1103515245
	i32.mul 	$push10=, $2, $pop157
	i32.const	$push156=, 12345
	i32.add 	$push155=, $pop10, $pop156
	tee_local	$push154=, $2=, $pop155
	i32.const	$push153=, 16
	i32.shr_u	$push11=, $pop154, $pop153
	i32.store8	$discard=, sU+2($pop158):p2align=1, $pop11
	i32.const	$push152=, 0
	i32.const	$push151=, 1103515245
	i32.mul 	$push12=, $2, $pop151
	i32.const	$push150=, 12345
	i32.add 	$push149=, $pop12, $pop150
	tee_local	$push148=, $2=, $pop149
	i32.const	$push147=, 16
	i32.shr_u	$push13=, $pop148, $pop147
	i32.store8	$discard=, sU+3($pop152), $pop13
	i32.const	$push146=, 0
	i32.const	$push145=, 1103515245
	i32.mul 	$push14=, $2, $pop145
	i32.const	$push144=, 12345
	i32.add 	$push143=, $pop14, $pop144
	tee_local	$push142=, $2=, $pop143
	i32.const	$push141=, 16
	i32.shr_u	$push15=, $pop142, $pop141
	i32.store8	$discard=, sU+4($pop146):p2align=1, $pop15
	i32.const	$push140=, 0
	i32.const	$push139=, 1103515245
	i32.mul 	$push16=, $2, $pop139
	i32.const	$push138=, 12345
	i32.add 	$push137=, $pop16, $pop138
	tee_local	$push136=, $2=, $pop137
	i32.const	$push135=, 16
	i32.shr_u	$push17=, $pop136, $pop135
	i32.store8	$discard=, sU+5($pop140), $pop17
	i32.const	$push134=, 0
	i32.const	$push133=, 1103515245
	i32.mul 	$push18=, $2, $pop133
	i32.const	$push132=, 12345
	i32.add 	$push131=, $pop18, $pop132
	tee_local	$push130=, $2=, $pop131
	i32.const	$push129=, 16
	i32.shr_u	$push19=, $pop130, $pop129
	i32.store8	$discard=, sU+6($pop134):p2align=1, $pop19
	i32.const	$push128=, 0
	i32.const	$push127=, 1103515245
	i32.mul 	$push20=, $2, $pop127
	i32.const	$push126=, 12345
	i32.add 	$push125=, $pop20, $pop126
	tee_local	$push124=, $2=, $pop125
	i32.const	$push123=, 16
	i32.shr_u	$push21=, $pop124, $pop123
	i32.store8	$discard=, sU+7($pop128), $pop21
	i32.const	$push122=, 0
	i32.const	$push121=, 1103515245
	i32.mul 	$push22=, $2, $pop121
	i32.const	$push120=, 12345
	i32.add 	$push119=, $pop22, $pop120
	tee_local	$push118=, $2=, $pop119
	i32.const	$push117=, 16
	i32.shr_u	$push23=, $pop118, $pop117
	i32.store8	$discard=, sU+8($pop122):p2align=1, $pop23
	i32.const	$push116=, 0
	i32.const	$push115=, 1103515245
	i32.mul 	$push24=, $2, $pop115
	i32.const	$push114=, 12345
	i32.add 	$push113=, $pop24, $pop114
	tee_local	$push112=, $2=, $pop113
	i32.const	$push111=, 16
	i32.shr_u	$push25=, $pop112, $pop111
	i32.store8	$discard=, sU+9($pop116), $pop25
	i32.const	$push110=, 0
	i32.load16_u	$0=, sU($pop110)
	i32.const	$push109=, 0
	i32.const	$push108=, 1103515245
	i32.mul 	$push26=, $2, $pop108
	i32.const	$push107=, 12345
	i32.add 	$push106=, $pop26, $pop107
	tee_local	$push105=, $2=, $pop106
	i32.const	$push104=, 1103515245
	i32.mul 	$push28=, $pop105, $pop104
	i32.const	$push103=, 12345
	i32.add 	$push0=, $pop28, $pop103
	i32.store	$1=, myrnd.s($pop109), $pop0
	i32.const	$push102=, 0
	i32.const	$push101=, 16
	i32.shr_u	$push100=, $2, $pop101
	tee_local	$push99=, $4=, $pop100
	i32.const	$push27=, 2047
	i32.and 	$push98=, $pop99, $pop27
	tee_local	$push97=, $3=, $pop98
	i32.const	$push29=, 6
	i32.shl 	$push30=, $pop97, $pop29
	i32.const	$push31=, 64
	i32.and 	$push32=, $pop30, $pop31
	i32.const	$push33=, -65
	i32.and 	$push96=, $0, $pop33
	tee_local	$push95=, $2=, $pop96
	i32.or  	$push94=, $pop32, $pop95
	tee_local	$push93=, $0=, $pop94
	i32.store16	$discard=, sU($pop102), $pop93
	block
	block
	block
	i32.const	$push34=, 65472
	i32.and 	$push35=, $0, $pop34
	i32.const	$push92=, 6
	i32.shr_u	$push91=, $pop35, $pop92
	tee_local	$push90=, $0=, $pop91
	i32.xor 	$push36=, $pop90, $3
	i32.const	$push89=, 1
	i32.and 	$push37=, $pop36, $pop89
	br_if   	0, $pop37       # 0: down to label18
# BB#1:                                 # %lor.lhs.false41
	i32.const	$push172=, 16
	i32.shr_u	$push171=, $1, $pop172
	tee_local	$push170=, $3=, $pop171
	i32.add 	$push38=, $0, $pop170
	i32.add 	$push39=, $3, $4
	i32.xor 	$push40=, $pop38, $pop39
	i32.const	$push169=, 1
	i32.and 	$push41=, $pop40, $pop169
	br_if   	0, $pop41       # 0: down to label18
# BB#2:                                 # %if.end
	i32.const	$push47=, 0
	i32.const	$push42=, 1103515245
	i32.mul 	$push43=, $1, $pop42
	i32.const	$push44=, 12345
	i32.add 	$push188=, $pop43, $pop44
	tee_local	$push187=, $0=, $pop188
	i32.const	$push186=, 1103515245
	i32.mul 	$push46=, $pop187, $pop186
	i32.const	$push185=, 12345
	i32.add 	$push1=, $pop46, $pop185
	i32.store	$1=, myrnd.s($pop47), $pop1
	i32.const	$push184=, 0
	i32.const	$push183=, 16
	i32.shr_u	$push182=, $0, $pop183
	tee_local	$push181=, $4=, $pop182
	i32.const	$push45=, 2047
	i32.and 	$push180=, $pop181, $pop45
	tee_local	$push179=, $0=, $pop180
	i32.const	$push48=, 6
	i32.shl 	$push49=, $pop179, $pop48
	i32.const	$push50=, 64
	i32.and 	$push51=, $pop49, $pop50
	i32.or  	$push178=, $pop51, $2
	tee_local	$push177=, $3=, $pop178
	i32.store16	$discard=, sU($pop184), $pop177
	i32.const	$push52=, 65472
	i32.and 	$push53=, $3, $pop52
	i32.const	$push176=, 6
	i32.shr_u	$push175=, $pop53, $pop176
	tee_local	$push174=, $3=, $pop175
	i32.xor 	$push54=, $pop174, $0
	i32.const	$push173=, 1
	i32.and 	$push55=, $pop54, $pop173
	br_if   	1, $pop55       # 1: down to label17
# BB#3:                                 # %lor.lhs.false85
	i32.const	$push194=, 16
	i32.shr_u	$push193=, $1, $pop194
	tee_local	$push192=, $0=, $pop193
	i32.add 	$push56=, $3, $pop192
	i32.const	$push191=, 1
	i32.and 	$push57=, $pop56, $pop191
	i32.const	$push58=, 15
	i32.rem_u	$push59=, $pop57, $pop58
	i32.add 	$push60=, $0, $4
	i32.const	$push190=, 1
	i32.and 	$push61=, $pop60, $pop190
	i32.const	$push189=, 15
	i32.rem_u	$push62=, $pop61, $pop189
	i32.ne  	$push63=, $pop59, $pop62
	br_if   	1, $pop63       # 1: down to label17
# BB#4:                                 # %lor.lhs.false130
	i32.const	$push71=, 0
	i32.const	$push64=, 1103515245
	i32.mul 	$push65=, $1, $pop64
	i32.const	$push66=, 12345
	i32.add 	$push206=, $pop65, $pop66
	tee_local	$push205=, $1=, $pop206
	i32.const	$push73=, 10
	i32.shr_u	$push74=, $pop205, $pop73
	i32.const	$push75=, 64
	i32.and 	$push76=, $pop74, $pop75
	i32.or  	$push77=, $pop76, $2
	i32.const	$push78=, 65472
	i32.and 	$push79=, $pop77, $pop78
	i32.const	$push80=, 6
	i32.shr_u	$push81=, $pop79, $pop80
	i32.const	$push204=, 0
	i32.const	$push203=, 1103515245
	i32.mul 	$push69=, $1, $pop203
	i32.const	$push202=, 12345
	i32.add 	$push70=, $pop69, $pop202
	i32.store	$push72=, myrnd.s($pop204), $pop70
	i32.const	$push67=, 16
	i32.shr_u	$push201=, $pop72, $pop67
	tee_local	$push200=, $0=, $pop201
	i32.add 	$push199=, $pop81, $pop200
	tee_local	$push198=, $3=, $pop199
	i32.const	$push197=, 6
	i32.shl 	$push82=, $pop198, $pop197
	i32.const	$push196=, 64
	i32.and 	$push83=, $pop82, $pop196
	i32.or  	$push84=, $pop83, $2
	i32.store16	$discard=, sU($pop71), $pop84
	i32.const	$push195=, 16
	i32.shr_u	$push68=, $1, $pop195
	i32.add 	$push85=, $0, $pop68
	i32.xor 	$push86=, $pop85, $3
	i32.const	$push87=, 1
	i32.and 	$push88=, $pop86, $pop87
	br_if   	2, $pop88       # 2: down to label16
# BB#5:                                 # %if.end136
	return
.LBB126_6:                              # %if.then
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
.LBB126_7:                              # %if.then91
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB126_8:                              # %if.then135
	end_block                       # label16:
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
	i32.load16_u	$push15=, sV($pop16):p2align=2
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
	i32.store16	$discard=, sV($pop0):p2align=2, $pop8
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
	i32.const	$push109=, 0
	i32.const	$push108=, 0
	i32.load	$push2=, myrnd.s($pop108)
	i32.const	$push107=, 1103515245
	i32.mul 	$push3=, $pop2, $pop107
	i32.const	$push106=, 12345
	i32.add 	$push105=, $pop3, $pop106
	tee_local	$push104=, $0=, $pop105
	i32.const	$push103=, 16
	i32.shr_u	$push4=, $pop104, $pop103
	i32.store8	$discard=, sV($pop109):p2align=2, $pop4
	i32.const	$push102=, 0
	i32.const	$push101=, 1103515245
	i32.mul 	$push5=, $0, $pop101
	i32.const	$push100=, 12345
	i32.add 	$push99=, $pop5, $pop100
	tee_local	$push98=, $0=, $pop99
	i32.const	$push97=, 16
	i32.shr_u	$push6=, $pop98, $pop97
	i32.store8	$discard=, sV+1($pop102), $pop6
	i32.const	$push96=, 0
	i32.const	$push95=, 1103515245
	i32.mul 	$push7=, $0, $pop95
	i32.const	$push94=, 12345
	i32.add 	$push93=, $pop7, $pop94
	tee_local	$push92=, $0=, $pop93
	i32.const	$push91=, 16
	i32.shr_u	$push8=, $pop92, $pop91
	i32.store8	$discard=, sV+2($pop96):p2align=1, $pop8
	i32.const	$push90=, 0
	i32.const	$push89=, 1103515245
	i32.mul 	$push9=, $0, $pop89
	i32.const	$push88=, 12345
	i32.add 	$push87=, $pop9, $pop88
	tee_local	$push86=, $0=, $pop87
	i32.const	$push85=, 16
	i32.shr_u	$push10=, $pop86, $pop85
	i32.store8	$discard=, sV+3($pop90), $pop10
	i32.const	$push84=, 0
	i32.const	$push83=, 1103515245
	i32.mul 	$push12=, $0, $pop83
	i32.const	$push82=, 12345
	i32.add 	$push81=, $pop12, $pop82
	tee_local	$push80=, $3=, $pop81
	i32.const	$push79=, 8
	i32.shr_u	$push15=, $pop80, $pop79
	i32.const	$push78=, 256
	i32.and 	$push16=, $pop15, $pop78
	i32.const	$push77=, 0
	i32.load16_u	$push11=, sV($pop77):p2align=2
	i32.const	$push76=, 65279
	i32.and 	$push17=, $pop11, $pop76
	i32.or  	$push18=, $pop16, $pop17
	i32.store16	$discard=, sV($pop84):p2align=2, $pop18
	i32.const	$push75=, 0
	i32.load	$0=, sV($pop75)
	block
	block
	i32.const	$push74=, 0
	i32.const	$push73=, 1103515245
	i32.mul 	$push14=, $3, $pop73
	i32.const	$push72=, 12345
	i32.add 	$push0=, $pop14, $pop72
	i32.store	$push71=, myrnd.s($pop74), $pop0
	tee_local	$push70=, $2=, $pop71
	i32.const	$push69=, 16
	i32.shr_u	$push68=, $pop70, $pop69
	tee_local	$push67=, $1=, $pop68
	i32.const	$push66=, 16
	i32.shr_u	$push13=, $3, $pop66
	i32.add 	$push21=, $pop67, $pop13
	i32.const	$push65=, 8
	i32.shr_u	$push19=, $0, $pop65
	i32.add 	$push20=, $pop19, $1
	i32.xor 	$push22=, $pop21, $pop20
	i32.const	$push64=, 1
	i32.and 	$push23=, $pop22, $pop64
	br_if   	0, $pop23       # 0: down to label20
# BB#1:                                 # %if.end
	i32.const	$push130=, 0
	i32.const	$push129=, 1103515245
	i32.mul 	$push24=, $2, $pop129
	i32.const	$push128=, 12345
	i32.add 	$push127=, $pop24, $pop128
	tee_local	$push126=, $1=, $pop127
	i32.const	$push125=, 1103515245
	i32.mul 	$push26=, $pop126, $pop125
	i32.const	$push124=, 12345
	i32.add 	$push1=, $pop26, $pop124
	i32.store	$3=, myrnd.s($pop130), $pop1
	i32.const	$push123=, 0
	i32.const	$push122=, 16
	i32.shr_u	$push121=, $1, $pop122
	tee_local	$push120=, $4=, $pop121
	i32.const	$push25=, 2047
	i32.and 	$push119=, $pop120, $pop25
	tee_local	$push118=, $1=, $pop119
	i32.const	$push117=, 8
	i32.shl 	$push27=, $pop118, $pop117
	i32.const	$push116=, 256
	i32.and 	$push28=, $pop27, $pop116
	i32.const	$push29=, -257
	i32.and 	$push30=, $0, $pop29
	i32.or  	$push115=, $pop28, $pop30
	tee_local	$push114=, $2=, $pop115
	i32.store16	$discard=, sV($pop123):p2align=2, $pop114
	block
	i32.const	$push31=, 65280
	i32.and 	$push32=, $2, $pop31
	i32.const	$push113=, 8
	i32.shr_u	$push112=, $pop32, $pop113
	tee_local	$push111=, $2=, $pop112
	i32.xor 	$push33=, $pop111, $1
	i32.const	$push110=, 1
	i32.and 	$push34=, $pop33, $pop110
	br_if   	0, $pop34       # 0: down to label21
# BB#2:                                 # %lor.lhs.false89
	i32.const	$push136=, 16
	i32.shr_u	$push135=, $3, $pop136
	tee_local	$push134=, $1=, $pop135
	i32.add 	$push35=, $2, $pop134
	i32.const	$push133=, 1
	i32.and 	$push36=, $pop35, $pop133
	i32.const	$push37=, 15
	i32.rem_u	$push38=, $pop36, $pop37
	i32.add 	$push39=, $1, $4
	i32.const	$push132=, 1
	i32.and 	$push40=, $pop39, $pop132
	i32.const	$push131=, 15
	i32.rem_u	$push41=, $pop40, $pop131
	i32.ne  	$push42=, $pop38, $pop41
	br_if   	0, $pop42       # 0: down to label21
# BB#3:                                 # %lor.lhs.false136
	i32.const	$push50=, 0
	i32.const	$push43=, 1103515245
	i32.mul 	$push44=, $3, $pop43
	i32.const	$push45=, 12345
	i32.add 	$push153=, $pop44, $pop45
	tee_local	$push152=, $3=, $pop153
	i32.const	$push52=, 8
	i32.shr_u	$push53=, $pop152, $pop52
	i32.const	$push54=, 256
	i32.and 	$push55=, $pop53, $pop54
	i32.const	$push151=, 65279
	i32.and 	$push150=, $0, $pop151
	tee_local	$push149=, $0=, $pop150
	i32.or  	$push56=, $pop55, $pop149
	i32.const	$push148=, 8
	i32.shr_u	$push57=, $pop56, $pop148
	i32.const	$push147=, 0
	i32.const	$push146=, 1103515245
	i32.mul 	$push48=, $3, $pop146
	i32.const	$push145=, 12345
	i32.add 	$push49=, $pop48, $pop145
	i32.store	$push51=, myrnd.s($pop147), $pop49
	i32.const	$push46=, 16
	i32.shr_u	$push144=, $pop51, $pop46
	tee_local	$push143=, $1=, $pop144
	i32.add 	$push142=, $pop57, $pop143
	tee_local	$push141=, $2=, $pop142
	i32.const	$push140=, 8
	i32.shl 	$push58=, $pop141, $pop140
	i32.const	$push139=, 256
	i32.and 	$push59=, $pop58, $pop139
	i32.or  	$push60=, $pop59, $0
	i32.store16	$discard=, sV($pop50):p2align=2, $pop60
	i32.const	$push138=, 16
	i32.shr_u	$push47=, $3, $pop138
	i32.add 	$push61=, $1, $pop47
	i32.xor 	$push62=, $pop61, $2
	i32.const	$push137=, 1
	i32.and 	$push63=, $pop62, $pop137
	br_if   	2, $pop63       # 2: down to label19
# BB#4:                                 # %if.end142
	return
.LBB132_5:                              # %if.then95
	end_block                       # label21:
	call    	abort@FUNCTION
	unreachable
.LBB132_6:                              # %if.then
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
.LBB132_7:                              # %if.then141
	end_block                       # label19:
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
	.local  	i32, i64
# BB#0:                                 # %entry
	i32.const	$push1=, 16
	i32.add 	$push3=, $1, $pop1
	i32.load	$2=, 0($pop3):p2align=0
	i32.const	$push4=, 8
	i32.add 	$push6=, $1, $pop4
	i64.load	$3=, 0($pop6):p2align=0
	i64.load	$push0=, 0($1):p2align=0
	i64.store	$discard=, 0($0):p2align=0, $pop0
	i32.const	$push8=, 16
	i32.add 	$push2=, $0, $pop8
	i32.store	$discard=, 0($pop2):p2align=0, $2
	i32.const	$push7=, 8
	i32.add 	$push5=, $0, $pop7
	i64.store	$discard=, 0($pop5):p2align=0, $3
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
	i32.load	$push9=, sW+16($pop10):p2align=4
	tee_local	$push8=, $1=, $pop9
	i32.add 	$push1=, $pop8, $0
	i32.const	$push2=, 4095
	i32.and 	$push7=, $pop1, $pop2
	tee_local	$push6=, $0=, $pop7
	i32.const	$push3=, -4096
	i32.and 	$push4=, $1, $pop3
	i32.or  	$push5=, $pop6, $pop4
	i32.store	$discard=, sW+16($pop0):p2align=4, $pop5
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
	i32.const	$push98=, 0
	i32.load	$push1=, myrnd.s($pop98)
	i32.const	$push2=, 1670464429
	i32.mul 	$push3=, $pop1, $pop2
	i32.const	$push4=, 2121308585
	i32.add 	$push97=, $pop3, $pop4
	tee_local	$push96=, $0=, $pop97
	i32.const	$push5=, 16
	i32.shr_u	$push6=, $pop96, $pop5
	i32.store8	$discard=, sW+16($pop0):p2align=4, $pop6
	i32.const	$push95=, 0
	i32.const	$push7=, 1103515245
	i32.mul 	$push8=, $0, $pop7
	i32.const	$push9=, 12345
	i32.add 	$push94=, $pop8, $pop9
	tee_local	$push93=, $0=, $pop94
	i32.const	$push92=, 16
	i32.shr_u	$push10=, $pop93, $pop92
	i32.store8	$discard=, sW+17($pop95), $pop10
	i32.const	$push91=, 0
	i32.const	$push90=, 1103515245
	i32.mul 	$push11=, $0, $pop90
	i32.const	$push89=, 12345
	i32.add 	$push88=, $pop11, $pop89
	tee_local	$push87=, $0=, $pop88
	i32.const	$push86=, 16
	i32.shr_u	$push12=, $pop87, $pop86
	i32.store8	$discard=, sW+18($pop91):p2align=1, $pop12
	i32.const	$push85=, 0
	i32.const	$push84=, 1103515245
	i32.mul 	$push13=, $0, $pop84
	i32.const	$push83=, 12345
	i32.add 	$push82=, $pop13, $pop83
	tee_local	$push81=, $0=, $pop82
	i32.const	$push80=, 16
	i32.shr_u	$push14=, $pop81, $pop80
	i32.store8	$discard=, sW+19($pop85), $pop14
	i32.const	$push79=, 0
	i32.const	$push78=, 1103515245
	i32.mul 	$push18=, $0, $pop78
	i32.const	$push77=, 12345
	i32.add 	$push76=, $pop18, $pop77
	tee_local	$push75=, $1=, $pop76
	i32.const	$push74=, 16
	i32.shr_u	$push19=, $pop75, $pop74
	i32.const	$push20=, 2047
	i32.and 	$push21=, $pop19, $pop20
	i32.const	$push73=, 0
	i32.load	$push17=, sW+16($pop73):p2align=4
	i32.const	$push25=, -4096
	i32.and 	$push72=, $pop17, $pop25
	tee_local	$push71=, $0=, $pop72
	i32.or  	$push26=, $pop21, $pop71
	i32.store	$discard=, sW+16($pop79):p2align=4, $pop26
	i32.const	$push70=, 0
	i32.const	$push69=, 0
	i32.const	$push68=, 1103515245
	i32.mul 	$push22=, $1, $pop68
	i32.const	$push67=, 12345
	i32.add 	$push23=, $pop22, $pop67
	i32.store	$push24=, myrnd.s($pop69), $pop23
	i32.const	$push66=, 1103515245
	i32.mul 	$push27=, $pop24, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push64=, $pop27, $pop65
	tee_local	$push63=, $1=, $pop64
	i32.const	$push62=, 16
	i32.shr_u	$push28=, $pop63, $pop62
	i32.const	$push61=, 2047
	i32.and 	$push29=, $pop28, $pop61
	i32.or  	$push33=, $pop29, $0
	i32.store	$discard=, sW+16($pop70):p2align=4, $pop33
	i32.const	$push60=, 0
	i32.const	$push59=, 0
	i32.const	$push58=, 0
	i32.const	$push57=, 1103515245
	i32.mul 	$push30=, $1, $pop57
	i32.const	$push56=, 12345
	i32.add 	$push31=, $pop30, $pop56
	i32.store	$push32=, myrnd.s($pop58), $pop31
	i32.const	$push55=, 1103515245
	i32.mul 	$push34=, $pop32, $pop55
	i32.const	$push54=, 12345
	i32.add 	$push53=, $pop34, $pop54
	tee_local	$push52=, $1=, $pop53
	i32.const	$push51=, 1103515245
	i32.mul 	$push37=, $pop52, $pop51
	i32.const	$push50=, 12345
	i32.add 	$push38=, $pop37, $pop50
	i32.store	$push39=, myrnd.s($pop59), $pop38
	i32.const	$push49=, 16
	i32.shr_u	$push40=, $pop39, $pop49
	i32.const	$push48=, 2047
	i32.and 	$push41=, $pop40, $pop48
	i32.const	$push47=, 16
	i32.shr_u	$push35=, $1, $pop47
	i32.const	$push46=, 2047
	i32.and 	$push36=, $pop35, $pop46
	i32.add 	$push42=, $pop41, $pop36
	i32.or  	$push43=, $pop42, $0
	i32.store	$discard=, sW+16($pop60):p2align=4, $pop43
	i32.const	$push45=, 0
	i64.const	$push15=, 4612055454334320640
	i64.store	$discard=, sW+8($pop45), $pop15
	i32.const	$push44=, 0
	i64.const	$push16=, 0
	i64.store	$discard=, sW($pop44):p2align=4, $pop16
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
	.local  	i32, i64
# BB#0:                                 # %entry
	i32.const	$push1=, 16
	i32.add 	$push3=, $1, $pop1
	i32.load	$2=, 0($pop3):p2align=0
	i32.const	$push4=, 8
	i32.add 	$push6=, $1, $pop4
	i64.load	$3=, 0($pop6):p2align=0
	i64.load	$push0=, 0($1):p2align=0
	i64.store	$discard=, 0($0):p2align=0, $pop0
	i32.const	$push8=, 16
	i32.add 	$push2=, $0, $pop8
	i32.store	$discard=, 0($pop2):p2align=0, $2
	i32.const	$push7=, 8
	i32.add 	$push5=, $0, $pop7
	i64.store	$discard=, 0($pop5):p2align=0, $3
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
	i32.store8	$discard=, sX($pop0):p2align=2, $pop6
	i32.const	$push95=, 0
	i32.const	$push94=, 1103515245
	i32.mul 	$push7=, $0, $pop94
	i32.const	$push93=, 12345
	i32.add 	$push92=, $pop7, $pop93
	tee_local	$push91=, $0=, $pop92
	i32.const	$push90=, 16
	i32.shr_u	$push8=, $pop91, $pop90
	i32.store8	$discard=, sX+1($pop95), $pop8
	i32.const	$push89=, 0
	i32.const	$push88=, 1103515245
	i32.mul 	$push9=, $0, $pop88
	i32.const	$push87=, 12345
	i32.add 	$push86=, $pop9, $pop87
	tee_local	$push85=, $0=, $pop86
	i32.const	$push84=, 16
	i32.shr_u	$push10=, $pop85, $pop84
	i32.store8	$discard=, sX+2($pop89):p2align=1, $pop10
	i32.const	$push83=, 0
	i32.const	$push82=, 1103515245
	i32.mul 	$push11=, $0, $pop82
	i32.const	$push81=, 12345
	i32.add 	$push80=, $pop11, $pop81
	tee_local	$push79=, $0=, $pop80
	i32.const	$push78=, 16
	i32.shr_u	$push12=, $pop79, $pop78
	i32.store8	$discard=, sX+3($pop83), $pop12
	i32.const	$push77=, 0
	i32.const	$push16=, 1670464429
	i32.mul 	$push17=, $0, $pop16
	i32.const	$push18=, 2121308585
	i32.add 	$push76=, $pop17, $pop18
	tee_local	$push75=, $1=, $pop76
	i32.const	$push74=, 16
	i32.shr_u	$push19=, $pop75, $pop74
	i32.const	$push20=, 2047
	i32.and 	$push21=, $pop19, $pop20
	i32.const	$push73=, 0
	i32.load	$push15=, sX($pop73)
	i32.const	$push25=, -4096
	i32.and 	$push72=, $pop15, $pop25
	tee_local	$push71=, $0=, $pop72
	i32.or  	$push26=, $pop21, $pop71
	i32.store	$discard=, sX($pop77), $pop26
	i32.const	$push70=, 0
	i32.const	$push69=, 0
	i32.const	$push68=, 1103515245
	i32.mul 	$push22=, $1, $pop68
	i32.const	$push67=, 12345
	i32.add 	$push23=, $pop22, $pop67
	i32.store	$push24=, myrnd.s($pop69), $pop23
	i32.const	$push66=, 1103515245
	i32.mul 	$push27=, $pop24, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push64=, $pop27, $pop65
	tee_local	$push63=, $1=, $pop64
	i32.const	$push62=, 16
	i32.shr_u	$push28=, $pop63, $pop62
	i32.const	$push61=, 2047
	i32.and 	$push29=, $pop28, $pop61
	i32.or  	$push33=, $pop29, $0
	i32.store	$discard=, sX($pop70), $pop33
	i32.const	$push60=, 0
	i32.const	$push59=, 0
	i32.const	$push58=, 0
	i32.const	$push57=, 1103515245
	i32.mul 	$push30=, $1, $pop57
	i32.const	$push56=, 12345
	i32.add 	$push31=, $pop30, $pop56
	i32.store	$push32=, myrnd.s($pop58), $pop31
	i32.const	$push55=, 1103515245
	i32.mul 	$push34=, $pop32, $pop55
	i32.const	$push54=, 12345
	i32.add 	$push53=, $pop34, $pop54
	tee_local	$push52=, $1=, $pop53
	i32.const	$push51=, 1103515245
	i32.mul 	$push37=, $pop52, $pop51
	i32.const	$push50=, 12345
	i32.add 	$push38=, $pop37, $pop50
	i32.store	$push39=, myrnd.s($pop59), $pop38
	i32.const	$push49=, 16
	i32.shr_u	$push40=, $pop39, $pop49
	i32.const	$push48=, 2047
	i32.and 	$push41=, $pop40, $pop48
	i32.const	$push47=, 16
	i32.shr_u	$push35=, $1, $pop47
	i32.const	$push46=, 2047
	i32.and 	$push36=, $pop35, $pop46
	i32.add 	$push42=, $pop41, $pop36
	i32.or  	$push43=, $pop42, $0
	i32.store	$discard=, sX($pop60), $pop43
	i32.const	$push45=, 0
	i64.const	$push13=, 4612055454334320640
	i64.store	$discard=, sX+12($pop45):p2align=2, $pop13
	i32.const	$push44=, 0
	i64.const	$push14=, 0
	i64.store	$discard=, sX+4($pop44):p2align=2, $pop14
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
	.local  	i32, i64
# BB#0:                                 # %entry
	i32.const	$push1=, 16
	i32.add 	$push3=, $1, $pop1
	i32.load	$2=, 0($pop3):p2align=0
	i32.const	$push4=, 8
	i32.add 	$push6=, $1, $pop4
	i64.load	$3=, 0($pop6):p2align=0
	i64.load	$push0=, 0($1):p2align=0
	i64.store	$discard=, 0($0):p2align=0, $pop0
	i32.const	$push8=, 16
	i32.add 	$push2=, $0, $pop8
	i32.store	$discard=, 0($pop2):p2align=0, $2
	i32.const	$push7=, 8
	i32.add 	$push5=, $0, $pop7
	i64.store	$discard=, 0($pop5):p2align=0, $3
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
	i32.store8	$discard=, sY($pop0):p2align=2, $pop6
	i32.const	$push95=, 0
	i32.const	$push94=, 1103515245
	i32.mul 	$push7=, $0, $pop94
	i32.const	$push93=, 12345
	i32.add 	$push92=, $pop7, $pop93
	tee_local	$push91=, $0=, $pop92
	i32.const	$push90=, 16
	i32.shr_u	$push8=, $pop91, $pop90
	i32.store8	$discard=, sY+1($pop95), $pop8
	i32.const	$push89=, 0
	i32.const	$push88=, 1103515245
	i32.mul 	$push9=, $0, $pop88
	i32.const	$push87=, 12345
	i32.add 	$push86=, $pop9, $pop87
	tee_local	$push85=, $0=, $pop86
	i32.const	$push84=, 16
	i32.shr_u	$push10=, $pop85, $pop84
	i32.store8	$discard=, sY+2($pop89):p2align=1, $pop10
	i32.const	$push83=, 0
	i32.const	$push82=, 1103515245
	i32.mul 	$push11=, $0, $pop82
	i32.const	$push81=, 12345
	i32.add 	$push80=, $pop11, $pop81
	tee_local	$push79=, $0=, $pop80
	i32.const	$push78=, 16
	i32.shr_u	$push12=, $pop79, $pop78
	i32.store8	$discard=, sY+3($pop83), $pop12
	i32.const	$push77=, 0
	i32.const	$push16=, 1670464429
	i32.mul 	$push17=, $0, $pop16
	i32.const	$push18=, 2121308585
	i32.add 	$push76=, $pop17, $pop18
	tee_local	$push75=, $1=, $pop76
	i32.const	$push74=, 16
	i32.shr_u	$push19=, $pop75, $pop74
	i32.const	$push20=, 2047
	i32.and 	$push21=, $pop19, $pop20
	i32.const	$push73=, 0
	i32.load	$push15=, sY($pop73)
	i32.const	$push25=, -4096
	i32.and 	$push72=, $pop15, $pop25
	tee_local	$push71=, $0=, $pop72
	i32.or  	$push26=, $pop21, $pop71
	i32.store	$discard=, sY($pop77), $pop26
	i32.const	$push70=, 0
	i32.const	$push69=, 0
	i32.const	$push68=, 1103515245
	i32.mul 	$push22=, $1, $pop68
	i32.const	$push67=, 12345
	i32.add 	$push23=, $pop22, $pop67
	i32.store	$push24=, myrnd.s($pop69), $pop23
	i32.const	$push66=, 1103515245
	i32.mul 	$push27=, $pop24, $pop66
	i32.const	$push65=, 12345
	i32.add 	$push64=, $pop27, $pop65
	tee_local	$push63=, $1=, $pop64
	i32.const	$push62=, 16
	i32.shr_u	$push28=, $pop63, $pop62
	i32.const	$push61=, 2047
	i32.and 	$push29=, $pop28, $pop61
	i32.or  	$push33=, $pop29, $0
	i32.store	$discard=, sY($pop70), $pop33
	i32.const	$push60=, 0
	i32.const	$push59=, 0
	i32.const	$push58=, 0
	i32.const	$push57=, 1103515245
	i32.mul 	$push30=, $1, $pop57
	i32.const	$push56=, 12345
	i32.add 	$push31=, $pop30, $pop56
	i32.store	$push32=, myrnd.s($pop58), $pop31
	i32.const	$push55=, 1103515245
	i32.mul 	$push34=, $pop32, $pop55
	i32.const	$push54=, 12345
	i32.add 	$push53=, $pop34, $pop54
	tee_local	$push52=, $1=, $pop53
	i32.const	$push51=, 1103515245
	i32.mul 	$push37=, $pop52, $pop51
	i32.const	$push50=, 12345
	i32.add 	$push38=, $pop37, $pop50
	i32.store	$push39=, myrnd.s($pop59), $pop38
	i32.const	$push49=, 16
	i32.shr_u	$push40=, $pop39, $pop49
	i32.const	$push48=, 2047
	i32.and 	$push41=, $pop40, $pop48
	i32.const	$push47=, 16
	i32.shr_u	$push35=, $1, $pop47
	i32.const	$push46=, 2047
	i32.and 	$push36=, $pop35, $pop46
	i32.add 	$push42=, $pop41, $pop36
	i32.or  	$push43=, $pop42, $0
	i32.store	$discard=, sY($pop60), $pop43
	i32.const	$push45=, 0
	i64.const	$push13=, 4612055454334320640
	i64.store	$discard=, sY+12($pop45):p2align=2, $pop13
	i32.const	$push44=, 0
	i64.const	$push14=, 0
	i64.store	$discard=, sY+4($pop44):p2align=2, $pop14
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
	.local  	i32, i64
# BB#0:                                 # %entry
	i32.const	$push1=, 16
	i32.add 	$push3=, $1, $pop1
	i32.load	$2=, 0($pop3):p2align=0
	i32.const	$push4=, 8
	i32.add 	$push6=, $1, $pop4
	i64.load	$3=, 0($pop6):p2align=0
	i64.load	$push0=, 0($1):p2align=0
	i64.store	$discard=, 0($0):p2align=0, $pop0
	i32.const	$push8=, 16
	i32.add 	$push2=, $0, $pop8
	i32.store	$discard=, 0($pop2):p2align=0, $2
	i32.const	$push7=, 8
	i32.add 	$push5=, $0, $pop7
	i64.store	$discard=, 0($pop5):p2align=0, $3
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
	i32.const	$push98=, 0
	i32.const	$push97=, 0
	i32.load	$push2=, myrnd.s($pop97)
	i32.const	$push3=, 1670464429
	i32.mul 	$push4=, $pop2, $pop3
	i32.const	$push5=, 2121308585
	i32.add 	$push96=, $pop4, $pop5
	tee_local	$push95=, $0=, $pop96
	i32.const	$push94=, 16
	i32.shr_u	$push6=, $pop95, $pop94
	i32.store8	$discard=, sZ+16($pop98):p2align=4, $pop6
	i32.const	$push93=, 0
	i32.const	$push92=, 1103515245
	i32.mul 	$push7=, $0, $pop92
	i32.const	$push91=, 12345
	i32.add 	$push90=, $pop7, $pop91
	tee_local	$push89=, $0=, $pop90
	i32.const	$push88=, 16
	i32.shr_u	$push8=, $pop89, $pop88
	i32.store8	$discard=, sZ+17($pop93), $pop8
	i32.const	$push87=, 0
	i32.const	$push86=, 1103515245
	i32.mul 	$push9=, $0, $pop86
	i32.const	$push85=, 12345
	i32.add 	$push84=, $pop9, $pop85
	tee_local	$push83=, $0=, $pop84
	i32.const	$push82=, 16
	i32.shr_u	$push10=, $pop83, $pop82
	i32.store8	$discard=, sZ+18($pop87):p2align=1, $pop10
	i32.const	$push81=, 0
	i32.const	$push80=, 1103515245
	i32.mul 	$push11=, $0, $pop80
	i32.const	$push79=, 12345
	i32.add 	$push78=, $pop11, $pop79
	tee_local	$push77=, $0=, $pop78
	i32.const	$push76=, 16
	i32.shr_u	$push12=, $pop77, $pop76
	i32.store8	$discard=, sZ+19($pop81), $pop12
	i32.const	$push75=, 0
	i32.load	$3=, sZ+16($pop75):p2align=4
	i32.const	$push74=, 0
	i32.const	$push73=, 1103515245
	i32.mul 	$push15=, $0, $pop73
	i32.const	$push72=, 12345
	i32.add 	$push71=, $pop15, $pop72
	tee_local	$push70=, $4=, $pop71
	i32.const	$push69=, 1103515245
	i32.mul 	$push17=, $pop70, $pop69
	i32.const	$push68=, 12345
	i32.add 	$push0=, $pop17, $pop68
	i32.store	$0=, myrnd.s($pop74), $pop0
	i32.const	$push67=, 0
	i32.const	$push66=, 16
	i32.shr_u	$push16=, $4, $pop66
	i32.const	$push65=, 2047
	i32.and 	$push64=, $pop16, $pop65
	tee_local	$push63=, $4=, $pop64
	i32.const	$push62=, 20
	i32.shl 	$push19=, $pop63, $pop62
	i32.const	$push20=, 1048575
	i32.and 	$push61=, $3, $pop20
	tee_local	$push60=, $3=, $pop61
	i32.or  	$push21=, $pop19, $pop60
	i32.store	$1=, sZ+16($pop67):p2align=4, $pop21
	i32.const	$push59=, 0
	i64.const	$push13=, 4612055454334320640
	i64.store	$discard=, sZ+8($pop59), $pop13
	i32.const	$push58=, 0
	i64.const	$push14=, 0
	i64.store	$discard=, sZ($pop58):p2align=4, $pop14
	block
	i32.const	$push57=, 16
	i32.shr_u	$push18=, $0, $pop57
	i32.const	$push56=, 2047
	i32.and 	$push55=, $pop18, $pop56
	tee_local	$push54=, $2=, $pop55
	i32.add 	$push25=, $pop54, $4
	i32.const	$push53=, 20
	i32.shl 	$push22=, $2, $pop53
	i32.add 	$push23=, $1, $pop22
	i32.const	$push52=, 20
	i32.shr_u	$push24=, $pop23, $pop52
	i32.ne  	$push26=, $pop25, $pop24
	br_if   	0, $pop26       # 0: down to label22
# BB#1:                                 # %if.end80
	block
	i32.const	$push122=, 0
	i32.const	$push121=, 0
	i32.const	$push120=, 1103515245
	i32.mul 	$push27=, $0, $pop120
	i32.const	$push119=, 12345
	i32.add 	$push118=, $pop27, $pop119
	tee_local	$push117=, $0=, $pop118
	i32.const	$push33=, -1029531031
	i32.mul 	$push34=, $pop117, $pop33
	i32.const	$push35=, -740551042
	i32.add 	$push116=, $pop34, $pop35
	tee_local	$push115=, $4=, $pop116
	i32.const	$push114=, 1103515245
	i32.mul 	$push37=, $pop115, $pop114
	i32.const	$push113=, 12345
	i32.add 	$push38=, $pop37, $pop113
	i32.store	$push39=, myrnd.s($pop121), $pop38
	i32.const	$push112=, 16
	i32.shr_u	$push40=, $pop39, $pop112
	i32.const	$push111=, 2047
	i32.and 	$push110=, $pop40, $pop111
	tee_local	$push109=, $1=, $pop110
	i32.const	$push108=, 20
	i32.shl 	$push43=, $pop109, $pop108
	i32.const	$push107=, 16
	i32.shr_u	$push36=, $4, $pop107
	i32.const	$push106=, 2047
	i32.and 	$push105=, $pop36, $pop106
	tee_local	$push104=, $4=, $pop105
	i32.const	$push103=, 20
	i32.shl 	$push41=, $pop104, $pop103
	i32.or  	$push42=, $pop41, $3
	i32.add 	$push1=, $pop43, $pop42
	i32.store	$push102=, sZ+16($pop122):p2align=4, $pop1
	tee_local	$push101=, $2=, $pop102
	i32.const	$push28=, 4
	i32.shl 	$push29=, $0, $pop28
	i32.const	$push30=, 2146435072
	i32.and 	$push31=, $pop29, $pop30
	i32.or  	$push32=, $pop31, $3
	i32.xor 	$push100=, $pop101, $pop32
	tee_local	$push99=, $0=, $pop100
	i32.const	$push44=, 1040384
	i32.and 	$push45=, $pop99, $pop44
	br_if   	0, $pop45       # 0: down to label23
# BB#2:                                 # %lor.lhs.false98
	i32.add 	$push50=, $1, $4
	i32.const	$push47=, 20
	i32.shr_u	$push48=, $2, $pop47
	i32.ne  	$push51=, $pop50, $pop48
	br_if   	0, $pop51       # 0: down to label23
# BB#3:                                 # %lor.lhs.false98
	i32.const	$push49=, 8191
	i32.and 	$push46=, $0, $pop49
	br_if   	0, $pop46       # 0: down to label23
# BB#4:                                 # %if.end121
	return
.LBB156_5:                              # %if.then120
	end_block                       # label23:
	call    	abort@FUNCTION
	unreachable
.LBB156_6:                              # %if.then
	end_block                       # label22:
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


	.ident	"clang version 3.9.0 "
