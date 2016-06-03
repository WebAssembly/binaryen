	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr38051.c"
	.section	.text.mymemcmp,"ax",@progbits
	.hidden	mymemcmp
	.globl	mymemcmp
	.type	mymemcmp,@function
mymemcmp:                               # @mymemcmp
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push103=, 0
	i32.load	$push104=, __stack_pointer($pop103)
	i32.const	$push105=, 16
	i32.sub 	$10=, $pop104, $pop105
	i32.const	$push26=, 2
	i32.shr_u	$2=, $2, $pop26
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
	i32.const	$push146=, 3
	i32.and 	$push27=, $0, $pop146
	i32.eqz 	$push222=, $pop27
	br_if   	0, $pop222      # 0: down to label13
# BB#1:                                 # %if.else
	i32.const	$push28=, -4
	i32.and 	$4=, $0, $pop28
	i32.const	$push31=, 32
	i32.const	$push152=, 3
	i32.shl 	$push29=, $0, $pop152
	i32.const	$push30=, 24
	i32.and 	$push151=, $pop29, $pop30
	tee_local	$push150=, $0=, $pop151
	i32.sub 	$3=, $pop31, $pop150
	i32.const	$push149=, 3
	i32.and 	$push148=, $2, $pop149
	tee_local	$push147=, $5=, $pop148
	i32.eqz 	$push223=, $pop147
	br_if   	1, $pop223      # 1: down to label12
# BB#2:                                 # %if.else
	i32.const	$push32=, 1
	i32.eq  	$push33=, $5, $pop32
	br_if   	2, $pop33       # 2: down to label11
# BB#3:                                 # %if.else
	i32.const	$push34=, 3
	i32.ne  	$push35=, $5, $pop34
	br_if   	3, $pop35       # 3: down to label10
# BB#4:                                 # %sw.bb6.i
	i32.const	$push40=, 1
	i32.add 	$2=, $2, $pop40
	i32.const	$push41=, -4
	i32.add 	$8=, $1, $pop41
	i32.load	$7=, 0($4)
	br      	8               # 8: down to label5
.LBB0_5:                                # %if.then
	end_block                       # label13:
	i32.const	$push155=, 3
	i32.and 	$push154=, $2, $pop155
	tee_local	$push153=, $4=, $pop154
	i32.eqz 	$push224=, $pop153
	br_if   	10, $pop224     # 10: down to label2
# BB#6:                                 # %if.then
	i32.const	$push70=, 1
	i32.eq  	$push71=, $4, $pop70
	br_if   	3, $pop71       # 3: down to label9
# BB#7:                                 # %if.then
	i32.const	$push72=, 3
	i32.ne  	$push73=, $4, $pop72
	br_if   	4, $pop73       # 4: down to label8
# BB#8:                                 # %sw.bb3.i
	i32.const	$push76=, 1
	i32.add 	$2=, $2, $pop76
	i32.const	$push77=, -4
	i32.add 	$4=, $1, $pop77
	i32.const	$push156=, -4
	i32.add 	$3=, $0, $pop156
	br      	11              # 11: down to label1
.LBB0_9:                                # %sw.bb12.i18
	end_block                       # label12:
	i32.const	$push39=, 4
	i32.add 	$6=, $4, $pop39
	i32.load	$5=, 0($4)
	br      	5               # 5: down to label6
.LBB0_10:                               # %sw.bb17.i
	end_block                       # label11:
	i32.const	$push36=, -1
	i32.add 	$2=, $2, $pop36
	i32.const	$push38=, 8
	i32.add 	$6=, $4, $pop38
	i32.load	$7=, 0($1)
	i32.load	$5=, 4($4)
	i32.load	$4=, 0($4)
	i32.const	$push37=, 4
	i32.add 	$push14=, $1, $pop37
	copy_local	$1=, $pop14
	br      	3               # 3: down to label7
