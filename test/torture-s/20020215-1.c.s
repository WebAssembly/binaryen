	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020215-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 4($1)
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop0, $pop1
	i32.store	$2=, 4($1), $pop2
	i32.const	$push4=, 8
	i32.add 	$push6=, $1, $pop4
	i32.load	$3=, 0($pop6)
	i32.load	$push3=, 0($1)
	i32.store	$discard=, 0($0), $pop3
	i32.const	$push9=, 8
	i32.add 	$push5=, $0, $pop9
	i32.store	$discard=, 0($pop5), $3
	i32.const	$push7=, 4
	i32.add 	$push8=, $0, $pop7
	i32.store	$discard=, 0($pop8), $2
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
