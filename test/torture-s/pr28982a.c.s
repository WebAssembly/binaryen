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
	i64.load	$push124=, incs+64($pop125)
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
	i64.load	$push112=, incs+48($pop113)
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
	i64.load	$push100=, incs+32($pop101)
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
	i64.load	$push88=, incs+16($pop89)
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
	i64.load	$push76=, incs($pop77)
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
	i32.load	$39=, ptrs+72($pop70)
	i32.const	$push69=, 0
	i32.load	$38=, ptrs+68($pop69)
	i32.const	$push68=, 0
	i32.load	$37=, ptrs+64($pop68)
	i32.const	$push67=, 0
	i32.load	$36=, ptrs+60($pop67)
	i32.const	$push66=, 0
	i32.load	$35=, ptrs+56($pop66)
	i32.const	$push65=, 0
	i32.load	$34=, ptrs+52($pop65)
	i32.const	$push64=, 0
	i32.load	$33=, ptrs+48($pop64)
	i32.const	$push63=, 0
	i32.load	$32=, ptrs+44($pop63)
	i32.const	$push62=, 0
	i32.load	$31=, ptrs+40($pop62)
	i32.const	$push61=, 0
	i32.load	$30=, ptrs+36($pop61)
	i32.const	$push60=, 0
	i32.load	$29=, ptrs+32($pop60)
	i32.const	$push59=, 0
	i32.load	$28=, ptrs+28($pop59)
	i32.const	$push58=, 0
	i32.load	$27=, ptrs+24($pop58)
	i32.const	$push57=, 0
	i32.load	$26=, ptrs+20($pop57)
	i32.const	$push56=, 0
	i32.load	$25=, ptrs+16($pop56)
	i32.const	$push55=, 0
	i32.load	$24=, ptrs+12($pop55)
	i32.const	$push54=, 0
	i32.load	$23=, ptrs+8($pop54)
	i32.const	$push53=, 0
	i32.load	$22=, ptrs+4($pop53)
	i32.const	$push52=, 0
	i32.load	$21=, ptrs($pop52)
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
	f32.store	$discard=, results($pop150), $60
	i32.const	$push149=, 0
	f32.store	$discard=, results+4($pop149), $59
	i32.const	$push148=, 0
	f32.store	$discard=, results+8($pop148), $58
	i32.const	$push147=, 0
	f32.store	$discard=, results+12($pop147), $57
	i32.const	$push146=, 0
	f32.store	$discard=, results+16($pop146), $56
	i32.const	$push145=, 0
	f32.store	$discard=, results+20($pop145), $55
	i32.const	$push144=, 0
	f32.store	$discard=, results+24($pop144), $54
	i32.const	$push143=, 0
	f32.store	$discard=, results+28($pop143), $53
	i32.const	$push142=, 0
	f32.store	$discard=, results+32($pop142), $52
	i32.const	$push141=, 0
	f32.store	$discard=, results+36($pop141), $51
	i32.const	$push140=, 0
	f32.store	$discard=, results+40($pop140), $50
	i32.const	$push139=, 0
	f32.store	$discard=, results+44($pop139), $49
	i32.const	$push138=, 0
	f32.store	$discard=, results+48($pop138), $48
	i32.const	$push137=, 0
	f32.store	$discard=, results+52($pop137), $47
	i32.const	$push136=, 0
	f32.store	$discard=, results+56($pop136), $46
	i32.const	$push135=, 0
	f32.store	$discard=, results+60($pop135), $45
	i32.const	$push134=, 0
	f32.store	$discard=, results+64($pop134), $44
	i32.const	$push133=, 0
	f32.store	$discard=, results+68($pop133), $43
	i32.const	$push132=, 0
	f32.store	$discard=, results+72($pop132), $42
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
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.const	$push162=, 0
	i32.const	$push1=, input+4
	i32.store	$discard=, ptrs+4($pop162), $pop1
	i32.const	$push161=, 0
	i32.const	$push3=, input+8
	i32.store	$discard=, ptrs+8($pop161), $pop3
	i32.const	$push160=, 0
	i32.const	$push4=, input+12
	i32.store	$discard=, ptrs+12($pop160), $pop4
	i32.const	$push159=, 0
	i32.const	$push5=, 3
	i32.store	$discard=, incs+12($pop159), $pop5
	i32.const	$push158=, 0
	i32.const	$push6=, input+16
	i32.store	$discard=, ptrs+16($pop158), $pop6
	i32.const	$push157=, 0
	i32.const	$push8=, input+20
	i32.store	$discard=, ptrs+20($pop157), $pop8
	i32.const	$push156=, 0
	i32.const	$push9=, 5
	i32.store	$discard=, incs+20($pop156), $pop9
	i32.const	$push155=, 0
	i32.const	$push10=, input+24
	i32.store	$discard=, ptrs+24($pop155), $pop10
	i32.const	$push154=, 0
	i32.const	$push11=, 6
	i32.store	$discard=, incs+24($pop154), $pop11
	i32.const	$push153=, 0
	i32.const	$push12=, input+28
	i32.store	$discard=, ptrs+28($pop153), $pop12
	i32.const	$push152=, 0
	i32.const	$push13=, 7
	i32.store	$discard=, incs+28($pop152), $pop13
	i32.const	$push151=, 0
	i32.const	$push14=, input+32
	i32.store	$discard=, ptrs+32($pop151), $pop14
	i32.const	$push150=, 0
	i32.const	$push15=, 8
	i32.store	$discard=, incs+32($pop150), $pop15
	i32.const	$push149=, 0
	i32.const	$push16=, input+36
	i32.store	$discard=, ptrs+36($pop149), $pop16
	i32.const	$push148=, 0
	i32.const	$push17=, 9
	i32.store	$discard=, incs+36($pop148), $pop17
	i32.const	$push147=, 0
	i32.const	$push18=, input+40
	i32.store	$discard=, ptrs+40($pop147), $pop18
	i32.const	$push146=, 0
	i32.const	$push19=, 10
	i32.store	$discard=, incs+40($pop146), $pop19
	i32.const	$push145=, 0
	i32.const	$push20=, input+44
	i32.store	$discard=, ptrs+44($pop145), $pop20
	i32.const	$push144=, 0
	i32.const	$push21=, 11
	i32.store	$discard=, incs+44($pop144), $pop21
	i32.const	$push143=, 0
	i32.const	$push22=, input+48
	i32.store	$discard=, ptrs+48($pop143), $pop22
	i32.const	$push142=, 0
	i32.const	$push23=, 12
	i32.store	$discard=, incs+48($pop142), $pop23
	i32.const	$push141=, 0
	i32.const	$push24=, input+52
	i32.store	$discard=, ptrs+52($pop141), $pop24
	i32.const	$push140=, 0
	i32.const	$push25=, 13
	i32.store	$discard=, incs+52($pop140), $pop25
	i32.const	$push139=, 0
	i32.const	$push26=, input+56
	i32.store	$discard=, ptrs+56($pop139), $pop26
	i32.const	$push138=, 0
	i32.const	$push27=, 14
	i32.store	$discard=, incs+56($pop138), $pop27
	i32.const	$push137=, 0
	i32.const	$push28=, input+60
	i32.store	$discard=, ptrs+60($pop137), $pop28
	i32.const	$push136=, 0
	i32.const	$push29=, 15
	i32.store	$discard=, incs+60($pop136), $pop29
	i32.const	$push135=, 0
	i32.const	$push30=, input+64
	i32.store	$discard=, ptrs+64($pop135), $pop30
	i32.const	$push134=, 0
	i32.const	$push31=, 16
	i32.store	$discard=, incs+64($pop134), $pop31
	i32.const	$push133=, 0
	i32.const	$push32=, input+68
	i32.store	$discard=, ptrs+68($pop133), $pop32
	i32.const	$push132=, 0
	i32.const	$push33=, 17
	i32.store	$discard=, incs+68($pop132), $pop33
	i32.const	$push131=, 0
	i32.const	$push34=, input+72
	i32.store	$discard=, ptrs+72($pop131), $pop34
	i32.const	$push130=, 0
	i32.const	$push35=, 18
	i32.store	$discard=, incs+72($pop130), $pop35
	i32.const	$push129=, 0
	i32.const	$push36=, input+76
	i32.store	$discard=, ptrs+76($pop129), $pop36
	i32.const	$push128=, 0
	i32.const	$push37=, 19
	i32.store	$discard=, incs+76($pop128), $pop37
	i32.const	$push127=, 0
	i64.const	$push2=, 8589934593
	i64.store	$discard=, incs+4($pop127):p2align=2, $pop2
	i32.const	$1=, input
	i32.const	$push126=, 0
	i32.const	$push125=, input
	i32.store	$discard=, ptrs($pop126), $pop125
	i32.const	$push124=, 0
	i32.const	$push123=, 0
	i32.store	$push0=, incs($pop124), $pop123
	i32.const	$push7=, 4
	i32.store	$0=, incs+16($pop0), $pop7
