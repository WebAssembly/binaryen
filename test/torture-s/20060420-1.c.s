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
	i32.const	$push89=, 1
	i32.lt_s	$push1=, $3, $pop89
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %land.rhs.lr.ph
	i32.const	$push91=, 4
	i32.add 	$27=, $1, $pop91
	i32.const	$push90=, -1
	i32.add 	$26=, $2, $pop90
	i32.const	$7=, 0
.LBB0_2:                                # %land.rhs
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_4 Depth 2
	loop                            # label1:
	i32.add 	$push2=, $7, $0
	i32.const	$push92=, 15
	i32.and 	$push3=, $pop2, $pop92
	i32.const	$push156=, 0
	i32.eq  	$push157=, $pop3, $pop156
	br_if   	$pop157, 1      # 1: down to label2
# BB#3:                                 # %for.body
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$push4=, 0($1)
	i32.const	$push99=, 2
	i32.shl 	$push5=, $7, $pop99
	tee_local	$push98=, $9=, $pop5
	i32.add 	$push6=, $pop4, $pop98
	f32.load	$25=, 0($pop6)
	copy_local	$28=, $26
	copy_local	$8=, $27
	block
	i32.const	$push97=, 2
	i32.lt_s	$push7=, $2, $pop97
	br_if   	$pop7, 0        # 0: down to label3
.LBB0_4:                                # %for.body4
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label4:
	i32.load	$push8=, 0($8)
	i32.add 	$push9=, $pop8, $9
	f32.load	$push10=, 0($pop9)
	f32.add 	$25=, $25, $pop10
	i32.const	$push101=, 4
	i32.add 	$8=, $8, $pop101
	i32.const	$push100=, -1
	i32.add 	$28=, $28, $pop100
	br_if   	$28, 0          # 0: up to label4
.LBB0_5:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label5:
	end_block                       # label3:
	i32.add 	$push11=, $0, $9
	f32.store	$discard=, 0($pop11), $25
	i32.const	$push102=, 1
	i32.add 	$7=, $7, $pop102
	i32.lt_s	$push12=, $7, $3
	br_if   	$pop12, 0       # 0: up to label1
.LBB0_6:                                # %for.cond12.preheader
	end_loop                        # label2:
	end_block                       # label0:
	block
	i32.const	$push13=, -15
	i32.add 	$push0=, $3, $pop13
	tee_local	$push93=, $26=, $pop0
	i32.ge_s	$push14=, $7, $pop93
	br_if   	$pop14, 0       # 0: down to label6
# BB#7:                                 # %for.body15.lr.ph
	i32.const	$push15=, -16
	i32.add 	$push16=, $3, $pop15
	i32.sub 	$push17=, $pop16, $7
	i32.const	$push96=, -16
	i32.and 	$push18=, $pop17, $pop96
	i32.add 	$4=, $7, $pop18
	i32.const	$push95=, 4
	i32.add 	$5=, $1, $pop95
	i32.const	$push94=, -1
	i32.add 	$6=, $2, $pop94
