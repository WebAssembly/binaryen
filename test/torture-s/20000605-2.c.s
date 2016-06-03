	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000605-2.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block
	block
	i32.load	$push9=, 0($0)
	tee_local	$push8=, $2=, $pop9
	i32.load	$push0=, 0($1)
	i32.ge_s	$push1=, $pop8, $pop0
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %for.body.preheader
	i32.const	$3=, 0
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop                            # label2:
	i32.const	$push10=, 5
	i32.ge_s	$push2=, $3, $pop10
	br_if   	3, $pop2        # 3: down to label0
# BB#3:                                 # %for.inc
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.add 	$push3=, $2, $3
	i32.const	$push14=, 1
	i32.add 	$push4=, $pop3, $pop14
	i32.store	$drop=, 0($0), $pop4
	i32.const	$push13=, 1
	i32.add 	$push12=, $3, $pop13
	tee_local	$push11=, $3=, $pop12
	i32.add 	$push5=, $2, $pop11
	i32.load	$push6=, 0($1)
	i32.lt_s	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: up to label2
.LBB0_4:                                # %for.end
	end_loop                        # label3:
	end_block                       # label1:
	return
.LBB0_5:                                # %if.then
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
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push8=, $pop3, $pop4
	i32.store	$push10=, __stack_pointer($pop5), $pop8
	tee_local	$push9=, $1=, $pop10
	i32.const	$push0=, 0
	i32.store	$0=, 8($pop9), $pop0
	i32.const	$push1=, 1
	i32.store	$drop=, 0($1), $pop1
	i32.const	$push6=, 8
	i32.add 	$push7=, $1, $pop6
	call    	f1@FUNCTION, $pop7, $1
	call    	exit@FUNCTION, $0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
