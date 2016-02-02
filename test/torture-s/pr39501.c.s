	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr39501.c"
	.section	.text.float_min1,"ax",@progbits
	.hidden	float_min1
	.globl	float_min1
	.type	float_min1,@function
float_min1:                             # @float_min1
	.param  	f32, f32
	.result 	f32
# BB#0:                                 # %entry
	f32.lt  	$push0=, $0, $1
	f32.select	$push1=, $pop0, $0, $1
	return  	$pop1
	.endfunc
.Lfunc_end0:
	.size	float_min1, .Lfunc_end0-float_min1

	.section	.text.float_min2,"ax",@progbits
	.hidden	float_min2
	.globl	float_min2
	.type	float_min2,@function
float_min2:                             # @float_min2
	.param  	f32, f32
	.result 	f32
# BB#0:                                 # %entry
	f32.le  	$push0=, $0, $1
	f32.select	$push1=, $pop0, $0, $1
	return  	$pop1
	.endfunc
.Lfunc_end1:
	.size	float_min2, .Lfunc_end1-float_min2

	.section	.text.float_max1,"ax",@progbits
	.hidden	float_max1
	.globl	float_max1
	.type	float_max1,@function
float_max1:                             # @float_max1
	.param  	f32, f32
	.result 	f32
# BB#0:                                 # %entry
	f32.gt  	$push0=, $0, $1
	f32.select	$push1=, $pop0, $0, $1
	return  	$pop1
	.endfunc
.Lfunc_end2:
	.size	float_max1, .Lfunc_end2-float_max1

	.section	.text.float_max2,"ax",@progbits
	.hidden	float_max2
	.globl	float_max2
	.type	float_max2,@function
float_max2:                             # @float_max2
	.param  	f32, f32
	.result 	f32
# BB#0:                                 # %entry
	f32.ge  	$push0=, $0, $1
	f32.select	$push1=, $pop0, $0, $1
	return  	$pop1
	.endfunc
.Lfunc_end3:
	.size	float_max2, .Lfunc_end3-float_max2

	.section	.text.double_min1,"ax",@progbits
	.hidden	double_min1
	.globl	double_min1
	.type	double_min1,@function
double_min1:                            # @double_min1
	.param  	f64, f64
	.result 	f64
# BB#0:                                 # %entry
	f64.lt  	$push0=, $0, $1
	f64.select	$push1=, $pop0, $0, $1
	return  	$pop1
	.endfunc
.Lfunc_end4:
	.size	double_min1, .Lfunc_end4-double_min1

	.section	.text.double_min2,"ax",@progbits
	.hidden	double_min2
	.globl	double_min2
	.type	double_min2,@function
double_min2:                            # @double_min2
	.param  	f64, f64
	.result 	f64
# BB#0:                                 # %entry
	f64.le  	$push0=, $0, $1
	f64.select	$push1=, $pop0, $0, $1
	return  	$pop1
	.endfunc
.Lfunc_end5:
	.size	double_min2, .Lfunc_end5-double_min2

	.section	.text.double_max1,"ax",@progbits
	.hidden	double_max1
	.globl	double_max1
	.type	double_max1,@function
double_max1:                            # @double_max1
	.param  	f64, f64
	.result 	f64
# BB#0:                                 # %entry
	f64.gt  	$push0=, $0, $1
	f64.select	$push1=, $pop0, $0, $1
	return  	$pop1
	.endfunc
.Lfunc_end6:
	.size	double_max1, .Lfunc_end6-double_max1

	.section	.text.double_max2,"ax",@progbits
	.hidden	double_max2
	.globl	double_max2
	.type	double_max2,@function
double_max2:                            # @double_max2
	.param  	f64, f64
	.result 	f64
# BB#0:                                 # %entry
	f64.ge  	$push0=, $0, $1
	f64.select	$push1=, $pop0, $0, $1
	return  	$pop1
	.endfunc
