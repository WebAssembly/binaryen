	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr38051.c"
	.section	.text.mymemcmp,"ax",@progbits
	.hidden	mymemcmp
	.globl	mymemcmp
	.type	mymemcmp,@function
mymemcmp:                               # @mymemcmp
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push77=, __stack_pointer
	i32.load	$push78=, 0($pop77)
	i32.const	$push79=, 16
	i32.sub 	$8=, $pop78, $pop79
	i32.const	$push1=, 2
	i32.shr_u	$2=, $2, $pop1
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
	i32.const	$push120=, 3
	i32.and 	$push0=, $0, $pop120
	i32.eqz 	$push192=, $pop0
	br_if   	0, $pop192      # 0: down to label13
# BB#1:                                 # %if.else
	i32.const	$push5=, -4
	i32.and 	$4=, $0, $pop5
	i32.const	$push4=, 32
	i32.const	$push126=, 3
	i32.shl 	$push2=, $0, $pop126
	i32.const	$push3=, 24
	i32.and 	$push125=, $pop2, $pop3
	tee_local	$push124=, $0=, $pop125
	i32.sub 	$3=, $pop4, $pop124
	i32.const	$push123=, 3
	i32.and 	$push122=, $2, $pop123
	tee_local	$push121=, $7=, $pop122
	i32.eqz 	$push193=, $pop121
	br_if   	1, $pop193      # 1: down to label12
# BB#2:                                 # %if.else
	i32.const	$push6=, 1
	i32.eq  	$push7=, $7, $pop6
	br_if   	2, $pop7        # 2: down to label11
# BB#3:                                 # %if.else
	i32.const	$push8=, 3
	i32.ne  	$push9=, $7, $pop8
	br_if   	3, $pop9        # 3: down to label10
# BB#4:                                 # %sw.bb6.i
	i32.load	$9=, 0($4)
	i32.const	$push15=, 1
	i32.add 	$2=, $2, $pop15
	i32.const	$push14=, -4
	i32.add 	$7=, $1, $pop14
	br      	8               # 8: down to label5
.LBB0_5:                                # %if.then
	end_block                       # label13:
	i32.const	$push129=, 3
	i32.and 	$push128=, $2, $pop129
	tee_local	$push127=, $4=, $pop128
	i32.eqz 	$push194=, $pop127
	br_if   	10, $pop194     # 10: down to label2
# BB#6:                                 # %if.then
	i32.const	$push44=, 1
	i32.eq  	$push45=, $4, $pop44
	br_if   	3, $pop45       # 3: down to label9
# BB#7:                                 # %if.then
	i32.const	$push46=, 3
	i32.ne  	$push47=, $4, $pop46
	br_if   	4, $pop47       # 4: down to label8
# BB#8:                                 # %sw.bb3.i
	copy_local	$4=, $0
	i32.const	$push50=, -4
	i32.add 	$0=, $0, $pop50
	copy_local	$3=, $1
	i32.const	$push130=, -4
	i32.add 	$1=, $1, $pop130
	i32.const	$push51=, 1
	i32.add 	$2=, $2, $pop51
	br      	11              # 11: down to label1
.LBB0_9:                                # %sw.bb12.i18
	end_block                       # label12:
	i32.load	$6=, 0($4)
	i32.const	$push13=, 4
	i32.add 	$4=, $4, $pop13
	copy_local	$7=, $1
	br      	5               # 5: down to label6
.LBB0_10:                               # %sw.bb17.i
	end_block                       # label11:
	i32.load	$9=, 0($4)
	i32.load	$6=, 4($4)
	i32.const	$push10=, 8
	i32.add 	$4=, $4, $pop10
	i32.load	$5=, 0($1)
	i32.const	$push11=, 4
	i32.add 	$7=, $1, $pop11
	i32.const	$push12=, -1
	i32.add 	$2=, $2, $pop12
	br      	3               # 3: down to label7
