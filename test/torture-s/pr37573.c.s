	.text
	.file	"pr37573.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	call    	bar@FUNCTION
	block   	
	i32.const	$push2=, p
	i32.const	$push1=, q
	i32.const	$push0=, 23
	i32.call	$push3=, memcmp@FUNCTION, $pop2, $pop1, $pop0
	br_if   	0, $pop3        # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.type	bar,@function           # -- Begin function bar
bar:                                    # @bar
	.local  	i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push77=, 0
	i32.load	$push76=, __stack_pointer($pop77)
	i32.const	$push78=, 2512
	i32.sub 	$3=, $pop76, $pop78
	i32.const	$push79=, 0
	i32.store	__stack_pointer($pop79), $3
	i32.const	$1=, 41589
	i32.const	$push129=, 41589
	i32.store	16($3), $pop129
	i32.const	$push0=, 20
	i32.add 	$0=, $3, $pop0
	i32.const	$2=, 1
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push134=, 30
	i32.shr_u	$push1=, $1, $pop134
	i32.xor 	$push2=, $pop1, $1
	i32.const	$push133=, 1812433253
	i32.mul 	$push3=, $pop2, $pop133
	i32.add 	$1=, $pop3, $2
	i32.store	0($0), $1
	i32.const	$push132=, 4
	i32.add 	$0=, $0, $pop132
	i32.const	$push131=, 1
	i32.add 	$2=, $2, $pop131
	i32.const	$push130=, 624
	i32.ne  	$push4=, $2, $pop130
	br_if   	0, $pop4        # 0: up to label1
