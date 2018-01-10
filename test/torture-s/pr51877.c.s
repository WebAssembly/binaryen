	.text
	.file	"pr51877.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.store8	4($0), $1
	i32.const	$push0=, 28
	i32.add 	$push1=, $0, $pop0
	i64.const	$push2=, 0
	i64.store	0($pop1):p2align=0, $pop2
	i32.const	$push3=, 21
	i32.add 	$push4=, $0, $pop3
	i64.const	$push15=, 0
	i64.store	0($pop4):p2align=0, $pop15
	i32.const	$push5=, 13
	i32.add 	$push6=, $0, $pop5
	i64.const	$push14=, 0
	i64.store	0($pop6):p2align=0, $pop14
	i32.const	$push7=, 5
	i32.add 	$push8=, $0, $pop7
	i64.const	$push13=, 0
	i64.store	0($pop8):p2align=0, $pop13
	i32.const	$push9=, 0
	i32.load	$push10=, bar.n($pop9)
	i32.const	$push11=, 1
	i32.add 	$1=, $pop10, $pop11
	i32.store	0($0), $1
	i32.const	$push12=, 0
	i32.store	bar.n($pop12), $1
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar
                                        # -- End function
	.section	.text.baz,"ax",@progbits
	.hidden	baz                     # -- Begin function baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
# %bb.0:                                # %entry
	#APP
	#NO_APP
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	baz, .Lfunc_end1-baz
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push36=, 0
	i32.load	$push35=, __stack_pointer($pop36)
	i32.const	$push37=, 80
	i32.sub 	$2=, $pop35, $pop37
	i32.const	$push38=, 0
	i32.store	__stack_pointer($pop38), $2
	block   	
	block   	
	i32.const	$push0=, 6
	i32.ne  	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label1
# %bb.1:                                # %if.then
	i32.const	$push42=, 40
	i32.add 	$push43=, $2, $pop42
	i32.const	$push20=, 7
	call    	bar@FUNCTION, $pop43, $pop20
	i32.const	$push24=, 0
	i32.const	$push21=, 72
	i32.add 	$push22=, $2, $pop21
	i32.load	$push23=, 0($pop22)
	i32.store	a+32($pop24), $pop23
	i32.const	$push47=, 0
	i32.const	$push25=, 64
	i32.add 	$push26=, $2, $pop25
	i64.load	$push27=, 0($pop26)
	i64.store	a+24($pop47):p2align=2, $pop27
	i32.const	$push46=, 0
	i32.const	$push28=, 56
	i32.add 	$push29=, $2, $pop28
	i64.load	$push30=, 0($pop29)
	i64.store	a+16($pop46):p2align=2, $pop30
	i32.const	$push45=, 0
	i32.const	$push31=, 48
	i32.add 	$push32=, $2, $pop31
	i64.load	$push33=, 0($pop32)
	i64.store	a+8($pop45):p2align=2, $pop33
	i32.const	$push44=, 0
	i64.load	$push34=, 40($2)
	i64.store	a($pop44):p2align=2, $pop34
	br      	1               # 1: down to label0
.LBB2_2:                                # %if.else
	end_block                       # label1:
	i32.const	$push2=, 7
	call    	bar@FUNCTION, $2, $pop2
	i32.const	$push3=, 32
	i32.add 	$push4=, $0, $pop3
	i32.const	$push51=, 32
	i32.add 	$push5=, $2, $pop51
	i32.load	$push6=, 0($pop5)
	i32.store	0($pop4), $pop6
	i32.const	$push7=, 24
	i32.add 	$push8=, $0, $pop7
	i32.const	$push50=, 24
	i32.add 	$push9=, $2, $pop50
	i64.load	$push10=, 0($pop9)
	i64.store	0($pop8):p2align=2, $pop10
	i32.const	$push11=, 16
	i32.add 	$push12=, $0, $pop11
	i32.const	$push49=, 16
	i32.add 	$push13=, $2, $pop49
	i64.load	$push14=, 0($pop13)
	i64.store	0($pop12):p2align=2, $pop14
	i32.const	$push15=, 8
	i32.add 	$push16=, $0, $pop15
	i32.const	$push48=, 8
	i32.add 	$push17=, $2, $pop48
	i64.load	$push18=, 0($pop17)
	i64.store	0($pop16):p2align=2, $pop18
	i64.load	$push19=, 0($2)
	i64.store	0($0):p2align=2, $pop19
