	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20060420-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, 0
	block
	i32.const	$push82=, 1
	i32.lt_s	$push0=, $3, $pop82
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %land.rhs.lr.ph
	i32.const	$push84=, 4
	i32.add 	$27=, $1, $pop84
	i32.const	$push83=, -1
	i32.add 	$26=, $2, $pop83
	i32.const	$7=, 0
.LBB0_2:                                # %land.rhs
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_4 Depth 2
	loop                            # label1:
	i32.add 	$push1=, $7, $0
	i32.const	$push85=, 15
	i32.and 	$push2=, $pop1, $pop85
	i32.const	$push156=, 0
	i32.eq  	$push157=, $pop2, $pop156
	br_if   	1, $pop157      # 1: down to label2
# BB#3:                                 # %for.body
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$push3=, 0($1)
	i32.const	$push94=, 2
	i32.shl 	$push93=, $7, $pop94
	tee_local	$push92=, $9=, $pop93
	i32.add 	$push4=, $pop3, $pop92
	f32.load	$25=, 0($pop4)
	copy_local	$28=, $26
	copy_local	$8=, $27
	block
	i32.const	$push91=, 2
	i32.lt_s	$push5=, $2, $pop91
	br_if   	0, $pop5        # 0: down to label3
.LBB0_4:                                # %for.body4
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label4:
	i32.load	$push6=, 0($8)
	i32.add 	$push7=, $pop6, $9
	f32.load	$push8=, 0($pop7)
	f32.add 	$25=, $25, $pop8
	i32.const	$push96=, 4
	i32.add 	$8=, $8, $pop96
	i32.const	$push95=, -1
	i32.add 	$28=, $28, $pop95
	br_if   	0, $28          # 0: up to label4
.LBB0_5:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label5:
	end_block                       # label3:
	i32.add 	$push9=, $0, $9
	f32.store	$discard=, 0($pop9), $25
	i32.const	$push97=, 1
	i32.add 	$7=, $7, $pop97
	i32.lt_s	$push10=, $7, $3
	br_if   	0, $pop10       # 0: up to label1
.LBB0_6:                                # %for.cond12.preheader
	end_loop                        # label2:
	end_block                       # label0:
	block
	i32.const	$push11=, -15
	i32.add 	$push87=, $3, $pop11
	tee_local	$push86=, $26=, $pop87
	i32.ge_s	$push12=, $7, $pop86
	br_if   	0, $pop12       # 0: down to label6
# BB#7:                                 # %for.body15.lr.ph
	i32.const	$push13=, -16
	i32.add 	$push14=, $3, $pop13
	i32.sub 	$push15=, $pop14, $7
	i32.const	$push90=, -16
	i32.and 	$push16=, $pop15, $pop90
	i32.add 	$4=, $7, $pop16
	i32.const	$push89=, 4
	i32.add 	$5=, $1, $pop89
	i32.const	$push88=, -1
	i32.add 	$6=, $2, $pop88
.LBB0_8:                                # %for.body15
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_9 Depth 2
	loop                            # label7:
	i32.load	$push17=, 0($1)
	i32.const	$push117=, 2
	i32.shl 	$push116=, $7, $pop117
	tee_local	$push115=, $27=, $pop116
	i32.add 	$push114=, $pop17, $pop115
	tee_local	$push113=, $28=, $pop114
	i32.const	$push112=, 12
	i32.add 	$push18=, $pop113, $pop112
	f32.load	$25=, 0($pop18)
	i32.const	$push111=, 8
	i32.add 	$push19=, $28, $pop111
	f32.load	$24=, 0($pop19):p2align=3
	i32.const	$push110=, 4
	i32.add 	$push20=, $28, $pop110
	f32.load	$23=, 0($pop20)
	i32.const	$push109=, 28
	i32.add 	$push21=, $28, $pop109
	f32.load	$21=, 0($pop21)
	i32.const	$push108=, 24
	i32.add 	$push22=, $28, $pop108
	f32.load	$20=, 0($pop22):p2align=3
	i32.const	$push107=, 20
	i32.add 	$push23=, $28, $pop107
	f32.load	$19=, 0($pop23)
	i32.const	$push106=, 44
	i32.add 	$push24=, $28, $pop106
	f32.load	$17=, 0($pop24)
	i32.const	$push105=, 40
	i32.add 	$push25=, $28, $pop105
	f32.load	$16=, 0($pop25):p2align=3
	i32.const	$push104=, 36
	i32.add 	$push26=, $28, $pop104
	f32.load	$15=, 0($pop26)
	f32.load	$22=, 0($28):p2align=4
	f32.load	$18=, 16($28):p2align=4
	f32.load	$14=, 32($28):p2align=4
	f32.load	$10=, 48($28):p2align=4
	i32.const	$push103=, 60
	i32.add 	$push27=, $28, $pop103
	f32.load	$13=, 0($pop27)
	i32.const	$push102=, 56
	i32.add 	$push28=, $28, $pop102
	f32.load	$12=, 0($pop28):p2align=3
	i32.const	$push101=, 52
	i32.add 	$push29=, $28, $pop101
	f32.load	$11=, 0($pop29)
	copy_local	$8=, $6
	copy_local	$9=, $5
	block
	i32.const	$push100=, 2
	i32.lt_s	$push30=, $2, $pop100
	br_if   	0, $pop30       # 0: down to label9
