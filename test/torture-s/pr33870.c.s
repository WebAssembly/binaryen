	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr33870.c"
	.section	.text.sort_pagelist,"ax",@progbits
	.hidden	sort_pagelist
	.globl	sort_pagelist
	.type	sort_pagelist,@function
sort_pagelist:                          # @sort_pagelist
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push25=, 0
	i32.const	$push22=, 0
	i32.load	$push23=, __stack_pointer($pop22)
	i32.const	$push24=, 144
	i32.sub 	$push47=, $pop23, $pop24
	tee_local	$push46=, $11=, $pop47
	i32.store	__stack_pointer($pop25), $pop46
	i32.const	$4=, 0
	i32.const	$push45=, 0
	i32.const	$push0=, 100
	i32.call	$1=, memset@FUNCTION, $11, $pop45, $pop0
	block   	
	i32.eqz 	$push103=, $0
	br_if   	0, $pop103      # 0: down to label0
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
	loop    	                # label8:
	i32.const	$push56=, 2
	i32.shl 	$push1=, $7, $pop56
	i32.add 	$push55=, $1, $pop1
	tee_local	$push54=, $2=, $pop55
	i32.load	$push53=, 0($pop54)
	tee_local	$push52=, $4=, $pop53
	i32.eqz 	$push104=, $pop52
	br_if   	1, $pop104      # 1: down to label7
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push37=, 104
	i32.add 	$push38=, $1, $pop37
	copy_local	$10=, $pop38
	block   	
	block   	
	i32.eqz 	$push105=, $8
	br_if   	0, $pop105      # 0: down to label10
# BB#5:                                 # %while.body.lr.ph.i.preheader
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push43=, 104
	i32.add 	$push44=, $1, $pop43
	copy_local	$9=, $pop44
.LBB0_6:                                # %while.body.lr.ph.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_7 Depth 4
	loop    	                # label11:
	copy_local	$push58=, $4
	tee_local	$push57=, $3=, $pop58
	i32.load	$4=, 0($pop57)
.LBB0_7:                                # %while.body.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        #       Parent Loop BB0_6 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	block   	
	block   	
	loop    	                # label14:
	copy_local	$push60=, $8
	tee_local	$push59=, $11=, $pop60
	i32.load	$push2=, 0($pop59)
	i32.lt_u	$push3=, $4, $pop2
	br_if   	1, $pop3        # 1: down to label13
# BB#8:                                 # %if.else.i
                                        #   in Loop: Header=BB0_7 Depth=4
	i32.const	$push63=, 28
	i32.add 	$push4=, $9, $pop63
	i32.store	0($pop4), $11
	copy_local	$9=, $11
	i32.load	$push62=, 28($11)
	tee_local	$push61=, $8=, $pop62
	br_if   	0, $pop61       # 0: up to label14
	br      	2               # 2: down to label12
.LBB0_9:                                # %if.then.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_loop
	end_block                       # label13:
	i32.const	$push66=, 28
	i32.add 	$push5=, $9, $pop66
	i32.store	0($pop5), $3
	copy_local	$9=, $3
	copy_local	$8=, $11
	copy_local	$10=, $3
	i32.load	$push65=, 28($3)
	tee_local	$push64=, $4=, $pop65
	br_if   	1, $pop64       # 1: up to label11
	br      	3               # 3: down to label9
.LBB0_10:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label12:
	end_loop
	copy_local	$10=, $11
	copy_local	$11=, $3
	br      	1               # 1: down to label9
.LBB0_11:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label10:
	copy_local	$11=, $4
.LBB0_12:                               # %merge_pagelist.exit
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label9:
	i32.store	28($10), $11
	i32.load	$8=, 0($5)
	i32.const	$push71=, 0
	i32.store	0($2), $pop71
	i32.const	$push70=, 1
	i32.add 	$push69=, $7, $pop70
	tee_local	$push68=, $7=, $pop69
	i32.const	$push67=, 24
	i32.lt_s	$push6=, $pop68, $pop67
	br_if   	0, $pop6        # 0: up to label8
