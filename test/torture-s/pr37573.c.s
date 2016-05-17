	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr37573.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	call    	bar@FUNCTION
	block
	i32.const	$push1=, p
	i32.const	$push0=, q
	i32.const	$push2=, 23
	i32.call	$push3=, memcmp@FUNCTION, $pop1, $pop0, $pop2
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
	i32.const	$3=, 41589
	i32.const	$push81=, __stack_pointer
	i32.const	$push78=, __stack_pointer
	i32.load	$push79=, 0($pop78)
	i32.const	$push80=, 2512
	i32.sub 	$push131=, $pop79, $pop80
	i32.store	$push134=, 0($pop81), $pop131
	tee_local	$push133=, $2=, $pop134
	i32.const	$push0=, 16
	i32.add 	$push1=, $pop133, $pop0
	i32.const	$push132=, 41589
	i32.store	$drop=, 0($pop1), $pop132
	i32.const	$push2=, 20
	i32.add 	$0=, $2, $pop2
	i32.const	$1=, 1
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push141=, 30
	i32.shr_u	$push3=, $3, $pop141
	i32.xor 	$push4=, $pop3, $3
	i32.const	$push140=, 1812433253
	i32.mul 	$push5=, $pop4, $pop140
	i32.add 	$push139=, $pop5, $1
	tee_local	$push138=, $3=, $pop139
	i32.store	$drop=, 0($0), $pop138
	i32.const	$push137=, 1
	i32.add 	$1=, $1, $pop137
	i32.const	$push136=, 4
	i32.add 	$0=, $0, $pop136
	i32.const	$push135=, 624
	i32.ne  	$push6=, $1, $pop135
	br_if   	0, $pop6        # 0: up to label1
