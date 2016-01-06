	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/950714-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$9=, 0
	i32.load	$0=, array($9)
	i32.load	$1=, array+4($9)
	i32.load	$2=, array+8($9)
	i32.load	$3=, array+12($9)
	i32.load	$4=, array+16($9)
	i32.load	$5=, array+20($9)
	i32.load	$6=, array+24($9)
	i32.load	$7=, array+28($9)
	i32.load	$8=, array+32($9)
BB0_1:                                  # %for.cond1.preheader
                                        # =>This Inner Loop Header: Depth=1
	block   	BB0_13
	loop    	BB0_11
	i32.eq  	$push0=, $0, $9
	br_if   	$pop0, BB0_11
# BB#2:                                 # %for.cond1.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.eq  	$push1=, $1, $9
	br_if   	$pop1, BB0_11
# BB#3:                                 # %for.cond1.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.eq  	$push2=, $2, $9
	br_if   	$pop2, BB0_11
# BB#4:                                 # %for.cond1.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.eq  	$push3=, $3, $9
	br_if   	$pop3, BB0_11
# BB#5:                                 # %for.cond1.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.eq  	$push4=, $4, $9
	br_if   	$pop4, BB0_11
# BB#6:                                 # %for.cond1.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.eq  	$push5=, $5, $9
	br_if   	$pop5, BB0_11
# BB#7:                                 # %for.cond1.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.eq  	$push6=, $6, $9
	br_if   	$pop6, BB0_11
# BB#8:                                 # %for.cond1.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.eq  	$push7=, $7, $9
	br_if   	$pop7, BB0_11
# BB#9:                                 # %for.cond1.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.eq  	$push8=, $8, $9
	br_if   	$pop8, BB0_11
# BB#10:                                # %for.cond1.8
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push9=, 1
	i32.add 	$9=, $9, $pop9
	i32.const	$push10=, 10
	i32.lt_s	$push11=, $9, $pop10
	br_if   	$pop11, BB0_1
	br      	BB0_13
BB0_11:                                 # %label
	i32.const	$push12=, 1
	i32.ne  	$push13=, $9, $pop12
	br_if   	$pop13, BB0_13
# BB#12:                                # %if.end9
	i32.const	$push14=, 0
	call    	exit, $pop14
	unreachable
BB0_13:                                 # %if.then8
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	array,@object           # @array
	.data
	.globl	array
	.align	4
array:
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.int32	1                       # 0x1
	.size	array, 40


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
