	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/960302-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$0=, a($pop0)
	i32.const	$push6=, 1
	i32.const	$push8=, -1
	i32.const	$push1=, 31
	i32.shr_u	$push2=, $0, $pop1
	i32.add 	$push3=, $0, $pop2
	i32.const	$push4=, -2
	i32.and 	$push5=, $pop3, $pop4
	i32.sub 	$push14=, $0, $pop5
	tee_local	$push13=, $0=, $pop14
	i32.const	$push12=, 1
	i32.eq  	$push7=, $pop13, $pop12
	i32.select	$push9=, $pop6, $pop8, $pop7
	i32.const	$push11=, 0
	i32.select	$push10=, $pop9, $pop11, $0
	return  	$pop10
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.load	$0=, a($pop8)
	block
	i32.const	$push0=, 31
	i32.shr_u	$push1=, $0, $pop0
	i32.add 	$push2=, $0, $pop1
	i32.const	$push3=, -2
	i32.and 	$push4=, $pop2, $pop3
	i32.sub 	$push5=, $0, $pop4
	i32.const	$push6=, 1
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	2
a:
	.int32	1                       # 0x1
	.size	a, 4


	.ident	"clang version 3.9.0 "
