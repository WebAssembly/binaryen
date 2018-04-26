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
# %bb.0:                                # %entry
	i32.const	$push104=, 0
	i32.load	$push103=, __stack_pointer($pop104)
	i32.const	$push105=, 16
	i32.sub 	$10=, $pop103, $pop105
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
	i32.const	$push146=, 3
	i32.and 	$push27=, $0, $pop146
	i32.eqz 	$push178=, $pop27
	br_if   	0, $pop178      # 0: down to label14
# %bb.1:                                # %if.else
	i32.const	$push148=, 3
	i32.and 	$8=, $2, $pop148
	i32.const	$push28=, -4
	i32.and 	$4=, $0, $pop28
	i32.const	$push147=, 3
	i32.shl 	$push29=, $0, $pop147
	i32.const	$push30=, 24
	i32.and 	$0=, $pop29, $pop30
	i32.const	$push31=, 32
	i32.sub 	$3=, $pop31, $0
	i32.eqz 	$push179=, $8
	br_if   	1, $pop179      # 1: down to label13
# %bb.2:                                # %if.else
	i32.const	$push32=, 1
	i32.eq  	$push33=, $8, $pop32
	br_if   	2, $pop33       # 2: down to label12
# %bb.3:                                # %if.else
	i32.const	$push34=, 3
	i32.ne  	$push35=, $8, $pop34
	br_if   	3, $pop35       # 3: down to label11
# %bb.4:                                # %sw.bb6.i
	i32.const	$push40=, 1
	i32.add 	$2=, $2, $pop40
	i32.const	$push41=, -4
	i32.add 	$8=, $1, $pop41
	i32.load	$7=, 0($4)
	br      	8               # 8: down to label6
.LBB0_5:                                # %if.then
	end_block                       # label14:
	i32.const	$push149=, 3
	i32.and 	$4=, $2, $pop149
	i32.eqz 	$push180=, $4
	br_if   	10, $pop180     # 10: down to label3
# %bb.6:                                # %if.then
	i32.const	$push70=, 1
	i32.eq  	$push71=, $4, $pop70
	br_if   	3, $pop71       # 3: down to label10
# %bb.7:                                # %if.then
	i32.const	$push72=, 3
	i32.ne  	$push73=, $4, $pop72
	br_if   	4, $pop73       # 4: down to label9
# %bb.8:                                # %sw.bb3.i
	i32.const	$push76=, 1
	i32.add 	$2=, $2, $pop76
	i32.const	$push77=, -4
	i32.add 	$4=, $1, $pop77
	i32.const	$push150=, -4
	i32.add 	$3=, $0, $pop150
	br      	11              # 11: down to label2
.LBB0_9:                                # %sw.bb12.i18
	end_block                       # label13:
	i32.const	$push39=, 4
	i32.add 	$6=, $4, $pop39
	i32.load	$9=, 0($4)
	br      	5               # 5: down to label7
.LBB0_10:                               # %sw.bb17.i
	end_block                       # label12:
	i32.const	$push36=, -1
	i32.add 	$2=, $2, $pop36
	i32.const	$push38=, 8
	i32.add 	$6=, $4, $pop38
	i32.load	$5=, 0($1)
	i32.load	$9=, 4($4)
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
	i32.add 	$7=, $4, $pop44
	i32.const	$push45=, 4
	i32.add 	$6=, $4, $pop45
	i32.load	$9=, 0($4)
	br      	5               # 5: down to label5
.LBB0_12:                               # %sw.bb12.i
	end_block                       # label10:
	i32.const	$push74=, -1
	i32.add 	$2=, $2, $pop74
	i32.load	$8=, 0($1)
	i32.load	$7=, 0($0)
	i32.const	$push75=, 4
	i32.add 	$push0=, $0, $pop75
	copy_local	$0=, $pop0
	i32.const	$push151=, 4
	i32.add 	$push1=, $1, $pop151
	copy_local	$1=, $pop1
	br      	5               # 5: down to label4
