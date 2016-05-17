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
	i32.const	$push51=, __stack_pointer
	i32.const	$push48=, __stack_pointer
	i32.load	$push49=, 0($pop48)
	i32.const	$push50=, 160
	i32.sub 	$push69=, $pop49, $pop50
	i32.store	$push0=, 0($pop51), $pop69
	i32.const	$push70=, 0
	i32.const	$push1=, 100
	i32.call	$1=, memset@FUNCTION, $pop0, $pop70, $pop1
	i32.const	$9=, 0
	block
	i32.eqz 	$push129=, $0
	br_if   	0, $pop129      # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push15=, 96
	i32.add 	$5=, $1, $pop15
	i32.const	$push61=, 112
	i32.add 	$push62=, $1, $pop61
	i32.const	$push71=, 32
	i32.add 	$4=, $pop62, $pop71
.LBB0_2:                                # %while.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
                                        #       Child Loop BB0_6 Depth 3
                                        #     Child Loop BB0_22 Depth 2
	loop                            # label1:
	copy_local	$push77=, $0
	tee_local	$push76=, $10=, $pop77
	i32.const	$push75=, 32
	i32.add 	$push74=, $pop76, $pop75
	tee_local	$push73=, $11=, $pop74
	i32.load	$0=, 0($pop73)
	i32.const	$push72=, 0
	i32.store	$2=, 0($11), $pop72
	i32.const	$6=, 0
.LBB0_3:                                # %for.body
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_6 Depth 3
	block
	block
	block
	block
	loop                            # label7:
	i32.const	$push82=, 2
	i32.shl 	$push2=, $6, $pop82
	i32.add 	$push81=, $1, $pop2
	tee_local	$push80=, $12=, $pop81
	i32.load	$push79=, 0($pop80)
	tee_local	$push78=, $11=, $pop79
	i32.eqz 	$push130=, $pop78
	br_if   	2, $pop130      # 2: down to label6
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$3=, xx($2), $4
	block
	block
	block
	i32.eqz 	$push131=, $10
	br_if   	0, $pop131      # 0: down to label11
# BB#5:                                 # %while.body.i.preheader
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push67=, 112
	i32.add 	$push68=, $1, $pop67
	copy_local	$7=, $pop68
.LBB0_6:                                # %while.body.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label12:
	block
	block
	i32.load	$push3=, 4($11)
	i32.load	$push4=, 4($10)
	i32.ge_u	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label15
# BB#7:                                 # %if.then.i
                                        #   in Loop: Header=BB0_6 Depth=3
	i32.const	$push86=, 32
	i32.add 	$push8=, $7, $pop86
	i32.store	$push85=, 0($pop8), $11
	tee_local	$push84=, $11=, $pop85
	i32.const	$push83=, 32
	i32.add 	$push9=, $pop84, $pop83
	i32.load	$9=, 0($pop9)
	copy_local	$8=, $10
	copy_local	$7=, $11
	br      	1               # 1: down to label14
.LBB0_8:                                # %if.else.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_block                       # label15:
	i32.const	$push90=, 32
	i32.add 	$push6=, $7, $pop90
	i32.store	$push89=, 0($pop6), $10
	tee_local	$push88=, $10=, $pop89
	i32.const	$push87=, 32
	i32.add 	$push7=, $pop88, $pop87
	i32.load	$8=, 0($pop7)
	copy_local	$9=, $11
	copy_local	$7=, $10
.LBB0_9:                                # %if.end.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_block                       # label14:
	i32.load	$push10=, xx($2)
	i32.load	$push11=, 0($pop10)
	i32.load	$push12=, 0($pop11)
	i32.store	$discard=, vx($2), $pop12
	i32.eqz 	$push132=, $9
	br_if   	1, $pop132      # 1: down to label13
# BB#10:                                # %if.end.i
                                        #   in Loop: Header=BB0_6 Depth=3
	copy_local	$10=, $8
	copy_local	$11=, $9
	br_if   	0, $8           # 0: up to label12
.LBB0_11:                               # %while.end.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_loop                        # label13:
	i32.const	$push91=, 32
	i32.add 	$10=, $7, $pop91
	i32.eqz 	$push133=, $9
	br_if   	1, $pop133      # 1: down to label10
# BB#12:                                # %if.then14.i
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$discard=, 0($10), $9
	br      	2               # 2: down to label9
.LBB0_13:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label11:
	copy_local	$push46=, $3
	copy_local	$push47=, $11
	i32.store	$discard=, 0($pop46), $pop47
	br      	1               # 1: down to label9
