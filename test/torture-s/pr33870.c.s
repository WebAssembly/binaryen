	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr33870.c"
	.section	.text.sort_pagelist,"ax",@progbits
	.hidden	sort_pagelist
	.globl	sort_pagelist
	.type	sort_pagelist,@function
sort_pagelist:                          # @sort_pagelist
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push34=, 0
	i32.const	$push31=, 0
	i32.load	$push32=, __stack_pointer($pop31)
	i32.const	$push33=, 144
	i32.sub 	$push54=, $pop32, $pop33
	i32.store	$push0=, __stack_pointer($pop34), $pop54
	i32.const	$push55=, 0
	i32.const	$push1=, 100
	i32.call	$1=, memset@FUNCTION, $pop0, $pop55, $pop1
	i32.const	$5=, 0
	block
	i32.eqz 	$push134=, $0
	br_if   	0, $pop134      # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push44=, 104
	i32.add 	$push45=, $1, $pop44
	i32.const	$push56=, 28
	i32.add 	$3=, $pop45, $pop56
	i32.const	$push9=, 96
	i32.add 	$7=, $1, $pop9
.LBB0_2:                                # %while.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
                                        #       Child Loop BB0_6 Depth 3
                                        #         Child Loop BB0_7 Depth 4
                                        #     Child Loop BB0_23 Depth 2
                                        #       Child Loop BB0_24 Depth 3
	loop                            # label1:
	copy_local	$push59=, $0
	tee_local	$push58=, $9=, $pop59
	i32.load	$0=, 28($pop58)
	i32.const	$push57=, 0
	i32.store	$2=, 28($9), $pop57
	i32.const	$8=, 0
.LBB0_3:                                # %for.body
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_6 Depth 3
                                        #         Child Loop BB0_7 Depth 4
	block
	block
	block
	block
	block
	block
	block
	loop                            # label10:
	i32.const	$push64=, 2
	i32.shl 	$push2=, $8, $pop64
	i32.add 	$push63=, $1, $pop2
	tee_local	$push62=, $4=, $pop63
	i32.load	$push61=, 0($pop62)
	tee_local	$push60=, $5=, $pop61
	i32.eqz 	$push135=, $pop60
	br_if   	2, $pop135      # 2: down to label9
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	block
	block
	i32.eqz 	$push136=, $9
	br_if   	0, $pop136      # 0: down to label13
# BB#5:                                 # %while.body.lr.ph.i.preheader
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push52=, 104
	i32.add 	$push53=, $1, $pop52
	copy_local	$10=, $pop53
.LBB0_6:                                # %while.body.lr.ph.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_7 Depth 4
	block
	loop                            # label15:
	copy_local	$push66=, $5
	tee_local	$push65=, $11=, $pop66
	i32.load	$5=, 0($pop65)
.LBB0_7:                                # %while.body.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        #       Parent Loop BB0_6 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label17:
	copy_local	$push68=, $9
	tee_local	$push67=, $6=, $pop68
	i32.load	$push3=, 0($pop67)
	i32.lt_u	$push4=, $5, $pop3
	br_if   	1, $pop4        # 1: down to label18
# BB#8:                                 # %if.else.i
                                        #   in Loop: Header=BB0_7 Depth=4
	i32.const	$push73=, 28
	i32.add 	$push5=, $10, $pop73
	i32.store	$push72=, 0($pop5), $6
	tee_local	$push71=, $6=, $pop72
	copy_local	$10=, $pop71
	i32.load	$push70=, 28($6)
	tee_local	$push69=, $9=, $pop70
	br_if   	0, $pop69       # 0: up to label17
	br      	4               # 4: down to label14
.LBB0_9:                                # %if.then.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_loop                        # label18:
	i32.const	$push76=, 28
	i32.add 	$push6=, $10, $pop76
	i32.store	$push75=, 0($pop6), $11
	tee_local	$push74=, $11=, $pop75
	i32.load	$5=, 28($pop74)
	i32.eqz 	$push137=, $6
	br_if   	1, $pop137      # 1: down to label16
# BB#10:                                # %if.then.i
                                        #   in Loop: Header=BB0_6 Depth=3
	copy_local	$10=, $11
	copy_local	$9=, $6
	br_if   	0, $5           # 0: up to label15
.LBB0_11:                               # %while.end.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_loop                        # label16:
	i32.const	$push77=, 28
	i32.add 	$9=, $11, $pop77
	block
	br_if   	0, $5           # 0: down to label19
# BB#12:                                # %if.else9.i
                                        #   in Loop: Header=BB0_3 Depth=2
	block
	i32.eqz 	$push138=, $6
	br_if   	0, $pop138      # 0: down to label20
# BB#13:                                # %if.then11.i
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$drop=, 0($9), $6
	br      	4               # 4: down to label12
