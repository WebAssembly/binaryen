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
	i32.const	$push134=, __stack_pointer
	i32.load	$push135=, 0($pop134)
	i32.const	$push136=, 16
	i32.sub 	$10=, $pop135, $pop136
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
	i32.const	$push68=, 3
	i32.and 	$push0=, $0, $pop68
	i32.const	$push177=, 0
	i32.eq  	$push178=, $pop0, $pop177
	br_if   	0, $pop178      # 0: down to label13
# BB#1:                                 # %if.else
	i32.const	$push5=, -4
	i32.and 	$4=, $0, $pop5
	i32.const	$push4=, 32
	i32.const	$push105=, 3
	i32.shl 	$push2=, $0, $pop105
	i32.const	$push3=, 24
	i32.and 	$push104=, $pop2, $pop3
	tee_local	$push103=, $8=, $pop104
	i32.sub 	$3=, $pop4, $pop103
	i32.const	$push102=, 3
	i32.and 	$push101=, $2, $pop102
	tee_local	$push100=, $0=, $pop101
	i32.const	$push179=, 0
	i32.eq  	$push180=, $pop100, $pop179
	br_if   	1, $pop180      # 1: down to label12
# BB#2:                                 # %if.else
	i32.const	$push6=, 1
	i32.eq  	$push7=, $0, $pop6
	br_if   	2, $pop7        # 2: down to label11
# BB#3:                                 # %if.else
	i32.const	$push8=, 3
	i32.ne  	$push9=, $0, $pop8
	br_if   	3, $pop9        # 3: down to label10
# BB#4:                                 # %sw.bb6.i
	i32.load	$6=, 0($4)
	i32.const	$push15=, 1
	i32.add 	$2=, $2, $pop15
	i32.const	$push14=, -4
	i32.add 	$0=, $1, $pop14
	br      	8               # 8: down to label5
.LBB0_5:                                # %if.then
	end_block                       # label13:
	i32.const	$push71=, 3
	i32.and 	$push70=, $2, $pop71
	tee_local	$push69=, $4=, $pop70
	i32.const	$push181=, 0
	i32.eq  	$push182=, $pop69, $pop181
	br_if   	10, $pop182     # 10: down to label2
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
	copy_local	$8=, $1
	i32.const	$push73=, -4
	i32.add 	$1=, $1, $pop73
	i32.const	$push51=, 1
	i32.add 	$2=, $2, $pop51
	br      	11              # 11: down to label1
.LBB0_9:                                # %sw.bb12.i18
	end_block                       # label12:
	i32.load	$7=, 0($4)
	i32.const	$push13=, 4
	i32.add 	$4=, $4, $pop13
	copy_local	$0=, $1
	br      	5               # 5: down to label6
.LBB0_10:                               # %sw.bb17.i
	end_block                       # label11:
	i32.load	$6=, 0($4)
	i32.load	$7=, 4($4)
	i32.const	$push10=, 8
	i32.add 	$4=, $4, $pop10
	i32.load	$5=, 0($1)
	i32.const	$push11=, 4
	i32.add 	$0=, $1, $pop11
	i32.const	$push12=, -1
	i32.add 	$2=, $2, $pop12
	br      	3               # 3: down to label7
.LBB0_11:                               # %sw.bb.i16
	end_block                       # label10:
	i32.const	$push16=, 4
	i32.add 	$6=, $4, $pop16
	i32.load	$7=, 0($4)
	i32.const	$push17=, -4
	i32.add 	$4=, $4, $pop17
	i32.const	$push19=, 2
	i32.add 	$2=, $2, $pop19
	i32.const	$push18=, -8
	i32.add 	$0=, $1, $pop18
	br      	5               # 5: down to label4
.LBB0_12:                               # %sw.bb12.i
	end_block                       # label9:
	i32.load	$4=, 0($0)
	i32.const	$push48=, 4
	i32.add 	$0=, $0, $pop48
	i32.load	$8=, 0($1)
	i32.const	$push74=, 4
	i32.add 	$1=, $1, $pop74
	i32.const	$push49=, -1
	i32.add 	$2=, $2, $pop49
	br      	5               # 5: down to label3
.LBB0_13:                               # %sw.bb.i
	end_block                       # label8:
	copy_local	$4=, $0
	i32.const	$push52=, -8
	i32.add 	$0=, $0, $pop52
	copy_local	$8=, $1
	i32.const	$push72=, -8
	i32.add 	$1=, $1, $pop72
	i32.const	$push53=, 2
	i32.add 	$2=, $2, $pop53
