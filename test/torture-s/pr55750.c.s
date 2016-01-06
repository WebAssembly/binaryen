	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr55750.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 2
	i32.const	$push1=, arr
	i32.shl 	$push0=, $0, $1
	i32.add 	$0=, $pop1, $pop0
	i32.load8_u	$push2=, 0($0)
	i32.add 	$push3=, $pop2, $1
	i32.store8	$discard=, 0($0), $pop3
	return
func_end0:
	.size	foo, func_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push1=, 127
	i32.store8	$discard=, arr($0), $pop1
	i32.const	$push2=, 254
	i32.store8	$discard=, arr+4($0), $pop2
	call    	foo, $0
	block   	BB1_3
	i32.const	$push3=, 1
	call    	foo, $pop3
	i32.load8_u	$push4=, arr($0)
	i32.const	$push5=, 129
	i32.ne  	$push6=, $pop4, $pop5
	br_if   	$pop6, BB1_3
# BB#1:                                 # %entry
	i32.load8_u	$push0=, arr+4($0)
	i32.const	$push7=, 255
	i32.and 	$push8=, $pop0, $pop7
	br_if   	$pop8, BB1_3
# BB#2:                                 # %if.end
	return  	$0
BB1_3:                                  # %if.then
	call    	abort
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	arr,@object             # @arr
	.bss
	.globl	arr
	.align	2
arr:
	.zero	8
	.size	arr, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
