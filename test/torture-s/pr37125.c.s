	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr37125.c"
	.section	.text.func_44,"ax",@progbits
	.hidden	func_44
	.globl	func_44
	.type	func_44,@function
func_44:                                # @func_44
	.param  	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$1=, -9
	block
	i32.mul 	$push0=, $0, $1
	i32.rem_u	$push1=, $pop0, $1
	i32.const	$push2=, 0
	i32.eq  	$push3=, $pop1, $pop2
	br_if   	$pop3, 0        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	func_44, .Lfunc_end0-func_44

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 0
	return  	$pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
