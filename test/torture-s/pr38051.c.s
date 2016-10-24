	.text
	.file	"/usr/local/google/home/jgravelle/code/wasm/waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr38051.c"
	.section	.text.mymemcmp,"ax",@progbits
	.hidden	mymemcmp
	.globl	mymemcmp
	.type	mymemcmp,@function
mymemcmp:                               # @mymemcmp
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push104=, 0
	i32.load	$push105=, __stack_pointer($pop104)
	i32.const	$push106=, 16
	i32.sub 	$10=, $pop105, $pop106
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
	block   	
	i32.const	$push147=, 3
	i32.and 	$push27=, $0, $pop147
	i32.eqz 	$push223=, $pop27
	br_if   	0, $pop223      # 0: down to label14
# BB#1:                                 # %if.else
	i32.const	$push28=, -4
	i32.and 	$4=, $0, $pop28
	i32.const	$push31=, 32
	i32.const	$push153=, 3
	i32.shl 	$push29=, $0, $pop153
	i32.const	$push30=, 24
	i32.and 	$push152=, $pop29, $pop30
	tee_local	$push151=, $0=, $pop152
	i32.sub 	$3=, $pop31, $pop151
	i32.const	$push150=, 3
	i32.and 	$push149=, $2, $pop150
	tee_local	$push148=, $5=, $pop149
	i32.eqz 	$push224=, $pop148
	br_if   	1, $pop224      # 1: down to label13
# BB#2:                                 # %if.else
	i32.const	$push32=, 1
	i32.eq  	$push33=, $5, $pop32
	br_if   	2, $pop33       # 2: down to label12
# BB#3:                                 # %if.else
	i32.const	$push34=, 3
	i32.ne  	$push35=, $5, $pop34
	br_if   	3, $pop35       # 3: down to label11
# BB#4:                                 # %sw.bb6.i
	i32.const	$push40=, 1
	i32.add 	$2=, $2, $pop40
	i32.const	$push41=, -4
	i32.add 	$8=, $1, $pop41
	i32.load	$7=, 0($4)
	br      	8               # 8: down to label6
.LBB0_5:                                # %if.then
	end_block                       # label14:
	i32.const	$push156=, 3
	i32.and 	$push155=, $2, $pop156
	tee_local	$push154=, $4=, $pop155
	i32.eqz 	$push225=, $pop154
	br_if   	11, $pop225     # 11: down to label2
# BB#6:                                 # %if.then
	i32.const	$push70=, 1
	i32.eq  	$push71=, $4, $pop70
	br_if   	3, $pop71       # 3: down to label10
# BB#7:                                 # %if.then
	i32.const	$push72=, 3
	i32.ne  	$push73=, $4, $pop72
	br_if   	4, $pop73       # 4: down to label9
# BB#8:                                 # %sw.bb3.i
	i32.const	$push76=, 1
	i32.add 	$2=, $2, $pop76
	i32.const	$push77=, -4
	i32.add 	$4=, $1, $pop77
	i32.const	$push157=, -4
	i32.add 	$3=, $0, $pop157
	br      	12              # 12: down to label1
.LBB0_9:                                # %sw.bb12.i18
	end_block                       # label13:
	i32.const	$push39=, 4
	i32.add 	$6=, $4, $pop39
	i32.load	$5=, 0($4)
	br      	5               # 5: down to label7
.LBB0_10:                               # %sw.bb17.i
	end_block                       # label12:
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
	br      	3               # 3: down to label8
.LBB0_11:                               # %sw.bb.i16
	end_block                       # label11:
	i32.const	$push42=, 2
	i32.add 	$2=, $2, $pop42
	i32.const	$push43=, -8
	i32.add 	$8=, $1, $pop43
	i32.const	$push44=, -4
	i32.add 	$9=, $4, $pop44
	i32.const	$push45=, 4
	i32.add 	$6=, $4, $pop45
	i32.load	$5=, 0($4)
	br      	5               # 5: down to label5
.LBB0_12:                               # %sw.bb12.i
	end_block                       # label10:
	i32.const	$push74=, -1
	i32.add 	$2=, $2, $pop74
	i32.load	$5=, 0($1)
	i32.load	$6=, 0($0)
	i32.const	$push75=, 4
	i32.add 	$push0=, $0, $pop75
	copy_local	$0=, $pop0
	i32.const	$push158=, 4
	i32.add 	$push1=, $1, $pop158
	copy_local	$1=, $pop1
	i32.eq  	$push84=, $6, $5
	br_if   	5, $pop84       # 5: down to label4
	br      	6               # 6: down to label3
