	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20111227-1.c"
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
# BB#0:                                 # %entry
	block   	BB0_2
	i32.const	$push0=, -1
	i32.ne  	$push1=, $0, $pop0
	br_if   	$pop1, BB0_2
# BB#1:                                 # %if.end
	return
BB0_2:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	bar, func_end0-bar

	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load16_u	$0=, 0($0)
	block   	BB1_3
	block   	BB1_2
	i32.const	$push2=, 0
	i32.eq  	$push3=, $1, $pop2
	br_if   	$pop3, BB1_2
# BB#1:                                 # %if.then
	call    	bar, $0
	br      	BB1_3
BB1_2:                                  # %if.else
	i32.const	$1=, 16
	i32.shl 	$push1=, $0, $1
	i32.shr_s	$push0=, $pop1, $1
	call    	bar, $pop0
BB1_3:                                  # %if.end
	return
func_end1:
	.size	foo, func_end1-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.const	$push0=, v
	call    	foo, $pop0, $0
	return  	$0
func_end2:
	.size	main, func_end2-main

	.type	v,@object               # @v
	.data
	.globl	v
	.align	1
v:
	.int16	65535                   # 0xffff
	.size	v, 2


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
