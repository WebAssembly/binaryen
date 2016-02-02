	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/nestfunc-4.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.then
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push1=, level($pop10)
	tee_local	$push9=, $0=, $pop1
	i32.const	$push2=, 499
	i32.gt_s	$push3=, $pop9, $pop2
	i32.const	$push8=, 499
	i32.select	$push4=, $pop3, $0, $pop8
	i32.const	$push5=, 1
	i32.add 	$push6=, $pop4, $pop5
	i32.store	$discard=, level($pop0), $pop6
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push10=, 0
	i32.load	$push1=, level($pop10)
	tee_local	$push9=, $0=, $pop1
	i32.const	$push2=, 499
	i32.gt_s	$push3=, $pop9, $pop2
	i32.const	$push8=, 499
	i32.select	$push4=, $pop3, $0, $pop8
	i32.const	$push5=, 1
	i32.add 	$push6=, $pop4, $pop5
	i32.store	$discard=, level($pop0), $pop6
	i32.const	$push7=, -42
	return  	$pop7
	.endfunc
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, -42
	block
	i32.const	$push1=, 0
	i32.load	$push0=, level($pop1)
	tee_local	$push5=, $1=, $pop0
	i32.const	$push2=, 499
	i32.gt_s	$push3=, $pop5, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %cond.false
	i32.call	$0=, foo@FUNCTION
.LBB2_2:                                # %cond.end
	end_block                       # label0:
	i32.sub 	$push4=, $0, $1
	return  	$pop4
	.endfunc
.Lfunc_end2:
	.size	bar, .Lfunc_end2-bar

	.hidden	level                   # @level
	.type	level,@object
	.section	.bss.level,"aw",@nobits
	.globl	level
	.p2align	2
level:
	.int32	0                       # 0x0
	.size	level, 4


	.ident	"clang version 3.9.0 "
