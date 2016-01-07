	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/ashrdi-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64, i32, i64, i64, i32, i32, i64, i32, i32, i32, i32
# BB#0:                                 # %entry
	i64.const	$4=, 0
	i32.const	$10=, zext
.LBB0_1:                                  # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	.LBB0_13
	loop    	.LBB0_3
	i64.const	$0=, 8526495107234113920
	i64.shr_u	$push0=, $0, $4
	i64.load	$push1=, 0($10)
	i64.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, .LBB0_13
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=.LBB0_1 Depth=1
	i64.const	$1=, 1
	i64.add 	$4=, $4, $1
	i32.const	$2=, 8
	i32.add 	$10=, $10, $2
	i64.const	$7=, 0
	i64.const	$3=, 63
	i32.const	$11=, sext
	i64.le_s	$push3=, $4, $3
	br_if   	$pop3, .LBB0_1
.LBB0_3:                                  # %for.body4
                                        # =>This Inner Loop Header: Depth=1
	block   	.LBB0_12
	loop    	.LBB0_5
	i64.const	$4=, -8152436031399644656
	i64.shr_s	$push4=, $4, $7
	i64.load	$push5=, 0($11)
	i64.ne  	$push6=, $pop4, $pop5
	br_if   	$pop6, .LBB0_12
# BB#4:                                 # %for.cond2
                                        #   in Loop: Header=.LBB0_3 Depth=1
	i64.add 	$7=, $7, $1
	i32.add 	$11=, $11, $2
	i32.const	$9=, 0
	i32.const	$8=, zext
	i64.le_s	$push7=, $7, $3
	br_if   	$pop7, .LBB0_3
.LBB0_5:                                  # %for.body16
                                        # =>This Inner Loop Header: Depth=1
	block   	.LBB0_11
	loop    	.LBB0_7
	i64.call	$push8=, constant_shift, $0, $9
	i64.load	$push9=, 0($8)
	i64.ne  	$push10=, $pop8, $pop9
	br_if   	$pop10, .LBB0_11
# BB#6:                                 # %for.cond14
                                        #   in Loop: Header=.LBB0_5 Depth=1
	i32.const	$5=, 1
	i32.add 	$9=, $9, $5
	i32.add 	$8=, $8, $2
	i32.const	$11=, 0
	i32.const	$10=, sext
	i32.const	$6=, 63
	i32.le_s	$push11=, $9, $6
	br_if   	$pop11, .LBB0_5
.LBB0_7:                                  # %for.body28
                                        # =>This Inner Loop Header: Depth=1
	block   	.LBB0_10
	loop    	.LBB0_9
	i64.call	$push12=, constant_shift, $4, $11
	i64.load	$push13=, 0($10)
	i64.ne  	$push14=, $pop12, $pop13
	br_if   	$pop14, .LBB0_10
# BB#8:                                 # %for.cond26
                                        #   in Loop: Header=.LBB0_7 Depth=1
	i32.add 	$11=, $11, $5
	i32.add 	$10=, $10, $2
	i32.le_s	$push15=, $11, $6
	br_if   	$pop15, .LBB0_7
.LBB0_9:                                  # %for.end37
	i32.const	$push16=, 0
	call    	exit, $pop16
	unreachable
.LBB0_10:                                 # %if.then33
	call    	abort
	unreachable
.LBB0_11:                                 # %if.then21
	call    	abort
	unreachable
.LBB0_12:                                 # %if.then9
	call    	abort
	unreachable
.LBB0_13:                                 # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	constant_shift,@function
constant_shift:                         # @constant_shift
	.param  	i64, i32
	.result 	i64
# BB#0:                                 # %entry
	block   	.LBB1_66
	i32.const	$push0=, 63
	i32.gt_u	$push1=, $1, $pop0
	br_if   	$pop1, .LBB1_66
