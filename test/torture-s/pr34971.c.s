	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr34971.c"
	.section	.text.test1,"ax",@progbits
	.hidden	test1
	.globl	test1
	.type	test1,@function
test1:                                  # @test1
	.param  	i64
	.local  	i64
# BB#0:                                 # %entry
	block   	.LBB0_2
	i32.const	$push0=, 0
	i64.load	$push1=, x($pop0)
	i64.const	$push2=, 1099511627775
	i64.and 	$1=, $pop1, $pop2
	i64.const	$push3=, 8
	i64.shl 	$push4=, $1, $pop3
	i64.const	$push5=, 32
	i64.shr_u	$push6=, $1, $pop5
	i64.or  	$push7=, $pop4, $pop6
	i64.ne  	$push8=, $pop7, $0
	br_if   	$pop8, .LBB0_2
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	test1, .Lfunc_end0-test1

	.section	.text.main,"ax",@progbits
	.hidden	main
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
	i64.const	$push3=, 4294967297
	i64.or  	$push4=, $pop2, $pop3
	i64.store	$discard=, x($0), $pop4
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.align	3
x:
	.skip	8
	.size	x, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
