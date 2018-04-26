	.text
	.file	"pr17133.c"
	.section	.text.pure_alloc,"ax",@progbits
	.hidden	pure_alloc              # -- Begin function pure_alloc
	.globl	pure_alloc
	.type	pure_alloc,@function
pure_alloc:                             # @pure_alloc
	.result 	i32
	.local  	i32, i32, i32, i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$3=, foo($pop0)
	i32.const	$push9=, 2
	i32.add 	$2=, $3, $pop9
	i32.const	$push8=, 0
	i32.store	foo($pop8), $2
	i32.const	$push7=, 0
	i32.load	$1=, baz($pop7)
	i32.const	$push6=, 0
	i32.load	$0=, bar($pop6)
	block   	
	i32.lt_u	$push1=, $2, $1
	br_if   	0, $pop1        # 0: down to label0
# %bb.1:
	i32.const	$push10=, 2
	i32.gt_u	$3=, $1, $pop10
.LBB0_2:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.eqz 	$push12=, $3
	br_if   	0, $pop12       # 0: up to label1
# %bb.3:                                # %while.cond.if.then_crit_edge
	end_loop
	i32.const	$3=, 0
	i32.const	$push11=, 0
	i32.const	$push2=, 2
	i32.store	foo($pop11), $pop2
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
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, foo($pop0)
	i32.const	$push10=, 2
	i32.add 	$0=, $pop1, $pop10
	i32.const	$push9=, 0
	i32.store	foo($pop9), $0
	i32.const	$push8=, 0
	i32.load	$1=, baz($pop8)
	block   	
	block   	
	i32.ge_u	$push2=, $0, $1
	br_if   	0, $pop2        # 0: down to label3
# %bb.1:                                # %pure_alloc.exit
	i32.eqz 	$push12=, $0
	br_if   	1, $pop12       # 1: down to label2
# %bb.2:                                # %if.end
	i32.const	$push7=, 0
	return  	$pop7
.LBB1_3:                                # %if.end.lr.ph.i
	end_block                       # label3:
	block   	
	i32.const	$push11=, 2
	i32.le_u	$push3=, $1, $pop11
	br_if   	0, $pop3        # 0: down to label4
# %bb.4:                                # %pure_alloc.exit.thread.split
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
