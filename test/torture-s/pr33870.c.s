	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr33870.c"
	.section	.text.sort_pagelist,"ax",@progbits
	.hidden	sort_pagelist
	.globl	sort_pagelist
	.type	sort_pagelist,@function
sort_pagelist:                          # @sort_pagelist
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push32=, 0
	i32.const	$push29=, 0
	i32.load	$push30=, __stack_pointer($pop29)
	i32.const	$push31=, 160
	i32.sub 	$push66=, $pop30, $pop31
	tee_local	$push65=, $1=, $pop66
	i32.store	$drop=, __stack_pointer($pop32), $pop65
	i32.const	$push64=, 0
	i32.const	$push0=, 100
	i32.call	$drop=, memset@FUNCTION, $1, $pop64, $pop0
	i32.const	$7=, 0
	block
	i32.eqz 	$push139=, $0
	br_if   	0, $pop139      # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push46=, 112
	i32.add 	$push47=, $1, $pop46
	i32.const	$push67=, 28
	i32.add 	$2=, $pop47, $pop67
	i32.const	$push8=, 96
	i32.add 	$5=, $1, $pop8
.LBB0_2:                                # %while.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
                                        #       Child Loop BB0_6 Depth 3
                                        #     Child Loop BB0_19 Depth 2
	loop                            # label1:
	copy_local	$push70=, $0
	tee_local	$push69=, $7=, $pop70
	i32.load	$0=, 28($pop69)
	i32.const	$push68=, 0
	i32.store	$drop=, 28($7), $pop68
	i32.const	$6=, 0
.LBB0_3:                                # %for.body
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_6 Depth 3
	block
	block
	block
	block
	loop                            # label7:
	i32.const	$push75=, 2
	i32.shl 	$push1=, $6, $pop75
	i32.add 	$push74=, $1, $pop1
	tee_local	$push73=, $3=, $pop74
	i32.load	$push72=, 0($pop73)
	tee_local	$push71=, $8=, $pop72
	i32.eqz 	$push140=, $pop71
	br_if   	2, $pop140      # 2: down to label6
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$drop=, 156($1), $8
	i32.store	$drop=, 152($1), $7
	block
	block
	block
	i32.eqz 	$push141=, $7
	br_if   	0, $pop141      # 0: down to label11
# BB#5:                                 # %while.body.i.preheader
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push58=, 112
	i32.add 	$push59=, $1, $pop58
	copy_local	$9=, $pop59
.LBB0_6:                                # %while.body.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label12:
	i32.load	$push3=, 0($8)
	i32.load	$push2=, 0($7)
	i32.lt_u	$push83=, $pop3, $pop2
	tee_local	$push82=, $4=, $pop83
	i32.select	$push4=, $8, $7, $pop82
	i32.store	$drop=, 28($9), $pop4
	i32.const	$push60=, 156
	i32.add 	$push61=, $1, $pop60
	i32.const	$push62=, 152
	i32.add 	$push63=, $1, $pop62
	i32.select	$push81=, $pop61, $pop63, $4
	tee_local	$push80=, $7=, $pop81
	i32.load	$push79=, 0($7)
	tee_local	$push78=, $9=, $pop79
	i32.load	$push5=, 28($pop78)
	i32.store	$drop=, 0($pop80), $pop5
	i32.load	$7=, 152($1)
	i32.load	$push77=, 156($1)
	tee_local	$push76=, $8=, $pop77
	i32.eqz 	$push142=, $pop76
	br_if   	1, $pop142      # 1: down to label13
# BB#7:                                 # %while.body.i
                                        #   in Loop: Header=BB0_6 Depth=3
	br_if   	0, $7           # 0: up to label12
.LBB0_8:                                # %while.end.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_loop                        # label13:
	i32.const	$push84=, 28
	i32.add 	$9=, $9, $pop84
	i32.eqz 	$push143=, $8
	br_if   	1, $pop143      # 1: down to label10
# BB#9:                                 # %if.then7.i
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$drop=, 0($9), $8
	br      	2               # 2: down to label9
