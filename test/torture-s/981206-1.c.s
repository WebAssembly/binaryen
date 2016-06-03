	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/981206-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push3=, 0
	i32.const	$push1=, 1
	i32.store8	$push0=, y($pop3), $pop1
	i32.store8	$drop=, x($pop2), $pop0
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push2=, 0
	i32.const	$push4=, 0
	i32.const	$push1=, 1
	i32.store8	$push0=, y($pop4), $pop1
	i32.store8	$drop=, x($pop2), $pop0
	i32.const	$push3=, 0
	call    	exit@FUNCTION, $pop3
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	x,@object               # @x
	.lcomm	x,1,1
	.type	y,@object               # @y
	.lcomm	y,1,1

	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
