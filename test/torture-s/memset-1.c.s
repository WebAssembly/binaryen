	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/memset-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
.LBB0_1:                                # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
                                        #       Child Loop BB0_3 Depth 3
                                        #       Child Loop BB0_5 Depth 3
                                        #       Child Loop BB0_9 Depth 3
                                        #       Child Loop BB0_20 Depth 3
                                        #       Child Loop BB0_24 Depth 3
                                        #       Child Loop BB0_35 Depth 3
                                        #       Child Loop BB0_39 Depth 3
	block
	block
	block
	block
	block
	block
	loop                            # label6:
	i32.const	$3=, u
	i32.add 	$1=, $3, $0
	i32.const	$2=, 1
.LBB0_2:                                # %for.cond4.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
                                        #       Child Loop BB0_5 Depth 3
                                        #       Child Loop BB0_9 Depth 3
                                        #       Child Loop BB0_20 Depth 3
                                        #       Child Loop BB0_24 Depth 3
                                        #       Child Loop BB0_35 Depth 3
                                        #       Child Loop BB0_39 Depth 3
	loop                            # label8:
	i32.const	$14=, -96
.LBB0_3:                                # %for.body6
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label10:
	i32.add 	$push0=, $3, $14
	i32.const	$push1=, 96
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, 97
	i32.store8	$4=, 0($pop2), $pop3
	i32.const	$5=, 1
	i32.add 	$14=, $14, $5
	br_if   	$14, 0          # 0: up to label10
# BB#4:                                 # %for.end
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label11:
	i32.const	$14=, 0
	call    	memset@FUNCTION, $1, $14, $2
	copy_local	$6=, $3
	block
	i32.lt_s	$push4=, $0, $5
	br_if   	$pop4, 0        # 0: down to label12
.LBB0_5:                                # %for.body11
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label13:
	i32.const	$6=, u
	i32.add 	$push5=, $6, $14
	i32.load8_u	$push6=, 0($pop5)
	i32.ne  	$push7=, $pop6, $4
	br_if   	$pop7, 1        # 1: down to label14
# BB#6:                                 # %for.inc16
                                        #   in Loop: Header=BB0_5 Depth=3
	i32.add 	$14=, $14, $5
	i32.add 	$6=, $6, $14
	i32.lt_s	$push8=, $14, $0
	br_if   	$pop8, 0        # 0: up to label13
	br      	2               # 2: down to label12
.LBB0_7:                                # %if.then14
	end_loop                        # label14:
	call    	abort@FUNCTION
	unreachable
.LBB0_8:                                # %for.body22.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label12:
	i32.const	$14=, 0
.LBB0_9:                                # %for.body22
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label15:
	i32.add 	$push9=, $6, $14
	i32.load8_u	$push10=, 0($pop9)
	br_if   	$pop10, 11      # 11: down to label0
# BB#10:                                # %for.inc28
                                        #   in Loop: Header=BB0_9 Depth=3
	i32.add 	$14=, $14, $5
	i32.lt_s	$push11=, $14, $2
	br_if   	$pop11, 0       # 0: up to label15
# BB#11:                                # %for.body35.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label16:
	i32.add 	$14=, $6, $14
	i32.load8_u	$push12=, 0($14)
	i32.ne  	$push13=, $pop12, $4
	br_if   	$pop13, 8       # 8: down to label1
# BB#12:                                # %for.inc41
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.add 	$push14=, $14, $5
	i32.load8_u	$push15=, 0($pop14)
	i32.ne  	$push16=, $pop15, $4
	br_if   	$pop16, 8       # 8: down to label1
# BB#13:                                # %for.inc41.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$7=, 2
	i32.add 	$push17=, $14, $7
	i32.load8_u	$push18=, 0($pop17)
	i32.ne  	$push19=, $pop18, $4
	br_if   	$pop19, 8       # 8: down to label1
# BB#14:                                # %for.inc41.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$8=, 3
	i32.add 	$push20=, $14, $8
	i32.load8_u	$push21=, 0($pop20)
	i32.ne  	$push22=, $pop21, $4
	br_if   	$pop22, 8       # 8: down to label1
# BB#15:                                # %for.inc41.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$9=, 4
	i32.add 	$push23=, $14, $9
	i32.load8_u	$push24=, 0($pop23)
	i32.ne  	$push25=, $pop24, $4
	br_if   	$pop25, 8       # 8: down to label1
# BB#16:                                # %for.inc41.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$10=, 5
	i32.add 	$push26=, $14, $10
	i32.load8_u	$push27=, 0($pop26)
	i32.ne  	$push28=, $pop27, $4
	br_if   	$pop28, 8       # 8: down to label1
