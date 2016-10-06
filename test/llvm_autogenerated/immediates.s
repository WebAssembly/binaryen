	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/immediates.ll"
	.globl	zero_i32
	.type	zero_i32,@function
zero_i32:
	.result 	i32
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	zero_i32, .Lfunc_end0-zero_i32

	.globl	one_i32
	.type	one_i32,@function
one_i32:
	.result 	i32
	i32.const	$push0=, 1
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	one_i32, .Lfunc_end1-one_i32

	.globl	max_i32
	.type	max_i32,@function
max_i32:
	.result 	i32
	i32.const	$push0=, 2147483647
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	max_i32, .Lfunc_end2-max_i32

	.globl	min_i32
	.type	min_i32,@function
min_i32:
	.result 	i32
	i32.const	$push0=, -2147483648
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	min_i32, .Lfunc_end3-min_i32

	.globl	zero_i64
	.type	zero_i64,@function
zero_i64:
	.result 	i64
	i64.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end4:
	.size	zero_i64, .Lfunc_end4-zero_i64

	.globl	one_i64
	.type	one_i64,@function
one_i64:
	.result 	i64
	i64.const	$push0=, 1
	return  	$pop0
	.endfunc
.Lfunc_end5:
	.size	one_i64, .Lfunc_end5-one_i64

	.globl	max_i64
	.type	max_i64,@function
max_i64:
	.result 	i64
	i64.const	$push0=, 9223372036854775807
	return  	$pop0
	.endfunc
.Lfunc_end6:
	.size	max_i64, .Lfunc_end6-max_i64

	.globl	min_i64
	.type	min_i64,@function
min_i64:
	.result 	i64
	i64.const	$push0=, -9223372036854775808
	return  	$pop0
	.endfunc
.Lfunc_end7:
	.size	min_i64, .Lfunc_end7-min_i64

	.globl	negzero_f32
	.type	negzero_f32,@function
negzero_f32:
	.result 	f32
	f32.const	$push0=, -0x0p0
	return  	$pop0
	.endfunc
.Lfunc_end8:
	.size	negzero_f32, .Lfunc_end8-negzero_f32

	.globl	zero_f32
	.type	zero_f32,@function
zero_f32:
	.result 	f32
	f32.const	$push0=, 0x0p0
	return  	$pop0
	.endfunc
.Lfunc_end9:
	.size	zero_f32, .Lfunc_end9-zero_f32

	.globl	one_f32
	.type	one_f32,@function
one_f32:
	.result 	f32
	f32.const	$push0=, 0x1p0
	return  	$pop0
	.endfunc
.Lfunc_end10:
	.size	one_f32, .Lfunc_end10-one_f32

	.globl	two_f32
	.type	two_f32,@function
two_f32:
	.result 	f32
	f32.const	$push0=, 0x1p1
	return  	$pop0
	.endfunc
.Lfunc_end11:
	.size	two_f32, .Lfunc_end11-two_f32

	.globl	nan_f32
	.type	nan_f32,@function
nan_f32:
	.result 	f32
	f32.const	$push0=, nan
	return  	$pop0
	.endfunc
.Lfunc_end12:
	.size	nan_f32, .Lfunc_end12-nan_f32

	.globl	negnan_f32
	.type	negnan_f32,@function
negnan_f32:
	.result 	f32
	f32.const	$push0=, -nan
	return  	$pop0
	.endfunc
.Lfunc_end13:
	.size	negnan_f32, .Lfunc_end13-negnan_f32

	.globl	inf_f32
	.type	inf_f32,@function
inf_f32:
	.result 	f32
	f32.const	$push0=, infinity
	return  	$pop0
	.endfunc
.Lfunc_end14:
	.size	inf_f32, .Lfunc_end14-inf_f32

	.globl	neginf_f32
	.type	neginf_f32,@function
neginf_f32:
	.result 	f32
	f32.const	$push0=, -infinity
	return  	$pop0
	.endfunc
.Lfunc_end15:
	.size	neginf_f32, .Lfunc_end15-neginf_f32

	.globl	custom_nan_f32
	.type	custom_nan_f32,@function
custom_nan_f32:
	.result 	f32
	f32.const	$push0=, -nan:0x6bcdef
	return  	$pop0
	.endfunc
.Lfunc_end16:
	.size	custom_nan_f32, .Lfunc_end16-custom_nan_f32

	.globl	custom_nans_f32
	.type	custom_nans_f32,@function
custom_nans_f32:
	.result 	f32
	f32.const	$push0=, -nan:0x6bcdef
	return  	$pop0
	.endfunc
.Lfunc_end17:
	.size	custom_nans_f32, .Lfunc_end17-custom_nans_f32

	.globl	negzero_f64
	.type	negzero_f64,@function
negzero_f64:
	.result 	f64
	f64.const	$push0=, -0x0p0
	return  	$pop0
	.endfunc
.Lfunc_end18:
	.size	negzero_f64, .Lfunc_end18-negzero_f64

	.globl	zero_f64
	.type	zero_f64,@function
zero_f64:
	.result 	f64
	f64.const	$push0=, 0x0p0
	return  	$pop0
	.endfunc
.Lfunc_end19:
	.size	zero_f64, .Lfunc_end19-zero_f64

	.globl	one_f64
	.type	one_f64,@function
one_f64:
	.result 	f64
	f64.const	$push0=, 0x1p0
	return  	$pop0
	.endfunc
.Lfunc_end20:
	.size	one_f64, .Lfunc_end20-one_f64

	.globl	two_f64
	.type	two_f64,@function
two_f64:
	.result 	f64
	f64.const	$push0=, 0x1p1
	return  	$pop0
	.endfunc
.Lfunc_end21:
	.size	two_f64, .Lfunc_end21-two_f64

	.globl	nan_f64
	.type	nan_f64,@function
nan_f64:
	.result 	f64
	f64.const	$push0=, nan
	return  	$pop0
	.endfunc
.Lfunc_end22:
	.size	nan_f64, .Lfunc_end22-nan_f64

	.globl	negnan_f64
	.type	negnan_f64,@function
negnan_f64:
	.result 	f64
	f64.const	$push0=, -nan
	return  	$pop0
	.endfunc
.Lfunc_end23:
	.size	negnan_f64, .Lfunc_end23-negnan_f64

	.globl	inf_f64
	.type	inf_f64,@function
inf_f64:
	.result 	f64
	f64.const	$push0=, infinity
	return  	$pop0
	.endfunc
.Lfunc_end24:
	.size	inf_f64, .Lfunc_end24-inf_f64

	.globl	neginf_f64
	.type	neginf_f64,@function
neginf_f64:
	.result 	f64
	f64.const	$push0=, -infinity
	return  	$pop0
	.endfunc
.Lfunc_end25:
	.size	neginf_f64, .Lfunc_end25-neginf_f64

	.globl	custom_nan_f64
	.type	custom_nan_f64,@function
custom_nan_f64:
	.result 	f64
	f64.const	$push0=, -nan:0xabcdef0123456
	return  	$pop0
	.endfunc
.Lfunc_end26:
	.size	custom_nan_f64, .Lfunc_end26-custom_nan_f64

	.globl	custom_nans_f64
	.type	custom_nans_f64,@function
custom_nans_f64:
	.result 	f64
	f64.const	$push0=, -nan:0x2bcdef0123456
	return  	$pop0
	.endfunc
.Lfunc_end27:
	.size	custom_nans_f64, .Lfunc_end27-custom_nans_f64


