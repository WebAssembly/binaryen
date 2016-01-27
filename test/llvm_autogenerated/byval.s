	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/byval.ll"
	.globl	byval_arg
	.type	byval_arg,@function
byval_arg:
	.param  	i32
	.local  	i32, i32, i32, i32, i32
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$5=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$5=, 0($2), $5
	i32.load	$push0=, 0($0)
	i32.store	$discard=, 12($5), $pop0
	i32.const	$4=, 12
	i32.add 	$4=, $5, $4
	call    	ext_byval_func@FUNCTION, $4
	i32.const	$3=, 16
	i32.add 	$5=, $5, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	return
	.endfunc
.Lfunc_end0:
	.size	byval_arg, .Lfunc_end0-byval_arg

	.globl	byval_arg_align8
	.type	byval_arg_align8,@function
byval_arg_align8:
	.param  	i32
	.local  	i32, i32, i32, i32, i32
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$5=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$5=, 0($2), $5
	i32.load	$push0=, 0($0):p2align=3
	i32.store	$discard=, 8($5):p2align=3, $pop0
	i32.const	$4=, 8
	i32.add 	$4=, $5, $4
	call    	ext_byval_func_align8@FUNCTION, $4
	i32.const	$3=, 16
	i32.add 	$5=, $5, $3
	i32.const	$3=, __stack_pointer
	i32.store	$5=, 0($3), $5
	return
	.endfunc
.Lfunc_end1:
	.size	byval_arg_align8, .Lfunc_end1-byval_arg_align8

	.globl	byval_arg_double
	.type	byval_arg_double,@function
byval_arg_double:
	.param  	i32
	.local  	i32, i32, i32, i32
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 16
	i32.sub 	$4=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$4=, 0($2), $4
	i32.const	$push0=, 8
	i32.add 	$push3=, $4, $pop0
	i32.const	$push5=, 8
	i32.add 	$push1=, $0, $pop5
	i64.load	$push2=, 0($pop1)
	i64.store	$discard=, 0($pop3), $pop2
	i64.load	$push4=, 0($0)
	i64.store	$discard=, 0($4), $pop4
	call    	ext_byval_func_alignedstruct@FUNCTION, $4
	i32.const	$3=, 16
	i32.add 	$4=, $4, $3
	i32.const	$3=, __stack_pointer
	i32.store	$4=, 0($3), $4
	return
	.endfunc
.Lfunc_end2:
	.size	byval_arg_double, .Lfunc_end2-byval_arg_double

	.globl	byval_arg_big
	.type	byval_arg_big,@function
byval_arg_big:
	.param  	i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
	i32.const	$1=, __stack_pointer
	i32.load	$1=, 0($1)
	i32.const	$2=, 48
	i32.sub 	$9=, $1, $2
	i32.const	$2=, __stack_pointer
	i32.store	$9=, 0($2), $9
	i32.const	$push0=, 32
	i32.const	$4=, 12
	i32.add 	$4=, $9, $4
	i32.add 	$push3=, $4, $pop0
	i32.const	$push20=, 32
	i32.add 	$push1=, $0, $pop20
	i32.load8_u	$push2=, 0($pop1)
	i32.store8	$discard=, 0($pop3):p2align=2, $pop2
	i32.const	$push4=, 24
	i32.const	$5=, 12
	i32.add 	$5=, $9, $5
	i32.add 	$push7=, $5, $pop4
	i32.const	$push19=, 24
	i32.add 	$push5=, $0, $pop19
	i64.load	$push6=, 0($pop5):p2align=0
	i64.store	$discard=, 0($pop7):p2align=2, $pop6
	i32.const	$push8=, 16
	i32.const	$6=, 12
	i32.add 	$6=, $9, $6
	i32.add 	$push11=, $6, $pop8
	i32.const	$push18=, 16
	i32.add 	$push9=, $0, $pop18
	i64.load	$push10=, 0($pop9):p2align=0
	i64.store	$discard=, 0($pop11):p2align=2, $pop10
	i32.const	$push12=, 8
	i32.const	$7=, 12
	i32.add 	$7=, $9, $7
	i32.add 	$push15=, $7, $pop12
	i32.const	$push17=, 8
	i32.add 	$push13=, $0, $pop17
	i64.load	$push14=, 0($pop13):p2align=0
	i64.store	$discard=, 0($pop15):p2align=2, $pop14
	i64.load	$push16=, 0($0):p2align=0
	i64.store	$discard=, 12($9):p2align=2, $pop16
	i32.const	$8=, 12
	i32.add 	$8=, $9, $8
	call    	ext_byval_func_bigarray@FUNCTION, $8
	i32.const	$3=, 48
	i32.add 	$9=, $9, $3
	i32.const	$3=, __stack_pointer
	i32.store	$9=, 0($3), $9
	return
	.endfunc
.Lfunc_end3:
	.size	byval_arg_big, .Lfunc_end3-byval_arg_big

	.globl	byval_param
	.type	byval_param,@function
byval_param:
	.param  	i32
	call    	ext_func@FUNCTION, $0
	return
	.endfunc
.Lfunc_end4:
	.size	byval_param, .Lfunc_end4-byval_param