.LBB0_14:                               # %if.else13.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label20:
	i32.store	$drop=, 0($9), $2
	br      	3               # 3: down to label12
.LBB0_15:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label19:
	copy_local	$push25=, $5
	i32.store	$drop=, 0($9), $pop25
	br      	2               # 2: down to label12
.LBB0_16:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label14:
	i32.const	$push78=, 28
	i32.add 	$push24=, $6, $pop78
	i32.store	$drop=, 0($pop24), $11
	br      	1               # 1: down to label12
.LBB0_17:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label13:
	copy_local	$push23=, $3
	copy_local	$push26=, $5
	i32.store	$drop=, 0($pop23), $pop26
.LBB0_18:                               # %merge_pagelist.exit
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label12:
	i32.const	$push46=, 104
	i32.add 	$push47=, $1, $pop46
	i32.const	$push85=, 28
	i32.add 	$push84=, $pop47, $pop85
	tee_local	$push83=, $10=, $pop84
	i32.load	$9=, 0($pop83)
	i32.store	$6=, 0($4), $2
	i32.const	$push82=, 1
	i32.add 	$push81=, $8, $pop82
	tee_local	$push80=, $8=, $pop81
	i32.const	$push79=, 24
	i32.lt_s	$push7=, $pop80, $pop79
	br_if   	0, $pop7        # 0: up to label10
# BB#19:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label11:
	i32.const	$push86=, 24
	i32.ne  	$push8=, $8, $pop86
	br_if   	6, $pop8        # 6: down to label3
# BB#20:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.ne  	$12=, $9, $6
	i32.load	$push88=, 0($7)
	tee_local	$push87=, $11=, $pop88
	i32.ne  	$2=, $pop87, $6
	i32.const	$push48=, 104
	i32.add 	$push49=, $1, $pop48
	copy_local	$4=, $pop49
	i32.eqz 	$push139=, $9
	br_if   	2, $pop139      # 2: down to label7
# BB#21:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.eqz 	$push140=, $11
	br_if   	3, $pop140      # 3: down to label6
# BB#22:                                # %while.body.lr.ph.i85.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push50=, 104
	i32.add 	$push51=, $1, $pop50
	copy_local	$8=, $pop51
.LBB0_23:                               # %while.body.lr.ph.i85
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_24 Depth 3
	loop                            # label21:
	copy_local	$push90=, $11
	tee_local	$push89=, $4=, $pop90
	i32.load	$11=, 0($pop89)
.LBB0_24:                               # %while.body.i91
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_23 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label23:
	copy_local	$push92=, $9
	tee_local	$push91=, $5=, $pop92
	i32.load	$push10=, 0($pop91)
	i32.lt_u	$push11=, $11, $pop10
	br_if   	1, $pop11       # 1: down to label24
# BB#25:                                # %if.else.i98
                                        #   in Loop: Header=BB0_24 Depth=3
	i32.const	$push97=, 28
	i32.add 	$push12=, $8, $pop97
	i32.store	$push96=, 0($pop12), $5
	tee_local	$push95=, $5=, $pop96
	copy_local	$8=, $pop95
	i32.load	$push94=, 28($5)
	tee_local	$push93=, $9=, $pop94
	br_if   	0, $pop93       # 0: up to label23
	br      	5               # 5: down to label8
.LBB0_26:                               # %if.then.i95
                                        #   in Loop: Header=BB0_23 Depth=2
	end_loop                        # label24:
	i32.ne  	$12=, $5, $6
	i32.const	$push102=, 28
	i32.add 	$push13=, $8, $pop102
	i32.store	$push101=, 0($pop13), $4
	tee_local	$push100=, $9=, $pop101
	i32.load	$push99=, 28($pop100)
	tee_local	$push98=, $11=, $pop99
	i32.ne  	$2=, $pop98, $6
	i32.eqz 	$push141=, $5
	br_if   	6, $pop141      # 6: down to label5
# BB#27:                                # %if.then.i95
                                        #   in Loop: Header=BB0_23 Depth=2
	copy_local	$8=, $9
	copy_local	$9=, $5
	br_if   	0, $11          # 0: up to label21
	br      	6               # 6: down to label5
.LBB0_28:                               # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label22:
	end_block                       # label9:
	i32.store	$drop=, 0($4), $9
	br      	5               # 5: down to label3
.LBB0_29:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label8:
	i32.const	$push103=, 28
	i32.add 	$push28=, $5, $pop103
	i32.store	$drop=, 0($pop28), $4
	br      	3               # 3: down to label4
.LBB0_30:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label7:
	copy_local	$5=, $9
	br      	1               # 1: down to label5
.LBB0_31:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label6:
	copy_local	$5=, $9
