	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/ashrdi-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i32, i32, i32, i32
# BB#0:                                 # %entry
	i64.const	$0=, 0
	i32.const	$4=, zext
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	block
	block
	loop                            # label3:
	i64.const	$push32=, 8526495107234113920
	i64.shr_u	$push0=, $pop32, $0
	i64.load	$push1=, 0($4)
	i64.ne  	$push2=, $pop0, $pop1
	br_if   	2, $pop2        # 2: down to label2
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB0_1 Depth=1
	i64.const	$push31=, 1
	i64.add 	$0=, $0, $pop31
	i32.const	$push30=, 8
	i32.add 	$4=, $4, $pop30
	i64.const	$1=, 0
	i32.const	$5=, sext
	i64.const	$push29=, 63
	i64.le_s	$push3=, $0, $pop29
	br_if   	0, $pop3        # 0: up to label3
.LBB0_3:                                # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label4:
	loop                            # label5:
	i64.const	$push4=, -8152436031399644656
	i64.shr_s	$push5=, $pop4, $1
	i64.load	$push6=, 0($5)
	i64.ne  	$push7=, $pop5, $pop6
	br_if   	3, $pop7        # 3: down to label1
# BB#4:                                 # %for.cond2
                                        #   in Loop: Header=BB0_3 Depth=1
	i32.const	$push9=, 8
	i32.add 	$5=, $5, $pop9
	i64.const	$push8=, 1
	i64.add 	$1=, $1, $pop8
	i32.const	$3=, 0
	i32.const	$2=, zext
	i64.const	$push10=, 63
	i64.le_s	$push11=, $1, $pop10
	br_if   	0, $pop11       # 0: up to label5
.LBB0_5:                                # %for.body16
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label6:
	loop                            # label7:
	i64.const	$push12=, 8526495107234113920
	i64.call	$push13=, constant_shift@FUNCTION, $pop12, $3
	i64.load	$push14=, 0($2)
	i64.ne  	$push15=, $pop13, $pop14
	br_if   	4, $pop15       # 4: down to label0
# BB#6:                                 # %for.cond14
                                        #   in Loop: Header=BB0_5 Depth=1
	i32.const	$push16=, 1
	i32.add 	$3=, $3, $pop16
	i32.const	$push17=, 8
	i32.add 	$2=, $2, $pop17
	i32.const	$5=, 0
	i32.const	$4=, sext
	i32.const	$push18=, 63
	i32.le_s	$push19=, $3, $pop18
	br_if   	0, $pop19       # 0: up to label7
.LBB0_7:                                # %for.body28
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label8:
	block
	loop                            # label10:
	i64.const	$push20=, -8152436031399644656
	i64.call	$push21=, constant_shift@FUNCTION, $pop20, $5
	i64.load	$push22=, 0($4)
	i64.ne  	$push23=, $pop21, $pop22
	br_if   	2, $pop23       # 2: down to label9
# BB#8:                                 # %for.cond26
                                        #   in Loop: Header=BB0_7 Depth=1
	i32.const	$push24=, 1
	i32.add 	$5=, $5, $pop24
	i32.const	$push25=, 8
	i32.add 	$4=, $4, $pop25
	i32.const	$push26=, 63
	i32.le_s	$push27=, $5, $pop26
	br_if   	0, $pop27       # 0: up to label10
# BB#9:                                 # %for.end37
	end_loop                        # label11:
	i32.const	$push28=, 0
	call    	exit@FUNCTION, $pop28
	unreachable
.LBB0_10:                               # %if.then33
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB0_11:                               # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_12:                               # %if.then9
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_13:                               # %if.then21
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.constant_shift,"ax",@progbits
	.type	constant_shift,@function
constant_shift:                         # @constant_shift
	.param  	i64, i32
	.result 	i64
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 63
	i32.gt_u	$push1=, $1, $pop0
	br_if   	0, $pop1        # 0: down to label12
