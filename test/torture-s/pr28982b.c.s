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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32
# BB#0:                                 # %entry
	i32.const	$push75=, 0
	i32.const	$push72=, 0
	i32.load	$push73=, __stack_pointer($pop72)
	i32.const	$push74=, 524288
	i32.sub 	$push83=, $pop73, $pop74
	i32.store	$push87=, __stack_pointer($pop75), $pop83
	tee_local	$push86=, $1=, $pop87
	i32.const	$push79=, 262144
	i32.add 	$push80=, $pop86, $pop79
	i32.const	$push85=, 0
	i32.const	$push84=, 262144
	i32.call	$drop=, memset@FUNCTION, $pop80, $pop85, $pop84
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
	f32.const	$62=, 0x0p0
	block
	i32.eqz 	$push192=, $0
	br_if   	0, $pop192      # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$push165=, 0
	i64.load	$push164=, incs($pop165)
	tee_local	$push163=, $22=, $pop164
	i32.wrap/i64	$push0=, $pop163
	i32.const	$push51=, 2
	i32.shl 	$21=, $pop0, $pop51
	i64.const	$push40=, 32
	i64.shr_u	$push50=, $22, $pop40
	i32.wrap/i64	$push1=, $pop50
	i32.const	$push162=, 2
	i32.shl 	$20=, $pop1, $pop162
	i32.const	$push161=, 0
	i64.load	$push160=, incs+8($pop161)
	tee_local	$push159=, $22=, $pop160
	i32.wrap/i64	$push2=, $pop159
	i32.const	$push158=, 2
	i32.shl 	$19=, $pop2, $pop158
	i64.const	$push157=, 32
	i64.shr_u	$push49=, $22, $pop157
	i32.wrap/i64	$push3=, $pop49
	i32.const	$push156=, 2
	i32.shl 	$18=, $pop3, $pop156
	i32.const	$push155=, 0
	i64.load	$push154=, incs+16($pop155)
	tee_local	$push153=, $22=, $pop154
	i32.wrap/i64	$push4=, $pop153
	i32.const	$push152=, 2
	i32.shl 	$17=, $pop4, $pop152
	i64.const	$push151=, 32
	i64.shr_u	$push48=, $22, $pop151
	i32.wrap/i64	$push5=, $pop48
	i32.const	$push150=, 2
	i32.shl 	$16=, $pop5, $pop150
	i32.const	$push149=, 0
	i64.load	$push148=, incs+24($pop149)
	tee_local	$push147=, $22=, $pop148
	i32.wrap/i64	$push6=, $pop147
	i32.const	$push146=, 2
	i32.shl 	$15=, $pop6, $pop146
	i64.const	$push145=, 32
	i64.shr_u	$push47=, $22, $pop145
	i32.wrap/i64	$push7=, $pop47
	i32.const	$push144=, 2
	i32.shl 	$14=, $pop7, $pop144
	i32.const	$push143=, 0
	i64.load	$push142=, incs+32($pop143)
	tee_local	$push141=, $22=, $pop142
	i32.wrap/i64	$push8=, $pop141
	i32.const	$push140=, 2
	i32.shl 	$13=, $pop8, $pop140
	i64.const	$push139=, 32
	i64.shr_u	$push46=, $22, $pop139
	i32.wrap/i64	$push9=, $pop46
	i32.const	$push138=, 2
	i32.shl 	$12=, $pop9, $pop138
	i32.const	$push137=, 0
	i64.load	$push136=, incs+40($pop137)
	tee_local	$push135=, $22=, $pop136
	i32.wrap/i64	$push10=, $pop135
	i32.const	$push134=, 2
	i32.shl 	$11=, $pop10, $pop134
	i64.const	$push133=, 32
	i64.shr_u	$push45=, $22, $pop133
	i32.wrap/i64	$push11=, $pop45
	i32.const	$push132=, 2
	i32.shl 	$10=, $pop11, $pop132
	i32.const	$push131=, 0
	i64.load	$push130=, incs+48($pop131)
	tee_local	$push129=, $22=, $pop130
	i32.wrap/i64	$push12=, $pop129
	i32.const	$push128=, 2
	i32.shl 	$9=, $pop12, $pop128
	i64.const	$push127=, 32
	i64.shr_u	$push44=, $22, $pop127
	i32.wrap/i64	$push13=, $pop44
	i32.const	$push126=, 2
	i32.shl 	$8=, $pop13, $pop126
	i32.const	$push125=, 0
	i64.load	$push124=, incs+56($pop125)
	tee_local	$push123=, $22=, $pop124
	i32.wrap/i64	$push14=, $pop123
	i32.const	$push122=, 2
	i32.shl 	$7=, $pop14, $pop122
	i64.const	$push121=, 32
	i64.shr_u	$push43=, $22, $pop121
	i32.wrap/i64	$push15=, $pop43
	i32.const	$push120=, 2
	i32.shl 	$6=, $pop15, $pop120
	i32.const	$push119=, 0
	i64.load	$push118=, incs+64($pop119)
	tee_local	$push117=, $22=, $pop118
	i32.wrap/i64	$push16=, $pop117
	i32.const	$push116=, 2
	i32.shl 	$5=, $pop16, $pop116
	i64.const	$push115=, 32
	i64.shr_u	$push42=, $22, $pop115
	i32.wrap/i64	$push17=, $pop42
	i32.const	$push114=, 2
	i32.shl 	$4=, $pop17, $pop114
	i32.const	$push113=, 0
	i64.load	$push112=, incs+72($pop113)
	tee_local	$push111=, $22=, $pop112
	i32.wrap/i64	$push18=, $pop111
	i32.const	$push110=, 2
	i32.shl 	$3=, $pop18, $pop110
	i64.const	$push109=, 32
	i64.shr_u	$push41=, $22, $pop109
	i32.wrap/i64	$push19=, $pop41
	i32.const	$push108=, 2
	i32.shl 	$2=, $pop19, $pop108
	i32.const	$push107=, 0
	i32.load	$23=, ptrs($pop107)
	i32.const	$push106=, 0
	i32.load	$24=, ptrs+4($pop106)
	i32.const	$push105=, 0
	i32.load	$25=, ptrs+8($pop105)
	i32.const	$push104=, 0
	i32.load	$26=, ptrs+12($pop104)
	i32.const	$push103=, 0
	i32.load	$27=, ptrs+16($pop103)
	i32.const	$push102=, 0
	i32.load	$28=, ptrs+20($pop102)
	i32.const	$push101=, 0
	i32.load	$29=, ptrs+24($pop101)
	i32.const	$push100=, 0
	i32.load	$30=, ptrs+28($pop100)
	i32.const	$push99=, 0
	i32.load	$31=, ptrs+32($pop99)
	i32.const	$push98=, 0
	i32.load	$32=, ptrs+36($pop98)
	i32.const	$push97=, 0
	i32.load	$33=, ptrs+40($pop97)
	i32.const	$push96=, 0
	i32.load	$34=, ptrs+44($pop96)
	i32.const	$push95=, 0
	i32.load	$35=, ptrs+48($pop95)
	i32.const	$push94=, 0
	i32.load	$36=, ptrs+52($pop94)
	i32.const	$push93=, 0
	i32.load	$37=, ptrs+56($pop93)
	i32.const	$push92=, 0
	i32.load	$38=, ptrs+60($pop92)
	i32.const	$push91=, 0
	i32.load	$39=, ptrs+64($pop91)
	i32.const	$push90=, 0
	i32.load	$40=, ptrs+68($pop90)
	i32.const	$push89=, 0
	i32.load	$41=, ptrs+72($pop89)
	i32.const	$push88=, 0
	i32.load	$42=, ptrs+76($pop88)
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
	f32.const	$62=, 0x0p0
