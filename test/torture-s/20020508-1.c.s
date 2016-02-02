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
	i32.const	$push13=, 0
	i32.load8_u	$push0=, uc($pop13)
	tee_local	$push136=, $2=, $pop0
	i32.const	$push15=, 8
	i32.const	$push135=, 0
	i32.load	$push1=, shift1($pop135)
	tee_local	$push134=, $1=, $pop1
	i32.sub 	$push2=, $pop15, $pop134
	tee_local	$push133=, $0=, $pop2
	i32.shl 	$push16=, $pop136, $pop133
	i32.shr_u	$push14=, $2, $1
	i32.or  	$push17=, $pop16, $pop14
	i32.const	$push132=, 835
	i32.ne  	$push18=, $pop17, $pop132
	br_if   	$pop18, 0       # 0: down to label0
# BB#1:                                 # %if.end
	block
	i32.const	$push19=, 4
	i32.shr_u	$push20=, $2, $pop19
	i32.const	$push138=, 4
	i32.shl 	$push21=, $2, $pop138
	i32.or  	$push22=, $pop20, $pop21
	i32.const	$push137=, 835
	i32.ne  	$push23=, $pop22, $pop137
	br_if   	$pop23, 0       # 0: down to label1
# BB#2:                                 # %if.end11
	block
	i32.const	$push24=, 0
	i32.load16_u	$push3=, us($pop24)
	tee_local	$push141=, $4=, $pop3
	i32.shr_u	$push25=, $pop141, $1
	i32.const	$push26=, 16
	i32.sub 	$push4=, $pop26, $1
	tee_local	$push140=, $3=, $pop4
	i32.shl 	$push27=, $4, $pop140
	i32.or  	$push28=, $pop25, $pop27
	i32.const	$push139=, 253972259
	i32.ne  	$push29=, $pop28, $pop139
	br_if   	$pop29, 0       # 0: down to label2
# BB#3:                                 # %if.end21
	block
	i32.const	$push30=, 4
	i32.shr_u	$push31=, $4, $pop30
	i32.const	$push32=, 12
	i32.shl 	$push33=, $4, $pop32
	i32.or  	$push34=, $pop31, $pop33
	i32.const	$push142=, 253972259
	i32.ne  	$push35=, $pop34, $pop142
	br_if   	$pop35, 0       # 0: down to label3
# BB#4:                                 # %if.end30
	block
	i32.const	$push36=, 0
	i32.load	$push5=, ui($pop36)
	tee_local	$push145=, $6=, $pop5
	i32.shr_u	$push37=, $pop145, $1
	i32.const	$push38=, 32
	i32.sub 	$push6=, $pop38, $1
	tee_local	$push144=, $5=, $pop6
	i32.shl 	$push39=, $6, $pop144
	i32.or  	$push40=, $pop37, $pop39
	i32.const	$push143=, 1073745699
	i32.ne  	$push41=, $pop40, $pop143
	br_if   	$pop41, 0       # 0: down to label4
# BB#5:                                 # %if.end38
	block
	i32.const	$push42=, 4
	i32.shr_u	$push43=, $6, $pop42
	i32.const	$push44=, 28
	i32.shl 	$push45=, $6, $pop44
	i32.or  	$push46=, $pop43, $pop45
	i32.const	$push146=, 1073745699
	i32.ne  	$push47=, $pop46, $pop146
	br_if   	$pop47, 0       # 0: down to label5
# BB#6:                                 # %if.end45
	block
	i32.const	$push48=, 0
	i32.load	$push7=, ul($pop48)
	tee_local	$push148=, $7=, $pop7
	i32.shr_u	$push49=, $pop148, $1
	i32.shl 	$push50=, $7, $5
	i32.or  	$push51=, $pop49, $pop50
	i32.const	$push147=, -1893513881
	i32.ne  	$push52=, $pop51, $pop147
	br_if   	$pop52, 0       # 0: down to label6
# BB#7:                                 # %if.end53
	block
	i32.const	$push53=, 4
	i32.shr_u	$push54=, $7, $pop53
	i32.const	$push55=, 28
	i32.shl 	$push56=, $7, $pop55
	i32.or  	$push57=, $pop54, $pop56
	i32.const	$push149=, -1893513881
	i32.ne  	$push58=, $pop57, $pop149
	br_if   	$pop58, 0       # 0: down to label7
