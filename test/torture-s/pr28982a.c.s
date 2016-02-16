	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr28982a.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, i64
# BB#0:                                 # %entry
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
	block
	i32.const	$push151=, 0
	i32.eq  	$push152=, $0, $pop151
	br_if   	0, $pop152      # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$push129=, 0
	i64.load	$push128=, incs+72($pop129)
	tee_local	$push127=, $61=, $pop128
	i64.const	$push20=, 32
	i64.shr_u	$push30=, $pop127, $pop20
	i32.wrap/i64	$push19=, $pop30
	i32.const	$push31=, 2
	i32.shl 	$1=, $pop19, $pop31
	i32.wrap/i64	$push18=, $61
	i32.const	$push126=, 2
	i32.shl 	$2=, $pop18, $pop126
	i32.const	$push125=, 0
	i64.load	$push124=, incs+64($pop125):p2align=4
	tee_local	$push123=, $61=, $pop124
	i64.const	$push122=, 32
	i64.shr_u	$push29=, $pop123, $pop122
	i32.wrap/i64	$push17=, $pop29
	i32.const	$push121=, 2
	i32.shl 	$3=, $pop17, $pop121
	i32.wrap/i64	$push16=, $61
	i32.const	$push120=, 2
	i32.shl 	$4=, $pop16, $pop120
	i32.const	$push119=, 0
	i64.load	$push118=, incs+56($pop119)
	tee_local	$push117=, $61=, $pop118
	i64.const	$push116=, 32
	i64.shr_u	$push28=, $pop117, $pop116
	i32.wrap/i64	$push15=, $pop28
	i32.const	$push115=, 2
	i32.shl 	$5=, $pop15, $pop115
	i32.wrap/i64	$push14=, $61
	i32.const	$push114=, 2
	i32.shl 	$6=, $pop14, $pop114
	i32.const	$push113=, 0
	i64.load	$push112=, incs+48($pop113):p2align=4
	tee_local	$push111=, $61=, $pop112
	i64.const	$push110=, 32
	i64.shr_u	$push27=, $pop111, $pop110
	i32.wrap/i64	$push13=, $pop27
	i32.const	$push109=, 2
	i32.shl 	$7=, $pop13, $pop109
	i32.wrap/i64	$push12=, $61
	i32.const	$push108=, 2
	i32.shl 	$8=, $pop12, $pop108
	i32.const	$push107=, 0
	i64.load	$push106=, incs+40($pop107)
	tee_local	$push105=, $61=, $pop106
	i64.const	$push104=, 32
	i64.shr_u	$push26=, $pop105, $pop104
	i32.wrap/i64	$push11=, $pop26
	i32.const	$push103=, 2
	i32.shl 	$9=, $pop11, $pop103
	i32.wrap/i64	$push10=, $61
	i32.const	$push102=, 2
	i32.shl 	$10=, $pop10, $pop102
	i32.const	$push101=, 0
	i64.load	$push100=, incs+32($pop101):p2align=4
	tee_local	$push99=, $61=, $pop100
	i64.const	$push98=, 32
	i64.shr_u	$push25=, $pop99, $pop98
	i32.wrap/i64	$push9=, $pop25
	i32.const	$push97=, 2
	i32.shl 	$11=, $pop9, $pop97
	i32.wrap/i64	$push8=, $61
	i32.const	$push96=, 2
	i32.shl 	$12=, $pop8, $pop96
	i32.const	$push95=, 0
	i64.load	$push94=, incs+24($pop95)
	tee_local	$push93=, $61=, $pop94
	i64.const	$push92=, 32
	i64.shr_u	$push24=, $pop93, $pop92
	i32.wrap/i64	$push7=, $pop24
	i32.const	$push91=, 2
	i32.shl 	$13=, $pop7, $pop91
	i32.wrap/i64	$push6=, $61
	i32.const	$push90=, 2
	i32.shl 	$14=, $pop6, $pop90
	i32.const	$push89=, 0
	i64.load	$push88=, incs+16($pop89):p2align=4
	tee_local	$push87=, $61=, $pop88
	i64.const	$push86=, 32
	i64.shr_u	$push23=, $pop87, $pop86
	i32.wrap/i64	$push5=, $pop23
	i32.const	$push85=, 2
	i32.shl 	$15=, $pop5, $pop85
	i32.wrap/i64	$push4=, $61
	i32.const	$push84=, 2
	i32.shl 	$16=, $pop4, $pop84
	i32.const	$push83=, 0
	i64.load	$push82=, incs+8($pop83)
	tee_local	$push81=, $61=, $pop82
	i64.const	$push80=, 32
	i64.shr_u	$push22=, $pop81, $pop80
	i32.wrap/i64	$push3=, $pop22
	i32.const	$push79=, 2
	i32.shl 	$17=, $pop3, $pop79
	i32.wrap/i64	$push2=, $61
	i32.const	$push78=, 2
	i32.shl 	$18=, $pop2, $pop78
	i32.const	$push77=, 0
	i64.load	$push76=, incs($pop77):p2align=4
	tee_local	$push75=, $61=, $pop76
	i64.const	$push74=, 32
	i64.shr_u	$push21=, $pop75, $pop74
	i32.wrap/i64	$push1=, $pop21
	i32.const	$push73=, 2
	i32.shl 	$19=, $pop1, $pop73
	i32.wrap/i64	$push0=, $61
	i32.const	$push72=, 2
	i32.shl 	$20=, $pop0, $pop72
	f32.const	$41=, 0x0p0
	i32.const	$push71=, 0
	i32.load	$40=, ptrs+76($pop71)
	i32.const	$push70=, 0
	i32.load	$39=, ptrs+72($pop70):p2align=3
	i32.const	$push69=, 0
	i32.load	$38=, ptrs+68($pop69)
	i32.const	$push68=, 0
	i32.load	$37=, ptrs+64($pop68):p2align=4
	i32.const	$push67=, 0
	i32.load	$36=, ptrs+60($pop67)
	i32.const	$push66=, 0
	i32.load	$35=, ptrs+56($pop66):p2align=3
	i32.const	$push65=, 0
	i32.load	$34=, ptrs+52($pop65)
	i32.const	$push64=, 0
	i32.load	$33=, ptrs+48($pop64):p2align=4
	i32.const	$push63=, 0
	i32.load	$32=, ptrs+44($pop63)
	i32.const	$push62=, 0
	i32.load	$31=, ptrs+40($pop62):p2align=3
	i32.const	$push61=, 0
	i32.load	$30=, ptrs+36($pop61)
	i32.const	$push60=, 0
	i32.load	$29=, ptrs+32($pop60):p2align=4
	i32.const	$push59=, 0
	i32.load	$28=, ptrs+28($pop59)
	i32.const	$push58=, 0
	i32.load	$27=, ptrs+24($pop58):p2align=3
	i32.const	$push57=, 0
	i32.load	$26=, ptrs+20($pop57)
	i32.const	$push56=, 0
	i32.load	$25=, ptrs+16($pop56):p2align=4
	i32.const	$push55=, 0
	i32.load	$24=, ptrs+12($pop55)
	i32.const	$push54=, 0
	i32.load	$23=, ptrs+8($pop54):p2align=3
	i32.const	$push53=, 0
	i32.load	$22=, ptrs+4($pop53)
	i32.const	$push52=, 0
	i32.load	$21=, ptrs($pop52):p2align=4
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
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	f32.load	$push32=, 0($21)
	f32.add 	$60=, $60, $pop32
	f32.load	$push33=, 0($22)
	f32.add 	$59=, $59, $pop33
	f32.load	$push34=, 0($23)
	f32.add 	$58=, $58, $pop34
	f32.load	$push35=, 0($24)
	f32.add 	$57=, $57, $pop35
	f32.load	$push36=, 0($25)
	f32.add 	$56=, $56, $pop36
	f32.load	$push37=, 0($26)
	f32.add 	$55=, $55, $pop37
	f32.load	$push38=, 0($27)
	f32.add 	$54=, $54, $pop38
	f32.load	$push39=, 0($28)
	f32.add 	$53=, $53, $pop39
	f32.load	$push40=, 0($29)
	f32.add 	$52=, $52, $pop40
	f32.load	$push41=, 0($30)
	f32.add 	$51=, $51, $pop41
	f32.load	$push42=, 0($31)
	f32.add 	$50=, $50, $pop42
	f32.load	$push43=, 0($32)
	f32.add 	$49=, $49, $pop43
	f32.load	$push44=, 0($33)
	f32.add 	$48=, $48, $pop44
	f32.load	$push45=, 0($34)
	f32.add 	$47=, $47, $pop45
	f32.load	$push46=, 0($35)
	f32.add 	$46=, $46, $pop46
	f32.load	$push47=, 0($36)
	f32.add 	$45=, $45, $pop47
	f32.load	$push48=, 0($37)
	f32.add 	$44=, $44, $pop48
	f32.load	$push49=, 0($38)
	f32.add 	$43=, $43, $pop49
	f32.load	$push50=, 0($39)
	f32.add 	$42=, $42, $pop50
	f32.load	$push51=, 0($40)
	f32.add 	$41=, $41, $pop51
	i32.const	$push130=, -1
	i32.add 	$0=, $0, $pop130
	i32.add 	$40=, $40, $1
	i32.add 	$39=, $39, $2
	i32.add 	$38=, $38, $3
	i32.add 	$37=, $37, $4
	i32.add 	$36=, $36, $5
	i32.add 	$35=, $35, $6
	i32.add 	$34=, $34, $7
	i32.add 	$33=, $33, $8
	i32.add 	$32=, $32, $9
	i32.add 	$31=, $31, $10
	i32.add 	$30=, $30, $11
	i32.add 	$29=, $29, $12
	i32.add 	$28=, $28, $13
	i32.add 	$27=, $27, $14
	i32.add 	$26=, $26, $15
	i32.add 	$25=, $25, $16
	i32.add 	$24=, $24, $17
	i32.add 	$23=, $23, $18
	i32.add 	$22=, $22, $19
	i32.add 	$21=, $21, $20
	br_if   	0, $0           # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push150=, 0
	f32.store	$discard=, results($pop150):p2align=4, $60
	i32.const	$push149=, 0
	f32.store	$discard=, results+4($pop149), $59
	i32.const	$push148=, 0
	f32.store	$discard=, results+8($pop148):p2align=3, $58
	i32.const	$push147=, 0
	f32.store	$discard=, results+12($pop147), $57
	i32.const	$push146=, 0
	f32.store	$discard=, results+16($pop146):p2align=4, $56
	i32.const	$push145=, 0
	f32.store	$discard=, results+20($pop145), $55
	i32.const	$push144=, 0
	f32.store	$discard=, results+24($pop144):p2align=3, $54
	i32.const	$push143=, 0
	f32.store	$discard=, results+28($pop143), $53
	i32.const	$push142=, 0
	f32.store	$discard=, results+32($pop142):p2align=4, $52
	i32.const	$push141=, 0
	f32.store	$discard=, results+36($pop141), $51
	i32.const	$push140=, 0
	f32.store	$discard=, results+40($pop140):p2align=3, $50
	i32.const	$push139=, 0
	f32.store	$discard=, results+44($pop139), $49
	i32.const	$push138=, 0
	f32.store	$discard=, results+48($pop138):p2align=4, $48
	i32.const	$push137=, 0
	f32.store	$discard=, results+52($pop137), $47
	i32.const	$push136=, 0
	f32.store	$discard=, results+56($pop136):p2align=3, $46
	i32.const	$push135=, 0
	f32.store	$discard=, results+60($pop135), $45
	i32.const	$push134=, 0
	f32.store	$discard=, results+64($pop134):p2align=4, $44
	i32.const	$push133=, 0
	f32.store	$discard=, results+68($pop133), $43
	i32.const	$push132=, 0
	f32.store	$discard=, results+72($pop132):p2align=3, $42
	i32.const	$push131=, 0
	f32.store	$discard=, results+76($pop131), $41
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, input
	i32.store	$2=, ptrs($pop1):p2align=4, $pop0
	i32.const	$push128=, 0
	i32.const	$push127=, 0
	i32.store	$push126=, incs($pop128):p2align=4, $pop127
	tee_local	$push125=, $3=, $pop126
	i32.const	$push2=, input+4
	i32.store	$discard=, ptrs+4($pop125), $pop2
	i32.const	$push4=, input+8
	i32.store	$discard=, ptrs+8($3):p2align=3, $pop4
	i32.const	$push5=, 2
	i32.store	$discard=, incs+8($3):p2align=3, $pop5
	i32.const	$push6=, input+12
	i32.store	$discard=, ptrs+12($3), $pop6
	i32.const	$push7=, 3
	i32.store	$discard=, incs+12($3), $pop7
	i32.const	$push8=, input+16
	i32.store	$discard=, ptrs+16($3):p2align=4, $pop8
	i32.const	$push10=, input+20
	i32.store	$discard=, ptrs+20($3), $pop10
	i32.const	$push11=, 5
	i32.store	$discard=, incs+20($3), $pop11
	i32.const	$push12=, input+24
	i32.store	$discard=, ptrs+24($3):p2align=3, $pop12
	i32.const	$push13=, 6
	i32.store	$discard=, incs+24($3):p2align=3, $pop13
	i32.const	$push14=, input+28
	i32.store	$discard=, ptrs+28($3), $pop14
	i32.const	$push15=, 7
	i32.store	$discard=, incs+28($3), $pop15
	i32.const	$push16=, input+32
	i32.store	$discard=, ptrs+32($3):p2align=4, $pop16
	i32.const	$push17=, 8
	i32.store	$discard=, incs+32($3):p2align=4, $pop17
	i32.const	$push18=, input+36
	i32.store	$discard=, ptrs+36($3), $pop18
	i32.const	$push19=, 9
	i32.store	$discard=, incs+36($3), $pop19
	i32.const	$push20=, input+40
	i32.store	$discard=, ptrs+40($3):p2align=3, $pop20
	i32.const	$push21=, 10
	i32.store	$discard=, incs+40($3):p2align=3, $pop21
	i32.const	$push22=, input+44
	i32.store	$discard=, ptrs+44($3), $pop22
	i32.const	$push23=, 11
	i32.store	$discard=, incs+44($3), $pop23
	i32.const	$push24=, input+48
	i32.store	$discard=, ptrs+48($3):p2align=4, $pop24
	i32.const	$push25=, 12
	i32.store	$discard=, incs+48($3):p2align=4, $pop25
	i32.const	$push26=, input+52
	i32.store	$discard=, ptrs+52($3), $pop26
	i32.const	$push27=, 13
	i32.store	$discard=, incs+52($3), $pop27
	i32.const	$push28=, input+56
	i32.store	$discard=, ptrs+56($3):p2align=3, $pop28
	i32.const	$push29=, 14
	i32.store	$discard=, incs+56($3):p2align=3, $pop29
	i32.const	$push30=, input+60
	i32.store	$discard=, ptrs+60($3), $pop30
	i32.const	$push31=, 15
	i32.store	$discard=, incs+60($3), $pop31
	i32.const	$push32=, input+64
	i32.store	$discard=, ptrs+64($3):p2align=4, $pop32
	i32.const	$push33=, 16
	i32.store	$discard=, incs+64($3):p2align=4, $pop33
	i32.const	$push34=, input+68
	i32.store	$discard=, ptrs+68($3), $pop34
	i32.const	$push35=, 17
	i32.store	$discard=, incs+68($3), $pop35
	i32.const	$push36=, input+72
	i32.store	$discard=, ptrs+72($3):p2align=3, $pop36
	i32.const	$push37=, 18
	i32.store	$discard=, incs+72($3):p2align=3, $pop37
	i32.const	$push38=, input+76
	i32.store	$discard=, ptrs+76($3), $pop38
	i32.const	$push39=, 19
	i32.store	$discard=, incs+76($3), $pop39
	i32.const	$push3=, 1
	i32.store	$0=, incs+4($3), $pop3
	i32.const	$push9=, 4
	i32.store	$1=, incs+16($3):p2align=4, $pop9
