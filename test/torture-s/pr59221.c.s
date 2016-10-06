	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59221.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push10=, 0
	i32.load	$push0=, b($pop10)
	i32.eqz 	$push21=, $pop0
	br_if   	0, $pop21       # 0: down to label0
# BB#1:                                 # %for.inc.preheader
	i32.const	$push12=, 0
	i32.const	$push11=, 0
	i32.store	b($pop12), $pop11
.LBB0_2:                                # %for.end
	end_block                       # label0:
	i32.const	$push20=, 0
	i32.const	$push19=, 0
	i32.load	$push18=, a($pop19)
	tee_local	$push17=, $0=, $pop18
	i32.const	$push3=, 16
	i32.shl 	$push4=, $pop17, $pop3
	i32.const	$push16=, 16
	i32.shr_s	$push5=, $pop4, $pop16
	i32.const	$push6=, -32768
	i32.const	$push1=, 65535
	i32.and 	$push2=, $0, $pop1
	i32.select	$push15=, $pop5, $pop6, $pop2
	tee_local	$push14=, $0=, $pop15
	i32.store16	e($pop20), $pop14
	i32.const	$push13=, 0
	i32.store	d($pop13), $0
	block   	
	i32.const	$push7=, 1
	i32.ne  	$push8=, $0, $pop7
	br_if   	0, $pop8        # 0: down to label1
# BB#3:                                 # %if.end
	i32.const	$push9=, 0
	return  	$pop9
.LBB0_4:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	2
a:
	.int32	1                       # 0x1
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	1
e:
	.int16	0                       # 0x0
	.size	e, 2

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.int32	0                       # 0x0
	.size	d, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
