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
	i32.const	$push130=, __stack_pointer
	i32.load	$push131=, 0($pop130)
	i32.const	$push132=, 2512
	i32.sub 	$3=, $pop131, $pop132
	i32.const	$push133=, __stack_pointer
	i32.store	$discard=, 0($pop133), $3
	i32.const	$push137=, 8
	i32.add 	$push138=, $3, $pop137
	i32.const	$push2=, 8
	i32.add 	$push3=, $pop138, $pop2
	i32.const	$push1=, 41589
	i32.store	$1=, 0($pop3), $pop1
	i32.const	$push139=, 8
	i32.add 	$push140=, $3, $pop139
	i32.const	$push4=, 12
	i32.add 	$0=, $pop140, $pop4
	i32.const	$2=, 1
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push84=, 30
	i32.shr_u	$push5=, $1, $pop84
	i32.xor 	$push6=, $pop5, $1
	i32.const	$push83=, 1812433253
	i32.mul 	$push7=, $pop6, $pop83
	i32.add 	$push0=, $pop7, $2
	i32.store	$1=, 0($0), $pop0
	i32.const	$push82=, 1
	i32.add 	$2=, $2, $pop82
	i32.const	$push81=, 4
	i32.add 	$0=, $0, $pop81
	i32.const	$push80=, 624
	i32.ne  	$push8=, $2, $pop80
	br_if   	0, $pop8        # 0: up to label1
