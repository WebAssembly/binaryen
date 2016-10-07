	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020911-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push1=, 0
	i32.load16_s	$push11=, c($pop1)
	tee_local	$push10=, $0=, $pop11
	i32.const	$push3=, -1
	i32.gt_s	$push4=, $pop10, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push2=, 65535
	i32.and 	$push0=, $0, $pop2
	i32.const	$push5=, -32768
	i32.add 	$push6=, $pop0, $pop5
	i32.const	$push7=, 32768
	i32.ge_s	$push8=, $pop6, $pop7
	br_if   	0, $pop8        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push9=, 0
	return  	$pop9
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.p2align	1
c:
	.int16	32768                   # 0x8000
	.size	c, 2


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
