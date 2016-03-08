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
	.local  	i64, i32
# BB#0:                                 # %entry
	i64.const	$0=, 0
	i32.const	$1=, 0
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block
	loop                            # label1:
	i64.const	$push10=, 33
	i64.shr_u	$push0=, $0, $pop10
	i32.wrap/i64	$push1=, $pop0
	i32.const	$push9=, 3
	i32.div_u	$push2=, $1, $pop9
	i32.ne  	$push3=, $pop1, $pop2
	br_if   	2, $pop3        # 2: down to label0
# BB#2:                                 # %for.cond
                                        #   in Loop: Header=BB1_1 Depth=1
	i32.const	$push8=, 1
	i32.add 	$1=, $1, $pop8
	i64.const	$push7=, 2863311531
	i64.add 	$0=, $0, $pop7
	i32.const	$push6=, 9999
	i32.le_u	$push4=, $1, $pop6
	br_if   	0, $pop4        # 0: up to label1
# BB#3:                                 # %for.end
	end_loop                        # label2:
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
.LBB1_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
