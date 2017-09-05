	.text
	.file	"pr38051.c"
	.section	.text.mymemcmp,"ax",@progbits
	.hidden	mymemcmp                # -- Begin function mymemcmp
	.globl	mymemcmp
	.type	mymemcmp,@function
mymemcmp:                               # @mymemcmp
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push105=, 0
	i32.load	$push104=, __stack_pointer($pop105)
	i32.const	$push106=, 16
	i32.sub 	$6=, $pop104, $pop106
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
	i32.const	$push147=, 3
	i32.and 	$push27=, $0, $pop147
	i32.eqz 	$push223=, $pop27
	br_if   	0, $pop223      # 0: down to label13
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
	br_if   	1, $pop224      # 1: down to label12
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
	i32.add 	$9=, $1, $pop41
	i32.load	$8=, 0($4)
	br      	8               # 8: down to label5
.LBB0_5:                                # %if.then
	end_block                       # label13:
	i32.const	$push156=, 3
	i32.and 	$push155=, $2, $pop156
	tee_local	$push154=, $4=, $pop155
	i32.eqz 	$push225=, $pop154
	br_if   	10, $pop225     # 10: down to label2
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
	i32.const	$push157=, -4
	i32.add 	$3=, $0, $pop157
	br      	11              # 11: down to label1
.LBB0_9:                                # %sw.bb12.i18
	end_block                       # label12:
	i32.const	$push39=, 4
	i32.add 	$7=, $4, $pop39
	i32.load	$5=, 0($4)
	br      	5               # 5: down to label6
.LBB0_10:                               # %sw.bb17.i
	end_block                       # label11:
	i32.const	$push36=, -1
	i32.add 	$2=, $2, $pop36
	i32.const	$push38=, 8
	i32.add 	$7=, $4, $pop38
	i32.load	$8=, 0($1)
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
	i32.add 	$9=, $1, $pop43
	i32.const	$push44=, -4
	i32.add 	$10=, $4, $pop44
	i32.const	$push45=, 4
	i32.add 	$7=, $4, $pop45
	i32.load	$5=, 0($4)
	br      	5               # 5: down to label4
.LBB0_12:                               # %sw.bb12.i
	end_block                       # label9:
	i32.const	$push74=, -1
	i32.add 	$2=, $2, $pop74
	i32.load	$5=, 0($1)
	i32.load	$7=, 0($0)
	i32.const	$push75=, 4
	i32.add 	$push0=, $0, $pop75
	copy_local	$0=, $pop0
	i32.const	$push158=, 4
	i32.add 	$push1=, $1, $pop158
	copy_local	$1=, $pop1
	i32.ne  	$push85=, $7, $5
	br_if   	5, $pop85       # 5: down to label3
# BB#13:
	i32.const	$11=, 29
	br      	8               # 8: down to label0
.LBB0_14:                               # %sw.bb.i
	end_block                       # label8:
	i32.const	$push78=, 2
	i32.add 	$2=, $2, $pop78
	i32.const	$push79=, -8
	i32.add 	$4=, $1, $pop79
	i32.const	$push169=, -8
	i32.add 	$3=, $0, $pop169
# BB#15:
	i32.const	$11=, 39
	br      	7               # 7: down to label0
.LBB0_16:
	end_block                       # label7:
	i32.const	$11=, 0
	br      	6               # 6: down to label0
.LBB0_17:
	end_block                       # label6:
	i32.const	$11=, 4
	br      	5               # 5: down to label0
.LBB0_18:
	end_block                       # label5:
	i32.const	$11=, 9
	br      	4               # 4: down to label0