.LBB0_11:                               # %sw.bb.i16
	end_block                       # label10:
	i32.const	$push42=, 2
	i32.add 	$2=, $2, $pop42
	i32.const	$push43=, -8
	i32.add 	$8=, $1, $pop43
	i32.const	$push44=, -4
	i32.add 	$9=, $4, $pop44
	i32.const	$push45=, 4
	i32.add 	$6=, $4, $pop45
	i32.load	$5=, 0($4)
	br      	5               # 5: down to label4
.LBB0_12:                               # %sw.bb12.i
	end_block                       # label9:
	i32.const	$push74=, -1
	i32.add 	$2=, $2, $pop74
	i32.load	$5=, 0($1)
	i32.load	$6=, 0($0)
	i32.const	$push75=, 4
	i32.add 	$push0=, $0, $pop75
	copy_local	$0=, $pop0
	i32.const	$push157=, 4
	i32.add 	$push1=, $1, $pop157
	copy_local	$1=, $pop1
	br      	5               # 5: down to label3
.LBB0_13:                               # %sw.bb.i
	end_block                       # label8:
	i32.const	$push78=, 2
	i32.add 	$2=, $2, $pop78
	i32.const	$push79=, -8
	i32.add 	$4=, $1, $pop79
	i32.const	$push158=, -8
	i32.add 	$3=, $0, $pop158
# BB#14:
	i32.const	$11=, 39
	br      	7               # 7: down to label0
.LBB0_15:
	end_block                       # label7:
	i32.const	$11=, 0
	br      	6               # 6: down to label0
.LBB0_16:
	end_block                       # label6:
	i32.const	$11=, 4
	br      	5               # 5: down to label0
.LBB0_17:
	end_block                       # label5:
	i32.const	$11=, 9
	br      	4               # 4: down to label0
.LBB0_18:
	end_block                       # label4:
	i32.const	$11=, 14
	br      	3               # 3: down to label0
.LBB0_19:
	end_block                       # label3:
	i32.const	$11=, 25
	br      	2               # 2: down to label0
.LBB0_20:
	end_block                       # label2:
	i32.const	$11=, 29
	br      	1               # 1: down to label0
.LBB0_21:
	end_block                       # label1:
	i32.const	$11=, 34
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
	br_table 	$11, 27, 35, 36, 37, 28, 38, 39, 40, 29, 30, 41, 42, 43, 31, 24, 32, 33, 34, 25, 26, 44, 45, 46, 47, 48, 3, 11, 12, 13, 4, 14, 15, 16, 5, 6, 17, 18, 19, 7, 0, 8, 9, 10, 1, 2, 20, 21, 22, 23, 23 # 27: down to label61
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
	i32.load	$push162=, 0($0)
	tee_local	$push161=, $0=, $pop162
	i32.load	$push160=, 0($1)
	tee_local	$push159=, $1=, $pop160
	i32.ne  	$push80=, $pop161, $pop159
	br_if   	68, $pop80      # 68: down to label19
# BB#24:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 43
	br      	72              # 72: up to label14
.LBB0_25:                               # %if.end37.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label87:
	i32.load	$5=, 12($4)
	i32.load	$6=, 12($3)
	i32.const	$push82=, -4
	i32.add 	$push164=, $2, $pop82
	tee_local	$push163=, $2=, $pop164
	i32.eqz 	$push225=, $pop163
	br_if   	69, $pop225     # 69: down to label17
# BB#26:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 44
	br      	71              # 71: up to label14
.LBB0_27:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label86:
	i32.const	$push83=, 16
	i32.add 	$1=, $4, $pop83
	i32.const	$push165=, 16
	i32.add 	$0=, $3, $pop165
# BB#28:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 25
	br      	70              # 70: up to label14
.LBB0_29:                               # %do.body.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label85:
	i32.ne  	$push84=, $6, $5
	br_if   	45, $pop84      # 45: down to label39
# BB#30:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 29
	br      	69              # 69: up to label14
.LBB0_31:                               # %do3.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label84:
	i32.load	$push169=, 0($0)
	tee_local	$push168=, $4=, $pop169
	i32.load	$push167=, 0($1)
	tee_local	$push166=, $3=, $pop167
	i32.ne  	$push87=, $pop168, $pop166
	br_if   	59, $pop87      # 59: down to label24
