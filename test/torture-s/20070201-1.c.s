	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20070201-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.store	$discard=, 0($5):p2align=4, $1
	i32.const	$push2=, .L.str
	i32.call	$discard=, sprintf@FUNCTION, $0, $pop2, $5
	i32.const	$push0=, 1
	i32.add 	$push1=, $1, $pop0
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
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
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %if.end
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$5=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$5=, 0($1), $5
	i32.const	$push0=, 2
	i32.const	$3=, 10
	i32.add 	$3=, $5, $3
	i32.add 	$push1=, $3, $pop0
	i32.store	$discard=, 0($5):p2align=4, $pop1
	i32.const	$push2=, .L.str
	i32.const	$4=, 10
	i32.add 	$4=, $5, $4
	i32.call	$discard=, sprintf@FUNCTION, $4, $pop2, $5
	i32.const	$push3=, 0
	i32.const	$2=, 16
	i32.add 	$5=, $5, $2
	i32.const	$2=, __stack_pointer
	i32.store	$5=, 0($2), $5
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
