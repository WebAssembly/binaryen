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
.Lfunc_end7:
	.size	double_max2, .Lfunc_end7-double_max2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f32, f32, f32, f64, f64, f64
# BB#0:                                 # %entry
	f32.const	$0=, -0x1p0
	f32.const	$1=, 0x0p0
	block   	.LBB8_2
	f32.call	$push0=, float_min1@FUNCTION, $1, $0
	f32.eq  	$push1=, $pop0, $0
	br_if   	$pop1, .LBB8_2
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB8_2:                                # %if.end
	block   	.LBB8_4
	f32.call	$push2=, float_min1@FUNCTION, $0, $1
	f32.eq  	$push3=, $pop2, $0
	br_if   	$pop3, .LBB8_4
# BB#3:                                 # %if.then3
	call    	abort@FUNCTION
	unreachable
.LBB8_4:                                # %if.end4
	f32.const	$2=, 0x1p0
	block   	.LBB8_6
	f32.call	$push4=, float_min1@FUNCTION, $1, $2
	f32.eq  	$push5=, $pop4, $1
	br_if   	$pop5, .LBB8_6
# BB#5:                                 # %if.then7
	call    	abort@FUNCTION
	unreachable
.LBB8_6:                                # %if.end8
	block   	.LBB8_8
	f32.call	$push6=, float_min1@FUNCTION, $2, $1
	f32.eq  	$push7=, $pop6, $1
	br_if   	$pop7, .LBB8_8
# BB#7:                                 # %if.then11
	call    	abort@FUNCTION
	unreachable
.LBB8_8:                                # %if.end12
	block   	.LBB8_10
	f32.call	$push8=, float_min1@FUNCTION, $0, $2
	f32.eq  	$push9=, $pop8, $0
	br_if   	$pop9, .LBB8_10
# BB#9:                                 # %if.then15
	call    	abort@FUNCTION
	unreachable
.LBB8_10:                               # %if.end16
	block   	.LBB8_12
	f32.call	$push10=, float_min1@FUNCTION, $2, $0
	f32.eq  	$push11=, $pop10, $0
	br_if   	$pop11, .LBB8_12
# BB#11:                                # %if.then19
	call    	abort@FUNCTION
	unreachable
.LBB8_12:                               # %if.end20
	block   	.LBB8_14
	f32.call	$push12=, float_max1@FUNCTION, $1, $0
	f32.eq  	$push13=, $pop12, $1
	br_if   	$pop13, .LBB8_14
# BB#13:                                # %if.then23
	call    	abort@FUNCTION
	unreachable
.LBB8_14:                               # %if.end24
	block   	.LBB8_16
	f32.call	$push14=, float_max1@FUNCTION, $0, $1
	f32.eq  	$push15=, $pop14, $1
	br_if   	$pop15, .LBB8_16
# BB#15:                                # %if.then27
	call    	abort@FUNCTION
	unreachable
.LBB8_16:                               # %if.end28
	block   	.LBB8_18
	f32.call	$push16=, float_max1@FUNCTION, $1, $2
	f32.eq  	$push17=, $pop16, $2
	br_if   	$pop17, .LBB8_18
# BB#17:                                # %if.then31
	call    	abort@FUNCTION
	unreachable
.LBB8_18:                               # %if.end32
	block   	.LBB8_20
	f32.call	$push18=, float_max1@FUNCTION, $2, $1
	f32.eq  	$push19=, $pop18, $2
	br_if   	$pop19, .LBB8_20
# BB#19:                                # %if.then35
	call    	abort@FUNCTION
	unreachable
.LBB8_20:                               # %if.end36
	block   	.LBB8_22
	f32.call	$push20=, float_max1@FUNCTION, $0, $2
	f32.eq  	$push21=, $pop20, $2
	br_if   	$pop21, .LBB8_22
# BB#21:                                # %if.then39
	call    	abort@FUNCTION
	unreachable
.LBB8_22:                               # %if.end40
	block   	.LBB8_24
	f32.call	$push22=, float_max1@FUNCTION, $2, $0
	f32.eq  	$push23=, $pop22, $2
	br_if   	$pop23, .LBB8_24
