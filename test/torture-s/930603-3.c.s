	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930603-3.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.result 	i32
# BB#0:                                 # %entry
	block
	block
	i32.const	$push0=, 107
	i32.eq  	$push1=, $1, $pop0
	br_if   	$pop1, 0        # 0: down to label1
# BB#1:                                 # %entry
	block
	i32.const	$push2=, 100
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, 0        # 0: down to label2
# BB#2:                                 # %sw.bb
	i32.load8_u	$push6=, 0($0)
	i32.const	$push7=, 1
	i32.shr_u	$1=, $pop6, $pop7
	br      	2               # 2: down to label0
.LBB0_3:                                # %sw.default
	end_block                       # label2:
	call    	abort@FUNCTION
	unreachable
.LBB0_4:                                # %sw.bb3
	end_block                       # label1:
	i32.load8_u	$push4=, 3($0)
	i32.const	$push5=, 4
	i32.shr_u	$1=, $pop4, $pop5
.LBB0_5:                                # %sw.epilog
	end_block                       # label0:
	return  	$1
	.endfunc
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
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main


	.ident	"clang version 3.9.0 "
	.section	".note.GNU-stack","",@progbits
