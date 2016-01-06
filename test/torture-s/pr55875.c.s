	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr55875.c"
	.globl	t
	.type	t,@function
t:                                      # @t
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	block   	BB0_4
	i32.const	$push3=, 0
	i32.eq  	$push4=, $0, $pop3
	br_if   	$pop4, BB0_4
# BB#1:                                 # %if.end
	block   	BB0_3
	i32.const	$push0=, 256
	i32.ge_s	$push1=, $0, $pop0
	br_if   	$pop1, BB0_3
# BB#2:                                 # %if.end3
	return  	$0
BB0_3:                                  # %if.then2
	call    	abort
	unreachable
BB0_4:                                  # %if.then
	i32.const	$push2=, 0
	call    	exit, $pop2
	unreachable
func_end0:
	.size	t, func_end0-t

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 5
BB1_1:                                  # %for.cond
                                        # =>This Inner Loop Header: Depth=1
	loop    	BB1_2
	i32.const	$push0=, 255
	i32.and 	$push1=, $0, $pop0
	i32.call	$discard=, t, $pop1
	i32.const	$push2=, 1
	i32.add 	$0=, $0, $pop2
	br      	BB1_1
BB1_2:
func_end1:
	.size	main, func_end1-main

	.type	a,@object               # @a
	.bss
	.globl	a
	.align	4
a:
	.zero	1004
	.size	a, 1004


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
