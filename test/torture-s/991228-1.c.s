	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/991228-1.c"
	.section	.text.signbit,"ax",@progbits
	.hidden	signbit
	.globl	signbit
	.type	signbit,@function
signbit:                                # @signbit
	.param  	f64
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	i32.load	$1=, endianness_test($pop0)
	i32.const	$push7=, __stack_pointer
	i32.load	$push8=, 0($pop7)
	i32.const	$push9=, 16
	i32.sub 	$push13=, $pop8, $pop9
	tee_local	$push12=, $2=, $pop13
	f64.store	$discard=, 8($pop12), $0
	i32.const	$push10=, 8
	i32.add 	$push11=, $2, $pop10
	i32.const	$push1=, 2
	i32.shl 	$push2=, $1, $pop1
	i32.add 	$push3=, $pop11, $pop2
	i32.load	$push4=, 0($pop3)
	i32.const	$push5=, 31
	i32.shr_u	$push6=, $pop4, $pop5
	return  	$pop6
	.endfunc
.Lfunc_end0:
	.size	signbit, .Lfunc_end0-signbit

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push12=, __stack_pointer
	i32.const	$push9=, __stack_pointer
	i32.load	$push10=, 0($pop9)
	i32.const	$push11=, 16
	i32.sub 	$push15=, $pop10, $pop11
	i32.store	$0=, 0($pop12), $pop15
	block
	i32.const	$push19=, 0
	i32.load	$push0=, endianness_test($pop19)
	i32.const	$push1=, 2
	i32.shl 	$push18=, $pop0, $pop1
	tee_local	$push17=, $1=, $pop18
	i32.load	$push2=, u($pop17)
	i32.const	$push16=, 0
	i32.lt_s	$push3=, $pop2, $pop16
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push20=, 0
	call    	exit@FUNCTION, $pop20
	unreachable
.LBB1_2:                                # %if.end
	end_block                       # label0:
	i64.const	$push4=, -4625196817309499392
	i64.store	$discard=, 8($0), $pop4
	block
	i32.const	$push13=, 8
	i32.add 	$push14=, $0, $pop13
	i32.add 	$push5=, $pop14, $1
	i32.load	$push6=, 0($pop5)
	i32.const	$push21=, 0
	i32.lt_s	$push7=, $pop6, $pop21
	br_if   	0, $pop7        # 0: down to label1
# BB#3:                                 # %if.then1
	call    	abort@FUNCTION
	unreachable
.LBB1_4:                                # %if.end2
	end_block                       # label1:
	i32.const	$push8=, 0
	call    	exit@FUNCTION, $pop8
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.hidden	u                       # @u
	.type	u,@object
	.section	.data.u,"aw",@progbits
	.globl	u
	.p2align	3
u:
	.int64	-4625196817309499392    # double -0.25
	.size	u, 8

	.hidden	endianness_test         # @endianness_test
	.type	endianness_test,@object
	.section	.data.endianness_test,"aw",@progbits
	.globl	endianness_test
	.p2align	3
endianness_test:
	.int64	1                       # 0x1
	.size	endianness_test, 8


	.ident	"clang version 3.9.0 "
