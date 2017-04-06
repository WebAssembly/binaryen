	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr33870-1.c"
	.section	.text.sort_pagelist,"ax",@progbits
	.hidden	sort_pagelist
	.globl	sort_pagelist
	.type	sort_pagelist,@function
sort_pagelist:                          # @sort_pagelist
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push43=, 0
	i32.const	$push41=, 0
	i32.load	$push40=, __stack_pointer($pop41)
	i32.const	$push42=, 160
	i32.sub 	$push65=, $pop40, $pop42
	tee_local	$push64=, $3=, $pop65
	i32.store	__stack_pointer($pop43), $pop64
	i32.const	$push63=, 0
	i32.const	$push0=, 100
	i32.call	$1=, memset@FUNCTION, $3, $pop63, $pop0
	i32.const	$3=, 0
	block   	
	i32.eqz 	$push115=, $0
	br_if   	0, $pop115      # 0: down to label0
# BB#1:                                 # %while.body.lr.ph
	i32.const	$push53=, 112
	i32.add 	$push54=, $1, $pop53
	i32.const	$push66=, 32
	i32.add 	$2=, $pop54, $pop66
	i32.const	$push13=, 96
	i32.add 	$5=, $1, $pop13
.LBB0_2:                                # %while.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
                                        #       Child Loop BB0_6 Depth 3
                                        #     Child Loop BB0_19 Depth 2
	loop    	                # label1:
	copy_local	$push72=, $0
	tee_local	$push71=, $3=, $pop72
	i32.const	$push70=, 32
	i32.add 	$push69=, $pop71, $pop70
	tee_local	$push68=, $8=, $pop69
	i32.load	$0=, 0($pop68)
	i32.const	$push67=, 0
	i32.store	0($8), $pop67
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
	i32.const	$push77=, 2
	i32.shl 	$push1=, $6, $pop77
	i32.add 	$push76=, $1, $pop1
	tee_local	$push75=, $4=, $pop76
	i32.load	$push74=, 0($pop75)
	tee_local	$push73=, $9=, $pop74
	i32.eqz 	$push116=, $pop73
	br_if   	1, $pop116      # 1: down to label6
# BB#4:                                 # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push78=, 0
	i32.store	xx($pop78), $2
	block   	
	block   	
	block   	
	i32.eqz 	$push117=, $3
	br_if   	0, $pop117      # 0: down to label10
# BB#5:                                 # %while.body.i.preheader
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push61=, 112
	i32.add 	$push62=, $1, $pop61
	copy_local	$7=, $pop62
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
	i32.const	$push80=, 32
	i32.add 	$push7=, $7, $pop80
	i32.store	0($pop7), $8
	i32.const	$push79=, 32
	i32.add 	$push8=, $8, $pop79
	i32.load	$9=, 0($pop8)
	copy_local	$10=, $3
	copy_local	$7=, $8
	br      	1               # 1: down to label12
.LBB0_8:                                # %if.else.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_block                       # label13:
	i32.const	$push82=, 32
	i32.add 	$push5=, $7, $pop82
	i32.store	0($pop5), $3
	i32.const	$push81=, 32
	i32.add 	$push6=, $3, $pop81
	i32.load	$10=, 0($pop6)
	copy_local	$9=, $8
	copy_local	$7=, $3
.LBB0_9:                                # %if.end.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_block                       # label12:
	block   	
	i32.const	$push83=, 0
	i32.load	$push9=, 0($2)
	i32.load	$push10=, 0($pop9)
	i32.store	vx($pop83), $pop10
	i32.eqz 	$push118=, $9
	br_if   	0, $pop118      # 0: down to label14
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
	i32.const	$push55=, 112
	i32.add 	$push56=, $1, $pop55
	copy_local	$7=, $pop56
.LBB0_13:                               # %merge_pagelist.exit.thread
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label9:
	copy_local	$10=, $9
