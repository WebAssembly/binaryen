	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-8.c"
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
# BB#0:                                 # %entry
	block   	BB0_3
	br_if   	$0, BB0_3
# BB#1:                                 # %lor.lhs.false
	f64.load	$push0=, 0($1)
	f64.const	$push1=, 0x1p0
	f64.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, BB0_3
# BB#2:                                 # %if.end
	return
BB0_3:                                  # %if.then
	call    	abort
	unreachable
func_end0:
	.size	bar, func_end0-bar

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, f64, f64
# BB#0:                                 # %entry
	i32.const	$0=, 0
	f64.load	$2=, a($0)
	f64.const	$1=, 0x0p0
	block   	BB1_4
	f64.gt  	$push0=, $2, $1
	br_if   	$pop0, BB1_4
# BB#1:                                 # %for.cond
	f64.load	$2=, a+8($0)
	f64.le  	$push1=, $2, $1
	f64.ne  	$push2=, $2, $2
	i32.or  	$push3=, $pop1, $pop2
	i32.const	$push7=, 0
	i32.eq  	$push8=, $pop3, $pop7
	br_if   	$pop8, BB1_4
# BB#2:                                 # %for.cond.1
	f64.load	$2=, a+16($0)
	f64.gt  	$push4=, $2, $1
	br_if   	$pop4, BB1_4
# BB#3:                                 # %for.cond.2
	call    	abort
	unreachable
BB1_4:                                  # %e
	block   	BB1_6
	f64.const	$push5=, 0x1p0
	f64.eq  	$push6=, $2, $pop5
	br_if   	$pop6, BB1_6
# BB#5:                                 # %if.then.i
	call    	abort
	unreachable
BB1_6:                                  # %bar.exit4
	call    	exit, $0
	unreachable
func_end1:
	.size	main, func_end1-main

	.type	a,@object               # @a
	.data
	.globl	a
	.align	4
a:
	.int64	0                       # double 0
	.int64	4607182418800017408     # double 1
	.int64	4611686018427387904     # double 2
	.size	a, 24


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
