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
	block   	.LBB0_7
	block   	.LBB0_6
	i32.const	$push0=, 2
	i32.eq  	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_6
# BB#1:                                 # %entry
	block   	.LBB0_5
	i32.const	$push2=, 1
	i32.eq  	$push3=, $0, $pop2
	br_if   	$pop3, .LBB0_5
# BB#2:                                 # %entry
	block   	.LBB0_4
	br_if   	$0, .LBB0_4
# BB#3:                                 # %sw.bb
	i32.load	$0=, 0($1)
	br      	.LBB0_7
.LBB0_4:                                # %sw.epilog
	call    	abort
	unreachable
.LBB0_5:                                # %sw.bb1
	i32.load8_s	$0=, 0($1)
	br      	.LBB0_7
.LBB0_6:                                # %sw.bb2
	i32.load16_s	$0=, 0($1)
.LBB0_7:                                # %return
	return  	$0
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
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