# BB#32:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 33
	br      	68              # 68: up to label14
.LBB0_33:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label83:
	copy_local	$3=, $0
	copy_local	$4=, $1
	i32.const	$push86=, 4
	i32.add 	$push4=, $0, $pop86
	copy_local	$0=, $pop4
	i32.const	$push170=, 4
	i32.add 	$push5=, $1, $pop170
	copy_local	$1=, $pop5
# BB#34:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 34
	br      	67              # 67: up to label14
.LBB0_35:                               # %do2.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label82:
	i32.load	$push174=, 0($0)
	tee_local	$push173=, $0=, $pop174
	i32.load	$push172=, 0($1)
	tee_local	$push171=, $1=, $pop172
	i32.ne  	$push90=, $pop173, $pop171
	br_if   	59, $pop90      # 59: down to label22
# BB#36:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 38
	br      	66              # 66: up to label14
.LBB0_37:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label81:
	i32.const	$push89=, 8
	i32.add 	$1=, $4, $pop89
	i32.const	$push175=, 8
	i32.add 	$0=, $3, $pop175
	br      	60              # 60: down to label20
.LBB0_38:                               # %if.then35.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label80:
	i32.store	$drop=, 12($10), $0
	i32.store	$drop=, 8($10), $1
	i32.const	$push114=, 8
	i32.add 	$push115=, $10, $pop114
	copy_local	$1=, $pop115
	i32.const	$push116=, 12
	i32.add 	$push117=, $10, $pop116
	copy_local	$10=, $pop117
# BB#39:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 41
	br      	64              # 64: up to label14
.LBB0_40:                               # %do.body.i116.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label79:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($10)
	i32.const	$push177=, 1
	i32.add 	$push11=, $1, $pop177
	copy_local	$1=, $pop11
	i32.const	$push176=, 1
	i32.add 	$push10=, $10, $pop176
	copy_local	$10=, $pop10
	i32.eq  	$push81=, $2, $0
	br_if   	60, $pop81      # 60: down to label18
# BB#41:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 42
	br      	63              # 63: up to label14
.LBB0_42:                               # %mymemcmp1.exit120.i
	end_block                       # label78:
	i32.sub 	$push99=, $2, $0
	return  	$pop99
.LBB0_43:                               # %if.then.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label77:
	i32.store	$drop=, 12($10), $6
	i32.store	$drop=, 8($10), $5
	i32.const	$push110=, 8
	i32.add 	$push111=, $10, $pop110
	copy_local	$1=, $pop111
	i32.const	$push112=, 12
	i32.add 	$push113=, $10, $pop112
	copy_local	$10=, $pop113
# BB#44:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 27
	br      	61              # 61: up to label14
.LBB0_45:                               # %do.body.i.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label76:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($10)
	i32.const	$push179=, 1
	i32.add 	$push3=, $1, $pop179
	copy_local	$1=, $pop3
	i32.const	$push178=, 1
	i32.add 	$push2=, $10, $pop178
	copy_local	$10=, $pop2
	i32.eq  	$push85=, $2, $0
	br_if   	50, $pop85      # 50: down to label25
# BB#46:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 28
	br      	60              # 60: up to label14
.LBB0_47:                               # %mymemcmp1.exit.i
	end_block                       # label75:
	i32.sub 	$push102=, $2, $0
	return  	$pop102
.LBB0_48:                               # %if.then23.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label74:
	i32.store	$drop=, 12($10), $4
	i32.store	$drop=, 8($10), $3
	i32.const	$push122=, 8
	i32.add 	$push123=, $10, $pop122
	copy_local	$1=, $pop123
	i32.const	$push124=, 12
	i32.add 	$push125=, $10, $pop124
	copy_local	$10=, $pop125
# BB#49:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 31
	br      	58              # 58: up to label14
.LBB0_50:                               # %do.body.i140.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label73:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($10)
	i32.const	$push181=, 1
	i32.add 	$push7=, $1, $pop181
	copy_local	$1=, $pop7
	i32.const	$push180=, 1
	i32.add 	$push6=, $10, $pop180
	copy_local	$10=, $pop6
	i32.eq  	$push88=, $2, $0
	br_if   	49, $pop88      # 49: down to label23
