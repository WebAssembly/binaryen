	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/varargs.ll"
	.globl	end
	.type	end,@function
end:
	.param  	i32
	return
.Lfunc_end0:
	.size	end, .Lfunc_end0-end

	.globl	copy
	.type	copy,@function
copy:
	.param  	i32, i32
	i32.load	$push0=, 0($1)
	i32.store	$discard=, 0($0), $pop0
	return
.Lfunc_end1:
	.size	copy, .Lfunc_end1-copy

	.globl	arg_i8
	.type	arg_i8,@function
arg_i8:
	.param  	i32
	.result 	i32
	.local  	i32
	i32.load	$1=, 0($0)
	i32.const	$push0=, 4
	i32.add 	$push1=, $1, $pop0
	i32.store	$discard=, 0($0), $pop1
	i32.load	$push2=, 0($1)
	return  	$pop2
.Lfunc_end2:
	.size	arg_i8, .Lfunc_end2-arg_i8

	.globl	arg_i32
	.type	arg_i32,@function
arg_i32:
	.param  	i32
	.result 	i32
	.local  	i32
	i32.load	$push0=, 0($0)
	i32.const	$push1=, 3
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -4
	i32.and 	$1=, $pop2, $pop3
	i32.const	$push4=, 4
	i32.add 	$push5=, $1, $pop4
	i32.store	$discard=, 0($0), $pop5
	i32.load	$push6=, 0($1)
	return  	$pop6
.Lfunc_end3:
	.size	arg_i32, .Lfunc_end3-arg_i32

	.globl	arg_i128
	.type	arg_i128,@function
arg_i128:
	.param  	i32, i32
	.local  	i32, i32, i32, i64
	i32.load	$push0=, 0($1)
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$2=, $pop2, $pop3
	i32.const	$3=, 8
	i32.add 	$push4=, $2, $3
	i32.store	$4=, 0($1), $pop4
	i64.load	$5=, 0($2)
	i32.const	$push5=, 16
	i32.add 	$push6=, $2, $pop5
	i32.store	$discard=, 0($1), $pop6
	i32.add 	$push8=, $0, $3
	i64.load	$push7=, 0($4)
	i64.store	$discard=, 0($pop8), $pop7
	i64.store	$discard=, 0($0), $5
	return
.Lfunc_end4:
	.size	arg_i128, .Lfunc_end4-arg_i128

	.globl	caller_none
	.type	caller_none,@function
caller_none:
	call    	callee
	return
.Lfunc_end5:
	.size	caller_none, .Lfunc_end5-caller_none

	.globl	caller_some
	.type	caller_some,@function
caller_some:
	return
.Lfunc_end6:
	.size	caller_some, .Lfunc_end6-caller_some


	.section	".note.GNU-stack","",@progbits