.Lfunc_end7:
	.size	double_max2, .Lfunc_end7-double_max2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	f32.const	$push99=, 0x0p0
	f32.const	$push98=, -0x1p0
	f32.call	$push0=, float_min1@FUNCTION, $pop99, $pop98
	f32.const	$push97=, -0x1p0
	f32.eq  	$push1=, $pop0, $pop97
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB8_2:                                # %if.end
	end_block                       # label0:
	block
	f32.const	$push102=, -0x1p0
	f32.const	$push101=, 0x0p0
	f32.call	$push2=, float_min1@FUNCTION, $pop102, $pop101
	f32.const	$push100=, -0x1p0
	f32.eq  	$push3=, $pop2, $pop100
	br_if   	$pop3, 0        # 0: down to label1
# BB#3:                                 # %if.then3
	call    	abort@FUNCTION
	unreachable
.LBB8_4:                                # %if.end4
	end_block                       # label1:
	block
	f32.const	$push105=, 0x0p0
	f32.const	$push104=, 0x1p0
	f32.call	$push4=, float_min1@FUNCTION, $pop105, $pop104
	f32.const	$push103=, 0x0p0
	f32.eq  	$push5=, $pop4, $pop103
	br_if   	$pop5, 0        # 0: down to label2
# BB#5:                                 # %if.then7
	call    	abort@FUNCTION
	unreachable
.LBB8_6:                                # %if.end8
	end_block                       # label2:
	block
	f32.const	$push108=, 0x1p0
	f32.const	$push107=, 0x0p0
	f32.call	$push6=, float_min1@FUNCTION, $pop108, $pop107
	f32.const	$push106=, 0x0p0
	f32.eq  	$push7=, $pop6, $pop106
	br_if   	$pop7, 0        # 0: down to label3
# BB#7:                                 # %if.then11
	call    	abort@FUNCTION
	unreachable
.LBB8_8:                                # %if.end12
	end_block                       # label3:
	block
	f32.const	$push111=, -0x1p0
	f32.const	$push110=, 0x1p0
	f32.call	$push8=, float_min1@FUNCTION, $pop111, $pop110
	f32.const	$push109=, -0x1p0
	f32.eq  	$push9=, $pop8, $pop109
	br_if   	$pop9, 0        # 0: down to label4
# BB#9:                                 # %if.then15
	call    	abort@FUNCTION
	unreachable
.LBB8_10:                               # %if.end16
	end_block                       # label4:
	block
	f32.const	$push114=, 0x1p0
	f32.const	$push113=, -0x1p0
	f32.call	$push10=, float_min1@FUNCTION, $pop114, $pop113
	f32.const	$push112=, -0x1p0
	f32.eq  	$push11=, $pop10, $pop112
	br_if   	$pop11, 0       # 0: down to label5
# BB#11:                                # %if.then19
	call    	abort@FUNCTION
	unreachable
.LBB8_12:                               # %if.end20
	end_block                       # label5:
	block
	f32.const	$push117=, 0x0p0
	f32.const	$push116=, -0x1p0
	f32.call	$push12=, float_max1@FUNCTION, $pop117, $pop116
	f32.const	$push115=, 0x0p0
	f32.eq  	$push13=, $pop12, $pop115
	br_if   	$pop13, 0       # 0: down to label6
# BB#13:                                # %if.then23
	call    	abort@FUNCTION
	unreachable
.LBB8_14:                               # %if.end24
	end_block                       # label6:
	block
	f32.const	$push120=, -0x1p0
	f32.const	$push119=, 0x0p0
	f32.call	$push14=, float_max1@FUNCTION, $pop120, $pop119
	f32.const	$push118=, 0x0p0
	f32.eq  	$push15=, $pop14, $pop118
	br_if   	$pop15, 0       # 0: down to label7
# BB#15:                                # %if.then27
	call    	abort@FUNCTION
	unreachable
.LBB8_16:                               # %if.end28
	end_block                       # label7:
	block
	f32.const	$push123=, 0x0p0
	f32.const	$push122=, 0x1p0
	f32.call	$push16=, float_max1@FUNCTION, $pop123, $pop122
	f32.const	$push121=, 0x1p0
	f32.eq  	$push17=, $pop16, $pop121
	br_if   	$pop17, 0       # 0: down to label8
