	.text
	.file	"fix_em_ehsjlj_names.bc"
	.type	_Z5func1v,@function
_Z5func1v:
	.endfunc
.Lfunc_end0:
	.size	_Z5func1v, .Lfunc_end0-_Z5func1v

	.type	_Z5func2iii,@function
_Z5func2iii:
	.param  	i32, i32, i32
	.result 	i32
	i32.const	$push0=, 3
	.endfunc
.Lfunc_end1:
	.size	_Z5func2iii, .Lfunc_end1-_Z5func2iii

	.type	_Z5func3fd,@function
_Z5func3fd:
	.param  	f32, f64
	.result 	f32
	f32.const	$push0=, 0x1p0
	.endfunc
.Lfunc_end2:
	.size	_Z5func3fd, .Lfunc_end2-_Z5func3fd

	.type	_Z5func4P8mystructS_,@function
_Z5func4P8mystructS_:
	.param  	i32, i32
	.result 	i32
	i32.const	$push0=, 0
	.endfunc
.Lfunc_end3:
	.size	_Z5func4P8mystructS_, .Lfunc_end3-_Z5func4P8mystructS_

	.hidden	main
	.globl	main
	.type	main,@function
main:
	.result 	i32
	.local  	i32, i32, i32, i32
	i32.const	$push1=, _Z5func1v@FUNCTION
	call    	__invoke_void@FUNCTION, $pop1
	i32.const	$push5=, _Z5func2iii@FUNCTION
	i32.const	$push4=, 1
	i32.const	$push3=, 2
	i32.const	$push2=, 3
	i32.call	$drop=, __invoke_i32_i32_i32_i32@FUNCTION, $pop5, $pop4, $pop3, $pop2
	i32.const	$push8=, _Z5func3fd@FUNCTION
	f32.const	$push7=, 0x1.8p0
	f64.const	$push6=, 0x1.b333333333333p1
	f32.call	$drop=, __invoke_float_float_double@FUNCTION, $pop8, $pop7, $pop6
	i32.const	$push9=, _Z5func4P8mystructS_@FUNCTION
	i32.const	$push10=, 32
	i32.add 	$push11=, $1, $pop10
	i32.const	$push12=, 4
	i32.add 	$push13=, $1, $pop12
	i32.call	$drop=, "__invoke_%struct.mystruct*_%struct.mystruct*_%struct.mystruct*"@FUNCTION, $pop9, $pop11, $pop13
	i32.const	$push14=, 5
	i32.const	$push15=, 6
	call    	emscripten_longjmp_jmpbuf@FUNCTION, $pop15, $pop14
	i32.const	$push16=, 0
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main

	.functype	__invoke_void, void, i32
	.functype	__invoke_i32_i32_i32_i32, i32, i32, i32, i32, i32
	.functype	__invoke_float_float_double, f32, i32, f32, f64
	.functype	__invoke_%struct.mystruct*_%struct.mystruct*_%struct.mystruct*, i32, i32, i32, i32
	.functype	emscripten_longjmp_jmpbuf, void, i32, i32
	.functype	emscripten_longjmp, void, i32, i32