# BB#51:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 32
	br      	57              # 57: up to label14
.LBB0_52:                               # %mymemcmp1.exit144.i
	end_block                       # label72:
	i32.sub 	$push101=, $2, $0
	return  	$pop101
.LBB0_53:                               # %if.then29.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label71:
	i32.store	$drop=, 12($10), $0
	i32.store	$drop=, 8($10), $1
	i32.const	$push118=, 8
	i32.add 	$push119=, $10, $pop118
	copy_local	$1=, $pop119
	i32.const	$push120=, 12
	i32.add 	$push121=, $10, $pop120
	copy_local	$10=, $pop121
# BB#54:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 36
	br      	55              # 55: up to label14
.LBB0_55:                               # %do.body.i128.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label70:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($10)
	i32.const	$push183=, 1
	i32.add 	$push9=, $1, $pop183
	copy_local	$1=, $pop9
	i32.const	$push182=, 1
	i32.add 	$push8=, $10, $pop182
	copy_local	$10=, $pop8
	i32.eq  	$push91=, $2, $0
	br_if   	48, $pop91      # 48: down to label21
# BB#56:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 37
	br      	54              # 54: up to label14
.LBB0_57:                               # %mymemcmp1.exit132.i
	end_block                       # label69:
	i32.sub 	$push100=, $2, $0
	return  	$pop100
.LBB0_58:                               # %do0.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label68:
	i32.const	$1=, 0
	i32.eq  	$push92=, $6, $5
	br_if   	41, $pop92      # 41: down to label26
# BB#59:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 46
	br      	52              # 52: up to label14
.LBB0_60:                               # %if.then43.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label67:
	i32.store	$drop=, 12($10), $6
	i32.store	$drop=, 8($10), $5
	i32.const	$push106=, 8
	i32.add 	$push107=, $10, $pop106
	copy_local	$1=, $pop107
	i32.const	$push108=, 12
	i32.add 	$push109=, $10, $pop108
	copy_local	$10=, $pop109
# BB#61:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 47
	br      	51              # 51: up to label14
.LBB0_62:                               # %do.body.i104.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label66:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($10)
	i32.const	$push185=, 1
	i32.add 	$push13=, $1, $pop185
	copy_local	$1=, $pop13
	i32.const	$push184=, 1
	i32.add 	$push12=, $10, $pop184
	copy_local	$10=, $pop12
	i32.eq  	$push93=, $2, $0
	br_if   	49, $pop93      # 49: down to label16
# BB#63:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 48
	br      	50              # 50: up to label14
.LBB0_64:                               # %mymemcmp1.exit108.i
	end_block                       # label65:
	i32.sub 	$push98=, $2, $0
	return  	$pop98
.LBB0_65:                               # %do1.i56
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label64:
	i32.load	$push191=, 0($6)
	tee_local	$push190=, $4=, $pop191
	i32.shl 	$push47=, $pop190, $3
	i32.shr_u	$push46=, $5, $0
	i32.or  	$push189=, $pop47, $pop46
	tee_local	$push188=, $5=, $pop189
	i32.load	$push187=, 0($1)
	tee_local	$push186=, $1=, $pop187
	i32.ne  	$push48=, $pop188, $pop186
	br_if   	32, $pop48      # 32: down to label31
# BB#66:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 18
	br      	48              # 48: up to label14
.LBB0_67:                               # %if.end54.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label63:
	i32.load	$7=, 12($8)
	i32.load	$5=, 12($9)
	i32.const	$push50=, -4
	i32.add 	$push193=, $2, $pop50
	tee_local	$push192=, $2=, $pop193
	i32.eqz 	$push226=, $pop192
	br_if   	33, $pop226     # 33: down to label29
# BB#68:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 19
	br      	47              # 47: up to label14
.LBB0_69:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label62:
	i32.const	$push51=, 16
	i32.add 	$1=, $8, $pop51
	i32.const	$push194=, 16
	i32.add 	$6=, $9, $pop194
# BB#70:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 0
	br      	46              # 46: up to label14
