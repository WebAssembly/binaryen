	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr33870-1.c"
	.section	.text.sort_pagelist,"ax",@progbits
	.hidden	sort_pagelist
	.globl	sort_pagelist
	.type	sort_pagelist,@function
sort_pagelist:                          # @sort_pagelist
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push49=, 0
	i32.const	$push46=, 0
	i32.load	$push47=, __stack_pointer($pop46)
	i32.const	$push48=, 160
	i32.sub 	$push67=, $pop47, $pop48
	i32.store	$push0=, __stack_pointer($pop49), $pop67
	i32.const	$push68=, 0
	i32.const	$push1=, 100
	i32.call	$1=, memset@FUNCTION, $pop0, $pop68, $pop1
	i32.const	$12=, 0
	block
	i32.eqz 	$push131=, $0
	br_if   	0, $pop131      # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push59=, 112
	i32.add 	$push60=, $1, $pop59
	i32.const	$push69=, 32
	i32.add 	$4=, $pop60, $pop69
	i32.const	$push14=, 96
	i32.add 	$6=, $1, $pop14
.LBB0_2:                                # %while.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
                                        #       Child Loop BB0_6 Depth 3
                                        #     Child Loop BB0_22 Depth 2
	loop                            # label1:
	copy_local	$push75=, $0
	tee_local	$push74=, $8=, $pop75
	i32.const	$push73=, 32
	i32.add 	$push72=, $pop74, $pop73
	tee_local	$push71=, $10=, $pop72
	i32.load	$0=, 0($pop71)
	i32.const	$push70=, 0
	i32.store	$2=, 0($10), $pop70
	i32.const	$7=, 0
.LBB0_3:                                # %for.body
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_6 Depth 3
	block
	block
	block
	block
	loop                            # label7:
	i32.const	$push80=, 2
	i32.shl 	$push2=, $7, $pop80
	i32.add 	$push79=, $1, $pop2
	tee_local	$push78=, $5=, $pop79
	i32.load	$push77=, 0($pop78)
	tee_local	$push76=, $10=, $pop77
	i32.eqz 	$push132=, $pop76
	br_if   	2, $pop132      # 2: down to label6
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$3=, xx($2), $4
	block
	block
	block
	i32.eqz 	$push133=, $8
	br_if   	0, $pop133      # 0: down to label11
# BB#5:                                 # %while.body.i.preheader
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push65=, 112
	i32.add 	$push66=, $1, $pop65
	copy_local	$9=, $pop66
.LBB0_6:                                # %while.body.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label12:
	block
	block
	i32.load	$push4=, 4($10)
	i32.load	$push3=, 4($8)
	i32.ge_u	$push5=, $pop4, $pop3
	br_if   	0, $pop5        # 0: down to label15
# BB#7:                                 # %if.then.i
                                        #   in Loop: Header=BB0_6 Depth=3
	i32.const	$push84=, 32
	i32.add 	$push8=, $9, $pop84
	i32.store	$push83=, 0($pop8), $10
	tee_local	$push82=, $10=, $pop83
	i32.const	$push81=, 32
	i32.add 	$push9=, $pop82, $pop81
	i32.load	$12=, 0($pop9)
	copy_local	$11=, $8
	copy_local	$9=, $10
	br      	1               # 1: down to label14
.LBB0_8:                                # %if.else.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_block                       # label15:
	i32.const	$push88=, 32
	i32.add 	$push6=, $9, $pop88
	i32.store	$push87=, 0($pop6), $8
	tee_local	$push86=, $8=, $pop87
	i32.const	$push85=, 32
	i32.add 	$push7=, $pop86, $pop85
	i32.load	$11=, 0($pop7)
	copy_local	$12=, $10
	copy_local	$9=, $8
.LBB0_9:                                # %if.end.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_block                       # label14:
	i32.load	$push10=, 0($3)
	i32.load	$push11=, 0($pop10)
	i32.store	$drop=, vx($2), $pop11
	i32.eqz 	$push134=, $12
	br_if   	1, $pop134      # 1: down to label13