.LBB0_10:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label11:
	copy_local	$push28=, $2
	i32.store	$drop=, 0($pop28), $8
	br      	1               # 1: down to label9
.LBB0_11:                               # %if.else9.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label10:
	block
	i32.eqz 	$push144=, $7
	br_if   	0, $pop144      # 0: down to label14
# BB#12:                                # %if.then11.i
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	$drop=, 0($9), $7
	br      	1               # 1: down to label9
.LBB0_13:                               # %if.else13.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label14:
	i32.const	$push85=, 0
	i32.store	$drop=, 0($9), $pop85
.LBB0_14:                               # %merge_pagelist.exit
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label9:
	i32.const	$push48=, 112
	i32.add 	$push49=, $1, $pop48
	i32.const	$push93=, 28
	i32.add 	$push92=, $pop49, $pop93
	tee_local	$push91=, $9=, $pop92
	i32.load	$7=, 0($pop91)
	i32.const	$push90=, 0
	i32.store	$drop=, 0($3), $pop90
	i32.const	$push89=, 1
	i32.add 	$push88=, $6, $pop89
	tee_local	$push87=, $6=, $pop88
	i32.const	$push86=, 24
	i32.lt_s	$push6=, $pop87, $pop86
	br_if   	0, $pop6        # 0: up to label7
# BB#15:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label8:
	i32.const	$push94=, 24
	i32.ne  	$push7=, $6, $pop94
	br_if   	3, $pop7        # 3: down to label3
# BB#16:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$push98=, 0($5)
	tee_local	$push97=, $8=, $pop98
	i32.store	$drop=, 156($1), $pop97
	i32.store	$drop=, 152($1), $7
	i32.const	$push96=, 0
	i32.ne  	$3=, $7, $pop96
	i32.const	$push95=, 0
	i32.ne  	$6=, $8, $pop95
	i32.const	$push50=, 112
	i32.add 	$push51=, $1, $pop50
	copy_local	$4=, $pop51
	block
	i32.eqz 	$push145=, $7
	br_if   	0, $pop145      # 0: down to label15
# BB#17:                                # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.eqz 	$push146=, $8
	br_if   	0, $pop146      # 0: down to label15
# BB#18:                                # %while.body.i92.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push52=, 112
	i32.add 	$push53=, $1, $pop52
	copy_local	$4=, $pop53
.LBB0_19:                               # %while.body.i92
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label16:
	i32.load	$push10=, 0($8)
	i32.load	$push9=, 0($7)
	i32.lt_u	$push110=, $pop10, $pop9
	tee_local	$push109=, $6=, $pop110
	i32.select	$push11=, $8, $7, $pop109
	i32.store	$drop=, 28($4), $pop11
	i32.const	$push54=, 156
	i32.add 	$push55=, $1, $pop54
	i32.const	$push56=, 152
	i32.add 	$push57=, $1, $pop56
	i32.select	$push108=, $pop55, $pop57, $6
	tee_local	$push107=, $7=, $pop108
	i32.load	$push106=, 0($7)
	tee_local	$push105=, $4=, $pop106
	i32.load	$push12=, 28($pop105)
	i32.store	$drop=, 0($pop107), $pop12
	i32.load	$push104=, 152($1)
	tee_local	$push103=, $7=, $pop104
	i32.const	$push102=, 0
	i32.ne  	$3=, $pop103, $pop102
	i32.load	$push101=, 156($1)
	tee_local	$push100=, $8=, $pop101
	i32.const	$push99=, 0
	i32.ne  	$6=, $pop100, $pop99
	i32.eqz 	$push147=, $8
	br_if   	1, $pop147      # 1: down to label17
# BB#20:                                # %while.body.i92
                                        #   in Loop: Header=BB0_19 Depth=2
	br_if   	0, $7           # 0: up to label16
.LBB0_21:                               # %while.end.i99
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop                        # label17:
	end_block                       # label15:
	i32.eqz 	$push148=, $6
	br_if   	1, $pop148      # 1: down to label5