.LBB0_13:                               # %sw.bb.i
	end_block                       # label9:
	i32.const	$push78=, 2
	i32.add 	$2=, $2, $pop78
	i32.const	$push79=, -8
	i32.add 	$4=, $1, $pop79
	i32.const	$push159=, -8
	i32.add 	$3=, $0, $pop159
# BB#14:
	i32.const	$11=, 39
	br      	8               # 8: down to label0
.LBB0_15:
	end_block                       # label8:
	i32.const	$11=, 0
	br      	7               # 7: down to label0
.LBB0_16:
	end_block                       # label7:
	i32.const	$11=, 4
	br      	6               # 6: down to label0
.LBB0_17:
	end_block                       # label6:
	i32.const	$11=, 9
	br      	5               # 5: down to label0
.LBB0_18:
	end_block                       # label5:
	i32.const	$11=, 14
	br      	4               # 4: down to label0
.LBB0_19:
	end_block                       # label4:
	i32.const	$11=, 29
	br      	3               # 3: down to label0
.LBB0_20:
	end_block                       # label3:
	i32.const	$11=, 26
	br      	2               # 2: down to label0
.LBB0_21:
	end_block                       # label2:
	i32.const	$11=, 29
	br      	1               # 1: down to label0
.LBB0_22:
	end_block                       # label1:
	i32.const	$11=, 34
.LBB0_23:                               # =>This Inner Loop Header: Depth=1
	end_block                       # label0:
	loop    	i32             # label15:
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$11, 26, 34, 35, 36, 27, 37, 38, 39, 28, 29, 40, 41, 42, 30, 23, 31, 32, 33, 24, 25, 43, 44, 45, 46, 47, 2, 10, 11, 12, 3, 13, 14, 15, 4, 5, 16, 17, 18, 6, 0, 7, 8, 9, 1, 19, 20, 21, 22, 22 # 26: down to label61
                                        # 34: down to label53
                                        # 35: down to label52
                                        # 36: down to label51
                                        # 27: down to label60
                                        # 37: down to label50
                                        # 38: down to label49
                                        # 39: down to label48
                                        # 28: down to label59
                                        # 29: down to label58
                                        # 40: down to label47
                                        # 41: down to label46
                                        # 42: down to label45
                                        # 30: down to label57
                                        # 23: down to label64
                                        # 31: down to label56
                                        # 32: down to label55
                                        # 33: down to label54
                                        # 24: down to label63
                                        # 25: down to label62
                                        # 43: down to label44
                                        # 44: down to label43
                                        # 45: down to label42
                                        # 46: down to label41
                                        # 47: down to label40
                                        # 2: down to label85
                                        # 10: down to label77
                                        # 11: down to label76
                                        # 12: down to label75
                                        # 3: down to label84
                                        # 13: down to label74
                                        # 14: down to label73
                                        # 15: down to label72
                                        # 4: down to label83
                                        # 5: down to label82
                                        # 16: down to label71
                                        # 17: down to label70
                                        # 18: down to label69
                                        # 6: down to label81
                                        # 0: down to label87
                                        # 7: down to label80
                                        # 8: down to label79
                                        # 9: down to label78
                                        # 1: down to label86
                                        # 19: down to label68
                                        # 20: down to label67
                                        # 21: down to label66
                                        # 22: down to label65
.LBB0_24:                               # %do1.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label87:
	i32.load	$push163=, 0($0)
	tee_local	$push162=, $0=, $pop163
	i32.load	$push161=, 0($1)
	tee_local	$push160=, $1=, $pop161
	i32.ne  	$push80=, $pop162, $pop160
	br_if   	68, $pop80      # 68: down to label18
# BB#25:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 43
	br      	71              # 71: up to label15
.LBB0_26:                               # %if.end37.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label86:
	i32.load	$5=, 12($4)
	i32.load	$6=, 12($3)
	i32.const	$push82=, -4
	i32.add 	$push165=, $2, $pop82
	tee_local	$push164=, $2=, $pop165
	i32.eqz 	$push226=, $pop164
	br_if   	60, $pop226     # 60: down to label25
