	.text
	.file	"pr29695-2.c"
	.section	.text.f1,"ax",@progbits
	.hidden	f1                      # -- Begin function f1
	.globl	f1
	.type	f1,@function
f1:                                     # @f1
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load	$push1=, a($pop0)
	i32.const	$push2=, 128
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end0:
	.size	f1, .Lfunc_end0-f1
                                        # -- End function
	.section	.text.f2,"ax",@progbits
	.hidden	f2                      # -- Begin function f2
	.globl	f2
	.type	f2,@function
f2:                                     # @f2
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load8_u	$push1=, b($pop0)
	i32.const	$push2=, 128
	i32.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	f2, .Lfunc_end1-f2
                                        # -- End function
	.section	.text.f3,"ax",@progbits
	.hidden	f3                      # -- Begin function f3
	.globl	f3
	.type	f3,@function
f3:                                     # @f3
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load8_s	$push1=, b($pop0)
	i32.const	$push2=, 31
	i32.shr_s	$push3=, $pop1, $pop2
	i32.const	$push4=, 896
	i32.and 	$push5=, $pop3, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end2:
	.size	f3, .Lfunc_end2-f3
                                        # -- End function
	.section	.text.f4,"ax",@progbits
	.hidden	f4                      # -- Begin function f4
	.globl	f4
	.type	f4,@function
f4:                                     # @f4
	.result 	i32
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i32.load8_s	$push1=, b($pop0)
	i32.const	$push2=, 31
	i32.shr_s	$push3=, $pop1, $pop2
	i32.const	$push4=, -128
	i32.and 	$push5=, $pop3, $pop4
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end3:
	.size	f4, .Lfunc_end3-f4
                                        # -- End function
	.section	.text.f5,"ax",@progbits
	.hidden	f5                      # -- Begin function f5
	.globl	f5
	.type	f5,@function
f5:                                     # @f5
	.result 	i64
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i64.load	$push1=, c($pop0)
	i64.const	$push2=, 2147483648
	i64.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end4:
	.size	f5, .Lfunc_end4-f5
                                        # -- End function
	.section	.text.f6,"ax",@progbits
	.hidden	f6                      # -- Begin function f6
	.globl	f6
	.type	f6,@function
f6:                                     # @f6
	.result 	i64
# %bb.0:                                # %entry
	i32.const	$push0=, 0
	i64.load32_u	$push1=, d($pop0)
	i64.const	$push2=, 2147483648
	i64.and 	$push3=, $pop1, $pop2
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end5:
	.size	f6, .Lfunc_end5-f6
                                        # -- End function
	.section	.text.f7,"ax",@progbits
	.hidden	f7                      # -- Begin function f7
	.globl	f7
	.type	f7,@function
f7:                                     # @f7
	.result 	i64
# %bb.0:                                # %entry
	i64.const	$push4=, 15032385536
	i64.const	$push3=, 0
	i32.const	$push0=, 0
	i32.load	$push1=, d($pop0)
	i32.const	$push6=, 0
	i32.lt_s	$push2=, $pop1, $pop6
	i64.select	$push5=, $pop4, $pop3, $pop2
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end6:
	.size	f7, .Lfunc_end6-f7
                                        # -- End function
	.section	.text.f8,"ax",@progbits
	.hidden	f8                      # -- Begin function f8
	.globl	f8
	.type	f8,@function
f8:                                     # @f8
	.result 	i64
# %bb.0:                                # %entry
	i64.const	$push4=, -2147483648
	i64.const	$push3=, 0
	i32.const	$push0=, 0
	i32.load	$push1=, d($pop0)
	i32.const	$push6=, 0
	i32.lt_s	$push2=, $pop1, $pop6
	i64.select	$push5=, $pop4, $pop3, $pop2
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end7:
	.size	f8, .Lfunc_end7-f8
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push10=, 0
	i32.load8_u	$push0=, a($pop10)
	i32.const	$push1=, 7
	i32.shr_u	$push2=, $pop0, $pop1
	i32.eqz 	$push17=, $pop2
	br_if   	0, $pop17       # 0: down to label0
# %bb.1:                                # %if.end
	i32.const	$push12=, 0
	i32.load8_s	$push3=, b($pop12)
	i32.const	$push11=, 0
	i32.ge_s	$push4=, $pop3, $pop11
	br_if   	0, $pop4        # 0: down to label0
# %bb.2:                                # %if.end12
	i32.const	$push14=, 0
	i32.load	$push5=, c($pop14)
	i32.const	$push13=, 0
	i32.ge_s	$push6=, $pop5, $pop13
	br_if   	0, $pop6        # 0: down to label0
# %bb.3:                                # %if.end16
	i32.const	$push16=, 0
	i32.load	$push7=, d($pop16)
	i32.const	$push15=, 0
	i32.ge_s	$push8=, $pop7, $pop15
	br_if   	0, $pop8        # 0: down to label0
# %bb.4:                                # %if.end28
	i32.const	$push9=, 0
	return  	$pop9
.LBB8_5:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end8:
	.size	main, .Lfunc_end8-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	2
a:
	.int32	128                     # 0x80
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.data.b,"aw",@progbits
	.globl	b
b:
	.int8	128                     # 0x80
	.size	b, 1

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.p2align	3
c:
	.int64	2147483648              # 0x80000000
	.size	c, 8

	.hidden	d                       # @d
	.type	d,@object
	.section	.data.d,"aw",@progbits
	.globl	d
	.p2align	2
d:
	.int32	2147483648              # 0x80000000
	.size	d, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