.LBB0_13:                               # %sw.bb.i
	end_block                       # label9:
	i32.const	$push78=, 2
	i32.add 	$2=, $2, $pop78
	i32.const	$push79=, -8
	i32.add 	$4=, $1, $pop79
	i32.const	$push152=, -8
	i32.add 	$3=, $0, $pop152
	br      	7               # 7: down to label1
.LBB0_14:
	end_block                       # label8:
	i32.const	$11=, 0
	br      	7               # 7: down to label0
.LBB0_15:
	end_block                       # label7:
	i32.const	$11=, 4
	br      	6               # 6: down to label0
.LBB0_16:
	end_block                       # label6:
	i32.const	$11=, 9
	br      	5               # 5: down to label0
.LBB0_17:
	end_block                       # label5:
	i32.const	$11=, 14
	br      	4               # 4: down to label0
.LBB0_18:
	end_block                       # label4:
	i32.const	$11=, 25
	br      	3               # 3: down to label0
.LBB0_19:
	end_block                       # label3:
	i32.const	$11=, 29
	br      	2               # 2: down to label0
.LBB0_20:
	end_block                       # label2:
	i32.const	$11=, 34
	br      	1               # 1: down to label0
.LBB0_21:
	end_block                       # label1:
	i32.const	$11=, 39
.LBB0_22:                               # =>This Inner Loop Header: Depth=1
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
	block   	
	br_table 	$11, 24, 32, 33, 34, 25, 35, 36, 37, 26, 27, 38, 39, 40, 28, 29, 41, 42, 43, 30, 31, 44, 45, 46, 47, 48, 0, 8, 9, 10, 1, 11, 12, 13, 2, 3, 14, 15, 16, 4, 5, 17, 18, 19, 6, 7, 20, 21, 22, 23, 23 # 24: down to label64
                                        # 32: down to label56
                                        # 33: down to label55
                                        # 34: down to label54
                                        # 25: down to label63
                                        # 35: down to label53
                                        # 36: down to label52
                                        # 37: down to label51
                                        # 26: down to label62
                                        # 27: down to label61
                                        # 38: down to label50
                                        # 39: down to label49
                                        # 40: down to label48
                                        # 28: down to label60
                                        # 29: down to label59
                                        # 41: down to label47
                                        # 42: down to label46
                                        # 43: down to label45
                                        # 30: down to label58
                                        # 31: down to label57
                                        # 44: down to label44
                                        # 45: down to label43
                                        # 46: down to label42
                                        # 47: down to label41
                                        # 48: down to label40
                                        # 0: down to label88
                                        # 8: down to label80
                                        # 9: down to label79
                                        # 10: down to label78
                                        # 1: down to label87
                                        # 11: down to label77
                                        # 12: down to label76
                                        # 13: down to label75
                                        # 2: down to label86
                                        # 3: down to label85
                                        # 14: down to label74
                                        # 15: down to label73
                                        # 16: down to label72
                                        # 4: down to label84
                                        # 5: down to label83
                                        # 17: down to label71
                                        # 18: down to label70
                                        # 19: down to label69
                                        # 6: down to label82
                                        # 7: down to label81
                                        # 20: down to label68
                                        # 21: down to label67
                                        # 22: down to label66
                                        # 23: down to label65
.LBB0_23:                               # %do.body.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label88:
	i32.ne  	$push84=, $7, $8
	br_if   	48, $pop84      # 48: down to label39
# %bb.24:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 29
	br      	72              # 72: up to label15
.LBB0_25:                               # %do3.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label87:
	i32.load	$4=, 0($1)
	i32.load	$3=, 0($0)
	i32.ne  	$push87=, $3, $4
	br_if   	63, $pop87      # 63: down to label23
# %bb.26:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 33
	br      	71              # 71: up to label15
.LBB0_27:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label86:
	copy_local	$3=, $0
	copy_local	$4=, $1
	i32.const	$push86=, 4
	i32.add 	$push4=, $0, $pop86
	copy_local	$0=, $pop4
	i32.const	$push153=, 4
	i32.add 	$push5=, $1, $pop153
	copy_local	$1=, $pop5
