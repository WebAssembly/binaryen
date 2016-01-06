	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr48809.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	BB0_37
	block   	BB0_33
	i32.const	$push0=, 32
	i32.gt_u	$push1=, $0, $pop0
	br_if   	$pop1, BB0_33
# BB#1:                                 # %entry
	block   	BB0_32
	block   	BB0_31
	block   	BB0_30
	block   	BB0_29
	block   	BB0_28
	block   	BB0_27
	block   	BB0_26
	block   	BB0_25
	block   	BB0_24
	block   	BB0_23
	block   	BB0_22
	block   	BB0_21
	block   	BB0_20
	block   	BB0_19
	block   	BB0_18
	block   	BB0_17
	block   	BB0_16
	block   	BB0_15
	block   	BB0_14
	block   	BB0_13
	block   	BB0_12
	block   	BB0_11
	block   	BB0_10
	block   	BB0_9
	block   	BB0_8
	block   	BB0_7
	block   	BB0_6
	block   	BB0_5
	block   	BB0_4
	block   	BB0_3
	block   	BB0_2
	tableswitch	$0, BB0_2, BB0_2, BB0_3, BB0_37, BB0_4, BB0_5, BB0_6, BB0_7, BB0_8, BB0_9, BB0_10, BB0_11, BB0_12, BB0_13, BB0_14, BB0_15, BB0_16, BB0_17, BB0_18, BB0_19, BB0_37, BB0_20, BB0_21, BB0_22, BB0_23, BB0_24, BB0_25, BB0_26, BB0_27, BB0_28, BB0_29, BB0_30, BB0_31, BB0_32
BB0_2:                                  # %sw.bb
	i32.const	$0=, 1
	br      	BB0_37
BB0_3:                                  # %sw.bb1
	i32.const	$0=, 7
	br      	BB0_37
BB0_4:                                  # %sw.bb3
	i32.const	$0=, 19
	br      	BB0_37
BB0_5:                                  # %sw.bb4
	i32.const	$0=, 5
	br      	BB0_37
BB0_6:                                  # %sw.bb5
	i32.const	$0=, 17
	br      	BB0_37
BB0_7:                                  # %sw.bb6
	i32.const	$0=, 31
	br      	BB0_37
BB0_8:                                  # %sw.bb7
	i32.const	$0=, 8
	br      	BB0_37
BB0_9:                                  # %sw.bb8
	i32.const	$0=, 28
	br      	BB0_37
BB0_10:                                 # %sw.bb9
	i32.const	$0=, 16
	br      	BB0_37
BB0_11:                                 # %sw.bb10
	i32.const	$0=, 31
	br      	BB0_37
BB0_12:                                 # %sw.bb11
	i32.const	$0=, 12
	br      	BB0_37
BB0_13:                                 # %sw.bb12
	i32.const	$0=, 15
	br      	BB0_37
BB0_14:                                 # %sw.bb13
	i32.const	$0=, 111
	br      	BB0_37
BB0_15:                                 # %sw.bb14
	i32.const	$0=, 17
	br      	BB0_37
BB0_16:                                 # %sw.bb15
	i32.const	$0=, 10
	br      	BB0_37
BB0_17:                                 # %sw.bb16
	i32.const	$0=, 31
	br      	BB0_37
BB0_18:                                 # %sw.bb17
	i32.const	$0=, 7
	br      	BB0_37
BB0_19:                                 # %sw.bb18
	i32.const	$0=, 2
	br      	BB0_37
BB0_20:                                 # %sw.bb20
	i32.const	$0=, 5
	br      	BB0_37
BB0_21:                                 # %sw.bb21
	i32.const	$0=, 107
	br      	BB0_37
BB0_22:                                 # %sw.bb22
	i32.const	$0=, 31
	br      	BB0_37
BB0_23:                                 # %sw.bb23
	i32.const	$0=, 8
	br      	BB0_37
BB0_24:                                 # %sw.bb24
	i32.const	$0=, 28
	br      	BB0_37
BB0_25:                                 # %sw.bb25
	i32.const	$0=, 106
	br      	BB0_37
BB0_26:                                 # %sw.bb26
	i32.const	$0=, 31
	br      	BB0_37
BB0_27:                                 # %sw.bb27
	i32.const	$0=, 102
	br      	BB0_37
BB0_28:                                 # %sw.bb28
	i32.const	$0=, 105
	br      	BB0_37
BB0_29:                                 # %sw.bb29
	i32.const	$0=, 111
	br      	BB0_37
BB0_30:                                 # %sw.bb30
	i32.const	$0=, 17
	br      	BB0_37
BB0_31:                                 # %sw.bb31
	i32.const	$0=, 10
	br      	BB0_37
BB0_32:                                 # %sw.bb32
	i32.const	$0=, 31
	br      	BB0_37
BB0_33:                                 # %entry
	block   	BB0_36
	i32.const	$push2=, -62
	i32.eq  	$push3=, $0, $pop2
	br_if   	$pop3, BB0_36
# BB#34:                                # %entry
	i32.const	$1=, 0
	i32.const	$push4=, 98
	i32.eq  	$2=, $0, $pop4
	copy_local	$0=, $1
	i32.const	$push5=, 0
	i32.eq  	$push6=, $2, $pop5
	br_if   	$pop6, BB0_37
# BB#35:                                # %sw.bb33
	i32.const	$0=, 18
	br      	BB0_37
BB0_36:                                 # %sw.bb34
	i32.const	$0=, 19
BB0_37:                                 # %sw.epilog
	return  	$0
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end25
	i32.const	$push0=, 0
	return  	$pop0
func_end1:
	.size	main, func_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
