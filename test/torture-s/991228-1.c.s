	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/991228-1.c"
	.section	.text.signbit,"ax",@progbits
	.hidden	signbit
	.globl	signbit
	.type	signbit,@function
signbit:                                # @signbit
	.param  	f64
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push8=, 0
	i32.load	$push9=, __stack_pointer($pop8)
	i32.const	$push10=, 16
	i32.sub 	$push14=, $pop9, $pop10
	tee_local	$push13=, $1=, $pop14
	f64.store	8($pop13), $0
	i32.const	$push11=, 8
	i32.add 	$push12=, $1, $pop11
	i32.const	$push0=, 0
	i32.load	$push1=, endianness_test($pop0)
	i32.const	$push2=, 2
	i32.shl 	$push3=, $pop1, $pop2
	i32.add 	$push4=, $pop12, $pop3
	i32.load	$push5=, 0($pop4)
	i32.const	$push6=, 31
	i32.shr_u	$push7=, $pop5, $pop6
                                        # fallthrough-return: $pop7
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
	i32.const	$push14=, 0
	i32.const	$push11=, 0
	i32.load	$push12=, __stack_pointer($pop11)
	i32.const	$push13=, 16
	i32.sub 	$push22=, $pop12, $pop13
	tee_local	$push21=, $1=, $pop22
	i32.store	__stack_pointer($pop14), $pop21
	block   	
	i32.const	$push20=, 0
	i32.load	$push0=, endianness_test($pop20)
	i32.const	$push1=, 2
	i32.shl 	$push19=, $pop0, $pop1
	tee_local	$push18=, $0=, $pop19
	i32.const	$push2=, u
	i32.add 	$push3=, $pop18, $pop2
	i32.load	$push4=, 0($pop3)
	i32.const	$push17=, 0
	i32.lt_s	$push5=, $pop4, $pop17
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.then
	i32.const	$push23=, 0
	call    	exit@FUNCTION, $pop23
	unreachable
.LBB1_2:                                # %if.end
	end_block                       # label0:
	i64.const	$push6=, -4625196817309499392
	i64.store	8($1), $pop6
	block   	
	i32.const	$push15=, 8
	i32.add 	$push16=, $1, $pop15
	i32.add 	$push7=, $pop16, $0
	i32.load	$push8=, 0($pop7)
	i32.const	$push24=, 0
	i32.lt_s	$push9=, $pop8, $pop24
	br_if   	0, $pop9        # 0: down to label1
# BB#3:                                 # %if.then1
	call    	abort@FUNCTION
	unreachable
.LBB1_4:                                # %if.end2
	end_block                       # label1:
	i32.const	$push10=, 0
	call    	exit@FUNCTION, $pop10
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	exit, void, i32
	.functype	abort, void
