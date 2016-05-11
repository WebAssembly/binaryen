	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr33870.c"
	.section	.text.sort_pagelist,"ax",@progbits
	.hidden	sort_pagelist
	.globl	sort_pagelist
	.type	sort_pagelist,@function
sort_pagelist:                          # @sort_pagelist
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push33=, __stack_pointer
	i32.const	$push30=, __stack_pointer
	i32.load	$push31=, 0($pop30)
	i32.const	$push32=, 144
	i32.sub 	$push53=, $pop31, $pop32
	i32.store	$push0=, 0($pop33), $pop53
	i32.const	$push54=, 0
	i32.const	$push1=, 100
	i32.call	$1=, memset@FUNCTION, $pop0, $pop54, $pop1
	i32.const	$10=, 0
	block
	i32.const	$push129=, 0
	i32.eq  	$push130=, $0, $pop129
	br_if   	0, $pop130      # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push9=, 96
	i32.add 	$5=, $1, $pop9
	i32.const	$push43=, 104
	i32.add 	$push44=, $1, $pop43
	i32.const	$push55=, 28
	i32.add 	$3=, $pop44, $pop55
.LBB0_2:                                # %while.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
                                        #       Child Loop BB0_6 Depth 3
                                        #         Child Loop BB0_7 Depth 4
                                        #     Child Loop BB0_23 Depth 2
                                        #       Child Loop BB0_24 Depth 3
	loop                            # label1:
	copy_local	$push58=, $0
	tee_local	$push57=, $11=, $pop58
	i32.load	$0=, 28($pop57)
	i32.const	$push56=, 0
	i32.store	$2=, 28($11), $pop56
	i32.const	$6=, 0
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
	loop                            # label8:
	i32.const	$push63=, 2
	i32.shl 	$push2=, $6, $pop63
	i32.add 	$push62=, $1, $pop2
	tee_local	$push61=, $8=, $pop62
	i32.load	$push60=, 0($pop61)
	tee_local	$push59=, $10=, $pop60
	i32.const	$push131=, 0
	i32.eq  	$push132=, $pop59, $pop131
	br_if   	2, $pop132      # 2: down to label7
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	block
	block
	i32.const	$push133=, 0
	i32.eq  	$push134=, $11, $pop133
	br_if   	0, $pop134      # 0: down to label11
# BB#5:                                 # %while.body.lr.ph.i.preheader
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push51=, 104
	i32.add 	$push52=, $1, $pop51
	copy_local	$7=, $pop52
.LBB0_6:                                # %while.body.lr.ph.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_7 Depth 4
	block
	loop                            # label13:
	copy_local	$push65=, $10
	tee_local	$push64=, $9=, $pop65
	i32.load	$4=, 0($pop64)
	copy_local	$11=, $11
.LBB0_7:                                # %while.body.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        #       Parent Loop BB0_6 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label15:
	copy_local	$push67=, $11
	tee_local	$push66=, $11=, $pop67
	i32.load	$push3=, 0($pop66)
	i32.lt_u	$push4=, $4, $pop3
	br_if   	1, $pop4        # 1: down to label16
# BB#8:                                 # %if.else.i
                                        #   in Loop: Header=BB0_7 Depth=4
	i32.const	$push72=, 28
	i32.add 	$push5=, $7, $pop72
	i32.store	$push71=, 0($pop5), $11
	tee_local	$push70=, $10=, $pop71
	copy_local	$7=, $pop70
	i32.load	$push69=, 28($10)
	tee_local	$push68=, $11=, $pop69
	br_if   	0, $pop68       # 0: up to label15
	br      	4               # 4: down to label12
.LBB0_9:                                # %if.then.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_loop                        # label16:
	i32.const	$push75=, 28
	i32.add 	$push6=, $7, $pop75
	i32.store	$push74=, 0($pop6), $9
	tee_local	$push73=, $4=, $pop74
	i32.load	$10=, 28($pop73)
	i32.const	$push135=, 0
	i32.eq  	$push136=, $11, $pop135
	br_if   	1, $pop136      # 1: down to label14
# BB#10:                                # %if.then.i
                                        #   in Loop: Header=BB0_6 Depth=3
	copy_local	$7=, $4
	br_if   	0, $10          # 0: up to label13
.LBB0_11:                               # %while.end.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_loop                        # label14:
	i32.const	$push76=, 28
	i32.add 	$7=, $4, $pop76
	block
	br_if   	0, $10          # 0: down to label17
# BB#12:                                # %if.else9.i
                                        #   in Loop: Header=BB0_3 Depth=2
	block
	i32.const	$push137=, 0
	i32.eq  	$push138=, $11, $pop137
	br_if   	0, $pop138      # 0: down to label18
