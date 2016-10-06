	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr37573.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	call    	bar@FUNCTION
	block   	
	i32.const	$push2=, p
	i32.const	$push1=, q
	i32.const	$push0=, 23
	i32.call	$push3=, memcmp@FUNCTION, $pop2, $pop1, $pop0
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.bar,"ax",@progbits
	.type	bar,@function
bar:                                    # @bar
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push81=, 0
	i32.const	$push78=, 0
	i32.load	$push79=, __stack_pointer($pop78)
	i32.const	$push80=, 2512
	i32.sub 	$push133=, $pop79, $pop80
	tee_local	$push132=, $3=, $pop133
	i32.store	__stack_pointer($pop81), $pop132
	i32.const	$1=, 41589
	i32.const	$push0=, 16
	i32.add 	$push1=, $3, $pop0
	i32.const	$push131=, 41589
	i32.store	0($pop1), $pop131
	i32.const	$push2=, 20
	i32.add 	$0=, $3, $pop2
	i32.const	$2=, 1
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push142=, 30
	i32.shr_u	$push3=, $1, $pop142
	i32.xor 	$push4=, $pop3, $1
	i32.const	$push141=, 1812433253
	i32.mul 	$push5=, $pop4, $pop141
	i32.add 	$push140=, $pop5, $2
	tee_local	$push139=, $1=, $pop140
	i32.store	0($0), $pop139
	i32.const	$push138=, 4
	i32.add 	$0=, $0, $pop138
	i32.const	$push137=, 1
	i32.add 	$push136=, $2, $pop137
	tee_local	$push135=, $2=, $pop136
	i32.const	$push134=, 624
	i32.ne  	$push6=, $pop135, $pop134
	br_if   	0, $pop6        # 0: up to label1
