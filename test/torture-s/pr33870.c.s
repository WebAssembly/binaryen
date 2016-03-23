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
	i32.const	$push63=, __stack_pointer
	i32.load	$push64=, 0($pop63)
	i32.const	$push65=, 144
	i32.sub 	$10=, $pop64, $pop65
	i32.const	$push66=, __stack_pointer
	i32.store	$discard=, 0($pop66), $10
	i32.const	$push22=, 0
	i32.const	$push0=, 100
	i32.call	$discard=, memset@FUNCTION, $10, $pop22, $pop0
	i32.const	$8=, 0
	block
	i32.const	$push82=, 0
	i32.eq  	$push83=, $0, $pop82
	br_if   	0, $pop83       # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push8=, 96
	i32.add 	$4=, $10, $pop8
	i32.const	$push74=, 104
	i32.add 	$push75=, $10, $pop74
	i32.const	$push23=, 28
	i32.add 	$1=, $pop75, $pop23
.LBB0_2:                                # %while.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
                                        #       Child Loop BB0_5 Depth 3
                                        #         Child Loop BB0_6 Depth 4
                                        #     Child Loop BB0_20 Depth 2
                                        #       Child Loop BB0_21 Depth 3
	loop                            # label1:
	copy_local	$push26=, $0
	tee_local	$push25=, $7=, $pop26
	i32.load	$0=, 28($pop25)
	i32.const	$push24=, 0
	i32.store	$3=, 28($7), $pop24
	copy_local	$5=, $3
.LBB0_3:                                # %for.body
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_5 Depth 3
                                        #         Child Loop BB0_6 Depth 4
	block
	block
	block
	block
	block
	loop                            # label8:
	i32.const	$push31=, 2
	i32.shl 	$push1=, $5, $pop31
	i32.add 	$push30=, $10, $pop1
	tee_local	$push29=, $9=, $pop30
	i32.load	$push28=, 0($pop29)
	tee_local	$push27=, $8=, $pop28
	i32.const	$push84=, 0
	i32.eq  	$push85=, $pop27, $pop84
	br_if   	2, $pop85       # 2: down to label7
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push76=, 104
	i32.add 	$push77=, $10, $pop76
	copy_local	$6=, $pop77
	copy_local	$2=, $1
	block
	block
	i32.const	$push86=, 0
	i32.eq  	$push87=, $7, $pop86
	br_if   	0, $pop87       # 0: down to label11
.LBB0_5:                                # %while.body.lr.ph.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_6 Depth 4
	block
	loop                            # label13:
	i32.load	$2=, 0($8)
.LBB0_6:                                # %while.body.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        #       Parent Loop BB0_5 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label15:
	i32.load	$push2=, 0($7)
	i32.lt_u	$push3=, $2, $pop2
	br_if   	1, $pop3        # 1: down to label16
# BB#7:                                 # %if.else.i
                                        #   in Loop: Header=BB0_6 Depth=4
	i32.const	$push33=, 28
	i32.add 	$push4=, $6, $pop33
	i32.store	$6=, 0($pop4), $7
	i32.load	$7=, 28($6)
	br_if   	0, $7           # 0: up to label15
	br      	4               # 4: down to label12
.LBB0_8:                                # %if.then.i
                                        #   in Loop: Header=BB0_5 Depth=3
	end_loop                        # label16:
	i32.const	$push32=, 28
	i32.add 	$push5=, $6, $pop32
	i32.store	$6=, 0($pop5), $8
	i32.load	$8=, 28($6)
	i32.const	$push88=, 0
	i32.eq  	$push89=, $7, $pop88
	br_if   	1, $pop89       # 1: down to label14
# BB#9:                                 # %if.then.i
                                        #   in Loop: Header=BB0_5 Depth=3
	br_if   	0, $8           # 0: up to label13
.LBB0_10:                               # %while.end.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_loop                        # label14:
	i32.const	$push35=, 28
	i32.add 	$2=, $6, $pop35
	br_if   	1, $8           # 1: down to label11