# BB#13:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop
	i32.const	$push72=, 24
	i32.ne  	$push7=, $7, $pop72
	br_if   	5, $pop7        # 5: down to label2
# BB#14:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$4=, 0($6)
	i32.eqz 	$push106=, $8
	br_if   	1, $pop106      # 1: down to label6
# BB#15:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.eqz 	$push107=, $4
	br_if   	1, $pop107      # 1: down to label6
# BB#16:                                # %while.body.lr.ph.i79.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push39=, 104
	i32.add 	$push40=, $1, $pop39
	copy_local	$9=, $pop40
	copy_local	$11=, $8
.LBB0_17:                               # %while.body.lr.ph.i79
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_18 Depth 3
	loop    	                # label15:
	copy_local	$push74=, $4
	tee_local	$push73=, $3=, $pop74
	i32.load	$4=, 0($pop73)
.LBB0_18:                               # %while.body.i85
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_17 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	block   	
	loop    	                # label17:
	copy_local	$push76=, $11
	tee_local	$push75=, $8=, $pop76
	i32.load	$push9=, 0($pop75)
	i32.lt_u	$push10=, $4, $pop9
	br_if   	1, $pop10       # 1: down to label16
# BB#19:                                # %if.else.i91
                                        #   in Loop: Header=BB0_18 Depth=3
	i32.const	$push79=, 28
	i32.add 	$push11=, $9, $pop79
	i32.store	0($pop11), $8
	copy_local	$9=, $8
	i32.load	$push78=, 28($8)
	tee_local	$push77=, $11=, $pop78
	br_if   	0, $pop77       # 0: up to label17
	br      	5               # 5: down to label5
.LBB0_20:                               # %if.then.i88
                                        #   in Loop: Header=BB0_17 Depth=2
	end_loop
	end_block                       # label16:
	i32.const	$push82=, 28
	i32.add 	$push12=, $9, $pop82
	i32.store	0($pop12), $3
	copy_local	$9=, $3
	copy_local	$11=, $8
	i32.load	$push81=, 28($3)
	tee_local	$push80=, $4=, $pop81
	br_if   	0, $pop80       # 0: up to label15
	br      	5               # 5: down to label3
.LBB0_21:                               # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop
	end_block                       # label7:
	i32.store	0($2), $8
	br      	4               # 4: down to label2
.LBB0_22:                               # %while.end.i96
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label6:
	i32.const	$push41=, 104
	i32.add 	$push42=, $1, $pop41
	copy_local	$push84=, $pop42
	tee_local	$push83=, $11=, $pop84
	copy_local	$3=, $pop83
	br_if   	1, $4           # 1: down to label4
	br      	2               # 2: down to label3
.LBB0_23:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	copy_local	$11=, $8
	copy_local	$4=, $3
.LBB0_24:                               # %while.end.thread.i99
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	copy_local	$3=, $11
	copy_local	$8=, $4
.LBB0_25:                               # %merge_pagelist.exit103
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.store	28($3), $8
	i32.load	$push13=, 0($5)
	i32.store	0($6), $pop13
.LBB0_26:                               # %while.cond.backedge
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label2:
	br_if   	0, $0           # 0: up to label1
# BB#27:                                # %while.end.loopexit
	end_loop
	i32.load	$4=, 0($1)
.LBB0_28:                               # %while.end
	end_block                       # label0:
	i32.const	$10=, 1
.LBB0_29:                               # %for.body15
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_32 Depth 2
                                        #       Child Loop BB0_33 Depth 3
	loop    	                # label18:
	i32.const	$push85=, 2
	i32.shl 	$push14=, $10, $pop85
	i32.add 	$push15=, $1, $pop14
	i32.load	$11=, 0($pop15)
	block   	
	block   	
	block   	
	block   	
	i32.eqz 	$push108=, $4
	br_if   	0, $pop108      # 0: down to label22
# BB#30:                                # %for.body15
                                        #   in Loop: Header=BB0_29 Depth=1
	i32.eqz 	$push109=, $11
	br_if   	0, $pop109      # 0: down to label22
