	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr17133.c"
	.section	.text.pure_alloc,"ax",@progbits
	.hidden	pure_alloc
	.globl	pure_alloc
	.type	pure_alloc,@function
pure_alloc:                             # @pure_alloc
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$0=, bar($pop0)
	i32.const	$push14=, 0
	i32.load	$1=, baz($pop14)
	block
	i32.const	$push13=, 0
	i32.const	$push12=, 0
	i32.load	$push11=, foo($pop12)
	tee_local	$push10=, $2=, $pop11
	i32.const	$push9=, 2
	i32.add 	$push1=, $pop10, $pop9
	i32.store	$push2=, foo($pop13), $pop1
	i32.lt_u	$push3=, $pop2, $1
	br_if   	0, $pop3        # 0: down to label0
.LBB0_1:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push16=, 2
	i32.le_u	$push4=, $1, $pop16
	br_if   	0, $pop4        # 0: up to label1
# BB#2:                                 # %while.body.if.then_crit_edge
	end_loop                        # label2:
	i32.const	$2=, 0
	i32.const	$push15=, 0
	i32.const	$push5=, 2
	i32.store	$discard=, foo($pop15), $pop5
.LBB0_3:                                # %if.then
	end_block                       # label0:
	i32.add 	$push6=, $0, $2
	i32.const	$push7=, -2
	i32.and 	$push8=, $pop6, $pop7
	return  	$pop8
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
	i32.const	$push1=, 0
	i32.load	$0=, baz($pop1)
	block
	block
	block
	i32.const	$push13=, 0
	i32.const	$push12=, 0
	i32.load	$push2=, foo($pop12)
	i32.const	$push3=, 2
	i32.add 	$push0=, $pop2, $pop3
	i32.store	$push11=, foo($pop13), $pop0
	tee_local	$push10=, $1=, $pop11
	i32.ge_u	$push4=, $pop10, $0
	br_if   	0, $pop4        # 0: down to label5
# BB#1:                                 # %pure_alloc.exit
	br_if   	1, $1           # 1: down to label4
# BB#2:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB1_3:                                # %if.end.lr.ph.i
	end_block                       # label5:
	i32.const	$push5=, 3
	i32.lt_u	$push6=, $0, $pop5
	br_if   	1, $pop6        # 1: down to label3
# BB#4:                                 # %pure_alloc.exit.thread.split
	i32.const	$push7=, 0
	i32.const	$push8=, 2
	i32.store	$discard=, foo($pop7), $pop8
.LBB1_5:                                # %if.end
	end_block                       # label4:
	i32.const	$push9=, 0
	return  	$pop9
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
