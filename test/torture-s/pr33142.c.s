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
	i32.shr_s	$push13=, $1, $pop4
	tee_local	$push12=, $2=, $pop13
	i32.add 	$push7=, $1, $pop12
	i32.xor 	$push8=, $pop7, $2
	i32.const	$push11=, 31
	i32.shr_s	$push10=, $0, $pop11
	tee_local	$push9=, $1=, $pop10
	i32.add 	$push5=, $0, $pop9
	i32.xor 	$push6=, $pop5, $1
	i32.le_s	$2=, $pop8, $pop6
.LBB0_3:                                # %return
	end_block                       # label0:
	copy_local	$push14=, $2
                                        # fallthrough-return: $pop14
	.endfunc
.Lfunc_end0:
	.size	lisp_atan2, .Lfunc_end0-lisp_atan2

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push13=, $pop7, $pop8
	i32.store	$push15=, __stack_pointer($pop9), $pop13
	tee_local	$push14=, $0=, $pop15
	i32.const	$push0=, 63
	i32.store	$drop=, 12($pop14), $pop0
	i32.const	$push1=, -77
	i32.store	$drop=, 8($0), $pop1
	block
	i32.load	$push2=, 12($0)
	i32.load	$push3=, 8($0)
	i32.call	$push4=, lisp_atan2@FUNCTION, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label1
# BB#1:                                 # %if.end
	i32.const	$push12=, 0
	i32.const	$push10=, 16
	i32.add 	$push11=, $0, $pop10
	i32.store	$drop=, __stack_pointer($pop12), $pop11
	i32.const	$push5=, 0
	return  	$pop5
.LBB1_2:                                # %if.then
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.functype	abort, void
