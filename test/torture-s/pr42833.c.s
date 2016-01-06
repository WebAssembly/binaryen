	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr42833.c"
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
	block   	BB0_7
	i32.const	$push0=, 117440512
	i32.gt_s	$push1=, $7, $pop0
	br_if   	$pop1, BB0_7
# BB#1:                                 # %if.else
	block   	BB0_3
	i32.const	$push2=, -134217729
	i32.gt_s	$push3=, $7, $pop2
	br_if   	$pop3, BB0_3
# BB#2:                                 # %if.then13
	i32.shl 	$push14=, $0, $6
	i32.const	$push15=, 31
	i32.shr_s	$8=, $pop14, $pop15
	br      	BB0_7
BB0_3:                                  # %if.else18
	i32.shr_s	$4=, $7, $6
	copy_local	$8=, $11
	i32.const	$push4=, -8
	i32.eq  	$push5=, $4, $pop4
	br_if   	$pop5, BB0_7
# BB#4:                                 # %if.else34
	i32.shl 	$push6=, $0, $6
	i32.shr_s	$8=, $pop6, $6
	i32.const	$3=, -1
	block   	BB0_6
	i32.le_s	$push7=, $7, $3
	br_if   	$pop7, BB0_6
# BB#5:                                 # %if.else48
	i32.shl 	$8=, $8, $4
	br      	BB0_7
BB0_6:                                  # %if.then38
	i32.const	$push9=, 1
	i32.xor 	$push8=, $4, $3
	i32.shl 	$push10=, $pop9, $pop8
	i32.add 	$push11=, $pop10, $8
	i32.const	$push12=, 0
	i32.sub 	$push13=, $pop12, $4
	i32.shr_s	$8=, $pop11, $pop13
BB0_7:                                  # %if.end57
	i32.shl 	$push16=, $1, $5
	i32.shr_s	$3=, $pop16, $6
	i32.const	$4=, 8
	i32.const	$7=, 7
	copy_local	$9=, $11
	block   	BB0_14
	i32.gt_s	$push17=, $3, $7
	br_if   	$pop17, BB0_14
# BB#8:                                 # %if.else68
	i32.shr_u	$10=, $0, $4
	block   	BB0_10
	i32.const	$push18=, -9
	i32.gt_s	$push19=, $3, $pop18
	br_if   	$pop19, BB0_10
# BB#9:                                 # %if.then72
	i32.shl 	$push30=, $10, $6
	i32.const	$push31=, 31
	i32.shr_s	$9=, $pop30, $pop31
	br      	BB0_14
BB0_10:                                 # %if.else78
	copy_local	$9=, $11
	i32.const	$push20=, -8
	i32.eq  	$push21=, $3, $pop20
	br_if   	$pop21, BB0_14
# BB#11:                                # %if.else96
	i32.shl 	$push22=, $10, $6
	i32.shr_s	$10=, $pop22, $6
	i32.const	$9=, -1
	block   	BB0_13
	i32.le_s	$push23=, $3, $9
	br_if   	$pop23, BB0_13
# BB#12:                                # %if.else112
	i32.shl 	$9=, $10, $3
	br      	BB0_14
BB0_13:                                 # %if.then100
	i32.const	$push25=, 1
	i32.xor 	$push24=, $3, $9
	i32.shl 	$push26=, $pop25, $pop24
	i32.add 	$push27=, $pop26, $10
	i32.const	$push28=, 0
	i32.sub 	$push29=, $pop28, $3
	i32.shr_s	$9=, $pop27, $pop29
BB0_14:                                 # %if.end122
	i32.shl 	$push32=, $1, $4
	i32.shr_s	$3=, $pop32, $6
	copy_local	$10=, $11
	block   	BB0_21
	i32.gt_s	$push33=, $3, $7
	br_if   	$pop33, BB0_21
# BB#15:                                # %if.else133
	i32.shr_u	$2=, $0, $5
	block   	BB0_17
	i32.const	$push34=, -9
	i32.gt_s	$push35=, $3, $pop34
	br_if   	$pop35, BB0_17
# BB#16:                                # %if.then137
	i32.shl 	$push46=, $2, $6
	i32.const	$push47=, 31
	i32.shr_s	$10=, $pop46, $pop47
	br      	BB0_21
BB0_17:                                 # %if.else143
	copy_local	$10=, $11
	i32.const	$push36=, -8
	i32.eq  	$push37=, $3, $pop36
	br_if   	$pop37, BB0_21
# BB#18:                                # %if.else161
	i32.shl 	$push38=, $2, $6
	i32.shr_s	$2=, $pop38, $6
	i32.const	$10=, -1
	block   	BB0_20
	i32.le_s	$push39=, $3, $10
	br_if   	$pop39, BB0_20
# BB#19:                                # %if.else177
	i32.shl 	$10=, $2, $3
	br      	BB0_21
BB0_20:                                 # %if.then165
	i32.const	$push41=, 1
	i32.xor 	$push40=, $3, $10
	i32.shl 	$push42=, $pop41, $pop40
	i32.add 	$push43=, $pop42, $2
	i32.const	$push44=, 0
	i32.sub 	$push45=, $pop44, $3
	i32.shr_s	$10=, $pop43, $pop45
BB0_21:                                 # %if.end187
	i32.shr_s	$1=, $1, $6
	block   	BB0_28
	i32.gt_s	$push48=, $1, $7
	br_if   	$pop48, BB0_28
# BB#22:                                # %if.else199
	block   	BB0_24
	i32.const	$push49=, -9
	i32.gt_s	$push50=, $1, $pop49
	br_if   	$pop50, BB0_24
# BB#23:                                # %if.then203
	i32.const	$push60=, 31
	i32.shr_s	$11=, $0, $pop60
	br      	BB0_28
BB0_24:                                 # %if.else209
	i32.const	$push51=, -8
	i32.eq  	$push52=, $1, $pop51
	br_if   	$pop52, BB0_28
# BB#25:                                # %if.else227
	i32.shr_s	$7=, $0, $6
	i32.const	$11=, -1
	block   	BB0_27
	i32.le_s	$push53=, $1, $11
	br_if   	$pop53, BB0_27
# BB#26:                                # %if.else243
	i32.shl 	$11=, $7, $1
	br      	BB0_28
BB0_27:                                 # %if.then231
	i32.const	$push55=, 1
	i32.xor 	$push54=, $1, $11
	i32.shl 	$push56=, $pop55, $pop54
	i32.add 	$push57=, $pop56, $7
	i32.const	$push58=, 0
	i32.sub 	$push59=, $pop58, $1
	i32.shr_s	$11=, $pop57, $pop59
BB0_28:                                 # %if.end253
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
func_end0:
	.size	helper_neon_rshl_s8, func_end0-helper_neon_rshl_s8

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