.LBB0_11:                               # %sw.bb.i16
	end_block                       # label10:
	i32.const	$push16=, 4
	i32.add 	$9=, $4, $pop16
	i32.load	$6=, 0($4)
	i32.const	$push17=, -4
	i32.add 	$4=, $4, $pop17
	i32.const	$push19=, 2
	i32.add 	$2=, $2, $pop19
	i32.const	$push18=, -8
	i32.add 	$7=, $1, $pop18
	br      	5               # 5: down to label4
.LBB0_12:                               # %sw.bb12.i
	end_block                       # label9:
	i32.load	$4=, 0($0)
	i32.const	$push48=, 4
	i32.add 	$0=, $0, $pop48
	i32.load	$3=, 0($1)
	i32.const	$push131=, 4
	i32.add 	$1=, $1, $pop131
	i32.const	$push49=, -1
	i32.add 	$2=, $2, $pop49
	br      	5               # 5: down to label3
.LBB0_13:                               # %sw.bb.i
	end_block                       # label8:
	copy_local	$4=, $0
	i32.const	$push52=, -8
	i32.add 	$0=, $0, $pop52
	copy_local	$3=, $1
	i32.const	$push132=, -8
	i32.add 	$1=, $1, $pop132
	i32.const	$push53=, 2
	i32.add 	$2=, $2, $pop53
# BB#14:
	i32.const	$10=, 39
	br      	7               # 7: down to label0
.LBB0_15:
	end_block                       # label7:
	i32.const	$10=, 0
	br      	6               # 6: down to label0
.LBB0_16:
	end_block                       # label6:
	i32.const	$10=, 4
	br      	5               # 5: down to label0
.LBB0_17:
	end_block                       # label5:
	i32.const	$10=, 9
	br      	4               # 4: down to label0
.LBB0_18:
	end_block                       # label4:
	i32.const	$10=, 14
	br      	3               # 3: down to label0
.LBB0_19:
	end_block                       # label3:
	i32.const	$10=, 25
	br      	2               # 2: down to label0
.LBB0_20:
	end_block                       # label2:
	i32.const	$10=, 29
	br      	1               # 1: down to label0
.LBB0_21:
	end_block                       # label1:
	i32.const	$10=, 34
.LBB0_22:                               # =>This Inner Loop Header: Depth=1
	end_block                       # label0:
	loop                            # label14:
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
	block
	block
	block
	block
	block
	block
	block
	block
	block
	br_table 	$10, 27, 35, 36, 37, 28, 38, 39, 40, 29, 30, 41, 42, 43, 31, 24, 32, 33, 34, 25, 26, 44, 45, 46, 47, 48, 3, 11, 12, 13, 4, 14, 15, 16, 5, 6, 17, 18, 19, 7, 0, 8, 9, 10, 1, 2, 20, 21, 22, 23, 23 # 27: down to label61
                                        # 35: down to label53
                                        # 36: down to label52
                                        # 37: down to label51
                                        # 28: down to label60
                                        # 38: down to label50
                                        # 39: down to label49
                                        # 40: down to label48
                                        # 29: down to label59
                                        # 30: down to label58
                                        # 41: down to label47
                                        # 42: down to label46
                                        # 43: down to label45
                                        # 31: down to label57
                                        # 24: down to label64
                                        # 32: down to label56
                                        # 33: down to label55
                                        # 34: down to label54
                                        # 25: down to label63
                                        # 26: down to label62
                                        # 44: down to label44
                                        # 45: down to label43
                                        # 46: down to label42
                                        # 47: down to label41
                                        # 48: down to label40
                                        # 3: down to label85
                                        # 11: down to label77
                                        # 12: down to label76
                                        # 13: down to label75
                                        # 4: down to label84
                                        # 14: down to label74
                                        # 15: down to label73
                                        # 16: down to label72
                                        # 5: down to label83
                                        # 6: down to label82
                                        # 17: down to label71
                                        # 18: down to label70
                                        # 19: down to label69
                                        # 7: down to label81
                                        # 0: down to label88
                                        # 8: down to label80
                                        # 9: down to label79
                                        # 10: down to label78
                                        # 1: down to label87
                                        # 2: down to label86
                                        # 20: down to label68
                                        # 21: down to label67
                                        # 22: down to label66
                                        # 23: down to label65