# BB#8:                                 # %if.end60
	block
	i32.const	$push59=, 0
	i64.load	$push8=, ull($pop59)
	tee_local	$push153=, $10=, $pop8
	i64.extend_u/i32	$push9=, $1
	tee_local	$push152=, $9=, $pop9
	i64.shr_u	$push60=, $pop153, $pop152
	i32.const	$push61=, 64
	i32.sub 	$push62=, $pop61, $1
	i64.extend_u/i32	$push10=, $pop62
	tee_local	$push151=, $8=, $pop10
	i64.shl 	$push63=, $10, $pop151
	i64.or  	$push64=, $pop60, $pop63
	i64.const	$push150=, 68174490360335855
	i64.ne  	$push65=, $pop64, $pop150
	br_if   	$pop65, 0       # 0: down to label8
# BB#9:                                 # %if.end69
	block
	i64.const	$push66=, 4
	i64.shr_u	$push67=, $10, $pop66
	i64.const	$push68=, 60
	i64.shl 	$push69=, $10, $pop68
	i64.or  	$push70=, $pop67, $pop69
	i64.const	$push154=, 68174490360335855
	i64.ne  	$push71=, $pop70, $pop154
	br_if   	$pop71, 0       # 0: down to label9
# BB#10:                                # %if.end76
	block
	i32.const	$push75=, 64
	i32.const	$push72=, 0
	i32.load	$push73=, shift2($pop72)
	tee_local	$push158=, $13=, $pop73
	i32.sub 	$push76=, $pop75, $pop158
	i64.extend_u/i32	$push12=, $pop76
	tee_local	$push157=, $12=, $pop12
	i64.shl 	$push77=, $10, $pop157
	i64.extend_u/i32	$push11=, $13
	tee_local	$push156=, $11=, $pop11
	i64.shr_u	$push74=, $10, $pop156
	i64.or  	$push78=, $pop77, $pop74
	i64.const	$push155=, -994074541463572736
	i64.ne  	$push79=, $pop78, $pop155
	br_if   	$pop79, 0       # 0: down to label10
# BB#11:                                # %if.end86
	block
	i64.const	$push80=, 60
	i64.shr_u	$push81=, $10, $pop80
	i64.const	$push82=, 4
	i64.shl 	$push83=, $10, $pop82
	i64.or  	$push84=, $pop81, $pop83
	i64.const	$push159=, -994074541463572736
	i64.ne  	$push85=, $pop84, $pop159
	br_if   	$pop85, 0       # 0: down to label11
# BB#12:                                # %if.end93
	block
	i32.shr_u	$push87=, $2, $0
	i32.shl 	$push86=, $2, $1
	i32.or  	$push88=, $pop87, $pop86
	i32.const	$push89=, 835
	i32.ne  	$push90=, $pop88, $pop89
	br_if   	$pop90, 0       # 0: down to label12
# BB#13:                                # %if.end112
	block
	i32.shl 	$push91=, $4, $1
	i32.shr_u	$push92=, $4, $3
	i32.or  	$push93=, $pop91, $pop92
	i32.const	$push160=, 992079
	i32.ne  	$push94=, $pop93, $pop160
	br_if   	$pop94, 0       # 0: down to label13
# BB#14:                                # %if.end122
	block
	i32.const	$push95=, 4
	i32.shl 	$push96=, $4, $pop95
	i32.const	$push97=, 12
	i32.shr_u	$push98=, $4, $pop97
	i32.or  	$push99=, $pop96, $pop98
	i32.const	$push161=, 992079
	i32.ne  	$push100=, $pop99, $pop161
	br_if   	$pop100, 0      # 0: down to label14
# BB#15:                                # %if.end131
	block
	i32.shl 	$push101=, $6, $1
	i32.shr_u	$push102=, $6, $5
	i32.or  	$push103=, $pop101, $pop102
	i32.const	$push162=, 992064
	i32.ne  	$push104=, $pop103, $pop162
	br_if   	$pop104, 0      # 0: down to label15
