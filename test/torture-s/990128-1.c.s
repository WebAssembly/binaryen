	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990128-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %for.inc.i.preheader.i.preheader
	i32.const	$push1=, 0
	i32.const	$push2=, sss
	i32.store	$discard=, ss($pop1), $pop2
	i32.const	$push29=, 0
	i32.const	$push3=, sss+4
	i32.store	$discard=, sss($pop29), $pop3
	i32.const	$push28=, 0
	i32.const	$push4=, sss+8
	i32.store	$discard=, sss+4($pop28), $pop4
	i32.const	$push27=, 0
	i32.const	$push5=, sss+12
	i32.store	$discard=, sss+8($pop27), $pop5
	i32.const	$push26=, 0
	i32.const	$push6=, sss+16
	i32.store	$discard=, sss+12($pop26), $pop6
	i32.const	$push25=, 0
	i32.const	$push7=, sss+20
	i32.store	$discard=, sss+16($pop25), $pop7
	i32.const	$push24=, 0
	i32.const	$push8=, sss+24
	i32.store	$discard=, sss+20($pop24), $pop8
	i32.const	$push23=, 0
	i32.const	$push9=, sss+28
	i32.store	$discard=, sss+24($pop23), $pop9
	i32.const	$push22=, 0
	i32.const	$push10=, sss+32
	i32.store	$discard=, sss+28($pop22), $pop10
	i32.const	$push21=, 0
	i32.const	$push11=, sss+36
	i32.store	$discard=, sss+32($pop21), $pop11
	i32.const	$1=, ss
	i32.const	$push20=, 0
	i32.load	$2=, count($pop20)
	i32.const	$push19=, 0
	i32.const	$push18=, ss
	i32.store	$discard=, p($pop19), $pop18
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.store	$discard=, sss+36($pop17), $pop16
.LBB0_1:                                # %for.inc.i.preheader.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
	loop                            # label0:
	copy_local	$0=, $2
	copy_local	$2=, $1
.LBB0_2:                                # %for.inc.i.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label2:
	i32.load	$2=, 0($2)
	br_if   	0, $2           # 0: up to label2
# BB#3:                                 # %if.then.i
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label3:
	i32.load	$1=, 0($1)
	i32.const	$push30=, 1
	i32.add 	$2=, $0, $pop30
	br_if   	0, $1           # 0: up to label0
# BB#4:                                 # %sub.exit
	end_loop                        # label1:
	block
	i32.const	$push31=, 0
	i32.const	$push12=, 2
	i32.add 	$push13=, $0, $pop12
	i32.store	$push0=, count($pop31), $pop13
	i32.const	$push14=, 12
	i32.ne  	$push15=, $pop0, $pop14
	br_if   	0, $pop15       # 0: down to label4
# BB#5:                                 # %if.end
	i32.const	$push32=, 0
	call    	exit@FUNCTION, $pop32
	unreachable
.LBB0_6:                                # %if.then
	end_block                       # label4:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.sub,"ax",@progbits
	.hidden	sub
	.globl	sub
	.type	sub,@function
sub:                                    # @sub
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.load	$2=, count($pop4)
	block
	i32.eqz 	$push8=, $0
	br_if   	0, $pop8        # 0: down to label5
# BB#1:                                 # %for.inc.i.preheader.preheader
.LBB1_2:                                # %for.inc.i.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_3 Depth 2
	loop                            # label6:
	copy_local	$3=, $0
.LBB1_3:                                # %for.inc.i
                                        #   Parent Loop BB1_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop                            # label8:
	i32.load	$3=, 0($3)
	br_if   	0, $3           # 0: up to label8
# BB#4:                                 # %if.then
                                        #   in Loop: Header=BB1_2 Depth=1
	end_loop                        # label9:
	i32.const	$push6=, 0
	i32.store	$discard=, 0($1), $pop6
	i32.load	$0=, 0($0)
	i32.const	$push5=, 1
	i32.add 	$2=, $2, $pop5
	br_if   	0, $0           # 0: up to label6
# BB#5:                                 # %for.cond.look.exit.thread_crit_edge
	end_loop                        # label7:
	i32.const	$push1=, 0
	i32.store	$discard=, count($pop1), $2
.LBB1_6:                                # %for.end
	end_block                       # label5:
	i32.const	$push7=, 0
	i32.store	$push0=, 0($1), $pop7
	i32.const	$push2=, 1
	i32.add 	$push3=, $2, $pop2
	i32.store	$discard=, count($pop0), $pop3
	return
	.endfunc
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
	block
	i32.eqz 	$push6=, $0
	br_if   	0, $pop6        # 0: down to label10
.LBB2_1:                                # %for.inc
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label11:
	i32.load	$0=, 0($0)
	br_if   	0, $0           # 0: up to label11
.LBB2_2:                                # %for.end
	end_loop                        # label12:
	end_block                       # label10:
	i32.const	$push1=, 0
	i32.load	$0=, count($pop1)
	i32.const	$push5=, 0
	i32.store	$push0=, 0($1), $pop5
	i32.const	$push2=, 1
	i32.add 	$push3=, $0, $pop2
	i32.store	$discard=, count($pop0), $pop3
	i32.const	$push4=, 1
	return  	$pop4
	.endfunc
.Lfunc_end2:
	.size	look, .Lfunc_end2-look

	.hidden	count                   # @count
	.type	count,@object
	.section	.bss.count,"aw",@nobits
	.globl	count
	.p2align	2
count:
	.int32	0                       # 0x0
	.size	count, 4

	.hidden	ss                      # @ss
	.type	ss,@object
	.section	.bss.ss,"aw",@nobits
	.globl	ss
	.p2align	2
ss:
	.skip	4
	.size	ss, 4

	.hidden	p                       # @p
	.type	p,@object
	.section	.bss.p,"aw",@nobits
	.globl	p
	.p2align	2
p:
	.int32	0
	.size	p, 4

	.hidden	sss                     # @sss
	.type	sss,@object
	.section	.bss.sss,"aw",@nobits
	.globl	sss
	.p2align	4
sss:
	.skip	40
	.size	sss, 40


	.ident	"clang version 3.9.0 "
