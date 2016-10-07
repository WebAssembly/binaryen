	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr43008.c"
	.section	.text.my_alloc,"ax",@progbits
	.hidden	my_alloc
	.globl	my_alloc
	.type	my_alloc,@function
my_alloc:                               # @my_alloc
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4
	i32.call	$push3=, __builtin_malloc@FUNCTION, $pop0
	tee_local	$push2=, $0=, $pop3
	i32.const	$push1=, i
	i32.store	0($pop2), $pop1
	copy_local	$push4=, $0
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	my_alloc, .Lfunc_end0-my_alloc

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4
	i32.call	$push12=, __builtin_malloc@FUNCTION, $pop0
	tee_local	$push11=, $0=, $pop12
	i32.const	$push1=, i
	i32.store	0($pop11), $pop1
	i32.const	$push10=, 4
	i32.call	$push2=, __builtin_malloc@FUNCTION, $pop10
	i32.const	$push9=, i
	i32.store	0($pop2), $pop9
	i32.load	$push8=, 0($0)
	tee_local	$push7=, $0=, $pop8
	i32.const	$push3=, 1
	i32.store	0($pop7), $pop3
	i32.const	$push6=, 0
	i32.const	$push5=, 0
	i32.store	i($pop6), $pop5
	block   	
	i32.load	$push4=, 0($0)
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push13=, 0
	return  	$pop13
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	__builtin_malloc, i32
	.functype	abort, void
