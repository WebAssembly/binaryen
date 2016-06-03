	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000706-4.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push1=, 2
	i32.ne  	$push2=, $0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push3=, 0
	i32.load	$push4=, c($pop3)
	i32.load	$push0=, 0($pop4)
	i32.const	$push5=, 1
	i32.ne  	$push6=, $pop0, $pop5
	br_if   	0, $pop6        # 0: down to label0
# BB#2:                                 # %if.end
	return
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push15=, $pop7, $pop8
	i32.store	$push17=, __stack_pointer($pop9), $pop15
	tee_local	$push16=, $2=, $pop17
	i32.const	$push13=, 12
	i32.add 	$push14=, $pop16, $pop13
	i32.store	$drop=, c($pop1), $pop14
	block
	i32.store	$push0=, 12($2), $0
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop0, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %entry
	i32.const	$push4=, 2
	i32.ne  	$push5=, $1, $pop4
	br_if   	0, $pop5        # 0: down to label1
# BB#2:                                 # %bar.exit
	i32.const	$push12=, 0
	i32.const	$push10=, 16
	i32.add 	$push11=, $2, $pop10
	i32.store	$drop=, __stack_pointer($pop12), $pop11
	return
.LBB1_3:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 1
	i32.const	$push0=, 2
	call    	foo@FUNCTION, $pop1, $pop0
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0
	.size	c, 4


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