# BB#2:                                 # %for.end
	end_loop                        # label2:
	i32.const	$push7=, 1
	i32.store	$drop=, 12($2), $pop7
	i32.const	$push9=, 0
	i32.const	$push85=, 8
	i32.add 	$push86=, $2, $pop85
	i32.call	$push8=, foo@FUNCTION, $pop86
	i32.const	$push186=, 0
	i32.load8_u	$push10=, p($pop186)
	i32.xor 	$push11=, $pop8, $pop10
	i32.store8	$drop=, p($pop9), $pop11
	i32.const	$push185=, 0
	i32.const	$push87=, 8
	i32.add 	$push88=, $2, $pop87
	i32.call	$push12=, foo@FUNCTION, $pop88
	i32.const	$push184=, 0
	i32.load8_u	$push13=, p+1($pop184)
	i32.xor 	$push14=, $pop12, $pop13
	i32.store8	$drop=, p+1($pop185), $pop14
	i32.const	$push183=, 0
	i32.const	$push89=, 8
	i32.add 	$push90=, $2, $pop89
	i32.call	$push15=, foo@FUNCTION, $pop90
	i32.const	$push182=, 0
	i32.load8_u	$push16=, p+2($pop182)
	i32.xor 	$push17=, $pop15, $pop16
	i32.store8	$drop=, p+2($pop183), $pop17
	i32.const	$push181=, 0
	i32.const	$push91=, 8
	i32.add 	$push92=, $2, $pop91
	i32.call	$push18=, foo@FUNCTION, $pop92
	i32.const	$push180=, 0
	i32.load8_u	$push19=, p+3($pop180)
	i32.xor 	$push20=, $pop18, $pop19
	i32.store8	$drop=, p+3($pop181), $pop20
	i32.const	$push179=, 0
	i32.const	$push93=, 8
	i32.add 	$push94=, $2, $pop93
	i32.call	$push21=, foo@FUNCTION, $pop94
	i32.const	$push178=, 0
	i32.load8_u	$push22=, p+4($pop178)
	i32.xor 	$push23=, $pop21, $pop22
	i32.store8	$drop=, p+4($pop179), $pop23
	i32.const	$push177=, 0
	i32.const	$push95=, 8
	i32.add 	$push96=, $2, $pop95
	i32.call	$push24=, foo@FUNCTION, $pop96
	i32.const	$push176=, 0
	i32.load8_u	$push25=, p+5($pop176)
	i32.xor 	$push26=, $pop24, $pop25
	i32.store8	$drop=, p+5($pop177), $pop26
	i32.const	$push175=, 0
	i32.const	$push97=, 8
	i32.add 	$push98=, $2, $pop97
	i32.call	$push27=, foo@FUNCTION, $pop98
	i32.const	$push174=, 0
	i32.load8_u	$push28=, p+6($pop174)
	i32.xor 	$push29=, $pop27, $pop28
	i32.store8	$drop=, p+6($pop175), $pop29
	i32.const	$push173=, 0
	i32.const	$push99=, 8
	i32.add 	$push100=, $2, $pop99
	i32.call	$push30=, foo@FUNCTION, $pop100
	i32.const	$push172=, 0
	i32.load8_u	$push31=, p+7($pop172)
	i32.xor 	$push32=, $pop30, $pop31
	i32.store8	$drop=, p+7($pop173), $pop32
	i32.const	$push171=, 0
	i32.const	$push101=, 8
	i32.add 	$push102=, $2, $pop101
	i32.call	$push33=, foo@FUNCTION, $pop102
	i32.const	$push170=, 0
	i32.load8_u	$push34=, p+8($pop170)
	i32.xor 	$push35=, $pop33, $pop34
	i32.store8	$drop=, p+8($pop171), $pop35
	i32.const	$push169=, 0
	i32.const	$push103=, 8
	i32.add 	$push104=, $2, $pop103
	i32.call	$push36=, foo@FUNCTION, $pop104
	i32.const	$push168=, 0
	i32.load8_u	$push37=, p+9($pop168)
	i32.xor 	$push38=, $pop36, $pop37
	i32.store8	$drop=, p+9($pop169), $pop38
	i32.const	$push167=, 0
	i32.const	$push105=, 8
	i32.add 	$push106=, $2, $pop105
	i32.call	$push39=, foo@FUNCTION, $pop106
	i32.const	$push166=, 0
	i32.load8_u	$push40=, p+10($pop166)
	i32.xor 	$push41=, $pop39, $pop40
	i32.store8	$drop=, p+10($pop167), $pop41
	i32.const	$push165=, 0
	i32.const	$push107=, 8
	i32.add 	$push108=, $2, $pop107
	i32.call	$push42=, foo@FUNCTION, $pop108
	i32.const	$push164=, 0
	i32.load8_u	$push43=, p+11($pop164)
	i32.xor 	$push44=, $pop42, $pop43
	i32.store8	$drop=, p+11($pop165), $pop44
	i32.const	$push163=, 0
	i32.const	$push109=, 8
	i32.add 	$push110=, $2, $pop109
	i32.call	$push45=, foo@FUNCTION, $pop110
	i32.const	$push162=, 0
	i32.load8_u	$push46=, p+12($pop162)
	i32.xor 	$push47=, $pop45, $pop46
	i32.store8	$drop=, p+12($pop163), $pop47
	i32.const	$push161=, 0
	i32.const	$push111=, 8
	i32.add 	$push112=, $2, $pop111
	i32.call	$push48=, foo@FUNCTION, $pop112
	i32.const	$push160=, 0
	i32.load8_u	$push49=, p+13($pop160)
	i32.xor 	$push50=, $pop48, $pop49
	i32.store8	$drop=, p+13($pop161), $pop50
	i32.const	$push159=, 0
	i32.const	$push113=, 8
	i32.add 	$push114=, $2, $pop113
	i32.call	$push51=, foo@FUNCTION, $pop114
	i32.const	$push158=, 0
	i32.load8_u	$push52=, p+14($pop158)
	i32.xor 	$push53=, $pop51, $pop52
	i32.store8	$drop=, p+14($pop159), $pop53
	i32.const	$push157=, 0
	i32.const	$push115=, 8
	i32.add 	$push116=, $2, $pop115
	i32.call	$push54=, foo@FUNCTION, $pop116
	i32.const	$push156=, 0
	i32.load8_u	$push55=, p+15($pop156)
	i32.xor 	$push56=, $pop54, $pop55
	i32.store8	$drop=, p+15($pop157), $pop56
	i32.const	$push155=, 0
	i32.const	$push117=, 8
	i32.add 	$push118=, $2, $pop117
	i32.call	$push57=, foo@FUNCTION, $pop118
	i32.const	$push154=, 0
	i32.load8_u	$push58=, p+16($pop154)
	i32.xor 	$push59=, $pop57, $pop58
	i32.store8	$drop=, p+16($pop155), $pop59
	i32.const	$push153=, 0
	i32.const	$push119=, 8
	i32.add 	$push120=, $2, $pop119
	i32.call	$push60=, foo@FUNCTION, $pop120
	i32.const	$push152=, 0
	i32.load8_u	$push61=, p+17($pop152)
	i32.xor 	$push62=, $pop60, $pop61
	i32.store8	$drop=, p+17($pop153), $pop62
	i32.const	$push151=, 0
	i32.const	$push121=, 8
	i32.add 	$push122=, $2, $pop121
	i32.call	$push63=, foo@FUNCTION, $pop122
	i32.const	$push150=, 0
	i32.load8_u	$push64=, p+18($pop150)
	i32.xor 	$push65=, $pop63, $pop64
	i32.store8	$drop=, p+18($pop151), $pop65
	i32.const	$push149=, 0
	i32.const	$push123=, 8
	i32.add 	$push124=, $2, $pop123
	i32.call	$push66=, foo@FUNCTION, $pop124
	i32.const	$push148=, 0
	i32.load8_u	$push67=, p+19($pop148)
	i32.xor 	$push68=, $pop66, $pop67
	i32.store8	$drop=, p+19($pop149), $pop68
	i32.const	$push147=, 0
	i32.const	$push125=, 8
	i32.add 	$push126=, $2, $pop125
	i32.call	$push69=, foo@FUNCTION, $pop126
	i32.const	$push146=, 0
	i32.load8_u	$push70=, p+20($pop146)
	i32.xor 	$push71=, $pop69, $pop70
	i32.store8	$drop=, p+20($pop147), $pop71
	i32.const	$push145=, 0
	i32.const	$push127=, 8
	i32.add 	$push128=, $2, $pop127
	i32.call	$push72=, foo@FUNCTION, $pop128
	i32.const	$push144=, 0
	i32.load8_u	$push73=, p+21($pop144)
	i32.xor 	$push74=, $pop72, $pop73
	i32.store8	$drop=, p+21($pop145), $pop74
	i32.const	$push143=, 0
	i32.const	$push129=, 8
	i32.add 	$push130=, $2, $pop129
	i32.call	$push75=, foo@FUNCTION, $pop130
	i32.const	$push142=, 0
	i32.load8_u	$push76=, p+22($pop142)
	i32.xor 	$push77=, $pop75, $pop76
	i32.store8	$drop=, p+22($pop143), $pop77
	i32.const	$push84=, __stack_pointer
	i32.const	$push82=, 2512
	i32.add 	$push83=, $2, $pop82
	i32.store	$drop=, 0($pop84), $pop83
	return
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
	block
	i32.load	$push1=, 4($0)
	i32.const	$push2=, -1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$push0=, 4($0), $pop3
	br_if   	0, $pop0        # 0: down to label3
