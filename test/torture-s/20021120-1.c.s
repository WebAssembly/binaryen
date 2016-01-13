	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021120-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64, f64
# BB#0:                                 # %entry
	i32.const	$1=, 0
	f64.load	$130=, gd($1)
	f64.load	$131=, gd+8($1)
	f64.load	$132=, gd+16($1)
	f64.load	$133=, gd+24($1)
	f64.load	$134=, gd+32($1)
	f64.load	$135=, gd+40($1)
	f64.load	$136=, gd+48($1)
	f64.load	$137=, gd+56($1)
	f64.load	$138=, gd+64($1)
	f64.load	$139=, gd+72($1)
	f64.load	$140=, gd+80($1)
	f64.load	$141=, gd+88($1)
	f64.load	$142=, gd+96($1)
	f64.load	$143=, gd+104($1)
	f64.load	$144=, gd+112($1)
	f64.load	$145=, gd+120($1)
	f64.load	$146=, gd+128($1)
	f64.load	$147=, gd+136($1)
	f64.load	$148=, gd+144($1)
	f64.load	$149=, gd+152($1)
	f64.load	$150=, gd+160($1)
	f64.load	$151=, gd+168($1)
	f64.load	$152=, gd+176($1)
	f64.load	$153=, gd+184($1)
	f64.load	$154=, gd+192($1)
	f64.load	$155=, gd+200($1)
	f64.load	$156=, gd+208($1)
	f64.load	$157=, gd+216($1)
	f64.load	$158=, gd+224($1)
	f64.load	$159=, gd+232($1)
	f64.load	$160=, gd+240($1)
	f64.load	$161=, gd+248($1)
	block
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	f32.load	$2=, gf($1)
	f32.load	$3=, gf+4($1)
	f32.load	$4=, gf+8($1)
	f32.load	$5=, gf+12($1)
	f32.load	$6=, gf+16($1)
	f32.load	$7=, gf+20($1)
	f32.load	$8=, gf+24($1)
	f32.load	$9=, gf+28($1)
	f32.load	$10=, gf+32($1)
	f32.load	$11=, gf+36($1)
	f32.load	$12=, gf+40($1)
	f32.load	$13=, gf+44($1)
	f32.load	$14=, gf+48($1)
	f32.load	$15=, gf+52($1)
	f32.load	$16=, gf+56($1)
	f32.load	$17=, gf+60($1)
	f32.load	$18=, gf+64($1)
	f32.load	$19=, gf+68($1)
	f32.load	$20=, gf+72($1)
	f32.load	$21=, gf+76($1)
	f32.load	$22=, gf+80($1)
	f32.load	$23=, gf+84($1)
	f32.load	$24=, gf+88($1)
	f32.load	$25=, gf+92($1)
	f32.load	$26=, gf+96($1)
	f32.load	$27=, gf+100($1)
	f32.load	$28=, gf+104($1)
	f32.load	$29=, gf+108($1)
	f32.load	$30=, gf+112($1)
	f32.load	$31=, gf+116($1)
	f32.load	$32=, gf+120($1)
	f32.load	$33=, gf+124($1)
	f64.load	$34=, gd($1)
	f64.load	$35=, gd+8($1)
	f64.load	$36=, gd+16($1)
	f64.load	$37=, gd+24($1)
	f64.load	$38=, gd+32($1)
	f64.load	$39=, gd+40($1)
	f64.load	$40=, gd+48($1)
	f64.load	$41=, gd+56($1)
	f64.load	$42=, gd+64($1)
	f64.load	$43=, gd+72($1)
	f64.load	$44=, gd+80($1)
	f64.load	$45=, gd+88($1)
	f64.load	$46=, gd+96($1)
	f64.load	$47=, gd+104($1)
	f64.load	$48=, gd+112($1)
	f64.load	$49=, gd+120($1)
	f64.load	$50=, gd+128($1)
	f64.load	$51=, gd+136($1)
	f64.load	$52=, gd+144($1)
	f64.load	$53=, gd+152($1)
	f64.load	$54=, gd+160($1)
	f64.load	$55=, gd+168($1)
	f64.load	$56=, gd+176($1)
	f64.load	$57=, gd+184($1)
	f64.load	$58=, gd+192($1)
	f64.load	$59=, gd+200($1)
	f64.load	$60=, gd+208($1)
	f64.load	$61=, gd+216($1)
	f64.load	$62=, gd+224($1)
	f64.load	$63=, gd+232($1)
	f64.load	$64=, gd+240($1)
	f64.load	$65=, gd+248($1)
	f64.load	$66=, gd($1)
	f64.load	$67=, gd+8($1)
	f64.load	$68=, gd+16($1)
	f64.load	$69=, gd+24($1)
	f64.load	$70=, gd+32($1)
	f64.load	$71=, gd+40($1)
	f64.load	$72=, gd+48($1)
	f64.load	$73=, gd+56($1)
	f64.load	$74=, gd+64($1)
	f64.load	$75=, gd+72($1)
	f64.load	$76=, gd+80($1)
	f64.load	$77=, gd+88($1)
	f64.load	$78=, gd+96($1)
	f64.load	$79=, gd+104($1)
	f64.load	$80=, gd+112($1)
	f64.load	$81=, gd+120($1)
	f64.load	$82=, gd+128($1)
	f64.load	$83=, gd+136($1)
	f64.load	$84=, gd+144($1)
	f64.load	$85=, gd+152($1)
	f64.load	$86=, gd+160($1)
	f64.load	$87=, gd+168($1)
	f64.load	$88=, gd+176($1)
	f64.load	$89=, gd+184($1)
	f64.load	$90=, gd+192($1)
	f64.load	$91=, gd+200($1)
	f64.load	$92=, gd+208($1)
	f64.load	$93=, gd+216($1)
	f64.load	$94=, gd+224($1)
	f64.load	$95=, gd+232($1)
	f64.load	$96=, gd+240($1)
	f64.load	$97=, gd+248($1)
	f64.load	$98=, gd($1)
	f64.load	$99=, gd+8($1)
	f64.load	$100=, gd+16($1)
	f64.load	$101=, gd+24($1)
	f64.load	$102=, gd+32($1)
	f64.load	$103=, gd+40($1)
	f64.load	$104=, gd+48($1)
	f64.load	$105=, gd+56($1)
	f64.load	$106=, gd+64($1)
	f64.load	$107=, gd+72($1)
	f64.load	$108=, gd+80($1)
	f64.load	$109=, gd+88($1)
	f64.load	$110=, gd+96($1)
	f64.load	$111=, gd+104($1)
	f64.load	$112=, gd+112($1)
	f64.load	$113=, gd+120($1)
	f64.load	$114=, gd+128($1)
	f64.load	$115=, gd+136($1)
	f64.load	$116=, gd+144($1)
	f64.load	$117=, gd+152($1)
	f64.load	$118=, gd+160($1)
	f64.load	$119=, gd+168($1)
	f64.load	$120=, gd+176($1)
	f64.load	$121=, gd+184($1)
	f64.load	$122=, gd+192($1)
	f64.load	$123=, gd+200($1)
	f64.load	$124=, gd+208($1)
	f64.load	$125=, gd+216($1)
	f64.load	$126=, gd+224($1)
	f64.load	$127=, gd+232($1)
	f64.load	$128=, gd+240($1)
	f64.load	$129=, gd+248($1)
	f32.store	$discard=, gf($1), $2
	f32.store	$discard=, gf+4($1), $3
	f32.store	$discard=, gf+8($1), $4
	f32.store	$discard=, gf+12($1), $5
	f32.store	$discard=, gf+16($1), $6
	f32.store	$discard=, gf+20($1), $7
	f32.store	$discard=, gf+24($1), $8
	f32.store	$discard=, gf+28($1), $9
	f32.store	$discard=, gf+32($1), $10
	f32.store	$discard=, gf+36($1), $11
	f32.store	$discard=, gf+40($1), $12
	f32.store	$discard=, gf+44($1), $13
	f32.store	$discard=, gf+48($1), $14
	f32.store	$discard=, gf+52($1), $15
	f32.store	$discard=, gf+56($1), $16
	f32.store	$discard=, gf+60($1), $17
	f32.store	$discard=, gf+64($1), $18
	f32.store	$discard=, gf+68($1), $19
	f32.store	$discard=, gf+72($1), $20
	f32.store	$discard=, gf+76($1), $21
	f32.store	$discard=, gf+80($1), $22
	f32.store	$discard=, gf+84($1), $23
	f32.store	$discard=, gf+88($1), $24
	f32.store	$discard=, gf+92($1), $25
	f32.store	$discard=, gf+96($1), $26
	f32.store	$discard=, gf+100($1), $27
	f32.store	$discard=, gf+104($1), $28
	f32.store	$discard=, gf+108($1), $29
	f32.store	$discard=, gf+112($1), $30
	f32.store	$discard=, gf+116($1), $31
	f32.store	$discard=, gf+120($1), $32
	f64.add 	$push2=, $130, $34
	f64.add 	$push34=, $pop2, $66
	f64.add 	$130=, $pop34, $98
	f64.add 	$push3=, $131, $35
	f64.add 	$push35=, $pop3, $67
	f64.add 	$131=, $pop35, $99
	f64.add 	$push4=, $132, $36
	f64.add 	$push36=, $pop4, $68
	f64.add 	$132=, $pop36, $100
	f64.add 	$push5=, $133, $37
	f64.add 	$push37=, $pop5, $69
	f64.add 	$133=, $pop37, $101
	f64.add 	$push6=, $134, $38
	f64.add 	$push38=, $pop6, $70
	f64.add 	$134=, $pop38, $102
	f64.add 	$push7=, $135, $39
	f64.add 	$push39=, $pop7, $71
	f64.add 	$135=, $pop39, $103
	f64.add 	$push8=, $136, $40
	f64.add 	$push40=, $pop8, $72
	f64.add 	$136=, $pop40, $104
	f64.add 	$push9=, $137, $41
	f64.add 	$push41=, $pop9, $73
	f64.add 	$137=, $pop41, $105
	f64.add 	$push10=, $138, $42
	f64.add 	$push42=, $pop10, $74
	f64.add 	$138=, $pop42, $106
	f64.add 	$push11=, $139, $43
	f64.add 	$push43=, $pop11, $75
	f64.add 	$139=, $pop43, $107
	f64.add 	$push12=, $140, $44
	f64.add 	$push44=, $pop12, $76
	f64.add 	$140=, $pop44, $108
	f64.add 	$push13=, $141, $45
	f64.add 	$push45=, $pop13, $77
	f64.add 	$141=, $pop45, $109
	f64.add 	$push14=, $142, $46
	f64.add 	$push46=, $pop14, $78
	f64.add 	$142=, $pop46, $110
	f64.add 	$push15=, $143, $47
	f64.add 	$push47=, $pop15, $79
	f64.add 	$143=, $pop47, $111
	f64.add 	$push16=, $144, $48
	f64.add 	$push48=, $pop16, $80
	f64.add 	$144=, $pop48, $112
	f64.add 	$push17=, $145, $49
	f64.add 	$push49=, $pop17, $81
	f64.add 	$145=, $pop49, $113
	f64.add 	$push18=, $146, $50
	f64.add 	$push50=, $pop18, $82
	f64.add 	$146=, $pop50, $114
	f64.add 	$push19=, $147, $51
	f64.add 	$push51=, $pop19, $83
	f64.add 	$147=, $pop51, $115
	f64.add 	$push20=, $148, $52
	f64.add 	$push52=, $pop20, $84
	f64.add 	$148=, $pop52, $116
	f64.add 	$push21=, $149, $53
	f64.add 	$push53=, $pop21, $85
	f64.add 	$149=, $pop53, $117
	f64.add 	$push22=, $150, $54
	f64.add 	$push54=, $pop22, $86
	f64.add 	$150=, $pop54, $118
	f64.add 	$push23=, $151, $55
	f64.add 	$push55=, $pop23, $87
	f64.add 	$151=, $pop55, $119
	f64.add 	$push24=, $152, $56
	f64.add 	$push56=, $pop24, $88
	f64.add 	$152=, $pop56, $120
	f64.add 	$push25=, $153, $57
	f64.add 	$push57=, $pop25, $89
	f64.add 	$153=, $pop57, $121
	f64.add 	$push26=, $154, $58
	f64.add 	$push58=, $pop26, $90
	f64.add 	$154=, $pop58, $122
	f64.add 	$push27=, $155, $59
	f64.add 	$push59=, $pop27, $91
	f64.add 	$155=, $pop59, $123
	f64.add 	$push28=, $156, $60
	f64.add 	$push60=, $pop28, $92
	f64.add 	$156=, $pop60, $124
	f64.add 	$push29=, $157, $61
	f64.add 	$push61=, $pop29, $93
	f64.add 	$157=, $pop61, $125
	f64.add 	$push30=, $158, $62
	f64.add 	$push62=, $pop30, $94
	f64.add 	$158=, $pop62, $126
	f64.add 	$push31=, $159, $63
	f64.add 	$push63=, $pop31, $95
	f64.add 	$159=, $pop63, $127
	f64.add 	$push32=, $160, $64
	f64.add 	$push64=, $pop32, $96
	f64.add 	$160=, $pop64, $128
	f64.add 	$push33=, $161, $65
	f64.add 	$push65=, $pop33, $97
	f64.add 	$161=, $pop65, $129
	i32.const	$push66=, -1
	i32.add 	$0=, $0, $pop66
	f32.store	$discard=, gf+124($1), $33
	br_if   	$0, 0           # 0: up to label1
