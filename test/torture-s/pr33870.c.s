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
	i32.const	$push34=, __stack_pointer
	i32.const	$push31=, __stack_pointer
	i32.load	$push32=, 0($pop31)
	i32.const	$push33=, 144
	i32.sub 	$push54=, $pop32, $pop33
	i32.store	$push0=, 0($pop34), $pop54
	i32.const	$push55=, 0
	i32.const	$push1=, 100
	i32.call	$1=, memset@FUNCTION, $pop0, $pop55, $pop1
	i32.const	$10=, 0
	block
	i32.eqz 	$push130=, $0
	br_if   	0, $pop130      # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push9=, 96
	i32.add 	$5=, $1, $pop9
	i32.const	$push44=, 104
	i32.add 	$push45=, $1, $pop44
	i32.const	$push56=, 28
	i32.add 	$3=, $pop45, $pop56
.LBB0_2:                                # %while.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
                                        #       Child Loop BB0_6 Depth 3
                                        #         Child Loop BB0_7 Depth 4
                                        #     Child Loop BB0_23 Depth 2
                                        #       Child Loop BB0_24 Depth 3
	loop                            # label1:
	copy_local	$push59=, $0
	tee_local	$push58=, $11=, $pop59
	i32.load	$0=, 28($pop58)
	i32.const	$push57=, 0
	i32.store	$2=, 28($11), $pop57
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
	i32.const	$push64=, 2
	i32.shl 	$push2=, $6, $pop64
	i32.add 	$push63=, $1, $pop2
	tee_local	$push62=, $8=, $pop63
	i32.load	$push61=, 0($pop62)
	tee_local	$push60=, $10=, $pop61
	i32.eqz 	$push131=, $pop60
	br_if   	2, $pop131      # 2: down to label7
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	block
	block
	i32.eqz 	$push132=, $11
	br_if   	0, $pop132      # 0: down to label11
# BB#5:                                 # %while.body.lr.ph.i.preheader
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push52=, 104
	i32.add 	$push53=, $1, $pop52
	copy_local	$7=, $pop53
.LBB0_6:                                # %while.body.lr.ph.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_7 Depth 4
	block
	loop                            # label13:
	copy_local	$push66=, $10
	tee_local	$push65=, $9=, $pop66
	i32.load	$4=, 0($pop65)
	copy_local	$11=, $11
.LBB0_7:                                # %while.body.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        #       Parent Loop BB0_6 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label15:
	copy_local	$push68=, $11
	tee_local	$push67=, $11=, $pop68
	i32.load	$push3=, 0($pop67)
	i32.lt_u	$push4=, $4, $pop3
	br_if   	1, $pop4        # 1: down to label16
# BB#8:                                 # %if.else.i
                                        #   in Loop: Header=BB0_7 Depth=4
	i32.const	$push73=, 28
	i32.add 	$push5=, $7, $pop73
	i32.store	$push72=, 0($pop5), $11
	tee_local	$push71=, $10=, $pop72
	copy_local	$7=, $pop71
	i32.load	$push70=, 28($10)
	tee_local	$push69=, $11=, $pop70
	br_if   	0, $pop69       # 0: up to label15
	br      	4               # 4: down to label12
.LBB0_9:                                # %if.then.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_loop                        # label16:
	i32.const	$push76=, 28
	i32.add 	$push6=, $7, $pop76
	i32.store	$push75=, 0($pop6), $9
	tee_local	$push74=, $4=, $pop75
	i32.load	$10=, 28($pop74)
	i32.eqz 	$push133=, $11
	br_if   	1, $pop133      # 1: down to label14
# BB#10:                                # %if.then.i
                                        #   in Loop: Header=BB0_6 Depth=3
	copy_local	$7=, $4
	br_if   	0, $10          # 0: up to label13
.LBB0_11:                               # %while.end.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_loop                        # label14:
	i32.const	$push77=, 28
	i32.add 	$7=, $4, $pop77
	block
	br_if   	0, $10          # 0: down to label17
