	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr33870-1.c"
	.section	.text.sort_pagelist,"ax",@progbits
	.hidden	sort_pagelist
	.globl	sort_pagelist
	.type	sort_pagelist,@function
sort_pagelist:                          # @sort_pagelist
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push92=, __stack_pointer
	i32.load	$push93=, 0($pop92)
	i32.const	$push94=, 160
	i32.sub 	$11=, $pop93, $pop94
	i32.const	$push95=, __stack_pointer
	i32.store	$discard=, 0($pop95), $11
	i32.const	$push45=, 0
	i32.const	$push0=, 100
	i32.call	$discard=, memset@FUNCTION, $11, $pop45, $pop0
	i32.const	$8=, 0
	block
	i32.const	$push109=, 0
	i32.eq  	$push110=, $0, $pop109
	br_if   	0, $pop110      # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push14=, 96
	i32.add 	$4=, $11, $pop14
	i32.const	$push103=, 112
	i32.add 	$push104=, $11, $pop103
	i32.const	$push46=, 32
	i32.add 	$1=, $pop104, $pop46
.LBB0_2:                                # %while.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
                                        #       Child Loop BB0_5 Depth 3
                                        #     Child Loop BB0_19 Depth 2
	loop                            # label1:
	copy_local	$push52=, $0
	tee_local	$push51=, $8=, $pop52
	i32.const	$push50=, 32
	i32.add 	$push49=, $pop51, $pop50
	tee_local	$push48=, $9=, $pop49
	i32.load	$0=, 0($pop48)
	i32.const	$push47=, 0
	i32.store	$2=, 0($9), $pop47
	copy_local	$5=, $2
.LBB0_3:                                # %for.body
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_5 Depth 3
	block
	block
	block
	block
	loop                            # label7:
	i32.const	$push57=, 2
	i32.shl 	$push1=, $5, $pop57
	i32.add 	$push56=, $11, $pop1
	tee_local	$push55=, $10=, $pop56
	i32.load	$push54=, 0($pop55)
	tee_local	$push53=, $9=, $pop54
	i32.const	$push111=, 0
	i32.eq  	$push112=, $pop53, $pop111
	br_if   	2, $pop112      # 2: down to label6
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$3=, xx($2), $1
	i32.const	$push105=, 112
	i32.add 	$push106=, $11, $pop105
	copy_local	$6=, $pop106
	copy_local	$7=, $1
	block
	block
	i32.const	$push113=, 0
	i32.eq  	$push114=, $8, $pop113
	br_if   	0, $pop114      # 0: down to label10
.LBB0_5:                                # %while.body.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label11:
	block
	block
	i32.load	$push2=, 4($9)
	i32.load	$push3=, 4($8)
	i32.ge_u	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label14
# BB#6:                                 # %if.then.i
                                        #   in Loop: Header=BB0_5 Depth=3
	i32.const	$push59=, 32
	i32.add 	$push7=, $6, $pop59
	i32.store	$6=, 0($pop7), $9
	i32.const	$push58=, 32
	i32.add 	$push8=, $6, $pop58
	i32.load	$9=, 0($pop8)
	br      	1               # 1: down to label13
.LBB0_7:                                # %if.else.i
                                        #   in Loop: Header=BB0_5 Depth=3
	end_block                       # label14:
	i32.const	$push61=, 32
	i32.add 	$push5=, $6, $pop61
	i32.store	$6=, 0($pop5), $8
	i32.const	$push60=, 32
	i32.add 	$push6=, $6, $pop60
	i32.load	$8=, 0($pop6)
.LBB0_8:                                # %if.end.i
                                        #   in Loop: Header=BB0_5 Depth=3
	end_block                       # label13:
	i32.load	$push9=, xx($2)
	i32.load	$push10=, 0($pop9)
	i32.load	$push11=, 0($pop10)
	i32.store	$discard=, vx($2), $pop11
	i32.const	$push115=, 0
	i32.eq  	$push116=, $9, $pop115
	br_if   	1, $pop116      # 1: down to label12
# BB#9:                                 # %if.end.i
                                        #   in Loop: Header=BB0_5 Depth=3
	br_if   	0, $8           # 0: up to label11
.LBB0_10:                               # %while.end.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_loop                        # label12:
	i32.const	$push62=, 32
	i32.add 	$7=, $6, $pop62
	br_if   	0, $9           # 0: down to label10
