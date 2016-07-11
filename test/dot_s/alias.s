	.text
	.file	"alias.c"

	.hidden	__exit
	.globl	__exit
	.type	__exit,@function
__exit:                           # @__exit
	i32.const	$push0=, _A
	i32.load	$push1=, 0($pop0)
	i32.const	$push2=, ._B
	i32.load	$push3=, 0($pop2)
	i32.add 	$push4=, $pop1, $pop3
# BB#0:                                 # %entry
	return		$pop4
	.endfunc
.Lfunc_end0:
	.size	__exit, .Lfunc_end0-__exit

	.hidden	__needs_exit
	.globl	__needs_exit
	.type	__needs_exit,@function
__needs_exit:              # @__needs_exit
	.result i32
# BB#0:                                 # %entry
	call		__exit_needed@FUNCTION
	i32.const	$push0=, __exit_needed@FUNCTION
	return  $pop0
	.endfunc
.Lfunc_end1:
	.size	__needs_exit, .Lfunc_end1-__needs_exit

	.weak	__exit_needed
	.type	__exit_needed,@function
	.hidden	__exit_needed
__exit_needed = __exit@FUNCTION

	.type	.L__unnamed_1,@object
	.p2align	4
.L__unnamed_1:
	.int32	1234
	.skip	4
	.int32	2345
	.size	.L__unnamed_1, 12

_A = .L__unnamed_1
	.size	_A, 12
._B = _A+8
	.size	._B, 4
