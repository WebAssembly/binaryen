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
	i32.store	$discard=, incs($pop1), $pop3
	return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, i64, i32
# BB#0:                                 # %entry
	i32.const	$push154=, __stack_pointer
	i32.load	$push155=, 0($pop154)
	i32.const	$push156=, 524288
	i32.sub 	$62=, $pop155, $pop156
	i32.const	$push157=, __stack_pointer
	i32.store	$discard=, 0($pop157), $62
	i32.const	$push161=, 262144
	i32.add 	$push162=, $62, $pop161
	i32.const	$push53=, 0
	i32.const	$push52=, 262144
	i32.call	$discard=, memset@FUNCTION, $pop162, $pop53, $pop52
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
	i32.const	$push165=, 0
	i32.eq  	$push166=, $0, $pop165
	br_if   	0, $pop166      # 0: down to label0
# BB#1:                                 # %while.body.preheader
	i32.const	$push131=, 0
	i64.load	$push130=, incs+72($pop131)
	tee_local	$push129=, $61=, $pop130
	i64.const	$push20=, 32
	i64.shr_u	$push30=, $pop129, $pop20
	i32.wrap/i64	$push19=, $pop30
	i32.const	$push31=, 2
	i32.shl 	$1=, $pop19, $pop31
	i32.wrap/i64	$push18=, $61
	i32.const	$push128=, 2
	i32.shl 	$2=, $pop18, $pop128
	i32.const	$push127=, 0
	i64.load	$push126=, incs+64($pop127)
	tee_local	$push125=, $61=, $pop126
	i64.const	$push124=, 32
	i64.shr_u	$push29=, $pop125, $pop124
	i32.wrap/i64	$push17=, $pop29
	i32.const	$push123=, 2
	i32.shl 	$3=, $pop17, $pop123
	i32.wrap/i64	$push16=, $61
	i32.const	$push122=, 2
	i32.shl 	$4=, $pop16, $pop122
	i32.const	$push121=, 0
	i64.load	$push120=, incs+56($pop121)
	tee_local	$push119=, $61=, $pop120
	i64.const	$push118=, 32
	i64.shr_u	$push28=, $pop119, $pop118
	i32.wrap/i64	$push15=, $pop28
	i32.const	$push117=, 2
	i32.shl 	$5=, $pop15, $pop117
	i32.wrap/i64	$push14=, $61
	i32.const	$push116=, 2
	i32.shl 	$6=, $pop14, $pop116
	i32.const	$push115=, 0
	i64.load	$push114=, incs+48($pop115)
	tee_local	$push113=, $61=, $pop114
	i64.const	$push112=, 32
	i64.shr_u	$push27=, $pop113, $pop112
	i32.wrap/i64	$push13=, $pop27
	i32.const	$push111=, 2
	i32.shl 	$7=, $pop13, $pop111
	i32.wrap/i64	$push12=, $61
	i32.const	$push110=, 2
	i32.shl 	$8=, $pop12, $pop110
	i32.const	$push109=, 0
	i64.load	$push108=, incs+40($pop109)
	tee_local	$push107=, $61=, $pop108
	i64.const	$push106=, 32
	i64.shr_u	$push26=, $pop107, $pop106
	i32.wrap/i64	$push11=, $pop26
	i32.const	$push105=, 2
	i32.shl 	$9=, $pop11, $pop105
	i32.wrap/i64	$push10=, $61
	i32.const	$push104=, 2
	i32.shl 	$10=, $pop10, $pop104
	i32.const	$push103=, 0
	i64.load	$push102=, incs+32($pop103)
	tee_local	$push101=, $61=, $pop102
	i64.const	$push100=, 32
	i64.shr_u	$push25=, $pop101, $pop100
	i32.wrap/i64	$push9=, $pop25
	i32.const	$push99=, 2
	i32.shl 	$11=, $pop9, $pop99
	i32.wrap/i64	$push8=, $61
	i32.const	$push98=, 2
	i32.shl 	$12=, $pop8, $pop98
	i32.const	$push97=, 0
	i64.load	$push96=, incs+24($pop97)
	tee_local	$push95=, $61=, $pop96
	i64.const	$push94=, 32
	i64.shr_u	$push24=, $pop95, $pop94
	i32.wrap/i64	$push7=, $pop24
	i32.const	$push93=, 2
	i32.shl 	$13=, $pop7, $pop93
	i32.wrap/i64	$push6=, $61
	i32.const	$push92=, 2
	i32.shl 	$14=, $pop6, $pop92
	i32.const	$push91=, 0
	i64.load	$push90=, incs+16($pop91)
	tee_local	$push89=, $61=, $pop90
	i64.const	$push88=, 32
	i64.shr_u	$push23=, $pop89, $pop88
	i32.wrap/i64	$push5=, $pop23
	i32.const	$push87=, 2
	i32.shl 	$15=, $pop5, $pop87
	i32.wrap/i64	$push4=, $61
	i32.const	$push86=, 2
	i32.shl 	$16=, $pop4, $pop86
	i32.const	$push85=, 0
	i64.load	$push84=, incs+8($pop85)
	tee_local	$push83=, $61=, $pop84
	i64.const	$push82=, 32
	i64.shr_u	$push22=, $pop83, $pop82
	i32.wrap/i64	$push3=, $pop22
	i32.const	$push81=, 2
	i32.shl 	$17=, $pop3, $pop81
	i32.wrap/i64	$push2=, $61
	i32.const	$push80=, 2
	i32.shl 	$18=, $pop2, $pop80
	i32.const	$push79=, 0
	i64.load	$push78=, incs($pop79)
	tee_local	$push77=, $61=, $pop78
	i64.const	$push76=, 32
	i64.shr_u	$push21=, $pop77, $pop76
	i32.wrap/i64	$push1=, $pop21
	i32.const	$push75=, 2
	i32.shl 	$19=, $pop1, $pop75
	i32.wrap/i64	$push0=, $61
	i32.const	$push74=, 2
	i32.shl 	$20=, $pop0, $pop74
	f32.const	$41=, 0x0p0
	i32.const	$push73=, 0
	i32.load	$40=, ptrs+76($pop73)
	i32.const	$push72=, 0
	i32.load	$39=, ptrs+72($pop72)
	i32.const	$push71=, 0
	i32.load	$38=, ptrs+68($pop71)
	i32.const	$push70=, 0
	i32.load	$37=, ptrs+64($pop70)
	i32.const	$push69=, 0
	i32.load	$36=, ptrs+60($pop69)
	i32.const	$push68=, 0
	i32.load	$35=, ptrs+56($pop68)
	i32.const	$push67=, 0
	i32.load	$34=, ptrs+52($pop67)
	i32.const	$push66=, 0
	i32.load	$33=, ptrs+48($pop66)
	i32.const	$push65=, 0
	i32.load	$32=, ptrs+44($pop65)
	i32.const	$push64=, 0
	i32.load	$31=, ptrs+40($pop64)
	i32.const	$push63=, 0
	i32.load	$30=, ptrs+36($pop63)
	i32.const	$push62=, 0
	i32.load	$29=, ptrs+32($pop62)
	i32.const	$push61=, 0
	i32.load	$28=, ptrs+28($pop61)
	i32.const	$push60=, 0
	i32.load	$27=, ptrs+24($pop60)
	i32.const	$push59=, 0
	i32.load	$26=, ptrs+20($pop59)
	i32.const	$push58=, 0
	i32.load	$25=, ptrs+16($pop58)
	i32.const	$push57=, 0
	i32.load	$24=, ptrs+12($pop57)
	i32.const	$push56=, 0
	i32.load	$23=, ptrs+8($pop56)
	i32.const	$push55=, 0
	i32.load	$22=, ptrs+4($pop55)
	i32.const	$push54=, 0
	i32.load	$21=, ptrs($pop54)
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
.LBB1_2:                                # %while.body
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
	i32.const	$push132=, -1
	i32.add 	$0=, $0, $pop132
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
.LBB1_3:                                # %while.end
	end_loop                        # label2:
	end_block                       # label0:
	i32.const	$push153=, 0
	f32.store	$discard=, results($pop153), $60
	i32.const	$push152=, 0
	f32.store	$discard=, results+4($pop152), $59
	i32.const	$push151=, 0
	f32.store	$discard=, results+8($pop151), $58
	i32.const	$push150=, 0
	f32.store	$discard=, results+12($pop150), $57
	i32.const	$push149=, 0
	f32.store	$discard=, results+16($pop149), $56
	i32.const	$push148=, 0
	f32.store	$discard=, results+20($pop148), $55
	i32.const	$push147=, 0
	f32.store	$discard=, results+24($pop147), $54
	i32.const	$push146=, 0
	f32.store	$discard=, results+28($pop146), $53
	i32.const	$push145=, 0
	f32.store	$discard=, results+32($pop145), $52
	i32.const	$push144=, 0
	f32.store	$discard=, results+36($pop144), $51
	i32.const	$push143=, 0
	f32.store	$discard=, results+40($pop143), $50
	i32.const	$push142=, 0
	f32.store	$discard=, results+44($pop142), $49
	i32.const	$push141=, 0
	f32.store	$discard=, results+48($pop141), $48
	i32.const	$push140=, 0
	f32.store	$discard=, results+52($pop140), $47
	i32.const	$push139=, 0
	f32.store	$discard=, results+56($pop139), $46
	i32.const	$push138=, 0
	f32.store	$discard=, results+60($pop138), $45
	i32.const	$push137=, 0
	f32.store	$discard=, results+64($pop137), $44
	i32.const	$push136=, 0
	f32.store	$discard=, results+68($pop136), $43
	i32.const	$push135=, 0
	f32.store	$discard=, results+72($pop135), $42
	i32.const	$push134=, 0
	f32.store	$discard=, results+76($pop134), $41
	i32.const	$push163=, 262144
	i32.add 	$push164=, $62, $pop163
	i32.const	$push133=, 262144
	i32.call	$discard=, memcpy@FUNCTION, $62, $pop164, $pop133
	call    	bar@FUNCTION, $62
	i32.const	$push160=, __stack_pointer
	i32.const	$push158=, 524288
	i32.add 	$push159=, $62, $pop158
	i32.store	$discard=, 0($pop160), $pop159
	return
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, input
	i32.store	$1=, ptrs($pop1), $pop0
	i32.const	$push127=, 0
	i32.const	$push126=, 0
	i32.store	$push125=, incs($pop127), $pop126
	tee_local	$push124=, $2=, $pop125
	i32.const	$push2=, input+4
	i32.store	$discard=, ptrs+4($pop124), $pop2
	i32.const	$push4=, input+8
	i32.store	$discard=, ptrs+8($2), $pop4
	i32.const	$push5=, input+12
	i32.store	$discard=, ptrs+12($2), $pop5
	i32.const	$push6=, 3
	i32.store	$discard=, incs+12($2), $pop6
	i32.const	$push7=, input+16
	i32.store	$discard=, ptrs+16($2), $pop7
	i32.const	$push9=, input+20
	i32.store	$discard=, ptrs+20($2), $pop9
	i32.const	$push10=, 5
	i32.store	$discard=, incs+20($2), $pop10
	i32.const	$push11=, input+24
	i32.store	$discard=, ptrs+24($2), $pop11
	i32.const	$push12=, 6
	i32.store	$discard=, incs+24($2), $pop12
	i32.const	$push13=, input+28
	i32.store	$discard=, ptrs+28($2), $pop13
	i32.const	$push14=, 7
	i32.store	$discard=, incs+28($2), $pop14
	i32.const	$push15=, input+32
	i32.store	$discard=, ptrs+32($2), $pop15
	i32.const	$push16=, 8
	i32.store	$discard=, incs+32($2), $pop16
	i32.const	$push17=, input+36
	i32.store	$discard=, ptrs+36($2), $pop17
	i32.const	$push18=, 9
	i32.store	$discard=, incs+36($2), $pop18
	i32.const	$push19=, input+40
	i32.store	$discard=, ptrs+40($2), $pop19
	i32.const	$push20=, 10
	i32.store	$discard=, incs+40($2), $pop20
	i32.const	$push21=, input+44
	i32.store	$discard=, ptrs+44($2), $pop21
	i32.const	$push22=, 11
	i32.store	$discard=, incs+44($2), $pop22
	i32.const	$push23=, input+48
	i32.store	$discard=, ptrs+48($2), $pop23
	i32.const	$push24=, 12
	i32.store	$discard=, incs+48($2), $pop24
	i32.const	$push25=, input+52
	i32.store	$discard=, ptrs+52($2), $pop25
	i32.const	$push26=, 13
	i32.store	$discard=, incs+52($2), $pop26
	i32.const	$push27=, input+56
	i32.store	$discard=, ptrs+56($2), $pop27
	i32.const	$push28=, 14
	i32.store	$discard=, incs+56($2), $pop28
	i32.const	$push29=, input+60
	i32.store	$discard=, ptrs+60($2), $pop29
	i32.const	$push30=, 15
	i32.store	$discard=, incs+60($2), $pop30
	i32.const	$push31=, input+64
	i32.store	$discard=, ptrs+64($2), $pop31
	i32.const	$push32=, 16
	i32.store	$discard=, incs+64($2), $pop32
	i32.const	$push33=, input+68
	i32.store	$discard=, ptrs+68($2), $pop33
	i32.const	$push34=, 17
	i32.store	$discard=, incs+68($2), $pop34
	i32.const	$push35=, input+72
	i32.store	$discard=, ptrs+72($2), $pop35
	i32.const	$push36=, 18
	i32.store	$discard=, incs+72($2), $pop36
	i32.const	$push37=, input+76
	i32.store	$discard=, ptrs+76($2), $pop37
	i32.const	$push38=, 19
	i32.store	$discard=, incs+76($2), $pop38
	i64.const	$push3=, 8589934593
	i64.store	$discard=, incs+4($2):p2align=2, $pop3
	i32.const	$push8=, 4
	i32.store	$0=, incs+16($2), $pop8