# BB#11:                                # %if.else17.i
                                        #   in Loop: Header=BB0_3 Depth=2
	block
	i32.const	$push117=, 0
	i32.eq  	$push118=, $8, $pop117
	br_if   	0, $pop118      # 0: down to label15
# BB#12:                                # %if.then19.i
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$discard=, 0($7), $8
	br      	2               # 2: down to label9
.LBB0_13:                               # %if.else22.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label15:
	i32.store	$discard=, 0($7), $2
	br      	1               # 1: down to label9
.LBB0_14:                               # %if.then14.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label10:
	i32.store	$discard=, 0($7), $9
.LBB0_15:                               # %merge_pagelist.exit
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label9:
	i32.load	$8=, 0($3):p2align=3
	i32.store	$9=, 0($10), $2
	i32.const	$push64=, 1
	i32.add 	$5=, $5, $pop64
	i32.const	$push63=, 24
	i32.lt_s	$push12=, $5, $pop63
	br_if   	0, $pop12       # 0: up to label7
# BB#16:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label8:
	i32.const	$push65=, 24
	i32.ne  	$push13=, $5, $pop65
	br_if   	3, $pop13       # 3: down to label3
# BB#17:                                # %if.then9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$6=, 0($4):p2align=4
	i32.store	$10=, xx($9), $3
	i32.ne  	$5=, $6, $9
	i32.ne  	$7=, $8, $9
	i32.const	$push107=, 112
	i32.add 	$push108=, $11, $pop107
	copy_local	$2=, $pop108
	block
	i32.const	$push119=, 0
	i32.eq  	$push120=, $8, $pop119
	br_if   	0, $pop120      # 0: down to label16
# BB#18:                                # %if.then9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push121=, 0
	i32.eq  	$push122=, $6, $pop121
	br_if   	0, $pop122      # 0: down to label16
.LBB0_19:                               # %while.body.i89
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label17:
	block
	block
	i32.load	$push15=, 4($6)
	i32.load	$push16=, 4($8)
	i32.ge_u	$push17=, $pop15, $pop16
	br_if   	0, $pop17       # 0: down to label20
# BB#20:                                # %if.then.i91
                                        #   in Loop: Header=BB0_19 Depth=2
	i32.const	$push67=, 32
	i32.add 	$push20=, $2, $pop67
	i32.store	$2=, 0($pop20), $6
	i32.const	$push66=, 32
	i32.add 	$push21=, $2, $pop66
	i32.load	$6=, 0($pop21)
	br      	1               # 1: down to label19
.LBB0_21:                               # %if.else.i93
                                        #   in Loop: Header=BB0_19 Depth=2
	end_block                       # label20:
	i32.const	$push69=, 32
	i32.add 	$push18=, $2, $pop69
	i32.store	$2=, 0($pop18), $8
	i32.const	$push68=, 32
	i32.add 	$push19=, $2, $pop68
	i32.load	$8=, 0($pop19)
.LBB0_22:                               # %if.end.i100
                                        #   in Loop: Header=BB0_19 Depth=2
	end_block                       # label19:
	i32.load	$push22=, xx($9)
	i32.load	$push23=, 0($pop22)
	i32.load	$push24=, 0($pop23)
	i32.store	$discard=, vx($9), $pop24
	i32.ne  	$5=, $6, $9
	i32.ne  	$7=, $8, $9
	i32.const	$push123=, 0
	i32.eq  	$push124=, $6, $pop123
	br_if   	1, $pop124      # 1: down to label18
# BB#23:                                # %if.end.i100
                                        #   in Loop: Header=BB0_19 Depth=2
	br_if   	0, $8           # 0: up to label17
.LBB0_24:                               # %while.end.i107
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label18:
	end_block                       # label16:
	i32.const	$push125=, 0
	i32.eq  	$push126=, $5, $pop125
	br_if   	1, $pop126      # 1: down to label5
# BB#25:                                # %if.then14.i108
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push70=, 32
	i32.add 	$push27=, $2, $pop70
	i32.store	$discard=, 0($pop27), $6
	br      	2               # 2: down to label4
.LBB0_26:                               # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label6:
	i32.store	$discard=, 0($10), $8
	br      	2               # 2: down to label3
.LBB0_27:                               # %if.else17.i109
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	block
	i32.const	$push127=, 0
	i32.eq  	$push128=, $7, $pop127
	br_if   	0, $pop128      # 0: down to label21
