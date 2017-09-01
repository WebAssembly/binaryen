	.text
	.file	"pr33870-1.c"
	.section	.text.sort_pagelist,"ax",@progbits
	.hidden	sort_pagelist           # -- Begin function sort_pagelist
	.globl	sort_pagelist
	.type	sort_pagelist,@function
sort_pagelist:                          # @sort_pagelist
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push42=, 0
	i32.const	$push40=, 0
	i32.load	$push39=, __stack_pointer($pop40)
	i32.const	$push41=, 160
	i32.sub 	$push66=, $pop39, $pop41
	tee_local	$push65=, $4=, $pop66
	i32.store	__stack_pointer($pop42), $pop65
	i32.const	$push64=, 0
	i32.const	$push0=, 100
	i32.call	$1=, memset@FUNCTION, $4, $pop64, $pop0
	i32.const	$4=, 0
	block   	
	i32.eqz 	$push122=, $0
	br_if   	0, $pop122      # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push52=, 112
	i32.add 	$push53=, $1, $pop52
	i32.const	$push68=, 32
	i32.add 	$3=, $pop53, $pop68
	i32.const	$push54=, 112
	i32.add 	$push55=, $1, $pop54
	i32.const	$push67=, 32
	i32.add 	$2=, $pop55, $pop67
	i32.const	$push13=, 96
	i32.add 	$6=, $1, $pop13
.LBB0_2:                                # %while.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
                                        #       Child Loop BB0_6 Depth 3
                                        #     Child Loop BB0_19 Depth 2
	loop    	                # label1:
	copy_local	$push74=, $0
	tee_local	$push73=, $4=, $pop74
	i32.const	$push72=, 32
	i32.add 	$push71=, $pop73, $pop72
	tee_local	$push70=, $9=, $pop71
	i32.load	$0=, 0($pop70)
	i32.const	$push69=, 0
	i32.store	0($9), $pop69
	i32.const	$7=, 0
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
	i32.const	$push79=, 2
	i32.shl 	$push1=, $7, $pop79
	i32.add 	$push78=, $1, $pop1
	tee_local	$push77=, $5=, $pop78
	i32.load	$push76=, 0($pop77)
	tee_local	$push75=, $9=, $pop76
	i32.eqz 	$push123=, $pop75
	br_if   	1, $pop123      # 1: down to label6
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push80=, 0
	i32.store	xx($pop80), $2
	block   	
	block   	
	block   	
	i32.eqz 	$push124=, $4
	br_if   	0, $pop124      # 0: down to label10
# BB#5:                                 # %while.body.i.preheader
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push60=, 112
	i32.add 	$push61=, $1, $pop60
	copy_local	$8=, $pop61
.LBB0_6:                                # %while.body.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label11:
	block   	
	block   	
	i32.load	$push3=, 4($9)
	i32.load	$push2=, 4($4)
	i32.ge_u	$push4=, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label13
# BB#7:                                 # %if.then.i
                                        #   in Loop: Header=BB0_6 Depth=3
	i32.const	$push82=, 32
	i32.add 	$push7=, $8, $pop82
	i32.store	0($pop7), $9
	i32.const	$push81=, 32
	i32.add 	$push8=, $9, $pop81
	i32.load	$10=, 0($pop8)
	copy_local	$11=, $4
	copy_local	$8=, $9
	br      	1               # 1: down to label12
.LBB0_8:                                # %if.else.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_block                       # label13:
	i32.const	$push84=, 32
	i32.add 	$push5=, $8, $pop84
	i32.store	0($pop5), $4
	i32.const	$push83=, 32
	i32.add 	$push6=, $4, $pop83
	i32.load	$11=, 0($pop6)
	copy_local	$10=, $9
	copy_local	$8=, $4
.LBB0_9:                                # %if.end.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_block                       # label12:
	block   	
	i32.const	$push86=, 0
	i32.const	$push62=, 112
	i32.add 	$push63=, $1, $pop62
	i32.const	$push85=, 32
	i32.add 	$push9=, $pop63, $pop85
	i32.load	$push10=, 0($pop9)
	i32.load	$push11=, 0($pop10)
	i32.store	vx($pop86), $pop11
	i32.eqz 	$push125=, $10
	br_if   	0, $pop125      # 0: down to label14