# BB#27:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 25
	br      	70              # 70: up to label15
.LBB0_28:                               #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label85:
	i32.const	$push83=, 16
	i32.add 	$1=, $4, $pop83
	i32.const	$push166=, 16
	i32.add 	$0=, $3, $pop166
	i32.ne  	$push85=, $6, $5
	br_if   	45, $pop85      # 45: down to label39
# BB#29:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 29
	br      	69              # 69: up to label15
.LBB0_30:                               # %do3.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label84:
	i32.load	$push170=, 0($0)
	tee_local	$push169=, $4=, $pop170
	i32.load	$push168=, 0($1)
	tee_local	$push167=, $3=, $pop168
	i32.ne  	$push88=, $pop169, $pop167
	br_if   	60, $pop88      # 60: down to label23
# BB#31:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 33
	br      	68              # 68: up to label15
.LBB0_32:                               #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label83:
	copy_local	$3=, $0
	copy_local	$4=, $1
	i32.const	$push87=, 4
	i32.add 	$push4=, $0, $pop87
	copy_local	$0=, $pop4
	i32.const	$push171=, 4
	i32.add 	$push5=, $1, $pop171
	copy_local	$1=, $pop5
# BB#33:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 34
	br      	67              # 67: up to label15
.LBB0_34:                               # %do2.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label82:
	i32.load	$push175=, 0($0)
	tee_local	$push174=, $0=, $pop175
	i32.load	$push173=, 0($1)
	tee_local	$push172=, $1=, $pop173
	i32.ne  	$push91=, $pop174, $pop172
	br_if   	60, $pop91      # 60: down to label21
# BB#35:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 38
	br      	66              # 66: up to label15
.LBB0_36:                               #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label81:
	i32.const	$push90=, 8
	i32.add 	$1=, $4, $pop90
	i32.const	$push176=, 8
	i32.add 	$0=, $3, $pop176
	br      	61              # 61: down to label19
.LBB0_37:                               # %if.then35.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label80:
	i32.store	12($10), $0
	i32.store	8($10), $1
	i32.const	$push115=, 8
	i32.add 	$push116=, $10, $pop115
	copy_local	$1=, $pop116
	i32.const	$push117=, 12
	i32.add 	$push118=, $10, $pop117
	copy_local	$10=, $pop118
# BB#38:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 41
	br      	64              # 64: up to label15
.LBB0_39:                               # %do.body.i116.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label79:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($10)
	i32.const	$push178=, 1
	i32.add 	$push11=, $1, $pop178
	copy_local	$1=, $pop11
	i32.const	$push177=, 1
	i32.add 	$push10=, $10, $pop177
	copy_local	$10=, $pop10
	i32.eq  	$push81=, $2, $0
	br_if   	61, $pop81      # 61: down to label17
# BB#40:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 42
	br      	63              # 63: up to label15
.LBB0_41:                               # %mymemcmp1.exit120.i
	end_block                       # label78:
	i32.sub 	$push100=, $2, $0
	return  	$pop100
.LBB0_42:                               # %if.then.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label77:
	i32.store	12($10), $6
	i32.store	8($10), $5
	i32.const	$push111=, 8
	i32.add 	$push112=, $10, $pop111
	copy_local	$1=, $pop112
	i32.const	$push113=, 12
	i32.add 	$push114=, $10, $pop113
	copy_local	$10=, $pop114
# BB#43:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 27
	br      	61              # 61: up to label15
.LBB0_44:                               # %do.body.i.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label76:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($10)
	i32.const	$push180=, 1
	i32.add 	$push3=, $1, $pop180
	copy_local	$1=, $pop3
	i32.const	$push179=, 1
	i32.add 	$push2=, $10, $pop179
	copy_local	$10=, $pop2
	i32.eq  	$push86=, $2, $0
	br_if   	51, $pop86      # 51: down to label24
# BB#45:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 28
	br      	60              # 60: up to label15
.LBB0_46:                               # %mymemcmp1.exit.i
	end_block                       # label75:
	i32.sub 	$push103=, $2, $0
	return  	$pop103
.LBB0_47:                               # %if.then23.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label74:
	i32.store	12($10), $4
	i32.store	8($10), $3
	i32.const	$push123=, 8
	i32.add 	$push124=, $10, $pop123
	copy_local	$1=, $pop124
	i32.const	$push125=, 12
	i32.add 	$push126=, $10, $pop125
	copy_local	$10=, $pop126
