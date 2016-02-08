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
	.local  	i64, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i64.load8_u	$0=, a+4($pop1):p2align=2
	i32.const	$push25=, 0
	i64.load32_u	$1=, a($pop25):p2align=3
	i32.const	$push24=, 0
	i32.const	$push23=, 0
	i32.store8	$push9=, b+4($pop24), $pop23
	tee_local	$push22=, $3=, $pop9
	i32.store	$push10=, b($pop22):p2align=0, $3
	tee_local	$push21=, $3=, $pop10
	i32.store	$push11=, e($pop21), $3
	tee_local	$push20=, $2=, $pop11
	i32.load	$3=, d($pop20)
	i32.const	$push19=, 0
	i64.const	$push2=, 32
	i64.shl 	$push3=, $0, $pop2
	i64.or  	$push0=, $1, $pop3
	tee_local	$push18=, $1=, $pop0
	i64.const	$push4=, 964220157951
	i64.and 	$push5=, $pop18, $pop4
	tee_local	$push17=, $0=, $pop5
	i64.const	$push16=, 32
	i64.shr_u	$push8=, $pop17, $pop16
	i64.store8	$discard=, a+4($pop19):p2align=2, $pop8
	i32.const	$push15=, 0
	i64.const	$push6=, 2147483648
	i64.or  	$push7=, $0, $pop6
	i64.store32	$discard=, a($pop15):p2align=3, $pop7
	block
	i32.const	$push27=, 0
	i32.eq  	$push28=, $3, $pop27
	br_if   	0, $pop28       # 0: down to label0
# BB#1:                                 # %if.then
	i64.const	$push12=, 33
	i64.shl 	$push13=, $1, $pop12
	i64.const	$push26=, 33
	i64.shr_s	$push14=, $pop13, $pop26
	i64.store32	$discard=, c($2), $pop14
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
	.local  	i64, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i64.load8_u	$0=, a+4($pop1):p2align=2
	i32.const	$push26=, 0
	i64.load32_u	$1=, a($pop26):p2align=3
	i32.const	$push25=, 0
	i32.const	$push24=, 0
	i32.store8	$push9=, b+4($pop25), $pop24
	tee_local	$push23=, $3=, $pop9
	i32.store	$push10=, b($pop23):p2align=0, $3
	tee_local	$push22=, $3=, $pop10
	i32.store	$push11=, e($pop22), $3
	tee_local	$push21=, $3=, $pop11
	i32.load	$2=, d($pop21)
	i32.const	$push20=, 0
	i64.const	$push2=, 32
	i64.shl 	$push3=, $0, $pop2
	i64.or  	$push0=, $1, $pop3
	tee_local	$push19=, $1=, $pop0
	i64.const	$push4=, 964220157951
	i64.and 	$push5=, $pop19, $pop4
	tee_local	$push18=, $0=, $pop5
	i64.const	$push17=, 32
	i64.shr_u	$push8=, $pop18, $pop17
	i64.store8	$discard=, a+4($pop20):p2align=2, $pop8
	i32.const	$push16=, 0
	i64.const	$push6=, 2147483648
	i64.or  	$push7=, $0, $pop6
	i64.store32	$discard=, a($pop16):p2align=3, $pop7
	block
	i32.const	$push28=, 0
	i32.eq  	$push29=, $2, $pop28
	br_if   	0, $pop29       # 0: down to label1
# BB#1:                                 # %if.then.i
	i64.const	$push12=, 33
	i64.shl 	$push13=, $1, $pop12
	i64.const	$push27=, 33
	i64.shr_s	$push14=, $pop13, $pop27
	i64.store32	$discard=, c($3), $pop14
.LBB2_2:                                # %bar.exit
	end_block                       # label1:
	i32.load	$2=, b($3):p2align=0
	i32.load8_u	$push15=, b+4($3)
	i32.store8	$discard=, a+4($3):p2align=2, $pop15
	i32.store	$discard=, a($3):p2align=3, $2
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
	.local  	i64, i64, i32, i32
# BB#0:                                 # %entry
	i32.const	$push1=, 0
	i64.load8_u	$0=, a+4($pop1):p2align=2
	i32.const	$push32=, 0
	i64.load32_u	$1=, a($pop32):p2align=3
	i32.const	$push31=, 0
	i32.const	$push30=, 0
	i32.store8	$push9=, b+4($pop31), $pop30
	tee_local	$push29=, $3=, $pop9
	i32.store	$push10=, b($pop29):p2align=0, $3
	tee_local	$push28=, $3=, $pop10
	i32.store	$push11=, e($pop28), $3
	tee_local	$push27=, $3=, $pop11
	i32.load	$2=, d($pop27)
	i32.const	$push26=, 0
	i64.const	$push2=, 32
	i64.shl 	$push3=, $0, $pop2
	i64.or  	$push0=, $1, $pop3
	tee_local	$push25=, $1=, $pop0
	i64.const	$push4=, 964220157951
	i64.and 	$push5=, $pop25, $pop4
	tee_local	$push24=, $0=, $pop5
	i64.const	$push23=, 32
	i64.shr_u	$push8=, $pop24, $pop23
	i64.store8	$discard=, a+4($pop26):p2align=2, $pop8
	i32.const	$push22=, 0
	i64.const	$push6=, 2147483648
	i64.or  	$push7=, $0, $pop6
	i64.store32	$discard=, a($pop22):p2align=3, $pop7
	block
	i32.const	$push35=, 0
	i32.eq  	$push36=, $2, $pop35
	br_if   	0, $pop36       # 0: down to label2
# BB#1:                                 # %if.then.i.i
	i64.const	$push12=, 33
	i64.shl 	$push13=, $1, $pop12
	i64.const	$push33=, 33
	i64.shr_s	$push14=, $pop13, $pop33
	i64.store32	$discard=, c($3), $pop14
.LBB3_2:                                # %baz.exit
	end_block                       # label2:
	i32.load	$2=, b($3):p2align=0
	i32.load8_u	$push15=, b+4($3)
	i32.store8	$discard=, a+4($3):p2align=2, $pop15
	i32.store	$discard=, a($3):p2align=3, $2
	block
	i64.load32_u	$push16=, a($3):p2align=3
	i64.const	$push17=, 33
	i64.shl 	$push18=, $pop16, $pop17
	i64.const	$push34=, 33
	i64.shr_s	$push19=, $pop18, $pop34
	i32.wrap/i64	$push20=, $pop19
	br_if   	0, $pop20       # 0: down to label3
# BB#3:                                 # %if.end
	i32.const	$push21=, 0
	return  	$pop21
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