# BB#12:                                # %if.else9.i
                                        #   in Loop: Header=BB0_3 Depth=2
	block
	i32.eqz 	$push134=, $11
	br_if   	0, $pop134      # 0: down to label18
# BB#13:                                # %if.then11.i
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$drop=, 0($7), $11
	br      	4               # 4: down to label10
.LBB0_14:                               # %if.else13.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label18:
	i32.store	$drop=, 0($7), $2
	br      	3               # 3: down to label10
.LBB0_15:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label17:
	copy_local	$push25=, $10
	i32.store	$drop=, 0($7), $pop25
	br      	2               # 2: down to label10
.LBB0_16:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label12:
	i32.const	$push78=, 28
	i32.add 	$push24=, $10, $pop78
	i32.store	$drop=, 0($pop24), $9
	br      	1               # 1: down to label10
.LBB0_17:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label11:
	copy_local	$push23=, $3
	copy_local	$push26=, $10
	i32.store	$drop=, 0($pop23), $pop26
.LBB0_18:                               # %merge_pagelist.exit
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label10:
	i32.const	$push46=, 104
	i32.add 	$push47=, $1, $pop46
	i32.const	$push83=, 28
	i32.add 	$push82=, $pop47, $pop83
	tee_local	$push81=, $10=, $pop82
	i32.load	$11=, 0($pop81)
	i32.store	$7=, 0($8), $2
	i32.const	$push80=, 1
	i32.add 	$6=, $6, $pop80
	i32.const	$push79=, 24
	i32.lt_s	$push7=, $6, $pop79
	br_if   	0, $pop7        # 0: up to label8
# BB#19:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label9:
	i32.const	$push84=, 24
	i32.ne  	$push8=, $6, $pop84
	br_if   	4, $pop8        # 4: down to label3
# BB#20:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$push86=, 0($5)
	tee_local	$push85=, $6=, $pop86
	i32.ne  	$9=, $pop85, $7
	i32.ne  	$2=, $11, $7
	i32.const	$push48=, 104
	i32.add 	$push49=, $1, $pop48
	copy_local	$8=, $pop49
	block
	i32.eqz 	$push135=, $11
	br_if   	0, $pop135      # 0: down to label19
# BB#21:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.eqz 	$push136=, $6
	br_if   	0, $pop136      # 0: down to label19
# BB#22:                                # %while.body.lr.ph.i85.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push50=, 104
	i32.add 	$push51=, $1, $pop50
	copy_local	$4=, $pop51
.LBB0_23:                               # %while.body.lr.ph.i85
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_24 Depth 3
	loop                            # label20:
	copy_local	$push88=, $6
	tee_local	$push87=, $8=, $pop88
	i32.load	$9=, 0($pop87)
	copy_local	$11=, $11
.LBB0_24:                               # %while.body.i91
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_23 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label22:
	copy_local	$push90=, $11
	tee_local	$push89=, $11=, $pop90
	i32.load	$push10=, 0($pop89)
	i32.lt_u	$push11=, $9, $pop10
	br_if   	1, $pop11       # 1: down to label23
# BB#25:                                # %if.else.i98
                                        #   in Loop: Header=BB0_24 Depth=3
	i32.const	$push95=, 28
	i32.add 	$push12=, $4, $pop95
	i32.store	$push94=, 0($pop12), $11
	tee_local	$push93=, $6=, $pop94
	copy_local	$4=, $pop93
	i32.load	$push92=, 28($6)
	tee_local	$push91=, $11=, $pop92
	br_if   	0, $pop91       # 0: up to label22
	br      	6               # 6: down to label6
.LBB0_26:                               # %if.then.i95
                                        #   in Loop: Header=BB0_23 Depth=2
	end_loop                        # label23:
	i32.const	$push100=, 28
	i32.add 	$push13=, $4, $pop100
	i32.store	$push99=, 0($pop13), $8
	tee_local	$push98=, $4=, $pop99
	i32.load	$push97=, 28($pop98)
	tee_local	$push96=, $6=, $pop97
	i32.ne  	$9=, $pop96, $7
	i32.ne  	$2=, $11, $7
	i32.eqz 	$push137=, $11
	br_if   	1, $pop137      # 1: down to label21
