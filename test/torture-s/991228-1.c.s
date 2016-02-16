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
	i32.sub 	$6=, $2, $3
	i32.const	$3=, __stack_pointer
	i32.store	$6=, 0($3), $6
	i32.const	$push0=, 0
	i32.load	$1=, endianness_test($pop0):p2align=3
	f64.store	$discard=, 8($6), $0
	i32.const	$push1=, 2
	i32.shl 	$push2=, $1, $pop1
	i32.const	$5=, 8
	i32.add 	$5=, $6, $5
	i32.add 	$push3=, $5, $pop2
	i32.load	$push4=, 0($pop3)
	i32.const	$push5=, 31
	i32.shr_u	$push6=, $pop4, $pop5
	i32.const	$4=, 16
	i32.add 	$6=, $6, $4
	i32.const	$4=, __stack_pointer
	i32.store	$6=, 0($4), $6
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
	.local  	i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$4=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	block
	i32.const	$push12=, 0
	i32.load	$push0=, endianness_test($pop12):p2align=3
	i32.const	$push1=, 2
	i32.shl 	$push11=, $pop0, $pop1
	tee_local	$push10=, $0=, $pop11
	i32.load	$push2=, u($pop10)
	i32.const	$push9=, 0
	i32.lt_s	$push3=, $pop2, $pop9
	br_if   	0, $pop3        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push13=, 0
	call    	exit@FUNCTION, $pop13
	unreachable
.LBB1_2:                                # %if.end
	end_block                       # label0:
	i64.const	$push4=, -4625196817309499392
	i64.store	$discard=, 8($4), $pop4
	i32.const	$3=, 8
	i32.add 	$3=, $4, $3
	block
	i32.add 	$push5=, $3, $0
	i32.load	$push6=, 0($pop5)
	i32.const	$push14=, 0
	i32.lt_s	$push7=, $pop6, $pop14
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