# BB#10:                                # %if.end.i
                                        #   in Loop: Header=BB0_6 Depth=3
	copy_local	$4=, $11
	copy_local	$9=, $10
	br_if   	1, $11          # 1: up to label11
.LBB0_11:                               # %merge_pagelist.exit
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label14:
	end_loop
	i32.const	$push87=, 32
	i32.add 	$4=, $8, $pop87
	br_if   	1, $10          # 1: down to label9
	br      	2               # 2: down to label8
.LBB0_12:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label10:
	copy_local	$10=, $9
	copy_local	$4=, $2
.LBB0_13:                               # %merge_pagelist.exit.thread
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label9:
	copy_local	$11=, $10
.LBB0_14:                               # %for.cond
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label8:
	i32.store	0($4), $11
	i32.const	$push56=, 112
	i32.add 	$push57=, $1, $pop56
	i32.const	$push95=, 32
	i32.add 	$push94=, $pop57, $pop95
	tee_local	$push93=, $10=, $pop94
	i32.load	$4=, 0($pop93)
	i32.const	$push92=, 0
	i32.store	0($5), $pop92
	i32.const	$push91=, 23
	i32.lt_u	$9=, $7, $pop91
	i32.const	$push90=, 1
	i32.add 	$push89=, $7, $pop90
	tee_local	$push88=, $11=, $pop89
	copy_local	$7=, $pop88
	br_if   	0, $9           # 0: up to label7
# BB#15:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop
	i32.const	$push96=, 24
	i32.ne  	$push12=, $11, $pop96
	br_if   	1, $pop12       # 1: down to label5
# BB#16:                                # %if.then9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$9=, 0($6)
	i32.const	$push98=, 0
	i32.store	xx($pop98), $3
	i32.const	$push97=, 0
	i32.ne  	$5=, $9, $pop97
	i32.eqz 	$push126=, $4
	br_if   	2, $pop126      # 2: down to label4
# BB#17:                                # %if.then9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.eqz 	$push127=, $9
	br_if   	2, $pop127      # 2: down to label4
# BB#18:                                # %while.body.i87.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push58=, 112
	i32.add 	$push59=, $1, $pop58
	copy_local	$7=, $pop59
.LBB0_19:                               # %while.body.i87
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label15:
	block   	
	block   	
	i32.load	$push15=, 4($9)
	i32.load	$push14=, 4($4)
	i32.ge_u	$push16=, $pop15, $pop14
	br_if   	0, $pop16       # 0: down to label17
# BB#20:                                # %if.then.i89
                                        #   in Loop: Header=BB0_19 Depth=2
	i32.const	$push100=, 32
	i32.add 	$push19=, $7, $pop100
	i32.store	0($pop19), $9
	i32.const	$push99=, 32
	i32.add 	$push20=, $9, $pop99
	i32.load	$11=, 0($pop20)
	copy_local	$8=, $4
	copy_local	$7=, $9
	br      	1               # 1: down to label16
.LBB0_21:                               # %if.else.i91
                                        #   in Loop: Header=BB0_19 Depth=2
	end_block                       # label17:
	i32.const	$push102=, 32
	i32.add 	$push17=, $7, $pop102
	i32.store	0($pop17), $4
	i32.const	$push101=, 32
	i32.add 	$push18=, $4, $pop101
	i32.load	$8=, 0($pop18)
	copy_local	$11=, $9
	copy_local	$7=, $4
.LBB0_22:                               # %if.end.i98
                                        #   in Loop: Header=BB0_19 Depth=2
	end_block                       # label16:
	block   	
	i32.const	$push103=, 0
	i32.load	$push21=, 0($10)
	i32.load	$push22=, 0($pop21)
	i32.store	vx($pop103), $pop22
	i32.eqz 	$push128=, $11
	br_if   	0, $pop128      # 0: down to label18
# BB#23:                                # %if.end.i98
                                        #   in Loop: Header=BB0_19 Depth=2
	copy_local	$4=, $8
	copy_local	$9=, $11
	br_if   	1, $8           # 1: up to label15
.LBB0_24:                               # %while.end.loopexit.i100
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label18:
	end_loop
	i32.const	$push105=, 0
	i32.ne  	$5=, $11, $pop105
	i32.const	$push104=, 32
	i32.add 	$7=, $7, $pop104
	br      	3               # 3: down to label3
