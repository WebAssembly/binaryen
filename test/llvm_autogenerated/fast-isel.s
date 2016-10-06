	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/fast-isel.ll"
	.globl	immediate_f32
	.type	immediate_f32,@function
immediate_f32:
	.result 	f32
	f32.const	$push0=, 0x1.4p1
	.endfunc
.Lfunc_end0:
	.size	immediate_f32, .Lfunc_end0-immediate_f32

	.globl	immediate_f64
	.type	immediate_f64,@function
immediate_f64:
	.result 	f64
	f64.const	$push0=, 0x1.4p1
	.endfunc
.Lfunc_end1:
	.size	immediate_f64, .Lfunc_end1-immediate_f64

	.globl	bitcast_i32_f32
	.type	bitcast_i32_f32,@function
bitcast_i32_f32:
	.param  	f32
	.result 	i32
	i32.reinterpret/f32	$push0=, $0
	.endfunc
.Lfunc_end2:
	.size	bitcast_i32_f32, .Lfunc_end2-bitcast_i32_f32

	.globl	bitcast_f32_i32
	.type	bitcast_f32_i32,@function
bitcast_f32_i32:
	.param  	i32
	.result 	f32
	f32.reinterpret/i32	$push0=, $0
	.endfunc
.Lfunc_end3:
	.size	bitcast_f32_i32, .Lfunc_end3-bitcast_f32_i32

	.globl	bitcast_i64_f64
	.type	bitcast_i64_f64,@function
bitcast_i64_f64:
	.param  	f64
	.result 	i64
	i64.reinterpret/f64	$push0=, $0
	.endfunc
.Lfunc_end4:
	.size	bitcast_i64_f64, .Lfunc_end4-bitcast_i64_f64

	.globl	bitcast_f64_i64
	.type	bitcast_f64_i64,@function
bitcast_f64_i64:
	.param  	i64
	.result 	f64
	f64.reinterpret/i64	$push0=, $0
	.endfunc
.Lfunc_end5:
	.size	bitcast_f64_i64, .Lfunc_end5-bitcast_f64_i64


