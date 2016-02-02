	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/bitfld-3.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64
# BB#0:                                 # %entry
	block
	i32.const	$push14=, 0
	i64.load	$push1=, a($pop14)
	i64.const	$push2=, 8589934591
	i64.and 	$push0=, $pop1, $pop2
	tee_local	$push13=, $0=, $pop0
	i64.mul 	$push3=, $pop13, $0
	i64.const	$push12=, 0
	i64.ne  	$push4=, $pop3, $pop12
	br_if   	$pop4, 0        # 0: down to label0
# BB#1:                                 # %lor.lhs.false
	i32.const	$push17=, 0
	i64.load	$push5=, a+8($pop17)
	i64.const	$push6=, 1099511627775
	i64.and 	$push7=, $pop5, $pop6
	tee_local	$push16=, $1=, $pop7
	i64.mul 	$push8=, $pop16, $0
	i64.mul 	$push9=, $1, $1
	i64.or  	$push10=, $pop8, $pop9
	i64.const	$push15=, 0
	i64.ne  	$push11=, $pop10, $pop15
	br_if   	$pop11, 0       # 0: down to label0
# BB#2:                                 # %if.end
	call    	abort@FUNCTION
	unreachable
.LBB0_3:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	3
a:
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	16                      # 0x10
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.skip	3
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	16                      # 0x10
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.skip	3
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	16                      # 0x10
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.skip	2
	.size	a, 24

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
	.p2align	3
b:
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	1                       # 0x1
	.skip	3
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	1                       # 0x1
	.skip	3
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	1                       # 0x1
	.int8	0                       # 0x0
	.skip	2
	.size	b, 24

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.p2align	3
c:
	.int8	255                     # 0xff
	.int8	255                     # 0xff
	.int8	255                     # 0xff
	.int8	255                     # 0xff
	.int8	1                       # 0x1
	.skip	3
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.skip	3
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.skip	2
	.size	c, 24


	.ident	"clang version 3.9.0 "
