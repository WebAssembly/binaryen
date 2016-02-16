	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020213-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, b($pop0)
	i32.const	$push2=, -1
	i32.add 	$0=, $pop1, $pop2
	i32.const	$push8=, 0
	i32.const	$push3=, 2241
	i32.const	$push7=, 2241
	i32.gt_s	$push6=, $0, $pop7
	tee_local	$push5=, $1=, $pop6
	i32.select	$push4=, $pop3, $0, $pop5
	i32.store	$discard=, a+4($pop8), $pop4
	block
	i32.const	$push9=, 0
	i32.eq  	$push10=, $1, $pop9
	br_if   	0, $pop10       # 0: down to label0
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
	return  	$pop0
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
	i32.const	$push2=, 3384
	i32.store	$discard=, b($pop1), $pop2
	i32.const	$push4=, 0
	i64.const	$push0=, 9626087063552
	i64.store	$discard=, a($pop4):p2align=2, $pop0
	i32.const	$push3=, 0
	return  	$pop3
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


	.ident	"clang version 3.9.0 "
