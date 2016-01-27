	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/varargs.ll"
	.globl	end
	.type	end,@function
end:
	.param  	i32
	return
	.endfunc
.Lfunc_end0:
	.size	end, .Lfunc_end0-end

	.globl	copy
	.type	copy,@function
copy:
	.param  	i32, i32
	i32.load	$push0=, 0($1)
	i32.store	$discard=, 0($0), $pop0
	return
	.endfunc
.Lfunc_end1:
	.size	copy, .Lfunc_end1-copy

	.globl	arg_i8
	.type	arg_i8,@function
arg_i8:
	.param  	i32
	.result 	i32
	.local  	i32
	i32.load	$push0=, 0($0)
	tee_local	$push4=, $1=, $pop0
	i32.const	$push1=, 4
	i32.add 	$push2=, $pop4, $pop1
	i32.store	$discard=, 0($0), $pop2
	i32.load	$push3=, 0($1)
	return  	$pop3
	.endfunc
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
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push8=, $1=, $pop4
	i32.const	$push5=, 4
	i32.add 	$push6=, $pop8, $pop5
	i32.store	$discard=, 0($0), $pop6
	i32.load	$push7=, 0($1)
	return  	$pop7
	.endfunc
.Lfunc_end3:
	.size	arg_i32, .Lfunc_end3-arg_i32

	.globl	arg_i128
	.type	arg_i128,@function
arg_i128:
	.param  	i32, i32
	.local  	i32, i64, i32
	i32.load	$push0=, 0($1)
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push4=, $pop2, $pop3
	tee_local	$push12=, $4=, $pop4
	i32.const	$push5=, 8
	i32.add 	$push6=, $pop12, $pop5
	i32.store	$2=, 0($1), $pop6
	i64.load	$3=, 0($4)
	i32.const	$push7=, 16
	i32.add 	$push8=, $4, $pop7
	i32.store	$discard=, 0($1), $pop8
	i32.const	$push11=, 8
	i32.add 	$push10=, $0, $pop11
	i64.load	$push9=, 0($2)
	i64.store	$discard=, 0($pop10), $pop9
	i64.store	$discard=, 0($0), $3
	return
	.endfunc
.Lfunc_end4:
	.size	arg_i128, .Lfunc_end4-arg_i128

	.globl	caller_none
	.type	caller_none,@function
caller_none:
	call    	callee@FUNCTION
	return
	.endfunc
.Lfunc_end5:
	.size	caller_none, .Lfunc_end5-caller_none

	.globl	caller_some
	.type	caller_some,@function
caller_some:
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
	i32.const	$5=, __stack_pointer
	i32.load	$5=, 0($5)
	i32.const	$6=, 16
	i32.sub 	$8=, $5, $6
	i32.const	$6=, __stack_pointer
	i32.store	$8=, 0($6), $8
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$8=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$8=, 0($2), $8
	i32.const	$push0=, 0
	i32.store	$discard=, 0($8), $pop0
	i32.const	$push1=, 8
	i32.add 	$0=, $8, $pop1
	i64.const	$push2=, 4611686018427387904
	i64.store	$discard=, 0($0), $pop2
	call    	callee@FUNCTION
	i32.const	$3=, __stack_pointer
	i32.load	$3=, 0($3)
	i32.const	$4=, 16
	i32.add 	$8=, $3, $4
	i32.const	$4=, __stack_pointer
	i32.store	$8=, 0($4), $8
	i32.const	$7=, 16
	i32.add 	$8=, $8, $7
	i32.const	$7=, __stack_pointer
	i32.store	$8=, 0($7), $8
	return
	.endfunc
.Lfunc_end6:
	.size	caller_some, .Lfunc_end6-caller_some


