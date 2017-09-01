	.text
	.file	"pr33870.c"
	.section	.text.sort_pagelist,"ax",@progbits
	.hidden	sort_pagelist           # -- Begin function sort_pagelist
	.globl	sort_pagelist
	.type	sort_pagelist,@function
sort_pagelist:                          # @sort_pagelist
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push28=, 0
	i32.const	$push26=, 0
	i32.load	$push25=, __stack_pointer($pop26)
	i32.const	$push27=, 144
	i32.sub 	$push48=, $pop25, $pop27
	tee_local	$push47=, $3=, $pop48
	i32.store	__stack_pointer($pop28), $pop47
	i32.const	$push46=, 0
	i32.const	$push0=, 100
	i32.call	$1=, memset@FUNCTION, $3, $pop46, $pop0
	i32.const	$3=, 0
	block   	
	i32.eqz 	$push99=, $0
	br_if   	0, $pop99       # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push36=, 104
	i32.add 	$push37=, $1, $pop36
	i32.const	$push49=, 28
	i32.add 	$2=, $pop37, $pop49
	i32.const	$push8=, 96
	i32.add 	$5=, $1, $pop8
.LBB0_2:                                # %while.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
                                        #       Child Loop BB0_6 Depth 3
                                        #     Child Loop BB0_18 Depth 2
	loop    	                # label1:
	copy_local	$push52=, $0
	tee_local	$push51=, $3=, $pop52
	i32.load	$0=, 28($pop51)
	i32.const	$push50=, 0
	i32.store	28($3), $pop50
	i32.const	$6=, 0
.LBB0_3:                                # %for.body
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_6 Depth 3
	block   	
	block   	
	block   	
	block   	
	block   	
	loop    	                # label7:
	i32.const	$push57=, 2
	i32.shl 	$push1=, $6, $pop57
	i32.add 	$push56=, $1, $pop1
	tee_local	$push55=, $4=, $pop56
	i32.load	$push54=, 0($pop55)
	tee_local	$push53=, $9=, $pop54
	i32.eqz 	$push100=, $pop53
	br_if   	1, $pop100      # 1: down to label6
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	block   	
	block   	
	block   	
	i32.eqz 	$push101=, $3
	br_if   	0, $pop101      # 0: down to label10
# BB#5:                                 # %while.body.i.preheader
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push44=, 104
	i32.add 	$push45=, $1, $pop44
	copy_local	$7=, $pop45
	copy_local	$8=, $9
.LBB0_6:                                # %while.body.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	block   	
	loop    	                # label12:
	block   	
	block   	
	i32.load	$push3=, 0($8)
	i32.load	$push2=, 0($3)
	i32.ge_u	$push4=, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label14
# BB#7:                                 # %if.then.i
                                        #   in Loop: Header=BB0_6 Depth=3
	i32.const	$push60=, 28
	i32.add 	$push6=, $7, $pop60
	i32.store	0($pop6), $8
	copy_local	$10=, $3
	copy_local	$7=, $8
	i32.load	$push59=, 28($8)
	tee_local	$push58=, $9=, $pop59
	br_if   	1, $pop58       # 1: down to label13
	br      	3               # 3: down to label11
.LBB0_8:                                # %if.else.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_block                       # label14:
	i32.const	$push63=, 28
	i32.add 	$push5=, $7, $pop63
	i32.store	0($pop5), $3
	i32.load	$10=, 28($3)
	copy_local	$7=, $3
	copy_local	$push62=, $8
	tee_local	$push61=, $9=, $pop62
	i32.eqz 	$push102=, $pop61
	br_if   	2, $pop102      # 2: down to label11
.LBB0_9:                                # %if.end.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_block                       # label13:
	copy_local	$3=, $10
	copy_local	$8=, $9
	br_if   	0, $10          # 0: up to label12
.LBB0_10:                               # %merge_pagelist.exit
                                        #   in Loop: Header=BB0_3 Depth=2
	end_loop
	end_block                       # label11:
	br_if   	1, $9           # 1: down to label9
	br      	2               # 2: down to label8
.LBB0_11:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label10:
	i32.const	$push38=, 104
	i32.add 	$push39=, $1, $pop38
	copy_local	$7=, $pop39
