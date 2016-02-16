	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr33870.c"
	.section	.text.sort_pagelist,"ax",@progbits
	.hidden	sort_pagelist
	.globl	sort_pagelist
	.type	sort_pagelist,@function
sort_pagelist:                          # @sort_pagelist
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$11=, __stack_pointer
	i32.load	$11=, 0($11)
	i32.const	$12=, 144
	i32.sub 	$20=, $11, $12
	i32.const	$12=, __stack_pointer
	i32.store	$20=, 0($12), $20
	i32.const	$push22=, 0
	i32.const	$push0=, 100
	i32.call	$discard=, memset@FUNCTION, $20, $pop22, $pop0
	i32.const	$9=, 0
	block
	i32.const	$push63=, 0
	i32.eq  	$push64=, $0, $pop63
	br_if   	0, $pop64       # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push8=, 96
	i32.add 	$4=, $20, $pop8
	i32.const	$push23=, 28
	i32.const	$16=, 104
	i32.add 	$16=, $20, $16
	i32.add 	$1=, $16, $pop23
.LBB0_2:                                # %while.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
                                        #       Child Loop BB0_5 Depth 3
                                        #         Child Loop BB0_6 Depth 4
                                        #     Child Loop BB0_19 Depth 2
                                        #       Child Loop BB0_20 Depth 3
	loop                            # label1:
	copy_local	$push26=, $0
	tee_local	$push25=, $8=, $pop26
	i32.load	$0=, 28($pop25)
	i32.const	$push24=, 0
	i32.store	$3=, 28($8), $pop24
	copy_local	$5=, $3
.LBB0_3:                                # %for.body
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_5 Depth 3
                                        #         Child Loop BB0_6 Depth 4
	block
	block
	loop                            # label5:
	i32.const	$push31=, 2
	i32.shl 	$push1=, $5, $pop31
	i32.add 	$push30=, $20, $pop1
	tee_local	$push29=, $10=, $pop30
	i32.load	$push28=, 0($pop29)
	tee_local	$push27=, $9=, $pop28
	i32.const	$push65=, 0
	i32.eq  	$push66=, $pop27, $pop65
	br_if   	2, $pop66       # 2: down to label4
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$17=, 104
	i32.add 	$17=, $20, $17
	copy_local	$6=, $17
	copy_local	$7=, $1
	block
	block
	i32.const	$push67=, 0
	i32.eq  	$push68=, $8, $pop67
	br_if   	0, $pop68       # 0: down to label8
.LBB0_5:                                # %while.body.lr.ph.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_6 Depth 4
	loop                            # label9:
	i32.load	$2=, 0($9)
.LBB0_6:                                # %while.body.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        #       Parent Loop BB0_5 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label11:
	i32.load	$push2=, 0($8)
	i32.lt_u	$push3=, $2, $pop2
	br_if   	1, $pop3        # 1: down to label12
# BB#7:                                 # %if.else.i
                                        #   in Loop: Header=BB0_6 Depth=4
	i32.const	$push34=, 28
	i32.add 	$push4=, $6, $pop34
	i32.store	$6=, 0($pop4), $8
	i32.load	$8=, 28($6)
	i32.const	$push33=, 28
	i32.add 	$7=, $6, $pop33
	br_if   	0, $8           # 0: up to label11
	br      	4               # 4: down to label8
.LBB0_8:                                # %if.then.i
                                        #   in Loop: Header=BB0_5 Depth=3
	end_loop                        # label12:
	i32.const	$push32=, 28
	i32.add 	$push5=, $6, $pop32
	i32.store	$6=, 0($pop5), $9
	i32.load	$9=, 28($6)
	i32.const	$push69=, 0
	i32.eq  	$push70=, $8, $pop69
	br_if   	1, $pop70       # 1: down to label10
# BB#9:                                 # %if.then.i
                                        #   in Loop: Header=BB0_5 Depth=3
	br_if   	0, $9           # 0: up to label9