# %bb.28:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 34
	br      	70              # 70: up to label15
.LBB0_29:                               # %do2.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label85:
	i32.load	$1=, 0($1)
	i32.load	$0=, 0($0)
	i32.ne  	$push89=, $0, $1
	br_if   	63, $pop89      # 63: down to label21
# %bb.30:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 38
	br      	69              # 69: up to label15
.LBB0_31:                               # %if.end31.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label84:
	i32.const	$push91=, 8
	i32.add 	$0=, $3, $pop91
	i32.const	$push154=, 8
	i32.add 	$1=, $4, $pop154
# %bb.32:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 39
	br      	68              # 68: up to label15
.LBB0_33:                               # %do1.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label83:
	i32.load	$1=, 0($1)
	i32.load	$0=, 0($0)
	i32.ne  	$push80=, $0, $1
	br_if   	63, $pop80      # 63: down to label19
# %bb.34:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 43
	br      	67              # 67: up to label15
.LBB0_35:                               # %if.end37.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label82:
	i32.load	$8=, 12($4)
	i32.load	$7=, 12($3)
	i32.const	$push82=, -4
	i32.add 	$2=, $2, $pop82
	i32.eqz 	$push181=, $2
	br_if   	64, $pop181     # 64: down to label17
# %bb.36:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 44
	br      	66              # 66: up to label15
.LBB0_37:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label81:
	i32.const	$push83=, 16
	i32.add 	$1=, $4, $pop83
	i32.const	$push155=, 16
	i32.add 	$0=, $3, $pop155
	br      	55              # 55: down to label25
.LBB0_38:                               # %if.then.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label80:
	i32.store	8($10), $8
	i32.store	12($10), $7
	i32.const	$push110=, 8
	i32.add 	$push111=, $10, $pop110
	copy_local	$1=, $pop111
	i32.const	$push112=, 12
	i32.add 	$push113=, $10, $pop112
	copy_local	$0=, $pop113
# %bb.39:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 27
	br      	64              # 64: up to label15
.LBB0_40:                               # %do.body.i.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label79:
	i32.load8_u	$2=, 0($1)
	i32.load8_u	$4=, 0($0)
	i32.const	$push157=, 1
	i32.add 	$push3=, $1, $pop157
	copy_local	$1=, $pop3
	i32.const	$push156=, 1
	i32.add 	$push2=, $0, $pop156
	copy_local	$0=, $pop2
	i32.eq  	$push85=, $4, $2
	br_if   	54, $pop85      # 54: down to label24
# %bb.41:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 28
	br      	63              # 63: up to label15
.LBB0_42:                               # %mymemcmp1.exit.i
	end_block                       # label78:
	i32.sub 	$push102=, $4, $2
	return  	$pop102
.LBB0_43:                               # %if.then23.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label77:
	i32.store	8($10), $4
	i32.store	12($10), $3
	i32.const	$push122=, 8
	i32.add 	$push123=, $10, $pop122
	copy_local	$1=, $pop123
	i32.const	$push124=, 12
	i32.add 	$push125=, $10, $pop124
	copy_local	$0=, $pop125
# %bb.44:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 31
	br      	61              # 61: up to label15
.LBB0_45:                               # %do.body.i140.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label76:
	i32.load8_u	$2=, 0($1)
	i32.load8_u	$4=, 0($0)
	i32.const	$push159=, 1
	i32.add 	$push7=, $1, $pop159
	copy_local	$1=, $pop7
	i32.const	$push158=, 1
	i32.add 	$push6=, $0, $pop158
	copy_local	$0=, $pop6
	i32.eq  	$push88=, $4, $2
	br_if   	53, $pop88      # 53: down to label22
# %bb.46:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 32
	br      	60              # 60: up to label15
.LBB0_47:                               # %mymemcmp1.exit144.i
	end_block                       # label75:
	i32.sub 	$push101=, $4, $2
	return  	$pop101
