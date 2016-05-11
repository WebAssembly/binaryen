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
	.endfunc
.Lfunc_end0:
	.size	init, .Lfunc_end0-init

	.section	.text.expect_func,"ax",@progbits
	.hidden	expect_func
	.globl	expect_func
	.type	expect_func,@function
expect_func:                            # @expect_func
	.param  	i32, i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 0
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push2=, 0
	i32.eq  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %if.end6
	return
.LBB1_3:                                # %if.then5
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	expect_func, .Lfunc_end1-expect_func

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push5=, __stack_pointer
	i32.const	$push2=, __stack_pointer
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push11=, $pop3, $pop4
	i32.store	$push13=, 0($pop5), $pop11
	tee_local	$push12=, $1=, $pop13
	i32.const	$push0=, 0
	i32.store8	$0=, 15($pop12), $pop0
	i32.const	$push1=, 1
	i32.const	$push9=, 15
	i32.add 	$push10=, $1, $pop9
	call    	expect_func@FUNCTION, $pop1, $pop10
	i32.const	$push8=, __stack_pointer
	i32.const	$push6=, 16
	i32.add 	$push7=, $1, $pop6
	i32.store	$discard=, 0($pop8), $pop7
	return  	$0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