.LBB0_8:                                # %for.body15
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_9 Depth 2
	loop                            # label7:
	i32.load	$push19=, 0($1)
	i32.const	$push120=, 2
	i32.shl 	$push20=, $7, $pop120
	tee_local	$push119=, $27=, $pop20
	i32.add 	$push21=, $pop19, $pop119
	tee_local	$push118=, $28=, $pop21
	i32.const	$push117=, 12
	i32.add 	$push22=, $pop118, $pop117
	f32.load	$25=, 0($pop22)
	i32.const	$push116=, 8
	i32.add 	$push23=, $28, $pop116
	f32.load	$24=, 0($pop23):p2align=3
	i32.const	$push115=, 4
	i32.add 	$push24=, $28, $pop115
	f32.load	$23=, 0($pop24)
	i32.const	$push114=, 28
	i32.add 	$push25=, $28, $pop114
	f32.load	$21=, 0($pop25)
	i32.const	$push113=, 24
	i32.add 	$push26=, $28, $pop113
	f32.load	$20=, 0($pop26):p2align=3
	i32.const	$push112=, 20
	i32.add 	$push27=, $28, $pop112
	f32.load	$19=, 0($pop27)
	i32.const	$push111=, 44
	i32.add 	$push28=, $28, $pop111
	f32.load	$17=, 0($pop28)
	i32.const	$push110=, 40
	i32.add 	$push29=, $28, $pop110
	f32.load	$16=, 0($pop29):p2align=3
	i32.const	$push109=, 36
	i32.add 	$push30=, $28, $pop109
	f32.load	$15=, 0($pop30)
	f32.load	$22=, 0($28):p2align=4
	f32.load	$18=, 16($28):p2align=4
	f32.load	$14=, 32($28):p2align=4
	f32.load	$10=, 48($28):p2align=4
	i32.const	$push108=, 60
	i32.add 	$push31=, $28, $pop108
	f32.load	$13=, 0($pop31)
	i32.const	$push107=, 56
	i32.add 	$push32=, $28, $pop107
	f32.load	$12=, 0($pop32):p2align=3
	i32.const	$push106=, 52
	i32.add 	$push33=, $28, $pop106
	f32.load	$11=, 0($pop33)
	copy_local	$8=, $6
	copy_local	$9=, $5
	block
	i32.const	$push105=, 2
	i32.lt_s	$push34=, $2, $pop105
	br_if   	$pop34, 0       # 0: down to label9
.LBB0_9:                                # %for.body33
                                        #   Parent Loop BB0_8 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label10:
	i32.load	$push35=, 0($9)
	i32.add 	$push36=, $pop35, $27
	tee_local	$push135=, $28=, $pop36
	f32.load	$push43=, 0($pop135):p2align=4
	f32.add 	$22=, $22, $pop43
	i32.const	$push134=, 12
	i32.add 	$push41=, $28, $pop134
	f32.load	$push42=, 0($pop41)
	f32.add 	$25=, $25, $pop42
	i32.const	$push133=, 8
	i32.add 	$push39=, $28, $pop133
	f32.load	$push40=, 0($pop39):p2align=3
	f32.add 	$24=, $24, $pop40
	i32.const	$push132=, 4
	i32.add 	$push37=, $28, $pop132
	f32.load	$push38=, 0($pop37)
	f32.add 	$23=, $23, $pop38
	f32.load	$push50=, 16($28):p2align=4
	f32.add 	$18=, $18, $pop50
	i32.const	$push131=, 28
	i32.add 	$push48=, $28, $pop131
	f32.load	$push49=, 0($pop48)
	f32.add 	$21=, $21, $pop49
	i32.const	$push130=, 24
	i32.add 	$push46=, $28, $pop130
	f32.load	$push47=, 0($pop46):p2align=3
	f32.add 	$20=, $20, $pop47
	i32.const	$push129=, 20
	i32.add 	$push44=, $28, $pop129
	f32.load	$push45=, 0($pop44)
	f32.add 	$19=, $19, $pop45
	f32.load	$push57=, 32($28):p2align=4
	f32.add 	$14=, $14, $pop57
	i32.const	$push128=, 44
	i32.add 	$push55=, $28, $pop128
	f32.load	$push56=, 0($pop55)
	f32.add 	$17=, $17, $pop56
	i32.const	$push127=, 40
	i32.add 	$push53=, $28, $pop127
	f32.load	$push54=, 0($pop53):p2align=3
	f32.add 	$16=, $16, $pop54
	i32.const	$push126=, 36
	i32.add 	$push51=, $28, $pop126
	f32.load	$push52=, 0($pop51)
	f32.add 	$15=, $15, $pop52
	f32.load	$push64=, 48($28):p2align=4
	f32.add 	$10=, $10, $pop64
	i32.const	$push125=, 60
	i32.add 	$push62=, $28, $pop125
	f32.load	$push63=, 0($pop62)
	f32.add 	$13=, $13, $pop63
	i32.const	$push124=, 56
	i32.add 	$push60=, $28, $pop124
	f32.load	$push61=, 0($pop60):p2align=3
	f32.add 	$12=, $12, $pop61
	i32.const	$push123=, 52
	i32.add 	$push58=, $28, $pop123
	f32.load	$push59=, 0($pop58)
	f32.add 	$11=, $11, $pop59
	i32.const	$push122=, 4
	i32.add 	$9=, $9, $pop122
	i32.const	$push121=, -1
	i32.add 	$8=, $8, $pop121
	br_if   	$8, 0           # 0: up to label10
