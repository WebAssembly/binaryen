	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20080604-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	block   	BB0_2
	i32.const	$push0=, 0
	i32.load	$push1=, x($pop0)
	i32.const	$push2=, 0
	i32.eq  	$push3=, $pop1, $pop2
	br_if   	$pop3, BB0_2
# BB#1:                                 # %if.end
	return
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	foo, func_end0-foo

	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.param  	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$4=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	i32.const	$push0=, x
	i32.const	$4=, 12
	i32.add 	$4=, $4, $4
	i32.select	$0=, $0, $4, $pop0
	call    	foo
	i32.const	$push1=, .str
	i32.store	$push2=, 0($0), $pop1
	i32.store	$discard=, 0($0), $pop2
	i32.const	$3=, 16
	i32.add 	$4=, $4, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	return
func_end1:
	.size	baz, func_end1-baz

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	call    	foo
	i32.const	$push0=, .str
	i32.store	$push1=, x($0), $pop0
	i32.store	$discard=, x($0), $pop1
	return  	$0
func_end2:
	.size	main, func_end2-main

	.type	x,@object               # @x
	.bss
	.globl	x
	.align	2
x:
	.zero	4
	.size	x, 4

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"Everything OK"
	.size	.str, 14


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