# BB#17:                                # %if.then31
	call    	abort@FUNCTION
	unreachable
.LBB8_18:                               # %if.end32
	end_block                       # label8:
	block
	f32.const	$push126=, 0x1p0
	f32.const	$push125=, 0x0p0
	f32.call	$push18=, float_max1@FUNCTION, $pop126, $pop125
	f32.const	$push124=, 0x1p0
	f32.eq  	$push19=, $pop18, $pop124
	br_if   	$pop19, 0       # 0: down to label9
# BB#19:                                # %if.then35
	call    	abort@FUNCTION
	unreachable
.LBB8_20:                               # %if.end36
	end_block                       # label9:
	block
	f32.const	$push129=, -0x1p0
	f32.const	$push128=, 0x1p0
	f32.call	$push20=, float_max1@FUNCTION, $pop129, $pop128
	f32.const	$push127=, 0x1p0
	f32.eq  	$push21=, $pop20, $pop127
	br_if   	$pop21, 0       # 0: down to label10
# BB#21:                                # %if.then39
	call    	abort@FUNCTION
	unreachable
.LBB8_22:                               # %if.end40
	end_block                       # label10:
	block
	f32.const	$push132=, 0x1p0
	f32.const	$push131=, -0x1p0
	f32.call	$push22=, float_max1@FUNCTION, $pop132, $pop131
	f32.const	$push130=, 0x1p0
	f32.eq  	$push23=, $pop22, $pop130
	br_if   	$pop23, 0       # 0: down to label11
# BB#23:                                # %if.then43
	call    	abort@FUNCTION
	unreachable
.LBB8_24:                               # %if.end44
	end_block                       # label11:
	block
	f32.const	$push135=, 0x0p0
	f32.const	$push134=, -0x1p0
	f32.call	$push24=, float_min2@FUNCTION, $pop135, $pop134
	f32.const	$push133=, -0x1p0
	f32.eq  	$push25=, $pop24, $pop133
	br_if   	$pop25, 0       # 0: down to label12
# BB#25:                                # %if.then47
	call    	abort@FUNCTION
	unreachable
.LBB8_26:                               # %if.end48
	end_block                       # label12:
	block
	f32.const	$push138=, -0x1p0
	f32.const	$push137=, 0x0p0
	f32.call	$push26=, float_min2@FUNCTION, $pop138, $pop137
	f32.const	$push136=, -0x1p0
	f32.eq  	$push27=, $pop26, $pop136
	br_if   	$pop27, 0       # 0: down to label13
# BB#27:                                # %if.then51
	call    	abort@FUNCTION
	unreachable
.LBB8_28:                               # %if.end52
	end_block                       # label13:
	block
	f32.const	$push141=, 0x0p0
	f32.const	$push140=, 0x1p0
	f32.call	$push28=, float_min2@FUNCTION, $pop141, $pop140
	f32.const	$push139=, 0x0p0
	f32.eq  	$push29=, $pop28, $pop139
	br_if   	$pop29, 0       # 0: down to label14
# BB#29:                                # %if.then55
	call    	abort@FUNCTION
	unreachable
.LBB8_30:                               # %if.end56
	end_block                       # label14:
	block
	f32.const	$push144=, 0x1p0
	f32.const	$push143=, 0x0p0
	f32.call	$push30=, float_min2@FUNCTION, $pop144, $pop143
	f32.const	$push142=, 0x0p0
	f32.eq  	$push31=, $pop30, $pop142
	br_if   	$pop31, 0       # 0: down to label15
# BB#31:                                # %if.then59
	call    	abort@FUNCTION
	unreachable
.LBB8_32:                               # %if.end60
	end_block                       # label15:
	block
	f32.const	$push147=, -0x1p0
	f32.const	$push146=, 0x1p0
	f32.call	$push32=, float_min2@FUNCTION, $pop147, $pop146
	f32.const	$push145=, -0x1p0
	f32.eq  	$push33=, $pop32, $pop145
	br_if   	$pop33, 0       # 0: down to label16
