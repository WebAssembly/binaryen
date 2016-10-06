	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120105-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push12=, 0
	i32.const	$push9=, 0
	i32.load	$push10=, __stack_pointer($pop9)
	i32.const	$push11=, 16
	i32.sub 	$push20=, $pop10, $pop11
	tee_local	$push19=, $0=, $pop20
	i32.store	__stack_pointer($pop12), $pop19
	i32.const	$push0=, 12
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 0
	i32.store8	0($pop1), $pop2
	i32.const	$push3=, 8
	i32.add 	$push4=, $0, $pop3
	i32.const	$push18=, 0
	i32.store	0($pop4), $pop18
	i64.const	$push5=, 0
	i64.store	0($0):p2align=2, $pop5
	i32.const	$push17=, 0
	i32.const	$push6=, 1
	i32.or  	$push7=, $0, $pop6
	i32.call	$push8=, extract@FUNCTION, $pop7
	i32.store	i($pop17), $pop8
	i32.const	$push15=, 0
	i32.const	$push13=, 16
	i32.add 	$push14=, $0, $pop13
	i32.store	__stack_pointer($pop15), $pop14
	i32.const	$push16=, 0
                                        # fallthrough-return: $pop16
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.extract,"ax",@progbits
	.type	extract,@function
extract:                                # @extract
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($0):p2align=0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	extract, .Lfunc_end1-extract

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.p2align	2
i:
	.int32	0                       # 0x0
	.size	i, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