# BB#48:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 31
	br      	58              # 58: up to label15
.LBB0_49:                               # %do.body.i140.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label73:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($10)
	i32.const	$push182=, 1
	i32.add 	$push7=, $1, $pop182
	copy_local	$1=, $pop7
	i32.const	$push181=, 1
	i32.add 	$push6=, $10, $pop181
	copy_local	$10=, $pop6
	i32.eq  	$push89=, $2, $0
	br_if   	50, $pop89      # 50: down to label22
# BB#50:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 32
	br      	57              # 57: up to label15
.LBB0_51:                               # %mymemcmp1.exit144.i
	end_block                       # label72:
	i32.sub 	$push102=, $2, $0
	return  	$pop102
.LBB0_52:                               # %if.then29.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label71:
	i32.store	12($10), $0
	i32.store	8($10), $1
	i32.const	$push119=, 8
	i32.add 	$push120=, $10, $pop119
	copy_local	$1=, $pop120
	i32.const	$push121=, 12
	i32.add 	$push122=, $10, $pop121
	copy_local	$10=, $pop122
# BB#53:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 36
	br      	55              # 55: up to label15
.LBB0_54:                               # %do.body.i128.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label70:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($10)
	i32.const	$push184=, 1
	i32.add 	$push9=, $1, $pop184
	copy_local	$1=, $pop9
	i32.const	$push183=, 1
	i32.add 	$push8=, $10, $pop183
	copy_local	$10=, $pop8
	i32.eq  	$push92=, $2, $0
	br_if   	49, $pop92      # 49: down to label20
# BB#55:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 37
	br      	54              # 54: up to label15
.LBB0_56:                               # %mymemcmp1.exit132.i
	end_block                       # label69:
	i32.sub 	$push101=, $2, $0
	return  	$pop101
.LBB0_57:                               # %do0.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label68:
	i32.const	$1=, 0
	i32.eq  	$push93=, $6, $5
	br_if   	41, $pop93      # 41: down to label26
# BB#58:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 45
	br      	52              # 52: up to label15
.LBB0_59:                               # %if.then43.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label67:
	i32.store	12($10), $6
	i32.store	8($10), $5
	i32.const	$push107=, 8
	i32.add 	$push108=, $10, $pop107
	copy_local	$1=, $pop108
	i32.const	$push109=, 12
	i32.add 	$push110=, $10, $pop109
	copy_local	$10=, $pop110
# BB#60:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 46
	br      	51              # 51: up to label15
.LBB0_61:                               # %do.body.i104.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label66:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($10)
	i32.const	$push186=, 1
	i32.add 	$push13=, $1, $pop186
	copy_local	$1=, $pop13
	i32.const	$push185=, 1
	i32.add 	$push12=, $10, $pop185
	copy_local	$10=, $pop12
	i32.eq  	$push94=, $2, $0
	br_if   	49, $pop94      # 49: down to label16
# BB#62:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 47
	br      	50              # 50: up to label15
.LBB0_63:                               # %mymemcmp1.exit108.i
	end_block                       # label65:
	i32.sub 	$push99=, $2, $0
	return  	$pop99
.LBB0_64:                               # %do1.i56
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label64:
	i32.load	$push192=, 0($6)
	tee_local	$push191=, $4=, $pop192
	i32.shl 	$push47=, $pop191, $3
	i32.shr_u	$push46=, $5, $0
	i32.or  	$push190=, $pop47, $pop46
	tee_local	$push189=, $5=, $pop190
	i32.load	$push188=, 0($1)
	tee_local	$push187=, $1=, $pop188
	i32.ne  	$push48=, $pop189, $pop187
	br_if   	32, $pop48      # 32: down to label31
# BB#65:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 18
	br      	48              # 48: up to label15
.LBB0_66:                               # %if.end54.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label63:
	i32.load	$7=, 12($8)
	i32.load	$5=, 12($9)
	i32.const	$push50=, -4
	i32.add 	$push194=, $2, $pop50
	tee_local	$push193=, $2=, $pop194
	i32.eqz 	$push227=, $pop193
	br_if   	33, $pop227     # 33: down to label29
# BB#67:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 19
	br      	47              # 47: up to label15
