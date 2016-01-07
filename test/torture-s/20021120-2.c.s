	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20021120-2.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.const	$push0=, 10
	i32.store	$discard=, g1($1), $pop0
	i32.const	$push1=, 7930
	i32.div_s	$push2=, $pop1, $0
	i32.store	$discard=, g2($1), $pop2
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.const	$push0=, 10
	i32.store	$push1=, g1($0), $pop0
	i32.store	$discard=, g2($0), $pop1
	call    	exit, $0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	g1,@object              # @g1
	.bss
	.globl	g1
	.align	2
g1:
	.int32	0                       # 0x0
	.size	g1, 4

	.type	g2,@object              # @g2
	.globl	g2
	.align	2
g2:
	.int32	0                       # 0x0
	.size	g2, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