.LBB0_48:                               # %if.then29.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label74:
	i32.store	8($10), $1
	i32.store	12($10), $0
	i32.const	$push118=, 8
	i32.add 	$push119=, $10, $pop118
	copy_local	$1=, $pop119
	i32.const	$push120=, 12
	i32.add 	$push121=, $10, $pop120
	copy_local	$0=, $pop121
# %bb.49:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 36
	br      	58              # 58: up to label15
.LBB0_50:                               # %do.body.i128.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label73:
	i32.load8_u	$2=, 0($1)
	i32.load8_u	$4=, 0($0)
	i32.const	$push161=, 1
	i32.add 	$push9=, $1, $pop161
	copy_local	$1=, $pop9
	i32.const	$push160=, 1
	i32.add 	$push8=, $0, $pop160
	copy_local	$0=, $pop8
	i32.eq  	$push90=, $4, $2
	br_if   	52, $pop90      # 52: down to label20
# %bb.51:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 37
	br      	57              # 57: up to label15
.LBB0_52:                               # %mymemcmp1.exit132.i
	end_block                       # label72:
	i32.sub 	$push100=, $4, $2
	return  	$pop100
.LBB0_53:                               # %if.then35.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label71:
	i32.store	8($10), $1
	i32.store	12($10), $0
	i32.const	$push114=, 8
	i32.add 	$push115=, $10, $pop114
	copy_local	$1=, $pop115
	i32.const	$push116=, 12
	i32.add 	$push117=, $10, $pop116
	copy_local	$0=, $pop117
# %bb.54:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 41
	br      	55              # 55: up to label15
.LBB0_55:                               # %do.body.i116.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label70:
	i32.load8_u	$2=, 0($1)
	i32.load8_u	$4=, 0($0)
	i32.const	$push163=, 1
	i32.add 	$push11=, $1, $pop163
	copy_local	$1=, $pop11
	i32.const	$push162=, 1
	i32.add 	$push10=, $0, $pop162
	copy_local	$0=, $pop10
	i32.eq  	$push81=, $4, $2
	br_if   	51, $pop81      # 51: down to label18
# %bb.56:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 42
	br      	54              # 54: up to label15
.LBB0_57:                               # %mymemcmp1.exit120.i
	end_block                       # label69:
	i32.sub 	$push99=, $4, $2
	return  	$pop99
.LBB0_58:                               # %do0.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label68:
	i32.const	$1=, 0
	i32.eq  	$push92=, $7, $8
	br_if   	41, $pop92      # 41: down to label26
# %bb.59:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 46
	br      	52              # 52: up to label15
.LBB0_60:                               # %if.then43.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label67:
	i32.store	8($10), $8
	i32.store	12($10), $7
	i32.const	$push106=, 8
	i32.add 	$push107=, $10, $pop106
	copy_local	$1=, $pop107
	i32.const	$push108=, 12
	i32.add 	$push109=, $10, $pop108
	copy_local	$0=, $pop109
# %bb.61:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 47
	br      	51              # 51: up to label15
.LBB0_62:                               # %do.body.i104.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label66:
	i32.load8_u	$2=, 0($1)
	i32.load8_u	$4=, 0($0)
	i32.const	$push165=, 1
	i32.add 	$push13=, $1, $pop165
	copy_local	$1=, $pop13
	i32.const	$push164=, 1
	i32.add 	$push12=, $0, $pop164
	copy_local	$0=, $pop12
	i32.eq  	$push93=, $4, $2
	br_if   	49, $pop93      # 49: down to label16
# %bb.63:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 48
	br      	50              # 50: up to label15
.LBB0_64:                               # %mymemcmp1.exit108.i
	end_block                       # label65:
	i32.sub 	$push98=, $4, $2
	return  	$pop98
.LBB0_65:                               # %do.body.i23
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label64:
	i32.shl 	$push53=, $9, $3
	i32.shr_u	$push52=, $4, $0
	i32.or  	$4=, $pop53, $pop52
	i32.ne  	$push54=, $4, $5
	br_if   	25, $pop54      # 25: down to label38
