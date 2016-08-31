	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr33870-1.c"
	.section	.text.sort_pagelist,"ax",@progbits
	.hidden	sort_pagelist
	.globl	sort_pagelist
	.type	sort_pagelist,@function
sort_pagelist:                          # @sort_pagelist
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push42=, 0
	i32.const	$push39=, 0
	i32.load	$push40=, __stack_pointer($pop39)
	i32.const	$push41=, 160
	i32.sub 	$push74=, $pop40, $pop41
	tee_local	$push73=, $1=, $pop74
	i32.store	$drop=, __stack_pointer($pop42), $pop73
	i32.const	$push72=, 0
	i32.const	$push0=, 100
	i32.call	$drop=, memset@FUNCTION, $1, $pop72, $pop0
	i32.const	$6=, 0
	block
	i32.eqz 	$push160=, $0
	br_if   	0, $pop160      # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push56=, 104
	i32.add 	$push57=, $1, $pop56
	i32.const	$push75=, 32
	i32.add 	$2=, $pop57, $pop75
	i32.const	$push11=, 96
	i32.add 	$4=, $1, $pop11
.LBB0_2:                                # %while.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
                                        #       Child Loop BB0_6 Depth 3
                                        #     Child Loop BB0_19 Depth 2
	loop                            # label1:
	copy_local	$push81=, $0
	tee_local	$push80=, $6=, $pop81
	i32.const	$push79=, 32
	i32.add 	$push78=, $pop80, $pop79
	tee_local	$push77=, $7=, $pop78
	i32.load	$0=, 0($pop77)
	i32.const	$push76=, 0
	i32.store	$drop=, 0($7), $pop76
	i32.const	$5=, 0
.LBB0_3:                                # %for.body
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_6 Depth 3
	block
	block
	block
	block
	loop                            # label7:
	i32.const	$push86=, 2
	i32.shl 	$push1=, $5, $pop86
	i32.add 	$push85=, $1, $pop1
	tee_local	$push84=, $3=, $pop85
	i32.load	$push83=, 0($pop84)
	tee_local	$push82=, $7=, $pop83
	i32.eqz 	$push161=, $pop82
	br_if   	2, $pop161      # 2: down to label6
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$drop=, 156($1), $7
	i32.store	$drop=, 152($1), $6
	i32.const	$push87=, 0
	i32.store	$drop=, xx($pop87), $2
	block
	block
	block
	i32.eqz 	$push162=, $6
	br_if   	0, $pop162      # 0: down to label11
# BB#5:                                 # %while.body.i.preheader
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push66=, 104
	i32.add 	$push67=, $1, $pop66
	copy_local	$8=, $pop67
.LBB0_6:                                # %while.body.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label12:
	i32.const	$push100=, 32
	i32.add 	$push5=, $8, $pop100
	i32.load	$push3=, 4($7)
	i32.load	$push2=, 4($6)
	i32.lt_u	$push99=, $pop3, $pop2
	tee_local	$push98=, $8=, $pop99
	i32.select	$push4=, $7, $6, $pop98
	i32.store	$drop=, 0($pop5), $pop4
	i32.const	$push68=, 156
	i32.add 	$push69=, $1, $pop68
	i32.const	$push70=, 152
	i32.add 	$push71=, $1, $pop70
	i32.select	$push97=, $pop69, $pop71, $8
	tee_local	$push96=, $6=, $pop97
	i32.load	$push95=, 0($6)
	tee_local	$push94=, $8=, $pop95
	i32.const	$push93=, 32
	i32.add 	$push92=, $pop94, $pop93
	tee_local	$push91=, $9=, $pop92
	i32.load	$push6=, 0($pop91)
	i32.store	$drop=, 0($pop96), $pop6
	i32.const	$push90=, 0
	i32.load	$push7=, 0($2)
	i32.load	$push8=, 0($pop7)
	i32.store	$drop=, vx($pop90), $pop8
	i32.load	$6=, 152($1)
	i32.load	$push89=, 156($1)
	tee_local	$push88=, $7=, $pop89
	i32.eqz 	$push163=, $pop88
	br_if   	1, $pop163      # 1: down to label13
# BB#7:                                 # %while.body.i
                                        #   in Loop: Header=BB0_6 Depth=3
	br_if   	0, $6           # 0: up to label12
.LBB0_8:                                # %while.end.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_loop                        # label13:
	i32.eqz 	$push164=, $7
	br_if   	1, $pop164      # 1: down to label10
# BB#9:                                 # %if.then14.i
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$drop=, 0($9), $7
	br      	2               # 2: down to label9