# BB#1:                                 # %entry
	block   	.LBB1_65
	block   	.LBB1_64
	block   	.LBB1_63
	block   	.LBB1_62
	block   	.LBB1_61
	block   	.LBB1_60
	block   	.LBB1_59
	block   	.LBB1_58
	block   	.LBB1_57
	block   	.LBB1_56
	block   	.LBB1_55
	block   	.LBB1_54
	block   	.LBB1_53
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
	block   	.LBB1_34
	block   	.LBB1_33
	block   	.LBB1_32
	block   	.LBB1_31
	block   	.LBB1_30
	block   	.LBB1_29
	block   	.LBB1_28
	block   	.LBB1_27
	block   	.LBB1_26
	block   	.LBB1_25
	block   	.LBB1_24
	block   	.LBB1_23
	block   	.LBB1_22
	block   	.LBB1_21
	block   	.LBB1_20
	block   	.LBB1_19
	block   	.LBB1_18
	block   	.LBB1_17
	block   	.LBB1_16
	block   	.LBB1_15
	block   	.LBB1_14
	block   	.LBB1_13
	block   	.LBB1_12
	block   	.LBB1_11
	block   	.LBB1_10
	block   	.LBB1_9
	block   	.LBB1_8
	block   	.LBB1_7
	block   	.LBB1_6
	block   	.LBB1_5
	block   	.LBB1_4
	block   	.LBB1_3
	block   	.LBB1_2
	tableswitch	$1, .LBB1_65, .LBB1_65, .LBB1_2, .LBB1_3, .LBB1_4, .LBB1_5, .LBB1_6, .LBB1_7, .LBB1_8, .LBB1_9, .LBB1_10, .LBB1_11, .LBB1_12, .LBB1_13, .LBB1_14, .LBB1_15, .LBB1_16, .LBB1_17, .LBB1_18, .LBB1_19, .LBB1_20, .LBB1_21, .LBB1_22, .LBB1_23, .LBB1_24, .LBB1_25, .LBB1_26, .LBB1_27, .LBB1_28, .LBB1_29, .LBB1_30, .LBB1_31, .LBB1_32, .LBB1_33, .LBB1_34, .LBB1_35, .LBB1_36, .LBB1_37, .LBB1_38, .LBB1_39, .LBB1_40, .LBB1_41, .LBB1_42, .LBB1_43, .LBB1_44, .LBB1_45, .LBB1_46, .LBB1_47, .LBB1_48, .LBB1_49, .LBB1_50, .LBB1_51, .LBB1_52, .LBB1_53, .LBB1_54, .LBB1_55, .LBB1_56, .LBB1_57, .LBB1_58, .LBB1_59, .LBB1_60, .LBB1_61, .LBB1_62, .LBB1_63, .LBB1_64
.LBB1_2:                                  # %sw.bb1
	i64.const	$push64=, 1
	i64.shr_s	$0=, $0, $pop64
	br      	.LBB1_65
.LBB1_3:                                  # %sw.bb3
	i64.const	$push63=, 2
	i64.shr_s	$0=, $0, $pop63
	br      	.LBB1_65
.LBB1_4:                                  # %sw.bb5
	i64.const	$push62=, 3
	i64.shr_s	$0=, $0, $pop62
	br      	.LBB1_65
.LBB1_5:                                  # %sw.bb7
	i64.const	$push61=, 4
	i64.shr_s	$0=, $0, $pop61
	br      	.LBB1_65
.LBB1_6:                                  # %sw.bb9
	i64.const	$push60=, 5
	i64.shr_s	$0=, $0, $pop60
	br      	.LBB1_65
.LBB1_7:                                  # %sw.bb11
	i64.const	$push59=, 6
	i64.shr_s	$0=, $0, $pop59
	br      	.LBB1_65
.LBB1_8:                                  # %sw.bb13
	i64.const	$push58=, 7
	i64.shr_s	$0=, $0, $pop58
	br      	.LBB1_65
.LBB1_9:                                  # %sw.bb15
	i64.const	$push57=, 8
	i64.shr_s	$0=, $0, $pop57
	br      	.LBB1_65
.LBB1_10:                                 # %sw.bb17
	i64.const	$push56=, 9
	i64.shr_s	$0=, $0, $pop56
	br      	.LBB1_65
.LBB1_11:                                 # %sw.bb19
	i64.const	$push55=, 10
	i64.shr_s	$0=, $0, $pop55
	br      	.LBB1_65
.LBB1_12:                                 # %sw.bb21
	i64.const	$push54=, 11
	i64.shr_s	$0=, $0, $pop54
	br      	.LBB1_65
.LBB1_13:                                 # %sw.bb23
	i64.const	$push53=, 12
	i64.shr_s	$0=, $0, $pop53
	br      	.LBB1_65
.LBB1_14:                                 # %sw.bb25
	i64.const	$push52=, 13
	i64.shr_s	$0=, $0, $pop52
	br      	.LBB1_65
