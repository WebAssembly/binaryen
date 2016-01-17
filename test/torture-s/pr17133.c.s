	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr17133.c"
	.section	.text.pure_alloc,"ax",@progbits
	.hidden	pure_alloc
	.globl	pure_alloc
	.type	pure_alloc,@function
pure_alloc:                             # @pure_alloc
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.load	$4=, foo($2)
	i32.load	$0=, bar($2)
	i32.load	$1=, baz($2)
	i32.const	$3=, 2
	block
	i32.add 	$push0=, $4, $3
	i32.store	$push1=, foo($2), $pop0
	i32.lt_u	$push2=, $pop1, $1
	br_if   	$pop2, 0        # 0: down to label0
.LBB0_1:                                # %if.end
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.le_u	$push3=, $1, $3
	br_if   	$pop3, 0        # 0: up to label1
# BB#2:                                 # %while.body.if.then_crit_edge
	end_loop                        # label2:
	i32.store	$discard=, foo($2), $3
	copy_local	$4=, $2
.LBB0_3:                                # %if.then
	end_block                       # label0:
	i32.add 	$push4=, $0, $4
	i32.const	$push5=, -2
	i32.and 	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end0:
	.size	pure_alloc, .Lfunc_end0-pure_alloc

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$0=, baz($1)
	i32.const	$2=, 2
	block
	block
	block
	i32.load	$push1=, foo($1)
	i32.add 	$push0=, $pop1, $2
	i32.store	$3=, foo($1), $pop0
	i32.ge_u	$push2=, $3, $0
	br_if   	$pop2, 0        # 0: down to label5
# BB#1:                                 # %pure_alloc.exit
	br_if   	$3, 1           # 1: down to label4
# BB#2:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB1_3:                                # %if.end.lr.ph.i
	end_block                       # label5:
	i32.const	$push3=, 3
	i32.lt_u	$push4=, $0, $pop3
	br_if   	$pop4, 1        # 1: down to label3
# BB#4:                                 # %pure_alloc.exit.thread.split
	i32.store	$discard=, foo($1), $2
.LBB1_5:                                # %if.end
	end_block                       # label4:
	return  	$1
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
	.align	2
foo:
	.int32	0                       # 0x0
	.size	foo, 4

	.hidden	bar                     # @bar
	.type	bar,@object
	.section	.bss.bar,"aw",@nobits
	.globl	bar
	.align	2
bar:
	.int32	0
	.size	bar, 4

	.hidden	baz                     # @baz
	.type	baz,@object
	.section	.data.baz,"aw",@progbits
	.globl	baz
	.align	2
baz:
	.int32	100                     # 0x64
	.size	baz, 4


	.ident	"clang version 3.9.0 "
