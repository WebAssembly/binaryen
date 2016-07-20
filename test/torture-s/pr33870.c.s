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
	i32.const	$push30=, 0
	i32.const	$push27=, 0
	i32.load	$push28=, __stack_pointer($pop27)
	i32.const	$push29=, 144
	i32.sub 	$push50=, $pop28, $pop29
	i32.store	$push0=, __stack_pointer($pop30), $pop50
	i32.const	$push51=, 0
	i32.const	$push1=, 100
	i32.call	$1=, memset@FUNCTION, $pop0, $pop51, $pop1
	i32.const	$5=, 0
	block
	i32.eqz 	$push130=, $0
	br_if   	0, $pop130      # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push40=, 104
	i32.add 	$push41=, $1, $pop40
	i32.const	$push52=, 28
	i32.add 	$3=, $pop41, $pop52
	i32.const	$push9=, 96
	i32.add 	$7=, $1, $pop9
.LBB0_2:                                # %while.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
                                        #       Child Loop BB0_6 Depth 3
                                        #         Child Loop BB0_7 Depth 4
                                        #     Child Loop BB0_24 Depth 2
                                        #       Child Loop BB0_25 Depth 3
	loop                            # label1:
	copy_local	$push55=, $0
	tee_local	$push54=, $9=, $pop55
	i32.load	$0=, 28($pop54)
	i32.const	$push53=, 0
	i32.store	$2=, 28($9), $pop53
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
	i32.const	$push60=, 2
	i32.shl 	$push2=, $8, $pop60
	i32.add 	$push59=, $1, $pop2
	tee_local	$push58=, $4=, $pop59
	i32.load	$push57=, 0($pop58)
	tee_local	$push56=, $5=, $pop57
	i32.eqz 	$push131=, $pop56
	br_if   	2, $pop131      # 2: down to label9
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	block
	block
	block
	block
	i32.eqz 	$push132=, $9
	br_if   	0, $pop132      # 0: down to label15
# BB#5:                                 # %while.body.lr.ph.i.preheader
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push48=, 104
	i32.add 	$push49=, $1, $pop48
	copy_local	$10=, $pop49
.LBB0_6:                                # %while.body.lr.ph.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_7 Depth 4
	block
	loop                            # label17:
	copy_local	$push62=, $5
	tee_local	$push61=, $11=, $pop62
	i32.load	$5=, 0($pop61)
.LBB0_7:                                # %while.body.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        #       Parent Loop BB0_6 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label19:
	copy_local	$push64=, $9
	tee_local	$push63=, $6=, $pop64
	i32.load	$push3=, 0($pop63)
	i32.lt_u	$push4=, $5, $pop3
	br_if   	1, $pop4        # 1: down to label20
# BB#8:                                 # %if.else.i
                                        #   in Loop: Header=BB0_7 Depth=4
	i32.const	$push69=, 28
	i32.add 	$push5=, $10, $pop69
	i32.store	$push68=, 0($pop5), $6
	tee_local	$push67=, $6=, $pop68
	copy_local	$10=, $pop67
	i32.load	$push66=, 28($6)
	tee_local	$push65=, $9=, $pop66
	br_if   	0, $pop65       # 0: up to label19
	br      	4               # 4: down to label16
.LBB0_9:                                # %if.then.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_loop                        # label20:
	i32.const	$push72=, 28
	i32.add 	$push6=, $10, $pop72
	i32.store	$push71=, 0($pop6), $11
	tee_local	$push70=, $11=, $pop71
	i32.load	$5=, 28($pop70)
	i32.eqz 	$push133=, $6
	br_if   	1, $pop133      # 1: down to label18
# BB#10:                                # %if.then.i
                                        #   in Loop: Header=BB0_6 Depth=3
	copy_local	$10=, $11
	copy_local	$9=, $6
	br_if   	0, $5           # 0: up to label17
