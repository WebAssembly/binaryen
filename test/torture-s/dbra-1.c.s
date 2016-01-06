	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/dbra-1.c"
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	block   	BB0_10
	i32.const	$push11=, 0
	i32.eq  	$push12=, $0, $pop11
	br_if   	$pop12, BB0_10
# BB#1:                                 # %for.inc
	i32.const	$1=, 1
	i32.eq  	$push0=, $0, $1
	br_if   	$pop0, BB0_10
# BB#2:                                 # %for.inc.1
	i32.const	$1=, 2
	i32.eq  	$push1=, $0, $1
	br_if   	$pop1, BB0_10
# BB#3:                                 # %for.inc.2
	i32.const	$1=, 3
	i32.eq  	$push2=, $0, $1
	br_if   	$pop2, BB0_10
# BB#4:                                 # %for.inc.3
	i32.const	$1=, 4
	i32.eq  	$push3=, $0, $1
	br_if   	$pop3, BB0_10
# BB#5:                                 # %for.inc.4
	i32.const	$1=, 5
	i32.eq  	$push4=, $0, $1
	br_if   	$pop4, BB0_10
# BB#6:                                 # %for.inc.5
	i32.const	$1=, 6
	i32.eq  	$push5=, $0, $1
	br_if   	$pop5, BB0_10
# BB#7:                                 # %for.inc.6
	i32.const	$1=, 7
	i32.eq  	$push6=, $0, $1
	br_if   	$pop6, BB0_10
# BB#8:                                 # %for.inc.7
	i32.const	$1=, 8
	i32.eq  	$push7=, $0, $1
	br_if   	$pop7, BB0_10
# BB#9:                                 # %for.inc.8
	i32.const	$1=, 9
	i32.eq  	$push8=, $0, $1
	i32.const	$push9=, -1
	i32.select	$push10=, $pop8, $1, $pop9
	return  	$pop10
BB0_10:                                 # %cleanup
	return  	$1
func_end0:
	.size	f1, func_end0-f1

	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.eq  	$push1=, $0, $pop0
	return  	$pop1
func_end1:
	.size	f2, func_end1-f2

	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, 1
	i32.const	$2=, 0
	block   	BB2_10
	i32.eq  	$push0=, $0, $1
	br_if   	$pop0, BB2_10
# BB#1:                                 # %for.inc
	copy_local	$2=, $1
	i32.const	$1=, 2
	i32.eq  	$push1=, $0, $1
	br_if   	$pop1, BB2_10
# BB#2:                                 # %for.inc.1
	copy_local	$2=, $1
	i32.const	$1=, 3
	i32.eq  	$push2=, $0, $1
	br_if   	$pop2, BB2_10
# BB#3:                                 # %for.inc.2
	copy_local	$2=, $1
	i32.const	$1=, 4
	i32.eq  	$push3=, $0, $1
	br_if   	$pop3, BB2_10
# BB#4:                                 # %for.inc.3
	copy_local	$2=, $1
	i32.const	$1=, 5
	i32.eq  	$push4=, $0, $1
	br_if   	$pop4, BB2_10
# BB#5:                                 # %for.inc.4
	copy_local	$2=, $1
	i32.const	$1=, 6
	i32.eq  	$push5=, $0, $1
	br_if   	$pop5, BB2_10
# BB#6:                                 # %for.inc.5
	copy_local	$2=, $1
	i32.const	$1=, 7
	i32.eq  	$push6=, $0, $1
	br_if   	$pop6, BB2_10
# BB#7:                                 # %for.inc.6
	copy_local	$2=, $1
	i32.const	$1=, 8
	i32.eq  	$push7=, $0, $1
	br_if   	$pop7, BB2_10
# BB#8:                                 # %for.inc.7
	copy_local	$2=, $1
	i32.const	$1=, 9
	i32.eq  	$push8=, $0, $1
	br_if   	$pop8, BB2_10
# BB#9:                                 # %for.inc.8
	i32.const	$push9=, 10
	i32.eq  	$push10=, $0, $pop9
	i32.const	$push11=, -1
	i32.select	$push12=, $pop10, $1, $pop11
	return  	$pop12
BB2_10:                                 # %cleanup
	return  	$2
func_end2:
	.size	f3, func_end2-f3

	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 1
	i32.eq  	$push1=, $0, $pop0
	return  	$pop1
func_end3:
	.size	f4, func_end3-f4

	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, -1
	i32.const	$2=, 0
	block   	BB4_10
	i32.eq  	$push0=, $0, $1
	br_if   	$pop0, BB4_10
# BB#1:                                 # %for.inc
	i32.const	$2=, 1
	i32.const	$push1=, -2
	i32.eq  	$push2=, $0, $pop1
	br_if   	$pop2, BB4_10
# BB#2:                                 # %for.inc.1
	i32.const	$2=, 2
	i32.const	$push3=, -3
	i32.eq  	$push4=, $0, $pop3
	br_if   	$pop4, BB4_10
# BB#3:                                 # %for.inc.2
	i32.const	$2=, 3
	i32.const	$push5=, -4
	i32.eq  	$push6=, $0, $pop5
	br_if   	$pop6, BB4_10
# BB#4:                                 # %for.inc.3
	i32.const	$2=, 4
	i32.const	$push7=, -5
	i32.eq  	$push8=, $0, $pop7
	br_if   	$pop8, BB4_10
# BB#5:                                 # %for.inc.4
	i32.const	$2=, 5
	i32.const	$push9=, -6
	i32.eq  	$push10=, $0, $pop9
	br_if   	$pop10, BB4_10
# BB#6:                                 # %for.inc.5
	i32.const	$2=, 6
	i32.const	$push11=, -7
	i32.eq  	$push12=, $0, $pop11
	br_if   	$pop12, BB4_10
# BB#7:                                 # %for.inc.6
	i32.const	$2=, 7
	i32.const	$push13=, -8
	i32.eq  	$push14=, $0, $pop13
	br_if   	$pop14, BB4_10
# BB#8:                                 # %for.inc.7
	i32.const	$2=, 8
	i32.const	$push15=, -9
	i32.eq  	$push16=, $0, $pop15
	br_if   	$pop16, BB4_10
# BB#9:                                 # %for.inc.8
	i32.const	$push17=, -10
	i32.eq  	$push18=, $0, $pop17
	i32.const	$push19=, 9
	i32.select	$push20=, $pop18, $pop19, $1
	return  	$pop20
BB4_10:                                 # %cleanup
	return  	$2
func_end4:
	.size	f5, func_end4-f5

	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, -1
	i32.eq  	$push1=, $0, $pop0
	return  	$pop1
func_end5:
	.size	f6, func_end5-f6

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end32
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
func_end6:
	.size	main, func_end6-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