# BB#33:                                # %if.then63
	call    	abort@FUNCTION
	unreachable
.LBB8_34:                               # %if.end64
	end_block                       # label16:
	block
	f32.const	$push150=, 0x1p0
	f32.const	$push149=, -0x1p0
	f32.call	$push34=, float_min2@FUNCTION, $pop150, $pop149
	f32.const	$push148=, -0x1p0
	f32.eq  	$push35=, $pop34, $pop148
	br_if   	$pop35, 0       # 0: down to label17
# BB#35:                                # %if.then67
	call    	abort@FUNCTION
	unreachable
.LBB8_36:                               # %if.end68
	end_block                       # label17:
	block
	f32.const	$push153=, 0x0p0
	f32.const	$push152=, -0x1p0
	f32.call	$push36=, float_max2@FUNCTION, $pop153, $pop152
	f32.const	$push151=, 0x0p0
	f32.eq  	$push37=, $pop36, $pop151
	br_if   	$pop37, 0       # 0: down to label18
# BB#37:                                # %if.then71
	call    	abort@FUNCTION
	unreachable
.LBB8_38:                               # %if.end72
	end_block                       # label18:
	block
	f32.const	$push156=, -0x1p0
	f32.const	$push155=, 0x0p0
	f32.call	$push38=, float_max2@FUNCTION, $pop156, $pop155
	f32.const	$push154=, 0x0p0
	f32.eq  	$push39=, $pop38, $pop154
	br_if   	$pop39, 0       # 0: down to label19
# BB#39:                                # %if.then75
	call    	abort@FUNCTION
	unreachable
.LBB8_40:                               # %if.end76
	end_block                       # label19:
	block
	f32.const	$push159=, 0x0p0
	f32.const	$push158=, 0x1p0
	f32.call	$push40=, float_max2@FUNCTION, $pop159, $pop158
	f32.const	$push157=, 0x1p0
	f32.eq  	$push41=, $pop40, $pop157
	br_if   	$pop41, 0       # 0: down to label20
# BB#41:                                # %if.then79
	call    	abort@FUNCTION
	unreachable
.LBB8_42:                               # %if.end80
	end_block                       # label20:
	block
	f32.const	$push162=, 0x1p0
	f32.const	$push161=, 0x0p0
	f32.call	$push42=, float_max2@FUNCTION, $pop162, $pop161
	f32.const	$push160=, 0x1p0
	f32.eq  	$push43=, $pop42, $pop160
	br_if   	$pop43, 0       # 0: down to label21
# BB#43:                                # %if.then83
	call    	abort@FUNCTION
	unreachable
.LBB8_44:                               # %if.end84
	end_block                       # label21:
	block
	f32.const	$push165=, -0x1p0
	f32.const	$push164=, 0x1p0
	f32.call	$push44=, float_max2@FUNCTION, $pop165, $pop164
	f32.const	$push163=, 0x1p0
	f32.eq  	$push45=, $pop44, $pop163
	br_if   	$pop45, 0       # 0: down to label22
# BB#45:                                # %if.then87
	call    	abort@FUNCTION
	unreachable
.LBB8_46:                               # %if.end88
	end_block                       # label22:
	block
	f32.const	$push168=, 0x1p0
	f32.const	$push167=, -0x1p0
	f32.call	$push46=, float_max2@FUNCTION, $pop168, $pop167
	f32.const	$push166=, 0x1p0
	f32.eq  	$push47=, $pop46, $pop166
	br_if   	$pop47, 0       # 0: down to label23
# BB#47:                                # %if.then91
	call    	abort@FUNCTION
	unreachable
.LBB8_48:                               # %if.end92
	end_block                       # label23:
	block
	f64.const	$push171=, 0x0p0
	f64.const	$push170=, -0x1p0
	f64.call	$push48=, double_min1@FUNCTION, $pop171, $pop170
	f64.const	$push169=, -0x1p0
	f64.eq  	$push49=, $pop48, $pop169
	br_if   	$pop49, 0       # 0: down to label24
