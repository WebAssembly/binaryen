	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memcpy-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, 0
	copy_local	$0=, $6
.LBB0_1:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_6 Depth 4
                                        #         Child Loop BB0_10 Depth 4
	block   	.LBB0_25
	block   	.LBB0_24
	loop    	.LBB0_23
	i32.const	$7=, u1
	i32.add 	$1=, $7, $0
	copy_local	$2=, $6
.LBB0_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_6 Depth 4
                                        #         Child Loop BB0_10 Depth 4
	loop    	.LBB0_22
	i32.const	$8=, u2
	i32.add 	$3=, $8, $2
	i32.const	$9=, 65
	i32.add 	$4=, $2, $9
	i32.const	$5=, 1
.LBB0_3:                                # %for.cond7.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_4 Depth 4
                                        #         Child Loop BB0_6 Depth 4
                                        #         Child Loop BB0_10 Depth 4
	loop    	.LBB0_21
	i32.const	$14=, -96
	copy_local	$15=, $9
.LBB0_4:                                # %for.body9
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop    	.LBB0_5
	i32.const	$13=, 96
	i32.add 	$push0=, $7, $14
	i32.add 	$push1=, $pop0, $13
	i32.const	$push2=, 97
	i32.store8	$10=, 0($pop1), $pop2
	i32.const	$11=, 24
	i32.const	$12=, 95
	i32.add 	$push7=, $8, $14
	i32.add 	$push8=, $pop7, $13
	i32.shl 	$push3=, $15, $11
	i32.shr_s	$push4=, $pop3, $11
	i32.gt_s	$push5=, $pop4, $12
	i32.select	$push6=, $pop5, $9, $15
	i32.store8	$15=, 0($pop8), $pop6
	i32.const	$13=, 1
	i32.add 	$15=, $15, $13
	i32.add 	$14=, $14, $13
	br_if   	$14, .LBB0_4
.LBB0_5:                                # %for.end
                                        #   in Loop: Header=BB0_3 Depth=3
	call    	memcpy, $1, $3, $5
	i32.const	$14=, 0
	copy_local	$16=, $7
	block   	.LBB0_9
	i32.lt_s	$push9=, $0, $13
	br_if   	$pop9, .LBB0_9
.LBB0_6:                                # %for.body23
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop    	.LBB0_8
	i32.const	$15=, u1
	i32.add 	$push10=, $15, $14
	i32.load8_u	$push11=, 0($pop10)
	i32.ne  	$push12=, $pop11, $10
	br_if   	$pop12, .LBB0_8
# BB#7:                                 # %for.inc29
                                        #   in Loop: Header=BB0_6 Depth=4
	i32.add 	$14=, $14, $13
	i32.add 	$16=, $15, $14
	i32.lt_s	$push13=, $14, $0
	br_if   	$pop13, .LBB0_6
	br      	.LBB0_9
.LBB0_8:                                # %if.then27
	call    	abort
	unreachable
.LBB0_9:                                # %for.body36.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$14=, 0
	copy_local	$15=, $4
.LBB0_10:                               # %for.body36
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        #       Parent Loop BB0_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop    	.LBB0_12
	i32.shl 	$push14=, $15, $11
	i32.shr_s	$push15=, $pop14, $11
	i32.gt_s	$push16=, $pop15, $12
	i32.const	$push17=, 65
	i32.select	$15=, $pop16, $pop17, $15
	i32.add 	$push20=, $16, $14
	i32.load8_u	$push21=, 0($pop20)
	i32.const	$push18=, 255
	i32.and 	$push19=, $15, $pop18
	i32.ne  	$push22=, $pop21, $pop19
	br_if   	$pop22, .LBB0_25
# BB#11:                                # %for.inc48
                                        #   in Loop: Header=BB0_10 Depth=4
	i32.add 	$14=, $14, $13
	i32.add 	$15=, $15, $13
	i32.lt_s	$push23=, $14, $5
	br_if   	$pop23, .LBB0_10
.LBB0_12:                               # %for.body56.preheader
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.add 	$14=, $16, $14
	i32.load8_u	$push24=, 0($14)
	i32.ne  	$push25=, $pop24, $10
	br_if   	$pop25, .LBB0_24
# BB#13:                                # %for.inc62
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.add 	$push26=, $14, $13
	i32.load8_u	$push27=, 0($pop26)
	i32.ne  	$push28=, $pop27, $10
	br_if   	$pop28, .LBB0_24
# BB#14:                                # %for.inc62.1
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push29=, 2
	i32.add 	$push30=, $14, $pop29
	i32.load8_u	$push31=, 0($pop30)
	i32.ne  	$push32=, $pop31, $10
	br_if   	$pop32, .LBB0_24
# BB#15:                                # %for.inc62.2
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push33=, 3
	i32.add 	$push34=, $14, $pop33
	i32.load8_u	$push35=, 0($pop34)
	i32.ne  	$push36=, $pop35, $10
	br_if   	$pop36, .LBB0_24
# BB#16:                                # %for.inc62.3
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push37=, 4
	i32.add 	$push38=, $14, $pop37
	i32.load8_u	$push39=, 0($pop38)
	i32.ne  	$push40=, $pop39, $10
	br_if   	$pop40, .LBB0_24
# BB#17:                                # %for.inc62.4
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push41=, 5
	i32.add 	$push42=, $14, $pop41
	i32.load8_u	$push43=, 0($pop42)
	i32.ne  	$push44=, $pop43, $10
	br_if   	$pop44, .LBB0_24
# BB#18:                                # %for.inc62.5
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push45=, 6
	i32.add 	$push46=, $14, $pop45
	i32.load8_u	$push47=, 0($pop46)
	i32.ne  	$push48=, $pop47, $10
	br_if   	$pop48, .LBB0_24
# BB#19:                                # %for.inc62.6
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.const	$push49=, 7
	i32.add 	$push50=, $14, $pop49
	i32.load8_u	$push51=, 0($pop50)
	i32.ne  	$push52=, $pop51, $10
	br_if   	$pop52, .LBB0_24
# BB#20:                                # %for.inc62.7
                                        #   in Loop: Header=BB0_3 Depth=3
	i32.add 	$5=, $5, $13
	i32.const	$push53=, 80
	i32.lt_u	$push54=, $5, $pop53
	br_if   	$pop54, .LBB0_3
.LBB0_21:                               # %for.inc69
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.add 	$2=, $2, $13
	i32.const	$14=, 8
	i32.lt_u	$push55=, $2, $14
	br_if   	$pop55, .LBB0_2
.LBB0_22:                               # %for.inc72
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.add 	$0=, $0, $13
	i32.lt_u	$push56=, $0, $14
	br_if   	$pop56, .LBB0_1
.LBB0_23:                               # %for.end74
	i32.const	$push57=, 0
	call    	exit, $pop57
	unreachable
.LBB0_24:                               # %if.then60
	call    	abort
	unreachable
.LBB0_25:                               # %if.then46
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	u1,@object              # @u1
	.lcomm	u1,96,4
	.type	u2,@object              # @u2
	.lcomm	u2,96,4

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
