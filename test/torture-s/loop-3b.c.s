	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-3b.c"
	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push4=, 0
	i32.load	$push1=, n($pop4)
	i32.const	$push2=, 1
	i32.add 	$push3=, $pop1, $pop2
	i32.store	n($pop0), $pop3
	copy_local	$push5=, $1
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end0:
	.size	g, .Lfunc_end0-g

	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.const	$push16=, 0
	i32.load	$push9=, n($pop16)
	i32.const	$push0=, 268435455
	i32.const	$push15=, 268435455
	i32.lt_s	$push1=, $0, $pop15
	i32.select	$push2=, $0, $pop0, $pop1
	i32.const	$push3=, -1
	i32.xor 	$push4=, $pop2, $pop3
	i32.add 	$push5=, $0, $pop4
	i32.const	$push14=, 268435455
	i32.add 	$push6=, $pop5, $pop14
	i32.const	$push13=, 268435455
	i32.div_u	$push7=, $pop6, $pop13
	i32.add 	$push10=, $pop9, $pop7
	i32.const	$push11=, 1
	i32.add 	$push12=, $pop10, $pop11
	i32.store	n($pop8), $pop12
	copy_local	$push17=, $0
                                        # fallthrough-return: $pop17
	.endfunc
.Lfunc_end1:
	.size	f, .Lfunc_end1-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i32.load	$push3=, n($pop4)
	tee_local	$push2=, $0=, $pop3
	i32.const	$push0=, 4
	i32.add 	$push1=, $pop2, $pop0
	i32.store	n($pop5), $pop1
	block   	
	br_if   	0, $0           # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	n                       # @n
	.type	n,@object
	.section	.bss.n,"aw",@nobits
	.globl	n
	.p2align	2
n:
	.int32	0                       # 0x0
	.size	n, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
