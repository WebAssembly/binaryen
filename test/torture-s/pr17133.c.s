	.text
	.file	"pr17133.c"
	.section	.text.pure_alloc,"ax",@progbits
	.hidden	pure_alloc              # -- Begin function pure_alloc
	.globl	pure_alloc
	.type	pure_alloc,@function
pure_alloc:                             # @pure_alloc
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push15=, 0
	i32.load	$push14=, foo($pop15)
	tee_local	$push13=, $3=, $pop14
	i32.const	$push12=, 2
	i32.add 	$push11=, $pop13, $pop12
	tee_local	$push10=, $2=, $pop11
	i32.store	foo($pop0), $pop10
	i32.const	$push9=, 0
	i32.load	$0=, bar($pop9)
	block   	
	i32.const	$push8=, 0
	i32.load	$push7=, baz($pop8)
	tee_local	$push6=, $1=, $pop7
	i32.lt_u	$push1=, $2, $pop6
	br_if   	0, $pop1        # 0: down to label0
# BB#1:
	i32.const	$push16=, 2
	i32.gt_u	$3=, $1, $pop16
.LBB0_2:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.eqz 	$push18=, $3
	br_if   	0, $pop18       # 0: up to label1
# BB#3:                                 # %while.cond.if.then_crit_edge
	end_loop
	i32.const	$3=, 0
	i32.const	$push17=, 0
	i32.const	$push2=, 2
	i32.store	foo($pop17), $pop2
.LBB0_4:                                # %if.then
	end_block                       # label0:
	i32.add 	$push3=, $0, $3
	i32.const	$push4=, -2
	i32.and 	$push5=, $pop3, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end0:
	.size	pure_alloc, .Lfunc_end0-pure_alloc
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push14=, 0
	i32.load	$push1=, foo($pop14)
	i32.const	$push13=, 2
	i32.add 	$push12=, $pop1, $pop13
	tee_local	$push11=, $0=, $pop12
	i32.store	foo($pop0), $pop11
	block   	
	block   	
	i32.const	$push10=, 0
	i32.load	$push9=, baz($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.ge_u	$push2=, $0, $pop8
	br_if   	0, $pop2        # 0: down to label3
# BB#1:                                 # %pure_alloc.exit
	i32.eqz 	$push16=, $0
	br_if   	1, $pop16       # 1: down to label2
# BB#2:                                 # %if.end
	i32.const	$push7=, 0
	return  	$pop7
.LBB1_3:                                # %if.end.lr.ph.i
	end_block                       # label3:
	block   	
	i32.const	$push15=, 2
	i32.le_u	$push3=, $1, $pop15
	br_if   	0, $pop3        # 0: down to label4
# BB#4:                                 # %pure_alloc.exit.thread.split
	i32.const	$push5=, 0
	i32.const	$push4=, 2
	i32.store	foo($pop5), $pop4
	i32.const	$push6=, 0
	return  	$pop6
.LBB1_5:                                # %if.end.i
                                        # =>This Inner Loop Header: Depth=1
	end_block                       # label4:
	loop    	                # label5:
	br      	0               # 0: up to label5
.LBB1_6:                                # %if.then
	end_loop
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	foo                     # @foo
	.type	foo,@object
	.section	.bss.foo,"aw",@nobits
	.globl	foo
	.p2align	2
foo:
	.int32	0                       # 0x0
	.size	foo, 4

	.hidden	bar                     # @bar
	.type	bar,@object
	.section	.bss.bar,"aw",@nobits
	.globl	bar
	.p2align	2
bar:
	.int32	0
	.size	bar, 4

	.hidden	baz                     # @baz
	.type	baz,@object
	.section	.data.baz,"aw",@progbits
	.globl	baz
	.p2align	2
baz:
	.int32	100                     # 0x64
	.size	baz, 4


	.ident	"clang version 6.0.0 (https://llvm.googlesource.com/clang.git a1774cccdccfa673c057f93ccf23bc2d8cb04932) (https://llvm.googlesource.com/llvm.git fc50e1c6121255333bc42d6faf2b524c074eae25)"
	.functype	abort, void