# BB#11:                                # %if.else9.i
                                        #   in Loop: Header=BB0_3 Depth=2
	block
	br_if   	0, $7           # 0: down to label17
# BB#12:                                # %if.else13.i
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$discard=, 0($2), $3
	br      	3               # 3: down to label10
.LBB0_13:                               # %if.then11.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label17:
	i32.store	$discard=, 0($2), $7
	br      	2               # 2: down to label10
.LBB0_14:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label12:
	i32.const	$push34=, 28
	i32.add 	$2=, $6, $pop34
.LBB0_15:                               # %if.then7.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label11:
	i32.store	$discard=, 0($2), $8
.LBB0_16:                               # %merge_pagelist.exit
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label10:
	i32.const	$push78=, 104
	i32.add 	$push79=, $10, $pop78
	i32.const	$push40=, 28
	i32.add 	$push39=, $pop79, $pop40
	tee_local	$push38=, $2=, $pop39
	i32.load	$7=, 0($pop38)
	i32.store	$6=, 0($9), $3
	i32.const	$push37=, 1
	i32.add 	$5=, $5, $pop37
	i32.const	$push36=, 24
	i32.lt_s	$push6=, $5, $pop36
	br_if   	0, $pop6        # 0: up to label8
# BB#17:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label9:
	i32.const	$push41=, 24
	i32.ne  	$push7=, $5, $pop41
	br_if   	4, $pop7        # 4: down to label3
# BB#18:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$push43=, 0($4):p2align=4
	tee_local	$push42=, $9=, $pop43
	i32.ne  	$5=, $pop42, $6
	i32.ne  	$3=, $7, $6
	i32.const	$push80=, 104
	i32.add 	$push81=, $10, $pop80
	copy_local	$8=, $pop81
	block
	i32.const	$push90=, 0
	i32.eq  	$push91=, $7, $pop90
	br_if   	0, $pop91       # 0: down to label18
# BB#19:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push92=, 0
	i32.eq  	$push93=, $9, $pop92
	br_if   	0, $pop93       # 0: down to label18
.LBB0_20:                               # %while.body.lr.ph.i85
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_21 Depth 3
	loop                            # label19:
	i32.load	$5=, 0($9)
.LBB0_21:                               # %while.body.i91
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_20 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label21:
	i32.load	$push9=, 0($7)
	i32.lt_u	$push10=, $5, $pop9
	br_if   	1, $pop10       # 1: down to label22
# BB#22:                                # %if.else.i98
                                        #   in Loop: Header=BB0_21 Depth=3
	i32.const	$push45=, 28
	i32.add 	$push11=, $8, $pop45
	i32.store	$8=, 0($pop11), $7
	i32.load	$7=, 28($8)
	br_if   	0, $7           # 0: up to label21
	br      	6               # 6: down to label6
.LBB0_23:                               # %if.then.i95
                                        #   in Loop: Header=BB0_20 Depth=2
	end_loop                        # label22:
	i32.const	$push44=, 28
	i32.add 	$push12=, $8, $pop44
	i32.store	$8=, 0($pop12), $9
	i32.load	$9=, 28($8)
	i32.ne  	$5=, $9, $6
	i32.ne  	$3=, $7, $6
	i32.const	$push94=, 0
	i32.eq  	$push95=, $7, $pop94
	br_if   	1, $pop95       # 1: down to label20
# BB#24:                                # %if.then.i95
                                        #   in Loop: Header=BB0_20 Depth=2
	br_if   	0, $9           # 0: up to label19
.LBB0_25:                               # %while.end.i107
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label20:
	end_block                       # label18:
	i32.const	$push47=, 28
	i32.add 	$8=, $8, $pop47
	br_if   	2, $5           # 2: down to label5
# BB#26:                                # %if.else9.i111
                                        #   in Loop: Header=BB0_2 Depth=1
	block
	br_if   	0, $3           # 0: down to label23
# BB#27:                                # %if.else13.i113
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.store	$discard=, 0($8), $6
	br      	4               # 4: down to label4