# BB#10:                                # %if.end.i
                                        #   in Loop: Header=BB0_6 Depth=3
	copy_local	$8=, $11
	copy_local	$10=, $12
	br_if   	0, $11          # 0: up to label12
.LBB0_11:                               # %while.end.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_loop                        # label13:
	i32.const	$push89=, 32
	i32.add 	$8=, $9, $pop89
	i32.eqz 	$push135=, $12
	br_if   	1, $pop135      # 1: down to label10
# BB#12:                                # %if.then14.i
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$drop=, 0($8), $12
	br      	2               # 2: down to label9
.LBB0_13:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label11:
	copy_local	$push44=, $3
	copy_local	$push45=, $10
	i32.store	$drop=, 0($pop44), $pop45
	br      	1               # 1: down to label9
.LBB0_14:                               # %if.else17.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label10:
	block
	i32.eqz 	$push136=, $11
	br_if   	0, $pop136      # 0: down to label16
# BB#15:                                # %if.then19.i
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$drop=, 0($8), $11
	br      	1               # 1: down to label9
.LBB0_16:                               # %if.else22.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label16:
	i32.store	$drop=, 0($8), $2
.LBB0_17:                               # %merge_pagelist.exit
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label9:
	i32.load	$8=, 0($3)
	i32.store	$10=, 0($5), $2
	i32.const	$push93=, 1
	i32.add 	$push92=, $7, $pop93
	tee_local	$push91=, $7=, $pop92
	i32.const	$push90=, 24
	i32.lt_s	$push12=, $pop91, $pop90
	br_if   	0, $pop12       # 0: up to label7
# BB#18:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label8:
	i32.const	$push94=, 24
	i32.ne  	$push13=, $7, $pop94
	br_if   	3, $pop13       # 3: down to label3
# BB#19:                                # %if.then9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$9=, 0($6)
	i32.store	$2=, xx($10), $3
	i32.ne  	$5=, $8, $10
	i32.ne  	$7=, $9, $10
	i32.const	$push61=, 112
	i32.add 	$push62=, $1, $pop61
	copy_local	$3=, $pop62
	i32.eqz 	$push137=, $8
	br_if   	1, $pop137      # 1: down to label5
# BB#20:                                # %if.then9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.eqz 	$push138=, $9
	br_if   	1, $pop138      # 1: down to label5
# BB#21:                                # %while.body.i89.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push63=, 112
	i32.add 	$push64=, $1, $pop63
	copy_local	$3=, $pop64
.LBB0_22:                               # %while.body.i89
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label17:
	block
	block
	i32.load	$push16=, 4($9)
	i32.load	$push15=, 4($8)
	i32.ge_u	$push17=, $pop16, $pop15
	br_if   	0, $pop17       # 0: down to label20
# BB#23:                                # %if.then.i91
                                        #   in Loop: Header=BB0_22 Depth=2
	i32.const	$push98=, 32
	i32.add 	$push20=, $3, $pop98
	i32.store	$push97=, 0($pop20), $9
	tee_local	$push96=, $9=, $pop97
	i32.const	$push95=, 32
	i32.add 	$push21=, $pop96, $pop95
	i32.load	$12=, 0($pop21)
	copy_local	$11=, $8
	copy_local	$3=, $9
	br      	1               # 1: down to label19
.LBB0_24:                               # %if.else.i93
                                        #   in Loop: Header=BB0_22 Depth=2
	end_block                       # label20:
	i32.const	$push102=, 32
	i32.add 	$push18=, $3, $pop102
	i32.store	$push101=, 0($pop18), $8
	tee_local	$push100=, $8=, $pop101
	i32.const	$push99=, 32
	i32.add 	$push19=, $pop100, $pop99
	i32.load	$11=, 0($pop19)
	copy_local	$12=, $9
	copy_local	$3=, $8