.LBB0_11:                               # %while.end.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_loop                        # label18:
	i32.const	$push73=, 28
	i32.add 	$9=, $11, $pop73
	br_if   	2, $5           # 2: down to label14
# BB#12:                                # %if.else9.i
                                        #   in Loop: Header=BB0_3 Depth=2
	block
	br_if   	0, $6           # 0: down to label21
# BB#13:                                # %if.else13.i
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$drop=, 0($9), $2
	br      	5               # 5: down to label12
.LBB0_14:                               # %if.then11.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label21:
	i32.store	$drop=, 0($9), $6
	br      	4               # 4: down to label12
.LBB0_15:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label16:
	i32.const	$push74=, 28
	i32.add 	$9=, $6, $pop74
	br      	2               # 2: down to label13
.LBB0_16:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label15:
	copy_local	$9=, $3
.LBB0_17:                               # %merge_pagelist.exit
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label14:
	copy_local	$11=, $5
.LBB0_18:                               # %merge_pagelist.exit
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label13:
	i32.store	$drop=, 0($9), $11
.LBB0_19:                               # %merge_pagelist.exit
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label12:
	i32.const	$push42=, 104
	i32.add 	$push43=, $1, $pop42
	i32.const	$push81=, 28
	i32.add 	$push80=, $pop43, $pop81
	tee_local	$push79=, $10=, $pop80
	i32.load	$9=, 0($pop79)
	i32.store	$6=, 0($4), $2
	i32.const	$push78=, 1
	i32.add 	$push77=, $8, $pop78
	tee_local	$push76=, $8=, $pop77
	i32.const	$push75=, 24
	i32.lt_s	$push7=, $pop76, $pop75
	br_if   	0, $pop7        # 0: up to label10
# BB#20:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label11:
	i32.const	$push82=, 24
	i32.ne  	$push8=, $8, $pop82
	br_if   	6, $pop8        # 6: down to label3
# BB#21:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.ne  	$12=, $9, $6
	i32.load	$push84=, 0($7)
	tee_local	$push83=, $8=, $pop84
	i32.ne  	$2=, $pop83, $6
	i32.const	$push44=, 104
	i32.add 	$push45=, $1, $pop44
	copy_local	$4=, $pop45
	i32.eqz 	$push134=, $9
	br_if   	1, $pop134      # 1: down to label8
# BB#22:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.eqz 	$push135=, $8
	br_if   	1, $pop135      # 1: down to label8
# BB#23:                                # %while.body.lr.ph.i85.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push46=, 104
	i32.add 	$push47=, $1, $pop46
	copy_local	$11=, $pop47
.LBB0_24:                               # %while.body.lr.ph.i85
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_25 Depth 3
	loop                            # label22:
	copy_local	$push86=, $8
	tee_local	$push85=, $4=, $pop86
	i32.load	$8=, 0($pop85)
.LBB0_25:                               # %while.body.i91
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_24 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label24:
	copy_local	$push88=, $9
	tee_local	$push87=, $5=, $pop88
	i32.load	$push10=, 0($pop87)
	i32.lt_u	$push11=, $8, $pop10
	br_if   	1, $pop11       # 1: down to label25
# BB#26:                                # %if.else.i98
                                        #   in Loop: Header=BB0_25 Depth=3
	i32.const	$push93=, 28
	i32.add 	$push12=, $11, $pop93
	i32.store	$push92=, 0($pop12), $5
	tee_local	$push91=, $5=, $pop92
	copy_local	$11=, $pop91
	i32.load	$push90=, 28($5)
	tee_local	$push89=, $9=, $pop90
	br_if   	0, $pop89       # 0: up to label24
	br      	7               # 7: down to label6