.LBB0_23:                               # %do1.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label88:
	i32.load	$push136=, 0($4)
	tee_local	$push135=, $4=, $pop136
	i32.load	$push134=, 0($3)
	tee_local	$push133=, $3=, $pop134
	i32.ne  	$push54=, $pop135, $pop133
	br_if   	68, $pop54      # 68: down to label19
# BB#24:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 43
	br      	72              # 72: up to label14
.LBB0_25:                               # %if.end37.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label87:
	i32.load	$4=, 12($0)
	i32.load	$3=, 12($1)
	i32.const	$push57=, -4
	i32.add 	$2=, $2, $pop57
	i32.eqz 	$push195=, $2
	br_if   	69, $pop195     # 69: down to label17
# BB#26:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 44
	br      	71              # 71: up to label14
.LBB0_27:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label86:
	i32.const	$push56=, 16
	i32.add 	$0=, $0, $pop56
	i32.const	$push137=, 16
	i32.add 	$1=, $1, $pop137
# BB#28:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 25
	br      	70              # 70: up to label14
.LBB0_29:                               # %do.body.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label85:
	i32.ne  	$push58=, $4, $3
	br_if   	45, $pop58      # 45: down to label39
# BB#30:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 29
	br      	69              # 69: up to label14
.LBB0_31:                               # %do3.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label84:
	i32.load	$push141=, 0($0)
	tee_local	$push140=, $4=, $pop141
	i32.load	$push139=, 0($1)
	tee_local	$push138=, $3=, $pop139
	i32.ne  	$push61=, $pop140, $pop138
	br_if   	59, $pop61      # 59: down to label24
# BB#32:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 33
	br      	68              # 68: up to label14
.LBB0_33:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label83:
	i32.const	$push60=, 4
	i32.add 	$4=, $0, $pop60
	i32.const	$push142=, 4
	i32.add 	$3=, $1, $pop142
# BB#34:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 34
	br      	67              # 67: up to label14
.LBB0_35:                               # %do2.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label82:
	i32.load	$push146=, 0($4)
	tee_local	$push145=, $4=, $pop146
	i32.load	$push144=, 0($3)
	tee_local	$push143=, $3=, $pop144
	i32.ne  	$push64=, $pop145, $pop143
	br_if   	59, $pop64      # 59: down to label22
# BB#36:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 38
	br      	66              # 66: up to label14
.LBB0_37:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label81:
	i32.const	$push63=, 8
	i32.add 	$4=, $0, $pop63
	i32.const	$push147=, 8
	i32.add 	$3=, $1, $pop147
	br      	60              # 60: down to label20
.LBB0_38:                               # %if.then35.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label80:
	i32.store	$discard=, 12($8), $4
	i32.store	$discard=, 8($8), $3
	i32.const	$push88=, 12
	i32.add 	$push89=, $8, $pop88
	copy_local	$0=, $pop89
	i32.const	$push90=, 8
	i32.add 	$push91=, $8, $pop90
	copy_local	$8=, $pop91
# BB#39:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 41
	br      	64              # 64: up to label14
.LBB0_40:                               # %do.body.i116.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label79:
	i32.load8_u	$2=, 0($0)
	i32.load8_u	$1=, 0($8)
	i32.const	$push149=, 1
	i32.add 	$0=, $0, $pop149
	i32.const	$push148=, 1
	i32.add 	$8=, $8, $pop148
	i32.eq  	$push55=, $2, $1
	br_if   	60, $pop55      # 60: down to label18
