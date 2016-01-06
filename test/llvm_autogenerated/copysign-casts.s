	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/copysign-casts.ll"
	.globl	fold_promote
	.type	fold_promote,@function
fold_promote:
	.param  	f64, f32
	.result 	f64
	f64.promote/f32	$push0=, $1
	f64.copysign	$push1=, $0, $pop0
	return  	$pop1
func_end0:
	.size	fold_promote, func_end0-fold_promote

	.globl	fold_demote
	.type	fold_demote,@function
fold_demote:
	.param  	f32, f64
	.result 	f32
	f32.demote/f64	$push0=, $1
	f32.copysign	$push1=, $0, $pop0
	return  	$pop1
func_end1:
	.size	fold_demote, func_end1-fold_demote


	.section	".note.GNU-stack","",@progbits