.LBB0_68:                               #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label62:
	i32.const	$push51=, 16
	i32.add 	$1=, $8, $pop51
	i32.const	$push195=, 16
	i32.add 	$6=, $9, $pop195
# BB#69:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 0
	br      	46              # 46: up to label15
.LBB0_70:                               # %do.body.i23
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label61:
	i32.shl 	$push53=, $5, $3
	i32.shr_u	$push52=, $4, $0
	i32.or  	$push197=, $pop53, $pop52
	tee_local	$push196=, $4=, $pop197
	i32.ne  	$push54=, $pop196, $7
	br_if   	22, $pop54      # 22: down to label38
# BB#71:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 4
	br      	45              # 45: up to label15
.LBB0_72:                               # %do3.i42
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label60:
	i32.load	$push203=, 0($6)
	tee_local	$push202=, $7=, $pop203
	i32.shl 	$push57=, $pop202, $3
	i32.shr_u	$push56=, $5, $0
	i32.or  	$push201=, $pop57, $pop56
	tee_local	$push200=, $4=, $pop201
	i32.load	$push199=, 0($1)
	tee_local	$push198=, $5=, $pop199
	i32.ne  	$push58=, $pop200, $pop198
	br_if   	23, $pop58      # 23: down to label36
# BB#73:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 8
	br      	44              # 44: up to label15
.LBB0_74:                               #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label59:
	copy_local	$8=, $1
	copy_local	$4=, $6
	i32.const	$push59=, 4
	i32.add 	$push17=, $1, $pop59
	copy_local	$1=, $pop17
# BB#75:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 9
	br      	43              # 43: up to label15
.LBB0_76:                               # %do2.i50
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label58:
	i32.load	$push209=, 4($4)
	tee_local	$push208=, $5=, $pop209
	i32.shl 	$push62=, $pop208, $3
	i32.shr_u	$push61=, $7, $0
	i32.or  	$push207=, $pop62, $pop61
	tee_local	$push206=, $6=, $pop207
	i32.load	$push205=, 0($1)
	tee_local	$push204=, $1=, $pop205
	i32.ne  	$push63=, $pop206, $pop204
	br_if   	23, $pop63      # 23: down to label34
# BB#77:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 13
	br      	42              # 42: up to label15
.LBB0_78:                               #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label57:
	i32.const	$push64=, 8
	i32.add 	$1=, $8, $pop64
	i32.const	$push210=, 8
	i32.add 	$6=, $4, $pop210
	copy_local	$9=, $4
	br      	24              # 24: down to label32
.LBB0_79:                               # %if.then52.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label56:
	i32.store	12($10), $5
	i32.store	8($10), $1
	i32.const	$push135=, 8
	i32.add 	$push136=, $10, $pop135
	copy_local	$1=, $pop136
	i32.const	$push137=, 12
	i32.add 	$push138=, $10, $pop137
	copy_local	$10=, $pop138
# BB#80:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 16
	br      	40              # 40: up to label15
.LBB0_81:                               # %do.body.i170.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label55:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($10)
	i32.const	$push212=, 1
	i32.add 	$push23=, $1, $pop212
	copy_local	$1=, $pop23
	i32.const	$push211=, 1
	i32.add 	$push22=, $10, $pop211
	copy_local	$10=, $pop22
	i32.eq  	$push49=, $2, $0
	br_if   	24, $pop49      # 24: down to label30
# BB#82:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 17
	br      	39              # 39: up to label15
.LBB0_83:                               # %mymemcmp1.exit174.i
	end_block                       # label54:
	i32.sub 	$push95=, $2, $0
	return  	$pop95
.LBB0_84:                               # %if.then.i24
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label53:
	i32.store	12($10), $4
	i32.store	8($10), $7
	i32.const	$push131=, 8
	i32.add 	$push132=, $10, $pop131
	copy_local	$1=, $pop132
	i32.const	$push133=, 12
	i32.add 	$push134=, $10, $pop133
	copy_local	$10=, $pop134
# BB#85:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 2
	br      	37              # 37: up to label15
.LBB0_86:                               # %do.body.i.i30
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label52:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($10)
	i32.const	$push214=, 1
	i32.add 	$push16=, $1, $pop214
	copy_local	$1=, $pop16
	i32.const	$push213=, 1
	i32.add 	$push15=, $10, $pop213
	copy_local	$10=, $pop15
	i32.eq  	$push55=, $2, $0
	br_if   	14, $pop55      # 14: down to label37
