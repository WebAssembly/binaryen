	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr33870-1.c"
	.section	.text.sort_pagelist,"ax",@progbits
	.hidden	sort_pagelist
	.globl	sort_pagelist
	.type	sort_pagelist,@function
sort_pagelist:                          # @sort_pagelist
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push44=, 0
	i32.const	$push41=, 0
	i32.load	$push42=, __stack_pointer($pop41)
	i32.const	$push43=, 160
	i32.sub 	$push66=, $pop42, $pop43
	tee_local	$push65=, $3=, $pop66
	i32.store	__stack_pointer($pop44), $pop65
	i32.const	$push64=, 0
	i32.const	$push0=, 100
	i32.call	$1=, memset@FUNCTION, $3, $pop64, $pop0
	i32.const	$3=, 0
	block   	
	i32.eqz 	$push116=, $0
	br_if   	0, $pop116      # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push54=, 112
	i32.add 	$push55=, $1, $pop54
	i32.const	$push67=, 32
	i32.add 	$2=, $pop55, $pop67
	i32.const	$push14=, 96
	i32.add 	$5=, $1, $pop14
.LBB0_2:                                # %while.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
                                        #       Child Loop BB0_6 Depth 3
                                        #     Child Loop BB0_19 Depth 2
	loop    	                # label1:
	copy_local	$push73=, $0
	tee_local	$push72=, $3=, $pop73
	i32.const	$push71=, 32
	i32.add 	$push70=, $pop72, $pop71
	tee_local	$push69=, $8=, $pop70
	i32.load	$0=, 0($pop69)
	i32.const	$push68=, 0
	i32.store	0($8), $pop68
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
	i32.const	$push78=, 2
	i32.shl 	$push1=, $6, $pop78
	i32.add 	$push77=, $1, $pop1
	tee_local	$push76=, $4=, $pop77
	i32.load	$push75=, 0($pop76)
	tee_local	$push74=, $9=, $pop75
	i32.eqz 	$push117=, $pop74
	br_if   	1, $pop117      # 1: down to label6
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push79=, 0
	i32.store	xx($pop79), $2
	block   	
	block   	
	block   	
	i32.eqz 	$push118=, $3
	br_if   	0, $pop118      # 0: down to label10
# BB#5:                                 # %while.body.i.preheader
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push62=, 112
	i32.add 	$push63=, $1, $pop62
	copy_local	$7=, $pop63
	copy_local	$8=, $9
.LBB0_6:                                # %while.body.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label11:
	block   	
	block   	
	i32.load	$push3=, 4($8)
	i32.load	$push2=, 4($3)
	i32.ge_u	$push4=, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label13
# BB#7:                                 # %if.then.i
                                        #   in Loop: Header=BB0_6 Depth=3
	i32.const	$push81=, 32
	i32.add 	$push7=, $7, $pop81
	i32.store	0($pop7), $8
	i32.const	$push80=, 32
	i32.add 	$push8=, $8, $pop80
	i32.load	$9=, 0($pop8)
	copy_local	$10=, $3
	copy_local	$7=, $8
	br      	1               # 1: down to label12
.LBB0_8:                                # %if.else.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_block                       # label13:
	i32.const	$push83=, 32
	i32.add 	$push5=, $7, $pop83
	i32.store	0($pop5), $3
	i32.const	$push82=, 32
	i32.add 	$push6=, $3, $pop82
	i32.load	$10=, 0($pop6)
	copy_local	$9=, $8
	copy_local	$7=, $3
.LBB0_9:                                # %if.end.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_block                       # label12:
	block   	
	i32.const	$push84=, 0
	i32.load	$push9=, 0($2)
	i32.load	$push10=, 0($pop9)
	i32.store	vx($pop84), $pop10
	i32.eqz 	$push119=, $9
	br_if   	0, $pop119      # 0: down to label14
# BB#10:                                # %if.end.i
                                        #   in Loop: Header=BB0_6 Depth=3
	copy_local	$3=, $10
	copy_local	$8=, $9
	br_if   	1, $10          # 1: up to label11
.LBB0_11:                               # %merge_pagelist.exit
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label14:
	end_loop
	br_if   	1, $9           # 1: down to label9
	br      	2               # 2: down to label8
.LBB0_12:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label10:
	i32.const	$push56=, 112
	i32.add 	$push57=, $1, $pop56
	copy_local	$7=, $pop57
.LBB0_13:                               # %merge_pagelist.exit.thread
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label9:
	copy_local	$10=, $9
.LBB0_14:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label8:
	i32.const	$push90=, 32
	i32.add 	$push11=, $7, $pop90
	i32.store	0($pop11), $10
	i32.load	$3=, 0($2)
	i32.const	$push89=, 0
	i32.store	0($4), $pop89
	i32.const	$push88=, 1
	i32.add 	$push87=, $6, $pop88
	tee_local	$push86=, $6=, $pop87
	i32.const	$push85=, 24
	i32.lt_s	$push12=, $pop86, $pop85
	br_if   	0, $pop12       # 0: up to label7