# BB#28:                                # %if.then19.i110
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push71=, 32
	i32.add 	$push26=, $2, $pop71
	i32.store	$discard=, 0($pop26), $8
	br      	1               # 1: down to label4
.LBB0_29:                               # %if.else22.i111
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label21:
	i32.const	$push72=, 32
	i32.add 	$push25=, $2, $pop72
	i32.store	$discard=, 0($pop25), $9
.LBB0_30:                               # %merge_pagelist.exit112
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.load	$push28=, 0($10):p2align=3
	i32.store	$discard=, 0($4):p2align=4, $pop28
.LBB0_31:                               # %while.cond.backedge
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	br_if   	0, $0           # 0: up to label1
# BB#32:                                # %while.end.loopexit
	end_loop                        # label2:
	i32.load	$8=, 0($11):p2align=4
.LBB0_33:                               # %while.end
	end_block                       # label0:
	i32.const	$push99=, 112
	i32.add 	$push100=, $11, $pop99
	i32.const	$push73=, 32
	i32.add 	$3=, $pop100, $pop73
	i32.const	$7=, 1
.LBB0_34:                               # %for.body17
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_36 Depth 2
	loop                            # label22:
	i32.const	$push77=, 2
	i32.shl 	$push29=, $7, $pop77
	i32.add 	$push30=, $11, $pop29
	i32.load	$9=, 0($pop30)
	i32.const	$push76=, 0
	i32.store	$10=, xx($pop76), $3
	i32.const	$push75=, 0
	i32.ne  	$2=, $8, $pop75
	i32.const	$push74=, 0
	i32.ne  	$5=, $9, $pop74
	i32.const	$push101=, 112
	i32.add 	$push102=, $11, $pop101
	copy_local	$6=, $pop102
	block
	i32.const	$push129=, 0
	i32.eq  	$push130=, $8, $pop129
	br_if   	0, $pop130      # 0: down to label24
# BB#35:                                # %for.body17
                                        #   in Loop: Header=BB0_34 Depth=1
	i32.const	$push131=, 0
	i32.eq  	$push132=, $9, $pop131
	br_if   	0, $pop132      # 0: down to label24
.LBB0_36:                               # %while.body.i54
                                        #   Parent Loop BB0_34 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label25:
	block
	block
	i32.load	$push31=, 4($8)
	i32.load	$push32=, 4($9)
	i32.ge_u	$push33=, $pop31, $pop32
	br_if   	0, $pop33       # 0: down to label28
# BB#37:                                # %if.then.i56
                                        #   in Loop: Header=BB0_36 Depth=2
	i32.const	$push79=, 32
	i32.add 	$push36=, $6, $pop79
	i32.store	$6=, 0($pop36), $8
	i32.const	$push78=, 32
	i32.add 	$push37=, $6, $pop78
	i32.load	$8=, 0($pop37)
	br      	1               # 1: down to label27
.LBB0_38:                               # %if.else.i58
                                        #   in Loop: Header=BB0_36 Depth=2
	end_block                       # label28:
	i32.const	$push81=, 32
	i32.add 	$push34=, $6, $pop81
	i32.store	$6=, 0($pop34), $9
	i32.const	$push80=, 32
	i32.add 	$push35=, $6, $pop80
	i32.load	$9=, 0($pop35)
.LBB0_39:                               # %if.end.i65
                                        #   in Loop: Header=BB0_36 Depth=2
	end_block                       # label27:
	i32.const	$push85=, 0
	i32.const	$push84=, 0
	i32.load	$push38=, xx($pop84)
	i32.load	$push39=, 0($pop38)
	i32.load	$push40=, 0($pop39)
	i32.store	$discard=, vx($pop85), $pop40
	i32.const	$push83=, 0
	i32.ne  	$2=, $8, $pop83
	i32.const	$push82=, 0
	i32.ne  	$5=, $9, $pop82
	i32.const	$push133=, 0
	i32.eq  	$push134=, $8, $pop133
	br_if   	1, $pop134      # 1: down to label26
# BB#40:                                # %if.end.i65
                                        #   in Loop: Header=BB0_36 Depth=2
	br_if   	0, $9           # 0: up to label25
.LBB0_41:                               # %while.end.i72
                                        #   in Loop: Header=BB0_34 Depth=1
	end_loop                        # label26:
	end_block                       # label24:
	block
	block
	i32.const	$push135=, 0
	i32.eq  	$push136=, $2, $pop135
	br_if   	0, $pop136      # 0: down to label30