.LBB0_71:                               # %do.body.i23
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label61:
	i32.shl 	$push53=, $5, $3
	i32.shr_u	$push52=, $4, $0
	i32.or  	$push196=, $pop53, $pop52
	tee_local	$push195=, $4=, $pop196
	i32.ne  	$push54=, $pop195, $7
	br_if   	22, $pop54      # 22: down to label38
# BB#72:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 4
	br      	45              # 45: up to label14
.LBB0_73:                               # %do3.i42
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label60:
	i32.load	$push202=, 0($6)
	tee_local	$push201=, $7=, $pop202
	i32.shl 	$push57=, $pop201, $3
	i32.shr_u	$push56=, $5, $0
	i32.or  	$push200=, $pop57, $pop56
	tee_local	$push199=, $4=, $pop200
	i32.load	$push198=, 0($1)
	tee_local	$push197=, $5=, $pop198
	i32.ne  	$push58=, $pop199, $pop197
	br_if   	23, $pop58      # 23: down to label36
# BB#74:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 8
	br      	44              # 44: up to label14
.LBB0_75:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label59:
	copy_local	$8=, $1
	copy_local	$4=, $6
	i32.const	$push59=, 4
	i32.add 	$push17=, $1, $pop59
	copy_local	$1=, $pop17
# BB#76:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 9
	br      	43              # 43: up to label14
.LBB0_77:                               # %do2.i50
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label58:
	i32.load	$push208=, 4($4)
	tee_local	$push207=, $5=, $pop208
	i32.shl 	$push62=, $pop207, $3
	i32.shr_u	$push61=, $7, $0
	i32.or  	$push206=, $pop62, $pop61
	tee_local	$push205=, $6=, $pop206
	i32.load	$push204=, 0($1)
	tee_local	$push203=, $1=, $pop204
	i32.ne  	$push63=, $pop205, $pop203
	br_if   	23, $pop63      # 23: down to label34
# BB#78:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 13
	br      	42              # 42: up to label14
.LBB0_79:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label57:
	i32.const	$push64=, 8
	i32.add 	$1=, $8, $pop64
	i32.const	$push209=, 8
	i32.add 	$6=, $4, $pop209
	copy_local	$9=, $4
	br      	24              # 24: down to label32
.LBB0_80:                               # %if.then52.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label56:
	i32.store	$drop=, 12($10), $5
	i32.store	$drop=, 8($10), $1
	i32.const	$push134=, 8
	i32.add 	$push135=, $10, $pop134
	copy_local	$1=, $pop135
	i32.const	$push136=, 12
	i32.add 	$push137=, $10, $pop136
	copy_local	$10=, $pop137
# BB#81:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 16
	br      	40              # 40: up to label14
.LBB0_82:                               # %do.body.i170.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label55:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($10)
	i32.const	$push211=, 1
	i32.add 	$push23=, $1, $pop211
	copy_local	$1=, $pop23
	i32.const	$push210=, 1
	i32.add 	$push22=, $10, $pop210
	copy_local	$10=, $pop22
	i32.eq  	$push49=, $2, $0
	br_if   	24, $pop49      # 24: down to label30
# BB#83:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 17
	br      	39              # 39: up to label14
.LBB0_84:                               # %mymemcmp1.exit174.i
	end_block                       # label54:
	i32.sub 	$push94=, $2, $0
	return  	$pop94
.LBB0_85:                               # %if.then.i24
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label53:
	i32.store	$drop=, 12($10), $4
	i32.store	$drop=, 8($10), $7
	i32.const	$push130=, 8
	i32.add 	$push131=, $10, $pop130
	copy_local	$1=, $pop131
	i32.const	$push132=, 12
	i32.add 	$push133=, $10, $pop132
	copy_local	$10=, $pop133
# BB#86:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 2
	br      	37              # 37: up to label14
.LBB0_87:                               # %do.body.i.i30
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label52:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($10)
	i32.const	$push213=, 1
	i32.add 	$push16=, $1, $pop213
	copy_local	$1=, $pop16
	i32.const	$push212=, 1
	i32.add 	$push15=, $10, $pop212
	copy_local	$10=, $pop15
	i32.eq  	$push55=, $2, $0
	br_if   	14, $pop55      # 14: down to label37
