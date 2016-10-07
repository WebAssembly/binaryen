	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr21173.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i32.const	$push10=, 0
	i32.load	$push2=, a($pop10)
	i32.const	$push0=, q
	i32.sub 	$push9=, $0, $pop0
	tee_local	$push8=, $0=, $pop9
	i32.add 	$push3=, $pop2, $pop8
	i32.store	a($pop1), $pop3
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.load	$push4=, a+4($pop6)
	i32.add 	$push5=, $pop4, $0
	i32.store	a+4($pop7), $pop5
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push4=, 0
	i32.load	$push1=, a($pop4)
	i32.const	$push3=, 0
	i32.load	$push0=, a+4($pop3)
	i32.or  	$push2=, $pop1, $pop0
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %for.cond.1
	i32.const	$push5=, 0
	return  	$pop5
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	q                       # @q
	.type	q,@object
	.section	.bss.q,"aw",@nobits
	.globl	q
q:
	.int8	0                       # 0x0
	.size	q, 1

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.skip	8
	.size	a, 8


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