.LBB0_19:
	end_block                       # label4:
	i32.const	$11=, 14
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
	loop    	i32             # label14:
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	block   	
	br_table 	$11, 23, 31, 32, 33, 24, 34, 35, 36, 25, 26, 37, 38, 39, 27, 28, 40, 41, 42, 29, 30, 43, 44, 45, 46, 47, 6, 7, 8, 9, 0, 10, 11, 12, 1, 2, 13, 14, 15, 3, 4, 16, 17, 18, 5, 19, 20, 21, 22, 22 # 23: down to label63
                                        # 31: down to label55
                                        # 32: down to label54
                                        # 33: down to label53
                                        # 24: down to label62
                                        # 34: down to label52
                                        # 35: down to label51
                                        # 36: down to label50
                                        # 25: down to label61
                                        # 26: down to label60
                                        # 37: down to label49
                                        # 38: down to label48
                                        # 39: down to label47
                                        # 27: down to label59
                                        # 28: down to label58
                                        # 40: down to label46
                                        # 41: down to label45
                                        # 42: down to label44
                                        # 29: down to label57
                                        # 30: down to label56
                                        # 43: down to label43
                                        # 44: down to label42
                                        # 45: down to label41
                                        # 46: down to label40
                                        # 47: down to label39
                                        # 6: down to label80
                                        # 7: down to label79
                                        # 8: down to label78
                                        # 9: down to label77
                                        # 0: down to label86
                                        # 10: down to label76
                                        # 11: down to label75
                                        # 12: down to label74
                                        # 1: down to label85
                                        # 2: down to label84
                                        # 13: down to label73
                                        # 14: down to label72
                                        # 15: down to label71
                                        # 3: down to label83
                                        # 4: down to label82
                                        # 16: down to label70
                                        # 17: down to label69
                                        # 18: down to label68
                                        # 5: down to label81
                                        # 19: down to label67
                                        # 20: down to label66
                                        # 21: down to label65
                                        # 22: down to label64
.LBB0_24:                               # %do3.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label86:
	i32.load	$push162=, 0($0)
	tee_local	$push161=, $4=, $pop162
	i32.load	$push160=, 0($1)
	tee_local	$push159=, $3=, $pop160
	i32.ne  	$push88=, $pop161, $pop159
	br_if   	63, $pop88      # 63: down to label22
# BB#25:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 33
	br      	71              # 71: up to label14
.LBB0_26:                               #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label85:
	copy_local	$3=, $0
	copy_local	$4=, $1
	i32.const	$push87=, 4
	i32.add 	$push4=, $0, $pop87
	copy_local	$0=, $pop4
	i32.const	$push163=, 4
	i32.add 	$push5=, $1, $pop163
	copy_local	$1=, $pop5
# BB#27:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 34
	br      	70              # 70: up to label14
.LBB0_28:                               # %do2.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label84:
	i32.load	$push167=, 0($0)
	tee_local	$push166=, $0=, $pop167
	i32.load	$push165=, 0($1)
	tee_local	$push164=, $1=, $pop165
	i32.ne  	$push90=, $pop166, $pop164
	br_if   	63, $pop90      # 63: down to label20
# BB#29:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 38
	br      	69              # 69: up to label14
.LBB0_30:                               # %if.end31.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label83:
	i32.const	$push92=, 8
	i32.add 	$0=, $3, $pop92
	i32.const	$push168=, 8
	i32.add 	$1=, $4, $pop168
	br      	64              # 64: down to label18
.LBB0_31:                               # %do1.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label82:
	i32.load	$push173=, 0($0)
	tee_local	$push172=, $0=, $pop173
	i32.load	$push171=, 0($1)
	tee_local	$push170=, $1=, $pop171
	i32.ne  	$push80=, $pop172, $pop170
	br_if   	64, $pop80      # 64: down to label17
# BB#32:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 43
	br      	67              # 67: up to label14
.LBB0_33:                               # %if.end37.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label81:
	i32.load	$5=, 12($4)
	i32.load	$7=, 12($3)
	i32.const	$push82=, -4
	i32.add 	$push175=, $2, $pop82
	tee_local	$push174=, $2=, $pop175
	i32.eqz 	$push226=, $pop174
	br_if   	56, $pop226     # 56: down to label24
# BB#34:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 25
	br      	66              # 66: up to label14
