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
# %bb.0:                                # %entry
	i32.const	$push46=, 0
	i32.load	$push45=, __stack_pointer($pop46)
	i32.const	$push47=, 160
	i32.sub 	$7=, $pop45, $pop47
	i32.const	$push48=, 0
	i32.store	__stack_pointer($pop48), $7
	i32.const	$push72=, 0
	i32.const	$push0=, 100
	i32.call	$1=, memset@FUNCTION, $7, $pop72, $pop0
	i32.const	$7=, 0
	block   	
	i32.eqz 	$push118=, $0
	br_if   	0, $pop118      # 0: down to label0
# %bb.1:                                # %while.body.lr.ph
	i32.const	$push60=, 112
	i32.add 	$push61=, $1, $pop60
	i32.const	$push74=, 32
	i32.add 	$3=, $pop61, $pop74
	i32.const	$push62=, 112
	i32.add 	$push63=, $1, $pop62
	i32.const	$push73=, 32
	i32.add 	$2=, $pop63, $pop73
	i32.const	$push14=, 96
	i32.add 	$5=, $1, $pop14
.LBB0_2:                                # %while.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
                                        #       Child Loop BB0_6 Depth 3
                                        #     Child Loop BB0_22 Depth 2
	loop    	                # label1:
	copy_local	$7=, $0
	i32.const	$push76=, 32
	i32.add 	$9=, $7, $pop76
	i32.load	$0=, 0($9)
	i32.const	$push75=, 0
	i32.store	0($9), $pop75
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
	block   	
	block   	
	block   	
	block   	
	block   	
	loop    	                # label12:
	i32.const	$push77=, 2
	i32.shl 	$push1=, $6, $pop77
	i32.add 	$4=, $1, $pop1
	i32.load	$9=, 0($4)
	i32.eqz 	$push119=, $9
	br_if   	1, $pop119      # 1: down to label11
# %bb.4:                                # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push78=, 0
	i32.store	xx($pop78), $2
	block   	
	block   	
	block   	
	i32.eqz 	$push120=, $7
	br_if   	0, $pop120      # 0: down to label15
# %bb.5:                                # %while.body.i.preheader
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push68=, 112
	i32.add 	$push69=, $1, $pop68
	copy_local	$8=, $pop69
.LBB0_6:                                # %while.body.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label16:
	block   	
	block   	
	i32.load	$push3=, 4($9)
	i32.load	$push2=, 4($7)
	i32.ge_u	$push4=, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label18
# %bb.7:                                # %if.then.i
                                        #   in Loop: Header=BB0_6 Depth=3
	i32.const	$push80=, 32
	i32.add 	$push7=, $8, $pop80
	i32.store	0($pop7), $9
	i32.const	$push79=, 32
	i32.add 	$push8=, $9, $pop79
	i32.load	$10=, 0($pop8)
	copy_local	$11=, $7
	copy_local	$8=, $9
	br      	1               # 1: down to label17
.LBB0_8:                                # %if.else.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_block                       # label18:
	i32.const	$push82=, 32
	i32.add 	$push5=, $8, $pop82
	i32.store	0($pop5), $7
	i32.const	$push81=, 32
	i32.add 	$push6=, $7, $pop81
	i32.load	$11=, 0($pop6)
	copy_local	$10=, $9
	copy_local	$8=, $7
.LBB0_9:                                # %if.end.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_block                       # label17:
	block   	
	i32.const	$push84=, 0
	i32.const	$push70=, 112
	i32.add 	$push71=, $1, $pop70
	i32.const	$push83=, 32
	i32.add 	$push9=, $pop71, $pop83
	i32.load	$push10=, 0($pop9)
	i32.load	$push11=, 0($pop10)
	i32.store	vx($pop84), $pop11
	i32.eqz 	$push121=, $10
	br_if   	0, $pop121      # 0: down to label19
# %bb.10:                               # %if.end.i
                                        #   in Loop: Header=BB0_6 Depth=3
	copy_local	$7=, $11
	copy_local	$9=, $10
	br_if   	1, $11          # 1: up to label16
.LBB0_11:                               # %while.end.loopexit.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label19:
	end_loop
	i32.const	$push85=, 32
	i32.add 	$7=, $8, $pop85
	i32.eqz 	$push122=, $10
	br_if   	1, $pop122      # 1: down to label14