# BB#14:
	i32.const	$9=, 32
	br      	7               # 7: down to label0
.LBB0_15:
	end_block                       # label7:
	i32.const	$9=, 0
	br      	6               # 6: down to label0
.LBB0_16:
	end_block                       # label6:
	i32.const	$9=, 5
	br      	5               # 5: down to label0
.LBB0_17:
	end_block                       # label5:
	i32.const	$9=, 9
	br      	4               # 4: down to label0
.LBB0_18:
	end_block                       # label4:
	i32.const	$9=, 13
	br      	3               # 3: down to label0
.LBB0_19:
	end_block                       # label3:
	i32.const	$9=, 21
	br      	2               # 2: down to label0
.LBB0_20:
	end_block                       # label2:
	i32.const	$9=, 24
	br      	1               # 1: down to label0
.LBB0_21:
	end_block                       # label1:
	i32.const	$9=, 28
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
	br_table 	$9, 22, 29, 30, 35, 36, 23, 31, 32, 24, 25, 33, 34, 26, 19, 27, 28, 20, 21, 37, 38, 39, 3, 10, 11, 4, 12, 13, 5, 6, 14, 15, 7, 0, 8, 9, 1, 2, 16, 17, 18, 18 # 22: down to label66
                                        # 29: down to label59
                                        # 30: down to label58
                                        # 35: down to label53
                                        # 36: down to label52
                                        # 23: down to label65
                                        # 31: down to label57
                                        # 32: down to label56
                                        # 24: down to label64
                                        # 25: down to label63
                                        # 33: down to label55
                                        # 34: down to label54
                                        # 26: down to label62
                                        # 19: down to label69
                                        # 27: down to label61
                                        # 28: down to label60
                                        # 20: down to label68
                                        # 21: down to label67
                                        # 37: down to label51
                                        # 38: down to label50
                                        # 39: down to label49
                                        # 3: down to label85
                                        # 10: down to label78
                                        # 11: down to label77
                                        # 4: down to label84
                                        # 12: down to label76
                                        # 13: down to label75
                                        # 5: down to label83
                                        # 6: down to label82
                                        # 14: down to label74
                                        # 15: down to label73
                                        # 7: down to label81
                                        # 0: down to label88
                                        # 8: down to label80
                                        # 9: down to label79
                                        # 1: down to label87
                                        # 2: down to label86
                                        # 16: down to label72
                                        # 17: down to label71
                                        # 18: down to label70
.LBB0_23:                               # %do1.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label88:
	i32.load	$push94=, 0($4)
	tee_local	$push93=, $4=, $pop94
	i32.load	$push92=, 0($8)
	tee_local	$push91=, $8=, $pop92
	i32.ne  	$push54=, $pop93, $pop91
	br_if   	70, $pop54      # 70: down to label17
# BB#24:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 35
	br      	72              # 72: up to label14
.LBB0_25:                               # %if.end37.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label87:
	i32.load	$4=, 12($0)
	i32.load	$8=, 12($1)
	i32.const	$push57=, -4
	i32.add 	$2=, $2, $pop57
	i32.const	$push183=, 0
	i32.eq  	$push184=, $2, $pop183
	br_if   	70, $pop184     # 70: down to label16
# BB#26:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 36
	br      	71              # 71: up to label14
.LBB0_27:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label86:
	i32.const	$push56=, 16
	i32.add 	$0=, $0, $pop56
	i32.const	$push97=, 16
	i32.add 	$1=, $1, $pop97
# BB#28:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 21
	br      	70              # 70: up to label14
.LBB0_29:                               # %do.body.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label85:
	i32.ne  	$push58=, $4, $8
	br_if   	36, $pop58      # 36: down to label48
# BB#30:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 24
	br      	69              # 69: up to label14
.LBB0_31:                               # %do3.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label84:
	i32.load	$push80=, 0($0)
	tee_local	$push79=, $4=, $pop80
	i32.load	$push78=, 0($1)
	tee_local	$push77=, $8=, $pop78
	i32.ne  	$push61=, $pop79, $pop77
	br_if   	63, $pop61      # 63: down to label20
# BB#32:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 27
	br      	68              # 68: up to label14
.LBB0_33:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label83:
	i32.const	$push60=, 4
	i32.add 	$4=, $0, $pop60
	i32.const	$push81=, 4
	i32.add 	$8=, $1, $pop81