# %bb.66:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 4
	br      	48              # 48: up to label15
.LBB0_67:                               # %do3.i42
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label63:
	i32.load	$7=, 0($6)
	i32.shl 	$push57=, $7, $3
	i32.shr_u	$push56=, $9, $0
	i32.or  	$4=, $pop57, $pop56
	i32.load	$8=, 0($1)
	i32.ne  	$push58=, $4, $8
	br_if   	27, $pop58      # 27: down to label35
# %bb.68:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 8
	br      	47              # 47: up to label15
.LBB0_69:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label62:
	copy_local	$8=, $1
	copy_local	$4=, $6
	i32.const	$push59=, 4
	i32.add 	$push17=, $1, $pop59
	copy_local	$1=, $pop17
# %bb.70:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 9
	br      	46              # 46: up to label15
.LBB0_71:                               # %do2.i50
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label61:
	i32.load	$9=, 4($4)
	i32.shl 	$push62=, $9, $3
	i32.shr_u	$push61=, $7, $0
	i32.or  	$7=, $pop62, $pop61
	i32.load	$1=, 0($1)
	i32.ne  	$push63=, $7, $1
	br_if   	27, $pop63      # 27: down to label33
# %bb.72:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 13
	br      	45              # 45: up to label15
.LBB0_73:                               # %if.end45.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label60:
	i32.const	$push65=, 8
	i32.add 	$6=, $4, $pop65
	i32.const	$push166=, 8
	i32.add 	$1=, $8, $pop166
	copy_local	$7=, $4
# %bb.74:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 14
	br      	44              # 44: up to label15
.LBB0_75:                               # %do1.i56
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label59:
	i32.load	$4=, 0($6)
	i32.shl 	$push47=, $4, $3
	i32.shr_u	$push46=, $9, $0
	i32.or  	$9=, $pop47, $pop46
	i32.load	$1=, 0($1)
	i32.ne  	$push48=, $9, $1
	br_if   	27, $pop48      # 27: down to label31
# %bb.76:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 18
	br      	43              # 43: up to label15
.LBB0_77:                               # %if.end54.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label58:
	i32.load	$5=, 12($8)
	i32.load	$9=, 12($7)
	i32.const	$push50=, -4
	i32.add 	$2=, $2, $pop50
	i32.eqz 	$push182=, $2
	br_if   	28, $pop182     # 28: down to label29
# %bb.78:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 19
	br      	42              # 42: up to label15
.LBB0_79:                               #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label57:
	i32.const	$push51=, 16
	i32.add 	$1=, $8, $pop51
	i32.const	$push167=, 16
	i32.add 	$6=, $7, $pop167
	br      	19              # 19: down to label37
.LBB0_80:                               # %if.then.i24
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label56:
	i32.store	8($10), $5
	i32.store	12($10), $4
	i32.const	$push130=, 8
	i32.add 	$push131=, $10, $pop130
	copy_local	$1=, $pop131
	i32.const	$push132=, 12
	i32.add 	$push133=, $10, $pop132
	copy_local	$0=, $pop133
# %bb.81:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 2
	br      	40              # 40: up to label15
.LBB0_82:                               # %do.body.i.i30
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label55:
	i32.load8_u	$2=, 0($1)
	i32.load8_u	$4=, 0($0)
	i32.const	$push169=, 1
	i32.add 	$push16=, $1, $pop169
	copy_local	$1=, $pop16
	i32.const	$push168=, 1
	i32.add 	$push15=, $0, $pop168
	copy_local	$0=, $pop15
	i32.eq  	$push55=, $4, $2
	br_if   	18, $pop55      # 18: down to label36
# %bb.83:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 3
	br      	39              # 39: up to label15
.LBB0_84:                               # %mymemcmp1.exit.i34
	end_block                       # label54:
	i32.sub 	$push97=, $4, $2
	return  	$pop97
