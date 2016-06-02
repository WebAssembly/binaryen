	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20011126-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, .L.str
	i32.const	$push10=, 0
	i32.load	$push11=, __stack_pointer($pop10)
	i32.const	$push12=, 16
	i32.sub 	$push15=, $pop11, $pop12
	i32.const	$push13=, 12
	i32.add 	$push14=, $pop15, $pop13
	copy_local	$3=, $pop14
.LBB0_1:                                # %while.body.outer.outer.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
                                        #       Child Loop BB0_3 Depth 3
                                        #     Child Loop BB0_8 Depth 2
	loop                            # label0:
	copy_local	$0=, $3
	copy_local	$push20=, $4
	tee_local	$push19=, $6=, $pop20
	i32.load8_u	$push18=, 0($pop19)
	tee_local	$push17=, $4=, $pop18
	copy_local	$3=, $pop17
.LBB0_2:                                # %while.body.outer.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_3 Depth 3
	block
	block
	block
	loop                            # label5:
	copy_local	$5=, $6
	i32.const	$push22=, 255
	i32.and 	$push0=, $3, $pop22
	i32.const	$push21=, 97
	i32.ne  	$push1=, $pop0, $pop21
	br_if   	2, $pop1        # 2: down to label4
.LBB0_3:                                # %while.cond2.i
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label7:
	copy_local	$push30=, $5
	tee_local	$push29=, $1=, $pop30
	i32.const	$push28=, 1
	i32.add 	$push27=, $pop29, $pop28
	tee_local	$push26=, $5=, $pop27
	i32.load8_u	$push25=, 0($pop26)
	tee_local	$push24=, $3=, $pop25
	i32.const	$push23=, 120
	i32.eq  	$push2=, $pop24, $pop23
	br_if   	0, $pop2        # 0: up to label7
# BB#4:                                 # %while.cond2.i
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label8:
	i32.const	$push31=, 98
	i32.eq  	$push3=, $3, $pop31
	br_if   	3, $pop3        # 3: down to label3
# BB#5:                                 # %while.cond11.preheader.i
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$3=, 97
	i32.ge_u	$push5=, $6, $5
	br_if   	0, $pop5        # 0: up to label5
# BB#6:                                 # %while.body14.i.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label6:
	i32.store8	$drop=, 0($0), $4
	i32.const	$push33=, 1
	i32.add 	$3=, $0, $pop33
	i32.const	$push32=, 1
	i32.add 	$4=, $6, $pop32
	i32.ge_u	$push6=, $6, $1
	br_if   	3, $pop6        # 3: up to label0
# BB#7:                                 # %while.body14.while.body14_crit_edge.i.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push34=, 0
	i32.sub 	$2=, $pop34, $6
	i32.add 	$4=, $0, $1
.LBB0_8:                                # %while.body14.while.body14_crit_edge.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label9:
	i32.const	$push38=, 1
	i32.add 	$push37=, $6, $pop38
	tee_local	$push36=, $6=, $pop37
	i32.load8_u	$push7=, 0($pop36)
	i32.store8	$drop=, 0($3), $pop7
	i32.const	$push35=, 1
	i32.add 	$3=, $3, $pop35
	i32.ne  	$push8=, $1, $6
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
	return  	$pop4
.LBB0_11:                               # %while.body.outer.outer.i.loopexit
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.add 	$push9=, $4, $2
	i32.const	$push16=, 1
	i32.add 	$3=, $pop9, $pop16
	copy_local	$4=, $5
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