.LBB2_3:                                # %if.end
	end_block                       # label0:
	call    	baz@FUNCTION
	i32.const	$push41=, 0
	i32.const	$push39=, 80
	i32.add 	$push40=, $2, $pop39
	i32.store	__stack_pointer($pop41), $pop40
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	foo, .Lfunc_end2-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push67=, 0
	i32.load	$push66=, __stack_pointer($pop67)
	i32.const	$push68=, 80
	i32.sub 	$0=, $pop66, $pop68
	i32.const	$push69=, 0
	i32.store	__stack_pointer($pop69), $0
	i32.const	$push73=, 40
	i32.add 	$push74=, $0, $pop73
	i32.const	$push98=, 3
	call    	bar@FUNCTION, $pop74, $pop98
	i32.const	$push97=, 0
	i32.const	$push75=, 40
	i32.add 	$push76=, $0, $pop75
	i32.const	$push0=, 32
	i32.add 	$push1=, $pop76, $pop0
	i32.load	$push2=, 0($pop1)
	i32.store	a+32($pop97), $pop2
	i32.const	$push96=, 0
	i32.const	$push77=, 40
	i32.add 	$push78=, $0, $pop77
	i32.const	$push3=, 24
	i32.add 	$push4=, $pop78, $pop3
	i64.load	$push5=, 0($pop4)
	i64.store	a+24($pop96):p2align=2, $pop5
	i32.const	$push95=, 0
	i32.const	$push79=, 40
	i32.add 	$push80=, $0, $pop79
	i32.const	$push6=, 16
	i32.add 	$push7=, $pop80, $pop6
	i64.load	$push8=, 0($pop7)
	i64.store	a+16($pop95):p2align=2, $pop8
	i32.const	$push94=, 0
	i32.const	$push81=, 40
	i32.add 	$push82=, $0, $pop81
	i32.const	$push9=, 8
	i32.add 	$push10=, $pop82, $pop9
	i64.load	$push11=, 0($pop10)
	i64.store	a+8($pop94):p2align=2, $pop11
	i32.const	$push93=, 0
	i64.load	$push12=, 40($0)
	i64.store	a($pop93):p2align=2, $pop12
	i32.const	$push13=, 4
	call    	bar@FUNCTION, $0, $pop13
	i32.const	$push92=, 0
	i32.const	$push91=, 32
	i32.add 	$push14=, $0, $pop91
	i32.load	$push15=, 0($pop14)
	i32.store	b+32($pop92), $pop15
	i32.const	$push90=, 0
	i32.const	$push89=, 24
	i32.add 	$push16=, $0, $pop89
	i64.load	$push17=, 0($pop16)
	i64.store	b+24($pop90):p2align=2, $pop17
	i32.const	$push88=, 0
	i32.const	$push87=, 16
	i32.add 	$push18=, $0, $pop87
	i64.load	$push19=, 0($pop18)
	i64.store	b+16($pop88):p2align=2, $pop19
	i32.const	$push86=, 0
	i32.const	$push85=, 8
	i32.add 	$push20=, $0, $pop85
	i64.load	$push21=, 0($pop20)
	i64.store	b+8($pop86):p2align=2, $pop21
	i32.const	$push84=, 0
	i64.load	$push22=, 0($0)
	i64.store	b($pop84):p2align=2, $pop22
	block   	
	i32.const	$push83=, 0
	i32.load	$push23=, a($pop83)
	i32.const	$push24=, 1
	i32.ne  	$push25=, $pop23, $pop24
	br_if   	0, $pop25       # 0: down to label2
# %bb.1:                                # %lor.lhs.false
	i32.const	$push100=, 0
	i32.load8_u	$push28=, a+4($pop100)
	i32.const	$push99=, 3
	i32.ne  	$push29=, $pop28, $pop99
	br_if   	0, $pop29       # 0: down to label2