.LBB2_1:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	f32.convert_s/i32	$push39=, $2
	f32.store	$discard=, 0($1), $pop39
	i32.const	$push129=, 1
	i32.add 	$2=, $2, $pop129
	i32.add 	$1=, $1, $0
	i32.const	$push128=, 80
	i32.ne  	$push40=, $2, $pop128
	br_if   	0, $pop40       # 0: up to label3
# BB#2:                                 # %for.end8
	end_loop                        # label4:
	i32.const	$push41=, 4
	call    	foo@FUNCTION, $pop41
	i32.const	$push42=, 0
	f32.load	$push43=, results($pop42)
	f32.const	$push44=, 0x0p0
	f32.ne  	$push45=, $pop43, $pop44
	i32.const	$push148=, 0
	f32.load	$push46=, results+4($pop148)
	f32.const	$push47=, 0x1.4p3
	f32.ne  	$push48=, $pop46, $pop47
	i32.or  	$push49=, $pop45, $pop48
	i32.const	$push147=, 0
	f32.load	$push50=, results+8($pop147)
	f32.const	$push51=, 0x1.4p4
	f32.ne  	$push52=, $pop50, $pop51
	i32.or  	$push53=, $pop49, $pop52
	i32.const	$push146=, 0
	f32.load	$push54=, results+12($pop146)
	f32.const	$push55=, 0x1.ep4
	f32.ne  	$push56=, $pop54, $pop55
	i32.or  	$push57=, $pop53, $pop56
	i32.const	$push145=, 0
	f32.load	$push58=, results+16($pop145)
	f32.const	$push59=, 0x1.4p5
	f32.ne  	$push60=, $pop58, $pop59
	i32.or  	$push61=, $pop57, $pop60
	i32.const	$push144=, 0
	f32.load	$push62=, results+20($pop144)
	f32.const	$push63=, 0x1.9p5
	f32.ne  	$push64=, $pop62, $pop63
	i32.or  	$push65=, $pop61, $pop64
	i32.const	$push143=, 0
	f32.load	$push66=, results+24($pop143)
	f32.const	$push67=, 0x1.ep5
	f32.ne  	$push68=, $pop66, $pop67
	i32.or  	$push69=, $pop65, $pop68
	i32.const	$push142=, 0
	f32.load	$push70=, results+28($pop142)
	f32.const	$push71=, 0x1.18p6
	f32.ne  	$push72=, $pop70, $pop71
	i32.or  	$push73=, $pop69, $pop72
	i32.const	$push141=, 0
	f32.load	$push74=, results+32($pop141)
	f32.const	$push75=, 0x1.4p6
	f32.ne  	$push76=, $pop74, $pop75
	i32.or  	$push77=, $pop73, $pop76
	i32.const	$push140=, 0
	f32.load	$push78=, results+36($pop140)
	f32.const	$push79=, 0x1.68p6
	f32.ne  	$push80=, $pop78, $pop79
	i32.or  	$push81=, $pop77, $pop80
	i32.const	$push139=, 0
	f32.load	$push82=, results+40($pop139)
	f32.const	$push83=, 0x1.9p6
	f32.ne  	$push84=, $pop82, $pop83
	i32.or  	$push85=, $pop81, $pop84
	i32.const	$push138=, 0
	f32.load	$push86=, results+44($pop138)
	f32.const	$push87=, 0x1.b8p6
	f32.ne  	$push88=, $pop86, $pop87
	i32.or  	$push89=, $pop85, $pop88
	i32.const	$push137=, 0
	f32.load	$push90=, results+48($pop137)
	f32.const	$push91=, 0x1.ep6
	f32.ne  	$push92=, $pop90, $pop91
	i32.or  	$push93=, $pop89, $pop92
	i32.const	$push136=, 0
	f32.load	$push94=, results+52($pop136)
	f32.const	$push95=, 0x1.04p7
	f32.ne  	$push96=, $pop94, $pop95
	i32.or  	$push97=, $pop93, $pop96
	i32.const	$push135=, 0
	f32.load	$push98=, results+56($pop135)
	f32.const	$push99=, 0x1.18p7
	f32.ne  	$push100=, $pop98, $pop99
	i32.or  	$push101=, $pop97, $pop100
	i32.const	$push134=, 0
	f32.load	$push102=, results+60($pop134)
	f32.const	$push103=, 0x1.2cp7
	f32.ne  	$push104=, $pop102, $pop103
	i32.or  	$push105=, $pop101, $pop104
	i32.const	$push133=, 0
	f32.load	$push106=, results+64($pop133)
	f32.const	$push107=, 0x1.4p7
	f32.ne  	$push108=, $pop106, $pop107
	i32.or  	$push109=, $pop105, $pop108
	i32.const	$push132=, 0
	f32.load	$push110=, results+68($pop132)
	f32.const	$push111=, 0x1.54p7
	f32.ne  	$push112=, $pop110, $pop111
	i32.or  	$push113=, $pop109, $pop112
	i32.const	$push131=, 0
	f32.load	$push114=, results+72($pop131)
	f32.const	$push115=, 0x1.68p7
	f32.ne  	$push116=, $pop114, $pop115
	i32.or  	$push117=, $pop113, $pop116
	i32.const	$push130=, 0
	f32.load	$push118=, results+76($pop130)
	f32.const	$push119=, 0x1.7cp7
	f32.ne  	$push120=, $pop118, $pop119
	i32.or  	$push121=, $pop117, $pop120
	i32.const	$push122=, 1
	i32.and 	$push123=, $pop121, $pop122
	return  	$pop123
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
