	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/select.ll"
	.globl	select_i32_bool
	.type	select_i32_bool,@function
select_i32_bool:
	.param  	i32, i32, i32
	.result 	i32
	i32.select	$push0=, $1, $2, $0
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	select_i32_bool, .Lfunc_end0-select_i32_bool

	.globl	select_i32_eq
	.type	select_i32_eq,@function
select_i32_eq:
	.param  	i32, i32, i32
	.result 	i32
	i32.select	$push0=, $2, $1, $0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	select_i32_eq, .Lfunc_end1-select_i32_eq

	.globl	select_i32_ne
	.type	select_i32_ne,@function
select_i32_ne:
	.param  	i32, i32, i32
	.result 	i32
	i32.select	$push0=, $1, $2, $0
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	select_i32_ne, .Lfunc_end2-select_i32_ne

	.globl	select_i64_bool
	.type	select_i64_bool,@function
select_i64_bool:
	.param  	i32, i64, i64
	.result 	i64
	i64.select	$push0=, $1, $2, $0
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	select_i64_bool, .Lfunc_end3-select_i64_bool

	.globl	select_i64_eq
	.type	select_i64_eq,@function
select_i64_eq:
	.param  	i32, i64, i64
	.result 	i64
	i64.select	$push0=, $2, $1, $0
	return  	$pop0
	.endfunc
.Lfunc_end4:
	.size	select_i64_eq, .Lfunc_end4-select_i64_eq

	.globl	select_i64_ne
	.type	select_i64_ne,@function
select_i64_ne:
	.param  	i32, i64, i64
	.result 	i64
	i64.select	$push0=, $1, $2, $0
	return  	$pop0
	.endfunc
.Lfunc_end5:
	.size	select_i64_ne, .Lfunc_end5-select_i64_ne

	.globl	select_f32_bool
	.type	select_f32_bool,@function
select_f32_bool:
	.param  	i32, f32, f32
	.result 	f32
	f32.select	$push0=, $1, $2, $0
	return  	$pop0
	.endfunc
.Lfunc_end6:
	.size	select_f32_bool, .Lfunc_end6-select_f32_bool

	.globl	select_f32_eq
	.type	select_f32_eq,@function
select_f32_eq:
	.param  	i32, f32, f32
	.result 	f32
	f32.select	$push0=, $2, $1, $0
	return  	$pop0
	.endfunc
.Lfunc_end7:
	.size	select_f32_eq, .Lfunc_end7-select_f32_eq

	.globl	select_f32_ne
	.type	select_f32_ne,@function
select_f32_ne:
	.param  	i32, f32, f32
	.result 	f32
	f32.select	$push0=, $1, $2, $0
	return  	$pop0
	.endfunc
.Lfunc_end8:
	.size	select_f32_ne, .Lfunc_end8-select_f32_ne

	.globl	select_f64_bool
	.type	select_f64_bool,@function
select_f64_bool:
	.param  	i32, f64, f64
	.result 	f64
	f64.select	$push0=, $1, $2, $0
	return  	$pop0
	.endfunc
.Lfunc_end9:
	.size	select_f64_bool, .Lfunc_end9-select_f64_bool

	.globl	select_f64_eq
	.type	select_f64_eq,@function
select_f64_eq:
	.param  	i32, f64, f64
	.result 	f64
	f64.select	$push0=, $2, $1, $0
	return  	$pop0
	.endfunc
.Lfunc_end10:
	.size	select_f64_eq, .Lfunc_end10-select_f64_eq

	.globl	select_f64_ne
	.type	select_f64_ne,@function
select_f64_ne:
	.param  	i32, f64, f64
	.result 	f64
	f64.select	$push0=, $1, $2, $0
	return  	$pop0
	.endfunc
.Lfunc_end11:
	.size	select_f64_ne, .Lfunc_end11-select_f64_ne


