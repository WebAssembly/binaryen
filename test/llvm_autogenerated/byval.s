	.text
	.file	"/s/llvm-upstream/llvm/test/CodeGen/WebAssembly/byval.ll"
	.globl	byval_arg
	.type	byval_arg,@function
byval_arg:
	.param  	i32
	.local  	i32
	i32.const	$push4=, 0
	i32.const	$push1=, 0
	i32.load	$push2=, __stack_pointer($pop1)
	i32.const	$push3=, 16
	i32.sub 	$push11=, $pop2, $pop3
	tee_local	$push10=, $1=, $pop11
	i32.store	__stack_pointer($pop4), $pop10
	i32.load	$push0=, 0($0)
	i32.store	12($1), $pop0
	i32.const	$push8=, 12
	i32.add 	$push9=, $1, $pop8
	call    	ext_byval_func@FUNCTION, $pop9
	i32.const	$push7=, 0
	i32.const	$push5=, 16
	i32.add 	$push6=, $1, $pop5
	i32.store	__stack_pointer($pop7), $pop6
	return
	.endfunc
.Lfunc_end0:
	.size	byval_arg, .Lfunc_end0-byval_arg

	.globl	byval_arg_align8
	.type	byval_arg_align8,@function
byval_arg_align8:
	.param  	i32
	.local  	i32
	i32.const	$push4=, 0
	i32.const	$push1=, 0
	i32.load	$push2=, __stack_pointer($pop1)
	i32.const	$push3=, 16
	i32.sub 	$push11=, $pop2, $pop3
	tee_local	$push10=, $1=, $pop11
	i32.store	__stack_pointer($pop4), $pop10
	i32.load	$push0=, 0($0)
	i32.store	8($1), $pop0
	i32.const	$push8=, 8
	i32.add 	$push9=, $1, $pop8
	call    	ext_byval_func_align8@FUNCTION, $pop9
	i32.const	$push7=, 0
	i32.const	$push5=, 16
	i32.add 	$push6=, $1, $pop5
	i32.store	__stack_pointer($pop7), $pop6
	return
	.endfunc
.Lfunc_end1:
	.size	byval_arg_align8, .Lfunc_end1-byval_arg_align8

	.globl	byval_arg_double
	.type	byval_arg_double,@function
byval_arg_double:
	.param  	i32
	.local  	i32
	i32.const	$push8=, 0
	i32.const	$push5=, 0
	i32.load	$push6=, __stack_pointer($pop5)
	i32.const	$push7=, 16
	i32.sub 	$push14=, $pop6, $pop7
	tee_local	$push13=, $1=, $pop14
	i32.store	__stack_pointer($pop8), $pop13
	i32.const	$push0=, 8
	i32.add 	$push3=, $1, $pop0
	i32.const	$push12=, 8
	i32.add 	$push1=, $0, $pop12
	i64.load	$push2=, 0($pop1)
	i64.store	0($pop3), $pop2
	i64.load	$push4=, 0($0)
	i64.store	0($1), $pop4
	call    	ext_byval_func_alignedstruct@FUNCTION, $1
	i32.const	$push11=, 0
	i32.const	$push9=, 16
	i32.add 	$push10=, $1, $pop9
	i32.store	__stack_pointer($pop11), $pop10
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
	.local  	i32
	i32.const	$push4=, 0
	i32.const	$push1=, 0
	i32.load	$push2=, __stack_pointer($pop1)
	i32.const	$push3=, 131072
	i32.sub 	$push11=, $pop2, $pop3
	tee_local	$push10=, $1=, $pop11
	i32.store	__stack_pointer($pop4), $pop10
	i32.const	$push0=, 131072
	i32.call	$push9=, memcpy@FUNCTION, $1, $0, $pop0
	tee_local	$push8=, $0=, $pop9
	call    	big_byval_callee@FUNCTION, $pop8
	i32.const	$push7=, 0
	i32.const	$push5=, 131072
	i32.add 	$push6=, $0, $pop5
	i32.store	__stack_pointer($pop7), $pop6
	return
	.endfunc
.Lfunc_end6:
	.size	big_byval, .Lfunc_end6-big_byval


	.functype	ext_func, void, i32
	.functype	ext_func_empty, void, i32
	.functype	ext_byval_func, void, i32
	.functype	ext_byval_func_align8, void, i32
	.functype	ext_byval_func_alignedstruct, void, i32
	.functype	ext_byval_func_bigarray, void, i32
	.functype	ext_byval_func_empty, void, i32
	.functype	big_byval_callee, void, i32
