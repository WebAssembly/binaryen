	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/20000419-1.c"
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
	.local  	i32
# BB#0:                                 # %entry
	i32.const	$push9=, 0
	i32.const	$push6=, 0
	i32.load	$push7=, __stack_pointer($pop6)
	i32.const	$push8=, 16
	i32.sub 	$push15=, $pop7, $pop8
	tee_local	$push14=, $0=, $pop15
	i32.store	__stack_pointer($pop9), $pop14
	i32.const	$push2=, 12
	i32.add 	$push3=, $0, $pop2
	i32.const	$push0=, 0
	i32.load	$push1=, .Lmain.f+8($pop0)
	i32.store	0($pop3), $pop1
	i32.const	$push13=, 0
	i64.load	$push4=, .Lmain.f($pop13):p2align=2
	i64.store	4($0):p2align=2, $pop4
	i32.const	$push10=, 4
	i32.add 	$push11=, $0, $pop10
	i32.const	$push5=, 1
	call    	sister@FUNCTION, $pop11, $pop5, $0
	i32.const	$push12=, 0
	call    	exit@FUNCTION, $pop12
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


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