# BB#15:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop
	i32.const	$push91=, 24
	i32.ne  	$push13=, $6, $pop91
	br_if   	3, $pop13       # 3: down to label3
# BB#16:                                # %if.then9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$8=, 0($5)
	i32.const	$push93=, 0
	i32.store	xx($pop93), $2
	i32.const	$push92=, 0
	i32.ne  	$6=, $8, $pop92
	i32.const	$push58=, 112
	i32.add 	$push59=, $1, $pop58
	copy_local	$7=, $pop59
	i32.eqz 	$push120=, $3
	br_if   	1, $pop120      # 1: down to label5
# BB#17:                                # %if.then9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.eqz 	$push121=, $8
	br_if   	1, $pop121      # 1: down to label5
# BB#18:                                # %while.body.i84.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push60=, 112
	i32.add 	$push61=, $1, $pop60
	copy_local	$7=, $pop61
.LBB0_19:                               # %while.body.i84
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label15:
	block   	
	block   	
	i32.load	$push16=, 4($8)
	i32.load	$push15=, 4($3)
	i32.ge_u	$push17=, $pop16, $pop15
	br_if   	0, $pop17       # 0: down to label17
# BB#20:                                # %if.then.i86
                                        #   in Loop: Header=BB0_19 Depth=2
	i32.const	$push95=, 32
	i32.add 	$push20=, $7, $pop95
	i32.store	0($pop20), $8
	i32.const	$push94=, 32
	i32.add 	$push21=, $8, $pop94
	i32.load	$9=, 0($pop21)
	copy_local	$10=, $3
	copy_local	$7=, $8
	br      	1               # 1: down to label16
.LBB0_21:                               # %if.else.i88
                                        #   in Loop: Header=BB0_19 Depth=2
	end_block                       # label17:
	i32.const	$push97=, 32
	i32.add 	$push18=, $7, $pop97
	i32.store	0($pop18), $3
	i32.const	$push96=, 32
	i32.add 	$push19=, $3, $pop96
	i32.load	$10=, 0($pop19)
	copy_local	$9=, $8
	copy_local	$7=, $3
.LBB0_22:                               # %if.end.i95
                                        #   in Loop: Header=BB0_19 Depth=2
	end_block                       # label16:
	i32.const	$push99=, 0
	i32.load	$push22=, 0($2)
	i32.load	$push23=, 0($pop22)
	i32.store	vx($pop99), $pop23
	i32.const	$push98=, 0
	i32.ne  	$6=, $9, $pop98
	i32.eqz 	$push122=, $9
	br_if   	3, $pop122      # 3: down to label4
# BB#23:                                # %if.end.i95
                                        #   in Loop: Header=BB0_19 Depth=2
	copy_local	$3=, $10
	copy_local	$8=, $9
	br_if   	0, $10          # 0: up to label15
	br      	3               # 3: down to label4
.LBB0_24:                               # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop
	end_block                       # label6:
	i32.store	0($4), $3
	br_if   	4, $0           # 4: up to label1
	br      	3               # 3: down to label2
.LBB0_25:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	copy_local	$9=, $8
	copy_local	$10=, $3
.LBB0_26:                               # %merge_pagelist.exit102
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.const	$push100=, 32
	i32.add 	$push25=, $7, $pop100
	i32.select	$push24=, $9, $10, $6
	i32.store	0($pop25), $pop24
	i32.load	$push26=, 0($2)
	i32.store	0($5), $pop26
.LBB0_27:                               # %while.cond.backedge
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	br_if   	1, $0           # 1: up to label1
.LBB0_28:                               # %while.end.loopexit
	end_block                       # label2:
	end_loop
	i32.load	$3=, 0($1)
.LBB0_29:                               # %while.end
	end_block                       # label0:
	i32.const	$push48=, 112
	i32.add 	$push49=, $1, $pop48
	i32.const	$push101=, 32
	i32.add 	$2=, $pop49, $pop101
	i32.const	$4=, 1
.LBB0_30:                               # %for.body17
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_33 Depth 2
	loop    	                # label18:
	i32.const	$push104=, 2
	i32.shl 	$push27=, $4, $pop104
	i32.add 	$push28=, $1, $pop27
	i32.load	$8=, 0($pop28)
	i32.const	$push103=, 0
	i32.store	xx($pop103), $2
	i32.const	$push102=, 0
	i32.ne  	$6=, $3, $pop102
	i32.const	$push50=, 112
	i32.add 	$push51=, $1, $pop50
	copy_local	$7=, $pop51
	block   	
	block   	
	i32.eqz 	$push123=, $3
	br_if   	0, $pop123      # 0: down to label20
