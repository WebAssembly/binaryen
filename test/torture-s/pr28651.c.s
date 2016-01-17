	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr28651.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2147483643
	i32.gt_s	$push1=, $0, $pop0
	return  	$pop1
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, 2147483647
	i32.call	$push1=, foo@FUNCTION, $pop0
	i32.const	$push3=, 0
	i32.eq  	$push4=, $pop1, $pop3
	br_if   	$pop4, 0        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push2=, 0
	return  	$pop2
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