# BB#42:                                # %if.then14.i73
                                        #   in Loop: Header=BB0_34 Depth=1
	i32.const	$push86=, 32
	i32.add 	$push43=, $6, $pop86
	i32.store	$discard=, 0($pop43), $8
	br      	1               # 1: down to label29
.LBB0_43:                               # %if.else17.i74
                                        #   in Loop: Header=BB0_34 Depth=1
	end_block                       # label30:
	block
	i32.const	$push137=, 0
	i32.eq  	$push138=, $5, $pop137
	br_if   	0, $pop138      # 0: down to label31
# BB#44:                                # %if.then19.i75
                                        #   in Loop: Header=BB0_34 Depth=1
	i32.const	$push87=, 32
	i32.add 	$push42=, $6, $pop87
	i32.store	$discard=, 0($pop42), $9
	br      	1               # 1: down to label29
.LBB0_45:                               # %if.else22.i76
                                        #   in Loop: Header=BB0_34 Depth=1
	end_block                       # label31:
	i32.const	$push89=, 32
	i32.add 	$push41=, $6, $pop89
	i32.const	$push88=, 0
	i32.store	$discard=, 0($pop41), $pop88
.LBB0_46:                               # %merge_pagelist.exit77
                                        #   in Loop: Header=BB0_34 Depth=1
	end_block                       # label29:
	i32.load	$8=, 0($10):p2align=3
	i32.const	$push91=, 1
	i32.add 	$7=, $7, $pop91
	i32.const	$push90=, 25
	i32.ne  	$push44=, $7, $pop90
	br_if   	0, $pop44       # 0: up to label22
# BB#47:                                # %for.end22
	end_loop                        # label23:
	i32.const	$push98=, __stack_pointer
	i32.const	$push96=, 160
	i32.add 	$push97=, $11, $pop96
	i32.store	$discard=, 0($pop98), $pop97
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
	i32.const	$push29=, __stack_pointer
	i32.load	$push30=, 0($pop29)
	i32.const	$push31=, 224
	i32.sub 	$2=, $pop30, $pop31
	i32.const	$push32=, __stack_pointer
	i32.store	$discard=, 0($pop32), $2
	i32.const	$push3=, 32
	i32.add 	$push4=, $2, $pop3
	i32.const	$push1=, 44
	i32.add 	$push2=, $2, $pop1
	i32.store	$discard=, 0($pop4):p2align=4, $pop2
	i32.const	$push5=, 48
	i32.add 	$push6=, $2, $pop5
	i32.const	$push7=, 4
	i32.store	$discard=, 0($pop6):p2align=4, $pop7
	i32.const	$push10=, 76
	i32.add 	$push11=, $2, $pop10
	i32.const	$push8=, 88
	i32.add 	$push9=, $2, $pop8
	i32.store	$discard=, 0($pop11), $pop9
	i32.const	$push12=, 92
	i32.add 	$push13=, $2, $pop12
	i32.const	$push14=, 1
	i32.store	$discard=, 0($pop13), $pop14
	i32.const	$push17=, 120
	i32.add 	$push18=, $2, $pop17
	i32.const	$push15=, 132
	i32.add 	$push16=, $2, $pop15
	i32.store	$discard=, 0($pop18):p2align=3, $pop16
	i32.const	$push19=, 136
	i32.add 	$push20=, $2, $pop19
	i32.const	$push21=, 3
	i32.store	$discard=, 0($pop20):p2align=3, $pop21
	i32.const	$push0=, 5
	i32.store	$discard=, 4($2), $pop0
	i32.const	$push22=, 164
	i32.add 	$push23=, $2, $pop22
	i32.const	$push24=, 0
	i32.store	$0=, 0($pop23), $pop24
	i32.call	$1=, sort_pagelist@FUNCTION, $2
	block
	i32.const	$push28=, 32
	i32.add 	$push25=, $1, $pop28
	i32.load	$push26=, 0($pop25)
	i32.eq  	$push27=, $1, $pop26
	br_if   	0, $pop27       # 0: down to label32
# BB#1:                                 # %if.end
	i32.const	$push35=, __stack_pointer
	i32.const	$push33=, 224
	i32.add 	$push34=, $2, $pop33
	i32.store	$discard=, 0($pop35), $pop34
	return  	$0
.LBB1_2:                                # %if.then
	end_block                       # label32:
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


	.ident	"clang version 3.9.0 "