.LBB0_85:                               # %if.then34.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label53:
	i32.store	8($10), $8
	i32.store	12($10), $4
	i32.const	$push142=, 8
	i32.add 	$push143=, $10, $pop142
	copy_local	$1=, $pop143
	i32.const	$push144=, 12
	i32.add 	$push145=, $10, $pop144
	copy_local	$0=, $pop145
# %bb.86:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 6
	br      	37              # 37: up to label15
.LBB0_87:                               # %do.body.i194.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label52:
	i32.load8_u	$2=, 0($1)
	i32.load8_u	$4=, 0($0)
	i32.const	$push171=, 1
	i32.add 	$push19=, $1, $pop171
	copy_local	$1=, $pop19
	i32.const	$push170=, 1
	i32.add 	$push18=, $0, $pop170
	copy_local	$0=, $pop18
	i32.eq  	$push60=, $4, $2
	br_if   	17, $pop60      # 17: down to label34
# %bb.88:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 7
	br      	36              # 36: up to label15
.LBB0_89:                               # %mymemcmp1.exit198.i
	end_block                       # label51:
	i32.sub 	$push96=, $4, $2
	return  	$pop96
.LBB0_90:                               # %if.then43.i51
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label50:
	i32.store	8($10), $1
	i32.store	12($10), $7
	i32.const	$push138=, 8
	i32.add 	$push139=, $10, $pop138
	copy_local	$1=, $pop139
	i32.const	$push140=, 12
	i32.add 	$push141=, $10, $pop140
	copy_local	$0=, $pop141
# %bb.91:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 11
	br      	34              # 34: up to label15
.LBB0_92:                               # %do.body.i182.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label49:
	i32.load8_u	$2=, 0($1)
	i32.load8_u	$4=, 0($0)
	i32.const	$push173=, 1
	i32.add 	$push21=, $1, $pop173
	copy_local	$1=, $pop21
	i32.const	$push172=, 1
	i32.add 	$push20=, $0, $pop172
	copy_local	$0=, $pop20
	i32.eq  	$push64=, $4, $2
	br_if   	16, $pop64      # 16: down to label32
# %bb.93:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 12
	br      	33              # 33: up to label15
.LBB0_94:                               # %mymemcmp1.exit186.i
	end_block                       # label48:
	i32.sub 	$push95=, $4, $2
	return  	$pop95
.LBB0_95:                               # %if.then52.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label47:
	i32.store	8($10), $1
	i32.store	12($10), $9
	i32.const	$push134=, 8
	i32.add 	$push135=, $10, $pop134
	copy_local	$1=, $pop135
	i32.const	$push136=, 12
	i32.add 	$push137=, $10, $pop136
	copy_local	$0=, $pop137
# %bb.96:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 16
	br      	31              # 31: up to label15
.LBB0_97:                               # %do.body.i170.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label46:
	i32.load8_u	$2=, 0($1)
	i32.load8_u	$4=, 0($0)
	i32.const	$push175=, 1
	i32.add 	$push23=, $1, $pop175
	copy_local	$1=, $pop23
	i32.const	$push174=, 1
	i32.add 	$push22=, $0, $pop174
	copy_local	$0=, $pop22
	i32.eq  	$push49=, $4, $2
	br_if   	15, $pop49      # 15: down to label30
# %bb.98:                               #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 17
	br      	30              # 30: up to label15
.LBB0_99:                               # %mymemcmp1.exit174.i
	end_block                       # label45:
	i32.sub 	$push94=, $4, $2
	return  	$pop94
.LBB0_100:                              # %do0.i57
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label44:
	i32.shl 	$push67=, $9, $3
	i32.shr_u	$push66=, $4, $0
	i32.or  	$0=, $pop67, $pop66
	i32.const	$1=, 0
	i32.eq  	$push68=, $0, $5
	br_if   	15, $pop68      # 15: down to label28
# %bb.101:                              #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 21
	br      	28              # 28: up to label15
.LBB0_102:                              # %if.then63.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label43:
	i32.store	8($10), $5
	i32.store	12($10), $0
	i32.const	$push126=, 8
	i32.add 	$push127=, $10, $pop126
	copy_local	$1=, $pop127
	i32.const	$push128=, 12
	i32.add 	$push129=, $10, $pop128
	copy_local	$0=, $pop129