# %bb.12:                               #   in Loop: Header=BB0_3 Depth=2
	copy_local	$push39=, $10
	i32.store	0($7), $pop39
	br      	2               # 2: down to label13
.LBB0_13:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label15:
	copy_local	$push40=, $2
	i32.store	0($pop40), $9
	br      	1               # 1: down to label13
.LBB0_14:                               # %if.else17.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label14:
	block   	
	i32.eqz 	$push123=, $11
	br_if   	0, $pop123      # 0: down to label20
# %bb.15:                               # %if.then19.i
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	0($7), $11
	br      	1               # 1: down to label13
.LBB0_16:                               # %if.else22.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label20:
	i32.const	$push86=, 0
	i32.store	0($7), $pop86
.LBB0_17:                               # %merge_pagelist.exit
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label13:
	i32.const	$push64=, 112
	i32.add 	$push65=, $1, $pop64
	i32.const	$push90=, 32
	i32.add 	$9=, $pop65, $pop90
	i32.load	$7=, 0($9)
	i32.const	$push89=, 0
	i32.store	0($4), $pop89
	i32.const	$push88=, 1
	i32.add 	$6=, $6, $pop88
	i32.const	$push87=, 24
	i32.lt_u	$push12=, $6, $pop87
	br_if   	0, $pop12       # 0: up to label12
# %bb.18:                               # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop
	i32.const	$push91=, 24
	i32.ne  	$push13=, $6, $pop91
	br_if   	1, $pop13       # 1: down to label10
# %bb.19:                               # %if.then9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$10=, 0($5)
	i32.const	$push92=, 0
	i32.store	xx($pop92), $3
	i32.eqz 	$push124=, $7
	br_if   	2, $pop124      # 2: down to label9
# %bb.20:                               # %if.then9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.eqz 	$push125=, $10
	br_if   	2, $pop125      # 2: down to label9
# %bb.21:                               # %while.body.i92.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push66=, 112
	i32.add 	$push67=, $1, $pop66
	copy_local	$6=, $pop67
.LBB0_22:                               # %while.body.i92
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label21:
	block   	
	block   	
	i32.load	$push16=, 4($10)
	i32.load	$push15=, 4($7)
	i32.ge_u	$push17=, $pop16, $pop15
	br_if   	0, $pop17       # 0: down to label23
# %bb.23:                               # %if.then.i94
                                        #   in Loop: Header=BB0_22 Depth=2
	i32.const	$push94=, 32
	i32.add 	$push20=, $6, $pop94
	i32.store	0($pop20), $10
	i32.const	$push93=, 32
	i32.add 	$push21=, $10, $pop93
	i32.load	$11=, 0($pop21)
	copy_local	$8=, $7
	copy_local	$6=, $10
	br      	1               # 1: down to label22
.LBB0_24:                               # %if.else.i96
                                        #   in Loop: Header=BB0_22 Depth=2
	end_block                       # label23:
	i32.const	$push96=, 32
	i32.add 	$push18=, $6, $pop96
	i32.store	0($pop18), $7
	i32.const	$push95=, 32
	i32.add 	$push19=, $7, $pop95
	i32.load	$8=, 0($pop19)
	copy_local	$11=, $10
	copy_local	$6=, $7
.LBB0_25:                               # %if.end.i103
                                        #   in Loop: Header=BB0_22 Depth=2
	end_block                       # label22:
	block   	
	i32.const	$push97=, 0
	i32.load	$push22=, 0($9)
	i32.load	$push23=, 0($pop22)
	i32.store	vx($pop97), $pop23
	i32.eqz 	$push126=, $11
	br_if   	0, $pop126      # 0: down to label24
# %bb.26:                               # %if.end.i103
                                        #   in Loop: Header=BB0_22 Depth=2
	copy_local	$7=, $8
	copy_local	$10=, $11
	br_if   	1, $8           # 1: up to label21
.LBB0_27:                               # %while.end.loopexit.i105
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label24:
	end_loop
	i32.const	$push98=, 32
	i32.add 	$6=, $6, $pop98
	i32.eqz 	$push127=, $11
	br_if   	4, $pop127      # 4: down to label7
# %bb.28:                               #   in Loop: Header=BB0_2 Depth=1
	copy_local	$10=, $11
	br      	3               # 3: down to label8
.LBB0_29:                               # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label11:
	i32.store	0($4), $7