.LBB0_35:                               #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label80:
	i32.const	$push83=, 16
	i32.add 	$1=, $4, $pop83
	i32.const	$push176=, 16
	i32.add 	$0=, $3, $pop176
	i32.eq  	$push84=, $7, $5
	br_if   	41, $pop84      # 41: down to label38
# BB#36:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 26
	br      	65              # 65: up to label14
.LBB0_37:                               # %if.then.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label79:
	i32.store	8($6), $5
	i32.store	12($6), $7
	i32.const	$push111=, 8
	i32.add 	$push112=, $6, $pop111
	copy_local	$1=, $pop112
	i32.const	$push113=, 12
	i32.add 	$push114=, $6, $pop113
	copy_local	$6=, $pop114
# BB#38:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 27
	br      	64              # 64: up to label14
.LBB0_39:                               # %do.body.i.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label78:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($6)
	i32.const	$push178=, 1
	i32.add 	$push3=, $1, $pop178
	copy_local	$1=, $pop3
	i32.const	$push177=, 1
	i32.add 	$push2=, $6, $pop177
	copy_local	$6=, $pop2
	i32.eq  	$push86=, $2, $0
	br_if   	54, $pop86      # 54: down to label23
# BB#40:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 28
	br      	63              # 63: up to label14
.LBB0_41:                               # %mymemcmp1.exit.i
	end_block                       # label77:
	i32.sub 	$push103=, $2, $0
	return  	$pop103
.LBB0_42:                               # %if.then23.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label76:
	i32.store	8($6), $3
	i32.store	12($6), $4
	i32.const	$push123=, 8
	i32.add 	$push124=, $6, $pop123
	copy_local	$1=, $pop124
	i32.const	$push125=, 12
	i32.add 	$push126=, $6, $pop125
	copy_local	$6=, $pop126
# BB#43:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 31
	br      	61              # 61: up to label14
.LBB0_44:                               # %do.body.i140.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label75:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($6)
	i32.const	$push180=, 1
	i32.add 	$push7=, $1, $pop180
	copy_local	$1=, $pop7
	i32.const	$push179=, 1
	i32.add 	$push6=, $6, $pop179
	copy_local	$6=, $pop6
	i32.eq  	$push89=, $2, $0
	br_if   	53, $pop89      # 53: down to label21
# BB#45:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 32
	br      	60              # 60: up to label14
.LBB0_46:                               # %mymemcmp1.exit144.i
	end_block                       # label74:
	i32.sub 	$push102=, $2, $0
	return  	$pop102
.LBB0_47:                               # %if.then29.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label73:
	i32.store	8($6), $1
	i32.store	12($6), $0
	i32.const	$push119=, 8
	i32.add 	$push120=, $6, $pop119
	copy_local	$1=, $pop120
	i32.const	$push121=, 12
	i32.add 	$push122=, $6, $pop121
	copy_local	$6=, $pop122
# BB#48:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 36
	br      	58              # 58: up to label14
.LBB0_49:                               # %do.body.i128.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label72:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($6)
	i32.const	$push182=, 1
	i32.add 	$push9=, $1, $pop182
	copy_local	$1=, $pop9
	i32.const	$push181=, 1
	i32.add 	$push8=, $6, $pop181
	copy_local	$6=, $pop8
	i32.eq  	$push91=, $2, $0
	br_if   	52, $pop91      # 52: down to label19
# BB#50:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 37
	br      	57              # 57: up to label14
.LBB0_51:                               # %mymemcmp1.exit132.i
	end_block                       # label71:
	i32.sub 	$push101=, $2, $0
	return  	$pop101
.LBB0_52:                               # %if.then35.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label70:
	i32.store	8($6), $1
	i32.store	12($6), $0
	i32.const	$push115=, 8
	i32.add 	$push116=, $6, $pop115
	copy_local	$1=, $pop116
	i32.const	$push117=, 12
	i32.add 	$push118=, $6, $pop117
	copy_local	$6=, $pop118
