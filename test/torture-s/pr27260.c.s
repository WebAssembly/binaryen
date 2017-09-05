	.text
	.file	"pr27260.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i64
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push0=, 2
	i32.ne  	$push1=, $0, $pop0
	i64.extend_u/i32	$push2=, $pop1
	i64.const	$push3=, 72340172838076673
	i64.mul 	$push13=, $pop2, $pop3
	tee_local	$push12=, $1=, $pop13
	i64.store	buf+56($pop4), $pop12
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
# BB#0:                                 # %entry
	i32.const	$push3=, 0
	i32.const	$push2=, 2
	i32.store8	buf+64($pop3), $pop2
	i32.const	$1=, -1
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	block   	
	loop    	                # label2:
	i32.const	$push19=, buf+1
	i32.add 	$push4=, $1, $pop19
	i32.load8_u	$push5=, 0($pop4)
	br_if   	1, $pop5        # 1: down to label1
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push23=, 1
	i32.add 	$push22=, $1, $pop23
	tee_local	$push21=, $1=, $pop22
	i32.const	$push20=, 62
	i32.le_u	$push6=, $pop21, $pop20
	br_if   	0, $pop6        # 0: up to label2
# BB#3:                                 # %for.end
	end_loop
	i32.const	$push8=, 0
	i64.const	$push7=, 72340172838076673
	i64.store	buf+56($pop8), $pop7
	i32.const	$push37=, 0
	i64.const	$push36=, 72340172838076673
	i64.store	buf+48($pop37), $pop36
	i32.const	$push35=, 0
	i64.const	$push34=, 72340172838076673
	i64.store	buf+40($pop35), $pop34
	i32.const	$push33=, 0
	i64.const	$push32=, 72340172838076673
	i64.store	buf+32($pop33), $pop32
	i32.const	$push31=, 0
	i64.const	$push30=, 72340172838076673
	i64.store	buf+24($pop31), $pop30
	i32.const	$push29=, 0
	i64.const	$push28=, 72340172838076673
	i64.store	buf+16($pop29), $pop28
	i32.const	$push27=, 0
	i64.const	$push26=, 72340172838076673
	i64.store	buf+8($pop27), $pop26
	i32.const	$push25=, 0
	i64.const	$push24=, 72340172838076673
	i64.store	buf($pop25), $pop24
	i32.const	$1=, 1
.LBB1_4:                                # %for.cond3
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label4:
	i32.const	$push39=, -1
	i32.add 	$push9=, $1, $pop39
	i32.const	$push38=, 62
	i32.gt_u	$push10=, $pop9, $pop38
	br_if   	1, $pop10       # 1: down to label3
# BB#5:                                 # %for.cond3.for.body6_crit_edge
                                        #   in Loop: Header=BB1_4 Depth=1
	i32.const	$push42=, buf
	i32.add 	$0=, $1, $pop42
	i32.const	$push41=, 1
	i32.add 	$push0=, $1, $pop41
	copy_local	$1=, $pop0
	i32.load8_u	$push17=, 0($0)
	i32.const	$push40=, 1
	i32.eq  	$push18=, $pop17, $pop40
	br_if   	0, $pop18       # 0: up to label4
	br      	2               # 2: down to label1
.LBB1_6:                                # %for.end15
	end_loop
	end_block                       # label3:
	i32.const	$push12=, 0
	i64.const	$push11=, 0
	i64.store	buf+56($pop12), $pop11
	i32.const	$push56=, 0
	i64.const	$push55=, 0
	i64.store	buf+48($pop56), $pop55
	i32.const	$push54=, 0
	i64.const	$push53=, 0
	i64.store	buf+40($pop54), $pop53
	i32.const	$push52=, 0
	i64.const	$push51=, 0
	i64.store	buf+32($pop52), $pop51
	i32.const	$push50=, 0
	i64.const	$push49=, 0
	i64.store	buf+24($pop50), $pop49
	i32.const	$push48=, 0
	i64.const	$push47=, 0
	i64.store	buf+16($pop48), $pop47
	i32.const	$push46=, 0
	i64.const	$push45=, 0
	i64.store	buf+8($pop46), $pop45
	i32.const	$push44=, 0
	i64.const	$push43=, 0
	i64.store	buf($pop44), $pop43
	i32.const	$1=, 1
.LBB1_7:                                # %for.cond16
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label5:
	i32.const	$push58=, -1
	i32.add 	$push13=, $1, $pop58
	i32.const	$push57=, 62
	i32.gt_u	$push14=, $pop13, $pop57
	br_if   	2, $pop14       # 2: down to label0
# BB#8:                                 # %for.cond16.for.body19_crit_edge
                                        #   in Loop: Header=BB1_7 Depth=1
	i32.const	$push60=, buf
	i32.add 	$0=, $1, $pop60
	i32.const	$push59=, 1
	i32.add 	$push1=, $1, $pop59
	copy_local	$1=, $pop1
	i32.load8_u	$push16=, 0($0)
	i32.eqz 	$push61=, $pop16
	br_if   	0, $pop61       # 0: up to label5
.LBB1_9:                                # %if.then
	end_loop
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB1_10:                               # %if.end33
	end_block                       # label0:
	i32.const	$push15=, 0
                                        # fallthrough-return: $pop15
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


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