.LBB0_10:                               # %for.end56
                                        #   in Loop: Header=BB0_8 Depth=1
	end_loop                        # label11:
	end_block                       # label9:
	i32.add 	$push65=, $0, $27
	tee_local	$push149=, $28=, $pop65
	f32.store	$discard=, 0($pop149):p2align=4, $22
	i32.const	$push148=, 12
	i32.add 	$push66=, $28, $pop148
	f32.store	$discard=, 0($pop66), $25
	i32.const	$push147=, 8
	i32.add 	$push67=, $28, $pop147
	f32.store	$discard=, 0($pop67):p2align=3, $24
	i32.const	$push146=, 4
	i32.add 	$push68=, $28, $pop146
	f32.store	$discard=, 0($pop68), $23
	f32.store	$discard=, 16($28):p2align=4, $18
	i32.const	$push145=, 28
	i32.add 	$push69=, $28, $pop145
	f32.store	$discard=, 0($pop69), $21
	i32.const	$push144=, 24
	i32.add 	$push70=, $28, $pop144
	f32.store	$discard=, 0($pop70):p2align=3, $20
	i32.const	$push143=, 20
	i32.add 	$push71=, $28, $pop143
	f32.store	$discard=, 0($pop71), $19
	f32.store	$discard=, 32($28):p2align=4, $14
	i32.const	$push142=, 44
	i32.add 	$push72=, $28, $pop142
	f32.store	$discard=, 0($pop72), $17
	i32.const	$push141=, 40
	i32.add 	$push73=, $28, $pop141
	f32.store	$discard=, 0($pop73):p2align=3, $16
	i32.const	$push140=, 36
	i32.add 	$push74=, $28, $pop140
	f32.store	$discard=, 0($pop74), $15
	f32.store	$discard=, 48($28):p2align=4, $10
	i32.const	$push139=, 60
	i32.add 	$push75=, $28, $pop139
	f32.store	$discard=, 0($pop75), $13
	i32.const	$push138=, 56
	i32.add 	$push76=, $28, $pop138
	f32.store	$discard=, 0($pop76):p2align=3, $12
	i32.const	$push137=, 52
	i32.add 	$push77=, $28, $pop137
	f32.store	$discard=, 0($pop77), $11
	i32.const	$push136=, 16
	i32.add 	$7=, $7, $pop136
	i32.lt_s	$push78=, $7, $26
	br_if   	$pop78, 0       # 0: up to label7
# BB#11:                                # %for.cond73.preheader.loopexit
	end_loop                        # label8:
	i32.const	$push79=, 16
	i32.add 	$7=, $4, $pop79
.LBB0_12:                               # %for.cond73.preheader
	end_block                       # label6:
	block
	i32.ge_s	$push80=, $7, $3
	br_if   	$pop80, 0       # 0: down to label12
# BB#13:                                # %for.body75.lr.ph
	i32.load	$27=, 0($1)
	i32.const	$push104=, 4
	i32.add 	$1=, $1, $pop104
	i32.const	$push103=, -1
	i32.add 	$26=, $2, $pop103
.LBB0_14:                               # %for.body75
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_15 Depth 2
	loop                            # label13:
	i32.const	$push152=, 2
	i32.shl 	$push81=, $7, $pop152
	tee_local	$push151=, $9=, $pop81
	i32.add 	$push82=, $27, $pop151
	f32.load	$25=, 0($pop82)
	copy_local	$28=, $26
	copy_local	$8=, $1
	block
	i32.const	$push150=, 2
	i32.lt_s	$push83=, $2, $pop150
	br_if   	$pop83, 0       # 0: down to label15
