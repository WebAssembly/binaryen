	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20060420-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32
# BB#0:                                 # %entry
	block   	
	block   	
	i32.const	$push85=, 1
	i32.lt_s	$push3=, $3, $pop85
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %land.rhs.lr.ph
	i32.const	$push87=, -1
	i32.add 	$8=, $2, $pop87
	i32.const	$push86=, 4
	i32.add 	$4=, $1, $pop86
	i32.const	$10=, 0
.LBB0_2:                                # %land.rhs
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_5 Depth 2
	loop    	                # label2:
	i32.add 	$push4=, $10, $0
	i32.const	$push88=, 15
	i32.and 	$push5=, $pop4, $pop88
	i32.eqz 	$push171=, $pop5
	br_if   	2, $pop171      # 2: down to label0
# BB#3:                                 # %for.body
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$push7=, 0($1)
	i32.const	$push92=, 2
	i32.shl 	$push91=, $10, $pop92
	tee_local	$push90=, $11=, $pop91
	i32.add 	$push8=, $pop7, $pop90
	f32.load	$25=, 0($pop8)
	block   	
	i32.const	$push89=, 2
	i32.lt_s	$push6=, $2, $pop89
	br_if   	0, $pop6        # 0: down to label3
# BB#4:                                 # %for.body4.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	copy_local	$12=, $8
	copy_local	$9=, $4
.LBB0_5:                                # %for.body4
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label4:
	i32.load	$push9=, 0($9)
	i32.add 	$push10=, $pop9, $11
	f32.load	$push11=, 0($pop10)
	f32.add 	$25=, $25, $pop11
	i32.const	$push96=, 4
	i32.add 	$push0=, $9, $pop96
	copy_local	$9=, $pop0
	i32.const	$push95=, -1
	i32.add 	$push94=, $12, $pop95
	tee_local	$push93=, $12=, $pop94
	br_if   	0, $pop93       # 0: up to label4
.LBB0_6:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop
	end_block                       # label3:
	i32.add 	$push12=, $0, $11
	f32.store	0($pop12), $25
	i32.const	$push99=, 1
	i32.add 	$push98=, $10, $pop99
	tee_local	$push97=, $10=, $pop98
	i32.lt_s	$push13=, $pop97, $3
	br_if   	0, $pop13       # 0: up to label2
	br      	2               # 2: down to label0
.LBB0_7:
	end_loop
	end_block                       # label1:
	i32.const	$10=, 0
.LBB0_8:                                # %for.cond12.preheader
	end_block                       # label0:
	block   	
	i32.const	$push14=, -15
	i32.add 	$push101=, $3, $pop14
	tee_local	$push100=, $4=, $pop101
	i32.ge_s	$push15=, $10, $pop100
	br_if   	0, $pop15       # 0: down to label5
# BB#9:                                 # %for.body15.lr.ph
	i32.const	$push104=, -1
	i32.add 	$7=, $2, $pop104
	i32.const	$push103=, 4
	i32.add 	$6=, $1, $pop103
	i32.const	$push16=, -16
	i32.add 	$push17=, $3, $pop16
	i32.sub 	$push18=, $pop17, $10
	i32.const	$push102=, -16
	i32.and 	$push19=, $pop18, $pop102
	i32.add 	$5=, $10, $pop19
