	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020508-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i64, i64, i64, i64, i64, i32
# BB#0:                                 # %entry
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	block
	i32.const	$push0=, 0
	i32.load8_u	$push125=, uc($pop0)
	tee_local	$push124=, $2=, $pop125
	i32.const	$push2=, 8
	i32.const	$push123=, 0
	i32.load	$push122=, shift1($pop123)
	tee_local	$push121=, $1=, $pop122
	i32.sub 	$push120=, $pop2, $pop121
	tee_local	$push119=, $0=, $pop120
	i32.shl 	$push3=, $pop124, $pop119
	i32.shr_u	$push1=, $2, $1
	i32.or  	$push4=, $pop3, $pop1
	i32.const	$push118=, 835
	i32.ne  	$push5=, $pop4, $pop118
	br_if   	0, $pop5        # 0: down to label20
# BB#1:                                 # %if.end
	i32.const	$push6=, 4
	i32.shr_u	$push7=, $2, $pop6
	i32.const	$push127=, 4
	i32.shl 	$push8=, $2, $pop127
	i32.or  	$push9=, $pop7, $pop8
	i32.const	$push126=, 835
	i32.ne  	$push10=, $pop9, $pop126
	br_if   	1, $pop10       # 1: down to label19
# BB#2:                                 # %if.end11
	i32.const	$push11=, 0
	i32.load16_u	$push132=, us($pop11)
	tee_local	$push131=, $4=, $pop132
	i32.shr_u	$push12=, $pop131, $1
	i32.const	$push13=, 16
	i32.sub 	$push130=, $pop13, $1
	tee_local	$push129=, $3=, $pop130
	i32.shl 	$push14=, $4, $pop129
	i32.or  	$push15=, $pop12, $pop14
	i32.const	$push128=, 253972259
	i32.ne  	$push16=, $pop15, $pop128
	br_if   	2, $pop16       # 2: down to label18
# BB#3:                                 # %if.end21
	i32.const	$push17=, 4
	i32.shr_u	$push18=, $4, $pop17
	i32.const	$push19=, 12
	i32.shl 	$push20=, $4, $pop19
	i32.or  	$push21=, $pop18, $pop20
	i32.const	$push133=, 253972259
	i32.ne  	$push22=, $pop21, $pop133
	br_if   	3, $pop22       # 3: down to label17
# BB#4:                                 # %if.end30
	i32.const	$push23=, 0
	i32.load	$push138=, ui($pop23)
	tee_local	$push137=, $6=, $pop138
	i32.shr_u	$push24=, $pop137, $1
	i32.const	$push25=, 32
	i32.sub 	$push136=, $pop25, $1
	tee_local	$push135=, $5=, $pop136
	i32.shl 	$push26=, $6, $pop135
	i32.or  	$push27=, $pop24, $pop26
	i32.const	$push134=, 1073745699
	i32.ne  	$push28=, $pop27, $pop134
	br_if   	4, $pop28       # 4: down to label16
# BB#5:                                 # %if.end38
	i32.const	$push29=, 4
	i32.shr_u	$push30=, $6, $pop29
	i32.const	$push31=, 28
	i32.shl 	$push32=, $6, $pop31
	i32.or  	$push33=, $pop30, $pop32
	i32.const	$push139=, 1073745699
	i32.ne  	$push34=, $pop33, $pop139
	br_if   	5, $pop34       # 5: down to label15
# BB#6:                                 # %if.end45
	i32.const	$push35=, 0
	i32.load	$push142=, ul($pop35)
	tee_local	$push141=, $7=, $pop142
	i32.shr_u	$push36=, $pop141, $1
	i32.shl 	$push37=, $7, $5
	i32.or  	$push38=, $pop36, $pop37
	i32.const	$push140=, -1893513881
	i32.ne  	$push39=, $pop38, $pop140
	br_if   	6, $pop39       # 6: down to label14
# BB#7:                                 # %if.end53
	i32.const	$push40=, 4
	i32.shr_u	$push41=, $7, $pop40
	i32.const	$push42=, 28
	i32.shl 	$push43=, $7, $pop42
	i32.or  	$push44=, $pop41, $pop43
	i32.const	$push143=, -1893513881
	i32.ne  	$push45=, $pop44, $pop143
	br_if   	7, $pop45       # 7: down to label13
