	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/921029-1.c"
	.section	.text.build,"ax",@progbits
	.hidden	build
	.globl	build
	.type	build,@function
build:                                  # @build
	.param  	i32, i32
	.result 	i64
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.const	$push10=, 0
	i64.extend_u/i32	$push3=, $1
	i64.store	$push0=, lpart($pop10), $pop3
	i32.const	$push9=, 0
	i64.extend_u/i32	$push5=, $0
	i64.const	$push6=, 32
	i64.shl 	$push7=, $pop5, $pop6
	i64.store	$push1=, hpart($pop9), $pop7
	i64.or  	$push8=, $pop0, $pop1
	i64.store	$push2=, back($pop4), $pop8
                                        # fallthrough-return: $pop2
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
	i64.store	$drop=, lpart($pop1), $pop0
	i32.const	$push6=, 0
	i64.const	$push2=, -4294967296
	i64.store	$drop=, hpart($pop6), $pop2
	i32.const	$push5=, 0
	i64.const	$push3=, -2
	i64.store	$drop=, back($pop5), $pop3
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


	.ident	"clang version 3.9.0 "
	.functype	exit, void, i32
