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
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label1:
	i64.extend_u/i32	$push0=, $0
	i64.const	$push12=, 2863311531
	i64.mul 	$push1=, $pop0, $pop12
	i64.const	$push11=, 33
	i64.shr_u	$push2=, $pop1, $pop11
	i32.wrap/i64	$push3=, $pop2
	i32.const	$push10=, 3
	i32.div_u	$push4=, $0, $pop10
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	2, $pop5        # 2: down to label0
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push9=, 1
	i32.add 	$0=, $0, $pop9
	i32.const	$push8=, 9999
	i32.le_u	$push6=, $0, $pop8
	br_if   	0, $pop6        # 0: up to label1
# BB#3:                                 # %for.end
	end_loop                        # label2:
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
.LBB1_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
