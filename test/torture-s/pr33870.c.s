	.text
	.file	"pr33870.c"
	.section	.text.sort_pagelist,"ax",@progbits
	.hidden	sort_pagelist           # -- Begin function sort_pagelist
	.globl	sort_pagelist
	.type	sort_pagelist,@function
sort_pagelist:                          # @sort_pagelist
	.param  	i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push32=, 0
	i32.load	$push31=, __stack_pointer($pop32)
	i32.const	$push33=, 144
	i32.sub 	$7=, $pop31, $pop33
	i32.const	$push34=, 0
	i32.store	__stack_pointer($pop34), $7
	i32.const	$push54=, 0
	i32.const	$push0=, 100
	i32.call	$1=, memset@FUNCTION, $7, $pop54, $pop0
	i32.const	$7=, 0
	block   	
	i32.eqz 	$push85=, $0
	br_if   	0, $pop85       # 0: down to label0
# %bb.1:                                # %while.body.lr.ph
	i32.const	$push44=, 104
	i32.add 	$push45=, $1, $pop44
	i32.const	$push56=, 28
	i32.add 	$3=, $pop45, $pop56
	i32.const	$push46=, 104
	i32.add 	$push47=, $1, $pop46
	i32.const	$push55=, 28
	i32.add 	$2=, $pop47, $pop55
	i32.const	$push9=, 96
	i32.add 	$5=, $1, $pop9
.LBB0_2:                                # %while.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
                                        #       Child Loop BB0_6 Depth 3
                                        #     Child Loop BB0_21 Depth 2
	loop    	                # label1:
	copy_local	$7=, $0
	i32.load	$0=, 28($7)
	i32.const	$push57=, 0
	i32.store	28($7), $pop57
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
	i32.const	$push58=, 2
	i32.shl 	$push1=, $6, $pop58
	i32.add 	$4=, $1, $pop1
	i32.load	$9=, 0($4)
	i32.eqz 	$push86=, $9
	br_if   	1, $pop86       # 1: down to label11
# %bb.4:                                # %if.else
                                        #   in Loop: Header=BB0_3 Depth=2
	block   	
	block   	
	block   	
	i32.eqz 	$push87=, $7
	br_if   	0, $pop87       # 0: down to label15
# %bb.5:                                # %while.body.i.preheader
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.const	$push52=, 104
	i32.add 	$push53=, $1, $pop52
	copy_local	$8=, $pop53
.LBB0_6:                                # %while.body.i
                                        #   Parent Loop BB0_2 Depth=1
                                        #     Parent Loop BB0_3 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	block   	
	loop    	                # label17:
	block   	
	block   	
	i32.load	$push3=, 0($9)
	i32.load	$push2=, 0($7)
	i32.ge_u	$push4=, $pop3, $pop2
	br_if   	0, $pop4        # 0: down to label19
# %bb.7:                                # %if.then.i
                                        #   in Loop: Header=BB0_6 Depth=3
	i32.const	$push59=, 28
	i32.add 	$push6=, $8, $pop59
	i32.store	0($pop6), $9
	i32.load	$11=, 28($9)
	copy_local	$10=, $7
	copy_local	$8=, $9
	br_if   	1, $11          # 1: down to label18
	br      	3               # 3: down to label16
.LBB0_8:                                # %if.else.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_block                       # label19:
	i32.const	$push60=, 28
	i32.add 	$push5=, $8, $pop60
	i32.store	0($pop5), $7
	i32.load	$10=, 28($7)
	copy_local	$11=, $9
	copy_local	$8=, $7
	i32.eqz 	$push88=, $11
	br_if   	2, $pop88       # 2: down to label16
.LBB0_9:                                # %if.end.i
                                        #   in Loop: Header=BB0_6 Depth=3
	end_block                       # label18:
	copy_local	$7=, $10
	copy_local	$9=, $11
	br_if   	0, $10          # 0: up to label17
.LBB0_10:                               # %while.end.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_loop
	end_block                       # label16:
	i32.const	$push61=, 28
	i32.add 	$7=, $8, $pop61
	i32.eqz 	$push89=, $11
	br_if   	1, $pop89       # 1: down to label14