# BB#41:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 42
	br      	63              # 63: up to label14
.LBB0_42:                               # %mymemcmp1.exit120.i
	end_block                       # label78:
	i32.sub 	$push73=, $2, $1
	return  	$pop73
.LBB0_43:                               # %if.then.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label77:
	i32.store	$discard=, 12($8), $4
	i32.store	$discard=, 8($8), $3
	i32.const	$push84=, 12
	i32.add 	$push85=, $8, $pop84
	copy_local	$0=, $pop85
	i32.const	$push86=, 8
	i32.add 	$push87=, $8, $pop86
	copy_local	$8=, $pop87
# BB#44:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 27
	br      	61              # 61: up to label14
.LBB0_45:                               # %do.body.i.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label76:
	i32.load8_u	$2=, 0($0)
	i32.load8_u	$1=, 0($8)
	i32.const	$push151=, 1
	i32.add 	$0=, $0, $pop151
	i32.const	$push150=, 1
	i32.add 	$8=, $8, $pop150
	i32.eq  	$push59=, $2, $1
	br_if   	50, $pop59      # 50: down to label25
# BB#46:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 28
	br      	60              # 60: up to label14
.LBB0_47:                               # %mymemcmp1.exit.i
	end_block                       # label75:
	i32.sub 	$push76=, $2, $1
	return  	$pop76
.LBB0_48:                               # %if.then23.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label74:
	i32.store	$discard=, 12($8), $4
	i32.store	$discard=, 8($8), $3
	i32.const	$push96=, 12
	i32.add 	$push97=, $8, $pop96
	copy_local	$0=, $pop97
	i32.const	$push98=, 8
	i32.add 	$push99=, $8, $pop98
	copy_local	$8=, $pop99
# BB#49:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 31
	br      	58              # 58: up to label14
.LBB0_50:                               # %do.body.i140.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label73:
	i32.load8_u	$2=, 0($0)
	i32.load8_u	$1=, 0($8)
	i32.const	$push153=, 1
	i32.add 	$0=, $0, $pop153
	i32.const	$push152=, 1
	i32.add 	$8=, $8, $pop152
	i32.eq  	$push62=, $2, $1
	br_if   	49, $pop62      # 49: down to label23
# BB#51:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 32
	br      	57              # 57: up to label14
.LBB0_52:                               # %mymemcmp1.exit144.i
	end_block                       # label72:
	i32.sub 	$push75=, $2, $1
	return  	$pop75
.LBB0_53:                               # %if.then29.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label71:
	i32.store	$discard=, 12($8), $4
	i32.store	$discard=, 8($8), $3
	i32.const	$push92=, 12
	i32.add 	$push93=, $8, $pop92
	copy_local	$0=, $pop93
	i32.const	$push94=, 8
	i32.add 	$push95=, $8, $pop94
	copy_local	$8=, $pop95
# BB#54:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 36
	br      	55              # 55: up to label14
.LBB0_55:                               # %do.body.i128.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label70:
	i32.load8_u	$2=, 0($0)
	i32.load8_u	$1=, 0($8)
	i32.const	$push155=, 1
	i32.add 	$0=, $0, $pop155
	i32.const	$push154=, 1
	i32.add 	$8=, $8, $pop154
	i32.eq  	$push65=, $2, $1
	br_if   	48, $pop65      # 48: down to label21
# BB#56:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 37
	br      	54              # 54: up to label14
.LBB0_57:                               # %mymemcmp1.exit132.i
	end_block                       # label69:
	i32.sub 	$push74=, $2, $1
	return  	$pop74
.LBB0_58:                               # %do0.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label68:
	i32.const	$2=, 0
	i32.eq  	$push66=, $4, $3
	br_if   	41, $pop66      # 41: down to label26
# BB#59:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 46
	br      	52              # 52: up to label14
