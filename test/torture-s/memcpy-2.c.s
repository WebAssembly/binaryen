	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memcpy-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
.LBB0_1:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_6 Depth 4
                                        #         Child Loop BB0_9 Depth 4
	block
	block
	block
	loop                            # label3:
	i32.const	$push44=, u1
	i32.add 	$1=, $0, $pop44
	i32.const	$2=, 0
.LBB0_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_6 Depth 4
                                        #         Child Loop BB0_9 Depth 4
	loop                            # label5:
	i32.const	$push46=, u2
	i32.add 	$3=, $2, $pop46
	i32.const	$push45=, 65
	i32.add 	$4=, $2, $pop45
	i32.const	$5=, 1
.LBB0_3:                                # %for.cond7.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_6 Depth 4
                                        #         Child Loop BB0_9 Depth 4
	loop                            # label7:
	i32.const	$push49=, u1
	i32.const	$push48=, 97
	i32.const	$push47=, 96
	i32.call	$discard=, memset@FUNCTION, $pop49, $pop48, $pop47
	i32.const	$6=, 65
	i32.const	$8=, -96
.LBB0_4:                                # %for.body9
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label9:
	i32.const	$push55=, 65
	i32.const	$push54=, 24
	i32.shl 	$push0=, $6, $pop54
	i32.const	$push53=, 24
	i32.shr_s	$push1=, $pop0, $pop53
	i32.const	$push52=, 95
	i32.gt_s	$push2=, $pop1, $pop52
	i32.select	$push3=, $pop55, $6, $pop2
	i32.store8	$push4=, u2+96($8), $pop3
	i32.const	$push51=, 1
	i32.add 	$6=, $pop4, $pop51
	i32.const	$push50=, 1
	i32.add 	$8=, $8, $pop50
	br_if   	0, $8           # 0: up to label9
# BB#5:                                 # %for.end
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop                        # label10:
	i32.call	$discard=, memcpy@FUNCTION, $1, $3, $5
	i32.const	$7=, u1
	i32.const	$8=, 0
	block
	i32.const	$push56=, 1
	i32.lt_s	$push5=, $0, $pop56
	br_if   	0, $pop5        # 0: down to label11
.LBB0_6:                                # %for.body23
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label12:
	i32.load8_u	$push6=, u1($8)
	i32.const	$push57=, 97
	i32.ne  	$push7=, $pop6, $pop57
	br_if   	10, $pop7       # 10: down to label1
# BB#7:                                 # %for.inc29
                                        #   in Loop: Header=BB0_6 Depth=4
	i32.const	$push59=, u1+1
	i32.add 	$7=, $8, $pop59
	i32.const	$push58=, 1
	i32.add 	$6=, $8, $pop58
	copy_local	$8=, $6
	i32.lt_s	$push8=, $6, $0
	br_if   	0, $pop8        # 0: up to label12
.LBB0_8:                                # %for.body36.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop                        # label13:
	end_block                       # label11:
	i32.const	$8=, 0
	copy_local	$6=, $4
.LBB0_9:                                # %for.body36
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label14:
	i32.add 	$push13=, $7, $8
	i32.load8_u	$push14=, 0($pop13)
	i32.const	$push66=, 65
	i32.const	$push65=, 24
	i32.shl 	$push9=, $6, $pop65
	i32.const	$push64=, 24
	i32.shr_s	$push10=, $pop9, $pop64
	i32.const	$push63=, 95
	i32.gt_s	$push11=, $pop10, $pop63
	i32.select	$push62=, $pop66, $6, $pop11
	tee_local	$push61=, $6=, $pop62
	i32.const	$push60=, 255
	i32.and 	$push12=, $pop61, $pop60
	i32.ne  	$push15=, $pop14, $pop12
	br_if   	8, $pop15       # 8: down to label2
# BB#10:                                # %for.inc48
                                        #   in Loop: Header=BB0_9 Depth=4
	i32.const	$push68=, 1
	i32.add 	$8=, $8, $pop68
	i32.const	$push67=, 1
	i32.add 	$6=, $6, $pop67
	i32.lt_s	$push16=, $8, $5
	br_if   	0, $pop16       # 0: up to label14
