	.text
	.file	"990128-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, sss
	i32.store	ss($pop1), $pop0
	i32.const	$1=, ss
	i32.const	$push27=, 0
	i32.const	$push26=, ss
	i32.store	p($pop27), $pop26
	i32.const	$push25=, 0
	i32.const	$push2=, sss+4
	i32.store	sss($pop25), $pop2
	i32.const	$push24=, 0
	i32.const	$push3=, sss+8
	i32.store	sss+4($pop24), $pop3
	i32.const	$push23=, 0
	i32.const	$push4=, sss+12
	i32.store	sss+8($pop23), $pop4
	i32.const	$push22=, 0
	i32.const	$push5=, sss+16
	i32.store	sss+12($pop22), $pop5
	i32.const	$push21=, 0
	i32.const	$push6=, sss+20
	i32.store	sss+16($pop21), $pop6
	i32.const	$push20=, 0
	i32.const	$push7=, sss+24
	i32.store	sss+20($pop20), $pop7
	i32.const	$push19=, 0
	i32.const	$push8=, sss+28
	i32.store	sss+24($pop19), $pop8
	i32.const	$push18=, 0
	i32.const	$push9=, sss+32
	i32.store	sss+28($pop18), $pop9
	i32.const	$push17=, 0
	i32.const	$push10=, sss+36
	i32.store	sss+32($pop17), $pop10
	i32.const	$push16=, 0
	i32.const	$push15=, 0
	i32.store	sss+36($pop16), $pop15
	i32.const	$push14=, 0
	i32.load	$2=, count($pop14)
.LBB0_1:                                # %for.inc.lr.ph.i.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_2 Depth 2
	loop    	                # label0:
	copy_local	$0=, $2
	copy_local	$2=, $1
.LBB0_2:                                # %for.inc.i.i
                                        #   Parent Loop BB0_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label1:
	i32.load	$2=, 0($2)
	br_if   	0, $2           # 0: up to label1
# %bb.3:                                # %if.then.i
                                        #   in Loop: Header=BB0_1 Depth=1
	end_loop
	i32.const	$push28=, 1
	i32.add 	$2=, $0, $pop28
	i32.load	$1=, 0($1)
	br_if   	0, $1           # 0: up to label0
# %bb.4:                                # %sub.exit
	end_loop
	i32.const	$push11=, 2
	i32.add 	$2=, $0, $pop11
	i32.const	$push29=, 0
	i32.store	count($pop29), $2
	block   	
	i32.const	$push12=, 12
	i32.ne  	$push13=, $2, $pop12
	br_if   	0, $pop13       # 0: down to label2
# %bb.5:                                # %if.end
	i32.const	$push30=, 0
	call    	exit@FUNCTION, $pop30
	unreachable
.LBB0_6:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.section	.text.sub,"ax",@progbits
	.hidden	sub                     # -- Begin function sub
	.globl	sub
	.type	sub,@function
sub:                                    # @sub
	.param  	i32, i32
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$push3=, 0
	i32.load	$2=, count($pop3)
	block   	
	i32.eqz 	$push8=, $0
	br_if   	0, $pop8        # 0: down to label3
# %bb.1:
.LBB1_2:                                # %for.inc.lr.ph.i
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_3 Depth 2
	loop    	                # label4:
	copy_local	$3=, $0
.LBB1_3:                                # %for.inc.i
                                        #   Parent Loop BB1_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	                # label5:
	i32.load	$3=, 0($3)
	br_if   	0, $3           # 0: up to label5
# %bb.4:                                # %if.then
                                        #   in Loop: Header=BB1_2 Depth=1
	end_loop
	i32.const	$push5=, 0
	i32.store	0($1), $pop5
	i32.const	$push4=, 1
	i32.add 	$2=, $2, $pop4
	i32.load	$0=, 0($0)
	br_if   	0, $0           # 0: up to label4
# %bb.5:                                # %for.cond.look.exit.thread_crit_edge
	end_loop
	i32.const	$push0=, 0
	i32.store	count($pop0), $2
.LBB1_6:                                # %for.end
	end_block                       # label3:
	i32.const	$push7=, 0
	i32.store	0($1), $pop7
	i32.const	$push6=, 0
	i32.const	$push1=, 1
	i32.add 	$push2=, $2, $pop1
	i32.store	count($pop6), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	sub, .Lfunc_end1-sub
                                        # -- End function
	.section	.text.look,"ax",@progbits
	.hidden	look                    # -- Begin function look
	.globl	look
	.type	look,@function
look:                                   # @look
	.param  	i32, i32
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.eqz 	$push7=, $0
	br_if   	0, $pop7        # 0: down to label6
.LBB2_1:                                # %for.inc
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label7:
	i32.load	$0=, 0($0)
	br_if   	0, $0           # 0: up to label7
.LBB2_2:                                # %for.end
	end_loop
	end_block                       # label6:
	i32.const	$push0=, 0
	i32.store	0($1), $pop0
	i32.const	$push6=, 0
	i32.const	$push5=, 0
	i32.load	$push1=, count($pop5)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	count($pop6), $pop3
	i32.const	$push4=, 1
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end2:
	.size	look, .Lfunc_end2-look
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
	.functype	exit, void, i32
