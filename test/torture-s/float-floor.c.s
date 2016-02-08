	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/float-floor.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	f64
# BB#0:                                 # %entry
	block
	i32.const	$push1=, 0
	f64.load	$push2=, d($pop1)
	f64.floor	$push0=, $pop2
	tee_local	$push10=, $0=, $pop0
	i32.trunc_s/f64	$push3=, $pop10
	i32.const	$push9=, 1023
	i32.ne  	$push4=, $pop3, $pop9
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	f32.demote/f64	$push5=, $0
	i32.trunc_s/f32	$push6=, $pop5
	i32.const	$push11=, 1023
	i32.ne  	$push7=, $pop6, $pop11
	br_if   	0, $pop7        # 0: down to label0
# BB#2:                                 # %if.end
	i32.const	$push8=, 0
	return  	$pop8
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	d                       # @d
	.type	d,@object
	.section	.data.d,"aw",@progbits
	.globl	d
	.p2align	3
d:
	.int64	4652218414805286912     # double 1023.9999694824219
	.size	d, 8


	.ident	"clang version 3.9.0 "
