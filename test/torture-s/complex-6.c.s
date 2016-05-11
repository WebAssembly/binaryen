	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/complex-6.c"
	.section	.text.ctest_float,"ax",@progbits
	.hidden	ctest_float
	.globl	ctest_float
	.type	ctest_float,@function
ctest_float:                            # @ctest_float
	.param  	i32, i32
	.local  	f32
# BB#0:                                 # %entry
	f32.load	$2=, 4($1)
	i32.load	$push0=, 0($1)
	i32.store	$discard=, 0($0), $pop0
	f32.neg 	$push1=, $2
	f32.store	$discard=, 4($0), $pop1
	return
	.endfunc
.Lfunc_end0:
	.size	ctest_float, .Lfunc_end0-ctest_float

	.section	.text.test_float,"ax",@progbits
	.hidden	test_float
	.globl	test_float
	.type	test_float,@function
test_float:                             # @test_float
# BB#0:                                 # %if.end
	return
	.endfunc
.Lfunc_end1:
	.size	test_float, .Lfunc_end1-test_float

	.section	.text.ctest_double,"ax",@progbits
	.hidden	ctest_double
	.globl	ctest_double
	.type	ctest_double,@function
ctest_double:                           # @ctest_double
	.param  	i32, i32
	.local  	f64
# BB#0:                                 # %entry
	f64.load	$2=, 8($1)
	i64.load	$push0=, 0($1)
	i64.store	$discard=, 0($0), $pop0
	f64.neg 	$push1=, $2
	f64.store	$discard=, 8($0), $pop1
	return
	.endfunc
.Lfunc_end2:
	.size	ctest_double, .Lfunc_end2-ctest_double

	.section	.text.test_double,"ax",@progbits
	.hidden	test_double
	.globl	test_double
	.type	test_double,@function
test_double:                            # @test_double
# BB#0:                                 # %if.end
	return
	.endfunc
.Lfunc_end3:
	.size	test_double, .Lfunc_end3-test_double

	.section	.text.ctest_long_double,"ax",@progbits
	.hidden	ctest_long_double
	.globl	ctest_long_double
	.type	ctest_long_double,@function
ctest_long_double:                      # @ctest_long_double
	.param  	i32, i32
	.local  	i32, i64, i64, i64, i64
# BB#0:                                 # %entry
	i32.const	$push14=, __stack_pointer
	i32.const	$push11=, __stack_pointer
	i32.load	$push12=, 0($pop11)
	i32.const	$push13=, 16
	i32.sub 	$push18=, $pop12, $pop13
	i32.store	$2=, 0($pop14), $pop18
	i32.const	$push0=, 8
	i32.add 	$push1=, $1, $pop0
	i64.load	$3=, 0($pop1)
	i64.load	$4=, 0($1)
	i64.const	$push7=, 0
	i64.const	$push6=, -9223372036854775808
	i64.load	$push5=, 16($1)
	i32.const	$push2=, 24
	i32.add 	$push3=, $1, $pop2
	i64.load	$push4=, 0($pop3)
	call    	__subtf3@FUNCTION, $2, $pop7, $pop6, $pop5, $pop4
	i32.const	$push21=, 8
	i32.add 	$push8=, $2, $pop21
	i64.load	$5=, 0($pop8)
	i64.load	$6=, 0($2)
	i64.store	$discard=, 0($0), $4
	i32.const	$push20=, 8
	i32.add 	$push9=, $0, $pop20
	i64.store	$discard=, 0($pop9), $3
	i32.const	$push19=, 24
	i32.add 	$push10=, $0, $pop19
	i64.store	$discard=, 0($pop10), $5
	i64.store	$discard=, 16($0), $6
	i32.const	$push17=, __stack_pointer
	i32.const	$push15=, 16
	i32.add 	$push16=, $2, $pop15
	i32.store	$discard=, 0($pop17), $pop16
	return
	.endfunc
.Lfunc_end4:
	.size	ctest_long_double, .Lfunc_end4-ctest_long_double

	.section	.text.test_long_double,"ax",@progbits
	.hidden	test_long_double
	.globl	test_long_double
	.type	test_long_double,@function
test_long_double:                       # @test_long_double
# BB#0:                                 # %if.end
	return
	.endfunc
.Lfunc_end5:
	.size	test_long_double, .Lfunc_end5-test_long_double

	.section	.text.ctest_int,"ax",@progbits
	.hidden	ctest_int
	.globl	ctest_int
	.type	ctest_int,@function
ctest_int:                              # @ctest_int
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$2=, 4($1)
	i32.load	$push0=, 0($1)
	i32.store	$discard=, 0($0), $pop0
	i32.const	$push1=, 0
	i32.sub 	$push2=, $pop1, $2
	i32.store	$discard=, 4($0), $pop2
	return
	.endfunc
.Lfunc_end6:
	.size	ctest_int, .Lfunc_end6-ctest_int

	.section	.text.test_int,"ax",@progbits
	.hidden	test_int
	.globl	test_int
	.type	test_int,@function
test_int:                               # @test_int
# BB#0:                                 # %if.end
	return
	.endfunc
.Lfunc_end7:
	.size	test_int, .Lfunc_end7-test_int

	.section	.text.ctest_long_int,"ax",@progbits
	.hidden	ctest_long_int
	.globl	ctest_long_int
	.type	ctest_long_int,@function
ctest_long_int:                         # @ctest_long_int
	.param  	i32, i32
	.local  	i32
# BB#0:                                 # %entry
	i32.load	$2=, 4($1)
	i32.load	$push0=, 0($1)
	i32.store	$discard=, 0($0), $pop0
	i32.const	$push1=, 0
	i32.sub 	$push2=, $pop1, $2
	i32.store	$discard=, 4($0), $pop2
	return
	.endfunc
.Lfunc_end8:
	.size	ctest_long_int, .Lfunc_end8-ctest_long_int

	.section	.text.test_long_int,"ax",@progbits
	.hidden	test_long_int
	.globl	test_long_int
	.type	test_long_int,@function
test_long_int:                          # @test_long_int
# BB#0:                                 # %if.end
	return
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
	i32.const	$push1=, 0
	i32.const	$push2=, 0
	i32.store	$push0=, err($pop1), $pop2
	return  	$pop0
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


	.ident	"clang version 3.9.0 "
