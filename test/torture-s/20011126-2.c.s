	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20011126-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push11=, __stack_pointer
	i32.load	$push12=, 0($pop11)
	i32.const	$push13=, 16
	i32.sub 	$push16=, $pop12, $pop13
	i32.const	$push14=, 12
	i32.add 	$push15=, $pop16, $pop14
	copy_local	$3=, $pop15
	i32.const	$1=, .L.str
.LBB0_1:                                # %while.body.outer.outer.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
                                        #       Child Loop BB0_3 Depth 3
                                        #     Child Loop BB0_8 Depth 2
	loop                            # label0:
	copy_local	$2=, $1
	copy_local	$0=, $3
	i32.load8_u	$push19=, 0($2)
	tee_local	$push18=, $1=, $pop19
	copy_local	$3=, $pop18
.LBB0_2:                                # %while.body.outer.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
	block
	block
	block
	loop                            # label5:
	copy_local	$4=, $2
	i32.const	$push21=, 255
	i32.and 	$push1=, $3, $pop21
	i32.const	$push20=, 97
	i32.ne  	$push2=, $pop1, $pop20
	br_if   	2, $pop2        # 2: down to label4
.LBB0_3:                                # %while.cond2.i
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label7:
	copy_local	$push29=, $4
	tee_local	$push28=, $5=, $pop29
	i32.const	$push27=, 1
	i32.add 	$push26=, $pop28, $pop27
	tee_local	$push25=, $4=, $pop26
	i32.load8_u	$push24=, 0($pop25)
	tee_local	$push23=, $3=, $pop24
	i32.const	$push22=, 120
	i32.eq  	$push3=, $pop23, $pop22
	br_if   	0, $pop3        # 0: up to label7
# BB#4:                                 # %while.cond2.i
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label8:
	i32.const	$push30=, 98
	i32.eq  	$push4=, $3, $pop30
	br_if   	3, $pop4        # 3: down to label3
# BB#5:                                 # %while.cond11.preheader.i
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$3=, 97
	i32.ge_u	$push6=, $2, $4
	br_if   	0, $pop6        # 0: up to label5
# BB#6:                                 # %while.body14.i.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label6:
	i32.store8	$discard=, 0($0), $1
	i32.const	$push32=, 1
	i32.add 	$1=, $2, $pop32
	i32.const	$push31=, 1
	i32.add 	$3=, $0, $pop31
	i32.ge_u	$push7=, $2, $5
	br_if   	3, $pop7        # 3: up to label0
# BB#7:                                 # %while.body14.while.body14_crit_edge.i.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.add 	$1=, $0, $5
	i32.const	$push33=, 0
	i32.sub 	$0=, $pop33, $2
.LBB0_8:                                # %while.body14.while.body14_crit_edge.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label9:
	i32.const	$push35=, 1
	i32.add 	$2=, $2, $pop35
	i32.load8_u	$push8=, 0($2)
	i32.store8	$discard=, 0($3), $pop8
	i32.const	$push34=, 1
	i32.add 	$push0=, $3, $pop34
	copy_local	$3=, $pop0
	i32.ne  	$push9=, $5, $2
	br_if   	0, $pop9        # 0: up to label9
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
	i32.const	$push5=, 0
	return  	$pop5
.LBB0_11:                               # %while.body.outer.outer.i.loopexit
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.add 	$push10=, $1, $0
	i32.const	$push17=, 1
	i32.add 	$3=, $pop10, $pop17
	copy_local	$1=, $4
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
