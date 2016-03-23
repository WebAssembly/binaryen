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
	i32.const	$push7=, __stack_pointer
	i32.load	$push8=, 0($pop7)
	i32.const	$push9=, 16
	i32.sub 	$0=, $pop8, $pop9
	i32.const	$push10=, __stack_pointer
	i32.store	$discard=, 0($pop10), $0
	block
	i32.const	$push5=, 0
	i32.load	$push2=, A($pop5)
	i32.const	$push4=, 0
	i32.load	$push0=, A($pop4)
	i32.store	$push1=, 1($0):p2align=0, $pop0
	i32.ne  	$push3=, $pop2, $pop1
	br_if   	0, $pop3        # 0: down to label1
# BB#1:                                 # %foo.exit
	i32.const	$push6=, 0
	i32.const	$push13=, __stack_pointer
	i32.const	$push11=, 16
	i32.add 	$push12=, $0, $pop11
	i32.store	$discard=, 0($pop13), $pop12
	return  	$pop6
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
