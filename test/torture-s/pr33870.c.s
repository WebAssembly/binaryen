	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr33870.c"
	.section	.text.sort_pagelist,"ax",@progbits
	.hidden	sort_pagelist
	.globl	sort_pagelist
	.type	sort_pagelist,@function
sort_pagelist:                          # @sort_pagelist
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push25=, 0
	i32.const	$push22=, 0
	i32.load	$push23=, __stack_pointer($pop22)
	i32.const	$push24=, 144
	i32.sub 	$push47=, $pop23, $pop24
	tee_local	$push46=, $10=, $pop47
	i32.store	__stack_pointer($pop25), $pop46
	i32.const	$4=, 0
	i32.const	$push45=, 0
	i32.const	$push0=, 100
	i32.call	$1=, memset@FUNCTION, $10, $pop45, $pop0
	block   	
	i32.eqz 	$push99=, $0
	br_if   	0, $pop99       # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push35=, 104
	i32.add 	$push36=, $1, $pop35
	i32.const	$push48=, 28
	i32.add 	$5=, $pop36, $pop48
	i32.const	$push8=, 96
	i32.add 	$6=, $1, $pop8
.LBB0_2:                                # %while.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
                                        #       Child Loop BB0_6 Depth 3
                                        #         Child Loop BB0_7 Depth 4
                                        #     Child Loop BB0_17 Depth 2
                                        #       Child Loop BB0_18 Depth 3
	loop    	                # label1:
	copy_local	$push51=, $0
	tee_local	$push50=, $8=, $pop51
	i32.load	$0=, 28($pop50)
	i32.const	$push49=, 0
	i32.store	28($8), $pop49
	i32.const	$7=, 0
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
	loop    	                # label9:
	i32.const	$push56=, 2
	i32.shl 	$push1=, $7, $pop56
	i32.add 	$push55=, $1, $pop1
	tee_local	$push54=, $2=, $pop55
	i32.load	$push53=, 0($pop54)
	tee_local	$push52=, $10=, $pop53
	i32.eqz 	$push100=, $pop52
	br_if   	1, $pop100      # 1: down to label8
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	block   	
	block   	
	i32.eqz 	$push101=, $8
	br_if   	0, $pop101      # 0: down to label11
# BB#5:                                 # %while.body.lr.ph.i.preheader
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push43=, 104
	i32.add 	$push44=, $1, $pop43
	copy_local	$9=, $pop44
	copy_local	$3=, $10
.LBB0_6:                                # %while.body.lr.ph.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_7 Depth 4
	loop    	                # label12:
	copy_local	$push58=, $3
	tee_local	$push57=, $3=, $pop58
	i32.load	$4=, 0($pop57)
.LBB0_7:                                # %while.body.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        #       Parent Loop BB0_6 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	block   	
	block   	
	loop    	                # label15:
	copy_local	$push60=, $8
	tee_local	$push59=, $10=, $pop60
	i32.load	$push2=, 0($pop59)
	i32.lt_u	$push3=, $4, $pop2
	br_if   	1, $pop3        # 1: down to label14
# BB#8:                                 # %if.else.i
                                        #   in Loop: Header=BB0_7 Depth=4
	i32.const	$push63=, 28
	i32.add 	$push4=, $9, $pop63
	i32.store	0($pop4), $10
	copy_local	$9=, $10
	i32.load	$push62=, 28($10)
	tee_local	$push61=, $8=, $pop62
	br_if   	0, $pop61       # 0: up to label15
	br      	2               # 2: down to label13
.LBB0_9:                                # %if.then.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_loop
	end_block                       # label14:
	i32.const	$push66=, 28
	i32.add 	$push5=, $9, $pop66
	i32.store	0($pop5), $3
	copy_local	$9=, $3
	copy_local	$8=, $10
	copy_local	$4=, $3
	i32.load	$push65=, 28($3)
	tee_local	$push64=, $3=, $pop65
	br_if   	1, $pop64       # 1: up to label12
	br      	3               # 3: down to label10
.LBB0_10:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label13:
	end_loop
	copy_local	$4=, $10
	copy_local	$10=, $3
	br      	1               # 1: down to label10
.LBB0_11:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label11:
	i32.const	$push37=, 104
	i32.add 	$push38=, $1, $pop37
	copy_local	$4=, $pop38
.LBB0_12:                               # %merge_pagelist.exit
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label10:
	i32.store	28($4), $10
	i32.load	$8=, 0($5)
	i32.const	$push71=, 0
	i32.store	0($2), $pop71
	i32.const	$push70=, 1
	i32.add 	$push69=, $7, $pop70
	tee_local	$push68=, $7=, $pop69
	i32.const	$push67=, 24
	i32.lt_s	$push6=, $pop68, $pop67
	br_if   	0, $pop6        # 0: up to label9
# BB#13:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop
	i32.const	$push72=, 24
	i32.ne  	$push7=, $7, $pop72
	br_if   	5, $pop7        # 5: down to label3
# BB#14:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$4=, 0($6)
	i32.eqz 	$push102=, $8
	br_if   	1, $pop102      # 1: down to label7
