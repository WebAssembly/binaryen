	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr53084.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 111
	block
	i32.load8_u	$push0=, 0($0)
	i32.ne  	$push1=, $pop0, $1
	br_if   	$pop1, 0        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.load8_u	$push2=, 1($0)
	i32.ne  	$push3=, $pop2, $1
	br_if   	$pop3, 0        # 0: down to label0
# BB#2:                                 # %lor.lhs.false6
	i32.load8_u	$push4=, 2($0)
	br_if   	$pop4, 0        # 0: down to label0
# BB#3:                                 # %if.end
	return
.LBB0_4:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, .L.str+1
	call    	bar@FUNCTION, $pop0
	i32.const	$push1=, 0
	return  	$pop1
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"foo"
	.size	.L.str, 4


	.ident	"clang version 3.9.0 "
