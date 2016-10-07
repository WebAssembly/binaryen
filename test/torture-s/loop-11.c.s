	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-11.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 199
	i32.const	$0=, a+792
.LBB0_1:                                # %for.body.i
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push9=, -1
	i32.add 	$push8=, $1, $pop9
	tee_local	$push7=, $1=, $pop8
	i32.store	0($0), $pop7
	i32.const	$push6=, -4
	i32.add 	$0=, $0, $pop6
	i32.const	$push5=, 0
	i32.gt_s	$push0=, $1, $pop5
	br_if   	0, $pop0        # 0: up to label0
# BB#2:                                 # %for.body.preheader
	end_loop
	i32.const	$1=, 0
	i32.const	$0=, a
.LBB0_3:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label2:
	i32.load	$push1=, 0($0)
	i32.ne  	$push2=, $1, $pop1
	br_if   	1, $pop2        # 1: down to label1
# BB#4:                                 # %for.cond
                                        #   in Loop: Header=BB0_3 Depth=1
	i32.const	$push14=, 4
	i32.add 	$0=, $0, $pop14
	i32.const	$push13=, 1
	i32.add 	$push12=, $1, $pop13
	tee_local	$push11=, $1=, $pop12
	i32.const	$push10=, 198
	i32.le_s	$push3=, $pop11, $pop10
	br_if   	0, $pop3        # 0: up to label2
# BB#5:                                 # %for.end
	end_loop
	i32.const	$push4=, 0
	return  	$pop4
.LBB0_6:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.type	a,@object               # @a
	.section	.bss.a,"aw",@nobits
	.p2align	4
a:
	.skip	796
	.size	a, 796


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
