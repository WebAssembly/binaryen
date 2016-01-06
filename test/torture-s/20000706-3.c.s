	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000706-3.c"
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.load	$push0=, 0($0)
	i32.store	$discard=, c($pop1), $pop0
	return
func_end0:
	.size	baz, func_end0-baz

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	block   	BB1_3
	i32.const	$push2=, 2
	i32.ne  	$push3=, $0, $pop2
	br_if   	$pop3, BB1_3
# BB#1:                                 # %entry
	i32.const	$push1=, 0
	i32.load	$push0=, c($pop1)
	i32.const	$push4=, 1
	i32.ne  	$push5=, $pop0, $pop4
	br_if   	$pop5, BB1_3
# BB#2:                                 # %if.end
	return
BB1_3:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	bar, func_end1-bar

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	BB2_3
	i32.const	$push0=, 0
	i32.store	$push1=, c($pop0), $0
	i32.const	$push2=, 1
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	$pop3, BB2_3
# BB#1:                                 # %entry
	i32.const	$push4=, 2
	i32.ne  	$push5=, $1, $pop4
	br_if   	$pop5, BB2_3
# BB#2:                                 # %bar.exit
	return
BB2_3:                                  # %if.then.i
	call    	abort
	unreachable
func_end2:
	.size	foo, func_end2-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push0=, 1
	i32.store	$discard=, c($0), $pop0
	call    	exit, $0
	unreachable
func_end3:
	.size	main, func_end3-main

	.type	c,@object               # @c
	.bss
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
