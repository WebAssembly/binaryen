	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr19689.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load	$push0=, f($1)
	i32.const	$push3=, -536870912
	i32.and 	$push4=, $pop0, $pop3
	i32.const	$push1=, 536870911
	i32.and 	$push2=, $0, $pop1
	i32.or  	$push5=, $pop4, $pop2
	i32.store	$discard=, f($1), $pop5
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
	i32.load	$push0=, f($0)
	i32.const	$push1=, -536870912
	i32.and 	$push2=, $pop0, $pop1
	i32.const	$push3=, 536870857
	i32.or  	$push4=, $pop2, $pop3
	i32.store	$discard=, f($0), $pop4
	return  	$0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.align	2
f:
	.skip	4
	.size	f, 4


	.ident	"clang version 3.9.0 "
