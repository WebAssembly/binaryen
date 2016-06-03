	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr37125.c"
	.section	.text.func_44,"ax",@progbits
	.hidden	func_44
	.globl	func_44
	.type	func_44,@function
func_44:                                # @func_44
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.const	$push0=, -9
	i32.mul 	$push1=, $0, $pop0
	i32.const	$push3=, -9
	i32.rem_u	$push2=, $pop1, $pop3
	i32.eqz 	$push4=, $pop2
	br_if   	0, $pop4        # 0: down to label0
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
                                        # fallthrough-return: $pop0
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