.LBB0_28:                               # %if.then11.i112
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label23:
	i32.store	$discard=, 0($8), $7
	br      	3               # 3: down to label4
.LBB0_29:                               # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label7:
	i32.store	$discard=, 0($9), $7
	br      	3               # 3: down to label3
.LBB0_30:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label6:
	i32.const	$push46=, 28
	i32.add 	$8=, $8, $pop46
.LBB0_31:                               # %if.then7.i110
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	i32.store	$discard=, 0($8), $9
.LBB0_32:                               # %merge_pagelist.exit115
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.load	$push13=, 0($2)
	i32.store	$discard=, 0($4):p2align=4, $pop13
.LBB0_33:                               # %while.cond.backedge
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	br_if   	0, $0           # 0: up to label1
# BB#34:                                # %while.end.loopexit
	end_loop                        # label2:
	i32.load	$8=, 0($10):p2align=4
.LBB0_35:                               # %while.end
	end_block                       # label0:
	i32.const	$5=, 1
.LBB0_36:                               # %for.body15
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_38 Depth 2
                                        #       Child Loop BB0_39 Depth 3
	loop                            # label24:
	i32.const	$push52=, 0
	i32.ne  	$2=, $8, $pop52
	i32.const	$push51=, 2
	i32.shl 	$push14=, $5, $pop51
	i32.add 	$push15=, $10, $pop14
	i32.load	$push50=, 0($pop15)
	tee_local	$push49=, $7=, $pop50
	i32.const	$push48=, 0
	i32.ne  	$9=, $pop49, $pop48
	i32.const	$push70=, 104
	i32.add 	$push71=, $10, $pop70
	copy_local	$6=, $pop71
	block
	block
	block
	block
	i32.const	$push96=, 0
	i32.eq  	$push97=, $8, $pop96
	br_if   	0, $pop97       # 0: down to label29
# BB#37:                                # %for.body15
                                        #   in Loop: Header=BB0_36 Depth=1
	i32.const	$push98=, 0
	i32.eq  	$push99=, $7, $pop98
	br_if   	0, $pop99       # 0: down to label29
.LBB0_38:                               # %while.body.lr.ph.i47
                                        #   Parent Loop BB0_36 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_39 Depth 3
	loop                            # label30:
	i32.load	$2=, 0($8)
.LBB0_39:                               # %while.body.i53
                                        #   Parent Loop BB0_36 Depth=1
                                        #     Parent Loop BB0_38 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label32:
	i32.load	$push16=, 0($7)
	i32.lt_u	$push17=, $2, $pop16
	br_if   	1, $pop17       # 1: down to label33
# BB#40:                                # %if.else.i60
                                        #   in Loop: Header=BB0_39 Depth=3
	i32.const	$push56=, 28
	i32.add 	$push18=, $6, $pop56
	i32.store	$6=, 0($pop18), $7
	i32.load	$7=, 28($6)
	br_if   	0, $7           # 0: up to label32
	br      	5               # 5: down to label28
.LBB0_41:                               # %if.then.i57
                                        #   in Loop: Header=BB0_38 Depth=2
	end_loop                        # label33:
	i32.const	$push55=, 28
	i32.add 	$push19=, $6, $pop55
	i32.store	$6=, 0($pop19), $8
	i32.load	$8=, 28($6)
	i32.const	$push54=, 0
	i32.ne  	$2=, $8, $pop54
	i32.const	$push53=, 0
	i32.ne  	$9=, $7, $pop53
	i32.const	$push100=, 0
	i32.eq  	$push101=, $7, $pop100
	br_if   	1, $pop101      # 1: down to label31
# BB#42:                                # %if.then.i57
                                        #   in Loop: Header=BB0_38 Depth=2
	br_if   	0, $8           # 0: up to label30
.LBB0_43:                               # %while.end.i69
                                        #   in Loop: Header=BB0_36 Depth=1
	end_loop                        # label31:
	end_block                       # label29:
	i32.const	$push58=, 28
	i32.add 	$6=, $6, $pop58
	br_if   	1, $2           # 1: down to label27