# %bb.103:                              #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 22
	br      	27              # 27: up to label15
.LBB0_104:                              # %do.body.i158.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label42:
	i32.load8_u	$2=, 0($1)
	i32.load8_u	$4=, 0($0)
	i32.const	$push177=, 1
	i32.add 	$push25=, $1, $pop177
	copy_local	$1=, $pop25
	i32.const	$push176=, 1
	i32.add 	$push24=, $0, $pop176
	copy_local	$0=, $pop24
	i32.eq  	$push69=, $4, $2
	br_if   	14, $pop69      # 14: down to label27
# %bb.105:                              #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 23
	br      	26              # 26: up to label15
.LBB0_106:                              # %mymemcmp1.exit162.i
                                        #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label41:
	i32.sub 	$1=, $4, $2
# %bb.107:                              #   in Loop: Header=BB0_22 Depth=1
	i32.const	$11=, 24
	br      	25              # 25: up to label15
.LBB0_108:                              # %cleanup
	end_block                       # label40:
	return  	$1
.LBB0_109:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label39:
	i32.const	$11=, 26
	br      	23              # 23: up to label15
.LBB0_110:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label38:
	i32.const	$11=, 1
	br      	22              # 22: up to label15
.LBB0_111:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label37:
	i32.const	$11=, 0
	br      	21              # 21: up to label15
.LBB0_112:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label36:
	i32.const	$11=, 2
	br      	20              # 20: up to label15
.LBB0_113:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label35:
	i32.const	$11=, 5
	br      	19              # 19: up to label15
.LBB0_114:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label34:
	i32.const	$11=, 6
	br      	18              # 18: up to label15
.LBB0_115:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label33:
	i32.const	$11=, 10
	br      	17              # 17: up to label15
.LBB0_116:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label32:
	i32.const	$11=, 11
	br      	16              # 16: up to label15
.LBB0_117:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label31:
	i32.const	$11=, 15
	br      	15              # 15: up to label15
.LBB0_118:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label30:
	i32.const	$11=, 16
	br      	14              # 14: up to label15
.LBB0_119:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label29:
	i32.const	$11=, 20
	br      	13              # 13: up to label15
.LBB0_120:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label28:
	i32.const	$11=, 24
	br      	12              # 12: up to label15
.LBB0_121:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label27:
	i32.const	$11=, 22
	br      	11              # 11: up to label15
.LBB0_122:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label26:
	i32.const	$11=, 24
	br      	10              # 10: up to label15
.LBB0_123:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label25:
	i32.const	$11=, 25
	br      	9               # 9: up to label15
.LBB0_124:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label24:
	i32.const	$11=, 27
	br      	8               # 8: up to label15
.LBB0_125:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label23:
	i32.const	$11=, 30
	br      	7               # 7: up to label15
.LBB0_126:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label22:
	i32.const	$11=, 31
	br      	6               # 6: up to label15
.LBB0_127:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label21:
	i32.const	$11=, 35
	br      	5               # 5: up to label15
.LBB0_128:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label20:
	i32.const	$11=, 36
	br      	4               # 4: up to label15
.LBB0_129:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label19:
	i32.const	$11=, 40
	br      	3               # 3: up to label15
.LBB0_130:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label18:
	i32.const	$11=, 41
	br      	2               # 2: up to label15
.LBB0_131:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label17:
	i32.const	$11=, 45
	br      	1               # 1: up to label15
.LBB0_132:                              #   in Loop: Header=BB0_22 Depth=1
	end_block                       # label16:
	i32.const	$11=, 47
	br      	0               # 0: up to label15
.LBB0_133:
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
# %bb.0:                                # %entry
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
	br_if   	0, $pop9        # 0: down to label89
# %bb.1:                                # %cleanup
	i32.const	$push18=, 0
	return  	$pop18
.LBB1_2:                                # %if.then26
	end_block                       # label89:
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
