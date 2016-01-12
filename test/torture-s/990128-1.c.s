	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990128-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %for.inc.i.preheader.i.preheader
	i32.const	$2=, 0
	i32.const	$push1=, sss
	i32.store	$discard=, ss($2), $pop1
	i32.const	$push2=, sss+4
	i32.store	$discard=, sss($2), $pop2
	i32.const	$push3=, sss+8
	i32.store	$discard=, sss+4($2), $pop3
	i32.const	$push4=, sss+12
	i32.store	$discard=, sss+8($2), $pop4
	i32.const	$push5=, sss+16
	i32.store	$discard=, sss+12($2), $pop5
	i32.const	$push6=, sss+20
	i32.store	$discard=, sss+16($2), $pop6
	i32.const	$push7=, sss+24
	i32.store	$discard=, sss+20($2), $pop7
	i32.const	$push8=, sss+28
	i32.store	$discard=, sss+24($2), $pop8
	i32.const	$push9=, sss+32
	i32.store	$discard=, sss+28($2), $pop9
	i32.store	$1=, sss+36($2), $2
	i32.load	$3=, count($1)
	i32.const	$push10=, sss+36
	i32.store	$discard=, sss+32($2), $pop10
	i32.const	$push0=, ss
	i32.store	$2=, p($2), $pop0
.LBB0_1:                                # %for.inc.i.preheader.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
	loop    	.LBB0_4
	copy_local	$0=, $3
	copy_local	$3=, $2
.LBB0_2:                                # %for.inc.i.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB0_3
	i32.load	$3=, 0($3)
	br_if   	$3, .LBB0_2
.LBB0_3:                                # %if.then.i
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.load	$2=, 0($2)
	i32.const	$push11=, 1
	i32.add 	$3=, $0, $pop11
	br_if   	$2, .LBB0_1
.LBB0_4:                                # %sub.exit
	block   	.LBB0_6
	i32.const	$push12=, 2
	i32.add 	$push13=, $0, $pop12
	i32.store	$push14=, count($1), $pop13
	i32.const	$push15=, 12
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	$pop16, .LBB0_6
# BB#5:                                 # %if.end
	call    	exit@FUNCTION, $1
	unreachable
.LBB0_6:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.sub,"ax",@progbits
	.hidden	sub
	.globl	sub
	.type	sub,@function
sub:                                    # @sub
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.load	$3=, count($2)
	block   	.LBB1_5
	i32.const	$push3=, 0
	i32.eq  	$push4=, $0, $pop3
	br_if   	$pop4, .LBB1_5
.LBB1_1:                                # %for.inc.i.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_2 Depth 2
	loop    	.LBB1_4
	copy_local	$4=, $0
.LBB1_2:                                # %for.inc.i
                                        #   Parent Loop BB1_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	.LBB1_3
	i32.load	$4=, 0($4)
	br_if   	$4, .LBB1_2
.LBB1_3:                                # %if.then
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.store	$4=, 0($1), $2
	i32.load	$0=, 0($0)
	i32.const	$push0=, 1
	i32.add 	$3=, $3, $pop0
	br_if   	$0, .LBB1_1
.LBB1_4:                                # %for.cond.look.exit.thread_crit_edge
	i32.store	$discard=, count($4), $3
.LBB1_5:                                # %for.end
	i32.store	$4=, 0($1), $2
	i32.const	$push1=, 1
	i32.add 	$push2=, $3, $pop1
	i32.store	$discard=, count($4), $pop2
	return
.Lfunc_end1:
	.size	sub, .Lfunc_end1-sub

	.section	.text.look,"ax",@progbits
	.hidden	look
	.globl	look
	.type	look,@function
look:                                   # @look
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	.LBB2_2
	i32.const	$push3=, 0
	i32.eq  	$push4=, $0, $pop3
	br_if   	$pop4, .LBB2_2
.LBB2_1:                                # %for.inc
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB2_2
	i32.load	$0=, 0($0)
	br_if   	$0, .LBB2_1
.LBB2_2:                                # %for.end
	i32.const	$push0=, 0
	i32.store	$0=, 0($1), $pop0
	i32.const	$1=, 1
	i32.load	$push1=, count($0)
	i32.add 	$push2=, $pop1, $1
	i32.store	$discard=, count($0), $pop2
	return  	$1
.Lfunc_end2:
	.size	look, .Lfunc_end2-look

	.hidden	count                   # @count
	.type	count,@object
	.section	.bss.count,"aw",@nobits
	.globl	count
	.align	2
count:
	.int32	0                       # 0x0
	.size	count, 4

	.hidden	ss                      # @ss
	.type	ss,@object
	.section	.bss.ss,"aw",@nobits
	.globl	ss
	.align	2
ss:
	.skip	4
	.size	ss, 4

	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.align	2
p:
	.int32	0
	.size	p, 4

	.hidden	sss                     # @sss
	.type	sss,@object
	.section	.bss.sss,"aw",@nobits
	.globl	sss
	.align	4
sss:
	.skip	40
	.size	sss, 40


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
