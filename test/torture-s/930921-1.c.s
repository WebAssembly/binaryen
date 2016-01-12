	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930921-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i64.extend_u/i32	$push0=, $0
	i64.const	$push1=, 2863311531
	i64.mul 	$push2=, $pop0, $pop1
	i64.const	$push3=, 33
	i64.shr_u	$push4=, $pop2, $pop3
	i32.wrap/i64	$push5=, $pop4
	return  	$pop5
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i32, i32
# BB#0:                                 # %entry
	i64.const	$0=, 2863311531
	i32.const	$2=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	.LBB1_4
	loop    	.LBB1_3
	i32.const	$push5=, 3
	i32.div_u	$1=, $2, $pop5
	i64.extend_u/i32	$push0=, $2
	i64.mul 	$push1=, $pop0, $0
	i64.const	$push2=, 33
	i64.shr_u	$push3=, $pop1, $pop2
	i32.wrap/i64	$push4=, $pop3
	i32.ne  	$push6=, $pop4, $1
	br_if   	$pop6, .LBB1_4
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push7=, 1
	i32.add 	$2=, $2, $pop7
	i32.const	$push8=, 9999
	i32.le_u	$push9=, $2, $pop8
	br_if   	$pop9, .LBB1_1
.LBB1_3:                                # %for.end
	i32.const	$push10=, 0
	call    	exit@FUNCTION, $pop10
	unreachable
.LBB1_4:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
