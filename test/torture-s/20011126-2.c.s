	.text
	.file	"20011126-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
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
# %bb.3:                                # %while.cond2.i.preheader
                                        #   in Loop: Header=BB0_2 Depth=2
	copy_local	$7=, $5
.LBB0_4:                                # %while.cond2.i
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label3:
	i32.const	$push21=, 1
	i32.add 	$1=, $7, $pop21
	i32.load8_u	$4=, 1($7)
	copy_local	$7=, $1
	i32.const	$push20=, 120
	i32.eq  	$push2=, $4, $pop20
	br_if   	0, $pop2        # 0: up to label3
# %bb.5:                                # %while.cond2.i
                                        #   in Loop: Header=BB0_2 Depth=2
	end_loop
	i32.const	$push22=, 98
	i32.eq  	$push3=, $4, $pop22
	br_if   	1, $pop3        # 1: down to label1
# %bb.6:                                # %if.end.i
                                        #   in Loop: Header=BB0_2 Depth=2
	i32.ge_u	$push5=, $5, $1
	br_if   	0, $pop5        # 0: up to label2
# %bb.7:                                # %while.body14.lr.ph.i
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop
	i32.const	$push26=, 97
	i32.store8	0($6), $pop26
	i32.const	$push25=, -1
	i32.add 	$0=, $1, $pop25
	i32.gt_u	$push6=, $5, $0
	i32.select	$push7=, $5, $0, $pop6
	i32.add 	$2=, $6, $pop7
	i32.const	$push24=, 1
	i32.add 	$7=, $5, $pop24
	i32.const	$push23=, 0
	i32.sub 	$3=, $pop23, $5
	block   	
	block   	
	i32.ge_u	$push8=, $5, $0
	br_if   	0, $pop8        # 0: down to label5
# %bb.8:                                # %while.body14.while.body14_crit_edge.i.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push27=, 1
	i32.add 	$4=, $6, $pop27
.LBB0_9:                                # %while.body14.while.body14_crit_edge.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label6:
	i32.load8_u	$push9=, 0($7)
	i32.store8	0($4), $pop9
	i32.const	$push29=, 1
	i32.add 	$4=, $4, $pop29
	i32.const	$push28=, 1
	i32.add 	$5=, $7, $pop28
	i32.lt_u	$1=, $7, $0
	copy_local	$7=, $5
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