.LBB0_15:                               # %for.body81
                                        #   Parent Loop BB0_14 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label16:
	i32.load	$push84=, 0($8)
	i32.add 	$push85=, $pop84, $9
	f32.load	$push86=, 0($pop85)
	f32.add 	$25=, $25, $pop86
	i32.const	$push154=, 4
	i32.add 	$8=, $8, $pop154
	i32.const	$push153=, -1
	i32.add 	$28=, $28, $pop153
	br_if   	$28, 0          # 0: up to label16
.LBB0_16:                               # %for.end87
                                        #   in Loop: Header=BB0_14 Depth=1
	end_loop                        # label17:
	end_block                       # label15:
	i32.add 	$push87=, $0, $9
	f32.store	$discard=, 0($pop87), $25
	i32.const	$push155=, 1
	i32.add 	$7=, $7, $pop155
	i32.ne  	$push88=, $7, $3
	br_if   	$pop88, 0       # 0: up to label13
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
	i32.const	$push32=, 0
	i32.const	$push1=, buffer
	i32.sub 	$push2=, $pop32, $pop1
	i32.const	$push3=, 63
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push31=, $1=, $pop4
	i32.const	$push6=, buffer+128
	i32.add 	$push7=, $pop31, $pop6
	i32.store	$discard=, 12($7), $pop7
	i32.const	$push5=, buffer+64
	i32.add 	$push0=, $1, $pop5
	i32.store	$1=, 8($7), $pop0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label18:
	f32.convert_s/i32	$0=, $2
	i32.const	$push38=, 64
	i32.add 	$push12=, $1, $pop38
	f32.const	$push37=, 0x1.8p3
	f32.mul 	$push10=, $0, $pop37
	f32.add 	$push11=, $0, $pop10
	f32.store	$discard=, 0($pop12), $pop11
	f32.const	$push36=, 0x1.6p3
	f32.mul 	$push8=, $0, $pop36
	f32.add 	$push9=, $0, $pop8
	f32.store	$discard=, 0($1), $pop9
	i32.const	$push35=, 1
	i32.add 	$2=, $2, $pop35
	i32.const	$push34=, 4
	i32.add 	$1=, $1, $pop34
	i32.const	$push33=, 16
	i32.ne  	$push13=, $2, $pop33
	br_if   	$pop13, 0       # 0: up to label18
# BB#2:                                 # %for.end
	end_loop                        # label19:
	i32.const	$2=, 0
	i32.const	$push41=, 0
	i32.const	$push14=, buffer
	i32.sub 	$push15=, $pop41, $pop14
	i32.const	$push16=, 63
	i32.and 	$push17=, $pop15, $pop16
	i32.const	$push40=, buffer
	i32.add 	$push30=, $pop17, $pop40
	tee_local	$push39=, $1=, $pop30
	i32.const	$push19=, 2
	i32.const	$push18=, 16
	i32.const	$6=, 8
	i32.add 	$6=, $7, $6
	call    	foo@FUNCTION, $pop39, $6, $pop19, $pop18
.LBB1_3:                                # %for.body16
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label21:
	f32.load	$push26=, 0($1)
	f32.convert_s/i32	$push20=, $2
	tee_local	$push47=, $0=, $pop20
	f32.const	$push46=, 0x1.8p3
	f32.mul 	$push24=, $pop47, $pop46
	f32.const	$push45=, 0x1.6p3
	f32.mul 	$push21=, $0, $pop45
	f32.add 	$push22=, $0, $pop21
	f32.add 	$push23=, $0, $pop22
	f32.add 	$push25=, $pop24, $pop23
	f32.ne  	$push27=, $pop26, $pop25
	br_if   	$pop27, 2       # 2: down to label20
# BB#4:                                 # %for.cond13
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push44=, 1
	i32.add 	$2=, $2, $pop44
	i32.const	$push43=, 4
	i32.add 	$1=, $1, $pop43
	i32.const	$push42=, 15
	i32.le_s	$push28=, $2, $pop42
	br_if   	$pop28, 0       # 0: up to label21
# BB#5:                                 # %for.end31
	end_loop                        # label22:
	i32.const	$push29=, 0
	i32.const	$5=, 16
	i32.add 	$7=, $7, $5
	i32.const	$5=, __stack_pointer
	i32.store	$7=, 0($5), $7
	return  	$pop29
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
