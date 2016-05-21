	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/varargs.ll"
	.globl	start
	.type	start,@function
start:
	.param  	i32, i32
	i32.store	$drop=, 0($0), $1
	return
	.endfunc
.Lfunc_end0:
	.size	start, .Lfunc_end0-start

	.globl	end
	.type	end,@function
end:
	.param  	i32
	return
	.endfunc
.Lfunc_end1:
	.size	end, .Lfunc_end1-end

	.globl	copy
	.type	copy,@function
copy:
	.param  	i32, i32
	i32.load	$push0=, 0($1)
	i32.store	$drop=, 0($0), $pop0
	return
	.endfunc
.Lfunc_end2:
	.size	copy, .Lfunc_end2-copy

	.globl	arg_i8
	.type	arg_i8,@function
arg_i8:
	.param  	i32
	.result 	i32
	.local  	i32
	i32.load	$push4=, 0($0)
	tee_local	$push3=, $1=, $pop4
	i32.const	$push0=, 4
	i32.add 	$push1=, $pop3, $pop0
	i32.store	$drop=, 0($0), $pop1
	i32.load	$push2=, 0($1)
	return  	$pop2
	.endfunc
.Lfunc_end3:
	.size	arg_i8, .Lfunc_end3-arg_i8

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
	i32.and 	$push8=, $pop2, $pop3
	tee_local	$push7=, $1=, $pop8
	i32.const	$push4=, 4
	i32.add 	$push5=, $pop7, $pop4
	i32.store	$drop=, 0($0), $pop5
	i32.load	$push6=, 0($1)
	return  	$pop6
	.endfunc
.Lfunc_end4:
	.size	arg_i32, .Lfunc_end4-arg_i32

	.globl	arg_i128
	.type	arg_i128,@function
arg_i128:
	.param  	i32, i32
	.local  	i32, i32, i64
	i32.load	$push0=, 0($1)
	i32.const	$push1=, 7
	i32.add 	$push2=, $pop0, $pop1
	i32.const	$push3=, -8
	i32.and 	$push12=, $pop2, $pop3
	tee_local	$push11=, $3=, $pop12
	i32.const	$push4=, 8
	i32.add 	$push5=, $pop11, $pop4
	i32.store	$2=, 0($1), $pop5
	i64.load	$4=, 0($3)
	i32.const	$push6=, 16
	i32.add 	$push7=, $3, $pop6
	i32.store	$drop=, 0($1), $pop7
	i32.const	$push10=, 8
	i32.add 	$push8=, $0, $pop10
	i64.load	$push9=, 0($2)
	i64.store	$drop=, 0($pop8), $pop9
	i64.store	$drop=, 0($0), $4
	return
	.endfunc
.Lfunc_end5:
	.size	arg_i128, .Lfunc_end5-arg_i128

	.globl	caller_none
	.type	caller_none,@function
caller_none:
	i32.const	$push0=, 0
	call    	callee@FUNCTION, $pop0
	return
	.endfunc
.Lfunc_end6:
	.size	caller_none, .Lfunc_end6-caller_none

	.globl	caller_some
	.type	caller_some,@function
caller_some:
	.local  	i32
	i32.const	$push5=, __stack_pointer
	i32.const	$push2=, __stack_pointer
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push9=, $pop3, $pop4
	i32.store	$push11=, 0($pop5), $pop9
	tee_local	$push10=, $0=, $pop11
	i64.const	$push0=, 4611686018427387904
	i64.store	$drop=, 8($pop10), $pop0
	i32.const	$push1=, 0
	i32.store	$drop=, 0($0), $pop1
	call    	callee@FUNCTION, $0
	i32.const	$push8=, __stack_pointer
	i32.const	$push6=, 16
	i32.add 	$push7=, $0, $pop6
	i32.store	$drop=, 0($pop8), $pop7
	return
	.endfunc
.Lfunc_end7:
	.size	caller_some, .Lfunc_end7-caller_some

	.globl	startbb
	.type	startbb,@function
startbb:
	.param  	i32, i32, i32
	block
	i32.const	$push0=, 1
	i32.and 	$push1=, $0, $pop0
	i32.eqz 	$push2=, $pop1
	br_if   	0, $pop2
	return
.LBB8_2:
	end_block
	i32.store	$drop=, 0($1), $2
	return
	.endfunc
.Lfunc_end8:
	.size	startbb, .Lfunc_end8-startbb