# BB#49:                                # %if.then95
	call    	abort@FUNCTION
	unreachable
.LBB8_50:                               # %if.end96
	end_block                       # label24:
	block
	f64.const	$push174=, -0x1p0
	f64.const	$push173=, 0x0p0
	f64.call	$push50=, double_min1@FUNCTION, $pop174, $pop173
	f64.const	$push172=, -0x1p0
	f64.eq  	$push51=, $pop50, $pop172
	br_if   	$pop51, 0       # 0: down to label25
# BB#51:                                # %if.then99
	call    	abort@FUNCTION
	unreachable
.LBB8_52:                               # %if.end100
	end_block                       # label25:
	block
	f64.const	$push177=, 0x0p0
	f64.const	$push176=, 0x1p0
	f64.call	$push52=, double_min1@FUNCTION, $pop177, $pop176
	f64.const	$push175=, 0x0p0
	f64.eq  	$push53=, $pop52, $pop175
	br_if   	$pop53, 0       # 0: down to label26
# BB#53:                                # %if.then103
	call    	abort@FUNCTION
	unreachable
.LBB8_54:                               # %if.end104
	end_block                       # label26:
	block
	f64.const	$push180=, 0x1p0
	f64.const	$push179=, 0x0p0
	f64.call	$push54=, double_min1@FUNCTION, $pop180, $pop179
	f64.const	$push178=, 0x0p0
	f64.eq  	$push55=, $pop54, $pop178
	br_if   	$pop55, 0       # 0: down to label27
# BB#55:                                # %if.then107
	call    	abort@FUNCTION
	unreachable
.LBB8_56:                               # %if.end108
	end_block                       # label27:
	block
	f64.const	$push183=, -0x1p0
	f64.const	$push182=, 0x1p0
	f64.call	$push56=, double_min1@FUNCTION, $pop183, $pop182
	f64.const	$push181=, -0x1p0
	f64.eq  	$push57=, $pop56, $pop181
	br_if   	$pop57, 0       # 0: down to label28
# BB#57:                                # %if.then111
	call    	abort@FUNCTION
	unreachable
.LBB8_58:                               # %if.end112
	end_block                       # label28:
	block
	f64.const	$push186=, 0x1p0
	f64.const	$push185=, -0x1p0
	f64.call	$push58=, double_min1@FUNCTION, $pop186, $pop185
	f64.const	$push184=, -0x1p0
	f64.eq  	$push59=, $pop58, $pop184
	br_if   	$pop59, 0       # 0: down to label29
# BB#59:                                # %if.then115
	call    	abort@FUNCTION
	unreachable
.LBB8_60:                               # %if.end116
	end_block                       # label29:
	block
	f64.const	$push189=, 0x0p0
	f64.const	$push188=, -0x1p0
	f64.call	$push60=, double_max1@FUNCTION, $pop189, $pop188
	f64.const	$push187=, 0x0p0
	f64.eq  	$push61=, $pop60, $pop187
	br_if   	$pop61, 0       # 0: down to label30
# BB#61:                                # %if.then119
	call    	abort@FUNCTION
	unreachable
.LBB8_62:                               # %if.end120
	end_block                       # label30:
	block
	f64.const	$push192=, -0x1p0
	f64.const	$push191=, 0x0p0
	f64.call	$push62=, double_max1@FUNCTION, $pop192, $pop191
	f64.const	$push190=, 0x0p0
	f64.eq  	$push63=, $pop62, $pop190
	br_if   	$pop63, 0       # 0: down to label31
# BB#63:                                # %if.then123
	call    	abort@FUNCTION
	unreachable
.LBB8_64:                               # %if.end124
	end_block                       # label31:
	block
	f64.const	$push195=, 0x0p0
	f64.const	$push194=, 0x1p0
	f64.call	$push64=, double_max1@FUNCTION, $pop195, $pop194
	f64.const	$push193=, 0x1p0
	f64.eq  	$push65=, $pop64, $pop193
	br_if   	$pop65, 0       # 0: down to label32
