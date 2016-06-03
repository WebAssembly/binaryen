	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20011126-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, .L.str
	i32.const	$push9=, 0
	i32.load	$push10=, __stack_pointer($pop9)
	i32.const	$push11=, 16
	i32.sub 	$push14=, $pop10, $pop11
	i32.const	$push12=, 12
	i32.add 	$push13=, $pop14, $pop12
	copy_local	$4=, $pop13
.LBB0_1:                                # %while.body.outer.outer.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
                                        #       Child Loop BB0_4 Depth 3
                                        #     Child Loop BB0_9 Depth 2
	loop                            # label0:
	copy_local	$1=, $4
	copy_local	$push19=, $5
	tee_local	$push18=, $0=, $pop19
	i32.load8_u	$push17=, 0($pop18)
	tee_local	$push16=, $2=, $pop17
	copy_local	$5=, $pop16
.LBB0_2:                                # %while.body.outer.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_4 Depth 3
	block
	block
	block
	loop                            # label5:
	i32.const	$push21=, 255
	i32.and 	$push0=, $5, $pop21
	i32.const	$push20=, 97
	i32.ne  	$push1=, $pop0, $pop20
	br_if   	2, $pop1        # 2: down to label4
# BB#3:                                 # %while.cond2.i.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$5=, 0
	copy_local	$6=, $0
.LBB0_4:                                # %while.cond2.i
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label7:
	copy_local	$push30=, $5
	tee_local	$push29=, $7=, $pop30
	i32.const	$push28=, 1
	i32.add 	$5=, $pop29, $pop28
	copy_local	$push27=, $6
	tee_local	$push26=, $3=, $pop27
	i32.const	$push25=, 1
	i32.add 	$6=, $pop26, $pop25
	i32.load8_u	$push24=, 1($3)
	tee_local	$push23=, $4=, $pop24
	i32.const	$push22=, 120
	i32.eq  	$push2=, $pop23, $pop22
	br_if   	0, $pop2        # 0: up to label7
# BB#5:                                 # %while.cond2.i
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop                        # label8:
	i32.const	$push31=, 98
	i32.eq  	$push3=, $4, $pop31
	br_if   	3, $pop3        # 3: down to label3
# BB#6:                                 # %while.cond11.preheader.i
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$5=, 97
	i32.ge_u	$push5=, $0, $6
	br_if   	0, $pop5        # 0: up to label5
# BB#7:                                 # %while.body14.i.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label6:
	i32.store8	$drop=, 0($1), $2
	i32.const	$push33=, 1
	i32.add 	$4=, $1, $pop33
	i32.const	$push32=, 1
	i32.add 	$5=, $0, $pop32
	i32.ge_u	$push6=, $0, $3
	br_if   	3, $pop6        # 3: up to label0
# BB#8:                                 # %while.body14.while.body14_crit_edge.i.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push34=, 0
	i32.sub 	$0=, $pop34, $0
	i32.add 	$3=, $1, $3
.LBB0_9:                                # %while.body14.while.body14_crit_edge.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label9:
	i32.load8_u	$push7=, 0($5)
	i32.store8	$drop=, 0($4), $pop7
	i32.const	$push39=, 1
	i32.add 	$4=, $4, $pop39
	i32.const	$push38=, 1
	i32.add 	$5=, $5, $pop38
	i32.const	$push37=, -1
	i32.add 	$push36=, $7, $pop37
	tee_local	$push35=, $7=, $pop36
	br_if   	0, $pop35       # 0: up to label9
	br      	4               # 4: down to label2
.LBB0_10:                               # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	end_loop                        # label10:
	end_block                       # label4:
	loop                            # label11:
	br      	0               # 0: up to label11
.LBB0_11:                               # %test.exit
	end_loop                        # label12:
	end_block                       # label3:
	i32.const	$push4=, 0
	return  	$pop4
.LBB0_12:                               # %while.body.outer.outer.i.loopexit
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	i32.add 	$push8=, $3, $0
	i32.const	$push15=, 1
	i32.add 	$4=, $pop8, $pop15
	copy_local	$5=, $6
	br      	0               # 0: up to label0
.LBB0_13:
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
