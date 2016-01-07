	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010925-1.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i64.load	$1=, src($0)
	i32.load16_u	$push0=, src+8($0)
	i32.store16	$discard=, dst+8($0), $pop0
	i64.store	$discard=, dst($0), $1
	call    	exit, $0
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$3=, 1
	block   	.LBB1_2
	i32.const	$push0=, 0
	i32.eq  	$push1=, $2, $pop0
	br_if   	$pop1, .LBB1_2
# BB#1:                                 # %if.end
	call    	memcpy, $0, $1, $2
	i32.const	$3=, 0
.LBB1_2:                                  # %return
	return  	$3
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.type	dst,@object             # @dst
	.bss
	.globl	dst
	.align	4
dst:
	.zero	40
	.size	dst, 40

	.type	src,@object             # @src
	.globl	src
	.align	4
src:
	.zero	40
	.size	src, 40


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