# BB#23:                                # %if.then43
	call    	abort@FUNCTION
	unreachable
.LBB8_24:                               # %if.end44
	block   	.LBB8_26
	f32.call	$push24=, float_min2@FUNCTION, $1, $0
	f32.eq  	$push25=, $pop24, $0
	br_if   	$pop25, .LBB8_26
# BB#25:                                # %if.then47
	call    	abort@FUNCTION
	unreachable
.LBB8_26:                               # %if.end48
	block   	.LBB8_28
	f32.call	$push26=, float_min2@FUNCTION, $0, $1
	f32.eq  	$push27=, $pop26, $0
	br_if   	$pop27, .LBB8_28
# BB#27:                                # %if.then51
	call    	abort@FUNCTION
	unreachable
.LBB8_28:                               # %if.end52
	block   	.LBB8_30
	f32.call	$push28=, float_min2@FUNCTION, $1, $2
	f32.eq  	$push29=, $pop28, $1
	br_if   	$pop29, .LBB8_30
# BB#29:                                # %if.then55
	call    	abort@FUNCTION
	unreachable
.LBB8_30:                               # %if.end56
	block   	.LBB8_32
	f32.call	$push30=, float_min2@FUNCTION, $2, $1
	f32.eq  	$push31=, $pop30, $1
	br_if   	$pop31, .LBB8_32
# BB#31:                                # %if.then59
	call    	abort@FUNCTION
	unreachable
.LBB8_32:                               # %if.end60
	block   	.LBB8_34
	f32.call	$push32=, float_min2@FUNCTION, $0, $2
	f32.eq  	$push33=, $pop32, $0
	br_if   	$pop33, .LBB8_34
# BB#33:                                # %if.then63
	call    	abort@FUNCTION
	unreachable
.LBB8_34:                               # %if.end64
	block   	.LBB8_36
	f32.call	$push34=, float_min2@FUNCTION, $2, $0
	f32.eq  	$push35=, $pop34, $0
	br_if   	$pop35, .LBB8_36
# BB#35:                                # %if.then67
	call    	abort@FUNCTION
	unreachable
.LBB8_36:                               # %if.end68
	block   	.LBB8_38
	f32.call	$push36=, float_max2@FUNCTION, $1, $0
	f32.eq  	$push37=, $pop36, $1
	br_if   	$pop37, .LBB8_38
# BB#37:                                # %if.then71
	call    	abort@FUNCTION
	unreachable
.LBB8_38:                               # %if.end72
	block   	.LBB8_40
	f32.call	$push38=, float_max2@FUNCTION, $0, $1
	f32.eq  	$push39=, $pop38, $1
	br_if   	$pop39, .LBB8_40
# BB#39:                                # %if.then75
	call    	abort@FUNCTION
	unreachable
.LBB8_40:                               # %if.end76
	block   	.LBB8_42
	f32.call	$push40=, float_max2@FUNCTION, $1, $2
	f32.eq  	$push41=, $pop40, $2
	br_if   	$pop41, .LBB8_42
# BB#41:                                # %if.then79
	call    	abort@FUNCTION
	unreachable
.LBB8_42:                               # %if.end80
	block   	.LBB8_44
	f32.call	$push42=, float_max2@FUNCTION, $2, $1
	f32.eq  	$push43=, $pop42, $2
	br_if   	$pop43, .LBB8_44
# BB#43:                                # %if.then83
	call    	abort@FUNCTION
	unreachable
.LBB8_44:                               # %if.end84
	block   	.LBB8_46
	f32.call	$push44=, float_max2@FUNCTION, $0, $2
	f32.eq  	$push45=, $pop44, $2
	br_if   	$pop45, .LBB8_46
# BB#45:                                # %if.then87
	call    	abort@FUNCTION
	unreachable
.LBB8_46:                               # %if.end88
	block   	.LBB8_48
	f32.call	$push46=, float_max2@FUNCTION, $2, $0
	f32.eq  	$push47=, $pop46, $2
	br_if   	$pop47, .LBB8_48
# BB#47:                                # %if.then91
	call    	abort@FUNCTION
	unreachable
