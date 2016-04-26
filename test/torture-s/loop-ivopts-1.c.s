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
	i32.store	$discard=, foo.tmp+8($pop1), $pop0
	i32.const	$push4=, 0
	i64.const	$push2=, 4803089003686395904
	i64.store	$discard=, foo.tmp($pop4), $pop2
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
	i64.const	$push1=, 4838273375797772288
	i64.store	$discard=, foo.tmp+4($pop0):p2align=2, $pop1
	i32.const	$push10=, 0
	i32.const	$push2=, 1095761920
	i32.store	$push3=, foo.tmp($pop10), $pop2
	i32.store	$discard=, 0($0), $pop3
	i32.const	$push9=, 0
	i32.load	$push4=, foo.tmp+4($pop9)
	i32.store	$discard=, 4($0), $pop4
	i32.const	$push8=, 0
	i32.load	$push5=, foo.tmp+8($pop8)
	i32.store	$discard=, 8($0), $pop5
	i32.const	$push7=, 0
	i32.load	$push6=, foo.tmp+12($pop7)
	i32.store	$discard=, 12($0), $pop6
	return
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.type	foo.tmp,@object         # @foo.tmp
	.lcomm	foo.tmp,16,4

	.ident	"clang version 3.9.0 "
