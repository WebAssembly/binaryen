	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/991023-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push1=, 4044
	i32.store	$push2=, blah($pop0), $pop1
	return  	$pop2
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.const	$push0=, 4044
	i32.store	$discard=, blah($0), $pop0
	call    	exit, $0
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	blah,@object            # @blah
	.bss
	.globl	blah
	.align	2
blah:
	.int32	0                       # 0x0
	.size	blah, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
