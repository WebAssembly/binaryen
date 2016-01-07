	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr39240.c"
	.globl	bar1
	.type	bar1,@function
bar1:                                   # @bar1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	i32.add 	$push1=, $0, $pop0
	i32.call	$push2=, foo1, $pop1
	return  	$pop2
.Lfunc_end0:
	.size	bar1, .Lfunc_end0-bar1

	.type	foo1,@function
foo1:                                   # @foo1
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	return  	$0
.Lfunc_end1:
	.size	foo1, .Lfunc_end1-foo1

	.globl	bar2
	.type	bar2,@function
bar2:                                   # @bar2
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	i32.add 	$push1=, $0, $pop0
	i32.call	$push2=, foo2, $pop1
	i32.const	$push3=, 65535
	i32.and 	$push4=, $pop2, $pop3
	return  	$pop4
.Lfunc_end2:
	.size	bar2, .Lfunc_end2-bar2

	.type	foo2,@function
foo2:                                   # @foo2
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 16
	i32.shl 	$push0=, $0, $1
	i32.shr_s	$push1=, $pop0, $1
	return  	$pop1
.Lfunc_end3:
	.size	foo2, .Lfunc_end3-foo2

	.globl	bar3
	.type	bar3,@function
bar3:                                   # @bar3
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	i32.add 	$push1=, $0, $pop0
	i32.call	$push2=, foo3, $pop1
	i32.const	$push3=, 255
	i32.and 	$push4=, $pop2, $pop3
	return  	$pop4
.Lfunc_end4:
	.size	bar3, .Lfunc_end4-bar3

	.type	foo3,@function
foo3:                                   # @foo3
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 24
	i32.shl 	$push0=, $0, $1
	i32.shr_s	$push1=, $pop0, $1
	return  	$pop1
.Lfunc_end5:
	.size	foo3, .Lfunc_end5-foo3

	.globl	bar4
	.type	bar4,@function
bar4:                                   # @bar4
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	i32.add 	$push1=, $0, $pop0
	i32.call	$push2=, foo4, $pop1
	return  	$pop2
.Lfunc_end6:
	.size	bar4, .Lfunc_end6-bar4

	.type	foo4,@function
foo4:                                   # @foo4
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	return  	$0
.Lfunc_end7:
	.size	foo4, .Lfunc_end7-foo4

	.globl	bar5
	.type	bar5,@function
bar5:                                   # @bar5
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	i32.add 	$push1=, $0, $pop0
	i32.call	$1=, foo5, $pop1
	i32.const	$0=, 16
	i32.shl 	$push2=, $1, $0
	i32.shr_s	$push3=, $pop2, $0
	return  	$pop3
.Lfunc_end8:
	.size	bar5, .Lfunc_end8-bar5

	.type	foo5,@function
foo5:                                   # @foo5
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 65535
	i32.and 	$push1=, $0, $pop0
	return  	$pop1
.Lfunc_end9:
	.size	foo5, .Lfunc_end9-foo5

	.globl	bar6
	.type	bar6,@function
bar6:                                   # @bar6
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 6
	i32.add 	$push1=, $0, $pop0
	i32.call	$1=, foo6, $pop1
	i32.const	$0=, 24
	i32.shl 	$push2=, $1, $0
	i32.shr_s	$push3=, $pop2, $0
	return  	$pop3
.Lfunc_end10:
	.size	bar6, .Lfunc_end10-bar6

	.type	foo6,@function
foo6:                                   # @foo6
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 255
	i32.and 	$push1=, $0, $pop0
	return  	$pop1
.Lfunc_end11:
	.size	foo6, .Lfunc_end11-foo6

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, -10
	i32.call	$1=, bar1, $0
	i32.const	$2=, 0
	block   	.LBB12_12
	i32.load	$push0=, l1($2)
	i32.ne  	$push1=, $1, $pop0
	br_if   	$pop1, .LBB12_12
# BB#1:                                 # %if.end
	block   	.LBB12_11
	i32.call	$push2=, bar2, $0
	i32.load	$push3=, l2($2)
	i32.ne  	$push4=, $pop2, $pop3
	br_if   	$pop4, .LBB12_11
# BB#2:                                 # %if.end5
	block   	.LBB12_10
	i32.call	$push5=, bar3, $0
	i32.load	$push6=, l3($2)
	i32.ne  	$push7=, $pop5, $pop6
	br_if   	$pop7, .LBB12_10
# BB#3:                                 # %if.end11
	block   	.LBB12_9
	i32.call	$push8=, bar4, $0
	i32.load	$push9=, l4($2)
	i32.ne  	$push10=, $pop8, $pop9
	br_if   	$pop10, .LBB12_9
# BB#4:                                 # %if.end16
	block   	.LBB12_8
	i32.call	$push11=, bar5, $0
	i32.load	$push12=, l5($2)
	i32.ne  	$push13=, $pop11, $pop12
	br_if   	$pop13, .LBB12_8
# BB#5:                                 # %if.end22
	block   	.LBB12_7
	i32.call	$push14=, bar6, $0
	i32.load	$push15=, l6($2)
	i32.ne  	$push16=, $pop14, $pop15
	br_if   	$pop16, .LBB12_7
# BB#6:                                 # %if.end28
	return  	$2
.LBB12_7:                                 # %if.then27
	call    	abort
	unreachable
.LBB12_8:                                 # %if.then21
	call    	abort
	unreachable
.LBB12_9:                                 # %if.then15
	call    	abort
	unreachable
.LBB12_10:                                # %if.then10
	call    	abort
	unreachable
.LBB12_11:                                # %if.then4
	call    	abort
	unreachable
.LBB12_12:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end12:
	.size	main, .Lfunc_end12-main

	.type	l1,@object              # @l1
	.data
	.globl	l1
	.align	2
l1:
	.int32	4294967292              # 0xfffffffc
	.size	l1, 4

	.type	l2,@object              # @l2
	.globl	l2
	.align	2
l2:
	.int32	65532                   # 0xfffc
	.size	l2, 4

	.type	l3,@object              # @l3
	.globl	l3
	.align	2
l3:
	.int32	252                     # 0xfc
	.size	l3, 4

	.type	l4,@object              # @l4
	.globl	l4
	.align	2
l4:
	.int32	4294967292              # 0xfffffffc
	.size	l4, 4

	.type	l5,@object              # @l5
	.globl	l5
	.align	2
l5:
	.int32	4294967292              # 0xfffffffc
	.size	l5, 4

	.type	l6,@object              # @l6
	.globl	l6
	.align	2
l6:
	.int32	4294967292              # 0xfffffffc
	.size	l6, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
