	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030913-1.c"
	.globl	fn2
	.type	fn2,@function
fn2:                                    # @fn2
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, glob
	i32.store	$discard=, 0($0), $pop0
	return
func_end0:
	.size	fn2, func_end0-fn2

	.globl	test
	.type	test,@function
test:                                   # @test
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push1=, 42
	i32.store	$discard=, glob($pop0), $pop1
	return
func_end1:
	.size	test, func_end1-test

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.const	$push0=, 42
	i32.store	$discard=, glob($0), $pop0
	call    	exit, $0
	unreachable
func_end2:
	.size	main, func_end2-main

	.type	glob,@object            # @glob
	.bss
	.globl	glob
	.align	2
glob:
	.int32	0                       # 0x0
	.size	glob, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
