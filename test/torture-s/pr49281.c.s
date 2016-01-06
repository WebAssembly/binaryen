	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr49281.c"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 4
	i32.or  	$push3=, $pop1, $pop2
	return  	$pop3
func_end0:
	.size	foo, func_end0-foo

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push2=, 3
	i32.or  	$push3=, $pop1, $pop2
	return  	$pop3
func_end1:
	.size	bar, func_end1-bar

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 43
	block   	BB2_8
	i32.call	$push0=, foo, $0
	i32.const	$push1=, 172
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	$pop2, BB2_8
# BB#1:                                 # %lor.lhs.false
	i32.const	$1=, 1
	i32.call	$push3=, foo, $1
	i32.const	$push4=, 4
	i32.ne  	$push5=, $pop3, $pop4
	br_if   	$pop5, BB2_8
# BB#2:                                 # %lor.lhs.false3
	i32.const	$2=, 2
	i32.call	$push6=, foo, $2
	i32.const	$push7=, 12
	i32.ne  	$push8=, $pop6, $pop7
	br_if   	$pop8, BB2_8
# BB#3:                                 # %if.end
	block   	BB2_7
	i32.call	$push9=, bar, $0
	i32.const	$push10=, 175
	i32.ne  	$push11=, $pop9, $pop10
	br_if   	$pop11, BB2_7
# BB#4:                                 # %lor.lhs.false8
	i32.call	$push12=, bar, $1
	i32.const	$push13=, 7
	i32.ne  	$push14=, $pop12, $pop13
	br_if   	$pop14, BB2_7
# BB#5:                                 # %lor.lhs.false11
	i32.call	$push15=, bar, $2
	i32.const	$push16=, 11
	i32.ne  	$push17=, $pop15, $pop16
	br_if   	$pop17, BB2_7
# BB#6:                                 # %if.end15
	i32.const	$push18=, 0
	return  	$pop18
BB2_7:                                  # %if.then14
	call    	abort
	unreachable
BB2_8:                                  # %if.then
	call    	abort
	unreachable
func_end2:
	.size	main, func_end2-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
