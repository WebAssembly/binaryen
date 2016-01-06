	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/returned.ll"
	.globl	_Z3foov
	.type	_Z3foov,@function
_Z3foov:
	.result 	i32
	i32.const	$push0=, 1
	i32.call	$push1=, _Znwm, $pop0
	i32.call	$push2=, _ZN5AppleC1Ev, $pop1
	return  	$pop2
func_end0:
	.size	_Z3foov, func_end0-_Z3foov

	.globl	_Z3barPvS_l
	.type	_Z3barPvS_l,@function
_Z3barPvS_l:
	.param  	i32, i32, i32
	.result 	i32
	i32.call	$push0=, memcpy, $0, $1, $2
	return  	$pop0
func_end1:
	.size	_Z3barPvS_l, func_end1-_Z3barPvS_l

	.globl	test_constant_arg
	.type	test_constant_arg,@function
test_constant_arg:
	i32.const	$push0=, global
	i32.call	$discard=, returns_arg, $pop0
	return
func_end2:
	.size	test_constant_arg, func_end2-test_constant_arg

	.type	addr,@object
	.data
	.globl	addr
	.align	2
addr:
	.int32	global
	.size	addr, 4


	.section	".note.GNU-stack","",@progbits
