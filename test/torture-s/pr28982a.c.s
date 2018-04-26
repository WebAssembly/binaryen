	.text
	.file	"pr28982a.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32
# %bb.0:                                # %entry
	block   	
	block   	
	i32.eqz 	$push141=, $0
	br_if   	0, $pop141      # 0: down to label1
# %bb.1:                                # %while.body.lr.ph
	i32.const	$push119=, 0
	i32.load	$push0=, incs($pop119)
	i32.const	$push40=, 2
	i32.shl 	$20=, $pop0, $pop40
	i32.const	$push118=, 0
	i32.load	$push1=, incs+4($pop118)
	i32.const	$push117=, 2
	i32.shl 	$19=, $pop1, $pop117
	i32.const	$push116=, 0
	i32.load	$push2=, incs+8($pop116)
	i32.const	$push115=, 2
	i32.shl 	$18=, $pop2, $pop115
	i32.const	$push114=, 0
	i32.load	$push3=, incs+12($pop114)
	i32.const	$push113=, 2
	i32.shl 	$17=, $pop3, $pop113
	i32.const	$push112=, 0
	i32.load	$push4=, incs+16($pop112)
	i32.const	$push111=, 2
	i32.shl 	$16=, $pop4, $pop111
	i32.const	$push110=, 0
	i32.load	$push5=, incs+20($pop110)
	i32.const	$push109=, 2
	i32.shl 	$15=, $pop5, $pop109
	i32.const	$push108=, 0
	i32.load	$push6=, incs+24($pop108)
	i32.const	$push107=, 2
	i32.shl 	$14=, $pop6, $pop107
	i32.const	$push106=, 0
	i32.load	$push7=, incs+28($pop106)
	i32.const	$push105=, 2
	i32.shl 	$13=, $pop7, $pop105
	i32.const	$push104=, 0
	i32.load	$push8=, incs+32($pop104)
	i32.const	$push103=, 2
	i32.shl 	$12=, $pop8, $pop103
	i32.const	$push102=, 0
	i32.load	$push9=, incs+36($pop102)
	i32.const	$push101=, 2
	i32.shl 	$11=, $pop9, $pop101
	i32.const	$push100=, 0
	i32.load	$push10=, incs+40($pop100)
	i32.const	$push99=, 2
	i32.shl 	$10=, $pop10, $pop99
	i32.const	$push98=, 0
	i32.load	$push11=, incs+44($pop98)
	i32.const	$push97=, 2
	i32.shl 	$9=, $pop11, $pop97
	i32.const	$push96=, 0
	i32.load	$push12=, incs+48($pop96)
	i32.const	$push95=, 2
	i32.shl 	$8=, $pop12, $pop95
	i32.const	$push94=, 0
	i32.load	$push13=, incs+52($pop94)
	i32.const	$push93=, 2
	i32.shl 	$7=, $pop13, $pop93
	i32.const	$push92=, 0
	i32.load	$push14=, incs+56($pop92)
	i32.const	$push91=, 2
	i32.shl 	$6=, $pop14, $pop91
	i32.const	$push90=, 0
	i32.load	$push15=, incs+60($pop90)
	i32.const	$push89=, 2
	i32.shl 	$5=, $pop15, $pop89
	i32.const	$push88=, 0
	i32.load	$push16=, incs+64($pop88)
	i32.const	$push87=, 2
	i32.shl 	$4=, $pop16, $pop87
	i32.const	$push86=, 0
	i32.load	$push17=, incs+68($pop86)
	i32.const	$push85=, 2
	i32.shl 	$3=, $pop17, $pop85
	i32.const	$push84=, 0
	i32.load	$push18=, incs+72($pop84)
	i32.const	$push83=, 2
	i32.shl 	$2=, $pop18, $pop83
	i32.const	$push82=, 0
	i32.load	$push19=, incs+76($pop82)
	i32.const	$push81=, 2
	i32.shl 	$1=, $pop19, $pop81
	i32.const	$push80=, 0
	i32.load	$21=, ptrs($pop80)
	i32.const	$push79=, 0
	i32.load	$22=, ptrs+4($pop79)
	i32.const	$push78=, 0
	i32.load	$23=, ptrs+8($pop78)
	i32.const	$push77=, 0
	i32.load	$24=, ptrs+12($pop77)
	i32.const	$push76=, 0
	i32.load	$25=, ptrs+16($pop76)
	i32.const	$push75=, 0
	i32.load	$26=, ptrs+20($pop75)
	i32.const	$push74=, 0
	i32.load	$27=, ptrs+24($pop74)
	i32.const	$push73=, 0
	i32.load	$28=, ptrs+28($pop73)
	i32.const	$push72=, 0
	i32.load	$29=, ptrs+32($pop72)
	i32.const	$push71=, 0
	i32.load	$30=, ptrs+36($pop71)
	i32.const	$push70=, 0
	i32.load	$31=, ptrs+40($pop70)
	i32.const	$push69=, 0
	i32.load	$32=, ptrs+44($pop69)
	i32.const	$push68=, 0
	i32.load	$33=, ptrs+48($pop68)
	i32.const	$push67=, 0
	i32.load	$34=, ptrs+52($pop67)
	i32.const	$push66=, 0
	i32.load	$35=, ptrs+56($pop66)
	i32.const	$push65=, 0
	i32.load	$36=, ptrs+60($pop65)
	i32.const	$push64=, 0
	i32.load	$37=, ptrs+64($pop64)
	i32.const	$push63=, 0
	i32.load	$38=, ptrs+68($pop63)
	i32.const	$push62=, 0
	i32.load	$39=, ptrs+72($pop62)
	i32.const	$push61=, 0
	i32.load	$40=, ptrs+76($pop61)
	f32.const	$60=, 0x0p0
	f32.const	$59=, 0x0p0
	f32.const	$58=, 0x0p0
	f32.const	$57=, 0x0p0
	f32.const	$56=, 0x0p0
	f32.const	$55=, 0x0p0
	f32.const	$54=, 0x0p0
	f32.const	$53=, 0x0p0
	f32.const	$52=, 0x0p0
	f32.const	$51=, 0x0p0
	f32.const	$50=, 0x0p0
	f32.const	$49=, 0x0p0
	f32.const	$48=, 0x0p0
	f32.const	$47=, 0x0p0
	f32.const	$46=, 0x0p0
	f32.const	$45=, 0x0p0
	f32.const	$44=, 0x0p0
	f32.const	$43=, 0x0p0
	f32.const	$42=, 0x0p0
	f32.const	$41=, 0x0p0
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
	i32.const	$push120=, -1
	i32.add 	$0=, $0, $pop120
	f32.load	$push41=, 0($40)
	f32.add 	$60=, $60, $pop41
	f32.load	$push42=, 0($39)
	f32.add 	$59=, $59, $pop42
	f32.load	$push43=, 0($38)
	f32.add 	$58=, $58, $pop43
	f32.load	$push44=, 0($37)
	f32.add 	$57=, $57, $pop44
	f32.load	$push45=, 0($36)
	f32.add 	$56=, $56, $pop45
	f32.load	$push46=, 0($35)
	f32.add 	$55=, $55, $pop46
	f32.load	$push47=, 0($34)
	f32.add 	$54=, $54, $pop47
	f32.load	$push48=, 0($33)
	f32.add 	$53=, $53, $pop48
	f32.load	$push49=, 0($32)
	f32.add 	$52=, $52, $pop49
	f32.load	$push50=, 0($31)
	f32.add 	$51=, $51, $pop50
	f32.load	$push51=, 0($30)
	f32.add 	$50=, $50, $pop51
	f32.load	$push52=, 0($29)
	f32.add 	$49=, $49, $pop52
	f32.load	$push53=, 0($28)
	f32.add 	$48=, $48, $pop53
	f32.load	$push54=, 0($27)
	f32.add 	$47=, $47, $pop54
	f32.load	$push55=, 0($26)
	f32.add 	$46=, $46, $pop55
	f32.load	$push56=, 0($25)
	f32.add 	$45=, $45, $pop56
	f32.load	$push57=, 0($24)
	f32.add 	$44=, $44, $pop57
	f32.load	$push58=, 0($23)
	f32.add 	$43=, $43, $pop58
	f32.load	$push59=, 0($22)
	f32.add 	$42=, $42, $pop59
	f32.load	$push60=, 0($21)
	f32.add 	$41=, $41, $pop60
	i32.add 	$push39=, $21, $20
	copy_local	$21=, $pop39
	i32.add 	$push38=, $22, $19
	copy_local	$22=, $pop38
	i32.add 	$push37=, $23, $18
	copy_local	$23=, $pop37
	i32.add 	$push36=, $24, $17
	copy_local	$24=, $pop36
	i32.add 	$push35=, $25, $16
	copy_local	$25=, $pop35
	i32.add 	$push34=, $26, $15
	copy_local	$26=, $pop34
	i32.add 	$push33=, $27, $14
	copy_local	$27=, $pop33
	i32.add 	$push32=, $28, $13
	copy_local	$28=, $pop32
	i32.add 	$push31=, $29, $12
	copy_local	$29=, $pop31
	i32.add 	$push30=, $30, $11
	copy_local	$30=, $pop30
	i32.add 	$push29=, $31, $10
	copy_local	$31=, $pop29
	i32.add 	$push28=, $32, $9
	copy_local	$32=, $pop28
	i32.add 	$push27=, $33, $8
	copy_local	$33=, $pop27
	i32.add 	$push26=, $34, $7
	copy_local	$34=, $pop26
	i32.add 	$push25=, $35, $6
	copy_local	$35=, $pop25
	i32.add 	$push24=, $36, $5
	copy_local	$36=, $pop24
	i32.add 	$push23=, $37, $4
	copy_local	$37=, $pop23
	i32.add 	$push22=, $38, $3
	copy_local	$38=, $pop22
	i32.add 	$push21=, $39, $2
	copy_local	$39=, $pop21
	i32.add 	$push20=, $40, $1
	copy_local	$40=, $pop20
	br_if   	0, $0           # 0: up to label2
	br      	2               # 2: down to label0
