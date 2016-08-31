	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/strct-pack-1.c"
	.section	.text.check,"ax",@progbits
	.hidden	check
	.globl	check
	.type	check,@function
check:                                  # @check
	.param  	i32
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	block
	block
	i32.load16_u	$push0=, 0($0)
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label1
# BB#1:                                 # %lor.lhs.false
	i32.const	$1=, 0
	f64.load	$push3=, 2($0):p2align=1
	f64.const	$push4=, 0x1p4
	f64.eq  	$push5=, $pop3, $pop4
	br_if   	1, $pop5        # 1: down to label0
.LBB0_2:                                # %if.then
	end_block                       # label1:
	i32.const	$1=, 1
.LBB0_3:                                # %return
	end_block                       # label0:
	copy_local	$push6=, $1
                                        # fallthrough-return: $pop6
	.endfunc
.Lfunc_end0:
	.size	check, .Lfunc_end0-check

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
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 4.0.0 "
	.functype	exit, void, i32
