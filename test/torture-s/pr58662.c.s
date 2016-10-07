	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58662.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push18=, 0
	i32.const	$push17=, 0
	i32.load	$push0=, c($pop17)
	i32.const	$push16=, 0
	i32.ne  	$push1=, $pop0, $pop16
	i32.const	$push15=, 0
	i32.load	$push2=, a($pop15)
	i32.eqz 	$push3=, $pop2
	i32.const	$push4=, -30000
	i32.div_s	$push14=, $pop3, $pop4
	tee_local	$push13=, $0=, $pop14
	i32.const	$push5=, 14
	i32.rem_s	$push6=, $pop13, $pop5
	i32.const	$push12=, 0
	i32.ne  	$push7=, $pop6, $pop12
	i32.and 	$push8=, $pop1, $pop7
	i32.store	b($pop18), $pop8
	i32.const	$push11=, 0
	i32.store	d($pop11), $0
	block   	
	i32.const	$push10=, 0
	i32.load	$push9=, b($pop10)
	br_if   	0, $pop9        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push19=, 0
	return  	$pop19
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.int32	0                       # 0x0
	.size	a, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

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
