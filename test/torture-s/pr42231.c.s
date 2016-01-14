	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr42231.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 1
	i32.call	$push1=, CallFunctionRec@FUNCTION, $pop0
	i32.const	$push6=, 0
	i32.eq  	$push7=, $pop1, $pop6
	br_if   	$pop7, 0        # 0: down to label0
# BB#1:                                 # %land.rhs.i
	i32.const	$push2=, 0
	call    	storemax@FUNCTION, $pop2
.LBB0_2:                                # %CallFunction.exit
	end_block                       # label0:
	i32.const	$0=, 0
	block
	i32.load	$push3=, max($0)
	i32.const	$push4=, 10
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, 0        # 0: down to label1
# BB#3:                                 # %if.end
	return  	$0
.LBB0_4:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.CallFunctionRec,"ax",@progbits
	.type	CallFunctionRec,@function
CallFunctionRec:                        # @CallFunctionRec
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	call    	storemax@FUNCTION, $0
	i32.const	$1=, 0
	block
	i32.const	$push3=, 0
	i32.eq  	$push4=, $0, $pop3
	br_if   	$pop4, 0        # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$1=, 1
	i32.const	$push0=, 9
	i32.gt_s	$push1=, $0, $pop0
	br_if   	$pop1, 0        # 0: down to label2
# BB#2:                                 # %if.then1
	i32.const	$1=, 1
	i32.add 	$push2=, $0, $1
	i32.call	$discard=, CallFunctionRec@FUNCTION, $pop2
	return  	$1
.LBB1_3:                                # %return
	end_block                       # label2:
	return  	$1
	.endfunc
.Lfunc_end1:
	.size	CallFunctionRec, .Lfunc_end1-CallFunctionRec

	.section	.text.storemax,"ax",@progbits
	.type	storemax,@function
storemax:                               # @storemax
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block
	i32.load	$push0=, max($1)
	i32.ge_s	$push1=, $pop0, $0
	br_if   	$pop1, 0        # 0: down to label3
# BB#1:                                 # %if.then
	i32.store	$discard=, max($1), $0
.LBB2_2:                                # %if.end
	end_block                       # label3:
	return
	.endfunc
.Lfunc_end2:
	.size	storemax, .Lfunc_end2-storemax

	.type	max,@object             # @max
	.lcomm	max,4,2

	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