.LBB0_10:                               # %for.body15
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_12 Depth 2
	loop    	                # label6:
	i32.load	$push21=, 0($1)
	i32.const	$push122=, 2
	i32.shl 	$push121=, $10, $pop122
	tee_local	$push120=, $8=, $pop121
	i32.add 	$push119=, $pop21, $pop120
	tee_local	$push118=, $9=, $pop119
	f32.load	$25=, 48($pop118)
	f32.load	$21=, 32($9)
	f32.load	$17=, 16($9)
	f32.load	$13=, 0($9)
	i32.const	$push117=, 60
	i32.add 	$push22=, $9, $pop117
	f32.load	$28=, 0($pop22)
	i32.const	$push116=, 56
	i32.add 	$push23=, $9, $pop116
	f32.load	$27=, 0($pop23)
	i32.const	$push115=, 52
	i32.add 	$push24=, $9, $pop115
	f32.load	$26=, 0($pop24)
	i32.const	$push114=, 44
	i32.add 	$push25=, $9, $pop114
	f32.load	$24=, 0($pop25)
	i32.const	$push113=, 40
	i32.add 	$push26=, $9, $pop113
	f32.load	$23=, 0($pop26)
	i32.const	$push112=, 36
	i32.add 	$push27=, $9, $pop112
	f32.load	$22=, 0($pop27)
	i32.const	$push111=, 28
	i32.add 	$push28=, $9, $pop111
	f32.load	$20=, 0($pop28)
	i32.const	$push110=, 24
	i32.add 	$push29=, $9, $pop110
	f32.load	$19=, 0($pop29)
	i32.const	$push109=, 20
	i32.add 	$push30=, $9, $pop109
	f32.load	$18=, 0($pop30)
	i32.const	$push108=, 12
	i32.add 	$push31=, $9, $pop108
	f32.load	$16=, 0($pop31)
	i32.const	$push107=, 8
	i32.add 	$push32=, $9, $pop107
	f32.load	$15=, 0($pop32)
	i32.const	$push106=, 4
	i32.add 	$push33=, $9, $pop106
	f32.load	$14=, 0($pop33)
	block   	
	i32.const	$push105=, 2
	i32.lt_s	$push20=, $2, $pop105
	br_if   	0, $pop20       # 0: down to label7
# BB#11:                                # %for.body33.preheader
                                        #   in Loop: Header=BB0_10 Depth=1
	copy_local	$11=, $7
	copy_local	$12=, $6
.LBB0_12:                               # %for.body33
                                        #   Parent Loop BB0_10 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label8:
	i32.load	$push34=, 0($12)
	i32.add 	$push140=, $pop34, $8
	tee_local	$push139=, $9=, $pop140
	f32.load	$push35=, 48($pop139)
	f32.add 	$25=, $25, $pop35
	f32.load	$push36=, 32($9)
	f32.add 	$21=, $21, $pop36
	f32.load	$push37=, 16($9)
	f32.add 	$17=, $17, $pop37
	f32.load	$push38=, 0($9)
	f32.add 	$13=, $13, $pop38
	i32.const	$push138=, 60
	i32.add 	$push39=, $9, $pop138
	f32.load	$push40=, 0($pop39)
	f32.add 	$28=, $28, $pop40
	i32.const	$push137=, 56
	i32.add 	$push41=, $9, $pop137
	f32.load	$push42=, 0($pop41)
	f32.add 	$27=, $27, $pop42
	i32.const	$push136=, 52
	i32.add 	$push43=, $9, $pop136
	f32.load	$push44=, 0($pop43)
	f32.add 	$26=, $26, $pop44
	i32.const	$push135=, 44
	i32.add 	$push45=, $9, $pop135
	f32.load	$push46=, 0($pop45)
	f32.add 	$24=, $24, $pop46
	i32.const	$push134=, 40
	i32.add 	$push47=, $9, $pop134
	f32.load	$push48=, 0($pop47)
	f32.add 	$23=, $23, $pop48
	i32.const	$push133=, 36
	i32.add 	$push49=, $9, $pop133
	f32.load	$push50=, 0($pop49)
	f32.add 	$22=, $22, $pop50
	i32.const	$push132=, 28
	i32.add 	$push51=, $9, $pop132
	f32.load	$push52=, 0($pop51)
	f32.add 	$20=, $20, $pop52
	i32.const	$push131=, 24
	i32.add 	$push53=, $9, $pop131
	f32.load	$push54=, 0($pop53)
	f32.add 	$19=, $19, $pop54
	i32.const	$push130=, 20
	i32.add 	$push55=, $9, $pop130
	f32.load	$push56=, 0($pop55)
	f32.add 	$18=, $18, $pop56
	i32.const	$push129=, 12
	i32.add 	$push57=, $9, $pop129
	f32.load	$push58=, 0($pop57)
	f32.add 	$16=, $16, $pop58
	i32.const	$push128=, 8
	i32.add 	$push59=, $9, $pop128
	f32.load	$push60=, 0($pop59)
	f32.add 	$15=, $15, $pop60
	i32.const	$push127=, 4
	i32.add 	$push61=, $9, $pop127
	f32.load	$push62=, 0($pop61)
	f32.add 	$14=, $14, $pop62
	i32.const	$push126=, 4
	i32.add 	$push1=, $12, $pop126
	copy_local	$12=, $pop1
	i32.const	$push125=, -1
	i32.add 	$push124=, $11, $pop125
	tee_local	$push123=, $11=, $pop124
	br_if   	0, $pop123      # 0: up to label8