# %bb.11:                               # %if.then7.i
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	0($7), $11
	br      	2               # 2: down to label13
.LBB0_12:                               #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label15:
	copy_local	$push25=, $2
	copy_local	$push26=, $9
	i32.store	0($pop25), $pop26
	br      	1               # 1: down to label13
.LBB0_13:                               # %if.else9.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label14:
	block   	
	i32.eqz 	$push90=, $10
	br_if   	0, $pop90       # 0: down to label20
# %bb.14:                               # %if.then11.i
                                        #   in Loop: Header=BB0_3 Depth=2
	i32.store	0($7), $10
	br      	1               # 1: down to label13
.LBB0_15:                               # %if.else13.i
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label20:
	i32.const	$push62=, 0
	i32.store	0($7), $pop62
.LBB0_16:                               # %merge_pagelist.exit
                                        #   in Loop: Header=BB0_3 Depth=2
	end_block                       # label13:
	i32.const	$push48=, 104
	i32.add 	$push49=, $1, $pop48
	i32.const	$push66=, 28
	i32.add 	$9=, $pop49, $pop66
	i32.load	$7=, 0($9)
	i32.const	$push65=, 0
	i32.store	0($4), $pop65
	i32.const	$push64=, 1
	i32.add 	$6=, $6, $pop64
	i32.const	$push63=, 24
	i32.lt_u	$push7=, $6, $pop63
	br_if   	0, $pop7        # 0: up to label12
# %bb.17:                               # %for.end
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop
	i32.const	$push67=, 24
	i32.ne  	$push8=, $6, $pop67
	br_if   	1, $pop8        # 1: down to label10
# %bb.18:                               # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.load	$11=, 0($5)
	i32.eqz 	$push91=, $7
	br_if   	2, $pop91       # 2: down to label9
# %bb.19:                               # %if.then7
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.eqz 	$push92=, $11
	br_if   	2, $pop92       # 2: down to label9
# %bb.20:                               # %while.body.i86.preheader
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.const	$push50=, 104
	i32.add 	$push51=, $1, $pop50
	copy_local	$6=, $pop51
.LBB0_21:                               # %while.body.i86
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label22:
	block   	
	block   	
	i32.load	$push11=, 0($11)
	i32.load	$push10=, 0($7)
	i32.ge_u	$push12=, $pop11, $pop10
	br_if   	0, $pop12       # 0: down to label24
# %bb.22:                               # %if.then.i88
                                        #   in Loop: Header=BB0_21 Depth=2
	i32.const	$push68=, 28
	i32.add 	$push14=, $6, $pop68
	i32.store	0($pop14), $11
	i32.load	$10=, 28($11)
	copy_local	$8=, $7
	copy_local	$6=, $11
	br_if   	1, $10          # 1: down to label23
	br      	3               # 3: down to label21
.LBB0_23:                               # %if.else.i90
                                        #   in Loop: Header=BB0_21 Depth=2
	end_block                       # label24:
	i32.const	$push69=, 28
	i32.add 	$push13=, $6, $pop69
	i32.store	0($pop13), $7
	i32.load	$8=, 28($7)
	copy_local	$10=, $11
	copy_local	$6=, $7
	i32.eqz 	$push93=, $10
	br_if   	2, $pop93       # 2: down to label21
.LBB0_24:                               # %if.end.i96
                                        #   in Loop: Header=BB0_21 Depth=2
	end_block                       # label23:
	copy_local	$7=, $8
	copy_local	$11=, $10
	br_if   	0, $8           # 0: up to label22
.LBB0_25:                               # %while.end.i103.loopexit
                                        #   in Loop: Header=BB0_2 Depth=1
	end_loop
	end_block                       # label21:
	i32.const	$push70=, 28
	i32.add 	$6=, $6, $pop70
	i32.eqz 	$push94=, $10
	br_if   	4, $pop94       # 4: down to label7
# %bb.26:                               #   in Loop: Header=BB0_2 Depth=1
	copy_local	$11=, $10
	br      	3               # 3: down to label8
