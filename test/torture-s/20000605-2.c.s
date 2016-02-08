	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000605-2.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	block
	i32.load	$push0=, 0($0)
	tee_local	$push11=, $4=, $pop0
	i32.load	$push1=, 0($1)
	i32.ge_s	$push2=, $pop11, $pop1
	br_if   	0, $pop2        # 0: down to label0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push3=, 5
	i32.ge_s	$push4=, $3, $pop3
	br_if   	1, $pop4        # 1: down to label2
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.add 	$push6=, $4, $3
	i32.const	$push5=, 1
	i32.add 	$push7=, $pop6, $pop5
	i32.store	$discard=, 0($0), $pop7
	i32.const	$push12=, 1
	i32.add 	$2=, $3, $pop12
	copy_local	$3=, $2
	i32.add 	$push9=, $4, $2
	i32.load	$push8=, 0($1)
	i32.lt_s	$push10=, $pop9, $pop8
	br_if   	0, $pop10       # 0: up to label1
	br      	2               # 2: down to label0
.LBB0_3:                                # %if.then
	end_loop                        # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %for.end
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %for.inc.i
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