# BB#1:                                 # %if.then
	i32.const	$push39=, 8
	i32.add 	$push4=, $0, $pop39
	i32.store	$drop=, 0($0), $pop4
	i32.load	$2=, 8($0)
	i32.const	$1=, 0
.LBB2_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label4:
	i32.add 	$push53=, $0, $1
	tee_local	$push52=, $4=, $pop53
	i32.const	$push51=, 8
	i32.add 	$push17=, $pop52, $pop51
	i32.const	$push50=, 0
	i32.const	$push49=, 12
	i32.add 	$push5=, $4, $pop49
	i32.load	$push48=, 0($pop5)
	tee_local	$push47=, $3=, $pop48
	i32.const	$push46=, 1
	i32.and 	$push10=, $pop47, $pop46
	i32.sub 	$push11=, $pop50, $pop10
	i32.const	$push45=, -1727483681
	i32.and 	$push12=, $pop11, $pop45
	i32.const	$push44=, 1596
	i32.add 	$push13=, $4, $pop44
	i32.load	$push14=, 0($pop13)
	i32.xor 	$push15=, $pop12, $pop14
	i32.xor 	$push6=, $3, $2
	i32.const	$push43=, 2147483646
	i32.and 	$push7=, $pop6, $pop43
	i32.xor 	$push8=, $pop7, $2
	i32.const	$push42=, 1
	i32.shr_u	$push9=, $pop8, $pop42
	i32.xor 	$push16=, $pop15, $pop9
	i32.store	$drop=, 0($pop17), $pop16
	i32.const	$push41=, 4
	i32.add 	$1=, $1, $pop41
	copy_local	$2=, $3
	i32.const	$push40=, 908
	i32.ne  	$push18=, $1, $pop40
	br_if   	0, $pop18       # 0: up to label4
.LBB2_3:                                # %if.end
	end_loop                        # label5:
	end_block                       # label3:
	i32.load	$push59=, 0($0)
	tee_local	$push58=, $2=, $pop59
	i32.load	$1=, 0($pop58)
	i32.const	$push19=, 4
	i32.add 	$push20=, $2, $pop19
	i32.store	$drop=, 0($0), $pop20
	i32.const	$push21=, 11
	i32.shr_u	$push22=, $1, $pop21
	i32.xor 	$push57=, $1, $pop22
	tee_local	$push56=, $1=, $pop57
	i32.const	$push23=, 7
	i32.shl 	$push24=, $pop56, $pop23
	i32.const	$push25=, -1658038656
	i32.and 	$push26=, $pop24, $pop25
	i32.xor 	$push55=, $pop26, $1
	tee_local	$push54=, $1=, $pop55
	i32.const	$push27=, 15
	i32.shl 	$push28=, $pop54, $pop27
	i32.const	$push29=, 130023424
	i32.and 	$push30=, $pop28, $pop29
	i32.xor 	$push31=, $pop30, $1
	i32.const	$push32=, 18
	i32.shr_u	$push33=, $pop31, $pop32
	i32.xor 	$push34=, $pop33, $1
	i32.const	$push35=, 1
	i32.shr_u	$push36=, $pop34, $pop35
	i32.const	$push37=, 255
	i32.and 	$push38=, $pop36, $pop37
	return  	$pop38
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


	.ident	"clang version 3.9.0 "