# BB#65:                                # %if.then127
	call    	abort@FUNCTION
	unreachable
.LBB8_66:                               # %if.end128
	end_block                       # label32:
	block
	f64.const	$push198=, 0x1p0
	f64.const	$push197=, 0x0p0
	f64.call	$push66=, double_max1@FUNCTION, $pop198, $pop197
	f64.const	$push196=, 0x1p0
	f64.eq  	$push67=, $pop66, $pop196
	br_if   	$pop67, 0       # 0: down to label33
# BB#67:                                # %if.then131
	call    	abort@FUNCTION
	unreachable
.LBB8_68:                               # %if.end132
	end_block                       # label33:
	block
	f64.const	$push201=, -0x1p0
	f64.const	$push200=, 0x1p0
	f64.call	$push68=, double_max1@FUNCTION, $pop201, $pop200
	f64.const	$push199=, 0x1p0
	f64.eq  	$push69=, $pop68, $pop199
	br_if   	$pop69, 0       # 0: down to label34
# BB#69:                                # %if.then135
	call    	abort@FUNCTION
	unreachable
.LBB8_70:                               # %if.end136
	end_block                       # label34:
	block
	f64.const	$push204=, 0x1p0
	f64.const	$push203=, -0x1p0
	f64.call	$push70=, double_max1@FUNCTION, $pop204, $pop203
	f64.const	$push202=, 0x1p0
	f64.eq  	$push71=, $pop70, $pop202
	br_if   	$pop71, 0       # 0: down to label35
# BB#71:                                # %if.then139
	call    	abort@FUNCTION
	unreachable
.LBB8_72:                               # %if.end140
	end_block                       # label35:
	block
	f64.const	$push207=, 0x0p0
	f64.const	$push206=, -0x1p0
	f64.call	$push72=, double_min2@FUNCTION, $pop207, $pop206
	f64.const	$push205=, -0x1p0
	f64.eq  	$push73=, $pop72, $pop205
	br_if   	$pop73, 0       # 0: down to label36
# BB#73:                                # %if.then143
	call    	abort@FUNCTION
	unreachable
.LBB8_74:                               # %if.end144
	end_block                       # label36:
	block
	f64.const	$push210=, -0x1p0
	f64.const	$push209=, 0x0p0
	f64.call	$push74=, double_min2@FUNCTION, $pop210, $pop209
	f64.const	$push208=, -0x1p0
	f64.eq  	$push75=, $pop74, $pop208
	br_if   	$pop75, 0       # 0: down to label37
# BB#75:                                # %if.then147
	call    	abort@FUNCTION
	unreachable
.LBB8_76:                               # %if.end148
	end_block                       # label37:
	block
	f64.const	$push213=, 0x0p0
	f64.const	$push212=, 0x1p0
	f64.call	$push76=, double_min2@FUNCTION, $pop213, $pop212
	f64.const	$push211=, 0x0p0
	f64.eq  	$push77=, $pop76, $pop211
	br_if   	$pop77, 0       # 0: down to label38
# BB#77:                                # %if.then151
	call    	abort@FUNCTION
	unreachable
.LBB8_78:                               # %if.end152
	end_block                       # label38:
	block
	f64.const	$push216=, 0x1p0
	f64.const	$push215=, 0x0p0
	f64.call	$push78=, double_min2@FUNCTION, $pop216, $pop215
	f64.const	$push214=, 0x0p0
	f64.eq  	$push79=, $pop78, $pop214
	br_if   	$pop79, 0       # 0: down to label39
# BB#79:                                # %if.then155
	call    	abort@FUNCTION
	unreachable
.LBB8_80:                               # %if.end156
	end_block                       # label39:
	block
	f64.const	$push219=, -0x1p0
	f64.const	$push218=, 0x1p0
	f64.call	$push80=, double_min2@FUNCTION, $pop219, $pop218
	f64.const	$push217=, -0x1p0
	f64.eq  	$push81=, $pop80, $pop217
	br_if   	$pop81, 0       # 0: down to label40