.LBB0_9:                                # %for.body33
                                        #   Parent Loop BB0_8 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label10:
	i32.load	$push31=, 0($9)
	i32.add 	$push133=, $pop31, $27
	tee_local	$push132=, $28=, $pop133
	f32.load	$push38=, 0($pop132):p2align=4
	f32.add 	$22=, $22, $pop38
	i32.const	$push131=, 12
	i32.add 	$push36=, $28, $pop131
	f32.load	$push37=, 0($pop36)
	f32.add 	$25=, $25, $pop37
	i32.const	$push130=, 8
	i32.add 	$push34=, $28, $pop130
	f32.load	$push35=, 0($pop34):p2align=3
	f32.add 	$24=, $24, $pop35
	i32.const	$push129=, 4
	i32.add 	$push32=, $28, $pop129
	f32.load	$push33=, 0($pop32)
	f32.add 	$23=, $23, $pop33
	f32.load	$push45=, 16($28):p2align=4
	f32.add 	$18=, $18, $pop45
	i32.const	$push128=, 28
	i32.add 	$push43=, $28, $pop128
	f32.load	$push44=, 0($pop43)
	f32.add 	$21=, $21, $pop44
	i32.const	$push127=, 24
	i32.add 	$push41=, $28, $pop127
	f32.load	$push42=, 0($pop41):p2align=3
	f32.add 	$20=, $20, $pop42
	i32.const	$push126=, 20
	i32.add 	$push39=, $28, $pop126
	f32.load	$push40=, 0($pop39)
	f32.add 	$19=, $19, $pop40
	f32.load	$push52=, 32($28):p2align=4
	f32.add 	$14=, $14, $pop52
	i32.const	$push125=, 44
	i32.add 	$push50=, $28, $pop125
	f32.load	$push51=, 0($pop50)
	f32.add 	$17=, $17, $pop51
	i32.const	$push124=, 40
	i32.add 	$push48=, $28, $pop124
	f32.load	$push49=, 0($pop48):p2align=3
	f32.add 	$16=, $16, $pop49
	i32.const	$push123=, 36
	i32.add 	$push46=, $28, $pop123
	f32.load	$push47=, 0($pop46)
	f32.add 	$15=, $15, $pop47
	f32.load	$push59=, 48($28):p2align=4
	f32.add 	$10=, $10, $pop59
	i32.const	$push122=, 60
	i32.add 	$push57=, $28, $pop122
	f32.load	$push58=, 0($pop57)
	f32.add 	$13=, $13, $pop58
	i32.const	$push121=, 56
	i32.add 	$push55=, $28, $pop121
	f32.load	$push56=, 0($pop55):p2align=3
	f32.add 	$12=, $12, $pop56
	i32.const	$push120=, 52
	i32.add 	$push53=, $28, $pop120
	f32.load	$push54=, 0($pop53)
	f32.add 	$11=, $11, $pop54
	i32.const	$push119=, 4
	i32.add 	$9=, $9, $pop119
	i32.const	$push118=, -1
	i32.add 	$8=, $8, $pop118
	br_if   	0, $8           # 0: up to label10