# BB#13:                                # %if.then11.i
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$discard=, 0($7), $11
	br      	4               # 4: down to label10
.LBB0_14:                               # %if.else13.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label18:
	i32.store	$discard=, 0($7), $2
	br      	3               # 3: down to label10
.LBB0_15:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label17:
	copy_local	$push25=, $10
	i32.store	$discard=, 0($7), $pop25
	br      	2               # 2: down to label10
.LBB0_16:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label12:
	i32.const	$push77=, 28
	i32.add 	$push24=, $10, $pop77
	i32.store	$discard=, 0($pop24), $9
	br      	1               # 1: down to label10
.LBB0_17:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label11:
	copy_local	$11=, $10
	copy_local	$push23=, $3
	i32.store	$discard=, 0($pop23), $11
.LBB0_18:                               # %merge_pagelist.exit
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label10:
	i32.const	$push45=, 104
	i32.add 	$push46=, $1, $pop45
	i32.const	$push82=, 28
	i32.add 	$push81=, $pop46, $pop82
	tee_local	$push80=, $10=, $pop81
	i32.load	$11=, 0($pop80)
	i32.store	$7=, 0($8), $2
	i32.const	$push79=, 1
	i32.add 	$6=, $6, $pop79
	i32.const	$push78=, 24
	i32.lt_s	$push7=, $6, $pop78
	br_if   	0, $pop7        # 0: up to label8
# BB#19:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label9:
	i32.const	$push83=, 24
	i32.ne  	$push8=, $6, $pop83
	br_if   	4, $pop8        # 4: down to label3
# BB#20:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$push85=, 0($5)
	tee_local	$push84=, $6=, $pop85
	i32.ne  	$9=, $pop84, $7
	i32.ne  	$2=, $11, $7
	i32.const	$push47=, 104
	i32.add 	$push48=, $1, $pop47
	copy_local	$8=, $pop48
	block
	i32.const	$push139=, 0
	i32.eq  	$push140=, $11, $pop139
	br_if   	0, $pop140      # 0: down to label19
# BB#21:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push141=, 0
	i32.eq  	$push142=, $6, $pop141
	br_if   	0, $pop142      # 0: down to label19
# BB#22:                                # %while.body.lr.ph.i85.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push49=, 104
	i32.add 	$push50=, $1, $pop49
	copy_local	$4=, $pop50
.LBB0_23:                               # %while.body.lr.ph.i85
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_24 Depth 3
	loop                            # label20:
	copy_local	$push87=, $6
	tee_local	$push86=, $8=, $pop87
	i32.load	$9=, 0($pop86)
	copy_local	$11=, $11
.LBB0_24:                               # %while.body.i91
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_23 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label22:
	copy_local	$push89=, $11
	tee_local	$push88=, $11=, $pop89
	i32.load	$push10=, 0($pop88)
	i32.lt_u	$push11=, $9, $pop10
	br_if   	1, $pop11       # 1: down to label23
# BB#25:                                # %if.else.i98
                                        #   in Loop: Header=BB0_24 Depth=3
	i32.const	$push94=, 28
	i32.add 	$push12=, $4, $pop94
	i32.store	$push93=, 0($pop12), $11
	tee_local	$push92=, $6=, $pop93
	copy_local	$4=, $pop92
	i32.load	$push91=, 28($6)
	tee_local	$push90=, $11=, $pop91
	br_if   	0, $pop90       # 0: up to label22
	br      	6               # 6: down to label6
.LBB0_26:                               # %if.then.i95
                                        #   in Loop: Header=BB0_23 Depth=2
	end_loop                        # label23:
	i32.const	$push99=, 28
	i32.add 	$push13=, $4, $pop99
	i32.store	$push98=, 0($pop13), $8
	tee_local	$push97=, $4=, $pop98
	i32.load	$push96=, 28($pop97)
	tee_local	$push95=, $6=, $pop96
	i32.ne  	$9=, $pop95, $7
	i32.ne  	$2=, $11, $7
	i32.const	$push143=, 0
	i32.eq  	$push144=, $11, $pop143
	br_if   	1, $pop144      # 1: down to label21
# BB#27:                                # %if.then.i95
                                        #   in Loop: Header=BB0_23 Depth=2
	copy_local	$4=, $4
	br_if   	0, $6           # 0: up to label20
.LBB0_28:                               # %while.end.i107
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label21:
	end_block                       # label19:
	i32.const	$push100=, 28
	i32.add 	$4=, $8, $pop100
	i32.const	$push145=, 0
	i32.eq  	$push146=, $9, $pop145
	br_if   	2, $pop146      # 2: down to label5