# BB#31:                                # %for.body17
                                        #   in Loop: Header=BB0_30 Depth=1
	i32.eqz 	$push124=, $8
	br_if   	0, $pop124      # 0: down to label20
# BB#32:                                # %while.body.i54.preheader
                                        #   in Loop: Header=BB0_30 Depth=1
	i32.const	$push52=, 112
	i32.add 	$push53=, $1, $pop52
	copy_local	$7=, $pop53
.LBB0_33:                               # %while.body.i54
                                        #   Parent Loop BB0_30 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label21:
	block   	
	block   	
	i32.load	$push30=, 4($3)
	i32.load	$push29=, 4($8)
	i32.ge_u	$push31=, $pop30, $pop29
	br_if   	0, $pop31       # 0: down to label23
# BB#34:                                # %if.then.i56
                                        #   in Loop: Header=BB0_33 Depth=2
	i32.const	$push106=, 32
	i32.add 	$push34=, $7, $pop106
	i32.store	0($pop34), $3
	i32.const	$push105=, 32
	i32.add 	$push35=, $3, $pop105
	i32.load	$9=, 0($pop35)
	copy_local	$10=, $8
	copy_local	$7=, $3
	br      	1               # 1: down to label22
.LBB0_35:                               # %if.else.i58
                                        #   in Loop: Header=BB0_33 Depth=2
	end_block                       # label23:
	i32.const	$push108=, 32
	i32.add 	$push32=, $7, $pop108
	i32.store	0($pop32), $8
	i32.const	$push107=, 32
	i32.add 	$push33=, $8, $pop107
	i32.load	$10=, 0($pop33)
	copy_local	$9=, $3
	copy_local	$7=, $8
.LBB0_36:                               # %if.end.i65
                                        #   in Loop: Header=BB0_33 Depth=2
	end_block                       # label22:
	i32.const	$push110=, 0
	i32.load	$push36=, 0($2)
	i32.load	$push37=, 0($pop36)
	i32.store	vx($pop110), $pop37
	i32.const	$push109=, 0
	i32.ne  	$6=, $9, $pop109
	i32.eqz 	$push125=, $9
	br_if   	2, $pop125      # 2: down to label19
# BB#37:                                # %if.end.i65
                                        #   in Loop: Header=BB0_33 Depth=2
	copy_local	$8=, $10
	copy_local	$3=, $9
	br_if   	0, $10          # 0: up to label21
	br      	2               # 2: down to label19
.LBB0_38:                               #   in Loop: Header=BB0_30 Depth=1
	end_loop
	end_block                       # label20:
	copy_local	$9=, $3
	copy_local	$10=, $8
.LBB0_39:                               # %merge_pagelist.exit72
                                        #   in Loop: Header=BB0_30 Depth=1
	end_block                       # label19:
	i32.const	$push115=, 32
	i32.add 	$push39=, $7, $pop115
	i32.select	$push38=, $9, $10, $6
	i32.store	0($pop39), $pop38
	i32.load	$3=, 0($2)
	i32.const	$push114=, 1
	i32.add 	$push113=, $4, $pop114
	tee_local	$push112=, $4=, $pop113
	i32.const	$push111=, 25
	i32.ne  	$push40=, $pop112, $pop111
	br_if   	0, $pop40       # 0: up to label18
# BB#40:                                # %for.end22
	end_loop
	i32.const	$push47=, 0
	i32.const	$push45=, 160
	i32.add 	$push46=, $1, $pop45
	i32.store	__stack_pointer($pop47), $pop46
	copy_local	$push126=, $3
                                        # fallthrough-return: $pop126
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
	i32.const	$push30=, 0
	i32.const	$push27=, 0
	i32.load	$push28=, __stack_pointer($pop27)
	i32.const	$push29=, 224
	i32.sub 	$push39=, $pop28, $pop29
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
	i32.const	$push21=, 5
	i32.store	4($1), $pop21
	i32.const	$push22=, 164
	i32.add 	$push23=, $1, $pop22
	i32.const	$push37=, 0
	i32.store	0($pop23), $pop37
	block   	
	i32.call	$push36=, sort_pagelist@FUNCTION, $1
	tee_local	$push35=, $0=, $pop36
	i32.const	$push34=, 32
	i32.add 	$push24=, $0, $pop34
	i32.load	$push25=, 0($pop24)
	i32.eq  	$push26=, $pop35, $pop25
	br_if   	0, $pop26       # 0: down to label24
# BB#1:                                 # %if.end
	i32.const	$push33=, 0
	i32.const	$push31=, 224
	i32.add 	$push32=, $1, $pop31
	i32.store	__stack_pointer($pop33), $pop32
	i32.const	$push40=, 0
	return  	$pop40
.LBB1_2:                                # %if.then
	end_block                       # label24:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