# BB#53:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 41
	br      	55              # 55: up to label14
.LBB0_54:                               # %do.body.i116.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label69:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($6)
	i32.const	$push184=, 1
	i32.add 	$push11=, $1, $pop184
	copy_local	$1=, $pop11
	i32.const	$push183=, 1
	i32.add 	$push10=, $6, $pop183
	copy_local	$6=, $pop10
	i32.eq  	$push81=, $2, $0
	br_if   	52, $pop81      # 52: down to label16
# BB#55:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 42
	br      	54              # 54: up to label14
.LBB0_56:                               # %mymemcmp1.exit120.i
	end_block                       # label68:
	i32.sub 	$push100=, $2, $0
	return  	$pop100
.LBB0_57:                               # %do0.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label67:
	i32.const	$1=, 0
	i32.eq  	$push93=, $7, $5
	br_if   	41, $pop93      # 41: down to label25
# BB#58:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 45
	br      	52              # 52: up to label14
.LBB0_59:                               # %if.then43.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label66:
	i32.store	8($6), $5
	i32.store	12($6), $7
	i32.const	$push107=, 8
	i32.add 	$push108=, $6, $pop107
	copy_local	$1=, $pop108
	i32.const	$push109=, 12
	i32.add 	$push110=, $6, $pop109
	copy_local	$6=, $pop110
# BB#60:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 46
	br      	51              # 51: up to label14
.LBB0_61:                               # %do.body.i104.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label65:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($6)
	i32.const	$push186=, 1
	i32.add 	$push13=, $1, $pop186
	copy_local	$1=, $pop13
	i32.const	$push185=, 1
	i32.add 	$push12=, $6, $pop185
	copy_local	$6=, $pop12
	i32.eq  	$push94=, $2, $0
	br_if   	49, $pop94      # 49: down to label15
# BB#62:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 47
	br      	50              # 50: up to label14
.LBB0_63:                               # %mymemcmp1.exit108.i
	end_block                       # label64:
	i32.sub 	$push99=, $2, $0
	return  	$pop99
.LBB0_64:                               # %do.body.i23
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label63:
	i32.shl 	$push53=, $5, $3
	i32.shr_u	$push52=, $4, $0
	i32.or  	$push188=, $pop53, $pop52
	tee_local	$push187=, $4=, $pop188
	i32.ne  	$push54=, $pop187, $8
	br_if   	25, $pop54      # 25: down to label37
# BB#65:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 4
	br      	48              # 48: up to label14
.LBB0_66:                               # %do3.i42
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label62:
	i32.load	$push194=, 0($7)
	tee_local	$push193=, $8=, $pop194
	i32.shl 	$push57=, $pop193, $3
	i32.shr_u	$push56=, $5, $0
	i32.or  	$push192=, $pop57, $pop56
	tee_local	$push191=, $4=, $pop192
	i32.load	$push190=, 0($1)
	tee_local	$push189=, $5=, $pop190
	i32.ne  	$push58=, $pop191, $pop189
	br_if   	27, $pop58      # 27: down to label34
# BB#67:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 8
	br      	47              # 47: up to label14
.LBB0_68:                               #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label61:
	copy_local	$9=, $1
	copy_local	$4=, $7
	i32.const	$push59=, 4
	i32.add 	$push17=, $1, $pop59
	copy_local	$1=, $pop17
# BB#69:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 9
	br      	46              # 46: up to label14
.LBB0_70:                               # %do2.i50
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label60:
	i32.load	$push200=, 4($4)
	tee_local	$push199=, $5=, $pop200
	i32.shl 	$push62=, $pop199, $3
	i32.shr_u	$push61=, $8, $0
	i32.or  	$push198=, $pop62, $pop61
	tee_local	$push197=, $7=, $pop198
	i32.load	$push196=, 0($1)
	tee_local	$push195=, $1=, $pop196
	i32.ne  	$push63=, $pop197, $pop195
	br_if   	27, $pop63      # 27: down to label32
