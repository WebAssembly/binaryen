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
	i32.const	$0=, 1
	block
	i32.const	$push1=, 2
	i32.const	$push0=, 3
	i32.call	$push2=, foo@FUNCTION, $pop1, $pop0, $0, $0, $0
	i32.const	$push4=, 0
	i32.eq  	$push5=, $pop2, $pop4
	br_if   	$pop5, 0        # 0: down to label2
# BB#1:                                 # %if.end
	i32.const	$push3=, 0
	return  	$pop3
.LBB1_2:                                # %if.then
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
