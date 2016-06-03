	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr24716.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$5=, 0
	i32.const	$2=, 0
.LBB0_1:                                # %for.cond
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_6 Depth 2
                                        #     Child Loop BB0_8 Depth 2
                                        #       Child Loop BB0_9 Depth 3
                                        #     Child Loop BB0_14 Depth 2
                                        #       Child Loop BB0_15 Depth 3
	loop                            # label0:
	block
	block
	i32.const	$push23=, 3
	i32.lt_s	$push0=, $5, $pop23
	br_if   	0, $pop0        # 0: down to label3
# BB#2:                                 # %if.end.thread
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push25=, -1
	i32.add 	$3=, $2, $pop25
	i32.const	$push24=, 1
	i32.add 	$5=, $5, $pop24
	br      	1               # 1: down to label2
.LBB0_3:                                # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	i32.const	$3=, 0
	i32.const	$push26=, 1
	i32.eq  	$push1=, $2, $pop26
	br_if   	2, $pop1        # 2: down to label1
.LBB0_4:                                # %while.cond.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	block
	i32.le_s	$push2=, $5, $1
	br_if   	0, $pop2        # 0: down to label4
# BB#5:                                 # %while.body.lr.ph
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.eq  	$4=, $3, $1
.LBB0_6:                                # %while.body
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label5:
	i32.add 	$push12=, $5, $4
	tee_local	$push11=, $5=, $pop12
	i32.gt_s	$push3=, $pop11, $1
	br_if   	0, $pop3        # 0: up to label5
.LBB0_7:                                # %do.body10.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label6:
	end_block                       # label4:
	i32.const	$push14=, 2
	i32.shl 	$push4=, $0, $pop14
	i32.const	$push13=, W
	i32.add 	$2=, $pop4, $pop13
.LBB0_8:                                # %do.body10
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_9 Depth 3
	loop                            # label7:
	i32.load	$4=, 0($2)
.LBB0_9:                                # %do.body11
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_8 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label9:
	block
	i32.eqz 	$push27=, $4
	br_if   	0, $pop27       # 0: down to label11
# BB#10:                                # %if.then13
                                        #   in Loop: Header=BB0_9 Depth=3
	i32.const	$push15=, 0
	i32.store	$drop=, 0($2), $pop15
	i32.const	$5=, 1
.LBB0_11:                               # %do.cond16
                                        #   in Loop: Header=BB0_9 Depth=3
	end_block                       # label11:
	i32.const	$4=, 0
	i32.const	$push16=, 1
	i32.lt_s	$push5=, $1, $pop16
	br_if   	0, $pop5        # 0: up to label9
# BB#12:                                # %do.cond19
                                        #   in Loop: Header=BB0_8 Depth=2
	end_loop                        # label10:
	i32.const	$push17=, 0
	i32.gt_s	$push6=, $0, $pop17
	br_if   	0, $pop6        # 0: up to label7
# BB#13:                                # %do.body22.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label8:
	copy_local	$4=, $0
.LBB0_14:                               # %do.body22
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_15 Depth 3
	loop                            # label12:
	i32.const	$push18=, 2
	i32.shl 	$push7=, $4, $pop18
	i32.load	$4=, Link($pop7)
	i32.const	$1=, 0
.LBB0_15:                               # %while.cond24
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_14 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label14:
	i32.ge_s	$push8=, $1, $3
	br_if   	1, $pop8        # 1: down to label15
# BB#16:                                # %while.body26
                                        #   in Loop: Header=BB0_15 Depth=3
	i32.const	$push21=, -1
	i32.eq  	$push10=, $4, $pop21
	br_if   	0, $pop10       # 0: up to label14
# BB#17:                                # %if.then28
                                        #   in Loop: Header=BB0_15 Depth=3
	i32.const	$push20=, 1
	i32.add 	$1=, $1, $pop20
	i32.const	$push19=, 1
	i32.add 	$5=, $5, $pop19
	br      	0               # 0: up to label14
.LBB0_18:                               # %do.cond33
                                        #   in Loop: Header=BB0_14 Depth=2
	end_loop                        # label15:
	i32.const	$0=, -1
	i32.const	$2=, 1
	i32.const	$push22=, -1
	i32.ne  	$push9=, $4, $pop22
	br_if   	0, $pop9        # 0: up to label12
	br      	2               # 2: up to label0