.LBB0_3:
	end_loop
	end_block                       # label1:
	f32.const	$41=, 0x0p0
	f32.const	$42=, 0x0p0
	f32.const	$43=, 0x0p0
	f32.const	$44=, 0x0p0
	f32.const	$45=, 0x0p0
	f32.const	$46=, 0x0p0
	f32.const	$47=, 0x0p0
	f32.const	$48=, 0x0p0
	f32.const	$49=, 0x0p0
	f32.const	$50=, 0x0p0
	f32.const	$51=, 0x0p0
	f32.const	$52=, 0x0p0
	f32.const	$53=, 0x0p0
	f32.const	$54=, 0x0p0
	f32.const	$55=, 0x0p0
	f32.const	$56=, 0x0p0
	f32.const	$57=, 0x0p0
	f32.const	$58=, 0x0p0
	f32.const	$59=, 0x0p0
	f32.const	$60=, 0x0p0
.LBB0_4:                                # %while.end
	end_block                       # label0:
	i32.const	$push140=, 0
	f32.store	results+4($pop140), $42
	i32.const	$push139=, 0
	f32.store	results($pop139), $41
	i32.const	$push138=, 0
	f32.store	results+8($pop138), $43
	i32.const	$push137=, 0
	f32.store	results+12($pop137), $44
	i32.const	$push136=, 0
	f32.store	results+16($pop136), $45
	i32.const	$push135=, 0
	f32.store	results+20($pop135), $46
	i32.const	$push134=, 0
	f32.store	results+24($pop134), $47
	i32.const	$push133=, 0
	f32.store	results+28($pop133), $48
	i32.const	$push132=, 0
	f32.store	results+32($pop132), $49
	i32.const	$push131=, 0
	f32.store	results+36($pop131), $50
	i32.const	$push130=, 0
	f32.store	results+40($pop130), $51
	i32.const	$push129=, 0
	f32.store	results+44($pop129), $52
	i32.const	$push128=, 0
	f32.store	results+48($pop128), $53
	i32.const	$push127=, 0
	f32.store	results+52($pop127), $54
	i32.const	$push126=, 0
	f32.store	results+56($pop126), $55
	i32.const	$push125=, 0
	f32.store	results+60($pop125), $56
	i32.const	$push124=, 0
	f32.store	results+64($pop124), $57
	i32.const	$push123=, 0
	f32.store	results+68($pop123), $58
	i32.const	$push122=, 0
	f32.store	results+72($pop122), $59
	i32.const	$push121=, 0
	f32.store	results+76($pop121), $60
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$0=, input
	i32.const	$1=, 0
	i32.const	$push154=, 0
	i32.const	$push153=, input
	i32.store	ptrs($pop154), $pop153
	i32.const	$push152=, 0
	i32.const	$push0=, input+4
	i32.store	ptrs+4($pop152), $pop0
	i32.const	$push151=, 0
	i32.const	$push1=, input+8
	i32.store	ptrs+8($pop151), $pop1
	i32.const	$push150=, 0
	i64.const	$push2=, 8589934593
	i64.store	incs+4($pop150):p2align=2, $pop2
	i32.const	$push149=, 0
	i32.const	$push3=, input+12
	i32.store	ptrs+12($pop149), $pop3
	i32.const	$push148=, 0
	i32.const	$push4=, input+16
	i32.store	ptrs+16($pop148), $pop4
	i32.const	$push147=, 0
	i64.const	$push5=, 17179869187
	i64.store	incs+12($pop147):p2align=2, $pop5
	i32.const	$push146=, 0
	i32.const	$push6=, input+20
	i32.store	ptrs+20($pop146), $pop6
	i32.const	$push145=, 0
	i32.const	$push7=, input+24
	i32.store	ptrs+24($pop145), $pop7
	i32.const	$push144=, 0
	i64.const	$push8=, 25769803781
	i64.store	incs+20($pop144):p2align=2, $pop8
	i32.const	$push143=, 0
	i32.const	$push9=, input+28
	i32.store	ptrs+28($pop143), $pop9
	i32.const	$push142=, 0
	i32.const	$push10=, input+32
	i32.store	ptrs+32($pop142), $pop10
	i32.const	$push141=, 0
	i64.const	$push11=, 34359738375
	i64.store	incs+28($pop141):p2align=2, $pop11
	i32.const	$push140=, 0
	i32.const	$push12=, input+36
	i32.store	ptrs+36($pop140), $pop12
	i32.const	$push139=, 0
	i32.const	$push13=, input+40
	i32.store	ptrs+40($pop139), $pop13
	i32.const	$push138=, 0
	i64.const	$push14=, 42949672969
	i64.store	incs+36($pop138):p2align=2, $pop14
	i32.const	$push137=, 0
	i32.const	$push15=, input+44
	i32.store	ptrs+44($pop137), $pop15
	i32.const	$push136=, 0
	i32.const	$push135=, 0
	i32.store	incs($pop136), $pop135
	i32.const	$push134=, 0
	i32.const	$push16=, input+48
	i32.store	ptrs+48($pop134), $pop16
	i32.const	$push133=, 0
	i32.const	$push17=, 11
	i32.store	incs+44($pop133), $pop17
	i32.const	$push132=, 0
	i32.const	$push18=, 12
	i32.store	incs+48($pop132), $pop18
	i32.const	$push131=, 0
	i32.const	$push19=, input+52
	i32.store	ptrs+52($pop131), $pop19
	i32.const	$push130=, 0
	i32.const	$push20=, 13
	i32.store	incs+52($pop130), $pop20
	i32.const	$push129=, 0
	i32.const	$push21=, input+56
	i32.store	ptrs+56($pop129), $pop21
	i32.const	$push128=, 0
	i32.const	$push22=, 14
	i32.store	incs+56($pop128), $pop22
	i32.const	$push127=, 0
	i32.const	$push23=, input+60
	i32.store	ptrs+60($pop127), $pop23
	i32.const	$push126=, 0
	i32.const	$push24=, 15
	i32.store	incs+60($pop126), $pop24
	i32.const	$push125=, 0
	i32.const	$push25=, input+64
	i32.store	ptrs+64($pop125), $pop25
	i32.const	$push124=, 0
	i32.const	$push26=, 16
	i32.store	incs+64($pop124), $pop26
	i32.const	$push123=, 0
	i32.const	$push27=, input+68
	i32.store	ptrs+68($pop123), $pop27
	i32.const	$push122=, 0
	i32.const	$push28=, 17
	i32.store	incs+68($pop122), $pop28
	i32.const	$push121=, 0
	i32.const	$push29=, input+72
	i32.store	ptrs+72($pop121), $pop29
	i32.const	$push120=, 0
	i32.const	$push30=, 18
	i32.store	incs+72($pop120), $pop30
	i32.const	$push119=, 0
	i32.const	$push31=, input+76
	i32.store	ptrs+76($pop119), $pop31
	i32.const	$push118=, 0
	i32.const	$push32=, 19
	i32.store	incs+76($pop118), $pop32
