	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20011126-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$7=, __stack_pointer
	i32.load	$7=, 0($7)
	i32.const	$8=, 16
	i32.sub 	$11=, $7, $8
	i32.const	$8=, __stack_pointer
	i32.store	$11=, 0($8), $11
	i32.const	$10=, 12
	i32.add 	$10=, $11, $10
	copy_local	$5=, $10
	i32.const	$1=, .L.str
.LBB0_1:                                # %while.body.outer.outer.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
                                        #       Child Loop BB0_3 Depth 3
                                        #     Child Loop BB0_8 Depth 2
	loop                            # label0:
	copy_local	$push12=, $1
	tee_local	$push11=, $4=, $pop12
	i32.load8_u	$1=, 0($pop11)
	copy_local	$0=, $5
	copy_local	$5=, $1
.LBB0_2:                                # %while.body.outer.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
	block
	block
	block
	loop                            # label5:
	copy_local	$3=, $4
	i32.const	$push14=, 255
	i32.and 	$push0=, $5, $pop14
	i32.const	$push13=, 97
	i32.ne  	$push1=, $pop0, $pop13
	br_if   	2, $pop1        # 2: down to label4
.LBB0_3:                                # %while.cond2.i
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label7:
	copy_local	$push20=, $3
	tee_local	$push19=, $6=, $pop20
	i32.const	$push18=, 1
	i32.add 	$3=, $pop19, $pop18
	i32.load8_u	$push17=, 0($3)
	tee_local	$push16=, $5=, $pop17
	i32.const	$push15=, 120
	i32.eq  	$push2=, $pop16, $pop15
	br_if   	0, $pop2        # 0: up to label7
# BB#4:                                 # %while.cond2.i
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label8:
	i32.const	$push21=, 98
	i32.eq  	$push3=, $5, $pop21
	br_if   	3, $pop3        # 3: down to label3
# BB#5:                                 # %while.cond11.preheader.i
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$5=, 97
	i32.ge_u	$push5=, $4, $3
	br_if   	0, $pop5        # 0: up to label5
# BB#6:                                 # %while.body14.i.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label6:
	i32.store8	$discard=, 0($0), $1
	i32.const	$push23=, 1
	i32.add 	$1=, $4, $pop23
	i32.const	$push22=, 1
	i32.add 	$5=, $0, $pop22
	i32.ge_u	$push6=, $4, $6
	br_if   	3, $pop6        # 3: up to label0
# BB#7:                                 # %while.body14.while.body14_crit_edge.i.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.add 	$0=, $0, $6
	i32.const	$push24=, 0
	i32.sub 	$2=, $pop24, $4
.LBB0_8:                                # %while.body14.while.body14_crit_edge.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label9:
	i32.const	$push26=, 1
	i32.add 	$4=, $4, $pop26
	i32.const	$push25=, 1
	i32.add 	$1=, $5, $pop25
	i32.load8_u	$push7=, 0($4)
	i32.store8	$discard=, 0($5), $pop7
	copy_local	$5=, $1
	i32.ne  	$push8=, $6, $4
	br_if   	0, $pop8        # 0: up to label9
	br      	4               # 4: down to label2
.LBB0_9:                                # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label10:
	end_block                       # label4:
	loop                            # label11:
	br      	0               # 0: up to label11
.LBB0_10:                               # %test.exit
	end_loop                        # label12:
	end_block                       # label3:
	i32.const	$push4=, 0
	i32.const	$9=, 16
	i32.add 	$11=, $11, $9
	i32.const	$9=, __stack_pointer
	i32.store	$11=, 0($9), $11
	return  	$pop4
.LBB0_11:                               # %while.body.outer.outer.i.loopexit
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.add 	$push9=, $0, $2
	i32.const	$push10=, 1
	i32.add 	$5=, $pop9, $pop10
	copy_local	$1=, $3
	br      	0               # 0: up to label0
.LBB0_12:
	end_loop                        # label1:
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"aab"
	.size	.L.str, 4


	.ident	"clang version 3.9.0 "
