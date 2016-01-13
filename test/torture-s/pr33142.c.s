	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr33142.c"
	.section	.text.lisp_atan2,"ax",@progbits
	.hidden	lisp_atan2
	.globl	lisp_atan2
	.type	lisp_atan2,@function
lisp_atan2:                             # @lisp_atan2
	.param  	i32, i32
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$3=, 0
	block   	.LBB0_3
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	$pop1, .LBB0_3
# BB#1:                                 # %entry
	i32.const	$push2=, 0
	i32.gt_s	$push3=, $1, $pop2
	br_if   	$pop3, .LBB0_3
# BB#2:                                 # %if.then2
	i32.const	$3=, 31
	i32.shr_s	$2=, $1, $3
	i32.shr_s	$3=, $0, $3
	i32.add 	$push4=, $1, $2
	i32.xor 	$push5=, $pop4, $2
	i32.add 	$push6=, $0, $3
	i32.xor 	$push7=, $pop6, $3
	i32.le_s	$3=, $pop5, $pop7
.LBB0_3:                                # %return
	return  	$3
.Lfunc_end0:
	.size	lisp_atan2, .Lfunc_end0-lisp_atan2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$0=, __stack_pointer
	i32.load	$0=, 0($0)
	i32.const	$1=, 16
	i32.sub 	$3=, $0, $1
	i32.const	$1=, __stack_pointer
	i32.store	$3=, 0($1), $3
	block   	.LBB1_2
	i32.const	$push0=, 63
	i32.store	$discard=, 12($3), $pop0
	i32.const	$push1=, -77
	i32.store	$discard=, 8($3), $pop1
	i32.load	$push2=, 12($3)
	i32.load	$push3=, 8($3)
	i32.call	$push4=, lisp_atan2@FUNCTION, $pop2, $pop3
	br_if   	$pop4, .LBB1_2
# BB#1:                                 # %if.end
	i32.const	$push5=, 0
	i32.const	$2=, 16
	i32.add 	$3=, $3, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	return  	$pop5
.LBB1_2:                                # %if.then
	call    	abort@FUNCTION
	unreachable
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.8.0 "
	.section	".note.GNU-stack","",@progbits