.LBB0_14:                               # %if.else17.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label10:
	block
	i32.eqz 	$push134=, $8
	br_if   	0, $pop134      # 0: down to label16
# BB#15:                                # %if.then19.i
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$discard=, 0($10), $8
	br      	1               # 1: down to label9
.LBB0_16:                               # %if.else22.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label16:
	i32.store	$discard=, 0($10), $2
.LBB0_17:                               # %merge_pagelist.exit
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label9:
	i32.load	$10=, 0($3)
	i32.store	$11=, 0($12), $2
	i32.const	$push93=, 1
	i32.add 	$6=, $6, $pop93
	i32.const	$push92=, 24
	i32.lt_s	$push13=, $6, $pop92
	br_if   	0, $pop13       # 0: up to label7
# BB#18:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label8:
	i32.const	$push94=, 24
	i32.ne  	$push14=, $6, $pop94
	br_if   	3, $pop14       # 3: down to label3
# BB#19:                                # %if.then9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$2=, 0($5)
	i32.store	$12=, xx($11), $3
	i32.ne  	$6=, $2, $11
	i32.ne  	$3=, $10, $11
	i32.const	$push63=, 112
	i32.add 	$push64=, $1, $pop63
	copy_local	$7=, $pop64
	i32.eqz 	$push135=, $10
	br_if   	1, $pop135      # 1: down to label5
# BB#20:                                # %if.then9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.eqz 	$push136=, $2
	br_if   	1, $pop136      # 1: down to label5
# BB#21:                                # %while.body.i89.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push65=, 112
	i32.add 	$push66=, $1, $pop65
	copy_local	$7=, $pop66
.LBB0_22:                               # %while.body.i89
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label17:
	block
	block
	i32.load	$push16=, 4($2)
	i32.load	$push17=, 4($10)
	i32.ge_u	$push18=, $pop16, $pop17
	br_if   	0, $pop18       # 0: down to label20
# BB#23:                                # %if.then.i91
                                        #   in Loop: Header=BB0_22 Depth=2
	i32.const	$push98=, 32
	i32.add 	$push21=, $7, $pop98
	i32.store	$push97=, 0($pop21), $2
	tee_local	$push96=, $2=, $pop97
	i32.const	$push95=, 32
	i32.add 	$push22=, $pop96, $pop95
	i32.load	$9=, 0($pop22)
	copy_local	$8=, $10
	copy_local	$7=, $2
	br      	1               # 1: down to label19
.LBB0_24:                               # %if.else.i93
                                        #   in Loop: Header=BB0_22 Depth=2
	end_block                       # label20:
	i32.const	$push102=, 32
	i32.add 	$push19=, $7, $pop102
	i32.store	$push101=, 0($pop19), $10
	tee_local	$push100=, $10=, $pop101
	i32.const	$push99=, 32
	i32.add 	$push20=, $pop100, $pop99
	i32.load	$8=, 0($pop20)
	copy_local	$9=, $2
	copy_local	$7=, $10
.LBB0_25:                               # %if.end.i100
                                        #   in Loop: Header=BB0_22 Depth=2
	end_block                       # label19:
	i32.load	$push23=, xx($11)
	i32.load	$push24=, 0($pop23)
	i32.load	$push25=, 0($pop24)
	i32.store	$discard=, vx($11), $pop25
	i32.ne  	$6=, $9, $11
	i32.ne  	$3=, $8, $11
	i32.eqz 	$push137=, $9
	br_if   	4, $pop137      # 4: down to label4
# BB#26:                                # %if.end.i100
                                        #   in Loop: Header=BB0_22 Depth=2
	copy_local	$10=, $8
	copy_local	$2=, $9
	br_if   	0, $8           # 0: up to label17
	br      	4               # 4: down to label4
.LBB0_27:                               # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label18:
	end_block                       # label6:
	i32.store	$discard=, 0($12), $10
	br      	2               # 2: down to label3
.LBB0_28:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	copy_local	$8=, $10
	copy_local	$9=, $2
.LBB0_29:                               # %while.end.i107
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	block
	block
	i32.eqz 	$push138=, $6
	br_if   	0, $pop138      # 0: down to label22
# BB#30:                                # %if.then14.i108
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push103=, 32
	i32.add 	$push28=, $7, $pop103
	i32.store	$discard=, 0($pop28), $9
	br      	1               # 1: down to label21
.LBB0_31:                               # %if.else17.i109
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label22:
	block
	i32.eqz 	$push139=, $3
	br_if   	0, $pop139      # 0: down to label23
