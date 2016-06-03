	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020215-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push1=, 0($1)
	i32.store	$drop=, 0($0), $pop1
	i32.const	$push2=, 8
	i32.add 	$push3=, $0, $pop2
	i32.const	$push11=, 8
	i32.add 	$push4=, $1, $pop11
	i32.load	$push5=, 0($pop4)
	i32.store	$drop=, 0($pop3), $pop5
	i32.const	$push6=, 4
	i32.add 	$push7=, $0, $pop6
	i32.load	$push8=, 4($1)
	i32.const	$push9=, 1
	i32.add 	$push10=, $pop8, $pop9
	i32.store	$push0=, 0($pop7), $pop10
	i32.store	$drop=, 4($1), $pop0
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
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
