	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20081103-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.load	$push2=, 1($0):p2align=0
	i32.const	$push0=, 0
	i32.load	$push1=, A($pop0)
	i32.ne  	$push3=, $pop2, $pop1
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
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
	block
	i32.const	$push7=, 0
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push11=, $pop5, $pop6
	i32.store	$push15=, __stack_pointer($pop7), $pop11
	tee_local	$push14=, $0=, $pop15
	i32.const	$push13=, 0
	i32.load	$push1=, A($pop13)
	i32.store	$push0=, 1($pop14):p2align=0, $pop1
	i32.const	$push12=, 0
	i32.load	$push2=, A($pop12)
	i32.ne  	$push3=, $pop0, $pop2
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %foo.exit
	i32.const	$push10=, 0
	i32.const	$push8=, 16
	i32.add 	$push9=, $0, $pop8
	i32.store	$drop=, __stack_pointer($pop10), $pop9
	i32.const	$push16=, 0
	return  	$pop16
.LBB1_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	A                       # @A
	.type	A,@object
	.section	.data.A,"aw",@progbits
	.globl	A
	.p2align	2
A:
	.ascii	"1234"
	.size	A, 4


	.ident	"clang version 3.9.0 "
	.functype	memcmp, i32, i32, i32, i32
	.functype	abort, void
