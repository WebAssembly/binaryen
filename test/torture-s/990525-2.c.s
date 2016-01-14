	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990525-2.c"
	.section	.text.func1,"ax",@progbits
	.hidden	func1
	.globl	func1
	.type	func1,@function
func1:                                  # @func1
	.result 	i32
	.local  	i32
# BB#0:                                 # %if.end15
	return  	$0
	.endfunc
.Lfunc_end0:
	.size	func1, .Lfunc_end0-func1

	.section	.text.func2,"ax",@progbits
	.hidden	func2
	.globl	func2
	.type	func2,@function
func2:                                  # @func2
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 10
	i32.store	$discard=, 0($0), $pop0
	i32.const	$push1=, 20
	i32.store	$discard=, 4($0), $pop1
	i32.const	$push2=, 30
	i32.store	$discard=, 8($0), $pop2
	i32.const	$push3=, 40
	i32.store	$discard=, 12($0), $pop3
	return
	.endfunc
.Lfunc_end1:
	.size	func2, .Lfunc_end1-func2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