# BB#1:                                 # %entry
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
	block
	block
	block
	block
	tableswitch	$1, 63, 63, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62 # 63: down to label13
                                        # 0: down to label76
                                        # 1: down to label75
                                        # 2: down to label74
                                        # 3: down to label73
                                        # 4: down to label72
                                        # 5: down to label71
                                        # 6: down to label70
                                        # 7: down to label69
                                        # 8: down to label68
                                        # 9: down to label67
                                        # 10: down to label66
                                        # 11: down to label65
                                        # 12: down to label64
                                        # 13: down to label63
                                        # 14: down to label62
                                        # 15: down to label61
                                        # 16: down to label60
                                        # 17: down to label59
                                        # 18: down to label58
                                        # 19: down to label57
                                        # 20: down to label56
                                        # 21: down to label55
                                        # 22: down to label54
                                        # 23: down to label53
                                        # 24: down to label52
                                        # 25: down to label51
                                        # 26: down to label50
                                        # 27: down to label49
                                        # 28: down to label48
                                        # 29: down to label47
                                        # 30: down to label46
                                        # 31: down to label45
                                        # 32: down to label44
                                        # 33: down to label43
                                        # 34: down to label42
                                        # 35: down to label41
                                        # 36: down to label40
                                        # 37: down to label39
                                        # 38: down to label38
                                        # 39: down to label37
                                        # 40: down to label36
                                        # 41: down to label35
                                        # 42: down to label34
                                        # 43: down to label33
                                        # 44: down to label32
                                        # 45: down to label31
                                        # 46: down to label30
                                        # 47: down to label29
                                        # 48: down to label28
                                        # 49: down to label27
                                        # 50: down to label26
                                        # 51: down to label25
                                        # 52: down to label24
                                        # 53: down to label23
                                        # 54: down to label22
                                        # 55: down to label21
                                        # 56: down to label20
                                        # 57: down to label19
                                        # 58: down to label18
                                        # 59: down to label17
                                        # 60: down to label16
                                        # 61: down to label15
                                        # 62: down to label14
.LBB1_2:                                # %sw.bb1
	end_block                       # label76:
	i64.const	$push64=, 1
	i64.shr_s	$0=, $0, $pop64
	br      	62              # 62: down to label13
.LBB1_3:                                # %sw.bb3
	end_block                       # label75:
	i64.const	$push63=, 2
	i64.shr_s	$0=, $0, $pop63
	br      	61              # 61: down to label13
.LBB1_4:                                # %sw.bb5
	end_block                       # label74:
	i64.const	$push62=, 3
	i64.shr_s	$0=, $0, $pop62
	br      	60              # 60: down to label13
.LBB1_5:                                # %sw.bb7
	end_block                       # label73:
	i64.const	$push61=, 4
	i64.shr_s	$0=, $0, $pop61
	br      	59              # 59: down to label13
.LBB1_6:                                # %sw.bb9
	end_block                       # label72:
	i64.const	$push60=, 5
	i64.shr_s	$0=, $0, $pop60
	br      	58              # 58: down to label13
.LBB1_7:                                # %sw.bb11
	end_block                       # label71:
	i64.const	$push59=, 6
	i64.shr_s	$0=, $0, $pop59
	br      	57              # 57: down to label13
.LBB1_8:                                # %sw.bb13
	end_block                       # label70:
	i64.const	$push58=, 7
	i64.shr_s	$0=, $0, $pop58
	br      	56              # 56: down to label13
.LBB1_9:                                # %sw.bb15
	end_block                       # label69:
	i64.const	$push57=, 8
	i64.shr_s	$0=, $0, $pop57
	br      	55              # 55: down to label13
.LBB1_10:                               # %sw.bb17
	end_block                       # label68:
	i64.const	$push56=, 9
	i64.shr_s	$0=, $0, $pop56
	br      	54              # 54: down to label13
.LBB1_11:                               # %sw.bb19
	end_block                       # label67:
	i64.const	$push55=, 10
	i64.shr_s	$0=, $0, $pop55
	br      	53              # 53: down to label13
.LBB1_12:                               # %sw.bb21
	end_block                       # label66:
	i64.const	$push54=, 11
	i64.shr_s	$0=, $0, $pop54
	br      	52              # 52: down to label13
.LBB1_13:                               # %sw.bb23
	end_block                       # label65:
	i64.const	$push53=, 12
	i64.shr_s	$0=, $0, $pop53
	br      	51              # 51: down to label13
.LBB1_14:                               # %sw.bb25
	end_block                       # label64:
	i64.const	$push52=, 13
	i64.shr_s	$0=, $0, $pop52
	br      	50              # 50: down to label13
.LBB1_15:                               # %sw.bb27
	end_block                       # label63:
	i64.const	$push51=, 14
	i64.shr_s	$0=, $0, $pop51
	br      	49              # 49: down to label13
.LBB1_16:                               # %sw.bb29
	end_block                       # label62:
	i64.const	$push50=, 15
	i64.shr_s	$0=, $0, $pop50
	br      	48              # 48: down to label13