.LBB0_12:                               # %merge_pagelist.exit.thread
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label9:
	copy_local	$10=, $9
.LBB0_13:                               # %for.cond
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label8:
	i32.store	28($7), $10
	i32.const	$push40=, 104
	i32.add 	$push41=, $1, $pop40
	i32.const	$push71=, 28
	i32.add 	$push70=, $pop41, $pop71
	tee_local	$push69=, $9=, $pop70
	i32.load	$3=, 0($pop69)
	i32.const	$push68=, 0
	i32.store	0($4), $pop68
	i32.const	$push67=, 23
	i32.lt_u	$8=, $6, $pop67
	i32.const	$push66=, 1
	i32.add 	$push65=, $6, $pop66
	tee_local	$push64=, $10=, $pop65
	copy_local	$6=, $pop64
	br_if   	0, $8           # 0: up to label7
# BB#14:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop
	i32.const	$push72=, 24
	i32.ne  	$push7=, $10, $pop72
	br_if   	1, $pop7        # 1: down to label5
# BB#15:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$push75=, 0($5)
	tee_local	$push74=, $8=, $pop75
	i32.const	$push73=, 0
	i32.ne  	$4=, $pop74, $pop73
	i32.eqz 	$push103=, $3
	br_if   	2, $pop103      # 2: down to label4
# BB#16:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.eqz 	$push104=, $8
	br_if   	2, $pop104      # 2: down to label4
# BB#17:                                # %while.body.i81.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push42=, 104
	i32.add 	$push43=, $1, $pop42
	copy_local	$6=, $pop43
.LBB0_18:                               # %while.body.i81
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label16:
	block   	
	block   	
	i32.load	$push10=, 0($8)
	i32.load	$push9=, 0($3)
	i32.ge_u	$push11=, $pop10, $pop9
	br_if   	0, $pop11       # 0: down to label18
# BB#19:                                # %if.then.i83
                                        #   in Loop: Header=BB0_18 Depth=2
	i32.const	$push78=, 28
	i32.add 	$push13=, $6, $pop78
	i32.store	0($pop13), $8
	copy_local	$10=, $3
	copy_local	$6=, $8
	i32.load	$push77=, 28($8)
	tee_local	$push76=, $7=, $pop77
	br_if   	1, $pop76       # 1: down to label17
	br      	3               # 3: down to label15
.LBB0_20:                               # %if.else.i85
                                        #   in Loop: Header=BB0_18 Depth=2
	end_block                       # label18:
	i32.const	$push81=, 28
	i32.add 	$push12=, $6, $pop81
	i32.store	0($pop12), $3
	i32.load	$10=, 28($3)
	copy_local	$6=, $3
	copy_local	$push80=, $8
	tee_local	$push79=, $7=, $pop80
	i32.eqz 	$push105=, $pop79
	br_if   	2, $pop105      # 2: down to label15
.LBB0_21:                               # %if.end.i91
                                        #   in Loop: Header=BB0_18 Depth=2
	end_block                       # label17:
	copy_local	$3=, $10
	copy_local	$8=, $7
	br_if   	0, $10          # 0: up to label16
.LBB0_22:                               # %merge_pagelist.exit99.loopexit
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop
	end_block                       # label15:
	i32.const	$push83=, 0
	i32.ne  	$4=, $7, $pop83
	i32.const	$push82=, 28
	i32.add 	$6=, $6, $pop82
	br      	3               # 3: down to label3
.LBB0_23:                               # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label6:
	i32.store	0($4), $3
.LBB0_24:                               # %if.end11
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	br_if   	3, $0           # 3: up to label1
	br      	2               # 2: down to label2
.LBB0_25:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	copy_local	$6=, $2
	copy_local	$7=, $8
	copy_local	$10=, $3
.LBB0_26:                               # %merge_pagelist.exit99
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.select	$push14=, $7, $10, $4
	i32.store	0($6), $pop14
	i32.load	$push15=, 0($9)
	i32.store	0($5), $pop15
	br_if   	1, $0           # 1: up to label1
.LBB0_27:                               # %while.end.loopexit
	end_block                       # label2:
	end_loop
	i32.load	$3=, 0($1)
.LBB0_28:                               # %while.end
	end_block                       # label0:
	i32.const	$push32=, 104
	i32.add 	$push33=, $1, $pop32
	i32.const	$push84=, 28
	i32.add 	$0=, $pop33, $pop84
	i32.const	$6=, 1
