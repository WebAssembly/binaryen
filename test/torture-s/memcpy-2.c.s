	.text
	.file	"memcpy-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$0=, 0
.LBB0_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_7 Depth 4
                                        #         Child Loop BB0_12 Depth 4
	block   	
	loop    	                # label1:
	i32.const	$push43=, u1
	i32.add 	$1=, $0, $pop43
	i32.const	$2=, 0
.LBB0_2:                                # %for.body3
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_7 Depth 4
                                        #         Child Loop BB0_12 Depth 4
	loop    	                # label2:
	i32.const	$push45=, 65
	i32.add 	$4=, $2, $pop45
	i32.const	$push44=, u2
	i32.add 	$3=, $2, $pop44
	i32.const	$5=, 1
.LBB0_3:                                # %for.body6
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_7 Depth 4
                                        #         Child Loop BB0_12 Depth 4
	loop    	                # label3:
	i32.const	$push48=, u1
	i32.const	$push47=, 97
	i32.const	$push46=, 96
	i32.call	$7=, memset@FUNCTION, $pop48, $pop47, $pop46
	i32.const	$6=, 65
	i32.const	$8=, -96
.LBB0_4:                                # %for.body9
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop    	                # label4:
	i32.const	$push55=, 65
	i32.const	$push54=, 24
	i32.shl 	$push0=, $6, $pop54
	i32.const	$push53=, 24
	i32.shr_s	$push1=, $pop0, $pop53
	i32.const	$push52=, 95
	i32.gt_s	$push2=, $pop1, $pop52
	i32.select	$6=, $pop55, $6, $pop2
	i32.const	$push51=, u2+96
	i32.add 	$push3=, $8, $pop51
	i32.store8	0($pop3), $6
	i32.const	$push50=, 1
	i32.add 	$8=, $8, $pop50
	i32.const	$push49=, 1
	i32.add 	$6=, $6, $pop49
	br_if   	0, $8           # 0: up to label4
# %bb.5:                                # %for.end
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop
	i32.call	$drop=, memcpy@FUNCTION, $1, $3, $5
	block   	
	block   	
	i32.eqz 	$push86=, $0
	br_if   	0, $pop86       # 0: down to label6
# %bb.6:                                # %for.body23.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$8=, 0
.LBB0_7:                                # %for.body23
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop    	                # label7:
	i32.add 	$push4=, $8, $7
	i32.load8_u	$push5=, 0($pop4)
	i32.const	$push56=, 97
	i32.ne  	$push6=, $pop5, $pop56
	br_if   	6, $pop6        # 6: down to label0
# %bb.8:                                # %for.inc29
                                        #   in Loop: Header=BB0_7 Depth=4
	i32.const	$push57=, 1
	i32.add 	$8=, $8, $pop57
	i32.lt_u	$push7=, $8, $0
	br_if   	0, $pop7        # 0: up to label7
# %bb.9:                                # %for.body36.preheader.loopexit
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop
	i32.add 	$7=, $8, $7
	br      	1               # 1: down to label5
.LBB0_10:                               #   in Loop: Header=BB0_3 Depth=3
	end_block                       # label6:
	i32.const	$7=, u1
.LBB0_11:                               # %for.body36.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	end_block                       # label5:
	i32.const	$8=, 0
	copy_local	$6=, $4
.LBB0_12:                               # %for.body36
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop    	                # label8:
	i32.const	$push62=, 65
	i32.const	$push61=, 24
	i32.shl 	$push8=, $6, $pop61
	i32.const	$push60=, 24
	i32.shr_s	$push9=, $pop8, $pop60
	i32.const	$push59=, 95
	i32.gt_s	$push10=, $pop9, $pop59
	i32.select	$6=, $pop62, $6, $pop10
	i32.add 	$push12=, $7, $8
	i32.load8_u	$push13=, 0($pop12)
	i32.const	$push58=, 255
	i32.and 	$push11=, $6, $pop58
	i32.ne  	$push14=, $pop13, $pop11
	br_if   	4, $pop14       # 4: down to label0