.LBB0_10:                               # %for.end56
                                        #   in Loop: Header=BB0_8 Depth=1
	end_loop                        # label11:
	end_block                       # label9:
	i32.add 	$push148=, $0, $27
	tee_local	$push147=, $28=, $pop148
	f32.store	$discard=, 0($pop147):p2align=4, $22
	i32.const	$push146=, 12
	i32.add 	$push60=, $28, $pop146
	f32.store	$discard=, 0($pop60), $25
	i32.const	$push145=, 8
	i32.add 	$push61=, $28, $pop145
	f32.store	$discard=, 0($pop61):p2align=3, $24
	i32.const	$push144=, 4
	i32.add 	$push62=, $28, $pop144
	f32.store	$discard=, 0($pop62), $23
	f32.store	$discard=, 16($28):p2align=4, $18
	i32.const	$push143=, 28
	i32.add 	$push63=, $28, $pop143
	f32.store	$discard=, 0($pop63), $21
	i32.const	$push142=, 24
	i32.add 	$push64=, $28, $pop142
	f32.store	$discard=, 0($pop64):p2align=3, $20
	i32.const	$push141=, 20
	i32.add 	$push65=, $28, $pop141
	f32.store	$discard=, 0($pop65), $19
	f32.store	$discard=, 32($28):p2align=4, $14
	i32.const	$push140=, 44
	i32.add 	$push66=, $28, $pop140
	f32.store	$discard=, 0($pop66), $17
	i32.const	$push139=, 40
	i32.add 	$push67=, $28, $pop139
	f32.store	$discard=, 0($pop67):p2align=3, $16
	i32.const	$push138=, 36
	i32.add 	$push68=, $28, $pop138
	f32.store	$discard=, 0($pop68), $15
	f32.store	$discard=, 48($28):p2align=4, $10
	i32.const	$push137=, 60
	i32.add 	$push69=, $28, $pop137
	f32.store	$discard=, 0($pop69), $13
	i32.const	$push136=, 56
	i32.add 	$push70=, $28, $pop136
	f32.store	$discard=, 0($pop70):p2align=3, $12
	i32.const	$push135=, 52
	i32.add 	$push71=, $28, $pop135
	f32.store	$discard=, 0($pop71), $11
	i32.const	$push134=, 16
	i32.add 	$7=, $7, $pop134
	i32.lt_s	$push72=, $7, $26
	br_if   	0, $pop72       # 0: up to label7
# BB#11:                                # %for.cond73.preheader.loopexit
	end_loop                        # label8:
	i32.const	$push73=, 16
	i32.add 	$7=, $4, $pop73
.LBB0_12:                               # %for.cond73.preheader
	end_block                       # label6:
	block
	i32.ge_s	$push74=, $7, $3
	br_if   	0, $pop74       # 0: down to label12
# BB#13:                                # %for.body75.lr.ph
	i32.load	$27=, 0($1)
	i32.const	$push99=, 4
	i32.add 	$1=, $1, $pop99
	i32.const	$push98=, -1
	i32.add 	$26=, $2, $pop98
.LBB0_14:                               # %for.body75
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_15 Depth 2
	loop                            # label13:
	i32.const	$push152=, 2
	i32.shl 	$push151=, $7, $pop152
	tee_local	$push150=, $9=, $pop151
	i32.add 	$push75=, $27, $pop150
	f32.load	$25=, 0($pop75)
	copy_local	$28=, $26
	copy_local	$8=, $1
	block
	i32.const	$push149=, 2
	i32.lt_s	$push76=, $2, $pop149
	br_if   	0, $pop76       # 0: down to label15
.LBB0_15:                               # %for.body81
                                        #   Parent Loop BB0_14 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label16:
	i32.load	$push77=, 0($8)
	i32.add 	$push78=, $pop77, $9
	f32.load	$push79=, 0($pop78)
	f32.add 	$25=, $25, $pop79
	i32.const	$push154=, 4
	i32.add 	$8=, $8, $pop154
	i32.const	$push153=, -1
	i32.add 	$28=, $28, $pop153
	br_if   	0, $28          # 0: up to label16
