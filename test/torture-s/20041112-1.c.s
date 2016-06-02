	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041112-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push3=, 0
	i32.const	$push18=, 0
	i32.load	$push17=, global($pop18)
	tee_local	$push16=, $0=, $pop17
	i32.const	$push5=, 1
	i32.add 	$push6=, $pop16, $pop5
	i32.const	$push7=, 2
	i32.select	$push8=, $pop6, $pop7, $0
	i32.const	$push15=, 1
	i32.const	$push14=, 0
	i32.ne  	$push4=, $0, $pop14
	i32.const	$push1=, global
	i32.const	$push0=, -1
	i32.eq  	$push2=, $pop1, $pop0
	i32.or  	$push13=, $pop4, $pop2
	tee_local	$push12=, $0=, $pop13
	i32.select	$push9=, $pop8, $pop15, $pop12
	i32.store	$drop=, global($pop3), $pop9
	i32.const	$push11=, 1
	i32.xor 	$push10=, $0, $pop11
                                        # fallthrough-return: $pop10
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
	i32.store	$drop=, global($pop1), $pop0
	i32.const	$push2=, 0
                                        # fallthrough-return: $pop2
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