.LBB0_30:                               # %if.end13
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label10:
	br_if   	8, $0           # 8: up to label1
	br      	7               # 7: down to label2
.LBB0_31:                               # %while.end.i106
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label9:
	copy_local	$6=, $3
	i32.eqz 	$push128=, $10
	br_if   	2, $pop128      # 2: down to label6
.LBB0_32:                               # %if.then14.i109
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label8:
	i32.store	0($6), $10
	br      	4               # 4: down to label3
.LBB0_33:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label7:
	i32.const	$push99=, 0
	i32.ne  	$push42=, $8, $pop99
	br_if   	1, $pop42       # 1: down to label5
	br      	2               # 2: down to label4
.LBB0_34:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label6:
	copy_local	$8=, $7
	copy_local	$6=, $3
	i32.const	$push101=, 0
	i32.eq  	$push41=, $7, $pop101
	br_if   	1, $pop41       # 1: down to label4
.LBB0_35:                               # %if.then19.i114
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	i32.store	0($6), $8
	br      	1               # 1: down to label3
.LBB0_36:                               # %if.else22.i115
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.const	$push100=, 0
	i32.store	0($6), $pop100
.LBB0_37:                               # %merge_pagelist.exit116
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.load	$push24=, 0($9)
	i32.store	0($5), $pop24
	br_if   	1, $0           # 1: up to label1
.LBB0_38:                               # %while.end.loopexit
	end_block                       # label2:
	end_loop
	i32.load	$7=, 0($1)
.LBB0_39:                               # %while.end
	end_block                       # label0:
	i32.const	$push52=, 112
	i32.add 	$push53=, $1, $pop52
	i32.const	$push102=, 32
	i32.add 	$4=, $pop53, $pop102
	i32.const	$6=, 1
.LBB0_40:                               # %for.body17
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_43 Depth 2
	loop    	                # label25:
	i32.const	$push104=, 2
	i32.shl 	$push25=, $6, $pop104
	i32.add 	$push26=, $1, $pop25
	i32.load	$9=, 0($pop26)
	i32.const	$push103=, 0
	i32.store	xx($pop103), $4
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	i32.eqz 	$push129=, $7
	br_if   	0, $pop129      # 0: down to label32
# %bb.41:                               # %for.body17
                                        #   in Loop: Header=BB0_40 Depth=1
	i32.eqz 	$push130=, $9
	br_if   	0, $pop130      # 0: down to label32
# %bb.42:                               # %while.body.i55.preheader
                                        #   in Loop: Header=BB0_40 Depth=1
	i32.const	$push54=, 112
	i32.add 	$push55=, $1, $pop54
	copy_local	$8=, $pop55
.LBB0_43:                               # %while.body.i55
                                        #   Parent Loop BB0_40 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label33:
	block   	
	block   	
	i32.load	$push28=, 4($7)
	i32.load	$push27=, 4($9)
	i32.ge_u	$push29=, $pop28, $pop27
	br_if   	0, $pop29       # 0: down to label35
# %bb.44:                               # %if.then.i57
                                        #   in Loop: Header=BB0_43 Depth=2
	i32.const	$push106=, 32
	i32.add 	$push32=, $8, $pop106
	i32.store	0($pop32), $7
	i32.const	$push105=, 32
	i32.add 	$push33=, $7, $pop105
	i32.load	$10=, 0($pop33)
	copy_local	$11=, $9
	copy_local	$8=, $7
	br      	1               # 1: down to label34
.LBB0_45:                               # %if.else.i59
                                        #   in Loop: Header=BB0_43 Depth=2
	end_block                       # label35:
	i32.const	$push108=, 32
	i32.add 	$push30=, $8, $pop108
	i32.store	0($pop30), $9
	i32.const	$push107=, 32
	i32.add 	$push31=, $9, $pop107
	i32.load	$11=, 0($pop31)
	copy_local	$10=, $7
	copy_local	$8=, $9
.LBB0_46:                               # %if.end.i66
                                        #   in Loop: Header=BB0_43 Depth=2
	end_block                       # label34:
	block   	
	i32.const	$push110=, 0
	i32.const	$push56=, 112
	i32.add 	$push57=, $1, $pop56
	i32.const	$push109=, 32
	i32.add 	$push34=, $pop57, $pop109
	i32.load	$push35=, 0($pop34)
	i32.load	$push36=, 0($pop35)
	i32.store	vx($pop110), $pop36
	i32.eqz 	$push131=, $10
	br_if   	0, $pop131      # 0: down to label36
