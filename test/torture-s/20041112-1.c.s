	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20041112-1.c"
	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push19=, 0
	i32.load	$push18=, global($pop19)
	tee_local	$push17=, $0=, $pop18
	i32.const	$push1=, 1
	i32.add 	$push2=, $pop17, $pop1
	i32.const	$push3=, 2
	i32.select	$push16=, $pop2, $pop3, $0
	tee_local	$push15=, $1=, $pop16
	i32.const	$push14=, 1
	i32.const	$push5=, global
	i32.const	$push4=, -1
	i32.eq  	$push6=, $pop5, $pop4
	i32.select	$push7=, $1, $pop14, $pop6
	i32.select	$push8=, $pop15, $pop7, $0
	i32.store	global($pop0), $pop8
	i32.eqz 	$push10=, $0
	i32.const	$push13=, global
	i32.const	$push12=, -1
	i32.ne  	$push9=, $pop13, $pop12
	i32.and 	$push11=, $pop10, $pop9
                                        # fallthrough-return: $pop11
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
	i32.store	global($pop1), $pop0
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
