	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr28982b.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push4=, 0
	i32.load	$push2=, incs($pop4)
	i32.load	$push0=, 0($0)
	i32.add 	$push3=, $pop2, $pop0
	i32.store	incs($pop1), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, i32
# BB#0:                                 # %entry
	i32.const	$push64=, 0
	i32.const	$push61=, 0
	i32.load	$push62=, __stack_pointer($pop61)
	i32.const	$push63=, 524288
	i32.sub 	$push75=, $pop62, $pop63
	tee_local	$push74=, $61=, $pop75
	i32.store	__stack_pointer($pop64), $pop74
	i32.const	$push68=, 262144
	i32.add 	$push69=, $61, $pop68
	i32.const	$push73=, 0
	i32.const	$push72=, 262144
	i32.call	$drop=, memset@FUNCTION, $pop69, $pop73, $pop72
	block   	
	block   	
	i32.eqz 	$push161=, $0
	br_if   	0, $pop161      # 0: down to label1
# BB#1:                                 # %while.body.preheader
	i32.const	$push134=, 0
	i32.load	$push0=, incs($pop134)
	i32.const	$push40=, 2
	i32.shl 	$20=, $pop0, $pop40
	i32.const	$push133=, 0
	i32.load	$push1=, incs+4($pop133)
	i32.const	$push132=, 2
	i32.shl 	$19=, $pop1, $pop132
	i32.const	$push131=, 0
	i32.load	$push2=, incs+8($pop131)
	i32.const	$push130=, 2
	i32.shl 	$18=, $pop2, $pop130
	i32.const	$push129=, 0
	i32.load	$push3=, incs+12($pop129)
	i32.const	$push128=, 2
	i32.shl 	$17=, $pop3, $pop128
	i32.const	$push127=, 0
	i32.load	$push4=, incs+16($pop127)
	i32.const	$push126=, 2
	i32.shl 	$16=, $pop4, $pop126
	i32.const	$push125=, 0
	i32.load	$push5=, incs+20($pop125)
	i32.const	$push124=, 2
	i32.shl 	$15=, $pop5, $pop124
	i32.const	$push123=, 0
	i32.load	$push6=, incs+24($pop123)
	i32.const	$push122=, 2
	i32.shl 	$14=, $pop6, $pop122
	i32.const	$push121=, 0
	i32.load	$push7=, incs+28($pop121)
	i32.const	$push120=, 2
	i32.shl 	$13=, $pop7, $pop120
	i32.const	$push119=, 0
	i32.load	$push8=, incs+32($pop119)
	i32.const	$push118=, 2
	i32.shl 	$12=, $pop8, $pop118
	i32.const	$push117=, 0
	i32.load	$push9=, incs+36($pop117)
	i32.const	$push116=, 2
	i32.shl 	$11=, $pop9, $pop116
	i32.const	$push115=, 0
	i32.load	$push10=, incs+40($pop115)
	i32.const	$push114=, 2
	i32.shl 	$10=, $pop10, $pop114
	i32.const	$push113=, 0
	i32.load	$push11=, incs+44($pop113)
	i32.const	$push112=, 2
	i32.shl 	$9=, $pop11, $pop112
	i32.const	$push111=, 0
	i32.load	$push12=, incs+48($pop111)
	i32.const	$push110=, 2
	i32.shl 	$8=, $pop12, $pop110
	i32.const	$push109=, 0
	i32.load	$push13=, incs+52($pop109)
	i32.const	$push108=, 2
	i32.shl 	$7=, $pop13, $pop108
	i32.const	$push107=, 0
	i32.load	$push14=, incs+56($pop107)
	i32.const	$push106=, 2
	i32.shl 	$6=, $pop14, $pop106
	i32.const	$push105=, 0
	i32.load	$push15=, incs+60($pop105)
	i32.const	$push104=, 2
	i32.shl 	$5=, $pop15, $pop104
	i32.const	$push103=, 0
	i32.load	$push16=, incs+64($pop103)
	i32.const	$push102=, 2
	i32.shl 	$4=, $pop16, $pop102
	i32.const	$push101=, 0
	i32.load	$push17=, incs+68($pop101)
	i32.const	$push100=, 2
	i32.shl 	$3=, $pop17, $pop100
	i32.const	$push99=, 0
	i32.load	$push18=, incs+72($pop99)
	i32.const	$push98=, 2
	i32.shl 	$2=, $pop18, $pop98
	i32.const	$push97=, 0
	i32.load	$push19=, incs+76($pop97)
	i32.const	$push96=, 2
	i32.shl 	$1=, $pop19, $pop96
	i32.const	$push95=, 0
	i32.load	$21=, ptrs($pop95)
	i32.const	$push94=, 0
	i32.load	$22=, ptrs+4($pop94)
	i32.const	$push93=, 0
	i32.load	$23=, ptrs+8($pop93)
	i32.const	$push92=, 0
	i32.load	$24=, ptrs+12($pop92)
	i32.const	$push91=, 0
	i32.load	$25=, ptrs+16($pop91)
	i32.const	$push90=, 0
	i32.load	$26=, ptrs+20($pop90)
	i32.const	$push89=, 0
	i32.load	$27=, ptrs+24($pop89)
	i32.const	$push88=, 0
	i32.load	$28=, ptrs+28($pop88)
	i32.const	$push87=, 0
	i32.load	$29=, ptrs+32($pop87)
	i32.const	$push86=, 0
	i32.load	$30=, ptrs+36($pop86)
	i32.const	$push85=, 0
	i32.load	$31=, ptrs+40($pop85)
	i32.const	$push84=, 0
	i32.load	$32=, ptrs+44($pop84)
	i32.const	$push83=, 0
	i32.load	$33=, ptrs+48($pop83)
	i32.const	$push82=, 0
	i32.load	$34=, ptrs+52($pop82)
	i32.const	$push81=, 0
	i32.load	$35=, ptrs+56($pop81)
	i32.const	$push80=, 0
	i32.load	$36=, ptrs+60($pop80)
	i32.const	$push79=, 0
	i32.load	$37=, ptrs+64($pop79)
	i32.const	$push78=, 0
	i32.load	$38=, ptrs+68($pop78)
	i32.const	$push77=, 0
	i32.load	$39=, ptrs+72($pop77)
	i32.const	$push76=, 0
	i32.load	$40=, ptrs+76($pop76)
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
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label2:
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
	i32.const	$push137=, -1
	i32.add 	$push136=, $0, $pop137
	tee_local	$push135=, $0=, $pop136
	br_if   	0, $pop135      # 0: up to label2
	br      	2               # 2: down to label0
