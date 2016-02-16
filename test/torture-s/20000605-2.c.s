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
	block
	i32.load	$push11=, 0($0)
	tee_local	$push10=, $4=, $pop11
	i32.load	$push0=, 0($1)
	i32.ge_s	$push1=, $pop10, $pop0
	br_if   	0, $pop1        # 0: down to label1
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push2=, 5
	i32.ge_s	$push3=, $3, $pop2
	br_if   	3, $pop3        # 3: down to label0
# BB#2:                                 # %for.inc
                                        #   in Loop: Header=BB0_1 Depth=1
	i32.add 	$push5=, $4, $3
	i32.const	$push4=, 1
	i32.add 	$push6=, $pop5, $pop4
	i32.store	$discard=, 0($0), $pop6
	i32.const	$push12=, 1
	i32.add 	$2=, $3, $pop12
	copy_local	$3=, $2
	i32.add 	$push8=, $4, $2
	i32.load	$push7=, 0($1)
	i32.lt_s	$push9=, $pop8, $pop7
	br_if   	0, $pop9        # 0: up to label2
.LBB0_3:                                # %for.end
	end_loop                        # label3:
	end_block                       # label1:
	return
.LBB0_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
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
