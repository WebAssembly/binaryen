	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030218-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push2=, 0
	i32.const	$push0=, 2
	i32.add 	$push1=, $0, $pop0
	i32.store	$drop=, q($pop2), $pop1
	i32.load16_s	$push3=, 0($0)
                                        # fallthrough-return: $pop3
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
	i32.const	$push2=, 0
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push8=, $pop5, $pop6
	i32.store	$push11=, __stack_pointer($pop7), $pop8
	tee_local	$push10=, $0=, $pop11
	i32.const	$push0=, 16
	i32.add 	$push1=, $pop10, $pop0
	i32.store	$drop=, q($pop2), $pop1
	i32.const	$push3=, 65280
	i32.store16	$drop=, 14($0), $pop3
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	q                       # @q
	.type	q,@object
	.section	.bss.q,"aw",@nobits
	.globl	q
	.p2align	2
q:
	.int32	0
	.size	q, 4


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