.LBB0_25:                               # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label6:
	i32.store	0($5), $4
.LBB0_26:                               # %if.end13
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	br_if   	3, $0           # 3: up to label1
	br      	2               # 2: down to label2
.LBB0_27:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	copy_local	$7=, $3
	copy_local	$11=, $9
	copy_local	$8=, $4
.LBB0_28:                               # %merge_pagelist.exit106
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.select	$push23=, $11, $8, $5
	i32.store	0($7), $pop23
	i32.load	$push24=, 0($10)
	i32.store	0($6), $pop24
	br_if   	1, $0           # 1: up to label1
.LBB0_29:                               # %while.end.loopexit
	end_block                       # label2:
	end_loop
	i32.load	$4=, 0($1)
.LBB0_30:                               # %while.end
	end_block                       # label0:
	i32.const	$push46=, 112
	i32.add 	$push47=, $1, $pop46
	i32.const	$push106=, 32
	i32.add 	$5=, $pop47, $pop106
	i32.const	$7=, 1
.LBB0_31:                               # %for.body17
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_34 Depth 2
	loop    	                # label19:
	i32.const	$push109=, 2
	i32.shl 	$push25=, $7, $pop109
	i32.add 	$push26=, $1, $pop25
	i32.load	$9=, 0($pop26)
	i32.const	$push108=, 0
	i32.store	xx($pop108), $5
	i32.const	$push107=, 0
	i32.ne  	$2=, $4, $pop107
	block   	
	block   	
	i32.eqz 	$push129=, $4
	br_if   	0, $pop129      # 0: down to label21
# BB#32:                                # %for.body17
                                        #   in Loop: Header=BB0_31 Depth=1
	i32.eqz 	$push130=, $9
	br_if   	0, $pop130      # 0: down to label21
# BB#33:                                # %while.body.i55.preheader
                                        #   in Loop: Header=BB0_31 Depth=1
	i32.const	$push48=, 112
	i32.add 	$push49=, $1, $pop48
	copy_local	$8=, $pop49
.LBB0_34:                               # %while.body.i55
                                        #   Parent Loop BB0_31 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label22:
	block   	
	block   	
	i32.load	$push28=, 4($4)
	i32.load	$push27=, 4($9)
	i32.ge_u	$push29=, $pop28, $pop27
	br_if   	0, $pop29       # 0: down to label24
# BB#35:                                # %if.then.i57
                                        #   in Loop: Header=BB0_34 Depth=2
	i32.const	$push111=, 32
	i32.add 	$push32=, $8, $pop111
	i32.store	0($pop32), $4
	i32.const	$push110=, 32
	i32.add 	$push33=, $4, $pop110
	i32.load	$10=, 0($pop33)
	copy_local	$11=, $9
	copy_local	$8=, $4
	br      	1               # 1: down to label23
.LBB0_36:                               # %if.else.i59
                                        #   in Loop: Header=BB0_34 Depth=2
	end_block                       # label24:
	i32.const	$push113=, 32
	i32.add 	$push30=, $8, $pop113
	i32.store	0($pop30), $9
	i32.const	$push112=, 32
	i32.add 	$push31=, $9, $pop112
	i32.load	$11=, 0($pop31)
	copy_local	$10=, $4
	copy_local	$8=, $9
.LBB0_37:                               # %if.end.i66
                                        #   in Loop: Header=BB0_34 Depth=2
	end_block                       # label23:
	block   	
	i32.const	$push115=, 0
	i32.const	$push50=, 112
	i32.add 	$push51=, $1, $pop50
	i32.const	$push114=, 32
	i32.add 	$push34=, $pop51, $pop114
	i32.load	$push35=, 0($pop34)
	i32.load	$push36=, 0($pop35)
	i32.store	vx($pop115), $pop36
	i32.eqz 	$push131=, $10
	br_if   	0, $pop131      # 0: down to label25
# BB#38:                                # %if.end.i66
                                        #   in Loop: Header=BB0_34 Depth=2
	copy_local	$9=, $11
	copy_local	$4=, $10
	br_if   	1, $11          # 1: up to label22