.LBB0_27:                               # %if.then.i95
                                        #   in Loop: Header=BB0_24 Depth=2
	end_loop                        # label25:
	i32.ne  	$12=, $5, $6
	i32.const	$push98=, 28
	i32.add 	$push13=, $11, $pop98
	i32.store	$push97=, 0($pop13), $4
	tee_local	$push96=, $9=, $pop97
	i32.load	$push95=, 28($pop96)
	tee_local	$push94=, $8=, $pop95
	i32.ne  	$2=, $pop94, $6
	i32.eqz 	$push136=, $5
	br_if   	4, $pop136      # 4: down to label7
# BB#28:                                # %if.then.i95
                                        #   in Loop: Header=BB0_24 Depth=2
	copy_local	$11=, $9
	copy_local	$9=, $5
	br_if   	0, $8           # 0: up to label22
	br      	4               # 4: down to label7
.LBB0_29:                               # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label23:
	end_block                       # label9:
	i32.store	$drop=, 0($4), $9
	br      	5               # 5: down to label3
.LBB0_30:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label8:
	copy_local	$5=, $9
.LBB0_31:                               # %while.end.i107
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label7:
	i32.const	$push99=, 28
	i32.add 	$9=, $4, $pop99
	i32.eqz 	$push137=, $2
	br_if   	1, $pop137      # 1: down to label5
# BB#32:                                #   in Loop: Header=BB0_2 Depth=1
	copy_local	$push23=, $8
	i32.store	$drop=, 0($9), $pop23
	br      	2               # 2: down to label4
.LBB0_33:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label6:
	i32.const	$push100=, 28
	i32.add 	$push24=, $5, $pop100
	i32.store	$drop=, 0($pop24), $4
	br      	1               # 1: down to label4
.LBB0_34:                               # %if.else9.i111
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	block
	i32.eqz 	$push138=, $12
	br_if   	0, $pop138      # 0: down to label26
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
	i32.const	$8=, 1
.LBB0_41:                               # %for.body15
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_44 Depth 2
                                        #       Child Loop BB0_45 Depth 3
	loop                            # label27:
	i32.const	$push105=, 0
	i32.ne  	$4=, $5, $pop105
	i32.const	$push104=, 2
	i32.shl 	$push15=, $8, $pop104
	i32.add 	$push16=, $1, $pop15
	i32.load	$push103=, 0($pop16)
	tee_local	$push102=, $9=, $pop103
	i32.const	$push101=, 0
	i32.ne  	$2=, $pop102, $pop101
	i32.const	$push34=, 104
	i32.add 	$push35=, $1, $pop34
	copy_local	$11=, $pop35
	block
	block
	block
	block
	block
	i32.eqz 	$push139=, $5
	br_if   	0, $pop139      # 0: down to label33
# BB#42:                                # %for.body15
                                        #   in Loop: Header=BB0_41 Depth=1
	i32.eqz 	$push140=, $9
	br_if   	0, $pop140      # 0: down to label33
# BB#43:                                # %while.body.lr.ph.i47.preheader
                                        #   in Loop: Header=BB0_41 Depth=1
	i32.const	$push36=, 104
	i32.add 	$push37=, $1, $pop36
	copy_local	$10=, $pop37
.LBB0_44:                               # %while.body.lr.ph.i47
                                        #   Parent Loop BB0_41 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_45 Depth 3
	loop                            # label34:
	copy_local	$push107=, $5
	tee_local	$push106=, $11=, $pop107
	i32.load	$5=, 0($pop106)
.LBB0_45:                               # %while.body.i53
                                        #   Parent Loop BB0_41 Depth=1
                                        #     Parent Loop BB0_44 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label36:
	copy_local	$push109=, $9
	tee_local	$push108=, $6=, $pop109
	i32.load	$push17=, 0($pop108)
	i32.lt_u	$push18=, $5, $pop17
	br_if   	1, $pop18       # 1: down to label37