# BB#34:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 28
	br      	67              # 67: up to label14
.LBB0_35:                               # %do2.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label82:
	i32.load	$push87=, 0($4)
	tee_local	$push86=, $4=, $pop87
	i32.load	$push85=, 0($8)
	tee_local	$push84=, $8=, $pop85
	i32.ne  	$push64=, $pop86, $pop84
	br_if   	62, $pop64      # 62: down to label19
# BB#36:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 31
	br      	66              # 66: up to label14
.LBB0_37:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label81:
	i32.const	$push63=, 8
	i32.add 	$4=, $0, $pop63
	i32.const	$push88=, 8
	i32.add 	$8=, $1, $pop88
	br      	62              # 62: down to label18
.LBB0_38:                               # %if.then35.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label80:
	i32.store	$discard=, 12($10), $4
	i32.store	$discard=, 8($10), $8
	i32.const	$push145=, 12
	i32.add 	$push146=, $10, $pop145
	copy_local	$0=, $pop146
	i32.const	$push147=, 8
	i32.add 	$push148=, $10, $pop147
	copy_local	$2=, $pop148
# BB#39:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 34
	br      	64              # 64: up to label14
.LBB0_40:                               # %do.body.i116.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label79:
	i32.load8_u	$1=, 0($0)
	i32.load8_u	$4=, 0($2)
	i32.const	$push96=, 1
	i32.add 	$0=, $0, $pop96
	i32.const	$push95=, 1
	i32.add 	$2=, $2, $pop95
	i32.eq  	$push55=, $1, $4
	br_if   	42, $pop55      # 42: down to label36
	br      	43              # 43: down to label35
.LBB0_41:                               # %if.then.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label78:
	i32.store	$discard=, 12($10), $4
	i32.store	$discard=, 8($10), $8
	i32.const	$push141=, 12
	i32.add 	$push142=, $10, $pop141
	copy_local	$0=, $pop142
	i32.const	$push143=, 8
	i32.add 	$push144=, $10, $pop143
	copy_local	$2=, $pop144
# BB#42:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 23
	br      	62              # 62: up to label14
.LBB0_43:                               # %do.body.i.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label77:
	i32.load8_u	$1=, 0($0)
	i32.load8_u	$4=, 0($2)
	i32.const	$push76=, 1
	i32.add 	$0=, $0, $pop76
	i32.const	$push75=, 1
	i32.add 	$2=, $2, $pop75
	i32.eq  	$push59=, $1, $4
	br_if   	34, $pop59      # 34: down to label42
	br      	35              # 35: down to label41
.LBB0_44:                               # %if.then23.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label76:
	i32.store	$discard=, 12($10), $4
	i32.store	$discard=, 8($10), $8
	i32.const	$push153=, 12
	i32.add 	$push154=, $10, $pop153
	copy_local	$0=, $pop154
	i32.const	$push155=, 8
	i32.add 	$push156=, $10, $pop155
	copy_local	$2=, $pop156
# BB#45:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 26
	br      	60              # 60: up to label14
.LBB0_46:                               # %do.body.i140.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label75:
	i32.load8_u	$1=, 0($0)
	i32.load8_u	$4=, 0($2)
	i32.const	$push83=, 1
	i32.add 	$0=, $0, $pop83
	i32.const	$push82=, 1
	i32.add 	$2=, $2, $pop82
	i32.eq  	$push62=, $1, $4
	br_if   	34, $pop62      # 34: down to label40
	br      	35              # 35: down to label39
.LBB0_47:                               # %if.then29.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label74:
	i32.store	$discard=, 12($10), $4
	i32.store	$discard=, 8($10), $8
	i32.const	$push149=, 12
	i32.add 	$push150=, $10, $pop149
	copy_local	$0=, $pop150
	i32.const	$push151=, 8
	i32.add 	$push152=, $10, $pop151
	copy_local	$2=, $pop152
# BB#48:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 30
	br      	58              # 58: up to label14
.LBB0_49:                               # %do.body.i128.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label73:
	i32.load8_u	$1=, 0($0)
	i32.load8_u	$4=, 0($2)
	i32.const	$push90=, 1
	i32.add 	$0=, $0, $pop90
	i32.const	$push89=, 1
	i32.add 	$2=, $2, $pop89
	i32.eq  	$push65=, $1, $4
	br_if   	34, $pop65      # 34: down to label38
	br      	35              # 35: down to label37