.LBB0_2:                                # %for.end
	end_loop                        # label2:
	end_block                       # label0:
	f64.store	$discard=, gd($1), $130
	f64.store	$discard=, gd+8($1), $131
	f64.store	$discard=, gd+16($1), $132
	f64.store	$discard=, gd+24($1), $133
	f64.store	$discard=, gd+32($1), $134
	f64.store	$discard=, gd+40($1), $135
	f64.store	$discard=, gd+48($1), $136
	f64.store	$discard=, gd+56($1), $137
	f64.store	$discard=, gd+64($1), $138
	f64.store	$discard=, gd+72($1), $139
	f64.store	$discard=, gd+80($1), $140
	f64.store	$discard=, gd+88($1), $141
	f64.store	$discard=, gd+96($1), $142
	f64.store	$discard=, gd+104($1), $143
	f64.store	$discard=, gd+112($1), $144
	f64.store	$discard=, gd+120($1), $145
	f64.store	$discard=, gd+128($1), $146
	f64.store	$discard=, gd+136($1), $147
	f64.store	$discard=, gd+144($1), $148
	f64.store	$discard=, gd+152($1), $149
	f64.store	$discard=, gd+160($1), $150
	f64.store	$discard=, gd+168($1), $151
	f64.store	$discard=, gd+176($1), $152
	f64.store	$discard=, gd+184($1), $153
	f64.store	$discard=, gd+192($1), $154
	f64.store	$discard=, gd+200($1), $155
	f64.store	$discard=, gd+208($1), $156
	f64.store	$discard=, gd+216($1), $157
	f64.store	$discard=, gd+224($1), $158
	f64.store	$discard=, gd+232($1), $159
	f64.store	$discard=, gd+240($1), $160
	f64.store	$discard=, gd+248($1), $161
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, f64, i32, i32, i32
# BB#0:                                 # %entry
	f64.const	$3=, 0x0p0
	i32.const	$4=, 0
	i32.const	$6=, gd
	i32.const	$5=, gf
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label3:
	f64.store	$push0=, 0($6), $3
	f64.const	$push2=, 0x1p0
	f64.add 	$3=, $pop0, $pop2
	f32.convert_s/i32	$push1=, $4
	f32.store	$discard=, 0($5), $pop1
	i32.const	$0=, 1
	i32.add 	$4=, $4, $0
	i32.const	$1=, 8
	i32.add 	$6=, $6, $1
	i32.const	$2=, 4
	i32.add 	$5=, $5, $2
	i32.const	$push3=, 32
	i32.ne  	$push4=, $4, $pop3
	br_if   	$pop4, 0        # 0: up to label3