# %bb.2:                                # %lor.lhs.false
	i32.const	$push101=, 0
	i32.load	$push26=, b($pop101)
	i32.const	$push30=, 2
	i32.ne  	$push31=, $pop26, $pop30
	br_if   	0, $pop31       # 0: down to label2
# %bb.3:                                # %lor.lhs.false
	i32.const	$push102=, 0
	i32.load8_u	$push27=, b+4($pop102)
	i32.const	$push32=, 255
	i32.and 	$push33=, $pop27, $pop32
	i32.const	$push34=, 4
	i32.ne  	$push35=, $pop33, $pop34
	br_if   	0, $pop35       # 0: down to label2
# %bb.4:                                # %if.end
	i32.const	$push36=, b
	i32.const	$push104=, 0
	call    	foo@FUNCTION, $pop36, $pop104
	i32.const	$push103=, 0
	i32.load	$push37=, a($pop103)
	i32.const	$push38=, 1
	i32.ne  	$push39=, $pop37, $pop38
	br_if   	0, $pop39       # 0: down to label2
# %bb.5:                                # %lor.lhs.false13
	i32.const	$push106=, 0
	i32.load8_u	$push42=, a+4($pop106)
	i32.const	$push105=, 3
	i32.ne  	$push43=, $pop42, $pop105
	br_if   	0, $pop43       # 0: down to label2
# %bb.6:                                # %lor.lhs.false13
	i32.const	$push108=, 0
	i32.load	$push40=, b($pop108)
	i32.const	$push107=, 3
	i32.ne  	$push44=, $pop40, $pop107
	br_if   	0, $pop44       # 0: down to label2
# %bb.7:                                # %lor.lhs.false13
	i32.const	$push109=, 0
	i32.load8_u	$push41=, b+4($pop109)
	i32.const	$push45=, 255
	i32.and 	$push46=, $pop41, $pop45
	i32.const	$push47=, 7
	i32.ne  	$push48=, $pop46, $pop47
	br_if   	0, $pop48       # 0: down to label2
# %bb.8:                                # %if.end25
	i32.const	$push50=, b
	i32.const	$push49=, 6
	call    	foo@FUNCTION, $pop50, $pop49
	i32.const	$push110=, 0
	i32.load	$push51=, a($pop110)
	i32.const	$push52=, 4
	i32.ne  	$push53=, $pop51, $pop52
	br_if   	0, $pop53       # 0: down to label2
# %bb.9:                                # %lor.lhs.false28
	i32.const	$push111=, 0
	i32.load8_u	$push56=, a+4($pop111)
	i32.const	$push57=, 7
	i32.ne  	$push58=, $pop56, $pop57
	br_if   	0, $pop58       # 0: down to label2
# %bb.10:                               # %lor.lhs.false28
	i32.const	$push112=, 0
	i32.load	$push54=, b($pop112)
	i32.const	$push59=, 3
	i32.ne  	$push60=, $pop54, $pop59
	br_if   	0, $pop60       # 0: down to label2
# %bb.11:                               # %lor.lhs.false28
	i32.const	$push113=, 0
	i32.load8_u	$push55=, b+4($pop113)
	i32.const	$push61=, 255
	i32.and 	$push62=, $pop55, $pop61
	i32.const	$push63=, 7
	i32.ne  	$push64=, $pop62, $pop63
	br_if   	0, $pop64       # 0: down to label2
# %bb.12:                               # %if.end40
	i32.const	$push72=, 0
	i32.const	$push70=, 80
	i32.add 	$push71=, $0, $pop70
	i32.store	__stack_pointer($pop72), $pop71
	i32.const	$push65=, 0
	return  	$pop65
.LBB3_13:                               # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function
	.type	bar.n,@object           # @bar.n
	.section	.bss.bar.n,"aw",@nobits
	.p2align	2
bar.n:
	.int32	0                       # 0x0
	.size	bar.n, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.skip	36
	.size	a, 36

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.skip	36
	.size	b, 36


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
