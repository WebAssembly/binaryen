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
	i32.load	$push1=, 0($0)
	i32.const	$push2=, 0
	i64.load	$push0=, R($pop2)
	tee_local	$push10=, $1=, $pop0
	i32.wrap/i64	$push3=, $pop10
	i32.ne  	$push4=, $pop1, $pop3
	br_if   	$pop4, 0        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load	$push8=, 4($0)
	i64.const	$push5=, 32
	i64.shr_u	$push6=, $1, $pop5
	i32.wrap/i64	$push7=, $pop6
	i32.ne  	$push9=, $pop8, $pop7
	br_if   	$pop9, 0        # 0: down to label0
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
	br_if   	$pop0, 0        # 0: down to label1
# BB#1:                                 # %lor.lhs.false.i
	i32.const	$push1=, 1
	i32.const	$push3=, 0
	i32.eq  	$push4=, $pop1, $pop3
	br_if   	$pop4, 0        # 0: down to label1
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
