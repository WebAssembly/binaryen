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
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$3=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$3=, 0($1), $3
	block
	i32.const	$push7=, 0
	i32.load	$push4=, A($pop7)
	i32.const	$push1=, 1
	i32.or  	$push2=, $3, $pop1
	i32.const	$push6=, 0
	i32.load	$push0=, A($pop6)
	i32.store	$push3=, 0($pop2):p2align=0, $pop0
	i32.ne  	$push5=, $pop4, $pop3
	br_if   	0, $pop5        # 0: down to label1
# BB#1:                                 # %foo.exit
	i32.const	$push8=, 0
	i32.const	$2=, 16
	i32.add 	$3=, $3, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	return  	$pop8
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