# BB#15:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.eqz 	$push103=, $4
	br_if   	1, $pop103      # 1: down to label7
# BB#16:                                # %while.body.lr.ph.i79.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push39=, 104
	i32.add 	$push40=, $1, $pop39
	copy_local	$9=, $pop40
.LBB0_17:                               # %while.body.lr.ph.i79
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_18 Depth 3
	loop    	                # label16:
	copy_local	$push74=, $4
	tee_local	$push73=, $3=, $pop74
	i32.load	$4=, 0($pop73)
.LBB0_18:                               # %while.body.i85
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_17 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	block   	
	loop    	                # label18:
	copy_local	$push76=, $8
	tee_local	$push75=, $10=, $pop76
	i32.load	$push9=, 0($pop75)
	i32.lt_u	$push10=, $4, $pop9
	br_if   	1, $pop10       # 1: down to label17
# BB#19:                                # %if.else.i91
                                        #   in Loop: Header=BB0_18 Depth=3
	i32.const	$push79=, 28
	i32.add 	$push11=, $9, $pop79
	i32.store	0($pop11), $10
	copy_local	$9=, $10
	i32.load	$push78=, 28($10)
	tee_local	$push77=, $8=, $pop78
	br_if   	0, $pop77       # 0: up to label18
	br      	5               # 5: down to label6
.LBB0_20:                               # %if.then.i88
                                        #   in Loop: Header=BB0_17 Depth=2
	end_loop
	end_block                       # label17:
	i32.const	$push82=, 28
	i32.add 	$push12=, $9, $pop82
	i32.store	0($pop12), $3
	copy_local	$9=, $3
	copy_local	$8=, $10
	i32.load	$push81=, 28($3)
	tee_local	$push80=, $4=, $pop81
	br_if   	0, $pop80       # 0: up to label16
	br      	5               # 5: down to label4
.LBB0_21:                               # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop
	end_block                       # label8:
	i32.store	0($2), $8
	br_if   	6, $0           # 6: up to label1
	br      	5               # 5: down to label2
.LBB0_22:                               # %while.end.i96
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label7:
	i32.const	$push41=, 104
	i32.add 	$push42=, $1, $pop41
	copy_local	$3=, $pop42
	block   	
	br_if   	0, $4           # 0: down to label19
# BB#23:                                #   in Loop: Header=BB0_2 Depth=1
	copy_local	$10=, $8
	br      	3               # 3: down to label4
.LBB0_24:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label19:
	copy_local	$8=, $3
	copy_local	$10=, $4
	br      	1               # 1: down to label5
.LBB0_25:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label6:
	copy_local	$8=, $10
	copy_local	$10=, $3
.LBB0_26:                               # %while.end.thread.i99
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	copy_local	$3=, $8
.LBB0_27:                               # %merge_pagelist.exit103
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.store	28($3), $10
	i32.load	$push13=, 0($5)
	i32.store	0($6), $pop13
.LBB0_28:                               # %while.cond.backedge
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	br_if   	1, $0           # 1: up to label1
.LBB0_29:                               # %while.end.loopexit
	end_block                       # label2:
	end_loop
	i32.load	$4=, 0($1)
.LBB0_30:                               # %while.end
	end_block                       # label0:
	i32.const	$7=, 1
.LBB0_31:                               # %for.body15
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_34 Depth 2
                                        #       Child Loop BB0_35 Depth 3
	loop    	                # label20:
	i32.const	$push83=, 2
	i32.shl 	$push14=, $7, $pop83
	i32.add 	$push15=, $1, $pop14
	i32.load	$8=, 0($pop15)
	block   	
	block   	
	block   	
	block   	
	i32.eqz 	$push104=, $4
	br_if   	0, $pop104      # 0: down to label24
# BB#32:                                # %for.body15
                                        #   in Loop: Header=BB0_31 Depth=1
	i32.eqz 	$push105=, $8
	br_if   	0, $pop105      # 0: down to label24
# BB#33:                                # %while.body.lr.ph.i47.preheader
                                        #   in Loop: Header=BB0_31 Depth=1
	i32.const	$push29=, 104
	i32.add 	$push30=, $1, $pop29
	copy_local	$9=, $pop30
.LBB0_34:                               # %while.body.lr.ph.i47
                                        #   Parent Loop BB0_31 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_35 Depth 3
	loop    	                # label25:
	copy_local	$push85=, $4
	tee_local	$push84=, $3=, $pop85
	i32.load	$4=, 0($pop84)
.LBB0_35:                               # %while.body.i53
                                        #   Parent Loop BB0_31 Depth=1
                                        #     Parent Loop BB0_34 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	block   	
	loop    	                # label27:
	copy_local	$push87=, $8
	tee_local	$push86=, $10=, $pop87
	i32.load	$push16=, 0($pop86)
	i32.lt_u	$push17=, $4, $pop16
	br_if   	1, $pop17       # 1: down to label26