.LBB8_48:                               # %if.end92
	f64.const	$3=, -0x1p0
	f64.const	$4=, 0x0p0
	block   	.LBB8_50
	f64.call	$push48=, double_min1@FUNCTION, $4, $3
	f64.eq  	$push49=, $pop48, $3
	br_if   	$pop49, .LBB8_50
# BB#49:                                # %if.then95
	call    	abort@FUNCTION
	unreachable
.LBB8_50:                               # %if.end96
	block   	.LBB8_52
	f64.call	$push50=, double_min1@FUNCTION, $3, $4
	f64.eq  	$push51=, $pop50, $3
	br_if   	$pop51, .LBB8_52
# BB#51:                                # %if.then99
	call    	abort@FUNCTION
	unreachable
.LBB8_52:                               # %if.end100
	f64.const	$5=, 0x1p0
	block   	.LBB8_54
	f64.call	$push52=, double_min1@FUNCTION, $4, $5
	f64.eq  	$push53=, $pop52, $4
	br_if   	$pop53, .LBB8_54
# BB#53:                                # %if.then103
	call    	abort@FUNCTION
	unreachable
.LBB8_54:                               # %if.end104
	block   	.LBB8_56
	f64.call	$push54=, double_min1@FUNCTION, $5, $4
	f64.eq  	$push55=, $pop54, $4
	br_if   	$pop55, .LBB8_56
# BB#55:                                # %if.then107
	call    	abort@FUNCTION
	unreachable
.LBB8_56:                               # %if.end108
	block   	.LBB8_58
	f64.call	$push56=, double_min1@FUNCTION, $3, $5
	f64.eq  	$push57=, $pop56, $3
	br_if   	$pop57, .LBB8_58
# BB#57:                                # %if.then111
	call    	abort@FUNCTION
	unreachable
.LBB8_58:                               # %if.end112
	block   	.LBB8_60
	f64.call	$push58=, double_min1@FUNCTION, $5, $3
	f64.eq  	$push59=, $pop58, $3
	br_if   	$pop59, .LBB8_60
# BB#59:                                # %if.then115
	call    	abort@FUNCTION
	unreachable
.LBB8_60:                               # %if.end116
	block   	.LBB8_62
	f64.call	$push60=, double_max1@FUNCTION, $4, $3
	f64.eq  	$push61=, $pop60, $4
	br_if   	$pop61, .LBB8_62
# BB#61:                                # %if.then119
	call    	abort@FUNCTION
	unreachable
.LBB8_62:                               # %if.end120
	block   	.LBB8_64
	f64.call	$push62=, double_max1@FUNCTION, $3, $4
	f64.eq  	$push63=, $pop62, $4
	br_if   	$pop63, .LBB8_64
# BB#63:                                # %if.then123
	call    	abort@FUNCTION
	unreachable
.LBB8_64:                               # %if.end124
	block   	.LBB8_66
	f64.call	$push64=, double_max1@FUNCTION, $4, $5
	f64.eq  	$push65=, $pop64, $5
	br_if   	$pop65, .LBB8_66
# BB#65:                                # %if.then127
	call    	abort@FUNCTION
	unreachable
.LBB8_66:                               # %if.end128
	block   	.LBB8_68
	f64.call	$push66=, double_max1@FUNCTION, $5, $4
	f64.eq  	$push67=, $pop66, $5
	br_if   	$pop67, .LBB8_68
# BB#67:                                # %if.then131
	call    	abort@FUNCTION
	unreachable
.LBB8_68:                               # %if.end132
	block   	.LBB8_70
	f64.call	$push68=, double_max1@FUNCTION, $3, $5
	f64.eq  	$push69=, $pop68, $5
	br_if   	$pop69, .LBB8_70
# BB#69:                                # %if.then135
	call    	abort@FUNCTION
	unreachable
.LBB8_70:                               # %if.end136
	block   	.LBB8_72
	f64.call	$push70=, double_max1@FUNCTION, $5, $3
	f64.eq  	$push71=, $pop70, $5
	br_if   	$pop71, .LBB8_72
# BB#71:                                # %if.then139
	call    	abort@FUNCTION
	unreachable