.LBB1_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	f32.load	$push52=, 0($42)
	f32.add 	$43=, $43, $pop52
	f32.load	$push53=, 0($41)
	f32.add 	$44=, $44, $pop53
	f32.load	$push54=, 0($40)
	f32.add 	$45=, $45, $pop54
	f32.load	$push55=, 0($39)
	f32.add 	$46=, $46, $pop55
	f32.load	$push56=, 0($38)
	f32.add 	$47=, $47, $pop56
	f32.load	$push57=, 0($37)
	f32.add 	$48=, $48, $pop57
	f32.load	$push58=, 0($36)
	f32.add 	$49=, $49, $pop58
	f32.load	$push59=, 0($35)
	f32.add 	$50=, $50, $pop59
	f32.load	$push60=, 0($34)
	f32.add 	$51=, $51, $pop60
	f32.load	$push61=, 0($33)
	f32.add 	$52=, $52, $pop61
	f32.load	$push62=, 0($32)
	f32.add 	$53=, $53, $pop62
	f32.load	$push63=, 0($31)
	f32.add 	$54=, $54, $pop63
	f32.load	$push64=, 0($30)
	f32.add 	$55=, $55, $pop64
	f32.load	$push65=, 0($29)
	f32.add 	$56=, $56, $pop65
	f32.load	$push66=, 0($28)
	f32.add 	$57=, $57, $pop66
	f32.load	$push67=, 0($27)
	f32.add 	$58=, $58, $pop67
	f32.load	$push68=, 0($26)
	f32.add 	$59=, $59, $pop68
	f32.load	$push69=, 0($25)
	f32.add 	$60=, $60, $pop69
	f32.load	$push70=, 0($24)
	f32.add 	$61=, $61, $pop70
	f32.load	$push71=, 0($23)
	f32.add 	$62=, $62, $pop71
	i32.add 	$push39=, $23, $21
	copy_local	$23=, $pop39
	i32.add 	$push38=, $24, $20
	copy_local	$24=, $pop38
	i32.add 	$push37=, $25, $19
	copy_local	$25=, $pop37
	i32.add 	$push36=, $26, $18
	copy_local	$26=, $pop36
	i32.add 	$push35=, $27, $17
	copy_local	$27=, $pop35
	i32.add 	$push34=, $28, $16
	copy_local	$28=, $pop34
	i32.add 	$push33=, $29, $15
	copy_local	$29=, $pop33
	i32.add 	$push32=, $30, $14
	copy_local	$30=, $pop32
	i32.add 	$push31=, $31, $13
	copy_local	$31=, $pop31
	i32.add 	$push30=, $32, $12
	copy_local	$32=, $pop30
	i32.add 	$push29=, $33, $11
	copy_local	$33=, $pop29
	i32.add 	$push28=, $34, $10
	copy_local	$34=, $pop28
	i32.add 	$push27=, $35, $9
	copy_local	$35=, $pop27
	i32.add 	$push26=, $36, $8
	copy_local	$36=, $pop26
	i32.add 	$push25=, $37, $7
	copy_local	$37=, $pop25
	i32.add 	$push24=, $38, $6
	copy_local	$38=, $pop24
	i32.add 	$push23=, $39, $5
	copy_local	$39=, $pop23
	i32.add 	$push22=, $40, $4
	copy_local	$40=, $pop22
	i32.add 	$push21=, $41, $3
	copy_local	$41=, $pop21
	i32.add 	$push20=, $42, $2
	copy_local	$42=, $pop20
	i32.const	$push168=, -1
	i32.add 	$push167=, $0, $pop168
	tee_local	$push166=, $0=, $pop167
	br_if   	0, $pop166      # 0: up to label1
