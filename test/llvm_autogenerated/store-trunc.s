	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/store-trunc.ll"
	.globl	trunc_i8_i32
	.type	trunc_i8_i32,@function
trunc_i8_i32:
	.param  	i32, i32
	i32.store8	$discard=, 0($0), $1
	return
func_end0:
	.size	trunc_i8_i32, func_end0-trunc_i8_i32

	.globl	trunc_i16_i32
	.type	trunc_i16_i32,@function
trunc_i16_i32:
	.param  	i32, i32
	i32.store16	$discard=, 0($0), $1
	return
func_end1:
	.size	trunc_i16_i32, func_end1-trunc_i16_i32

	.globl	trunc_i8_i64
	.type	trunc_i8_i64,@function
trunc_i8_i64:
	.param  	i32, i64
	i64.store8	$discard=, 0($0), $1
	return
func_end2:
	.size	trunc_i8_i64, func_end2-trunc_i8_i64

	.globl	trunc_i16_i64
	.type	trunc_i16_i64,@function
trunc_i16_i64:
	.param  	i32, i64
	i64.store16	$discard=, 0($0), $1
	return
func_end3:
	.size	trunc_i16_i64, func_end3-trunc_i16_i64

	.globl	trunc_i32_i64
	.type	trunc_i32_i64,@function
trunc_i32_i64:
	.param  	i32, i64
	i64.store32	$discard=, 0($0), $1
	return
func_end4:
	.size	trunc_i32_i64, func_end4-trunc_i32_i64


	.section	".note.GNU-stack","",@progbits