.LBB0_25:                               # %if.end.i100
                                        #   in Loop: Header=BB0_22 Depth=2
	end_block                       # label19:
	i32.load	$push22=, 0($2)
	i32.load	$push23=, 0($pop22)
	i32.store	$drop=, vx($10), $pop23
	i32.ne  	$5=, $11, $10
	i32.ne  	$7=, $12, $10
	i32.eqz 	$push139=, $12
	br_if   	4, $pop139      # 4: down to label4
# BB#26:                                # %if.end.i100
                                        #   in Loop: Header=BB0_22 Depth=2
	copy_local	$8=, $11
	copy_local	$9=, $12
	br_if   	0, $11          # 0: up to label17
	br      	4               # 4: down to label4
.LBB0_27:                               # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label18:
	end_block                       # label6:
	i32.store	$drop=, 0($5), $8
	br      	2               # 2: down to label3
.LBB0_28:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	copy_local	$11=, $8
	copy_local	$12=, $9
.LBB0_29:                               # %while.end.i107
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	block
	block
	i32.eqz 	$push140=, $7
	br_if   	0, $pop140      # 0: down to label22
# BB#30:                                # %if.then14.i108
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push103=, 32
	i32.add 	$push26=, $3, $pop103
	i32.store	$drop=, 0($pop26), $12
	br      	1               # 1: down to label21
.LBB0_31:                               # %if.else17.i109
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label22:
	block
	i32.eqz 	$push141=, $5
	br_if   	0, $pop141      # 0: down to label23
# BB#32:                                # %if.then19.i110
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push104=, 32
	i32.add 	$push25=, $3, $pop104
	i32.store	$drop=, 0($pop25), $11
	br      	1               # 1: down to label21
.LBB0_33:                               # %if.else22.i111
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label23:
	i32.const	$push105=, 32
	i32.add 	$push24=, $3, $pop105
	i32.store	$drop=, 0($pop24), $10
.LBB0_34:                               # %merge_pagelist.exit112
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label21:
	i32.load	$push27=, 0($2)
	i32.store	$drop=, 0($6), $pop27
.LBB0_35:                               # %while.cond.backedge
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	br_if   	0, $0           # 0: up to label1
# BB#36:                                # %while.end.loopexit
	end_loop                        # label2:
	i32.load	$12=, 0($1)
.LBB0_37:                               # %while.end
	end_block                       # label0:
	i32.const	$push53=, 112
	i32.add 	$push54=, $1, $pop53
	i32.const	$push106=, 32
	i32.add 	$7=, $pop54, $pop106
	i32.const	$5=, 1
.LBB0_38:                               # %for.body17
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_41 Depth 2
	loop                            # label24:
	i32.const	$push111=, 0
	i32.ne  	$3=, $12, $pop111
	i32.const	$push110=, 2
	i32.shl 	$push28=, $5, $pop110
	i32.add 	$push29=, $1, $pop28
	i32.load	$push109=, 0($pop29)
	tee_local	$push108=, $11=, $pop109
	i32.const	$push107=, 0
	i32.ne  	$2=, $pop108, $pop107
	i32.const	$push55=, 112
	i32.add 	$push56=, $1, $pop55
	copy_local	$9=, $pop56
	block
	block
	i32.eqz 	$push142=, $12
	br_if   	0, $pop142      # 0: down to label27
# BB#39:                                # %for.body17
                                        #   in Loop: Header=BB0_38 Depth=1
	i32.eqz 	$push143=, $11
	br_if   	0, $pop143      # 0: down to label27
# BB#40:                                # %while.body.i54.preheader
                                        #   in Loop: Header=BB0_38 Depth=1
	i32.const	$push57=, 112
	i32.add 	$push58=, $1, $pop57
	copy_local	$9=, $pop58
