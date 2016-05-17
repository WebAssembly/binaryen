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
                                        #     Child Loop BB0_5 Depth 2
	loop                            # label1:
	i32.add 	$push1=, $7, $0
	i32.const	$push85=, 15
	i32.and 	$push2=, $pop1, $pop85
	i32.eqz 	$push156=, $pop2
	br_if   	1, $pop156      # 1: down to label2
# BB#3:                                 # %for.body
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$push3=, 0($1)
	i32.const	$push89=, 2
	i32.shl 	$push88=, $7, $pop89
	tee_local	$push87=, $9=, $pop88
	i32.add 	$push4=, $pop3, $pop87
	f32.load	$25=, 0($pop4)
	block
	i32.const	$push86=, 2
	i32.lt_s	$push5=, $2, $pop86
	br_if   	0, $pop5        # 0: down to label3
# BB#4:                                 # %for.body4.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	copy_local	$28=, $26
	copy_local	$8=, $27
.LBB0_5:                                # %for.body4
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label4:
	i32.load	$push6=, 0($8)
	i32.add 	$push7=, $pop6, $9
	f32.load	$push8=, 0($pop7)
	f32.add 	$25=, $25, $pop8
	i32.const	$push91=, 4
	i32.add 	$8=, $8, $pop91
	i32.const	$push90=, -1
	i32.add 	$28=, $28, $pop90
	br_if   	0, $28          # 0: up to label4
.LBB0_6:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label5:
	end_block                       # label3:
	i32.add 	$push9=, $0, $9
	f32.store	$discard=, 0($pop9), $25
	i32.const	$push92=, 1
	i32.add 	$7=, $7, $pop92
	i32.lt_s	$push10=, $7, $3
	br_if   	0, $pop10       # 0: up to label1
.LBB0_7:                                # %for.cond12.preheader
	end_loop                        # label2:
	end_block                       # label0:
	block
	i32.const	$push11=, -15
	i32.add 	$push94=, $3, $pop11
	tee_local	$push93=, $26=, $pop94
	i32.ge_s	$push12=, $7, $pop93
	br_if   	0, $pop12       # 0: down to label6
# BB#8:                                 # %for.body15.lr.ph
	i32.const	$push13=, -16
	i32.add 	$push14=, $3, $pop13
	i32.sub 	$push15=, $pop14, $7
	i32.const	$push97=, -16
	i32.and 	$push16=, $pop15, $pop97
	i32.add 	$4=, $7, $pop16
	i32.const	$push96=, 4
	i32.add 	$5=, $1, $pop96
	i32.const	$push95=, -1
	i32.add 	$6=, $2, $pop95
.LBB0_9:                                # %for.body15
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_11 Depth 2
	loop                            # label7:
	i32.load	$push17=, 0($1)
	i32.const	$push115=, 2
	i32.shl 	$push114=, $7, $pop115
	tee_local	$push113=, $27=, $pop114
	i32.add 	$push112=, $pop17, $pop113
	tee_local	$push111=, $28=, $pop112
	i32.const	$push110=, 12
	i32.add 	$push18=, $pop111, $pop110
	f32.load	$25=, 0($pop18)
	i32.const	$push109=, 8
	i32.add 	$push19=, $28, $pop109
	f32.load	$24=, 0($pop19)
	i32.const	$push108=, 4
	i32.add 	$push20=, $28, $pop108
	f32.load	$23=, 0($pop20)
	i32.const	$push107=, 28
	i32.add 	$push21=, $28, $pop107
	f32.load	$21=, 0($pop21)
	i32.const	$push106=, 24
	i32.add 	$push22=, $28, $pop106
	f32.load	$20=, 0($pop22)
	i32.const	$push105=, 20
	i32.add 	$push23=, $28, $pop105
	f32.load	$19=, 0($pop23)
	i32.const	$push104=, 44
	i32.add 	$push24=, $28, $pop104
	f32.load	$17=, 0($pop24)
	i32.const	$push103=, 40
	i32.add 	$push25=, $28, $pop103
	f32.load	$16=, 0($pop25)
	i32.const	$push102=, 36
	i32.add 	$push26=, $28, $pop102
	f32.load	$15=, 0($pop26)
	f32.load	$22=, 0($28)
	f32.load	$18=, 16($28)
	f32.load	$14=, 32($28)
	f32.load	$10=, 48($28)
	i32.const	$push101=, 60
	i32.add 	$push27=, $28, $pop101
	f32.load	$13=, 0($pop27)
	i32.const	$push100=, 56
	i32.add 	$push28=, $28, $pop100
	f32.load	$12=, 0($pop28)
	i32.const	$push99=, 52
	i32.add 	$push29=, $28, $pop99
	f32.load	$11=, 0($pop29)
	block
	i32.const	$push98=, 2
	i32.lt_s	$push30=, $2, $pop98
	br_if   	0, $pop30       # 0: down to label9
