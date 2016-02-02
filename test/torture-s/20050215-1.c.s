	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20050215-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block
	block
	block
	i32.const	$push13=, v
	i32.const	$push0=, 4
	i32.and 	$push1=, $pop13, $pop0
	i32.const	$push18=, 0
	i32.eq  	$push19=, $pop1, $pop18
	br_if   	$pop19, 0       # 0: down to label2
# BB#1:                                 # %if.then
	i32.const	$push17=, v
	i32.const	$push10=, 7
	i32.and 	$push11=, $pop17, $pop10
	br_if   	$pop11, 1       # 1: down to label1
	br      	2               # 2: down to label0
.LBB0_2:                                # %lor.lhs.false
	end_block                       # label2:
	i32.const	$push16=, v
	i32.const	$push6=, 1
	i32.and 	$push7=, $pop16, $pop6
	i32.const	$push4=, 0
	i32.eq  	$push8=, $pop7, $pop4
	i32.const	$push15=, v
	i32.const	$push2=, 7
	i32.and 	$push3=, $pop15, $pop2
	i32.const	$push14=, 0
	i32.ne  	$push5=, $pop3, $pop14
	i32.or  	$push9=, $pop8, $pop5
	i32.const	$push20=, 0
	i32.eq  	$push21=, $pop9, $pop20
	br_if   	$pop21, 1       # 1: down to label0
.LBB0_3:                                # %if.end3
	end_block                       # label1:
	i32.const	$push12=, 0
	return  	$pop12
.LBB0_4:                                # %if.then2
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	v                       # @v
	.type	v,@object
	.section	.bss.v,"aw",@nobits
	.globl	v
v:
	.skip	8
	.size	v, 8


	.ident	"clang version 3.9.0 "
