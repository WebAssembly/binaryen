	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120105-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push13=, 0
	i32.const	$push10=, 0
	i32.load	$push11=, __stack_pointer($pop10)
	i32.const	$push12=, 16
	i32.sub 	$push17=, $pop11, $pop12
	i32.store	$push19=, __stack_pointer($pop13), $pop17
	tee_local	$push18=, $1=, $pop19
	i32.const	$push4=, 8
	i32.add 	$push5=, $pop18, $pop4
	i32.const	$push1=, 12
	i32.add 	$push2=, $1, $pop1
	i32.const	$push3=, 0
	i32.store8	$push0=, 0($pop2), $pop3
	i32.store	$0=, 0($pop5), $pop0
	i64.const	$push6=, 0
	i64.store	$drop=, 0($1):p2align=2, $pop6
	i32.const	$push7=, 1
	i32.or  	$push8=, $1, $pop7
	i32.call	$push9=, extract@FUNCTION, $pop8
	i32.store	$drop=, i($0), $pop9
	i32.const	$push16=, 0
	i32.const	$push14=, 16
	i32.add 	$push15=, $1, $pop14
	i32.store	$drop=, __stack_pointer($pop16), $pop15
	copy_local	$push20=, $0
                                        # fallthrough-return: $pop20
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


	.ident	"clang version 3.9.0 "