.LBB8_72:                               # %if.end140
	block   	.LBB8_74
	f64.call	$push72=, double_min2@FUNCTION, $4, $3
	f64.eq  	$push73=, $pop72, $3
	br_if   	$pop73, .LBB8_74
# BB#73:                                # %if.then143
	call    	abort@FUNCTION
	unreachable
.LBB8_74:                               # %if.end144
	block   	.LBB8_76
	f64.call	$push74=, double_min2@FUNCTION, $3, $4
	f64.eq  	$push75=, $pop74, $3
	br_if   	$pop75, .LBB8_76
# BB#75:                                # %if.then147
	call    	abort@FUNCTION
	unreachable
.LBB8_76:                               # %if.end148
	block   	.LBB8_78
	f64.call	$push76=, double_min2@FUNCTION, $4, $5
	f64.eq  	$push77=, $pop76, $4
	br_if   	$pop77, .LBB8_78
# BB#77:                                # %if.then151
	call    	abort@FUNCTION
	unreachable
.LBB8_78:                               # %if.end152
	block   	.LBB8_80
	f64.call	$push78=, double_min2@FUNCTION, $5, $4
	f64.eq  	$push79=, $pop78, $4
	br_if   	$pop79, .LBB8_80
# BB#79:                                # %if.then155
	call    	abort@FUNCTION
	unreachable
.LBB8_80:                               # %if.end156
	block   	.LBB8_82
	f64.call	$push80=, double_min2@FUNCTION, $3, $5
	f64.eq  	$push81=, $pop80, $3
	br_if   	$pop81, .LBB8_82
# BB#81:                                # %if.then159
	call    	abort@FUNCTION
	unreachable
.LBB8_82:                               # %if.end160
	block   	.LBB8_84
	f64.call	$push82=, double_min2@FUNCTION, $5, $3
	f64.eq  	$push83=, $pop82, $3
	br_if   	$pop83, .LBB8_84
# BB#83:                                # %if.then163
	call    	abort@FUNCTION
	unreachable
.LBB8_84:                               # %if.end164
	block   	.LBB8_86
	f64.call	$push84=, double_max2@FUNCTION, $4, $3
	f64.eq  	$push85=, $pop84, $4
	br_if   	$pop85, .LBB8_86
# BB#85:                                # %if.then167
	call    	abort@FUNCTION
	unreachable
.LBB8_86:                               # %if.end168
	block   	.LBB8_88
	f64.call	$push86=, double_max2@FUNCTION, $3, $4
	f64.eq  	$push87=, $pop86, $4
	br_if   	$pop87, .LBB8_88
# BB#87:                                # %if.then171
	call    	abort@FUNCTION
	unreachable
.LBB8_88:                               # %if.end172
	block   	.LBB8_90
	f64.call	$push88=, double_max2@FUNCTION, $4, $5
	f64.eq  	$push89=, $pop88, $5
	br_if   	$pop89, .LBB8_90
# BB#89:                                # %if.then175
	call    	abort@FUNCTION
	unreachable
.LBB8_90:                               # %if.end176
	block   	.LBB8_92
	f64.call	$push90=, double_max2@FUNCTION, $5, $4
	f64.eq  	$push91=, $pop90, $5
	br_if   	$pop91, .LBB8_92
# BB#91:                                # %if.then179
	call    	abort@FUNCTION
	unreachable
.LBB8_92:                               # %if.end180
	block   	.LBB8_94
	f64.call	$push92=, double_max2@FUNCTION, $3, $5
	f64.eq  	$push93=, $pop92, $5
	br_if   	$pop93, .LBB8_94
# BB#93:                                # %if.then183
	call    	abort@FUNCTION
	unreachable
.LBB8_94:                               # %if.end184
	block   	.LBB8_96
	f64.call	$push94=, double_max2@FUNCTION, $5, $3
	f64.eq  	$push95=, $pop94, $5
	br_if   	$pop95, .LBB8_96
# BB#95:                                # %if.then187
	call    	abort@FUNCTION
	unreachable
.LBB8_96:                               # %if.end188
	i32.const	$push96=, 0
	call    	exit@FUNCTION, $pop96
	unreachable
.Lfunc_end8:
	.size	main, .Lfunc_end8-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
