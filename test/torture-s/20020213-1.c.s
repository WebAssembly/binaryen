	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020213-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push3=, 2241
	i32.const	$push10=, 0
	i32.load	$push1=, b($pop10)
	i32.const	$push2=, -1
	i32.add 	$push9=, $pop1, $pop2
	tee_local	$push8=, $0=, $pop9
	i32.const	$push7=, 2241
	i32.gt_s	$push6=, $0, $pop7
	tee_local	$push5=, $0=, $pop6
	i32.select	$push4=, $pop3, $pop8, $pop5
	i32.store	a+4($pop0), $pop4
	block   	
	i32.eqz 	$push11=, $0
	br_if   	0, $pop11       # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	f32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2241
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %foo.exit
	i32.const	$push1=, 0
	i32.const	$push0=, 3384
	i32.store	b($pop1), $pop0
	i32.const	$push4=, 0
	i64.const	$push2=, 9626087063552
	i64.store	a($pop4):p2align=2, $pop2
	i32.const	$push3=, 0
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	2
a:
	.skip	8
	.size	a, 8

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