.LBB0_10:                               # %while.end.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_loop                        # label10:
	i32.const	$push35=, 28
	i32.add 	$7=, $6, $pop35
	br_if   	0, $9           # 0: down to label8
# BB#11:                                # %if.else9.i
                                        #   in Loop: Header=BB0_3 Depth=2
	block
	i32.const	$push71=, 0
	i32.eq  	$push72=, $8, $pop71
	br_if   	0, $pop72       # 0: down to label13
# BB#12:                                # %if.then11.i
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$discard=, 0($7), $8
	br      	2               # 2: down to label7
.LBB0_13:                               # %if.else13.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label13:
	i32.store	$discard=, 0($7), $3
	br      	1               # 1: down to label7
.LBB0_14:                               # %if.then7.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label8:
	i32.store	$discard=, 0($7), $9
.LBB0_15:                               # %merge_pagelist.exit
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label7:
	i32.const	$push40=, 28
	i32.const	$18=, 104
	i32.add 	$18=, $20, $18
	i32.add 	$push39=, $18, $pop40
	tee_local	$push38=, $7=, $pop39
	i32.load	$8=, 0($pop38)
	i32.store	$6=, 0($10), $3
	i32.const	$push37=, 1
	i32.add 	$5=, $5, $pop37
	i32.const	$push36=, 24
	i32.lt_s	$push6=, $5, $pop36
	br_if   	0, $pop6        # 0: up to label5
# BB#16:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label6:
	i32.const	$push41=, 24
	i32.ne  	$push7=, $5, $pop41
	br_if   	1, $pop7        # 1: down to label3
# BB#17:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$push43=, 0($4):p2align=4
	tee_local	$push42=, $10=, $pop43
	i32.ne  	$5=, $pop42, $6
	i32.ne  	$3=, $8, $6
	i32.const	$19=, 104
	i32.add 	$19=, $20, $19
	copy_local	$2=, $19
	block
	block
	block
	i32.const	$push73=, 0
	i32.eq  	$push74=, $8, $pop73
	br_if   	0, $pop74       # 0: down to label16
# BB#18:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push75=, 0
	i32.eq  	$push76=, $10, $pop75
	br_if   	0, $pop76       # 0: down to label16
.LBB0_19:                               # %while.body.lr.ph.i85
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_20 Depth 3
	loop                            # label17:
	i32.load	$5=, 0($10)
.LBB0_20:                               # %while.body.i91
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_19 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label19:
	i32.load	$push9=, 0($8)
	i32.lt_u	$push10=, $5, $pop9
	br_if   	1, $pop10       # 1: down to label20
# BB#21:                                # %if.else.i98
                                        #   in Loop: Header=BB0_20 Depth=3
	i32.const	$push46=, 28
	i32.add 	$push11=, $2, $pop46
	i32.store	$2=, 0($pop11), $8
	i32.load	$8=, 28($2)
	i32.const	$push45=, 28
	i32.add 	$9=, $2, $pop45
	br_if   	0, $8           # 0: up to label19
	br      	5               # 5: down to label15
.LBB0_22:                               # %if.then.i95
                                        #   in Loop: Header=BB0_19 Depth=2
	end_loop                        # label20:
	i32.const	$push44=, 28
	i32.add 	$push12=, $2, $pop44
	i32.store	$2=, 0($pop12), $10
	i32.load	$10=, 28($2)
	i32.ne  	$5=, $10, $6
	i32.ne  	$3=, $8, $6
	i32.const	$push77=, 0
	i32.eq  	$push78=, $8, $pop77
	br_if   	1, $pop78       # 1: down to label18
# BB#23:                                # %if.then.i95
                                        #   in Loop: Header=BB0_19 Depth=2
	br_if   	0, $10          # 0: up to label17
.LBB0_24:                               # %while.end.i107
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label18:
	end_block                       # label16:
	i32.const	$push47=, 28
	i32.add 	$9=, $2, $pop47
	br_if   	0, $5           # 0: down to label15
