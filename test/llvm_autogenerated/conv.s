	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/conv.ll"
	.globl	i32_wrap_i64
	.type	i32_wrap_i64,@function
i32_wrap_i64:
	.param  	i64
	.result 	i32
	i32.wrap/i64	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	i32_wrap_i64, .Lfunc_end0-i32_wrap_i64

	.globl	i64_extend_s_i32
	.type	i64_extend_s_i32,@function
i64_extend_s_i32:
	.param  	i32
	.result 	i64
	i64.extend_s/i32	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	i64_extend_s_i32, .Lfunc_end1-i64_extend_s_i32

	.globl	i64_extend_u_i32
	.type	i64_extend_u_i32,@function
i64_extend_u_i32:
	.param  	i32
	.result 	i64
	i64.extend_u/i32	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	i64_extend_u_i32, .Lfunc_end2-i64_extend_u_i32

	.globl	i32_trunc_s_f32
	.type	i32_trunc_s_f32,@function
i32_trunc_s_f32:
	.param  	f32
	.result 	i32
	i32.trunc_s/f32	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	i32_trunc_s_f32, .Lfunc_end3-i32_trunc_s_f32

	.globl	i32_trunc_u_f32
	.type	i32_trunc_u_f32,@function
i32_trunc_u_f32:
	.param  	f32
	.result 	i32
	i32.trunc_u/f32	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end4:
	.size	i32_trunc_u_f32, .Lfunc_end4-i32_trunc_u_f32

	.globl	i32_trunc_s_f64
	.type	i32_trunc_s_f64,@function
i32_trunc_s_f64:
	.param  	f64
	.result 	i32
	i32.trunc_s/f64	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end5:
	.size	i32_trunc_s_f64, .Lfunc_end5-i32_trunc_s_f64

	.globl	i32_trunc_u_f64
	.type	i32_trunc_u_f64,@function
i32_trunc_u_f64:
	.param  	f64
	.result 	i32
	i32.trunc_u/f64	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end6:
	.size	i32_trunc_u_f64, .Lfunc_end6-i32_trunc_u_f64

	.globl	i64_trunc_s_f32
	.type	i64_trunc_s_f32,@function
i64_trunc_s_f32:
	.param  	f32
	.result 	i64
	i64.trunc_s/f32	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end7:
	.size	i64_trunc_s_f32, .Lfunc_end7-i64_trunc_s_f32

	.globl	i64_trunc_u_f32
	.type	i64_trunc_u_f32,@function
i64_trunc_u_f32:
	.param  	f32
	.result 	i64
	i64.trunc_u/f32	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end8:
	.size	i64_trunc_u_f32, .Lfunc_end8-i64_trunc_u_f32

	.globl	i64_trunc_s_f64
	.type	i64_trunc_s_f64,@function
i64_trunc_s_f64:
	.param  	f64
	.result 	i64
	i64.trunc_s/f64	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end9:
	.size	i64_trunc_s_f64, .Lfunc_end9-i64_trunc_s_f64

	.globl	i64_trunc_u_f64
	.type	i64_trunc_u_f64,@function
i64_trunc_u_f64:
	.param  	f64
	.result 	i64
	i64.trunc_u/f64	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end10:
	.size	i64_trunc_u_f64, .Lfunc_end10-i64_trunc_u_f64

	.globl	f32_convert_s_i32
	.type	f32_convert_s_i32,@function
f32_convert_s_i32:
	.param  	i32
	.result 	f32
	f32.convert_s/i32	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end11:
	.size	f32_convert_s_i32, .Lfunc_end11-f32_convert_s_i32

	.globl	f32_convert_u_i32
	.type	f32_convert_u_i32,@function
f32_convert_u_i32:
	.param  	i32
	.result 	f32
	f32.convert_u/i32	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end12:
	.size	f32_convert_u_i32, .Lfunc_end12-f32_convert_u_i32

	.globl	f64_convert_s_i32
	.type	f64_convert_s_i32,@function
f64_convert_s_i32:
	.param  	i32
	.result 	f64
	f64.convert_s/i32	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end13:
	.size	f64_convert_s_i32, .Lfunc_end13-f64_convert_s_i32

	.globl	f64_convert_u_i32
	.type	f64_convert_u_i32,@function
f64_convert_u_i32:
	.param  	i32
	.result 	f64
	f64.convert_u/i32	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end14:
	.size	f64_convert_u_i32, .Lfunc_end14-f64_convert_u_i32

	.globl	f32_convert_s_i64
	.type	f32_convert_s_i64,@function
f32_convert_s_i64:
	.param  	i64
	.result 	f32
	f32.convert_s/i64	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end15:
	.size	f32_convert_s_i64, .Lfunc_end15-f32_convert_s_i64

	.globl	f32_convert_u_i64
	.type	f32_convert_u_i64,@function
f32_convert_u_i64:
	.param  	i64
	.result 	f32
	f32.convert_u/i64	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end16:
	.size	f32_convert_u_i64, .Lfunc_end16-f32_convert_u_i64

	.globl	f64_convert_s_i64
	.type	f64_convert_s_i64,@function
f64_convert_s_i64:
	.param  	i64
	.result 	f64
	f64.convert_s/i64	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end17:
	.size	f64_convert_s_i64, .Lfunc_end17-f64_convert_s_i64

	.globl	f64_convert_u_i64
	.type	f64_convert_u_i64,@function
f64_convert_u_i64:
	.param  	i64
	.result 	f64
	f64.convert_u/i64	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end18:
	.size	f64_convert_u_i64, .Lfunc_end18-f64_convert_u_i64

	.globl	f64_promote_f32
	.type	f64_promote_f32,@function
f64_promote_f32:
	.param  	f32
	.result 	f64
	f64.promote/f32	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end19:
	.size	f64_promote_f32, .Lfunc_end19-f64_promote_f32

	.globl	f32_demote_f64
	.type	f32_demote_f64,@function
f32_demote_f64:
	.param  	f64
	.result 	f32
	f32.demote/f64	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end20:
	.size	f32_demote_f64, .Lfunc_end20-f32_demote_f64

	.globl	anyext
	.type	anyext,@function
anyext:
	.param  	i32
	.result 	i64
	i64.extend_u/i32	$push0=, $0
	i64.const	$push1=, 32
	i64.shl 	$push2=, $pop0, $pop1
	return  	$pop2
	.endfunc
.Lfunc_end21:
	.size	anyext, .Lfunc_end21-anyext

	.globl	bitcast_i32_to_float
	.type	bitcast_i32_to_float,@function
bitcast_i32_to_float:
	.param  	i32
	.result 	f32
	f32.reinterpret/i32	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end22:
	.size	bitcast_i32_to_float, .Lfunc_end22-bitcast_i32_to_float

	.globl	bitcast_float_to_i32
	.type	bitcast_float_to_i32,@function
bitcast_float_to_i32:
	.param  	f32
	.result 	i32
	i32.reinterpret/f32	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end23:
	.size	bitcast_float_to_i32, .Lfunc_end23-bitcast_float_to_i32

	.globl	bitcast_i64_to_double
	.type	bitcast_i64_to_double,@function
bitcast_i64_to_double:
	.param  	i64
	.result 	f64
	f64.reinterpret/i64	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end24:
	.size	bitcast_i64_to_double, .Lfunc_end24-bitcast_i64_to_double

	.globl	bitcast_double_to_i64
	.type	bitcast_double_to_i64,@function
bitcast_double_to_i64:
	.param  	f64
	.result 	i64
	i64.reinterpret/f64	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end25:
	.size	bitcast_double_to_i64, .Lfunc_end25-bitcast_double_to_i64