.LBB0_60:                               # %if.then43.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label67:
	i32.store	$discard=, 12($8), $4
	i32.store	$discard=, 8($8), $3
	i32.const	$push80=, 12
	i32.add 	$push81=, $8, $pop80
	copy_local	$0=, $pop81
	i32.const	$push82=, 8
	i32.add 	$push83=, $8, $pop82
	copy_local	$8=, $pop83
# BB#61:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 47
	br      	51              # 51: up to label14
.LBB0_62:                               # %do.body.i104.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label66:
	i32.load8_u	$2=, 0($0)
	i32.load8_u	$1=, 0($8)
	i32.const	$push157=, 1
	i32.add 	$0=, $0, $pop157
	i32.const	$push156=, 1
	i32.add 	$8=, $8, $pop156
	i32.eq  	$push67=, $2, $1
	br_if   	49, $pop67      # 49: down to label16
# BB#63:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 48
	br      	50              # 50: up to label14
.LBB0_64:                               # %mymemcmp1.exit108.i
	end_block                       # label65:
	i32.sub 	$push72=, $2, $1
	return  	$pop72
.LBB0_65:                               # %do1.i56
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label64:
	i32.load	$push163=, 0($9)
	tee_local	$push162=, $9=, $pop163
	i32.shl 	$push21=, $pop162, $3
	i32.shr_u	$push20=, $6, $0
	i32.or  	$push161=, $pop21, $pop20
	tee_local	$push160=, $6=, $pop161
	i32.load	$push159=, 0($1)
	tee_local	$push158=, $1=, $pop159
	i32.ne  	$push22=, $pop160, $pop158
	br_if   	32, $pop22      # 32: down to label31
# BB#66:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 18
	br      	48              # 48: up to label14
.LBB0_67:                               # %if.end54.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label63:
	i32.load	$6=, 12($4)
	i32.load	$5=, 12($7)
	i32.const	$push25=, -4
	i32.add 	$2=, $2, $pop25
	i32.eqz 	$push196=, $2
	br_if   	33, $pop196     # 33: down to label29
# BB#68:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 19
	br      	47              # 47: up to label14
.LBB0_69:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label62:
	i32.const	$push24=, 16
	i32.add 	$4=, $4, $pop24
	i32.const	$push164=, 16
	i32.add 	$7=, $7, $pop164
# BB#70:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 0
	br      	46              # 46: up to label14
.LBB0_71:                               # %do.body.i23
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label61:
	i32.shl 	$push27=, $6, $3
	i32.shr_u	$push26=, $9, $0
	i32.or  	$push166=, $pop27, $pop26
	tee_local	$push165=, $1=, $pop166
	i32.ne  	$push28=, $pop165, $5
	br_if   	22, $pop28      # 22: down to label38
# BB#72:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 4
	br      	45              # 45: up to label14
.LBB0_73:                               # %do3.i42
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label60:
	i32.load	$push172=, 0($4)
	tee_local	$push171=, $9=, $pop172
	i32.shl 	$push32=, $pop171, $3
	i32.shr_u	$push31=, $6, $0
	i32.or  	$push170=, $pop32, $pop31
	tee_local	$push169=, $1=, $pop170
	i32.load	$push168=, 0($7)
	tee_local	$push167=, $6=, $pop168
	i32.ne  	$push33=, $pop169, $pop167
	br_if   	23, $pop33      # 23: down to label36
# BB#74:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 8
	br      	44              # 44: up to label14
.LBB0_75:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label59:
	i32.const	$push30=, 4
	i32.add 	$1=, $7, $pop30
# BB#76:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 9
	br      	43              # 43: up to label14
.LBB0_77:                               # %do2.i50
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label58:
	i32.load	$push178=, 4($4)
	tee_local	$push177=, $6=, $pop178
	i32.shl 	$push37=, $pop177, $3
	i32.shr_u	$push36=, $9, $0
	i32.or  	$push176=, $pop37, $pop36
	tee_local	$push175=, $9=, $pop176
	i32.load	$push174=, 0($1)
	tee_local	$push173=, $1=, $pop174
	i32.ne  	$push38=, $pop175, $pop173
	br_if   	23, $pop38      # 23: down to label34