# BB#17:                                # %for.inc41.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$11=, 6
	i32.add 	$push29=, $14, $11
	i32.load8_u	$push30=, 0($pop29)
	i32.ne  	$push31=, $pop30, $4
	br_if   	$pop31, 8       # 8: down to label1
# BB#18:                                # %for.inc41.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$12=, 7
	i32.add 	$push32=, $14, $12
	i32.load8_u	$push33=, 0($pop32)
	i32.ne  	$push34=, $pop33, $4
	br_if   	$pop34, 8       # 8: down to label1
# BB#19:                                # %for.inc41.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$14=, 0
	i32.load8_u	$push36=, A($14)
	call    	memset@FUNCTION, $1, $pop36, $2
	i32.const	$6=, u
	block
	i32.le_s	$push35=, $0, $14
	br_if   	$pop35, 0       # 0: down to label17
.LBB0_20:                               # %for.body55
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label18:
	i32.const	$6=, u
	i32.add 	$push37=, $6, $14
	i32.load8_u	$push38=, 0($pop37)
	i32.ne  	$push39=, $pop38, $4
	br_if   	$pop39, 1       # 1: down to label19
# BB#21:                                # %for.inc61
                                        #   in Loop: Header=BB0_20 Depth=3
	i32.add 	$14=, $14, $5
	i32.add 	$6=, $6, $14
	i32.lt_s	$push40=, $14, $0
	br_if   	$pop40, 0       # 0: up to label18
	br      	2               # 2: down to label17
.LBB0_22:                               # %if.then59
	end_loop                        # label19:
	call    	abort@FUNCTION
	unreachable
.LBB0_23:                               # %for.body68.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label17:
	i32.const	$14=, 0
.LBB0_24:                               # %for.body68
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label20:
	i32.add 	$push41=, $6, $14
	i32.load8_u	$push42=, 0($pop41)
	i32.const	$push43=, 65
	i32.ne  	$push44=, $pop42, $pop43
	br_if   	$pop44, 9       # 9: down to label2
# BB#25:                                # %for.inc74
                                        #   in Loop: Header=BB0_24 Depth=3
	i32.add 	$14=, $14, $5
	i32.lt_s	$push45=, $14, $2
	br_if   	$pop45, 0       # 0: up to label20
# BB#26:                                # %for.body81.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label21:
	i32.add 	$14=, $6, $14
	i32.load8_u	$push46=, 0($14)
	i32.ne  	$push47=, $pop46, $4
	br_if   	$pop47, 6       # 6: down to label3
# BB#27:                                # %for.inc87
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.add 	$push48=, $14, $5
	i32.load8_u	$push49=, 0($pop48)
	i32.ne  	$push50=, $pop49, $4
	br_if   	$pop50, 6       # 6: down to label3
# BB#28:                                # %for.inc87.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.add 	$push51=, $14, $7
	i32.load8_u	$push52=, 0($pop51)
	i32.ne  	$push53=, $pop52, $4
	br_if   	$pop53, 6       # 6: down to label3
# BB#29:                                # %for.inc87.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.add 	$push54=, $14, $8
	i32.load8_u	$push55=, 0($pop54)
	i32.ne  	$push56=, $pop55, $4
	br_if   	$pop56, 6       # 6: down to label3
# BB#30:                                # %for.inc87.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.add 	$push57=, $14, $9
	i32.load8_u	$push58=, 0($pop57)
	i32.ne  	$push59=, $pop58, $4
	br_if   	$pop59, 6       # 6: down to label3
# BB#31:                                # %for.inc87.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.add 	$push60=, $14, $10
	i32.load8_u	$push61=, 0($pop60)
	i32.ne  	$push62=, $pop61, $4
	br_if   	$pop62, 6       # 6: down to label3
# BB#32:                                # %for.inc87.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.add 	$push63=, $14, $11
	i32.load8_u	$push64=, 0($pop63)
	i32.ne  	$push65=, $pop64, $4
	br_if   	$pop65, 6       # 6: down to label3
# BB#33:                                # %for.inc87.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.add 	$push66=, $14, $12
	i32.load8_u	$push67=, 0($pop66)
	i32.ne  	$push68=, $pop67, $4
	br_if   	$pop68, 6       # 6: down to label3
# BB#34:                                # %for.inc87.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$14=, 0
	i32.const	$13=, 66
	call    	memset@FUNCTION, $1, $13, $2
	i32.const	$6=, u
	block
	i32.le_s	$push69=, $0, $14
	br_if   	$pop69, 0       # 0: down to label22
