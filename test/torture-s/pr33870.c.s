	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr33870.c"
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
	i32.const	$push23=, 0
	i32.load	$push22=, __stack_pointer($pop23)
	i32.const	$push24=, 144
	i32.sub 	$push47=, $pop22, $pop24
	tee_local	$push46=, $10=, $pop47
	i32.store	__stack_pointer($pop25), $pop46
	i32.const	$5=, 0
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
	i32.add 	$6=, $pop36, $pop48
	i32.const	$push8=, 96
	i32.add 	$7=, $1, $pop8
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
	i32.const	$10=, 0
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
	copy_local	$push58=, $10
	tee_local	$push57=, $2=, $pop58
	i32.const	$push56=, 2
	i32.shl 	$push1=, $pop57, $pop56
	i32.add 	$push55=, $1, $pop1
	tee_local	$push54=, $3=, $pop55
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
	copy_local	$4=, $10
.LBB0_6:                                # %while.body.lr.ph.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_7 Depth 4
	loop    	                # label12:
	copy_local	$push60=, $4
	tee_local	$push59=, $4=, $pop60
	i32.load	$5=, 0($pop59)
.LBB0_7:                                # %while.body.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        #       Parent Loop BB0_6 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	block   	
	block   	
	loop    	                # label15:
	copy_local	$push62=, $8
	tee_local	$push61=, $10=, $pop62
	i32.load	$push2=, 0($pop61)
	i32.lt_u	$push3=, $5, $pop2
	br_if   	1, $pop3        # 1: down to label14
# BB#8:                                 # %if.else.i
                                        #   in Loop: Header=BB0_7 Depth=4
	i32.const	$push65=, 28
	i32.add 	$push4=, $9, $pop65
	i32.store	0($pop4), $10
	copy_local	$9=, $10
	i32.load	$push64=, 28($10)
	tee_local	$push63=, $8=, $pop64
	br_if   	0, $pop63       # 0: up to label15
	br      	2               # 2: down to label13
.LBB0_9:                                # %if.then.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_loop
	end_block                       # label14:
	i32.const	$push68=, 28
	i32.add 	$push5=, $9, $pop68
	i32.store	0($pop5), $4
	copy_local	$9=, $4
	copy_local	$8=, $10
	copy_local	$5=, $4
	i32.load	$push67=, 28($4)
	tee_local	$push66=, $4=, $pop67
	br_if   	1, $pop66       # 1: up to label12
	br      	3               # 3: down to label10
.LBB0_10:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label13:
	end_loop
	copy_local	$5=, $10
	copy_local	$10=, $4
	br      	1               # 1: down to label10
.LBB0_11:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label11:
	i32.const	$push37=, 104
	i32.add 	$push38=, $1, $pop37
	copy_local	$5=, $pop38
.LBB0_12:                               # %merge_pagelist.exit
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label10:
	i32.store	28($5), $10
	i32.load	$8=, 0($6)
	i32.const	$push71=, 0
	i32.store	0($3), $pop71
	i32.const	$push70=, 1
	i32.add 	$10=, $2, $pop70
	i32.const	$push69=, 23
	i32.lt_s	$push6=, $2, $pop69
	br_if   	0, $pop6        # 0: up to label9
# BB#13:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop
	i32.const	$push72=, 24
	i32.ne  	$push7=, $10, $pop72
	br_if   	1, $pop7        # 1: down to label7
# BB#14:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$5=, 0($7)
	i32.eqz 	$push102=, $8
	br_if   	2, $pop102      # 2: down to label6
# BB#15:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.eqz 	$push103=, $5
	br_if   	2, $pop103      # 2: down to label6
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
	copy_local	$push74=, $5
	tee_local	$push73=, $4=, $pop74
	i32.load	$5=, 0($pop73)
.LBB0_18:                               # %while.body.i85
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_17 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	block   	
	loop    	                # label18:
	copy_local	$push76=, $8
	tee_local	$push75=, $10=, $pop76
	i32.load	$push9=, 0($pop75)
	i32.lt_u	$push10=, $5, $pop9
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
	br      	6               # 6: down to label5
