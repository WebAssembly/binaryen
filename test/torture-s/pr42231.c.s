	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr42231.c"
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	BB0_2
	i32.const	$push0=, 1
	i32.call	$push1=, CallFunctionRec, $pop0
	i32.const	$push6=, 0
	i32.eq  	$push7=, $pop1, $pop6
	br_if   	$pop7, BB0_2
# BB#1:                                 # %land.rhs.i
	i32.const	$push2=, 0
	call    	storemax, $pop2
BB0_2:                                  # %CallFunction.exit
	i32.const	$0=, 0
	block   	BB0_4
	i32.load	$push3=, max($0)
	i32.const	$push4=, 10
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, BB0_4
# BB#3:                                 # %if.end
	return  	$0
BB0_4:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	main, func_end0-main

	.type	CallFunctionRec,@function
CallFunctionRec:                        # @CallFunctionRec
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	call    	storemax, $0
	i32.const	$1=, 0
	block   	BB1_3
	i32.const	$push3=, 0
	i32.eq  	$push4=, $0, $pop3
	br_if   	$pop4, BB1_3
# BB#1:                                 # %if.end
	i32.const	$1=, 1
	i32.const	$push0=, 9
	i32.gt_s	$push1=, $0, $pop0
	br_if   	$pop1, BB1_3
# BB#2:                                 # %if.then1
	i32.const	$1=, 1
	i32.add 	$push2=, $0, $1
	i32.call	$discard=, CallFunctionRec, $pop2
	return  	$1
BB1_3:                                  # %return
	return  	$1
func_end1:
	.size	CallFunctionRec, func_end1-CallFunctionRec

	.type	storemax,@function
storemax:                               # @storemax
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block   	BB2_2
	i32.load	$push0=, max($1)
	i32.ge_s	$push1=, $pop0, $0
	br_if   	$pop1, BB2_2
# BB#1:                                 # %if.then
	i32.store	$discard=, max($1), $0
BB2_2:                                  # %if.end
	return
func_end2:
	.size	storemax, func_end2-storemax

	.type	max,@object             # @max
	.lcomm	max,4,2

	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
