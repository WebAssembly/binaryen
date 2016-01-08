	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strncmp-1.c"
	.section	.text.test,"ax",@progbits
	.hidden	test
	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.call	$2=, strncmp, $0, $1, $2
	block   	.LBB0_3
	i32.const	$push0=, -1
	i32.gt_s	$push1=, $3, $pop0
	br_if   	$pop1, .LBB0_3
# BB#1:                                 # %entry
	i32.const	$push2=, 0
	i32.lt_s	$push3=, $2, $pop2
	br_if   	$pop3, .LBB0_3
# BB#2:                                 # %if.then
	call    	abort
	unreachable
.LBB0_3:                                # %if.else
	block   	.LBB0_6
	br_if   	$3, .LBB0_6
# BB#4:                                 # %if.else
	i32.const	$push8=, 0
	i32.eq  	$push9=, $2, $pop8
	br_if   	$pop9, .LBB0_6
# BB#5:                                 # %if.then5
	call    	abort
	unreachable
.LBB0_6:                                # %if.else6
	block   	.LBB0_9
	i32.const	$push4=, 1
	i32.lt_s	$push5=, $3, $pop4
	br_if   	$pop5, .LBB0_9
# BB#7:                                 # %if.else6
	i32.const	$push6=, 0
	i32.gt_s	$push7=, $2, $pop6
	br_if   	$pop7, .LBB0_9
# BB#8:                                 # %if.then10
	call    	abort
	unreachable
.LBB0_9:                                # %if.end12
	return
.Lfunc_end0:
	.size	test, .Lfunc_end0-test

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$8=, 0
	i32.const	$1=, u1
	copy_local	$0=, $8
.LBB1_1:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
                                        #       Child Loop BB1_3 Depth 3
                                        #         Child Loop BB1_4 Depth 4
                                        #         Child Loop BB1_6 Depth 4
                                        #         Child Loop BB1_9 Depth 4
                                        #         Child Loop BB1_11 Depth 4
	block   	.LBB1_52
	block   	.LBB1_51
	block   	.LBB1_50
	block   	.LBB1_49
	block   	.LBB1_48
	block   	.LBB1_47
	block   	.LBB1_46
	block   	.LBB1_45
	block   	.LBB1_44
	block   	.LBB1_43
	block   	.LBB1_42
	block   	.LBB1_41
	block   	.LBB1_40
	block   	.LBB1_39
	block   	.LBB1_38
	block   	.LBB1_37
	block   	.LBB1_36
	block   	.LBB1_35
	loop    	.LBB1_34
	i32.const	$3=, u2
	copy_local	$2=, $8
.LBB1_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_3 Depth 3
                                        #         Child Loop BB1_4 Depth 4
                                        #         Child Loop BB1_6 Depth 4
                                        #         Child Loop BB1_9 Depth 4
                                        #         Child Loop BB1_11 Depth 4
	loop    	.LBB1_33
	copy_local	$4=, $8
.LBB1_3:                                # %for.cond7.preheader
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB1_4 Depth 4
                                        #         Child Loop BB1_6 Depth 4
                                        #         Child Loop BB1_9 Depth 4
                                        #         Child Loop BB1_11 Depth 4
	loop    	.LBB1_32
	i32.const	$5=, u1
	copy_local	$16=, $8
	block   	.LBB1_5
	i32.const	$push70=, 0
	i32.eq  	$push71=, $0, $pop70
	br_if   	$pop71, .LBB1_5
.LBB1_4:                                # %for.body9
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        #       Parent Loop BB1_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop    	.LBB1_5
	i32.const	$push0=, u1
	i32.add 	$push1=, $pop0, $16
	i32.store8	$discard=, 0($pop1), $8
	i32.const	$push2=, 1
	i32.add 	$16=, $16, $pop2
	copy_local	$5=, $1
	i32.ne  	$push3=, $0, $16
	br_if   	$pop3, .LBB1_4
.LBB1_5:                                # %for.cond10.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$16=, 0
	copy_local	$6=, $5
	block   	.LBB1_8
	i32.const	$push72=, 0
	i32.eq  	$push73=, $4, $pop72
	br_if   	$pop73, .LBB1_8
.LBB1_6:                                # %for.body12
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        #       Parent Loop BB1_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop    	.LBB1_7
	i32.add 	$push4=, $5, $16
	i32.const	$push5=, 97
	i32.store8	$discard=, 0($pop4), $pop5
	i32.const	$push6=, 1
	i32.add 	$16=, $16, $pop6
	i32.ne  	$push7=, $4, $16
	br_if   	$pop7, .LBB1_6