.LBB0_32:                               # %while.end.i107
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	i32.const	$push104=, 28
	i32.add 	$9=, $4, $pop104
	block
	i32.eqz 	$push142=, $2
	br_if   	0, $pop142      # 0: down to label25
# BB#33:                                #   in Loop: Header=BB0_2 Depth=1
	copy_local	$push27=, $11
	i32.store	$drop=, 0($9), $pop27
	br      	1               # 1: down to label4
.LBB0_34:                               # %if.else9.i111
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label25:
	block
	i32.eqz 	$push143=, $12
	br_if   	0, $pop143      # 0: down to label26
# BB#35:                                # %if.then11.i112
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.store	$drop=, 0($9), $5
	br      	1               # 1: down to label4
.LBB0_36:                               # %if.else13.i113
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label26:
	i32.store	$drop=, 0($9), $6
.LBB0_37:                               # %merge_pagelist.exit115
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.load	$push14=, 0($10)
	i32.store	$drop=, 0($7), $pop14
.LBB0_38:                               # %while.cond.backedge
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	br_if   	0, $0           # 0: up to label1
# BB#39:                                # %while.end.loopexit
	end_loop                        # label2:
	i32.load	$5=, 0($1)
.LBB0_40:                               # %while.end
	end_block                       # label0:
	i32.const	$11=, 1
.LBB0_41:                               # %for.body15
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_44 Depth 2
                                        #       Child Loop BB0_45 Depth 3
	loop                            # label27:
	i32.const	$push109=, 0
	i32.ne  	$4=, $5, $pop109
	i32.const	$push108=, 2
	i32.shl 	$push15=, $11, $pop108
	i32.add 	$push16=, $1, $pop15
	i32.load	$push107=, 0($pop16)
	tee_local	$push106=, $9=, $pop107
	i32.const	$push105=, 0
	i32.ne  	$2=, $pop106, $pop105
	i32.const	$push38=, 104
	i32.add 	$push39=, $1, $pop38
	copy_local	$8=, $pop39
	block
	block
	block
	block
	i32.eqz 	$push144=, $5
	br_if   	0, $pop144      # 0: down to label32
# BB#42:                                # %for.body15
                                        #   in Loop: Header=BB0_41 Depth=1
	i32.eqz 	$push145=, $9
	br_if   	1, $pop145      # 1: down to label31
# BB#43:                                # %while.body.lr.ph.i47.preheader
                                        #   in Loop: Header=BB0_41 Depth=1
	i32.const	$push40=, 104
	i32.add 	$push41=, $1, $pop40
	copy_local	$10=, $pop41
.LBB0_44:                               # %while.body.lr.ph.i47
                                        #   Parent Loop BB0_41 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_45 Depth 3
	loop                            # label33:
	copy_local	$push111=, $5
	tee_local	$push110=, $8=, $pop111
	i32.load	$5=, 0($pop110)
.LBB0_45:                               # %while.body.i53
                                        #   Parent Loop BB0_41 Depth=1
                                        #     Parent Loop BB0_44 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label35:
	copy_local	$push113=, $9
	tee_local	$push112=, $6=, $pop113
	i32.load	$push17=, 0($pop112)
	i32.lt_u	$push18=, $5, $pop17
	br_if   	1, $pop18       # 1: down to label36
# BB#46:                                # %if.else.i60
                                        #   in Loop: Header=BB0_45 Depth=3
	i32.const	$push118=, 28
	i32.add 	$push19=, $10, $pop118
	i32.store	$push117=, 0($pop19), $6
	tee_local	$push116=, $6=, $pop117
	copy_local	$10=, $pop116
	i32.load	$push115=, 28($6)
	tee_local	$push114=, $9=, $pop115
	br_if   	0, $pop114      # 0: up to label35
	br      	3               # 3: down to label34
.LBB0_47:                               # %if.then.i57
                                        #   in Loop: Header=BB0_44 Depth=2
	end_loop                        # label36:
	i32.const	$push125=, 0
	i32.ne  	$2=, $6, $pop125
	i32.const	$push124=, 28
	i32.add 	$push20=, $10, $pop124
	i32.store	$push123=, 0($pop20), $8
	tee_local	$push122=, $9=, $pop123
	i32.load	$push121=, 28($pop122)
	tee_local	$push120=, $5=, $pop121
	i32.const	$push119=, 0
	i32.ne  	$4=, $pop120, $pop119
	i32.eqz 	$push146=, $6
	br_if   	4, $pop146      # 4: down to label30
# BB#48:                                # %if.then.i57
                                        #   in Loop: Header=BB0_44 Depth=2
	copy_local	$10=, $9
	copy_local	$9=, $6
	br_if   	0, $5           # 0: up to label33
	br      	4               # 4: down to label30