# BB#32:                                # %if.then19.i110
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push104=, 32
	i32.add 	$push27=, $7, $pop104
	i32.store	$discard=, 0($pop27), $8
	br      	1               # 1: down to label21
.LBB0_33:                               # %if.else22.i111
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label23:
	i32.const	$push105=, 32
	i32.add 	$push26=, $7, $pop105
	i32.store	$discard=, 0($pop26), $11
.LBB0_34:                               # %merge_pagelist.exit112
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label21:
	i32.load	$push29=, 0($12)
	i32.store	$discard=, 0($5), $pop29
.LBB0_35:                               # %while.cond.backedge
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	br_if   	0, $0           # 0: up to label1
# BB#36:                                # %while.end.loopexit
	end_loop                        # label2:
	i32.load	$9=, 0($1)
.LBB0_37:                               # %while.end
	end_block                       # label0:
	i32.const	$push55=, 112
	i32.add 	$push56=, $1, $pop55
	i32.const	$push106=, 32
	i32.add 	$4=, $pop56, $pop106
	i32.const	$3=, 1
.LBB0_38:                               # %for.body17
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_41 Depth 2
	loop                            # label24:
	i32.const	$push110=, 2
	i32.shl 	$push30=, $3, $pop110
	i32.add 	$push31=, $1, $pop30
	i32.load	$8=, 0($pop31)
	i32.const	$push109=, 0
	i32.store	$12=, xx($pop109), $4
	i32.const	$push108=, 0
	i32.ne  	$7=, $9, $pop108
	i32.const	$push107=, 0
	i32.ne  	$6=, $8, $pop107
	i32.const	$push57=, 112
	i32.add 	$push58=, $1, $pop57
	copy_local	$2=, $pop58
	block
	block
	i32.eqz 	$push140=, $9
	br_if   	0, $pop140      # 0: down to label27
# BB#39:                                # %for.body17
                                        #   in Loop: Header=BB0_38 Depth=1
	i32.eqz 	$push141=, $8
	br_if   	0, $pop141      # 0: down to label27
# BB#40:                                # %while.body.i54.preheader
                                        #   in Loop: Header=BB0_38 Depth=1
	i32.const	$push59=, 112
	i32.add 	$push60=, $1, $pop59
	copy_local	$2=, $pop60
.LBB0_41:                               # %while.body.i54
                                        #   Parent Loop BB0_38 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label28:
	block
	block
	i32.load	$push32=, 4($9)
	i32.load	$push33=, 4($8)
	i32.ge_u	$push34=, $pop32, $pop33
	br_if   	0, $pop34       # 0: down to label31
# BB#42:                                # %if.then.i56
                                        #   in Loop: Header=BB0_41 Depth=2
	i32.const	$push114=, 32
	i32.add 	$push37=, $2, $pop114
	i32.store	$push113=, 0($pop37), $9
	tee_local	$push112=, $9=, $pop113
	i32.const	$push111=, 32
	i32.add 	$push38=, $pop112, $pop111
	i32.load	$10=, 0($pop38)
	copy_local	$11=, $8
	copy_local	$2=, $9
	br      	1               # 1: down to label30
.LBB0_43:                               # %if.else.i58
                                        #   in Loop: Header=BB0_41 Depth=2
	end_block                       # label31:
	i32.const	$push118=, 32
	i32.add 	$push35=, $2, $pop118
	i32.store	$push117=, 0($pop35), $8
	tee_local	$push116=, $8=, $pop117
	i32.const	$push115=, 32
	i32.add 	$push36=, $pop116, $pop115
	i32.load	$11=, 0($pop36)
	copy_local	$10=, $9
	copy_local	$2=, $8
.LBB0_44:                               # %if.end.i65
                                        #   in Loop: Header=BB0_41 Depth=2
	end_block                       # label30:
	i32.const	$push122=, 0
	i32.const	$push121=, 0
	i32.load	$push39=, xx($pop121)
	i32.load	$push40=, 0($pop39)
	i32.load	$push41=, 0($pop40)
	i32.store	$discard=, vx($pop122), $pop41
	i32.const	$push120=, 0
	i32.ne  	$7=, $10, $pop120
	i32.const	$push119=, 0
	i32.ne  	$6=, $11, $pop119
	i32.eqz 	$push142=, $10
	br_if   	3, $pop142      # 3: down to label26
# BB#45:                                # %if.end.i65
                                        #   in Loop: Header=BB0_41 Depth=2
	copy_local	$8=, $11
	copy_local	$9=, $10
	br_if   	0, $11          # 0: up to label28
	br      	3               # 3: down to label26
