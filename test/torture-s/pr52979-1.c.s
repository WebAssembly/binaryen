	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr52979-1.c"
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
	.local  	i64, i64
# BB#0:                                 # %entry
	i32.const	$push27=, 0
	i32.const	$push26=, 0
	i64.load32_u	$push3=, a($pop26)
	i32.const	$push25=, 0
	i64.load8_u	$push0=, a+4($pop25)
	i64.const	$push1=, 32
	i64.shl 	$push2=, $pop0, $pop1
	i64.or  	$push24=, $pop3, $pop2
	tee_local	$push23=, $0=, $pop24
	i64.const	$push4=, 964220157951
	i64.and 	$push22=, $pop23, $pop4
	tee_local	$push21=, $1=, $pop22
	i64.const	$push20=, 32
	i64.shr_u	$push5=, $pop21, $pop20
	i64.store8	a+4($pop27), $pop5
	i32.const	$push19=, 0
	i64.const	$push6=, 2147483648
	i64.or  	$push7=, $1, $pop6
	i64.store32	a($pop19), $pop7
	i32.const	$push18=, 0
	i32.const	$push17=, 0
	i32.store8	b+4($pop18), $pop17
	i32.const	$push16=, 0
	i32.const	$push15=, 0
	i32.store	b($pop16):p2align=0, $pop15
	i32.const	$push14=, 0
	i32.const	$push13=, 0
	i32.store	e($pop14), $pop13
	block   	
	i32.const	$push12=, 0
	i32.load	$push8=, d($pop12)
	i32.eqz 	$push30=, $pop8
	br_if   	0, $pop30       # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push29=, 0
	i64.const	$push9=, 33
	i64.shl 	$push10=, $0, $pop9
	i64.const	$push28=, 33
	i64.shr_s	$push11=, $pop10, $pop28
	i64.store32	c($pop29), $pop11
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
	.local  	i64, i64
# BB#0:                                 # %entry
	i32.const	$push29=, 0
	i32.const	$push28=, 0
	i64.load32_u	$push3=, a($pop28)
	i32.const	$push27=, 0
	i64.load8_u	$push0=, a+4($pop27)
	i64.const	$push1=, 32
	i64.shl 	$push2=, $pop0, $pop1
	i64.or  	$push26=, $pop3, $pop2
	tee_local	$push25=, $0=, $pop26
	i64.const	$push4=, 964220157951
	i64.and 	$push24=, $pop25, $pop4
	tee_local	$push23=, $1=, $pop24
	i64.const	$push22=, 32
	i64.shr_u	$push5=, $pop23, $pop22
	i64.store8	a+4($pop29), $pop5
	i32.const	$push21=, 0
	i64.const	$push6=, 2147483648
	i64.or  	$push7=, $1, $pop6
	i64.store32	a($pop21), $pop7
	i32.const	$push20=, 0
	i32.const	$push19=, 0
	i32.store8	b+4($pop20), $pop19
	i32.const	$push18=, 0
	i32.const	$push17=, 0
	i32.store	b($pop18):p2align=0, $pop17
	i32.const	$push16=, 0
	i32.const	$push15=, 0
	i32.store	e($pop16), $pop15
	block   	
	i32.const	$push14=, 0
	i32.load	$push8=, d($pop14)
	i32.eqz 	$push36=, $pop8
	br_if   	0, $pop36       # 0: down to label1
# BB#1:                                 # %if.then.i
	i32.const	$push31=, 0
	i64.const	$push9=, 33
	i64.shl 	$push10=, $0, $pop9
	i64.const	$push30=, 33
	i64.shr_s	$push11=, $pop10, $pop30
	i64.store32	c($pop31), $pop11
.LBB2_2:                                # %bar.exit
	end_block                       # label1:
	i32.const	$push35=, 0
	i32.const	$push34=, 0
	i32.load8_u	$push12=, b+4($pop34)
	i32.store8	a+4($pop35), $pop12
	i32.const	$push33=, 0
	i32.const	$push32=, 0
	i32.load	$push13=, b($pop32):p2align=0
	i32.store	a($pop33), $pop13
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
	.local  	i64, i64
# BB#0:                                 # %entry
	i32.const	$push35=, 0
	i32.const	$push34=, 0
	i64.load32_u	$push3=, a($pop34)
	i32.const	$push33=, 0
	i64.load8_u	$push0=, a+4($pop33)
	i64.const	$push1=, 32
	i64.shl 	$push2=, $pop0, $pop1
	i64.or  	$push32=, $pop3, $pop2
	tee_local	$push31=, $0=, $pop32
	i64.const	$push4=, 964220157951
	i64.and 	$push30=, $pop31, $pop4
	tee_local	$push29=, $1=, $pop30
	i64.const	$push28=, 32
	i64.shr_u	$push5=, $pop29, $pop28
	i64.store8	a+4($pop35), $pop5
	i32.const	$push27=, 0
	i64.const	$push6=, 2147483648
	i64.or  	$push7=, $1, $pop6
	i64.store32	a($pop27), $pop7
	i32.const	$push26=, 0
	i32.const	$push25=, 0
	i32.store8	b+4($pop26), $pop25
	i32.const	$push24=, 0
	i32.const	$push23=, 0
	i32.store	b($pop24):p2align=0, $pop23
	i32.const	$push22=, 0
	i32.const	$push21=, 0
	i32.store	e($pop22), $pop21
	block   	
	i32.const	$push20=, 0
	i32.load	$push8=, d($pop20)
	i32.eqz 	$push44=, $pop8
	br_if   	0, $pop44       # 0: down to label2
# BB#1:                                 # %if.then.i.i
	i32.const	$push37=, 0
	i64.const	$push9=, 33
	i64.shl 	$push10=, $0, $pop9
	i64.const	$push36=, 33
	i64.shr_s	$push11=, $pop10, $pop36
	i64.store32	c($pop37), $pop11
.LBB3_2:                                # %baz.exit
	end_block                       # label2:
	i32.const	$push43=, 0
	i32.const	$push42=, 0
	i32.load8_u	$push12=, b+4($pop42)
	i32.store8	a+4($pop43), $pop12
	i32.const	$push41=, 0
	i32.const	$push40=, 0
	i32.load	$push13=, b($pop40):p2align=0
	i32.store	a($pop41), $pop13
	block   	
	i32.const	$push39=, 0
	i64.load32_u	$push14=, a($pop39)
	i64.const	$push15=, 33
	i64.shl 	$push16=, $pop14, $pop15
	i64.const	$push38=, 33
	i64.shr_s	$push17=, $pop16, $pop38
	i32.wrap/i64	$push18=, $pop17
	br_if   	0, $pop18       # 0: down to label3
# BB#3:                                 # %if.end
	i32.const	$push19=, 0
	return  	$pop19
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