.LBB1_7:                                # %for.cond17.preheader.loopexit
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.add 	$6=, $5, $4
.LBB1_8:                                # %for.cond17.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push8=, 120
	i32.store8	$push9=, 0($6), $pop8
	i32.store8	$push10=, 1($6), $pop9
	i32.store8	$push11=, 2($6), $pop10
	i32.store8	$push12=, 3($6), $pop11
	i32.store8	$push13=, 4($6), $pop12
	i32.store8	$push14=, 5($6), $pop13
	i32.store8	$push15=, 6($6), $pop14
	i32.store8	$11=, 7($6), $pop15
	i32.const	$9=, 0
	i32.const	$7=, u2
	copy_local	$16=, $9
	block   	.LBB1_10
	i32.const	$push74=, 0
	i32.eq  	$push75=, $2, $pop74
	br_if   	$pop75, .LBB1_10
.LBB1_9:                                # %for.body26
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        #       Parent Loop BB1_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop    	.LBB1_10
	i32.const	$push16=, u2
	i32.add 	$push17=, $pop16, $16
	i32.store8	$discard=, 0($pop17), $9
	i32.const	$push18=, 1
	i32.add 	$16=, $16, $pop18
	copy_local	$7=, $3
	i32.ne  	$push19=, $2, $16
	br_if   	$pop19, .LBB1_9
.LBB1_10:                               # %for.cond31.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$16=, 0
	copy_local	$9=, $7
	block   	.LBB1_13
	i32.const	$push76=, 0
	i32.eq  	$push77=, $4, $pop76
	br_if   	$pop77, .LBB1_13
.LBB1_11:                               # %for.body33
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        #       Parent Loop BB1_3 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	loop    	.LBB1_12
	i32.add 	$push20=, $7, $16
	i32.const	$push21=, 97
	i32.store8	$discard=, 0($pop20), $pop21
	i32.const	$push22=, 1
	i32.add 	$16=, $16, $pop22
	i32.ne  	$push23=, $4, $16
	br_if   	$pop23, .LBB1_11
.LBB1_12:                               # %for.cond38.preheader.loopexit
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.add 	$9=, $7, $4
.LBB1_13:                               # %for.cond38.preheader
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.store8	$push24=, 1($9), $11
	i32.store8	$push25=, 2($9), $pop24
	i32.store8	$push26=, 3($9), $pop25
	i32.store8	$push27=, 4($9), $pop26
	i32.store8	$push28=, 5($9), $pop27
	i32.store8	$push29=, 6($9), $pop28
	i32.store8	$discard=, 7($9), $pop29
	i32.const	$push30=, 0
	i32.store8	$11=, 0($6), $pop30
	i32.const	$16=, 80
	i32.store8	$12=, 0($9), $11
	i32.call	$push31=, strncmp, $5, $7, $16
	br_if   	$pop31, .LBB1_52
# BB#14:                                # %test.exit
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push32=, strncmp, $5, $7, $4
	br_if   	$pop32, .LBB1_51
# BB#15:                                # %test.exit185
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push33=, 97
	i32.store8	$13=, 0($6), $pop33
	i32.const	$10=, 1
	i32.add 	$11=, $6, $10
	i32.store8	$push34=, 0($11), $12
	i32.store8	$12=, 0($9), $pop34
	i32.call	$push35=, strncmp, $5, $7, $16
	i32.le_s	$push36=, $pop35, $12
	br_if   	$pop36, .LBB1_50
# BB#16:                                # %test.exit190
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push37=, strncmp, $5, $7, $4
	br_if   	$pop37, .LBB1_49
# BB#17:                                # %test.exit196
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.store8	$discard=, 0($9), $13
	i32.store8	$13=, 0($6), $12
	i32.add 	$12=, $9, $10
	i32.store8	$discard=, 0($12), $13
	i32.call	$push38=, strncmp, $5, $7, $16
	i32.ge_s	$push39=, $pop38, $13
	br_if   	$pop39, .LBB1_48
# BB#18:                                # %test.exit201
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push40=, strncmp, $5, $7, $4
	br_if   	$pop40, .LBB1_47
# BB#19:                                # %test.exit207
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.const	$push41=, 98
	i32.store8	$14=, 0($6), $pop41
	i32.store8	$discard=, 0($11), $13
	i32.const	$push42=, 99
	i32.store8	$15=, 0($9), $pop42
	i32.store8	$discard=, 0($12), $13
	i32.call	$push43=, strncmp, $5, $7, $16
	i32.ge_s	$push44=, $pop43, $13
	br_if   	$pop44, .LBB1_46
# BB#20:                                # %test.exit213
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push45=, strncmp, $5, $7, $4
	br_if   	$pop45, .LBB1_45
# BB#21:                                # %test.exit219
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.store8	$discard=, 0($6), $15
	i32.store8	$discard=, 0($9), $14
	i32.store8	$push46=, 0($11), $13
	i32.store8	$13=, 0($12), $pop46
	i32.call	$push47=, strncmp, $5, $7, $16
	i32.le_s	$push48=, $pop47, $13
	br_if   	$pop48, .LBB1_44
