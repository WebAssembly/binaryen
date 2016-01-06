	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/strlen-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, u
	i32.const	$1=, 0
	copy_local	$4=, $1
	copy_local	$5=, $2
BB0_1:                                  # %for.cond1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
                                        #       Child Loop BB0_3 Depth 3
                                        #       Child Loop BB0_6 Depth 3
	block   	BB0_12
	loop    	BB0_11
	i32.add 	$0=, $2, $4
	i32.const	$7=, 1
	copy_local	$6=, $1
BB0_2:                                  # %for.cond4.preheader
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
                                        #       Child Loop BB0_6 Depth 3
	loop    	BB0_10
	i32.const	$8=, u
	copy_local	$9=, $1
	block   	BB0_4
	i32.const	$push22=, 0
	i32.eq  	$push23=, $4, $pop22
	br_if   	$pop23, BB0_4
BB0_3:                                  # %for.body6
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	BB0_4
	i32.const	$push0=, u
	i32.add 	$push1=, $pop0, $9
	i32.store8	$discard=, 0($pop1), $1
	i32.const	$push2=, 1
	i32.add 	$9=, $9, $pop2
	copy_local	$8=, $5
	i32.ne  	$push3=, $4, $9
	br_if   	$pop3, BB0_3
BB0_4:                                  # %for.cond7.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$3=, 1
	i32.add 	$10=, $8, $3
	block   	BB0_8
	i32.const	$push24=, 0
	i32.eq  	$push25=, $6, $pop24
	br_if   	$pop25, BB0_8
# BB#5:                                 # %for.body9.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.add 	$10=, $8, $7
	i32.const	$9=, 0
BB0_6:                                  # %for.body9
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	BB0_7
	i32.add 	$push4=, $8, $9
	i32.const	$push5=, 97
	i32.store8	$discard=, 0($pop4), $pop5
	i32.add 	$9=, $9, $3
	i32.ne  	$push6=, $6, $9
	br_if   	$pop6, BB0_6
BB0_7:                                  # %for.end13.loopexit
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.add 	$8=, $8, $6
BB0_8:                                  # %for.end13
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$push7=, 0
	i32.store8	$9=, 0($8), $pop7
	i32.const	$push8=, 98
	i32.store8	$push9=, 0($10), $pop8
	i32.store8	$push10=, 1($10), $pop9
	i32.store8	$push11=, 2($10), $pop10
	i32.store8	$push12=, 3($10), $pop11
	i32.store8	$push13=, 4($10), $pop12
	i32.store8	$push14=, 5($10), $pop13
	i32.store8	$push15=, 6($10), $pop14
	i32.store8	$discard=, 7($10), $pop15
	i32.call	$push16=, strlen, $0
	i32.ne  	$push17=, $6, $pop16
	br_if   	$pop17, BB0_12
# BB#9:                                 # %for.cond1
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.add 	$6=, $6, $3
	i32.add 	$7=, $7, $3
	i32.const	$push18=, 63
	i32.le_u	$push19=, $6, $pop18
	br_if   	$pop19, BB0_2
BB0_10:                                 # %for.inc26
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.add 	$4=, $4, $3
	i32.add 	$5=, $5, $3
	i32.const	$push20=, 8
	i32.lt_u	$push21=, $4, $pop20
	br_if   	$pop21, BB0_1
BB0_11:                                 # %for.end28
	call    	exit, $9
	unreachable
BB0_12:                                 # %if.then
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	u,@object               # @u
	.lcomm	u,96,4

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
