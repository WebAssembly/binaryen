	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020508-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i64, i64, i64, i64, i64, i32, i32, i32, i32, i32, i32, i32, i32, i64, i64, i64, i32, i64
# BB#0:                                 # %entry
	i32.const	$11=, 0
	i32.load	$1=, shift1($11)
	i32.load8_u	$0=, uc($11)
	i32.const	$push1=, 8
	i32.sub 	$2=, $pop1, $1
	i32.const	$12=, 835
	block
	i32.shl 	$push2=, $0, $2
	i32.shr_u	$push0=, $0, $1
	i32.or  	$push3=, $pop2, $pop0
	i32.ne  	$push4=, $pop3, $12
	br_if   	$pop4, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$13=, 4
	block
	i32.shr_u	$push5=, $0, $13
	i32.shl 	$push6=, $0, $13
	i32.or  	$push7=, $pop5, $pop6
	i32.ne  	$push8=, $pop7, $12
	br_if   	$pop8, 0        # 0: down to label1
# BB#2:                                 # %if.end11
	i32.load16_u	$3=, us($11)
	i32.const	$push10=, 16
	i32.sub 	$4=, $pop10, $1
	i32.const	$14=, 253972259
	block
	i32.shr_u	$push9=, $3, $1
	i32.shl 	$push11=, $3, $4
	i32.or  	$push12=, $pop9, $pop11
	i32.ne  	$push13=, $pop12, $14
	br_if   	$pop13, 0       # 0: down to label2
# BB#3:                                 # %if.end21
	i32.const	$15=, 12
	block
	i32.shr_u	$push14=, $3, $13
	i32.shl 	$push15=, $3, $15
	i32.or  	$push16=, $pop14, $pop15
	i32.ne  	$push17=, $pop16, $14
	br_if   	$pop17, 0       # 0: down to label3
# BB#4:                                 # %if.end30
	i32.load	$14=, ui($11)
	i32.const	$push19=, 32
	i32.sub 	$5=, $pop19, $1
	i32.const	$16=, 1073745699
	block
	i32.shr_u	$push18=, $14, $1
	i32.shl 	$push20=, $14, $5
	i32.or  	$push21=, $pop18, $pop20
	i32.ne  	$push22=, $pop21, $16
	br_if   	$pop22, 0       # 0: down to label4
# BB#5:                                 # %if.end38
	i32.const	$17=, 28
	block
	i32.shr_u	$push23=, $14, $13
	i32.shl 	$push24=, $14, $17
	i32.or  	$push25=, $pop23, $pop24
	i32.ne  	$push26=, $pop25, $16
	br_if   	$pop26, 0       # 0: down to label5
# BB#6:                                 # %if.end45
	i32.load	$16=, ul($11)
	i32.const	$18=, -1893513881
	block
	i32.shr_u	$push27=, $16, $1
	i32.shl 	$push28=, $16, $5
	i32.or  	$push29=, $pop27, $pop28
	i32.ne  	$push30=, $pop29, $18
	br_if   	$pop30, 0       # 0: down to label6
# BB#7:                                 # %if.end53
	block
	i32.shr_u	$push31=, $16, $13
	i32.shl 	$push32=, $16, $17
	i32.or  	$push33=, $pop31, $pop32
	i32.ne  	$push34=, $pop33, $18
	br_if   	$pop34, 0       # 0: down to label7
# BB#8:                                 # %if.end60
	i64.load	$6=, ull($11)
	i32.const	$18=, 64
	i32.sub 	$push36=, $18, $1
	i64.extend_u/i32	$8=, $pop36
	i64.extend_u/i32	$7=, $1
	i64.const	$19=, 68174490360335855
	block
	i64.shr_u	$push35=, $6, $7
	i64.shl 	$push37=, $6, $8
	i64.or  	$push38=, $pop35, $pop37
	i64.ne  	$push39=, $pop38, $19
	br_if   	$pop39, 0       # 0: down to label8
# BB#9:                                 # %if.end69
	i64.const	$20=, 4
	i64.const	$21=, 60
	block
	i64.shr_u	$push40=, $6, $20
	i64.shl 	$push41=, $6, $21
	i64.or  	$push42=, $pop40, $pop41
	i64.ne  	$push43=, $pop42, $19
	br_if   	$pop43, 0       # 0: down to label9
# BB#10:                                # %if.end76
	i32.load	$22=, shift2($11)
	i64.extend_u/i32	$9=, $22
	i32.sub 	$push45=, $18, $22
	i64.extend_u/i32	$10=, $pop45
	i64.const	$23=, -994074541463572736
	block
	i64.shl 	$push46=, $6, $10
	i64.shr_u	$push44=, $6, $9
	i64.or  	$push47=, $pop46, $pop44
	i64.ne  	$push48=, $pop47, $23
	br_if   	$pop48, 0       # 0: down to label10
