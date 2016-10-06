	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr58640-2.c"
	.section	.text.fn1,"ax",@progbits
	.hidden	fn1
	.globl	fn1
	.type	fn1,@function
fn1:                                    # @fn1
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	i32.const	$push26=, 0
	i32.load	$push25=, a+36($pop26)
	tee_local	$push24=, $0=, $pop25
	i32.store	a($pop0), $pop24
	i32.const	$push23=, 0
	i32.const	$push1=, 1
	i32.store	a+48($pop23), $pop1
	i32.const	$push22=, 0
	i32.const	$push21=, 1
	i32.store	c($pop22), $pop21
	i32.const	$push20=, 0
	i32.store	a+4($pop20), $0
	i32.const	$push19=, 0
	i32.const	$push18=, 1
	i32.store	a($pop19), $pop18
	i32.const	$push17=, 0
	i32.const	$push16=, 1
	i32.store	c($pop17), $pop16
	i32.const	$push15=, 0
	i32.const	$push14=, 1
	i32.store	a+4($pop15), $pop14
	i32.const	$push13=, 0
	i32.const	$push12=, 1
	i32.store	c($pop13), $pop12
	i32.const	$push11=, 0
	i32.const	$push10=, 1
	i32.store	c($pop11), $pop10
	i32.const	$push9=, 0
	i32.const	$push8=, 0
	i32.load	$push7=, a+60($pop8)
	tee_local	$push6=, $0=, $pop7
	i32.store	a($pop9), $pop6
	i32.const	$push5=, 0
	i32.store	a+4($pop5), $0
	i32.const	$push4=, 0
	i32.const	$push3=, 1
	i32.store	c($pop4), $pop3
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
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
	i32.const	$push8=, 0
	i32.const	$push0=, 1
	i32.store	a+48($pop8), $pop0
	i32.const	$push7=, 0
	i32.const	$push6=, 1
	i32.store	c($pop7), $pop6
	i32.const	$push5=, 0
	i32.const	$push4=, 0
	i32.load	$push3=, a+60($pop4)
	tee_local	$push2=, $0=, $pop3
	i32.store	a($pop5), $pop2
	i32.const	$push1=, 0
	i32.store	a+4($pop1), $0
	block   	
	br_if   	0, $0           # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push9=, 0
	return  	$pop9
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	4
a:
	.skip	80
	.size	a, 80

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