.LBB1_17:                               # %sw.bb31
	end_block                       # label61:
	i64.const	$push49=, 16
	i64.shr_s	$0=, $0, $pop49
	br      	47              # 47: down to label13
.LBB1_18:                               # %sw.bb33
	end_block                       # label60:
	i64.const	$push48=, 17
	i64.shr_s	$0=, $0, $pop48
	br      	46              # 46: down to label13
.LBB1_19:                               # %sw.bb35
	end_block                       # label59:
	i64.const	$push47=, 18
	i64.shr_s	$0=, $0, $pop47
	br      	45              # 45: down to label13
.LBB1_20:                               # %sw.bb37
	end_block                       # label58:
	i64.const	$push46=, 19
	i64.shr_s	$0=, $0, $pop46
	br      	44              # 44: down to label13
.LBB1_21:                               # %sw.bb39
	end_block                       # label57:
	i64.const	$push45=, 20
	i64.shr_s	$0=, $0, $pop45
	br      	43              # 43: down to label13
.LBB1_22:                               # %sw.bb41
	end_block                       # label56:
	i64.const	$push44=, 21
	i64.shr_s	$0=, $0, $pop44
	br      	42              # 42: down to label13
.LBB1_23:                               # %sw.bb43
	end_block                       # label55:
	i64.const	$push43=, 22
	i64.shr_s	$0=, $0, $pop43
	br      	41              # 41: down to label13
.LBB1_24:                               # %sw.bb45
	end_block                       # label54:
	i64.const	$push42=, 23
	i64.shr_s	$0=, $0, $pop42
	br      	40              # 40: down to label13
.LBB1_25:                               # %sw.bb47
	end_block                       # label53:
	i64.const	$push41=, 24
	i64.shr_s	$0=, $0, $pop41
	br      	39              # 39: down to label13
.LBB1_26:                               # %sw.bb49
	end_block                       # label52:
	i64.const	$push40=, 25
	i64.shr_s	$0=, $0, $pop40
	br      	38              # 38: down to label13
.LBB1_27:                               # %sw.bb51
	end_block                       # label51:
	i64.const	$push39=, 26
	i64.shr_s	$0=, $0, $pop39
	br      	37              # 37: down to label13
.LBB1_28:                               # %sw.bb53
	end_block                       # label50:
	i64.const	$push38=, 27
	i64.shr_s	$0=, $0, $pop38
	br      	36              # 36: down to label13
.LBB1_29:                               # %sw.bb55
	end_block                       # label49:
	i64.const	$push37=, 28
	i64.shr_s	$0=, $0, $pop37
	br      	35              # 35: down to label13
.LBB1_30:                               # %sw.bb57
	end_block                       # label48:
	i64.const	$push36=, 29
	i64.shr_s	$0=, $0, $pop36
	br      	34              # 34: down to label13
.LBB1_31:                               # %sw.bb59
	end_block                       # label47:
	i64.const	$push35=, 30
	i64.shr_s	$0=, $0, $pop35
	br      	33              # 33: down to label13
.LBB1_32:                               # %sw.bb61
	end_block                       # label46:
	i64.const	$push34=, 31
	i64.shr_s	$0=, $0, $pop34
	br      	32              # 32: down to label13
.LBB1_33:                               # %sw.bb63
	end_block                       # label45:
	i64.const	$push33=, 32
	i64.shr_s	$0=, $0, $pop33
	br      	31              # 31: down to label13
.LBB1_34:                               # %sw.bb65
	end_block                       # label44:
	i64.const	$push32=, 33
	i64.shr_s	$0=, $0, $pop32
	br      	30              # 30: down to label13
.LBB1_35:                               # %sw.bb67
	end_block                       # label43:
	i64.const	$push31=, 34
	i64.shr_s	$0=, $0, $pop31
	br      	29              # 29: down to label13
.LBB1_36:                               # %sw.bb69
	end_block                       # label42:
	i64.const	$push30=, 35
	i64.shr_s	$0=, $0, $pop30
	br      	28              # 28: down to label13
.LBB1_37:                               # %sw.bb71
	end_block                       # label41:
	i64.const	$push29=, 36
	i64.shr_s	$0=, $0, $pop29
	br      	27              # 27: down to label13
.LBB1_38:                               # %sw.bb73
	end_block                       # label40:
	i64.const	$push28=, 37
	i64.shr_s	$0=, $0, $pop28
	br      	26              # 26: down to label13
