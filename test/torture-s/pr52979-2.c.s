	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr52979-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
	return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.local  	i32, i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push26=, 0
	i64.load32_u	$push4=, a($pop26)
	i32.const	$push25=, 0
	i64.load8_u	$push1=, a+4($pop25)
	i64.const	$push2=, 32
	i64.shl 	$push3=, $pop1, $pop2
	i64.or  	$push24=, $pop4, $pop3
	tee_local	$push23=, $3=, $pop24
	i64.const	$push5=, 964220157951
	i64.and 	$push22=, $pop23, $pop5
	tee_local	$push21=, $2=, $pop22
	i64.const	$push20=, 32
	i64.shr_u	$push8=, $pop21, $pop20
	i64.store8	$drop=, a+4($pop0), $pop8
	i32.const	$push19=, 0
	i64.const	$push6=, 2147483648
	i64.or  	$push7=, $2, $pop6
	i64.store32	$drop=, a($pop19), $pop7
	i32.const	$push18=, 0
	i32.load	$0=, d($pop18)
	i32.const	$push17=, 0
	i32.const	$push16=, 0
	i32.store8	$push15=, b+4($pop17), $pop16
	tee_local	$push14=, $1=, $pop15
	i32.store	$push13=, b($pop14):p2align=0, $1
	tee_local	$push12=, $1=, $pop13
	i32.store	$drop=, e($pop12), $1
	block
	i32.eqz 	$push28=, $0
	br_if   	0, $pop28       # 0: down to label0
# BB#1:                                 # %if.then
	i64.const	$push9=, 33
	i64.shl 	$push10=, $3, $pop9
	i64.const	$push27=, 33
	i64.shr_s	$push11=, $pop10, $pop27
	i64.store32	$drop=, c($1), $pop11
.LBB1_2:                                # %if.end
	end_block                       # label0:
	return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.baz,"ax",@progbits
	.hidden	baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.local  	i32, i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push27=, 0
	i64.load32_u	$push4=, a($pop27)
	i32.const	$push26=, 0
	i64.load8_u	$push1=, a+4($pop26)
	i64.const	$push2=, 32
	i64.shl 	$push3=, $pop1, $pop2
	i64.or  	$push25=, $pop4, $pop3
	tee_local	$push24=, $3=, $pop25
	i64.const	$push5=, 964220157951
	i64.and 	$push23=, $pop24, $pop5
	tee_local	$push22=, $2=, $pop23
	i64.const	$push21=, 32
	i64.shr_u	$push8=, $pop22, $pop21
	i64.store8	$drop=, a+4($pop0), $pop8
	i32.const	$push20=, 0
	i64.const	$push6=, 2147483648
	i64.or  	$push7=, $2, $pop6
	i64.store32	$drop=, a($pop20), $pop7
	i32.const	$push19=, 0
	i32.load	$1=, d($pop19)
	i32.const	$push18=, 0
	i32.const	$push17=, 0
	i32.store8	$push16=, b+4($pop18), $pop17
	tee_local	$push15=, $0=, $pop16
	i32.store	$push14=, b($pop15):p2align=0, $0
	tee_local	$push13=, $0=, $pop14
	i32.store	$drop=, e($pop13), $0
	block
	i32.eqz 	$push29=, $1
	br_if   	0, $pop29       # 0: down to label1
# BB#1:                                 # %if.then.i
	i64.const	$push9=, 33
	i64.shl 	$push10=, $3, $pop9
	i64.const	$push28=, 33
	i64.shr_s	$push11=, $pop10, $pop28
	i64.store32	$drop=, c($0), $pop11
.LBB2_2:                                # %bar.exit
	end_block                       # label1:
	i32.load	$1=, b($0):p2align=0
	i32.load8_u	$push12=, b+4($0)
	i32.store8	$drop=, a+4($0), $pop12
	i32.store	$drop=, a($0), $1
	return
	.endfunc
.Lfunc_end2:
	.size	baz, .Lfunc_end2-baz

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push33=, 0
	i64.load32_u	$push4=, a($pop33)
	i32.const	$push32=, 0
	i64.load8_u	$push1=, a+4($pop32)
	i64.const	$push2=, 32
	i64.shl 	$push3=, $pop1, $pop2
	i64.or  	$push31=, $pop4, $pop3
	tee_local	$push30=, $3=, $pop31
	i64.const	$push5=, 964220157951
	i64.and 	$push29=, $pop30, $pop5
	tee_local	$push28=, $2=, $pop29
	i64.const	$push27=, 32
	i64.shr_u	$push8=, $pop28, $pop27
	i64.store8	$drop=, a+4($pop0), $pop8
	i32.const	$push26=, 0
	i64.const	$push6=, 2147483648
	i64.or  	$push7=, $2, $pop6
	i64.store32	$drop=, a($pop26), $pop7
	i32.const	$push25=, 0
	i32.load	$1=, d($pop25)
	i32.const	$push24=, 0
	i32.const	$push23=, 0
	i32.store8	$push22=, b+4($pop24), $pop23
	tee_local	$push21=, $0=, $pop22
	i32.store	$push20=, b($pop21):p2align=0, $0
	tee_local	$push19=, $0=, $pop20
	i32.store	$drop=, e($pop19), $0
	block
	i32.eqz 	$push36=, $1
	br_if   	0, $pop36       # 0: down to label2
# BB#1:                                 # %if.then.i.i
	i64.const	$push9=, 33
	i64.shl 	$push10=, $3, $pop9
	i64.const	$push34=, 33
	i64.shr_s	$push11=, $pop10, $pop34
	i64.store32	$drop=, c($0), $pop11
.LBB3_2:                                # %baz.exit
	end_block                       # label2:
	i32.load	$1=, b($0):p2align=0
	i32.load8_u	$push12=, b+4($0)
	i32.store8	$drop=, a+4($0), $pop12
	i32.store	$drop=, a($0), $1
	block
	i64.load32_u	$push13=, a($0)
	i64.const	$push14=, 33
	i64.shl 	$push15=, $pop13, $pop14
	i64.const	$push35=, 33
	i64.shr_s	$push16=, $pop15, $pop35
	i32.wrap/i64	$push17=, $pop16
	br_if   	0, $pop17       # 0: down to label3
# BB#3:                                 # %if.end
	i32.const	$push18=, 0
	return  	$pop18
.LBB3_4:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main

	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	3
a:
	.int8	1                       # 0x1
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.size	a, 5

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	2
e:
	.int32	0                       # 0x0
	.size	e, 4

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.int32	0                       # 0x0
	.size	d, 4

	.hidden	c                       # @c
	.type	c,@object
	.section	.bss.c,"aw",@nobits
	.globl	c
	.p2align	2
c:
	.int32	0                       # 0x0
	.size	c, 4

	.type	b,@object               # @b
	.section	.data.b,"aw",@progbits
b:
	.int8	1                       # 0x1
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.int8	0                       # 0x0
	.size	b, 5


	.ident	"clang version 3.9.0 "
