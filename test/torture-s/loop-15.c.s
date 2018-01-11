	.text
	.file	"loop-15.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32
# %bb.0:                                # %entry
	block   	
	i32.le_u	$push0=, $1, $0
	br_if   	0, $pop0        # 0: down to label0
# %bb.1:                                # %while.body.preheader
.LBB0_2:                                # %while.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push3=, -4
	i32.add 	$2=, $1, $pop3
	i32.load	$push1=, 0($2)
	i32.store	0($1), $pop1
	copy_local	$1=, $2
	i32.gt_u	$push2=, $2, $0
	br_if   	0, $pop2        # 0: up to label1
.LBB0_3:                                # %while.end
	end_loop
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push19=, 0
	i32.load	$push18=, __stack_pointer($pop19)
	i32.const	$push20=, 32
	i32.sub 	$10=, $pop18, $pop20
	i32.const	$push21=, 0
	i32.store	__stack_pointer($pop21), $10
	i32.const	$push25=, 4
	i32.or  	$0=, $10, $pop25
	i32.const	$2=, 0
	i32.const	$push1=, 16
	i32.add 	$6=, $10, $pop1
	copy_local	$1=, $0
.LBB1_1:                                # %for.body
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
                                        #       Child Loop BB1_4 Depth 3
                                        #       Child Loop BB1_6 Depth 3
                                        #       Child Loop BB1_9 Depth 3
                                        #       Child Loop BB1_12 Depth 3
	block   	
	loop    	                # label3:
	i32.const	$push26=, 2
	i32.shl 	$push0=, $2, $pop26
	i32.add 	$3=, $10, $pop0
	copy_local	$4=, $0
	i32.const	$5=, 0
.LBB1_2:                                # %for.body3
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB1_4 Depth 3
                                        #       Child Loop BB1_6 Depth 3
                                        #       Child Loop BB1_9 Depth 3
                                        #       Child Loop BB1_12 Depth 3
	loop    	                # label4:
	i32.const	$push29=, 4
	i32.store	0($6), $pop29
	i64.const	$push28=, 4294967296
	i64.store	0($10), $pop28
	i64.const	$push27=, 12884901890
	i64.store	8($10), $pop27
	i32.le_u	$7=, $5, $2
	block   	
	br_if   	0, $7           # 0: down to label5
# %bb.3:                                # %while.body.lr.ph.i
                                        #   in Loop: Header=BB1_2 Depth=2
	i32.const	$push30=, 2
	i32.shl 	$push2=, $5, $pop30
	i32.add 	$8=, $10, $pop2
.LBB1_4:                                # %while.body.i
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label6:
	i32.const	$push31=, -4
	i32.add 	$9=, $8, $pop31
	i32.load	$push3=, 0($9)
	i32.store	0($8), $pop3
	copy_local	$8=, $9
	i32.gt_u	$push4=, $9, $3
	br_if   	0, $pop4        # 0: up to label6
.LBB1_5:                                # %for.body11.preheader
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop
	end_block                       # label5:
	i32.const	$9=, -1
	copy_local	$8=, $10
.LBB1_6:                                # %for.body11
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label7:
	i32.const	$push32=, 1
	i32.add 	$9=, $9, $pop32
	i32.load	$push5=, 0($8)
	i32.ne  	$push6=, $9, $pop5
	br_if   	3, $pop6        # 3: down to label2
# %bb.7:                                # %for.cond9
                                        #   in Loop: Header=BB1_6 Depth=3
	i32.const	$push33=, 4
	i32.add 	$8=, $8, $pop33
	i32.lt_u	$push7=, $9, $2
	br_if   	0, $pop7        # 0: up to label7
# %bb.8:                                # %for.end16
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop
	copy_local	$8=, $1
	copy_local	$9=, $2
	block   	
	br_if   	0, $7           # 0: down to label8
.LBB1_9:                                # %for.body19
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label9:
	i32.load	$push8=, 0($8)
	i32.ne  	$push9=, $9, $pop8
	br_if   	4, $pop9        # 4: down to label2
# %bb.10:                               # %for.cond17
                                        #   in Loop: Header=BB1_9 Depth=3
	i32.const	$push35=, 1
	i32.add 	$9=, $9, $pop35
	i32.const	$push34=, 4
	i32.add 	$8=, $8, $pop34
	i32.lt_u	$push10=, $9, $5
	br_if   	0, $pop10       # 0: up to label9
.LBB1_11:                               # %for.end26
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop
	end_block                       # label8:
	block   	
	i32.const	$push37=, 1
	i32.add 	$8=, $5, $pop37
	copy_local	$9=, $4
	i32.const	$push36=, 4
	i32.gt_u	$push11=, $8, $pop36
	br_if   	0, $pop11       # 0: down to label10
.LBB1_12:                               # %for.body30
                                        #   Parent Loop BB1_1 Depth=1
                                        #     Parent Loop BB1_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop    	                # label11:
	i32.const	$push38=, 1
	i32.add 	$5=, $5, $pop38
	i32.load	$push12=, 0($9)
	i32.ne  	$push13=, $5, $pop12
	br_if   	4, $pop13       # 4: down to label2
# %bb.13:                               # %for.cond28
                                        #   in Loop: Header=BB1_12 Depth=3
	i32.const	$push40=, 4
	i32.add 	$9=, $9, $pop40
	i32.const	$push39=, 3
	i32.le_u	$push14=, $5, $pop39
	br_if   	0, $pop14       # 0: up to label11
# %bb.14:                               # %for.inc38
                                        #   in Loop: Header=BB1_2 Depth=2
	end_loop
	i32.const	$push42=, 4
	i32.add 	$4=, $4, $pop42
	copy_local	$5=, $8
	i32.const	$push41=, 5
	i32.lt_u	$push15=, $8, $pop41
	br_if   	1, $pop15       # 1: up to label4
.LBB1_15:                               # %for.inc41
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label10:
	end_loop
	i32.const	$push45=, 4
	i32.add 	$1=, $1, $pop45
	i32.const	$push44=, 1
	i32.add 	$2=, $2, $pop44
	i32.const	$push43=, 5
	i32.lt_u	$push16=, $2, $pop43
	br_if   	0, $pop16       # 0: up to label3
# %bb.16:                               # %for.end43
	end_loop
	i32.const	$push24=, 0
	i32.const	$push22=, 32
	i32.add 	$push23=, $10, $pop22
	i32.store	__stack_pointer($pop24), $pop23
	i32.const	$push17=, 0
	return  	$pop17
.LBB1_17:                               # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function

	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