# BB#22:                                # %if.then7.i100
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push111=, 28
	i32.add 	$push15=, $4, $pop111
	i32.store	$drop=, 0($pop15), $8
	br      	2               # 2: down to label4
.LBB0_23:                               # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label6:
	i32.store	$drop=, 0($3), $7
	br      	2               # 2: down to label3
.LBB0_24:                               # %if.else9.i101
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	block
	i32.eqz 	$push149=, $3
	br_if   	0, $pop149      # 0: down to label18
# BB#25:                                # %if.then11.i102
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push112=, 28
	i32.add 	$push14=, $4, $pop112
	i32.store	$drop=, 0($pop14), $7
	br      	1               # 1: down to label4
.LBB0_26:                               # %if.else13.i103
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label18:
	i32.const	$push114=, 28
	i32.add 	$push13=, $4, $pop114
	i32.const	$push113=, 0
	i32.store	$drop=, 0($pop13), $pop113
.LBB0_27:                               # %merge_pagelist.exit105
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.load	$push16=, 0($9)
	i32.store	$drop=, 0($5), $pop16
.LBB0_28:                               # %while.cond.backedge
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	br_if   	0, $0           # 0: up to label1
# BB#29:                                # %while.end.loopexit
	end_loop                        # label2:
	i32.load	$7=, 0($1)
.LBB0_30:                               # %while.end
	end_block                       # label0:
	i32.const	$3=, 1
.LBB0_31:                               # %for.body15
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_34 Depth 2
	loop                            # label19:
	i32.const	$push117=, 2
	i32.shl 	$push17=, $3, $pop117
	i32.add 	$push18=, $1, $pop17
	i32.load	$8=, 0($pop18)
	i32.store	$drop=, 156($1), $7
	i32.store	$drop=, 152($1), $8
	i32.const	$push116=, 0
	i32.ne  	$4=, $7, $pop116
	i32.const	$push115=, 0
	i32.ne  	$6=, $8, $pop115
	i32.const	$push36=, 112
	i32.add 	$push37=, $1, $pop36
	copy_local	$9=, $pop37
	block
	i32.eqz 	$push150=, $7
	br_if   	0, $pop150      # 0: down to label21
# BB#32:                                # %for.body15
                                        #   in Loop: Header=BB0_31 Depth=1
	i32.eqz 	$push151=, $8
	br_if   	0, $pop151      # 0: down to label21
# BB#33:                                # %while.body.i59.preheader
                                        #   in Loop: Header=BB0_31 Depth=1
	i32.const	$push38=, 112
	i32.add 	$push39=, $1, $pop38
	copy_local	$9=, $pop39
.LBB0_34:                               # %while.body.i59
                                        #   Parent Loop BB0_31 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label22:
	i32.load	$push20=, 0($7)
	i32.load	$push19=, 0($8)
	i32.lt_u	$push129=, $pop20, $pop19
	tee_local	$push128=, $4=, $pop129
	i32.select	$push21=, $7, $8, $pop128
	i32.store	$drop=, 28($9), $pop21
	i32.const	$push40=, 156
	i32.add 	$push41=, $1, $pop40
	i32.const	$push42=, 152
	i32.add 	$push43=, $1, $pop42
	i32.select	$push127=, $pop41, $pop43, $4
	tee_local	$push126=, $7=, $pop127
	i32.load	$push125=, 0($7)
	tee_local	$push124=, $9=, $pop125
	i32.load	$push22=, 28($pop124)
	i32.store	$drop=, 0($pop126), $pop22
	i32.load	$push123=, 152($1)
	tee_local	$push122=, $8=, $pop123
	i32.const	$push121=, 0
	i32.ne  	$6=, $pop122, $pop121
	i32.load	$push120=, 156($1)
	tee_local	$push119=, $7=, $pop120
	i32.const	$push118=, 0
	i32.ne  	$4=, $pop119, $pop118
	i32.eqz 	$push152=, $7
	br_if   	1, $pop152      # 1: down to label23
