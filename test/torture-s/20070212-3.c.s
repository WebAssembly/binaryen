	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20070212-3.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4
	i32.add 	$push1=, $0, $pop0
	i32.select	$2=, $2, $0, $pop1
	i32.load	$4=, 0($2)
	block   	.LBB0_2
	i32.const	$push2=, 1
	i32.store	$discard=, 0($0), $pop2
	i32.const	$push4=, 0
	i32.eq  	$push5=, $3, $pop4
	br_if   	$pop5, .LBB0_2
# BB#1:                                 # %if.then3
	i32.load	$1=, 0($2)
.LBB0_2:                                # %if.end5
	i32.add 	$push3=, $1, $4
	return  	$pop3
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
