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
	i32.load	$2=, 0($0)
	i32.const	$4=, 0
	block
	i32.load	$push0=, 0($1)
	i32.ge_s	$push1=, $2, $pop0
	br_if   	$pop1, 0        # 0: down to label0
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label1:
	i32.const	$push2=, 5
	i32.ge_s	$push3=, $4, $pop2
	br_if   	$pop3, 1        # 1: down to label2
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.const	$3=, 1
	i32.add 	$push4=, $2, $4
	i32.add 	$push5=, $pop4, $3
	i32.store	$discard=, 0($0), $pop5
	i32.add 	$3=, $4, $3
	copy_local	$4=, $3
	i32.add 	$push7=, $2, $3
	i32.load	$push6=, 0($1)
	i32.lt_s	$push8=, $pop7, $pop6
	br_if   	$pop8, 0        # 0: up to label1
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
