	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20070201-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push3=, __stack_pointer
	i32.load	$push4=, 0($pop3)
	i32.const	$push5=, 16
	i32.sub 	$2=, $pop4, $pop5
	i32.const	$push6=, __stack_pointer
	i32.store	$discard=, 0($pop6), $2
	i32.store	$discard=, 0($2):p2align=4, $1
	i32.const	$push2=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $0, $pop2, $2
	i32.const	$push0=, 1
	i32.add 	$push1=, $1, $pop0
	i32.const	$push7=, 16
	i32.add 	$2=, $2, $pop7
	i32.const	$push8=, __stack_pointer
	i32.store	$discard=, 0($pop8), $2
	return  	$pop1
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %if.end
	i32.const	$push4=, __stack_pointer
	i32.load	$push5=, 0($pop4)
	i32.const	$push6=, 16
	i32.sub 	$2=, $pop5, $pop6
	i32.const	$push7=, __stack_pointer
	i32.store	$discard=, 0($pop7), $2
	i32.const	$push0=, 2
	i32.const	$0=, 10
	i32.add 	$0=, $2, $0
	i32.add 	$push1=, $0, $pop0
	i32.store	$discard=, 0($2):p2align=4, $pop1
	i32.const	$push2=, .L.str
	i32.const	$1=, 10
	i32.add 	$1=, $2, $1
	i32.call	$discard=, sprintf@FUNCTION, $1, $pop2, $2
	i32.const	$push3=, 0
	i32.const	$push8=, 16
	i32.add 	$2=, $2, $pop8
	i32.const	$push9=, __stack_pointer
	i32.store	$discard=, 0($pop9), $2
	return  	$pop3
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"abcde"
	.size	.L.str, 6


	.ident	"clang version 3.9.0 "