.LBB0_19:                               # %for.end
	end_loop                        # label13:
	end_loop                        # label1:
	copy_local	$push28=, $5
                                        # fallthrough-return: $pop28
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, 0
	i32.const	$1=, 2
	i32.const	$2=, 0
	i32.const	$3=, 0
.LBB1_1:                                # %for.cond.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_6 Depth 2
                                        #     Child Loop BB1_8 Depth 2
                                        #     Child Loop BB1_11 Depth 2
	loop                            # label16:
	block
	block
	block
	block
	i32.const	$push8=, 3
	i32.lt_s	$push0=, $2, $pop8
	br_if   	0, $pop0        # 0: down to label21
# BB#2:                                 # %if.end.thread.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push10=, -1
	i32.add 	$0=, $3, $pop10
	i32.const	$push9=, 1
	i32.add 	$2=, $2, $pop9
	br      	1               # 1: down to label20
.LBB1_3:                                # %if.end.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label21:
	i32.const	$0=, 0
	i32.const	$push11=, 1
	i32.eq  	$push1=, $3, $pop11
	br_if   	1, $pop1        # 1: down to label19
.LBB1_4:                                # %while.cond.preheader.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label20:
	block
	i32.le_s	$push3=, $2, $1
	br_if   	0, $pop3        # 0: down to label22
# BB#5:                                 # %while.body.lr.ph.i
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.eq  	$3=, $0, $1
.LBB1_6:                                # %while.body.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label23:
	i32.add 	$push13=, $2, $3
	tee_local	$push12=, $2=, $pop13
	i32.gt_s	$push4=, $pop12, $1
	br_if   	0, $pop4        # 0: up to label23
.LBB1_7:                                # %do.body10.i
                                        #   in Loop: Header=BB1_1 Depth=1
	end_loop                        # label24:
	end_block                       # label22:
	i32.const	$push17=, 2
	i32.shl 	$push16=, $4, $pop17
	tee_local	$push15=, $3=, $pop16
	i32.const	$push14=, W
	i32.add 	$0=, $pop15, $pop14
	i32.load	$3=, W($3)
.LBB1_8:                                # %do.body11.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label25:
	block
	i32.eqz 	$push22=, $3
	br_if   	0, $pop22       # 0: down to label27
# BB#9:                                 # %if.then13.i
                                        #   in Loop: Header=BB1_8 Depth=2
	i32.const	$push18=, 0
	i32.store	$drop=, 0($0), $pop18
	i32.const	$2=, 1
.LBB1_10:                               # %do.cond16.i
                                        #   in Loop: Header=BB1_8 Depth=2
	end_block                       # label27:
	i32.const	$3=, 0
	i32.eqz 	$push23=, $1
	br_if   	0, $pop23       # 0: up to label25
.LBB1_11:                               # %do.cond33.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	end_loop                        # label26:
	loop                            # label28:
	i32.const	$push21=, 2
	i32.shl 	$push6=, $4, $pop21
	i32.load	$push20=, Link($pop6)
	tee_local	$push19=, $4=, $pop20
	i32.const	$push5=, -1
	i32.ne  	$push7=, $pop19, $pop5
	br_if   	0, $pop7        # 0: up to label28
	br      	3               # 3: down to label18
.LBB1_12:                               # %f.exit
	end_loop                        # label29:
	end_block                       # label19:
	block
	i32.eqz 	$push24=, $2
	br_if   	0, $pop24       # 0: down to label30
# BB#13:                                # %if.end
	i32.const	$push2=, 0
	return  	$pop2
.LBB1_14:                               # %if.then
	end_block                       # label30:
	call    	abort@FUNCTION
	unreachable
.LBB1_15:                               #   in Loop: Header=BB1_1 Depth=1
	end_block                       # label18:
	i32.const	$3=, 1
	i32.const	$1=, 0
	i32.const	$4=, -1
	br      	0               # 0: up to label16
.LBB1_16:
	end_loop                        # label17:
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	Link                    # @Link
	.type	Link,@object
	.section	.data.Link,"aw",@progbits
	.globl	Link
	.p2align	2
Link:
	.skip	4,255
	.size	Link, 4

	.hidden	W                       # @W
	.type	W,@object
	.section	.data.W,"aw",@progbits
	.globl	W
	.p2align	2
W:
	.int32	2                       # 0x2
	.size	W, 4


	.ident	"clang version 3.9.0 "
	.functype	abort, void
