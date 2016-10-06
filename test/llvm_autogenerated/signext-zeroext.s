	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/signext-zeroext.ll"
	.globl	z2s_func
	.type	z2s_func,@function
z2s_func:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 24
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push3=, 24
	i32.shr_s	$push2=, $pop1, $pop3
	return  	$pop2
	.endfunc
.Lfunc_end0:
	.size	z2s_func, .Lfunc_end0-z2s_func

	.globl	s2z_func
	.type	s2z_func,@function
s2z_func:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 255
	i32.and 	$push1=, $0, $pop0
	return  	$pop1
	.endfunc
.Lfunc_end1:
	.size	s2z_func, .Lfunc_end1-s2z_func

	.globl	z2s_call
	.type	z2s_call,@function
z2s_call:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 255
	i32.and 	$push1=, $0, $pop0
	i32.call	$push2=, z2s_func@FUNCTION, $pop1
	return  	$pop2
	.endfunc
.Lfunc_end2:
	.size	z2s_call, .Lfunc_end2-z2s_call

	.globl	s2z_call
	.type	s2z_call,@function
s2z_call:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 24
	i32.shl 	$push1=, $0, $pop0
	i32.const	$push8=, 24
	i32.shr_s	$push2=, $pop1, $pop8
	i32.call	$push3=, s2z_func@FUNCTION, $pop2
	i32.const	$push7=, 24
	i32.shl 	$push4=, $pop3, $pop7
	i32.const	$push6=, 24
	i32.shr_s	$push5=, $pop4, $pop6
	return  	$pop5
	.endfunc
.Lfunc_end3:
	.size	s2z_call, .Lfunc_end3-s2z_call


