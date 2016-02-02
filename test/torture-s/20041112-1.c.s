	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041112-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push18=, 0
	i32.load	$push1=, global($pop18)
	tee_local	$push17=, $1=, $pop1
	i32.const	$push16=, 0
	i32.ne  	$push3=, $pop17, $pop16
	i32.const	$push2=, global
	i32.const	$push4=, -1
	i32.eq  	$push5=, $pop2, $pop4
	i32.or  	$push6=, $pop3, $pop5
	tee_local	$push15=, $0=, $pop6
	i32.const	$push7=, 1
	i32.add 	$push8=, $1, $pop7
	i32.const	$push9=, 2
	i32.select	$push10=, $1, $pop8, $pop9
	i32.const	$push14=, 1
	i32.select	$push11=, $pop15, $pop10, $pop14
	i32.store	$discard=, global($pop0), $pop11
	i32.const	$push13=, 1
	i32.xor 	$push12=, $0, $pop13
	return  	$pop12
	.endfunc
.Lfunc_end0:
	.size	bar, .Lfunc_end0-bar

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push1=, 0
	i32.const	$push0=, 2
	i32.store	$discard=, global($pop1), $pop0
	i32.const	$push2=, 0
	return  	$pop2
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	global                  # @global
	.type	global,@object
	.section	.bss.global,"aw",@nobits
	.globl	global
	.p2align	2
global:
	.int32	0                       # 0x0
	.size	global, 4


	.ident	"clang version 3.9.0 "