.LBB1_1:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	f32.convert_s/i32	$push40=, $3
	f32.store	$discard=, 0($2), $pop40
	i32.add 	$3=, $3, $0
	i32.add 	$2=, $2, $1
	i32.const	$push129=, 80
	i32.ne  	$push41=, $3, $pop129
	br_if   	0, $pop41       # 0: up to label3
# BB#2:                                 # %for.end8
	end_loop                        # label4:
	i32.const	$push42=, 4
	call    	foo@FUNCTION, $pop42
	i32.const	$push43=, 0
	f32.load	$push44=, results($pop43):p2align=4
	f32.const	$push45=, 0x0p0
	f32.ne  	$push46=, $pop44, $pop45
	i32.const	$push148=, 0
	f32.load	$push47=, results+4($pop148)
	f32.const	$push48=, 0x1.4p3
	f32.ne  	$push49=, $pop47, $pop48
	i32.or  	$push50=, $pop46, $pop49
	i32.const	$push147=, 0
	f32.load	$push51=, results+8($pop147):p2align=3
	f32.const	$push52=, 0x1.4p4
	f32.ne  	$push53=, $pop51, $pop52
	i32.or  	$push54=, $pop50, $pop53
	i32.const	$push146=, 0
	f32.load	$push55=, results+12($pop146)
	f32.const	$push56=, 0x1.ep4
	f32.ne  	$push57=, $pop55, $pop56
	i32.or  	$push58=, $pop54, $pop57
	i32.const	$push145=, 0
	f32.load	$push59=, results+16($pop145):p2align=4
	f32.const	$push60=, 0x1.4p5
	f32.ne  	$push61=, $pop59, $pop60
	i32.or  	$push62=, $pop58, $pop61
	i32.const	$push144=, 0
	f32.load	$push63=, results+20($pop144)
	f32.const	$push64=, 0x1.9p5
	f32.ne  	$push65=, $pop63, $pop64
	i32.or  	$push66=, $pop62, $pop65
	i32.const	$push143=, 0
	f32.load	$push67=, results+24($pop143):p2align=3
	f32.const	$push68=, 0x1.ep5
	f32.ne  	$push69=, $pop67, $pop68
	i32.or  	$push70=, $pop66, $pop69
	i32.const	$push142=, 0
	f32.load	$push71=, results+28($pop142)
	f32.const	$push72=, 0x1.18p6
	f32.ne  	$push73=, $pop71, $pop72
	i32.or  	$push74=, $pop70, $pop73
	i32.const	$push141=, 0
	f32.load	$push75=, results+32($pop141):p2align=4
	f32.const	$push76=, 0x1.4p6
	f32.ne  	$push77=, $pop75, $pop76
	i32.or  	$push78=, $pop74, $pop77
	i32.const	$push140=, 0
	f32.load	$push79=, results+36($pop140)
	f32.const	$push80=, 0x1.68p6
	f32.ne  	$push81=, $pop79, $pop80
	i32.or  	$push82=, $pop78, $pop81
	i32.const	$push139=, 0
	f32.load	$push83=, results+40($pop139):p2align=3
	f32.const	$push84=, 0x1.9p6
	f32.ne  	$push85=, $pop83, $pop84
	i32.or  	$push86=, $pop82, $pop85
	i32.const	$push138=, 0
	f32.load	$push87=, results+44($pop138)
	f32.const	$push88=, 0x1.b8p6
	f32.ne  	$push89=, $pop87, $pop88
	i32.or  	$push90=, $pop86, $pop89
	i32.const	$push137=, 0
	f32.load	$push91=, results+48($pop137):p2align=4
	f32.const	$push92=, 0x1.ep6
	f32.ne  	$push93=, $pop91, $pop92
	i32.or  	$push94=, $pop90, $pop93
	i32.const	$push136=, 0
	f32.load	$push95=, results+52($pop136)
	f32.const	$push96=, 0x1.04p7
	f32.ne  	$push97=, $pop95, $pop96
	i32.or  	$push98=, $pop94, $pop97
	i32.const	$push135=, 0
	f32.load	$push99=, results+56($pop135):p2align=3
	f32.const	$push100=, 0x1.18p7
	f32.ne  	$push101=, $pop99, $pop100
	i32.or  	$push102=, $pop98, $pop101
	i32.const	$push134=, 0
	f32.load	$push103=, results+60($pop134)
	f32.const	$push104=, 0x1.2cp7
	f32.ne  	$push105=, $pop103, $pop104
	i32.or  	$push106=, $pop102, $pop105
	i32.const	$push133=, 0
	f32.load	$push107=, results+64($pop133):p2align=4
	f32.const	$push108=, 0x1.4p7
	f32.ne  	$push109=, $pop107, $pop108
	i32.or  	$push110=, $pop106, $pop109
	i32.const	$push132=, 0
	f32.load	$push111=, results+68($pop132)
	f32.const	$push112=, 0x1.54p7
	f32.ne  	$push113=, $pop111, $pop112
	i32.or  	$push114=, $pop110, $pop113
	i32.const	$push131=, 0
	f32.load	$push115=, results+72($pop131):p2align=3
	f32.const	$push116=, 0x1.68p7
	f32.ne  	$push117=, $pop115, $pop116
	i32.or  	$push118=, $pop114, $pop117
	i32.const	$push130=, 0
	f32.load	$push119=, results+76($pop130)
	f32.const	$push120=, 0x1.7cp7
	f32.ne  	$push121=, $pop119, $pop120
	i32.or  	$push122=, $pop118, $pop121
	i32.const	$push123=, 1
	i32.and 	$push124=, $pop122, $pop123
	return  	$pop124
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

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


	.ident	"clang version 3.9.0 "
