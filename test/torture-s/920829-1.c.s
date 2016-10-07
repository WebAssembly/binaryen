	.text
	.file	"/usr/local/google/home/dschuff/s/wasm-waterfall/src/work/gcc/gcc/testsuite/gcc.c-torture/execute/920829-1.c"
	.section	.text.main,"ax",@progbits
	.hidden	main
	.globl	main
	.type	main,@function
main:                                   # @main
	.result 	i32
# BB#0:                                 # %entry
	block   	
	i32.const	$push6=, 0
	i64.load	$push0=, c($pop6)
	i64.const	$push1=, 3
	i64.mul 	$push2=, $pop0, $pop1
	i32.const	$push5=, 0
	i64.load	$push3=, c3($pop5)
	i64.ne  	$push4=, $pop2, $pop3
	br_if   	0, $pop4        # 0: down to label0
# BB#1:                                 # %if.end
	i32.const	$push7=, 0
	call    	exit@FUNCTION, $pop7
	unreachable
.LBB0_2:                                # %if.then
	end_block                       # label0:
	call    	abort@FUNCTION
	unreachable
	.endfunc
.Lfunc_end0:
	.size	main, .Lfunc_end0-main

	.hidden	c                       # @c
	.type	c,@object
	.section	.data.c,"aw",@progbits
	.globl	c
	.p2align	3
c:
	.int64	2863311530              # 0xaaaaaaaa
	.size	c, 8

	.hidden	c3                      # @c3
	.type	c3,@object
	.section	.data.c3,"aw",@progbits
	.globl	c3
	.p2align	3
c3:
	.int64	8589934590              # 0x1fffffffe
	.size	c3, 8


	.ident	"clang version 4.0.0 (trunk 283460) (llvm/trunk 283507)"
	.functype	abort, void
	.functype	exit, void, i32
