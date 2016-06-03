	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr52979-1.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# BB#0:                                 # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo

	.section	.text.bar,"ax",@progbits
	.hidden	bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.local  	i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push28=, 0
	i64.load32_u	$push4=, a($pop28)
	i32.const	$push27=, 0
	i64.load8_u	$push1=, a+4($pop27)
	i64.const	$push2=, 32
	i64.shl 	$push3=, $pop1, $pop2
	i64.or  	$push26=, $pop4, $pop3
	tee_local	$push25=, $1=, $pop26
	i64.const	$push5=, 964220157951
	i64.and 	$push24=, $pop25, $pop5
	tee_local	$push23=, $2=, $pop24
	i64.const	$push22=, 32
	i64.shr_u	$push6=, $pop23, $pop22
	i64.store8	$drop=, a+4($pop0), $pop6
	i32.const	$push21=, 0
	i64.const	$push7=, 2147483648
	i64.or  	$push8=, $2, $pop7
	i64.store32	$drop=, a($pop21), $pop8
	block
	i32.const	$push20=, 0
	i32.const	$push19=, 0
	i32.store8	$push18=, b+4($pop20), $pop19
	tee_local	$push17=, $0=, $pop18
	i32.store	$push16=, b($pop17):p2align=0, $0
	tee_local	$push15=, $0=, $pop16
	i32.store	$push14=, e($pop15), $0
	tee_local	$push13=, $0=, $pop14
	i32.load	$push9=, d($pop13)
	i32.eqz 	$push30=, $pop9
	br_if   	0, $pop30       # 0: down to label0
# BB#1:                                 # %if.then
	i64.const	$push10=, 33
	i64.shl 	$push11=, $1, $pop10
	i64.const	$push29=, 33
	i64.shr_s	$push12=, $pop11, $pop29
	i64.store32	$drop=, c($0), $pop12
.LBB1_2:                                # %if.end
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar

	.section	.text.baz,"ax",@progbits
	.hidden	baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.local  	i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push30=, 0
	i64.load32_u	$push4=, a($pop30)
	i32.const	$push29=, 0
	i64.load8_u	$push1=, a+4($pop29)
	i64.const	$push2=, 32
	i64.shl 	$push3=, $pop1, $pop2
	i64.or  	$push28=, $pop4, $pop3
	tee_local	$push27=, $1=, $pop28
	i64.const	$push5=, 964220157951
	i64.and 	$push26=, $pop27, $pop5
	tee_local	$push25=, $2=, $pop26
	i64.const	$push24=, 32
	i64.shr_u	$push6=, $pop25, $pop24
	i64.store8	$drop=, a+4($pop0), $pop6
	i32.const	$push23=, 0
	i64.const	$push7=, 2147483648
	i64.or  	$push8=, $2, $pop7
	i64.store32	$drop=, a($pop23), $pop8
	block
	i32.const	$push22=, 0
	i32.const	$push21=, 0
	i32.store8	$push20=, b+4($pop22), $pop21
	tee_local	$push19=, $0=, $pop20
	i32.store	$push18=, b($pop19):p2align=0, $0
	tee_local	$push17=, $0=, $pop18
	i32.store	$push16=, e($pop17), $0
	tee_local	$push15=, $0=, $pop16
	i32.load	$push9=, d($pop15)
	i32.eqz 	$push32=, $pop9
	br_if   	0, $pop32       # 0: down to label1
# BB#1:                                 # %if.then.i
	i64.const	$push10=, 33
	i64.shl 	$push11=, $1, $pop10
	i64.const	$push31=, 33
	i64.shr_s	$push12=, $pop11, $pop31
	i64.store32	$drop=, c($0), $pop12
.LBB2_2:                                # %bar.exit
	end_block                       # label1:
	i32.load8_u	$push13=, b+4($0)
	i32.store8	$drop=, a+4($0), $pop13
	i32.load	$push14=, b($0):p2align=0
	i32.store	$drop=, a($0), $pop14
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	baz, .Lfunc_end2-baz

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i64, i64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.const	$push36=, 0
	i64.load32_u	$push4=, a($pop36)
	i32.const	$push35=, 0
	i64.load8_u	$push1=, a+4($pop35)
	i64.const	$push2=, 32
	i64.shl 	$push3=, $pop1, $pop2
	i64.or  	$push34=, $pop4, $pop3
	tee_local	$push33=, $1=, $pop34
	i64.const	$push5=, 964220157951
	i64.and 	$push32=, $pop33, $pop5
	tee_local	$push31=, $2=, $pop32
	i64.const	$push30=, 32
	i64.shr_u	$push6=, $pop31, $pop30
	i64.store8	$drop=, a+4($pop0), $pop6
	i32.const	$push29=, 0
	i64.const	$push7=, 2147483648
	i64.or  	$push8=, $2, $pop7
	i64.store32	$drop=, a($pop29), $pop8
	block
	i32.const	$push28=, 0
	i32.const	$push27=, 0
	i32.store8	$push26=, b+4($pop28), $pop27
	tee_local	$push25=, $0=, $pop26
	i32.store	$push24=, b($pop25):p2align=0, $0
	tee_local	$push23=, $0=, $pop24
	i32.store	$push22=, e($pop23), $0
	tee_local	$push21=, $0=, $pop22
	i32.load	$push9=, d($pop21)
	i32.eqz 	$push39=, $pop9
	br_if   	0, $pop39       # 0: down to label2
# BB#1:                                 # %if.then.i.i
	i64.const	$push10=, 33
	i64.shl 	$push11=, $1, $pop10
	i64.const	$push37=, 33
	i64.shr_s	$push12=, $pop11, $pop37
	i64.store32	$drop=, c($0), $pop12
.LBB3_2:                                # %baz.exit
	end_block                       # label2:
	i32.load8_u	$push13=, b+4($0)
	i32.store8	$drop=, a+4($0), $pop13
	i32.load	$push14=, b($0):p2align=0
	i32.store	$drop=, a($0), $pop14
	block
	i64.load32_u	$push15=, a($0)
	i64.const	$push16=, 33
	i64.shl 	$push17=, $pop15, $pop16
	i64.const	$push38=, 33
	i64.shr_s	$push18=, $pop17, $pop38
	i32.wrap/i64	$push19=, $pop18
	br_if   	0, $pop19       # 0: down to label3
# BB#3:                                 # %if.end
	i32.const	$push20=, 0
	return  	$pop20
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
	.functype	abort, void
