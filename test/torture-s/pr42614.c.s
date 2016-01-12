	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr42614.c"
	.section	.text.init,"ax",@progbits
	.hidden	init
	.globl	init
	.type	init,@function
init:                                   # @init
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.call	$push1=, malloc@FUNCTION, $pop0
	return  	$pop1
.Lfunc_end0:
	.size	init, .Lfunc_end0-init

	.section	.text.expect_func,"ax",@progbits
	.hidden	expect_func
	.globl	expect_func
	.type	expect_func,@function
expect_func:                            # @expect_func
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	.LBB1_4
	i32.const	$push0=, 0
	i32.eq  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB1_4
# BB#1:                                 # %if.end
	block   	.LBB1_3
	i32.const	$push2=, 0
	i32.eq  	$push3=, $1, $pop2
	br_if   	$pop3, .LBB1_3
# BB#2:                                 # %if.end6
	return
.LBB1_3:                                # %if.then5
	call    	abort@FUNCTION
	unreachable
.LBB1_4:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	expect_func, .Lfunc_end1-expect_func

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$4=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$4=, 0($1), $4
	i32.const	$push2=, 1
	i32.const	$3=, 15
	i32.add 	$3=, $4, $3
	call    	expect_func@FUNCTION, $pop2, $3
	i32.const	$push0=, 0
	i32.store8	$push1=, 15($4), $pop0
	i32.const	$2=, 16
	i32.add 	$4=, $4, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	return  	$pop1
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
