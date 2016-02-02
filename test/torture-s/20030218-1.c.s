	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20030218-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load16_s	$1=, 0($0)
	i32.const	$push2=, 0
	i32.const	$push0=, 2
	i32.add 	$push1=, $0, $pop0
	i32.store	$discard=, q($pop2), $pop1
	return  	$1
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %if.end
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$3=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$3=, 0($1), $3
	i32.const	$push0=, 65280
	i32.store16	$discard=, 14($3), $pop0
	i32.const	$push3=, 0
	i32.const	$push1=, 2
	i32.const	$2=, 14
	i32.add 	$2=, $3, $2
	i32.add 	$push2=, $2, $pop1
	i32.store	$discard=, q($pop3), $pop2
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
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
