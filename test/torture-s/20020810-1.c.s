	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020810-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.local  	i64
# BB#0:                                 # %entry
	block
	i32.load	$push0=, 0($0)
	i32.const	$push1=, 0
	i64.load	$push10=, R($pop1)
	tee_local	$push9=, $1=, $pop10
	i32.wrap/i64	$push2=, $pop9
	i32.ne  	$push3=, $pop0, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push7=, 4($0)
	i64.const	$push4=, 32
	i64.shr_u	$push5=, $1, $pop4
	i32.wrap/i64	$push6=, $pop5
	i32.ne  	$push8=, $pop7, $pop6
	br_if   	0, $pop8        # 0: down to label0
# BB#2:                                 # %if.end
	return
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.g,"ax",@progbits
	.hidden	g
	.globl	g
	.type	g,@function
g:                                      # @g
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i64.load	$push1=, R($pop0)
	i64.store	$discard=, 0($0):p2align=2, $pop1
	return
	.endfunc
.Lfunc_end1:
	.size	g, .Lfunc_end1-g

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 0
	br_if   	0, $pop0        # 0: down to label1
# BB#1:                                 # %lor.lhs.false.i
	i32.const	$push1=, 1
	i32.const	$push3=, 0
	i32.eq  	$push4=, $pop1, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#2:                                 # %if.end
	i32.const	$push2=, 0
	return  	$pop2
.LBB2_3:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.hidden	R                       # @R
	.type	R,@object
	.section	.data.R,"aw",@progbits
	.globl	R
	.p2align	3
R:
	.int32	100                     # 0x64
	.int32	200                     # 0xc8
	.size	R, 8


	.ident	"clang version 3.9.0 "
