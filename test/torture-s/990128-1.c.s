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
	i32.const	$push3=, 0
	i32.const	$push2=, sss
	i32.store	$drop=, ss($pop3), $pop2
	i32.const	$1=, ss
	i32.const	$push29=, 0
	i32.const	$push28=, ss
	i32.store	$drop=, p($pop29), $pop28
	i32.const	$push27=, 0
	i32.const	$push4=, sss+4
	i32.store	$drop=, sss($pop27), $pop4
	i32.const	$push26=, 0
	i32.const	$push5=, sss+8
	i32.store	$drop=, sss+4($pop26), $pop5
	i32.const	$push25=, 0
	i32.const	$push6=, sss+12
	i32.store	$drop=, sss+8($pop25), $pop6
	i32.const	$push24=, 0
	i32.const	$push7=, sss+16
	i32.store	$drop=, sss+12($pop24), $pop7
	i32.const	$push23=, 0
	i32.const	$push8=, sss+20
	i32.store	$drop=, sss+16($pop23), $pop8
	i32.const	$push22=, 0
	i32.const	$push9=, sss+24
	i32.store	$drop=, sss+20($pop22), $pop9
	i32.const	$push21=, 0
	i32.const	$push10=, sss+28
	i32.store	$drop=, sss+24($pop21), $pop10
	i32.const	$push20=, 0
	i32.const	$push11=, sss+32
	i32.store	$drop=, sss+28($pop20), $pop11
	i32.const	$push19=, 0
	i32.const	$push12=, sss+36
	i32.store	$drop=, sss+32($pop19), $pop12
	i32.const	$push18=, 0
	i32.const	$push17=, 0
	i32.store	$push0=, sss+36($pop18), $pop17
	i32.load	$2=, count($pop0)
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
	i32.load	$push31=, 0($2)
	tee_local	$push30=, $2=, $pop31
	br_if   	0, $pop30       # 0: up to label2
# BB#3:                                 # %if.then.i
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop                        # label3:
	i32.const	$push34=, 1
	i32.add 	$2=, $0, $pop34
	i32.load	$push33=, 0($1)
	tee_local	$push32=, $1=, $pop33
	br_if   	0, $pop32       # 0: up to label0
# BB#4:                                 # %sub.exit
	end_loop                        # label1:
	block
	i32.const	$push35=, 0
	i32.const	$push13=, 2
	i32.add 	$push14=, $0, $pop13
	i32.store	$push1=, count($pop35), $pop14
	i32.const	$push15=, 12
	i32.ne  	$push16=, $pop1, $pop15
	br_if   	0, $pop16       # 0: down to label4
# BB#5:                                 # %if.end
	i32.const	$push36=, 0
	call    	exit@FUNCTION, $pop36
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
	i32.eqz 	$push12=, $0
	br_if   	0, $pop12       # 0: down to label5
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
	i32.load	$push6=, 0($3)
	tee_local	$push5=, $3=, $pop6
	br_if   	0, $pop5        # 0: up to label8
# BB#4:                                 # %if.then
                                        #   in Loop: Header=BB1_2 Depth=1
	end_loop                        # label9:
	i32.const	$push10=, 0
	i32.store	$drop=, 0($1), $pop10
	i32.const	$push9=, 1
	i32.add 	$2=, $2, $pop9
	i32.load	$push8=, 0($0)
	tee_local	$push7=, $0=, $pop8
	br_if   	0, $pop7        # 0: up to label6
# BB#5:                                 # %for.cond.look.exit.thread_crit_edge
	end_loop                        # label7:
	i32.const	$push1=, 0
	i32.store	$drop=, count($pop1), $2
.LBB1_6:                                # %for.end
	end_block                       # label5:
	i32.const	$push11=, 0
	i32.store	$push0=, 0($1), $pop11
	i32.const	$push2=, 1
	i32.add 	$push3=, $2, $pop2
	i32.store	$drop=, count($pop0), $pop3
                                        # fallthrough-return
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
	i32.eqz 	$push9=, $0
	br_if   	0, $pop9        # 0: down to label10
.LBB2_1:                                # %for.inc
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label11:
	i32.load	$push5=, 0($0)
	tee_local	$push4=, $0=, $pop5
	br_if   	0, $pop4        # 0: up to label11
.LBB2_2:                                # %for.end
	end_loop                        # label12:
	end_block                       # label10:
	i32.const	$push0=, 0
	i32.store	$push8=, 0($1), $pop0
	tee_local	$push7=, $0=, $pop8
	i32.load	$push1=, count($0)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	$drop=, count($pop7), $pop3
	i32.const	$push6=, 1
                                        # fallthrough-return: $pop6
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
	.functype	abort, void
	.functype	exit, void, i32