.LBB0_35:                               # %for.body100
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label23:
	i32.const	$6=, u
	i32.add 	$push70=, $6, $14
	i32.load8_u	$push71=, 0($pop70)
	i32.ne  	$push72=, $pop71, $4
	br_if   	$pop72, 1       # 1: down to label24
# BB#36:                                # %for.inc106
                                        #   in Loop: Header=BB0_35 Depth=3
	i32.add 	$14=, $14, $5
	i32.add 	$6=, $6, $14
	i32.lt_s	$push73=, $14, $0
	br_if   	$pop73, 0       # 0: up to label23
	br      	2               # 2: down to label22
.LBB0_37:                               # %if.then104
	end_loop                        # label24:
	call    	abort@FUNCTION
	unreachable
.LBB0_38:                               # %for.body113.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_block                       # label22:
	i32.const	$14=, 0
.LBB0_39:                               # %for.body113
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label25:
	i32.add 	$push74=, $6, $14
	i32.load8_u	$push75=, 0($pop74)
	i32.ne  	$push76=, $pop75, $13
	br_if   	$pop76, 7       # 7: down to label4
# BB#40:                                # %for.inc119
                                        #   in Loop: Header=BB0_39 Depth=3
	i32.add 	$14=, $14, $5
	i32.lt_s	$push77=, $14, $2
	br_if   	$pop77, 0       # 0: up to label25
# BB#41:                                # %for.body126.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label26:
	i32.add 	$14=, $6, $14
	i32.load8_u	$push78=, 0($14)
	i32.ne  	$push79=, $pop78, $4
	br_if   	$pop79, 4       # 4: down to label5
# BB#42:                                # %for.inc132
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.add 	$push80=, $14, $5
	i32.load8_u	$push81=, 0($pop80)
	i32.ne  	$push82=, $pop81, $4
	br_if   	$pop82, 4       # 4: down to label5
# BB#43:                                # %for.inc132.1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.add 	$push83=, $14, $7
	i32.load8_u	$push84=, 0($pop83)
	i32.ne  	$push85=, $pop84, $4
	br_if   	$pop85, 4       # 4: down to label5
# BB#44:                                # %for.inc132.2
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.add 	$push86=, $14, $8
	i32.load8_u	$push87=, 0($pop86)
	i32.ne  	$push88=, $pop87, $4
	br_if   	$pop88, 4       # 4: down to label5
# BB#45:                                # %for.inc132.3
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.add 	$push89=, $14, $9
	i32.load8_u	$push90=, 0($pop89)
	i32.ne  	$push91=, $pop90, $4
	br_if   	$pop91, 4       # 4: down to label5
# BB#46:                                # %for.inc132.4
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.add 	$push92=, $14, $10
	i32.load8_u	$push93=, 0($pop92)
	i32.ne  	$push94=, $pop93, $4
	br_if   	$pop94, 4       # 4: down to label5
# BB#47:                                # %for.inc132.5
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.add 	$push95=, $14, $11
	i32.load8_u	$push96=, 0($pop95)
	i32.ne  	$push97=, $pop96, $4
	br_if   	$pop97, 4       # 4: down to label5
# BB#48:                                # %for.inc132.6
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.add 	$push98=, $14, $12
	i32.load8_u	$push99=, 0($pop98)
	i32.ne  	$push100=, $pop99, $4
	br_if   	$pop100, 4      # 4: down to label5
# BB#49:                                # %for.inc132.7
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.add 	$2=, $2, $5
	i32.const	$push101=, 80
	i32.lt_u	$push102=, $2, $pop101
	br_if   	$pop102, 0      # 0: up to label8
# BB#50:                                # %for.inc139
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label9:
	i32.add 	$0=, $0, $5
	i32.const	$push103=, 8
	i32.lt_u	$push104=, $0, $pop103
	br_if   	$pop104, 0      # 0: up to label6
# BB#51:                                # %for.end141
	end_loop                        # label7:
	i32.const	$push105=, 0
	call    	exit@FUNCTION, $pop105
	unreachable
.LBB0_52:                               # %if.then130
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_53:                               # %if.then117
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_54:                               # %if.then85
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_55:                               # %if.then72
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_56:                               # %if.then39
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_57:                               # %if.then26
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	A                       # @A
	.type	A,@object
	.section	.data.A,"aw",@progbits
	.globl	A
A:
	.int8	65                      # 0x41
	.size	A, 1

	.type	u,@object               # @u
	.lcomm	u,96,4

	.ident	"clang version 3.9.0 "
