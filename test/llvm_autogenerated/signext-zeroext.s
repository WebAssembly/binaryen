	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/signext-zeroext.ll"
	.globl	z2s_func
	.type	z2s_func,@function
z2s_func:
	.param  	i32
	.result 	i32
	.local  	i32
	i32.const	$1=, 24
	i32.shl 	$push0=, $0, $1
	i32.shr_s	$push1=, $pop0, $1
	return  	$pop1
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
.Lfunc_end1:
	.size	s2z_func, .Lfunc_end1-s2z_func

	.globl	z2s_call
	.type	z2s_call,@function
z2s_call:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 255
	i32.and 	$push1=, $0, $pop0
	i32.call	$push2=, z2s_func, $pop1
	return  	$pop2
.Lfunc_end2:
	.size	z2s_call, .Lfunc_end2-z2s_call

	.globl	s2z_call
	.type	s2z_call,@function
s2z_call:
	.param  	i32
	.result 	i32
	.local  	i32
	i32.const	$1=, 24
	i32.shl 	$push0=, $0, $1
	i32.shr_s	$push1=, $pop0, $1
	i32.call	$push2=, s2z_func, $pop1
	i32.shl 	$push3=, $pop2, $1
	i32.shr_s	$push4=, $pop3, $1
	return  	$pop4
.Lfunc_end3:
	.size	s2z_call, .Lfunc_end3-s2z_call


	.section	".note.GNU-stack","",@progbits
