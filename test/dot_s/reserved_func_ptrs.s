	.text
	.file	"reserved_func_ptrs.cpp"
	.type	_Z18address_taken_funciii,@function
_Z18address_taken_funciii:
	.param  	i32, i32, i32
	.endfunc
.Lfunc_end0:
	.size	_Z18address_taken_funciii, .Lfunc_end0-_Z18address_taken_funciii

	.type	_Z19address_taken_func2iii,@function
_Z19address_taken_func2iii:
	.param  	i32, i32, i32
	.endfunc
.Lfunc_end1:
	.size	_Z19address_taken_func2iii, .Lfunc_end1-_Z19address_taken_func2iii

	.hidden	main
	.globl	main
	.type	main,@function
main:
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32, i32, i32
	i32.load	$push0=, 4($1)
	i32.call	$2=, atoi@FUNCTION, $pop0
	i32.load	$push1=, 8($1)
	i32.call	$3=, atoi@FUNCTION, $pop1
	i32.load	$push2=, 12($1)
	i32.call	$4=, atoi@FUNCTION, $pop2
	i32.load	$push3=, 16($1)
	i32.call	$5=, atoi@FUNCTION, $pop3
	i32.load	$push4=, 20($1)
	i32.call	$1=, atoi@FUNCTION, $pop4
	call_indirect	$2
	i32.const	$push5=, 3
	call_indirect	$pop5, $3
	i32.const	$push7=, 4
	i32.const	$push6=, 5
	i32.call_indirect	$drop=, $pop7, $pop6, $4
	f32.const	$push9=, 0x1.8cccccp1
	f32.const	$push8=, 0x1.0cccccp2
	i32.const	$push21=, 5
	f32.call_indirect	$drop=, $pop9, $pop8, $pop21, $5
	f64.const	$push10=, 0x1.0cccccccccccdp2
	i32.const	$push20=, 5
	f64.call_indirect	$drop=, $pop10, $pop20, $1
	i32.const	$push16=, 1
	i32.const	$push15=, 2
	i32.const	$push19=, 3
	i32.const	$push13=, _Z18address_taken_funciii@FUNCTION
	i32.const	$push12=, _Z19address_taken_func2iii@FUNCTION
	i32.const	$push18=, 3
	i32.gt_s	$push11=, $0, $pop18
	i32.select	$push14=, $pop13, $pop12, $pop11
	call_indirect	$pop16, $pop15, $pop19, $pop14
	i32.const	$push17=, 0
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