# BB#11:                                # %if.end86
	block
	i64.shr_u	$push49=, $6, $21
	i64.shl 	$push50=, $6, $20
	i64.or  	$push51=, $pop49, $pop50
	i64.ne  	$push52=, $pop51, $23
	br_if   	$pop52, 0       # 0: down to label11
# BB#12:                                # %if.end93
	block
	i32.shr_u	$push54=, $0, $2
	i32.shl 	$push53=, $0, $1
	i32.or  	$push55=, $pop54, $pop53
	i32.ne  	$push56=, $pop55, $12
	br_if   	$pop56, 0       # 0: down to label12
# BB#13:                                # %if.end112
	i32.const	$0=, 992079
	block
	i32.shl 	$push57=, $3, $1
	i32.shr_u	$push58=, $3, $4
	i32.or  	$push59=, $pop57, $pop58
	i32.ne  	$push60=, $pop59, $0
	br_if   	$pop60, 0       # 0: down to label13
# BB#14:                                # %if.end122
	block
	i32.shl 	$push61=, $3, $13
	i32.shr_u	$push62=, $3, $15
	i32.or  	$push63=, $pop61, $pop62
	i32.ne  	$push64=, $pop63, $0
	br_if   	$pop64, 0       # 0: down to label14
# BB#15:                                # %if.end131
	i32.const	$0=, 992064
	block
	i32.shl 	$push65=, $14, $1
	i32.shr_u	$push66=, $14, $5
	i32.or  	$push67=, $pop65, $pop66
	i32.ne  	$push68=, $pop67, $0
	br_if   	$pop68, 0       # 0: down to label15
# BB#16:                                # %if.end139
	block
	i32.shl 	$push69=, $14, $13
	i32.shr_u	$push70=, $14, $17
	i32.or  	$push71=, $pop69, $pop70
	i32.ne  	$push72=, $pop71, $0
	br_if   	$pop72, 0       # 0: down to label16
# BB#17:                                # %if.end146
	i32.const	$0=, 591751055
	block
	i32.shl 	$push73=, $16, $1
	i32.shr_u	$push74=, $16, $5
	i32.or  	$push75=, $pop73, $pop74
	i32.ne  	$push76=, $pop75, $0
	br_if   	$pop76, 0       # 0: down to label17
# BB#18:                                # %if.end154
	block
	i32.shl 	$push77=, $16, $13
	i32.shr_u	$push78=, $16, $17
	i32.or  	$push79=, $pop77, $pop78
	i32.ne  	$push80=, $pop79, $0
	br_if   	$pop80, 0       # 0: down to label18
# BB#19:                                # %if.end161
	block
	i64.shl 	$push81=, $6, $7
	i64.shr_u	$push82=, $6, $8
	i64.or  	$push83=, $pop81, $pop82
	i64.ne  	$push84=, $pop83, $23
	br_if   	$pop84, 0       # 0: down to label19
# BB#20:                                # %if.end178
	block
	i64.shr_u	$push86=, $6, $10
	i64.shl 	$push85=, $6, $9
	i64.or  	$push87=, $pop86, $pop85
	i64.ne  	$push88=, $pop87, $19
	br_if   	$pop88, 0       # 0: down to label20
# BB#21:                                # %if.end195
	call    	exit@FUNCTION, $11
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
	.align	1
us:
	.int16	62004                   # 0xf234
	.size	us, 2

	.hidden	ui                      # @ui
	.type	ui,@object
	.section	.data.ui,"aw",@progbits
	.globl	ui
	.align	2
ui:
	.int32	62004                   # 0xf234
	.size	ui, 4

	.hidden	ul                      # @ul
	.type	ul,@object
	.section	.data.ul,"aw",@progbits
	.globl	ul
	.align	2
ul:
	.int32	4063516280              # 0xf2345678
	.size	ul, 4

	.hidden	ull                     # @ull
	.type	ull,@object
	.section	.data.ull,"aw",@progbits
	.globl	ull
	.align	3
ull:
	.int64	1090791845765373680     # 0xf2345678abcdef0
	.size	ull, 8

	.hidden	shift1                  # @shift1
	.type	shift1,@object
	.section	.data.shift1,"aw",@progbits
	.globl	shift1
	.align	2
shift1:
	.int32	4                       # 0x4
	.size	shift1, 4

	.hidden	shift2                  # @shift2
	.type	shift2,@object
	.section	.data.shift2,"aw",@progbits
	.globl	shift2
	.align	2
shift2:
	.int32	60                      # 0x3c
	.size	shift2, 4


	.ident	"clang version 3.9.0 "