# BB#71:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 13
	br      	45              # 45: up to label14
.LBB0_72:                               # %if.end45.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label59:
	i32.const	$push65=, 8
	i32.add 	$7=, $4, $pop65
	i32.const	$push201=, 8
	i32.add 	$1=, $9, $pop201
	copy_local	$10=, $4
# BB#73:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 14
	br      	44              # 44: up to label14
.LBB0_74:                               # %do1.i56
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label58:
	i32.load	$push207=, 0($7)
	tee_local	$push206=, $4=, $pop207
	i32.shl 	$push47=, $pop206, $3
	i32.shr_u	$push46=, $5, $0
	i32.or  	$push205=, $pop47, $pop46
	tee_local	$push204=, $5=, $pop205
	i32.load	$push203=, 0($1)
	tee_local	$push202=, $1=, $pop203
	i32.ne  	$push48=, $pop204, $pop202
	br_if   	27, $pop48      # 27: down to label30
# BB#75:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 18
	br      	43              # 43: up to label14
.LBB0_76:                               # %if.end54.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label57:
	i32.load	$8=, 12($9)
	i32.load	$5=, 12($10)
	i32.const	$push50=, -4
	i32.add 	$push209=, $2, $pop50
	tee_local	$push208=, $2=, $pop209
	i32.eqz 	$push227=, $pop208
	br_if   	28, $pop227     # 28: down to label28
# BB#77:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 19
	br      	42              # 42: up to label14
.LBB0_78:                               #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label56:
	i32.const	$push51=, 16
	i32.add 	$1=, $9, $pop51
	i32.const	$push210=, 16
	i32.add 	$7=, $10, $pop210
	br      	19              # 19: down to label36
.LBB0_79:                               # %if.then.i24
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label55:
	i32.store	8($6), $8
	i32.store	12($6), $4
	i32.const	$push131=, 8
	i32.add 	$push132=, $6, $pop131
	copy_local	$1=, $pop132
	i32.const	$push133=, 12
	i32.add 	$push134=, $6, $pop133
	copy_local	$6=, $pop134
# BB#80:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 2
	br      	40              # 40: up to label14
.LBB0_81:                               # %do.body.i.i30
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label54:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($6)
	i32.const	$push212=, 1
	i32.add 	$push16=, $1, $pop212
	copy_local	$1=, $pop16
	i32.const	$push211=, 1
	i32.add 	$push15=, $6, $pop211
	copy_local	$6=, $pop15
	i32.eq  	$push55=, $2, $0
	br_if   	18, $pop55      # 18: down to label35
# BB#82:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 3
	br      	39              # 39: up to label14
.LBB0_83:                               # %mymemcmp1.exit.i34
	end_block                       # label53:
	i32.sub 	$push98=, $2, $0
	return  	$pop98
.LBB0_84:                               # %if.then34.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label52:
	i32.store	8($6), $5
	i32.store	12($6), $4
	i32.const	$push143=, 8
	i32.add 	$push144=, $6, $pop143
	copy_local	$1=, $pop144
	i32.const	$push145=, 12
	i32.add 	$push146=, $6, $pop145
	copy_local	$6=, $pop146
# BB#85:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 6
	br      	37              # 37: up to label14
.LBB0_86:                               # %do.body.i194.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label51:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($6)
	i32.const	$push214=, 1
	i32.add 	$push19=, $1, $pop214
	copy_local	$1=, $pop19
	i32.const	$push213=, 1
	i32.add 	$push18=, $6, $pop213
	copy_local	$6=, $pop18
	i32.eq  	$push60=, $2, $0
	br_if   	17, $pop60      # 17: down to label33
# BB#87:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 7
	br      	36              # 36: up to label14
.LBB0_88:                               # %mymemcmp1.exit198.i
	end_block                       # label50:
	i32.sub 	$push97=, $2, $0
	return  	$pop97
