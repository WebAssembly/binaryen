	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010409-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.load8_s	$push0=, 4($1)
	i32.const	$push1=, 25
	i32.mul 	$push2=, $2, $pop1
	i32.add 	$push3=, $pop0, $pop2
	i32.store	$discard=, c($pop4), $pop3
	return
func_end0:
	.size	foo, func_end0-foo

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	BB1_2
	br_if   	$1, BB1_2
# BB#1:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	bar, func_end1-bar

	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i32.load	$3=, b($2)
	block   	BB2_2
	i32.const	$push0=, 5000
	i32.store	$discard=, c($2), $pop0
	br_if   	$3, BB2_2
# BB#1:                                 # %if.then.i
	call    	abort
	unreachable
BB2_2:                                  # %if.end.i
	call    	exit, $2
	unreachable
func_end2:
	.size	test, func_end2-test

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.store	$discard=, d+4($0), $0
	i32.load	$1=, b($0)
	block   	BB3_2
	i32.const	$push0=, a
	i32.store	$discard=, d($0), $pop0
	i32.const	$push1=, 5000
	i32.store	$discard=, c($0), $pop1
	br_if   	$1, BB3_2
# BB#1:                                 # %if.then.i.i
	call    	abort
	unreachable
BB3_2:                                  # %if.end.i.i
	call    	exit, $0
	unreachable
func_end3:
	.size	main, func_end3-main

	.type	b,@object               # @b
	.data
	.globl	b
	.align	2
b:
	.int32	1                       # 0x1
	.size	b, 4

	.type	c,@object               # @c
	.bss
	.globl	c
	.align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.type	d,@object               # @d
	.globl	d
	.align	2
d:
	.zero	8
	.size	d, 8

	.type	a,@object               # @a
	.globl	a
	.align	2
a:
	.int32	0
	.size	a, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
