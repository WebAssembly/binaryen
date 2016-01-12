	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20020920-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32
# BB#0:                                 # %entry
	i32.const	$push0=, 2
	i32.store	$discard=, 0($0), $pop0
	i64.const	$push1=, 0
	i64.store32	$discard=, 4($0), $pop1
	i32.const	$push2=, 8
	i32.add 	$push3=, $0, $pop2
	i64.const	$push4=, 1
	i64.store32	$discard=, 0($pop3), $pop4
	return
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %if.end
	i32.const	$push0=, 0
	call    	exit@FUNCTION, $pop0
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