# BB#27:                                # %if.then.i95
                                        #   in Loop: Header=BB0_23 Depth=2
	copy_local	$4=, $4
	br_if   	0, $6           # 0: up to label20
.LBB0_28:                               # %while.end.i107
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label21:
	end_block                       # label19:
	i32.const	$push101=, 28
	i32.add 	$4=, $8, $pop101
	i32.eqz 	$push138=, $9
	br_if   	2, $pop138      # 2: down to label5
# BB#29:                                #   in Loop: Header=BB0_2 Depth=1
	copy_local	$push27=, $6
	i32.store	$drop=, 0($4), $pop27
	br      	3               # 3: down to label4
.LBB0_30:                               # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label7:
	i32.store	$drop=, 0($8), $11
	br      	3               # 3: down to label3
.LBB0_31:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label6:
	i32.const	$push102=, 28
	i32.add 	$push28=, $6, $pop102
	i32.store	$drop=, 0($pop28), $8
	br      	1               # 1: down to label4
.LBB0_32:                               # %if.else9.i111
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	block
	i32.eqz 	$push139=, $2
	br_if   	0, $pop139      # 0: down to label24
# BB#33:                                # %if.then11.i112
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.store	$drop=, 0($4), $11
	br      	1               # 1: down to label4
.LBB0_34:                               # %if.else13.i113
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label24:
	i32.store	$drop=, 0($4), $7
.LBB0_35:                               # %merge_pagelist.exit115
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.load	$push14=, 0($10)
	i32.store	$drop=, 0($5), $pop14
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
	i32.const	$push107=, 0
	i32.ne  	$4=, $10, $pop107
	i32.const	$push106=, 2
	i32.shl 	$push15=, $6, $pop106
	i32.add 	$push16=, $1, $pop15
	i32.load	$push105=, 0($pop16)
	tee_local	$push104=, $11=, $pop105
	i32.const	$push103=, 0
	i32.ne  	$8=, $pop104, $pop103
	i32.const	$push38=, 104
	i32.add 	$push39=, $1, $pop38
	copy_local	$9=, $pop39
	block
	block
	block
	block
	i32.eqz 	$push140=, $10
	br_if   	0, $pop140      # 0: down to label30
# BB#40:                                # %for.body15
                                        #   in Loop: Header=BB0_39 Depth=1
	i32.eqz 	$push141=, $11
	br_if   	0, $pop141      # 0: down to label30
# BB#41:                                # %while.body.lr.ph.i47.preheader
                                        #   in Loop: Header=BB0_39 Depth=1
	i32.const	$push40=, 104
	i32.add 	$push41=, $1, $pop40
	copy_local	$7=, $pop41
.LBB0_42:                               # %while.body.lr.ph.i47
                                        #   Parent Loop BB0_39 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_43 Depth 3
	loop                            # label31:
	copy_local	$push109=, $10
	tee_local	$push108=, $9=, $pop109
	i32.load	$4=, 0($pop108)
	copy_local	$11=, $11
.LBB0_43:                               # %while.body.i53
                                        #   Parent Loop BB0_39 Depth=1
                                        #     Parent Loop BB0_42 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label33:
	copy_local	$push111=, $11
	tee_local	$push110=, $11=, $pop111
	i32.load	$push17=, 0($pop110)
	i32.lt_u	$push18=, $4, $pop17
	br_if   	1, $pop18       # 1: down to label34
# BB#44:                                # %if.else.i60
                                        #   in Loop: Header=BB0_43 Depth=3
	i32.const	$push116=, 28
	i32.add 	$push19=, $7, $pop116
	i32.store	$push115=, 0($pop19), $11
	tee_local	$push114=, $10=, $pop115
	copy_local	$7=, $pop114
	i32.load	$push113=, 28($10)
	tee_local	$push112=, $11=, $pop113
	br_if   	0, $pop112      # 0: up to label33
	br      	5               # 5: down to label29