# BB#16:                                # %if.end139
	block
	i32.const	$push105=, 4
	i32.shl 	$push106=, $6, $pop105
	i32.const	$push107=, 28
	i32.shr_u	$push108=, $6, $pop107
	i32.or  	$push109=, $pop106, $pop108
	i32.const	$push163=, 992064
	i32.ne  	$push110=, $pop109, $pop163
	br_if   	$pop110, 0      # 0: down to label16
# BB#17:                                # %if.end146
	block
	i32.shl 	$push111=, $7, $1
	i32.shr_u	$push112=, $7, $5
	i32.or  	$push113=, $pop111, $pop112
	i32.const	$push164=, 591751055
	i32.ne  	$push114=, $pop113, $pop164
	br_if   	$pop114, 0      # 0: down to label17
# BB#18:                                # %if.end154
	block
	i32.const	$push115=, 4
	i32.shl 	$push116=, $7, $pop115
	i32.const	$push117=, 28
	i32.shr_u	$push118=, $7, $pop117
	i32.or  	$push119=, $pop116, $pop118
	i32.const	$push165=, 591751055
	i32.ne  	$push120=, $pop119, $pop165
	br_if   	$pop120, 0      # 0: down to label18
# BB#19:                                # %if.end161
	block
	i64.shl 	$push121=, $10, $9
	i64.shr_u	$push122=, $10, $8
	i64.or  	$push123=, $pop121, $pop122
	i64.const	$push124=, -994074541463572736
	i64.ne  	$push125=, $pop123, $pop124
	br_if   	$pop125, 0      # 0: down to label19
# BB#20:                                # %if.end178
	block
	i64.shr_u	$push127=, $10, $12
	i64.shl 	$push126=, $10, $11
	i64.or  	$push128=, $pop127, $pop126
	i64.const	$push129=, 68174490360335855
	i64.ne  	$push130=, $pop128, $pop129
	br_if   	$pop130, 0      # 0: down to label20
# BB#21:                                # %if.end195
	i32.const	$push131=, 0
	call    	exit@FUNCTION, $pop131
	unreachable
.LBB0_22:                               # %if.then187
	end_block                       # label20:
	call    	abort@FUNCTION
	unreachable
.LBB0_23:                               # %if.then170
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
.LBB0_24:                               # %if.then160
	end_block                       # label18:
	call    	abort@FUNCTION
	unreachable
.LBB0_25:                               # %if.then153
	end_block                       # label17:
	call    	abort@FUNCTION
	unreachable
.LBB0_26:                               # %if.then145
	end_block                       # label16:
	call    	abort@FUNCTION
	unreachable
.LBB0_27:                               # %if.then138
	end_block                       # label15:
	call    	abort@FUNCTION
	unreachable
.LBB0_28:                               # %if.then130
	end_block                       # label14:
	call    	abort@FUNCTION
	unreachable
.LBB0_29:                               # %if.then121
	end_block                       # label13:
	call    	abort@FUNCTION
	unreachable
.LBB0_30:                               # %if.then102
	end_block                       # label12:
	call    	abort@FUNCTION
	unreachable
.LBB0_31:                               # %if.then92
	end_block                       # label11:
	call    	abort@FUNCTION
	unreachable
.LBB0_32:                               # %if.then85
	end_block                       # label10:
	call    	abort@FUNCTION
	unreachable
.LBB0_33:                               # %if.then75
	end_block                       # label9:
	call    	abort@FUNCTION
	unreachable
.LBB0_34:                               # %if.then68
	end_block                       # label8:
	call    	abort@FUNCTION
	unreachable
.LBB0_35:                               # %if.then59
	end_block                       # label7:
	call    	abort@FUNCTION
	unreachable
.LBB0_36:                               # %if.then52
	end_block                       # label6:
	call    	abort@FUNCTION
	unreachable
.LBB0_37:                               # %if.then44
	end_block                       # label5:
	call    	abort@FUNCTION
	unreachable
.LBB0_38:                               # %if.then37
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
.LBB0_39:                               # %if.then29
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB0_40:                               # %if.then20
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_41:                               # %if.then10
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB0_42:                               # %if.then
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