# BB#10:                                # %for.body33.preheader
                                        #   in Loop: Header=BB0_9 Depth=1
	copy_local	$8=, $6
	copy_local	$9=, $5
.LBB0_11:                               # %for.body33
                                        #   Parent Loop BB0_9 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label10:
	i32.load	$push31=, 0($9)
	i32.add 	$push131=, $pop31, $27
	tee_local	$push130=, $28=, $pop131
	f32.load	$push38=, 0($pop130)
	f32.add 	$22=, $22, $pop38
	i32.const	$push129=, 12
	i32.add 	$push36=, $28, $pop129
	f32.load	$push37=, 0($pop36)
	f32.add 	$25=, $25, $pop37
	i32.const	$push128=, 8
	i32.add 	$push34=, $28, $pop128
	f32.load	$push35=, 0($pop34)
	f32.add 	$24=, $24, $pop35
	i32.const	$push127=, 4
	i32.add 	$push32=, $28, $pop127
	f32.load	$push33=, 0($pop32)
	f32.add 	$23=, $23, $pop33
	f32.load	$push45=, 16($28)
	f32.add 	$18=, $18, $pop45
	i32.const	$push126=, 28
	i32.add 	$push43=, $28, $pop126
	f32.load	$push44=, 0($pop43)
	f32.add 	$21=, $21, $pop44
	i32.const	$push125=, 24
	i32.add 	$push41=, $28, $pop125
	f32.load	$push42=, 0($pop41)
	f32.add 	$20=, $20, $pop42
	i32.const	$push124=, 20
	i32.add 	$push39=, $28, $pop124
	f32.load	$push40=, 0($pop39)
	f32.add 	$19=, $19, $pop40
	f32.load	$push52=, 32($28)
	f32.add 	$14=, $14, $pop52
	i32.const	$push123=, 44
	i32.add 	$push50=, $28, $pop123
	f32.load	$push51=, 0($pop50)
	f32.add 	$17=, $17, $pop51
	i32.const	$push122=, 40
	i32.add 	$push48=, $28, $pop122
	f32.load	$push49=, 0($pop48)
	f32.add 	$16=, $16, $pop49
	i32.const	$push121=, 36
	i32.add 	$push46=, $28, $pop121
	f32.load	$push47=, 0($pop46)
	f32.add 	$15=, $15, $pop47
	f32.load	$push59=, 48($28)
	f32.add 	$10=, $10, $pop59
	i32.const	$push120=, 60
	i32.add 	$push57=, $28, $pop120
	f32.load	$push58=, 0($pop57)
	f32.add 	$13=, $13, $pop58
	i32.const	$push119=, 56
	i32.add 	$push55=, $28, $pop119
	f32.load	$push56=, 0($pop55)
	f32.add 	$12=, $12, $pop56
	i32.const	$push118=, 52
	i32.add 	$push53=, $28, $pop118
	f32.load	$push54=, 0($pop53)
	f32.add 	$11=, $11, $pop54
	i32.const	$push117=, 4
	i32.add 	$9=, $9, $pop117
	i32.const	$push116=, -1
	i32.add 	$8=, $8, $pop116
	br_if   	0, $8           # 0: up to label10
