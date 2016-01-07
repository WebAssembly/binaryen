	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/vrp-7.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i32.load8_u	$push2=, t($1)
	i32.const	$push5=, 254
	i32.and 	$push6=, $pop2, $pop5
	i32.const	$push0=, 4
	i32.shr_u	$push1=, $0, $pop0
	i32.const	$push3=, 1
	i32.and 	$push4=, $pop1, $pop3
	i32.or  	$push7=, $pop6, $pop4
	i32.store8	$discard=, t($1), $pop7
	return
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 16
	call    	foo, $pop0
	i32.const	$0=, 0
	block   	.LBB1_2
	i32.load8_u	$push1=, t($0)
	i32.const	$push2=, 1
	i32.and 	$push3=, $pop1, $pop2
	i32.const	$push4=, 0
	i32.eq  	$push5=, $pop3, $pop4
	br_if   	$pop5, .LBB1_2
# BB#1:                                 # %if.end
	return  	$0
.LBB1_2:                                  # %if.then
	call    	abort
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	t,@object               # @t
	.bss
	.globl	t
	.align	2
t:
	.zero	4
	.size	t, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