.LBB1_39:                               # %sw.bb75
	end_block                       # label39:
	i64.const	$push27=, 38
	i64.shr_s	$0=, $0, $pop27
	br      	25              # 25: down to label13
.LBB1_40:                               # %sw.bb77
	end_block                       # label38:
	i64.const	$push26=, 39
	i64.shr_s	$0=, $0, $pop26
	br      	24              # 24: down to label13
.LBB1_41:                               # %sw.bb79
	end_block                       # label37:
	i64.const	$push25=, 40
	i64.shr_s	$0=, $0, $pop25
	br      	23              # 23: down to label13
.LBB1_42:                               # %sw.bb81
	end_block                       # label36:
	i64.const	$push24=, 41
	i64.shr_s	$0=, $0, $pop24
	br      	22              # 22: down to label13
.LBB1_43:                               # %sw.bb83
	end_block                       # label35:
	i64.const	$push23=, 42
	i64.shr_s	$0=, $0, $pop23
	br      	21              # 21: down to label13
.LBB1_44:                               # %sw.bb85
	end_block                       # label34:
	i64.const	$push22=, 43
	i64.shr_s	$0=, $0, $pop22
	br      	20              # 20: down to label13
.LBB1_45:                               # %sw.bb87
	end_block                       # label33:
	i64.const	$push21=, 44
	i64.shr_s	$0=, $0, $pop21
	br      	19              # 19: down to label13
.LBB1_46:                               # %sw.bb89
	end_block                       # label32:
	i64.const	$push20=, 45
	i64.shr_s	$0=, $0, $pop20
	br      	18              # 18: down to label13
.LBB1_47:                               # %sw.bb91
	end_block                       # label31:
	i64.const	$push19=, 46
	i64.shr_s	$0=, $0, $pop19
	br      	17              # 17: down to label13
.LBB1_48:                               # %sw.bb93
	end_block                       # label30:
	i64.const	$push18=, 47
	i64.shr_s	$0=, $0, $pop18
	br      	16              # 16: down to label13
.LBB1_49:                               # %sw.bb95
	end_block                       # label29:
	i64.const	$push17=, 48
	i64.shr_s	$0=, $0, $pop17
	br      	15              # 15: down to label13
.LBB1_50:                               # %sw.bb97
	end_block                       # label28:
	i64.const	$push16=, 49
	i64.shr_s	$0=, $0, $pop16
	br      	14              # 14: down to label13
.LBB1_51:                               # %sw.bb99
	end_block                       # label27:
	i64.const	$push15=, 50
	i64.shr_s	$0=, $0, $pop15
	br      	13              # 13: down to label13
.LBB1_52:                               # %sw.bb101
	end_block                       # label26:
	i64.const	$push14=, 51
	i64.shr_s	$0=, $0, $pop14
	br      	12              # 12: down to label13
.LBB1_53:                               # %sw.bb103
	end_block                       # label25:
	i64.const	$push13=, 52
	i64.shr_s	$0=, $0, $pop13
	br      	11              # 11: down to label13
.LBB1_54:                               # %sw.bb105
	end_block                       # label24:
	i64.const	$push12=, 53
	i64.shr_s	$0=, $0, $pop12
	br      	10              # 10: down to label13
.LBB1_55:                               # %sw.bb107
	end_block                       # label23:
	i64.const	$push11=, 54
	i64.shr_s	$0=, $0, $pop11
	br      	9               # 9: down to label13
.LBB1_56:                               # %sw.bb109
	end_block                       # label22:
	i64.const	$push10=, 55
	i64.shr_s	$0=, $0, $pop10
	br      	8               # 8: down to label13
.LBB1_57:                               # %sw.bb111
	end_block                       # label21:
	i64.const	$push9=, 56
	i64.shr_s	$0=, $0, $pop9
	br      	7               # 7: down to label13
.LBB1_58:                               # %sw.bb113
	end_block                       # label20:
	i64.const	$push8=, 57
	i64.shr_s	$0=, $0, $pop8
	br      	6               # 6: down to label13
.LBB1_59:                               # %sw.bb115
	end_block                       # label19:
	i64.const	$push7=, 58
	i64.shr_s	$0=, $0, $pop7
	br      	5               # 5: down to label13
.LBB1_60:                               # %sw.bb117
	end_block                       # label18:
	i64.const	$push6=, 59
	i64.shr_s	$0=, $0, $pop6
	br      	4               # 4: down to label13
