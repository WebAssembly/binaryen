	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20060930-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block   	.LBB0_2
	i32.const	$push0=, 1
	i32.ne  	$push1=, $1, $pop0
	br_if   	$pop1, .LBB0_2
# BB#1:                                 # %if.end
	return  	$1
.LBB0_2:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32
	.local  	i32, i32
# BB#0:                                 # %entry
	block   	.LBB1_3
	i32.const	$push2=, 1
	i32.lt_s	$push3=, $1, $pop2
	br_if   	$pop3, .LBB1_3
# BB#1:                                 # %for.body.lr.ph
	i32.const	$3=, 0
	i32.gt_s	$push0=, $0, $3
	i32.sub 	$push1=, $3, $0
	i32.select	$2=, $pop0, $pop1, $0
	i32.const	$0=, -1
	i32.gt_s	$push4=, $2, $0
	i32.sub 	$push5=, $3, $2
	i32.select	$3=, $pop4, $3, $pop5
.LBB1_2:                                # %for.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	.LBB1_3
	i32.call	$discard=, bar@FUNCTION, $1, $3
	i32.add 	$1=, $1, $0
	br_if   	$1, .LBB1_2
.LBB1_3:                                # %for.end
	return
.Lfunc_end1:
	.size	foo, .Lfunc_end1-foo

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$0=, 1
	call    	foo@FUNCTION, $0, $0
	i32.const	$push0=, 0
	return  	$pop0
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
