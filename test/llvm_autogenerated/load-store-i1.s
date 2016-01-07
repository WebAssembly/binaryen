	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/load-store-i1.ll"
	.globl	load_u_i1_i32
	.type	load_u_i1_i32,@function
load_u_i1_i32:
	.param  	i32
	.result 	i32
	i32.load8_u	$push0=, 0($0)
	return  	$pop0
.Lfunc_end0:
	.size	load_u_i1_i32, .Lfunc_end0-load_u_i1_i32

	.globl	load_s_i1_i32
	.type	load_s_i1_i32,@function
load_s_i1_i32:
	.param  	i32
	.result 	i32
	.local  	i32
	i32.const	$1=, 31
	i32.load8_u	$push0=, 0($0)
	i32.shl 	$push1=, $pop0, $1
	i32.shr_s	$push2=, $pop1, $1
	return  	$pop2
.Lfunc_end1:
	.size	load_s_i1_i32, .Lfunc_end1-load_s_i1_i32

	.globl	load_u_i1_i64
	.type	load_u_i1_i64,@function
load_u_i1_i64:
	.param  	i32
	.result 	i64
	i64.load8_u	$push0=, 0($0)
	return  	$pop0
.Lfunc_end2:
	.size	load_u_i1_i64, .Lfunc_end2-load_u_i1_i64

	.globl	load_s_i1_i64
	.type	load_s_i1_i64,@function
load_s_i1_i64:
	.param  	i32
	.result 	i64
	.local  	i64
	i64.const	$1=, 63
	i64.load8_u	$push0=, 0($0)
	i64.shl 	$push1=, $pop0, $1
	i64.shr_s	$push2=, $pop1, $1
	return  	$pop2
.Lfunc_end3:
	.size	load_s_i1_i64, .Lfunc_end3-load_s_i1_i64

	.globl	store_i32_i1
	.type	store_i32_i1,@function
store_i32_i1:
	.param  	i32, i32
	i32.const	$push0=, 1
	i32.and 	$push1=, $1, $pop0
	i32.store8	$discard=, 0($0), $pop1
	return
.Lfunc_end4:
	.size	store_i32_i1, .Lfunc_end4-store_i32_i1

	.globl	store_i64_i1
	.type	store_i64_i1,@function
store_i64_i1:
	.param  	i32, i64
	i64.const	$push0=, 1
	i64.and 	$push1=, $1, $pop0
	i64.store8	$discard=, 0($0), $pop1
	return
.Lfunc_end5:
	.size	store_i64_i1, .Lfunc_end5-store_i64_i1


	.section	".note.GNU-stack","",@progbits
