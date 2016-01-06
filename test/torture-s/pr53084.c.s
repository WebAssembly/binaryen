	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr53084.c"
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 111
	block   	BB0_4
	i32.load8_u	$push0=, 0($0)
	i32.ne  	$push1=, $pop0, $1
	br_if   	$pop1, BB0_4
# BB#1:                                 # %lor.lhs.false
	i32.load8_u	$push2=, 1($0)
	i32.ne  	$push3=, $pop2, $1
	br_if   	$pop3, BB0_4
# BB#2:                                 # %lor.lhs.false6
	i32.load8_u	$push4=, 2($0)
	br_if   	$pop4, BB0_4
# BB#3:                                 # %if.end
	return
BB0_4:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	bar, func_end0-bar

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, .str+1
	call    	bar, $pop0
	i32.const	$push1=, 0
	return  	$pop1
func_end1:
	.size	main, func_end1-main

	.type	.str,@object            # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.str:
	.asciz	"foo"
	.size	.str, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