.LBB0_41:                               # %while.body.i54
                                        #   Parent Loop BB0_38 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label28:
	block
	block
	i32.load	$push31=, 4($12)
	i32.load	$push30=, 4($11)
	i32.ge_u	$push32=, $pop31, $pop30
	br_if   	0, $pop32       # 0: down to label31
# BB#42:                                # %if.then.i56
                                        #   in Loop: Header=BB0_41 Depth=2
	i32.const	$push115=, 32
	i32.add 	$push35=, $9, $pop115
	i32.store	$push114=, 0($pop35), $12
	tee_local	$push113=, $12=, $pop114
	i32.const	$push112=, 32
	i32.add 	$push36=, $pop113, $pop112
	i32.load	$8=, 0($pop36)
	copy_local	$10=, $11
	copy_local	$9=, $12
	br      	1               # 1: down to label30
.LBB0_43:                               # %if.else.i58
                                        #   in Loop: Header=BB0_41 Depth=2
	end_block                       # label31:
	i32.const	$push119=, 32
	i32.add 	$push33=, $9, $pop119
	i32.store	$push118=, 0($pop33), $11
	tee_local	$push117=, $11=, $pop118
	i32.const	$push116=, 32
	i32.add 	$push34=, $pop117, $pop116
	i32.load	$10=, 0($pop34)
	copy_local	$8=, $12
	copy_local	$9=, $11
.LBB0_44:                               # %if.end.i65
                                        #   in Loop: Header=BB0_41 Depth=2
	end_block                       # label30:
	i32.const	$push122=, 0
	i32.load	$push37=, 0($7)
	i32.load	$push38=, 0($pop37)
	i32.store	$drop=, vx($pop122), $pop38
	i32.const	$push121=, 0
	i32.ne  	$2=, $10, $pop121
	i32.const	$push120=, 0
	i32.ne  	$3=, $8, $pop120
	i32.eqz 	$push144=, $8
	br_if   	3, $pop144      # 3: down to label26
# BB#45:                                # %if.end.i65
                                        #   in Loop: Header=BB0_41 Depth=2
	copy_local	$11=, $10
	copy_local	$12=, $8
	br_if   	0, $10          # 0: up to label28
	br      	3               # 3: down to label26
.LBB0_46:                               #   in Loop: Header=BB0_38 Depth=1
	end_loop                        # label29:
	end_block                       # label27:
	copy_local	$10=, $11
	copy_local	$8=, $12
.LBB0_47:                               # %while.end.i72
                                        #   in Loop: Header=BB0_38 Depth=1
	end_block                       # label26:
	block
	block
	i32.eqz 	$push145=, $3
	br_if   	0, $pop145      # 0: down to label33
# BB#48:                                # %if.then14.i73
                                        #   in Loop: Header=BB0_38 Depth=1
	i32.const	$push123=, 32
	i32.add 	$push41=, $9, $pop123
	i32.store	$drop=, 0($pop41), $8
	br      	1               # 1: down to label32
.LBB0_49:                               # %if.else17.i74
                                        #   in Loop: Header=BB0_38 Depth=1
	end_block                       # label33:
	block
	i32.eqz 	$push146=, $2
	br_if   	0, $pop146      # 0: down to label34
# BB#50:                                # %if.then19.i75
                                        #   in Loop: Header=BB0_38 Depth=1
	i32.const	$push124=, 32
	i32.add 	$push40=, $9, $pop124
	i32.store	$drop=, 0($pop40), $10
	br      	1               # 1: down to label32
.LBB0_51:                               # %if.else22.i76
                                        #   in Loop: Header=BB0_38 Depth=1
	end_block                       # label34:
	i32.const	$push126=, 32
	i32.add 	$push39=, $9, $pop126
	i32.const	$push125=, 0
	i32.store	$drop=, 0($pop39), $pop125