.LBB0_49:                               #   in Loop: Header=BB0_41 Depth=1
	end_loop                        # label34:
	i32.const	$push126=, 28
	i32.add 	$push30=, $6, $pop126
	i32.store	$drop=, 0($pop30), $8
	br      	3               # 3: down to label29
.LBB0_50:                               #   in Loop: Header=BB0_41 Depth=1
	end_block                       # label32:
	copy_local	$6=, $9
	br      	1               # 1: down to label30
.LBB0_51:                               #   in Loop: Header=BB0_41 Depth=1
	end_block                       # label31:
	copy_local	$6=, $9
.LBB0_52:                               # %while.end.i69
                                        #   in Loop: Header=BB0_41 Depth=1
	end_block                       # label30:
	i32.const	$push127=, 28
	i32.add 	$9=, $8, $pop127
	block
	i32.eqz 	$push147=, $4
	br_if   	0, $pop147      # 0: down to label37
# BB#53:                                #   in Loop: Header=BB0_41 Depth=1
	copy_local	$push29=, $5
	i32.store	$drop=, 0($9), $pop29
	br      	1               # 1: down to label29
.LBB0_54:                               # %if.else9.i73
                                        #   in Loop: Header=BB0_41 Depth=1
	end_block                       # label37:
	block
	i32.eqz 	$push148=, $2
	br_if   	0, $pop148      # 0: down to label38
# BB#55:                                # %if.then11.i74
                                        #   in Loop: Header=BB0_41 Depth=1
	i32.store	$drop=, 0($9), $6
	br      	1               # 1: down to label29
.LBB0_56:                               # %if.else13.i75
                                        #   in Loop: Header=BB0_41 Depth=1
	end_block                       # label38:
	i32.const	$push128=, 0
	i32.store	$drop=, 0($9), $pop128
.LBB0_57:                               # %merge_pagelist.exit77
                                        #   in Loop: Header=BB0_41 Depth=1
	end_block                       # label29:
	i32.const	$push42=, 104
	i32.add 	$push43=, $1, $pop42
	i32.const	$push133=, 28
	i32.add 	$push22=, $pop43, $pop133
	i32.load	$5=, 0($pop22)
	i32.const	$push132=, 1
	i32.add 	$push131=, $11, $pop132
	tee_local	$push130=, $11=, $pop131
	i32.const	$push129=, 25
	i32.ne  	$push21=, $pop130, $pop129
	br_if   	0, $pop21       # 0: up to label27
# BB#58:                                # %for.end20
	end_loop                        # label28:
	i32.const	$push37=, 0
	i32.const	$push35=, 144
	i32.add 	$push36=, $1, $pop35
	i32.store	$drop=, __stack_pointer($pop37), $pop36
	copy_local	$push149=, $5
                                        # fallthrough-return: $pop149
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
	i32.const	$push22=, 0
	i32.const	$push19=, 0
	i32.load	$push20=, __stack_pointer($pop19)
	i32.const	$push21=, 208
	i32.sub 	$push26=, $pop20, $pop21
	i32.store	$push30=, __stack_pointer($pop22), $pop26
	tee_local	$push29=, $1=, $pop30
	i32.const	$push2=, 68
	i32.add 	$push3=, $pop29, $pop2
	i32.const	$push0=, 80
	i32.add 	$push1=, $1, $pop0
	i32.store	$drop=, 0($pop3), $pop1
	i32.const	$push6=, 108
	i32.add 	$push7=, $1, $pop6
	i32.const	$push4=, 120
	i32.add 	$push5=, $1, $pop4
	i32.store	$drop=, 0($pop7), $pop5
	i32.const	$push8=, 5
	i32.store	$drop=, 0($1), $pop8
	i32.const	$push9=, 4
	i32.store	$drop=, 40($1), $pop9
	i32.const	$push10=, 1
	i32.store	$drop=, 80($1), $pop10
	i32.const	$push11=, 3
	i32.store	$drop=, 120($1), $pop11
	i32.const	$push12=, 40
	i32.add 	$push13=, $1, $pop12
	i32.store	$drop=, 28($1), $pop13
	i32.const	$push14=, 148
	i32.add 	$push15=, $1, $pop14
	i32.const	$push16=, 0
	i32.store	$0=, 0($pop15), $pop16
	block
	i32.call	$push28=, sort_pagelist@FUNCTION, $1
	tee_local	$push27=, $2=, $pop28
	i32.load	$push17=, 28($2)
	i32.eq  	$push18=, $pop27, $pop17
	br_if   	0, $pop18       # 0: down to label39
# BB#1:                                 # %if.end
	i32.const	$push25=, 0
	i32.const	$push23=, 208
	i32.add 	$push24=, $1, $pop23
	i32.store	$drop=, __stack_pointer($pop25), $pop24
	return  	$0
.LBB1_2:                                # %if.then
	end_block                       # label39:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