# BB#35:                                # %while.body.i59
                                        #   in Loop: Header=BB0_34 Depth=2
	br_if   	0, $8           # 0: up to label22
.LBB0_36:                               # %while.end.i66
                                        #   in Loop: Header=BB0_31 Depth=1
	end_loop                        # label23:
	end_block                       # label21:
	block
	block
	i32.eqz 	$push153=, $4
	br_if   	0, $pop153      # 0: down to label25
# BB#37:                                # %if.then7.i67
                                        #   in Loop: Header=BB0_31 Depth=1
	i32.const	$push130=, 28
	i32.add 	$push25=, $9, $pop130
	i32.store	$drop=, 0($pop25), $7
	br      	1               # 1: down to label24
.LBB0_38:                               # %if.else9.i68
                                        #   in Loop: Header=BB0_31 Depth=1
	end_block                       # label25:
	block
	i32.eqz 	$push154=, $6
	br_if   	0, $pop154      # 0: down to label26
# BB#39:                                # %if.then11.i69
                                        #   in Loop: Header=BB0_31 Depth=1
	i32.const	$push131=, 28
	i32.add 	$push24=, $9, $pop131
	i32.store	$drop=, 0($pop24), $8
	br      	1               # 1: down to label24
.LBB0_40:                               # %if.else13.i70
                                        #   in Loop: Header=BB0_31 Depth=1
	end_block                       # label26:
	i32.const	$push133=, 28
	i32.add 	$push23=, $9, $pop133
	i32.const	$push132=, 0
	i32.store	$drop=, 0($pop23), $pop132
.LBB0_41:                               # %merge_pagelist.exit72
                                        #   in Loop: Header=BB0_31 Depth=1
	end_block                       # label24:
	i32.const	$push44=, 112
	i32.add 	$push45=, $1, $pop44
	i32.const	$push138=, 28
	i32.add 	$push27=, $pop45, $pop138
	i32.load	$7=, 0($pop27)
	i32.const	$push137=, 1
	i32.add 	$push136=, $3, $pop137
	tee_local	$push135=, $3=, $pop136
	i32.const	$push134=, 25
	i32.ne  	$push26=, $pop135, $pop134
	br_if   	0, $pop26       # 0: up to label19
# BB#42:                                # %for.end20
	end_loop                        # label20:
	i32.const	$push35=, 0
	i32.const	$push33=, 160
	i32.add 	$push34=, $1, $pop33
	i32.store	$drop=, __stack_pointer($pop35), $pop34
	copy_local	$push155=, $7
                                        # fallthrough-return: $pop155
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
	i32.store	$drop=, __stack_pointer($pop21), $pop28
	i32.const	$push2=, 68
	i32.add 	$push3=, $1, $pop2
	i32.const	$push0=, 80
	i32.add 	$push1=, $1, $pop0
	i32.store	$drop=, 0($pop3), $pop1
	i32.const	$push6=, 108
	i32.add 	$push7=, $1, $pop6
	i32.const	$push4=, 120
	i32.add 	$push5=, $1, $pop4
	i32.store	$drop=, 0($pop7), $pop5
	i32.const	$push8=, 5
	i32.store	$drop=, 0($1), $pop8
	i32.const	$push9=, 4
	i32.store	$drop=, 40($1), $pop9
	i32.const	$push10=, 1
	i32.store	$drop=, 80($1), $pop10
	i32.const	$push11=, 3
	i32.store	$drop=, 120($1), $pop11
	i32.const	$push12=, 40
	i32.add 	$push13=, $1, $pop12
	i32.store	$drop=, 28($1), $pop13
	i32.const	$push14=, 148
	i32.add 	$push15=, $1, $pop14
	i32.const	$push27=, 0
	i32.store	$drop=, 0($pop15), $pop27
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
	i32.store	$drop=, __stack_pointer($pop24), $pop23
	i32.const	$push30=, 0
	return  	$pop30
.LBB1_2:                                # %if.then
	end_block                       # label27:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 "
	.functype	abort, void
