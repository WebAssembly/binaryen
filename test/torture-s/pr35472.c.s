	.text
	.file	"pr35472.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	p($pop0), $1
	i32.const	$push1=, -1
	i32.store	0($0), $pop1
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.test,"ax",@progbits
	.hidden	test                    # -- Begin function test
	.globl	test
	.type	test,@function
test:                                   # @test
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push31=, 0
	i32.const	$push29=, 0
	i32.load	$push28=, __stack_pointer($pop29)
	i32.const	$push30=, 128
	i32.sub 	$push125=, $pop28, $pop30
	tee_local	$push124=, $16=, $pop125
	i32.store	__stack_pointer($pop31), $pop124
	i32.const	$push35=, 64
	i32.add 	$push36=, $16, $pop35
	i32.const	$push0=, 56
	i32.add 	$push123=, $pop36, $pop0
	tee_local	$push122=, $0=, $pop123
	i64.const	$push1=, 0
	i64.store	0($pop122), $pop1
	i32.const	$push37=, 64
	i32.add 	$push38=, $16, $pop37
	i32.const	$push2=, 48
	i32.add 	$push121=, $pop38, $pop2
	tee_local	$push120=, $1=, $pop121
	i64.const	$push119=, 0
	i64.store	0($pop120), $pop119
	i32.const	$push39=, 64
	i32.add 	$push40=, $16, $pop39
	i32.const	$push3=, 40
	i32.add 	$push118=, $pop40, $pop3
	tee_local	$push117=, $2=, $pop118
	i64.const	$push116=, 0
	i64.store	0($pop117), $pop116
	i32.const	$push41=, 64
	i32.add 	$push42=, $16, $pop41
	i32.const	$push4=, 32
	i32.add 	$push115=, $pop42, $pop4
	tee_local	$push114=, $3=, $pop115
	i64.const	$push113=, 0
	i64.store	0($pop114), $pop113
	i32.const	$push43=, 64
	i32.add 	$push44=, $16, $pop43
	i32.const	$push5=, 24
	i32.add 	$push112=, $pop44, $pop5
	tee_local	$push111=, $4=, $pop112
	i64.const	$push110=, 0
	i64.store	0($pop111), $pop110
	i32.const	$push45=, 64
	i32.add 	$push46=, $16, $pop45
	i32.const	$push6=, 16
	i32.add 	$push109=, $pop46, $pop6
	tee_local	$push108=, $5=, $pop109
	i64.const	$push107=, 0
	i64.store	0($pop108), $pop107
	i32.const	$push47=, 64
	i32.add 	$push48=, $16, $pop47
	i32.const	$push7=, 8
	i32.add 	$push106=, $pop48, $pop7
	tee_local	$push105=, $6=, $pop106
	i64.const	$push104=, 0
	i64.store	0($pop105), $pop104
	i32.const	$push103=, 56
	i32.add 	$push102=, $16, $pop103
	tee_local	$push101=, $7=, $pop102
	i64.const	$push100=, 0
	i64.store	0($pop101), $pop100
	i32.const	$push99=, 48
	i32.add 	$push98=, $16, $pop99
	tee_local	$push97=, $8=, $pop98
	i64.const	$push96=, 0
	i64.store	0($pop97), $pop96
	i32.const	$push95=, 40
	i32.add 	$push94=, $16, $pop95
	tee_local	$push93=, $9=, $pop94
	i64.const	$push92=, 0
	i64.store	0($pop93), $pop92
	i32.const	$push91=, 32
	i32.add 	$push90=, $16, $pop91
	tee_local	$push89=, $10=, $pop90
	i64.const	$push88=, 0
	i64.store	0($pop89), $pop88
	i32.const	$push87=, 24
	i32.add 	$push86=, $16, $pop87
	tee_local	$push85=, $11=, $pop86
	i64.const	$push84=, 0
	i64.store	0($pop85), $pop84
	i32.const	$push83=, 16
	i32.add 	$push82=, $16, $pop83
	tee_local	$push81=, $12=, $pop82
	i64.const	$push80=, 0
	i64.store	0($pop81), $pop80
	i32.const	$push79=, 8
	i32.add 	$push78=, $16, $pop79
	tee_local	$push77=, $13=, $pop78
	i64.const	$push76=, 0
	i64.store	0($pop77), $pop76
	i64.const	$push75=, 0
	i64.store	64($16), $pop75
	i64.const	$push74=, 0
	i64.store	0($16), $pop74
	i32.const	$push49=, 64
	i32.add 	$push50=, $16, $pop49
	call    	foo@FUNCTION, $pop50, $16
	i32.const	$push8=, 0
	i32.load	$push73=, p($pop8)
	tee_local	$push72=, $14=, $pop73
	i64.load	$push9=, 64($16)
	i64.store	0($pop72):p2align=2, $pop9
	i32.const	$push71=, 56
	i32.add 	$push70=, $14, $pop71
	tee_local	$push69=, $15=, $pop70
	i64.load	$push10=, 0($0)
	i64.store	0($pop69):p2align=2, $pop10
	i32.const	$push68=, 48
	i32.add 	$push67=, $14, $pop68
	tee_local	$push66=, $0=, $pop67
	i64.load	$push11=, 0($1)
	i64.store	0($pop66):p2align=2, $pop11
	i32.const	$push65=, 40
	i32.add 	$push64=, $14, $pop65
	tee_local	$push63=, $1=, $pop64
	i64.load	$push12=, 0($2)
	i64.store	0($pop63):p2align=2, $pop12
	i32.const	$push62=, 32
	i32.add 	$push61=, $14, $pop62
	tee_local	$push60=, $2=, $pop61
	i64.load	$push13=, 0($3)
	i64.store	0($pop60):p2align=2, $pop13
	i32.const	$push59=, 24
	i32.add 	$push58=, $14, $pop59
	tee_local	$push57=, $3=, $pop58
	i64.load	$push14=, 0($4)
	i64.store	0($pop57):p2align=2, $pop14
	i32.const	$push56=, 16
	i32.add 	$push55=, $14, $pop56
	tee_local	$push54=, $4=, $pop55
	i64.load	$push15=, 0($5)
	i64.store	0($pop54):p2align=2, $pop15
	i32.const	$push53=, 8
	i32.add 	$push52=, $14, $pop53
	tee_local	$push51=, $5=, $pop52
	i64.load	$push16=, 0($6)
	i64.store	0($pop51):p2align=2, $pop16
	i64.load	$push17=, 0($16)
	i64.store	0($14):p2align=2, $pop17
	i64.load	$push18=, 0($13)
	i64.store	0($5):p2align=2, $pop18
	i64.load	$push19=, 0($12)
	i64.store	0($4):p2align=2, $pop19
	i64.load	$push20=, 0($11)
	i64.store	0($3):p2align=2, $pop20
	i64.load	$push21=, 0($10)
	i64.store	0($2):p2align=2, $pop21
	i64.load	$push22=, 0($9)
	i64.store	0($1):p2align=2, $pop22
	i64.load	$push23=, 0($8)
	i64.store	0($0):p2align=2, $pop23
	i64.load	$push24=, 0($7)
	i64.store	0($15):p2align=2, $pop24
	block   	
	i32.load	$push26=, 0($16)
	i32.const	$push25=, -1
	i32.ne  	$push27=, $pop26, $pop25
	br_if   	0, $pop27       # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push34=, 0
	i32.const	$push32=, 128
	i32.add 	$push33=, $16, $pop32
	i32.store	__stack_pointer($pop34), $pop33
	return
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	test, .Lfunc_end1-test
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push30=, 0
	i32.const	$push28=, 0
	i32.load	$push27=, __stack_pointer($pop28)
	i32.const	$push29=, 128
	i32.sub 	$push125=, $pop27, $pop29
	tee_local	$push124=, $16=, $pop125
	i32.store	__stack_pointer($pop30), $pop124
	i32.const	$push34=, 64
	i32.add 	$push35=, $16, $pop34
	i32.const	$push0=, 56
	i32.add 	$push123=, $pop35, $pop0
	tee_local	$push122=, $0=, $pop123
	i64.const	$push1=, 0
	i64.store	0($pop122), $pop1
	i32.const	$push36=, 64
	i32.add 	$push37=, $16, $pop36
	i32.const	$push2=, 48
	i32.add 	$push121=, $pop37, $pop2
	tee_local	$push120=, $1=, $pop121
	i64.const	$push119=, 0
	i64.store	0($pop120), $pop119
	i32.const	$push38=, 64
	i32.add 	$push39=, $16, $pop38
	i32.const	$push3=, 40
	i32.add 	$push118=, $pop39, $pop3
	tee_local	$push117=, $2=, $pop118
	i64.const	$push116=, 0
	i64.store	0($pop117), $pop116
	i32.const	$push40=, 64
	i32.add 	$push41=, $16, $pop40
	i32.const	$push4=, 32
	i32.add 	$push115=, $pop41, $pop4
	tee_local	$push114=, $3=, $pop115
	i64.const	$push113=, 0
	i64.store	0($pop114), $pop113
	i32.const	$push42=, 64
	i32.add 	$push43=, $16, $pop42
	i32.const	$push5=, 24
	i32.add 	$push112=, $pop43, $pop5
	tee_local	$push111=, $4=, $pop112
	i64.const	$push110=, 0
	i64.store	0($pop111), $pop110
	i32.const	$push44=, 64
	i32.add 	$push45=, $16, $pop44
	i32.const	$push6=, 16
	i32.add 	$push109=, $pop45, $pop6
	tee_local	$push108=, $5=, $pop109
	i64.const	$push107=, 0
	i64.store	0($pop108), $pop107
	i32.const	$push46=, 64
	i32.add 	$push47=, $16, $pop46
	i32.const	$push7=, 8
	i32.add 	$push106=, $pop47, $pop7
	tee_local	$push105=, $6=, $pop106
	i64.const	$push104=, 0
	i64.store	0($pop105), $pop104
	i32.const	$push103=, 56
	i32.add 	$push102=, $16, $pop103
	tee_local	$push101=, $7=, $pop102
	i64.const	$push100=, 0
	i64.store	0($pop101), $pop100
	i32.const	$push99=, 48
	i32.add 	$push98=, $16, $pop99
	tee_local	$push97=, $8=, $pop98
	i64.const	$push96=, 0
	i64.store	0($pop97), $pop96
	i32.const	$push95=, 40
	i32.add 	$push94=, $16, $pop95
	tee_local	$push93=, $9=, $pop94
	i64.const	$push92=, 0
	i64.store	0($pop93), $pop92
	i32.const	$push91=, 32
	i32.add 	$push90=, $16, $pop91
	tee_local	$push89=, $10=, $pop90
	i64.const	$push88=, 0
	i64.store	0($pop89), $pop88
	i32.const	$push87=, 24
	i32.add 	$push86=, $16, $pop87
	tee_local	$push85=, $11=, $pop86
	i64.const	$push84=, 0
	i64.store	0($pop85), $pop84
	i32.const	$push83=, 16
	i32.add 	$push82=, $16, $pop83
	tee_local	$push81=, $12=, $pop82
	i64.const	$push80=, 0
	i64.store	0($pop81), $pop80
	i32.const	$push79=, 8
	i32.add 	$push78=, $16, $pop79
	tee_local	$push77=, $13=, $pop78
	i64.const	$push76=, 0
	i64.store	0($pop77), $pop76
	i64.const	$push75=, 0
	i64.store	64($16), $pop75
	i64.const	$push74=, 0
	i64.store	0($16), $pop74
	i32.const	$push48=, 64
	i32.add 	$push49=, $16, $pop48
	call    	foo@FUNCTION, $pop49, $16
	i32.const	$push73=, 0
	i32.load	$push72=, p($pop73)
	tee_local	$push71=, $14=, $pop72
	i64.load	$push8=, 64($16)
	i64.store	0($pop71):p2align=2, $pop8
	i32.const	$push70=, 56
	i32.add 	$push69=, $14, $pop70
	tee_local	$push68=, $15=, $pop69
	i64.load	$push9=, 0($0)
	i64.store	0($pop68):p2align=2, $pop9
	i32.const	$push67=, 48
	i32.add 	$push66=, $14, $pop67
	tee_local	$push65=, $0=, $pop66
	i64.load	$push10=, 0($1)
	i64.store	0($pop65):p2align=2, $pop10
	i32.const	$push64=, 40
	i32.add 	$push63=, $14, $pop64
	tee_local	$push62=, $1=, $pop63
	i64.load	$push11=, 0($2)
	i64.store	0($pop62):p2align=2, $pop11
	i32.const	$push61=, 32
	i32.add 	$push60=, $14, $pop61
	tee_local	$push59=, $2=, $pop60
	i64.load	$push12=, 0($3)
	i64.store	0($pop59):p2align=2, $pop12
	i32.const	$push58=, 24
	i32.add 	$push57=, $14, $pop58
	tee_local	$push56=, $3=, $pop57
	i64.load	$push13=, 0($4)
	i64.store	0($pop56):p2align=2, $pop13
	i32.const	$push55=, 16
	i32.add 	$push54=, $14, $pop55
	tee_local	$push53=, $4=, $pop54
	i64.load	$push14=, 0($5)
	i64.store	0($pop53):p2align=2, $pop14
	i32.const	$push52=, 8
	i32.add 	$push51=, $14, $pop52
	tee_local	$push50=, $5=, $pop51
	i64.load	$push15=, 0($6)
	i64.store	0($pop50):p2align=2, $pop15
	i64.load	$push16=, 0($16)
	i64.store	0($14):p2align=2, $pop16
	i64.load	$push17=, 0($13)
	i64.store	0($5):p2align=2, $pop17
	i64.load	$push18=, 0($12)
	i64.store	0($4):p2align=2, $pop18
	i64.load	$push19=, 0($11)
	i64.store	0($3):p2align=2, $pop19
	i64.load	$push20=, 0($10)
	i64.store	0($2):p2align=2, $pop20
	i64.load	$push21=, 0($9)
	i64.store	0($1):p2align=2, $pop21
	i64.load	$push22=, 0($8)
	i64.store	0($0):p2align=2, $pop22
	i64.load	$push23=, 0($7)
	i64.store	0($15):p2align=2, $pop23
	block   	
	i32.load	$push25=, 0($16)
	i32.const	$push24=, -1
	i32.ne  	$push26=, $pop25, $pop24
	br_if   	0, $pop26       # 0: down to label1
# BB#1:                                 # %test.exit
	i32.const	$push33=, 0
	i32.const	$push31=, 128
	i32.add 	$push32=, $16, $pop31
	i32.store	__stack_pointer($pop33), $pop32
	i32.const	$push126=, 0
	return  	$pop126
.LBB2_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.p2align	2
p:
	.int32	0
	.size	p, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