.LBB1_3:
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
.LBB1_4:                                # %while.end
	end_block                       # label0:
	i32.const	$push160=, 0
	f32.store	results+4($pop160), $42
	i32.const	$push159=, 0
	f32.store	results($pop159), $41
	i32.const	$push158=, 0
	f32.store	results+8($pop158), $43
	i32.const	$push157=, 0
	f32.store	results+12($pop157), $44
	i32.const	$push156=, 0
	f32.store	results+16($pop156), $45
	i32.const	$push155=, 0
	f32.store	results+20($pop155), $46
	i32.const	$push154=, 0
	f32.store	results+24($pop154), $47
	i32.const	$push153=, 0
	f32.store	results+28($pop153), $48
	i32.const	$push152=, 0
	f32.store	results+32($pop152), $49
	i32.const	$push151=, 0
	f32.store	results+36($pop151), $50
	i32.const	$push150=, 0
	f32.store	results+40($pop150), $51
	i32.const	$push149=, 0
	f32.store	results+44($pop149), $52
	i32.const	$push148=, 0
	f32.store	results+48($pop148), $53
	i32.const	$push147=, 0
	f32.store	results+52($pop147), $54
	i32.const	$push146=, 0
	f32.store	results+56($pop146), $55
	i32.const	$push145=, 0
	f32.store	results+60($pop145), $56
	i32.const	$push144=, 0
	f32.store	results+64($pop144), $57
	i32.const	$push143=, 0
	f32.store	results+68($pop143), $58
	i32.const	$push142=, 0
	f32.store	results+72($pop142), $59
	i32.const	$push141=, 0
	f32.store	results+76($pop141), $60
	i32.const	$push70=, 262144
	i32.add 	$push71=, $61, $pop70
	i32.const	$push140=, 262144
	i32.call	$push139=, memcpy@FUNCTION, $61, $pop71, $pop140
	tee_local	$push138=, $21=, $pop139
	call    	bar@FUNCTION, $pop138
	i32.const	$push67=, 0
	i32.const	$push65=, 524288
	i32.add 	$push66=, $21, $pop65
	i32.store	__stack_pointer($pop67), $pop66
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, input
	i32.const	$1=, 0
	i32.const	$push162=, 0
	i32.const	$push161=, input
	i32.store	ptrs($pop162), $pop161
	i32.const	$push160=, 0
	i32.const	$push0=, input+4
	i32.store	ptrs+4($pop160), $pop0
	i32.const	$push159=, 0
	i32.const	$push1=, input+8
	i32.store	ptrs+8($pop159), $pop1
	i32.const	$push158=, 0
	i64.const	$push2=, 8589934593
	i64.store	incs+4($pop158):p2align=2, $pop2
	i32.const	$push157=, 0
	i32.const	$push3=, input+12
	i32.store	ptrs+12($pop157), $pop3
	i32.const	$push156=, 0
	i32.const	$push155=, 0
	i32.store	incs($pop156), $pop155
	i32.const	$push154=, 0
	i32.const	$push4=, 3
	i32.store	incs+12($pop154), $pop4
	i32.const	$push153=, 0
	i32.const	$push5=, input+16
	i32.store	ptrs+16($pop153), $pop5
	i32.const	$push152=, 0
	i32.const	$push151=, 4
	i32.store	incs+16($pop152), $pop151
	i32.const	$push150=, 0
	i32.const	$push6=, input+20
	i32.store	ptrs+20($pop150), $pop6
	i32.const	$push149=, 0
	i32.const	$push7=, 5
	i32.store	incs+20($pop149), $pop7
	i32.const	$push148=, 0
	i32.const	$push8=, input+24
	i32.store	ptrs+24($pop148), $pop8
	i32.const	$push147=, 0
	i32.const	$push9=, 6
	i32.store	incs+24($pop147), $pop9
	i32.const	$push146=, 0
	i32.const	$push10=, input+28
	i32.store	ptrs+28($pop146), $pop10
	i32.const	$push145=, 0
	i32.const	$push11=, 7
	i32.store	incs+28($pop145), $pop11
	i32.const	$push144=, 0
	i32.const	$push12=, input+32
	i32.store	ptrs+32($pop144), $pop12
	i32.const	$push143=, 0
	i32.const	$push13=, 8
	i32.store	incs+32($pop143), $pop13
	i32.const	$push142=, 0
	i32.const	$push14=, input+36
	i32.store	ptrs+36($pop142), $pop14
	i32.const	$push141=, 0
	i32.const	$push15=, 9
	i32.store	incs+36($pop141), $pop15
	i32.const	$push140=, 0
	i32.const	$push16=, input+40
	i32.store	ptrs+40($pop140), $pop16
	i32.const	$push139=, 0
	i32.const	$push17=, 10
	i32.store	incs+40($pop139), $pop17
	i32.const	$push138=, 0
	i32.const	$push18=, input+44
	i32.store	ptrs+44($pop138), $pop18
	i32.const	$push137=, 0
	i32.const	$push19=, 11
	i32.store	incs+44($pop137), $pop19
	i32.const	$push136=, 0
	i32.const	$push20=, input+48
	i32.store	ptrs+48($pop136), $pop20
	i32.const	$push135=, 0
	i32.const	$push21=, 12
	i32.store	incs+48($pop135), $pop21
	i32.const	$push134=, 0
	i32.const	$push22=, input+52
	i32.store	ptrs+52($pop134), $pop22
	i32.const	$push133=, 0
	i32.const	$push23=, 13
	i32.store	incs+52($pop133), $pop23
	i32.const	$push132=, 0
	i32.const	$push24=, input+56
	i32.store	ptrs+56($pop132), $pop24
	i32.const	$push131=, 0
	i32.const	$push25=, 14
	i32.store	incs+56($pop131), $pop25
	i32.const	$push130=, 0
	i32.const	$push26=, input+60
	i32.store	ptrs+60($pop130), $pop26
	i32.const	$push129=, 0
	i32.const	$push27=, 15
	i32.store	incs+60($pop129), $pop27
	i32.const	$push128=, 0
	i32.const	$push28=, input+64
	i32.store	ptrs+64($pop128), $pop28
	i32.const	$push127=, 0
	i32.const	$push29=, 16
	i32.store	incs+64($pop127), $pop29
	i32.const	$push126=, 0
	i32.const	$push30=, input+68
	i32.store	ptrs+68($pop126), $pop30
	i32.const	$push125=, 0
	i32.const	$push31=, 17
	i32.store	incs+68($pop125), $pop31
	i32.const	$push124=, 0
	i32.const	$push32=, input+72
	i32.store	ptrs+72($pop124), $pop32
	i32.const	$push123=, 0
	i32.const	$push33=, 18
	i32.store	incs+72($pop123), $pop33
	i32.const	$push122=, 0
	i32.const	$push34=, input+76
	i32.store	ptrs+76($pop122), $pop34
	i32.const	$push121=, 0
	i32.const	$push35=, 19
	i32.store	incs+76($pop121), $pop35
