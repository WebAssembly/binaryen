	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20001027-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push0=, 1
	i32.store	x($pop8), $pop0
	i32.const	$push7=, 0
	i32.load	$push1=, p($pop7)
	i32.const	$push2=, 2
	i32.store	0($pop1), $pop2
	block   	
	i32.const	$push6=, 0
	i32.load	$push3=, x($pop6)
	i32.const	$push5=, 2
	i32.ne  	$push4=, $pop3, $pop5
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	x                       # @x
	.type	x,@object
	.section	.bss.x,"aw",@nobits
	.globl	x
	.p2align	2
x:
	.int32	0                       # 0x0
	.size	x, 4

	.hidden	p                       # @p
	.type	p,@object
	.section	.data.p,"aw",@progbits
	.globl	p
	.p2align	2
p:
	.int32	x
	.size	p, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