.LBB1_1:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	f32.convert_s/i32	$push38=, $2
	f32.store	$discard=, 0($1), $pop38
	i32.const	$push164=, 1
	i32.add 	$2=, $2, $pop164
	i32.add 	$1=, $1, $0
	i32.const	$push163=, 80
	i32.ne  	$push39=, $2, $pop163
	br_if   	0, $pop39       # 0: up to label3
# BB#2:                                 # %for.end8
	end_loop                        # label4:
	i32.const	$push40=, 4
	call    	foo@FUNCTION, $pop40
	i32.const	$push41=, 0
	f32.load	$push42=, results($pop41)
	f32.const	$push43=, 0x0p0
	f32.ne  	$push44=, $pop42, $pop43
	i32.const	$push183=, 0
	f32.load	$push45=, results+4($pop183)
	f32.const	$push46=, 0x1.4p3
	f32.ne  	$push47=, $pop45, $pop46
	i32.or  	$push48=, $pop44, $pop47
	i32.const	$push182=, 0
	f32.load	$push49=, results+8($pop182)
	f32.const	$push50=, 0x1.4p4
	f32.ne  	$push51=, $pop49, $pop50
	i32.or  	$push52=, $pop48, $pop51
	i32.const	$push181=, 0
	f32.load	$push53=, results+12($pop181)
	f32.const	$push54=, 0x1.ep4
	f32.ne  	$push55=, $pop53, $pop54
	i32.or  	$push56=, $pop52, $pop55
	i32.const	$push180=, 0
	f32.load	$push57=, results+16($pop180)
	f32.const	$push58=, 0x1.4p5
	f32.ne  	$push59=, $pop57, $pop58
	i32.or  	$push60=, $pop56, $pop59
	i32.const	$push179=, 0
	f32.load	$push61=, results+20($pop179)
	f32.const	$push62=, 0x1.9p5
	f32.ne  	$push63=, $pop61, $pop62
	i32.or  	$push64=, $pop60, $pop63
	i32.const	$push178=, 0
	f32.load	$push65=, results+24($pop178)
	f32.const	$push66=, 0x1.ep5
	f32.ne  	$push67=, $pop65, $pop66
	i32.or  	$push68=, $pop64, $pop67
	i32.const	$push177=, 0
	f32.load	$push69=, results+28($pop177)
	f32.const	$push70=, 0x1.18p6
	f32.ne  	$push71=, $pop69, $pop70
	i32.or  	$push72=, $pop68, $pop71
	i32.const	$push176=, 0
	f32.load	$push73=, results+32($pop176)
	f32.const	$push74=, 0x1.4p6
	f32.ne  	$push75=, $pop73, $pop74
	i32.or  	$push76=, $pop72, $pop75
	i32.const	$push175=, 0
	f32.load	$push77=, results+36($pop175)
	f32.const	$push78=, 0x1.68p6
	f32.ne  	$push79=, $pop77, $pop78
	i32.or  	$push80=, $pop76, $pop79
	i32.const	$push174=, 0
	f32.load	$push81=, results+40($pop174)
	f32.const	$push82=, 0x1.9p6
	f32.ne  	$push83=, $pop81, $pop82
	i32.or  	$push84=, $pop80, $pop83
	i32.const	$push173=, 0
	f32.load	$push85=, results+44($pop173)
	f32.const	$push86=, 0x1.b8p6
	f32.ne  	$push87=, $pop85, $pop86
	i32.or  	$push88=, $pop84, $pop87
	i32.const	$push172=, 0
	f32.load	$push89=, results+48($pop172)
	f32.const	$push90=, 0x1.ep6
	f32.ne  	$push91=, $pop89, $pop90
	i32.or  	$push92=, $pop88, $pop91
	i32.const	$push171=, 0
	f32.load	$push93=, results+52($pop171)
	f32.const	$push94=, 0x1.04p7
	f32.ne  	$push95=, $pop93, $pop94
	i32.or  	$push96=, $pop92, $pop95
	i32.const	$push170=, 0
	f32.load	$push97=, results+56($pop170)
	f32.const	$push98=, 0x1.18p7
	f32.ne  	$push99=, $pop97, $pop98
	i32.or  	$push100=, $pop96, $pop99
	i32.const	$push169=, 0
	f32.load	$push101=, results+60($pop169)
	f32.const	$push102=, 0x1.2cp7
	f32.ne  	$push103=, $pop101, $pop102
	i32.or  	$push104=, $pop100, $pop103
	i32.const	$push168=, 0
	f32.load	$push105=, results+64($pop168)
	f32.const	$push106=, 0x1.4p7
	f32.ne  	$push107=, $pop105, $pop106
	i32.or  	$push108=, $pop104, $pop107
	i32.const	$push167=, 0
	f32.load	$push109=, results+68($pop167)
	f32.const	$push110=, 0x1.54p7
	f32.ne  	$push111=, $pop109, $pop110
	i32.or  	$push112=, $pop108, $pop111
	i32.const	$push166=, 0
	f32.load	$push113=, results+72($pop166)
	f32.const	$push114=, 0x1.68p7
	f32.ne  	$push115=, $pop113, $pop114
	i32.or  	$push116=, $pop112, $pop115
	i32.const	$push165=, 0
	f32.load	$push117=, results+76($pop165)
	f32.const	$push118=, 0x1.7cp7
	f32.ne  	$push119=, $pop117, $pop118
	i32.or  	$push120=, $pop116, $pop119
	i32.const	$push121=, 1
	i32.and 	$push122=, $pop120, $pop121
	return  	$pop122
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
