	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/921029-1.c"
	.section	.text.build,"ax",@progbits
	.hidden	build
	.globl	build
	.type	build,@function
build:                                  # @build
	.param  	i32, i32
	.result 	i64
	.local  	i64, i64
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i64.extend_u/i32	$push10=, $1
	tee_local	$push9=, $2=, $pop10
	i64.store	lpart($pop0), $pop9
	i32.const	$push8=, 0
	i64.extend_u/i32	$push1=, $0
	i64.const	$push2=, 32
	i64.shl 	$push7=, $pop1, $pop2
	tee_local	$push6=, $3=, $pop7
	i64.store	hpart($pop8), $pop6
	i32.const	$push5=, 0
	i64.or  	$push4=, $3, $2
	tee_local	$push3=, $2=, $pop4
	i64.store	back($pop5), $pop3
	copy_local	$push11=, $2
                                        # fallthrough-return: $pop11
	.endfunc
.Lfunc_end0:
	.size	build, .Lfunc_end0-build

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end44
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