# BB#8:                                 # %if.end60
	i32.const	$push46=, 0
	i64.load	$push150=, ull($pop46)
	tee_local	$push149=, $10=, $pop150
	i64.extend_u/i32	$push148=, $1
	tee_local	$push147=, $9=, $pop148
	i64.shr_u	$push47=, $pop149, $pop147
	i32.const	$push48=, 64
	i32.sub 	$push49=, $pop48, $1
	i64.extend_u/i32	$push146=, $pop49
	tee_local	$push145=, $8=, $pop146
	i64.shl 	$push50=, $10, $pop145
	i64.or  	$push51=, $pop47, $pop50
	i64.const	$push144=, 68174490360335855
	i64.ne  	$push52=, $pop51, $pop144
	br_if   	8, $pop52       # 8: down to label12
# BB#9:                                 # %if.end69
	i64.const	$push53=, 4
	i64.shr_u	$push54=, $10, $pop53
	i64.const	$push55=, 60
	i64.shl 	$push56=, $10, $pop55
	i64.or  	$push57=, $pop54, $pop56
	i64.const	$push151=, 68174490360335855
	i64.ne  	$push58=, $pop57, $pop151
	br_if   	9, $pop58       # 9: down to label11
# BB#10:                                # %if.end76
	i32.const	$push61=, 64
	i32.const	$push59=, 0
	i32.load	$push158=, shift2($pop59)
	tee_local	$push157=, $13=, $pop158
	i32.sub 	$push62=, $pop61, $pop157
	i64.extend_u/i32	$push156=, $pop62
	tee_local	$push155=, $12=, $pop156
	i64.shl 	$push63=, $10, $pop155
	i64.extend_u/i32	$push154=, $13
	tee_local	$push153=, $11=, $pop154
	i64.shr_u	$push60=, $10, $pop153
	i64.or  	$push64=, $pop63, $pop60
	i64.const	$push152=, -994074541463572736
	i64.ne  	$push65=, $pop64, $pop152
	br_if   	10, $pop65      # 10: down to label10
# BB#11:                                # %if.end86
	i64.const	$push66=, 60
	i64.shr_u	$push67=, $10, $pop66
	i64.const	$push68=, 4
	i64.shl 	$push69=, $10, $pop68
	i64.or  	$push70=, $pop67, $pop69
	i64.const	$push159=, -994074541463572736
	i64.ne  	$push71=, $pop70, $pop159
	br_if   	11, $pop71      # 11: down to label9
# BB#12:                                # %if.end93
	i32.shr_u	$push73=, $2, $0
	i32.shl 	$push72=, $2, $1
	i32.or  	$push74=, $pop73, $pop72
	i32.const	$push75=, 835
	i32.ne  	$push76=, $pop74, $pop75
	br_if   	12, $pop76      # 12: down to label8
# BB#13:                                # %if.end112
	i32.shl 	$push77=, $4, $1
	i32.shr_u	$push78=, $4, $3
	i32.or  	$push79=, $pop77, $pop78
	i32.const	$push160=, 992079
	i32.ne  	$push80=, $pop79, $pop160
	br_if   	13, $pop80      # 13: down to label7
# BB#14:                                # %if.end122
	i32.const	$push81=, 4
	i32.shl 	$push82=, $4, $pop81
	i32.const	$push83=, 12
	i32.shr_u	$push84=, $4, $pop83
	i32.or  	$push85=, $pop82, $pop84
	i32.const	$push161=, 992079
	i32.ne  	$push86=, $pop85, $pop161
	br_if   	14, $pop86      # 14: down to label6
# BB#15:                                # %if.end131
	i32.shl 	$push87=, $6, $1
	i32.shr_u	$push88=, $6, $5
	i32.or  	$push89=, $pop87, $pop88
	i32.const	$push162=, 992064
	i32.ne  	$push90=, $pop89, $pop162
	br_if   	15, $pop90      # 15: down to label5
# BB#16:                                # %if.end139
	i32.const	$push91=, 4
	i32.shl 	$push92=, $6, $pop91
	i32.const	$push93=, 28
	i32.shr_u	$push94=, $6, $pop93
	i32.or  	$push95=, $pop92, $pop94
	i32.const	$push163=, 992064
	i32.ne  	$push96=, $pop95, $pop163
	br_if   	16, $pop96      # 16: down to label4
