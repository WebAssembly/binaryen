	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/f32.ll"
	.globl	fadd32
	.type	fadd32,@function
fadd32:
	.param  	f32, f32
	.result 	f32
	f32.add 	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	fadd32, .Lfunc_end0-fadd32

	.globl	fsub32
	.type	fsub32,@function
fsub32:
	.param  	f32, f32
	.result 	f32
	f32.sub 	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	fsub32, .Lfunc_end1-fsub32

	.globl	fmul32
	.type	fmul32,@function
fmul32:
	.param  	f32, f32
	.result 	f32
	f32.mul 	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	fmul32, .Lfunc_end2-fmul32

	.globl	fdiv32
	.type	fdiv32,@function
fdiv32:
	.param  	f32, f32
	.result 	f32
	f32.div 	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	fdiv32, .Lfunc_end3-fdiv32

	.globl	fabs32
	.type	fabs32,@function
fabs32:
	.param  	f32
	.result 	f32
	f32.abs 	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end4:
	.size	fabs32, .Lfunc_end4-fabs32

	.globl	fneg32
	.type	fneg32,@function
fneg32:
	.param  	f32
	.result 	f32
	f32.neg 	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end5:
	.size	fneg32, .Lfunc_end5-fneg32

	.globl	copysign32
	.type	copysign32,@function
copysign32:
	.param  	f32, f32
	.result 	f32
	f32.copysign	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end6:
	.size	copysign32, .Lfunc_end6-copysign32

	.globl	sqrt32
	.type	sqrt32,@function
sqrt32:
	.param  	f32
	.result 	f32
	f32.sqrt	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end7:
	.size	sqrt32, .Lfunc_end7-sqrt32

	.globl	ceil32
	.type	ceil32,@function
ceil32:
	.param  	f32
	.result 	f32
	f32.ceil	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end8:
	.size	ceil32, .Lfunc_end8-ceil32

	.globl	floor32
	.type	floor32,@function
floor32:
	.param  	f32
	.result 	f32
	f32.floor	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end9:
	.size	floor32, .Lfunc_end9-floor32

	.globl	trunc32
	.type	trunc32,@function
trunc32:
	.param  	f32
	.result 	f32
	f32.trunc	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end10:
	.size	trunc32, .Lfunc_end10-trunc32

	.globl	nearest32
	.type	nearest32,@function
nearest32:
	.param  	f32
	.result 	f32
	f32.nearest	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end11:
	.size	nearest32, .Lfunc_end11-nearest32

	.globl	nearest32_via_rint
	.type	nearest32_via_rint,@function
nearest32_via_rint:
	.param  	f32
	.result 	f32
	f32.nearest	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end12:
	.size	nearest32_via_rint, .Lfunc_end12-nearest32_via_rint

	.globl	fmin32
	.type	fmin32,@function
fmin32:
	.param  	f32
	.result 	f32
	f32.const	$push0=, 0x0p0
	f32.min 	$push1=, $0, $pop0
	return  	$pop1
	.endfunc
.Lfunc_end13:
	.size	fmin32, .Lfunc_end13-fmin32

	.globl	fmax32
	.type	fmax32,@function
fmax32:
	.param  	f32
	.result 	f32
	f32.const	$push0=, 0x0p0
	f32.max 	$push1=, $0, $pop0
	return  	$pop1
	.endfunc
.Lfunc_end14:
	.size	fmax32, .Lfunc_end14-fmax32

	.globl	fma32
	.type	fma32,@function
fma32:
	.param  	f32, f32, f32
	.result 	f32
	f32.call	$push0=, fmaf@FUNCTION, $0, $1, $2
	return  	$pop0
	.endfunc
.Lfunc_end15:
	.size	fma32, .Lfunc_end15-fma32