.LBB0_12:                               # %for.end56
                                        #   in Loop: Header=BB0_9 Depth=1
	end_loop                        # label11:
	end_block                       # label9:
	i32.add 	$push146=, $0, $27
	tee_local	$push145=, $28=, $pop146
	f32.store	$discard=, 0($pop145), $22
	i32.const	$push144=, 12
	i32.add 	$push60=, $28, $pop144
	f32.store	$discard=, 0($pop60), $25
	i32.const	$push143=, 8
	i32.add 	$push61=, $28, $pop143
	f32.store	$discard=, 0($pop61), $24
	i32.const	$push142=, 4
	i32.add 	$push62=, $28, $pop142
	f32.store	$discard=, 0($pop62), $23
	f32.store	$discard=, 16($28), $18
	i32.const	$push141=, 28
	i32.add 	$push63=, $28, $pop141
	f32.store	$discard=, 0($pop63), $21
	i32.const	$push140=, 24
	i32.add 	$push64=, $28, $pop140
	f32.store	$discard=, 0($pop64), $20
	i32.const	$push139=, 20
	i32.add 	$push65=, $28, $pop139
	f32.store	$discard=, 0($pop65), $19
	f32.store	$discard=, 32($28), $14
	i32.const	$push138=, 44
	i32.add 	$push66=, $28, $pop138
	f32.store	$discard=, 0($pop66), $17
	i32.const	$push137=, 40
	i32.add 	$push67=, $28, $pop137
	f32.store	$discard=, 0($pop67), $16
	i32.const	$push136=, 36
	i32.add 	$push68=, $28, $pop136
	f32.store	$discard=, 0($pop68), $15
	f32.store	$discard=, 48($28), $10
	i32.const	$push135=, 60
	i32.add 	$push69=, $28, $pop135
	f32.store	$discard=, 0($pop69), $13
	i32.const	$push134=, 56
	i32.add 	$push70=, $28, $pop134
	f32.store	$discard=, 0($pop70), $12
	i32.const	$push133=, 52
	i32.add 	$push71=, $28, $pop133
	f32.store	$discard=, 0($pop71), $11
	i32.const	$push132=, 16
	i32.add 	$7=, $7, $pop132
	i32.lt_s	$push72=, $7, $26
	br_if   	0, $pop72       # 0: up to label7
# BB#13:                                # %for.cond73.preheader.loopexit
	end_loop                        # label8:
	i32.const	$push73=, 16
	i32.add 	$7=, $4, $pop73
.LBB0_14:                               # %for.cond73.preheader
	end_block                       # label6:
	block
	i32.ge_s	$push74=, $7, $3
	br_if   	0, $pop74       # 0: down to label12
# BB#15:                                # %for.body75.lr.ph
	i32.load	$27=, 0($1)
	i32.const	$push148=, 4
	i32.add 	$1=, $1, $pop148
	i32.const	$push147=, -1
	i32.add 	$26=, $2, $pop147
.LBB0_16:                               # %for.body75
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_18 Depth 2
	loop                            # label13:
	i32.const	$push152=, 2
	i32.shl 	$push151=, $7, $pop152
	tee_local	$push150=, $9=, $pop151
	i32.add 	$push75=, $27, $pop150
	f32.load	$25=, 0($pop75)
	block
	i32.const	$push149=, 2
	i32.lt_s	$push76=, $2, $pop149
	br_if   	0, $pop76       # 0: down to label15
# BB#17:                                # %for.body81.preheader
                                        #   in Loop: Header=BB0_16 Depth=1
	copy_local	$28=, $26
	copy_local	$8=, $1
.LBB0_18:                               # %for.body81
                                        #   Parent Loop BB0_16 Depth=1
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
.LBB0_19:                               # %for.end87
                                        #   in Loop: Header=BB0_16 Depth=1
	end_loop                        # label17:
	end_block                       # label15:
	i32.add 	$push80=, $0, $9
	f32.store	$discard=, 0($pop80), $25
	i32.const	$push155=, 1
	i32.add 	$7=, $7, $pop155
	i32.ne  	$push81=, $7, $3
	br_if   	0, $pop81       # 0: up to label13
