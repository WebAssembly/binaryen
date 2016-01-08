	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/921029-1.c"
	.section	.text.build,"ax",@progbits
	.hidden	build
	.globl	build
	.type	build,@function
build:                                  # @build
	.param  	i32, i32
	.result 	i64
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	i64.extend_u/i32	$push0=, $0
	i64.const	$push1=, 32
	i64.shl 	$push2=, $pop0, $pop1
	i64.store	$push3=, hpart($2), $pop2
	i64.extend_u/i32	$push4=, $1
	i64.store	$push5=, lpart($2), $pop4
	i64.or  	$push6=, $pop3, $pop5
	i64.store	$push7=, back($2), $pop6
	return  	$pop7
.Lfunc_end0:
	.size	build, .Lfunc_end0-build

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end44
	i32.const	$0=, 0
	i64.const	$push0=, -4294967296
	i64.store	$discard=, hpart($0), $pop0
	i64.const	$push1=, 4294967294
	i64.store	$discard=, lpart($0), $pop1
	i64.const	$push2=, -2
	i64.store	$discard=, back($0), $pop2
	call    	exit, $0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	hpart                   # @hpart
	.type	hpart,@object
	.section	.bss.hpart,"aw",@nobits
	.globl	hpart
	.align	3
hpart:
	.int64	0                       # 0x0
	.size	hpart, 8

	.hidden	lpart                   # @lpart
	.type	lpart,@object
	.section	.bss.lpart,"aw",@nobits
	.globl	lpart
	.align	3
lpart:
	.int64	0                       # 0x0
	.size	lpart, 8

	.hidden	back                    # @back
	.type	back,@object
	.section	.bss.back,"aw",@nobits
	.globl	back
	.align	3
back:
	.int64	0                       # 0x0
	.size	back, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