.LBB0_14:                               # %for.cond
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label8:
	i32.const	$push89=, 32
	i32.add 	$push11=, $7, $pop89
	i32.store	0($pop11), $10
	i32.load	$3=, 0($2)
	i32.const	$push88=, 0
	i32.store	0($4), $pop88
	i32.const	$push87=, 23
	i32.lt_s	$8=, $6, $pop87
	i32.const	$push86=, 1
	i32.add 	$push85=, $6, $pop86
	tee_local	$push84=, $9=, $pop85
	copy_local	$6=, $pop84
	br_if   	0, $8           # 0: up to label7
# BB#15:                                # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop
	i32.const	$push90=, 24
	i32.ne  	$push12=, $9, $pop90
	br_if   	1, $pop12       # 1: down to label5
# BB#16:                                # %if.then9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$8=, 0($5)
	i32.const	$push92=, 0
	i32.store	xx($pop92), $2
	i32.const	$push91=, 0
	i32.ne  	$6=, $8, $pop91
	i32.const	$push57=, 112
	i32.add 	$push58=, $1, $pop57
	copy_local	$7=, $pop58
	i32.eqz 	$push119=, $3
	br_if   	2, $pop119      # 2: down to label4
# BB#17:                                # %if.then9
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.eqz 	$push120=, $8
	br_if   	2, $pop120      # 2: down to label4
# BB#18:                                # %while.body.i84.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push59=, 112
	i32.add 	$push60=, $1, $pop59
	copy_local	$7=, $pop60
.LBB0_19:                               # %while.body.i84
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label15:
	block   	
	block   	
	i32.load	$push15=, 4($8)
	i32.load	$push14=, 4($3)
	i32.ge_u	$push16=, $pop15, $pop14
	br_if   	0, $pop16       # 0: down to label17
# BB#20:                                # %if.then.i86
                                        #   in Loop: Header=BB0_19 Depth=2
	i32.const	$push94=, 32
	i32.add 	$push19=, $7, $pop94
	i32.store	0($pop19), $8
	i32.const	$push93=, 32
	i32.add 	$push20=, $8, $pop93
	i32.load	$9=, 0($pop20)
	copy_local	$10=, $3
	copy_local	$7=, $8
	br      	1               # 1: down to label16
.LBB0_21:                               # %if.else.i88
                                        #   in Loop: Header=BB0_19 Depth=2
	end_block                       # label17:
	i32.const	$push96=, 32
	i32.add 	$push17=, $7, $pop96
	i32.store	0($pop17), $3
	i32.const	$push95=, 32
	i32.add 	$push18=, $3, $pop95
	i32.load	$10=, 0($pop18)
	copy_local	$9=, $8
	copy_local	$7=, $3
.LBB0_22:                               # %if.end.i95
                                        #   in Loop: Header=BB0_19 Depth=2
	end_block                       # label16:
	i32.const	$push98=, 0
	i32.load	$push21=, 0($2)
	i32.load	$push22=, 0($pop21)
	i32.store	vx($pop98), $pop22
	i32.const	$push97=, 0
	i32.ne  	$6=, $9, $pop97
	i32.eqz 	$push121=, $9
	br_if   	4, $pop121      # 4: down to label3
# BB#23:                                # %if.end.i95
                                        #   in Loop: Header=BB0_19 Depth=2
	copy_local	$3=, $10
	copy_local	$8=, $9
	br_if   	0, $10          # 0: up to label15
	br      	4               # 4: down to label3
.LBB0_24:                               # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop
	end_block                       # label6:
	i32.store	0($4), $3
.LBB0_25:                               # %while.cond.backedge
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	br_if   	3, $0           # 3: up to label1
	br      	2               # 2: down to label2
.LBB0_26:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	copy_local	$9=, $8
	copy_local	$10=, $3
.LBB0_27:                               # %merge_pagelist.exit102
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.const	$push99=, 32
	i32.add 	$push24=, $7, $pop99
	i32.select	$push23=, $9, $10, $6
	i32.store	0($pop24), $pop23
	i32.load	$push25=, 0($2)
	i32.store	0($5), $pop25
	br_if   	1, $0           # 1: up to label1
.LBB0_28:                               # %while.end.loopexit
	end_block                       # label2:
	end_loop
	i32.load	$3=, 0($1)