.LBB0_27:                               # %for.end.thread
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label11:
	i32.store	0($4), $7
.LBB0_28:                               # %if.end11
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label10:
	br_if   	8, $0           # 8: up to label1
	br      	7               # 7: down to label2
.LBB0_29:                               # %while.end.i103
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label9:
	copy_local	$6=, $3
	i32.eqz 	$push95=, $11
	br_if   	2, $pop95       # 2: down to label6
.LBB0_30:                               # %if.then7.i104
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label8:
	i32.store	0($6), $11
	br      	4               # 4: down to label3
.LBB0_31:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label7:
	i32.const	$push71=, 0
	i32.ne  	$push28=, $8, $pop71
	br_if   	1, $pop28       # 1: down to label5
	br      	2               # 2: down to label4
.LBB0_32:                               #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label6:
	copy_local	$8=, $7
	copy_local	$6=, $3
	i32.const	$push73=, 0
	i32.eq  	$push27=, $7, $pop73
	br_if   	1, $pop27       # 1: down to label4
.LBB0_33:                               # %if.then11.i106
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label5:
	i32.store	0($6), $8
	br      	1               # 1: down to label3
.LBB0_34:                               # %if.else13.i107
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label4:
	i32.const	$push72=, 0
	i32.store	0($6), $pop72
.LBB0_35:                               # %merge_pagelist.exit109
                                        #   in Loop: Header=BB0_2 Depth=1
	end_block                       # label3:
	i32.load	$push15=, 0($9)
	i32.store	0($5), $pop15
	br_if   	1, $0           # 1: up to label1
.LBB0_36:                               # %while.end.loopexit
	end_block                       # label2:
	end_loop
	i32.load	$7=, 0($1)
.LBB0_37:                               # %while.end
	end_block                       # label0:
	i32.const	$push38=, 104
	i32.add 	$push39=, $1, $pop38
	i32.const	$push74=, 28
	i32.add 	$4=, $pop39, $pop74
	i32.const	$6=, 1
.LBB0_38:                               # %for.body15
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_41 Depth 2
	loop    	                # label25:
	i32.const	$push75=, 2
	i32.shl 	$push16=, $6, $pop75
	i32.add 	$push17=, $1, $pop16
	i32.load	$9=, 0($pop17)
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	i32.eqz 	$push96=, $7
	br_if   	0, $pop96       # 0: down to label32
# %bb.39:                               # %for.body15
                                        #   in Loop: Header=BB0_38 Depth=1
	i32.eqz 	$push97=, $9
	br_if   	0, $pop97       # 0: down to label32
# %bb.40:                               # %while.body.i51.preheader
                                        #   in Loop: Header=BB0_38 Depth=1
	i32.const	$push40=, 104
	i32.add 	$push41=, $1, $pop40
	copy_local	$8=, $pop41
.LBB0_41:                               # %while.body.i51
                                        #   Parent Loop BB0_38 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	block   	
	loop    	                # label34:
	block   	
	block   	
	i32.load	$push19=, 0($7)
	i32.load	$push18=, 0($9)
	i32.ge_u	$push20=, $pop19, $pop18
	br_if   	0, $pop20       # 0: down to label36
# %bb.42:                               # %if.then.i53
                                        #   in Loop: Header=BB0_41 Depth=2
	i32.const	$push76=, 28
	i32.add 	$push22=, $8, $pop76
	i32.store	0($pop22), $7
	i32.load	$11=, 28($7)
	copy_local	$10=, $9
	copy_local	$8=, $7
	br_if   	1, $11          # 1: down to label35
	br      	3               # 3: down to label33
.LBB0_43:                               # %if.else.i55
                                        #   in Loop: Header=BB0_41 Depth=2
	end_block                       # label36:
	i32.const	$push77=, 28
	i32.add 	$push21=, $8, $pop77
	i32.store	0($pop21), $9
	i32.load	$10=, 28($9)
	copy_local	$11=, $7
	copy_local	$8=, $9
	i32.eqz 	$push98=, $11
	br_if   	2, $pop98       # 2: down to label33