.LBB0_29:                               # %for.body15
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_32 Depth 2
	loop    	                # label19:
	i32.const	$push86=, 0
	i32.ne  	$4=, $3, $pop86
	i32.const	$push85=, 2
	i32.shl 	$push16=, $6, $pop85
	i32.add 	$push17=, $1, $pop16
	i32.load	$8=, 0($pop17)
	block   	
	block   	
	i32.eqz 	$push106=, $3
	br_if   	0, $pop106      # 0: down to label21
# BB#30:                                # %for.body15
                                        #   in Loop: Header=BB0_29 Depth=1
	i32.eqz 	$push107=, $8
	br_if   	0, $pop107      # 0: down to label21
# BB#31:                                # %while.body.i51.preheader
                                        #   in Loop: Header=BB0_29 Depth=1
	i32.const	$push34=, 104
	i32.add 	$push35=, $1, $pop34
	copy_local	$7=, $pop35
.LBB0_32:                               # %while.body.i51
                                        #   Parent Loop BB0_29 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label23:
	block   	
	block   	
	i32.load	$push19=, 0($3)
	i32.load	$push18=, 0($8)
	i32.ge_u	$push20=, $pop19, $pop18
	br_if   	0, $pop20       # 0: down to label25
# BB#33:                                # %if.then.i53
                                        #   in Loop: Header=BB0_32 Depth=2
	i32.const	$push89=, 28
	i32.add 	$push22=, $7, $pop89
	i32.store	0($pop22), $3
	copy_local	$10=, $8
	copy_local	$7=, $3
	i32.load	$push88=, 28($3)
	tee_local	$push87=, $9=, $pop88
	br_if   	1, $pop87       # 1: down to label24
	br      	3               # 3: down to label22
.LBB0_34:                               # %if.else.i55
                                        #   in Loop: Header=BB0_32 Depth=2
	end_block                       # label25:
	i32.const	$push92=, 28
	i32.add 	$push21=, $7, $pop92
	i32.store	0($pop21), $8
	i32.load	$10=, 28($8)
	copy_local	$7=, $8
	copy_local	$push91=, $3
	tee_local	$push90=, $9=, $pop91
	i32.eqz 	$push108=, $pop90
	br_if   	2, $pop108      # 2: down to label22
.LBB0_35:                               # %if.end.i61
                                        #   in Loop: Header=BB0_32 Depth=2
	end_block                       # label24:
	copy_local	$8=, $10
	copy_local	$3=, $9
	br_if   	0, $10          # 0: up to label23
.LBB0_36:                               # %merge_pagelist.exit69.loopexit
                                        #   in Loop: Header=BB0_29 Depth=1
	end_loop
	end_block                       # label22:
	i32.const	$push94=, 0
	i32.ne  	$4=, $9, $pop94
	i32.const	$push93=, 28
	i32.add 	$7=, $7, $pop93
	br      	1               # 1: down to label20
.LBB0_37:                               #   in Loop: Header=BB0_29 Depth=1
	end_block                       # label21:
	copy_local	$7=, $0
	copy_local	$9=, $3
	copy_local	$10=, $8
.LBB0_38:                               # %merge_pagelist.exit69
                                        #   in Loop: Header=BB0_29 Depth=1
	end_block                       # label20:
	i32.select	$push23=, $9, $10, $4
	i32.store	0($7), $pop23
	i32.load	$3=, 0($0)
	i32.const	$push98=, 1
	i32.add 	$push97=, $6, $pop98
	tee_local	$push96=, $6=, $pop97
	i32.const	$push95=, 25
	i32.ne  	$push24=, $pop96, $pop95
	br_if   	0, $pop24       # 0: up to label19
# BB#39:                                # %for.end20
	end_loop
	i32.const	$push31=, 0
	i32.const	$push29=, 144
	i32.add 	$push30=, $1, $pop29
	i32.store	__stack_pointer($pop31), $pop30
	copy_local	$push109=, $3
                                        # fallthrough-return: $pop109
	.endfunc
.Lfunc_end0:
	.size	sort_pagelist, .Lfunc_end0-sort_pagelist
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
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
                                        # -- End function

	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
