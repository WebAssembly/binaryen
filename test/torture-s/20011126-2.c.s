	.text
	.file	"20011126-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, .L.str
	i32.const	$push12=, 0
	i32.load	$push11=, __stack_pointer($pop12)
	i32.const	$push13=, 16
	i32.sub 	$push16=, $pop11, $pop13
	i32.const	$push14=, 12
	i32.add 	$push15=, $pop16, $pop14
	copy_local	$6=, $pop15
.LBB0_1:                                # %while.body.i.outer
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
                                        #       Child Loop BB0_4 Depth 3
                                        #     Child Loop BB0_9 Depth 2
	loop    	                # label0:
	i32.load8_u	$0=, 0($5)
.LBB0_2:                                # %while.body.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_4 Depth 3
	block   	
	loop    	                # label2:
	i32.const	$push19=, 255
	i32.and 	$push0=, $0, $pop19
	i32.const	$push18=, 97
	i32.ne  	$push1=, $pop0, $pop18
	br_if   	0, $pop1        # 0: up to label2
# BB#3:                                 # %while.cond2.i.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	copy_local	$7=, $5
.LBB0_4:                                # %while.cond2.i
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label3:
	i32.load8_u	$4=, 1($7)
	i32.const	$push23=, 1
	i32.add 	$push22=, $7, $pop23
	tee_local	$push21=, $1=, $pop22
	copy_local	$7=, $pop21
	i32.const	$push20=, 120
	i32.eq  	$push2=, $4, $pop20
	br_if   	0, $pop2        # 0: up to label3
# BB#5:                                 # %while.cond2.i
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop
	i32.const	$push24=, 98
	i32.eq  	$push3=, $4, $pop24
	br_if   	1, $pop3        # 1: down to label1
# BB#6:                                 # %if.end.i
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.ge_u	$push5=, $5, $1
	br_if   	0, $pop5        # 0: up to label2
# BB#7:                                 # %while.body14.lr.ph.i
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop
	i32.const	$push30=, 97
	i32.store8	0($6), $pop30
	i32.const	$push29=, -1
	i32.add 	$push28=, $1, $pop29
	tee_local	$push27=, $0=, $pop28
	i32.gt_u	$push6=, $5, $0
	i32.select	$push7=, $5, $pop27, $pop6
	i32.add 	$2=, $6, $pop7
	i32.const	$push26=, 1
	i32.add 	$7=, $5, $pop26
	i32.const	$push25=, 0
	i32.sub 	$3=, $pop25, $5
	block   	
	block   	
	i32.ge_u	$push8=, $5, $0
	br_if   	0, $pop8        # 0: down to label5
# BB#8:                                 # %while.body14.while.body14_crit_edge.i.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push31=, 1
	i32.add 	$4=, $6, $pop31
.LBB0_9:                                # %while.body14.while.body14_crit_edge.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label6:
	i32.load8_u	$push9=, 0($7)
	i32.store8	0($4), $pop9
	i32.const	$push35=, 1
	i32.add 	$4=, $4, $pop35
	i32.lt_u	$1=, $7, $0
	i32.const	$push34=, 1
	i32.add 	$push33=, $7, $pop34
	tee_local	$push32=, $5=, $pop33
	copy_local	$7=, $pop32
	br_if   	0, $1           # 0: up to label6
	br      	2               # 2: down to label4
.LBB0_10:                               #   in Loop: Header=BB0_1 Depth=1
	end_loop
	end_block                       # label5:
	copy_local	$5=, $7
.LBB0_11:                               # %if.end18.loopexit.i
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label4:
	i32.add 	$push10=, $2, $3
	i32.const	$push17=, 1
	i32.add 	$6=, $pop10, $pop17
	br      	1               # 1: up to label0
.LBB0_12:                               # %test.exit
	end_block                       # label1:
	end_loop
	i32.const	$push4=, 0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"aab"
	.size	.L.str, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
