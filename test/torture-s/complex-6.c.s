	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/complex-6.c"
	.section	.text.ctest_float,"ax",@progbits
	.hidden	ctest_float
	.globl	ctest_float
	.type	ctest_float,@function
ctest_float:                            # @ctest_float
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($1)
	i32.store	0($0), $pop0
	f32.load	$push1=, 4($1)
	f32.neg 	$push2=, $pop1
	f32.store	4($0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	ctest_float, .Lfunc_end0-ctest_float

	.section	.text.test_float,"ax",@progbits
	.hidden	test_float
	.globl	test_float
	.type	test_float,@function
test_float:                             # @test_float
# BB#0:                                 # %if.end
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	test_float, .Lfunc_end1-test_float

	.section	.text.ctest_double,"ax",@progbits
	.hidden	ctest_double
	.globl	ctest_double
	.type	ctest_double,@function
ctest_double:                           # @ctest_double
	.param  	i32, i32
# BB#0:                                 # %entry
	i64.load	$push0=, 0($1)
	i64.store	0($0), $pop0
	f64.load	$push1=, 8($1)
	f64.neg 	$push2=, $pop1
	f64.store	8($0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	ctest_double, .Lfunc_end2-ctest_double

	.section	.text.test_double,"ax",@progbits
	.hidden	test_double
	.globl	test_double
	.type	test_double,@function
test_double:                            # @test_double
# BB#0:                                 # %if.end
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	test_double, .Lfunc_end3-test_double

	.section	.text.ctest_long_double,"ax",@progbits
	.hidden	ctest_long_double
	.globl	ctest_long_double
	.type	ctest_long_double,@function
ctest_long_double:                      # @ctest_long_double
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push18=, 0
	i32.const	$push15=, 0
	i32.load	$push16=, __stack_pointer($pop15)
	i32.const	$push17=, 16
	i32.sub 	$push26=, $pop16, $pop17
	tee_local	$push25=, $2=, $pop26
	i32.store	__stack_pointer($pop18), $pop25
	i64.const	$push5=, 0
	i64.const	$push4=, -9223372036854775808
	i64.load	$push3=, 16($1)
	i32.const	$push0=, 24
	i32.add 	$push1=, $1, $pop0
	i64.load	$push2=, 0($pop1)
	call    	__subtf3@FUNCTION, $2, $pop5, $pop4, $pop3, $pop2
	i64.load	$push6=, 0($1)
	i64.store	0($0), $pop6
	i32.const	$push7=, 8
	i32.add 	$push8=, $0, $pop7
	i32.const	$push24=, 8
	i32.add 	$push9=, $1, $pop24
	i64.load	$push10=, 0($pop9)
	i64.store	0($pop8), $pop10
	i32.const	$push23=, 24
	i32.add 	$push11=, $0, $pop23
	i32.const	$push22=, 8
	i32.add 	$push12=, $2, $pop22
	i64.load	$push13=, 0($pop12)
	i64.store	0($pop11), $pop13
	i64.load	$push14=, 0($2)
	i64.store	16($0), $pop14
	i32.const	$push21=, 0
	i32.const	$push19=, 16
	i32.add 	$push20=, $2, $pop19
	i32.store	__stack_pointer($pop21), $pop20
                                        # fallthrough-return
	.endfunc
.Lfunc_end4:
	.size	ctest_long_double, .Lfunc_end4-ctest_long_double

	.section	.text.test_long_double,"ax",@progbits
	.hidden	test_long_double
	.globl	test_long_double
	.type	test_long_double,@function
test_long_double:                       # @test_long_double
# BB#0:                                 # %if.end
                                        # fallthrough-return
	.endfunc
.Lfunc_end5:
	.size	test_long_double, .Lfunc_end5-test_long_double

	.section	.text.ctest_int,"ax",@progbits
	.hidden	ctest_int
	.globl	ctest_int
	.type	ctest_int,@function
ctest_int:                              # @ctest_int
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($1)
	i32.store	0($0), $pop0
	i32.const	$push2=, 0
	i32.load	$push1=, 4($1)
	i32.sub 	$push3=, $pop2, $pop1
	i32.store	4($0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end6:
	.size	ctest_int, .Lfunc_end6-ctest_int

	.section	.text.test_int,"ax",@progbits
	.hidden	test_int
	.globl	test_int
	.type	test_int,@function
test_int:                               # @test_int
# BB#0:                                 # %if.end
                                        # fallthrough-return
	.endfunc
.Lfunc_end7:
	.size	test_int, .Lfunc_end7-test_int

	.section	.text.ctest_long_int,"ax",@progbits
	.hidden	ctest_long_int
	.globl	ctest_long_int
	.type	ctest_long_int,@function
ctest_long_int:                         # @ctest_long_int
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.load	$push0=, 0($1)
	i32.store	0($0), $pop0
	i32.const	$push2=, 0
	i32.load	$push1=, 4($1)
	i32.sub 	$push3=, $pop2, $pop1
	i32.store	4($0), $pop3
                                        # fallthrough-return
	.endfunc
.Lfunc_end8:
	.size	ctest_long_int, .Lfunc_end8-ctest_long_int

	.section	.text.test_long_int,"ax",@progbits
	.hidden	test_long_int
	.globl	test_long_int
	.type	test_long_int,@function
test_long_int:                          # @test_long_int
# BB#0:                                 # %if.end
                                        # fallthrough-return
	.endfunc
.Lfunc_end9:
	.size	test_long_int, .Lfunc_end9-test_long_int

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	i32.const	$push2=, 0
	i32.store	err($pop0), $pop2
	i32.const	$push1=, 0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end10:
	.size	main, .Lfunc_end10-main

	.hidden	err                     # @err
	.type	err,@object
	.section	.bss.err,"aw",@nobits
	.globl	err
	.p2align	2
err:
	.int32	0                       # 0x0
	.size	err, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