.LBB0_13:                               # %for.end56
                                        #   in Loop: Header=BB0_10 Depth=1
	end_loop
	end_block                       # label7:
	i32.add 	$push157=, $0, $8
	tee_local	$push156=, $9=, $pop157
	f32.store	16($pop156), $17
	f32.store	0($9), $13
	f32.store	32($9), $21
	f32.store	48($9), $25
	i32.const	$push155=, 28
	i32.add 	$push63=, $9, $pop155
	f32.store	0($pop63), $20
	i32.const	$push154=, 24
	i32.add 	$push64=, $9, $pop154
	f32.store	0($pop64), $19
	i32.const	$push153=, 20
	i32.add 	$push65=, $9, $pop153
	f32.store	0($pop65), $18
	i32.const	$push152=, 12
	i32.add 	$push66=, $9, $pop152
	f32.store	0($pop66), $16
	i32.const	$push151=, 8
	i32.add 	$push67=, $9, $pop151
	f32.store	0($pop67), $15
	i32.const	$push150=, 4
	i32.add 	$push68=, $9, $pop150
	f32.store	0($pop68), $14
	i32.const	$push149=, 44
	i32.add 	$push69=, $9, $pop149
	f32.store	0($pop69), $24
	i32.const	$push148=, 40
	i32.add 	$push70=, $9, $pop148
	f32.store	0($pop70), $23
	i32.const	$push147=, 36
	i32.add 	$push71=, $9, $pop147
	f32.store	0($pop71), $22
	i32.const	$push146=, 60
	i32.add 	$push72=, $9, $pop146
	f32.store	0($pop72), $28
	i32.const	$push145=, 56
	i32.add 	$push73=, $9, $pop145
	f32.store	0($pop73), $27
	i32.const	$push144=, 52
	i32.add 	$push74=, $9, $pop144
	f32.store	0($pop74), $26
	i32.const	$push143=, 16
	i32.add 	$push142=, $10, $pop143
	tee_local	$push141=, $10=, $pop142
	i32.lt_s	$push75=, $pop141, $4
	br_if   	0, $pop75       # 0: up to label6
# BB#14:                                # %for.cond73.preheader.loopexit
	end_loop
	i32.const	$push76=, 16
	i32.add 	$10=, $5, $pop76
.LBB0_15:                               # %for.cond73.preheader
	end_block                       # label5:
	block   	
	i32.ge_s	$push77=, $10, $3
	br_if   	0, $pop77       # 0: down to label9
# BB#16:                                # %for.body75.lr.ph
	i32.const	$push159=, -1
	i32.add 	$4=, $2, $pop159
	i32.const	$push158=, 4
	i32.add 	$7=, $1, $pop158
	i32.load	$8=, 0($1)
.LBB0_17:                               # %for.body75
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_19 Depth 2
	loop    	                # label10:
	i32.const	$push163=, 2
	i32.shl 	$push162=, $10, $pop163
	tee_local	$push161=, $11=, $pop162
	i32.add 	$push79=, $8, $pop161
	f32.load	$25=, 0($pop79)
	block   	
	i32.const	$push160=, 2
	i32.lt_s	$push78=, $2, $pop160
	br_if   	0, $pop78       # 0: down to label11
# BB#18:                                # %for.body81.preheader
                                        #   in Loop: Header=BB0_17 Depth=1
	copy_local	$12=, $4
	copy_local	$9=, $7
.LBB0_19:                               # %for.body81
                                        #   Parent Loop BB0_17 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label12:
	i32.load	$push80=, 0($9)
	i32.add 	$push81=, $pop80, $11
	f32.load	$push82=, 0($pop81)
	f32.add 	$25=, $25, $pop82
	i32.const	$push167=, 4
	i32.add 	$push2=, $9, $pop167
	copy_local	$9=, $pop2
	i32.const	$push166=, -1
	i32.add 	$push165=, $12, $pop166
	tee_local	$push164=, $12=, $pop165
	br_if   	0, $pop164      # 0: up to label12
.LBB0_20:                               # %for.end87
                                        #   in Loop: Header=BB0_17 Depth=1
	end_loop
	end_block                       # label11:
	i32.add 	$push83=, $0, $11
	f32.store	0($pop83), $25
	i32.const	$push170=, 1
	i32.add 	$push169=, $10, $pop170
	tee_local	$push168=, $10=, $pop169
	i32.ne  	$push84=, $pop168, $3
	br_if   	0, $pop84       # 0: up to label10
