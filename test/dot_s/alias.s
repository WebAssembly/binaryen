	.text
	.file	"alias.c"

	.hidden	__exit
	.globl	__exit
	.type	__exit,@function
__exit:                           # @__exit
	i32.const	$push0=, _B
	i32.load	$push1=, 0($pop0)
	i32.const	$push2=, ._C
	i32.load	$push3=, 0($pop2)
	i32.add 	$drop=, $pop1, $pop3
# BB#0:                                 # %entry
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

	.weak	.A
._A = .L__unname_1
	.weak	._B
_B = .L__unnamed_1
	.size	_B, 12
	.weak	._C
._C = _B+8
	.size	._C, 4
