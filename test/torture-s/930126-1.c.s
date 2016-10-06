	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/930126-1.c"
	.section	.text.f,"ax",@progbits
	.hidden	f
	.globl	f
	.type	f,@function
f:                                      # @f
	.param  	i32, i32
# BB#0:                                 # %entry
	i32.const	$push0=, 4
	i32.add 	$push1=, $0, $pop0
	i64.const	$push2=, 205
	i64.store8	0($pop1), $pop2
	i64.load8_u	$push3=, 0($1)
	i64.const	$push4=, 4010947584
	i64.or  	$push5=, $pop3, $pop4
	i64.store32	0($0), $pop5
                                        # fallthrough-return
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
	i32.store8	main.i($pop11), $pop0
	i32.const	$push10=, 0
	i64.const	$push1=, 205
	i64.store8	main.i+4($pop10), $pop1
	i32.const	$push9=, 0
	i64.const	$push2=, 4010947596
	i64.store32	main.i($pop9), $pop2
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
	.section	.bss.main.i,"aw",@nobits
	.p2align	3
main.i:
	.skip	8
	.size	main.i, 8


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
