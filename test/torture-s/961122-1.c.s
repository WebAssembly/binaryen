	.text
	.file	"/b/build/slave/linux/build/src/buildbot/work/gcc/gcc/testsuite/gcc.c-torture/execute/961122-1.c"
	.globl	addhi
	.type	addhi,@function
addhi:                                  # @addhi
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i64.load	$push3=, acc($1)
	i64.extend_u/i32	$push0=, $0
	i64.const	$push1=, 32
	i64.shl 	$push2=, $pop0, $pop1
	i64.add 	$push4=, $pop3, $pop2
	i64.store	$discard=, acc($1), $pop4
	return  	$1
.Lfunc_end0:
	.size	addhi, .Lfunc_end0-addhi

	.globl	subhi
	.type	subhi,@function
subhi:                                  # @subhi
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, 0
	i64.load	$push3=, acc($1)
	i64.extend_u/i32	$push0=, $0
	i64.const	$push1=, 32
	i64.shl 	$push2=, $pop0, $pop1
	i64.sub 	$push4=, $pop3, $pop2
	i64.store	$discard=, acc($1), $pop4
	return  	$1
.Lfunc_end1:
	.size	subhi, .Lfunc_end1-subhi

	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end4
	i32.const	$0=, 0
	i64.const	$push0=, 281470681743360
	i64.store	$discard=, acc($0), $pop0
	call    	exit, $0
	unreachable
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	acc,@object             # @acc
	.bss
	.globl	acc
	.align	3
acc:
	.int64	0                       # 0x0
	.size	acc, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
