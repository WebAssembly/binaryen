	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/loop-3c.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, -4
	i32.add 	$1=, $0, $pop0
	i32.const	$push1=, 3
	i32.shl 	$push2=, $0, $pop1
	i32.const	$push6=, a
	i32.add 	$0=, $pop2, $pop6
	i32.const	$2=, 256
.LBB0_1:                                # %do.body
                                        # =>This Inner Loop Header: Depth=1
	loop    	                # label0:
	i32.const	$push16=, 1
	i32.shr_s	$push15=, $2, $pop16
	tee_local	$push14=, $2=, $pop15
	i32.const	$push13=, 2
	i32.shl 	$push3=, $pop14, $pop13
	i32.const	$push12=, a
	i32.add 	$push4=, $pop3, $pop12
	i32.store	0($pop4), $0
	i32.const	$push11=, 32
	i32.add 	$0=, $0, $pop11
	i32.const	$push10=, 4
	i32.add 	$push9=, $1, $pop10
	tee_local	$push8=, $1=, $pop9
	i32.const	$push7=, 1073741836
	i32.lt_s	$push5=, $pop8, $pop7
	br_if   	0, $pop5        # 0: up to label0
# BB#2:                                 # %do.end
	end_loop
	copy_local	$push17=, $0
                                        # fallthrough-return: $pop17
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end7
	i32.const	$push1=, 0
	i32.const	$push0=, a
	i32.store	a+512($pop1), $pop0
	i32.const	$push10=, 0
	i32.const	$push2=, a+32
	i32.store	a+256($pop10), $pop2
	i32.const	$push9=, 0
	i32.const	$push3=, a+64
	i32.store	a+128($pop9), $pop3
	i32.const	$push8=, 0
	i32.const	$push4=, a+96
	i32.store	a+64($pop8), $pop4
	i32.const	$push7=, 0
	i32.const	$push6=, 0
	i32.store	a+32($pop7), $pop6
	i32.const	$push5=, 0
	call    	exit@FUNCTION, $pop5
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.bss.a,"aw",@nobits
	.globl	a
	.p2align	4
a:
	.skip	1020
	.size	a, 1020


	.ident	"clang version 5.0.0 (https://chromium.googlesource.com/external/github.com/llvm-mirror/clang e7bf9bd23e5ab5ae3f79d88d3e8956f0067fc683) (https://chromium.googlesource.com/external/github.com/llvm-mirror/llvm 7bfedca6fc415b0e5edea211f299142b03de1e97)"
	.functype	exit, void, i32
