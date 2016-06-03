	.text
	.file	"/b/build/slave/linux/build/src/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/990525-1.c"
	.section	.text.die,"ax",@progbits
	.hidden	die
	.globl	die
	.type	die,@function
die:                                    # @die
	.param  	i32
# BB#0:                                 # %entry
	block
	i32.load	$push0=, 0($0)
	i32.const	$push1=, 1
	i32.ne  	$push2=, $pop0, $pop1
	br_if   	0, $pop2        # 0: down to label0
# BB#1:                                 # %if.end
	return
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	die, .Lfunc_end0-die

	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push5=, 0
	i32.const	$push2=, 0
	i32.load	$push3=, __stack_pointer($pop2)
	i32.const	$push4=, 16
	i32.sub 	$push8=, $pop3, $pop4
	i32.store	$push11=, __stack_pointer($pop5), $pop8
	tee_local	$push10=, $0=, $pop11
	i32.const	$push0=, 0
	i64.load	$push1=, .Lmain.s($pop0):p2align=2
	i64.store	$drop=, 8($pop10):p2align=2, $pop1
	i32.const	$push6=, 8
	i32.add 	$push7=, $0, $pop6
	call    	die@FUNCTION, $pop7
	i32.const	$push9=, 0
	call    	exit@FUNCTION, $pop9
	unreachable
	.endfunc
.Lfunc_end1:
	.size	main, .Lfunc_end1-main

	.type	.Lmain.s,@object        # @main.s
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	2
.Lmain.s:
	.int32	1                       # 0x1
	.int32	2                       # 0x2
	.size	.Lmain.s, 8


	.ident	"clang version 3.9.0 "
	.functype	abort, void
	.functype	exit, void, i32
