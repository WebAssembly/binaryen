	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/divrem-constant.ll"
	.globl	test_udiv_2
	.type	test_udiv_2,@function
test_udiv_2:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 1
	i32.shr_u	$push1=, $0, $pop0
	.endfunc
.Lfunc_end0:
	.size	test_udiv_2, .Lfunc_end0-test_udiv_2

	.globl	test_udiv_5
	.type	test_udiv_5,@function
test_udiv_5:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 5
	i32.div_u	$push1=, $0, $pop0
	.endfunc
.Lfunc_end1:
	.size	test_udiv_5, .Lfunc_end1-test_udiv_5

	.globl	test_sdiv_2
	.type	test_sdiv_2,@function
test_sdiv_2:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 2
	i32.div_s	$push1=, $0, $pop0
	.endfunc
.Lfunc_end2:
	.size	test_sdiv_2, .Lfunc_end2-test_sdiv_2

	.globl	test_sdiv_5
	.type	test_sdiv_5,@function
test_sdiv_5:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 5
	i32.div_s	$push1=, $0, $pop0
	.endfunc
.Lfunc_end3:
	.size	test_sdiv_5, .Lfunc_end3-test_sdiv_5

	.globl	test_urem_2
	.type	test_urem_2,@function
test_urem_2:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 1
	i32.and 	$push1=, $0, $pop0
	.endfunc
.Lfunc_end4:
	.size	test_urem_2, .Lfunc_end4-test_urem_2

	.globl	test_urem_5
	.type	test_urem_5,@function
test_urem_5:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 5
	i32.rem_u	$push1=, $0, $pop0
	.endfunc
.Lfunc_end5:
	.size	test_urem_5, .Lfunc_end5-test_urem_5

	.globl	test_srem_2
	.type	test_srem_2,@function
test_srem_2:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 2
	i32.rem_s	$push1=, $0, $pop0
	.endfunc
.Lfunc_end6:
	.size	test_srem_2, .Lfunc_end6-test_srem_2

	.globl	test_srem_5
	.type	test_srem_5,@function
test_srem_5:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 5
	i32.rem_s	$push1=, $0, $pop0
	.endfunc
.Lfunc_end7:
	.size	test_srem_5, .Lfunc_end7-test_srem_5