# BB#2:                                 # %for.end
	end_loop                        # label4:
	call    	foo@FUNCTION, $0
	i32.const	$4=, 0
	i32.const	$5=, gd
	copy_local	$6=, $4
.LBB1_3:                                # %for.body6
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label6:
	f64.load	$push5=, 0($5)
	f64.convert_s/i32	$push6=, $4
	f64.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, 2        # 2: down to label5
# BB#4:                                 # %lor.lhs.false
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push8=, gf
	i32.add 	$push9=, $pop8, $4
	f32.load	$push10=, 0($pop9)
	f32.convert_s/i32	$push11=, $6
	f32.ne  	$push12=, $pop10, $pop11
	br_if   	$pop12, 2       # 2: down to label5
# BB#5:                                 # %for.cond3
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.add 	$6=, $6, $0
	i32.add 	$5=, $5, $1
	i32.add 	$4=, $4, $2
	i32.const	$push13=, 31
	i32.le_s	$push14=, $6, $pop13
	br_if   	$pop14, 0       # 0: up to label6
# BB#6:                                 # %for.end17
	end_loop                        # label7:
	i32.const	$push15=, 0
	call    	exit@FUNCTION, $pop15
	unreachable
.LBB1_7:                                # %if.then
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	gd                      # @gd
	.type	gd,@object
	.section	.bss.gd,"aw",@nobits
	.globl	gd
	.align	4
gd:
	.skip	256
	.size	gd, 256

	.hidden	gf                      # @gf
	.type	gf,@object
	.section	.bss.gf,"aw",@nobits
	.globl	gf
	.align	4
gf:
	.skip	128
	.size	gf, 128


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
