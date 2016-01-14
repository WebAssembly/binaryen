	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr42833.c"
	.section	.text.helper_neon_rshl_s8,"ax",@progbits
	.hidden	helper_neon_rshl_s8
	.globl	helper_neon_rshl_s8
	.type	helper_neon_rshl_s8,@function
helper_neon_rshl_s8:                    # @helper_neon_rshl_s8
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$6=, 24
	i32.shl 	$7=, $1, $6
	i32.const	$11=, 0
	i32.const	$5=, 16
	copy_local	$8=, $11
	block
	i32.const	$push0=, 117440512
	i32.gt_s	$push1=, $7, $pop0
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %if.else
	block
	i32.const	$push2=, -134217729
	i32.gt_s	$push3=, $7, $pop2
	br_if   	$pop3, 0        # 0: down to label1
# BB#2:                                 # %if.then13
	i32.shl 	$push14=, $0, $6
	i32.const	$push15=, 31
	i32.shr_s	$8=, $pop14, $pop15
	br      	1               # 1: down to label0
.LBB0_3:                                # %if.else18
	end_block                       # label1:
	i32.shr_s	$4=, $7, $6
	copy_local	$8=, $11
	i32.const	$push4=, -8
	i32.eq  	$push5=, $4, $pop4
	br_if   	$pop5, 0        # 0: down to label0
# BB#4:                                 # %if.else34
	i32.shl 	$push6=, $0, $6
	i32.shr_s	$8=, $pop6, $6
	i32.const	$3=, -1
	block
	i32.le_s	$push7=, $7, $3
	br_if   	$pop7, 0        # 0: down to label2
# BB#5:                                 # %if.else48
	i32.shl 	$8=, $8, $4
	br      	1               # 1: down to label0
.LBB0_6:                                # %if.then38
	end_block                       # label2:
	i32.const	$push9=, 1
	i32.xor 	$push8=, $4, $3
	i32.shl 	$push10=, $pop9, $pop8
	i32.add 	$push11=, $pop10, $8
	i32.const	$push12=, 0
	i32.sub 	$push13=, $pop12, $4
	i32.shr_s	$8=, $pop11, $pop13
.LBB0_7:                                # %if.end57
	end_block                       # label0:
	i32.shl 	$push16=, $1, $5
	i32.shr_s	$3=, $pop16, $6
	i32.const	$4=, 8
	i32.const	$7=, 7
	copy_local	$9=, $11
	block
	i32.gt_s	$push17=, $3, $7
	br_if   	$pop17, 0       # 0: down to label3
# BB#8:                                 # %if.else68
	i32.shr_u	$10=, $0, $4
	block
	i32.const	$push18=, -9
	i32.gt_s	$push19=, $3, $pop18
	br_if   	$pop19, 0       # 0: down to label4
# BB#9:                                 # %if.then72
	i32.shl 	$push30=, $10, $6
	i32.const	$push31=, 31
	i32.shr_s	$9=, $pop30, $pop31
	br      	1               # 1: down to label3
.LBB0_10:                               # %if.else78
	end_block                       # label4:
	copy_local	$9=, $11
	i32.const	$push20=, -8
	i32.eq  	$push21=, $3, $pop20
	br_if   	$pop21, 0       # 0: down to label3
# BB#11:                                # %if.else96
	i32.shl 	$push22=, $10, $6
	i32.shr_s	$10=, $pop22, $6
	i32.const	$9=, -1
	block
	i32.le_s	$push23=, $3, $9
	br_if   	$pop23, 0       # 0: down to label5
# BB#12:                                # %if.else112
	i32.shl 	$9=, $10, $3
	br      	1               # 1: down to label3
.LBB0_13:                               # %if.then100
	end_block                       # label5:
	i32.const	$push25=, 1
	i32.xor 	$push24=, $3, $9
	i32.shl 	$push26=, $pop25, $pop24
	i32.add 	$push27=, $pop26, $10
	i32.const	$push28=, 0
	i32.sub 	$push29=, $pop28, $3
	i32.shr_s	$9=, $pop27, $pop29