# BB#29:                                #   in Loop: Header=BB0_2 Depth=1
	copy_local	$push26=, $6
	i32.store	$discard=, 0($4), $pop26
	br      	3               # 3: down to label4
.LBB0_30:                               # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label7:
	i32.store	$discard=, 0($8), $11
	br      	3               # 3: down to label3
.LBB0_31:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label6:
	i32.const	$push101=, 28
	i32.add 	$push27=, $6, $pop101
	i32.store	$discard=, 0($pop27), $8
	br      	1               # 1: down to label4
.LBB0_32:                               # %if.else9.i111
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	block
	i32.const	$push147=, 0
	i32.eq  	$push148=, $2, $pop147
	br_if   	0, $pop148      # 0: down to label24
# BB#33:                                # %if.then11.i112
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.store	$discard=, 0($4), $11
	br      	1               # 1: down to label4
.LBB0_34:                               # %if.else13.i113
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label24:
	i32.store	$discard=, 0($4), $7
.LBB0_35:                               # %merge_pagelist.exit115
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.load	$push14=, 0($10)
	i32.store	$discard=, 0($5), $pop14
.LBB0_36:                               # %while.cond.backedge
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	br_if   	0, $0           # 0: up to label1
# BB#37:                                # %while.end.loopexit
	end_loop                        # label2:
	i32.load	$10=, 0($1)
.LBB0_38:                               # %while.end
	end_block                       # label0:
	i32.const	$6=, 1
.LBB0_39:                               # %for.body15
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_42 Depth 2
                                        #       Child Loop BB0_43 Depth 3
	loop                            # label25:
	i32.const	$push106=, 0
	i32.ne  	$4=, $10, $pop106
	i32.const	$push105=, 2
	i32.shl 	$push15=, $6, $pop105
	i32.add 	$push16=, $1, $pop15
	i32.load	$push104=, 0($pop16)
	tee_local	$push103=, $11=, $pop104
	i32.const	$push102=, 0
	i32.ne  	$8=, $pop103, $pop102
	i32.const	$push37=, 104
	i32.add 	$push38=, $1, $pop37
	copy_local	$9=, $pop38
	block
	block
	block
	block
	i32.const	$push149=, 0
	i32.eq  	$push150=, $10, $pop149
	br_if   	0, $pop150      # 0: down to label30
# BB#40:                                # %for.body15
                                        #   in Loop: Header=BB0_39 Depth=1
	i32.const	$push151=, 0
	i32.eq  	$push152=, $11, $pop151
	br_if   	0, $pop152      # 0: down to label30
# BB#41:                                # %while.body.lr.ph.i47.preheader
                                        #   in Loop: Header=BB0_39 Depth=1
	i32.const	$push39=, 104
	i32.add 	$push40=, $1, $pop39
	copy_local	$7=, $pop40
.LBB0_42:                               # %while.body.lr.ph.i47
                                        #   Parent Loop BB0_39 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_43 Depth 3
	loop                            # label31:
	copy_local	$push108=, $10
	tee_local	$push107=, $9=, $pop108
	i32.load	$4=, 0($pop107)
	copy_local	$11=, $11
.LBB0_43:                               # %while.body.i53
                                        #   Parent Loop BB0_39 Depth=1
                                        #     Parent Loop BB0_42 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label33:
	copy_local	$push110=, $11
	tee_local	$push109=, $11=, $pop110
	i32.load	$push17=, 0($pop109)
	i32.lt_u	$push18=, $4, $pop17
	br_if   	1, $pop18       # 1: down to label34
# BB#44:                                # %if.else.i60
                                        #   in Loop: Header=BB0_43 Depth=3
	i32.const	$push115=, 28
	i32.add 	$push19=, $7, $pop115
	i32.store	$push114=, 0($pop19), $11
	tee_local	$push113=, $10=, $pop114
	copy_local	$7=, $pop113
	i32.load	$push112=, 28($10)
	tee_local	$push111=, $11=, $pop112
	br_if   	0, $pop111      # 0: up to label33
	br      	5               # 5: down to label29
.LBB0_45:                               # %if.then.i57
                                        #   in Loop: Header=BB0_42 Depth=2
	end_loop                        # label34:
	i32.const	$push122=, 28
	i32.add 	$push20=, $7, $pop122
	i32.store	$push121=, 0($pop20), $9
	tee_local	$push120=, $7=, $pop121
	i32.load	$push119=, 28($pop120)
	tee_local	$push118=, $10=, $pop119
	i32.const	$push117=, 0
	i32.ne  	$4=, $pop118, $pop117
	i32.const	$push116=, 0
	i32.ne  	$8=, $11, $pop116
	i32.const	$push153=, 0
	i32.eq  	$push154=, $11, $pop153
	br_if   	1, $pop154      # 1: down to label32