# BB#78:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 13
	br      	42              # 42: up to label14
.LBB0_79:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label57:
	i32.const	$push35=, 8
	i32.add 	$9=, $4, $pop35
	i32.const	$push179=, 8
	i32.add 	$1=, $7, $pop179
	br      	24              # 24: down to label32
.LBB0_80:                               # %if.then52.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label56:
	i32.store	$discard=, 12($8), $6
	i32.store	$discard=, 8($8), $1
	i32.const	$push108=, 12
	i32.add 	$push109=, $8, $pop108
	copy_local	$0=, $pop109
	i32.const	$push110=, 8
	i32.add 	$push111=, $8, $pop110
	copy_local	$8=, $pop111
# BB#81:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 16
	br      	40              # 40: up to label14
.LBB0_82:                               # %do.body.i170.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label55:
	i32.load8_u	$2=, 0($0)
	i32.load8_u	$1=, 0($8)
	i32.const	$push181=, 1
	i32.add 	$0=, $0, $pop181
	i32.const	$push180=, 1
	i32.add 	$8=, $8, $pop180
	i32.eq  	$push23=, $2, $1
	br_if   	24, $pop23      # 24: down to label30
# BB#83:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 17
	br      	39              # 39: up to label14
.LBB0_84:                               # %mymemcmp1.exit174.i
	end_block                       # label54:
	i32.sub 	$push68=, $2, $1
	return  	$pop68
.LBB0_85:                               # %if.then.i24
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label53:
	i32.store	$discard=, 12($8), $1
	i32.store	$discard=, 8($8), $5
	i32.const	$push104=, 12
	i32.add 	$push105=, $8, $pop104
	copy_local	$0=, $pop105
	i32.const	$push106=, 8
	i32.add 	$push107=, $8, $pop106
	copy_local	$8=, $pop107
# BB#86:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 2
	br      	37              # 37: up to label14
.LBB0_87:                               # %do.body.i.i30
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label52:
	i32.load8_u	$2=, 0($0)
	i32.load8_u	$1=, 0($8)
	i32.const	$push183=, 1
	i32.add 	$0=, $0, $pop183
	i32.const	$push182=, 1
	i32.add 	$8=, $8, $pop182
	i32.eq  	$push29=, $2, $1
	br_if   	14, $pop29      # 14: down to label37
# BB#88:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 3
	br      	36              # 36: up to label14
.LBB0_89:                               # %mymemcmp1.exit.i34
	end_block                       # label51:
	i32.sub 	$push71=, $2, $1
	return  	$pop71
.LBB0_90:                               # %if.then34.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label50:
	i32.store	$discard=, 12($8), $1
	i32.store	$discard=, 8($8), $6
	i32.const	$push116=, 12
	i32.add 	$push117=, $8, $pop116
	copy_local	$0=, $pop117
	i32.const	$push118=, 8
	i32.add 	$push119=, $8, $pop118
	copy_local	$8=, $pop119
# BB#91:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 6
	br      	34              # 34: up to label14
.LBB0_92:                               # %do.body.i194.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label49:
	i32.load8_u	$2=, 0($0)
	i32.load8_u	$1=, 0($8)
	i32.const	$push185=, 1
	i32.add 	$0=, $0, $pop185
	i32.const	$push184=, 1
	i32.add 	$8=, $8, $pop184
	i32.eq  	$push34=, $2, $1
	br_if   	13, $pop34      # 13: down to label35
# BB#93:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 7
	br      	33              # 33: up to label14
.LBB0_94:                               # %mymemcmp1.exit198.i
	end_block                       # label48:
	i32.sub 	$push70=, $2, $1
	return  	$pop70