.LBB1_3:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push191=, 0
	f32.store	$drop=, results+4($pop191), $61
	i32.const	$push190=, 0
	f32.store	$drop=, results($pop190), $62
	i32.const	$push189=, 0
	f32.store	$drop=, results+8($pop189), $60
	i32.const	$push188=, 0
	f32.store	$drop=, results+12($pop188), $59
	i32.const	$push187=, 0
	f32.store	$drop=, results+16($pop187), $58
	i32.const	$push186=, 0
	f32.store	$drop=, results+20($pop186), $57
	i32.const	$push185=, 0
	f32.store	$drop=, results+24($pop185), $56
	i32.const	$push184=, 0
	f32.store	$drop=, results+28($pop184), $55
	i32.const	$push183=, 0
	f32.store	$drop=, results+32($pop183), $54
	i32.const	$push182=, 0
	f32.store	$drop=, results+36($pop182), $53
	i32.const	$push181=, 0
	f32.store	$drop=, results+40($pop181), $52
	i32.const	$push180=, 0
	f32.store	$drop=, results+44($pop180), $51
	i32.const	$push179=, 0
	f32.store	$drop=, results+48($pop179), $50
	i32.const	$push178=, 0
	f32.store	$drop=, results+52($pop178), $49
	i32.const	$push177=, 0
	f32.store	$drop=, results+56($pop177), $48
	i32.const	$push176=, 0
	f32.store	$drop=, results+60($pop176), $47
	i32.const	$push175=, 0
	f32.store	$drop=, results+64($pop175), $46
	i32.const	$push174=, 0
	f32.store	$drop=, results+68($pop174), $45
	i32.const	$push173=, 0
	f32.store	$drop=, results+72($pop173), $44
	i32.const	$push172=, 0
	f32.store	$drop=, results+76($pop172), $43
	i32.const	$push81=, 262144
	i32.add 	$push82=, $1, $pop81
	i32.const	$push171=, 262144
	i32.call	$push170=, memcpy@FUNCTION, $1, $pop82, $pop171
	tee_local	$push169=, $23=, $pop170
	call    	bar@FUNCTION, $pop169
	i32.const	$push78=, 0
	i32.const	$push76=, 524288
	i32.add 	$push77=, $23, $pop76
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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, input
	i32.const	$3=, 0
	i32.const	$push131=, 0
	i32.const	$push130=, input
	i32.store	$drop=, ptrs($pop131), $pop130
	i32.const	$push129=, 0
	i32.const	$push0=, input+4
	i32.store	$drop=, ptrs+4($pop129), $pop0
	i32.const	$push128=, 0
	i32.const	$push1=, input+8
	i32.store	$drop=, ptrs+8($pop128), $pop1
	i32.const	$push127=, 0
	i64.const	$push2=, 8589934593
	i64.store	$drop=, incs+4($pop127):p2align=2, $pop2
	i32.const	$push126=, 0
	i32.const	$push3=, input+12
	i32.store	$drop=, ptrs+12($pop126), $pop3
	i32.const	$push125=, 0
	i32.const	$push124=, 0
	i32.store	$push123=, incs($pop125), $pop124
	tee_local	$push122=, $0=, $pop123
	i32.const	$push4=, 3
	i32.store	$drop=, incs+12($pop122), $pop4
	i32.const	$push5=, input+16
	i32.store	$drop=, ptrs+16($0), $pop5
	i32.const	$push6=, 4
	i32.store	$1=, incs+16($0), $pop6
	i32.const	$push7=, input+20
	i32.store	$drop=, ptrs+20($0), $pop7
	i32.const	$push8=, 5
	i32.store	$drop=, incs+20($0), $pop8
	i32.const	$push9=, input+24
	i32.store	$drop=, ptrs+24($0), $pop9
	i32.const	$push10=, 6
	i32.store	$drop=, incs+24($0), $pop10
	i32.const	$push11=, input+28
	i32.store	$drop=, ptrs+28($0), $pop11
	i32.const	$push12=, 7
	i32.store	$drop=, incs+28($0), $pop12
	i32.const	$push13=, input+32
	i32.store	$drop=, ptrs+32($0), $pop13
	i32.const	$push14=, 8
	i32.store	$drop=, incs+32($0), $pop14
	i32.const	$push15=, input+36
	i32.store	$drop=, ptrs+36($0), $pop15
	i32.const	$push16=, 9
	i32.store	$drop=, incs+36($0), $pop16
	i32.const	$push17=, input+40
	i32.store	$drop=, ptrs+40($0), $pop17
	i32.const	$push18=, 10
	i32.store	$drop=, incs+40($0), $pop18
	i32.const	$push19=, input+44
	i32.store	$drop=, ptrs+44($0), $pop19
	i32.const	$push20=, 11
	i32.store	$drop=, incs+44($0), $pop20
	i32.const	$push21=, input+48
	i32.store	$drop=, ptrs+48($0), $pop21
	i32.const	$push22=, 12
	i32.store	$drop=, incs+48($0), $pop22
	i32.const	$push23=, input+52
	i32.store	$drop=, ptrs+52($0), $pop23
	i32.const	$push24=, 13
	i32.store	$drop=, incs+52($0), $pop24
	i32.const	$push25=, input+56
	i32.store	$drop=, ptrs+56($0), $pop25
	i32.const	$push26=, 14
	i32.store	$drop=, incs+56($0), $pop26
	i32.const	$push27=, input+60
	i32.store	$drop=, ptrs+60($0), $pop27
	i32.const	$push28=, 15
	i32.store	$drop=, incs+60($0), $pop28
	i32.const	$push29=, input+64
	i32.store	$drop=, ptrs+64($0), $pop29
	i32.const	$push30=, 16
	i32.store	$drop=, incs+64($0), $pop30
	i32.const	$push31=, input+68
	i32.store	$drop=, ptrs+68($0), $pop31
	i32.const	$push32=, 17
	i32.store	$drop=, incs+68($0), $pop32
	i32.const	$push33=, input+72
	i32.store	$drop=, ptrs+72($0), $pop33
	i32.const	$push34=, 18
	i32.store	$drop=, incs+72($0), $pop34
	i32.const	$push35=, input+76
	i32.store	$drop=, ptrs+76($0), $pop35
	i32.const	$push36=, 19
	i32.store	$drop=, incs+76($0), $pop36