.LBB0_29:                               # %while.end
	end_block                       # label0:
	i32.const	$push47=, 112
	i32.add 	$push48=, $1, $pop47
	i32.const	$push100=, 32
	i32.add 	$2=, $pop48, $pop100
	i32.const	$4=, 1
.LBB0_30:                               # %for.body17
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_33 Depth 2
	loop    	                # label18:
	i32.const	$push103=, 2
	i32.shl 	$push26=, $4, $pop103
	i32.add 	$push27=, $1, $pop26
	i32.load	$8=, 0($pop27)
	i32.const	$push102=, 0
	i32.store	xx($pop102), $2
	i32.const	$push101=, 0
	i32.ne  	$6=, $3, $pop101
	i32.const	$push49=, 112
	i32.add 	$push50=, $1, $pop49
	copy_local	$7=, $pop50
	block   	
	block   	
	i32.eqz 	$push122=, $3
	br_if   	0, $pop122      # 0: down to label20
# BB#31:                                # %for.body17
                                        #   in Loop: Header=BB0_30 Depth=1
	i32.eqz 	$push123=, $8
	br_if   	0, $pop123      # 0: down to label20
# BB#32:                                # %while.body.i54.preheader
                                        #   in Loop: Header=BB0_30 Depth=1
	i32.const	$push51=, 112
	i32.add 	$push52=, $1, $pop51
	copy_local	$7=, $pop52
.LBB0_33:                               # %while.body.i54
                                        #   Parent Loop BB0_30 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label21:
	block   	
	block   	
	i32.load	$push29=, 4($3)
	i32.load	$push28=, 4($8)
	i32.ge_u	$push30=, $pop29, $pop28
	br_if   	0, $pop30       # 0: down to label23
# BB#34:                                # %if.then.i56
                                        #   in Loop: Header=BB0_33 Depth=2
	i32.const	$push105=, 32
	i32.add 	$push33=, $7, $pop105
	i32.store	0($pop33), $3
	i32.const	$push104=, 32
	i32.add 	$push34=, $3, $pop104
	i32.load	$9=, 0($pop34)
	copy_local	$10=, $8
	copy_local	$7=, $3
	br      	1               # 1: down to label22
.LBB0_35:                               # %if.else.i58
                                        #   in Loop: Header=BB0_33 Depth=2
	end_block                       # label23:
	i32.const	$push107=, 32
	i32.add 	$push31=, $7, $pop107
	i32.store	0($pop31), $8
	i32.const	$push106=, 32
	i32.add 	$push32=, $8, $pop106
	i32.load	$10=, 0($pop32)
	copy_local	$9=, $3
	copy_local	$7=, $8
.LBB0_36:                               # %if.end.i65
                                        #   in Loop: Header=BB0_33 Depth=2
	end_block                       # label22:
	i32.const	$push109=, 0
	i32.load	$push35=, 0($2)
	i32.load	$push36=, 0($pop35)
	i32.store	vx($pop109), $pop36
	i32.const	$push108=, 0
	i32.ne  	$6=, $9, $pop108
	i32.eqz 	$push124=, $9
	br_if   	2, $pop124      # 2: down to label19
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
	i32.const	$push114=, 32
	i32.add 	$push38=, $7, $pop114
	i32.select	$push37=, $9, $10, $6
	i32.store	0($pop38), $pop37
	i32.load	$3=, 0($2)
	i32.const	$push113=, 1
	i32.add 	$push112=, $4, $pop113
	tee_local	$push111=, $4=, $pop112
	i32.const	$push110=, 25
	i32.ne  	$push39=, $pop111, $pop110
	br_if   	0, $pop39       # 0: up to label18
# BB#40:                                # %for.end22
	end_loop
	i32.const	$push46=, 0
	i32.const	$push44=, 160
	i32.add 	$push45=, $1, $pop44
	i32.store	__stack_pointer($pop46), $pop45
	copy_local	$push125=, $3
                                        # fallthrough-return: $pop125
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


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	abort, void