.LBB0_20:                               # %if.then.i88
                                        #   in Loop: Header=BB0_17 Depth=2
	end_loop
	end_block                       # label17:
	i32.const	$push82=, 28
	i32.add 	$push12=, $9, $pop82
	i32.store	0($pop12), $4
	copy_local	$9=, $4
	copy_local	$8=, $10
	i32.load	$push81=, 28($4)
	tee_local	$push80=, $5=, $pop81
	br_if   	0, $pop80       # 0: up to label16
	br      	6               # 6: down to label3
.LBB0_21:                               # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop
	end_block                       # label8:
	i32.store	0($3), $8
.LBB0_22:                               # %while.cond.backedge
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label7:
	br_if   	5, $0           # 5: up to label1
	br      	4               # 4: down to label2
.LBB0_23:                               # %while.end.i96
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label6:
	i32.const	$push41=, 104
	i32.add 	$push42=, $1, $pop41
	copy_local	$4=, $pop42
	i32.eqz 	$push104=, $5
	br_if   	1, $pop104      # 1: down to label4
# BB#24:                                #   in Loop: Header=BB0_2 Depth=1
	copy_local	$10=, $5
	br      	2               # 2: down to label3
.LBB0_25:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	copy_local	$8=, $10
	copy_local	$10=, $4
	copy_local	$4=, $8
	br      	1               # 1: down to label3
.LBB0_26:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	copy_local	$10=, $8
.LBB0_27:                               # %merge_pagelist.exit103
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.store	28($4), $10
	i32.load	$push13=, 0($6)
	i32.store	0($7), $pop13
	br_if   	1, $0           # 1: up to label1
.LBB0_28:                               # %while.end.loopexit
	end_block                       # label2:
	end_loop
	i32.load	$5=, 0($1)
.LBB0_29:                               # %while.end
	end_block                       # label0:
	i32.const	$2=, 1
.LBB0_30:                               # %for.body15
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_33 Depth 2
                                        #       Child Loop BB0_34 Depth 3
	loop    	                # label19:
	i32.const	$push83=, 2
	i32.shl 	$push14=, $2, $pop83
	i32.add 	$push15=, $1, $pop14
	i32.load	$8=, 0($pop15)
	block   	
	block   	
	block   	
	block   	
	i32.eqz 	$push105=, $5
	br_if   	0, $pop105      # 0: down to label23
# BB#31:                                # %for.body15
                                        #   in Loop: Header=BB0_30 Depth=1
	i32.eqz 	$push106=, $8
	br_if   	0, $pop106      # 0: down to label23
# BB#32:                                # %while.body.lr.ph.i47.preheader
                                        #   in Loop: Header=BB0_30 Depth=1
	i32.const	$push29=, 104
	i32.add 	$push30=, $1, $pop29
	copy_local	$9=, $pop30
.LBB0_33:                               # %while.body.lr.ph.i47
                                        #   Parent Loop BB0_30 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_34 Depth 3
	loop    	                # label24:
	copy_local	$push85=, $5
	tee_local	$push84=, $4=, $pop85
	i32.load	$5=, 0($pop84)
.LBB0_34:                               # %while.body.i53
                                        #   Parent Loop BB0_30 Depth=1
                                        #     Parent Loop BB0_33 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	block   	
	loop    	                # label26:
	copy_local	$push87=, $8
	tee_local	$push86=, $10=, $pop87
	i32.load	$push16=, 0($pop86)
	i32.lt_u	$push17=, $5, $pop16
	br_if   	1, $pop17       # 1: down to label25
# BB#35:                                # %if.else.i59
                                        #   in Loop: Header=BB0_34 Depth=3
	i32.const	$push90=, 28
	i32.add 	$push18=, $9, $pop90
	i32.store	0($pop18), $10
	copy_local	$9=, $10
	i32.load	$push89=, 28($10)
	tee_local	$push88=, $8=, $pop89
	br_if   	0, $pop88       # 0: up to label26
	br      	4               # 4: down to label22
