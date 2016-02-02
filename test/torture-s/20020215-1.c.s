	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020215-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i64
# BB#0:                                 # %entry
	i32.load	$push0=, 4($1)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$discard=, 4($1), $pop2
	i64.load	$2=, 0($1):p2align=2
	i32.const	$push3=, 8
	i32.add 	$push4=, $0, $pop3
	i32.const	$push7=, 8
	i32.add 	$push5=, $1, $pop7
	i32.load	$push6=, 0($pop5)
	i32.store	$discard=, 0($pop4), $pop6
	i64.store	$discard=, 0($0):p2align=2, $2
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
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
