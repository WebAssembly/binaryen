	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930126-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
	.local  	i64
# BB#0:                                 # %entry
	i64.load8_u	$2=, 0($1):p2align=3
	i32.const	$push2=, 4
	i32.add 	$push3=, $0, $pop2
	i64.const	$push4=, 205
	i64.store8	$discard=, 0($pop3):p2align=2, $pop4
	i64.const	$push0=, 4010947584
	i64.or  	$push1=, $2, $pop0
	i64.store32	$discard=, 0($0):p2align=3, $pop1
	return
	.endfunc
.Lfunc_end0:
	.size	f, .Lfunc_end0-f

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push11=, 0
	i32.const	$push0=, 12
	i32.store8	$discard=, main.i($pop11):p2align=3, $pop0
	i32.const	$push10=, 0
	i64.const	$push1=, 205
	i64.store8	$discard=, main.i+4($pop10):p2align=2, $pop1
	i32.const	$push9=, 0
	i64.const	$push2=, 4010947596
	i64.store32	$discard=, main.i($pop9):p2align=3, $pop2
	block
	i32.const	$push8=, 0
	i64.load	$push3=, main.i($pop8)
	i64.const	$push4=, 1099511627775
	i64.and 	$push5=, $pop3, $pop4
	i64.const	$push6=, 884479243276
	i64.ne  	$push7=, $pop5, $pop6
	br_if   	0, $pop7        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push12=, 0
	call    	exit@FUNCTION, $pop12
	unreachable
.LBB1_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	main.i,@object          # @main.i
	.lcomm	main.i,8,3

	.ident	"clang version 3.9.0 "