.LBB0_95:                               # %if.then43.i51
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label47:
	i32.store	$discard=, 12($8), $9
	i32.store	$discard=, 8($8), $1
	i32.const	$push112=, 12
	i32.add 	$push113=, $8, $pop112
	copy_local	$0=, $pop113
	i32.const	$push114=, 8
	i32.add 	$push115=, $8, $pop114
	copy_local	$8=, $pop115
# BB#96:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 11
	br      	31              # 31: up to label14
.LBB0_97:                               # %do.body.i182.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label46:
	i32.load8_u	$2=, 0($0)
	i32.load8_u	$1=, 0($8)
	i32.const	$push187=, 1
	i32.add 	$0=, $0, $pop187
	i32.const	$push186=, 1
	i32.add 	$8=, $8, $pop186
	i32.eq  	$push39=, $2, $1
	br_if   	12, $pop39      # 12: down to label33
# BB#98:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 12
	br      	30              # 30: up to label14
.LBB0_99:                               # %mymemcmp1.exit186.i
	end_block                       # label45:
	i32.sub 	$push69=, $2, $1
	return  	$pop69
.LBB0_100:                              # %do0.i57
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label44:
	i32.const	$2=, 0
	i32.shl 	$push41=, $6, $3
	i32.shr_u	$push40=, $9, $0
	i32.or  	$push189=, $pop41, $pop40
	tee_local	$push188=, $0=, $pop189
	i32.eq  	$push42=, $pop188, $5
	br_if   	15, $pop42      # 15: down to label28
# BB#101:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 21
	br      	28              # 28: up to label14
.LBB0_102:                              # %if.then63.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label43:
	i32.store	$discard=, 12($8), $0
	i32.store	$discard=, 8($8), $5
	i32.const	$push100=, 12
	i32.add 	$push101=, $8, $pop100
	copy_local	$0=, $pop101
	i32.const	$push102=, 8
	i32.add 	$push103=, $8, $pop102
	copy_local	$8=, $pop103
# BB#103:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 22
	br      	27              # 27: up to label14
.LBB0_104:                              # %do.body.i158.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label42:
	i32.load8_u	$2=, 0($0)
	i32.load8_u	$1=, 0($8)
	i32.const	$push191=, 1
	i32.add 	$0=, $0, $pop191
	i32.const	$push190=, 1
	i32.add 	$8=, $8, $pop190
	i32.eq  	$push43=, $2, $1
	br_if   	14, $pop43      # 14: down to label27
# BB#105:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 23
	br      	26              # 26: up to label14
.LBB0_106:                              # %mymemcmp1.exit162.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label41:
	i32.sub 	$2=, $2, $1
# BB#107:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$10=, 24
	br      	25              # 25: up to label14
.LBB0_108:                              # %cleanup
	end_block                       # label40:
	return  	$2
.LBB0_109:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label39:
	i32.const	$10=, 26
	br      	23              # 23: up to label14
.LBB0_110:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label38:
	i32.const	$10=, 1
	br      	22              # 22: up to label14
.LBB0_111:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label37:
	i32.const	$10=, 2
	br      	21              # 21: up to label14
.LBB0_112:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label36:
	i32.const	$10=, 5
	br      	20              # 20: up to label14
.LBB0_113:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label35:
	i32.const	$10=, 6
	br      	19              # 19: up to label14
.LBB0_114:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label34:
	i32.const	$10=, 10
	br      	18              # 18: up to label14
.LBB0_115:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label33:
	i32.const	$10=, 11
	br      	17              # 17: up to label14
.LBB0_116:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label32:
	i32.const	$10=, 14
	br      	16              # 16: up to label14
.LBB0_117:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label31:
	i32.const	$10=, 15
	br      	15              # 15: up to label14
.LBB0_118:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label30:
	i32.const	$10=, 16
	br      	14              # 14: up to label14
