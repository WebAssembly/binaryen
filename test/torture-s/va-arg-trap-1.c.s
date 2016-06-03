	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/va-arg-trap-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.store	$drop=, ap($pop0), $1
	i32.call	$drop=, foo@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push1=, 0
	i32.load	$push2=, __stack_pointer($pop1)
	i32.const	$push3=, 16
	i32.sub 	$push5=, $pop2, $pop3
	i32.store	$push7=, __stack_pointer($pop4), $pop5
	tee_local	$push6=, $0=, $pop7
	i32.const	$push0=, 0
	i32.store	$drop=, 0($pop6), $pop0
	call    	bar@FUNCTION, $0, $0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	ap                      # @ap
	.type	ap,@object
	.section	.bss.ap,"aw",@nobits
	.globl	ap
	.p2align	2
ap:
	.int32	0
	.size	ap, 4

	.hidden	f                       # @f
	.type	f,@object
	.section	.bss.f,"aw",@nobits
	.globl	f
	.p2align	2
f:
	.int32	0                       # float 0
	.size	f, 4


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
