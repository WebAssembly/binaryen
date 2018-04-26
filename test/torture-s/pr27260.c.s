	.text
	.file	"pr27260.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i64
# %bb.0:                                # %entry
	i32.const	$push0=, 2
	i32.ne  	$push1=, $0, $pop0
	i64.extend_u/i32	$push2=, $pop1
	i64.const	$push3=, 72340172838076673
	i64.mul 	$1=, $pop2, $pop3
	i32.const	$push4=, 0
	i64.store	buf+56($pop4), $1
	i32.const	$push11=, 0
	i64.store	buf+48($pop11), $1
	i32.const	$push10=, 0
	i64.store	buf+40($pop10), $1
	i32.const	$push9=, 0
	i64.store	buf+32($pop9), $1
	i32.const	$push8=, 0
	i64.store	buf+24($pop8), $1
	i32.const	$push7=, 0
	i64.store	buf+16($pop7), $1
	i32.const	$push6=, 0
	i64.store	buf+8($pop6), $1
	i32.const	$push5=, 0
	i64.store	buf($pop5), $1
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
	.local  	i32, i32
# %bb.0:                                # %entry
	i32.const	$1=, 0
	i32.const	$push16=, 0
	i32.const	$push2=, 2
	i32.store8	buf+64($pop16), $pop2
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	block   	
	loop    	                # label2:
	i32.const	$push17=, buf
	i32.add 	$push3=, $1, $pop17
	i32.load8_u	$push4=, 0($pop3)
	br_if   	1, $pop4        # 1: down to label1
# %bb.2:                                # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push19=, 1
	i32.add 	$1=, $1, $pop19
	i32.const	$push18=, 63
	i32.le_u	$push5=, $1, $pop18
	br_if   	0, $pop5        # 0: up to label2
# %bb.3:                                # %for.end
	end_loop
	i32.const	$push7=, 0
	i64.const	$push6=, 72340172838076673
	i64.store	buf+56($pop7), $pop6
	i32.const	$push33=, 0
	i64.const	$push32=, 72340172838076673
	i64.store	buf+48($pop33), $pop32
	i32.const	$push31=, 0
	i64.const	$push30=, 72340172838076673
	i64.store	buf+40($pop31), $pop30
	i32.const	$push29=, 0
	i64.const	$push28=, 72340172838076673
	i64.store	buf+32($pop29), $pop28
	i32.const	$push27=, 0
	i64.const	$push26=, 72340172838076673
	i64.store	buf+24($pop27), $pop26
	i32.const	$push25=, 0
	i64.const	$push24=, 72340172838076673
	i64.store	buf+16($pop25), $pop24
	i32.const	$push23=, 0
	i64.const	$push22=, 72340172838076673
	i64.store	buf+8($pop23), $pop22
	i32.const	$push21=, 0
	i64.const	$push20=, 72340172838076673
	i64.store	buf($pop21), $pop20
	i32.const	$1=, 1
.LBB1_4:                                # %for.cond3
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label4:
	i32.const	$push34=, 63
	i32.gt_u	$push8=, $1, $pop34
	br_if   	1, $pop8        # 1: down to label3
# %bb.5:                                # %for.cond3.for.body6_crit_edge
                                        #   in Loop: Header=BB1_4 Depth=1
	i32.const	$push37=, buf
	i32.add 	$0=, $1, $pop37
	i32.const	$push36=, 1
	i32.add 	$push0=, $1, $pop36
	copy_local	$1=, $pop0
	i32.load8_u	$push14=, 0($0)
	i32.const	$push35=, 1
	i32.eq  	$push15=, $pop14, $pop35
	br_if   	0, $pop15       # 0: up to label4
	br      	2               # 2: down to label1
.LBB1_6:                                # %for.end15
	end_loop
	end_block                       # label3:
	i32.const	$push10=, 0
	i64.const	$push9=, 0
	i64.store	buf+56($pop10), $pop9
	i32.const	$push51=, 0
	i64.const	$push50=, 0
	i64.store	buf+48($pop51), $pop50
	i32.const	$push49=, 0
	i64.const	$push48=, 0
	i64.store	buf+40($pop49), $pop48
	i32.const	$push47=, 0
	i64.const	$push46=, 0
	i64.store	buf+32($pop47), $pop46
	i32.const	$push45=, 0
	i64.const	$push44=, 0
	i64.store	buf+24($pop45), $pop44
	i32.const	$push43=, 0
	i64.const	$push42=, 0
	i64.store	buf+16($pop43), $pop42
	i32.const	$push41=, 0
	i64.const	$push40=, 0
	i64.store	buf+8($pop41), $pop40
	i32.const	$push39=, 0
	i64.const	$push38=, 0
	i64.store	buf($pop39), $pop38
	i32.const	$1=, 1
.LBB1_7:                                # %for.cond16
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label5:
	i32.const	$push52=, 63
	i32.gt_u	$push11=, $1, $pop52
	br_if   	2, $pop11       # 2: down to label0
# %bb.8:                                # %for.cond16.for.body19_crit_edge
                                        #   in Loop: Header=BB1_7 Depth=1
	i32.const	$push54=, buf
	i32.add 	$0=, $1, $pop54
	i32.const	$push53=, 1
	i32.add 	$push1=, $1, $pop53
	copy_local	$1=, $pop1
	i32.load8_u	$push13=, 0($0)
	i32.eqz 	$push55=, $pop13
	br_if   	0, $pop55       # 0: up to label5
.LBB1_9:                                # %if.then
	end_loop
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB1_10:                               # %if.end33
	end_block                       # label0:
	i32.const	$push12=, 0
                                        # fallthrough-return: $pop12
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	buf                     # @buf
	.type	buf,@object
	.section	.bss.buf,"aw",@nobits
	.globl	buf
	.p2align	4
buf:
	.skip	65
	.size	buf, 65


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