.LBB0_50:                               # %do0.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label72:
	i32.const	$0=, 0
	i32.eq  	$push66=, $4, $8
	br_if   	45, $pop66      # 45: down to label26
# BB#51:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 38
	br      	56              # 56: up to label14
.LBB0_52:                               # %if.then43.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label71:
	i32.store	$discard=, 12($10), $4
	i32.store	$discard=, 8($10), $8
	i32.const	$push137=, 12
	i32.add 	$push138=, $10, $pop137
	copy_local	$0=, $pop138
	i32.const	$push139=, 8
	i32.add 	$push140=, $10, $pop139
	copy_local	$2=, $pop140
# BB#53:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 39
	br      	55              # 55: up to label14
.LBB0_54:                               # %do.body.i104.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label70:
	i32.load8_u	$1=, 0($0)
	i32.load8_u	$4=, 0($2)
	i32.const	$push99=, 1
	i32.add 	$0=, $0, $pop99
	i32.const	$push98=, 1
	i32.add 	$2=, $2, $pop98
	i32.eq  	$push67=, $1, $4
	br_if   	35, $pop67      # 35: down to label34
	br      	36              # 36: down to label33
.LBB0_55:                               # %do1.i56
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label69:
	i32.load	$6=, 0($6)
	i32.shl 	$push21=, $6, $3
	i32.shr_u	$push20=, $7, $8
	i32.or  	$push126=, $pop21, $pop20
	tee_local	$push125=, $7=, $pop126
	i32.load	$push124=, 0($1)
	tee_local	$push123=, $1=, $pop124
	i32.ne  	$push22=, $pop125, $pop123
	br_if   	46, $pop22      # 46: down to label22
# BB#56:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 16
	br      	53              # 53: up to label14
.LBB0_57:                               # %if.end54.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label68:
	i32.load	$7=, 12($4)
	i32.load	$5=, 12($0)
	i32.const	$push25=, -4
	i32.add 	$2=, $2, $pop25
	i32.const	$push185=, 0
	i32.eq  	$push186=, $2, $pop185
	br_if   	46, $pop186     # 46: down to label21
# BB#58:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 17
	br      	52              # 52: up to label14
.LBB0_59:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label67:
	i32.const	$push24=, 16
	i32.add 	$4=, $4, $pop24
	i32.const	$push129=, 16
	i32.add 	$0=, $0, $pop129
# BB#60:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 0
	br      	51              # 51: up to label14
.LBB0_61:                               # %do.body.i23
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label66:
	i32.shl 	$push27=, $7, $3
	i32.shr_u	$push26=, $6, $8
	i32.or  	$push107=, $pop27, $pop26
	tee_local	$push106=, $1=, $pop107
	i32.ne  	$push28=, $pop106, $5
	br_if   	18, $pop28      # 18: down to label47
# BB#62:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 5
	br      	50              # 50: up to label14
.LBB0_63:                               # %do3.i42
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label65:
	i32.load	$6=, 0($4)
	i32.shl 	$push32=, $6, $3
	i32.shr_u	$push31=, $7, $8
	i32.or  	$push113=, $pop32, $pop31
	tee_local	$push112=, $1=, $pop113
	i32.load	$push111=, 0($0)
	tee_local	$push110=, $7=, $pop111
	i32.ne  	$push33=, $pop112, $pop110
	br_if   	39, $pop33      # 39: down to label25
# BB#64:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 8
	br      	49              # 49: up to label14
.LBB0_65:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label64:
	i32.const	$push30=, 4
	i32.add 	$1=, $0, $pop30
# BB#66:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 9
	br      	48              # 48: up to label14
.LBB0_67:                               # %do2.i50
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label63:
	i32.load	$7=, 4($4)
	i32.shl 	$push37=, $7, $3
	i32.shr_u	$push36=, $6, $8
	i32.or  	$push119=, $pop37, $pop36
	tee_local	$push118=, $6=, $pop119
	i32.load	$push117=, 0($1)
	tee_local	$push116=, $1=, $pop117
	i32.ne  	$push38=, $pop118, $pop116
	br_if   	38, $pop38      # 38: down to label24
# BB#68:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 12
	br      	47              # 47: up to label14
.LBB0_69:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label62:
	i32.const	$push35=, 8
	i32.add 	$6=, $4, $pop35
	i32.const	$push120=, 8
	i32.add 	$1=, $0, $pop120
	br      	38              # 38: down to label23
