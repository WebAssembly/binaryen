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
	i32.store	$drop=, foo.tmp+8($pop1), $pop0
	i32.const	$push4=, 0
	i64.const	$push2=, 4803089003686395904
	i64.store	$drop=, foo.tmp($pop4), $pop2
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i64
# BB#0:                                 # %for.inc9.3
	i32.const	$push1=, 0
	i64.const	$push0=, 4838273375797772288
	i64.store	$drop=, foo.tmp+4($pop1):p2align=2, $pop0
	i32.const	$push10=, 0
	i32.const	$push2=, 1095761920
	i32.store	$drop=, foo.tmp($pop10), $pop2
	i32.const	$push3=, 1118306304
	i32.store	$drop=, 4($0), $pop3
	i32.const	$push9=, 1095761920
	i32.store	$drop=, 0($0), $pop9
	i32.const	$push8=, 0
	i64.load	$push7=, foo.tmp+8($pop8)
	tee_local	$push6=, $1=, $pop7
	i64.store32	$drop=, 8($0), $pop6
	i64.const	$push4=, 32
	i64.shr_u	$push5=, $1, $pop4
	i64.store32	$drop=, 12($0), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.type	foo.tmp,@object         # @foo.tmp
	.section	.bss.foo.tmp,"aw",@nobits
	.p2align	4
foo.tmp:
	.skip	16
	.size	foo.tmp, 16


	.ident	"clang version 4.0.0 "