.LBB0_46:                               #   in Loop: Header=BB0_38 Depth=1
	end_loop                        # label29:
	end_block                       # label27:
	copy_local	$11=, $8
	copy_local	$10=, $9
.LBB0_47:                               # %while.end.i72
                                        #   in Loop: Header=BB0_38 Depth=1
	end_block                       # label26:
	block
	block
	i32.eqz 	$push143=, $7
	br_if   	0, $pop143      # 0: down to label33
# BB#48:                                # %if.then14.i73
                                        #   in Loop: Header=BB0_38 Depth=1
	i32.const	$push123=, 32
	i32.add 	$push44=, $2, $pop123
	i32.store	$discard=, 0($pop44), $10
	br      	1               # 1: down to label32
.LBB0_49:                               # %if.else17.i74
                                        #   in Loop: Header=BB0_38 Depth=1
	end_block                       # label33:
	block
	i32.eqz 	$push144=, $6
	br_if   	0, $pop144      # 0: down to label34
# BB#50:                                # %if.then19.i75
                                        #   in Loop: Header=BB0_38 Depth=1
	i32.const	$push124=, 32
	i32.add 	$push43=, $2, $pop124
	i32.store	$discard=, 0($pop43), $11
	br      	1               # 1: down to label32
.LBB0_51:                               # %if.else22.i76
                                        #   in Loop: Header=BB0_38 Depth=1
	end_block                       # label34:
	i32.const	$push126=, 32
	i32.add 	$push42=, $2, $pop126
	i32.const	$push125=, 0
	i32.store	$discard=, 0($pop42), $pop125
.LBB0_52:                               # %merge_pagelist.exit77
                                        #   in Loop: Header=BB0_38 Depth=1
	end_block                       # label32:
	i32.load	$9=, 0($12)
	i32.const	$push128=, 1
	i32.add 	$3=, $3, $pop128
	i32.const	$push127=, 25
	i32.ne  	$push45=, $3, $pop127
	br_if   	0, $pop45       # 0: up to label24
# BB#53:                                # %for.end22
	end_loop                        # label25:
	i32.const	$push54=, __stack_pointer
	i32.const	$push52=, 160
	i32.add 	$push53=, $1, $pop52
	i32.store	$discard=, 0($pop54), $pop53
	return  	$9
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
	i32.const	$push31=, __stack_pointer
	i32.const	$push28=, __stack_pointer
	i32.load	$push29=, 0($pop28)
	i32.const	$push30=, 224
	i32.sub 	$push35=, $pop29, $pop30
	i32.store	$push38=, 0($pop31), $pop35
	tee_local	$push37=, $2=, $pop38
	i32.const	$push3=, 32
	i32.add 	$push4=, $pop37, $pop3
	i32.const	$push1=, 44
	i32.add 	$push2=, $2, $pop1
	i32.store	$discard=, 0($pop4), $pop2
	i32.const	$push5=, 48
	i32.add 	$push6=, $2, $pop5
	i32.const	$push7=, 4
	i32.store	$discard=, 0($pop6), $pop7
	i32.const	$push10=, 76
	i32.add 	$push11=, $2, $pop10
	i32.const	$push8=, 88
	i32.add 	$push9=, $2, $pop8
	i32.store	$discard=, 0($pop11), $pop9
	i32.const	$push12=, 92
	i32.add 	$push13=, $2, $pop12
	i32.const	$push14=, 1
	i32.store	$discard=, 0($pop13), $pop14
	i32.const	$push17=, 120
	i32.add 	$push18=, $2, $pop17
	i32.const	$push15=, 132
	i32.add 	$push16=, $2, $pop15
	i32.store	$discard=, 0($pop18), $pop16
	i32.const	$push19=, 136
	i32.add 	$push20=, $2, $pop19
	i32.const	$push21=, 3
	i32.store	$discard=, 0($pop20), $pop21
	i32.const	$push0=, 5
	i32.store	$discard=, 4($2), $pop0
	i32.const	$push22=, 164
	i32.add 	$push23=, $2, $pop22
	i32.const	$push24=, 0
	i32.store	$0=, 0($pop23), $pop24
	i32.call	$1=, sort_pagelist@FUNCTION, $2
	block
	i32.const	$push36=, 32
	i32.add 	$push25=, $1, $pop36
	i32.load	$push26=, 0($pop25)
	i32.eq  	$push27=, $1, $pop26
	br_if   	0, $pop27       # 0: down to label35
# BB#1:                                 # %if.end
	i32.const	$push34=, __stack_pointer
	i32.const	$push32=, 224
	i32.add 	$push33=, $2, $pop32
	i32.store	$discard=, 0($pop34), $pop33
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
