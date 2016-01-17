	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20120105-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$7=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$7=, 0($2), $7
	i32.const	$push0=, 12
	i32.const	$4=, 0
	i32.add 	$4=, $7, $4
	i32.add 	$push1=, $4, $pop0
	i32.const	$push2=, 0
	i32.store8	$0=, 0($pop1), $pop2
	i32.const	$push3=, 8
	i32.const	$5=, 0
	i32.add 	$5=, $7, $5
	i32.add 	$push4=, $5, $pop3
	i32.store	$discard=, 0($pop4), $0
	i64.const	$push5=, 0
	i64.store	$discard=, 0($7), $pop5
	i32.const	$push6=, 1
	i32.const	$6=, 0
	i32.add 	$6=, $7, $6
	i32.or  	$push7=, $6, $pop6
	i32.call	$push8=, extract@FUNCTION, $pop7
	i32.store	$discard=, i($0), $pop8
	i32.const	$3=, 16
	i32.add 	$7=, $7, $3
	i32.const	$3=, __stack_pointer
	i32.store	$7=, 0($3), $7
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.section	.text.extract,"ax",@progbits
	.type	extract,@function
extract:                                # @extract
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 8
	i32.const	$push0=, 3
	i32.add 	$push1=, $0, $pop0
	i32.load8_u	$push2=, 0($pop1)
	i32.shl 	$push3=, $pop2, $1
	i32.const	$push4=, 2
	i32.add 	$push5=, $0, $pop4
	i32.load8_u	$push6=, 0($pop5)
	i32.or  	$push7=, $pop3, $pop6
	i32.const	$push8=, 16
	i32.shl 	$push9=, $pop7, $pop8
	i32.const	$push10=, 1
	i32.add 	$push11=, $0, $pop10
	i32.load8_u	$push12=, 0($pop11)
	i32.shl 	$push13=, $pop12, $1
	i32.load8_u	$push14=, 0($0)
	i32.or  	$push15=, $pop13, $pop14
	i32.or  	$push16=, $pop9, $pop15
	return  	$pop16
	.endfunc
.Lfunc_end1:
	.size	extract, .Lfunc_end1-extract

	.hidden	i                       # @i
	.type	i,@object
	.section	.bss.i,"aw",@nobits
	.globl	i
	.align	2
i:
	.int32	0                       # 0x0
	.size	i, 4


	.ident	"clang version 3.9.0 "
