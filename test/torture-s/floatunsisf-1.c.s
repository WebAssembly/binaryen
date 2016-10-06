	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/floatunsisf-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	i32.const	$push10=, 0
	i32.const	$push9=, 0
	i32.load	$push0=, u($pop9)
	f32.convert_u/i32	$push1=, $pop0
	f32.store	f1($pop10), $pop1
	i32.const	$push8=, 0
	i32.const	$push2=, 1325400065
	i32.store	f2($pop8), $pop2
	block   	
	i32.const	$push7=, 0
	f32.load	$push3=, f1($pop7)
	i32.const	$push6=, 0
	f32.load	$push4=, f2($pop6)
	f32.eq  	$push5=, $pop3, $pop4
	br_if   	0, $pop5        # 0: down to label0
# BB#1:                                 # %if.then
	call    	abort@FUNCTION
	unreachable
.LBB0_2:                                # %if.end
	end_block                       # label0:
	i32.const	$push11=, 0
	call    	exit@FUNCTION, $pop11
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	u                       # @u
	.type	u,@object
	.section	.data.u,"aw",@progbits
	.globl	u
	.p2align	2
u:
	.int32	2147483777              # 0x80000081
	.size	u, 4

	.hidden	f1                      # @f1
	.type	f1,@object
	.section	.bss.f1,"aw",@nobits
	.globl	f1
	.p2align	2
f1:
	.int32	0                       # float 0
	.size	f1, 4

	.hidden	f2                      # @f2
	.type	f2,@object
	.section	.bss.f2,"aw",@nobits
	.globl	f2
	.p2align	2
f2:
	.int32	0                       # float 0
	.size	f2, 4


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
