	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/980602-2.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push12=, 0
	i32.const	$push11=, 0
	i32.load	$push10=, t($pop11)
	tee_local	$push9=, $0=, $pop10
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop9, $pop2
	i32.const	$push4=, 1073741823
	i32.and 	$push5=, $pop3, $pop4
	i32.const	$push0=, -1073741824
	i32.and 	$push1=, $0, $pop0
	i32.or  	$push6=, $pop5, $pop1
	i32.store	t($pop12), $pop6
	block   	
	i32.const	$push8=, 1073741823
	i32.and 	$push7=, $0, $pop8
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push13=, 0
	call    	exit@FUNCTION, $pop13
	unreachable
.LBB0_2:                                # %if.else
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	t                       # @t
	.type	t,@object
	.section	.bss.t,"aw",@nobits
	.globl	t
	.p2align	2
t:
	.skip	4
	.size	t, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
	.functype	abort, void