.LBB0_45:                               # %if.then.i57
                                        #   in Loop: Header=BB0_42 Depth=2
	end_loop                        # label34:
	i32.const	$push123=, 28
	i32.add 	$push20=, $7, $pop123
	i32.store	$push122=, 0($pop20), $9
	tee_local	$push121=, $7=, $pop122
	i32.load	$push120=, 28($pop121)
	tee_local	$push119=, $10=, $pop120
	i32.const	$push118=, 0
	i32.ne  	$4=, $pop119, $pop118
	i32.const	$push117=, 0
	i32.ne  	$8=, $11, $pop117
	i32.eqz 	$push142=, $11
	br_if   	1, $pop142      # 1: down to label32
# BB#46:                                # %if.then.i57
                                        #   in Loop: Header=BB0_42 Depth=2
	copy_local	$7=, $7
	br_if   	0, $10          # 0: up to label31
.LBB0_47:                               # %while.end.i69
                                        #   in Loop: Header=BB0_39 Depth=1
	end_loop                        # label32:
	end_block                       # label30:
	i32.const	$push124=, 28
	i32.add 	$7=, $9, $pop124
	i32.eqz 	$push143=, $4
	br_if   	1, $pop143      # 1: down to label28
# BB#48:                                #   in Loop: Header=BB0_39 Depth=1
	copy_local	$push29=, $10
	i32.store	$drop=, 0($7), $pop29
	br      	2               # 2: down to label27
.LBB0_49:                               #   in Loop: Header=BB0_39 Depth=1
	end_block                       # label29:
	i32.const	$push125=, 28
	i32.add 	$push30=, $10, $pop125
	i32.store	$drop=, 0($pop30), $9
	br      	1               # 1: down to label27
.LBB0_50:                               # %if.else9.i73
                                        #   in Loop: Header=BB0_39 Depth=1
	end_block                       # label28:
	block
	i32.eqz 	$push144=, $8
	br_if   	0, $pop144      # 0: down to label35
# BB#51:                                # %if.then11.i74
                                        #   in Loop: Header=BB0_39 Depth=1
	i32.store	$drop=, 0($7), $11
	br      	1               # 1: down to label27
.LBB0_52:                               # %if.else13.i75
                                        #   in Loop: Header=BB0_39 Depth=1
	end_block                       # label35:
	i32.const	$push126=, 0
	i32.store	$drop=, 0($7), $pop126
.LBB0_53:                               # %merge_pagelist.exit77
                                        #   in Loop: Header=BB0_39 Depth=1
	end_block                       # label27:
	i32.const	$push42=, 104
	i32.add 	$push43=, $1, $pop42
	i32.const	$push129=, 28
	i32.add 	$push21=, $pop43, $pop129
	i32.load	$10=, 0($pop21)
	i32.const	$push128=, 1
	i32.add 	$6=, $6, $pop128
	i32.const	$push127=, 25
	i32.ne  	$push22=, $6, $pop127
	br_if   	0, $pop22       # 0: up to label25
# BB#54:                                # %for.end20
	end_loop                        # label26:
	i32.const	$push37=, __stack_pointer
	i32.const	$push35=, 144
	i32.add 	$push36=, $1, $pop35
	i32.store	$drop=, 0($pop37), $pop36
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
	i32.store	$drop=, 0($pop7), $pop5
	i32.const	$push11=, 108
	i32.add 	$push12=, $2, $pop11
	i32.const	$push9=, 120
	i32.add 	$push10=, $2, $pop9
	i32.store	$drop=, 0($pop12), $pop10
	i32.const	$push0=, 5
	i32.store	$drop=, 0($2), $pop0
	i32.const	$push1=, 40
	i32.add 	$push2=, $2, $pop1
	i32.store	$drop=, 28($2), $pop2
	i32.const	$push3=, 4
	i32.store	$drop=, 40($2), $pop3
	i32.const	$push8=, 1
	i32.store	$drop=, 80($2), $pop8
	i32.const	$push13=, 3
	i32.store	$drop=, 120($2), $pop13
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
	i32.store	$drop=, 0($pop25), $pop24
	return  	$0
.LBB1_2:                                # %if.then
	end_block                       # label36:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
