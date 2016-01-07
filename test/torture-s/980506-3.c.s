	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/980506-3.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %if.else
	i32.const	$push0=, lookup_table
	i32.const	$push2=, 4
	i32.const	$push1=, 257
	call    	memset, $pop0, $pop2, $pop1
	i32.const	$push3=, 0
	call    	exit, $pop3
	unreachable
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	lookup_table,@object    # @lookup_table
	.bss
	.globl	lookup_table
	.align	4
lookup_table:
	.zero	257
	.size	lookup_table, 257


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