# BB#46:                                # %if.then.i57
                                        #   in Loop: Header=BB0_42 Depth=2
	copy_local	$7=, $7
	br_if   	0, $10          # 0: up to label31
.LBB0_47:                               # %while.end.i69
                                        #   in Loop: Header=BB0_39 Depth=1
	end_loop                        # label32:
	end_block                       # label30:
	i32.const	$push123=, 28
	i32.add 	$7=, $9, $pop123
	i32.const	$push155=, 0
	i32.eq  	$push156=, $4, $pop155
	br_if   	1, $pop156      # 1: down to label28
# BB#48:                                #   in Loop: Header=BB0_39 Depth=1
	copy_local	$push28=, $10
	i32.store	$discard=, 0($7), $pop28
	br      	2               # 2: down to label27
.LBB0_49:                               #   in Loop: Header=BB0_39 Depth=1
	end_block                       # label29:
	i32.const	$push124=, 28
	i32.add 	$push29=, $10, $pop124
	i32.store	$discard=, 0($pop29), $9
	br      	1               # 1: down to label27
.LBB0_50:                               # %if.else9.i73
                                        #   in Loop: Header=BB0_39 Depth=1
	end_block                       # label28:
	block
	i32.const	$push157=, 0
	i32.eq  	$push158=, $8, $pop157
	br_if   	0, $pop158      # 0: down to label35
# BB#51:                                # %if.then11.i74
                                        #   in Loop: Header=BB0_39 Depth=1
	i32.store	$discard=, 0($7), $11
	br      	1               # 1: down to label27
.LBB0_52:                               # %if.else13.i75
                                        #   in Loop: Header=BB0_39 Depth=1
	end_block                       # label35:
	i32.const	$push125=, 0
	i32.store	$discard=, 0($7), $pop125
.LBB0_53:                               # %merge_pagelist.exit77
                                        #   in Loop: Header=BB0_39 Depth=1
	end_block                       # label27:
	i32.const	$push41=, 104
	i32.add 	$push42=, $1, $pop41
	i32.const	$push128=, 28
	i32.add 	$push21=, $pop42, $pop128
	i32.load	$10=, 0($pop21)
	i32.const	$push127=, 1
	i32.add 	$6=, $6, $pop127
	i32.const	$push126=, 25
	i32.ne  	$push22=, $6, $pop126
	br_if   	0, $pop22       # 0: up to label25
# BB#54:                                # %for.end20
	end_loop                        # label26:
	i32.const	$push36=, __stack_pointer
	i32.const	$push34=, 144
	i32.add 	$push35=, $1, $pop34
	i32.store	$discard=, 0($pop36), $pop35
	return  	$10
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
	i32.const	$push22=, __stack_pointer
	i32.const	$push19=, __stack_pointer
	i32.load	$push20=, 0($pop19)
	i32.const	$push21=, 208
	i32.sub 	$push26=, $pop20, $pop21
	i32.store	$push28=, 0($pop22), $pop26
	tee_local	$push27=, $2=, $pop28
	i32.const	$push6=, 68
	i32.add 	$push7=, $pop27, $pop6
	i32.const	$push4=, 80
	i32.add 	$push5=, $2, $pop4
	i32.store	$discard=, 0($pop7), $pop5
	i32.const	$push11=, 108
	i32.add 	$push12=, $2, $pop11
	i32.const	$push9=, 120
	i32.add 	$push10=, $2, $pop9
	i32.store	$discard=, 0($pop12), $pop10
	i32.const	$push0=, 5
	i32.store	$discard=, 0($2), $pop0
	i32.const	$push1=, 40
	i32.add 	$push2=, $2, $pop1
	i32.store	$discard=, 28($2), $pop2
	i32.const	$push3=, 4
	i32.store	$discard=, 40($2), $pop3
	i32.const	$push8=, 1
	i32.store	$discard=, 80($2), $pop8
	i32.const	$push13=, 3
	i32.store	$discard=, 120($2), $pop13
	i32.const	$push14=, 148
	i32.add 	$push15=, $2, $pop14
	i32.const	$push16=, 0
	i32.store	$0=, 0($pop15), $pop16
	i32.call	$1=, sort_pagelist@FUNCTION, $2
	block
	i32.load	$push17=, 28($1)
	i32.eq  	$push18=, $1, $pop17
	br_if   	0, $pop18       # 0: down to label36
# BB#1:                                 # %if.end
	i32.const	$push25=, __stack_pointer
	i32.const	$push23=, 208
	i32.add 	$push24=, $2, $pop23
	i32.store	$discard=, 0($pop25), $pop24
	return  	$0
.LBB1_2:                                # %if.then
	end_block                       # label36:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
