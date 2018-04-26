	.text
	.file	"921029-1.c"
	.section	.text.build,"ax",@progbits
	.hidden	build                   # -- Begin function build
	.globl	build
	.type	build,@function
build:                                  # @build
	.param  	i32, i32
	.result 	i64
	.local  	i64, i64
# %bb.0:                                # %entry
	i64.extend_u/i32	$2=, $1
	i32.const	$push0=, 0
	i64.store	lpart($pop0), $2
	i64.extend_u/i32	$push1=, $0
	i64.const	$push2=, 32
	i64.shl 	$3=, $pop1, $pop2
	i32.const	$push4=, 0
	i64.store	hpart($pop4), $3
	i64.or  	$2=, $3, $2
	i32.const	$push3=, 0
	i64.store	back($pop3), $2
	copy_local	$push5=, $2
                                        # fallthrough-return: $pop5
	.endfunc
.Lfunc_end0:
	.size	build, .Lfunc_end0-build
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end44
	i32.const	$push1=, 0
	i64.const	$push0=, 4294967294
	i64.store	lpart($pop1), $pop0
	i32.const	$push6=, 0
	i64.const	$push2=, -4294967296
	i64.store	hpart($pop6), $pop2
	i32.const	$push5=, 0
	i64.const	$push3=, -2
	i64.store	back($pop5), $pop3
	i32.const	$push4=, 0
	call    	exit@FUNCTION, $pop4
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.hidden	hpart                   # @hpart
	.type	hpart,@object
	.section	.bss.hpart,"aw",@nobits
	.globl	hpart
	.p2align	3
hpart:
	.int64	0                       # 0x0
	.size	hpart, 8

	.hidden	lpart                   # @lpart
	.type	lpart,@object
	.section	.bss.lpart,"aw",@nobits
	.globl	lpart
	.p2align	3
lpart:
	.int64	0                       # 0x0
	.size	lpart, 8

	.hidden	back                    # @back
	.type	back,@object
	.section	.bss.back,"aw",@nobits
	.globl	back
	.p2align	3
back:
	.int64	0                       # 0x0
	.size	back, 8


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
	.functype	exit, void, i32
