	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr40057.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i32.wrap/i64	$push0=, $0
	i32.const	$push1=, 31
	i32.shr_s	$push2=, $pop0, $pop1
	return  	$pop2
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i64
	.result 	i32
# BB#0:                                 # %entry
	i32.wrap/i64	$push0=, $0
	i32.const	$push1=, 31
	i32.shr_s	$push2=, $pop0, $pop1
	return  	$pop2
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

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
	block
	i64.const	$push0=, 6042589866
	i32.call	$push1=, foo@FUNCTION, $pop0
	br_if   	0, $pop1        # 0: down to label3
# BB#1:                                 # %if.end
	i64.const	$push2=, 6579460778
	i32.call	$push3=, foo@FUNCTION, $pop2
	i32.const	$push9=, 0
	i32.eq  	$push10=, $pop3, $pop9
	br_if   	1, $pop10       # 1: down to label2
# BB#2:                                 # %if.end4
	i64.const	$push4=, 6042589866
	i32.call	$push5=, bar@FUNCTION, $pop4
	br_if   	2, $pop5        # 2: down to label1
# BB#3:                                 # %if.end8
	i64.const	$push6=, 6579460778
	i32.call	$push7=, bar@FUNCTION, $pop6
	i32.const	$push11=, 0
	i32.eq  	$push12=, $pop7, $pop11
	br_if   	3, $pop12       # 3: down to label0
# BB#4:                                 # %if.end12
	i32.const	$push8=, 0
	return  	$pop8
.LBB2_5:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
.LBB2_6:                                # %if.then3
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB2_7:                                # %if.then7
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
.LBB2_8:                                # %if.then11
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