# BB#22:                                # %test.exit225
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push49=, strncmp, $5, $7, $4
	br_if   	$pop49, .LBB1_43
# BB#23:                                # %test.exit231
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.store8	$discard=, 0($6), $14
	i32.store8	$discard=, 0($11), $13
	i32.const	$push50=, 169
	i32.store8	$15=, 0($9), $pop50
	i32.store8	$discard=, 0($12), $13
	i32.call	$push51=, strncmp, $5, $7, $16
	i32.ge_s	$push52=, $pop51, $13
	br_if   	$pop52, .LBB1_42
# BB#24:                                # %test.exit237
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push53=, strncmp, $5, $7, $4
	br_if   	$pop53, .LBB1_41
# BB#25:                                # %test.exit243
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.store8	$discard=, 0($9), $14
	i32.store8	$14=, 0($6), $15
	i32.store8	$push54=, 0($11), $13
	i32.store8	$13=, 0($12), $pop54
	i32.call	$push55=, strncmp, $5, $7, $16
	i32.le_s	$push56=, $pop55, $13
	br_if   	$pop56, .LBB1_40
# BB#26:                                # %test.exit249
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push57=, strncmp, $5, $7, $4
	br_if   	$pop57, .LBB1_39
# BB#27:                                # %test.exit255
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.store8	$discard=, 0($6), $14
	i32.store8	$discard=, 0($11), $13
	i32.const	$push58=, 170
	i32.store8	$15=, 0($9), $pop58
	i32.store8	$discard=, 0($12), $13
	i32.call	$push59=, strncmp, $5, $7, $16
	i32.ge_s	$push60=, $pop59, $13
	br_if   	$pop60, .LBB1_38
# BB#28:                                # %test.exit261
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push61=, strncmp, $5, $7, $4
	br_if   	$pop61, .LBB1_37
# BB#29:                                # %test.exit267
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.store8	$discard=, 0($6), $15
	i32.store8	$discard=, 0($9), $14
	i32.store8	$push62=, 0($11), $13
	i32.store8	$9=, 0($12), $pop62
	i32.call	$push63=, strncmp, $5, $7, $16
	i32.le_s	$push64=, $pop63, $9
	br_if   	$pop64, .LBB1_36
# BB#30:                                # %test.exit273
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.call	$push65=, strncmp, $5, $7, $4
	br_if   	$pop65, .LBB1_35
# BB#31:                                # %for.cond4
                                        #   in Loop: Header=BB1_3 Depth=3
	i32.add 	$4=, $4, $10
	i32.const	$push66=, 63
	i32.le_u	$push67=, $4, $pop66
	br_if   	$pop67, .LBB1_3
.LBB1_32:                               # %for.inc79
                                        #   in Loop: Header=BB1_2 Depth=2
	i32.add 	$2=, $2, $10
	i32.add 	$3=, $3, $10
	i32.const	$16=, 8
	i32.lt_u	$push68=, $2, $16
	br_if   	$pop68, .LBB1_2
.LBB1_33:                               # %for.inc82
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.add 	$0=, $0, $10
	i32.add 	$1=, $1, $10
	i32.lt_u	$push69=, $0, $16
	br_if   	$pop69, .LBB1_1
.LBB1_34:                               # %for.end84
	call    	exit, $9
	unreachable
.LBB1_35:                               # %if.then5.i277
	call    	abort
	unreachable
.LBB1_36:                               # %if.then10.i272
	call    	abort
	unreachable
.LBB1_37:                               # %if.then5.i265
	call    	abort
	unreachable
.LBB1_38:                               # %if.then.i258
	call    	abort
	unreachable
.LBB1_39:                               # %if.then5.i253
	call    	abort
	unreachable
.LBB1_40:                               # %if.then10.i248
	call    	abort
	unreachable
.LBB1_41:                               # %if.then5.i241
	call    	abort
	unreachable
.LBB1_42:                               # %if.then.i234
	call    	abort
	unreachable
.LBB1_43:                               # %if.then5.i229
	call    	abort
	unreachable
.LBB1_44:                               # %if.then10.i224
	call    	abort
	unreachable
.LBB1_45:                               # %if.then5.i217
	call    	abort
	unreachable
.LBB1_46:                               # %if.then.i210
	call    	abort
	unreachable
.LBB1_47:                               # %if.then5.i205
	call    	abort
	unreachable
.LBB1_48:                               # %if.then.i
	call    	abort
	unreachable
.LBB1_49:                               # %if.then5.i194
	call    	abort
	unreachable
.LBB1_50:                               # %if.then10.i
	call    	abort
	unreachable
.LBB1_51:                               # %if.then5.i183
	call    	abort
	unreachable
.LBB1_52:                               # %if.then5.i
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	u1,@object              # @u1
	.lcomm	u1,80,4
	.type	u2,@object              # @u2
	.lcomm	u2,80,4

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