.LBB1_1:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	f32.convert_s/i32	$push33=, $1
	f32.store	0($0), $pop33
	i32.const	$push157=, 4
	i32.add 	$0=, $0, $pop157
	i32.const	$push156=, 1
	i32.add 	$1=, $1, $pop156
	i32.const	$push155=, 80
	i32.ne  	$push34=, $1, $pop155
	br_if   	0, $pop34       # 0: up to label3
# %bb.2:                                # %for.end8
	end_loop
	i32.const	$push35=, 4
	call    	foo@FUNCTION, $pop35
	i32.const	$push36=, 0
	f32.load	$push40=, results($pop36)
	f32.const	$push41=, 0x0p0
	f32.ne  	$push42=, $pop40, $pop41
	i32.const	$push176=, 0
	f32.load	$push37=, results+4($pop176)
	f32.const	$push38=, 0x1.4p3
	f32.ne  	$push39=, $pop37, $pop38
	i32.or  	$push43=, $pop42, $pop39
	i32.const	$push175=, 0
	f32.load	$push44=, results+8($pop175)
	f32.const	$push45=, 0x1.4p4
	f32.ne  	$push46=, $pop44, $pop45
	i32.or  	$push47=, $pop43, $pop46
	i32.const	$push174=, 0
	f32.load	$push48=, results+12($pop174)
	f32.const	$push49=, 0x1.ep4
	f32.ne  	$push50=, $pop48, $pop49
	i32.or  	$push51=, $pop47, $pop50
	i32.const	$push173=, 0
	f32.load	$push52=, results+16($pop173)
	f32.const	$push53=, 0x1.4p5
	f32.ne  	$push54=, $pop52, $pop53
	i32.or  	$push55=, $pop51, $pop54
	i32.const	$push172=, 0
	f32.load	$push56=, results+20($pop172)
	f32.const	$push57=, 0x1.9p5
	f32.ne  	$push58=, $pop56, $pop57
	i32.or  	$push59=, $pop55, $pop58
	i32.const	$push171=, 0
	f32.load	$push60=, results+24($pop171)
	f32.const	$push61=, 0x1.ep5
	f32.ne  	$push62=, $pop60, $pop61
	i32.or  	$push63=, $pop59, $pop62
	i32.const	$push170=, 0
	f32.load	$push64=, results+28($pop170)
	f32.const	$push65=, 0x1.18p6
	f32.ne  	$push66=, $pop64, $pop65
	i32.or  	$push67=, $pop63, $pop66
	i32.const	$push169=, 0
	f32.load	$push68=, results+32($pop169)
	f32.const	$push69=, 0x1.4p6
	f32.ne  	$push70=, $pop68, $pop69
	i32.or  	$push71=, $pop67, $pop70
	i32.const	$push168=, 0
	f32.load	$push72=, results+36($pop168)
	f32.const	$push73=, 0x1.68p6
	f32.ne  	$push74=, $pop72, $pop73
	i32.or  	$push75=, $pop71, $pop74
	i32.const	$push167=, 0
	f32.load	$push76=, results+40($pop167)
	f32.const	$push77=, 0x1.9p6
	f32.ne  	$push78=, $pop76, $pop77
	i32.or  	$push79=, $pop75, $pop78
	i32.const	$push166=, 0
	f32.load	$push80=, results+44($pop166)
	f32.const	$push81=, 0x1.b8p6
	f32.ne  	$push82=, $pop80, $pop81
	i32.or  	$push83=, $pop79, $pop82
	i32.const	$push165=, 0
	f32.load	$push84=, results+48($pop165)
	f32.const	$push85=, 0x1.ep6
	f32.ne  	$push86=, $pop84, $pop85
	i32.or  	$push87=, $pop83, $pop86
	i32.const	$push164=, 0
	f32.load	$push88=, results+52($pop164)
	f32.const	$push89=, 0x1.04p7
	f32.ne  	$push90=, $pop88, $pop89
	i32.or  	$push91=, $pop87, $pop90
	i32.const	$push163=, 0
	f32.load	$push92=, results+56($pop163)
	f32.const	$push93=, 0x1.18p7
	f32.ne  	$push94=, $pop92, $pop93
	i32.or  	$push95=, $pop91, $pop94
	i32.const	$push162=, 0
	f32.load	$push96=, results+60($pop162)
	f32.const	$push97=, 0x1.2cp7
	f32.ne  	$push98=, $pop96, $pop97
	i32.or  	$push99=, $pop95, $pop98
	i32.const	$push161=, 0
	f32.load	$push100=, results+64($pop161)
	f32.const	$push101=, 0x1.4p7
	f32.ne  	$push102=, $pop100, $pop101
	i32.or  	$push103=, $pop99, $pop102
	i32.const	$push160=, 0
	f32.load	$push104=, results+68($pop160)
	f32.const	$push105=, 0x1.54p7
	f32.ne  	$push106=, $pop104, $pop105
	i32.or  	$push107=, $pop103, $pop106
	i32.const	$push159=, 0
	f32.load	$push108=, results+72($pop159)
	f32.const	$push109=, 0x1.68p7
	f32.ne  	$push110=, $pop108, $pop109
	i32.or  	$push111=, $pop107, $pop110
	i32.const	$push158=, 0
	f32.load	$push112=, results+76($pop158)
	f32.const	$push113=, 0x1.7cp7
	f32.ne  	$push114=, $pop112, $pop113
	i32.or  	$push115=, $pop111, $pop114
	i32.const	$push116=, 1
	i32.and 	$push117=, $pop115, $pop116
                                        # fallthrough-return: $pop117
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	incs                    # @incs
	.type	incs,@object
	.section	.bss.incs,"aw",@nobits
	.globl	incs
	.p2align	4
incs:
	.skip	80
	.size	incs, 80

	.hidden	ptrs                    # @ptrs
	.type	ptrs,@object
	.section	.bss.ptrs,"aw",@nobits
	.globl	ptrs
	.p2align	4
ptrs:
	.skip	80
	.size	ptrs, 80

	.hidden	results                 # @results
	.type	results,@object
	.section	.bss.results,"aw",@nobits
	.globl	results
	.p2align	4
results:
	.skip	80
	.size	results, 80

	.hidden	input                   # @input
	.type	input,@object
	.section	.bss.input,"aw",@nobits
	.globl	input
	.p2align	4
input:
	.skip	320
	.size	input, 320


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
