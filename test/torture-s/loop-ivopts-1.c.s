	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-ivopts-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push0=, 1126498304
	i32.store	$discard=, foo.tmp+8($pop1):p2align=3, $pop0
	i32.const	$push4=, 0
	i64.const	$push2=, 4803089003686395904
	i64.store	$discard=, foo.tmp($pop4):p2align=4, $pop2
	i32.const	$push3=, 0
	return  	$pop3
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %for.inc9.3
	i32.const	$push0=, 0
	i32.const	$push1=, 1126498304
	i32.store	$discard=, foo.tmp+8($pop0):p2align=3, $pop1
	i32.const	$push11=, 0
	i32.const	$push2=, 1118306304
	i32.store	$discard=, foo.tmp+4($pop11), $pop2
	i32.const	$push10=, 0
	i32.const	$push3=, 1095761920
	i32.store	$discard=, foo.tmp($pop10):p2align=4, $pop3
	i64.const	$push4=, 4803089003686395904
	i64.store	$discard=, 0($0):p2align=2, $pop4
	i32.const	$push9=, 0
	i64.load	$push5=, foo.tmp+8($pop9)
	i64.store32	$push6=, 8($0), $pop5
	i64.const	$push7=, 32
	i64.shr_u	$push8=, $pop6, $pop7
	i64.store32	$discard=, 12($0), $pop8
	return
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.type	foo.tmp,@object         # @foo.tmp
	.lcomm	foo.tmp,16,4

	.ident	"clang version 3.9.0 "
