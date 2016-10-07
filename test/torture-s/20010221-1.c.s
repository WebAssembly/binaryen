	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20010221-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	block   	
	i32.const	$push8=, 0
	i32.load	$push7=, n($pop8)
	tee_local	$push6=, $0=, $pop7
	i32.const	$push5=, 1
	i32.lt_s	$push0=, $pop6, $pop5
	br_if   	0, $pop0        # 0: down to label0
# BB#1:                                 # %for.body.preheader
	i32.const	$1=, 45
.LBB0_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label1:
	i32.select	$1=, $2, $1, $2
	i32.const	$push11=, 1
	i32.add 	$push10=, $2, $pop11
	tee_local	$push9=, $2=, $pop10
	i32.lt_s	$push1=, $pop9, $0
	br_if   	0, $pop1        # 0: up to label1
# BB#3:                                 # %for.end
	end_loop
	i32.const	$push2=, 1
	i32.ne  	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#4:                                 # %if.end5
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
.LBB0_5:                                # %if.then4
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	n                       # @n
	.type	n,@object
	.section	.data.n,"aw",@progbits
	.globl	n
	.p2align	2
n:
	.int32	2                       # 0x2
	.size	n, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