# BB#2:                                 # %for.end
	end_loop
	i32.const	$push7=, 1
	i32.store	12($3), $pop7
	i32.const	$push9=, 0
	i32.const	$push85=, 8
	i32.add 	$push86=, $3, $pop85
	i32.call	$push8=, foo@FUNCTION, $pop86
	i32.const	$push187=, 0
	i32.load8_u	$push10=, p($pop187)
	i32.xor 	$push11=, $pop8, $pop10
	i32.store8	p($pop9), $pop11
	i32.const	$push186=, 0
	i32.const	$push87=, 8
	i32.add 	$push88=, $3, $pop87
	i32.call	$push12=, foo@FUNCTION, $pop88
	i32.const	$push185=, 0
	i32.load8_u	$push13=, p+1($pop185)
	i32.xor 	$push14=, $pop12, $pop13
	i32.store8	p+1($pop186), $pop14
	i32.const	$push184=, 0
	i32.const	$push89=, 8
	i32.add 	$push90=, $3, $pop89
	i32.call	$push15=, foo@FUNCTION, $pop90
	i32.const	$push183=, 0
	i32.load8_u	$push16=, p+2($pop183)
	i32.xor 	$push17=, $pop15, $pop16
	i32.store8	p+2($pop184), $pop17
	i32.const	$push182=, 0
	i32.const	$push91=, 8
	i32.add 	$push92=, $3, $pop91
	i32.call	$push18=, foo@FUNCTION, $pop92
	i32.const	$push181=, 0
	i32.load8_u	$push19=, p+3($pop181)
	i32.xor 	$push20=, $pop18, $pop19
	i32.store8	p+3($pop182), $pop20
	i32.const	$push180=, 0
	i32.const	$push93=, 8
	i32.add 	$push94=, $3, $pop93
	i32.call	$push21=, foo@FUNCTION, $pop94
	i32.const	$push179=, 0
	i32.load8_u	$push22=, p+4($pop179)
	i32.xor 	$push23=, $pop21, $pop22
	i32.store8	p+4($pop180), $pop23
	i32.const	$push178=, 0
	i32.const	$push95=, 8
	i32.add 	$push96=, $3, $pop95
	i32.call	$push24=, foo@FUNCTION, $pop96
	i32.const	$push177=, 0
	i32.load8_u	$push25=, p+5($pop177)
	i32.xor 	$push26=, $pop24, $pop25
	i32.store8	p+5($pop178), $pop26
	i32.const	$push176=, 0
	i32.const	$push97=, 8
	i32.add 	$push98=, $3, $pop97
	i32.call	$push27=, foo@FUNCTION, $pop98
	i32.const	$push175=, 0
	i32.load8_u	$push28=, p+6($pop175)
	i32.xor 	$push29=, $pop27, $pop28
	i32.store8	p+6($pop176), $pop29
	i32.const	$push174=, 0
	i32.const	$push99=, 8
	i32.add 	$push100=, $3, $pop99
	i32.call	$push30=, foo@FUNCTION, $pop100
	i32.const	$push173=, 0
	i32.load8_u	$push31=, p+7($pop173)
	i32.xor 	$push32=, $pop30, $pop31
	i32.store8	p+7($pop174), $pop32
	i32.const	$push172=, 0
	i32.const	$push101=, 8
	i32.add 	$push102=, $3, $pop101
	i32.call	$push33=, foo@FUNCTION, $pop102
	i32.const	$push171=, 0
	i32.load8_u	$push34=, p+8($pop171)
	i32.xor 	$push35=, $pop33, $pop34
	i32.store8	p+8($pop172), $pop35
	i32.const	$push170=, 0
	i32.const	$push103=, 8
	i32.add 	$push104=, $3, $pop103
	i32.call	$push36=, foo@FUNCTION, $pop104
	i32.const	$push169=, 0
	i32.load8_u	$push37=, p+9($pop169)
	i32.xor 	$push38=, $pop36, $pop37
	i32.store8	p+9($pop170), $pop38
	i32.const	$push168=, 0
	i32.const	$push105=, 8
	i32.add 	$push106=, $3, $pop105
	i32.call	$push39=, foo@FUNCTION, $pop106
	i32.const	$push167=, 0
	i32.load8_u	$push40=, p+10($pop167)
	i32.xor 	$push41=, $pop39, $pop40
	i32.store8	p+10($pop168), $pop41
	i32.const	$push166=, 0
	i32.const	$push107=, 8
	i32.add 	$push108=, $3, $pop107
	i32.call	$push42=, foo@FUNCTION, $pop108
	i32.const	$push165=, 0
	i32.load8_u	$push43=, p+11($pop165)
	i32.xor 	$push44=, $pop42, $pop43
	i32.store8	p+11($pop166), $pop44
	i32.const	$push164=, 0
	i32.const	$push109=, 8
	i32.add 	$push110=, $3, $pop109
	i32.call	$push45=, foo@FUNCTION, $pop110
	i32.const	$push163=, 0
	i32.load8_u	$push46=, p+12($pop163)
	i32.xor 	$push47=, $pop45, $pop46
	i32.store8	p+12($pop164), $pop47
	i32.const	$push162=, 0
	i32.const	$push111=, 8
	i32.add 	$push112=, $3, $pop111
	i32.call	$push48=, foo@FUNCTION, $pop112
	i32.const	$push161=, 0
	i32.load8_u	$push49=, p+13($pop161)
	i32.xor 	$push50=, $pop48, $pop49
	i32.store8	p+13($pop162), $pop50
	i32.const	$push160=, 0
	i32.const	$push113=, 8
	i32.add 	$push114=, $3, $pop113
	i32.call	$push51=, foo@FUNCTION, $pop114
	i32.const	$push159=, 0
	i32.load8_u	$push52=, p+14($pop159)
	i32.xor 	$push53=, $pop51, $pop52
	i32.store8	p+14($pop160), $pop53
	i32.const	$push158=, 0
	i32.const	$push115=, 8
	i32.add 	$push116=, $3, $pop115
	i32.call	$push54=, foo@FUNCTION, $pop116
	i32.const	$push157=, 0
	i32.load8_u	$push55=, p+15($pop157)
	i32.xor 	$push56=, $pop54, $pop55
	i32.store8	p+15($pop158), $pop56
	i32.const	$push156=, 0
	i32.const	$push117=, 8
	i32.add 	$push118=, $3, $pop117
	i32.call	$push57=, foo@FUNCTION, $pop118
	i32.const	$push155=, 0
	i32.load8_u	$push58=, p+16($pop155)
	i32.xor 	$push59=, $pop57, $pop58
	i32.store8	p+16($pop156), $pop59
	i32.const	$push154=, 0
	i32.const	$push119=, 8
	i32.add 	$push120=, $3, $pop119
	i32.call	$push60=, foo@FUNCTION, $pop120
	i32.const	$push153=, 0
	i32.load8_u	$push61=, p+17($pop153)
	i32.xor 	$push62=, $pop60, $pop61
	i32.store8	p+17($pop154), $pop62
	i32.const	$push152=, 0
	i32.const	$push121=, 8
	i32.add 	$push122=, $3, $pop121
	i32.call	$push63=, foo@FUNCTION, $pop122
	i32.const	$push151=, 0
	i32.load8_u	$push64=, p+18($pop151)
	i32.xor 	$push65=, $pop63, $pop64
	i32.store8	p+18($pop152), $pop65
	i32.const	$push150=, 0
	i32.const	$push123=, 8
	i32.add 	$push124=, $3, $pop123
	i32.call	$push66=, foo@FUNCTION, $pop124
	i32.const	$push149=, 0
	i32.load8_u	$push67=, p+19($pop149)
	i32.xor 	$push68=, $pop66, $pop67
	i32.store8	p+19($pop150), $pop68
	i32.const	$push148=, 0
	i32.const	$push125=, 8
	i32.add 	$push126=, $3, $pop125
	i32.call	$push69=, foo@FUNCTION, $pop126
	i32.const	$push147=, 0
	i32.load8_u	$push70=, p+20($pop147)
	i32.xor 	$push71=, $pop69, $pop70
	i32.store8	p+20($pop148), $pop71
	i32.const	$push146=, 0
	i32.const	$push127=, 8
	i32.add 	$push128=, $3, $pop127
	i32.call	$push72=, foo@FUNCTION, $pop128
	i32.const	$push145=, 0
	i32.load8_u	$push73=, p+21($pop145)
	i32.xor 	$push74=, $pop72, $pop73
	i32.store8	p+21($pop146), $pop74
	i32.const	$push144=, 0
	i32.const	$push129=, 8
	i32.add 	$push130=, $3, $pop129
	i32.call	$push75=, foo@FUNCTION, $pop130
	i32.const	$push143=, 0
	i32.load8_u	$push76=, p+22($pop143)
	i32.xor 	$push77=, $pop75, $pop76
	i32.store8	p+22($pop144), $pop77
	i32.const	$push84=, 0
	i32.const	$push82=, 2512
	i32.add 	$push83=, $3, $pop82
	i32.store	__stack_pointer($pop84), $pop83
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.foo,"ax",@progbits
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 4($0)
	i32.const	$push1=, -1
	i32.add 	$push38=, $pop0, $pop1
	tee_local	$push37=, $4=, $pop38
	i32.store	4($0), $pop37
	block   	
	br_if   	0, $4           # 0: down to label2
