	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr59747.c"
	.section	.text.fn1,"ax",@progbits
	.hidden	fn1
	.globl	fn1
	.type	fn1,@function
fn1:                                    # @fn1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, a
	i32.add 	$push3=, $pop1, $pop2
	i32.load	$push4=, 0($pop3)
                                        # fallthrough-return: $pop4
	.endfunc
.Lfunc_end0:
	.size	fn1, .Lfunc_end0-fn1

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push16=, 0
	i32.const	$push0=, 1
	i32.store	a($pop16), $pop0
	i32.const	$push15=, 0
	i32.load16_u	$0=, e($pop15)
	block   	
	i32.const	$push14=, 0
	i32.load	$push1=, c($pop14)
	i32.eqz 	$push22=, $pop1
	br_if   	0, $pop22       # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push19=, 0
	i32.const	$push2=, -1
	i32.add 	$push18=, $0, $pop2
	tee_local	$push17=, $0=, $pop18
	i32.store16	e($pop19), $pop17
.LBB1_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push21=, 0
	i32.const	$push3=, 16
	i32.shl 	$push4=, $0, $pop3
	i32.const	$push20=, 16
	i32.shr_s	$push5=, $pop4, $pop20
	i32.store	d($pop21), $pop5
	block   	
	i64.extend_u/i32	$push6=, $0
	i64.const	$push7=, 48
	i64.shl 	$push8=, $pop6, $pop7
	i64.const	$push9=, 63
	i64.shr_u	$push10=, $pop8, $pop9
	i32.wrap/i64	$push11=, $pop10
	i32.call	$push12=, fn1@FUNCTION, $pop11
	br_if   	0, $pop12       # 0: down to label1
# BB#3:                                 # %if.end5
	i32.const	$push13=, 0
	call    	exit@FUNCTION, $pop13
	unreachable
.LBB1_4:                                # %if.then4
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.p2align	2
c:
	.int32	1                       # 0x1
	.size	c, 4

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	4
a:
	.skip	24
	.size	a, 24

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
	.functype	exit, void, i32