.LBB0_89:                               # %if.then43.i51
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label49:
	i32.store	8($6), $1
	i32.store	12($6), $7
	i32.const	$push139=, 8
	i32.add 	$push140=, $6, $pop139
	copy_local	$1=, $pop140
	i32.const	$push141=, 12
	i32.add 	$push142=, $6, $pop141
	copy_local	$6=, $pop142
# BB#90:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 11
	br      	34              # 34: up to label14
.LBB0_91:                               # %do.body.i182.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label48:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($6)
	i32.const	$push216=, 1
	i32.add 	$push21=, $1, $pop216
	copy_local	$1=, $pop21
	i32.const	$push215=, 1
	i32.add 	$push20=, $6, $pop215
	copy_local	$6=, $pop20
	i32.eq  	$push64=, $2, $0
	br_if   	16, $pop64      # 16: down to label31
# BB#92:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 12
	br      	33              # 33: up to label14
.LBB0_93:                               # %mymemcmp1.exit186.i
	end_block                       # label47:
	i32.sub 	$push96=, $2, $0
	return  	$pop96
.LBB0_94:                               # %if.then52.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label46:
	i32.store	8($6), $1
	i32.store	12($6), $5
	i32.const	$push135=, 8
	i32.add 	$push136=, $6, $pop135
	copy_local	$1=, $pop136
	i32.const	$push137=, 12
	i32.add 	$push138=, $6, $pop137
	copy_local	$6=, $pop138
# BB#95:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 16
	br      	31              # 31: up to label14
.LBB0_96:                               # %do.body.i170.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label45:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($6)
	i32.const	$push218=, 1
	i32.add 	$push23=, $1, $pop218
	copy_local	$1=, $pop23
	i32.const	$push217=, 1
	i32.add 	$push22=, $6, $pop217
	copy_local	$6=, $pop22
	i32.eq  	$push49=, $2, $0
	br_if   	15, $pop49      # 15: down to label29
# BB#97:                                #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 17
	br      	30              # 30: up to label14
.LBB0_98:                               # %mymemcmp1.exit174.i
	end_block                       # label44:
	i32.sub 	$push95=, $2, $0
	return  	$pop95
.LBB0_99:                               # %do0.i57
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label43:
	i32.const	$1=, 0
	i32.shl 	$push67=, $5, $3
	i32.shr_u	$push66=, $4, $0
	i32.or  	$push220=, $pop67, $pop66
	tee_local	$push219=, $0=, $pop220
	i32.eq  	$push68=, $pop219, $8
	br_if   	15, $pop68      # 15: down to label27
# BB#100:                               #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 21
	br      	28              # 28: up to label14
.LBB0_101:                              # %if.then63.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label42:
	i32.store	8($6), $8
	i32.store	12($6), $0
	i32.const	$push127=, 8
	i32.add 	$push128=, $6, $pop127
	copy_local	$1=, $pop128
	i32.const	$push129=, 12
	i32.add 	$push130=, $6, $pop129
	copy_local	$6=, $pop130
# BB#102:                               #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 22
	br      	27              # 27: up to label14
.LBB0_103:                              # %do.body.i158.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label41:
	i32.load8_u	$0=, 0($1)
	i32.load8_u	$2=, 0($6)
	i32.const	$push222=, 1
	i32.add 	$push25=, $1, $pop222
	copy_local	$1=, $pop25
	i32.const	$push221=, 1
	i32.add 	$push24=, $6, $pop221
	copy_local	$6=, $pop24
	i32.eq  	$push69=, $2, $0
	br_if   	14, $pop69      # 14: down to label26
# BB#104:                               #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 23
	br      	26              # 26: up to label14
.LBB0_105:                              # %mymemcmp1.exit162.i
                                        #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label40:
	i32.sub 	$1=, $2, $0
# BB#106:                               #   in Loop: Header=BB0_23 Depth=1
	i32.const	$11=, 24
	br      	25              # 25: up to label14