.LBB0_10:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label11:
	copy_local	$push38=, $2
	i32.store	$drop=, 0($pop38), $7
	br      	1               # 1: down to label9
.LBB0_11:                               # %if.else17.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label10:
	block
	i32.eqz 	$push165=, $6
	br_if   	0, $pop165      # 0: down to label14
# BB#12:                                # %if.then19.i
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$drop=, 0($9), $6
	br      	1               # 1: down to label9
.LBB0_13:                               # %if.else22.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label14:
	i32.const	$push101=, 0
	i32.store	$drop=, 0($9), $pop101
.LBB0_14:                               # %merge_pagelist.exit
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label9:
	i32.load	$6=, 0($2)
	i32.const	$push106=, 0
	i32.store	$drop=, 0($3), $pop106
	i32.const	$push105=, 1
	i32.add 	$push104=, $5, $pop105
	tee_local	$push103=, $5=, $pop104
	i32.const	$push102=, 24
	i32.lt_s	$push9=, $pop103, $pop102
	br_if   	0, $pop9        # 0: up to label7
# BB#15:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label8:
	i32.const	$push107=, 24
	i32.ne  	$push10=, $5, $pop107
	br_if   	3, $pop10       # 3: down to label3
# BB#16:                                # %if.then9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$push112=, 0($4)
	tee_local	$push111=, $7=, $pop112
	i32.store	$drop=, 156($1), $pop111
	i32.store	$drop=, 152($1), $6
	i32.const	$push110=, 0
	i32.store	$drop=, xx($pop110), $2
	i32.const	$push109=, 0
	i32.ne  	$5=, $6, $pop109
	i32.const	$push108=, 0
	i32.ne  	$9=, $7, $pop108
	i32.const	$push58=, 104
	i32.add 	$push59=, $1, $pop58
	copy_local	$8=, $pop59
	block
	i32.eqz 	$push166=, $6
	br_if   	0, $pop166      # 0: down to label15
# BB#17:                                # %if.then9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.eqz 	$push167=, $7
	br_if   	0, $pop167      # 0: down to label15
# BB#18:                                # %while.body.i98.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push60=, 104
	i32.add 	$push61=, $1, $pop60
	copy_local	$8=, $pop61
.LBB0_19:                               # %while.body.i98
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label16:
	i32.const	$push127=, 32
	i32.add 	$push15=, $8, $pop127
	i32.load	$push13=, 4($7)
	i32.load	$push12=, 4($6)
	i32.lt_u	$push126=, $pop13, $pop12
	tee_local	$push125=, $8=, $pop126
	i32.select	$push14=, $7, $6, $pop125
	i32.store	$drop=, 0($pop15), $pop14
	i32.const	$push62=, 156
	i32.add 	$push63=, $1, $pop62
	i32.const	$push64=, 152
	i32.add 	$push65=, $1, $pop64
	i32.select	$push124=, $pop63, $pop65, $8
	tee_local	$push123=, $6=, $pop124
	i32.load	$push122=, 0($6)
	tee_local	$push121=, $8=, $pop122
	i32.const	$push120=, 32
	i32.add 	$push16=, $pop121, $pop120
	i32.load	$push17=, 0($pop16)
	i32.store	$drop=, 0($pop123), $pop17
	i32.const	$push119=, 0
	i32.load	$push18=, 0($2)
	i32.load	$push19=, 0($pop18)
	i32.store	$drop=, vx($pop119), $pop19
	i32.load	$push118=, 152($1)
	tee_local	$push117=, $6=, $pop118
	i32.const	$push116=, 0
	i32.ne  	$5=, $pop117, $pop116
	i32.load	$push115=, 156($1)
	tee_local	$push114=, $7=, $pop115
	i32.const	$push113=, 0
	i32.ne  	$9=, $pop114, $pop113
	i32.eqz 	$push168=, $7
	br_if   	1, $pop168      # 1: down to label17
# BB#20:                                # %while.body.i98
                                        #   in Loop: Header=BB0_19 Depth=2
	br_if   	0, $6           # 0: up to label16
.LBB0_21:                               # %while.end.i105
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label17:
	end_block                       # label15:
	i32.eqz 	$push169=, $9
	br_if   	1, $pop169      # 1: down to label5
# BB#22:                                # %if.then14.i106
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push128=, 32
	i32.add 	$push22=, $8, $pop128
	i32.store	$drop=, 0($pop22), $7
	br      	2               # 2: down to label4