# %bb.2:                                # %for.end
	end_loop
	i32.const	$push5=, 1
	i32.store	12($3), $pop5
	i32.const	$push7=, 0
	i32.const	$push83=, 8
	i32.add 	$push84=, $3, $pop83
	i32.call	$push6=, foo@FUNCTION, $pop84
	i32.const	$push179=, 0
	i32.load8_u	$push8=, p($pop179)
	i32.xor 	$push9=, $pop6, $pop8
	i32.store8	p($pop7), $pop9
	i32.const	$push178=, 0
	i32.const	$push85=, 8
	i32.add 	$push86=, $3, $pop85
	i32.call	$push10=, foo@FUNCTION, $pop86
	i32.const	$push177=, 0
	i32.load8_u	$push11=, p+1($pop177)
	i32.xor 	$push12=, $pop10, $pop11
	i32.store8	p+1($pop178), $pop12
	i32.const	$push176=, 0
	i32.const	$push87=, 8
	i32.add 	$push88=, $3, $pop87
	i32.call	$push13=, foo@FUNCTION, $pop88
	i32.const	$push175=, 0
	i32.load8_u	$push14=, p+2($pop175)
	i32.xor 	$push15=, $pop13, $pop14
	i32.store8	p+2($pop176), $pop15
	i32.const	$push174=, 0
	i32.const	$push89=, 8
	i32.add 	$push90=, $3, $pop89
	i32.call	$push16=, foo@FUNCTION, $pop90
	i32.const	$push173=, 0
	i32.load8_u	$push17=, p+3($pop173)
	i32.xor 	$push18=, $pop16, $pop17
	i32.store8	p+3($pop174), $pop18
	i32.const	$push172=, 0
	i32.const	$push91=, 8
	i32.add 	$push92=, $3, $pop91
	i32.call	$push19=, foo@FUNCTION, $pop92
	i32.const	$push171=, 0
	i32.load8_u	$push20=, p+4($pop171)
	i32.xor 	$push21=, $pop19, $pop20
	i32.store8	p+4($pop172), $pop21
	i32.const	$push170=, 0
	i32.const	$push93=, 8
	i32.add 	$push94=, $3, $pop93
	i32.call	$push22=, foo@FUNCTION, $pop94
	i32.const	$push169=, 0
	i32.load8_u	$push23=, p+5($pop169)
	i32.xor 	$push24=, $pop22, $pop23
	i32.store8	p+5($pop170), $pop24
	i32.const	$push168=, 0
	i32.const	$push95=, 8
	i32.add 	$push96=, $3, $pop95
	i32.call	$push25=, foo@FUNCTION, $pop96
	i32.const	$push167=, 0
	i32.load8_u	$push26=, p+6($pop167)
	i32.xor 	$push27=, $pop25, $pop26
	i32.store8	p+6($pop168), $pop27
	i32.const	$push166=, 0
	i32.const	$push97=, 8
	i32.add 	$push98=, $3, $pop97
	i32.call	$push28=, foo@FUNCTION, $pop98
	i32.const	$push165=, 0
	i32.load8_u	$push29=, p+7($pop165)
	i32.xor 	$push30=, $pop28, $pop29
	i32.store8	p+7($pop166), $pop30
	i32.const	$push164=, 0
	i32.const	$push99=, 8
	i32.add 	$push100=, $3, $pop99
	i32.call	$push31=, foo@FUNCTION, $pop100
	i32.const	$push163=, 0
	i32.load8_u	$push32=, p+8($pop163)
	i32.xor 	$push33=, $pop31, $pop32
	i32.store8	p+8($pop164), $pop33
	i32.const	$push162=, 0
	i32.const	$push101=, 8
	i32.add 	$push102=, $3, $pop101
	i32.call	$push34=, foo@FUNCTION, $pop102
	i32.const	$push161=, 0
	i32.load8_u	$push35=, p+9($pop161)
	i32.xor 	$push36=, $pop34, $pop35
	i32.store8	p+9($pop162), $pop36
	i32.const	$push160=, 0
	i32.const	$push103=, 8
	i32.add 	$push104=, $3, $pop103
	i32.call	$push37=, foo@FUNCTION, $pop104
	i32.const	$push159=, 0
	i32.load8_u	$push38=, p+10($pop159)
	i32.xor 	$push39=, $pop37, $pop38
	i32.store8	p+10($pop160), $pop39
	i32.const	$push158=, 0
	i32.const	$push105=, 8
	i32.add 	$push106=, $3, $pop105
	i32.call	$push40=, foo@FUNCTION, $pop106
	i32.const	$push157=, 0
	i32.load8_u	$push41=, p+11($pop157)
	i32.xor 	$push42=, $pop40, $pop41
	i32.store8	p+11($pop158), $pop42
	i32.const	$push156=, 0
	i32.const	$push107=, 8
	i32.add 	$push108=, $3, $pop107
	i32.call	$push43=, foo@FUNCTION, $pop108
	i32.const	$push155=, 0
	i32.load8_u	$push44=, p+12($pop155)
	i32.xor 	$push45=, $pop43, $pop44
	i32.store8	p+12($pop156), $pop45
	i32.const	$push154=, 0
	i32.const	$push109=, 8
	i32.add 	$push110=, $3, $pop109
	i32.call	$push46=, foo@FUNCTION, $pop110
	i32.const	$push153=, 0
	i32.load8_u	$push47=, p+13($pop153)
	i32.xor 	$push48=, $pop46, $pop47
	i32.store8	p+13($pop154), $pop48
	i32.const	$push152=, 0
	i32.const	$push111=, 8
	i32.add 	$push112=, $3, $pop111
	i32.call	$push49=, foo@FUNCTION, $pop112
	i32.const	$push151=, 0
	i32.load8_u	$push50=, p+14($pop151)
	i32.xor 	$push51=, $pop49, $pop50
	i32.store8	p+14($pop152), $pop51
	i32.const	$push150=, 0
	i32.const	$push113=, 8
	i32.add 	$push114=, $3, $pop113
	i32.call	$push52=, foo@FUNCTION, $pop114
	i32.const	$push149=, 0
	i32.load8_u	$push53=, p+15($pop149)
	i32.xor 	$push54=, $pop52, $pop53
	i32.store8	p+15($pop150), $pop54
	i32.const	$push148=, 0
	i32.const	$push115=, 8
	i32.add 	$push116=, $3, $pop115
	i32.call	$push55=, foo@FUNCTION, $pop116
	i32.const	$push147=, 0
	i32.load8_u	$push56=, p+16($pop147)
	i32.xor 	$push57=, $pop55, $pop56
	i32.store8	p+16($pop148), $pop57
	i32.const	$push146=, 0
	i32.const	$push117=, 8
	i32.add 	$push118=, $3, $pop117
	i32.call	$push58=, foo@FUNCTION, $pop118
	i32.const	$push145=, 0
	i32.load8_u	$push59=, p+17($pop145)
	i32.xor 	$push60=, $pop58, $pop59
	i32.store8	p+17($pop146), $pop60
	i32.const	$push144=, 0
	i32.const	$push119=, 8
	i32.add 	$push120=, $3, $pop119
	i32.call	$push61=, foo@FUNCTION, $pop120
	i32.const	$push143=, 0
	i32.load8_u	$push62=, p+18($pop143)
	i32.xor 	$push63=, $pop61, $pop62
	i32.store8	p+18($pop144), $pop63
	i32.const	$push142=, 0
	i32.const	$push121=, 8
	i32.add 	$push122=, $3, $pop121
	i32.call	$push64=, foo@FUNCTION, $pop122
	i32.const	$push141=, 0
	i32.load8_u	$push65=, p+19($pop141)
	i32.xor 	$push66=, $pop64, $pop65
	i32.store8	p+19($pop142), $pop66
	i32.const	$push140=, 0
	i32.const	$push123=, 8
	i32.add 	$push124=, $3, $pop123
	i32.call	$push67=, foo@FUNCTION, $pop124
	i32.const	$push139=, 0
	i32.load8_u	$push68=, p+20($pop139)
	i32.xor 	$push69=, $pop67, $pop68
	i32.store8	p+20($pop140), $pop69
	i32.const	$push138=, 0
	i32.const	$push125=, 8
	i32.add 	$push126=, $3, $pop125
	i32.call	$push70=, foo@FUNCTION, $pop126
	i32.const	$push137=, 0
	i32.load8_u	$push71=, p+21($pop137)
	i32.xor 	$push72=, $pop70, $pop71
	i32.store8	p+21($pop138), $pop72
	i32.const	$push136=, 0
	i32.const	$push127=, 8
	i32.add 	$push128=, $3, $pop127
	i32.call	$push73=, foo@FUNCTION, $pop128
	i32.const	$push135=, 0
	i32.load8_u	$push74=, p+22($pop135)
	i32.xor 	$push75=, $pop73, $pop74
	i32.store8	p+22($pop136), $pop75
	i32.const	$push82=, 0
	i32.const	$push80=, 2512
	i32.add 	$push81=, $3, $pop80
	i32.store	__stack_pointer($pop82), $pop81
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar
                                        # -- End function
	.section	.text.foo,"ax",@progbits
	.type	foo,@function           # -- Begin function foo
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.load	$push0=, 4($0)
	i32.const	$push1=, -1
	i32.add 	$3=, $pop0, $pop1
	i32.store	4($0), $3
	block   	
	block   	
	i32.eqz 	$push47=, $3
	br_if   	0, $pop47       # 0: down to label3
