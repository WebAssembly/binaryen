	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr61306-3.c"
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
	i32.load16_s	$push10=, a($pop11)
	tee_local	$push9=, $0=, $pop10
	i32.store8	c($pop12), $pop9
	i32.const	$push8=, 0
	i32.const	$push0=, 24
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push7=, 24
	i32.shr_s	$push2=, $pop1, $pop7
	i32.or  	$push6=, $0, $pop2
	tee_local	$push5=, $0=, $pop6
	i32.store	b($pop8), $pop5
	block   	
	i32.const	$push3=, -1
	i32.ne  	$push4=, $0, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push13=, 0
	return  	$pop13
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	1
a:
	.int16	65535                   # 0xffff
	.size	a, 2

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
c:
	.int8	0                       # 0x0
	.size	c, 1

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
