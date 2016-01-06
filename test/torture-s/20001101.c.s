	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001101.c"
	.globl	dummy
	.type	dummy,@function
dummy:                                  # @dummy
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.store	$0=, 0($0), $pop0
	i32.const	$push1=, 7
	i32.store	$discard=, 0($1), $pop1
	return  	$0
func_end0:
	.size	dummy, func_end0-dummy

	.globl	bogus
	.type	bogus,@function
bogus:                                  # @bogus
	.param  	i32, i32, i32
# BB#0:                                 # %if.end5
	block   	BB1_2
	i32.load8_u	$push0=, 0($0)
	i32.const	$push1=, 1
	i32.or  	$push2=, $pop0, $pop1
	i32.store8	$discard=, 0($0), $pop2
	i32.const	$push3=, 7
	i32.ne  	$push4=, $1, $pop3
	br_if   	$pop4, BB1_2
# BB#1:                                 # %if.end8
	return
BB1_2:                                  # %if.then7
	call    	abort
	unreachable
func_end1:
	.size	bogus, func_end1-bogus

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