# %bb.47:                               # %if.end.i66
                                        #   in Loop: Header=BB0_43 Depth=2
	copy_local	$9=, $11
	copy_local	$7=, $10
	br_if   	1, $11          # 1: up to label33
.LBB0_48:                               # %while.end.loopexit.i68
                                        #   in Loop: Header=BB0_40 Depth=1
	end_block                       # label36:
	end_loop
	i32.const	$push111=, 32
	i32.add 	$8=, $8, $pop111
	i32.eqz 	$push132=, $10
	br_if   	2, $pop132      # 2: down to label30
# %bb.49:                               #   in Loop: Header=BB0_40 Depth=1
	copy_local	$7=, $10
	br      	1               # 1: down to label31
.LBB0_50:                               # %while.end.i69
                                        #   in Loop: Header=BB0_40 Depth=1
	end_block                       # label32:
	copy_local	$8=, $4
	i32.eqz 	$push133=, $7
	br_if   	2, $pop133      # 2: down to label29
.LBB0_51:                               # %if.then14.i72
                                        #   in Loop: Header=BB0_40 Depth=1
	end_block                       # label31:
	i32.store	0($8), $7
	br      	4               # 4: down to label26
.LBB0_52:                               #   in Loop: Header=BB0_40 Depth=1
	end_block                       # label30:
	i32.const	$push112=, 0
	i32.ne  	$push44=, $11, $pop112
	br_if   	1, $pop44       # 1: down to label28
	br      	2               # 2: down to label27
.LBB0_53:                               #   in Loop: Header=BB0_40 Depth=1
	end_block                       # label29:
	copy_local	$11=, $9
	copy_local	$8=, $4
	i32.const	$push114=, 0
	i32.eq  	$push43=, $9, $pop114
	br_if   	1, $pop43       # 1: down to label27
.LBB0_54:                               # %if.then19.i77
                                        #   in Loop: Header=BB0_40 Depth=1
	end_block                       # label28:
	i32.store	0($8), $11
	br      	1               # 1: down to label26
.LBB0_55:                               # %if.else22.i78
                                        #   in Loop: Header=BB0_40 Depth=1
	end_block                       # label27:
	i32.const	$push113=, 0
	i32.store	0($8), $pop113
.LBB0_56:                               # %merge_pagelist.exit79
                                        #   in Loop: Header=BB0_40 Depth=1
	end_block                       # label26:
	i32.const	$push117=, 1
	i32.add 	$6=, $6, $pop117
	i32.const	$push58=, 112
	i32.add 	$push59=, $1, $pop58
	i32.const	$push116=, 32
	i32.add 	$push38=, $pop59, $pop116
	i32.load	$7=, 0($pop38)
	i32.const	$push115=, 25
	i32.ne  	$push37=, $6, $pop115
	br_if   	0, $pop37       # 0: up to label25
# %bb.57:                               # %for.end22
	end_loop
	i32.const	$push51=, 0
	i32.const	$push49=, 160
	i32.add 	$push50=, $1, $pop49
	i32.store	__stack_pointer($pop51), $pop50
	copy_local	$push134=, $7
                                        # fallthrough-return: $pop134
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
# %bb.0:                                # %entry
	i32.const	$push28=, 0
	i32.load	$push27=, __stack_pointer($pop28)
	i32.const	$push29=, 224
	i32.sub 	$1=, $pop27, $pop29
	i32.const	$push30=, 0
	i32.store	__stack_pointer($pop30), $1
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
	i32.const	$push35=, 0
	i32.store	0($pop22), $pop35
	i32.const	$push23=, 5
	i32.store	4($1), $pop23
	i32.call	$0=, sort_pagelist@FUNCTION, $1
	block   	
	i32.const	$push34=, 32
	i32.add 	$push24=, $0, $pop34
	i32.load	$push25=, 0($pop24)
	i32.eq  	$push26=, $0, $pop25
	br_if   	0, $pop26       # 0: down to label37
# %bb.1:                                # %if.end
	i32.const	$push33=, 0
	i32.const	$push31=, 224
	i32.add 	$push32=, $1, $pop31
	i32.store	__stack_pointer($pop33), $pop32
	i32.const	$push36=, 0
	return  	$pop36
.LBB1_2:                                # %if.then
	end_block                       # label37:
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