# BB#25:                                # %if.else9.i111
                                        #   in Loop: Header=BB0_2 Depth=1
	block
	i32.const	$push79=, 0
	i32.eq  	$push80=, $3, $pop79
	br_if   	0, $pop80       # 0: down to label21
# BB#26:                                # %if.then11.i112
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.store	$discard=, 0($9), $8
	br      	2               # 2: down to label14
.LBB0_27:                               # %if.else13.i113
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label21:
	i32.store	$discard=, 0($9), $6
	br      	1               # 1: down to label14
.LBB0_28:                               # %if.then7.i110
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label15:
	i32.store	$discard=, 0($9), $10
.LBB0_29:                               # %merge_pagelist.exit115
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label14:
	i32.load	$push13=, 0($7)
	i32.store	$discard=, 0($4):p2align=4, $pop13
	br      	1               # 1: down to label3
.LBB0_30:                               # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.store	$discard=, 0($10), $8
.LBB0_31:                               # %while.cond.backedge
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	br_if   	0, $0           # 0: up to label1
# BB#32:                                # %while.end.loopexit
	end_loop                        # label2:
	i32.load	$9=, 0($20):p2align=4
.LBB0_33:                               # %while.end
	end_block                       # label0:
	i32.const	$5=, 1
.LBB0_34:                               # %for.body15
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_36 Depth 2
                                        #       Child Loop BB0_37 Depth 3
	loop                            # label22:
	i32.const	$push52=, 0
	i32.ne  	$2=, $9, $pop52
	i32.const	$push51=, 2
	i32.shl 	$push14=, $5, $pop51
	i32.add 	$push15=, $20, $pop14
	i32.load	$push50=, 0($pop15)
	tee_local	$push49=, $8=, $pop50
	i32.const	$push48=, 0
	i32.ne  	$10=, $pop49, $pop48
	i32.const	$14=, 104
	i32.add 	$14=, $20, $14
	copy_local	$6=, $14
	block
	block
	block
	i32.const	$push81=, 0
	i32.eq  	$push82=, $9, $pop81
	br_if   	0, $pop82       # 0: down to label26
# BB#35:                                # %for.body15
                                        #   in Loop: Header=BB0_34 Depth=1
	i32.const	$push83=, 0
	i32.eq  	$push84=, $8, $pop83
	br_if   	0, $pop84       # 0: down to label26
.LBB0_36:                               # %while.body.lr.ph.i47
                                        #   Parent Loop BB0_34 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_37 Depth 3
	loop                            # label27:
	i32.load	$2=, 0($9)
.LBB0_37:                               # %while.body.i53
                                        #   Parent Loop BB0_34 Depth=1
                                        #     Parent Loop BB0_36 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label29:
	i32.load	$push16=, 0($8)
	i32.lt_u	$push17=, $2, $pop16
	br_if   	1, $pop17       # 1: down to label30
# BB#38:                                # %if.else.i60
                                        #   in Loop: Header=BB0_37 Depth=3
	i32.const	$push57=, 28
	i32.add 	$push18=, $6, $pop57
	i32.store	$6=, 0($pop18), $8
	i32.load	$8=, 28($6)
	i32.const	$push56=, 28
	i32.add 	$7=, $6, $pop56
	br_if   	0, $8           # 0: up to label29
	br      	5               # 5: down to label25
.LBB0_39:                               # %if.then.i57
                                        #   in Loop: Header=BB0_36 Depth=2
	end_loop                        # label30:
	i32.const	$push55=, 28
	i32.add 	$push19=, $6, $pop55
	i32.store	$6=, 0($pop19), $9
	i32.load	$9=, 28($6)
	i32.const	$push54=, 0
	i32.ne  	$2=, $9, $pop54
	i32.const	$push53=, 0
	i32.ne  	$10=, $8, $pop53
	i32.const	$push85=, 0
	i32.eq  	$push86=, $8, $pop85
	br_if   	1, $pop86       # 1: down to label28
