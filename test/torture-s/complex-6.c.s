	.text
	.file	"complex-6.c"
	.section	.text.ctest_float,"ax",@progbits
	.hidden	ctest_float             # -- Begin function ctest_float
	.globl	ctest_float
	.type	ctest_float,@function
ctest_float:                            # @ctest_float
	.param  	i32, i32
# %bb.0:                                # %entry
	i32.load	$push0=, 0($1)
	i32.store	0($0), $pop0
	f32.load	$push1=, 4($1)
	f32.neg 	$push2=, $pop1
	f32.store	4($0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end0:
	.size	ctest_float, .Lfunc_end0-ctest_float
                                        # -- End function
	.section	.text.test_float,"ax",@progbits
	.hidden	test_float              # -- Begin function test_float
	.globl	test_float
	.type	test_float,@function
test_float:                             # @test_float
# %bb.0:                                # %if.end
                                        # fallthrough-return
	.endfunc
.Lfunc_end1:
	.size	test_float, .Lfunc_end1-test_float
                                        # -- End function
	.section	.text.ctest_double,"ax",@progbits
	.hidden	ctest_double            # -- Begin function ctest_double
	.globl	ctest_double
	.type	ctest_double,@function
ctest_double:                           # @ctest_double
	.param  	i32, i32
# %bb.0:                                # %entry
	i64.load	$push0=, 0($1)
	i64.store	0($0), $pop0
	f64.load	$push1=, 8($1)
	f64.neg 	$push2=, $pop1
	f64.store	8($0), $pop2
                                        # fallthrough-return
	.endfunc
.Lfunc_end2:
	.size	ctest_double, .Lfunc_end2-ctest_double
                                        # -- End function
	.section	.text.test_double,"ax",@progbits
	.hidden	test_double             # -- Begin function test_double
	.globl	test_double
	.type	test_double,@function
test_double:                            # @test_double
# %bb.0:                                # %if.end
                                        # fallthrough-return
	.endfunc
.Lfunc_end3:
	.size	test_double, .Lfunc_end3-test_double
                                        # -- End function
	.section	.text.ctest_long_double,"ax",@progbits
	.hidden	ctest_long_double       # -- Begin function ctest_long_double
	.globl	ctest_long_double
	.type	ctest_long_double,@function
ctest_long_double:                      # @ctest_long_double
	.param  	i32, i32
	.local  	i32
# %bb.0:                                # %entry
	i32.const	$push15=, 0
	i32.load	$push14=, __stack_pointer($pop15)
	i32.const	$push16=, 16
	i32.sub 	$2=, $pop14, $pop16
	i32.const	$push17=, 0
	i32.store	__stack_pointer($pop17), $2
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
	i32.add 	$push8=, $1, $pop7
	i64.load	$push9=, 0($pop8)
	i64.store	8($0), $pop9
	i32.const	$push22=, 24
	i32.add 	$push10=, $0, $pop22
	i32.const	$push21=, 8
	i32.add 	$push11=, $2, $pop21
	i64.load	$push12=, 0($pop11)
	i64.store	0($pop10), $pop12
	i64.load	$push13=, 0($2)
	i64.store	16($0), $pop13
	i32.const	$push20=, 0
	i32.const	$push18=, 16
	i32.add 	$push19=, $2, $pop18
	i32.store	__stack_pointer($pop20), $pop19
                                        # fallthrough-return
	.endfunc
.Lfunc_end4:
	.size	ctest_long_double, .Lfunc_end4-ctest_long_double
                                        # -- End function
	.section	.text.test_long_double,"ax",@progbits
	.hidden	test_long_double        # -- Begin function test_long_double
	.globl	test_long_double
	.type	test_long_double,@function
test_long_double:                       # @test_long_double
# %bb.0:                                # %if.end
                                        # fallthrough-return
	.endfunc
.Lfunc_end5:
	.size	test_long_double, .Lfunc_end5-test_long_double
                                        # -- End function
	.section	.text.ctest_int,"ax",@progbits
	.hidden	ctest_int               # -- Begin function ctest_int
	.globl	ctest_int
	.type	ctest_int,@function
ctest_int:                              # @ctest_int
	.param  	i32, i32
# %bb.0:                                # %entry
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
                                        # -- End function
	.section	.text.test_int,"ax",@progbits
	.hidden	test_int                # -- Begin function test_int
	.globl	test_int
	.type	test_int,@function
test_int:                               # @test_int
# %bb.0:                                # %if.end
                                        # fallthrough-return
	.endfunc
.Lfunc_end7:
	.size	test_int, .Lfunc_end7-test_int
                                        # -- End function
	.section	.text.ctest_long_int,"ax",@progbits
	.hidden	ctest_long_int          # -- Begin function ctest_long_int
	.globl	ctest_long_int
	.type	ctest_long_int,@function
ctest_long_int:                         # @ctest_long_int
	.param  	i32, i32
# %bb.0:                                # %entry
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
                                        # -- End function
	.section	.text.test_long_int,"ax",@progbits
	.hidden	test_long_int           # -- Begin function test_long_int
	.globl	test_long_int
	.type	test_long_int,@function
test_long_int:                          # @test_long_int
# %bb.0:                                # %if.end
                                        # fallthrough-return
	.endfunc
.Lfunc_end9:
	.size	test_long_int, .Lfunc_end9-test_long_int
                                        # -- End function
	.section	.text.main,"ax",@progbits
	.hidden	main                    # -- Begin function main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# %bb.0:                                # %if.end
	i32.const	$push0=, 0
	i32.const	$push2=, 0
	i32.store	err($pop0), $pop2
	i32.const	$push1=, 0
                                        # fallthrough-return: $pop1
	.endfunc
.Lfunc_end10:
	.size	main, .Lfunc_end10-main
                                        # -- End function
	.hidden	err                     # @err
	.type	err,@object
	.section	.bss.err,"aw",@nobits
	.globl	err
	.p2align	2
err:
	.int32	0                       # 0x0
	.size	err, 4


	.ident	"clang version 7.0.0 (https://llvm.googlesource.com/clang.git 1f874ca3c3f27c2149b6b33ca4a5966b3577280d) (https://llvm.googlesource.com/llvm.git 2e4bd2aa729dd2c33cdca2b39c971c675e914001)"