.LBB0_36:                               # %if.then.i56
                                        #   in Loop: Header=BB0_33 Depth=2
	end_loop
	end_block                       # label25:
	i32.const	$push93=, 28
	i32.add 	$push19=, $9, $pop93
	i32.store	0($pop19), $4
	copy_local	$9=, $4
	copy_local	$8=, $10
	i32.load	$push92=, 28($4)
	tee_local	$push91=, $5=, $pop92
	br_if   	0, $pop91       # 0: up to label24
	br      	4               # 4: down to label20
.LBB0_37:                               # %while.end.i64
                                        #   in Loop: Header=BB0_30 Depth=1
	end_loop
	end_block                       # label23:
	i32.const	$push33=, 104
	i32.add 	$push34=, $1, $pop33
	copy_local	$4=, $pop34
	i32.eqz 	$push107=, $5
	br_if   	1, $pop107      # 1: down to label21
# BB#38:                                #   in Loop: Header=BB0_30 Depth=1
	copy_local	$10=, $5
	br      	2               # 2: down to label20
.LBB0_39:                               #   in Loop: Header=BB0_30 Depth=1
	end_block                       # label22:
	copy_local	$8=, $10
	copy_local	$10=, $4
	copy_local	$4=, $8
	br      	1               # 1: down to label20
.LBB0_40:                               #   in Loop: Header=BB0_30 Depth=1
	end_block                       # label21:
	copy_local	$10=, $8
.LBB0_41:                               # %merge_pagelist.exit71
                                        #   in Loop: Header=BB0_30 Depth=1
	end_block                       # label20:
	i32.store	28($4), $10
	i32.const	$push31=, 104
	i32.add 	$push32=, $1, $pop31
	i32.const	$push98=, 28
	i32.add 	$push21=, $pop32, $pop98
	i32.load	$5=, 0($pop21)
	i32.const	$push97=, 1
	i32.add 	$push96=, $2, $pop97
	tee_local	$push95=, $2=, $pop96
	i32.const	$push94=, 25
	i32.ne  	$push20=, $pop95, $pop94
	br_if   	0, $pop20       # 0: up to label19
# BB#42:                                # %for.end20
	end_loop
	i32.const	$push28=, 0
	i32.const	$push26=, 144
	i32.add 	$push27=, $1, $pop26
	i32.store	__stack_pointer($pop28), $pop27
	copy_local	$push108=, $5
                                        # fallthrough-return: $pop108
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
	i32.const	$push19=, 0
	i32.load	$push18=, __stack_pointer($pop19)
	i32.const	$push20=, 208
	i32.sub 	$push29=, $pop18, $pop20
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
	i32.const	$push8=, 148
	i32.add 	$push9=, $1, $pop8
	i32.const	$push27=, 0
	i32.store	0($pop9), $pop27
	i32.const	$push10=, 5
	i32.store	0($1), $pop10
	i32.const	$push11=, 4
	i32.store	40($1), $pop11
	i32.const	$push12=, 1
	i32.store	80($1), $pop12
	i32.const	$push13=, 3
	i32.store	120($1), $pop13
	i32.const	$push14=, 40
	i32.add 	$push15=, $1, $pop14
	i32.store	28($1), $pop15
	block   	
	i32.call	$push26=, sort_pagelist@FUNCTION, $1
	tee_local	$push25=, $0=, $pop26
	i32.load	$push16=, 28($0)
	i32.eq  	$push17=, $pop25, $pop16
	br_if   	0, $pop17       # 0: down to label27
# BB#1:                                 # %if.end
	i32.const	$push24=, 0
	i32.const	$push22=, 208
	i32.add 	$push23=, $1, $pop22
	i32.store	__stack_pointer($pop24), $pop23
	i32.const	$push30=, 0
	return  	$pop30
.LBB1_2:                                # %if.then
	end_block                       # label27:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