.LBB1_15:                                 # %sw.bb27
	i64.const	$push51=, 14
	i64.shr_s	$0=, $0, $pop51
	br      	.LBB1_65
.LBB1_16:                                 # %sw.bb29
	i64.const	$push50=, 15
	i64.shr_s	$0=, $0, $pop50
	br      	.LBB1_65
.LBB1_17:                                 # %sw.bb31
	i64.const	$push49=, 16
	i64.shr_s	$0=, $0, $pop49
	br      	.LBB1_65
.LBB1_18:                                 # %sw.bb33
	i64.const	$push48=, 17
	i64.shr_s	$0=, $0, $pop48
	br      	.LBB1_65
.LBB1_19:                                 # %sw.bb35
	i64.const	$push47=, 18
	i64.shr_s	$0=, $0, $pop47
	br      	.LBB1_65
.LBB1_20:                                 # %sw.bb37
	i64.const	$push46=, 19
	i64.shr_s	$0=, $0, $pop46
	br      	.LBB1_65
.LBB1_21:                                 # %sw.bb39
	i64.const	$push45=, 20
	i64.shr_s	$0=, $0, $pop45
	br      	.LBB1_65
.LBB1_22:                                 # %sw.bb41
	i64.const	$push44=, 21
	i64.shr_s	$0=, $0, $pop44
	br      	.LBB1_65
.LBB1_23:                                 # %sw.bb43
	i64.const	$push43=, 22
	i64.shr_s	$0=, $0, $pop43
	br      	.LBB1_65
.LBB1_24:                                 # %sw.bb45
	i64.const	$push42=, 23
	i64.shr_s	$0=, $0, $pop42
	br      	.LBB1_65
.LBB1_25:                                 # %sw.bb47
	i64.const	$push41=, 24
	i64.shr_s	$0=, $0, $pop41
	br      	.LBB1_65
.LBB1_26:                                 # %sw.bb49
	i64.const	$push40=, 25
	i64.shr_s	$0=, $0, $pop40
	br      	.LBB1_65
.LBB1_27:                                 # %sw.bb51
	i64.const	$push39=, 26
	i64.shr_s	$0=, $0, $pop39
	br      	.LBB1_65
.LBB1_28:                                 # %sw.bb53
	i64.const	$push38=, 27
	i64.shr_s	$0=, $0, $pop38
	br      	.LBB1_65
.LBB1_29:                                 # %sw.bb55
	i64.const	$push37=, 28
	i64.shr_s	$0=, $0, $pop37
	br      	.LBB1_65
.LBB1_30:                                 # %sw.bb57
	i64.const	$push36=, 29
	i64.shr_s	$0=, $0, $pop36
	br      	.LBB1_65
.LBB1_31:                                 # %sw.bb59
	i64.const	$push35=, 30
	i64.shr_s	$0=, $0, $pop35
	br      	.LBB1_65
.LBB1_32:                                 # %sw.bb61
	i64.const	$push34=, 31
	i64.shr_s	$0=, $0, $pop34
	br      	.LBB1_65
.LBB1_33:                                 # %sw.bb63
	i64.const	$push33=, 32
	i64.shr_s	$0=, $0, $pop33
	br      	.LBB1_65
.LBB1_34:                                 # %sw.bb65
	i64.const	$push32=, 33
	i64.shr_s	$0=, $0, $pop32
	br      	.LBB1_65
.LBB1_35:                                 # %sw.bb67
	i64.const	$push31=, 34
	i64.shr_s	$0=, $0, $pop31
	br      	.LBB1_65
.LBB1_36:                                 # %sw.bb69
	i64.const	$push30=, 35
	i64.shr_s	$0=, $0, $pop30
	br      	.LBB1_65
.LBB1_37:                                 # %sw.bb71
	i64.const	$push29=, 36
	i64.shr_s	$0=, $0, $pop29
	br      	.LBB1_65
.LBB1_38:                                 # %sw.bb73
	i64.const	$push28=, 37
	i64.shr_s	$0=, $0, $pop28
	br      	.LBB1_65
.LBB1_39:                                 # %sw.bb75
	i64.const	$push27=, 38
	i64.shr_s	$0=, $0, $pop27
	br      	.LBB1_65
.LBB1_40:                                 # %sw.bb77
	i64.const	$push26=, 39
	i64.shr_s	$0=, $0, $pop26
	br      	.LBB1_65