# BB#87:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 3
	br      	36              # 36: up to label15
.LBB0_88:                               # %mymemcmp1.exit.i34
	end_block                       # label51:
	i32.sub 	$push98=, $2, $0
	return  	$pop98
.LBB0_89:                               # %if.then34.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label50:
	i32.store	12($10), $4
	i32.store	8($10), $5
	i32.const	$push143=, 8
	i32.add 	$push144=, $10, $pop143
	copy_local	$1=, $pop144
	i32.const	$push145=, 12
	i32.add 	$push146=, $10, $pop145
	copy_local	$10=, $pop146
# BB#90:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 6
	br      	34              # 34: up to label15
.LBB0_91:                               # %do.body.i194.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label49:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($10)
	i32.const	$push216=, 1
	i32.add 	$push19=, $1, $pop216
	copy_local	$1=, $pop19
	i32.const	$push215=, 1
	i32.add 	$push18=, $10, $pop215
	copy_local	$10=, $pop18
	i32.eq  	$push60=, $2, $0
	br_if   	13, $pop60      # 13: down to label35
# BB#92:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 7
	br      	33              # 33: up to label15
.LBB0_93:                               # %mymemcmp1.exit198.i
	end_block                       # label48:
	i32.sub 	$push97=, $2, $0
	return  	$pop97
.LBB0_94:                               # %if.then43.i51
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label47:
	i32.store	12($10), $6
	i32.store	8($10), $1
	i32.const	$push139=, 8
	i32.add 	$push140=, $10, $pop139
	copy_local	$1=, $pop140
	i32.const	$push141=, 12
	i32.add 	$push142=, $10, $pop141
	copy_local	$10=, $pop142
# BB#95:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 11
	br      	31              # 31: up to label15
.LBB0_96:                               # %do.body.i182.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label46:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($10)
	i32.const	$push218=, 1
	i32.add 	$push21=, $1, $pop218
	copy_local	$1=, $pop21
	i32.const	$push217=, 1
	i32.add 	$push20=, $10, $pop217
	copy_local	$10=, $pop20
	i32.eq  	$push65=, $2, $0
	br_if   	12, $pop65      # 12: down to label33
# BB#97:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 12
	br      	30              # 30: up to label15
.LBB0_98:                               # %mymemcmp1.exit186.i
	end_block                       # label45:
	i32.sub 	$push96=, $2, $0
	return  	$pop96
.LBB0_99:                               # %do0.i57
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label44:
	i32.const	$1=, 0
	i32.shl 	$push67=, $5, $3
	i32.shr_u	$push66=, $4, $0
	i32.or  	$push220=, $pop67, $pop66
	tee_local	$push219=, $0=, $pop220
	i32.eq  	$push68=, $pop219, $7
	br_if   	15, $pop68      # 15: down to label28
# BB#100:                               #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 21
	br      	28              # 28: up to label15
.LBB0_101:                              # %if.then63.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label43:
	i32.store	12($10), $0
	i32.store	8($10), $7
	i32.const	$push127=, 8
	i32.add 	$push128=, $10, $pop127
	copy_local	$1=, $pop128
	i32.const	$push129=, 12
	i32.add 	$push130=, $10, $pop129
	copy_local	$10=, $pop130
# BB#102:                               #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 22
	br      	27              # 27: up to label15
.LBB0_103:                              # %do.body.i158.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label42:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($10)
	i32.const	$push222=, 1
	i32.add 	$push25=, $1, $pop222
	copy_local	$1=, $pop25
	i32.const	$push221=, 1
	i32.add 	$push24=, $10, $pop221
	copy_local	$10=, $pop24
	i32.eq  	$push69=, $2, $0
	br_if   	14, $pop69      # 14: down to label27
# BB#104:                               #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 23
	br      	26              # 26: up to label15
.LBB0_105:                              # %mymemcmp1.exit162.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label41:
	i32.sub 	$1=, $2, $0
# BB#106:                               #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 24
	br      	25              # 25: up to label15
.LBB0_107:                              # %cleanup
	end_block                       # label40:
	return  	$1
.LBB0_108:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label39:
	i32.const	$11=, 26
	br      	23              # 23: up to label15
