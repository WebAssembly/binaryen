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
                                        #         Child Loop BB0_10 Depth 4
	block
	block
	loop                            # label2:
	i32.const	$push46=, u1
	i32.add 	$1=, $0, $pop46
	i32.const	$2=, 0
.LBB0_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_6 Depth 4
                                        #         Child Loop BB0_10 Depth 4
	loop                            # label4:
	i32.const	$push48=, u2
	i32.add 	$3=, $2, $pop48
	i32.const	$push47=, 65
	i32.add 	$4=, $2, $pop47
	i32.const	$5=, 1
.LBB0_3:                                # %for.cond7.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_6 Depth 4
                                        #         Child Loop BB0_10 Depth 4
	loop                            # label6:
	i32.const	$push51=, u1
	i32.const	$push50=, 97
	i32.const	$push49=, 96
	i32.call	$discard=, memset@FUNCTION, $pop51, $pop50, $pop49
	i32.const	$6=, 65
	i32.const	$8=, -96
.LBB0_4:                                # %for.body9
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label8:
	i32.const	$push57=, 65
	i32.const	$push56=, 24
	i32.shl 	$push2=, $6, $pop56
	i32.const	$push55=, 24
	i32.shr_s	$push3=, $pop2, $pop55
	i32.const	$push54=, 95
	i32.gt_s	$push4=, $pop3, $pop54
	i32.select	$push5=, $pop57, $6, $pop4
	i32.store8	$push6=, u2+96($8), $pop5
	i32.const	$push53=, 1
	i32.add 	$6=, $pop6, $pop53
	i32.const	$push52=, 1
	i32.add 	$8=, $8, $pop52
	br_if   	0, $8           # 0: up to label8
# BB#5:                                 # %for.end
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop                        # label9:
	i32.call	$discard=, memcpy@FUNCTION, $1, $3, $5
	i32.const	$7=, u1
	i32.const	$8=, 0
	block
	i32.const	$push58=, 1
	i32.lt_s	$push7=, $0, $pop58
	br_if   	0, $pop7        # 0: down to label10
.LBB0_6:                                # %for.body23
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label11:
	i32.load8_u	$push8=, u1($8)
	i32.const	$push59=, 97
	i32.ne  	$push9=, $pop8, $pop59
	br_if   	1, $pop9        # 1: down to label12
# BB#7:                                 # %for.inc29
                                        #   in Loop: Header=BB0_6 Depth=4
	i32.const	$push61=, u1+1
	i32.add 	$7=, $8, $pop61
	i32.const	$push60=, 1
	i32.add 	$6=, $8, $pop60
	copy_local	$8=, $6
	i32.lt_s	$push10=, $6, $0
	br_if   	0, $pop10       # 0: up to label11
	br      	2               # 2: down to label10
.LBB0_8:                                # %if.then27
	end_loop                        # label12:
	call    	abort@FUNCTION
	unreachable
.LBB0_9:                                # %for.body36.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	end_block                       # label10:
	i32.const	$8=, 0
	copy_local	$6=, $4
.LBB0_10:                               # %for.body36
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop                            # label13:
	i32.add 	$push15=, $7, $8
	i32.load8_u	$push16=, 0($pop15)
	i32.const	$push67=, 65
	i32.const	$push66=, 24
	i32.shl 	$push11=, $6, $pop66
	i32.const	$push65=, 24
	i32.shr_s	$push12=, $pop11, $pop65
	i32.const	$push64=, 95
	i32.gt_s	$push13=, $pop12, $pop64
	i32.select	$push0=, $pop67, $6, $pop13
	tee_local	$push63=, $6=, $pop0
	i32.const	$push62=, 255
	i32.and 	$push14=, $pop63, $pop62
	i32.ne  	$push17=, $pop16, $pop14
	br_if   	9, $pop17       # 9: down to label0