.LBB0_14:                               # %if.end122
	end_block                       # label3:
	i32.shl 	$push32=, $1, $4
	i32.shr_s	$3=, $pop32, $6
	copy_local	$10=, $11
	block
	i32.gt_s	$push33=, $3, $7
	br_if   	$pop33, 0       # 0: down to label6
# BB#15:                                # %if.else133
	i32.shr_u	$2=, $0, $5
	block
	i32.const	$push34=, -9
	i32.gt_s	$push35=, $3, $pop34
	br_if   	$pop35, 0       # 0: down to label7
# BB#16:                                # %if.then137
	i32.shl 	$push46=, $2, $6
	i32.const	$push47=, 31
	i32.shr_s	$10=, $pop46, $pop47
	br      	1               # 1: down to label6
.LBB0_17:                               # %if.else143
	end_block                       # label7:
	copy_local	$10=, $11
	i32.const	$push36=, -8
	i32.eq  	$push37=, $3, $pop36
	br_if   	$pop37, 0       # 0: down to label6
# BB#18:                                # %if.else161
	i32.shl 	$push38=, $2, $6
	i32.shr_s	$2=, $pop38, $6
	i32.const	$10=, -1
	block
	i32.le_s	$push39=, $3, $10
	br_if   	$pop39, 0       # 0: down to label8
# BB#19:                                # %if.else177
	i32.shl 	$10=, $2, $3
	br      	1               # 1: down to label6
.LBB0_20:                               # %if.then165
	end_block                       # label8:
	i32.const	$push41=, 1
	i32.xor 	$push40=, $3, $10
	i32.shl 	$push42=, $pop41, $pop40
	i32.add 	$push43=, $pop42, $2
	i32.const	$push44=, 0
	i32.sub 	$push45=, $pop44, $3
	i32.shr_s	$10=, $pop43, $pop45
.LBB0_21:                               # %if.end187
	end_block                       # label6:
	i32.shr_s	$1=, $1, $6
	block
	i32.gt_s	$push48=, $1, $7
	br_if   	$pop48, 0       # 0: down to label9
# BB#22:                                # %if.else199
	block
	i32.const	$push49=, -9
	i32.gt_s	$push50=, $1, $pop49
	br_if   	$pop50, 0       # 0: down to label10
# BB#23:                                # %if.then203
	i32.const	$push60=, 31
	i32.shr_s	$11=, $0, $pop60
	br      	1               # 1: down to label9
.LBB0_24:                               # %if.else209
	end_block                       # label10:
	i32.const	$push51=, -8
	i32.eq  	$push52=, $1, $pop51
	br_if   	$pop52, 0       # 0: down to label9
# BB#25:                                # %if.else227
	i32.shr_s	$7=, $0, $6
	i32.const	$11=, -1
	block
	i32.le_s	$push53=, $1, $11
	br_if   	$pop53, 0       # 0: down to label11
# BB#26:                                # %if.else243
	i32.shl 	$11=, $7, $1
	br      	1               # 1: down to label9
.LBB0_27:                               # %if.then231
	end_block                       # label11:
	i32.const	$push55=, 1
	i32.xor 	$push54=, $1, $11
	i32.shl 	$push56=, $pop55, $pop54
	i32.add 	$push57=, $pop56, $7
	i32.const	$push58=, 0
	i32.sub 	$push59=, $pop58, $1
	i32.shr_s	$11=, $pop57, $pop59
.LBB0_28:                               # %if.end253
	end_block                       # label9:
	i32.shl 	$push65=, $9, $4
	i32.const	$push66=, 65280
	i32.and 	$push67=, $pop65, $pop66
	i32.const	$push68=, 255
	i32.and 	$push69=, $8, $pop68
	i32.or  	$push70=, $pop67, $pop69
	i32.shl 	$push62=, $10, $5
	i32.const	$push63=, 16711680
	i32.and 	$push64=, $pop62, $pop63
	i32.or  	$push71=, $pop70, $pop64
	i32.shl 	$push61=, $11, $6
	i32.or  	$push72=, $pop71, $pop61
	return  	$pop72
	.endfunc
.Lfunc_end0:
	.size	helper_neon_rshl_s8, .Lfunc_end0-helper_neon_rshl_s8

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