.LBB1_61:                               # %sw.bb119
	end_block                       # label17:
	i64.const	$push5=, 60
	i64.shr_s	$0=, $0, $pop5
	br      	3               # 3: down to label13
.LBB1_62:                               # %sw.bb121
	end_block                       # label16:
	i64.const	$push4=, 61
	i64.shr_s	$0=, $0, $pop4
	br      	2               # 2: down to label13
.LBB1_63:                               # %sw.bb123
	end_block                       # label15:
	i64.const	$push3=, 62
	i64.shr_s	$0=, $0, $pop3
	br      	1               # 1: down to label13
.LBB1_64:                               # %sw.bb125
	end_block                       # label14:
	i64.const	$push2=, 63
	i64.shr_s	$0=, $0, $pop2
.LBB1_65:                               # %sw.epilog
	end_block                       # label13:
	return  	$0
.LBB1_66:                               # %sw.default
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	constant_shift, .Lfunc_end1-constant_shift

	.type	zext,@object            # @zext
	.section	.rodata.zext,"a",@progbits
	.p2align	4
zext:
	.int64	8526495107234113920     # 0x7654321fedcba980
	.int64	4263247553617056960     # 0x3b2a190ff6e5d4c0
	.int64	2131623776808528480     # 0x1d950c87fb72ea60
	.int64	1065811888404264240     # 0xeca8643fdb97530
	.int64	532905944202132120      # 0x7654321fedcba98
	.int64	266452972101066060      # 0x3b2a190ff6e5d4c
	.int64	133226486050533030      # 0x1d950c87fb72ea6
	.int64	66613243025266515       # 0xeca8643fdb9753
	.int64	33306621512633257       # 0x7654321fedcba9
	.int64	16653310756316628       # 0x3b2a190ff6e5d4
	.int64	8326655378158314        # 0x1d950c87fb72ea
	.int64	4163327689079157        # 0xeca8643fdb975
	.int64	2081663844539578        # 0x7654321fedcba
	.int64	1040831922269789        # 0x3b2a190ff6e5d
	.int64	520415961134894         # 0x1d950c87fb72e
	.int64	260207980567447         # 0xeca8643fdb97
	.int64	130103990283723         # 0x7654321fedcb
	.int64	65051995141861          # 0x3b2a190ff6e5
	.int64	32525997570930          # 0x1d950c87fb72
	.int64	16262998785465          # 0xeca8643fdb9
	.int64	8131499392732           # 0x7654321fedc
	.int64	4065749696366           # 0x3b2a190ff6e
	.int64	2032874848183           # 0x1d950c87fb7
	.int64	1016437424091           # 0xeca8643fdb
	.int64	508218712045            # 0x7654321fed
	.int64	254109356022            # 0x3b2a190ff6
	.int64	127054678011            # 0x1d950c87fb
	.int64	63527339005             # 0xeca8643fd
	.int64	31763669502             # 0x7654321fe
	.int64	15881834751             # 0x3b2a190ff
	.int64	7940917375              # 0x1d950c87f
	.int64	3970458687              # 0xeca8643f
	.int64	1985229343              # 0x7654321f
	.int64	992614671               # 0x3b2a190f
	.int64	496307335               # 0x1d950c87
	.int64	248153667               # 0xeca8643
	.int64	124076833               # 0x7654321
	.int64	62038416                # 0x3b2a190
	.int64	31019208                # 0x1d950c8
	.int64	15509604                # 0xeca864
	.int64	7754802                 # 0x765432
	.int64	3877401                 # 0x3b2a19
	.int64	1938700                 # 0x1d950c
	.int64	969350                  # 0xeca86
	.int64	484675                  # 0x76543
	.int64	242337                  # 0x3b2a1
	.int64	121168                  # 0x1d950
	.int64	60584                   # 0xeca8
	.int64	30292                   # 0x7654
	.int64	15146                   # 0x3b2a
	.int64	7573                    # 0x1d95
	.int64	3786                    # 0xeca
	.int64	1893                    # 0x765
	.int64	946                     # 0x3b2
	.int64	473                     # 0x1d9
	.int64	236                     # 0xec
	.int64	118                     # 0x76
	.int64	59                      # 0x3b
	.int64	29                      # 0x1d
	.int64	14                      # 0xe
	.int64	7                       # 0x7
	.int64	3                       # 0x3
	.int64	1                       # 0x1
	.int64	0                       # 0x0
	.size	zext, 512

	.type	sext,@object            # @sext
	.section	.rodata.sext,"a",@progbits
	.p2align	4
