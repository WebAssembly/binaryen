	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/pr33142.c"
	.section	.text.lisp_atan2,"ax",@progbits
	.hidden	lisp_atan2
	.globl	lisp_atan2
	.type	lisp_atan2,@function
lisp_atan2:                             # @lisp_atan2
	.param  	i32, i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$2=, 0
	block
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $0, $pop0
	br_if   	0, $pop1        # 0: down to label0
# BB#1:                                 # %entry
	i32.const	$push2=, 0
	i32.gt_s	$push3=, $1, $pop2
	br_if   	0, $pop3        # 0: down to label0
# BB#2:                                 # %if.then2
	i32.const	$push4=, 31
	i32.shr_s	$push5=, $1, $pop4
	tee_local	$push13=, $2=, $pop5
	i32.add 	$push6=, $1, $pop13
	i32.xor 	$push7=, $pop6, $2
	i32.const	$push12=, 31
	i32.shr_s	$push8=, $0, $pop12
	tee_local	$push11=, $1=, $pop8
	i32.add 	$push9=, $0, $pop11
	i32.xor 	$push10=, $pop9, $1
	i32.le_s	$2=, $pop7, $pop10
.LBB0_3:                                # %return
	end_block                       # label0:
	return  	$2
	.endfunc
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
	i32.const	$push0=, 63
	i32.store	$discard=, 12($3), $pop0
	i32.const	$push1=, -77
	i32.store	$discard=, 8($3), $pop1
	block
	i32.load	$push2=, 12($3)
	i32.load	$push3=, 8($3)
	i32.call	$push4=, lisp_atan2@FUNCTION, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push5=, 0
	i32.const	$2=, 16
	i32.add 	$3=, $3, $2
	i32.const	$2=, __stack_pointer
	i32.store	$3=, 0($2), $3
	return  	$pop5
.LBB1_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
