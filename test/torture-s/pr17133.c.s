	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr17133.c"
	.section	.text.pure_alloc,"ax",@progbits
	.hidden	pure_alloc
	.globl	pure_alloc
	.type	pure_alloc,@function
pure_alloc:                             # @pure_alloc
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push14=, 0
	i32.load	$push13=, foo($pop14)
	tee_local	$push12=, $3=, $pop13
	i32.const	$push11=, 2
	i32.add 	$push1=, $pop12, $pop11
	i32.store	$0=, foo($pop0), $pop1
	i32.const	$push10=, 0
	i32.load	$1=, bar($pop10)
	block
	i32.const	$push9=, 0
	i32.load	$push8=, baz($pop9)
	tee_local	$push7=, $2=, $pop8
	i32.lt_u	$push2=, $0, $pop7
	br_if   	0, $pop2        # 0: down to label0
# BB#1:
	i32.const	$push15=, 2
	i32.gt_u	$3=, $2, $pop15
.LBB0_2:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.eqz 	$push17=, $3
	br_if   	0, $pop17       # 0: up to label1
# BB#3:                                 # %while.cond.if.then_crit_edge
	end_loop                        # label2:
	i32.const	$3=, 0
	i32.const	$push16=, 0
	i32.const	$push3=, 2
	i32.store	$drop=, foo($pop16), $pop3
.LBB0_4:                                # %if.then
	end_block                       # label0:
	i32.add 	$push4=, $1, $3
	i32.const	$push5=, -2
	i32.and 	$push6=, $pop4, $pop5
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end0:
	.size	pure_alloc, .Lfunc_end0-pure_alloc

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block
	block
	block
	i32.const	$push1=, 0
	i32.const	$push14=, 0
	i32.load	$push2=, foo($pop14)
	i32.const	$push13=, 2
	i32.add 	$push0=, $pop2, $pop13
	i32.store	$push12=, foo($pop1), $pop0
	tee_local	$push11=, $0=, $pop12
	i32.const	$push10=, 0
	i32.load	$push9=, baz($pop10)
	tee_local	$push8=, $1=, $pop9
	i32.ge_u	$push3=, $pop11, $pop8
	br_if   	0, $pop3        # 0: down to label5
# BB#1:                                 # %pure_alloc.exit
	br_if   	1, $0           # 1: down to label4
# BB#2:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB1_3:                                # %if.end.lr.ph.i
	end_block                       # label5:
	i32.const	$push15=, 2
	i32.le_u	$push4=, $1, $pop15
	br_if   	1, $pop4        # 1: down to label3
# BB#4:                                 # %pure_alloc.exit.thread.split
	i32.const	$push6=, 0
	i32.const	$push5=, 2
	i32.store	$drop=, foo($pop6), $pop5
.LBB1_5:                                # %if.end
	end_block                       # label4:
	i32.const	$push7=, 0
	return  	$pop7
.LBB1_6:                                # %if.end.i
                                        # =>This Inner Loop Header: Depth=1
	end_block                       # label3:
	loop                            # label6:
	br      	0               # 0: up to label6
.LBB1_7:
	end_loop                        # label7:
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

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


	.ident	"clang version 3.9.0 "
	.functype	abort, void
