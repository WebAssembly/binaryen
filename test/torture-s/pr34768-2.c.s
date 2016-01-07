	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr34768-2.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$push0=, x($0)
	i32.sub 	$push1=, $0, $pop0
	i32.store	$discard=, x($0), $pop1
	return  	$0
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.globl	test
	.type	test,@function
test:                                   # @test
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$2=, x($1)
	i32.const	$push1=, foo
	i32.const	$push0=, bar
	i32.select	$push2=, $0, $pop1, $pop0
	i32.call_indirect	$push3=, $pop2
	i32.add 	$push5=, $pop3, $2
	i32.load	$push4=, x($1)
	i32.add 	$push6=, $pop5, $pop4
	return  	$pop6
.Lfunc_end2:
	.size	test, .Lfunc_end2-test

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	block   	.LBB3_2
	i32.const	$push0=, 1
	i32.store	$push1=, x($0), $pop0
	i32.call	$push2=, test, $pop1
	br_if   	$pop2, .LBB3_2
# BB#1:                                 # %if.end
	return  	$0
.LBB3_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.type	x,@object               # @x
	.bss
	.globl	x
	.align	2
x:
	.int32	0                       # 0x0
	.size	x, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