# BB#1:                                 # %if.then
	i32.const	$push39=, 8
	i32.add 	$push2=, $0, $pop39
	i32.store	0($0), $pop2
	i32.load	$4=, 8($0)
	i32.const	$3=, 0
.LBB2_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	i32.add 	$push55=, $0, $3
	tee_local	$push54=, $2=, $pop55
	i32.const	$push53=, 8
	i32.add 	$push15=, $pop54, $pop53
	i32.const	$push52=, 0
	i32.const	$push51=, 12
	i32.add 	$push3=, $2, $pop51
	i32.load	$push50=, 0($pop3)
	tee_local	$push49=, $1=, $pop50
	i32.const	$push48=, 1
	i32.and 	$push4=, $pop49, $pop48
	i32.sub 	$push5=, $pop52, $pop4
	i32.const	$push47=, -1727483681
	i32.and 	$push6=, $pop5, $pop47
	i32.const	$push46=, 1596
	i32.add 	$push7=, $2, $pop46
	i32.load	$push8=, 0($pop7)
	i32.xor 	$push9=, $pop6, $pop8
	i32.xor 	$push10=, $1, $4
	i32.const	$push45=, 2147483646
	i32.and 	$push11=, $pop10, $pop45
	i32.xor 	$push12=, $pop11, $4
	i32.const	$push44=, 1
	i32.shr_u	$push13=, $pop12, $pop44
	i32.xor 	$push14=, $pop9, $pop13
	i32.store	0($pop15), $pop14
	copy_local	$4=, $1
	i32.const	$push43=, 4
	i32.add 	$push42=, $3, $pop43
	tee_local	$push41=, $3=, $pop42
	i32.const	$push40=, 908
	i32.ne  	$push16=, $pop41, $pop40
	br_if   	0, $pop16       # 0: up to label3
.LBB2_3:                                # %if.end
	end_loop
	end_block                       # label2:
	i32.load	$push63=, 0($0)
	tee_local	$push62=, $4=, $pop63
	i32.const	$push17=, 4
	i32.add 	$push18=, $pop62, $pop17
	i32.store	0($0), $pop18
	i32.load	$push61=, 0($4)
	tee_local	$push60=, $4=, $pop61
	i32.const	$push19=, 11
	i32.shr_u	$push20=, $pop60, $pop19
	i32.xor 	$push59=, $pop20, $4
	tee_local	$push58=, $4=, $pop59
	i32.const	$push21=, 7
	i32.shl 	$push22=, $pop58, $pop21
	i32.const	$push23=, -1658038656
	i32.and 	$push24=, $pop22, $pop23
	i32.xor 	$push57=, $pop24, $4
	tee_local	$push56=, $4=, $pop57
	i32.const	$push25=, 15
	i32.shl 	$push26=, $pop56, $pop25
	i32.const	$push27=, 130023424
	i32.and 	$push28=, $pop26, $pop27
	i32.xor 	$push29=, $pop28, $4
	i32.const	$push30=, 18
	i32.shr_u	$push31=, $pop29, $pop30
	i32.xor 	$push32=, $pop31, $4
	i32.const	$push33=, 1
	i32.shr_u	$push34=, $pop32, $pop33
	i32.const	$push35=, 255
	i32.and 	$push36=, $pop34, $pop35
                                        # fallthrough-return: $pop36
	.endfunc
.Lfunc_end2:
	.size	foo, .Lfunc_end2-foo

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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
