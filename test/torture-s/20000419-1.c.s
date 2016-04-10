	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000419-1.c"
	.section	.text.brother,"ax",@progbits
	.hidden	brother
	.globl	brother
	.type	brother,@function
brother:                                # @brother
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block
	br_if   	0, $0           # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	brother, .Lfunc_end0-brother

	.section	.text.sister,"ax",@progbits
	.hidden	sister
	.globl	sister
	.type	sister,@function
sister:                                 # @sister
	.param  	i32, i32, i32
# BB#0:                                 # %entry
	block
	i32.load	$push0=, 4($0)
	i32.eq  	$push1=, $pop0, $1
	br_if   	0, $pop1        # 0: down to label1
# BB#1:                                 # %brother.exit
	return
.LBB1_2:                                # %if.then.i
	end_block                       # label1:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end1:
	.size	sister, .Lfunc_end1-sister

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push8=, __stack_pointer
	i32.load	$push9=, 0($pop8)
	i32.const	$push10=, 16
	i32.sub 	$1=, $pop9, $pop10
	i32.const	$push11=, __stack_pointer
	i32.store	$discard=, 0($pop11), $1
	i32.const	$push12=, 4
	i32.add 	$push13=, $1, $pop12
	i32.const	$push2=, 8
	i32.add 	$push3=, $pop13, $pop2
	i32.const	$push0=, 0
	i32.load	$push1=, .Lmain.f+8($pop0)
	i32.store	$discard=, 0($pop3), $pop1
	i32.const	$push7=, 0
	i64.load	$push4=, .Lmain.f($pop7):p2align=2
	i64.store	$discard=, 4($1):p2align=2, $pop4
	i32.const	$push14=, 4
	i32.add 	$push15=, $1, $pop14
	i32.const	$push5=, 1
	call    	sister@FUNCTION, $pop15, $pop5, $0
	i32.const	$push6=, 0
	call    	exit@FUNCTION, $pop6
	unreachable
	.endfunc
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	.Lmain.f,@object        # @main.f
	.section	.rodata..Lmain.f,"a",@progbits
	.p2align	2
.Lmain.f:
	.int32	7                       # 0x7
	.int32	8                       # 0x8
	.int32	9                       # 0x9
	.size	.Lmain.f, 12


	.ident	"clang version 3.9.0 "
