	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr28982b.c"
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
	i32.store	$drop=, incs($pop1), $pop3
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, i32
# BB#0:                                 # %entry
	i32.const	$push75=, 0
	i32.const	$push72=, 0
	i32.load	$push73=, __stack_pointer($pop72)
	i32.const	$push74=, 524288
	i32.sub 	$push86=, $pop73, $pop74
	tee_local	$push85=, $62=, $pop86
	i32.store	$drop=, __stack_pointer($pop75), $pop85
	i32.const	$push79=, 262144
	i32.add 	$push80=, $62, $pop79
	i32.const	$push84=, 0
	i32.const	$push83=, 262144
	i32.call	$drop=, memset@FUNCTION, $pop80, $pop84, $pop83
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
	f32.const	$61=, 0x0p0
	block
	i32.eqz 	$push191=, $0
	br_if   	0, $pop191      # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$push164=, 0
	i64.load	$push163=, incs($pop164)
	tee_local	$push162=, $21=, $pop163
	i32.wrap/i64	$push0=, $pop162
	i32.const	$push51=, 2
	i32.shl 	$20=, $pop0, $pop51
	i64.const	$push40=, 32
	i64.shr_u	$push50=, $21, $pop40
	i32.wrap/i64	$push1=, $pop50
	i32.const	$push161=, 2
	i32.shl 	$19=, $pop1, $pop161
	i32.const	$push160=, 0
	i64.load	$push159=, incs+8($pop160)
	tee_local	$push158=, $21=, $pop159
	i32.wrap/i64	$push2=, $pop158
	i32.const	$push157=, 2
	i32.shl 	$18=, $pop2, $pop157
	i64.const	$push156=, 32
	i64.shr_u	$push49=, $21, $pop156
	i32.wrap/i64	$push3=, $pop49
	i32.const	$push155=, 2
	i32.shl 	$17=, $pop3, $pop155
	i32.const	$push154=, 0
	i64.load	$push153=, incs+16($pop154)
	tee_local	$push152=, $21=, $pop153
	i32.wrap/i64	$push4=, $pop152
	i32.const	$push151=, 2
	i32.shl 	$16=, $pop4, $pop151
	i64.const	$push150=, 32
	i64.shr_u	$push48=, $21, $pop150
	i32.wrap/i64	$push5=, $pop48
	i32.const	$push149=, 2
	i32.shl 	$15=, $pop5, $pop149
	i32.const	$push148=, 0
	i64.load	$push147=, incs+24($pop148)
	tee_local	$push146=, $21=, $pop147
	i32.wrap/i64	$push6=, $pop146
	i32.const	$push145=, 2
	i32.shl 	$14=, $pop6, $pop145
	i64.const	$push144=, 32
	i64.shr_u	$push47=, $21, $pop144
	i32.wrap/i64	$push7=, $pop47
	i32.const	$push143=, 2
	i32.shl 	$13=, $pop7, $pop143
	i32.const	$push142=, 0
	i64.load	$push141=, incs+32($pop142)
	tee_local	$push140=, $21=, $pop141
	i32.wrap/i64	$push8=, $pop140
	i32.const	$push139=, 2
	i32.shl 	$12=, $pop8, $pop139
	i64.const	$push138=, 32
	i64.shr_u	$push46=, $21, $pop138
	i32.wrap/i64	$push9=, $pop46
	i32.const	$push137=, 2
	i32.shl 	$11=, $pop9, $pop137
	i32.const	$push136=, 0
	i64.load	$push135=, incs+40($pop136)
	tee_local	$push134=, $21=, $pop135
	i32.wrap/i64	$push10=, $pop134
	i32.const	$push133=, 2
	i32.shl 	$10=, $pop10, $pop133
	i64.const	$push132=, 32
	i64.shr_u	$push45=, $21, $pop132
	i32.wrap/i64	$push11=, $pop45
	i32.const	$push131=, 2
	i32.shl 	$9=, $pop11, $pop131
	i32.const	$push130=, 0
	i64.load	$push129=, incs+48($pop130)
	tee_local	$push128=, $21=, $pop129
	i32.wrap/i64	$push12=, $pop128
	i32.const	$push127=, 2
	i32.shl 	$8=, $pop12, $pop127
	i64.const	$push126=, 32
	i64.shr_u	$push44=, $21, $pop126
	i32.wrap/i64	$push13=, $pop44
	i32.const	$push125=, 2
	i32.shl 	$7=, $pop13, $pop125
	i32.const	$push124=, 0
	i64.load	$push123=, incs+56($pop124)
	tee_local	$push122=, $21=, $pop123
	i32.wrap/i64	$push14=, $pop122
	i32.const	$push121=, 2
	i32.shl 	$6=, $pop14, $pop121
	i64.const	$push120=, 32
	i64.shr_u	$push43=, $21, $pop120
	i32.wrap/i64	$push15=, $pop43
	i32.const	$push119=, 2
	i32.shl 	$5=, $pop15, $pop119
	i32.const	$push118=, 0
	i64.load	$push117=, incs+64($pop118)
	tee_local	$push116=, $21=, $pop117
	i32.wrap/i64	$push16=, $pop116
	i32.const	$push115=, 2
	i32.shl 	$4=, $pop16, $pop115
	i64.const	$push114=, 32
	i64.shr_u	$push42=, $21, $pop114
	i32.wrap/i64	$push17=, $pop42
	i32.const	$push113=, 2
	i32.shl 	$3=, $pop17, $pop113
	i32.const	$push112=, 0
	i64.load	$push111=, incs+72($pop112)
	tee_local	$push110=, $21=, $pop111
	i32.wrap/i64	$push18=, $pop110
	i32.const	$push109=, 2
	i32.shl 	$2=, $pop18, $pop109
	i64.const	$push108=, 32
	i64.shr_u	$push41=, $21, $pop108
	i32.wrap/i64	$push19=, $pop41
	i32.const	$push107=, 2
	i32.shl 	$1=, $pop19, $pop107
	i32.const	$push106=, 0
	i32.load	$22=, ptrs($pop106)
	i32.const	$push105=, 0
	i32.load	$23=, ptrs+4($pop105)
	i32.const	$push104=, 0
	i32.load	$24=, ptrs+8($pop104)
	i32.const	$push103=, 0
	i32.load	$25=, ptrs+12($pop103)
	i32.const	$push102=, 0
	i32.load	$26=, ptrs+16($pop102)
	i32.const	$push101=, 0
	i32.load	$27=, ptrs+20($pop101)
	i32.const	$push100=, 0
	i32.load	$28=, ptrs+24($pop100)
	i32.const	$push99=, 0
	i32.load	$29=, ptrs+28($pop99)
	i32.const	$push98=, 0
	i32.load	$30=, ptrs+32($pop98)
	i32.const	$push97=, 0
	i32.load	$31=, ptrs+36($pop97)
	i32.const	$push96=, 0
	i32.load	$32=, ptrs+40($pop96)
	i32.const	$push95=, 0
	i32.load	$33=, ptrs+44($pop95)
	i32.const	$push94=, 0
	i32.load	$34=, ptrs+48($pop94)
	i32.const	$push93=, 0
	i32.load	$35=, ptrs+52($pop93)
	i32.const	$push92=, 0
	i32.load	$36=, ptrs+56($pop92)
	i32.const	$push91=, 0
	i32.load	$37=, ptrs+60($pop91)
	i32.const	$push90=, 0
	i32.load	$38=, ptrs+64($pop90)
	i32.const	$push89=, 0
	i32.load	$39=, ptrs+68($pop89)
	i32.const	$push88=, 0
	i32.load	$40=, ptrs+72($pop88)
	i32.const	$push87=, 0
	i32.load	$41=, ptrs+76($pop87)
	f32.const	$61=, 0x0p0
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
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	f32.load	$push52=, 0($41)
	f32.add 	$61=, $61, $pop52
	f32.load	$push53=, 0($40)
	f32.add 	$60=, $60, $pop53
	f32.load	$push54=, 0($39)
	f32.add 	$59=, $59, $pop54
	f32.load	$push55=, 0($38)
	f32.add 	$58=, $58, $pop55
	f32.load	$push56=, 0($37)
	f32.add 	$57=, $57, $pop56
	f32.load	$push57=, 0($36)
	f32.add 	$56=, $56, $pop57
	f32.load	$push58=, 0($35)
	f32.add 	$55=, $55, $pop58
	f32.load	$push59=, 0($34)
	f32.add 	$54=, $54, $pop59
	f32.load	$push60=, 0($33)
	f32.add 	$53=, $53, $pop60
	f32.load	$push61=, 0($32)
	f32.add 	$52=, $52, $pop61
	f32.load	$push62=, 0($31)
	f32.add 	$51=, $51, $pop62
	f32.load	$push63=, 0($30)
	f32.add 	$50=, $50, $pop63
	f32.load	$push64=, 0($29)
	f32.add 	$49=, $49, $pop64
	f32.load	$push65=, 0($28)
	f32.add 	$48=, $48, $pop65
	f32.load	$push66=, 0($27)
	f32.add 	$47=, $47, $pop66
	f32.load	$push67=, 0($26)
	f32.add 	$46=, $46, $pop67
	f32.load	$push68=, 0($25)
	f32.add 	$45=, $45, $pop68
	f32.load	$push69=, 0($24)
	f32.add 	$44=, $44, $pop69
	f32.load	$push70=, 0($23)
	f32.add 	$43=, $43, $pop70
	f32.load	$push71=, 0($22)
	f32.add 	$42=, $42, $pop71
	i32.add 	$push39=, $22, $20
	copy_local	$22=, $pop39
	i32.add 	$push38=, $23, $19
	copy_local	$23=, $pop38
	i32.add 	$push37=, $24, $18
	copy_local	$24=, $pop37
	i32.add 	$push36=, $25, $17
	copy_local	$25=, $pop36
	i32.add 	$push35=, $26, $16
	copy_local	$26=, $pop35
	i32.add 	$push34=, $27, $15
	copy_local	$27=, $pop34
	i32.add 	$push33=, $28, $14
	copy_local	$28=, $pop33
	i32.add 	$push32=, $29, $13
	copy_local	$29=, $pop32
	i32.add 	$push31=, $30, $12
	copy_local	$30=, $pop31
	i32.add 	$push30=, $31, $11
	copy_local	$31=, $pop30
	i32.add 	$push29=, $32, $10
	copy_local	$32=, $pop29
	i32.add 	$push28=, $33, $9
	copy_local	$33=, $pop28
	i32.add 	$push27=, $34, $8
	copy_local	$34=, $pop27
	i32.add 	$push26=, $35, $7
	copy_local	$35=, $pop26
	i32.add 	$push25=, $36, $6
	copy_local	$36=, $pop25
	i32.add 	$push24=, $37, $5
	copy_local	$37=, $pop24
	i32.add 	$push23=, $38, $4
	copy_local	$38=, $pop23
	i32.add 	$push22=, $39, $3
	copy_local	$39=, $pop22
	i32.add 	$push21=, $40, $2
	copy_local	$40=, $pop21
	i32.add 	$push20=, $41, $1
	copy_local	$41=, $pop20
	i32.const	$push167=, -1
	i32.add 	$push166=, $0, $pop167
	tee_local	$push165=, $0=, $pop166
	br_if   	0, $pop165      # 0: up to label1