# BB#31:                                # %while.body.lr.ph.i47.preheader
                                        #   in Loop: Header=BB0_29 Depth=1
	i32.const	$push29=, 104
	i32.add 	$push30=, $1, $pop29
	copy_local	$9=, $pop30
	copy_local	$8=, $11
.LBB0_32:                               # %while.body.lr.ph.i47
                                        #   Parent Loop BB0_29 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_33 Depth 3
	loop    	                # label23:
	copy_local	$push87=, $4
	tee_local	$push86=, $3=, $pop87
	i32.load	$4=, 0($pop86)
.LBB0_33:                               # %while.body.i53
                                        #   Parent Loop BB0_29 Depth=1
                                        #     Parent Loop BB0_32 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	block   	
	loop    	                # label25:
	copy_local	$push89=, $8
	tee_local	$push88=, $11=, $pop89
	i32.load	$push16=, 0($pop88)
	i32.lt_u	$push17=, $4, $pop16
	br_if   	1, $pop17       # 1: down to label24
# BB#34:                                # %if.else.i59
                                        #   in Loop: Header=BB0_33 Depth=3
	i32.const	$push92=, 28
	i32.add 	$push18=, $9, $pop92
	i32.store	0($pop18), $11
	copy_local	$9=, $11
	i32.load	$push91=, 28($11)
	tee_local	$push90=, $8=, $pop91
	br_if   	0, $pop90       # 0: up to label25
	br      	4               # 4: down to label21
.LBB0_35:                               # %if.then.i56
                                        #   in Loop: Header=BB0_32 Depth=2
	end_loop
	end_block                       # label24:
	i32.const	$push95=, 28
	i32.add 	$push19=, $9, $pop95
	i32.store	0($pop19), $3
	copy_local	$9=, $3
	copy_local	$8=, $11
	i32.load	$push94=, 28($3)
	tee_local	$push93=, $4=, $pop94
	br_if   	0, $pop93       # 0: up to label23
	br      	4               # 4: down to label19
.LBB0_36:                               # %while.end.i64
                                        #   in Loop: Header=BB0_29 Depth=1
	end_loop
	end_block                       # label22:
	i32.const	$push33=, 104
	i32.add 	$push34=, $1, $pop33
	copy_local	$push97=, $pop34
	tee_local	$push96=, $8=, $pop97
	copy_local	$3=, $pop96
	br_if   	1, $4           # 1: down to label20
	br      	2               # 2: down to label19
.LBB0_37:                               #   in Loop: Header=BB0_29 Depth=1
	end_block                       # label21:
	copy_local	$8=, $11
	copy_local	$4=, $3
.LBB0_38:                               # %while.end.thread.i67
                                        #   in Loop: Header=BB0_29 Depth=1
	end_block                       # label20:
	copy_local	$3=, $8
	copy_local	$11=, $4
.LBB0_39:                               # %merge_pagelist.exit71
                                        #   in Loop: Header=BB0_29 Depth=1
	end_block                       # label19:
	i32.store	28($3), $11
	i32.const	$push31=, 104
	i32.add 	$push32=, $1, $pop31
	i32.const	$push102=, 28
	i32.add 	$push21=, $pop32, $pop102
	i32.load	$4=, 0($pop21)
	i32.const	$push101=, 1
	i32.add 	$push100=, $10, $pop101
	tee_local	$push99=, $10=, $pop100
	i32.const	$push98=, 25
	i32.ne  	$push20=, $pop99, $pop98
	br_if   	0, $pop20       # 0: up to label18
# BB#40:                                # %for.end20
	end_loop
	i32.const	$push28=, 0
	i32.const	$push26=, 144
	i32.add 	$push27=, $1, $pop26
	i32.store	__stack_pointer($pop28), $pop27
	copy_local	$push110=, $4
                                        # fallthrough-return: $pop110
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
	br_if   	0, $pop17       # 0: down to label26
# BB#1:                                 # %if.end
	i32.const	$push24=, 0
	i32.const	$push22=, 208
	i32.add 	$push23=, $1, $pop22
	i32.store	__stack_pointer($pop24), $pop23
	i32.const	$push30=, 0
	return  	$pop30
.LBB1_2:                                # %if.then
	end_block                       # label26:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
