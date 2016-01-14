	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20040309-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 16
	i32.const	$2=, 0
	block
	i32.shl 	$push0=, $0, $1
	i32.shr_s	$push1=, $pop0, $1
	i32.const	$push2=, -1
	i32.gt_s	$push3=, $pop1, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %cond.true
	i32.const	$push4=, 32768
	i32.add 	$push5=, $0, $pop4
	i32.const	$push6=, 65535
	i32.and 	$2=, $pop5, $pop6
.LBB0_2:                                # %cond.end
	end_block                       # label0:
	return  	$2
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
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