# BB#17:                                # %if.end146
	i32.shl 	$push97=, $7, $1
	i32.shr_u	$push98=, $7, $5
	i32.or  	$push99=, $pop97, $pop98
	i32.const	$push164=, 591751055
	i32.ne  	$push100=, $pop99, $pop164
	br_if   	17, $pop100     # 17: down to label3
# BB#18:                                # %if.end154
	i32.const	$push101=, 4
	i32.shl 	$push102=, $7, $pop101
	i32.const	$push103=, 28
	i32.shr_u	$push104=, $7, $pop103
	i32.or  	$push105=, $pop102, $pop104
	i32.const	$push165=, 591751055
	i32.ne  	$push106=, $pop105, $pop165
	br_if   	18, $pop106     # 18: down to label2
# BB#19:                                # %if.end161
	i64.shl 	$push107=, $10, $9
	i64.shr_u	$push108=, $10, $8
	i64.or  	$push109=, $pop107, $pop108
	i64.const	$push110=, -994074541463572736
	i64.ne  	$push111=, $pop109, $pop110
	br_if   	19, $pop111     # 19: down to label1
# BB#20:                                # %if.end178
	i64.shr_u	$push113=, $10, $12
	i64.shl 	$push112=, $10, $11
	i64.or  	$push114=, $pop113, $pop112
	i64.const	$push115=, 68174490360335855
	i64.ne  	$push116=, $pop114, $pop115
	br_if   	20, $pop116     # 20: down to label0
# BB#21:                                # %if.end195
	i32.const	$push117=, 0
	call    	exit@FUNCTION, $pop117
	unreachable
.LBB0_22:                               # %if.then
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
.LBB0_23:                               # %if.then10
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
.LBB0_24:                               # %if.then20
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
.LBB0_25:                               # %if.then29
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB0_26:                               # %if.then37
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
.LBB0_27:                               # %if.then44
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB0_28:                               # %if.then52
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB0_29:                               # %if.then59
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB0_30:                               # %if.then68
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB0_31:                               # %if.then75
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB0_32:                               # %if.then85
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB0_33:                               # %if.then92
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB0_34:                               # %if.then102
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB0_35:                               # %if.then121
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB0_36:                               # %if.then130
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_37:                               # %if.then138
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_38:                               # %if.then145
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_39:                               # %if.then153
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_40:                               # %if.then160
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_41:                               # %if.then170
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_42:                               # %if.then187
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	uc                      # @uc
	.type	uc,@object
	.section	.data.uc,"aw",@progbits
	.globl	uc
uc:
	.int8	52                      # 0x34
	.size	uc, 1

	.hidden	us                      # @us
	.type	us,@object
	.section	.data.us,"aw",@progbits
	.globl	us
	.p2align	1
us:
	.int16	62004                   # 0xf234
	.size	us, 2

	.hidden	ui                      # @ui
	.type	ui,@object
	.section	.data.ui,"aw",@progbits
	.globl	ui
	.p2align	2
ui:
	.int32	62004                   # 0xf234
	.size	ui, 4

	.hidden	ul                      # @ul
	.type	ul,@object
	.section	.data.ul,"aw",@progbits
	.globl	ul
	.p2align	2
ul:
	.int32	4063516280              # 0xf2345678
	.size	ul, 4

	.hidden	ull                     # @ull
	.type	ull,@object
	.section	.data.ull,"aw",@progbits
	.globl	ull
	.p2align	3
ull:
	.int64	1090791845765373680     # 0xf2345678abcdef0
	.size	ull, 8

	.hidden	shift1                  # @shift1
	.type	shift1,@object
	.section	.data.shift1,"aw",@progbits
	.globl	shift1
	.p2align	2
shift1:
	.int32	4                       # 0x4
	.size	shift1, 4

	.hidden	shift2                  # @shift2
	.type	shift2,@object
	.section	.data.shift2,"aw",@progbits
	.globl	shift2
	.p2align	2
shift2:
	.int32	60                      # 0x3c
	.size	shift2, 4


	.ident	"clang version 3.9.0 "
