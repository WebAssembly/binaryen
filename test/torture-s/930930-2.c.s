	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930930-2.c"
	.section	.text.test_endianness,"ax",@progbits
	.hidden	test_endianness
	.globl	test_endianness
	.type	test_endianness,@function
test_endianness:                        # @test_endianness
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end0:
	.size	test_endianness, .Lfunc_end0-test_endianness

	.section	.text.test_endianness_vol,"ax",@progbits
	.hidden	test_endianness_vol
	.globl	test_endianness_vol
	.type	test_endianness_vol,@function
test_endianness_vol:                    # @test_endianness_vol
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push4=, 0
	i32.load	$push5=, __stack_pointer($pop4)
	i32.const	$push6=, 16
	i32.sub 	$push8=, $pop5, $pop6
	tee_local	$push7=, $0=, $pop8
	i64.const	$push0=, 4621819117588971520
	i64.store	8($pop7), $pop0
	i32.load	$push2=, 8($0)
	i32.const	$push1=, 0
	i32.ne  	$push3=, $pop2, $pop1
                                        # fallthrough-return: $pop3
	.endfunc
.Lfunc_end1:
	.size	test_endianness_vol, .Lfunc_end1-test_endianness_vol

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push6=, 0
	i32.const	$push3=, 0
	i32.load	$push4=, __stack_pointer($pop3)
	i32.const	$push5=, 16
	i32.sub 	$push8=, $pop4, $pop5
	tee_local	$push7=, $0=, $pop8
	i32.store	__stack_pointer($pop6), $pop7
	i64.const	$push0=, 4621819117588971520
	i64.store	8($0), $pop0
	block   	
	i32.load	$push1=, 8($0)
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push2=, 0
	call    	exit@FUNCTION, $pop2
	unreachable
.LBB2_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
