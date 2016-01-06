	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021204-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block   	BB0_2
	i32.const	$push0=, 1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, BB0_2
# BB#1:                                 # %if.end
	return
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	block   	BB1_2
	i32.load	$push0=, z($2)
	i32.const	$push1=, 1
	i32.ge_s	$push2=, $pop0, $pop1
	br_if   	$pop2, BB1_2
# BB#1:                                 # %foo.exit
	call    	exit, $2
	unreachable
BB1_2:                                  # %if.then.i
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	z,@object               # @z
	.bss
	.globl	z
	.align	2
z:
	.int32	0                       # 0x0
	.size	z, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
