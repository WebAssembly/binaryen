	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020216-1.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load8_s	$push1=, c($pop0)
	i32.const	$push2=, 65535
	i32.and 	$push3=, $pop1, $pop2
	i32.const	$push4=, -103
	i32.xor 	$push5=, $pop3, $pop4
	return  	$pop5
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$1=, 65535
	block   	BB1_2
	i32.load8_s	$push0=, c($0)
	i32.and 	$push1=, $pop0, $1
	i32.ne  	$push2=, $pop1, $1
	br_if   	$pop2, BB1_2
# BB#1:                                 # %if.end
	call    	exit, $0
	unreachable
BB1_2:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	c,@object               # @c
	.data
	.globl	c
c:
	.int8	255                     # 0xff
	.size	c, 1


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