.LBB0_109:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label38:
	i32.const	$11=, 1
	br      	22              # 22: up to label15
.LBB0_110:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label37:
	i32.const	$11=, 2
	br      	21              # 21: up to label15
.LBB0_111:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label36:
	i32.const	$11=, 5
	br      	20              # 20: up to label15
.LBB0_112:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label35:
	i32.const	$11=, 6
	br      	19              # 19: up to label15
.LBB0_113:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label34:
	i32.const	$11=, 10
	br      	18              # 18: up to label15
.LBB0_114:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label33:
	i32.const	$11=, 11
	br      	17              # 17: up to label15
.LBB0_115:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label32:
	i32.const	$11=, 14
	br      	16              # 16: up to label15
.LBB0_116:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label31:
	i32.const	$11=, 15
	br      	15              # 15: up to label15
.LBB0_117:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label30:
	i32.const	$11=, 16
	br      	14              # 14: up to label15
.LBB0_118:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label29:
	i32.const	$11=, 20
	br      	13              # 13: up to label15
.LBB0_119:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label28:
	i32.const	$11=, 24
	br      	12              # 12: up to label15
.LBB0_120:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label27:
	i32.const	$11=, 22
	br      	11              # 11: up to label15
.LBB0_121:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label26:
	i32.const	$11=, 24
	br      	10              # 10: up to label15
.LBB0_122:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label25:
	i32.const	$11=, 44
	br      	9               # 9: up to label15
.LBB0_123:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label24:
	i32.const	$11=, 27
	br      	8               # 8: up to label15
.LBB0_124:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label23:
	i32.const	$11=, 30
	br      	7               # 7: up to label15
.LBB0_125:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label22:
	i32.const	$11=, 31
	br      	6               # 6: up to label15
.LBB0_126:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label21:
	i32.const	$11=, 35
	br      	5               # 5: up to label15
.LBB0_127:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label20:
	i32.const	$11=, 36
	br      	4               # 4: up to label15
.LBB0_128:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label19:
	i32.const	$11=, 39
	br      	3               # 3: up to label15
.LBB0_129:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label18:
	i32.const	$11=, 40
	br      	2               # 2: up to label15
.LBB0_130:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label17:
	i32.const	$11=, 41
	br      	1               # 1: up to label15
.LBB0_131:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label16:
	i32.const	$11=, 46
	br      	0               # 0: up to label15
.LBB0_132:
	end_loop
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
	i32.store8	buf+39($pop29), $pop0
	i32.const	$push27=, 0
	i32.const	$push26=, 0
	i32.load16_u	$push1=, .L.str+12($pop26):p2align=0
	i32.store16	buf+37($pop27):p2align=0, $pop1
	i32.const	$push25=, 0
	i32.const	$push24=, 0
	i32.load	$push2=, .L.str+8($pop24):p2align=0
	i32.store	buf+33($pop25):p2align=0, $pop2
	i32.const	$push23=, 0
	i32.const	$push22=, 0
	i64.load	$push3=, .L.str($pop22):p2align=0
	i64.store	buf+25($pop23):p2align=0, $pop3
	i32.const	$push21=, 0
	i32.const	$push20=, 0
	i32.load8_u	$push4=, .L.str.1+14($pop20)
	i32.store8	buf+182($pop21), $pop4
	i32.const	$push19=, 0
	i32.const	$push18=, 0
	i32.load16_u	$push5=, .L.str.1+12($pop18):p2align=0
	i32.store16	buf+180($pop19), $pop5
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.load	$push6=, .L.str.1+8($pop16):p2align=0
	i32.store	buf+176($pop17), $pop6
	i32.const	$push15=, 0
	i32.const	$push14=, 0
	i64.load	$push7=, .L.str.1($pop14):p2align=0
	i64.store	buf+168($pop15), $pop7
	block   	
	i32.const	$push10=, buf+25
	i32.const	$push9=, buf+168
	i32.const	$push8=, 33
	i32.call	$push11=, mymemcmp@FUNCTION, $pop10, $pop9, $pop8
	i32.const	$push12=, -51
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	0, $pop13       # 0: down to label88
# BB#1:                                 # %cleanup
	i32.const	$push30=, 0
	return  	$pop30
.LBB1_2:                                # %if.then26
	end_block                       # label88:
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