# BB#11:                                # %for.body56.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop                        # label15:
	i32.add 	$push71=, $7, $8
	tee_local	$push70=, $8=, $pop71
	i32.load8_u	$push17=, 0($pop70)
	i32.const	$push69=, 97
	i32.ne  	$push18=, $pop17, $pop69
	br_if   	8, $pop18       # 8: down to label0
# BB#12:                                # %for.inc62
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push73=, 1
	i32.add 	$push19=, $8, $pop73
	i32.load8_u	$push20=, 0($pop19)
	i32.const	$push72=, 97
	i32.ne  	$push21=, $pop20, $pop72
	br_if   	8, $pop21       # 8: down to label0
# BB#13:                                # %for.inc62.1
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push79=, 2
	i32.add 	$push22=, $8, $pop79
	i32.load8_u	$push23=, 0($pop22)
	i32.const	$push78=, 97
	i32.ne  	$push24=, $pop23, $pop78
	br_if   	8, $pop24       # 8: down to label0
# BB#14:                                # %for.inc62.2
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push81=, 3
	i32.add 	$push25=, $8, $pop81
	i32.load8_u	$push26=, 0($pop25)
	i32.const	$push80=, 97
	i32.ne  	$push27=, $pop26, $pop80
	br_if   	8, $pop27       # 8: down to label0
# BB#15:                                # %for.inc62.3
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push83=, 4
	i32.add 	$push28=, $8, $pop83
	i32.load8_u	$push29=, 0($pop28)
	i32.const	$push82=, 97
	i32.ne  	$push30=, $pop29, $pop82
	br_if   	8, $pop30       # 8: down to label0
# BB#16:                                # %for.inc62.4
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push85=, 5
	i32.add 	$push31=, $8, $pop85
	i32.load8_u	$push32=, 0($pop31)
	i32.const	$push84=, 97
	i32.ne  	$push33=, $pop32, $pop84
	br_if   	8, $pop33       # 8: down to label0
# BB#17:                                # %for.inc62.5
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push87=, 6
	i32.add 	$push34=, $8, $pop87
	i32.load8_u	$push35=, 0($pop34)
	i32.const	$push86=, 97
	i32.ne  	$push36=, $pop35, $pop86
	br_if   	8, $pop36       # 8: down to label0
# BB#18:                                # %for.inc62.6
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push89=, 7
	i32.add 	$push37=, $8, $pop89
	i32.load8_u	$push38=, 0($pop37)
	i32.const	$push88=, 97
	i32.ne  	$push39=, $pop38, $pop88
	br_if   	8, $pop39       # 8: down to label0
# BB#19:                                # %for.inc62.7
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push91=, 1
	i32.add 	$5=, $5, $pop91
	i32.const	$push90=, 80
	i32.lt_u	$push40=, $5, $pop90
	br_if   	0, $pop40       # 0: up to label7
# BB#20:                                # %for.inc69
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label8:
	i32.const	$push75=, 1
	i32.add 	$2=, $2, $pop75
	i32.const	$push74=, 8
	i32.lt_u	$push41=, $2, $pop74
	br_if   	0, $pop41       # 0: up to label5
# BB#21:                                # %for.inc72
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label6:
	i32.const	$push77=, 1
	i32.add 	$0=, $0, $pop77
	i32.const	$push76=, 8
	i32.lt_u	$push42=, $0, $pop76
	br_if   	0, $pop42       # 0: up to label3
# BB#22:                                # %for.end74
	end_loop                        # label4:
	i32.const	$push43=, 0
	call    	exit@FUNCTION, $pop43
	unreachable
.LBB0_23:                               # %if.then46
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_24:                               # %if.then27
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_25:                               # %if.then60
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	u1,@object              # @u1
	.lcomm	u1,96,4
	.type	u2,@object              # @u2
	.lcomm	u2,96,4

	.ident	"clang version 3.9.0 "