# BB#11:                                # %for.inc48
                                        #   in Loop: Header=BB0_10 Depth=4
	i32.const	$push69=, 1
	i32.add 	$8=, $8, $pop69
	i32.const	$push68=, 1
	i32.add 	$6=, $6, $pop68
	i32.lt_s	$push18=, $8, $5
	br_if   	0, $pop18       # 0: up to label13
# BB#12:                                # %for.body56.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	end_loop                        # label14:
	i32.add 	$push1=, $7, $8
	tee_local	$push71=, $8=, $pop1
	i32.load8_u	$push19=, 0($pop71)
	i32.const	$push70=, 97
	i32.ne  	$push20=, $pop19, $pop70
	br_if   	6, $pop20       # 6: down to label1
# BB#13:                                # %for.inc62
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push73=, 1
	i32.add 	$push21=, $8, $pop73
	i32.load8_u	$push22=, 0($pop21)
	i32.const	$push72=, 97
	i32.ne  	$push23=, $pop22, $pop72
	br_if   	6, $pop23       # 6: down to label1
# BB#14:                                # %for.inc62.1
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push79=, 2
	i32.add 	$push24=, $8, $pop79
	i32.load8_u	$push25=, 0($pop24)
	i32.const	$push78=, 97
	i32.ne  	$push26=, $pop25, $pop78
	br_if   	6, $pop26       # 6: down to label1
# BB#15:                                # %for.inc62.2
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push81=, 3
	i32.add 	$push27=, $8, $pop81
	i32.load8_u	$push28=, 0($pop27)
	i32.const	$push80=, 97
	i32.ne  	$push29=, $pop28, $pop80
	br_if   	6, $pop29       # 6: down to label1
# BB#16:                                # %for.inc62.3
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push83=, 4
	i32.add 	$push30=, $8, $pop83
	i32.load8_u	$push31=, 0($pop30)
	i32.const	$push82=, 97
	i32.ne  	$push32=, $pop31, $pop82
	br_if   	6, $pop32       # 6: down to label1
# BB#17:                                # %for.inc62.4
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push85=, 5
	i32.add 	$push33=, $8, $pop85
	i32.load8_u	$push34=, 0($pop33)
	i32.const	$push84=, 97
	i32.ne  	$push35=, $pop34, $pop84
	br_if   	6, $pop35       # 6: down to label1
# BB#18:                                # %for.inc62.5
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push87=, 6
	i32.add 	$push36=, $8, $pop87
	i32.load8_u	$push37=, 0($pop36)
	i32.const	$push86=, 97
	i32.ne  	$push38=, $pop37, $pop86
	br_if   	6, $pop38       # 6: down to label1
# BB#19:                                # %for.inc62.6
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push89=, 7
	i32.add 	$push39=, $8, $pop89
	i32.load8_u	$push40=, 0($pop39)
	i32.const	$push88=, 97
	i32.ne  	$push41=, $pop40, $pop88
	br_if   	6, $pop41       # 6: down to label1
# BB#20:                                # %for.inc62.7
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push91=, 1
	i32.add 	$5=, $5, $pop91
	i32.const	$push90=, 80
	i32.lt_u	$push42=, $5, $pop90
	br_if   	0, $pop42       # 0: up to label6
# BB#21:                                # %for.inc69
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label7:
	i32.const	$push75=, 1
	i32.add 	$2=, $2, $pop75
	i32.const	$push74=, 8
	i32.lt_u	$push43=, $2, $pop74
	br_if   	0, $pop43       # 0: up to label4
# BB#22:                                # %for.inc72
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label5:
	i32.const	$push77=, 1
	i32.add 	$0=, $0, $pop77
	i32.const	$push76=, 8
	i32.lt_u	$push44=, $0, $pop76
	br_if   	0, $pop44       # 0: up to label2
# BB#23:                                # %for.end74
	end_loop                        # label3:
	i32.const	$push45=, 0
	call    	exit@FUNCTION, $pop45
	unreachable
.LBB0_24:                               # %if.then60
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_25:                               # %if.then46
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
