	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr32244-1.c"
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i64
# BB#0:                                 # %entry
	block   	BB0_2
	i32.const	$push0=, 0
	i64.load	$push1=, x($pop0)
	i64.const	$push2=, 32
	i64.shl 	$push3=, $pop1, $pop2
	i64.ne  	$push4=, $pop3, $0
	br_if   	$pop4, BB0_2
# BB#1:                                 # %if.end
	return
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	test1, func_end0-test1

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.then.i
	i32.const	$0=, 0
	i64.load	$push0=, x($0)
	i64.const	$push1=, -1099511627776
	i64.and 	$push2=, $pop0, $pop1
	i64.const	$push3=, 256
	i64.or  	$push4=, $pop2, $pop3
	i64.store	$discard=, x($0), $pop4
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	x,@object               # @x
	.bss
	.globl	x
	.align	3
x:
	.zero	8
	.size	x, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