# BB#36:                                # %if.else.i59
                                        #   in Loop: Header=BB0_35 Depth=3
	i32.const	$push90=, 28
	i32.add 	$push18=, $9, $pop90
	i32.store	0($pop18), $10
	copy_local	$9=, $10
	i32.load	$push89=, 28($10)
	tee_local	$push88=, $8=, $pop89
	br_if   	0, $pop88       # 0: up to label27
	br      	4               # 4: down to label23
.LBB0_37:                               # %if.then.i56
                                        #   in Loop: Header=BB0_34 Depth=2
	end_loop
	end_block                       # label26:
	i32.const	$push93=, 28
	i32.add 	$push19=, $9, $pop93
	i32.store	0($pop19), $3
	copy_local	$9=, $3
	copy_local	$8=, $10
	i32.load	$push92=, 28($3)
	tee_local	$push91=, $4=, $pop92
	br_if   	0, $pop91       # 0: up to label25
	br      	4               # 4: down to label21
.LBB0_38:                               # %while.end.i64
                                        #   in Loop: Header=BB0_31 Depth=1
	end_loop
	end_block                       # label24:
	i32.const	$push33=, 104
	i32.add 	$push34=, $1, $pop33
	copy_local	$3=, $pop34
	block   	
	br_if   	0, $4           # 0: down to label28
# BB#39:                                #   in Loop: Header=BB0_31 Depth=1
	copy_local	$10=, $8
	br      	3               # 3: down to label21
.LBB0_40:                               #   in Loop: Header=BB0_31 Depth=1
	end_block                       # label28:
	copy_local	$8=, $3
	copy_local	$10=, $4
	br      	1               # 1: down to label22
.LBB0_41:                               #   in Loop: Header=BB0_31 Depth=1
	end_block                       # label23:
	copy_local	$8=, $10
	copy_local	$10=, $3
.LBB0_42:                               # %while.end.thread.i67
                                        #   in Loop: Header=BB0_31 Depth=1
	end_block                       # label22:
	copy_local	$3=, $8
.LBB0_43:                               # %merge_pagelist.exit71
                                        #   in Loop: Header=BB0_31 Depth=1
	end_block                       # label21:
	i32.store	28($3), $10
	i32.const	$push31=, 104
	i32.add 	$push32=, $1, $pop31
	i32.const	$push98=, 28
	i32.add 	$push21=, $pop32, $pop98
	i32.load	$4=, 0($pop21)
	i32.const	$push97=, 1
	i32.add 	$push96=, $7, $pop97
	tee_local	$push95=, $7=, $pop96
	i32.const	$push94=, 25
	i32.ne  	$push20=, $pop95, $pop94
	br_if   	0, $pop20       # 0: up to label20
# BB#44:                                # %for.end20
	end_loop
	i32.const	$push28=, 0
	i32.const	$push26=, 144
	i32.add 	$push27=, $1, $pop26
	i32.store	__stack_pointer($pop28), $pop27
	copy_local	$push106=, $4
                                        # fallthrough-return: $pop106
	.endfunc
.Lfunc_end0:
	.size	sort_pagelist, .Lfunc_end0-sort_pagelist

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push21=, 0
	i32.const	$push18=, 0
	i32.load	$push19=, __stack_pointer($pop18)
	i32.const	$push20=, 208
	i32.sub 	$push29=, $pop19, $pop20
	tee_local	$push28=, $1=, $pop29
	i32.store	__stack_pointer($pop21), $pop28
	i32.const	$push2=, 68
	i32.add 	$push3=, $1, $pop2
	i32.const	$push0=, 80
	i32.add 	$push1=, $1, $pop0
	i32.store	0($pop3), $pop1
	i32.const	$push6=, 108
	i32.add 	$push7=, $1, $pop6
	i32.const	$push4=, 120
	i32.add 	$push5=, $1, $pop4
	i32.store	0($pop7), $pop5
	i32.const	$push8=, 5
	i32.store	0($1), $pop8
	i32.const	$push9=, 4
	i32.store	40($1), $pop9
	i32.const	$push10=, 1
	i32.store	80($1), $pop10
	i32.const	$push11=, 3
	i32.store	120($1), $pop11
	i32.const	$push12=, 40
	i32.add 	$push13=, $1, $pop12
	i32.store	28($1), $pop13
	i32.const	$push14=, 148
	i32.add 	$push15=, $1, $pop14
	i32.const	$push27=, 0
	i32.store	0($pop15), $pop27
	block   	
	i32.call	$push26=, sort_pagelist@FUNCTION, $1
	tee_local	$push25=, $0=, $pop26
	i32.load	$push16=, 28($0)
	i32.eq  	$push17=, $pop25, $pop16
	br_if   	0, $pop17       # 0: down to label29
# BB#1:                                 # %if.end
	i32.const	$push24=, 0
	i32.const	$push22=, 208
	i32.add 	$push23=, $1, $pop22
	i32.store	__stack_pointer($pop24), $pop23
	i32.const	$push30=, 0
	return  	$pop30
.LBB1_2:                                # %if.then
	end_block                       # label29:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 "
	.functype	abort, void
