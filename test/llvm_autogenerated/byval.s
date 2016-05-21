	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/byval.ll"
	.globl	byval_arg
	.type	byval_arg,@function
byval_arg:
	.param  	i32
	.local  	i32
	i32.const	$push4=, __stack_pointer
	i32.const	$push1=, __stack_pointer
	i32.load	$push2=, 0($pop1)
	i32.const	$push3=, 16
	i32.sub 	$push10=, $pop2, $pop3
	i32.store	$push12=, 0($pop4), $pop10
	tee_local	$push11=, $1=, $pop12
	i32.load	$push0=, 0($0)
	i32.store	$drop=, 12($pop11), $pop0
	i32.const	$push8=, 12
	i32.add 	$push9=, $1, $pop8
	call    	ext_byval_func@FUNCTION, $pop9
	i32.const	$push7=, __stack_pointer
	i32.const	$push5=, 16
	i32.add 	$push6=, $1, $pop5
	i32.store	$drop=, 0($pop7), $pop6
	return
	.endfunc
.Lfunc_end0:
	.size	byval_arg, .Lfunc_end0-byval_arg

	.globl	byval_arg_align8
	.type	byval_arg_align8,@function
byval_arg_align8:
	.param  	i32
	.local  	i32
	i32.const	$push4=, __stack_pointer
	i32.const	$push1=, __stack_pointer
	i32.load	$push2=, 0($pop1)
	i32.const	$push3=, 16
	i32.sub 	$push10=, $pop2, $pop3
	i32.store	$push12=, 0($pop4), $pop10
	tee_local	$push11=, $1=, $pop12
	i32.load	$push0=, 0($0)
	i32.store	$drop=, 8($pop11), $pop0
	i32.const	$push8=, 8
	i32.add 	$push9=, $1, $pop8
	call    	ext_byval_func_align8@FUNCTION, $pop9
	i32.const	$push7=, __stack_pointer
	i32.const	$push5=, 16
	i32.add 	$push6=, $1, $pop5
	i32.store	$drop=, 0($pop7), $pop6
	return
	.endfunc
.Lfunc_end1:
	.size	byval_arg_align8, .Lfunc_end1-byval_arg_align8

	.globl	byval_arg_double
	.type	byval_arg_double,@function
byval_arg_double:
	.param  	i32
	.local  	i32
	i32.const	$push8=, __stack_pointer
	i32.const	$push5=, __stack_pointer
	i32.load	$push6=, 0($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push12=, $pop6, $pop7
	i32.store	$push15=, 0($pop8), $pop12
	tee_local	$push14=, $1=, $pop15
	i32.const	$push0=, 8
	i32.add 	$push3=, $pop14, $pop0
	i32.const	$push13=, 8
	i32.add 	$push1=, $0, $pop13
	i64.load	$push2=, 0($pop1)
	i64.store	$drop=, 0($pop3), $pop2
	i64.load	$push4=, 0($0)
	i64.store	$drop=, 0($1), $pop4
	call    	ext_byval_func_alignedstruct@FUNCTION, $1
	i32.const	$push11=, __stack_pointer
	i32.const	$push9=, 16
	i32.add 	$push10=, $1, $pop9
	i32.store	$drop=, 0($pop11), $pop10
	return
	.endfunc
.Lfunc_end2:
	.size	byval_arg_double, .Lfunc_end2-byval_arg_double

	.globl	byval_param
	.type	byval_param,@function
byval_param:
	.param  	i32
	call    	ext_func@FUNCTION, $0
	return
	.endfunc
.Lfunc_end3:
	.size	byval_param, .Lfunc_end3-byval_param

	.globl	byval_empty_caller
	.type	byval_empty_caller,@function
byval_empty_caller:
	.param  	i32
	call    	ext_byval_func_empty@FUNCTION, $0
	return
	.endfunc
.Lfunc_end4:
	.size	byval_empty_caller, .Lfunc_end4-byval_empty_caller

	.globl	byval_empty_callee
	.type	byval_empty_callee,@function
byval_empty_callee:
	.param  	i32
	call    	ext_func_empty@FUNCTION, $0
	return
	.endfunc
.Lfunc_end5:
	.size	byval_empty_callee, .Lfunc_end5-byval_empty_callee

	.globl	big_byval
	.type	big_byval,@function
big_byval:
	.param  	i32
	i32.const	$push5=, __stack_pointer
	i32.const	$push2=, __stack_pointer
	i32.load	$push3=, 0($pop2)
	i32.const	$push4=, 131072
	i32.sub 	$push9=, $pop3, $pop4
	i32.store	$push0=, 0($pop5), $pop9
	i32.const	$push1=, 131072
	i32.call	$push11=, memcpy@FUNCTION, $pop0, $0, $pop1
	tee_local	$push10=, $0=, $pop11
	call    	big_byval_callee@FUNCTION, $pop10
	i32.const	$push8=, __stack_pointer
	i32.const	$push6=, 131072
	i32.add 	$push7=, $0, $pop6
	i32.store	$drop=, 0($pop8), $pop7
	return
	.endfunc
.Lfunc_end6:
	.size	big_byval, .Lfunc_end6-big_byval