.LBB0_23:                               # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label6:
	i32.store	$drop=, 0($3), $6
	br      	2               # 2: down to label3
.LBB0_24:                               # %if.else17.i107
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	block
	i32.eqz 	$push170=, $5
	br_if   	0, $pop170      # 0: down to label18
# BB#25:                                # %if.then19.i108
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push129=, 32
	i32.add 	$push21=, $8, $pop129
	i32.store	$drop=, 0($pop21), $6
	br      	1               # 1: down to label4
.LBB0_26:                               # %if.else22.i109
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label18:
	i32.const	$push131=, 32
	i32.add 	$push20=, $8, $pop131
	i32.const	$push130=, 0
	i32.store	$drop=, 0($pop20), $pop130
.LBB0_27:                               # %merge_pagelist.exit110
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.load	$push23=, 0($2)
	i32.store	$drop=, 0($4), $pop23
.LBB0_28:                               # %while.cond.backedge
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	br_if   	0, $0           # 0: up to label1
# BB#29:                                # %while.end.loopexit
	end_loop                        # label2:
	i32.load	$6=, 0($1)
.LBB0_30:                               # %while.end
	end_block                       # label0:
	i32.const	$push46=, 104
	i32.add 	$push47=, $1, $pop46
	i32.const	$push132=, 32
	i32.add 	$2=, $pop47, $pop132
	i32.const	$3=, 1
.LBB0_31:                               # %for.body17
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_34 Depth 2
	loop                            # label19:
	i32.const	$push136=, 2
	i32.shl 	$push24=, $3, $pop136
	i32.add 	$push25=, $1, $pop24
	i32.load	$7=, 0($pop25)
	i32.store	$drop=, 156($1), $6
	i32.store	$drop=, 152($1), $7
	i32.const	$push135=, 0
	i32.store	$drop=, xx($pop135), $2
	i32.const	$push134=, 0
	i32.ne  	$9=, $6, $pop134
	i32.const	$push133=, 0
	i32.ne  	$5=, $7, $pop133
	i32.const	$push48=, 104
	i32.add 	$push49=, $1, $pop48
	copy_local	$8=, $pop49
	block
	i32.eqz 	$push171=, $6
	br_if   	0, $pop171      # 0: down to label21
# BB#32:                                # %for.body17
                                        #   in Loop: Header=BB0_31 Depth=1
	i32.eqz 	$push172=, $7
	br_if   	0, $pop172      # 0: down to label21
# BB#33:                                # %while.body.i64.preheader
                                        #   in Loop: Header=BB0_31 Depth=1
	i32.const	$push50=, 104
	i32.add 	$push51=, $1, $pop50
	copy_local	$8=, $pop51
.LBB0_34:                               # %while.body.i64
                                        #   Parent Loop BB0_31 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label22:
	i32.const	$push151=, 32
	i32.add 	$push29=, $8, $pop151
	i32.load	$push27=, 4($6)
	i32.load	$push26=, 4($7)
	i32.lt_u	$push150=, $pop27, $pop26
	tee_local	$push149=, $8=, $pop150
	i32.select	$push28=, $6, $7, $pop149
	i32.store	$drop=, 0($pop29), $pop28
	i32.const	$push52=, 156
	i32.add 	$push53=, $1, $pop52
	i32.const	$push54=, 152
	i32.add 	$push55=, $1, $pop54
	i32.select	$push148=, $pop53, $pop55, $8
	tee_local	$push147=, $6=, $pop148
	i32.load	$push146=, 0($6)
	tee_local	$push145=, $8=, $pop146
	i32.const	$push144=, 32
	i32.add 	$push30=, $pop145, $pop144
	i32.load	$push31=, 0($pop30)
	i32.store	$drop=, 0($pop147), $pop31
	i32.const	$push143=, 0
	i32.load	$push32=, 0($2)
	i32.load	$push33=, 0($pop32)
	i32.store	$drop=, vx($pop143), $pop33
	i32.load	$push142=, 152($1)
	tee_local	$push141=, $7=, $pop142
	i32.const	$push140=, 0
	i32.ne  	$5=, $pop141, $pop140
	i32.load	$push139=, 156($1)
	tee_local	$push138=, $6=, $pop139
	i32.const	$push137=, 0
	i32.ne  	$9=, $pop138, $pop137
	i32.eqz 	$push173=, $6
	br_if   	1, $pop173      # 1: down to label23
# BB#35:                                # %while.body.i64
                                        #   in Loop: Header=BB0_34 Depth=2
	br_if   	0, $7           # 0: up to label22
