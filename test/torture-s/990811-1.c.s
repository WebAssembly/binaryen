	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990811-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	block
	block
	block
	i32.const	$push0=, 2
	i32.eq  	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label3
# BB#1:                                 # %entry
	i32.const	$push2=, 1
	i32.eq  	$push3=, $0, $pop2
	br_if   	1, $pop3        # 1: down to label2
# BB#2:                                 # %entry
	br_if   	3, $0           # 3: down to label0
# BB#3:                                 # %sw.bb
	i32.load	$0=, 0($1)
	br      	2               # 2: down to label1
.LBB0_4:                                # %sw.bb2
	end_block                       # label3:
	i32.load16_s	$0=, 0($1)
	br      	1               # 1: down to label1
.LBB0_5:                                # %sw.bb1
	end_block                       # label2:
	i32.load8_s	$0=, 0($1)
.LBB0_6:                                # %return
	end_block                       # label1:
	return  	$0
.LBB0_7:                                # %sw.epilog
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
# BB#0:                                 # %if.end16
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