.LBB0_20:                               # %for.end91
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
	.local  	f32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$push30=, __stack_pointer
	i32.const	$push27=, __stack_pointer
	i32.load	$push28=, 0($pop27)
	i32.const	$push29=, 16
	i32.sub 	$push36=, $pop28, $pop29
	i32.store	$push43=, 0($pop30), $pop36
	tee_local	$push42=, $3=, $pop43
	i32.const	$push41=, 0
	i32.const	$push0=, buffer
	i32.sub 	$push1=, $pop41, $pop0
	i32.const	$push2=, 63
	i32.and 	$push40=, $pop1, $pop2
	tee_local	$push39=, $2=, $pop40
	i32.const	$push4=, buffer+128
	i32.add 	$push5=, $pop39, $pop4
	i32.store	$discard=, 12($pop42), $pop5
	i32.const	$push3=, buffer+64
	i32.add 	$push38=, $2, $pop3
	tee_local	$push37=, $2=, $pop38
	i32.store	$discard=, 8($3), $pop37
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label18:
	f32.convert_s/i32	$0=, $1
	i32.const	$push49=, 64
	i32.add 	$push10=, $2, $pop49
	f32.const	$push48=, 0x1.8p3
	f32.mul 	$push8=, $0, $pop48
	f32.add 	$push9=, $0, $pop8
	f32.store	$discard=, 0($pop10), $pop9
	f32.const	$push47=, 0x1.6p3
	f32.mul 	$push6=, $0, $pop47
	f32.add 	$push7=, $0, $pop6
	f32.store	$discard=, 0($2), $pop7
	i32.const	$push46=, 1
	i32.add 	$1=, $1, $pop46
	i32.const	$push45=, 4
	i32.add 	$2=, $2, $pop45
	i32.const	$push44=, 16
	i32.ne  	$push11=, $1, $pop44
	br_if   	0, $pop11       # 0: up to label18
# BB#2:                                 # %for.end
	end_loop                        # label19:
	i32.const	$1=, 0
	i32.const	$push53=, 0
	i32.const	$push12=, buffer
	i32.sub 	$push13=, $pop53, $pop12
	i32.const	$push14=, 63
	i32.and 	$push15=, $pop13, $pop14
	i32.const	$push52=, buffer
	i32.add 	$push51=, $pop15, $pop52
	tee_local	$push50=, $2=, $pop51
	i32.const	$push34=, 8
	i32.add 	$push35=, $3, $pop34
	i32.const	$push17=, 2
	i32.const	$push16=, 16
	call    	foo@FUNCTION, $pop50, $pop35, $pop17, $pop16
.LBB1_3:                                # %for.body16
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label21:
	f32.load	$push23=, 0($2)
	f32.convert_s/i32	$push57=, $1
	tee_local	$push56=, $0=, $pop57
	f32.const	$push55=, 0x1.8p3
	f32.mul 	$push21=, $pop56, $pop55
	f32.const	$push54=, 0x1.6p3
	f32.mul 	$push18=, $0, $pop54
	f32.add 	$push19=, $0, $pop18
	f32.add 	$push20=, $0, $pop19
	f32.add 	$push22=, $pop21, $pop20
	f32.ne  	$push24=, $pop23, $pop22
	br_if   	2, $pop24       # 2: down to label20
# BB#4:                                 # %for.cond13
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push60=, 1
	i32.add 	$1=, $1, $pop60
	i32.const	$push59=, 4
	i32.add 	$2=, $2, $pop59
	i32.const	$push58=, 15
	i32.le_s	$push25=, $1, $pop58
	br_if   	0, $pop25       # 0: up to label21
# BB#5:                                 # %for.end31
	end_loop                        # label22:
	i32.const	$push33=, __stack_pointer
	i32.const	$push31=, 16
	i32.add 	$push32=, $3, $pop31
	i32.store	$discard=, 0($pop33), $pop32
	i32.const	$push26=, 0
	return  	$pop26
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