.LBB2_1:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	f32.convert_s/i32	$push37=, $3
	f32.store	$drop=, 0($2), $pop37
	i32.add 	$2=, $2, $1
	i32.const	$push135=, 1
	i32.add 	$push134=, $3, $pop135
	tee_local	$push133=, $3=, $pop134
	i32.const	$push132=, 80
	i32.ne  	$push38=, $pop133, $pop132
	br_if   	0, $pop38       # 0: up to label3
# BB#2:                                 # %for.end8
	end_loop                        # label4:
	i32.const	$push39=, 4
	call    	foo@FUNCTION, $pop39
	i32.const	$push40=, 0
	f32.load	$push44=, results($pop40)
	f32.const	$push45=, 0x0p0
	f32.ne  	$push46=, $pop44, $pop45
	i32.const	$push154=, 0
	f32.load	$push41=, results+4($pop154)
	f32.const	$push42=, 0x1.4p3
	f32.ne  	$push43=, $pop41, $pop42
	i32.or  	$push47=, $pop46, $pop43
	i32.const	$push153=, 0
	f32.load	$push48=, results+8($pop153)
	f32.const	$push49=, 0x1.4p4
	f32.ne  	$push50=, $pop48, $pop49
	i32.or  	$push51=, $pop47, $pop50
	i32.const	$push152=, 0
	f32.load	$push52=, results+12($pop152)
	f32.const	$push53=, 0x1.ep4
	f32.ne  	$push54=, $pop52, $pop53
	i32.or  	$push55=, $pop51, $pop54
	i32.const	$push151=, 0
	f32.load	$push56=, results+16($pop151)
	f32.const	$push57=, 0x1.4p5
	f32.ne  	$push58=, $pop56, $pop57
	i32.or  	$push59=, $pop55, $pop58
	i32.const	$push150=, 0
	f32.load	$push60=, results+20($pop150)
	f32.const	$push61=, 0x1.9p5
	f32.ne  	$push62=, $pop60, $pop61
	i32.or  	$push63=, $pop59, $pop62
	i32.const	$push149=, 0
	f32.load	$push64=, results+24($pop149)
	f32.const	$push65=, 0x1.ep5
	f32.ne  	$push66=, $pop64, $pop65
	i32.or  	$push67=, $pop63, $pop66
	i32.const	$push148=, 0
	f32.load	$push68=, results+28($pop148)
	f32.const	$push69=, 0x1.18p6
	f32.ne  	$push70=, $pop68, $pop69
	i32.or  	$push71=, $pop67, $pop70
	i32.const	$push147=, 0
	f32.load	$push72=, results+32($pop147)
	f32.const	$push73=, 0x1.4p6
	f32.ne  	$push74=, $pop72, $pop73
	i32.or  	$push75=, $pop71, $pop74
	i32.const	$push146=, 0
	f32.load	$push76=, results+36($pop146)
	f32.const	$push77=, 0x1.68p6
	f32.ne  	$push78=, $pop76, $pop77
	i32.or  	$push79=, $pop75, $pop78
	i32.const	$push145=, 0
	f32.load	$push80=, results+40($pop145)
	f32.const	$push81=, 0x1.9p6
	f32.ne  	$push82=, $pop80, $pop81
	i32.or  	$push83=, $pop79, $pop82
	i32.const	$push144=, 0
	f32.load	$push84=, results+44($pop144)
	f32.const	$push85=, 0x1.b8p6
	f32.ne  	$push86=, $pop84, $pop85
	i32.or  	$push87=, $pop83, $pop86
	i32.const	$push143=, 0
	f32.load	$push88=, results+48($pop143)
	f32.const	$push89=, 0x1.ep6
	f32.ne  	$push90=, $pop88, $pop89
	i32.or  	$push91=, $pop87, $pop90
	i32.const	$push142=, 0
	f32.load	$push92=, results+52($pop142)
	f32.const	$push93=, 0x1.04p7
	f32.ne  	$push94=, $pop92, $pop93
	i32.or  	$push95=, $pop91, $pop94
	i32.const	$push141=, 0
	f32.load	$push96=, results+56($pop141)
	f32.const	$push97=, 0x1.18p7
	f32.ne  	$push98=, $pop96, $pop97
	i32.or  	$push99=, $pop95, $pop98
	i32.const	$push140=, 0
	f32.load	$push100=, results+60($pop140)
	f32.const	$push101=, 0x1.2cp7
	f32.ne  	$push102=, $pop100, $pop101
	i32.or  	$push103=, $pop99, $pop102
	i32.const	$push139=, 0
	f32.load	$push104=, results+64($pop139)
	f32.const	$push105=, 0x1.4p7
	f32.ne  	$push106=, $pop104, $pop105
	i32.or  	$push107=, $pop103, $pop106
	i32.const	$push138=, 0
	f32.load	$push108=, results+68($pop138)
	f32.const	$push109=, 0x1.54p7
	f32.ne  	$push110=, $pop108, $pop109
	i32.or  	$push111=, $pop107, $pop110
	i32.const	$push137=, 0
	f32.load	$push112=, results+72($pop137)
	f32.const	$push113=, 0x1.68p7
	f32.ne  	$push114=, $pop112, $pop113
	i32.or  	$push115=, $pop111, $pop114
	i32.const	$push136=, 0
	f32.load	$push116=, results+76($pop136)
	f32.const	$push117=, 0x1.7cp7
	f32.ne  	$push118=, $pop116, $pop117
	i32.or  	$push119=, $pop115, $pop118
	i32.const	$push120=, 1
	i32.and 	$push121=, $pop119, $pop120
                                        # fallthrough-return: $pop121
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


	.ident	"clang version 3.9.0 "