# BB#40:                                # %if.then.i57
                                        #   in Loop: Header=BB0_36 Depth=2
	br_if   	0, $9           # 0: up to label27
.LBB0_41:                               # %while.end.i69
                                        #   in Loop: Header=BB0_34 Depth=1
	end_loop                        # label28:
	end_block                       # label26:
	i32.const	$push58=, 28
	i32.add 	$7=, $6, $pop58
	br_if   	0, $2           # 0: down to label25
# BB#42:                                # %if.else9.i73
                                        #   in Loop: Header=BB0_34 Depth=1
	block
	i32.const	$push87=, 0
	i32.eq  	$push88=, $10, $pop87
	br_if   	0, $pop88       # 0: down to label31
# BB#43:                                # %if.then11.i74
                                        #   in Loop: Header=BB0_34 Depth=1
	i32.store	$discard=, 0($7), $8
	br      	2               # 2: down to label24
.LBB0_44:                               # %if.else13.i75
                                        #   in Loop: Header=BB0_34 Depth=1
	end_block                       # label31:
	i32.const	$push59=, 0
	i32.store	$discard=, 0($7), $pop59
	br      	1               # 1: down to label24
.LBB0_45:                               # %if.then7.i72
                                        #   in Loop: Header=BB0_34 Depth=1
	end_block                       # label25:
	i32.store	$discard=, 0($7), $9
.LBB0_46:                               # %merge_pagelist.exit77
                                        #   in Loop: Header=BB0_34 Depth=1
	end_block                       # label24:
	i32.const	$push62=, 28
	i32.const	$15=, 104
	i32.add 	$15=, $20, $15
	i32.add 	$push20=, $15, $pop62
	i32.load	$9=, 0($pop20)
	i32.const	$push61=, 1
	i32.add 	$5=, $5, $pop61
	i32.const	$push60=, 25
	i32.ne  	$push21=, $5, $pop60
	br_if   	0, $pop21       # 0: up to label22
# BB#47:                                # %for.end20
	end_loop                        # label23:
	i32.const	$13=, 144
	i32.add 	$20=, $20, $13
	i32.const	$13=, __stack_pointer
	i32.store	$20=, 0($13), $20
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
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 208
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.const	$push6=, 68
	i32.add 	$push7=, $5, $pop6
	i32.const	$push4=, 80
	i32.add 	$push5=, $5, $pop4
	i32.store	$discard=, 0($pop7), $pop5
	i32.const	$push11=, 108
	i32.add 	$push12=, $5, $pop11
	i32.const	$push9=, 120
	i32.add 	$push10=, $5, $pop9
	i32.store	$discard=, 0($pop12), $pop10
	i32.const	$push0=, 5
	i32.store	$discard=, 0($5):p2align=4, $pop0
	i32.const	$push1=, 40
	i32.add 	$push2=, $5, $pop1
	i32.store	$discard=, 28($5), $pop2
	i32.const	$push3=, 4
	i32.store	$discard=, 40($5):p2align=3, $pop3
	i32.const	$push8=, 1
	i32.store	$discard=, 80($5):p2align=4, $pop8
	i32.const	$push13=, 3
	i32.store	$discard=, 120($5):p2align=3, $pop13
	i32.const	$push14=, 148
	i32.add 	$push15=, $5, $pop14
	i32.const	$push16=, 0
	i32.store	$0=, 0($pop15), $pop16
	i32.call	$1=, sort_pagelist@FUNCTION, $5
	block
	i32.load	$push17=, 28($1)
	i32.eq  	$push18=, $1, $pop17
	br_if   	0, $pop18       # 0: down to label32
# BB#1:                                 # %if.end
	i32.const	$4=, 208
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return  	$0
.LBB1_2:                                # %if.then
	end_block                       # label32:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