.LBB2_1:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label3:
	f32.convert_s/i32	$push36=, $1
	f32.store	0($0), $pop36
	i32.const	$push167=, 4
	i32.add 	$0=, $0, $pop167
	i32.const	$push166=, 1
	i32.add 	$push165=, $1, $pop166
	tee_local	$push164=, $1=, $pop165
	i32.const	$push163=, 80
	i32.ne  	$push37=, $pop164, $pop163
	br_if   	0, $pop37       # 0: up to label3
# BB#2:                                 # %for.end8
	end_loop
	i32.const	$push38=, 4
	call    	foo@FUNCTION, $pop38
	i32.const	$push39=, 0
	f32.load	$push43=, results($pop39)
	f32.const	$push44=, 0x0p0
	f32.ne  	$push45=, $pop43, $pop44
	i32.const	$push186=, 0
	f32.load	$push40=, results+4($pop186)
	f32.const	$push41=, 0x1.4p3
	f32.ne  	$push42=, $pop40, $pop41
	i32.or  	$push46=, $pop45, $pop42
	i32.const	$push185=, 0
	f32.load	$push47=, results+8($pop185)
	f32.const	$push48=, 0x1.4p4
	f32.ne  	$push49=, $pop47, $pop48
	i32.or  	$push50=, $pop46, $pop49
	i32.const	$push184=, 0
	f32.load	$push51=, results+12($pop184)
	f32.const	$push52=, 0x1.ep4
	f32.ne  	$push53=, $pop51, $pop52
	i32.or  	$push54=, $pop50, $pop53
	i32.const	$push183=, 0
	f32.load	$push55=, results+16($pop183)
	f32.const	$push56=, 0x1.4p5
	f32.ne  	$push57=, $pop55, $pop56
	i32.or  	$push58=, $pop54, $pop57
	i32.const	$push182=, 0
	f32.load	$push59=, results+20($pop182)
	f32.const	$push60=, 0x1.9p5
	f32.ne  	$push61=, $pop59, $pop60
	i32.or  	$push62=, $pop58, $pop61
	i32.const	$push181=, 0
	f32.load	$push63=, results+24($pop181)
	f32.const	$push64=, 0x1.ep5
	f32.ne  	$push65=, $pop63, $pop64
	i32.or  	$push66=, $pop62, $pop65
	i32.const	$push180=, 0
	f32.load	$push67=, results+28($pop180)
	f32.const	$push68=, 0x1.18p6
	f32.ne  	$push69=, $pop67, $pop68
	i32.or  	$push70=, $pop66, $pop69
	i32.const	$push179=, 0
	f32.load	$push71=, results+32($pop179)
	f32.const	$push72=, 0x1.4p6
	f32.ne  	$push73=, $pop71, $pop72
	i32.or  	$push74=, $pop70, $pop73
	i32.const	$push178=, 0
	f32.load	$push75=, results+36($pop178)
	f32.const	$push76=, 0x1.68p6
	f32.ne  	$push77=, $pop75, $pop76
	i32.or  	$push78=, $pop74, $pop77
	i32.const	$push177=, 0
	f32.load	$push79=, results+40($pop177)
	f32.const	$push80=, 0x1.9p6
	f32.ne  	$push81=, $pop79, $pop80
	i32.or  	$push82=, $pop78, $pop81
	i32.const	$push176=, 0
	f32.load	$push83=, results+44($pop176)
	f32.const	$push84=, 0x1.b8p6
	f32.ne  	$push85=, $pop83, $pop84
	i32.or  	$push86=, $pop82, $pop85
	i32.const	$push175=, 0
	f32.load	$push87=, results+48($pop175)
	f32.const	$push88=, 0x1.ep6
	f32.ne  	$push89=, $pop87, $pop88
	i32.or  	$push90=, $pop86, $pop89
	i32.const	$push174=, 0
	f32.load	$push91=, results+52($pop174)
	f32.const	$push92=, 0x1.04p7
	f32.ne  	$push93=, $pop91, $pop92
	i32.or  	$push94=, $pop90, $pop93
	i32.const	$push173=, 0
	f32.load	$push95=, results+56($pop173)
	f32.const	$push96=, 0x1.18p7
	f32.ne  	$push97=, $pop95, $pop96
	i32.or  	$push98=, $pop94, $pop97
	i32.const	$push172=, 0
	f32.load	$push99=, results+60($pop172)
	f32.const	$push100=, 0x1.2cp7
	f32.ne  	$push101=, $pop99, $pop100
	i32.or  	$push102=, $pop98, $pop101
	i32.const	$push171=, 0
	f32.load	$push103=, results+64($pop171)
	f32.const	$push104=, 0x1.4p7
	f32.ne  	$push105=, $pop103, $pop104
	i32.or  	$push106=, $pop102, $pop105
	i32.const	$push170=, 0
	f32.load	$push107=, results+68($pop170)
	f32.const	$push108=, 0x1.54p7
	f32.ne  	$push109=, $pop107, $pop108
	i32.or  	$push110=, $pop106, $pop109
	i32.const	$push169=, 0
	f32.load	$push111=, results+72($pop169)
	f32.const	$push112=, 0x1.68p7
	f32.ne  	$push113=, $pop111, $pop112
	i32.or  	$push114=, $pop110, $pop113
	i32.const	$push168=, 0
	f32.load	$push115=, results+76($pop168)
	f32.const	$push116=, 0x1.7cp7
	f32.ne  	$push117=, $pop115, $pop116
	i32.or  	$push118=, $pop114, $pop117
	i32.const	$push119=, 1
	i32.and 	$push120=, $pop118, $pop119
                                        # fallthrough-return: $pop120
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

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


	.ident	"clang version 4.0.0 "