.LBB0_70:                               # %if.then52.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label61:
	i32.store	$discard=, 12($10), $7
	i32.store	$discard=, 8($10), $1
	i32.const	$push165=, 12
	i32.add 	$push166=, $10, $pop165
	copy_local	$0=, $pop166
	i32.const	$push167=, 8
	i32.add 	$push168=, $10, $pop167
	copy_local	$2=, $pop168
# BB#71:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 15
	br      	45              # 45: up to label14
.LBB0_72:                               # %do.body.i170.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label60:
	i32.load8_u	$1=, 0($0)
	i32.load8_u	$4=, 0($2)
	i32.const	$push128=, 1
	i32.add 	$0=, $0, $pop128
	i32.const	$push127=, 1
	i32.add 	$2=, $2, $pop127
	i32.eq  	$push23=, $1, $4
	br_if   	30, $pop23      # 30: down to label29
	br      	31              # 31: down to label28
.LBB0_73:                               # %if.then.i24
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label59:
	i32.store	$discard=, 12($10), $1
	i32.store	$discard=, 8($10), $5
	i32.const	$push161=, 12
	i32.add 	$push162=, $10, $pop161
	copy_local	$0=, $pop162
	i32.const	$push163=, 8
	i32.add 	$push164=, $10, $pop163
	copy_local	$2=, $pop164
# BB#74:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 2
	br      	43              # 43: up to label14
.LBB0_75:                               # %do.body.i.i30
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label58:
	i32.load8_u	$1=, 0($0)
	i32.load8_u	$4=, 0($2)
	i32.const	$push109=, 1
	i32.add 	$0=, $0, $pop109
	i32.const	$push108=, 1
	i32.add 	$2=, $2, $pop108
	i32.eq  	$push29=, $1, $4
	br_if   	11, $pop29      # 11: down to label46
	br      	12              # 12: down to label45
.LBB0_76:                               # %if.then34.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label57:
	i32.store	$discard=, 12($10), $1
	i32.store	$discard=, 8($10), $7
	i32.const	$push173=, 12
	i32.add 	$push174=, $10, $pop173
	copy_local	$0=, $pop174
	i32.const	$push175=, 8
	i32.add 	$push176=, $10, $pop175
	copy_local	$2=, $pop176
# BB#77:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 7
	br      	41              # 41: up to label14
.LBB0_78:                               # %do.body.i194.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label56:
	i32.load8_u	$1=, 0($0)
	i32.load8_u	$4=, 0($2)
	i32.const	$push115=, 1
	i32.add 	$0=, $0, $pop115
	i32.const	$push114=, 1
	i32.add 	$2=, $2, $pop114
	i32.eq  	$push34=, $1, $4
	br_if   	23, $pop34      # 23: down to label32
	br      	24              # 24: down to label31
.LBB0_79:                               # %if.then43.i51
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label55:
	i32.store	$discard=, 12($10), $6
	i32.store	$discard=, 8($10), $1
	i32.const	$push169=, 12
	i32.add 	$push170=, $10, $pop169
	copy_local	$0=, $pop170
	i32.const	$push171=, 8
	i32.add 	$push172=, $10, $pop171
	copy_local	$2=, $pop172
# BB#80:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 11
	br      	39              # 39: up to label14
.LBB0_81:                               # %do.body.i182.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label54:
	i32.load8_u	$1=, 0($0)
	i32.load8_u	$4=, 0($2)
	i32.const	$push122=, 1
	i32.add 	$0=, $0, $pop122
	i32.const	$push121=, 1
	i32.add 	$2=, $2, $pop121
	i32.eq  	$push39=, $1, $4
	br_if   	23, $pop39      # 23: down to label30
# BB#82:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 3
	br      	38              # 38: up to label14
.LBB0_83:                               # %mymemcmp1.exit162.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label53:
	i32.sub 	$0=, $1, $4
# BB#84:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 4
	br      	37              # 37: up to label14
.LBB0_85:                               # %cleanup
	end_block                       # label52:
	return  	$0
.LBB0_86:                               # %do0.i57
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label51:
	i32.const	$0=, 0
	i32.shl 	$push41=, $7, $3
	i32.shr_u	$push40=, $6, $8
	i32.or  	$push131=, $pop41, $pop40
	tee_local	$push130=, $2=, $pop131
	i32.eq  	$push42=, $pop130, $5
	br_if   	23, $pop42      # 23: down to label27
