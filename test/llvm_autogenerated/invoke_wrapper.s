	.text
	.file	"invoke_wrapper.ll"
	.hidden	_Z5func1v
	.globl	_Z5func1v
	.type	_Z5func1v,@function
_Z5func1v:
	.endfunc
.Lfunc_end0:
	.size	_Z5func1v, .Lfunc_end0-_Z5func1v

	.hidden	_Z5func2iii
	.globl	_Z5func2iii
	.type	_Z5func2iii,@function
_Z5func2iii:
	.param  	i32, i32, i32
	.result 	i32
	i32.const	$push0=, 3
	.endfunc
.Lfunc_end1:
	.size	_Z5func2iii, .Lfunc_end1-_Z5func2iii

	.hidden	_Z5func3fd
	.globl	_Z5func3fd
	.type	_Z5func3fd,@function
_Z5func3fd:
	.param  	f32, f64
	.result 	f32
	f32.const	$push0=, 0x1p0
	.endfunc
.Lfunc_end2:
	.size	_Z5func3fd, .Lfunc_end2-_Z5func3fd

	.hidden	_Z5func4P8mystructS_
	.globl	_Z5func4P8mystructS_
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
	i32.const	$push27=, 0
	i32.const	$push24=, 0
	i32.load	$push25=, __stack_pointer($pop24)
	i32.const	$push26=, 48
	i32.sub 	$push41=, $pop25, $pop26
	i32.store	$1=, __stack_pointer($pop27), $pop41
	i32.const	$push0=, 0
	i32.const	$push42=, 0
	i32.store8	$0=, __THREW__($pop0), $pop42
	i32.const	$push1=, _Z5func1v@FUNCTION
	call    	__invoke_void@FUNCTION, $pop1
	i32.load8_u	$2=, __THREW__($0)
	i32.store8	$drop=, __THREW__($0), $0
	block
	block
	br_if   	0, $2
	i32.store8	$2=, __THREW__($0), $0
	i32.const	$push5=, _Z5func2iii@FUNCTION
	i32.const	$push4=, 1
	i32.const	$push3=, 2
	i32.const	$push2=, 3
	i32.call	$drop=, __invoke_i32_i32_i32_i32@FUNCTION, $pop5, $pop4, $pop3, $pop2
	i32.load8_u	$3=, __THREW__($2)
	i32.store8	$drop=, __THREW__($2), $2
	br_if   	0, $3
	i32.const	$push6=, 0
	i32.const	$push43=, 0
	i32.store8	$2=, __THREW__($pop6), $pop43
	i32.const	$push9=, _Z5func3fd@FUNCTION
	f32.const	$push8=, 0x1.8p0
	f64.const	$push7=, 0x1.b333333333333p1
	f32.call	$drop=, __invoke_float_float_double@FUNCTION, $pop9, $pop8, $pop7
	i32.load8_u	$3=, __THREW__($2)
	i32.store8	$drop=, __THREW__($2), $2
	br_if   	0, $3
	i32.const	$push31=, 16
	i32.add 	$push32=, $1, $pop31
	i32.const	$push10=, 8
	i32.add 	$push47=, $pop32, $pop10
	tee_local	$push46=, $3=, $pop47
	i32.const	$push33=, 32
	i32.add 	$push34=, $1, $pop33
	i32.const	$push45=, 8
	i32.add 	$push11=, $pop34, $pop45
	i32.load	$push12=, 0($pop11)
	i32.store	$drop=, 0($pop46), $pop12
	i32.load	$push13=, 36($1)
	i32.store	$drop=, 20($1), $pop13
	i32.load	$push14=, 32($1)
	i32.store	$drop=, 16($1), $pop14
	i32.store8	$drop=, __THREW__($2), $2
	i32.const	$push35=, 4
	i32.add 	$push36=, $1, $pop35
	i32.const	$push44=, 8
	i32.add 	$push15=, $pop36, $pop44
	i32.load	$push16=, 0($3)
	i32.store	$drop=, 0($pop15), $pop16
	i32.const	$push17=, 8
	i32.add 	$push18=, $1, $pop17
	i32.load	$push19=, 20($1)
	i32.store	$drop=, 0($pop18), $pop19
	i32.load	$push20=, 16($1)
	i32.store	$drop=, 4($1), $pop20
	i32.const	$push21=, _Z5func4P8mystructS_@FUNCTION
	i32.const	$push37=, 32
	i32.add 	$push38=, $1, $pop37
	i32.const	$push39=, 4
	i32.add 	$push40=, $1, $pop39
	i32.call	$drop=, "__invoke_%struct.mystruct*_%struct.mystruct*_%struct.mystruct*"@FUNCTION, $pop21, $pop38, $pop40
	i32.load8_u	$3=, __THREW__($2)
	i32.store8	$drop=, __THREW__($2), $2
	i32.eqz 	$push48=, $3
	br_if   	1, $pop48
.LBB4_4:
	end_block
	i32.call	$push22=, __cxa_find_matching_catch_3@FUNCTION, $0
	i32.call	$drop=, __cxa_begin_catch@FUNCTION, $pop22
	call    	__cxa_end_catch@FUNCTION
.LBB4_5:
	end_block
	i32.const	$push30=, 0
	i32.const	$push28=, 48
	i32.add 	$push29=, $1, $pop28
	i32.store	$drop=, __stack_pointer($pop30), $pop29
	i32.const	$push23=, 0
	.endfunc
.Lfunc_end4:
	.size	main, .Lfunc_end4-main

	.globl	setThrew
	.type	setThrew,@function
setThrew:
	.param  	i32, i32
	block
	i32.const	$push3=, 0
	i32.load8_u	$push0=, __THREW__($pop3)
	br_if   	0, $pop0
	i32.const	$push5=, 0
	i32.const	$push1=, 1
	i32.and 	$push2=, $0, $pop1
	i32.store8	$drop=, __THREW__($pop5), $pop2
	i32.const	$push4=, 0
	i32.store	$drop=, threwValue($pop4), $1
.LBB5_2:
	end_block
	.endfunc
.Lfunc_end5:
	.size	setThrew, .Lfunc_end5-setThrew

	.globl	setTempRet0
	.type	setTempRet0,@function
setTempRet0:
	.param  	i32
	i32.const	$push0=, 0
	i32.store	$drop=, tempRet0($pop0), $0
	.endfunc
.Lfunc_end6:
	.size	setTempRet0, .Lfunc_end6-setTempRet0

	.type	__THREW__,@object
	.bss
	.globl	__THREW__
__THREW__:
	.int8	0
	.size	__THREW__, 1

	.type	threwValue,@object
	.globl	threwValue
	.p2align	2
threwValue:
	.int32	0
	.size	threwValue, 4

	.type	tempRet0,@object
	.globl	tempRet0
	.p2align	2
tempRet0:
	.int32	0
	.size	tempRet0, 4


	.ident	"clang version 4.0.0 (trunk 277551)"
	.functype	__gxx_personality_v0, i32
	.functype	__cxa_begin_catch, i32, i32
	.functype	__cxa_end_catch, void
	.functype	__resumeException, void, i32
	.functype	llvm_eh_typeid_for, i32, i32
	.functype	__invoke_void, void, i32
	.functype	__invoke_i32_i32_i32_i32, i32, i32, i32, i32, i32
	.functype	__invoke_float_float_double, f32, i32, f32, f64
	.functype	__invoke_%struct.mystruct*_%struct.mystruct*_%struct.mystruct*, i32, i32, i32, i32
	.functype	__cxa_find_matching_catch_3, i32, i32
