	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/f64.ll"
	.globl	fadd64
	.type	fadd64,@function
fadd64:
	.param  	f64, f64
	.result 	f64
	f64.add 	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end0:
	.size	fadd64, .Lfunc_end0-fadd64

	.globl	fsub64
	.type	fsub64,@function
fsub64:
	.param  	f64, f64
	.result 	f64
	f64.sub 	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	fsub64, .Lfunc_end1-fsub64

	.globl	fmul64
	.type	fmul64,@function
fmul64:
	.param  	f64, f64
	.result 	f64
	f64.mul 	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end2:
	.size	fmul64, .Lfunc_end2-fmul64

	.globl	fdiv64
	.type	fdiv64,@function
fdiv64:
	.param  	f64, f64
	.result 	f64
	f64.div 	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end3:
	.size	fdiv64, .Lfunc_end3-fdiv64

	.globl	fabs64
	.type	fabs64,@function
fabs64:
	.param  	f64
	.result 	f64
	f64.abs 	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end4:
	.size	fabs64, .Lfunc_end4-fabs64

	.globl	fneg64
	.type	fneg64,@function
fneg64:
	.param  	f64
	.result 	f64
	f64.neg 	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end5:
	.size	fneg64, .Lfunc_end5-fneg64

	.globl	copysign64
	.type	copysign64,@function
copysign64:
	.param  	f64, f64
	.result 	f64
	f64.copysign	$push0=, $0, $1
	return  	$pop0
	.endfunc
.Lfunc_end6:
	.size	copysign64, .Lfunc_end6-copysign64

	.globl	sqrt64
	.type	sqrt64,@function
sqrt64:
	.param  	f64
	.result 	f64
	f64.sqrt	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end7:
	.size	sqrt64, .Lfunc_end7-sqrt64

	.globl	ceil64
	.type	ceil64,@function
ceil64:
	.param  	f64
	.result 	f64
	f64.ceil	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end8:
	.size	ceil64, .Lfunc_end8-ceil64

	.globl	floor64
	.type	floor64,@function
floor64:
	.param  	f64
	.result 	f64
	f64.floor	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end9:
	.size	floor64, .Lfunc_end9-floor64

	.globl	trunc64
	.type	trunc64,@function
trunc64:
	.param  	f64
	.result 	f64
	f64.trunc	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end10:
	.size	trunc64, .Lfunc_end10-trunc64

	.globl	nearest64
	.type	nearest64,@function
nearest64:
	.param  	f64
	.result 	f64
	f64.nearest	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end11:
	.size	nearest64, .Lfunc_end11-nearest64

	.globl	nearest64_via_rint
	.type	nearest64_via_rint,@function
nearest64_via_rint:
	.param  	f64
	.result 	f64
	f64.nearest	$push0=, $0
	return  	$pop0
	.endfunc
.Lfunc_end12:
	.size	nearest64_via_rint, .Lfunc_end12-nearest64_via_rint

	.globl	fmin64
	.type	fmin64,@function
fmin64:
	.param  	f64
	.result 	f64
	f64.const	$push0=, 0x0p0
	f64.min 	$push1=, $0, $pop0
	return  	$pop1
	.endfunc
.Lfunc_end13:
	.size	fmin64, .Lfunc_end13-fmin64

	.globl	fmax64
	.type	fmax64,@function
fmax64:
	.param  	f64
	.result 	f64
	f64.const	$push0=, 0x0p0
	f64.max 	$push1=, $0, $pop0
	return  	$pop1
	.endfunc
.Lfunc_end14:
	.size	fmax64, .Lfunc_end14-fmax64

	.globl	fma64
	.type	fma64,@function
fma64:
	.param  	f64, f64, f64
	.result 	f64
	f64.call	$push0=, fma@FUNCTION, $0, $1, $2
	return  	$pop0
	.endfunc
.Lfunc_end15:
	.size	fma64, .Lfunc_end15-fma64