.LBB0_16:                               # %for.end87
                                        #   in Loop: Header=BB0_14 Depth=1
	end_loop                        # label17:
	end_block                       # label15:
	i32.add 	$push80=, $0, $9
	f32.store	$discard=, 0($pop80), $25
	i32.const	$push155=, 1
	i32.add 	$7=, $7, $pop155
	i32.ne  	$push81=, $7, $3
	br_if   	0, $pop81       # 0: up to label13
.LBB0_17:                               # %for.end91
	end_loop                        # label14:
	end_block                       # label12:
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
	.local  	f32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.sub 	$7=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$7=, 0($4), $7
	i32.const	$2=, 0
	i32.const	$push30=, 0
	i32.const	$push1=, buffer
	i32.sub 	$push2=, $pop30, $pop1
	i32.const	$push3=, 63
	i32.and 	$push29=, $pop2, $pop3
	tee_local	$push28=, $1=, $pop29
	i32.const	$push5=, buffer+128
	i32.add 	$push6=, $pop28, $pop5
	i32.store	$discard=, 12($7), $pop6
	i32.const	$push4=, buffer+64
	i32.add 	$push0=, $1, $pop4
	i32.store	$1=, 8($7), $pop0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label18:
	f32.convert_s/i32	$0=, $2
	i32.const	$push36=, 64
	i32.add 	$push11=, $1, $pop36
	f32.const	$push35=, 0x1.8p3
	f32.mul 	$push9=, $0, $pop35
	f32.add 	$push10=, $0, $pop9
	f32.store	$discard=, 0($pop11), $pop10
	f32.const	$push34=, 0x1.6p3
	f32.mul 	$push7=, $0, $pop34
	f32.add 	$push8=, $0, $pop7
	f32.store	$discard=, 0($1), $pop8
	i32.const	$push33=, 1
	i32.add 	$2=, $2, $pop33
	i32.const	$push32=, 4
	i32.add 	$1=, $1, $pop32
	i32.const	$push31=, 16
	i32.ne  	$push12=, $2, $pop31
	br_if   	0, $pop12       # 0: up to label18
# BB#2:                                 # %for.end
	end_loop                        # label19:
	i32.const	$2=, 0
	i32.const	$push40=, 0
	i32.const	$push13=, buffer
	i32.sub 	$push14=, $pop40, $pop13
	i32.const	$push15=, 63
	i32.and 	$push16=, $pop14, $pop15
	i32.const	$push39=, buffer
	i32.add 	$push38=, $pop16, $pop39
	tee_local	$push37=, $1=, $pop38
	i32.const	$push18=, 2
	i32.const	$push17=, 16
	i32.const	$6=, 8
	i32.add 	$6=, $7, $6
	call    	foo@FUNCTION, $pop37, $6, $pop18, $pop17
.LBB1_3:                                # %for.body16
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label21:
	f32.load	$push24=, 0($1)
	f32.convert_s/i32	$push47=, $2
	tee_local	$push46=, $0=, $pop47
	f32.const	$push45=, 0x1.8p3
	f32.mul 	$push22=, $pop46, $pop45
	f32.const	$push44=, 0x1.6p3
	f32.mul 	$push19=, $0, $pop44
	f32.add 	$push20=, $0, $pop19
	f32.add 	$push21=, $0, $pop20
	f32.add 	$push23=, $pop22, $pop21
	f32.ne  	$push25=, $pop24, $pop23
	br_if   	2, $pop25       # 2: down to label20
# BB#4:                                 # %for.cond13
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push43=, 1
	i32.add 	$2=, $2, $pop43
	i32.const	$push42=, 4
	i32.add 	$1=, $1, $pop42
	i32.const	$push41=, 15
	i32.le_s	$push26=, $2, $pop41
	br_if   	0, $pop26       # 0: up to label21
# BB#5:                                 # %for.end31
	end_loop                        # label22:
	i32.const	$push27=, 0
	i32.const	$5=, 16
	i32.add 	$7=, $7, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	return  	$pop27
.LBB1_6:                                # %if.then
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	buffer                  # @buffer
	.type	buffer,@object
	.section	.bss.buffer,"aw",@nobits
	.globl	buffer
	.p2align	4
buffer:
	.skip	256
	.size	buffer, 256


	.ident	"clang version 3.9.0 "
