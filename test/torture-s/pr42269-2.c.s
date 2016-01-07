	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr42269-2.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load16_u	$push1=, s($pop0)
	i64.call	$push2=, foo, $pop1
	i64.const	$push3=, -1
	i64.ne  	$push4=, $pop2, $pop3
	return  	$pop4
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i64
	.local  	i64
# BB#0:                                 # %entry
	i64.const	$1=, 48
	i64.extend_u/i32	$push0=, $0
	i64.shl 	$push1=, $pop0, $1
	i64.shr_s	$push2=, $pop1, $1
	return  	$pop2
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.type	s,@object               # @s
	.data
	.globl	s
	.align	1
s:
	.int16	65535                   # 0xffff
	.size	s, 2


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