.LBB0_21:                               # %for.end91
	end_loop
	end_block                       # label9:
                                        # fallthrough-return
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
	i32.const	$push30=, 0
	i32.const	$push27=, 0
	i32.load	$push28=, __stack_pointer($pop27)
	i32.const	$push29=, 16
	i32.sub 	$push42=, $pop28, $pop29
	tee_local	$push41=, $3=, $pop42
	i32.store	__stack_pointer($pop30), $pop41
	i32.const	$2=, 0
	i32.const	$push40=, 0
	i32.const	$push0=, buffer
	i32.sub 	$push1=, $pop40, $pop0
	i32.const	$push2=, 63
	i32.and 	$push39=, $pop1, $pop2
	tee_local	$push38=, $1=, $pop39
	i32.const	$push3=, buffer+128
	i32.add 	$push4=, $pop38, $pop3
	i32.store	12($3), $pop4
	i32.const	$push5=, buffer+64
	i32.add 	$push37=, $1, $pop5
	tee_local	$push36=, $1=, $pop37
	i32.store	8($3), $pop36
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label13:
	i32.const	$push52=, 64
	i32.add 	$push6=, $1, $pop52
	f32.convert_s/i32	$push51=, $2
	tee_local	$push50=, $0=, $pop51
	f32.const	$push49=, 0x1.8p3
	f32.mul 	$push7=, $0, $pop49
	f32.add 	$push8=, $pop50, $pop7
	f32.store	0($pop6), $pop8
	f32.const	$push48=, 0x1.6p3
	f32.mul 	$push9=, $0, $pop48
	f32.add 	$push10=, $0, $pop9
	f32.store	0($1), $pop10
	i32.const	$push47=, 4
	i32.add 	$1=, $1, $pop47
	i32.const	$push46=, 1
	i32.add 	$push45=, $2, $pop46
	tee_local	$push44=, $2=, $pop45
	i32.const	$push43=, 16
	i32.ne  	$push11=, $pop44, $pop43
	br_if   	0, $pop11       # 0: up to label13
# BB#2:                                 # %for.end
	end_loop
	i32.const	$1=, 0
	i32.const	$push56=, 0
	i32.const	$push12=, buffer
	i32.sub 	$push13=, $pop56, $pop12
	i32.const	$push14=, 63
	i32.and 	$push15=, $pop13, $pop14
	i32.const	$push55=, buffer
	i32.add 	$push54=, $pop15, $pop55
	tee_local	$push53=, $2=, $pop54
	i32.const	$push34=, 8
	i32.add 	$push35=, $3, $pop34
	i32.const	$push17=, 2
	i32.const	$push16=, 16
	call    	foo@FUNCTION, $pop53, $pop35, $pop17, $pop16
.LBB1_3:                                # %for.body16
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label15:
	f32.load	$push23=, 0($2)
	f32.convert_s/i32	$push60=, $1
	tee_local	$push59=, $0=, $pop60
	f32.const	$push58=, 0x1.8p3
	f32.mul 	$push18=, $pop59, $pop58
	f32.const	$push57=, 0x1.6p3
	f32.mul 	$push19=, $0, $pop57
	f32.add 	$push20=, $0, $pop19
	f32.add 	$push21=, $0, $pop20
	f32.add 	$push22=, $pop18, $pop21
	f32.ne  	$push24=, $pop23, $pop22
	br_if   	1, $pop24       # 1: down to label14
# BB#4:                                 # %for.cond13
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push65=, 4
	i32.add 	$2=, $2, $pop65
	i32.const	$push64=, 1
	i32.add 	$push63=, $1, $pop64
	tee_local	$push62=, $1=, $pop63
	i32.const	$push61=, 15
	i32.le_s	$push25=, $pop62, $pop61
	br_if   	0, $pop25       # 0: up to label15
# BB#5:                                 # %for.end31
	end_loop
	i32.const	$push33=, 0
	i32.const	$push31=, 16
	i32.add 	$push32=, $3, $pop31
	i32.store	__stack_pointer($pop33), $pop32
	i32.const	$push26=, 0
	return  	$pop26
.LBB1_6:                                # %if.then
	end_block                       # label14:
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
