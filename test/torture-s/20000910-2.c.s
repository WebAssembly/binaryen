	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000910-2.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$1=, 42
	block   	BB0_4
	i32.load	$push0=, list($0)
	i32.call	$push1=, strchr, $pop0, $1
	i32.const	$push4=, 0
	i32.eq  	$push5=, $pop1, $pop4
	br_if   	$pop5, BB0_4
# BB#1:                                 # %if.then.i
	block   	BB0_3
	i32.load	$push2=, list+4($0)
	i32.call	$push3=, strchr, $pop2, $1
	i32.const	$push6=, 0
	i32.eq  	$push7=, $pop3, $pop6
	br_if   	$pop7, BB0_3
# BB#2:                                 # %foo.exit
	return  	$0
BB0_3:                                  # %if.else.i
	call    	exit, $0
	unreachable
BB0_4:                                  # %if.then2.i
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"*"
	.size	.str, 2

	.type	.str.1,@object          # @.str.1
.str.1:
	.asciz	"e"
	.size	.str.1, 2

	.type	list,@object            # @list
	.data
	.globl	list
	.align	2
list:
	.int32	.str
	.int32	.str.1
	.size	list, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