# BB#81:                                # %if.then159
	call    	abort@FUNCTION
	unreachable
.LBB8_82:                               # %if.end160
	end_block                       # label40:
	block
	f64.const	$push222=, 0x1p0
	f64.const	$push221=, -0x1p0
	f64.call	$push82=, double_min2@FUNCTION, $pop222, $pop221
	f64.const	$push220=, -0x1p0
	f64.eq  	$push83=, $pop82, $pop220
	br_if   	$pop83, 0       # 0: down to label41
# BB#83:                                # %if.then163
	call    	abort@FUNCTION
	unreachable
.LBB8_84:                               # %if.end164
	end_block                       # label41:
	block
	f64.const	$push225=, 0x0p0
	f64.const	$push224=, -0x1p0
	f64.call	$push84=, double_max2@FUNCTION, $pop225, $pop224
	f64.const	$push223=, 0x0p0
	f64.eq  	$push85=, $pop84, $pop223
	br_if   	$pop85, 0       # 0: down to label42
# BB#85:                                # %if.then167
	call    	abort@FUNCTION
	unreachable
.LBB8_86:                               # %if.end168
	end_block                       # label42:
	block
	f64.const	$push228=, -0x1p0
	f64.const	$push227=, 0x0p0
	f64.call	$push86=, double_max2@FUNCTION, $pop228, $pop227
	f64.const	$push226=, 0x0p0
	f64.eq  	$push87=, $pop86, $pop226
	br_if   	$pop87, 0       # 0: down to label43
# BB#87:                                # %if.then171
	call    	abort@FUNCTION
	unreachable
.LBB8_88:                               # %if.end172
	end_block                       # label43:
	block
	f64.const	$push231=, 0x0p0
	f64.const	$push230=, 0x1p0
	f64.call	$push88=, double_max2@FUNCTION, $pop231, $pop230
	f64.const	$push229=, 0x1p0
	f64.eq  	$push89=, $pop88, $pop229
	br_if   	$pop89, 0       # 0: down to label44
# BB#89:                                # %if.then175
	call    	abort@FUNCTION
	unreachable
.LBB8_90:                               # %if.end176
	end_block                       # label44:
	block
	f64.const	$push234=, 0x1p0
	f64.const	$push233=, 0x0p0
	f64.call	$push90=, double_max2@FUNCTION, $pop234, $pop233
	f64.const	$push232=, 0x1p0
	f64.eq  	$push91=, $pop90, $pop232
	br_if   	$pop91, 0       # 0: down to label45
# BB#91:                                # %if.then179
	call    	abort@FUNCTION
	unreachable
.LBB8_92:                               # %if.end180
	end_block                       # label45:
	block
	f64.const	$push237=, -0x1p0
	f64.const	$push236=, 0x1p0
	f64.call	$push92=, double_max2@FUNCTION, $pop237, $pop236
	f64.const	$push235=, 0x1p0
	f64.eq  	$push93=, $pop92, $pop235
	br_if   	$pop93, 0       # 0: down to label46
# BB#93:                                # %if.then183
	call    	abort@FUNCTION
	unreachable
.LBB8_94:                               # %if.end184
	end_block                       # label46:
	block
	f64.const	$push240=, 0x1p0
	f64.const	$push239=, -0x1p0
	f64.call	$push94=, double_max2@FUNCTION, $pop240, $pop239
	f64.const	$push238=, 0x1p0
	f64.eq  	$push95=, $pop94, $pop238
	br_if   	$pop95, 0       # 0: down to label47
# BB#95:                                # %if.then187
	call    	abort@FUNCTION
	unreachable
.LBB8_96:                               # %if.end188
	end_block                       # label47:
	i32.const	$push96=, 0
	call    	exit@FUNCTION, $pop96
	unreachable
	.endfunc
.Lfunc_end8:
	.size	main, .Lfunc_end8-main


	.ident	"clang version 3.9.0 "