# %bb.13:                               # %for.inc48
                                        #   in Loop: Header=BB0_12 Depth=4
	i32.const	$push64=, 1
	i32.add 	$6=, $6, $pop64
	i32.const	$push63=, 1
	i32.add 	$8=, $8, $pop63
	i32.lt_u	$push15=, $8, $5
	br_if   	0, $pop15       # 0: up to label8
# %bb.14:                               # %for.end52
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop
	i32.add 	$8=, $7, $8
	i32.load8_u	$push16=, 0($8)
	i32.const	$push65=, 97
	i32.ne  	$push17=, $pop16, $pop65
	br_if   	3, $pop17       # 3: down to label0
# %bb.15:                               # %for.inc62
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push67=, 1
	i32.add 	$push18=, $8, $pop67
	i32.load8_u	$push19=, 0($pop18)
	i32.const	$push66=, 97
	i32.ne  	$push20=, $pop19, $pop66
	br_if   	3, $pop20       # 3: down to label0
# %bb.16:                               # %for.inc62.1
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push69=, 2
	i32.add 	$push21=, $8, $pop69
	i32.load8_u	$push22=, 0($pop21)
	i32.const	$push68=, 97
	i32.ne  	$push23=, $pop22, $pop68
	br_if   	3, $pop23       # 3: down to label0
# %bb.17:                               # %for.inc62.2
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push71=, 3
	i32.add 	$push24=, $8, $pop71
	i32.load8_u	$push25=, 0($pop24)
	i32.const	$push70=, 97
	i32.ne  	$push26=, $pop25, $pop70
	br_if   	3, $pop26       # 3: down to label0
# %bb.18:                               # %for.inc62.3
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push73=, 4
	i32.add 	$push27=, $8, $pop73
	i32.load8_u	$push28=, 0($pop27)
	i32.const	$push72=, 97
	i32.ne  	$push29=, $pop28, $pop72
	br_if   	3, $pop29       # 3: down to label0
# %bb.19:                               # %for.inc62.4
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push75=, 5
	i32.add 	$push30=, $8, $pop75
	i32.load8_u	$push31=, 0($pop30)
	i32.const	$push74=, 97
	i32.ne  	$push32=, $pop31, $pop74
	br_if   	3, $pop32       # 3: down to label0
# %bb.20:                               # %for.inc62.5
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push77=, 6
	i32.add 	$push33=, $8, $pop77
	i32.load8_u	$push34=, 0($pop33)
	i32.const	$push76=, 97
	i32.ne  	$push35=, $pop34, $pop76
	br_if   	3, $pop35       # 3: down to label0
# %bb.21:                               # %for.inc62.6
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push79=, 7
	i32.add 	$push36=, $8, $pop79
	i32.load8_u	$push37=, 0($pop36)
	i32.const	$push78=, 97
	i32.ne  	$push38=, $pop37, $pop78
	br_if   	3, $pop38       # 3: down to label0
# %bb.22:                               # %for.inc62.7
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push81=, 1
	i32.add 	$5=, $5, $pop81
	i32.const	$push80=, 80
	i32.lt_u	$push39=, $5, $pop80
	br_if   	0, $pop39       # 0: up to label3
# %bb.23:                               # %for.inc69
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop
	i32.const	$push83=, 1
	i32.add 	$2=, $2, $pop83
	i32.const	$push82=, 8
	i32.lt_u	$push40=, $2, $pop82
	br_if   	0, $pop40       # 0: up to label2
# %bb.24:                               # %for.inc72
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop
	i32.const	$push85=, 1
	i32.add 	$0=, $0, $pop85
	i32.const	$push84=, 8
	i32.lt_u	$push41=, $0, $pop84
	br_if   	0, $pop41       # 0: up to label1
# %bb.25:                               # %for.end74
	end_loop
	i32.const	$push42=, 0
	call    	exit@FUNCTION, $pop42
	unreachable
.LBB0_26:                               # %if.then27
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	u1,@object              # @u1
	.section	.bss.u1,"aw",@nobits
	.p2align	4
u1:
	.skip	96
	.size	u1, 96

	.type	u2,@object              # @u2
	.section	.bss.u2,"aw",@nobits
	.p2align	4
u2:
	.skip	96
	.size	u2, 96


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