.LBB0_52:                               # %merge_pagelist.exit77
                                        #   in Loop: Header=BB0_38 Depth=1
	end_block                       # label32:
	i32.load	$12=, 0($7)
	i32.const	$push130=, 1
	i32.add 	$push129=, $5, $pop130
	tee_local	$push128=, $5=, $pop129
	i32.const	$push127=, 25
	i32.ne  	$push42=, $pop128, $pop127
	br_if   	0, $pop42       # 0: up to label24
# BB#53:                                # %for.end22
	end_loop                        # label25:
	i32.const	$push43=, 0
	i32.store	$drop=, xx($pop43), $7
	i32.const	$push52=, 0
	i32.const	$push50=, 160
	i32.add 	$push51=, $1, $pop50
	i32.store	$drop=, __stack_pointer($pop52), $pop51
	copy_local	$push147=, $12
                                        # fallthrough-return: $pop147
	.endfunc
.Lfunc_end0:
	.size	sort_pagelist, .Lfunc_end0-sort_pagelist

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push31=, 0
	i32.const	$push28=, 0
	i32.load	$push29=, __stack_pointer($pop28)
	i32.const	$push30=, 224
	i32.sub 	$push35=, $pop29, $pop30
	i32.store	$push40=, __stack_pointer($pop31), $pop35
	tee_local	$push39=, $1=, $pop40
	i32.const	$push2=, 32
	i32.add 	$push3=, $pop39, $pop2
	i32.const	$push0=, 44
	i32.add 	$push1=, $1, $pop0
	i32.store	$drop=, 0($pop3), $pop1
	i32.const	$push4=, 48
	i32.add 	$push5=, $1, $pop4
	i32.const	$push6=, 4
	i32.store	$drop=, 0($pop5), $pop6
	i32.const	$push9=, 76
	i32.add 	$push10=, $1, $pop9
	i32.const	$push7=, 88
	i32.add 	$push8=, $1, $pop7
	i32.store	$drop=, 0($pop10), $pop8
	i32.const	$push11=, 92
	i32.add 	$push12=, $1, $pop11
	i32.const	$push13=, 1
	i32.store	$drop=, 0($pop12), $pop13
	i32.const	$push16=, 120
	i32.add 	$push17=, $1, $pop16
	i32.const	$push14=, 132
	i32.add 	$push15=, $1, $pop14
	i32.store	$drop=, 0($pop17), $pop15
	i32.const	$push18=, 136
	i32.add 	$push19=, $1, $pop18
	i32.const	$push20=, 3
	i32.store	$drop=, 0($pop19), $pop20
	i32.const	$push21=, 5
	i32.store	$drop=, 4($1), $pop21
	i32.const	$push22=, 164
	i32.add 	$push23=, $1, $pop22
	i32.const	$push24=, 0
	i32.store	$0=, 0($pop23), $pop24
	block
	i32.call	$push38=, sort_pagelist@FUNCTION, $1
	tee_local	$push37=, $2=, $pop38
	i32.const	$push36=, 32
	i32.add 	$push25=, $2, $pop36
	i32.load	$push26=, 0($pop25)
	i32.eq  	$push27=, $pop37, $pop26
	br_if   	0, $pop27       # 0: down to label35
# BB#1:                                 # %if.end
	i32.const	$push34=, 0
	i32.const	$push32=, 224
	i32.add 	$push33=, $1, $pop32
	i32.store	$drop=, __stack_pointer($pop34), $pop33
	return  	$0
.LBB1_2:                                # %if.then
	end_block                       # label35:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	xx                      # @xx
	.type	xx,@object
	.section	.bss.xx,"aw",@nobits
	.globl	xx
	.p2align	2
xx:
	.int32	0
	.size	xx, 4

	.hidden	vx                      # @vx
	.type	vx,@object
	.section	.bss.vx,"aw",@nobits
	.globl	vx
	.p2align	2
vx:
	.int32	0                       # 0x0
	.size	vx, 4


	.ident	"clang version 3.9.0 "
	.functype	abort, void