# BB#88:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 3
	br      	36              # 36: up to label14
.LBB0_89:                               # %mymemcmp1.exit.i34
	end_block                       # label51:
	i32.sub 	$push97=, $2, $0
	return  	$pop97
.LBB0_90:                               # %if.then34.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label50:
	i32.store	$drop=, 12($10), $4
	i32.store	$drop=, 8($10), $5
	i32.const	$push142=, 8
	i32.add 	$push143=, $10, $pop142
	copy_local	$1=, $pop143
	i32.const	$push144=, 12
	i32.add 	$push145=, $10, $pop144
	copy_local	$10=, $pop145
# BB#91:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 6
	br      	34              # 34: up to label14
.LBB0_92:                               # %do.body.i194.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label49:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($10)
	i32.const	$push215=, 1
	i32.add 	$push19=, $1, $pop215
	copy_local	$1=, $pop19
	i32.const	$push214=, 1
	i32.add 	$push18=, $10, $pop214
	copy_local	$10=, $pop18
	i32.eq  	$push60=, $2, $0
	br_if   	13, $pop60      # 13: down to label35
# BB#93:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 7
	br      	33              # 33: up to label14
.LBB0_94:                               # %mymemcmp1.exit198.i
	end_block                       # label48:
	i32.sub 	$push96=, $2, $0
	return  	$pop96
.LBB0_95:                               # %if.then43.i51
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label47:
	i32.store	$drop=, 12($10), $6
	i32.store	$drop=, 8($10), $1
	i32.const	$push138=, 8
	i32.add 	$push139=, $10, $pop138
	copy_local	$1=, $pop139
	i32.const	$push140=, 12
	i32.add 	$push141=, $10, $pop140
	copy_local	$10=, $pop141
# BB#96:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 11
	br      	31              # 31: up to label14
.LBB0_97:                               # %do.body.i182.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label46:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($10)
	i32.const	$push217=, 1
	i32.add 	$push21=, $1, $pop217
	copy_local	$1=, $pop21
	i32.const	$push216=, 1
	i32.add 	$push20=, $10, $pop216
	copy_local	$10=, $pop20
	i32.eq  	$push65=, $2, $0
	br_if   	12, $pop65      # 12: down to label33
# BB#98:                                #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 12
	br      	30              # 30: up to label14
.LBB0_99:                               # %mymemcmp1.exit186.i
	end_block                       # label45:
	i32.sub 	$push95=, $2, $0
	return  	$pop95
.LBB0_100:                              # %do0.i57
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label44:
	i32.const	$1=, 0
	i32.shl 	$push67=, $5, $3
	i32.shr_u	$push66=, $4, $0
	i32.or  	$push219=, $pop67, $pop66
	tee_local	$push218=, $0=, $pop219
	i32.eq  	$push68=, $pop218, $7
	br_if   	15, $pop68      # 15: down to label28
# BB#101:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 21
	br      	28              # 28: up to label14
.LBB0_102:                              # %if.then63.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label43:
	i32.store	$drop=, 12($10), $0
	i32.store	$drop=, 8($10), $7
	i32.const	$push126=, 8
	i32.add 	$push127=, $10, $pop126
	copy_local	$1=, $pop127
	i32.const	$push128=, 12
	i32.add 	$push129=, $10, $pop128
	copy_local	$10=, $pop129
# BB#103:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 22
	br      	27              # 27: up to label14
.LBB0_104:                              # %do.body.i158.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label42:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($10)
	i32.const	$push221=, 1
	i32.add 	$push25=, $1, $pop221
	copy_local	$1=, $pop25
	i32.const	$push220=, 1
	i32.add 	$push24=, $10, $pop220
	copy_local	$10=, $pop24
	i32.eq  	$push69=, $2, $0
	br_if   	14, $pop69      # 14: down to label27
# BB#105:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 23
	br      	26              # 26: up to label14
.LBB0_106:                              # %mymemcmp1.exit162.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label41:
	i32.sub 	$1=, $2, $0