.LBB0_36:                               # %while.end.i71
                                        #   in Loop: Header=BB0_31 Depth=1
	end_loop                        # label23:
	end_block                       # label21:
	block
	block
	i32.eqz 	$push174=, $9
	br_if   	0, $pop174      # 0: down to label25
# BB#37:                                # %if.then14.i72
                                        #   in Loop: Header=BB0_31 Depth=1
	i32.const	$push152=, 32
	i32.add 	$push36=, $8, $pop152
	i32.store	$drop=, 0($pop36), $6
	br      	1               # 1: down to label24
.LBB0_38:                               # %if.else17.i73
                                        #   in Loop: Header=BB0_31 Depth=1
	end_block                       # label25:
	block
	i32.eqz 	$push175=, $5
	br_if   	0, $pop175      # 0: down to label26
# BB#39:                                # %if.then19.i74
                                        #   in Loop: Header=BB0_31 Depth=1
	i32.const	$push153=, 32
	i32.add 	$push35=, $8, $pop153
	i32.store	$drop=, 0($pop35), $7
	br      	1               # 1: down to label24
.LBB0_40:                               # %if.else22.i75
                                        #   in Loop: Header=BB0_31 Depth=1
	end_block                       # label26:
	i32.const	$push155=, 32
	i32.add 	$push34=, $8, $pop155
	i32.const	$push154=, 0
	i32.store	$drop=, 0($pop34), $pop154
.LBB0_41:                               # %merge_pagelist.exit76
                                        #   in Loop: Header=BB0_31 Depth=1
	end_block                       # label24:
	i32.load	$6=, 0($2)
	i32.const	$push159=, 1
	i32.add 	$push158=, $3, $pop159
	tee_local	$push157=, $3=, $pop158
	i32.const	$push156=, 25
	i32.ne  	$push37=, $pop157, $pop156
	br_if   	0, $pop37       # 0: up to label19
# BB#42:                                # %for.end22
	end_loop                        # label20:
	i32.const	$push45=, 0
	i32.const	$push43=, 160
	i32.add 	$push44=, $1, $pop43
	i32.store	$drop=, __stack_pointer($pop45), $pop44
	copy_local	$push176=, $6
                                        # fallthrough-return: $pop176
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
	i32.store	$drop=, __stack_pointer($pop30), $pop38
	i32.const	$push2=, 32
	i32.add 	$push3=, $1, $pop2
	i32.const	$push0=, 44
	i32.add 	$push1=, $1, $pop0
	i32.store	$drop=, 0($pop3), $pop1
	i32.const	$push4=, 48
	i32.add 	$push5=, $1, $pop4
	i32.const	$push6=, 4
	i32.store	$drop=, 0($pop5), $pop6
	i32.const	$push9=, 76
	i32.add 	$push10=, $1, $pop9
	i32.const	$push7=, 88
	i32.add 	$push8=, $1, $pop7
	i32.store	$drop=, 0($pop10), $pop8
	i32.const	$push11=, 92
	i32.add 	$push12=, $1, $pop11
	i32.const	$push13=, 1
	i32.store	$drop=, 0($pop12), $pop13
	i32.const	$push16=, 120
	i32.add 	$push17=, $1, $pop16
	i32.const	$push14=, 132
	i32.add 	$push15=, $1, $pop14
	i32.store	$drop=, 0($pop17), $pop15
	i32.const	$push18=, 136
	i32.add 	$push19=, $1, $pop18
	i32.const	$push20=, 3
	i32.store	$drop=, 0($pop19), $pop20
	i32.const	$push21=, 5
	i32.store	$drop=, 4($1), $pop21
	i32.const	$push22=, 164
	i32.add 	$push23=, $1, $pop22
	i32.const	$push37=, 0
	i32.store	$drop=, 0($pop23), $pop37
	block
	i32.call	$push36=, sort_pagelist@FUNCTION, $1
	tee_local	$push35=, $0=, $pop36
	i32.const	$push34=, 32
	i32.add 	$push24=, $0, $pop34
	i32.load	$push25=, 0($pop24)
	i32.eq  	$push26=, $pop35, $pop25
	br_if   	0, $pop26       # 0: down to label27
# BB#1:                                 # %if.end
	i32.const	$push33=, 0
	i32.const	$push31=, 224
	i32.add 	$push32=, $1, $pop31
	i32.store	$drop=, __stack_pointer($pop33), $pop32
	i32.const	$push40=, 0
	return  	$pop40
.LBB1_2:                                # %if.then
	end_block                       # label27:
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