# BB#44:                                # %if.else9.i73
                                        #   in Loop: Header=BB0_36 Depth=1
	block
	br_if   	0, $9           # 0: down to label34
# BB#45:                                # %if.else13.i75
                                        #   in Loop: Header=BB0_36 Depth=1
	i32.const	$push59=, 0
	i32.store	$discard=, 0($6), $pop59
	br      	3               # 3: down to label26
.LBB0_46:                               # %if.then11.i74
                                        #   in Loop: Header=BB0_36 Depth=1
	end_block                       # label34:
	i32.store	$discard=, 0($6), $7
	br      	2               # 2: down to label26
.LBB0_47:                               #   in Loop: Header=BB0_36 Depth=1
	end_block                       # label28:
	i32.const	$push57=, 28
	i32.add 	$6=, $6, $pop57
.LBB0_48:                               # %if.then7.i72
                                        #   in Loop: Header=BB0_36 Depth=1
	end_block                       # label27:
	i32.store	$discard=, 0($6), $8
.LBB0_49:                               # %merge_pagelist.exit77
                                        #   in Loop: Header=BB0_36 Depth=1
	end_block                       # label26:
	i32.const	$push72=, 104
	i32.add 	$push73=, $10, $pop72
	i32.const	$push62=, 28
	i32.add 	$push20=, $pop73, $pop62
	i32.load	$8=, 0($pop20)
	i32.const	$push61=, 1
	i32.add 	$5=, $5, $pop61
	i32.const	$push60=, 25
	i32.ne  	$push21=, $5, $pop60
	br_if   	0, $pop21       # 0: up to label24
# BB#50:                                # %for.end20
	end_loop                        # label25:
	i32.const	$push69=, __stack_pointer
	i32.const	$push67=, 144
	i32.add 	$push68=, $10, $pop67
	i32.store	$discard=, 0($pop69), $pop68
	return  	$8
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
	i32.const	$push19=, __stack_pointer
	i32.load	$push20=, 0($pop19)
	i32.const	$push21=, 208
	i32.sub 	$2=, $pop20, $pop21
	i32.const	$push22=, __stack_pointer
	i32.store	$discard=, 0($pop22), $2
	i32.const	$push6=, 68
	i32.add 	$push7=, $2, $pop6
	i32.const	$push4=, 80
	i32.add 	$push5=, $2, $pop4
	i32.store	$discard=, 0($pop7), $pop5
	i32.const	$push11=, 108
	i32.add 	$push12=, $2, $pop11
	i32.const	$push9=, 120
	i32.add 	$push10=, $2, $pop9
	i32.store	$discard=, 0($pop12), $pop10
	i32.const	$push0=, 5
	i32.store	$discard=, 0($2):p2align=4, $pop0
	i32.const	$push1=, 40
	i32.add 	$push2=, $2, $pop1
	i32.store	$discard=, 28($2), $pop2
	i32.const	$push3=, 4
	i32.store	$discard=, 40($2):p2align=3, $pop3
	i32.const	$push8=, 1
	i32.store	$discard=, 80($2):p2align=4, $pop8
	i32.const	$push13=, 3
	i32.store	$discard=, 120($2):p2align=3, $pop13
	i32.const	$push14=, 148
	i32.add 	$push15=, $2, $pop14
	i32.const	$push16=, 0
	i32.store	$0=, 0($pop15), $pop16
	i32.call	$1=, sort_pagelist@FUNCTION, $2
	block
	i32.load	$push17=, 28($1)
	i32.eq  	$push18=, $1, $pop17
	br_if   	0, $pop18       # 0: down to label35
# BB#1:                                 # %if.end
	i32.const	$push25=, __stack_pointer
	i32.const	$push23=, 208
	i32.add 	$push24=, $2, $pop23
	i32.store	$discard=, 0($pop25), $pop24
	return  	$0
.LBB1_2:                                # %if.then
	end_block                       # label35:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