# BB#87:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 19
	br      	35              # 35: up to label14
.LBB0_88:                               # %if.then63.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label50:
	i32.store	$discard=, 12($10), $2
	i32.store	$discard=, 8($10), $5
	i32.const	$push157=, 12
	i32.add 	$push158=, $10, $pop157
	copy_local	$0=, $pop158
	i32.const	$push159=, 8
	i32.add 	$push160=, $10, $pop159
	copy_local	$2=, $pop160
# BB#89:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$9=, 20
	br      	34              # 34: up to label14
.LBB0_90:                               # %do.body.i158.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label49:
	i32.load8_u	$1=, 0($0)
	i32.load8_u	$4=, 0($2)
	i32.const	$push133=, 1
	i32.add 	$0=, $0, $pop133
	i32.const	$push132=, 1
	i32.add 	$2=, $2, $pop132
	i32.eq  	$push43=, $1, $4
	br_if   	4, $pop43       # 4: down to label44
	br      	5               # 5: down to label43
.LBB0_91:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label48:
	i32.const	$9=, 22
	br      	32              # 32: up to label14
.LBB0_92:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label47:
	i32.const	$9=, 1
	br      	31              # 31: up to label14
.LBB0_93:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label46:
	i32.const	$9=, 2
	br      	30              # 30: up to label14
.LBB0_94:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label45:
	i32.const	$9=, 3
	br      	29              # 29: up to label14
.LBB0_95:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label44:
	i32.const	$9=, 20
	br      	28              # 28: up to label14
.LBB0_96:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label43:
	i32.const	$9=, 3
	br      	27              # 27: up to label14
.LBB0_97:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label42:
	i32.const	$9=, 23
	br      	26              # 26: up to label14
.LBB0_98:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label41:
	i32.const	$9=, 3
	br      	25              # 25: up to label14
.LBB0_99:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label40:
	i32.const	$9=, 26
	br      	24              # 24: up to label14
.LBB0_100:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label39:
	i32.const	$9=, 3
	br      	23              # 23: up to label14
.LBB0_101:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label38:
	i32.const	$9=, 30
	br      	22              # 22: up to label14
.LBB0_102:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label37:
	i32.const	$9=, 3
	br      	21              # 21: up to label14
.LBB0_103:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label36:
	i32.const	$9=, 34
	br      	20              # 20: up to label14
.LBB0_104:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label35:
	i32.const	$9=, 3
	br      	19              # 19: up to label14
.LBB0_105:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label34:
	i32.const	$9=, 39
	br      	18              # 18: up to label14
.LBB0_106:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label33:
	i32.const	$9=, 3
	br      	17              # 17: up to label14
.LBB0_107:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label32:
	i32.const	$9=, 7
	br      	16              # 16: up to label14
.LBB0_108:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label31:
	i32.const	$9=, 3
	br      	15              # 15: up to label14
.LBB0_109:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label30:
	i32.const	$9=, 11
	br      	14              # 14: up to label14
.LBB0_110:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label29:
	i32.const	$9=, 15
	br      	13              # 13: up to label14
.LBB0_111:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label28:
	i32.const	$9=, 3
	br      	12              # 12: up to label14
.LBB0_112:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label27:
	i32.const	$9=, 4
	br      	11              # 11: up to label14
.LBB0_113:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label26:
	i32.const	$9=, 4
	br      	10              # 10: up to label14
.LBB0_114:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label25:
	i32.const	$9=, 6
	br      	9               # 9: up to label14
.LBB0_115:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label24:
	i32.const	$9=, 10
	br      	8               # 8: up to label14
.LBB0_116:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label23:
	i32.const	$9=, 13
	br      	7               # 7: up to label14
.LBB0_117:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label22:
	i32.const	$9=, 14
	br      	6               # 6: up to label14
.LBB0_118:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label21:
	i32.const	$9=, 18
	br      	5               # 5: up to label14
.LBB0_119:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label20:
	i32.const	$9=, 25
	br      	4               # 4: up to label14
.LBB0_120:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label19:
	i32.const	$9=, 29
	br      	3               # 3: up to label14
.LBB0_121:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label18:
	i32.const	$9=, 32
	br      	2               # 2: up to label14
.LBB0_122:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label17:
	i32.const	$9=, 33
	br      	1               # 1: up to label14
.LBB0_123:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label16:
	i32.const	$9=, 37
	br      	0               # 0: up to label14
.LBB0_124:
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