sext:
	.int64	-8152436031399644656    # 0x8edcba9f76543210
	.int64	-4076218015699822328    # 0xc76e5d4fbb2a1908
	.int64	-2038109007849911164    # 0xe3b72ea7dd950c84
	.int64	-1019054503924955582    # 0xf1db9753eeca8642
	.int64	-509527251962477791     # 0xf8edcba9f7654321
	.int64	-254763625981238896     # 0xfc76e5d4fbb2a190
	.int64	-127381812990619448     # 0xfe3b72ea7dd950c8
	.int64	-63690906495309724      # 0xff1db9753eeca864
	.int64	-31845453247654862      # 0xff8edcba9f765432
	.int64	-15922726623827431      # 0xffc76e5d4fbb2a19
	.int64	-7961363311913716       # 0xffe3b72ea7dd950c
	.int64	-3980681655956858       # 0xfff1db9753eeca86
	.int64	-1990340827978429       # 0xfff8edcba9f76543
	.int64	-995170413989215        # 0xfffc76e5d4fbb2a1
	.int64	-497585206994608        # 0xfffe3b72ea7dd950
	.int64	-248792603497304        # 0xffff1db9753eeca8
	.int64	-124396301748652        # 0xffff8edcba9f7654
	.int64	-62198150874326         # 0xffffc76e5d4fbb2a
	.int64	-31099075437163         # 0xffffe3b72ea7dd95
	.int64	-15549537718582         # 0xfffff1db9753eeca
	.int64	-7774768859291          # 0xfffff8edcba9f765
	.int64	-3887384429646          # 0xfffffc76e5d4fbb2
	.int64	-1943692214823          # 0xfffffe3b72ea7dd9
	.int64	-971846107412           # 0xffffff1db9753eec
	.int64	-485923053706           # 0xffffff8edcba9f76
	.int64	-242961526853           # 0xffffffc76e5d4fbb
	.int64	-121480763427           # 0xffffffe3b72ea7dd
	.int64	-60740381714            # 0xfffffff1db9753ee
	.int64	-30370190857            # 0xfffffff8edcba9f7
	.int64	-15185095429            # 0xfffffffc76e5d4fb
	.int64	-7592547715             # 0xfffffffe3b72ea7d
	.int64	-3796273858             # 0xffffffff1db9753e
	.int64	-1898136929             # 0xffffffff8edcba9f
	.int64	-949068465              # 0xffffffffc76e5d4f
	.int64	-474534233              # 0xffffffffe3b72ea7
	.int64	-237267117              # 0xfffffffff1db9753
	.int64	-118633559              # 0xfffffffff8edcba9
	.int64	-59316780               # 0xfffffffffc76e5d4
	.int64	-29658390               # 0xfffffffffe3b72ea
	.int64	-14829195               # 0xffffffffff1db975
	.int64	-7414598                # 0xffffffffff8edcba
	.int64	-3707299                # 0xffffffffffc76e5d
	.int64	-1853650                # 0xffffffffffe3b72e
	.int64	-926825                 # 0xfffffffffff1db97
	.int64	-463413                 # 0xfffffffffff8edcb
	.int64	-231707                 # 0xfffffffffffc76e5
	.int64	-115854                 # 0xfffffffffffe3b72
	.int64	-57927                  # 0xffffffffffff1db9
	.int64	-28964                  # 0xffffffffffff8edc
	.int64	-14482                  # 0xffffffffffffc76e
	.int64	-7241                   # 0xffffffffffffe3b7
	.int64	-3621                   # 0xfffffffffffff1db
	.int64	-1811                   # 0xfffffffffffff8ed
	.int64	-906                    # 0xfffffffffffffc76
	.int64	-453                    # 0xfffffffffffffe3b
	.int64	-227                    # 0xffffffffffffff1d
	.int64	-114                    # 0xffffffffffffff8e
	.int64	-57                     # 0xffffffffffffffc7
	.int64	-29                     # 0xffffffffffffffe3
	.int64	-15                     # 0xfffffffffffffff1
	.int64	-8                      # 0xfffffffffffffff8
	.int64	-4                      # 0xfffffffffffffffc
	.int64	-2                      # 0xfffffffffffffffe
	.int64	-1                      # 0xffffffffffffffff
	.size	sext, 512


	.ident	"clang version 3.9.0 "
