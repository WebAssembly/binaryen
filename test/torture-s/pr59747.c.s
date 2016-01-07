	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59747.c"
	.globl	fn1
	.type	fn1,@function
fn1:                                    # @fn1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, a
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.add 	$push3=, $pop2, $pop1
	i32.load	$push4=, 0($pop3)
	return  	$pop4
.Lfunc_end0:
	.size	fn1, .Lfunc_end0-fn1

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, c($0)
	i32.load16_u	$2=, e($0)
	block   	.LBB1_2
	i32.const	$push1=, 1
	i32.store	$discard=, a($0), $pop1
	i32.const	$push12=, 0
	i32.eq  	$push13=, $1, $pop12
	br_if   	$pop13, .LBB1_2
# BB#1:                                 # %if.then
	i32.const	$push2=, -1
	i32.add 	$push0=, $2, $pop2
	i32.store16	$2=, e($0), $pop0
.LBB1_2:                                  # %if.end
	i32.const	$1=, 16
	block   	.LBB1_4
	i32.shl 	$push3=, $2, $1
	i32.shr_s	$push4=, $pop3, $1
	i32.store	$discard=, d($0), $pop4
	i64.extend_u/i32	$push5=, $2
	i64.const	$push6=, 48
	i64.shl 	$push7=, $pop5, $pop6
	i64.const	$push8=, 63
	i64.shr_u	$push9=, $pop7, $pop8
	i32.wrap/i64	$push10=, $pop9
	i32.call	$push11=, fn1, $pop10
	br_if   	$pop11, .LBB1_4
# BB#3:                                 # %if.end5
	call    	exit, $0
	unreachable
.LBB1_4:                                  # %if.then4
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	c,@object               # @c
	.data
	.globl	c
	.align	2
c:
	.int32	1                       # 0x1
	.size	c, 4

	.type	a,@object               # @a
	.bss
	.globl	a
	.align	4
a:
	.zero	24
	.size	a, 24

	.type	e,@object               # @e
	.globl	e
	.align	1
e:
	.int16	0                       # 0x0
	.size	e, 2

	.type	d,@object               # @d
	.globl	d
	.align	2
d:
	.int32	0                       # 0x0
	.size	d, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
