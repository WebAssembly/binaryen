	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr24716.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push17=, 0
	i32.load	$push18=, __stack_pointer($pop17)
	i32.const	$push19=, 16
	i32.sub 	$push26=, $pop18, $pop19
	tee_local	$push25=, $6=, $pop26
	i32.const	$push24=, 0
	i32.store	$drop=, 8($pop25), $pop24
	i32.const	$push20=, 12
	i32.add 	$push21=, $6, $pop20
	copy_local	$5=, $pop21
	i32.const	$3=, 0
.LBB0_1:                                # %for.cond
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_6 Depth 2
                                        #     Child Loop BB0_10 Depth 2
                                        #       Child Loop BB0_11 Depth 3
                                        #     Child Loop BB0_15 Depth 2
                                        #       Child Loop BB0_16 Depth 3
	loop                            # label0:
	i32.store	$drop=, 0($5), $3
	i32.load	$5=, 8($6)
	block
	block
	i32.load	$push29=, 12($6)
	tee_local	$push28=, $4=, $pop29
	i32.const	$push27=, 3
	i32.lt_s	$push0=, $pop28, $pop27
	br_if   	0, $pop0        # 0: down to label3
# BB#2:                                 # %do.body.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$push42=, 0
	i32.sub 	$push41=, $pop42, $5
	tee_local	$push40=, $3=, $pop41
	i32.const	$push39=, -3
	i32.const	$push38=, -3
	i32.gt_s	$push1=, $3, $pop38
	i32.select	$push37=, $pop40, $pop39, $pop1
	tee_local	$push36=, $2=, $pop37
	i32.const	$push35=, -1
	i32.xor 	$push34=, $pop36, $pop35
	tee_local	$push33=, $3=, $pop34
	i32.store	$drop=, 8($6), $pop33
	i32.add 	$push2=, $5, $4
	i32.add 	$push3=, $pop2, $2
	i32.const	$push32=, 1
	i32.add 	$push31=, $pop3, $pop32
	tee_local	$push30=, $4=, $pop31
	i32.store	$drop=, 12($6), $pop30
	br      	1               # 1: down to label2
.LBB0_3:                                #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label3:
	copy_local	$3=, $5
.LBB0_4:                                # %if.end
                                        #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label2:
	block
	block
	i32.const	$push43=, 1
	i32.eq  	$push4=, $3, $pop43
	br_if   	0, $pop4        # 0: down to label5
# BB#5:                                 # %while.cond.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	block
	i32.le_s	$push5=, $4, $1
	br_if   	0, $pop5        # 0: down to label6
.LBB0_6:                                # %while.body
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label7:
	block
	i32.ne  	$push6=, $3, $1
	br_if   	0, $pop6        # 0: down to label9
# BB#7:                                 # %if.then7
                                        #   in Loop: Header=BB0_6 Depth=2
	i32.const	$push46=, 1
	i32.add 	$push45=, $4, $pop46
	tee_local	$push44=, $4=, $pop45
	i32.store	$drop=, 12($6), $pop44
.LBB0_8:                                # %while.cond.backedge
                                        #   in Loop: Header=BB0_6 Depth=2
	end_block                       # label9:
	i32.gt_s	$push7=, $4, $1
	br_if   	0, $pop7        # 0: up to label7
.LBB0_9:                                # %do.body10.preheader
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label8:
	end_block                       # label6:
	i32.const	$push48=, 2
	i32.shl 	$push8=, $0, $pop48
	i32.const	$push47=, W
	i32.add 	$2=, $pop8, $pop47
.LBB0_10:                               # %do.body10
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_11 Depth 3
	loop                            # label10:
	i32.load	$5=, 0($2)
.LBB0_11:                               # %do.body11
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_10 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label12:
	block
	i32.eqz 	$push60=, $5
	br_if   	0, $pop60       # 0: down to label14
# BB#12:                                # %if.then13
                                        #   in Loop: Header=BB0_11 Depth=3
	i32.const	$push50=, 0
	i32.store	$drop=, 0($2), $pop50
	i32.const	$4=, 1
	i32.const	$push49=, 1
	i32.store	$drop=, 12($6), $pop49
.LBB0_13:                               # %do.cond16
                                        #   in Loop: Header=BB0_11 Depth=3
	end_block                       # label14:
	i32.const	$5=, 0
	i32.const	$push51=, 1
	i32.lt_s	$push9=, $1, $pop51
	br_if   	0, $pop9        # 0: up to label12
# BB#14:                                # %do.cond19
                                        #   in Loop: Header=BB0_10 Depth=2
	end_loop                        # label13:
	i32.const	$push52=, 0
	i32.gt_s	$push10=, $0, $pop52
	br_if   	0, $pop10       # 0: up to label10
.LBB0_15:                               # %do.body22
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_16 Depth 3
	end_loop                        # label11:
	loop                            # label15:
	i32.const	$push54=, 2
	i32.shl 	$push11=, $0, $pop54
	i32.const	$push53=, Link
	i32.add 	$push12=, $pop11, $pop53
	i32.load	$0=, 0($pop12)
	i32.const	$1=, 0
.LBB0_16:                               # %while.cond24
                                        #   Parent Loop BB0_1 Depth=1
                                        #     Parent Loop BB0_15 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	loop                            # label17:
	i32.ge_s	$push13=, $1, $3
	br_if   	1, $pop13       # 1: down to label18
# BB#17:                                # %while.body26
                                        #   in Loop: Header=BB0_16 Depth=3
	i32.const	$push59=, -1
	i32.eq  	$push16=, $0, $pop59
	br_if   	0, $pop16       # 0: up to label17
# BB#18:                                # %if.then28
                                        #   in Loop: Header=BB0_16 Depth=3
	i32.const	$push58=, 1
	i32.add 	$push57=, $4, $pop58
	tee_local	$push56=, $4=, $pop57
	i32.store	$drop=, 12($6), $pop56
	i32.const	$push55=, 1
	i32.add 	$1=, $1, $pop55
	br      	0               # 0: up to label17
.LBB0_19:                               # %do.cond33
                                        #   in Loop: Header=BB0_15 Depth=2
	end_loop                        # label18:
	i32.const	$push14=, -1
	i32.ne  	$push15=, $0, $pop14
	br_if   	0, $pop15       # 0: up to label15
	br      	3               # 3: down to label4
.LBB0_20:                               # %for.end
	end_loop                        # label16:
	end_block                       # label5:
	return  	$4
.LBB0_21:                               #   in Loop: Header=BB0_1 Depth=1
	end_block                       # label4:
	i32.const	$3=, 1
	i32.const	$push22=, 8
	i32.add 	$push23=, $6, $pop22
	copy_local	$5=, $pop23
	i32.const	$0=, -1
	br      	0               # 0: up to label0
.LBB0_22:
	end_loop                        # label1:
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push2=, 0
	i32.const	$push0=, 2
	i32.call	$push1=, f@FUNCTION, $pop2, $pop0
	i32.eqz 	$push4=, $pop1
	br_if   	0, $pop4        # 0: down to label19
# BB#1:                                 # %if.end
	i32.const	$push3=, 0
	return  	$pop3
.LBB1_2:                                # %if.then
	end_block                       # label19:
	call    	abort@FUNCTION
	unreachable
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


	.ident	"clang version 4.0.0 "
	.functype	abort, void