# BB#46:                                # %if.else.i60
                                        #   in Loop: Header=BB0_45 Depth=3
	i32.const	$push114=, 28
	i32.add 	$push19=, $10, $pop114
	i32.store	$push113=, 0($pop19), $6
	tee_local	$push112=, $6=, $pop113
	copy_local	$10=, $pop112
	i32.load	$push111=, 28($6)
	tee_local	$push110=, $9=, $pop111
	br_if   	0, $pop110      # 0: up to label36
	br      	6               # 6: down to label31
.LBB0_47:                               # %if.then.i57
                                        #   in Loop: Header=BB0_44 Depth=2
	end_loop                        # label37:
	i32.const	$push121=, 0
	i32.ne  	$2=, $6, $pop121
	i32.const	$push120=, 28
	i32.add 	$push20=, $10, $pop120
	i32.store	$push119=, 0($pop20), $11
	tee_local	$push118=, $9=, $pop119
	i32.load	$push117=, 28($pop118)
	tee_local	$push116=, $5=, $pop117
	i32.const	$push115=, 0
	i32.ne  	$4=, $pop116, $pop115
	i32.eqz 	$push141=, $6
	br_if   	3, $pop141      # 3: down to label32
# BB#48:                                # %if.then.i57
                                        #   in Loop: Header=BB0_44 Depth=2
	copy_local	$10=, $9
	copy_local	$9=, $6
	br_if   	0, $5           # 0: up to label34
	br      	3               # 3: down to label32
.LBB0_49:                               #   in Loop: Header=BB0_41 Depth=1
	end_loop                        # label35:
	end_block                       # label33:
	copy_local	$6=, $9
.LBB0_50:                               # %while.end.i69
                                        #   in Loop: Header=BB0_41 Depth=1
	end_block                       # label32:
	i32.const	$push122=, 28
	i32.add 	$9=, $11, $pop122
	i32.eqz 	$push142=, $4
	br_if   	1, $pop142      # 1: down to label30
# BB#51:                                #   in Loop: Header=BB0_41 Depth=1
	copy_local	$push25=, $5
	i32.store	$drop=, 0($9), $pop25
	br      	2               # 2: down to label29
.LBB0_52:                               #   in Loop: Header=BB0_41 Depth=1
	end_block                       # label31:
	i32.const	$push123=, 28
	i32.add 	$push26=, $6, $pop123
	i32.store	$drop=, 0($pop26), $11
	br      	1               # 1: down to label29
.LBB0_53:                               # %if.else9.i73
                                        #   in Loop: Header=BB0_41 Depth=1
	end_block                       # label30:
	block
	i32.eqz 	$push143=, $2
	br_if   	0, $pop143      # 0: down to label38
# BB#54:                                # %if.then11.i74
                                        #   in Loop: Header=BB0_41 Depth=1
	i32.store	$drop=, 0($9), $6
	br      	1               # 1: down to label29
.LBB0_55:                               # %if.else13.i75
                                        #   in Loop: Header=BB0_41 Depth=1
	end_block                       # label38:
	i32.const	$push124=, 0
	i32.store	$drop=, 0($9), $pop124
.LBB0_56:                               # %merge_pagelist.exit77
                                        #   in Loop: Header=BB0_41 Depth=1
	end_block                       # label29:
	i32.const	$push38=, 104
	i32.add 	$push39=, $1, $pop38
	i32.const	$push129=, 28
	i32.add 	$push22=, $pop39, $pop129
	i32.load	$5=, 0($pop22)
	i32.const	$push128=, 1
	i32.add 	$push127=, $8, $pop128
	tee_local	$push126=, $8=, $pop127
	i32.const	$push125=, 25
	i32.ne  	$push21=, $pop126, $pop125
	br_if   	0, $pop21       # 0: up to label27
# BB#57:                                # %for.end20
	end_loop                        # label28:
	i32.const	$push33=, 0
	i32.const	$push31=, 144
	i32.add 	$push32=, $1, $pop31
	i32.store	$drop=, __stack_pointer($pop33), $pop32
	copy_local	$push144=, $5
                                        # fallthrough-return: $pop144
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
