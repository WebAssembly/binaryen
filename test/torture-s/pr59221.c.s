	.text
	.file	"pr59221.c"
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# %bb.0:                                # %entry
	block   	
	i32.const	$push11=, 0
	i32.load	$push0=, b($pop11)
	i32.eqz 	$push19=, $pop0
	br_if   	0, $pop19       # 0: down to label0
# %bb.1:                                # %for.inc.lr.ph
	i32.const	$push13=, 0
	i32.const	$push12=, 0
	i32.store	b($pop13), $pop12
.LBB0_2:                                # %for.end
	end_block                       # label0:
	i32.const	$push18=, 0
	i32.load	$0=, a($pop18)
	i32.const	$push3=, -32768
	i32.const	$push1=, 65535
	i32.and 	$push2=, $0, $pop1
	i32.select	$0=, $0, $pop3, $pop2
	i32.const	$push17=, 0
	i32.store16	e($pop17), $0
	i32.const	$push16=, 0
	i32.const	$push4=, 16
	i32.shl 	$push5=, $0, $pop4
	i32.const	$push15=, 16
	i32.shr_s	$push6=, $pop5, $pop15
	i32.store	d($pop16), $pop6
	block   	
	i32.const	$push14=, 65535
	i32.and 	$push7=, $0, $pop14
	i32.const	$push8=, 1
	i32.ne  	$push9=, $pop7, $pop8
	br_if   	0, $pop9        # 0: down to label1
# %bb.3:                                # %if.end
	i32.const	$push10=, 0
	return  	$pop10
.LBB0_4:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        # -- End function
	.hidden	a                       # @a
	.type	a,@object
	.section	.data.a,"aw",@progbits
	.globl	a
	.p2align	2
a:
	.int32	1                       # 0x1
	.size	a, 4

	.hidden	b                       # @b
	.type	b,@object
	.section	.bss.b,"aw",@nobits
	.globl	b
	.p2align	2
b:
	.int32	0                       # 0x0
	.size	b, 4

	.hidden	e                       # @e
	.type	e,@object
	.section	.bss.e,"aw",@nobits
	.globl	e
	.p2align	1
e:
	.int16	0                       # 0x0
	.size	e, 2

	.hidden	d                       # @d
	.type	d,@object
	.section	.bss.d,"aw",@nobits
	.globl	d
	.p2align	2
d:
	.int32	0                       # 0x0
	.size	d, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	abort, void