# %bb.1:                                # %entry.if.end_crit_edge
	i32.load	$5=, 0($0)
	br      	1               # 1: down to label2
.LBB2_2:                                # %if.then
	end_block                       # label3:
	i32.const	$push36=, 8
	i32.add 	$5=, $0, $pop36
	i32.store	0($0), $5
	i32.load	$4=, 8($0)
	i32.const	$3=, 0
.LBB2_3:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label4:
	i32.add 	$2=, $0, $3
	i32.const	$push46=, 12
	i32.add 	$push2=, $2, $pop46
	i32.load	$1=, 0($pop2)
	i32.const	$push45=, 8
	i32.add 	$push14=, $2, $pop45
	i32.const	$push44=, 0
	i32.const	$push43=, 1
	i32.and 	$push3=, $1, $pop43
	i32.sub 	$push4=, $pop44, $pop3
	i32.const	$push42=, -1727483681
	i32.and 	$push5=, $pop4, $pop42
	i32.const	$push41=, 1596
	i32.add 	$push6=, $2, $pop41
	i32.load	$push7=, 0($pop6)
	i32.xor 	$push8=, $pop5, $pop7
	i32.xor 	$push9=, $1, $4
	i32.const	$push40=, 2147483646
	i32.and 	$push10=, $pop9, $pop40
	i32.xor 	$push11=, $pop10, $4
	i32.const	$push39=, 1
	i32.shr_u	$push12=, $pop11, $pop39
	i32.xor 	$push13=, $pop8, $pop12
	i32.store	0($pop14), $pop13
	i32.const	$push38=, 4
	i32.add 	$3=, $3, $pop38
	copy_local	$4=, $1
	i32.const	$push37=, 908
	i32.ne  	$push15=, $3, $pop37
	br_if   	0, $pop15       # 0: up to label4
.LBB2_4:                                # %if.end
	end_loop
	end_block                       # label2:
	i32.const	$push16=, 4
	i32.add 	$push17=, $5, $pop16
	i32.store	0($0), $pop17
	i32.load	$3=, 0($5)
	i32.const	$push18=, 11
	i32.shr_u	$push19=, $3, $pop18
	i32.xor 	$3=, $pop19, $3
	i32.const	$push20=, 7
	i32.shl 	$push21=, $3, $pop20
	i32.const	$push22=, -1658038656
	i32.and 	$push23=, $pop21, $pop22
	i32.xor 	$3=, $pop23, $3
	i32.const	$push24=, 15
	i32.shl 	$push25=, $3, $pop24
	i32.const	$push26=, 130023424
	i32.and 	$push27=, $pop25, $pop26
	i32.xor 	$push28=, $pop27, $3
	i32.const	$push29=, 18
	i32.shr_u	$push30=, $pop28, $pop29
	i32.xor 	$push31=, $pop30, $3
	i32.const	$push32=, 1
	i32.shr_u	$push33=, $pop31, $pop32
	i32.const	$push34=, 255
	i32.and 	$push35=, $pop33, $pop34
                                        # fallthrough-return: $pop35
	.endfunc
.Lfunc_end2:
	.size	foo, .Lfunc_end2-foo
                                        # -- End function
	.type	p,@object               # @p
	.section	.data.p,"aw",@progbits
	.p2align	4
p:
	.ascii	"\300I\0272b\036.\325L\031(I\221\344r\203\221=\223\203\263a8"
	.size	p, 23

	.type	q,@object               # @q
	.section	.data.q,"aw",@progbits
	.p2align	4
q:
	.ascii	">AUTOIT UNICODE SCRIPT<"
	.size	q, 23


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