.LBB0_107:                              # %cleanup
	end_block                       # label39:
	return  	$1
.LBB0_108:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label38:
	i32.const	$11=, 29
	br      	23              # 23: up to label14
.LBB0_109:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label37:
	i32.const	$11=, 1
	br      	22              # 22: up to label14
.LBB0_110:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label36:
	i32.const	$11=, 0
	br      	21              # 21: up to label14
.LBB0_111:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label35:
	i32.const	$11=, 2
	br      	20              # 20: up to label14
.LBB0_112:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label34:
	i32.const	$11=, 5
	br      	19              # 19: up to label14
.LBB0_113:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label33:
	i32.const	$11=, 6
	br      	18              # 18: up to label14
.LBB0_114:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label32:
	i32.const	$11=, 10
	br      	17              # 17: up to label14
.LBB0_115:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label31:
	i32.const	$11=, 11
	br      	16              # 16: up to label14
.LBB0_116:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label30:
	i32.const	$11=, 15
	br      	15              # 15: up to label14
.LBB0_117:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label29:
	i32.const	$11=, 16
	br      	14              # 14: up to label14
.LBB0_118:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label28:
	i32.const	$11=, 20
	br      	13              # 13: up to label14
.LBB0_119:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label27:
	i32.const	$11=, 24
	br      	12              # 12: up to label14
.LBB0_120:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label26:
	i32.const	$11=, 22
	br      	11              # 11: up to label14
.LBB0_121:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label25:
	i32.const	$11=, 24
	br      	10              # 10: up to label14
.LBB0_122:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label24:
	i32.const	$11=, 44
	br      	9               # 9: up to label14
.LBB0_123:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label23:
	i32.const	$11=, 27
	br      	8               # 8: up to label14
.LBB0_124:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label22:
	i32.const	$11=, 30
	br      	7               # 7: up to label14
.LBB0_125:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label21:
	i32.const	$11=, 31
	br      	6               # 6: up to label14
.LBB0_126:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label20:
	i32.const	$11=, 35
	br      	5               # 5: up to label14
.LBB0_127:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label19:
	i32.const	$11=, 36
	br      	4               # 4: up to label14
.LBB0_128:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label18:
	i32.const	$11=, 39
	br      	3               # 3: up to label14
.LBB0_129:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label17:
	i32.const	$11=, 40
	br      	2               # 2: up to label14
.LBB0_130:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label16:
	i32.const	$11=, 41
	br      	1               # 1: up to label14
.LBB0_131:                              #   in Loop: Header=BB0_23 Depth=1
	end_block                       # label15:
	i32.const	$11=, 46
	br      	0               # 0: up to label14
.LBB0_132:
	end_loop
	.endfunc
.Lfunc_end0:
	.size	mymemcmp, .Lfunc_end0-mymemcmp
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i64.load	$push0=, .L.str+7($pop16):p2align=0
	i64.store	buf+32($pop17):p2align=0, $pop0
	i32.const	$push15=, 0
	i32.const	$push14=, 0
	i64.load	$push1=, .L.str($pop14):p2align=0
	i64.store	buf+25($pop15):p2align=0, $pop1
	i32.const	$push13=, 0
	i32.const	$push12=, 0
	i64.load	$push2=, .L.str.1($pop12):p2align=0
	i64.store	buf+168($pop13), $pop2
	i32.const	$push11=, 0
	i32.const	$push10=, 0
	i64.load	$push3=, .L.str.1+7($pop10):p2align=0
	i64.store	buf+175($pop11):p2align=0, $pop3
	block   	
	i32.const	$push6=, buf+25
	i32.const	$push5=, buf+168
	i32.const	$push4=, 33
	i32.call	$push7=, mymemcmp@FUNCTION, $pop6, $pop5, $pop4
	i32.const	$push8=, -51
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label87
# BB#1:                                 # %cleanup
	i32.const	$push18=, 0
	return  	$pop18
.LBB1_2:                                # %if.then26
	end_block                       # label87:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
