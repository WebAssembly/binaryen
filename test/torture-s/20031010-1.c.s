	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20031010-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32, i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push2=, 0
	i32.eq  	$push3=, $2, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %if.then
	i32.sub 	$2=, $0, $1
	block
	i32.const	$push4=, 0
	i32.eq  	$push5=, $3, $pop4
	br_if   	$pop5, 0        # 0: down to label1
# BB#2:                                 # %if.then4
	i32.select	$push1=, $4, $1, $0
	i32.select	$push0=, $4, $0, $1
	i32.sub 	$2=, $pop1, $pop0
.LBB0_3:                                # %if.end8
	end_block                       # label1:
	return  	$2
.LBB0_4:                                # %if.end9
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
# BB#0:                                 # %entry
	block
	i32.const	$push2=, 2
	i32.const	$push1=, 3
	i32.const	$push0=, 1
	i32.const	$push6=, 1
	i32.const	$push5=, 1
	i32.call	$push3=, foo@FUNCTION, $pop2, $pop1, $pop0, $pop6, $pop5
	i32.const	$push7=, 0
	i32.eq  	$push8=, $pop3, $pop7
	br_if   	$pop8, 0        # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$push4=, 0
	return  	$pop4
.LBB1_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
