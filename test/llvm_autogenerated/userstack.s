	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/userstack.ll"
	.globl	alloca32
	.type	alloca32,@function
alloca32:
	.local  	i32, i32, i32, i32
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$3=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$3=, 0($1), $3
	i32.const	$push0=, 0
	i32.store	$discard=, 12($3), $pop0
	i32.const	$2=, 16
	i32.add 	$3=, $3, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	return
.Lfunc_end0:
	.size	alloca32, .Lfunc_end0-alloca32

	.globl	alloca3264
	.type	alloca3264,@function
alloca3264:
	.local  	i32, i32, i32, i32
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$3=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$3=, 0($1), $3
	i32.const	$push0=, 0
	i32.store	$discard=, 12($3), $pop0
	i64.const	$push1=, 0
	i64.store	$discard=, 0($3), $pop1
	i32.const	$2=, 16
	i32.add 	$3=, $3, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	return
.Lfunc_end1:
	.size	alloca3264, .Lfunc_end1-alloca3264

	.globl	allocarray
	.type	allocarray,@function
allocarray:
	.local  	i32, i32, i32, i32, i32, i32
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 32
	i32.sub 	$5=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$5=, 0($2), $5
	i32.const	$push0=, 1
	i32.store	$0=, 12($5), $pop0
	i32.const	$push1=, 4
	i32.const	$4=, 12
	i32.add 	$4=, $5, $4
	i32.add 	$push2=, $4, $pop1
	i32.store	$discard=, 0($pop2), $0
	i32.const	$3=, 32
	i32.add 	$5=, $5, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	return
.Lfunc_end2:
	.size	allocarray, .Lfunc_end2-allocarray

	.globl	dynamic_alloca
	.type	dynamic_alloca,@function
dynamic_alloca:
	.param  	i32
	return
.Lfunc_end3:
	.size	dynamic_alloca, .Lfunc_end3-dynamic_alloca


	.section	".note.GNU-stack","",@progbits
