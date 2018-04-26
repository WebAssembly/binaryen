	.text
	.file	"pr52979-2.c"
	.section	.text.foo,"ax",@progbits
	.hidden	foo                     # -- Begin function foo
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
# %bb.0:                                # %entry
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	foo, .Lfunc_end0-foo
                                        # -- End function
	.section	.text.bar,"ax",@progbits
	.hidden	bar                     # -- Begin function bar
	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.local  	i64, i64
# %bb.0:                                # %entry
	i32.const	$push23=, 0
	i64.load32_u	$push3=, a($pop23)
	i32.const	$push22=, 0
	i64.load8_u	$push0=, a+4($pop22)
	i64.const	$push1=, 32
	i64.shl 	$push2=, $pop0, $pop1
	i64.or  	$0=, $pop3, $pop2
	i64.const	$push4=, 964220157951
	i64.and 	$1=, $0, $pop4
	i32.const	$push21=, 0
	i64.const	$push20=, 32
	i64.shr_u	$push5=, $1, $pop20
	i64.store8	a+4($pop21), $pop5
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
	i32.eqz 	$push26=, $pop8
	br_if   	0, $pop26       # 0: down to label0
# %bb.1:                                # %if.then
	i32.const	$push25=, 0
	i64.const	$push9=, 33
	i64.shl 	$push10=, $0, $pop9
	i64.const	$push24=, 33
	i64.shr_s	$push11=, $pop10, $pop24
	i64.store32	c($pop25), $pop11
.LBB1_2:                                # %if.end
	end_block                       # label0:
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	bar, .Lfunc_end1-bar
                                        # -- End function
	.section	.text.baz,"ax",@progbits
	.hidden	baz                     # -- Begin function baz
	.globl	baz
	.type	baz,@function
baz:                                    # @baz
	.local  	i64, i64
# %bb.0:                                # %entry
	i32.const	$push25=, 0
	i64.load32_u	$push3=, a($pop25)
	i32.const	$push24=, 0
	i64.load8_u	$push0=, a+4($pop24)
	i64.const	$push1=, 32
	i64.shl 	$push2=, $pop0, $pop1
	i64.or  	$0=, $pop3, $pop2
	i64.const	$push4=, 964220157951
	i64.and 	$1=, $0, $pop4
	i32.const	$push23=, 0
	i64.const	$push22=, 32
	i64.shr_u	$push5=, $1, $pop22
	i64.store8	a+4($pop23), $pop5
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
	i32.eqz 	$push32=, $pop8
	br_if   	0, $pop32       # 0: down to label1
# %bb.1:                                # %if.then.i
	i32.const	$push27=, 0
	i64.const	$push9=, 33
	i64.shl 	$push10=, $0, $pop9
	i64.const	$push26=, 33
	i64.shr_s	$push11=, $pop10, $pop26
	i64.store32	c($pop27), $pop11
.LBB2_2:                                # %bar.exit
	end_block                       # label1:
	i32.const	$push31=, 0
	i32.const	$push30=, 0
	i32.load8_u	$push12=, b+4($pop30)
	i32.store8	a+4($pop31), $pop12
	i32.const	$push29=, 0
	i32.const	$push28=, 0
	i32.load	$push13=, b($pop28):p2align=0
	i32.store	a($pop29), $pop13
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	baz, .Lfunc_end2-baz
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i64, i64
# %bb.0:                                # %entry
	i32.const	$push31=, 0
	i64.load32_u	$push3=, a($pop31)
	i32.const	$push30=, 0
	i64.load8_u	$push0=, a+4($pop30)
	i64.const	$push1=, 32
	i64.shl 	$push2=, $pop0, $pop1
	i64.or  	$0=, $pop3, $pop2
	i64.const	$push4=, 964220157951
	i64.and 	$1=, $0, $pop4
	i32.const	$push29=, 0
	i64.const	$push28=, 32
	i64.shr_u	$push5=, $1, $pop28
	i64.store8	a+4($pop29), $pop5
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
	i32.eqz 	$push40=, $pop8
	br_if   	0, $pop40       # 0: down to label2
# %bb.1:                                # %if.then.i.i
	i32.const	$push33=, 0
	i64.const	$push9=, 33
	i64.shl 	$push10=, $0, $pop9
	i64.const	$push32=, 33
	i64.shr_s	$push11=, $pop10, $pop32
	i64.store32	c($pop33), $pop11
.LBB3_2:                                # %baz.exit
	end_block                       # label2:
	i32.const	$push39=, 0
	i32.const	$push38=, 0
	i32.load8_u	$push12=, b+4($pop38)
	i32.store8	a+4($pop39), $pop12
	i32.const	$push37=, 0
	i32.const	$push36=, 0
	i32.load	$push13=, b($pop36):p2align=0
	i32.store	a($pop37), $pop13
	block   	
	i32.const	$push35=, 0
	i64.load32_u	$push14=, a($pop35)
	i64.const	$push15=, 33
	i64.shl 	$push16=, $pop14, $pop15
	i64.const	$push34=, 33
	i64.shr_s	$push17=, $pop16, $pop34
	i32.wrap/i64	$push18=, $pop17
	br_if   	0, $pop18       # 0: down to label3
# %bb.3:                                # %if.end
	i32.const	$push19=, 0
	return  	$pop19
.LBB3_4:                                # %if.then
	end_block                       # label3:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
                                        # -- End function
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


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