.LBB0_119:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label29:
	i32.const	$10=, 20
	br      	13              # 13: up to label14
.LBB0_120:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label28:
	i32.const	$10=, 24
	br      	12              # 12: up to label14
.LBB0_121:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label27:
	i32.const	$10=, 22
	br      	11              # 11: up to label14
.LBB0_122:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label26:
	i32.const	$10=, 24
	br      	10              # 10: up to label14
.LBB0_123:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label25:
	i32.const	$10=, 27
	br      	9               # 9: up to label14
.LBB0_124:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label24:
	i32.const	$10=, 30
	br      	8               # 8: up to label14
.LBB0_125:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label23:
	i32.const	$10=, 31
	br      	7               # 7: up to label14
.LBB0_126:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label22:
	i32.const	$10=, 35
	br      	6               # 6: up to label14
.LBB0_127:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label21:
	i32.const	$10=, 36
	br      	5               # 5: up to label14
.LBB0_128:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label20:
	i32.const	$10=, 39
	br      	4               # 4: up to label14
.LBB0_129:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label19:
	i32.const	$10=, 40
	br      	3               # 3: up to label14
.LBB0_130:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label18:
	i32.const	$10=, 41
	br      	2               # 2: up to label14
.LBB0_131:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label17:
	i32.const	$10=, 45
	br      	1               # 1: up to label14
.LBB0_132:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label16:
	i32.const	$10=, 47
	br      	0               # 0: up to label14
.LBB0_133:
	end_loop                        # label15:
	.endfunc
.Lfunc_end0:
	.size	mymemcmp, .Lfunc_end0-mymemcmp

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push29=, 0
	i32.const	$push28=, 0
	i32.load8_u	$push0=, .L.str+14($pop28)
	i32.store8	$discard=, buf+39($pop29), $pop0
	i32.const	$push27=, 0
	i32.const	$push26=, 0
	i32.load16_u	$push1=, .L.str+12($pop26):p2align=0
	i32.store16	$discard=, buf+37($pop27):p2align=0, $pop1
	i32.const	$push25=, 0
	i32.const	$push24=, 0
	i32.load	$push2=, .L.str+8($pop24):p2align=0
	i32.store	$discard=, buf+33($pop25):p2align=0, $pop2
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i32.load8_u	$push4=, .L.str.1+14($pop22)
	i32.store8	$discard=, buf+182($pop23), $pop4
	i32.const	$push21=, 0
	i32.const	$push20=, 0
	i32.load16_u	$push5=, .L.str.1+12($pop20):p2align=0
	i32.store16	$discard=, buf+180($pop21), $pop5
	i32.const	$push19=, 0
	i32.const	$push18=, 0
	i32.load	$push6=, .L.str.1+8($pop18):p2align=0
	i32.store	$discard=, buf+176($pop19), $pop6
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i64.load	$push3=, .L.str($pop16):p2align=0
	i64.store	$discard=, buf+25($pop17):p2align=0, $pop3
	i32.const	$push15=, 0
	i32.const	$push14=, 0
	i64.load	$push7=, .L.str.1($pop14):p2align=0
	i64.store	$discard=, buf+168($pop15), $pop7
	block
	i32.const	$push10=, buf+25
	i32.const	$push9=, buf+168
	i32.const	$push8=, 33
	i32.call	$push11=, mymemcmp@FUNCTION, $pop10, $pop9, $pop8
	i32.const	$push12=, -51
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label89
# BB#1:                                 # %cleanup
	i32.const	$push30=, 0
	return  	$pop30
.LBB1_2:                                # %if.then26
	end_block                       # label89:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
	.p2align	4
buf:
	.skip	256
	.size	buf, 256

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"\0017\202\247UI\235\277\370D\266U\027\216\371"
	.size	.L.str, 16

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"\0017\202\247UI\320\363\267*m#qIj"
	.size	.L.str.1, 16


	.ident	"clang version 3.9.0 "
