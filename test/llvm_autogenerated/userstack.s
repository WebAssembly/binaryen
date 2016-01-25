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
	.endfunc
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
	.endfunc
.Lfunc_end1:
	.size	alloca3264, .Lfunc_end1-alloca3264

	.globl	allocarray
	.type	allocarray,@function
allocarray:
	.local  	i32, i32, i32, i32, i32
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 32
	i32.sub 	$4=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$4=, 0($1), $4
	i32.const	$push2=, 12
	i32.const	$3=, 12
	i32.add 	$3=, $4, $3
	i32.add 	$push3=, $3, $pop2
	i32.const	$push0=, 1
	i32.store	$push1=, 12($4), $pop0
	i32.store	$discard=, 0($pop3), $pop1
	i32.const	$2=, 32
	i32.add 	$4=, $4, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	return
	.endfunc
.Lfunc_end2:
	.size	allocarray, .Lfunc_end2-allocarray

	.globl	allocarray_inbounds
	.type	allocarray_inbounds,@function
allocarray_inbounds:
	.local  	i32, i32, i32, i32
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 32
	i32.sub 	$3=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$3=, 0($1), $3
	i32.const	$push0=, 1
	i32.store	$push1=, 12($3), $pop0
	i32.store	$discard=, 24($3), $pop1
	i32.const	$2=, 32
	i32.add 	$3=, $3, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	return
	.endfunc
.Lfunc_end3:
	.size	allocarray_inbounds, .Lfunc_end3-allocarray_inbounds

	.globl	dynamic_alloca
	.type	dynamic_alloca,@function
dynamic_alloca:
	.param  	i32
	return
	.endfunc
.Lfunc_end4:
	.size	dynamic_alloca, .Lfunc_end4-dynamic_alloca


