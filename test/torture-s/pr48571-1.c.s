	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr48571-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$1=, c($pop0)
	i32.const	$0=, 4
.LBB0_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push10=, c
	i32.add 	$push1=, $0, $pop10
	i32.const	$push9=, 1
	i32.shl 	$push8=, $1, $pop9
	tee_local	$push7=, $1=, $pop8
	i32.store	0($pop1), $pop7
	i32.const	$push6=, 4
	i32.add 	$push5=, $0, $pop6
	tee_local	$push4=, $0=, $pop5
	i32.const	$push3=, 2496
	i32.ne  	$push2=, $pop4, $pop3
	br_if   	0, $pop2        # 0: up to label0
# BB#2:                                 # %for.end
	end_loop
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, -2496
.LBB1_1:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.const	$push9=, c+2496
	i32.add 	$push0=, $0, $pop9
	i32.const	$push8=, 1
	i32.store	0($pop0), $pop8
	i32.const	$push7=, 4
	i32.add 	$push6=, $0, $pop7
	tee_local	$push5=, $0=, $pop6
	br_if   	0, $pop5        # 0: up to label1
# BB#2:                                 # %for.end
	end_loop
	call    	bar@FUNCTION
	i32.const	$2=, 0
	i32.const	$0=, c
	i32.const	$1=, 1
.LBB1_3:                                # %for.body3
                                        # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                # label3:
	i32.load	$push1=, 0($0)
	i32.ne  	$push2=, $pop1, $1
	br_if   	1, $pop2        # 1: down to label2
# BB#4:                                 # %if.end
                                        #   in Loop: Header=BB1_3 Depth=1
	i32.const	$push15=, 4
	i32.add 	$0=, $0, $pop15
	i32.const	$push14=, 1
	i32.shl 	$1=, $1, $pop14
	i32.const	$push13=, 1
	i32.add 	$push12=, $2, $pop13
	tee_local	$push11=, $2=, $pop12
	i32.const	$push10=, 624
	i32.lt_u	$push3=, $pop11, $pop10
	br_if   	0, $pop3        # 0: up to label3
# BB#5:                                 # %for.end8
	end_loop
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_6:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	4
c:
	.skip	2496
	.size	c, 2496


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