.LBB1_3:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push190=, 0
	f32.store	$drop=, results+4($pop190), $43
	i32.const	$push189=, 0
	f32.store	$drop=, results($pop189), $42
	i32.const	$push188=, 0
	f32.store	$drop=, results+8($pop188), $44
	i32.const	$push187=, 0
	f32.store	$drop=, results+12($pop187), $45
	i32.const	$push186=, 0
	f32.store	$drop=, results+16($pop186), $46
	i32.const	$push185=, 0
	f32.store	$drop=, results+20($pop185), $47
	i32.const	$push184=, 0
	f32.store	$drop=, results+24($pop184), $48
	i32.const	$push183=, 0
	f32.store	$drop=, results+28($pop183), $49
	i32.const	$push182=, 0
	f32.store	$drop=, results+32($pop182), $50
	i32.const	$push181=, 0
	f32.store	$drop=, results+36($pop181), $51
	i32.const	$push180=, 0
	f32.store	$drop=, results+40($pop180), $52
	i32.const	$push179=, 0
	f32.store	$drop=, results+44($pop179), $53
	i32.const	$push178=, 0
	f32.store	$drop=, results+48($pop178), $54
	i32.const	$push177=, 0
	f32.store	$drop=, results+52($pop177), $55
	i32.const	$push176=, 0
	f32.store	$drop=, results+56($pop176), $56
	i32.const	$push175=, 0
	f32.store	$drop=, results+60($pop175), $57
	i32.const	$push174=, 0
	f32.store	$drop=, results+64($pop174), $58
	i32.const	$push173=, 0
	f32.store	$drop=, results+68($pop173), $59
	i32.const	$push172=, 0
	f32.store	$drop=, results+72($pop172), $60
	i32.const	$push171=, 0
	f32.store	$drop=, results+76($pop171), $61
	i32.const	$push81=, 262144
	i32.add 	$push82=, $62, $pop81
	i32.const	$push170=, 262144
	i32.call	$push169=, memcpy@FUNCTION, $62, $pop82, $pop170
	tee_local	$push168=, $22=, $pop169
	call    	bar@FUNCTION, $pop168
	i32.const	$push78=, 0
	i32.const	$push76=, 524288
	i32.add 	$push77=, $22, $pop76
	i32.store	$drop=, __stack_pointer($pop78), $pop77
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
	i32.store	$drop=, ptrs($pop162), $pop161
	i32.const	$push160=, 0
	i32.const	$push0=, input+4
	i32.store	$drop=, ptrs+4($pop160), $pop0
	i32.const	$push159=, 0
	i32.const	$push1=, input+8
	i32.store	$drop=, ptrs+8($pop159), $pop1
	i32.const	$push158=, 0
	i64.const	$push2=, 8589934593
	i64.store	$drop=, incs+4($pop158):p2align=2, $pop2
	i32.const	$push157=, 0
	i32.const	$push3=, input+12
	i32.store	$drop=, ptrs+12($pop157), $pop3
	i32.const	$push156=, 0
	i32.const	$push155=, 0
	i32.store	$drop=, incs($pop156), $pop155
	i32.const	$push154=, 0
	i32.const	$push4=, 3
	i32.store	$drop=, incs+12($pop154), $pop4
	i32.const	$push153=, 0
	i32.const	$push5=, input+16
	i32.store	$drop=, ptrs+16($pop153), $pop5
	i32.const	$push152=, 0
	i32.const	$push151=, 4
	i32.store	$drop=, incs+16($pop152), $pop151
	i32.const	$push150=, 0
	i32.const	$push6=, input+20
	i32.store	$drop=, ptrs+20($pop150), $pop6
	i32.const	$push149=, 0
	i32.const	$push7=, 5
	i32.store	$drop=, incs+20($pop149), $pop7
	i32.const	$push148=, 0
	i32.const	$push8=, input+24
	i32.store	$drop=, ptrs+24($pop148), $pop8
	i32.const	$push147=, 0
	i32.const	$push9=, 6
	i32.store	$drop=, incs+24($pop147), $pop9
	i32.const	$push146=, 0
	i32.const	$push10=, input+28
	i32.store	$drop=, ptrs+28($pop146), $pop10
	i32.const	$push145=, 0
	i32.const	$push11=, 7
	i32.store	$drop=, incs+28($pop145), $pop11
	i32.const	$push144=, 0
	i32.const	$push12=, input+32
	i32.store	$drop=, ptrs+32($pop144), $pop12
	i32.const	$push143=, 0
	i32.const	$push13=, 8
	i32.store	$drop=, incs+32($pop143), $pop13
	i32.const	$push142=, 0
	i32.const	$push14=, input+36
	i32.store	$drop=, ptrs+36($pop142), $pop14
	i32.const	$push141=, 0
	i32.const	$push15=, 9
	i32.store	$drop=, incs+36($pop141), $pop15
	i32.const	$push140=, 0
	i32.const	$push16=, input+40
	i32.store	$drop=, ptrs+40($pop140), $pop16
	i32.const	$push139=, 0
	i32.const	$push17=, 10
	i32.store	$drop=, incs+40($pop139), $pop17
	i32.const	$push138=, 0
	i32.const	$push18=, input+44
	i32.store	$drop=, ptrs+44($pop138), $pop18
	i32.const	$push137=, 0
	i32.const	$push19=, 11
	i32.store	$drop=, incs+44($pop137), $pop19
	i32.const	$push136=, 0
	i32.const	$push20=, input+48
	i32.store	$drop=, ptrs+48($pop136), $pop20
	i32.const	$push135=, 0
	i32.const	$push21=, 12
	i32.store	$drop=, incs+48($pop135), $pop21
	i32.const	$push134=, 0
	i32.const	$push22=, input+52
	i32.store	$drop=, ptrs+52($pop134), $pop22
	i32.const	$push133=, 0
	i32.const	$push23=, 13
	i32.store	$drop=, incs+52($pop133), $pop23
	i32.const	$push132=, 0
	i32.const	$push24=, input+56
	i32.store	$drop=, ptrs+56($pop132), $pop24
	i32.const	$push131=, 0
	i32.const	$push25=, 14
	i32.store	$drop=, incs+56($pop131), $pop25
	i32.const	$push130=, 0
	i32.const	$push26=, input+60
	i32.store	$drop=, ptrs+60($pop130), $pop26
	i32.const	$push129=, 0
	i32.const	$push27=, 15
	i32.store	$drop=, incs+60($pop129), $pop27
	i32.const	$push128=, 0
	i32.const	$push28=, input+64
	i32.store	$drop=, ptrs+64($pop128), $pop28
	i32.const	$push127=, 0
	i32.const	$push29=, 16
	i32.store	$drop=, incs+64($pop127), $pop29
	i32.const	$push126=, 0
	i32.const	$push30=, input+68
	i32.store	$drop=, ptrs+68($pop126), $pop30
	i32.const	$push125=, 0
	i32.const	$push31=, 17
	i32.store	$drop=, incs+68($pop125), $pop31
	i32.const	$push124=, 0
	i32.const	$push32=, input+72
	i32.store	$drop=, ptrs+72($pop124), $pop32
	i32.const	$push123=, 0
	i32.const	$push33=, 18
	i32.store	$drop=, incs+72($pop123), $pop33
	i32.const	$push122=, 0
	i32.const	$push34=, input+76
	i32.store	$drop=, ptrs+76($pop122), $pop34
	i32.const	$push121=, 0
	i32.const	$push35=, 19
	i32.store	$drop=, incs+76($pop121), $pop35
.LBB2_1:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	f32.convert_s/i32	$push36=, $1
	f32.store	$drop=, 0($0), $pop36
	i32.const	$push167=, 4
	i32.add 	$0=, $0, $pop167
	i32.const	$push166=, 1
	i32.add 	$push165=, $1, $pop166
	tee_local	$push164=, $1=, $pop165
	i32.const	$push163=, 80
	i32.ne  	$push37=, $pop164, $pop163
	br_if   	0, $pop37       # 0: up to label3
# BB#2:                                 # %for.end8
	end_loop                        # label4:
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
