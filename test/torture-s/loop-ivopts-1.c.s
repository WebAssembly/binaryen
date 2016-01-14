	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-ivopts-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push0=, 1126498304
	i32.store	$discard=, foo.tmp+8($0), $pop0
	i64.const	$push1=, 4803089003686395904
	i64.store	$discard=, foo.tmp($0), $pop1
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32, i32
# BB#0:                                 # %for.inc9.3
	i32.const	$1=, 0
	i32.const	$push0=, 1126498304
	i32.store	$discard=, foo.tmp+8($1), $pop0
	i32.const	$push1=, 1118306304
	i32.store	$2=, foo.tmp+4($1), $pop1
	i32.const	$push2=, 1095761920
	i32.store	$push3=, foo.tmp($1), $pop2
	i32.store	$discard=, 0($0), $pop3
	i32.store	$discard=, 4($0), $2
	i64.load	$push4=, foo.tmp+8($1)
	i64.store32	$push5=, 8($0), $pop4
	i64.const	$push6=, 32
	i64.shr_u	$push7=, $pop5, $pop6
	i64.store32	$discard=, 12($0), $pop7
	return
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.type	foo.tmp,@object         # @foo.tmp
	.lcomm	foo.tmp,16,4

	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
