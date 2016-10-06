	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20011126-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, .L.str
	i32.const	$push11=, 0
	i32.load	$push12=, __stack_pointer($pop11)
	i32.const	$push13=, 16
	i32.sub 	$push16=, $pop12, $pop13
	i32.const	$push14=, 12
	i32.add 	$push15=, $pop16, $pop14
	copy_local	$0=, $pop15
.LBB0_1:                                # %while.body.outer.outer.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
                                        #       Child Loop BB0_4 Depth 3
                                        #     Child Loop BB0_9 Depth 2
	block   	
	loop    	                # label1:
	i32.load8_u	$push19=, 0($5)
	tee_local	$push18=, $1=, $pop19
	copy_local	$6=, $pop18
.LBB0_2:                                # %while.body.outer.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_4 Depth 3
	block   	
	loop    	                # label3:
	i32.const	$push21=, 255
	i32.and 	$push0=, $6, $pop21
	i32.const	$push20=, 97
	i32.ne  	$push1=, $pop0, $pop20
	br_if   	1, $pop1        # 1: down to label2
# BB#3:                                 # %while.cond2.i.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$6=, 0
	copy_local	$7=, $5
.LBB0_4:                                # %while.cond2.i
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label4:
	copy_local	$push32=, $6
	tee_local	$push31=, $8=, $pop32
	i32.const	$push30=, 1
	i32.add 	$6=, $pop31, $pop30
	copy_local	$push29=, $7
	tee_local	$push28=, $2=, $pop29
	i32.const	$push27=, 1
	i32.add 	$push26=, $pop28, $pop27
	tee_local	$push25=, $7=, $pop26
	i32.load8_u	$push24=, 0($pop25)
	tee_local	$push23=, $4=, $pop24
	i32.const	$push22=, 120
	i32.eq  	$push2=, $pop23, $pop22
	br_if   	0, $pop2        # 0: up to label4
# BB#5:                                 # %while.cond2.i
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop
	i32.const	$push33=, 98
	i32.eq  	$push3=, $4, $pop33
	br_if   	3, $pop3        # 3: down to label0
# BB#6:                                 # %while.cond11.preheader.i
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.const	$6=, 97
	i32.ge_u	$push5=, $5, $7
	br_if   	0, $pop5        # 0: up to label3
# BB#7:                                 # %while.body14.preheader.i
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop
	i32.store8	0($0), $1
	i32.const	$push35=, 1
	i32.add 	$6=, $5, $pop35
	i32.const	$push34=, 0
	i32.sub 	$3=, $pop34, $5
	i32.gt_u	$push6=, $5, $2
	i32.select	$push7=, $5, $2, $pop6
	i32.add 	$1=, $0, $pop7
	block   	
	block   	
	i32.ge_u	$push8=, $5, $2
	br_if   	0, $pop8        # 0: down to label6
# BB#8:                                 # %while.body14.while.body14_crit_edge.i.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push36=, 1
	i32.add 	$4=, $0, $pop36
.LBB0_9:                                # %while.body14.while.body14_crit_edge.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label7:
	i32.load8_u	$push9=, 0($6)
	i32.store8	0($4), $pop9
	i32.const	$push41=, 1
	i32.add 	$4=, $4, $pop41
	i32.const	$push40=, 1
	i32.add 	$6=, $6, $pop40
	i32.const	$push39=, -1
	i32.add 	$push38=, $8, $pop39
	tee_local	$push37=, $8=, $pop38
	br_if   	0, $pop37       # 0: up to label7
# BB#10:                                #   in Loop: Header=BB0_1 Depth=1
	end_loop
	copy_local	$5=, $7
	br      	1               # 1: down to label5
.LBB0_11:                               #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label6:
	copy_local	$5=, $6
.LBB0_12:                               # %while.body.outer.loopexit.i
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label5:
	i32.add 	$push10=, $1, $3
	i32.const	$push17=, 1
	i32.add 	$0=, $pop10, $pop17
	br      	1               # 1: up to label1
.LBB0_13:                               # %while.body.i
                                        # =>This Inner Loop Header: Depth=1
	end_block                       # label2:
	end_loop
	loop    	                # label8:
	br      	0               # 0: up to label8
.LBB0_14:                               # %test.exit
	end_loop
	end_block                       # label0:
	i32.const	$push4=, 0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"aab"
	.size	.L.str, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