.LBB0_39:                               # %while.end.loopexit.i68
                                        #   in Loop: Header=BB0_31 Depth=1
	end_block                       # label25:
	end_loop
	i32.const	$push117=, 0
	i32.ne  	$2=, $10, $pop117
	i32.const	$push116=, 32
	i32.add 	$8=, $8, $pop116
	br      	1               # 1: down to label20
.LBB0_40:                               #   in Loop: Header=BB0_31 Depth=1
	end_block                       # label21:
	copy_local	$8=, $5
	copy_local	$10=, $4
	copy_local	$11=, $9
.LBB0_41:                               # %merge_pagelist.exit74
                                        #   in Loop: Header=BB0_31 Depth=1
	end_block                       # label20:
	i32.select	$push37=, $10, $11, $2
	i32.store	0($8), $pop37
	i32.load	$4=, 0($5)
	i32.const	$push121=, 1
	i32.add 	$push120=, $7, $pop121
	tee_local	$push119=, $7=, $pop120
	i32.const	$push118=, 25
	i32.ne  	$push38=, $pop119, $pop118
	br_if   	0, $pop38       # 0: up to label19
# BB#42:                                # %for.end22
	end_loop
	i32.const	$push45=, 0
	i32.const	$push43=, 160
	i32.add 	$push44=, $1, $pop43
	i32.store	__stack_pointer($pop45), $pop44
	copy_local	$push132=, $4
                                        # fallthrough-return: $pop132
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
	i32.const	$push30=, 0
	i32.const	$push28=, 0
	i32.load	$push27=, __stack_pointer($pop28)
	i32.const	$push29=, 224
	i32.sub 	$push39=, $pop27, $pop29
	tee_local	$push38=, $1=, $pop39
	i32.store	__stack_pointer($pop30), $pop38
	i32.const	$push2=, 32
	i32.add 	$push3=, $1, $pop2
	i32.const	$push0=, 44
	i32.add 	$push1=, $1, $pop0
	i32.store	0($pop3), $pop1
	i32.const	$push4=, 48
	i32.add 	$push5=, $1, $pop4
	i32.const	$push6=, 4
	i32.store	0($pop5), $pop6
	i32.const	$push9=, 76
	i32.add 	$push10=, $1, $pop9
	i32.const	$push7=, 88
	i32.add 	$push8=, $1, $pop7
	i32.store	0($pop10), $pop8
	i32.const	$push11=, 92
	i32.add 	$push12=, $1, $pop11
	i32.const	$push13=, 1
	i32.store	0($pop12), $pop13
	i32.const	$push16=, 120
	i32.add 	$push17=, $1, $pop16
	i32.const	$push14=, 132
	i32.add 	$push15=, $1, $pop14
	i32.store	0($pop17), $pop15
	i32.const	$push18=, 136
	i32.add 	$push19=, $1, $pop18
	i32.const	$push20=, 3
	i32.store	0($pop19), $pop20
	i32.const	$push21=, 164
	i32.add 	$push22=, $1, $pop21
	i32.const	$push37=, 0
	i32.store	0($pop22), $pop37
	i32.const	$push23=, 5
	i32.store	4($1), $pop23
	block   	
	i32.call	$push36=, sort_pagelist@FUNCTION, $1
	tee_local	$push35=, $0=, $pop36
	i32.const	$push34=, 32
	i32.add 	$push24=, $0, $pop34
	i32.load	$push25=, 0($pop24)
	i32.eq  	$push26=, $pop35, $pop25
	br_if   	0, $pop26       # 0: down to label26
# BB#1:                                 # %if.end
	i32.const	$push33=, 0
	i32.const	$push31=, 224
	i32.add 	$push32=, $1, $pop31
	i32.store	__stack_pointer($pop33), $pop32
	i32.const	$push40=, 0
	return  	$pop40
.LBB1_2:                                # %if.then
	end_block                       # label26:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	xx                      # @xx
	.type	xx,@object
	.section	.bss.xx,"aw",@nobits
	.globl	xx
	.p2align	2
xx:
	.int32	0
	.size	xx, 4

	.hidden	vx                      # @vx
	.type	vx,@object
	.section	.bss.vx,"aw",@nobits
	.globl	vx
	.p2align	2
vx:
	.int32	0                       # 0x0
	.size	vx, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
