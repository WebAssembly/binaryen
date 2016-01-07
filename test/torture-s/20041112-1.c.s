	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041112-1.c"
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, 0
	i32.load	$1=, global($0)
	i32.const	$3=, 1
	i32.ne  	$push1=, $1, $0
	i32.const	$push0=, global
	i32.const	$push2=, -1
	i32.eq  	$push3=, $pop0, $pop2
	i32.or  	$2=, $pop1, $pop3
	i32.add 	$push4=, $1, $3
	i32.const	$push5=, 2
	i32.select	$push6=, $1, $pop4, $pop5
	i32.select	$push7=, $2, $pop6, $3
	i32.store	$discard=, global($0), $pop7
	i32.xor 	$push8=, $2, $3
	return  	$pop8
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end
	i32.const	$0=, 0
	i32.const	$push0=, 2
	i32.store	$discard=, global($0), $pop0
	return  	$0
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	global,@object          # @global
	.bss
	.globl	global
	.align	2
global:
	.int32	0                       # 0x0
	.size	global, 4


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
