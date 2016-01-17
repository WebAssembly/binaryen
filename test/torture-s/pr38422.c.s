	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr38422.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, s($0)
	i32.const	$push0=, 1
	i32.shl 	$push1=, $1, $pop0
	i32.const	$push2=, 1073741822
	i32.and 	$push3=, $pop1, $pop2
	i32.const	$push4=, -1073741824
	i32.and 	$push5=, $1, $pop4
	i32.or  	$push6=, $pop3, $pop5
	i32.store	$discard=, s($0), $pop6
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.load	$push0=, s($0)
	i32.const	$push1=, -1073741824
	i32.and 	$push2=, $pop0, $pop1
	i32.const	$push3=, 48
	i32.or  	$push4=, $pop2, $pop3
	i32.store	$discard=, s($0), $pop4
	return  	$0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	s                       # @s
	.type	s,@object
	.section	.bss.s,"aw",@nobits
	.globl	s
	.align	2
s:
	.skip	4
	.size	s, 4


	.ident	"clang version 3.9.0 "