# BB#2:                                 # %for.end
	end_loop                        # label2:
	i32.const	$push9=, 1
	i32.store	$discard=, 12($3), $pop9
	i32.const	$push11=, 0
	i32.const	$push141=, 8
	i32.add 	$push142=, $3, $pop141
	i32.call	$push10=, foo@FUNCTION, $pop142
	i32.const	$push129=, 0
	i32.load8_u	$push12=, p($pop129)
	i32.xor 	$push13=, $pop10, $pop12
	i32.store8	$discard=, p($pop11), $pop13
	i32.const	$push128=, 0
	i32.const	$push143=, 8
	i32.add 	$push144=, $3, $pop143
	i32.call	$push14=, foo@FUNCTION, $pop144
	i32.const	$push127=, 0
	i32.load8_u	$push15=, p+1($pop127)
	i32.xor 	$push16=, $pop14, $pop15
	i32.store8	$discard=, p+1($pop128), $pop16
	i32.const	$push126=, 0
	i32.const	$push145=, 8
	i32.add 	$push146=, $3, $pop145
	i32.call	$push17=, foo@FUNCTION, $pop146
	i32.const	$push125=, 0
	i32.load8_u	$push18=, p+2($pop125)
	i32.xor 	$push19=, $pop17, $pop18
	i32.store8	$discard=, p+2($pop126), $pop19
	i32.const	$push124=, 0
	i32.const	$push147=, 8
	i32.add 	$push148=, $3, $pop147
	i32.call	$push20=, foo@FUNCTION, $pop148
	i32.const	$push123=, 0
	i32.load8_u	$push21=, p+3($pop123)
	i32.xor 	$push22=, $pop20, $pop21
	i32.store8	$discard=, p+3($pop124), $pop22
	i32.const	$push122=, 0
	i32.const	$push149=, 8
	i32.add 	$push150=, $3, $pop149
	i32.call	$push23=, foo@FUNCTION, $pop150
	i32.const	$push121=, 0
	i32.load8_u	$push24=, p+4($pop121)
	i32.xor 	$push25=, $pop23, $pop24
	i32.store8	$discard=, p+4($pop122), $pop25
	i32.const	$push120=, 0
	i32.const	$push151=, 8
	i32.add 	$push152=, $3, $pop151
	i32.call	$push26=, foo@FUNCTION, $pop152
	i32.const	$push119=, 0
	i32.load8_u	$push27=, p+5($pop119)
	i32.xor 	$push28=, $pop26, $pop27
	i32.store8	$discard=, p+5($pop120), $pop28
	i32.const	$push118=, 0
	i32.const	$push153=, 8
	i32.add 	$push154=, $3, $pop153
	i32.call	$push29=, foo@FUNCTION, $pop154
	i32.const	$push117=, 0
	i32.load8_u	$push30=, p+6($pop117)
	i32.xor 	$push31=, $pop29, $pop30
	i32.store8	$discard=, p+6($pop118), $pop31
	i32.const	$push116=, 0
	i32.const	$push155=, 8
	i32.add 	$push156=, $3, $pop155
	i32.call	$push32=, foo@FUNCTION, $pop156
	i32.const	$push115=, 0
	i32.load8_u	$push33=, p+7($pop115)
	i32.xor 	$push34=, $pop32, $pop33
	i32.store8	$discard=, p+7($pop116), $pop34
	i32.const	$push114=, 0
	i32.const	$push157=, 8
	i32.add 	$push158=, $3, $pop157
	i32.call	$push35=, foo@FUNCTION, $pop158
	i32.const	$push113=, 0
	i32.load8_u	$push36=, p+8($pop113)
	i32.xor 	$push37=, $pop35, $pop36
	i32.store8	$discard=, p+8($pop114), $pop37
	i32.const	$push112=, 0
	i32.const	$push159=, 8
	i32.add 	$push160=, $3, $pop159
	i32.call	$push38=, foo@FUNCTION, $pop160
	i32.const	$push111=, 0
	i32.load8_u	$push39=, p+9($pop111)
	i32.xor 	$push40=, $pop38, $pop39
	i32.store8	$discard=, p+9($pop112), $pop40
	i32.const	$push110=, 0
	i32.const	$push161=, 8
	i32.add 	$push162=, $3, $pop161
	i32.call	$push41=, foo@FUNCTION, $pop162
	i32.const	$push109=, 0
	i32.load8_u	$push42=, p+10($pop109)
	i32.xor 	$push43=, $pop41, $pop42
	i32.store8	$discard=, p+10($pop110), $pop43
	i32.const	$push108=, 0
	i32.const	$push163=, 8
	i32.add 	$push164=, $3, $pop163
	i32.call	$push44=, foo@FUNCTION, $pop164
	i32.const	$push107=, 0
	i32.load8_u	$push45=, p+11($pop107)
	i32.xor 	$push46=, $pop44, $pop45
	i32.store8	$discard=, p+11($pop108), $pop46
	i32.const	$push106=, 0
	i32.const	$push165=, 8
	i32.add 	$push166=, $3, $pop165
	i32.call	$push47=, foo@FUNCTION, $pop166
	i32.const	$push105=, 0
	i32.load8_u	$push48=, p+12($pop105)
	i32.xor 	$push49=, $pop47, $pop48
	i32.store8	$discard=, p+12($pop106), $pop49
	i32.const	$push104=, 0
	i32.const	$push167=, 8
	i32.add 	$push168=, $3, $pop167
	i32.call	$push50=, foo@FUNCTION, $pop168
	i32.const	$push103=, 0
	i32.load8_u	$push51=, p+13($pop103)
	i32.xor 	$push52=, $pop50, $pop51
	i32.store8	$discard=, p+13($pop104), $pop52
	i32.const	$push102=, 0
	i32.const	$push169=, 8
	i32.add 	$push170=, $3, $pop169
	i32.call	$push53=, foo@FUNCTION, $pop170
	i32.const	$push101=, 0
	i32.load8_u	$push54=, p+14($pop101)
	i32.xor 	$push55=, $pop53, $pop54
	i32.store8	$discard=, p+14($pop102), $pop55
	i32.const	$push100=, 0
	i32.const	$push171=, 8
	i32.add 	$push172=, $3, $pop171
	i32.call	$push56=, foo@FUNCTION, $pop172
	i32.const	$push99=, 0
	i32.load8_u	$push57=, p+15($pop99)
	i32.xor 	$push58=, $pop56, $pop57
	i32.store8	$discard=, p+15($pop100), $pop58
	i32.const	$push98=, 0
	i32.const	$push173=, 8
	i32.add 	$push174=, $3, $pop173
	i32.call	$push59=, foo@FUNCTION, $pop174
	i32.const	$push97=, 0
	i32.load8_u	$push60=, p+16($pop97)
	i32.xor 	$push61=, $pop59, $pop60
	i32.store8	$discard=, p+16($pop98), $pop61
	i32.const	$push96=, 0
	i32.const	$push175=, 8
	i32.add 	$push176=, $3, $pop175
	i32.call	$push62=, foo@FUNCTION, $pop176
	i32.const	$push95=, 0
	i32.load8_u	$push63=, p+17($pop95)
	i32.xor 	$push64=, $pop62, $pop63
	i32.store8	$discard=, p+17($pop96), $pop64
	i32.const	$push94=, 0
	i32.const	$push177=, 8
	i32.add 	$push178=, $3, $pop177
	i32.call	$push65=, foo@FUNCTION, $pop178
	i32.const	$push93=, 0
	i32.load8_u	$push66=, p+18($pop93)
	i32.xor 	$push67=, $pop65, $pop66
	i32.store8	$discard=, p+18($pop94), $pop67
	i32.const	$push92=, 0
	i32.const	$push179=, 8
	i32.add 	$push180=, $3, $pop179
	i32.call	$push68=, foo@FUNCTION, $pop180
	i32.const	$push91=, 0
	i32.load8_u	$push69=, p+19($pop91)
	i32.xor 	$push70=, $pop68, $pop69
	i32.store8	$discard=, p+19($pop92), $pop70
	i32.const	$push90=, 0
	i32.const	$push181=, 8
	i32.add 	$push182=, $3, $pop181
	i32.call	$push71=, foo@FUNCTION, $pop182
	i32.const	$push89=, 0
	i32.load8_u	$push72=, p+20($pop89)
	i32.xor 	$push73=, $pop71, $pop72
	i32.store8	$discard=, p+20($pop90), $pop73
	i32.const	$push88=, 0
	i32.const	$push183=, 8
	i32.add 	$push184=, $3, $pop183
	i32.call	$push74=, foo@FUNCTION, $pop184
	i32.const	$push87=, 0
	i32.load8_u	$push75=, p+21($pop87)
	i32.xor 	$push76=, $pop74, $pop75
	i32.store8	$discard=, p+21($pop88), $pop76
	i32.const	$push86=, 0
	i32.const	$push185=, 8
	i32.add 	$push186=, $3, $pop185
	i32.call	$push77=, foo@FUNCTION, $pop186
	i32.const	$push85=, 0
	i32.load8_u	$push78=, p+22($pop85)
	i32.xor 	$push79=, $pop77, $pop78
	i32.store8	$discard=, p+22($pop86), $pop79
	i32.const	$push136=, __stack_pointer
	i32.const	$push134=, 2512
	i32.add 	$push135=, $3, $pop134
	i32.store	$discard=, 0($pop136), $pop135
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
	i32.load	$push0=, 4($0)
	i32.const	$push1=, -1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$push3=, 4($0), $pop2
	br_if   	0, $pop3        # 0: down to label3
# BB#1:                                 # %if.then
	i32.const	$push39=, 8
	i32.add 	$push4=, $0, $pop39
	i32.store	$discard=, 0($0), $pop4
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
	i32.store	$discard=, 0($pop17), $pop16
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
	i32.store	$discard=, 0($0), $pop20
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
