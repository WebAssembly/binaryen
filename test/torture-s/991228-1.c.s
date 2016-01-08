	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/991228-1.c"
	.section	.text.signbit,"ax",@progbits
	.hidden	signbit
	.globl	signbit
	.type	signbit,@function
signbit:                                # @signbit
	.param  	f64
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.const	$push0=, 0
	i32.load	$1=, endianness_test($pop0)
	f64.store	$discard=, 8($5), $0
	i32.const	$push1=, 2
	i32.shl 	$push2=, $1, $pop1
	i32.const	$5=, 8
	i32.add 	$5=, $5, $5
	i32.add 	$push3=, $5, $pop2
	i32.load	$push4=, 0($pop3)
	i32.const	$push5=, 31
	i32.shr_u	$push6=, $pop4, $pop5
	i32.const	$4=, 16
	i32.add 	$5=, $5, $4
	i32.const	$4=, __stack_pointer
	i32.store	$5=, 0($4), $5
	return  	$pop6
.Lfunc_end0:
	.size	signbit, .Lfunc_end0-signbit

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$2=, __stack_pointer
	i32.load	$2=, 0($2)
	i32.const	$3=, 16
	i32.sub 	$5=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	i32.const	$0=, 0
	block   	.LBB1_2
	i32.load	$push0=, endianness_test($0)
	i32.const	$push1=, 2
	i32.shl 	$1=, $pop0, $pop1
	i32.const	$push2=, u
	i32.add 	$push3=, $pop2, $1
	i32.load	$push4=, 0($pop3)
	i32.lt_s	$push5=, $pop4, $0
	br_if   	$pop5, .LBB1_2
# BB#1:                                 # %if.then
	call    	exit, $0
	unreachable
.LBB1_2:                                # %if.end
	i64.const	$push6=, -4625196817309499392
	i64.store	$discard=, 8($5), $pop6
	i32.const	$4=, 8
	i32.add 	$4=, $5, $4
	block   	.LBB1_4
	i32.add 	$push7=, $4, $1
	i32.load	$push8=, 0($pop7)
	i32.lt_s	$push9=, $pop8, $0
	br_if   	$pop9, .LBB1_4
# BB#3:                                 # %if.then1
	call    	abort
	unreachable
.LBB1_4:                                # %if.end2
	call    	exit, $0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	u                       # @u
	.type	u,@object
	.section	.data.u,"aw",@progbits
	.globl	u
	.align	3
u:
	.int64	-4625196817309499392    # double -0.25
	.size	u, 8

	.hidden	endianness_test         # @endianness_test
	.type	endianness_test,@object
	.section	.data.endianness_test,"aw",@progbits
	.globl	endianness_test
	.align	3
endianness_test:
	.int64	1                       # 0x1
	.size	endianness_test, 8


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
