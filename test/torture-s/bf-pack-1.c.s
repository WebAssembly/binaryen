	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/bf-pack-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
	.result 	i32
	.local  	i64
# BB#0:                                 # %entry
	block   	.LBB0_4
	i32.const	$push0=, 4
	i32.add 	$push1=, $0, $pop0
	i64.load32_u	$push2=, 0($pop1)
	i64.const	$push3=, 32
	i64.shl 	$push4=, $pop2, $pop3
	i64.load32_u	$push5=, 0($0)
	i64.or  	$1=, $pop4, $pop5
	i64.const	$push6=, 65535
	i64.and 	$push7=, $1, $pop6
	i64.const	$push8=, 4660
	i64.ne  	$push9=, $pop7, $pop8
	br_if   	$pop9, .LBB0_4
# BB#1:                                 # %if.end
	block   	.LBB0_3
	i64.const	$push10=, 281474976645120
	i64.and 	$push11=, $1, $pop10
	i64.const	$push12=, 95075992076288
	i64.ne  	$push13=, $pop11, $pop12
	br_if   	$pop13, .LBB0_3
# BB#2:                                 # %if.end6
	return  	$0
.LBB0_3:                                # %if.then5
	call    	abort
	unreachable
.LBB0_4:                                # %if.then
	call    	abort
	unreachable
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %f.exit
	i32.const	$push0=, 0
	call    	exit, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