# BB#107:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 24
	br      	25              # 25: up to label14
.LBB0_108:                              # %cleanup
	end_block                       # label40:
	return  	$1
.LBB0_109:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label39:
	i32.const	$11=, 26
	br      	23              # 23: up to label14
.LBB0_110:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label38:
	i32.const	$11=, 1
	br      	22              # 22: up to label14
.LBB0_111:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label37:
	i32.const	$11=, 2
	br      	21              # 21: up to label14
.LBB0_112:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label36:
	i32.const	$11=, 5
	br      	20              # 20: up to label14
.LBB0_113:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label35:
	i32.const	$11=, 6
	br      	19              # 19: up to label14
.LBB0_114:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label34:
	i32.const	$11=, 10
	br      	18              # 18: up to label14
.LBB0_115:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label33:
	i32.const	$11=, 11
	br      	17              # 17: up to label14
.LBB0_116:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label32:
	i32.const	$11=, 14
	br      	16              # 16: up to label14
.LBB0_117:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label31:
	i32.const	$11=, 15
	br      	15              # 15: up to label14
.LBB0_118:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label30:
	i32.const	$11=, 16
	br      	14              # 14: up to label14
.LBB0_119:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label29:
	i32.const	$11=, 20
	br      	13              # 13: up to label14
.LBB0_120:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label28:
	i32.const	$11=, 24
	br      	12              # 12: up to label14
.LBB0_121:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label27:
	i32.const	$11=, 22
	br      	11              # 11: up to label14
.LBB0_122:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label26:
	i32.const	$11=, 24
	br      	10              # 10: up to label14
.LBB0_123:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label25:
	i32.const	$11=, 27
	br      	9               # 9: up to label14
.LBB0_124:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label24:
	i32.const	$11=, 30
	br      	8               # 8: up to label14
.LBB0_125:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label23:
	i32.const	$11=, 31
	br      	7               # 7: up to label14
.LBB0_126:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label22:
	i32.const	$11=, 35
	br      	6               # 6: up to label14
.LBB0_127:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label21:
	i32.const	$11=, 36
	br      	5               # 5: up to label14
.LBB0_128:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label20:
	i32.const	$11=, 39
	br      	4               # 4: up to label14
.LBB0_129:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label19:
	i32.const	$11=, 40
	br      	3               # 3: up to label14
.LBB0_130:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label18:
	i32.const	$11=, 41
	br      	2               # 2: up to label14
.LBB0_131:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label17:
	i32.const	$11=, 45
	br      	1               # 1: up to label14
.LBB0_132:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label16:
	i32.const	$11=, 47
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
	i32.store8	$drop=, buf+39($pop29), $pop0
	i32.const	$push27=, 0
	i32.const	$push26=, 0
	i32.load16_u	$push1=, .L.str+12($pop26):p2align=0
	i32.store16	$drop=, buf+37($pop27):p2align=0, $pop1
	i32.const	$push25=, 0
	i32.const	$push24=, 0
	i32.load	$push2=, .L.str+8($pop24):p2align=0
	i32.store	$drop=, buf+33($pop25):p2align=0, $pop2
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i64.load	$push3=, .L.str($pop22):p2align=0
	i64.store	$drop=, buf+25($pop23):p2align=0, $pop3
	i32.const	$push21=, 0
	i32.const	$push20=, 0
	i32.load8_u	$push4=, .L.str.1+14($pop20)
	i32.store8	$drop=, buf+182($pop21), $pop4
	i32.const	$push19=, 0
	i32.const	$push18=, 0
	i32.load16_u	$push5=, .L.str.1+12($pop18):p2align=0
	i32.store16	$drop=, buf+180($pop19), $pop5
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.load	$push6=, .L.str.1+8($pop16):p2align=0
	i32.store	$drop=, buf+176($pop17), $pop6
	i32.const	$push15=, 0
	i32.const	$push14=, 0
	i64.load	$push7=, .L.str.1($pop14):p2align=0
	i64.store	$drop=, buf+168($pop15), $pop7
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
	.functype	abort, void
