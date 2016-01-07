	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020118-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
.LBB0_1:                                  # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB0_2
	i32.load	$1=, q($0)
	i32.load8_s	$push0=, 2($1)
	i32.store	$discard=, n($0), $pop0
	i32.load8_s	$push1=, 2($1)
	i32.store	$discard=, n($0), $pop1
	i32.load8_s	$push2=, 2($1)
	i32.store	$discard=, n($0), $pop2
	i32.load8_s	$push3=, 2($1)
	i32.store	$discard=, n($0), $pop3
	i32.load	$1=, q($0)
	i32.load8_s	$push4=, 2($1)
	i32.store	$discard=, n($0), $pop4
	i32.load8_s	$push5=, 2($1)
	i32.store	$discard=, n($0), $pop5
	i32.load	$1=, q($0)
	i32.load8_s	$push6=, 2($1)
	i32.store	$discard=, n($0), $pop6
	i32.load8_s	$push7=, 2($1)
	i32.store	$discard=, n($0), $pop7
	i32.load	$1=, q($0)
	i32.load8_s	$push8=, 2($1)
	i32.store	$discard=, n($0), $pop8
	i32.load8_s	$push9=, 2($1)
	i32.store	$discard=, n($0), $pop9
	i32.load	$push10=, q($0)
	i32.load8_s	$push11=, 2($pop10)
	i32.store	$discard=, n($0), $pop11
	br      	.LBB0_1
.LBB0_2:
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	q,@object               # @q
	.bss
	.globl	q
	.align	2
q:
	.int32	0
	.size	q, 4

	.type	n,@object               # @n
	.globl	n
	.align	2
n:
	.int32	0                       # 0x0
	.size	n, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