.LBB1_41:                                 # %sw.bb79
	i64.const	$push25=, 40
	i64.shr_s	$0=, $0, $pop25
	br      	.LBB1_65
.LBB1_42:                                 # %sw.bb81
	i64.const	$push24=, 41
	i64.shr_s	$0=, $0, $pop24
	br      	.LBB1_65
.LBB1_43:                                 # %sw.bb83
	i64.const	$push23=, 42
	i64.shr_s	$0=, $0, $pop23
	br      	.LBB1_65
.LBB1_44:                                 # %sw.bb85
	i64.const	$push22=, 43
	i64.shr_s	$0=, $0, $pop22
	br      	.LBB1_65
.LBB1_45:                                 # %sw.bb87
	i64.const	$push21=, 44
	i64.shr_s	$0=, $0, $pop21
	br      	.LBB1_65
.LBB1_46:                                 # %sw.bb89
	i64.const	$push20=, 45
	i64.shr_s	$0=, $0, $pop20
	br      	.LBB1_65
.LBB1_47:                                 # %sw.bb91
	i64.const	$push19=, 46
	i64.shr_s	$0=, $0, $pop19
	br      	.LBB1_65
.LBB1_48:                                 # %sw.bb93
	i64.const	$push18=, 47
	i64.shr_s	$0=, $0, $pop18
	br      	.LBB1_65
.LBB1_49:                                 # %sw.bb95
	i64.const	$push17=, 48
	i64.shr_s	$0=, $0, $pop17
	br      	.LBB1_65
.LBB1_50:                                 # %sw.bb97
	i64.const	$push16=, 49
	i64.shr_s	$0=, $0, $pop16
	br      	.LBB1_65
.LBB1_51:                                 # %sw.bb99
	i64.const	$push15=, 50
	i64.shr_s	$0=, $0, $pop15
	br      	.LBB1_65
.LBB1_52:                                 # %sw.bb101
	i64.const	$push14=, 51
	i64.shr_s	$0=, $0, $pop14
	br      	.LBB1_65
.LBB1_53:                                 # %sw.bb103
	i64.const	$push13=, 52
	i64.shr_s	$0=, $0, $pop13
	br      	.LBB1_65
.LBB1_54:                                 # %sw.bb105
	i64.const	$push12=, 53
	i64.shr_s	$0=, $0, $pop12
	br      	.LBB1_65
.LBB1_55:                                 # %sw.bb107
	i64.const	$push11=, 54
	i64.shr_s	$0=, $0, $pop11
	br      	.LBB1_65
.LBB1_56:                                 # %sw.bb109
	i64.const	$push10=, 55
	i64.shr_s	$0=, $0, $pop10
	br      	.LBB1_65
.LBB1_57:                                 # %sw.bb111
	i64.const	$push9=, 56
	i64.shr_s	$0=, $0, $pop9
	br      	.LBB1_65
.LBB1_58:                                 # %sw.bb113
	i64.const	$push8=, 57
	i64.shr_s	$0=, $0, $pop8
	br      	.LBB1_65
.LBB1_59:                                 # %sw.bb115
	i64.const	$push7=, 58
	i64.shr_s	$0=, $0, $pop7
	br      	.LBB1_65
.LBB1_60:                                 # %sw.bb117
	i64.const	$push6=, 59
	i64.shr_s	$0=, $0, $pop6
	br      	.LBB1_65
.LBB1_61:                                 # %sw.bb119
	i64.const	$push5=, 60
	i64.shr_s	$0=, $0, $pop5
	br      	.LBB1_65
.LBB1_62:                                 # %sw.bb121
	i64.const	$push4=, 61
	i64.shr_s	$0=, $0, $pop4
	br      	.LBB1_65
.LBB1_63:                                 # %sw.bb123
	i64.const	$push3=, 62
	i64.shr_s	$0=, $0, $pop3
	br      	.LBB1_65
.LBB1_64:                                 # %sw.bb125
	i64.const	$push2=, 63
	i64.shr_s	$0=, $0, $pop2
.LBB1_65:                                 # %sw.epilog
	return  	$0
.LBB1_66:                                 # %sw.default
	call    	abort
	unreachable
.Lfunc_end1:
	.size	constant_shift, .Lfunc_end1-constant_shift

	.type	zext,@object            # @zext
	.section	.rodata,"a",@progbits
	.align	4
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
	.align	4
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


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