.LBB0_44:                               # %if.end.i61
                                        #   in Loop: Header=BB0_41 Depth=2
	end_block                       # label35:
	copy_local	$9=, $10
	copy_local	$7=, $11
	br_if   	0, $10          # 0: up to label34
.LBB0_45:                               # %while.end.i68.loopexit
                                        #   in Loop: Header=BB0_38 Depth=1
	end_loop
	end_block                       # label33:
	i32.const	$push78=, 28
	i32.add 	$8=, $8, $pop78
	i32.eqz 	$push99=, $11
	br_if   	2, $pop99       # 2: down to label30
# %bb.46:                               #   in Loop: Header=BB0_38 Depth=1
	copy_local	$7=, $11
	br      	1               # 1: down to label31
.LBB0_47:                               # %while.end.i68
                                        #   in Loop: Header=BB0_38 Depth=1
	end_block                       # label32:
	copy_local	$8=, $4
	i32.eqz 	$push100=, $7
	br_if   	2, $pop100      # 2: down to label29
.LBB0_48:                               # %if.then7.i69
                                        #   in Loop: Header=BB0_38 Depth=1
	end_block                       # label31:
	i32.store	0($8), $7
	br      	4               # 4: down to label26
.LBB0_49:                               #   in Loop: Header=BB0_38 Depth=1
	end_block                       # label30:
	i32.const	$push79=, 0
	i32.ne  	$push30=, $10, $pop79
	br_if   	1, $pop30       # 1: down to label28
	br      	2               # 2: down to label27
.LBB0_50:                               #   in Loop: Header=BB0_38 Depth=1
	end_block                       # label29:
	copy_local	$10=, $9
	copy_local	$8=, $4
	i32.const	$push81=, 0
	i32.eq  	$push29=, $9, $pop81
	br_if   	1, $pop29       # 1: down to label27
.LBB0_51:                               # %if.then11.i71
                                        #   in Loop: Header=BB0_38 Depth=1
	end_block                       # label28:
	i32.store	0($8), $10
	br      	1               # 1: down to label26
.LBB0_52:                               # %if.else13.i72
                                        #   in Loop: Header=BB0_38 Depth=1
	end_block                       # label27:
	i32.const	$push80=, 0
	i32.store	0($8), $pop80
.LBB0_53:                               # %merge_pagelist.exit74
                                        #   in Loop: Header=BB0_38 Depth=1
	end_block                       # label26:
	i32.const	$push84=, 1
	i32.add 	$6=, $6, $pop84
	i32.const	$push42=, 104
	i32.add 	$push43=, $1, $pop42
	i32.const	$push83=, 28
	i32.add 	$push24=, $pop43, $pop83
	i32.load	$7=, 0($pop24)
	i32.const	$push82=, 25
	i32.ne  	$push23=, $6, $pop82
	br_if   	0, $pop23       # 0: up to label25
# %bb.54:                               # %for.end20
	end_loop
	i32.const	$push37=, 0
	i32.const	$push35=, 144
	i32.add 	$push36=, $1, $pop35
	i32.store	__stack_pointer($pop37), $pop36
	copy_local	$push101=, $7
                                        # fallthrough-return: $pop101
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
	i32.const	$push19=, 0
	i32.load	$push18=, __stack_pointer($pop19)
	i32.const	$push20=, 208
	i32.sub 	$1=, $pop18, $pop20
	i32.const	$push21=, 0
	i32.store	__stack_pointer($pop21), $1
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
	i32.const	$push25=, 0
	i32.store	0($pop9), $pop25
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
	i32.call	$0=, sort_pagelist@FUNCTION, $1
	block   	
	i32.load	$push16=, 28($0)
	i32.eq  	$push17=, $0, $pop16
	br_if   	0, $pop17       # 0: down to label37
# %bb.1:                                # %if.end
	i32.const	$push24=, 0
	i32.const	$push22=, 208
	i32.add 	$push23=, $1, $pop22
	i32.store	__stack_pointer($pop24), $pop23
	i32.const	$push26=, 0
	return  	$pop26
.LBB1_2:                                # %if.then
	end_block                       # label37:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
